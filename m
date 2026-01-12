Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96631CF45D4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047F06B00B2; Mon, 12 Jan 2026 18:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028CA6B00B3; Mon, 12 Jan 2026 18:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F086B00B4; Mon, 12 Jan 2026 18:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1A6C6B00B2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:33:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ACE3C80A4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:33:54 +0000 (UTC)
X-FDA: 84324916788.24.19E5F91
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 989CBC0012
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:33:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JfrSfsoQ;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768260832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVpfFj6hka/DJY/5ODmGKfI4Kx1XNOYSlSR7awzDNx4=;
	b=NAY+otULoE71ueyGQwDBr2YPH5p9KSvR+ubkaD9XbRDCe6H9Fr091C+TWBngYInhDwTmcv
	ZSRTds+pQxHux/crmk4J1Eh9Xa2xnv0vElKWNrntq69SpxCsMJ49BuNw0a4nob3AkfZWCQ
	BZBpnlIHAFn74gPIXkdMjyKtKA5jXO4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JfrSfsoQ;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768260832; a=rsa-sha256;
	cv=none;
	b=wi5VCHRvL8tesu0PB38qOahljHCIH6gElSQ2+HHAmM9pRYO0bxo0WH63W+v5MCVqF5oGC/
	50oT7QX5epiQhDx43B0u80qHjx+Z8GMEa6WlmAb+ADeuR6ptiuVWLXywl72P9jiNPKaF3G
	zHy3z8Kj6RMMk2SP5LWXPG+SA1UHd9Y=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c07bc2ad13so483739685a.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768260832; x=1768865632; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVpfFj6hka/DJY/5ODmGKfI4Kx1XNOYSlSR7awzDNx4=;
        b=JfrSfsoQ1Y43c/TWPm59/FxZm5tLRW0Kgnyanq3pvBWApqxmjkGDtgZg29x2rE2NBb
         WRhkW64GcZpjUS+6UnQT1iJhPJcrlrtsdyE+9mCuQkDII3ZKj+CRjJ7VCex7nffEqP5T
         FlOYhyz1MksbZg1qo47/i94HIeHqF3x9tf1EeJ7w8axX19Q3Nv7XiTenzbWvr+k30l1D
         i4/bboPmuf7i7ZBXF0ceCqfRnc/YlEvj1PVCOS/wVPUfsQJNghMbIKxQuXIGnI6dFUSD
         U1Q6apkhoklIYGmWvQPpSHQokerjdFEySO61llw3vhCa2CwIy1Zcnf3mYomzi1RF9uP7
         Ysxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768260832; x=1768865632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LVpfFj6hka/DJY/5ODmGKfI4Kx1XNOYSlSR7awzDNx4=;
        b=jcuuNQD/THShkXn6DgcQvAO8eJlv1ildhx2UBhbvpDJJx0ewJ+E8rAxqWtkIhHUkLo
         OF3Q9Tos3syIaN5zzb3tU6rgn4FYp2M5M7rY80xdNOE56mBz+JNfw2N0WALjq7G+piKV
         J+M1X5wlw4gjyikd8RIL+oM9aqTd3L3+QbK1g2eRwwKKUJW7P4DODX9oeWl0bIxRxaZs
         5XD9CLxUZ6QmeP/b77e55AKkin/WNMTcWp5w3pLZIm+ywt3c6+qxEOk8IlvgXVIU1JcN
         oHC0FcudSn7NzT6TD5eWZs5Zt7Oefd6soTm7yMPT9r8G4s1QQsoAWcZC94ZC2wRvauX1
         GgIw==
X-Gm-Message-State: AOJu0Yymmbe76UqxpNlzYS99H42E+/Mr9wuU0R2pKvd57FcR6qmHRe2t
	/gnKKuYKSzFDGfwAbS9SMJYMqmNkp8N6gGJO7F5W+Q9miiqUbtnrgyY3rS9iBjoZEco=
X-Gm-Gg: AY/fxX7AIBNs72HWCqQHnyIqO+sXwglVVLblQ7IQO/cqExhmCCKca60uR8q4fJTsta1
	ZyNgMkXXseKzy+9Ctb05hiG0ssfwvCEZMT1p1pX0+AYloIdb/utav2bZOrpmBvQC/v0ZUFEKapW
	l2Ut4WdnXzf5JzT6jGFTYj+ZelQMaFCyifIWCxrJuyirxcDpANRPX1fMLfmZqLHkCEFEfGcgZUG
	YuuXTrzkDqS72CxJM80dqAJoPMHjCmvDVGZZnoA8HxcDYA1Kou96YMeb0jQgZZ7Hp6ceaireX3Z
	jAT3auUPKOjyhWOehvOkm73Hsnc8L2byNsizXjwrBcBRZdppq8inNWlukpJAL3cJP2bHcqMNCmz
	hEswaJE1EZtr6nm4GNvqhB16WyiIQVaY7qQ7r+VxnDc/MUjGDy3FaQR6tyHKqIssjjO+/SKg7Vt
	8qEKOxNqDIT7cRibmJ5GvngkHldlu2uqUlh2sMnXeiewAQWwR3vN9uPexg9YrGF+OJvKzZZw==
X-Google-Smtp-Source: AGHT+IHMBCCAecFcwqDPXZCmjtmCZLckRO4RmA0iVdHt93P2StieqUO9Nzjvt39n7Nz2NJh9b9wqbQ==
X-Received: by 2002:a05:620a:690d:b0:8b3:83b:6e9c with SMTP id af79cd13be357-8c38940e5efmr2586340785a.90.1768260831556;
        Mon, 12 Jan 2026 15:33:51 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4b92a0sm1574077885a.13.2026.01.12.15.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:33:50 -0800 (PST)
Date: Mon, 12 Jan 2026 18:33:16 -0500
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 989CBC0012
X-Stat-Signature: rhbj6pwureqai1f6gedm4z4ctwzwjaxm
X-HE-Tag: 1768260832-973152
X-HE-Meta: U2FsdGVkX1+7uni2ocr4vRl+u9dyG9scPUqpUfaUgYO2PMNSDJ+Yl51sMmmEEwuHjd0npbm/Usr3TIZ0wC7BtDyMXPxrrtuM8KL4kVWvsBu/aJkgZ7AJI6xjqaC3jxRCWB5emKQc9AY7+ahfe0icN6KdU1kL9dnsPpqBz8/bU6L0JtPzaAMVZIrb9uUEb/ipMqlKBREK3tUbmhZq3HsySCaydp1x+S5AXt53Bu69bhM67PJAJyAm74PdJWQFZUAy6dLzCaSsqOzwXEYojf1ngTynK2T5Ssc2KaiqlIWS8/vXdIxywApD16wm1Kw3dbxXAmLzKoDQTH4kSxAXmCTmmcyjbh4EUMXlFR4Jw2hhsz7QmLArQt2q1Uc/HXIbqAqkAGfgNVCyGuedv9CD/AbrquhTtBMylGJUuEJpFIiclBc3bG0swU+tsO9RwWiZ/njnoQgQvmzeW/kyot9DPlCGa6zciWqoWJb7htpnhH7VYRb4JTdJ9+zl+FoO4kye+iGinXkDpAt/SDrlLBl++agxAxlBWXChcuI1HWafmGUmVxfPjw/KaJncCymzT984ZvBIzYCB5VWLF0+wR7lzsy4XIBoXfd9d1WYFLXv5T+VHotwi/DOJxjN6wqbibkymm+9aVFF30I0nyj3IryXscAoDU0Xedw9SkfLkqjBVurft0gvMiBt9H58NO9cF64+Y9u2wD8uf5aR8hhaxK+Ywvu3F2VoqP6qJpTa7w6ohOJI1pGmj0ryOneI+xzvt1WQVM4vvCfIoZ9IPeF3GN/l/+3yQ53vObS9ZpIU9l9INPXZLbRu5dScK8sJ+SmY4pvFhRUhkfXNbsA89rb/GxRalUpP9xX3YLeZ4wp6RLu6Ln3ulmeu9ADVavSz9/XFXA8LhQ3UMwTLWq9g7PE9Ip0Tfp4DsWa9RoHX2IajnwtjXlCztnuUSdl78DspfpMimIjWcf8A/03tc9XZ5AFHPlFrL4F5
 kFw3JnXr
 BPPNY7t/NiMGL5WLEODtb7+84oNhf1sGKuCcJSki2OZRYje7CjgO0+uinIV2rYU2ZZiYaHwGwREUXNgRXSnxb3gv8ha7uKoXpewCMloKGDOHIi3yqyBvsPLvR9Su0ng/ukx06n54/X2OD3ldso050TNzeDZ/+6sXnoHYDBexSCv1QdSUhH+xzyhSwjyyl6GMjC108LevDVnvzIp+lDTE+r4OTsZdPQCmWowtTLrPw0I8jQyDCeAZb2+tAtinL6+sj0Q/hCbYlqhPhvPWa+YGXQwQxGZx1uu/TaTAQkO+Suf8ou2F8z2VgKR59DJIcSJUyHmN96NKYuQ2JrqfZoVWWnbAzCdjeOSYXkK816T4H/vu5plPL7yrDuYJ76xkbL9F6wSgXXOxZVeAHdn+EQ/YnAf7N8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 09:13:26PM +0000, Yosry Ahmed wrote:
> On Fri, Jan 09, 2026 at 04:40:08PM -0500, Gregory Price wrote:
> > On Fri, Jan 09, 2026 at 04:00:00PM +0000, Yosry Ahmed wrote:
> > > On Thu, Jan 08, 2026 at 03:37:54PM -0500, Gregory Price wrote:
> > 
> > Hardware Says : 8GB
> > Hardware Has  : 1GB
> > Node Capacity : 8GB
> > 
> > The capacity numbers are static.  Even with hotplug, they must be
> > considered static - because the runtime compression ratio can change.
> > 
> > If the device fails to achieve a 4:1 compression ratio, and real usage
> > starts to exceed real capacity - the system will fail.
> > (dropped writes, poisons, machine checks, etc).
> > 
> > We can mitigate this with strong write-controls and querying the device
> > for compression ratio data prior to actually migrating a page. 
> 
> I am a little bit confused about this. Why do we only need to query the
> device before migrating the page?
>

Because there is no other interposition point at which we could.
Everything is memory semantic - it reduces to memcpy().

The actual question you're asking is "What happens if we write the page
and we're out of memory?"

The answer is:  The page gets poisoned and the write gets dropped.

That's it.  The writer does not get notified.  The next reader of that
memory will hit POISON and the failure process will happen (MCE or
SIGBUS, essentially).

> Are we checking if the device has enough memory for the worst case
> scenario (i.e. PAGE_SIZE)?
> 
> Or are we checking if the device can compress this specific page and
> checking if it can compress it and store it? This seems like it could be
> racy and there might be some throwaway work.
> 

We essentially need to capture the current compression ratio and
real-usage to determine whether there's another page available.

It is definitely racey, and the best we can do is set reasonable
real-memory-usage limits to prevent ever finding ourselves in that
scenario.  That most likely means requiring the hardware send an
interrupt when usage and/or ratio hit some threshhold and setting a
"NO ALLOCATION ALLOWED" bit.

But in software we can also try to query/track this as well, but we may
not be able to query the device at allocation time (or at least that
would be horribly non-performant).

So yeah, it's racy.

> I guess my question is: why not just give the page to the device and get
> either: successfully compressed and stored OR failed?
> 

Yeah this is what I meant by this whole thing being sunk into the
callback.  I think that's reasonable.

> Another question, can the device or driver be configured such that we
> reject pages that compress poorly to avoid wasting memory and BW on the
> device for little savings?
> 

Memory semantics :]

memcpy(dst, src) -> no indication of compression ratio

> > on *write* access:
> > - promote to real page
> > - clean up the compressed page
> 
> This makes sense. I am assuming the main benefit of zswap.c over cram.c
> in this scenario is limiting read accesses as well.
>

For the first go, yeah.  A cram.c would need special page table handling
bits that will take a while to get right.  We can make use of the
hardware differently in the meantime.

> > --- assuming there isn't a way and we have to deal with fuzzy math ---
> > 
> > The goal should definitely be to leave the charging statistics the same
> > from the perspective of services - i.e zswap should charge a whole page,
> > because according to the OS it just used a whole page.
> > 
> > What this would mean is memcg would have to work with fuzzy data.
> > If 1GB is charged and the compression ratio is 4:1, reclaim should
> > operate (by way of callback) like it has used 256MB.
> > 
> > I think this is the best you can do without tracking individual pages.
> 
> This part needs more thought. Zswap cannot charge a full page because
> then from the memcg perspective reclaim is not making any progress.
> OTOH, as you mention, from the system perspective we just consumed a
> full page, so not charging that would be inconsistent.
> 
> This is not a zswap-specific thing though, even with cram.c we have to
> figure out how to charge memory on the compressed node to the memcg.
> It's perhaps not as much of a problem as with zswap because we are not
> dealing with reclaim not making progress.
>
> Maybe the memcg limits need to be "enlightened" about different tiers?
> We did have such discussions in the past outside the context of
> compressed memory, for memory tiering in general.
> 
> Not sure if this is the right place to discuss this, but I see the memcg
> folks CC'd so maybe it is :)
>

I will probably need some help to get the accounting right if I'm being
honest.  I can't say I fully understanding the implications here, but
what you describe makes sense.

One of the assumptions you have in zswap is that there's some known
REAL chunk of memory X-GB, and the compression ratio dictates that you
get to cram more than X-GB of data in there.

This device flips that on its head.  It lies to the system and says
there's X-GB, and you can only actually use a fraction of it in the
worst case - and in the best case you use all of it.

So in that sense, zswap has "infinite upside" (if you're infinitely
compressible), whereas this device has "limited upside" (node capacity).

That changes how you account for things entirely, and that's why
entry->length always has to be PAGE_SIZE.  Even if the device can tell
us the real size, i'm not sure how useful that is - you still have to
charge for an entire `struct page`.

Time for a good long :think:

> > 
> > This is ignorance of zswap on my part, and yeah good point.  Will look
> > into this accounting a little more.
> 
> This is similar-ish to the memcg charging problem, how do we count the
> compressed memory usage toward the global zswap limit? Do we keep this
> limit for the top-tier? If not, do we charge full size for pages in
> c.zswap or compressed size?
> 
> Do we need a separate limit for c.zswap? Probably not if the whole node
> is dedicated for zswap usage.
>

Since we're accounting for entire `struct page` usage vs the hard cap of
(device_capcity / PAGE_SIZE) - then this might actually be the answer.

> > 
> > Thank you again for taking a look, this has been enlightening.  Good
> > takeaways for the rest of the N_PRIVATE design.
> 
> Thanks for kicking off the discussion here, an interesting problem to
> solve for sure :)
> 

One of the more interesting ones i've had in a few years :]

Cheers,
~Gregory

