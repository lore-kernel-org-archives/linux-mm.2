Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89266CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FAD6B008A; Thu, 25 Jun 2026 09:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707006B0092; Thu, 25 Jun 2026 09:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF686B0093; Thu, 25 Jun 2026 09:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2532F6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:51:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D0A3887E5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:51:50 +0000 (UTC)
X-FDA: 84918573180.14.1181D01
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD92514000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:51:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iS231uLX;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782395508;
	b=vpjC3rVORGk4tlJk5WHnVF/lXTTet92J+LIltpeWmqt8x5KJgoYr2MyuYB9K8J2HXN+FCB
	XroytU8GDEAEChbbKJoztUChiOZV2hyrQRKoPjqhqoh/ViySU9FTJuvtzb11HB1JFigf4c
	Zn1nnYrVi9a87lwvdk/gwTbaqAZ29is=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKYJf6dgXdgamkqA4Gs/PyiillXu8yFih4YnbHcGiuM=;
	b=5K96F6bWTKt2Hnurr9QiunQ2O8LVd8CgiUoDQBXxO0mIxoQpx7AeZNh4Z79oPaITG61pba
	lBDEb2h3/WtVbznKaL6V4UerQHx5xukWccwml8ltYHYkgSLugD1IYxPHY8dY7wVYj9seuv
	zYZIv7txZLdtqeCd8LwG41c+1ywsi9o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iS231uLX;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9157d3f2098so205197185a.3
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782395508; x=1783000308; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aKYJf6dgXdgamkqA4Gs/PyiillXu8yFih4YnbHcGiuM=;
        b=iS231uLXCedGnd/FP5a2gafQcoKMgqEA6J9bZtG9nW3uKMItV31yIKUWZi3xbk6IXb
         Ne6X1BixKUB9EOjVgWienvlOXNWGeD5R0bnuvvWMlGGK3j8NQgOo0qhNULbTDqW9HaqX
         EmdoezpLSY0E0RQHpnto9PcS05ZSdxc9EPTCjd9BNZBZpJC9FJT0r5M5UjYDoFnLkt1R
         fI5Hk7qXUCJJeA7Ib/vnM6jkc0OV8etuPFO2HLQ+7cMlikMiiAJ91O5iwbQdrctoGuy1
         MRmS1xG6jbgW0YQdn+eGVdUVePt25nhxCtQEobD7Ct5Rf+nwMSIk6RH10T0JBHGFgpbE
         2XcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395508; x=1783000308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKYJf6dgXdgamkqA4Gs/PyiillXu8yFih4YnbHcGiuM=;
        b=XEYeGH5tgi3aieFC1uqxVEcyTruFY50NRKXUbzzZvTal7jQpqTlLnRGia0KteMBbV5
         JkWKlnI6vvTnmuhGwiKTi9cH5W9W1ZNTwQ9DECpqP3h5ObiQvOyl6X5+8j36gbeaXFvX
         WucloUxtu/X5DzJG8T6le9gcppl+le98ZuGiDU0dEH5OkZWsURIuQ82AzpdTKDtXhaOe
         LUXkkbHklin4ZezVryEmJKaOJClhfV53M/k0GBXXi5NY1DCtLHZ2hL5MZjWUsrBJ59gW
         SWd0i7Hx3P2vWdmUliEjsnuPO0JCgH5WhvLsLiL9lssB+z19WEy4hn0VHTHB96nZdxZo
         UlNg==
X-Gm-Message-State: AOJu0YwzVFmqPqI9Qjxir8X+WRQkPEeFW3IdeAxdoUOVKHtU8pGOcQEC
	P/XhtwKJswgWZAyY9Obi/ylXp20ayEQI6FI5YlwF2g3RtoiE8cHNYjVJsEo2UzuKpEMzZQeINXq
	3RZZl
X-Gm-Gg: AfdE7cn6cpOvq7of8axBmc86oXO82S7RcyW1L0uLSpshEdo/9jmYX6iqoDVUQm6LJAb
	JUZvw0aY61w97zdTfLGtJgwQND3tK4olfqjr+mfqBi1Mb9HbWj53q0NeUoCbikEIQaT5X1xTWEp
	jrxXVcSk8NipkWmgML0GPVdz5Dp+NruoOR6Rge9/T9EzPwUn4xp1OGg6DzEA0CLeHtv3hd5XLFE
	HQ5CYKSffLagaI1Ug1BmvKrUxMY3ec1U3knzc7TtWAVHAHYF9z6bT9bM+qIakyoj8zRrCWPFPcq
	MffuXhyaz32OtrGzeugaEb4q/Ix1+HOpV9MHWO0XcLH5HJEBb6HWrO1JQrcaWqK6CJeqh3EA1XN
	cckUI6RhPKy0n5vRGsjENlIHE3WM/ikfimUayL1Zw2IhfEhW/8oV7PgLy6JrTFBqLRR5ttXczaA
	xHhKp7OAMqCP+D0Q62qbHRzLuvPi3M6W4tLocToY229EbWf5mp6F12SPpkg6ZvfGLoOVeqbEcRP
	VRKjx0=
X-Received: by 2002:a05:620a:2887:b0:91e:7a20:3cc9 with SMTP id af79cd13be357-9293d5b247dmr385793985a.52.1782395507830;
        Thu, 25 Jun 2026 06:51:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f5ff5e6sm180208286d6.12.2026.06.25.06.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:51:47 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:51:42 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com
Subject: Re: [PATCH v5 5/9] mm/memory_hotplug:
 offline_and_remove_memory_ranges()
Message-ID: <aj0ybgV7n0pqXF0b@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-6-gourry@gourry.net>
 <d48feca1-0203-43ff-bd66-6243291a51ba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d48feca1-0203-43ff-bd66-6243291a51ba@kernel.org>
X-Stat-Signature: 1ysjsfueu48diigeh7gqbshw83gprr56
X-Rspamd-Queue-Id: CD92514000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782395508-827624
X-HE-Meta: U2FsdGVkX1+Hk6W9sykOjSzXVYJ6eyWGeZNA0zPNVzUJs4weO4R8bcH+foJriPaOg+A4Kx4ZiOwXvIyMj0XvX2knEWi6jz0tUoy6Lsj3RykpMEjKqs1Ry1d3k0B9v9zzRD8Y+or4gWvG4RMExW+AhZr1EgDqrna+MtK6bhckyhApuKuS4e0+f/M9yxI+gm1RA1VvaAYuZNW7nbkgkF8MmDTNR92bYnpWuFcYGkFAIYuUJZtwI6RepoW9tyBEV2N5XE/SGg3W0MYf8G5KRBBmaOC4mANEZXpjZ+WS0h4vG5rqkQe75+oTuczWmWuBm61FzTsJE1MQ2MS7aSmYxeMqbmdHwmjZxINd81r1THK5PjY36eFBeViA8q5t8mdtlc/Jm+MeKz3Y9KXysoeW2X7TU5ylpNKTsmByKfbFJPAxYJDZysnmafjT56b3yoSE6fiYYypXzjXanSZlumV1E4QXUSpHOnV8VbRLhNGgW/fRd2hSeLDQXFDSGQ0KHjd8gloz2nX2wmqzJ6TCWb3FjqCw87I7dkkmOXb5YO6x5RwWqLv5r3QFFajnjdpXqlJeVrv3M5g7xmNJyd2TcvvZBbvg3v/m18aqnuP/STcnkio7siY6p4zEnvOqS8JOAbeBH2kCm7SPgkY/NGWWOIDXvs56YPzoi7M8juEPBKih6tkqJCRdP//37ALPfFf2qr+UALvn9JTONl1spRjXlsPMdhyCngU3NnEN91/RazWj0bUzWK9d6moMR2k/NR0F15qbEDQpOSSjn/raK9bSvdgjKL1jMfN4nKkd4mBAgTjGQtGETZzU1XdpQGGbbsx+QkyvQTOXcLv+7q7a+/EaGjXysvvFonxG7uD9daLq0db+UvsDfvSdVlKwvSGV3pPny83/+0nppDHMSLnUu5rJ6pEGPsbP+X+m8Wr0dLBJOVJZWBXKw9rw6efOhDR2ffNxI9RtOH7YWCGuOdgAFQX+BckB1U2
 +k9gJLQK
 teEpFdumI5w64dcOVQpSKB8DUKvx7d2JVtZrXi+Cj2JQOEehhKAx1VFjDiTfmZcZRgfTzp8n3Ic8xuboL2yD2nB4xwcxcWX161/bawqcNj3SbPTxnR13naeqj6Wu1T7pTSyMrFyHkjSpwq3I7DOCXUaqsb1uFcC0bvw4Q8P+VvXd+ceK+Rk8jDr3OITXkL3/LHeJQvR5y99zNee8LhAyZQFxAiD6cWwylN5Dls54gg0o939hYKD9UhRuWN8EJF9gS3006IsdisP5hJZFHmeMZLrP+937fF/3skdd0+5MliZws2WZ3/o048aSwskXtjwhAIaWHx10OytARjIYO+dnAFS368hNgn3rkLJJLpQv6ApZ49HVu1SfQRUZqQ9IrDa3ePZDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:22:01AM +0200, David Hildenbrand (Arm) wrote:
> On 6/24/26 16:57, Gregory Price wrote:
> >  extern int offline_and_remove_memory(u64 start, u64 size);
> > +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
> >  
> >  #else
> >  static inline void try_offline_node(int nid) {}
> > @@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
> >  }
> >  
> >  static inline void __remove_memory(u64 start, u64 size) {}
> > +
> > +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
> > +						   int nr_ranges)
> 
> Best to use "unsigned int" right from the start and use two tabs to indent.
> 

ack, ack.  need to reprogram my brain to two-indent style, i keep doing
this reflexively.

> > +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
> > +{
> > +	unsigned long mb_total = 0;
> >  	uint8_t *online_types, *tmp;
> > -	int rc;
> > +	int i, rc = 0;
> >  
> > -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> > -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> > +	if (!ranges || nr_ranges <= 0)
> 
> With "unsigned int" this will be !nr_ranges.
> 
> Wondering whether we would WARN_ON_ONCE() here.
> 

Seems reasonable.  Do we normally WARN when callers send dumb arguments?
Seems like sending -EINVAL is sufficient?

> > -	online_types = kmalloc_array(mb_count, sizeof(*online_types),
> > +	online_types = kmalloc_array(mb_total, sizeof(*online_types),
> >  				     GFP_KERNEL);
> 
> Is "mb_total" really more expressive than "mb_count"?
> 

No, this was mostly my way ok keeping try of what was being moved around
while working it.  I will change it back.

> >  	/*
> > -	 * In case we succeeded to offline all memory, remove it.
> > -	 * This cannot fail as it cannot get onlined in the meantime.
> > +	 * Phase 2: Remove each range. This essentially cannot fail as we hold
> > +	 * the hotplug lock . WARN if that assumption is ever broken.
> >  	 */
> >  	if (!rc) {
> > -		rc = try_remove_memory(start, size);
> > -		if (rc)
> > -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> > +		for (i = 0; i < nr_ranges; i++) {
> > +			rc = try_remove_memory(ranges[i].start,
> > +					       range_len(&ranges[i]));
> > +			if (WARN_ON_ONCE(rc)) {
> > +				pr_err("%s: Failed to remove memory: %d",
> > +				       __func__, rc);
> > +				break;
> 
> Do we really want to break? I'd say, just warn and continue, and fake rc == 0.
> Something is seriously messed up already, and we partially removed memory. There
> is no clean rollback possible.
> 
> Similar to __remove_memory(), ignoring the error because it offlined it already.
> 

This seems reasonable, will change to warn and continue + return error.

Sashiko actually pointed out there there's a corner condition here with
offline rollback, so i needed to tweak this chunk anyway.

~Gregory

