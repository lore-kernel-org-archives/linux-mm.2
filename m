Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEE2D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B686B0096; Thu, 15 Jan 2026 12:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F19E6B0098; Thu, 15 Jan 2026 12:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2143B6B0099; Thu, 15 Jan 2026 12:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF2D6B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:27:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3E6C140401
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:27:19 +0000 (UTC)
X-FDA: 84334879398.27.D12B19D
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id E02A910000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:27:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=seBq2pCn;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768498038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FK61OSEd0UmY2wqnN+WlOD2t6xQO8MJ1jOlEc9XBMg=;
	b=tRanEUDyR2Opn3JgdcvJBHtIb/TSjSGPX9S2/ARjsc+1PoQYjxE4c768sQ6dRCDuWynvri
	r5RE7rJQSYVhEBCihjw7yCb/THh5StZxkz+AodO0Sxn9PEr+fHQp1BwB0ARqBt25FYM0Hw
	rW4SV0iZ41WYTDR1GtJcyY+16uQpLbA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=seBq2pCn;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768498038; a=rsa-sha256;
	cv=none;
	b=Dp5shVs8ZDbPoWGNyOg7woni6aXF9aSYEltdM9w03UM5J0UJfsvNOwy9i+xGPM9AcpFQPW
	h2XG78rwq0yX374mYyFDsFaSnaW5f5d2BCrbXM0tQTLLhSs7WRpqNDe820C+hUJZLuwPkh
	Ftf31wPHv5itHuFjdycFEZumpOlnlBA=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a3bba9fd4so13055876d6.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768498037; x=1769102837; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FK61OSEd0UmY2wqnN+WlOD2t6xQO8MJ1jOlEc9XBMg=;
        b=seBq2pCnMn2R5fvQVuHc/BnpJA0SCIsVERKGtFI0bgtim9voNmLuP5GiNnReD5TtDV
         4c4kS42KD5sD1nQA8lENMrqaYaNL/trkPJUW3U6GrbEe5Eq1gDXeM4FZpyraDGuRxNb6
         +SvHHXeslfjW2ACc0XvByXohKm+D3AcHqiLMb1OPKac/tj61JcioOXiVfvn9yzw5LYAn
         KvaJXxUy3FCBGu7BAd8wkoCCfufsLvAATWzkEWUtPvNO/ymazSdMVjqtIe9rsvlmDRQ8
         sxudxfi0c8ttSMJQ0ytabmoJOcKJIFxibqRva8rrTjrwIbl+PFAFQW/oTqHz2+O7xjz3
         3kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498037; x=1769102837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FK61OSEd0UmY2wqnN+WlOD2t6xQO8MJ1jOlEc9XBMg=;
        b=O0YauNmTNA0od/QT5gWhnJEcJi6kqs9nMun5haH1kmDXFEfBvivFHdLrJFvfTtIPy+
         CNAnRbA4B1i5wdqDKXVV1DSTCOl3EUkRPo8qZqSdA+V1k6W3wisRKrwPr8BI1LWd3tx8
         lbyl7rGveFybpNmfcrgYmhTiU4iuESIAkOme3zFNvXgj5Bru+eUHQzUqn5CGQUuuYVCA
         iR3VZ0FfxROwYUGJc6+gUz5MKKNcN6ZJ92jIRdGqV93/1mDh5lJnJitZoGdiPi+NAZys
         8PPTfqQjeqBeibiWoaA4csFsdlndFXiNS1ryn0w559q2t/hj5RyK1xJ2yjVTTYw1czwU
         hlFw==
X-Gm-Message-State: AOJu0Yzw8VcpMrRtAkqxPD3J5MmltIIkM/3dnv9YzSQ8tGas06ZZHzGH
	dSdLTLzdh80B+ifaO3joW88hK+weQezJ4Ez2h1ipww7MUIFVO2SNYUvdp/Gv/McFC2M=
X-Gm-Gg: AY/fxX5snvwuj4Zo84FGoYC54e9KvlIDO7qdFMxTXL6kWD5Rh3kpePlb43axfpYp+QM
	VpI2XySaNJRC2uS7IWP4UgTx/xDmR5Agyq5ojoWH570lhe08+OqxJteWvxJU6VqWyg9Q4oeDb6m
	FDtK8xqspEFkxfteS4+nUvz3wfZ1wurID8TrwU/YV9RT9+k1e24q+Vz0X3tMRpk7Gr+eOsBxlxA
	ahjdVjVZh9jyE/1JTZkbBeHRTUwdfs5u5lJ4lHO/A1dbMYoi8DAknsXjQdNfqdvW0yca7vM5rdc
	pWrrZtDB6zzGAjCiXg7Cejd+yqL3jv47jY1w6zkH8+2kn63oZeLTyWOY2EINTs8yL7mWJq6+Hqh
	EDjpbF1wwj0fjhKl8qo1ltbURVg4F9kWZsvXeVHStcpDF2bHWzJNB+AgDKOQb8EShEbv/aQUW4k
	7SWU1mqMGfTqViglKzoeHYmbuXChnUTHprTTJLocXTB9lBXd6Sgz+Hk/Ngpdxd60aw43AMKA==
X-Received: by 2002:a05:6214:4007:b0:889:b6f1:1f30 with SMTP id 6a1803df08f44-8942dbf5199mr2798016d6.18.1768498036628;
        Thu, 15 Jan 2026 09:27:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077253305sm219364246d6.41.2026.01.15.09.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:27:14 -0800 (PST)
Date: Thu, 15 Jan 2026 12:26:41 -0500
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
Message-ID: <aWkjUXpyLEJyc-C0@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
 <fkxcxh4eilncsbtwt7jmuiaxrfvuidlnbovesa6m7eoif5tmxc@r34c5zy4nr4y>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fkxcxh4eilncsbtwt7jmuiaxrfvuidlnbovesa6m7eoif5tmxc@r34c5zy4nr4y>
X-Stat-Signature: 9a6fz5kpknr418qzkjrzxrrfn7w6n83j
X-Rspam-User: 
X-Rspamd-Queue-Id: E02A910000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768498037-963655
X-HE-Meta: U2FsdGVkX19fQoxIl449FePtI2NSJXC5PajsLgJqgUqCaSsnEz68PwZDasVLw71/AaPOPvBsDMqb26/yrEm0iMV+eSmS4+z0T13CAmMgVA8+WMMsQuTAwgDcvjFEskzUnxPuEEk2eDXGGlK96ZKI8h5BxbJANJsxIqRSZz+/RQmOU2n7Ts9czayrj0spCwxRWBLSoa5tTFSnqOBjYQ+vYk+/gQFkTYOGQCPhlRvhU3G5PCXGWbYQv/VO09X37Sh5lSCgBL61z4IJOjiwIeTPjprJ4OmVfR59Rk7ubAeo5x48katkS4BHSjG1SNcDBYJCEs6ZRPaLbBpH+ihcJpFHu6fFe2PS8W0qM8Ih02vspkuiP4ZWWa+C9mbGOHxUoJfw89Yr4v9nKzV5IUSKLQAuK9aCzy/6mK/B0gOjy3oOhHXSj0ehRI3QKzqvfhHh3N3h4tqFA1iHg5IakoAuwqRbHLQ/GX4F5OcTietWhnc812zu0J3Zapo5580pU8Jztl6R+jM671N0wsJBU5g1q+5S3uCJDpIE0sz2tz4ge3Ix7QuG6KyjmEYXR9RZjyKVR7lNPnz7/0EIxvYiBFuZOUXX5YzaICUXUetRC0usV6hwhhq+w6RKGDLCHvNZOkIX9TteS5nowE0qBid+z6CwSjeFLbb68wdKmv9wh5wDxUT5i9zK6uaC6GkcOF3FakxLg0L5WTUZNYsFi0eqZe2gqM+ihJ6ZEkYQFiirgMw2iSl+d50wu1CTmc6CXLEZa2SDUv09nKAMPGvq2xxe3rg1WIETB6QtUDxMeNmQ6IboElyeo2e6grHtcnwfNoc+CaoMqw/6mxy4Acc8xib1xH2n9K77aLR1RLToPCSllbOhLPZIbbzrDHBLLCph55N6rGw8d2/SgcHeZh0Bpoja5nlrPkwWjkfQ+xo4bqPtI4ARodJVkbZefICT4GvhL8sVdBWYm4D1r9QagDvpsSxWSsqoUCM
 4p+AW2wU
 FFE/SqHtq25r707QDKZ7m7d7UdLX/a+X4uKhwrwxJI30f9rKTHTU9dtmvlAFtxW5pxXkHU5/9o+r9nu6et7xYERpCI+fESWBUWCYmyII3VVtTc6jgLwTCj1EgXe3TM2x2bGyZZNKIX8ItXPHOibb7zB64CIylVkilzC+1D6g7g2lNTi6PtfvlEeQ1bUeMQvIwMsywze1r0gK8S4Ze2YMJGToPoYuQn77kyuktJuGiT4HJSxIthMjbpw4/4N6S+tFKw4WaCy0NkQFQ+FZejc0MesmVzJXtxiTmYfV58tcVPv4NSrhbnPIIfP0ChU7/rFRQr/cd6K9GVEJc5ZCDWNzmC3JlZYIU0mQlx58D17qao9w2h3hkKWIOEwrcmMOnN9QaaHOmq1FE0gKlxUVy5+gJyyRr9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > For the first go, yeah.  A cram.c would need special page table handling
> > bits that will take a while to get right.  We can make use of the
> > hardware differently in the meantime.
> 
> Makes sense.
> 
> I just want to point out that using compressed memory with zswap doesn't
> buy us much in terms of reclaim latency, so the main goal here is just
> saving memory on the top tier, not improving performance, right?
>

Yeah first goal is to just demonstrate such an accelerator can even work
as a top-tier memory saving mechanism.  But hard to say whether reclaim
latency will be affected appreciably - won't know until we get there :]

I'm totally prepared for this to be a science experiment that gets
thrown away.

> > 
> > I will probably need some help to get the accounting right if I'm being
> > honest.  I can't say I fully understanding the implications here, but
> > what you describe makes sense.
> > 
> 
> Yeah it's counter-intuitive. Zswap needs to charge less than PAGE_SIZE
> so that memcg tracking continues to make sense with reclaim (i.e. usage
> goes down), but if zswap consumed a full page from the system
> perspective, the math won't math.
> 
> Separate limits *could* be the answer, but it's harder to configure and
> existing configuration won't "just work" with compressed memory.
>

I think you are right. I am also inquiring whether individual page
compression data is retrievable.  If so, then this actually should be a
trivial integration.

If not then this is probably ending up on the cutting room floor and
going straight to a full cram.c implementation.

~Gregory

