Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F50BCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9538E000E; Tue, 30 Sep 2025 10:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1558E0002; Tue, 30 Sep 2025 10:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5901C8E000E; Tue, 30 Sep 2025 10:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43DEC8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:42:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C899913B9DB
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:42:46 +0000 (UTC)
X-FDA: 83946183132.13.0C5C4DA
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id E4D0118000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:42:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7Iuyww7;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759243364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4vkOfyVNOASDZ8RN89wGjL7/WcW/6y/QurTWddB4i8=;
	b=yhM45nvkdWZb9ZvpHwrpWwJzixikhjP1+iFthKtKFOiwzCTb3h3WzrKSdH12z5D9Xq6QGG
	zCxTQ/EBB9FNluvkvAH5D+zqTFPWhmCKe4SETbN25zqAhHJFGlV7a4KxRlZLYyM1e9/y51
	neU3jOdkbDwBdhY8/BVdlgcYYlKWzis=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M7Iuyww7;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759243364; a=rsa-sha256;
	cv=none;
	b=fpyA42SUg7zlruWDtbkb+LDISZ8Lii2DVl3hVmyp3wSctVxOajI+WnDld+vJFkmkt8qasW
	iCWIWoEL9NM0ykf2a25KXNku1OqADRtlnwXCxFlD3MBxEsbHdxYVZcQMDfoxr4H7xykBfr
	YPpbDhT+xxoZ5WtpezrvgqEiWJ+MD1M=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71d60501806so66582347b3.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759243364; x=1759848164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4vkOfyVNOASDZ8RN89wGjL7/WcW/6y/QurTWddB4i8=;
        b=M7Iuyww7bVhYCoyURrNHBvLRgxSCs6HwdD2lugsh2DPQCH0+vLRNu4u/DI1M6im8NV
         XnIm/P07eydE0IdUmu7Vk7fc7nYNPDf2J8VVAgTcADBhQ9Jwd/KLnZvmefY+R+cElk52
         9c4dTn/CwZyUGrxefDmylbnxEGRett/hj8z9JMQJzhjcvZCutYSZv8HiSiDBzJFqQ0Y9
         GVDpjz9PIksP+ANzGs6NDLKn+uEL855qiyk8ZtV5EF8tS4gVmLnBu+wd2j9b51M4QuVJ
         v/7XpB+asUiEyMyl1RlLGfjzwgG7iS2KXxOpcdiroInKF+vTzGEk2Q7/Y8PNavJQ6YiZ
         vT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759243364; x=1759848164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4vkOfyVNOASDZ8RN89wGjL7/WcW/6y/QurTWddB4i8=;
        b=LqaRdW/AFaoIW58SW2l/Z+6a8pfpfMXuNgxypW8GgBDLanNoSVf3fOsbnnmjZLLdk/
         L1kHJPxm3a+AoLny6drUZ8Fqie+tKpGMD0xWBpUYfhAEpHQwNXRZCMx89HfBtYnbFNAA
         cXzhO05XGqTdwBNwEOdBucAz9UUi7pPsWeqTW7e9kGolpgNnX5zfo0rjbr58vbVB/76K
         hed+axRHgephRQzrzu3Ce8ECcQ3YRVm3PHdF9sdXUkqyUzn1E+mFSFzI1H32LtCYFZfg
         JfITa5GZ85QLYedf5BpxuizaXrfJV1OdrP70+o/9r3lyJZnfaw506pcBe3MDmfxKL8bs
         WR9g==
X-Forwarded-Encrypted: i=1; AJvYcCUosIPwerdADPbCfnp5A/i/7+i1TTaSNesI9DS13/E5ttGiBWBbmDiFODZ/sucjBW8+62IPs2ExwQ==@kvack.org
X-Gm-Message-State: AOJu0Ywp9ggAWWGW97p1CMwXaIZltc1gzR27wt2xaTO+k7G4PgKHCj2i
	/8D7k0ACK5a5rn/XFXAAKHggtFJrdljUtLKrXvj1uqo9RaiaFVnVMf42
X-Gm-Gg: ASbGncu9ABUqfAVot/Rd509it4wZz1P3FEJlMqB2EkpPbRdDiol883bmsgBl6V60LvO
	bVjNKYk0Nm/MAq4dBNgb8sDJx+GfeXq4IM/y3+4rKIN3PYB6IunUgBtWvYe3jYw1B1FnmY1STNj
	5bOb1juD8eM8oQGvsPiRJMYx/FZd79cRxmWSIz0hsY4RG9Ha2AvZKtfoOjZ5y1CV8pBqhCHU0Un
	Rd5QXva47AOfjHgqGUosBXXKKBpkDyqp+LyREYqZkSxPB3nfTj0/NmSJ931ACiDEzLetUzLiBpp
	GzMFLYlI2LghWz06u400eAEu2Y7qTtwfAiVRm5OKJS8r4pAfLw3GjqXUtmidlbM5JGzCq6paVW4
	XJLyqY1TboteL9LFND6S3/kbQpL81H1+5UdS/NemWk5OEeMOX2zaCjLwD0cvKAgfH1jrpcHiD7v
	5xHdj/s4AGHebZ
X-Google-Smtp-Source: AGHT+IGFLbOdlIoJsKWFhzJr3Zr9Wq5OWyduoEy3LIKVzEZc048bz/UdbN0acRubA6Gf2aLu+Uui6Q==
X-Received: by 2002:a05:690c:e18:b0:774:2bc1:4aa with SMTP id 00721157ae682-7742bc1130cmr147112937b3.36.1759243363384;
        Tue, 30 Sep 2025 07:42:43 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765c60b7a4esm37971407b3.40.2025.09.30.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 07:42:42 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Tue, 30 Sep 2025 07:42:40 -0700
Message-ID: <20250930144240.2326093-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250927004617.7667-1-hdanton@sina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4D0118000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: c9k59i9g6xam85cpt1hg636i9y5kckmf
X-HE-Tag: 1759243364-490446
X-HE-Meta: U2FsdGVkX18aWEO5uIFebqwghXqkJnTgxbGFGjy88IhtIA0FT1Z1Wf4iMEJg0SamQBMxvKhkXlOXz1TwYhPWxhSuVDojNcaYH+yY6Jg/xKcIGbLX4xJjMNyD4gomVJvIoh3ur32ut8Reg2Rl2BEFY7za4U/3kZQ3zgwWyl3gBf0FDI295mTGfGxeWYlw90rjj90Pg3c5dKrKxxETH6+PTCvSTzvUlfG74ObKiSfQ6cCi3KwCRD4ktcg6RU53V7JQxcl6l38ROi997vvGv8UbV15vuCJ6H41FidllIY8CllM26kK1llOV/JdUTU1jrboviZ888gfL1ase1yvtYZhv5Jm7G+S/O833gVyE96OL7FCR6+fqQXOYCUtX5uMHjBGkuxynb6n2FDd3jYOgVo8cwAuhiLmCSzeZsafRCL+1P9ReUo2wtNkveMsFuNcbZa3hW83hDcQf9MXsJY3YoJw+bnjHHRheowpjZrZxX7LYhFhyvRzFOrgghZzML5QGaZNcvuq5atBbuao7sU4pNDKhJ0j52z/lzrwU8u45bib6DBoobcZphIJSi9v16op6jEcF7NgPAbFUurUuC6BMlFjBdibU2Xu+ydFX4eymj8kdrCL5cryacUzU/UG2rkgValVk/45NaQ4bYwdnDb9i4DbXrLmPYlVBEvKz0GY9aslalUPLjv//QJ8DfXsZ5khERHMFrM6p8PRYUV4O9LY7DTNqHA5XkcVKEuosv7nSVGgYgsz8Qi3ND1nGa6UOh55KELSeS2nqN1E/++eVQgvRTJ5OqaaMXg4zOCp+GxqZ50B1SAA5JDWAtxKuFHrAdmI2elDJKlm0x1Pg1cgW1NV95p7ll31gMIfRJz55XJeJGpsVH5D4/CJw9T98SCmMNrfixN7MxzdmQfcU3/P2l/HgVKTDCgG3rTaDHYXlC8hRft7dHHfK1KBg2KKthfpANbvBaGiFyzRhDXnCxHZxOZh5F5p
 IgV/uWqu
 2rjbewJBHG9BMblSKbzwBc/aVooxvFzufST5dJuL1MTJHbMXihAxNaMvRsI4NtNJslSVJTktVSveW/lrUBZvXcl3NjeJnktn4leR1DQ/FTH4OZ/Zr5XnJajXGXKeb4w1pAu1U8/rNwrDHjNDCLBIovH6K4YvKjNByn6MgMyWG3S4fMcgnxRE8aHzju6RPCUWsre9XTm7OGXvtHmxp/drgSakVox81D+qUjmwLif3S3mwf4rD1DSfPAzL6ColGtgT92se4NlPM8rvOGKdaicmcioYUYpPDrlURwZbgH9fJwcIcMz1KX96r2VK5rRR7JRXbBh2F4EsgfRrT9pu8zXJIO+K101Qjq7AYp2NQsY2cIG2eUr0iWBQm6n2haAK9cKmujfqww5V3A9vwIv06GSFk5smgMhHKP90qA/8FB1moKVMSumdjlHgmDKBSTWMHQ6rZJzN3/3eANhr4epE3ZGKV7VVPSWW4/85oS7JKRoGpEUNuR4vxzBNi7QSC0VA6/0WlhHoK4+dd/qJjXC8LuVg3Htxn4ZVsOXZ1IadUkvMxBLOqcOKHvpAa/qX1gzW98LmZd3RSncxy3UWQK5k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 27 Sep 2025 08:46:15 +0800 Hillf Danton <hdanton@sina.com> wrote:

> On Wed, 24 Sep 2025 13:44:06 -0700 Joshua Hahn wrote:
> > drain_pages_zone completely drains a zone of its pcp free pages by
> > repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> > In this loop, it already performs batched calls to ensure that
> > free_pcppages_bulk isn't called to free too many pages at once, and
> > relinquishes & reacquires the lock between each call to prevent
> > lock starvation from other processes.
> > 
> > However, the current batching does not prevent lock starvation. The
> > current implementation creates batches of
> > pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
> > Meta workloads to be up to 64 << 5 == 2048 pages.
> > 
> > While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
> > indeed can be adjusted by the system admin to be any number from
> > 0 to 6, it's default value of 5 is still too high to be reasonable for
> > any system.
> > 
> > Instead, let's create batches of pcp->batch pages, which gives a more
> > reasonable 64 pages per call to free_pcppages_bulk. This gives other
> > processes a chance to grab the lock and prevents starvation. Each

Hello Hillf,

Thank you for your feedback!

> Feel free to make it clear, which lock is contended, pcp->lock or
> zone->lock, or both, to help understand the starvation.

Sorry for the late reply. I took some time to run some more tests and
gather numbers so that I could give an accurate representation of what
I was seeing in these systems.

So running perf lock con -abl on my system and compiling the kernel,
I see that the biggest lock contentions come from free_pcppages_bulk
and __rmqueue_pcplist on the upstream kernel (ignoring lock contentions
on lruvec, which is actually the biggest offender on these systems.
This will hopefully be addressed some time in the future as well).

Looking deeper into where they are waiting on the lock, I found that they
are both waiting for the zone->lock (not the pcp lock, even for
__rmqueue_pcplist). I'll add this detail into v3, so that it is more
clear for the user. I'll also emphasize why we still need to break the
pcp lock, since this was something that wasn't immediately obvious to me.

> If the zone lock is hot, why did numa node fail to mitigate the contension,
> given workloads tested with high sustained memory pressure on large machines
> in the Meta fleet (1Tb memory, 316 CPUs)?

This is a good question. On this system, I've configured the machine to only
use 1 node/zone, so there is no ability to migrate the contention. Perhaps
another approach to this problem would be to encourage the user to
configure the system such that each NUMA node does not exceed N GB of memory?

But if so -- how many GB/node is too much? It seems like there would be
some sweet spot where the overhead required to maintain many nodes
cancels out with the benefits one would get from splitting the system into
multiple nodes. What do you think? Personally, I think that this patchset
(not this patch, since it will be dropped in v3) still provides value in
the form of preventing lock monopolies in the zone lock even in a system
where memory is spread out across more nodes.

> Can the contension be observed with tight memory pressure but not highly tight? 
> If not, it is due to misconfigure in the user space, no?

I'm not sure I entirely follow what you mean here, but are you asking
whether this is a userspace issue for running a workload that isn't
properly sized for the system? Perhaps that could be the case, but I think
that it would not be bad for the system to protect against these workloads
which can cause the system to stall, especially since the numbers show
that there is neutral to positive gains from this patch. But of course
I am very biased in this opinion : -) so happy to take other opinions on
this matter.

Thanks for your questions. I hope you have a great day!
Joshua

