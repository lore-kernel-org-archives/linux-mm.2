Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFB660A2601
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=CJ0SS3WN
Received: by kanga.kvack.org (Postfix)
	id 14F966B05BC; Tue, 10 Nov 2026 23:39:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1279D6B05C7; Tue, 10 Nov 2026 23:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CC66B05C8; Tue, 10 Nov 2026 23:39:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFE2C6B05BC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:39:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DD6A1201E7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:39:09 +0000 (UTC)
X-FDA: 85421583618.07.02AECCA
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8CF9140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:39:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=CJ0SS3WN;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371947;
	b=PDUvx+2tf4EKjhjgzRiRN/wWSYfCjBERGcnCw9kRdAi1zGuRb313GXxu4WV9e999yxFpbb
	4Hd8TXlE5MEEMgNTc1us0bqenYzdVWcSgrIdSlLCoDydTovKZ/F1UC5K6T6/PMPzt/A5Wu
	V6zy+cxE25H9wK5C78BW88kDVg+BViw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lvre1MX6Fv185E+vol1UoVO9hXcj6H5AcuzmOlcLq2I=;
	b=rrntgX/y3Iizrv6lHmzoNZ3hIqOgK3kmCKXD/5V6+yJdba1aDgHeEQYLKSTwFt7IH1lIfT
	MhqnhNSTWvV3+CFldENhwdMjuB/3VyQ7dGMGU9duW1cHYiv9lzxm+VFa8kooz2h3JToPkJ
	YUNE9OyYQZUsRnXkQTGpji1I9Qwybh4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=CJ0SS3WN;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf11.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.42 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso29567325e9.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794371946; x=1794976746; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lvre1MX6Fv185E+vol1UoVO9hXcj6H5AcuzmOlcLq2I=;
        b=CJ0SS3WNyp/skwIS/nALBiNSqk6kpt7AaEbjiQBUN4KAjHEBoyMAt67vHKaFMboPEI
         qD5Mtt89MEbOwt/mThHtoKdOZn+Caf07xhlKpySSk+sVkIUChnSbS5bUarGFj3Hi9Wa0
         3XD3wJOrmMrOBvuKxsaY4A2z7zM5RGxIN4wVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371946; x=1794976746;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Lvre1MX6Fv185E+vol1UoVO9hXcj6H5AcuzmOlcLq2I=;
        b=LMyJqiW9WsdHGSvNBIH4G9owsGtGd1zSFNpfyVxx/EtqcAQzRcXx+wE0xgdCJ/iT4Q
         K+yXS1whsPl+vQk4EeGpS2fsNu9arcAZEHWhckY26uxFFvvdDzUVlz+sKNllVsTO1Pih
         Am987DL0YcZAFPTCze1aa8BOLXlCZY3fv96EfLKJQ8ZZMyz2RSTYJ8qq42/kYsI62Q2V
         j8zqQpxKEugaUbvs68sxtFLN4Ah7BFk0AYOpKqt5UayJrSGthI1SgKhm1UnI4WSEV3EB
         fPNFeqn1XjvXnZoRYQVR18dAfN5F41w0r1nWtFyX7q78lb4a5CJm5mfsNaS4867XtUnC
         sKUA==
X-Forwarded-Encrypted: i=1; AL+hErE5FPuxWLuo28NJna3rOApnbroNQFPnrDo9JgVtWLypabUikMSXFljiqcye7/prZlyQaoU5ttY92Q==@kvack.org
X-Gm-Message-State: APuU4Z9kTSiKF6YwWCByGCfhdInVT/nTF0/XpNK1DHvaaTRwEomarD4V
	j/sURAt8i+7HzT0TevvN29nA7KQr7XJ4lZ/ELx0q3TLMQ1J7KOsXjA3r0YV4lOkcE+o=
X-Gm-Gg: AYBFou1r1OW9MmwVUDunXSbWnXNZyeN7YLxkOM1l529Qd0sgqN1yw8ZcBKxNsE+SFnV
	MByVqO9dGc8gfSckloMk0LBZ7LeZ2uaCRt1ZTzk9++EJWy6XZowOe+DeQu1Gr4bhdJKO3PW3ki6
	0+im+Y21ROuZDpEgjwEmlFBStJDTglumzXGEi9TxXafErHCudXU7++DjeQFFip/8uGU1ChI1A/A
	Duj9M6POUVQtuRGswjJVg9veMoVVaOFEPVtVmsGM9ElsyRgFw8PWlXySMCcWedQiidYEwjROIzO
	9aIVziMUvOAFy2gh2wd4Qbsoz6GA3UomNi4faS/FMg7HdrlFOxtHCNBP4h5v2yis+9NMjwKJQQ2
	ElsvSW/++AiEs4H6c9zP0opmUzk/fRn4U2hJlXbsyjgbACGhKgAn0epYQL9E24bAxQS7Ve7H9/U
	kCm5d2v/Rk0O/I1FxbFFsX+QEWtP/8g6xyVbpVK5TibYOwukliiiBFygzWAwypX8eCahOKV05VZ
	62WJvXm5aI0E+75ZvsEIolc0FFvk+l+UOfYPPmsGccwXqx01aTp84hTvnE1jg1yfB2+c7zYkdHr
	GY1WmcOxwJkpShMsCQ7UwlI+sWu4iuNwM3YGEhql6rVNiiF1YaM3dxZyIvJI/xzDX7o5PkPm1Th
	V5+mWocOoQQJ7XE9zloHWQ94ntIiDUAPPSZGZRsEYumHP5n9OLlXtbXvCgFBIm2TzwuRGSsPRrm
	qM1xtYLFVW9QTKSwEqtdCX22xqZbzwR70zsLxa+ddxudSgkssJH5wj
X-Received: by 2002:a05:600c:4f15:b0:4a2:190f:cf6a with SMTP id 5b1f17b1804b1-4ba093d4aacmr18204945e9.35.1794371945737;
        Tue, 10 Nov 2026 20:39:05 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba01ff3428sm124440165e9.15.2026.11.10.20.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:39:05 -0800 (PST)
Date: Tue, 10 Nov 2026 20:39:02 -0800
From: Chris Down <chris@chrisdown.name>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Mark Rutland <mark.rutland@arm.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale TLB
 entries
Message-ID: <avPxZjjdBIlM_8_g@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 8CF9140005
X-Rspamd-Server: rspam12
X-Stat-Signature: wtufhu6ixjguq34bx4xachbhkqb9896e
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794371947-11054
X-HE-Meta: U2FsdGVkX1/TttrMyKG0fL1jVs1UIGnqm7KzYaA5mR/wHtNguhE6CzdW1kdlkn1pt+2YcWM+3YFU2srQQQ2EjvuY1yyWFzuFIwaGLP0gTxFt6EO6scmP85D7r1NsbP8O7ExS99C6rW1IiBPPbVOOk7+MR818uwYMyo6O8Wm1ni42dDjchYEdv9+RTjz6ZbAzGIwDmQ2b89kmSey4we/eY4gmOVuYD6kOj8c4XmRU0CasACxSD6JGlUsBEcs44Z0rS245cWl3UDxprThzKMcJBoMLcV7fBaDePaMFW6tjqNXAOMTZorMj+i5aNnn3W15IlOqS15masvqyZ0KjduSzjD39l/VOgqjRfEdRxIKnJDIs2Mz3ZnNzU4JmctlTOKjB9wIrZjMvqX9MjlhKEoepsiHOi80daav3WigCbicd46Hy1caIfM4D5YnAVSIxmSZ4NvnIJ6Ih7NeMt2qrJLa67U/J6IGnKWxUR4BIUcEEDDsxgfavpQbd9suA2yGH7GldW02MPkfCOCNdqywdOsYAO1ABCkhb5R4dh+ZKzAWdJwNwqL7tfPx4pkIsCJ57AFt5Bk5Je6KmFNY31r9UUtjMgSUOoLWbiUhneX+iazv/8+/wabUZgAHYf/sQ3xUTO3lwOpAsVtZLSRXABJXRoR33sgty12yLWZ9HFY77RsG2VEK9T8aQn+MWH2VWun0dqFJ6J5OACiopHBuO/uvYri0yg2zlYMcf0tAi2/mj0YMmxAQfFv+tIZ5ZG/+Kza+KLuHTLjDa6qL3ysInpmT4t4G9785p1Yq1sVj0HSW31AN/A7vxqqwmA9a7Ttm2XKyvX5Z5xsv+qhL+wTH6DixuX0yPcCgGMnQcGH57/BNjykTqcenOd+8jAL2zeuX6SzKpfo7n3pAtjn3LHKlXM+Xdi2OQKOEzoR+lB0q4+AYoYZiDmK9Y/YzckmOmzoOr66V2AwkIBd1QNHpgJ4uL6WhGuKm
 cwPE37nG
 5XiloJl8ro1hYZZF3bjzLIXrjQsfsCs3ShrPci6L+IAlBbPQZ8Z6zPKptx/GR1s/iNlEhM+zF4Zw5yJnU3YoCKYe9SRSiuD8JBnTAYYSfBSzcoMUSiDoP3RIqO1LarW0Yn8LDfXLmxpHDgM7w7EHpn+epgdRthfgfydHof9WXYPIUABZVoAdfCOwF1pK3wRfLqDiYvcEHKdXM8Q8kwNPM5fRu0oHe05zUnhT1DmfGQqk7XOAjPuvpgA6RrcGKIMcky8Hhm34KhYDptlDgh/iNL4x7h/Uq4jOfMSGxYiqSPY/qi0u6GkqOTbZzGRomY6VtpVHUmOcT5vpWMmM44+LqjyNoyqet+SRDmFZG0lThD9N8qS7l9fGXGljr3Up5RvJ0gaGsTPBxMlJEbqXxaIweYYXREUS8uluBE339pR4GZ6e5CryHFKeDKsBZ5BR6yN1ySGB0iZMgLePTNtMZgx+gCZnpdy1p7X7+Udn/L6HuvLsIeTr3oHdEdEsWzvo0tvYnXSgdwfUv0NKdzriOlQAIjKTN7PtZAsNjmizOcs3JaiPLA386jb+aT+MYkQ9w6Qh+sMfUxHH+Nc5NMjes3OseNgA0OBwz8KNTmVIPvbNCjQP+IvuzdgOKUgEBNkEz+h5CucN+R3i0nLAok+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In Meta production, we have had tasks get stuck in a fault loop while
using hugetlb on arm64. During my investigations I found that affected
tasks share a private hugetlb page.

Looking at the stuck task states, I found the following ordering:

  CPU0                                 CPU1
  ----                                 ----
  read page
  [read only entry cached in TLB]
                                       write page
                                       hugetlb_fault()
                                         hugetlb_wp()
                                         [reuse folio]
                                         set_huge_ptep_maybe_writable()
                                           set_huge_ptep_writable()
                                         [flush local TLB only]

  write page using stale entry
  hugetlb_fault()
    huge_ptep_set_access_flags()
    [entry already writable, no flush]
  retry write using stale entry
  [fault indefinitely. well, that's not ideal!]

The reason is that when a write fault makes a non-contiguous hugetlb
entry writable, it only invalidates the local TLB. However, another CPU
can keep the old read-only entry, so its write will fault even though
the page table already permits it. hugetlb_fault() then finds nothing to
change and leaves the stale entry in place, so the same write keeps
going round in circles.

This is particularly bad because, if the kernel is copying to user
memory, the retry stays inside the kernel and the task can't act on the
pending signal.

It can even remain unkillable while holding locks across the copy,
resulting in further failures. For example, a read into a hugetlb
buffer can hold the pipe mutex and block other users of the pipe until
the loop ends, causing cascading lockups across the machine.

To fix this, when a write fault finds nothing to change in a
non-contiguous hugetlb entry, let's invalidate the local entry.

Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 arch/arm64/mm/hugetlbpage.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa..ff1f53e435e1 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -429,9 +429,24 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	VM_WARN_ON(!pte_present(pte));
 	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
 
-	if (!pte_cont(pte))
-		return __ptep_set_access_flags_anysz(vma, addr, ptep, pte,
-						     dirty, pgsize);
+	if (!pte_cont(pte)) {
+		if (__ptep_set_access_flags_anysz(vma, addr, ptep, pte,
+						  dirty, pgsize))
+			return 1;
+
+		/*
+		 * Another CPU may have made the entry writable without
+		 * invalidating our stale read-only TLB entry. To avoid
+		 * indefinitely faulting on this entry, flush it.
+		 */
+		if (dirty)
+			__flush_hugetlb_tlb_range(vma, addr, addr + pgsize,
+						  pgsize,
+						  TLBF_NOWALKCACHE |
+						  TLBF_NOBROADCAST |
+						  TLBF_NONOTIFY);
+		return 0;
+	}
 
 	if (!__cont_access_flags_changed(ptep, pte, ncontig))
 		return 0;

base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620
-- 
2.54.0


