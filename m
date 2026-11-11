Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E3160A3836
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G4h8Awzd
Received: by kanga.kvack.org (Postfix)
	id 4CD106B05BA; Wed, 11 Nov 2026 17:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EA66B05BB; Wed, 11 Nov 2026 17:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3943D6B05BC; Wed, 11 Nov 2026 17:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0046F6B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:00:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78B388040C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:27 +0000 (UTC)
X-FDA: 85424207694.26.9B771DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2FFE12000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:00:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4h8Awzd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHvYGTmbJqczwpKl5nraRSA21m3YoEwNoNnIMQVxtIM=;
	b=2WLMiEW/yqnlUvZ4u92Y16a2xOiB91f/blZNe0ET2S28oi3gbwcKv8DD/ZKj5CF29gGUCk
	nfnjmLNbL3RQsa5B0qeuQ/+0mi71NqZ54NQ8Hp3XoEw1vDE3ntrJAuqnB0Qp5QAa3sFapT
	5YBNaoMr4oE1/WeMhGPwlexHaddpApo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434425;
	b=Ve8jWACN6KeUCMiJiUfU8TDJ+9jm8mtL1/0lsIjTqoQgweZDluLQ7sTJq1rauWfR52jmfM
	7Lq9r3e7Q3KuHhBFD+i4IEof/RRnf8MWvYNxPaSWmLoNm4eMb0LogEUp0Nm4BiNYtmGvkd
	35i8ItKCIE7AC29SKTatW9jSVwhfBHY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4h8Awzd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07E2842E18;
	Wed, 11 Nov 2026 22:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5363E1F00A0B;
	Wed, 11 Nov 2026 22:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434424;
	bh=ZHvYGTmbJqczwpKl5nraRSA21m3YoEwNoNnIMQVxtIM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G4h8AwzdWPBd5kXLtPEIcLPvQ1XEyQuMdhORFExWsjdSoCaNtKsy7cfD3LDzBiwzp
	 F/zr+qUwxinhgii6Ov55+l27DkiMmrKtOCqiSmfImRT63WEgM7IMeZtc12uDMHCX//
	 tJ8kF3IWMazWVTjbrF94KYeuJiqa9WwQCac0phugFVC4VBWOuFGHgt5/kCGwQOWtDE
	 tJmZvLYiMtMsry3oI6Of8Xhd+l2bCBFjjY1ax4kIB4m7/fmuV3etcOhrLgFP7IzHT+
	 L8UOZdV06abq0DPr+URdfAWVnUkr9k8h5sxMZjQCN0FeeSr/RySdscpSgh81/KZtCs
	 qETQm6/IBBE7g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 11 Nov 2026 23:00:01 +0100
Subject: [PATCH 3/3] mm/rmap: fix PTE table overruns during batched
 reference checks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-pte_table_clamped_end-v1-3-2dbe339c487a@kernel.org>
References: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
In-Reply-To: <20261111-pte_table_clamped_end-v1-0-2dbe339c487a@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Peter Xu <peterx@redhat.com>, Lokesh Gidra <lokeshgidra@google.com>, 
 Barry Song <baohua@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1280; i=david@kernel.org;
 h=from:subject:message-id; bh=fwx7b+WXIb167Hoov0yJz4Tl/bBR+K10WHa0ZfAYrs4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+PE1depvP59o0LaXohd+F6rhf/LQ5Lrq3XMR35U1NA
 Z1a4VfvO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjI60xGhomLD7z/ev7Jq2uN
 qp6s3R5uuomPuVXjX9Vv2/148/Fqpb+MDI1HX02/wdpkJrDjDbu8ps4GjZ6Y9bfapLmaryZoygQ
 3cwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ftygk854qrhku736nff1xcsbdbafwty3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2FFE12000C
X-HE-Tag: 1794434425-409277
X-HE-Meta: U2FsdGVkX18/Qa2zpAMsBCylyeDqvNV/ydPoTDg1cDsjdflQhU24MKusmpByMVuSEDJumfVNoSmgcL56BdECB/a6rc/s5NgA7kwCXpSybHICxB5wvhW/CsJML3NIkWe9RwUlCR0y9OyhVqbh156/m/4ferC2F6uBDfg6sjGpXqBw75EN8mRhWgFvBhnpMeik3GJLYndlOCOb2rnf5ZY1gFL89h/crBJSl+1HS0vZZj7tDJGJO9aVi3Ko6BVJ3JdLleqiOjRaVtoP1XrWls359k4qHij6PMjXs2esarkkNq7ONOkUFfa3ZLqqL16PWC0t4/MBvx0vcgNFzMcKfdx/tGQNg+olf9GLIQBN5IVaEKckt7r5G/jqmEbUi/niu62UNKaAHqp+V7dYnaQJqJgVBrU6QCR7Nq5XvsTaw5jdzz6oOEtbfTCc4Z9X630Cj/VUwQJiNMNqd5SAgva2W5r/1NpYlTTuSOZUQSSXF0QAxyQm3FhJjA+GUQBCqnto7JIA/r39calAHWSHLmVUfLaGdae6BDRh16JJXg+CmU1kkhg50voE2I2TPAAKkolid8wKNC84Z57YSu48bGpRmf82xBMKbhb8BO5s+ZiTMVFwOHCQ/H7gUDQxrzV/ZMD4KwqjCeg47qoxD9WDgpRs3sqTIx1JKSJeVsAny5B5tDTVRWqs1lfK+nzguY8wSqOG3sH7ACDpWV9+lm5DLUg4tjOLBZXn+8KedtcAGFQ+XxPa+TazpZVFuuHx4hn3a3bF3Iu8fS7IfKiYZHO+vp+Vm1VlRV0w21g/V1ytc8Fmdle5BaX7zc0IltF+c2gT4Ijd79aiaUXtt5Aur+HphayYKQwqPEW2XjJb4tF68jjfsk3xp1sv6WavAuWgpHWNADp5zDdvlMlZQL7VGLg/kjMu0PsHO5H/AiZMoMTTAHOV9NRsJgyrVzn+X4EcKRUyzui++P6pNi9R0L3AbikacXfp4fQ
 IOUXw2EO
 M1AqHuo+6Th+T0RfgOo8cHqLZg2iTn8V6mgz5i4Q65l6jK00fs2JLalDEMSOWkbaEsZ2USpH2vEiRMD74wJnK8PViyWGVDXlPI9Th7THjaZlrV9CqA2s64aEJFYoWwmF6LK+K98UHYUJRqNyOa7xUV1aGw0WZhjYEgTkTWYSxKolEFa1c/r7Atcr4Pfd7OAz6YzMYqNmLXdNEmsebDlH9uZm/48TMLfgGrSgqJsq8RiFoQ7NB6Abv9ptnlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With a folded PMD, pmd_addr_end() simply returns the supplied end.
folio_referenced_one() can therefore walk past the PTE table when
checking references to a large folio.

Folded PMDs are uncommon, but can occur even on arm64, for example
with 64K pages and a 42-bit virtual address space.

Use pte_table_clamped_end() to clamp the range to the PTE table and
VMA boundaries.

Fixes: 52e054f71840 ("mm: rmap: support batched checks of the references for large folios")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 491a954b7fa44..65646ed6fc453 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -973,7 +973,7 @@ static bool folio_referenced_one(struct folio *folio,
 			pteval = ptep_get(pvmw.pte);
 
 		if (pvmw.pte && pte_present(pteval) && folio_test_large(folio)) {
-			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+			const unsigned long end_addr = pte_table_clamped_end(address, vma->vm_end);
 			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
 
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);

-- 
2.43.0


