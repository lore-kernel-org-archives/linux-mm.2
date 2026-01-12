Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EB3C9EC92
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377CE6B0088; Mon, 12 Jan 2026 08:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330446B0089; Mon, 12 Jan 2026 08:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E386B008A; Mon, 12 Jan 2026 08:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12FE06B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:57:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E332160281
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:57:31 +0000 (UTC)
X-FDA: 84323464302.25.8A4BBB1
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DE1114000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:57:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Q/pDMgmV";
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768226249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojfjuEZT6516dXGjj7cFzWBDB5vqwECXd9Bz2SUP+mg=;
	b=Q/y9kQGD43lMzn2a2MI8EFtQwY4sfXoUj4WcoNIqGXVqmz+nAxwDMdgiLRLCt4659/89zw
	sqXsNg4nl8rWidykx8xwnj8JPo4n0LVl/PX73a/64OAML6Z1lFsq0BDT1ww6P05B/OiXic
	bXIZoA1Sq8jYieGjKnEmzr8FoZhoD2Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Q/pDMgmV";
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768226249; a=rsa-sha256;
	cv=none;
	b=1jHyqqgy+B0reZk4eWiMx2uNknQ1ZR+sZa6fVx7Y9Z5wO+enVqxKiWabcwDKxpbZ/Ey7Ro
	dX8frnBCVekA+JWPOgFLjYyOTt/sEZDrWi3f6bnWvPU4Ov0LeOjTkKpMC+i7hvn/JRYKoz
	NLMzohHNSn+aBVBZpFtCmQgBKsY4egQ=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so44236805e9.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768226248; x=1768831048; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojfjuEZT6516dXGjj7cFzWBDB5vqwECXd9Bz2SUP+mg=;
        b=Q/pDMgmVbHtvuUIWhXHE1oKE4sLR4OMqDvPQCDobwbfQXveUpqsKo9rYvs08yneQRb
         HYrn3Bc791kTMayseH/EzI46yxOVVbk54rLtHprh07wOrSsPhBxunGkrDCriGEs8hVbB
         hfVdo+nK712QHM8qFb3l0q3UwN9lx3ktctFu4t0xAVZaVcHOB9U9XJ58ms63g7fRIb24
         v5yNx1AYqz4GqdgxjZbQ3A56cuZ5bNrvLhVPndjM7M+XPl29f9rsBTpGtZijHhh4EsWr
         3JyjbOfHVMPi26xxuNSXMwe3LxJ92RjMyl7f3Fq5CyYCCfZEI1vsQ+P7iO8pgUOrtS1e
         jL3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768226248; x=1768831048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojfjuEZT6516dXGjj7cFzWBDB5vqwECXd9Bz2SUP+mg=;
        b=MEfBYmP0IjHHpJw/uMOP35Ac8zPUpXfRICWmuVHMaNnpLlQDTiueabsj/lV6KXtKur
         pa4sQir4cIV98lDvqjUCWZuP0JZ5Ch6tZ7YwFJ5xexRK9NxXwn2bE6nYseMmmrsnHoNw
         nCnOyek5U54O5VKyr/xBv3FlJ01CC5M2coIZzX3UdVL5EptS8EKQL2xX8Gh97NJloOvo
         R48jesHDlrBwPEDVGZ15AJc0Q8KBj9I34qFTgDBygeNRdVzafzK7A0rAX4ayrSb39Ve/
         eLxgKn5NLbp3OxjOBPl7Re4DePT9V9kanOe2LJKkxs6M+z7HlHoVspX0B37kK6qwtAiW
         nArQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHmsI+QMW/d4++lxbyg4HWrlj6sMpDFuC0V1XcrIs5w2tc6cuLICXl0SU0IiUw1/x0xRoh5Vxy4g==@kvack.org
X-Gm-Message-State: AOJu0Yx+mn7CzsdOl+Up5aS/r6USzarH3iqhyBYDvwiFjoW3A3dy+Sd6
	6YTbinnK0NcD2tdTSENzbK6owuNGve9eDCnTWfwTC2PlFDsXvaf/o2gV2qg8NftVE/g=
X-Gm-Gg: AY/fxX5OCkmT5sACyAdY7aB+FAKAbcylMI0iQXCDToFZoBByJs3tbW1L6d/HOp9WoIF
	dF0QaPrVnzqB/MW/3PfzJt19ILeHZXHtxOvzpxmi5LzWw5VfBJO4rMznqG7sbcpzbPzOnwcgGMT
	RE7KwRQmBdOtkA1K/xd+hGvqTWD1KpqkJNHCiYe+gQMsSfA34ZAO8JGs+cB5RdxC2eZA8dR6Doz
	27GWlNePt6ZhyRvnVDgtZNUktjBHV9I3+D0Oz7RuZ/NmiW+HEfzaBXg0EI/4g/lr7dWcFYF194g
	zUz6y6YVvk89AAciFS04x69vjxnjWZi60hSmMRPR4ZqLy99x8/8B25c4lriCTlB+pGntn1J6qBu
	4P3aerXzmFmbXPG0ty83dB/ocmfIhtXhMIKwMPGUqEPExqGeRXpz25WyS4jc9nwcs50Y2gKLvaf
	8+NXho18EIy6K9J4ctDHOzGKTM
X-Google-Smtp-Source: AGHT+IH29GDIodJ0Iy57eZZOTR2mLdkX+1IGe3kPs2cJRyAcm1ljENQAhNQdsf2vi8k6BuFrEYkAGg==
X-Received: by 2002:a05:600c:1f8c:b0:477:7d94:5d0e with SMTP id 5b1f17b1804b1-47d84b40955mr197307005e9.27.1768226247504;
        Mon, 12 Jan 2026 05:57:27 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e199bsm38478758f8f.16.2026.01.12.05.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:57:27 -0800 (PST)
Date: Mon, 12 Jan 2026 14:57:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Message-ID: <aWT9xnrRQsvMLVkL@tiehlicka>
References: <20260110064613.606532-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110064613.606532-1-kartikey406@gmail.com>
X-Rspam-User: 
X-Stat-Signature: dc33iw4oo6qjjj8h9qymg1j5qynyk78e
X-Rspamd-Queue-Id: 6DE1114000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1768226249-236681
X-HE-Meta: U2FsdGVkX1+uesz8iwVhLKpnA/a1IeDcAt/E9I0BmWsfV5GnAgtK3G0nHEfcyvTtY6+cTMxltvpLo4KvzYEotHDpXPYzY2jnrqR8BIiUO7mlNL1EQmwkpj1Xjwxo01zTh+7UFZbSrmLqyYYHM7jQrPPMPZ2MBDxqtPTYOAHa/2r/t9ws3bcWa6Ka47dd9EJBc81bwN6Iq8QeFhEGUbMBKEdCKFR5hM7IlswnogOKjwaqwuvZZcbWaUkDqg6CoVQUghyb6d8qHphZMKA8okbX5w3P63MpnEBuNtySJcDoSyM76WNMulnemMl7h2FjXuCpN2CJCob160UgeWGfmSgM4Y0zlBNaKbQHCVO9e1DgFjARlRRSNuVgP4FUzZhTEMFOZmj3Cy0gOlqJotvzCvctganuU8149w5SSz4jeLFlVd4cFSw+lbpwcMBGwsAi0BLnG0BWqe8GRnmfUIt1dc964n4PV0Vcmtt+ssY0NJhxeWcusve6rl2B9WVVf+TQzcT6I0mK7CcqJXl1nirv4isvGnOnhKYdVws4BCuG9K+57Ygpvmeo0Y0vZGPJcci/uAj0k9oyZQHJuFIBcsG9A+ozY8PKxHM4drQ/Wac1+kzVC5z1k5SdkmrpqMDoMdCoswGJZtnLq7dM91ZXs1wLqblilCPiAa4ZiS67QTGcoJA6hfHDxNksnDH3ud7bDCvO8QQ5DbEHOH2vF/KXF7KJCTSZvL3qSCdjG4y2dpl8PWUbFJEqPyPZeQfDbG5VyhvidMF/17t1cvGEbGNppzMeJ5JcsQz37KHRbYJqhFF7aYjjp0WgxkpFtOPfON5deowxxMXpXLgrOzTRqXrRErpLA211z0UBicuZM0LDVHCvtxBmi9+I/kOgijBzO+hf6c9M9UPbNf7WTAQKIU9DCK37S+K4CDD0pUWZJPrBupYoYwdWBWOM29CRCfqFUROHd7DHPW6hkYTFXgIYwn3O4BS9bPb
 4MjMYXHu
 aybRnWkXFZkpwKAB+YS06WUlAGM5RoCLeQr93PuatTi+Rm9PFGvPxQgIyj5M4Sk1ndLTe+Fw1RHpm0NKXmhWnm1mQyWWIsGAAa/GBdJAb6nnQon6V91pRBeveMUQ1BRoVNulW8XpK2kR0bBpgzd82PIaXbtKKSrc1FuChM2RLWpw99esAbCPHEMbjfBC/j11K8i4u74/EEIW6HJBm8T16+lWDMndSSJXCJrn8LtnQFBzHFKs2PBCcJtKlGJEv28NTP7aD4Rrleq/Ag5HkhxFhbGaHJmZtmz7U82NxnPfpQ+2D5mgY5EMuin5h+FsPHwKXSxNtab6uByFeyQXqFB2Bv9vATVhXCwjWLeKGPiNDU+avEEyxqOSY18DfA1jmCRQgmdGtRz8GK0VikIgquwvyHQPdJVfd+skz1gI8TgH5kZ3nzSFFxQ8Rx/54rPRBL06uIlL1b9yoFmq7t7rO/G/1KSU0698pTDiEW+5gwe53+32UOjq36hqruqiLtiGKAmF4bmNmjlTIVuS/g7AYZcNPKpbRdo3OcAQBy54cuEHv+qI11y1S7fI/ei1tPo62RJ2II9HsmMHASxyGCCJ65pgsSaSW58Adx/S7ppCKr41dAJZ6UcWv8fCr+YFZRNc/lrp+XCLpSbeo8enUQ5Xbj3+KeFwFqiXEQf86d7WqvxlgcGaZcI+nSi9ulPN94aWc0PIYMhv22BxzaUjVuqL06URgnCtt1PjDNQrG+S67
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-01-26 12:16:13, Deepanshu Kartikey wrote:
> When using MADV_PAGEOUT, pages can remain in swapcache with their swap
> entries assigned. If MADV_PAGEOUT is called again on these pages, they
> reuse the same swap entries, causing memcg1_swapout() to call
> swap_cgroup_record() with an already-recorded entry.
> 
> The existing code assumes swap entries are always being recorded for the
> first time (oldid == 0), triggering VM_BUG_ON when it encounters an
> already-recorded entry:
> 
>   ------------[ cut here ]------------
>   kernel BUG at mm/swap_cgroup.c:78!
>   Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
>   CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted
>   RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
>   Call Trace:
>    memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
>    __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
>    shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
>    reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
>    reclaim_pages+0x454/0x520 mm/vmscan.c:2245
>    madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
>    ...
>    do_madvise+0x1bc/0x270 mm/madvise.c:2030
>    __do_sys_madvise mm/madvise.c:2039
> 
> This bug occurs because pages in swapcache can be targeted by
> MADV_PAGEOUT multiple times without being swapped in between. Each time,
> the same swap entry is reused, but swap_cgroup_record() expects to only
> record new, unused entries.

Shouldn't madvise path avoid paging out swap cache pages instead? IIRC
this is what the normal reclaim path does.

> Fix this by checking if the swap entry already has the correct cgroup ID
> recorded before attempting to record it. Use the existing
> lookup_swap_cgroup_id() to read the current cgroup ID, and return early
> from memcg1_swapout() if the entry is already correctly recorded. Only
> call swap_cgroup_record() when the entry needs to be set or updated.
> 
> This approach avoids unnecessary atomic operations, reference count
> manipulations, and statistics updates when the entry is already correct.
> 
> Link: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
> Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
> Tested-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

I would use
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
-- 
Michal Hocko
SUSE Labs

