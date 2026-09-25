Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361C8C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 22:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CEAA6B0088; Fri, 25 Sep 2026 18:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180216B008A; Fri, 25 Sep 2026 18:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096176B008C; Fri, 25 Sep 2026 18:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7F7E6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:15:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 681A2A07BA
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:15:05 +0000 (UTC)
X-FDA: 85253690970.13.276646E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id ECCA1180005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:15:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qxVDR1bg;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790374503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv3eO9GNPrNvYVMn07KZEaWja3PX8hQiFyYjoNkPaLQ=;
	b=XJ+g46wjSTdCDqQt2w5T2FmCNHZG4Q6yYiogfiYZ68jwW1YfcA5lwlrbWSPbXdby9vQJPH
	7bmNrJ5t9LJfO+uPzZeqmTwrZIa30pqdfY2t6iKTLsBaRldOaIzOXAQdCoL08YgBjTiDKr
	0qoPPoDbxv+FRUo1VzfcdYwZF/+Ye8w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qxVDR1bg;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790374503;
	b=da26QDinDQtAuhwaCYPE3XMHP9FDB/ngNQRYXuwXUU+bdNRip9Dc0UTJvnDF3FsH0MX/E2
	uaTDPPS6D5S7eutVkJCMc60+WadYTkBPMm0hSSjihVdEwQXAxEmIiHTlEIpZTWwjiunqP3
	39Kp92WB6fdMGy7afqF67VYie647sqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE05260252;
	Fri, 25 Sep 2026 22:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F4B1F000FF;
	Fri, 25 Sep 2026 22:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790374501;
	bh=Gv3eO9GNPrNvYVMn07KZEaWja3PX8hQiFyYjoNkPaLQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=qxVDR1bg1fo5VwO2/RGg5Vtr+CwwYlXKWaJbHeaOFrsRIEK1O6pCV38B9XtQQBxr6
	 hAlcZq47eA0Wku2HzDmgfyqeJG9EVIDe40BQoTe/mo/gXl0SW20FqiNtv6b60Ne3/8
	 BCCJDOSTtZbkTRGxu+3ULtmDL5DGFlj9DQTXGrRw=
Date: Fri, 25 Sep 2026 15:15:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Palla Raghunath <raghunathpalla.0209@gmail.com>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, Brigham
 Campbell <me@brighamcampbell.com>, linux-kernel-mentees@lists.linux.dev,
 syzbot+442828bb356b10813a47@syzkaller.appspotmail.com, Uladzislau Rezki
 <urezki@gmail.com>, Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmalloc: do not warn on -ENOMEM from va_clip() in
 pcpu_get_vm_areas()
Message-Id: <20260925151500.75fcb001ef8cd7f4842e62aa@linux-foundation.org>
In-Reply-To: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
References: <20260925205450.21262-1-raghunathpalla.0209@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECCA1180005
X-Rspam-User: 
X-Stat-Signature: r8tpymtmxmcczj6kys6ztmifc34bperh
X-HE-Tag: 1790374502-606251
X-HE-Meta: U2FsdGVkX18kLru0hR2YBBe6MmejSsrkpATrUuSbe544xLEOZppyWrHuaSqMV3fzG4yPMtWg+fSdUkFo9yUhUxUpo7IcRHtPHWtx/GVlMq2Kp4FSPZZkLLXHraAidl8qH+dLqkI7tkXiB2uRG5wtmcRqnGAtHGWlda3O78SROnMNSdrFiFmyl790wv5GsFVQZuciT9XU51a/KIcvCFkhRHz9VUzgrUBsWInc3aCRno2XrfJ2ziCIFlHs4T7JsD6HrlaB6Bgg2y4TgYnQb8Kl7+F4kTDs1aqxk/pz23T1nt6ua7NKv4YBV4ElsWrELqXyQRE0wymyNZkbZpNt8O0ALeIemaZUJcmgniuHzLNdBhb6+8mpZoLCujbyuKs4XmTTaTuTi6Aa3J2t9Y88m7+Hg1HiOjzcQZkrLO2O2MLpsgV0cq81oz33Cgk9lUjTh3hqL3hthfbW/b6aKxM2gIXlK5nxKDA4i7piiZtq7jY2Jw9dg6NyKwqRdcTdAMuH6Ci6aP2mLaF5Hwmqpcfq/3i4ySttJxW4Mg58BmPS7Tzxt3ICps/mr+r5wJTvC8lKQJNS8zfbnfSWFdN75EiVe4zzFSWpGfqpCh/4AmF4le0TP8REjl8h5ecIAyNO8a3RT6yRIAOqimDNIFgkwbco3UwOfux3nX8Ks4uWg7vv+e2z0XaTWmTci/9JC3k55LRISTkoEZknExn1BoRlBVttj/I4K77clwgF33xSszxy3tuMmdJdcZLOxYVPAGvvWkdwPeEbZXiIIwi3zUwgggXZQo456v1Y2TFQ9FM/TuU7ucu27bOpFscM8IUw4owCDv4ZoZwrMt6U1mR3H6QLPEntHyDMjvK6eykXhGAM/ZlnwpB6+UbXZmBhal6Mw8I9V3nniWE3Ay4UCqvzQnEhe5XD921jy8/mwQeJuaxDnK3gZwp+exrtDfM6Vmnxqy/R/Ho3uQijcZeHXb09BW9E95EZ7y9
 8aOQ1rIt
 ToVqJKrMFHXOwfkLh54IuYWkRs9da+bvJP7AfN6UxGg6Uqkl9W8epP2bngSRm1bFsdLtci9xkSRAZIduolq+Qwt70hPnIol1HTBSEAR4YfsYlO28x1rg9y+Gv8Cj6EmHMTxsXnQ8DmJ/kSy6dwixqFdT1x494mvXBI/npZGBuDDj2Wmult7/j3mlVhVYU2gsDWSf71yIRDanXYGMgEn4R28/mAlpqVPXWRkwpvedcWURmDnhDGZuIaeSW0ISmP5DVn4aGo4Dl22n8u5pvJXiBVmz7T9WQkkF4nBETaQv9nlua3VDrgINlpmtjPSohPHZKUpbIvC+WfTo86/SdwkFHfDEKoX1EqEKMaSsCy+v0C8pLRtNQXUa1zuMc1Re32i1cNotGP+0z+VEcWTJeRwMvzSE909+Em0kQelJYjTmAj3NIrlEa5A/YTDma3EBs7tlf4ssnX+Z7GYm8jef1FmiYuMta5F1VeWe+IJSgJS3BtRLDgfeUX1DpR3BzDvTCal7vdqaBt1LBivdnA8SKBRcmv1/4nPqssDcCQ6Xpuv19oT60ctf7183Kv81kVk3SGP3BnYBA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 21:54:49 +0100 Palla Raghunath <raghunathpalla.0209@gmail.com> wrote:

> When pcpu_get_vm_areas() has to split a free vmap_area in the middle
> (NE_FIT_TYPE), va_clip() needs an extra vmap_area object. It takes the
> per-cpu ne_fit_preload_node if one is there, and otherwise falls back
> to kmem_cache_alloc(GFP_NOWAIT), which may fail and return -ENOMEM.
> pcpu_get_vm_areas() never preloads, and a single call can do more than
> one such split: on a NUMA system it places one area per node group, so
> the first split consumes the preloaded object and the next one depends
> on the GFP_NOWAIT allocation.
> 
> That failure is expected and already handled: the recovery path returns
> the areas clipped so far to the free tree, purges lazily freed areas and
> retries. But the error is checked with WARN_ON_ONCE(), so a transient
> allocation failure under memory pressure or fault injection triggers a
> kernel warning, and a panic with panic_on_warn. syzbot hit this on a
> two-node VM while creating a per-cpu BPF array map.
> 
> Keep the WARN_ON_ONCE() for errors other than -ENOMEM, which do indicate
> a bug, and take the recovery path either way. This matches what commit
> b9183788a2de ("mm/vmalloc: do not warn on -ENOMEM from va_alloc()") did
> for the other va_clip() caller.
> 
> Fixes: 1b23ff80b399 ("mm/vmalloc: invoke classify_va_fit_type() in adjust_va_to_fit_type()")
> Reported-by: syzbot+442828bb356b10813a47@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=442828bb356b10813a47

I assume sysbot hit this via fault injection.    The report doesn't make this
info easily available.  Or maybe it wasn't fault injection.

> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5107,9 +5107,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  
>  		ret = va_clip(&free_vmap_area_root,
>  			&free_vmap_area_list, va, start, size);
> -		if (WARN_ON_ONCE(unlikely(ret)))
> -			/* It is a BUG(), but trigger recovery instead. */
> +		if (unlikely(ret)) {
> +			/*
> +			 * -ENOMEM from the GFP_NOWAIT fallback is expected.
> +			 * Anything else is a BUG(), but trigger recovery instead.
> +			 */
> +			WARN_ON_ONCE(ret != -ENOMEM);

Look good.

The WARN_ON_ONCE() is potentially redundant.  We could make va_clip()
remove __GFP_NOWARN from its kmem_cache_alloc() and let the page
allocator do the warn for us.  Doesn't matter.

>  			goto recovery;
> +		}
>  
>  		/* Allocated area. */
>  		va = vas[area];
> -- 
> 2.34.1

