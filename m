Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C030CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 22:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40828E0029; Fri, 17 Oct 2025 18:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1318E0008; Fri, 17 Oct 2025 18:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8848E0029; Fri, 17 Oct 2025 18:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74B118E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 18:23:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD26CC02BD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:23:44 +0000 (UTC)
X-FDA: 84009034368.16.B7A0717
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65AEEA0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:23:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JZ1bpfou;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760739822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+dVoUUzmBb0nQ+poBRDWT3Sih6gX5/+Nw8MS974GdY=;
	b=r5cppJwe25X1sl8jRzM9MzpxEYbwsbhpoCesNiDiiZbGWh+c+DavH7LsjLdkNLsJO/PHvS
	NiKMt+4oi7pTsoeKxCUbsTgk3Gd1WWTtXbk9KZhddERGDwbj2hcOx8RnP0dR+E7d/rC4k0
	sNDf/X6KP/ylb9aU3svNXU+lDeKeDno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JZ1bpfou;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760739822; a=rsa-sha256;
	cv=none;
	b=gVCtsxsrt5bw+kXtyKeGAre6tn3/XgQNktUzG/N6gLsErU6Er/Repb4snYr5CnnLxRD9ZC
	rcxliPyf6GdhWoLhcX2kzIqiDxG1ulxhj/wsDjpksTL1X5V833rA34ZLBjAYmiLVIZYal8
	d7SHCUhP+XpC1GYtuxwNtgQ6EjkkISA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760739821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=x+dVoUUzmBb0nQ+poBRDWT3Sih6gX5/+Nw8MS974GdY=;
	b=JZ1bpfou86RDbZI+O5JuLAE1YinbX78+nxceMT2DMGvOddLwkWGuIS3CMRMAqiqlXkS5Ps
	Qv1KimVY399WxnXn175HBdv/z3slnpNh/1o4x3ABMwNSGitqDFueWE9ZDCWdjzU+9i1Fm7
	pPq85+CRdTleHt0++YwhWATdiZ1iQsA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-qbFKMb3MMSushbmCxvhckw-1; Fri, 17 Oct 2025 18:23:38 -0400
X-MC-Unique: qbFKMb3MMSushbmCxvhckw-1
X-Mimecast-MFC-AGG-ID: qbFKMb3MMSushbmCxvhckw_1760739817
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471125c8bc1so28899885e9.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760739817; x=1761344617;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x+dVoUUzmBb0nQ+poBRDWT3Sih6gX5/+Nw8MS974GdY=;
        b=fxNxBHOWslBBXpIAl3DyGG7100NJ5uitaOyc8RIskYMt4RQQ20wfKTYP2/iZSHdw3L
         PMtpLSM5NpLht+vt9gzBrZ4uPZyc9ky4A0c4b4QsUfziHS08fhk1ac9va/b2OhDp/uxP
         CuRPus4O/6Ty2ueuDVbjLn+Dk+tSC2BZHSoy7iC2Jq74frfVsKXdvE7m12E6DmvY00/X
         LlJKC39whD0l4ekX+J2WKX+xYfXGZTcQ4xmXvwBhm/9MN4OLn/C4oUk355LUZq6X5SRd
         mHG8wrejFT4dtPgLyn6pvY/0oox5c/M9BlreuUcMN1e888TxKGMVU4Rqa1+4rw9ij5Cp
         /4DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkISO2dhNe0ASV96RDsLYn8P0DHbsYCEv/MV+9g/g8mh37+PIUIQdOBbsdS9WYSEcMExw08c7/hA==@kvack.org
X-Gm-Message-State: AOJu0Yw3CvzloeKtdJgmS2x00oBZL6PEWCgJnGh73o8JAlGmWEXuN/aL
	sxI//pEe7LGvV8jeKgbamSaRh9NdaX/BhKS61l8qKhALQphEPeGC82yYy37LDfrkcZxtD7dtmsP
	LiIE7OWqajAFaaMIomQvmSwBl0/6s2z58NYCwvab5awAsfunk6QtC
X-Gm-Gg: ASbGnctTj87AfgzwI2RFE7hLgNxK97XLNS7DkNCuZHys4uquDVuEjzmeVOCPOLflWps
	sjSpLrBdCzgBAAsjk0N6uwChEjt28tanJ96kV51pEQ83Ge4spQ6EbacnhOyNQjnVayyCqmBUmg4
	1mkmv0pB4gnkGAPyKMxgVAuLD9sltaiOLlwgVAF5Mklys4CAf7cpe4Z+rqqn9sJ/YVk1lIpkVqd
	YVIn956CUGX4b6/vH7LJ2Ia1kkC0OdpMw7tPPZxX75jWnjdJI0Z227fj8HqIU2LIBvDT2oE6nsN
	lgwGGcagGS7nHQimcqKgQG3w6P+isWXfMx+vQw52M44E89JUoxMzH/QVBphKriyaLLe9KiQkSQo
	/MnPe5jOfq3EW8DPp3LwPNxReUwb4IUKmDetg2nl6s94UOlxAzhlmucnY8oB3MYuhHotkZBbx2K
	+txdF4W+0brs67apmBTwSl/CqssXw=
X-Received: by 2002:a05:600c:4fc1:b0:471:b5d:2db7 with SMTP id 5b1f17b1804b1-4711790697amr33239555e9.24.1760739817111;
        Fri, 17 Oct 2025 15:23:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtlt0Ihr/Aaaf0M+Q3hhi1pZYNkt89VmRxQ2siQChpIBmDIjC60WiNcyPKF+UdUFpnxAaGqw==
X-Received: by 2002:a05:600c:4fc1:b0:471:b5d:2db7 with SMTP id 5b1f17b1804b1-4711790697amr33239455e9.24.1760739816699;
        Fri, 17 Oct 2025 15:23:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a976sm1525851f8f.32.2025.10.17.15.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 15:23:35 -0700 (PDT)
Message-ID: <844af749-374e-49b3-91f0-a72e951981c8@redhat.com>
Date: Sat, 18 Oct 2025 00:23:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, craftfever <craftfever@airmail.cc>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251016012236.4189-1-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B3E67wlqbUkqI_f2W6IVITKojaruoleAd5a44sm5g1A_1760739817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aykqqarykwdr69cgcfx5utxus54qehgq
X-Rspamd-Queue-Id: 65AEEA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760739822-598659
X-HE-Meta: U2FsdGVkX1+fkBFsjzCseQ/f4DjRa9Ei4iq9FrmDocWWc4dmZyBxaT+kyb3DkUxFVSSehuFUkgaFjFXwcWEQAKf0DQYqKjVpHhWSYPuCZB2ermXh7P4uKTbjBgp3dzb+LqffPW6ERRxELF/KYQWkr5x+tHvXLqYiMVxp+rn8gqTOvFJ8/0mKlz4SxN/7IaXncFVsHnaz9In1bU7N8TNHmgjPn2RI4cl7+s9s03FdGfn+pUGBWH92neT87EOSWhCy4mfwwVoTvCL8VD1c7v/Px18WKwF21is7idOmrzIuN5nAe00qKgUbDY0uMuA3y+IPmd5P4mZa2yZJ9vqJnf38V7Yj6gTBT0QZSrRxm3tphRvOJa/0tS8rCfv+DU4Og49FNX9rJSzcMVmncVeH57/ZSh4OgQvIlAbQzA/kM832mzNj05xRIKdSgoaNbt4Q0iutYmlB+tylekKvFPo/qVH5n9VlOFZsj8wCYXB+pNkchuhe1m3e7GL39eXvV37ybbybT4Nw0UO/Q4Kf/QYUt3rXMyz89j+oD8U7sNoJDZ5Zid9nliXeyphR/eJ5og4M9I8OvDP96s9udhuEXnjkYI9wiTeO69kV0qH+Fn1W2B/scE2E+2JeAgE+T1dFs6i+z2IY+LXzwFECoO6L6F7vAWm8W2JaSagU03NoG0C4jfoOS94+bJPadUZLAbd5PH6qhHt7eOzNok0wajBE8tYQmeNv0Xg32JdlrbVpFWl9d3VGtxDHXZw51RkRw+4seF6e0FTqmga1CQkJ02DpD+GGbQDhzmPJrbHo/t1jhcnvL9tduGi4niRU0+xqr1vq0U7n7CEqBWERLiN60236PdVHUppckprsSDPfDFEfoRHd7Bp8XmRmNSmynfxj7Ob0cvvpQkbHoCgEDaQRKVvgoQODPF5A/GZnDJd8o2/IEQ01aHK3zSQJYnvmhY8UP6MY9LPr9xBmh4BVXH/vX4oWORMcF0F
 yUC86k4v
 R/ce377GwlRDX2DDbDI/a5xt2doXkchIhwZXzj4mNGw1Rx809tveJGTnhyZiwEZMGZ/DywKg4hP0FsDhyVJiT+c/SN2AvaPhC0VypaP2/uEhGH5s+ZM8VJ1bdP0LhgJB9cHlrwxv2LVyhsCMuXHgluMqEEL0MpxBRgEg+nN+f1hvJdhlKUdz67MmtxGPvb+g5IZgqHkUpOllMXgibU6IhFg8hJ9AWZpRbWQ3350tUthrJNhGrhC5yIkFDnDXGQahXg5L7geANXCeUf5bJNi+QRthObkis6Y2cbqaJuzWFiXv3Vj5V1ZBv71xelcg2Syg0xdt2ikf9twpBprOvhwSvemIeL5UYprkScWMlaeKbpuUjCFb68A4UyQNGDzH6/I1j2jvxWCUDiTB1qn3trc9FhydnGx1zHk/dm1kKN4/WSzzLwKq5MCv/R6si14Rd+k/ai+j6GNaizf4CJXY2IanhFnn9fuehFurdIbgSnUJaUcPZgPWJzi7HLVr62fxFLaRT0qP1TdQ3hiqGcIRh7ZEgJ5HrTxdeGfq1iL8415ajj4i1HiFEpszAi0faBhbTM5w1WyaCZ0c5itdPqh05BJz+dIxGhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 03:22, Pedro Demarchi Gomes wrote:
> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 
> ---

This patch does to much in a single patch which makes it
rather hard to review.

As a first step, we should focus on leaving most of
scan_get_next_rmap_item() alone and only focus on replacing
folio_walk by walk_page_range_vma().

Follow-up cleanups could try cleaning up scan_get_next_rmap_item()
-- and boy oh boy, does that function scream for quite some cleanups.

This is something minimal based on your v3. I applied plenty of more
cleanups and I wish we could further shrink the pmd_entry function,
but I have to give up for today (well, it's already tomorrow :) ).


Briefly tested with ksm selftests and my machine did not burn down my building.


 From d971b88056fe3fefe50e5d4fa5b359e8c8331b2c Mon Sep 17 00:00:00 2001
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Date: Wed, 15 Oct 2025 22:22:36 -0300
Subject: [PATCH] ksm: use range-walk function to jump over holes in
  scan_get_next_rmap_item

Currently, scan_get_next_rmap_item() walks every page address in a VMA
to locate mergeable pages. This becomes highly inefficient when scanning
large virtual memory areas that contain mostly unmapped regions.

This patch replaces the per-address lookup with a range walk using
walk_page_range_vma(). The range walker allows KSM to skip over entire
unmapped holes in a VMA, avoiding unnecessary lookups.
This problem was previously discussed in [1].

[1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/

Reported-by: craftfever <craftfever@airmail.cc>
Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/ksm.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++-------
  1 file changed, 103 insertions(+), 13 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 3aed0478fdcef..8bd2b78c4f869 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2455,6 +2455,94 @@ static bool should_skip_rmap_item(struct folio *folio,
  	return true;
  }
  
+struct ksm_next_page_arg {
+	struct folio *folio;
+	struct page *page;
+	unsigned long addr;
+};
+
+static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
+		struct mm_walk *walk)
+{
+	struct ksm_next_page_arg *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	pte_t *start_ptep = NULL, *ptep, pte;
+	struct mm_struct *mm = walk->mm;
+	struct folio *folio;
+	struct page *page;
+	spinlock_t *ptl;
+	pmd_t pmd;
+
+	if (ksm_test_exit(mm))
+		return 0;
+	cond_resched();
+
+	pmd = pmdp_get_lockless(pmdp);
+	if (!pmd_present(pmd))
+		return 0;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pmd_leaf(pmd)) {
+		ptl = pmd_lock(mm, pmdp);
+		pmd = pmdp_get(pmdp);
+
+		if (!pmd_present(pmd)) {
+			goto not_found_unlock;
+		} else if (pmd_leaf(pmd)) {
+			page = vm_normal_page_pmd(vma, addr, pmd);
+			if (!page)
+				goto not_found_unlock;
+			folio = page_folio(page);
+
+			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+				goto not_found_unlock;
+
+			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
+			goto found_unlock;
+		}
+		spin_unlock(ptl);
+	}
+
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte = ptep_get(ptep);
+
+		if (!pte_present(pte))
+			continue;
+
+		page = vm_normal_page(vma, addr, pte);
+		if (!page)
+			continue;
+		folio = page_folio(page);
+
+		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			continue;
+		goto found_unlock;
+	}
+
+not_found_unlock:
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	return 0;
+found_unlock:
+	folio_get(folio);
+	spin_unlock(ptl);
+	if (start_ptep)
+		pte_unmap(start_ptep);
+	private->page = page;
+	private->folio = folio;
+	private->addr = addr;
+	return 1;
+}
+
+static struct mm_walk_ops ksm_next_page_ops = {
+	.pmd_entry = ksm_next_page_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
  static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  {
  	struct mm_struct *mm;
@@ -2542,21 +2630,23 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
  			ksm_scan.address = vma->vm_end;
  
  		while (ksm_scan.address < vma->vm_end) {
+			struct ksm_next_page_arg ksm_next_page_arg;
  			struct page *tmp_page = NULL;
-			struct folio_walk fw;
  			struct folio *folio;
-
-			if (ksm_test_exit(mm))
-				break;
-
-			folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
-			if (folio) {
-				if (!folio_is_zone_device(folio) &&
-				     folio_test_anon(folio)) {
-					folio_get(folio);
-					tmp_page = fw.page;
-				}
-				folio_walk_end(&fw, vma);
+			int found;
+
+			found = walk_page_range_vma(vma, ksm_scan.address,
+						    vma->vm_end,
+						    &ksm_next_page_ops,
+						    &ksm_next_page_arg);
+
+			if (found > 0) {
+				folio = ksm_next_page_arg.folio;
+				tmp_page = ksm_next_page_arg.page;
+				ksm_scan.address = ksm_next_page_arg.addr;
+			} else {
+				VM_WARN_ON_ONCE(found < 0);
+				ksm_scan.address = vma->vm_end - PAGE_SIZE;
  			}
  
  			if (tmp_page) {
-- 
2.51.0


-- 
Cheers

David / dhildenb


