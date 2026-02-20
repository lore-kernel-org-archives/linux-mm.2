Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 082DEC5AD55
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 18:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7BA6B0088; Fri, 20 Feb 2026 13:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85566B0089; Fri, 20 Feb 2026 13:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66C96B008A; Fri, 20 Feb 2026 13:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF2AA6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 13:24:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EEF0160205
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:24:34 +0000 (UTC)
X-FDA: 84465660468.21.051E52D
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 21B791C0008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:24:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HkfI9TBd;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771611872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCzQRspACLmQoBZ/bTk/LrnZL7VoOC9zA/xIvIg732Y=;
	b=0O/0dxqkDF+NvOcd/LP+M8Di0JlXqrnSkfFY+3BQwHtOF+e2hsypuI5jFcIjUF4xdfU3xY
	vlXjMISRKgKzIhvQQ8Xyg1W3FBBTfU5f3Kq22CspV1borgvqkHi5I1WvcNN7fEyfn2PEA+
	lC8r88maS75rn7wGl5DX88/g2Fd9lws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HkfI9TBd;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771611872; a=rsa-sha256;
	cv=none;
	b=eKSoQ6Tjt1Q2oQmpXO+aLvFBhVdslgi1I1M4mbfh4rP+aJBPyl08pVDDkJQakzPHDrs1hv
	qc9jvcxvTVXBmnoh1R1IGqyvTKBN3v48ruqzlrtMHH4PZIk7Ca+hycRLELltX892w9pQAZ
	a+sFs+xd1/rosxO16UgRv0oPRY6iCfs=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c6f21c2d81so223540085a.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771611871; x=1772216671; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oCzQRspACLmQoBZ/bTk/LrnZL7VoOC9zA/xIvIg732Y=;
        b=HkfI9TBdK9VkssJnqNwp8Di40m2EHjaTKVSnwlXjF86JxZVmomYYIRD3oeM0A7YBXp
         mbiBZ9J4EZzXAiRwnXeSm7RKD9/yitx8ugpC3UVep0rv2v66q3OIdDGu+jednR49oh+y
         BUclYvb9AmvVWUfC7IZjB/ijPDU8b6ByzbT+4I5hvlBqdaEf8nEccYcExYGoGe/i9Va5
         MPpLqYtc4yNEhWYMdDWiGkdwBXcQwkE7AQgZhEtzSJesrsWbSZuEjDOPzLJzkR0JA9B0
         JG3lJf8vsBqt4hihN2dqoBkXuEK5GljKEKf918ptXb5CtEvpU7Szgnw7TlmAwWeopIh5
         s9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771611871; x=1772216671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oCzQRspACLmQoBZ/bTk/LrnZL7VoOC9zA/xIvIg732Y=;
        b=i5UHRwufEwDK/0grqmTSmqZGLVPkeKaST20+HYgKGQR1nO+ySwKO6N8TgUzxczckq/
         j6l9XjADiKHqNSgohfSQBzn6OsEz7cDoTf7EqiKQm1KKaplHGDFRya8gMATIVjYkUEho
         SFxGK9CHZglNgF8/uwvwLgKC6pMDbeJw+tETBg/3oZ+CFsfn8bEfttQ5D2/V52OYDkKg
         Vng2oVzzsNSbsC4KLSXPSJFVQJCX4awo097SxTbnWt8epElHiX00OWC9bqv7IhlHIFuz
         Ei2PVjO3uZihfFS67pQ0B7FTLb/BCY493PnRM49vK+M14t5vBydWi9o8GZxvTQ/hD5kg
         B4Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVYsr/hmcrFsvxJcYt3CN0Dqc9M/bwgA6+eVp0GgNJrGrBQVq8PQ+/pwaT3nqw6WusUfQ0IQTfwOQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+9Zwj72C1mpdpRpJXaCCdva705P2K+mMiwtR8lageMTD9EIh6
	8xiJSCxXR3q5i4ADVMi8TrZUMGGiJ2MgYvxZyNRolI8UGqyOPO0OTSwr6+LYGVHQB8k=
X-Gm-Gg: AZuq6aJIaM6NmaTvBofluDQ1RbE6i9xJseNrawmzBzgZT5t+4IWyYAcg1ns0+QaAJyX
	03V/wrWmeWc9pt9N2HoF7NqLLetVvYT2G2uTM0QPM80sokeqnaZFPNitzt7joZlrRAAZ8NSRcac
	w5fhwKLR/YeAs9ABjeKacsaydWP6WH1aVafYDUxyIYN68Vae0skVx1oat7PHDEdHAmDW4MF53ui
	479i6Ppj1LgAXr1xMiZk+IOXhAC6mopxroCOgUKZbJOPFAcR8zpG2C/tqBAi/7hPC0+MmFoIdbV
	/5pbCi3mMliYupa/f3dgtGa2h3r3GRmb0hYDQlHE4iBbQajqxCheigpMp8ThGkg/McfxdKGLVR6
	zg640AFJwT7MisQv8oEuwe5DIJdpuZmWWrcB8hcWkxwmx5raz2dKR29hvJH2UCTJNSzZFFoWz0n
	UbGG0Bz0ffA65vtlx4tXmc2Q==
X-Received: by 2002:a05:620a:371a:b0:8b2:7558:409c with SMTP id af79cd13be357-8cb8ca14b43mr70053185a.36.1771611870954;
        Fri, 20 Feb 2026 10:24:30 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d06f422sm11687485a.20.2026.02.20.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 10:24:30 -0800 (PST)
Date: Fri, 20 Feb 2026 13:24:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <aZim2hT0nNjcRYVG@cmpxchg.org>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 21B791C0008
X-Stat-Signature: yp94hfcyywcwi46wrte1iznoeuqhheg9
X-HE-Tag: 1771611871-768185
X-HE-Meta: U2FsdGVkX19nRwGKBNaaeMxqXYlMO8Ey2Htm8FV1Gp9wsiT9pFZC4/TOYFaLfcdkTCPBUQMQnuu0zgOF4AFepZNeXaujSUu16AZnxDNuAaIMDf8YIMxrNFHuhggnvOavzzm3UmOX+LEyZ5DWc7MsmfVE5paO6eaUgANhRTTo/zzQQvhZWEBn3aLju5AL3ANNWYVsYdXVx5+wUCb3n8JckxdQSJFoSlzF0HuEnAxsBoGERXT7XcFxx5tGJhG/OH5YZQ15gIONEOOW4jndqm/hWyJHTiA0E2+4uGeq4Fjk/GqUlmLyz/NhaJY1ClmreKjUibkixn1AnInqpEUstsBIbAo1Q0TIX2nAvJKfIwvvY5pWUS1e3ota39XGsnnozDyx+YhSdmDpQ+gt0q7nY7eFkrQbi4DwOoJNA844gVuaT9eIjv69lMkzQkYz/PBe6OcU8u2f+GSObvCHL/2vqoZ+7escu9LtbCR1xBtzBageecAzTvbnzsjpS/sZ78ksTyb8DhDbvhM2acEbYUc8cxv8JG4ztCr4i8xGGJgNpPDIpcSS4GS0eFVwftZZtIlcRdbOuyXttQG4B7BgLOwr7KRyU10+iw6m5myN8UQO6glN0Ner5fnLoVO9j0LsS/Ww6++TNlN8JzOFlvL/GYuyEgib88EQBRODSd9gV5ziSm9aa4M6uHx0YszSms/PiMAF97Ps1hHsOdZg8xRPExJQ2jOJ/YEyv+bI3F4WpIoeeamJ/EB7VzwxqfhGxaG09HxCVCfp4h5pIux11GSymT78JCBcDmCjjn4Vu4yRPjQob9Zip9Q0gNRhRLOMz32IBA3Y+tHHBmAFw5pk4DTZp39SR+0rA15EgtgX9YshXr1kvETnFke1P0HdoLy0DGosNMoaZfT4PCjkLYJ8YF6vrli7c5GSQg1VeCX85I1XkwQYD8U+x99XjLdLmEYj5JKJX8swyM4UYOq5TR5wWZondeP7vbr
 E31/7u3Y
 FRro3/kE2/RWLtqcj6Y2zRgch04WvSxPacGuWPvpfuQECD6/Fg2t4/RNnhFb8aBFdd9p7LVRbGZOFUq19gGjKTODBU/fZ6rJI1ETGCqe/9ZZ3grTbrEQnqZZXfSjT03uOhJLC9wCJZxg+9fgBjjNWMIwXxjR7E94GxfOB1HGqdu4V3qY+1KMnfROM7gBpwmIYwDc9jxUjcTrA9gNEV8JD4bt9wVijBFgETeLbXWuMmyY83CrGYfilmtjc52snP0TUy97KhAadjcNpkMl3k0sB+pp/Hla0XuNMk9zwxe9aJKy531Ewtry623vyuFSXAbDqmrWlWY/s7peTd9NgDGHMxCVFn4DfPYO2NLsUD0i0SbXat6vR3km6Y7dAN2WmSb93SU0sT9epQhUNEXOgF0Me9Wpdbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> Hi All,
> 
> Apologies I forgot to add the proper tag in the previous email so
> resending this.
> 
> MGLRU has been introduced in the mainline for years, but we still have two LRUs
> today. There are many reasons MGLRU is still not the only LRU implementation in
> the kernel.
> 
> And I've been looking at a few major issues here:
> 
> 1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inactive
> LRU.
> 2. Regressions: MGLRU might cause regression, even though in many workloads it
> outperforms Active/Inactive by a lot.
> 3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
> /proc/meminfo.
> 4. Some reclaim behavior is less controllable.

I would be very interested in discussing this topic as well.

> 2. Regressions: Currently regression is a more major problem for us.
>    From our perspective, almost all regressions are caused by an under- or
>    overprotected file cache. MGLRU's PID protection either gets too aggressive
>    or too passive or just have a too long latency. To fix that, I'd propose a
>    LFU-like design and relax the PID's aggressiveness to make it much more
>    proactive and effective for file folios. The idea is always use 3 bits in
>    the page flags to count the referenced time (which would also replace
>    PG_workingset and PG_referenced). Initial tests showed a 30% reduction of
>    refaults, and many regressions are gone. A flow chart of how the MGLRU idea
>    might work:

Are you referring to refaults on the page cache side, or swapins?

Last time we evaluated MGLRU on Meta workloads, we noticed that it
tends to do better with zswap, but worse with disk swap. It seemed to
just prefer reclaiming anon, period.

For the balancing between anon and file to work well in all
situations, it needs to have a notion of backend speed and factor in
the respective cost of misses on each side.

> 4. MGLRU's swappiness is kind of useless in some situations compared to
>    Active / Inactive LRU, since its force protects the youngest two gen, so
>    quite often we can only reclaim one type of folios. To workaround that, the
>    user usually runs force aging before reclaim. So, can we just remove the
>    force protection of the youngest two gens?

[...]

> 6. Other issues and discussion on whether the above improvements will help
>    solve them or make them worse. e.g.

[...]

>    Can we just ignore the shadow for anon folios? MGLRU basically activates
>    anon folios unconditionally, especially if we combined with the LFU like
>    idea above we might only want to track the 3 bit count, and get rid of
>    the extra bit usage in the shadow. The eviction performance might be even
>    better, and other components like swap table [3] will have more bits to use
>    for better performance and more features.

On the face of it, both of these sounds problematic to me. Why are
anon pages special cased?

The cost of reclaiming a page is:

    reuse frequency * cost of a miss

The *type* of the page is not all that meaningful for workload
performance. The wait time is qualitatively the same.

If you assume every refaulting anon is hot, it'll fall apart when the
anon set is huge and has little locality.

