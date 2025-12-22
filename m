Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3192E674AF
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC036B0088; Mon, 22 Dec 2025 08:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15AA06B0089; Mon, 22 Dec 2025 08:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BAC6B008A; Mon, 22 Dec 2025 08:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E69006B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:09:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94AF81DF3B9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:09:03 +0000 (UTC)
X-FDA: 84247137366.24.2EB8EAA
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 77C7914001D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:09:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PEqZ7ppK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766408941; a=rsa-sha256;
	cv=none;
	b=wOE+XeKqJNeJCI1tfIhPXr7DGghUI2qlfbPNuQoOdwCoXz6BG8CKZFLqSCD2Bv8KMmIeV3
	AJSOxz9y6VpYUFZhUR+9DsZb3MREhwU+4MIiIKTmMPgGxdXHOCRuUBb2mQN+GF5x/QL0n+
	3//xYZpFamphgVicKqwPXhAnn1JOUsY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PEqZ7ppK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766408941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqkA3QTeqvfIHTaFJmrTviJUHc15iycYlD6ucgB4o6w=;
	b=6IzVL0bY27qA+SzmX/ZwjL5v74VXjoPN1DrEJsG/WCaShzhj8dcPuCx1Q5K8eDBMjA883z
	EkMlbwAHEFOqNyuzp6UE6qsXzZAimvEfH7LIqs0YWJ/UmJd/8EhJv90GUPYbIz2PIcDicU
	JT4C11WEbBI/jxI2cbYajZxxGw+j+bs=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5942b58ac81so3454902e87.2
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766408939; x=1767013739; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TqkA3QTeqvfIHTaFJmrTviJUHc15iycYlD6ucgB4o6w=;
        b=PEqZ7ppK+Phv6HNIkbOIfIt71hxQxvQISOrtl9FCnNno6QbUJDfA3SQd26mSZ3Z8E3
         uCg5OVNqldcPnSQ9OBvU81d1f3yaRiMOoDk6i6mBiPBGVxwCz3FQGfZNTij+if1tE6Bh
         1B/WMcXWWyywIO4tvI+GBPRNMHNTb5ptPel458HVdX7vcFHx8+va/RQmsWEay/p2RseE
         qrJxvkwPCAz02Z6fC3lilaud/RxHHWBAqPvQL7+51LKbsat+7TVfxAmzIz984sHrijdf
         jAS0btCfi9r7nbNz62Km3sbTqKf/38x6cIQMTvNrdiTpcd7K2bhBLsdPPG+RGs9rM9Ki
         Shkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766408939; x=1767013739;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TqkA3QTeqvfIHTaFJmrTviJUHc15iycYlD6ucgB4o6w=;
        b=hLVIMifPlJjXsF5HyJDyr3gVi8y1s93UHM+llasgogAxkxRH1y099Igp1xnrlrBlTN
         GIud125+rGUMU6ojYx/dPgPeXdn2tfXlyOPdvs+TQIclnVe6469N2YAkUSMWomiJK0Pu
         /MpRfyR/LA7hELoxOtK/5clthEAIbAYTAva0eMlixzZaRTt9+Y9haPSNCohw4oRxW5vb
         CviErd7uR73YuqmBeKDWDXZucZzT0DiPgqUnwtW8jPdAxHIO4QoM5NOMq5kW+oztHT5c
         r5vzctWar7daOUvoAxj/xQM6eaUiSdm5kGQSZGU0UFuHbqdh7hdVkiPeXhC/cDBRl4Hq
         BF/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqt7UA1NdMdy4w09+bE1l2ncKnOeaROVNF958V4cF4cgMnzNIZUya0UEKajNWlE494qXPI43kaYg==@kvack.org
X-Gm-Message-State: AOJu0YzD7+Hbp9PdL4Z3RcpT+GJoVtzsg5TP7m+k0kdrTF9jVwNf++SV
	lfe9FdV9lJBVfHcHO1xNY8CYjwngxyr2YOCr3degVsuwD7BVBt4KdkRH
X-Gm-Gg: AY/fxX5nT4K4QzexnpouhAqiIfQZ9wn5gXuegtkY1X1FxfdFJMto8YKsArlvZIl2Ymm
	kUURNa52P7ozKYcR2ubOQmwbk7pVQHV1ABEjwYaCpi7XSXzGsiefEXo/fXBYaogzK6ojNGrQ5RZ
	qG8NdqTbBb3y6XmczRE2IuJbPsh+HR+gRu7KyDm1sBzCscEeKQy7NQg2T6rJwXSJEMB83Ek0Bcb
	jnoPlUI+SkmQSxQBf2lmCVjG9LGwm/YbpxD0VOOObSZI7zVqL5MKxr0Sbp+txP78835tqqV7bTN
	eoXJuZ/kRCNsWsonZ/CJojafNxC0nGdGnKQ9LXVRUU+wwZXPHioQypeoKybE5D32/CWP2IYkRTK
	bNLhzB/98l1oJQSCSjwBIRaRNb99be5/LSWnO3tH0/KBG2nP5WpcJ
X-Google-Smtp-Source: AGHT+IEoHaD9txNltw8AYIh3bvKWbd6Ld21Uc2hEUyNiNte2MbtG2FdcMNsmNf298a2tH2qY7Uf5Kw==
X-Received: by 2002:a05:6512:3f1a:b0:598:e39b:d628 with SMTP id 2adb3069b0e04-59a17d7271amr3858414e87.5.1766408939248;
        Mon, 22 Dec 2025 05:08:59 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a1861f4e4sm3115532e87.83.2025.12.22.05.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 05:08:58 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 22 Dec 2025 14:08:56 +0100
To: Barry Song <21cnbao@gmail.com>
Cc: urezki@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	dri-devel@lists.freedesktop.org, jstultz@google.com,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org, mripard@kernel.org,
	sumit.semwal@linaro.org, v-songbaohua@oppo.com,
	zhengtangquan@oppo.com
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
Message-ID: <aUlC6N1jmDbMDPc5@milan>
References: <aUQHss6K8b_esvpw@milan>
 <20251218212436.17142-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251218212436.17142-1-21cnbao@gmail.com>
X-Rspamd-Queue-Id: 77C7914001D
X-Stat-Signature: 4uoq6w5yrxia9tr8f8cqs5sttrne4oiu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766408941-803967
X-HE-Meta: U2FsdGVkX1958Zws3binhpFIXjshMwyt+YLVK7BzbkWJ6uRD+/K1VIQxCeJZHF42jccOV56Pbx7NLjzHHS2MKUpIKQNakZ12c0NiXjfYSeIt1bmwGebxmYhWuNHT4PuMqJD/xUGm9kkxKVej1IZhGM/8xHZe0SprITsKgZuIIkz0fvQyLpL1MS8KYo2Upf4e/AzCRRwEYUXsVg0ZVhhaFUnfL2t5Jd/jEJ6Pv9CS3PEFS1FuG9+tmPSMT+x9OYGCBEt5JdIidZc3oBxqJk2Dgf+UelZa8VPKSudVEzPitx11RA6BF9Yd23zeCnL3wzpJBtUPaUKIVLzDYmAWe6354g5uch+Wgc9W3N5GD5gUR6PdigJCmHVeTadxU90SHk/EwFNFH78T2r32Lo2E3DXaIUpyMBfu1ty7ntSB/xafoq5eoWH0cMp89FZQIEgCoPob1+2nXqL0AiqeCUs/FPRnk85pgsFY/6i7vCSjcnt2+iqISjspdxsh7b4/uu4e2Q0GF+0fDkEHAbTkDapjhLm/cammbswUqgmK52ZvqZQJdW63yjbWEjHetyenx0YnG3oNLXNhlWL1J7vn8wnjIE6x6zii8XRJHiiGY3xpTxpRbW7Bwh063FcRaYgoejEza5y5+q4B0F+pEkWBV/xiCGUOxZW/4LSwUJGwsQFYr3ooQ56aEibau09g8t5cj4n/R64yEbqJnwgIeUNqkG7iUKf84CRsLyJCLZsNB/c2SKfg0+r+FmOaZ+tyo4bTfvvPGYir1MMheMO633DrnQvtMUK+uDrl37S1RavowT6fGZaB9v96ZISzS+2ToYCE0QL9H/Nxxxec9FclpDI0aSNkOq+TQN2VTqLGbsqMmzHvxZ+hZcE++KxROUD07nKkB6qg1MRFNiwSN1OqtEnxouAYX61pbgz2rrkbtl8tT0Aaw2midrhcqPD/Dyg2aheXRLFKi17/EzgjlyNMLy06DKe3ZE7
 K/w+LkFe
 C7/l3XHTnSqqnRBOz4qa5nCNTOcPGzqV9CtsQwdhTsBUpoVAdyyfHIZLUtZXJjLzy7kF7gVuKHb0XdISySHk32CPADnj8KxGm8wS/4XMX1BDXi/7MUqU6j4RJzoPjMJGlWOxcEug+3mUACa9HfSVstSrr2XPIIHPLws4u6twGG2aNtM2ZK4naaSH0A264zBMRe/R1UzplgUlU4B1zAk3Mf1fUmBC0OhAKDInhrtwJfg5osR2EB5h3YA+ubfXZp9p2O/9ogOQq31vs9gt99hH8Tm9E40xO50nAI98RZI+idovsKYs3cbNpUuQhgIt9L3rCANXUXtpaUMqDfV7CE+4fPU0BwR6dI2omH2lkUNltmpJ6RTOsOvCPcdHdpQpl8yzRw5PUpjROsbE6Np7219ekjllhg2Uyhif1P1AMkflbT6yhdh3+KMBFZpg2x9PwWvbIcO593O79ItF7MhyvGeXt+iKjEBVKMca7IXFp0WEbruGvNTMA7LudqUrNBxOiy0n/btwh/7P7Aefkzu6nyNcMMiwFC5lAq2SA3gQn0Oe17TZWbmtYnAsLqnJetVkdQs7abBxTj168DVd7MEI5wnjv6JDF93o7jTZQNUvr3MYlzZdA+9A/Mqa4hEhjew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 05:24:36AM +0800, Barry Song wrote:
> On Thu, Dec 18, 2025 at 9:55 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Thu, Dec 18, 2025 at 02:01:56PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/15/25 06:30, Barry Song wrote:
> > > > From: Barry Song <v-songbaohua@oppo.com>
> > > >
> > > > In many cases, the pages passed to vmap() may include high-order
> > > > pages allocated with __GFP_COMP flags. For example, the systemheap
> > > > often allocates pages in descending order: order 8, then 4, then 0.
> > > > Currently, vmap() iterates over every page individually—even pages
> > > > inside a high-order block are handled one by one.
> > > >
> > > > This patch detects high-order pages and maps them as a single
> > > > contiguous block whenever possible.
> > > >
> > > > An alternative would be to implement a new API, vmap_sg(), but that
> > > > change seems to be large in scope.
> > > >
> > > > When vmapping a 128MB dma-buf using the systemheap, this patch
> > > > makes system_heap_do_vmap() roughly 17× faster.
> > > >
> > > > W/ patch:
> > > > [   10.404769] system_heap_do_vmap took 2494000 ns
> > > > [   12.525921] system_heap_do_vmap took 2467008 ns
> > > > [   14.517348] system_heap_do_vmap took 2471008 ns
> > > > [   16.593406] system_heap_do_vmap took 2444000 ns
> > > > [   19.501341] system_heap_do_vmap took 2489008 ns
> > > >
> > > > W/o patch:
> > > > [    7.413756] system_heap_do_vmap took 42626000 ns
> > > > [    9.425610] system_heap_do_vmap took 42500992 ns
> > > > [   11.810898] system_heap_do_vmap took 42215008 ns
> > > > [   14.336790] system_heap_do_vmap took 42134992 ns
> > > > [   16.373890] system_heap_do_vmap took 42750000 ns
> > > >
> > >
> > > That's quite a speedup.
> > >
> > > > Cc: David Hildenbrand <david@kernel.org>
> > > > Cc: Uladzislau Rezki <urezki@gmail.com>
> > > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > > > Cc: John Stultz <jstultz@google.com>
> > > > Cc: Maxime Ripard <mripard@kernel.org>
> > > > Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
> > > > Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> > > > ---
> > > >   * diff with rfc:
> > > >   Many code refinements based on David's suggestions, thanks!
> > > >   Refine comment and changelog according to Uladzislau, thanks!
> > > >   rfc link:
> > > >   https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/
> > > >
> > > >   mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
> > > >   1 file changed, 39 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index 41dd01e8430c..8d577767a9e5 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
> > > >     return err;
> > > >   }
> > > > +static inline int get_vmap_batch_order(struct page **pages,
> > > > +           unsigned int stride, unsigned int max_steps, unsigned int idx)
> > > > +{
> > > > +   int nr_pages = 1;
> > >
> > > unsigned int, maybe
> 
> Right
> 
> > >
> > > Why are you initializing nr_pages when you overwrite it below?
> 
> Right, initializing nr_pages can be dropped.
> 
> > >
> > > > +
> > > > +   /*
> > > > +    * Currently, batching is only supported in vmap_pages_range
> > > > +    * when page_shift == PAGE_SHIFT.
> > >
> > > I don't know the code so realizing how we go from page_shift to stride too
> > > me a second. Maybe only talk about stride here?
> > >
> > > OTOH, is "stride" really the right terminology?
> > >
> > > we calculate it as
> > >
> > >       stride = 1U << (page_shift - PAGE_SHIFT);
> > >
> > > page_shift - PAGE_SHIFT should give us an "order". So is this a
> > > "granularity" in nr_pages?
> 
> This is the case where vmalloc() may realize that it has
> high-order pages and therefore calls
> vmap_pages_range_noflush() with a page_shift larger than
> PAGE_SHIFT. For vmap(), we take a pages array, so
> page_shift is always PAGE_SHIFT.
> 
> > >
> > > Again, I don't know this code, so sorry for the question.
> > >
> > To me "stride" also sounds unclear.
> 
> Thanks, David and Uladzislau. On second thought, this stride may be
> redundant, and it should be possible to drop it entirely. This results
> in the code below:
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..3962bdcb43e5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -642,6 +642,20 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int max_steps, unsigned int idx)
> +{
> +	unsigned int nr_pages	 = compound_nr(pages[idx]);
> +
> +	if (nr_pages == 1 || max_steps < nr_pages)
> +		return 0;
> +
> +	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
> +		return compound_order(pages[idx]);
> +	return 0;
> +}
> +
>



>  /*
>   * vmap_pages_range_noflush is similar to vmap_pages_range, but does not
>   * flush caches.
> @@ -658,20 +672,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  	WARN_ON(page_shift < PAGE_SHIFT);
>  
> +	/*
> +	 * For vmap(), users may allocate pages from high orders down to
> +	 * order 0, while always using PAGE_SHIFT as the page_shift.
> +	 * We first check whether the initial page is a compound page. If so,
> +	 * there may be an opportunity to batch multiple pages together.
> +	 */
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> +			(page_shift == PAGE_SHIFT && !PageCompound(pages[0])))
>  		return vmap_small_pages_range_noflush(addr, end, prot, pages);
Hm.. If first few pages are order-0 and the rest are compound
then we do nothing.

>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> +	for (i = 0; i < nr; ) {
> +		unsigned int shift = page_shift;
>  		int err;
>  
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> +		/*
> +		 * For vmap() cases, page_shift is always PAGE_SHIFT, even
> +		 * if the pages are physically contiguous, they may still
> +		 * be mapped in a batch.
> +		 */
> +		if (page_shift == PAGE_SHIFT)
> +			shift += get_vmap_batch_order(pages, nr - i, i);
> +		err = vmap_range_noflush(addr, addr + (1UL << shift),
>  					page_to_phys(pages[i]), prot,
> -					page_shift);
> +					shift);
>  		if (err)
>  			return err;
>  
> -		addr += 1UL << page_shift;
> +		addr += 1UL  << shift;
> +		i += 1U << shift;
>  	}
>  
>  	return 0;
> 
> Does this look clearer?
> 
The concern is we mix it with a huge page mapping path. If we want to batch
v-mapping for page_shift == PAGE_SHIFT case, where "pages" array may contain 
compound pages(folio)(corner case to me), i think we should split it.

--
Uladzislau Rezki

