Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF2C7C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 20:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAAC6B009D; Sat,  9 Aug 2025 16:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2B26B009E; Sat,  9 Aug 2025 16:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B87C6B009F; Sat,  9 Aug 2025 16:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9556B009D
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 16:18:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EAB6F1A0296
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 20:18:40 +0000 (UTC)
X-FDA: 83758332000.18.FE83DD1
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE71FA0007
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 20:18:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QYAT1Eg7;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754770719;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpOW6oYqvSq8dY4Sy6tlydo2R85SL2NbZNGCMBO2JGo=;
	b=4yHeN4mRhNQnIaFPYo/VsiqbEUGARivebqfHGtmCP00gxoAsCLdjLwo6Ua+/06MUvL4sqP
	/qEgBzjj6w3ch8qoNrNo2a7Mdy6CMlbInkOojW4Pvko8mIGrjlclsIiaAlcHTfd/jmyy/C
	uBuxtZlJwGyq5dhfVVWNjGy6CqEpwpM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QYAT1Eg7;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754770719; a=rsa-sha256;
	cv=none;
	b=b7wU1jadAuwRPpEO7xkfcSJLE3oDj7AeuLJwa5hSSWWiD2lfi37bcS7R8YTKfa/+ucMOax
	PU2M+LgtSukCBBJ3CT1NCNykUbV5JhmMj4RFlNYRGJzHFEp7wJI5xb7GcYMCI7Zg2xwQ/9
	hHnlraoiWmxpOYmSI5XAR+/Rm+Ui/fo=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61530559887so5130213a12.1
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 13:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754770717; x=1755375517; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpOW6oYqvSq8dY4Sy6tlydo2R85SL2NbZNGCMBO2JGo=;
        b=QYAT1Eg7JOJas+rjVBhBTfGJh154qsMFLQmfYo5WqEe6Ce2FiF4p2TzKzva48gIznX
         mRvh/gehbBeLav6jXWFkMiHOT49q+Cn7+GoVJn53w3G5j49zXiquCXvcxIUOJbgPTk+3
         Lmggx8SIIygo8dk7fSM3N//6Sv1rvwhD6vcK534rsE6XUn1h1wwOxyiVx67fY8hRf+4J
         YpFP0YbcpydEg+0/Olrtj5XFYzARvxBQfzSGrORwMloROWV8FWHI3r6uJsyZiy7d0Alk
         BKGXorE/KH+my1RxCqpSFw7VzlPqheHsrW7Ofy1kGxsGza5ZNaLgqwHCTURdgnaNQNap
         +72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754770717; x=1755375517;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fpOW6oYqvSq8dY4Sy6tlydo2R85SL2NbZNGCMBO2JGo=;
        b=OAQYkwk/3L69xRMnD2wqw/2CAB0693W80G692viqzbS1qSfzpYPUxfRUshQvImwqX2
         oohUfY/608DaxY7q7vEHx5ew7MEPlXINtfV90uq+iDD4+wvGxrIaOziydEjkSpjyRcHr
         y5mQ73j+UvPB5vLYi5jIo9anfrvWbKL5zp/9AXjVvxi3sE1Ty7+edMIfjC/IncwumE4a
         PwWw75PAlFeqSijLotV+vG13l1NEagrS0o8j/dR2xbHEgph9tLI4QNielgfSyuObqdXc
         dEpv4tJIdT81z+v/NcoRXa9w5I5usw/spG+UabwBJzUn5qWvUbA5sJCTeKLaNUDKfG4Z
         oPtg==
X-Forwarded-Encrypted: i=1; AJvYcCXKSTGY8EWwC/HO+cOqknqVxKJka+E2IzCnk0AH/SCQybsw4waifbajQCAbmeqWeJHf8FuVTCRrzA==@kvack.org
X-Gm-Message-State: AOJu0YyTHr0ceAiJXlNuPf5GOuOIgeRYROoJoiCfwSW4Iq6wkSOGvbJp
	xl2HhUtKd8KddWzqcwqt/8H+4qAkgtFxbmWAv8bkxDVae0vDTuLJhCXY
X-Gm-Gg: ASbGnctmKG9gCLvHXz6piJmwso3qar3APYGzD22poA3v9Gi/pd4n2qLx5Ir3sJJ2LNB
	JAvXMGK85s8O4U9kW1Jwaw8mq0euqfcyJdx5k5tBGpsEwrqSFqOPyX9Uiynd+4zQIdWzc1/oKsM
	GcCt5HxntcQh0XL2LbTBVJB5CZ5JvjWw5hdOLeoSQoq5OfrYJD/8S8jMY8jVXkLamlqM3sZQsds
	VQNRBUkMN+8os0dEf6fwcEvaNfMxk9kqXUN/qIKAej1FO5O58u3oSlUzO87PICFbQ6FxQ5nq2KK
	4SP8oOGq8ssIpy7/ZyGld+MYO5FNRRQXzUDg1IgCS2mqOxt+kSoIlcO4pBlN+w0Ezxgda2tuC3l
	EIR/y1kCLmzDif5jDt4ZofA==
X-Google-Smtp-Source: AGHT+IGoIF4TzpsGbw98vDMoE6TA6To8S/rOi5El7EFY9c81/pe07BFvjZIzYcHEsO4A8H/7IkNSjw==
X-Received: by 2002:a50:c310:0:b0:615:c5a9:4cab with SMTP id 4fb4d7f45d1cf-617e2bc49a1mr4617374a12.13.1754770717056;
        Sat, 09 Aug 2025 13:18:37 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6180ce5b9e3sm1250045a12.9.2025.08.09.13.18.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Aug 2025 13:18:36 -0700 (PDT)
Date: Sat, 9 Aug 2025 20:18:36 +0000
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
Subject: Re: [PATCH v2 2/3] selftests/mm: add check_folio_orders() helper.
Message-ID: <20250809201836.jegaanplfcjak44f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250808190144.797076-1-ziy@nvidia.com>
 <20250808190144.797076-3-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808190144.797076-3-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: nphj5gq1jprafhzc4uhq6sdndmkx6fcg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EE71FA0007
X-Rspam-User: 
X-HE-Tag: 1754770718-525372
X-HE-Meta: U2FsdGVkX18x29yT/nVnAgj7cBSD/S6PUMuYZm8es8ceBx3jBWQCVt1RUB8el4TA55xw6zfUEN09oDKVhMtr2XtirVgO2/Qnfzy/0Jik+eCe7lp8Ubp4jcADXe15ok/obOUwhA66o+kDIw4VwF/5rI3WtEIkaID2IgbHLSGgZeARRGC6otNf9oF09XtoQDfTYZ8v7kBJ3ZLCMo+O7ZokU0iBj5N5+qnqipRR5HK+azNOVmS5iT0agsYL6SSaRw/AnzxbhbePC+gvgDhrDKFkd1/ztyLMoBhWv6/y+TCjWiy4yK+Pn8aZNNfSpqn1m60PX3l3pHeil4A7+t1ZvYojiNsKE1+wo44yGPHLSgZYrnPGRhVB6WOm/g2T8IaW6YmMiHao9AvM7+a4Ju9KltuKml/vkgsw6+SgA2eZfEMYqYaepP3G/SUrB3JMwQYtiyriRbvJkvGhrctpReBsXBXTEEp7P4B/SSbhsqpVuqqgXUoqXSsd7SYiFzK/spuFmIo8z67lyBtmImIUcAOlMh82+kPkdwWP6WjkM2fJjky52VtCcbj249kMpc1YEXR6sx0Sjr/1DcAb54ElY9jg/oJP4KqbLJUlzAhePOnO3CZCYtyUFI3iYK3Fdc7nDyulPMG+ei5iJZFmS9I9r5jreyAEHEi5omxDsfAuozgcAOCSnRlhy06dphRwvT0ArsqxjxrHCnODYzdXiG43UUxsEwLnWf2bHwjgM4Sq/UlLFLYQlVpZGyC5++KgWvmFcQJxmd8CczBMwuFEuD4MfqIAVqlsDdxeZlaKAXMv62XSQFm35x3HOCmG/Q0A85p0j9Prnsx7Vq/tqeH8X5V9b+EXRudbpqmTBWJHRnoZOykudOmy8OGcve4G9wUz7vVNGZoL5QeNSbqPDYRiQynjpwBtlyeBan4o7zzLYYwIQgtAEuxU3AXVRs9cAzvXUAAeX/8nwDjQD+jDTJVwRu27O/SIzph
 AqlOYcOl
 6LFkU2G+ohYHv5v4WXO82dWHKJKchGozzgi3EJ/V3NWgEVWc8OJ4k04L8Ab3XRHjtgWI9oaJ5RtlSrzAKLuvH50+LzSCHGKylz500GydaYNlJfdI+fQTxmNLXW/wpNrlzWqhZOWusrl/D4Xo1yX0W2Nmeg78AwUw10yzCmClJgxPShdqJc/eMk76Jbzu3Emqo2oy0kPJhTNvS0x2baPCN51YrPPSczD2ZpmKfs3IT8HKRo9eAcFsV1WOU/cy/jm6xn1uclv6BIGZC5bXH+9iG696knptko8IkWPvLm7a03oCdJ9d4kFqWan/gzv/sQPGtU32fojVO51LoNartVCuchapcXbHWnMed2mOaqibYE0BC6agNTKRen7R9BUbummsMRt29GRXDNng76/+Nhyegf0IEAXu71M74iGGf6OP4LMHuqi4p5nZTZn0IP+9Iu/f/sNPKsQFVTJFBWXZqEjf5H9cymg7gSTImjJXZ8H/i3UoirnugkhoA66H74MZxP5lXj6Wx778dex9epx29E8toyDPdDaL7Zz3+8kaYsh5eQQYRGsz7R5ZlxBa4ehwFgvNBNY7WGx3cyTSjJluvUmYKBN/xT3DC6FnQurzmy2v+JsZh3RMBwTtaXVw/KhI1s3JW0DmtV74rWxcvLUw4r+IrVxKl+UCdhsTR63MW2/qseo8Pb0uUkDS/RCm+M4eWVsEuuO/mvYDH2oCW6djDe4QPnssPxJkmxy8rUZbThl4nKZasVQFQuyjoyqV0vOsefORNSiZc2s4xdKZNRwvjrk6cSWIKhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 03:01:43PM -0400, Zi Yan wrote:
>The helper gathers an folio order statistics of folios within a virtual
>address range and checks it against a given order list. It aims to provide
>a more precise folio order check instead of just checking the existence of
>PMD folios.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> .../selftests/mm/split_huge_page_test.c       |   4 +-
> tools/testing/selftests/mm/vm_util.c          | 133 ++++++++++++++++++
> tools/testing/selftests/mm/vm_util.h          |   7 +
> 3 files changed, 141 insertions(+), 3 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index cb364c5670c6..5ab488fab1cd 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -34,8 +34,6 @@ uint64_t pmd_pagesize;
> #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
> #define PATH_FMT "%s,0x%lx,0x%lx,%d"
> 
>-#define PFN_MASK     ((1UL<<55)-1)
>-#define KPF_THP      (1UL<<22)
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
> 
> int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
>@@ -49,7 +47,7 @@ int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
> 
> 		if (kpageflags_file) {
> 			pread(kpageflags_file, &page_flags, sizeof(page_flags),
>-				(paddr & PFN_MASK) * sizeof(page_flags));
>+				PAGEMAP_PFN(paddr) * sizeof(page_flags));
> 

is_backed_by_thp() shares similar logic as get_page_flags(), I am thinking we can
leverage get_page_flags() here.

> 			return !!(page_flags & KPF_THP);
> 		}
>diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>index 6a239aa413e2..41d50b74b2f6 100644
>--- a/tools/testing/selftests/mm/vm_util.c
>+++ b/tools/testing/selftests/mm/vm_util.c
>@@ -338,6 +338,139 @@ int detect_hugetlb_page_sizes(size_t sizes[], int max)
> 	return count;
> }
> 
>+static int get_page_flags(char *vaddr, int pagemap_file, int kpageflags_file,
>+			  uint64_t *flags)
>+{

Nit.

In vm_util.c, we usually name the file descriptor as xxx_fd.

>+	unsigned long pfn;
>+	size_t count;
>+
>+	pfn = pagemap_get_pfn(pagemap_file, vaddr);
>+	/*
>+	 * Treat non-present page as a page without any flag, so that
>+	 * gather_folio_orders() just record the current folio order.
>+	 */
>+	if (pfn == -1UL) {
>+		*flags = 0;
>+		return 0;
>+	}
>+
>+	count = pread(kpageflags_file, flags, sizeof(*flags),
>+		      pfn * sizeof(*flags));
>+
>+	if (count != sizeof(*flags))
>+		return -1;
>+
>+	return 0;
>+}
>+

Maybe a simple document here would be helpful.

>+static int gather_folio_orders(char *vaddr_start, size_t len,
>+			       int pagemap_file, int kpageflags_file,
>+			       int orders[], int nr_orders)
>+{
>+	uint64_t page_flags = 0;
>+	int cur_order = -1;
>+	char *vaddr;
>+
>+	if (!pagemap_file || !kpageflags_file)
>+		return -1;
>+	if (nr_orders <= 0)
>+		return -1;
>+
>+	for (vaddr = vaddr_start; vaddr < vaddr_start + len; ) {
>+		char *next_folio_vaddr;
>+		int status;
>+
>+		if (get_page_flags(vaddr, pagemap_file, kpageflags_file, &page_flags))
>+			return -1;
>+
>+		/* all order-0 pages with possible false postive (non folio) */
>+		if (!(page_flags & (KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))) {
>+			orders[0]++;
>+			vaddr += psize();
>+			continue;
>+		}
>+
>+		/* skip non thp compound pages */
>+		if (!(page_flags & KPF_THP)) {
>+			vaddr += psize();
>+			continue;
>+		}
>+
>+		/* vpn points to part of a THP at this point */
>+		if (page_flags & KPF_COMPOUND_HEAD)
>+			cur_order = 1;
>+		else {
>+			/* not a head nor a tail in a THP? */
>+			if (!(page_flags & KPF_COMPOUND_TAIL))
>+				return -1;
>+			continue;
>+		}
>+
>+		next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
>+
>+		if (next_folio_vaddr >= vaddr_start + len)
>+			break;

Would we skip order 1 folio at the last position?

For example, vaddr_start is 0x2000, len is 0x2000 and the folio at vaddr_start
is an order 1 folio, whose size is exactly 0x2000.

Then we will get next_folio_vaddr == vaddr_start + len.

Could that happen?

>+
>+		while (!(status = get_page_flags(next_folio_vaddr, pagemap_file,
>+						 kpageflags_file,
>+						 &page_flags))) {
>+			/* next compound head page or order-0 page */
>+			if ((page_flags & KPF_COMPOUND_HEAD) ||
>+			    !(page_flags & (KPF_COMPOUND_HEAD |
>+			      KPF_COMPOUND_TAIL))) {

Maybe we can put them into one line.

>+				if (cur_order < nr_orders) {
>+					orders[cur_order]++;
>+					cur_order = -1;
>+					vaddr = next_folio_vaddr;
>+				}
>+				break;
>+			}
>+
>+			/* not a head nor a tail in a THP? */
>+			if (!(page_flags & KPF_COMPOUND_TAIL))
>+				return -1;
>+
>+			cur_order++;
>+			next_folio_vaddr = vaddr + (1UL << (cur_order + pshift()));
>+		}

The while loop share similar logic as the outer for loop. Is it possible
reduce some duplication?

>+
>+		if (status)
>+			return status;
>+	}
>+	if (cur_order > 0 && cur_order < nr_orders)
>+		orders[cur_order]++;
>+	return 0;
>+}
>+
>+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
>+			int kpageflags_file, int orders[], int nr_orders)
>+{
>+	int *vaddr_orders;
>+	int status;
>+	int i;
>+
>+	vaddr_orders = (int *)malloc(sizeof(int) * nr_orders);
>+

I took a look into thp_setting.h, where defines an array with NR_ORDERS
element which is 20. Maybe we can leverage it here, since we don't expect the
order to be larger.

>+	if (!vaddr_orders)
>+		ksft_exit_fail_msg("Cannot allocate memory for vaddr_orders");
>+
>+	memset(vaddr_orders, 0, sizeof(int) * nr_orders);
>+	status = gather_folio_orders(vaddr_start, len, pagemap_file,
>+				     kpageflags_file, vaddr_orders, nr_orders);
>+	if (status)
>+		return status;
>+
>+	status = 0;
>+	for (i = 0; i < nr_orders; i++)
>+		if (vaddr_orders[i] != orders[i]) {
>+			ksft_print_msg("order %d: expected: %d got %d\n", i,
>+				       orders[i], vaddr_orders[i]);
>+			status = -1;
>+		}
>+
>+	return status;
>+}
>+
> /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
> int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
> 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
>diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>index 1843ad48d32b..02e3f1e7065b 100644
>--- a/tools/testing/selftests/mm/vm_util.h
>+++ b/tools/testing/selftests/mm/vm_util.h
>@@ -18,6 +18,11 @@
> #define PM_SWAP                       BIT_ULL(62)
> #define PM_PRESENT                    BIT_ULL(63)
> 
>+#define KPF_COMPOUND_HEAD             BIT_ULL(15)
>+#define KPF_COMPOUND_TAIL             BIT_ULL(16)
>+#define KPF_THP                       BIT_ULL(22)
>+
>+
> /*
>  * Ignore the checkpatch warning, we must read from x but don't want to do
>  * anything with it in order to trigger a read page fault. We therefore must use
>@@ -85,6 +90,8 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
> int64_t allocate_transhuge(void *ptr, int pagemap_fd);
> unsigned long default_huge_page_size(void);
> int detect_hugetlb_page_sizes(size_t sizes[], int max);
>+int check_folio_orders(char *vaddr_start, size_t len, int pagemap_file,
>+			int kpageflags_file, int orders[], int nr_orders);
> 
> int uffd_register(int uffd, void *addr, uint64_t len,
> 		  bool miss, bool wp, bool minor);
>-- 
>2.47.2

-- 
Wei Yang
Help you, Help me

