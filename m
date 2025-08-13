Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36329CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19509000D6; Wed, 13 Aug 2025 17:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA2A900088; Wed, 13 Aug 2025 17:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1199000D6; Wed, 13 Aug 2025 17:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7B1900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:41:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36EC6137FE5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:41:17 +0000 (UTC)
X-FDA: 83773055394.15.4BD128D
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5729E1C0008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:41:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkMbAmuQ;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755121275;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xw6h3XbW9SZjmv3VMhGxMmuRXeauHMpSfMMYghs+t1M=;
	b=c8L0AmYwSzjnhb7H8edqbXjzb6E/aXE8xZ/9rC6NzlfdWezud+QULbZMQ1npdbQD5mROaa
	egyte6NENIQCTWTRTq0DjeyCtKXftJqBe5LJMjrJ00iKMYOu/ZBLidspWjsjmHnQcC9KuF
	moDRojNOmLGib27567jNOWCf9Teooq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755121275; a=rsa-sha256;
	cv=none;
	b=xRGMNVc1yAV4AqVtwWRMnH45OOOkWu//2loCjxJ+G1AAToCBou35JVOUyHQ/FZHLxdUmwk
	oC3lhuUPibDWaiVAvGsmkTvMU43sANejr7mRe9HWv+Ud+XdOcEHmw1vOtuMAz7AMmsglnp
	CJiKv9PCZRsR2KWYC01hzC6ccExhTlk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XkMbAmuQ;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6188b73bef3so454031a12.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755121273; x=1755726073; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xw6h3XbW9SZjmv3VMhGxMmuRXeauHMpSfMMYghs+t1M=;
        b=XkMbAmuQwuE0Vt72Hup1nOEGZBSlxlxl7aLUTMl9tbSYVLLULNVUt9YijFhPzUzw4m
         Un9zTEsDD5a//jY4eTDJHymd29/h6X3Ro6ae1kXThR0kcmI7kl7fUcYTTnwi2ILWT9k4
         z21g+t8g/7V49kSLphJaVbNltsEJJyV4561R8ZHuHSNL7DN0Wr7kjXuBf+gXVi5VXWrC
         kC/Y1BWudk+WUJH6/NT4wmYQMHBi2NSGpUYx6VoHRJwUJELKu+wK2JKrMh9iyHQxrqCc
         HMJV8otJU1Be33rnv5bcVANYsFHYBaBShJ6dWCTQdWTOmz5gUln8hOQa3H2xVMd5wbdB
         uNRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755121273; x=1755726073;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xw6h3XbW9SZjmv3VMhGxMmuRXeauHMpSfMMYghs+t1M=;
        b=nsme+0KVF4MFSV5X2q7/Vwv/1DvpVV/7KxGG3GAsjwx6mw/ku+oPr9xFoPV9foEBJ4
         Espt7Vl6PMjTeZo3aZh7om/8mlpAg/P5gwk/kAdk6VpXp7oPazIHWI4Q3wPWbzVl1qhy
         bDUbqx33ckXsg1kHzvEqYWvuRN94l7oqeziIN4jUNT+nhon4HKA+2S0gPY7XUVh2F7js
         SkLUIVdqrC+Seys67O8zVlytxYrOHnyD1vKdrHAVLDqdYZCNMjwI6mOytUZ7U8d+4wn7
         gfF6VhKzWIWqI5xaW+ZDIr480v9zLrzokzqnO3Yt4s1tMv8v69jcsn1hIXYXcjkS5E8t
         dC/g==
X-Forwarded-Encrypted: i=1; AJvYcCVvJg6+8TX1cl+cdtTdt8KNJXNrFKi1t620U5A9jPhl6izoI988JgdLf/5lF7H1BsoSNb6z/JeBjg==@kvack.org
X-Gm-Message-State: AOJu0YwgX/t9DM2ouSAiGgzXoi8M5lIxlN1p5UkDO8scTV0YuS+jBl0W
	5m7sK2bh86iUqYjeU50PfKN0O21fRGInlZ2Djw+TA1CiLIelcpqdlOa3
X-Gm-Gg: ASbGncvBwoIQJllwqpcplFlVRN7a2dNuhJa9tyXHeCwC/88eTs3tEeh6XAsvV6Oyyfe
	VHMYyvMKhsdDk2VJAmXfeBnUsE/jgffhxYfvizhWPFLs7DjiQsOWNGSq/JMhjWV27qu3cs8lyUV
	ekyMCWkErWiyc7gEIP8+FRK2y5FZ0gKaLeMhvo9Ejs94VlDFjeOOdBe5hyAphB4kEP5lxyx+u+J
	F/+22PCDPBghpRCEwLit5IYEEma93c+w/GgqMbdp+zHeU/vK6CEXFVxFBBzoQGy02RzjenIRZna
	Czq/gd/VhBbsaYZ7GeclUHD5mpg75VGbfnPbbhZFeNksGvEYkooZ0E1i0B8GiCaxzONQ3bdMoTv
	bfXz6+iv6R4U08TE5CyjYEQ==
X-Google-Smtp-Source: AGHT+IGEVnxz9gbuq2Cd6iX98Y9+6sIOZ0bQIY85rrbIp58Ufb1dYCYBY4a3jiTNaFQchFh0O+qVCA==
X-Received: by 2002:a17:906:c152:b0:af9:610e:343e with SMTP id a640c23a62f3a-afcb93988f4mr55549066b.11.1755121273407;
        Wed, 13 Aug 2025 14:41:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a076409sm2480136966b.12.2025.08.13.14.41.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Aug 2025 14:41:13 -0700 (PDT)
Date: Wed, 13 Aug 2025 21:41:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 3/4] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
Message-ID: <20250813214112.tarr5rbamtc6cmie@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250812155512.926011-1-ziy@nvidia.com>
 <20250812155512.926011-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812155512.926011-4-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5729E1C0008
X-Stat-Signature: 7o433dxpaxjfugnp3j51qrsjwamkw14n
X-HE-Tag: 1755121275-531109
X-HE-Meta: U2FsdGVkX1+UmXi4GEBTDaz2Hmm/xwMLBkYtBTIVoG5Daz59TTcTVPlYNz8LVAkLXR2h+lFKi+IXB2KtZbLa2aohopWlBPQwlKeb5BbBiVlJkCqSWxEWf9exYTSnZM1BlWhvoLifnltvodzwfp5xFPMsMT/wtCG4CKLSANQsK0TRzAFLtXUnqvz4Ya8g3mYrgeoXQcixhSaAoOs5qwAovW9mUG0/tXkpLqWdSb8Ek3xgtSV4RGJeuZFpiUMhrMtyQuge6bClfHQ2EvVsTKJSuzvtFXerUGWcBOFCNLXOa3y9Q/0DKNs9Sue/YB85OIjolanyrPOgIoNleTLBieZBGYEguMLYPiEdj3IxtfhojqTtVRveivPu8kBVxrwlWe2I7P0kVKlnCNk6tHOBfPqQUPjQOCJcAFzt//M6rFQjIR/VDoF3pfxoiH9KgIQnJZkAdZeSN9ppH69NHWnAPSmBR6EoyhzzsTDqUCZWLtbRJoy882DS2ZnDHJoIcshU1SLcsWBHLhEA0Cx8lNMyqXBC4NcanKqrsBPaTTsRe2F93lhF27uHieFovOuHQ5b2jZ+rGd1jkcjpF81G7tVBOHU53SJkRrOg7cgpsymX9i6oCRBD0SCEtcnKr2svD4lOAFkbhY4fqJSOb5bI9nn04HdC4mJyliBYq5ytkLqVKcrW4NxwVT9vQunMuNqLknE5HIAJCiONoScjmMmx5fC5YkBRdhloycSQ0DBTqCI/XNVrhH/ARpqW+xG5mB6Pmaq+CRtCMjzQQ4FjnXhp02a+8E4GjWaeVOC1IUu6StMVISWRt1tAWn+N5FkZV2cfKTgVIXxP0RaspNsGntDMX3/8DWbh16bugKcgiIk/+01dAQ7BVJPPvcUE++/wGi7Eo3FUUkac1CUF2Tge9Ti54NvjHgnI7YKwqdxXOatYhOIBRDl8j9F1Pbl9NlH5I0pl55ZOpvxJewhuvTQjvDbOviSm4cj
 rAq3ojqS
 Dmcz4VCE28bedysF6cjRK0v3x9qpeUD+B1hgP4hcELRfmr3vayF9rNOddeR60qpcXsQ9+zksSrqkFTL2rhxmuOp9Ckd5izF531AhiWMnffA4FtAb1adCcFQllznsTkYKKv/vwXt2mgifrca/tepIecDpiZI3ZMoJDmzKBsmf5eO1TL4sGJIBtz3xbKB/MsW86RLhwbkaOUaY448ZJNgncGBM/1SUw/nLBQl4qBuQcRU0hT6O2tzp+TNCB9tHGcsTcdDqY5GZFohXT36co3AIbNaEnq/buphaLQLz3fmA+Smyek4KeVZccwRNOA+YfNqhWoPYt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:55:11AM -0400, Zi Yan wrote:
>and rename it to is_backed_by_folio().
>
>is_backed_by_folio() checks if the given vaddr is backed a folio with
>a given order. It does so by:
>1. getting the pfn of the vaddr;
>2. checking kpageflags of the pfn;
>
>if order is greater than 0:
>3. checking kpageflags of the head pfn;
>4. checking kpageflags of all tail pfns.
>
>pmd_order is added to split_huge_page_test.c and replaces max_order.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> .../selftests/mm/split_huge_page_test.c       | 67 +++++++++++++------
> tools/testing/selftests/mm/vm_util.c          |  2 +-
> tools/testing/selftests/mm/vm_util.h          |  1 +
> 3 files changed, 48 insertions(+), 22 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index 63ac82f0b9e0..3aaf783f339f 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -25,6 +25,7 @@
> uint64_t pagesize;
> unsigned int pageshift;
> uint64_t pmd_pagesize;
>+unsigned int pmd_order;
> 
> #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
> #define SMAP_PATH "/proc/self/smaps"
>@@ -36,23 +37,48 @@ uint64_t pmd_pagesize;
> 
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
> 
>-int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>+int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd)
> {
>-	uint64_t paddr;
>-	uint64_t page_flags;
>+	unsigned long pfn_head;
>+	uint64_t pfn_flags;
>+	unsigned long pfn;
>+	unsigned long i;
> 
>-	if (pagemap_file) {
>-		pread(pagemap_file, &paddr, sizeof(paddr),
>-			((long)vaddr >> pageshift) * sizeof(paddr));
>+	if (!pagemap_fd || !kpageflags_fd)
>+		return 0;

The same in patch 2.

> 
>-		if (kpageflags_file) {
>-			pread(kpageflags_file, &page_flags, sizeof(page_flags),
>-				PAGEMAP_PFN(paddr) * sizeof(page_flags));
>+	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
> 
>-			return !!(page_flags & KPF_THP);
>-		}
>+	if (pfn == -1UL)
>+		return 0;
>+
>+	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
>+		return 0;
>+
>+	if (!order) {
>+		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
>+			return 0;
>+		return 1;
> 	}
>-	return 0;
>+
>+	if (!(pfn_flags & KPF_THP))
>+		return 0;
>+
>+	pfn_head = pfn & ~((1 << order) - 1);
>+
>+	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
>+		return 0;
>+
>+	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
>+		return 0;
>+
>+	for (i = 1; i < (1UL << order) - 1; i++) {

Do we miss the last tail?

>+		if (get_pfn_flags(pfn_head + i, kpageflags_fd, &pfn_flags))
>+			return 0;
>+		if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL)))
>+			return 0;
>+	}

If this folio is larger than order, would it still return 1?

>+	return 1;
> }
> 
> static void write_file(const char *path, const char *buf, size_t buflen)
>@@ -233,7 +259,7 @@ void split_pte_mapped_thp(void)
> 	thp_size = 0;
> 	for (i = 0; i < pagesize * 4; i++)
> 		if (i % pagesize == 0 &&
>-		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
>+		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
> 			thp_size++;
> 
> 	if (thp_size != 4)
>@@ -250,7 +276,7 @@ void split_pte_mapped_thp(void)
> 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> 
> 		if (i % pagesize == 0 &&
>-		    is_backed_by_thp(&pte_mapped[i], pagemap_fd, kpageflags_fd))
>+		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
> 			thp_size++;
> 	}
> 
>@@ -522,7 +548,6 @@ int main(int argc, char **argv)
> 	const char *fs_loc;
> 	bool created_tmp;
> 	int offset;
>-	unsigned int max_order;
> 	unsigned int nr_pages;
> 	unsigned int tests;
> 
>@@ -543,28 +568,28 @@ int main(int argc, char **argv)
> 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
> 
> 	nr_pages = pmd_pagesize / pagesize;
>-	max_order = GET_ORDER(nr_pages);
>-	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
>+	pmd_order = GET_ORDER(nr_pages);
>+	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
> 	ksft_set_plan(tests);
> 
> 	fd_size = 2 * pmd_pagesize;
> 
> 	split_pmd_zero_pages();
> 
>-	for (i = 0; i < max_order; i++)
>+	for (i = 0; i < pmd_order; i++)
> 		if (i != 1)
> 			split_pmd_thp_to_order(i);
> 
> 	split_pte_mapped_thp();
>-	for (i = 0; i < max_order; i++)
>+	for (i = 0; i < pmd_order; i++)
> 		split_file_backed_thp(i);
> 
> 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
> 			&fs_loc);
>-	for (i = max_order - 1; i >= 0; i--)
>+	for (i = pmd_order - 1; i >= 0; i--)
> 		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
> 
>-	for (i = 0; i < max_order; i++)
>+	for (i = 0; i < pmd_order; i++)
> 		for (offset = 0;
> 		     offset < nr_pages;
> 		     offset += MAX(nr_pages / 4, 1 << i))
>diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>index 4d952d1bc96d..193ba1a1a3cc 100644
>--- a/tools/testing/selftests/mm/vm_util.c
>+++ b/tools/testing/selftests/mm/vm_util.c
>@@ -338,7 +338,7 @@ int detect_hugetlb_page_sizes(size_t sizes[], int max)
> 	return count;
> }
> 
>-static int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
>+int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
> {
> 	size_t count;
> 
>diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>index 02e3f1e7065b..148b792cff0f 100644
>--- a/tools/testing/selftests/mm/vm_util.h
>+++ b/tools/testing/selftests/mm/vm_util.h
>@@ -92,6 +92,7 @@ unsigned long default_huge_page_size(void);
> int detect_hugetlb_page_sizes(size_t sizes[], int max);
> int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
> 			int kpageflags_file, int orders[], int nr_orders);
>+int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
> 
> int uffd_register(int uffd, void *addr, uint64_t len,
> 		  bool miss, bool wp, bool minor);
>-- 
>2.47.2

-- 
Wei Yang
Help you, Help me

