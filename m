Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E4CCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF5D6B00E0; Mon, 11 May 2026 15:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7316B00E2; Mon, 11 May 2026 15:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBCF06B00E3; Mon, 11 May 2026 15:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA2816B00E0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:00:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C7278B831
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:45 +0000 (UTC)
X-FDA: 84756055650.06.1F86283
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 039AD40021
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:00:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GgfWCOmI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778526043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMiKbJIv8O+0Y9TOH41K0m9qnmm5UDCiFzxBAtFMR/E=;
	b=8n7FxQ27OrUXMne0ubZ1w1VrEP0FQvKuTbheL5xhHhhzvalcafp6Ua+GDeRXzzEiXdvsh3
	oQVRl8ts3QcRbVBrVKYv+kfvJUYKKL0zN0f1WMfkepwsAcL62NvUIkxdc9p3//WNpPFN5G
	JGu4B7HT2hFHAu1keL/IrV4wnrUko6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778526043; a=rsa-sha256;
	cv=none;
	b=t2dRlsn8c6Ofw0a60Y8RD9EeohfIX3qcc6cnIOSd8wvcWxhcgZ6Hvtr2J0uw8mL9FsOzEV
	EKegWZ2vBFmFa10UvA7TNF07H8xsyhLmcP+XWLNCBo0Xa2xkDIR3reP/Jr4SRSy1B+v8HC
	dKoo7j82z3DIXWEZRVj1ozNwRAJeeCc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GgfWCOmI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778526042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yMiKbJIv8O+0Y9TOH41K0m9qnmm5UDCiFzxBAtFMR/E=;
	b=GgfWCOmICFOjaWsJamjvPtyXFUQvLNuCdWfCmWRSNmkqDVyVNtpSBDrAh03UtRThITYNAD
	dYlQw9qIARwyqsniBx+4trogqIlsKaj9HZtv6ktuDg1kYDt35ULq8MfWZAb2W6V1QIKCbb
	KAnv81GzJYcI3sPu0R7Y6UyjmTF2pFM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-lWhAFX3UO6io7WLhpJdvrw-1; Mon,
 11 May 2026 15:00:35 -0400
X-MC-Unique: lWhAFX3UO6io7WLhpJdvrw-1
X-Mimecast-MFC-AGG-ID: lWhAFX3UO6io7WLhpJdvrw_1778526028
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1601B19560A2;
	Mon, 11 May 2026 19:00:28 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5555530001BE;
	Mon, 11 May 2026 19:00:08 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v17 07/14] mm/khugepaged: skip collapsing mTHP to smaller orders
Date: Mon, 11 May 2026 12:58:07 -0600
Message-ID: <20260511185817.686831-8-npache@redhat.com>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BMm-w5hhUhMW6Ufh4b8qn2uaJxdp0mCNKTDhsSSacEg_1778526028
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 039AD40021
X-Rspamd-Server: rspam04
X-Stat-Signature: 33nwhag3x847ytpn6owgx51ie98qbf46
X-HE-Tag: 1778526042-612384
X-HE-Meta: U2FsdGVkX1/vdFNIB7vpvTTXTQAiBSeOH1RcJ6r6GCZnqZRGENBU4eczdKI+3X3u2MTF8iy8KbS7pqCDio9s+LWsxQ8ZyOXk7O9O83X56QiBtCIs3JX70RyKbnAuXwwHF2Kj6c/bJlu/huU73cDMbhyga4MATBWQl8LjXo52fD8pZnBxXSiwwjnQ16t4F/Lk98kBFDd7DSfRWLXJaFGtMdHkEkQPD+HM0o5qlA37NOvu3lKS2pKefzpmB/ykRNHYs6/sjiNXVmG14VpT8MI3eGCq1JhRLyOCnZqrD8oszc7sYn2QCulF90gGEJ6CEQ1uC+NkdSRQkhpt/P2H+LjMtUqkL85rbvnRCTX3tYA1ZTOB5yDHhKIlVWfqdUlOg3acCgjJqis8+RFwIriJZc+D3gYzjUweNZcDW0uYMN+SgmEzENneUFXyOv2qymPPEZLiiJUtmoWH0yC9XRKkiWLDvVbatOdGOucR8zW3wJkbeSSnlaBSD8BwxhqYT/QnpVtYT2/+vQwPXFDrry8Fscg+sHoeXfi7IK5HxZBcUOLSjd5PlfkrrxDN5keFgdJTQDGjAvSZaffcEKIBGH/ydeXP68A71FLGryWARRXDHDmK9vZbbKoWzf3DIZNtLCQp9oiC6qJFFJwu677OtIfDOFSZx9jv9c8xVHPiXnjgg7oDvHX4BxUuk+BUn+kzRmIX4TTEj1XS9pIvpe7tCSHKLWqEffqvblT4VIjKHsB0xjpTzG6leoi4XKqahTbAusfZpcOkwWabAkC7h0tQQe4Thi96YjRASdpbyLx8aorD23SP95yqOioqnjnySsq83ZmkgunTtBrivE4Wr2gBNVQmMqcQMCzUMLn+95cv+w95r5wy5aE4Kg77lca5pgmn7fqjJEQaxwehnMha0zLf0/h7vijOwwdbbluTP8RiipnQ63D270oTgeBkuu0o6SjwotUxQAGOwAmkvn4AyDH0V85bfOL
 si0cI315
 76k99J3SOuFQixjdjRZPb8DdPaT5/JkVGcVA7LzddL/7hIZC1yk1gOCfuTWqABNu6mQehOuB2X3AW7lQp5ulSAKsDrCIv/bUQlqiVST33TjLJwJLTlLRhiDOyn5nD5O0kKVg6pMpxiD2VD5ioHUKxi3lMPt9+znrB9DMKcY7q9o5s9AJqUeipO6ic8qkVAZbE1rcD0yPSjIT20oo2uPPZiHNMnLVEimV885buyBIDvzxsNK8Z/CietIpzYPAXuFkXmWPNP6T+mayzTbnkeze9zM4A5RfT6mY7CxjhMh2+w+SfuWfNuRscGk767GxgxHn7dj4maSAvnbpIbm3TT3PDrERR6/4m0SFu4X78fkq+QLK2EnqQdf6M4h40O97g+3c2nerovKGMI7cDJ4EhSPtE4uDKFpw5aVQxT96hvIqUdWdn26UNe46RRlQBiBC7B0kzzTEUNDv72WcTg4JQgYAju15NxloCyTRpXnnd/00VcZJaLy3ZgN/YQZOnceRMpKc8hvT1i4QiiuHdS4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
some pages being unmapped. Skip these cases until we have a way to check
if its ok to collapse to a smaller mTHP size (like in the case of a
partially mapped folio). This check is also not done during the scan phase
as the current collapse order is unknown at that time.

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49bef78cf51..ba21b134fc86 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -685,6 +685,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				goto out;
 			}
 		}
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (!is_pmd_order(order) && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
 
 		if (folio_test_large(folio)) {
 			struct folio *f;
-- 
2.54.0


