Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECC1D64073
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 05:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6712C6B0005; Wed, 17 Dec 2025 00:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61ED46B0089; Wed, 17 Dec 2025 00:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D6D6B008A; Wed, 17 Dec 2025 00:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5866B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:17:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B149C05C4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:16:59 +0000 (UTC)
X-FDA: 84227803758.12.0A00C92
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id A06774000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:16:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/8d9oGU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765948617; a=rsa-sha256;
	cv=none;
	b=JJGPNvkQbqUkkm+cofszmBIsQoo//MGY9IvXpG+G2HgGG7HGysSwNXFOB+CNGxdZyLp+kS
	HdlIQBErewW/r3H4zOZLe6EM/dGZPOyZyYiWn9SLudPwJQnExBvoF6MmRpWZyDSIuKpT4A
	UnPSNfKpD5vWweMm8+klWKtVINYhO+A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c/8d9oGU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765948617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3U4fucPIwa5C3A7mTN8iePIKa9pv0/tHUusJYkp2+Y=;
	b=DRlv5oiACmcSXlycH7OCJAfziAgbocoK15JjjDnvM5Xnv2KIerLJ1wuSYoEEIiHQGVy2ih
	cCDqOe7DAmjINWYM1rEf9uUBS7KcezR4qNcTQ3QEvDoRfm4y9u/+sAY1rPPfpgE7U4saEZ
	Zps3/5fbT/sLkpX8oUlfVYYJ3COpo4g=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6446bae1e17so4758332d50.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765948616; x=1766553416; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3U4fucPIwa5C3A7mTN8iePIKa9pv0/tHUusJYkp2+Y=;
        b=c/8d9oGUhJoSAwgfdq8Vwh2u8SyufT5iaJVt4p+VCbfZ9xR1+sB3ZDGriPJh2Xb0/J
         5SA8SC6AfwnPNIr29GnEcJIOTif5iPI1u6DTifHIWdHLuYKruxMkd3szZHJOdhY5WbRL
         9Z3jNdVx3mJtO8cX/2srUmIw+vK460ampwgB/xEc8wgbPT8JDFj0N2zITBqLAD7K8LQd
         KvcVIqpYcqt5sAAU32icUgvGjHa6r77ClHRk1Jyo+EKH0HhvfLMYqb6Efh6v7pMtKq3s
         VP/JsVkbInv4s6w8xtewkCH2VQl1UIBcQlnbFlfs+28P6o62u99bGoDQvIC2aggpMo/c
         HuEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765948616; x=1766553416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e3U4fucPIwa5C3A7mTN8iePIKa9pv0/tHUusJYkp2+Y=;
        b=NCNxlDUSoF1ocs0bDjIAjffIggjGeA7dCQ18MHQGb2256jcVH6YGq3aBUxMYDlSrQ0
         DfRYYdZmwylB5hbw+CxkKdfQZKoLoRZiWMDmcvP7/UZ+diRm+TjIxWg29ZzO3/5v69Xi
         9IEn7Retac2CLxvpD5LOrddCITxqm5deQCfiDSu7ze3rofLyIDZ1D3ucFKDpASpC9BSq
         vi/lI1Nf52pNq49v7TnnVXkM3JqB7Q/PY8DxbaWFfoEZrRwttaXpn5HimIZrZTHEhZpT
         PuCVn71v1ijfy872boTH543UfIBG1NJLzCbQUEsMb8vEreqhjthopOooU/D6ZyLy/NdB
         R+sA==
X-Forwarded-Encrypted: i=1; AJvYcCV4A/948rO9eZxEK0RMlEPEX3CloB+lzlYsUQDhHO9LckEsWn8dV7KOGpl3Q7ssRWlhRls08o8w5w==@kvack.org
X-Gm-Message-State: AOJu0YxQwsVxfSzdGWFzqCktZ8ZVH1TxBguuN+4m7XTk4jPowh6WRQru
	ogGO60X9MagSLD+To+LhqatX2B8jEFpKt/fG0CClrWilD/cxpXVOLfF9
X-Gm-Gg: AY/fxX5U+D14UgL4iz5lKN4JbsVNS7ACoDr6P+SYD8IvnJCvOqdN+mEfGJsXOD+WyMe
	BC3xOKHMQCmlcnPP6IpZA769LNsl3zJO+LtkxzbhoMPl30LRW6CYuKwXUnHXlr1ou1TzSuqGLa+
	ctkMsHPY4p3hkKLn59rz8tW7RP7GUIsnuTmLOWSuVAIGQ1zAAAzx00MZ/9/PhCkB8fklGPSfKdh
	YB6jGxZ4tT/MgQXWRthZUmdQEOS5/dBIolDbc9wl7oH4xc4wMe2CBsDNryUKOtfnpupCdYdIp9U
	Xx0CJLW6mTRqrSR1tnQC0Yy3k/NfsiwQly5H0N4RETnVlRP3LjbKYOMkCqjJWE2SHWYDBjOB87g
	FYaVwTZOiEVGqum+rPQXIxQBv07eSEGDRtMGfrXxml4gn1D4EgimSjxZii0tnVpwPwkunKoIsJP
	oe38Sjyio83dSujEuAIGEkJA==
X-Google-Smtp-Source: AGHT+IHl6JmRY4pmU+6aPgmZru5eursIsfwMpCPv4j6lmgmMPRhAD6OhtZZX534fHOXjHyU3LGVXxw==
X-Received: by 2002:a05:690e:16a0:b0:644:7b59:4216 with SMTP id 956f58d0204a3-645555cda86mr12968997d50.3.1765948616522;
        Tue, 16 Dec 2025 21:16:56 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:52::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477dab686sm8555903d50.16.2025.12.16.21.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 21:16:56 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: Prevent reporting pcp->batch = 0 [mcf5208evb boot failure]
Date: Tue, 16 Dec 2025 21:16:54 -0800
Message-ID: <20251217051654.80355-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <42143500-c380-41fe-815c-696c17241506@roeck-us.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A06774000A
X-Rspamd-Server: rspam03
X-Stat-Signature: 3c6p34d4akc87zhcbwz6bwkg7exbkwk9
X-Rspam-User: 
X-HE-Tag: 1765948617-566291
X-HE-Meta: U2FsdGVkX19u3wyjDNZAlt9D54Tf/iZ2iVaHSY82GbzWQOaBqtLNGoQFz2yKgeif0AEoIXek4e/lnOAIKJblI77LA0rAdQuUIsz3YS3u2cN8tjoii1aWnovTGPnccjzLRUXDaISEgXIw2Upl4UYdA0HO6HqiwYbaSBglq4I+F6/CHG/gNUv0il1EDpRXiSPJbLfaMaoo/jXVJFXAOGlrsGvNfP6Nmhq5lYSzDirwdB9OJ92Wfjxptf1+5KivPJE8Ybi+8AgwXrkFioINc1kIvTdmIc0mo84H5+/KD33WwRKG1g8nSkm296UwDAMNv7ueJN1/mtwVdFGqoroQKiXTB3YB3M7qhDVZDIex+Acyg/+myjMFF3uDMIbSbIQqRYhF3B7lfyrZdN5sE5EDc+8V7Tdw3D+qtKqNwZzQIM+0Y70vaDcT/74bV1E0+lhmgC7DrqCFk9G7WgtMr/Z1fyboRb6x0YORUFnAc72cABSxVsjV4j++mdlroN6ul1kTXnQ0UnVOjz0c8r+hcLMncUipGFxr6jw0y1JBTnwqhCNly7seQrZpqPloB1w4uQsOlCKZt//9ei3IKxm7JjV09XBOMvJrlgLk4+OUwX4aO5tGHveTK9dJeD1TUpXEwXE8SKG2SOTJZ/eK6q1AmrZfW7AOtlDz0wpjYGxB7hKY2esM+4Xhb9ppTdjfVeFt7XQ85EQ6egRAJHylUzAIsNWF9rGEfTwkYDVxwX+vuIOx9kw4afBpeawQ1lcSZMDDZApCIrvmvPXxLRtlxzj1vjc3pMpt3Kr5E3T947cfpYmGQLMzu+ZSnP75Heu4JZL1OeRj+CP3cv4zpOFrBFWptX0B46KWV7lbQB7KSSc7bTNL2ao31JhqAfx2jAOEOkOyKi/M39URkg7MM7nqNP0hzZBPhyDg7fZV0OyaoewsP2hLYh6hCg5JT6sMBfYV/kcY+xXAV1EOeAbcYBjB5cnYzkVoIaQ
 Vb31iw6k
 1uFTiTWIRH/dEN+OkQALquWAcMLuLne/Faz5b9R3rTToTbY+LjdcVD1mCrhJfs2hIme4+Ny4L5qj7hioQIo8fXJMcQ1ZRMQdRaMve50oDvkwv1suZ13bT95uSRlBFq5+b+0iGhe6c3+Mwvs1Jqojlm0p4uydWiHbUopI6HaE8DN4vlP3jhyJek8OvAhEcJgxvbsIDmrZnWvaT900AlObMtKOnAhan3LqxyuR/IPdZ4+wpdEfb13NPMWQ7yoNUv8b0Lhg9BGwZcfhCt32LmShkIBwAzwfesEAb5Jx53DRk9hsEMGayK7In4xFpITLmVywHWbXz2vjFSvTovxA9DDKtfBqNzixI9y6zZU6Jr/YQF3wzrNT37xo+ksNTh0qyaNZ2YHX1zFouquYPAhkRYmqQYmCU5aNEsXNyZEOSU4CqlZ1ZASDfaWmuKUJcLWjuum90VtUza35EGBtC4sZJQg4Z448YCHQLSnHHlagJIjGnFAjZCVIjIf2cvdZ0IVY5+kCDscylo2Ddr/abMbR3+g3nOpBGUgH6+X/m5JExNzsfttgS0SFnfLy2/kFnICT9tHMzesiJhe62FT0FzRm0O2so2TkBnkjHeuK1qQBj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 13:47:03 -0800 Guenter Roeck <linux@roeck-us.net> wrote:

> Hi,
> 
> On Thu, Oct 09, 2025 at 12:29:31PM -0700, Joshua Hahn wrote:
> > zone_batchsize returns the appropriate value that should be used for
> > pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
> > 1M, however, it leads to some incorrect math.
> > 
> > In the above case, we will get an intermediary value of 1, which is then
> > rounded down to the nearest power of two, and 1 is subtracted from it.
> > Since 1 is already a power of two, we will get batch = 1-1 = 0:
> > 
> > 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
> > 
> > A pcp->batch value of 0 is nonsensical. If this were actually set, then
> > functions like drain_zone_pages would become no-ops, since they could
> > only free 0 pages at a time.
> > 
> > Of the two callers of zone_batchsize, the one that is actually used to
> > set pcp->batch works around this by setting pcp->batch to the maximum
> > of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
> > incorrectly prints out the batch size of the zone to be 0.
> > 
> > This is probably rare in a typical zone, but the DMA zone can often have
> > less than 4096 pages, which means it will print out "LIFO batch:0".
> > 
> > Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
> > After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1
> > 
> > Instead of dealing with the error handling and the mismatch between the
> > reported and actual zone batchsize, just return 1 if the zone_batchsize
> > is 1 page or less before the rounding.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> With this patch in the tree, the qemu 'mcf5208evb' machine fails to boot
> with memory errors such as
> 
> S01syslogd: page allocation failure: order:7, mode:0xcc0(GFP_KERNEL), nodemask=(null)
> CPU: 0 UID: 0 PID: 34 Comm: S01syslogd Not tainted 6.19.0-rc1 #1 NONE
> Stack from 407d7ce0:
>         407d7ce0 403df960 403df960 00000000 00000001 00000007 40027c60 403df960
>         400c06be 00000cc0 00000001 407d7d7e 400bf614 407d7d34 403df3ba 407d7d14
>         407d7db8 400c0e5c 00000cc0 00000000 403df3ba 00000007 00000007 00000cc0
>         000d8000 00000018 0000006c 00000001 00000000 40fe6640 00000000 40fe81e4
>         403ffa40 4085eff4 00000000 00000400 00000000 001008c0 00000000 40854041
>         f4fe0000 00004041 f4fe0000 00000000 00010000 403ffa40 4085ed00 4085e800
> Call Trace: [<40027c60>] dump_stack+0xc/0x10
>  [<400c06be>] warn_alloc+0xdc/0x1bc
>  [<400bf614>] get_page_from_freelist+0x0/0xfa6
>  [<400c0e5c>] __alloc_frozen_pages_noprof+0x6be/0x8be
>  [<400c1358>] get_free_pages_noprof+0x16/0x3e
> 
> Reverting this patch fixes the problem.

Hi Guenter,

Thank you for the report. Daniel Palmer has identified an issue on NOMMU
systems, and I think this is caused by the same issue. It seems like
mcf5208evb is also NOMMU (arch/m68k/Kconfig.cpu shows config M520x depends on
!MMU), so I imagine this is the same issue that was reported.

Andrew let me know that the commit has already been committed to mainline
so I'll be sending up a fix shortly. Sorry about the problem, and thank you
again for reporting it. I hope you have a great day!
Joshua

