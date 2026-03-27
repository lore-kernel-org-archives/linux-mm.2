Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B50210A3D9E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D096B00A0; Thu, 26 Mar 2026 22:14:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705746B00A2; Thu, 26 Mar 2026 22:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641F36B00A3; Thu, 26 Mar 2026 22:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53CAB6B00A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2172C5CDF6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:40 +0000 (UTC)
X-FDA: 84590224320.24.BEAB77B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 520721C0006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KJYNK18n;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AsidUyaFSU2OL+6pIevfNbim9vED85JJGBowf2ctQP8=;
	b=2iC7ilawk0rwlu6gXtSsI8Eviggc9QbmWzeay+c2hQtn+/7dCtVbu9r4v24vmemBrUH3xA
	Sj6+mfjYr1ryU7TVLKCyT4V9dgGsIARhd5QIY7I2pd65I+vX2roHafSJZrfFw4qhZ7lRyK
	iT4QD7CrABzS8ybUpRJjXCKyCxWGZNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577678; a=rsa-sha256;
	cv=none;
	b=NnKNUQ/nwJq2yXhp3LOAZcAhYzfHT9WTRy3rJUkFCjGa3my839I/G8DoujUl7rFmP/wrPO
	MfHOAeTsRvwqc6D+LyJG1BUVOjrB7CvztrPaYMqjdY3O5OQQZaGbDjClRzr3us6qHJY8Ru
	w8VzVqEcyqNND9DmufubWcb03HflZNI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KJYNK18n;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsidUyaFSU2OL+6pIevfNbim9vED85JJGBowf2ctQP8=;
	b=KJYNK18nvflazGbUsGQzniopI3KPVpz1LShSWjjSbT+hxFnh/0tpkw+tfNe3j+MVojye1j
	wdQPu4/bxNWWVoy1HF/DFPdbf1u5jrpcQiHNSPWDNk1zHFhU0vPcRAGI2daPSXBje5u6Yr
	R2eLlqWUdaQ4fQFe4gaiAaU+oQXNXZY=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 04/24] mm: thp: handle split failure in do_huge_pmd_wp_page()
Date: Thu, 26 Mar 2026 19:08:46 -0700
Message-ID: <20260327021403.214713-5-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: cddba8zgtbnxawdmszctryay5ftxymwq
X-Rspamd-Queue-Id: 520721C0006
X-Rspam-User: 
X-HE-Tag: 1774577678-846800
X-HE-Meta: U2FsdGVkX1+e4tfsllCCoWTOT0+NRAaI9Sd77TYWuGSv2AoWt7B+s2SH26CqsQ5KRK26dWzTosJbu2ywV/Ffq7WyNwoVKSwGeqth2w9Lh4SaBLVA7/b/Dci1KV+4FxlOPtKVZPRhagxn6ycGuyMY5rQqK0xVfW3v/dkB9MP0c1XxawWuMBgmvUrPOjs7antJtzXXqwSIBK8XbomTfg189Xr+Cz+XrnngSK6N+CKEtLwQbcOkmC1I0gCtK4TPK5kga02k4Fv4I1Hrv4z8SdZN2lrFEczWM2lz04o50IHysMRAdjzUOSkFXl8+9/UkysoJv1u3kuKqgthacktS2p10vyQ9WihqLdX2qU3rr3t+cPa8h5UwfAtU6nDqu7VVNIBk+AXxOZFTsVqixcEJQUbgPF1AfPbng4OqtfeLITHK8oyEySFUlnAts+vozrLbLY/ywOG+tA7vGqbB2G2WlWdV5z8H582RqqQixzTWwCktNsgUfEnmI2GyIWWgl53N1N9HGXZrtkl9JXxFmVWEk3UThxUM1qD31/qftlK2e85tkEpH7n7UE72978paPBKTHOY/g5CjlRQLBz5hAlQC3HhoJK8w8CYPS8a/crjbeZkuaCcd5sEDH7zFN1Demxd3/sIXZmVkplK7ZaO2SoaNaOXWMJhSWuGh/2EE7qi66LPB+NlCWWAogzlTdEVj9k3l3NHqXhkk8GED/6W+Gc5Z6QvXR5vfqIQ/vv6/QCeALCjJH0UsT1o7A4iGdJwdbao2Z6fQ14dgOU/bFi7or0fqV/xfl1X8KPm6O6H3WGc/1nsNXeBEtUZGrYVbgQBeHwFP7N35qqhbE1PzsooXouNha0ELn354DrzcJoxt1JNB29aE7AlIKtFFJC0bMd/8Dk1x4cIA4bptLe7oKCdCxYuLkWla3qN0wXeOODMpdjORJn2VvaY38B5qKjBodYZJaSFr3STMd9AC7y0alCeCaUWwDpr
 cDJ+e/F5
 IxPQTbBmEIuL6w5F/gJfy4TECWY+qLE5q2w/Ryf8lCWKX4vfttlimticd6raZE4WvM5rbgKwXe+vrvyPbE2W0+/eAyhI8ZBxBkfRYm9Att9ozRZU3ab5mWNG/5MB7yy4G1KR9Dua2g7yvBoBUcDmontKI4AeGJYwc38FAHPQ6K73mMlgWi2Z2iFN/x+6dKUYLeeJKEG4kfClO+e+Da0pNL/NXpnVddjtslry+E5KSeH9a0eBX/dhKIZSMxHM5KNUuH5xnc00cfwRWgc8UuL9pjKiCmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_huge_pmd_wp_page() splits the PMD when a COW of the entire huge page
fails (e.g., can't allocate a new folio or the folio is pinned).  It then
returns VM_FAULT_FALLBACK so the fault can be retried at PTE granularity.

If the split fails, the PMD is still huge.  Returning VM_FAULT_FALLBACK
would re-enter the PTE fault path, which expects a PTE page table at the
PMD entry — not a huge PMD.

Return VM_FAULT_OOM on split failure, which signals the fault handler to
invoke the OOM killer or return -ENOMEM to userspace.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8ad43897bdf80..9f4be707c8cb0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2137,7 +2137,13 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	/*
+	 * Split failure means the PMD is still huge; returning
+	 * VM_FAULT_FALLBACK would re-enter the PTE path with a
+	 * huge PMD, causing incorrect behavior.
+	 */
+	if (__split_huge_pmd(vma, vmf->pmd, vmf->address, false))
+		return VM_FAULT_OOM;
 	return VM_FAULT_FALLBACK;
 }
 
-- 
2.52.0


