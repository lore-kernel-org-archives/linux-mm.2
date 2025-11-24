Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCB2CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB30F6B000C; Mon, 24 Nov 2025 07:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AB16B000D; Mon, 24 Nov 2025 07:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A16C6B0010; Mon, 24 Nov 2025 07:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 858BA6B000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:37:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CD88C0371
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:37:39 +0000 (UTC)
X-FDA: 84145451838.17.BF4199D
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4426040014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:37:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt3Mtu4R;
	spf=pass (imf04.hostedemail.com: domain of smostafa@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763987857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbelAFcOsYSEHJr61jVue9qL8RZ/6OY7KUqEPYnfD10=;
	b=27BtOZjcCd59/ogGaSORPwlK1YApgV5tjM34AetQgWTSBjLmIcyPiFib8ZdgGI9ioilaTs
	K2MB7vWFQ5xYQsEDqj8hh6JA2727K18DcY+iHXr/l+ovfRT3cibRohxSxHRIBB6sy17xc/
	gZbwc2bWWYhl9+OJ0+s9bCsaoMRa0zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763987857; a=rsa-sha256;
	cv=none;
	b=D3XwPqxfjzNGkv9L88IakbW7AylHjbdprNQ7rwKuAWucefwUOYouBSs4eObiCNQFCYX1/c
	rsEC8h+CmZMEgLQeLsowskS1c4cpdSV9oT00v/Xa2xw8iUcltRx4MuW7SrUEiD6PlDWmSa
	vdec7Z4QTbO9Dp+8uQzPwbzpIjR5G14=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt3Mtu4R;
	spf=pass (imf04.hostedemail.com: domain of smostafa@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso95635e9.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763987856; x=1764592656; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FbelAFcOsYSEHJr61jVue9qL8RZ/6OY7KUqEPYnfD10=;
        b=dt3Mtu4RVvFJEEWnxF2s5ynQSPad0TKy0YhYHIKnexig20sq2B0Du/zgVo4BMYOCHg
         kQUAsvo5H6DPsd8WHWEzNX93pSPh6cOqQoo8WuOI2GuOaMBAokVPae9C5WebB54FFlUA
         jZp1qB5fdgB5yZKFWKgOtkd/KGlfWU0L8veKkLo2MCq7QnYlHPnVAsaQdOjJEF7YMrfy
         4sMr1ncr8tnRBgmA6/5s1snhNhld6oUXanmpOUytPdocC8HW81CAQRa6n+Mp0HpOSCE/
         0A1Gr6+8ft6D2z6l7MM/wp4dTjcJss9DSfQAT31IYkvFdOVvOxAECfuHvm074HpcsjMc
         WzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763987856; x=1764592656;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FbelAFcOsYSEHJr61jVue9qL8RZ/6OY7KUqEPYnfD10=;
        b=U+flnoD37T+oEqOnErjnFepLjwLb5gRlBKvlUDzw0W+i/+8/nmuyIqms8fyW1OgAZ0
         HSKtHDsmJW5AUSkMQUc87fQHLCKl2s+sPi1eaN+xwrqjZBpPSflAxi+y8DRMbPVgbkzt
         1CCzy2WTp9RM+CHGU0zEfgDUvKYA65WYn93jZjKh2edpXPlFULj56KrR2HlsKc06duh8
         6UoswUW7qOqh5nrP68DlAuO8UiBnFXeHY7OdZaaIuodvTHVWgUf2tL90TCQCnMjSb7k0
         OyJIoVXkFRJo3sfvSQwz2lifubkVvxBplStmQ2cVqU118n1uq4P+OYsfWF+3+lSGqmgs
         Q80w==
X-Gm-Message-State: AOJu0Yx1ena36nX6IVP6dqqGjt5/roB5a6cuqLsmZHA/8rP5EoH/gNRh
	pHzstGtavoF7pz4ntu60hCeV7X30OE19JK8pFdctrN78/YcajwSI4UbrK3A4ELjNUQ==
X-Gm-Gg: ASbGncuVkEdYXnH7GYCDiJVOEjdW+so7zwXkB+jOVxH4zhk74QITkJZGZYXNhs9e3BB
	WJX5iHqwxBykXyd3U1nhWuNRvgoxfyvAj0ylz0m/JVr07GxiitR81gruT72RsFR0Tg6rNIA2nAI
	tg32GleGTnfESKN2DaseIgQ73hVp8QHCn3G3c5XBCp8GviJ802uAORtR5SYclKTNGyfIjxNLU68
	xZQb0bH6gWZ0SsnqhzD33afWkJd6x+byHUOOR+OKJ8rNshzuyLrdx9XC5G6WnsUii/jOZDso111
	cEultyN/w3Wo/KtoekNVrAdUc1u2VG4UETNjrbLdTHqMxUEMYeohGxECMD8ffiW93/vipmS+2Al
	T3dzRp5KcD5FFa+yzaKNeLVAc6801scZLwab2aONmryxc8CXbt2j/wsmN4IrRpSDcDlubOlDPDP
	Wr31f7ku9WzyZUE13SgLGbuUQuWx6PWFLiLCQkoeuZOhTdj+mP4mVVmv9HehxH
X-Google-Smtp-Source: AGHT+IEZ1AffknXuVGP8AlyImRjsSfE4J4xB0sAqNDM7r0AApBCqrRJbKEvqzMG4cEc/7c+Lw03Hxw==
X-Received: by 2002:a05:600c:c114:b0:477:86fd:fb18 with SMTP id 5b1f17b1804b1-477c5e09081mr1789195e9.8.1763987855511;
        Mon, 24 Nov 2025 04:37:35 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1e868bsm188617465e9.4.2025.11.24.04.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 04:37:35 -0800 (PST)
Date: Mon, 24 Nov 2025 12:37:31 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
Message-ID: <aSRRizzS39jI3BjH@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-4-smostafa@google.com>
 <aRW6Tf_G2ObR__vE@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRW6Tf_G2ObR__vE@willie-the-truck>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4426040014
X-Stat-Signature: hbxqfq3k6d8d3rfa69wp3scgjf4swk4q
X-HE-Tag: 1763987857-342741
X-HE-Meta: U2FsdGVkX1/cSYF/YQP5B/Rh0Ml8W3dYesKn12HVn1a76DHqHbsMqJIpaVoXjyHnkpisQHQPwpZD57t2CXpLN7Eny3aBDgO0oY/FZwG7+bPE+ZdXV6inHQvIev686urYGstEB1X0xJPCaLclgxwyQJllqaYpsAzY24SxubXANxvylnDM8kLslTvrR9cKnGMHf3ZMppN3xPkzPsxdVWQIy9GiqUEYYGvik419Obh7gANOf5t2gAqUQub5xZIOLCsgycjVqkZDtUAhGALPme55hogH4XgwWco6B/hyB/3QdNvIpafAcg8kQpsrM4Sc3RhXn5KsPLV3ZCc+Ipj+n0KJO3jDCJ7JwaplxRfTY5YNOd3vfgnH8lKUKTqYC8hYMoWH1bJOs3aLgStvlUi0BiK52AhThTMj13HQJ0JfwmzEN7Kr2OiFR875XXcW5FR4I1NLvQ/iJSppZ8+FD04a3fFns1P4vUHy5EZKIqPRp/8T3hcFo16Me95uij/o0f4KzYruwgWb6CfIIXR7vHA98VkEKgBXr7yeUcET+Mtt+pUlmmJVDWtZHqMDbRf0aCPmT8ifwRS8LTcLb8VQBalIGXSfny6rWO9b/W6y+hk7ae2DwpFhHXLL90CEkc7kRa7FMpcv39ZCJCkNzlEu0hf23ZTjSQ1ZY6eoIISNVzvtC46rIWUMIb/clJMF5xxwIn5kh3K1VBVvZRruRGQi5Q5wyPlAA+lgrxDIrkong9niDRe+wAl1erQuHaFh/VX4CwUWOMfuUAx10bHLZK1tG7wJmuNUAds5EDcnzBQNhWq6nPjJWpVDgl9+6uWX3KUiBf+CDw9SjXAIgglwRhTbIg0hPMIgx9IQS+bPm3PBDBwBAluNdXINSFEz2e+GZzDS08RGXOeNWPncjtI/mR3Mf0SIMnxzHxEvcWyIRT07BQMvecxC8zedWlOEv8/qtASdfPsFveSUrcip0XnK9UqFJoj7yiu
 FEk2PYCD
 eLxBeC2tH6C4cIEemGu9miMm2uVtBDQrb+vbw58qoxKqEcOtIqwEOc7fL2C8KFwPOJwi0uTZljDmkrjDugFklp7ss79yBZMDzqqVDj9HrX4pIwQimxFLujSox1H3cpSBrYuo0f8V4dSnDAQOUjHW1swrLdQZEPbgJO3Hzbv7XhZq8JJIkljbk33UVwSCDF3jSV/HKh/RYs8+x7/nebgqvZoV41DNUfh99FYlvv6llD1lcFsdRlgBHRTOCjhrd7xBT3t/eaOz8hZMY5WtlnuaAJWDUollL0AbAaG6pAxtAip94/UQmRH4HkNDFQ6fRS0nZo6eA6EfocPDPDKjKxluWakfV+KsPQggx7KayhmpT7BgpkUvoJB26bi4spI5VitHAO8WgvRfqC6yM/D/86VWkQCHMTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:00:29AM +0000, Will Deacon wrote:
> On Thu, Nov 06, 2025 at 04:39:52PM +0000, Mostafa Saleh wrote:
> > Using the new calls, use an atomic refcount to track how many times
> > a page is mapped in any of the IOMMUs.
> > 
> > For unmap we need to use iova_to_phys() to get the physical address
> > of the pages.
> > 
> > We use the smallest supported page size as the granularity of tracking
> > per domain.
> > This is important as it possible to map pages and unmap them with
> > larger sizes (as in map_sg()) cases.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Tested-by: Qinxin Xia <xiaqinxin@huawei.com>
> > ---
> >  drivers/iommu/iommu-debug-pagealloc.c | 74 +++++++++++++++++++++++++++
> >  1 file changed, 74 insertions(+)
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > index a6a2f844b09d..0e14104b971c 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -27,16 +27,90 @@ struct page_ext_operations page_iommu_debug_ops = {
> >  	.need = need_iommu_debug,
> >  };
> >  
> > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > +{
> > +	struct page *page = phys_to_page(phys);
> > +	struct page_ext *page_ext = page_ext_get(page);
> > +
> > +	return page_ext;
> > +}
> > +
> > +static struct iommu_debug_metadate *get_iommu_data(struct page_ext *page_ext)
> > +{
> > +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> > +}
> > +
> > +static void iommu_debug_inc_page(phys_addr_t phys)
> > +{
> > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> > +
> > +	WARN_ON(atomic_inc_return(&d->ref) <= 0);
> 
> Is it worth dumping some information about the page in addition to the
> WARN_ON()? That way, you might be able to benefit from other debug
> options (e.g. PAGE_OWNER) if they are enabled.

These WARN_ON are for overflows, which should never happen.
I initially thought about using the refcount_t, but it didn’t seem
suitable as refcount_add() expects that the refcount is already “1”
indicating that an object was already created which doesn’t fit
in the semantics of what this is. Similar for refcount_dec().

In the next patch there is a WARN_ON for the refcount check
to capture the mis-behaving context, I will add a debug print with
the leaked physical address in that case as this is the important one.

> 
> > +	page_ext_put(page_ext);
> > +}
> > +
> > +static void iommu_debug_dec_page(phys_addr_t phys)
> > +{
> > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > +	struct iommu_debug_metadate *d = get_iommu_data(page_ext);
> > +
> > +	WARN_ON(atomic_dec_return(&d->ref) < 0);
> 
> nit: I can't see why you need memory ordering guarantees for the refcount,
> so you could use the relaxed variants for the inc/dec operations.

Will do.

> 
> > +	page_ext_put(page_ext);
> > +}
> > +
> > +/*
> > + * IOMMU page size might not match the CPU page size, in that case, we use
> > + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> > + * That is important as both map and unmap has to use the same page size
> > + * to update the refcount to avoid double counting the same page.
> > + * And as we can't know from iommu_unmap() what was the original page size
> > + * used for map, we just use the minimum supported one for both.
> > + */
> > +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> > +{
> > +	return 1UL << __ffs(domain->pgsize_bitmap);
> > +}
> > +
> >  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> >  {
> > +	size_t off;
> > +	size_t page_size = iommu_debug_page_size(domain);
> 
> Since this is a debug feature, is it worth checking other properties of
> the arguments too? For example, that phys is non-zero and that phys +
> size doesn't overflow?
> 

Makes sense, I will add some more checks.

> > +	for (off = 0 ; off < size ; off += page_size) {
> > +		if (!pfn_valid(__phys_to_pfn(phys + off)))
> > +			continue;
> > +		iommu_debug_inc_page(phys + off);
> > +	}
> >  }
> >  
> >  void __iommu_debug_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
> >  {
> > +	size_t off;
> > +	size_t page_size = iommu_debug_page_size(domain);
> > +
> > +	for (off = 0 ; off < size ; off += page_size) {
> > +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> > +
> > +		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
> > +			continue;
> 
> Hmm, it looks weird to add 'off' to both 'iova' _and_ the resulting
> physical address. Is that correct?
> 

Yes, that's a bug, I will fix it.

> > +		iommu_debug_dec_page(phys);
> > +	}
> >  }
> >  
> >  void __iommu_debug_remap(struct iommu_domain *domain, unsigned long iova, size_t size)
> >  {
> > +	size_t off;
> > +	size_t page_size = iommu_debug_page_size(domain);
> > +
> > +	for (off = 0 ; off < size ; off += page_size) {
> > +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> > +
> > +		if (!phys || !pfn_valid(__phys_to_pfn(phys + off)))
> > +			continue;
> > +
> > +		iommu_debug_inc_page(phys);
> > +	}
> 
> You can make the bulk of this code common with the unmap function.

Will do.

Thank,
Mostafa

> 
> Will

