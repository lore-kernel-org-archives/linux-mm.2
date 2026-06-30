Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41ADC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE916B00C7; Tue, 30 Jun 2026 09:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78CB6B00C9; Tue, 30 Jun 2026 09:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3A86B00CA; Tue, 30 Jun 2026 09:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAB16B00C7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CB0FA04EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:30 +0000 (UTC)
X-FDA: 84936723900.10.384D839
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF693140009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:54:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4KjF7DM;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782827668;
	b=jxltla8lKX7p8gc4T1Lqg/QtwrwMJuDPcOctcV0gIi6BTslrboOQlkiXlhmJNX1SdAMURy
	3uwdH+yX0Ban0VqPPFiHZxIrZR5onRuAdXS3nXyS2FhfyCFFqSK7x+4SXPKouwnsyrQcUH
	ucFQwSMdWbDcSJiWjxvoSIAwnr7MRZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782827668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8eNIJQnRMK2SdmmUofdTI44ZDndAOS8N0eRrZb61g0Q=;
	b=hQuAAI23N1dCVFITa3Qva7W4Z0rGwfcEnsDei3a9cf2iTwNtYmnFiC8R+45v0dUYKbO4WQ
	+kirTdaLi+wBj+KWiELO9RYhZWGGk5cmHD/n71A2juuX8LOslqdkhgyPVZKuDI6ldfyNX/
	7lb9ZXZL3MKNcYLQoM/oFlh2RFkuUOI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4KjF7DM;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so2540564e87.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782827667; x=1783432467; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8eNIJQnRMK2SdmmUofdTI44ZDndAOS8N0eRrZb61g0Q=;
        b=S4KjF7DMdCydtv9IX49TyoSIxCt8p8MxSTAIAmmkgRhSR4Bff2yWhMAuc9sZqJq5V8
         r+Xi9aND1v1fzfE0oD4dRTqWmFoKVTKKgzwiVBMSJA6dXtBdEu9URU5YhzMGnOB3DLmc
         tUjVqnq/aa+JTsnxbKGmttlcseTsXH7GhAevDkJuGZ68UPLns4nTy2oIjfJjKEDAOciw
         JUy0L+lu6+n8hPxOuIv9BkvtkfHCMAAI1hClXIxlEntEtUvNNQ8ry+dedEZw7uQ/MKcG
         AqIpDm1rq+TnHUhSuJNSvcUmFEugDOqf8cPk13emF15l/zAhfI7Jg2hk05M7h7LbiYal
         3NrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782827667; x=1783432467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eNIJQnRMK2SdmmUofdTI44ZDndAOS8N0eRrZb61g0Q=;
        b=E874kg2VPZcCJ1+8pgbVIyJME26Zax8/vUsX+F86wKoJax600VuQFjb/OE+Mct3OwB
         1jJPeXuQh9zI9YSAF2/Ce/PuaoWskiTMA0u8Uh9RM9XIxyEvONk9Gdnq7yNz4QUcQAm0
         VPEr7qwulWa2LVSpdE763tDFAzzugim46zb62IpQXIKOKeShNIy8qPiawaEMKMN5bZmk
         g/e4rJS35/i2Mk5GovqE0QwASf/jYe8Pn/nQwqsIL9jhOmuvFBbc0+U2AlsvITLK6oXU
         +0Ezvu++uxJ8j1zqLXGUKYnhnGdYeJNn0/p6vNVo2lCPOIEQFFTpo97wh9WZb7usCL44
         BqRQ==
X-Gm-Message-State: AOJu0YyQgd7ufhoKIuFueyRzAM6rD8IK0lpBSl4NGmz4TXrfqGAtjBxw
	pgXCk6xgSP/vKCqlKW0qVcDl21r53EexU6G8wvDhs+raKTuyVh1utukb
X-Gm-Gg: AfdE7cn9y6zE5M1VTnqzUCI+kRTPDlF/7Jx9aZzvU6shWpD9mlZAC+0QphYGblLzWZv
	Kv5Nd33S+a+lfWbZYegrXtBpVJVawCDtNzxue24R/Bjp2BNQbFFCMtrNdBblRoY5a6FpJ3e1rtk
	h5GgqJ9VMCPjeZgkxvLMVizaKjevbMGaAhrErYPqdjvjb/mxC5OhA1tioeVeG4LzwzOF/vJ/SGQ
	5bp+8uYjAFc4kpiniT9/3FDXwphMRG0ccWlQd0S/Fcs+8hBaAq0lx8+9wHYUCDhMRs7yNfU17Ms
	NyJIdPX1hNn2jV9GAqrDuifwHWGZ65O4cW7fwOzQK8f1aFuV6m1CY7ttenm5MNIo5rLLNn/FA9s
	swiR2ZNfB9GiTsEOs8llGwgtBK42LjqMIbezksETv/pmCbNrNhmZSuw==
X-Received: by 2002:a05:6512:3410:b0:5ae:bf5c:bdc5 with SMTP id 2adb3069b0e04-5aebf5cbec4mr644835e87.52.1782827666670;
        Tue, 30 Jun 2026 06:54:26 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aebe344f03sm593321e87.30.2026.06.30.06.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 06:54:26 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 30 Jun 2026 15:54:24 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: Re: [PATCH v4 5/6] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
Message-ID: <akPKkOt_GNbAbyN5@milan>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-6-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260618084726.1070022-6-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF693140009
X-Stat-Signature: 4odiy6j9ms5ktz54tpq5uzudb95f6cfn
X-HE-Tag: 1782827668-573617
X-HE-Meta: U2FsdGVkX1/plLiOIyTPeBOcWGo4OFHanmwn/xILZk3XSqp15CuqWxfAht+Ky/ZXYTemiCPoS389lINa9Wz0wAKg7uY16W8qf0WYNh0qNZUATyHAH0mpLIEAjfy6Vd6MnzmiW/DwAh6/81utRVrJa7OYGUtB7dZoHdmPZRQlHJxzalQ0R2OteHL52KSxc/6PX+osMv/uq4Kk6uAI91tXjDY9oDPHsb2Rp3R0+jeJNpSajNlPliu30HXf7Qp9SWMtPYu4gMH4Ap0vxGR458DmBxsnvLi0gN0b2yx9sHCVWvsqlNR4XqrL7ws2COcNbOzbelTV7xcyhqzyHDDkBv5L2yQ+7KcuTnr9D6pcO5I0nwi1V7PghskxX45hTRnl91GDBYVVJnn19NSmgLbMJ9xfLsitmmZffqEDUbWbDZOePvNK5yEMa8VCLUjTKOevA4j+zLak/KB/No7E/TmlQ7rT5ZKnYGGpgGbL/HXE0tFS/kL+7Li8FMJPpvjYN6qD8HMXsfR0puuoOAh0CsX6bA5cjMawBEeY91zl9H17KWR7nJLZiyVZijgzN2NoEhoK200GlKMYlApkhNjoqBKjK4CvfpHVwoHFlZAWuQpW+7kdSb7eh/HSduJW3HgG6l/zZHQv7wHn47SplEQjCDCF1zbao+7TTAxtX0EWyE3GkEobSw6zqoP10BlWTig1s7A6Wjstvnkz35SvRYWz/RS1aP5zFFTkHwMO4ljDovZdnkntUQAPKoZF+RiQDcLzvzGpXmnx3flQ2PXJMWML4XLYydGGNLf3LGgxRF/Veklz6ZFO6bgqJCVJBsp/5hVhlgzoRipJDKwculllMyyjGiKwWoqjJWTEvIo7Pf2iLVgXlEF0sgQEgvrhpx9EAZCWlYVKTZmCM1KJkVqmBdfR1oAqItHKxA1bKYxDc9XQplaniLtnEfUBkY+vy2uPFV/eE3UanjByA4LIYID5LFLEkuI0moW
 VsMWi/MU
 sgVQGn7w0YPaHGlljigBWy0k97vFSxPTdjMrLWBUBgjcaTwm6/P2wH1N6jdOfDGOVl/swN3FI+KFFW+LGlGjNeCpM4Rh+2E/pkvhYnSoHz2UNm4TOmh3YB40D19rQZZEznj7GbbCsor1hBynfAD6xo4Dh6GD+Z6Xpu2s+Bfoex+//jZyEKP1dt/qCtkM86DZhphrhjK8s//3plxO+/8q49b13MZQTNdAv8hypoVpnhNZ4W2Rf11AT8ex5HYPkdCbSZZ54+GvVPyKqV5bKLRtqARmw0uDay36Hq3Hg8/CRQwN9j8L1m+ltDqwGFBLYCOdqln2bA1TR11w8hUQReVSXeExlZ1j4D3m/J3+g2CvJJp1EXsfkPBs9u8J2AOGg6xhR3qcXtH5i0QiX7/owD99/8frOEQkSOLwfDq9SL3EDT21Nck0j23Lbzfla2ral9zMSCaDAf+ujVGWrTXe4b0nz6OsFctvj9qJcOWQbvodB9YE9E9ArUxX1if71XOhKBFlqZcAnf81EoQHMDW382lbOMCdoMKW9+MppNa42qWXFbgiMV9wcBP97HETFfOsqPA3aeOricuQR309yZj/J7uwhGRLBqMH4G+TJ373V74gupWiNMP7xEu3FBWDLqJpvUMuyIWntJyL0imfIWEIgpytEenei4Fe7g9R1mdJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:47:25PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages. For example, the systemheap often allocates pages in descending
> order: order 8, then 4, then 0. Currently, vmap() iterates over every
> page individually—even pages inside a high-order block are handled
> one by one.
> 
> This patch detects physically contiguous pages (regardless of whether
> they are compound or non-compound) by scanning with
> num_pages_contiguous(), and maps them as a single contiguous block
> whenever possible. The mapping order is determined by taking the
> minimum of the contiguous page count and the pfn alignment, allowing
> graceful degradation when pfn alignment is less than the contiguous
> range.
> 
> Pages with the same page_shift are coalesced and mapped via
> vmap_pages_range_noflush_walk() to avoid page table rewalk.
> 
> As users typically allocate memory in descending orders (e.g.
> 8 → 4 → 0), once an order-0 page is encountered, we stop scanning
> for contiguous pages since subsequent pages are likely order-0 as well.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 253e017130e09..fffb885cb2158 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3545,6 +3545,89 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
>  
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}
> +
> +static inline int get_vmap_batch_order(struct page **pages,
> +		pgprot_t prot, unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> +		return 0;
> +
> +	nr_contig = num_pages_contiguous(&pages[idx], max_steps);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order = ilog2(nr_contig);
> +
> +	/* Limit order by pfn alignment */
> +	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));
> +
> +	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
> +		return 0;
> +
> +	return order;
> +}
> +
> +static int vmap_batched(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)
> +{
> +	unsigned int count = (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift = 0, idx = 0;
> +	unsigned long start = addr, map_addr = addr;
> +	int err;
> +
> +	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +						PAGE_SHIFT, GFP_KERNEL);
> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i = 0; i < count; ) {
> +		unsigned int shift = PAGE_SHIFT +
> +			get_vmap_batch_order(pages, prot, count - i, i);
> +
> +		if (!i)
> +			prev_shift = shift;
> +
> +		if (shift != prev_shift) {
> +			err = vmap_pages_range_noflush_walk(map_addr, addr,
> +					prot, pages + idx, prev_shift);
> +			if (err)
> +				goto out;
> +			prev_shift = shift;
> +			map_addr = addr;
> +			idx = i;
> +		}
> +
> +		/*
> +		 * Once small pages are encountered, the remaining pages
> +		 * are likely small as well.
> +		 */
> +		if (shift == PAGE_SHIFT)
> +			break;
> +
> +		addr += 1UL << shift;
> +		i += 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (map_addr < end)
> +		err = vmap_pages_range_noflush_walk(map_addr, end,
> +				prot, pages + idx, prev_shift);
> +
> +out:
> +	flush_cache_vmap(start, end);
> +	return err;
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3588,8 +3671,8 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	addr = (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_batched(addr, addr + size, pgprot_nx(prot),
> +				pages) < 0) {
>
Better naming? vmap_pages_range_batched()?

--
Uladzislau Rezki

