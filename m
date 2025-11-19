Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9680CF3959
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E45E6B00B4; Wed, 19 Nov 2025 12:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494CD6B00BC; Wed, 19 Nov 2025 12:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C7E6B00CC; Wed, 19 Nov 2025 12:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13D9F6B00B4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:11:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB59359874
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:11:33 +0000 (UTC)
X-FDA: 84127998066.13.952270C
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77BEF140016
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:11:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=NYmJ03yj;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.177 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763572291; a=rsa-sha256;
	cv=none;
	b=FmqjWa8a/LbFQESzPu9UWhzL88QXvTtfV0/imUDARsqRWIC6LHCFajoit5fCTXZIaIiaRW
	Vc76d1pewg9UJ68AlYonWojTJbZAWQaELmN7Eq/rHPfV5pH8V/g50YfF9e5GiG4gUfcGjF
	C/vjhHC7Fkv+3eLLnCOwxmTjVNwadC4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=NYmJ03yj;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.177 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imxsq40OzA0Ie9nuhKfzZL+VMvsrBqdZdMB6IgBRj7U=;
	b=7qeMaxOp1W4wf2bW9l/mbvqs4vBVXrmiiYarv9QVgltRciDEBU62RszpRiKLzWW0JCZu8D
	4vi+NLa/vKu8gEAhwIEkVybYLWugcTfWcOskr9a2HRFYMkYXuWO33b5z4TbSLuEdclujz5
	5BYKguqZk56cxx5nfg/dCjJYr2O5Pbo=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37a5ab1e81fso59323771fa.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763572289; x=1764177089; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=imxsq40OzA0Ie9nuhKfzZL+VMvsrBqdZdMB6IgBRj7U=;
        b=NYmJ03yj29SjZcoids+X4H2HL9tRoRlutezI9W4e7XsaXf2ZV+5d9O3wGpr2poS79c
         hZUi3fYOG036dFRfDqdilaaT+WEXBslcnWaibcPq83aPuQqbdK2F2KyH0rNb6reRt6Gg
         6Mcc8CZTWvXpfFoK+kIOUXb5kG+OqLAxfr4vYVukflvKAV/pYEatTwwwSBqVSwZG/Ps0
         ai58i5WwZ2XZGJzpndfqvgwgv9pk2ZsPyNePA6gJ1YeG6zCPLLhdkk+Z8886a8bjef0Z
         Ou6W2C0HULtG+jvPcv6PHTejuyDa1xHJMW1DRuJ4x9VRyBZjMQd4QL33kOKnfh5/QjRw
         KGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763572289; x=1764177089;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imxsq40OzA0Ie9nuhKfzZL+VMvsrBqdZdMB6IgBRj7U=;
        b=WUBi6+DFJmpdAxsTj/8ZxKDqCTpljFc2MHahXDDJ0W4QpcjVMXxx64FeycfbAShIsc
         3OQAagjqFCRW+jBw9DiwOe4/TN+yx15/FAQzCuig5ebJLTq9ELam8I2woczTEOhqeuIc
         JftNU5azOVnz1WHzrA8v2HHbfYKijxzlFmdUXEs8T56lml0MsRzKmO9Trdg4W0eFJ0NI
         cLdZiiiYR6fqUuj4hqBwS5oq1QChKo02O7w6eQEVd2pFb5X5Gt3b6OFxlve0ZHSW85aY
         fanlvh7NCV8/mhIzIQPiwu4fIWroVJ6Em0lVvxf6qGF7CXx/oBoGuejLQR/Ql0IRBHA7
         x5yw==
X-Forwarded-Encrypted: i=1; AJvYcCX6O6V+cD6LBgC/EUju/iiLbQQS+v1mrLe7hC4MzGYIRathIqDquSiYY9kakfRWSzzHsnu3hm5xVw==@kvack.org
X-Gm-Message-State: AOJu0YznmjNZby0iDXfLn5q7CbpPvFnQF2+MPES5Ex087+siNiXzBoUt
	DmwP3/SsGly8ntP5sc+lUjkaKMXfx4Nq9TRWln4oTHi5eUWfLG0J9mK/sMC1hzhridg=
X-Gm-Gg: ASbGncutoCuj6MSwSbmechEgklsp4UPRZlpbmR4FAU4qibPeZCq22ZrUZvns+kIKJb5
	bHiYe9F1DPCKBP1rkG+AkPDsqViNmZOsPdC6mflB1PcboCLLPwW1sZ/sqRhQK1FkKGrdA3zo3S6
	Sh+T1XvnIVh0qE5jYRPT0umKUCbFQfZgauXAbz3QYCZfxJhp5BLMANk+4GvR8VJa/Vp8aRMBdce
	4jPsQjbLDay8wyfvoC5AfufDJJJy7kC2CrIYaxNwQO4jJhEnw9RDZiCzAwFuxKOy66SKz0P+9ej
	YQUuM2Rn/b/0Bhyp6Ro2aTAFST3zqHFNXCQyTi5DzBfI905WHLwmuR/IeHgtEXbHWpqbPLvy0Z3
	LiLOQgQXF1gG8mDU7tualjmv4v4uKNr/rfzQ3ail0DQscDuNJG1SbiKzA+UyHNJdDdZaqmdGHxe
	2Qa2BBrSgtawnnuDtBatTB
X-Google-Smtp-Source: AGHT+IEH2uVRaoWXxqf5lW4QGlbUReR2Hbmd7c6j+HPcJiq7hqxFbRM9UIfcv/r6AcUVW8EzKehpjA==
X-Received: by 2002:a2e:3217:0:b0:37b:b849:31c3 with SMTP id 38308e7fff4ca-37cc68d1bd9mr359131fa.44.1763572289379;
        Wed, 19 Nov 2025 09:11:29 -0800 (PST)
Received: from [10.101.2.140] ([93.122.165.106])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37b9ce080a6sm42198701fa.4.2025.11.19.09.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 09:11:28 -0800 (PST)
Message-ID: <19171859-94ac-4f41-b100-70a1497e62e6@linaro.org>
Date: Wed, 19 Nov 2025 19:11:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <6c9b0aa2-820c-4153-ad64-cd2a45f7cf32@lucifer.local>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <6c9b0aa2-820c-4153-ad64-cd2a45f7cf32@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77BEF140016
X-Stat-Signature: mjis44czkj4uqxwtmsob1oduuqmiapew
X-HE-Tag: 1763572291-875997
X-HE-Meta: U2FsdGVkX18Qi0OEEhCAWNM1U+MvO+aysHSBs/ybpokNZ9Jx5Lj/1iKLPO1e+ZW/JdzcbopZlGiEF3wo3bLAA5h4c+Sb6L2/eb9xJ+sP3YTh9m1OjCzo+LZ96ZvEFxSSs8zZweQv+nObTQahtluDwLEuQRZ16ZfHuTJ1mBWQTCZ01w7o+MdcET8fmrVgFIaHceGdizO396gSSN1nXDvIuUIMn/A6z3KAQ44QomCvPaz1NISovLQfUYNWrmiylhLLr5ARZaox5dBackwzp6KhTM1IVduoxXXPY6RCqgQwMQ4fVCmEvJKxo5Ph+6UPBBtK5vYIZhjk+p31/D8nmJ6siDeLmSgFykDAeB5LkZ3ayp5S38heUavrPHBPuD/XTiaV4PSJw+Hsz1t7HjjPn/N7ZaMG0utM8fIYyWcOxsCboL69cPzX3SEQ2q2s8ipp+TnuvjPsfm3Iy0uiaKQ3Cc42MOaG/Wb+32hd8lIR3xUtG3ozddT9Q2KJ5ig+7uHVFjQEiPUFU+IJh7xrRGhFPGaqf5XDnvPVVqj6q1yrwz0WRHSZqHg2DKlDngQ5LubzZB+HxbvQkIYAwedpTFPmAS+OBrdiwA5SOs18kQNOF4sboZimdxHRtPWxK4u4OweqL7K3gO3J/WejGrhvlNFSygVwQzgkTzqsgZ0IgMx20ZyM6tq6EAaic2P6kMCE4tMl16EMvkrmIfHd4ysYoPNcxRuMdWmslmRmOXNyG3+5KLPpd43zpFm9z7ImcHlk0bsOqlPgynu7oZ6N5s37+BbAN0a5K4u8nNEXHdS9WWSBFfg3Zw7ao9TMjs6JuhyIfyyr1PeOsS2bVPWd033/dex0UrOKgZs4Ctt7cKfXivUC9ZlRJ2dt0kWt17agj77NBGWSsets21RQwrr5fZDhMcflM1lmDVlrCU1YuqBzsMDbydvL4Uh4HmMP/sJaX2pdsNPa1qghXTW6GJ/lewrgrnlf5w2
 +vNX/oMB
 UeUmNq/Y1phT6zoL5J0WqAuTW61ACagrQX8JEVRZDHIDhTw5DUtC+csIebHSeH/A4eHfjtaSe1qR9xxPScLUGdt+znhgBDHhkNpSMjDE6BsaYSGHcFygOTHa+eUSwUh5y2VM0aPoOXWAFledZ9uO4n9rAADzzt2IYBHLSZw0Khb4KJGZ39yQCYDKcpgsulllbdHgugBNRND2wRaLE08jreahueRhxVr6mGWo8P73Cx9z9fI1DKTGXzX1j9tuy5F4GsdaSfiI8FZ6rZsLUAn6SxZ4LIMWl8IITCyn+ufdFneZvU5O3d2ay2IiqQuQkL7lWL2I6Ph5/YDUitRDkb46FrEcZVVByJqJblQr98dEMnNZlPrvS+uE96xpwI7Gu9giFTfI/0j7f2qLL01pvKgQDQkTI90UmwwDJ/75bNqmkXFSp3lZLIfUPA0tGUFOgZEEG/R1YQEim87XKFFh4a95MBWNiZTIhjGDPAb8j1V0kaQi4XhZe4jbiOBT6s9nYeA7NLJLPGZjEklvLlCjhbwwfipUJtbXYDzddFSV4VL+P/4d50faGSvdrzve6+0oHlbLdkbWoDh8ip97iDIJeWr0j5moRhNz53fZWk9X/J3Bi1N+NEySgfg3MFrDRWIoCq0sfIxVgyhGe5dGhsLTXL7b0noZNQCEiqfSWufK3ZTLz7hwGS5ysZR6NY68Uh0JB32GDf6L7/ya0qMZUV7VUoFbwO35iBPn3I6jRvdERoDlEIbzR1g6e+IOfj+uw0tX16RNi02+QJaZwYpYmAdhumbAFbomn/olhAUwgPRgcXSJ1bFVOJHTwmGqMVZeFz7erkXeUVUf1tlWt1MDE5knp1kZ9/6fnwNavCpKJ2ouQ8HvC2+icEzx6UB279lXb5t4bmLgHjYSov+h0rgLZ0KLHxZ9O0yIeiHbc+p6JubjlL6Rq77CcAuXjuQjeJ9SZsmcpKiSXkF29GnLiGRHoR3zNA2kDbtHFGEdo
 OWutJRmv
 zDDkGvjSrPzbP9XmEROpWe54TQ9y8QLCvYNTyjH4HU7wXjA3lxCqEs0L2xtSF7XDXqSMikSPFE71Oh8UlIFxVyK9QgRKzQ2dGKs1FVAUzNQa53GamKXxl6JRU+qgGUl1h3KFwfB6xrq00UyXnrGQ7owMvEOk4ySF8P+c92lHRhy9i6tqgcaQIYlB0tiIKD6mHfA0EISrfAyz1G+vKqlVpO1VPnrHqNlBhm2XU80zOEmVbjZMupwbWPlS4Iv0N4V09kL9219ZQGxwq0lCR/fIhZI4m95ZoEdGhDnZDuvqLtUqzD8qjBioaMKqLrIdpMcaDOAizfsjj8QPgiFNPLE1DxDXoTx/drTMq77F+s973FcZVsXQuv43w9KEn25f9cB69jwTDibifZxc+HCdgYirTKQO2l2TR4JALlXCh86PYyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 18:30, Lorenzo Stoakes wrote:
> Hi Eugen,
> 
> You've not run scripts/get_maintainer.pl so this is missing a ton of maintainers
> that you're required to send this to. This is not a great start for a huge 26
> patch series that seems to want to make very significant changes.
> 
> Please try to follow proper kernel procedure.

Hi Lorenzo,

I included the relevant mailing lists, but indeed I have not cc-ed every
individual maintainer. Do you think it would be appropriate to resend it
as-is to everyone cc-ed (PATCH RESEND) or just do that for the next
revision ?

> 
> Here's the list:
> 
> Jonathan Corbet <corbet@lwn.net> (maintainer:DOCUMENTATION PROCESS)
> Bjorn Andersson <andersson@kernel.org> (maintainer:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM)
> Mathieu Poirier <mathieu.poirier@linaro.org> (maintainer:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM)
> Konrad Dybcio <konradybcio@kernel.org> (maintainer:ARM/QUALCOMM SUPPORT)
> Arnd Bergmann <arnd@arndb.de> (maintainer:GENERIC INCLUDE/ASM HEADER FILES)
> Mike Rapoport <rppt@kernel.org> (maintainer:MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION)
> Thomas Gleixner <tglx@linutronix.de> (maintainer:CPU HOTPLUG)
> Peter Zijlstra <peterz@infradead.org> (maintainer:CPU HOTPLUG,commit_signer:8/46=17%,removed_lines:4/63=6%)
> Kees Cook <kees@kernel.org> (maintainer:EXEC & BINFMT API, ELF,commit_signer:7/46=15%)
> Ingo Molnar <mingo@redhat.com> (maintainer:SCHEDULER,commit_signer:1/2=50%)
> Juri Lelli <juri.lelli@redhat.com> (maintainer:SCHEDULER)
> Vincent Guittot <vincent.guittot@linaro.org> (maintainer:SCHEDULER)
> Dietmar Eggemann <dietmar.eggemann@arm.com> (reviewer:SCHEDULER)
> Steven Rostedt <rostedt@goodmis.org> (reviewer:SCHEDULER)
> Ben Segall <bsegall@google.com> (reviewer:SCHEDULER)
> Mel Gorman <mgorman@suse.de> (reviewer:SCHEDULER)
> Valentin Schneider <vschneid@redhat.com> (reviewer:SCHEDULER)
> Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - CORE,commit_signer:5/46=11%,commit_signer:14/22=64%)
> David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - CORE)
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
> "Liam R. Howlett" <Liam.Howlett@oracle.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Vlastimil Babka <vbabka@suse.cz> (reviewer:MEMORY MANAGEMENT - CORE)
> Suren Baghdasaryan <surenb@google.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Michal Hocko <mhocko@suse.com> (reviewer:MEMORY MANAGEMENT - CORE)
> Petr Mladek <pmladek@suse.com> (maintainer:PRINTK,commit_signer:5/22=23%)
> John Ogness <john.ogness@linutronix.de> (reviewer:PRINTK)
> Sergey Senozhatsky <senozhatsky@chromium.org> (reviewer:PRINTK,added_lines:21/262=8%,removed_lines:9/89=10%)
> Anna-Maria Behnsen <anna-maria@linutronix.de> (maintainer:HIGH-RESOLUTION TIMERS, TIMER WHEEL, CLOCKEVENTS)
> Frederic Weisbecker <frederic@kernel.org> (maintainer:HIGH-RESOLUTION TIMERS, TIMER WHEEL, CLOCKEVENTS)
> Brendan Jackman <jackmanb@google.com> (reviewer:MEMORY MANAGEMENT - PAGE ALLOCATOR)
> Johannes Weiner <hannes@cmpxchg.org> (reviewer:MEMORY MANAGEMENT - PAGE ALLOCATOR)
> Zi Yan <ziy@nvidia.com> (reviewer:MEMORY MANAGEMENT - PAGE ALLOCATOR)
> Dennis Zhou <dennis@kernel.org> (maintainer:PER-CPU MEMORY ALLOCATOR)
> Tejun Heo <tj@kernel.org> (maintainer:PER-CPU MEMORY ALLOCATOR)
> Christoph Lameter <cl@gentwo.org> (maintainer:PER-CPU MEMORY ALLOCATOR)
> Chris Li <chrisl@kernel.org> (maintainer:MEMORY MANAGEMENT - SWAP)
> Kairui Song <kasong@tencent.com> (maintainer:MEMORY MANAGEMENT - SWAP)
> Kemeng Shi <shikemeng@huaweicloud.com> (reviewer:MEMORY MANAGEMENT - SWAP)
> Nhat Pham <nphamcs@gmail.com> (reviewer:MEMORY MANAGEMENT - SWAP)
> Baoquan He <bhe@redhat.com> (reviewer:MEMORY MANAGEMENT - SWAP)
> Barry Song <baohua@kernel.org> (reviewer:MEMORY MANAGEMENT - SWAP)
> "Thomas Weißschuh" <thomas.weissschuh@linutronix.de> (added_lines:13/207=6%)
> workflows@vger.kernel.org (open list:DOCUMENTATION PROCESS)
> linux-doc@vger.kernel.org (open list:DOCUMENTATION)
> linux-kernel@vger.kernel.org (open list)
> linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM MAILING LIST)
> linux-remoteproc@vger.kernel.org (open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM)
> linux-arch@vger.kernel.org (open list:GENERIC INCLUDE/ASM HEADER FILES)
> linux-mm@kvack.org (open list:MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION)
> 
> On Wed, Nov 19, 2025 at 05:44:01PM +0200, Eugen Hristev wrote:
>> meminspect is a mechanism which allows the kernel to mark specific memory
>> areas for memory dumping or specific inspection, statistics, usage.
>> Once regions are marked, meminspect keeps an internal list with the regions
>> in a dedicated table.
>> Further, these regions can be accessed using specific API by any interested driver.
> 
> Instincitivley not a great fan of exposing and manipulating memory resources to
> drives in such a way but I haven't looked into this in detail here.
> 
>> Regions being marked beforehand, when the system is up and running, there
>> is no need nor dependency on a panic handler, or a working kernel that can
>> dump the debug information.
>> meminspect can be primarily used for debugging. The approach is feasible to work
>> when pstore, kdump, or another mechanism do not.
>> Pstore relies on persistent storage, a dedicated RAM area or flash, which
>> has the disadvantage of having the memory reserved all the time, or another
>> specific non volatile memory. Some devices cannot keep the RAM contents on
>> reboot so ramoops does not work. Some devices do not allow kexec to run
>> another kernel to debug the crashed one.
>> For such devices, that have another mechanism to help debugging, like
>> firmware, kmemdump is a viable solution.
>>
>> meminspect can create a core image, similar with /proc/vmcore, with only
>> the registered regions included. This can be loaded into crash tool/gdb and
>> analyzed. This happens if CRASH_DUMP=y.
>> To have this working, specific information from the kernel is registered,
>> and this is done at meminspect init time, no need for the meminspect users to
>> do anything.
>>
>> This version of the meminspect patch series includes two drivers that make use of it:
>> one is the Qualcomm Minidump, and the other one is the Debug Kinfo
>> backend for Android devices, reworked from this source here:
>> https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/drivers/android/debug_kinfo.c
>> written originally by Jone Chou <jonechou@google.com>
>>
>> *** History, motivation and available online resources ***
>>
>> The patch series is based on both minidump and kmemdump previous implementations.
>>
>> After the three RFC kmemdump versions, considering the ML discussions, I decided to
>> move this into kernel/ directory and rework it into naming it meminspect, as Thomas Gleixner
>> suggested.
>> I will present this version at Plumbers conference in Tokyo on December 13th:
>> https://lpc.events/event/19/contributions/2080/
>> I am eager to discuss it there face to face.
>>
>> Initial version of kmemdump and discussion is available here:
>> https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
>>
>> Kmemdump has been presented and discussed at Linaro Connect 2025,
>> including motivation, scope, usability and feasability.
>> Video of the recording is available here for anyone interested:
>> https://www.youtube.com/watch?v=r4gII7MX9zQ&list=PLKZSArYQptsODycGiE0XZdVovzAwYNwtK&index=14
>>
>> Linaro blog on kmemdump can be found here:
>> https://www.linaro.org/blog/introduction-to-kmemdump/
>>
>> Linaro blog on kmemdump step by stem using minidump backend is available here:
>> https://www.linaro.org/blog/kmemdump-step-by-step-on-qualcomm-automotive-platform/
>>
>> The implementation is based on the initial Pstore/directly mapped zones
>> published as an RFC here:
>> https://lore.kernel.org/all/20250217101706.2104498-1-eugen.hristev@linaro.org/
>>
>> The back-end implementation for qcom_minidump is based on the minidump
>> patch series and driver written by Mukesh Ojha, thanks:
>> https://lore.kernel.org/lkml/20240131110837.14218-1-quic_mojha@quicinc.com/
>>
>> The RFC v2 version with .section creation and macro annotation kmemdump
>> is available here:
>> https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
>>
>> The RFC v3 version with making everything static, which was pretty much rejected due to
>> all reasons discussed on the public ML:
>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> 
> OK so you've sent several RFC's and not cc'd the right people in any of them :/
> 
> This isn't great kernel etiquette.

I appologize for not cc-ing everyone.

> 
>>
>> *** How to use meminspect with minidump backend on Qualcomm platform guide ***
>>
>> Prerequisites:
>> Crash tool compiled with target=ARM64 and minor changes required for usual crash
>> mode (minimal mode works without the patch)
>> **A patch can be applied from here https://p.calebs.dev/1687bc **
>> This patch will be eventually sent in a reworked way to crash tool.
>>
>> Target kernel must be built with :
>> CONFIG_DEBUG_INFO_REDUCED=n ; this will have vmlinux include all the debugging
>> information needed for crash tool.
>>
>> Also, the kernel requires these as well:
>> CONFIG_MEMINSPECT,  CONFIG_CRASH_DUMP and the driver CONFIG_QCOM_MINIDUMP
>>
>> Kernel arguments:
>> Kernel firmware must be set to mode 'mini' by kernel module parameter
>> like this : qcom_scm.download_mode=mini
>>
>> After the kernel boots, and minidump module is loaded, everything is ready for
>> a possible crash.
>>
>> Once the crash happens, the firmware will kick in and you will see on
>> the console the message saying Sahara init, etc, that the firmware is
>> waiting in download mode. (this is subject to firmware supporting this
>> mode, I am using sa8775p-ride board)
>>
>> Example of log on the console:
>> "
>> [...]
>> B -   1096414 - usb: init start
>> B -   1100287 - usb: qusb_dci_platform , 0x19
>> B -   1105686 - usb: usb3phy: PRIM success: lane_A , 0x60
>> B -   1107455 - usb: usb2phy: PRIM success , 0x4
>> B -   1112670 - usb: dci, chgr_type_det_err
>> B -   1117154 - usb: ID:0x260, value: 0x4
>> B -   1121942 - usb: ID:0x108, value: 0x1d90
>> B -   1124992 - usb: timer_start , 0x4c4b40
>> B -   1129140 - usb: vbus_det_pm_unavail
>> B -   1133136 - usb: ID:0x252, value: 0x4
>> B -   1148874 - usb: SUPER , 0x900e
>> B -   1275510 - usb: SUPER , 0x900e
>> B -   1388970 - usb: ID:0x20d, value: 0x0
>> B -   1411113 - usb: ENUM success
>> B -   1411113 - Sahara Init
>> B -   1414285 - Sahara Open
>> "
>>
>> Once the board is in download mode, you can use the qdl tool (I
>> personally use edl , have not tried qdl yet), to get all the regions as
>> separate files.
>> The tool from the host computer will list the regions in the order they
>> were downloaded.
>>
>> Once you have all the files simply use `cat` to put them all together,
>> in the order of the indexes.
>> For my kernel config and setup, here is my cat command : (you can use a script
>> or something, I haven't done that so far):
>>
>> `cat memory/md_KELF1.BIN memory/md_Kvmcorein2.BIN memory/md_Kconfig3.BIN \
>> memory/md_Ktotalram4.BIN memory/md_Kcpu_poss5.BIN memory/md_Kcpu_pres6.BIN \
>> memory/md_Kcpu_onli7.BIN memory/md_Kcpu_acti8.BIN memory/md_Kmem_sect9.BIN \
>> memory/md_Kjiffies10.BIN memory/md_Klinux_ba11.BIN memory/md_Knr_threa12.BIN \
>> memory/md_Knr_irqs13.BIN memory/md_Ktainted_14.BIN memory/md_Ktaint_fl15.BIN \
>> memory/md_Knode_sta16.BIN memory/md_K__per_cp17.BIN memory/md_Knr_swapf18.BIN \
>> memory/md_Kinit_uts19.BIN memory/md_Kprintk_r20.BIN memory/md_Kprintk_r21.BIN \
>> memory/md_Kprb22.BIN memory/md_Kprb_desc23.BIN memory/md_Kprb_info24.BIN \
>> memory/md_Kprb_data25.BIN  memory/md_Khigh_mem26.BIN memory/md_Kinit_mm27.BIN \
>> memory/md_Kunknown29.BIN memory/md_Kunknown30.BIN memory/md_Kunknown31.BIN \
>> memory/md_Kunknown32.BIN memory/md_Kunknown33.BIN memory/md_Kunknown34.BIN \
>> memory/md_Kunknown35.BIN memory/md_Kunknown36.BIN memory/md_Kunknown37.BIN \
>> memory/md_Kunknown38.BIN memory/md_Kunknown39.BIN memory/md_Kunknown40.BIN \
>> memory/md_Kunknown41.BIN memory/md_Kunknown42.BIN memory/md_Kunknown43.BIN \
>> memory/md_Kunknown44.BIN memory/md_Kunknown45.BIN  memory/md_Kunknown46.BIN \
>> memory/md_Kunknown47.BIN memory/md_Kunknown48.BIN memory/md_Kunknown49.BIN \
>> memory/md_Kunknown50.BIN memory/md_Kunknown51.BIN memory/md_Kunknown52.BIN \
>> memory/md_Kunknown53.BIN memory/md_Kunknown54.BIN memory/md_Kunknown55.BIN \
>> memory/md_Kunknown56.BIN memory/md_Kunknown57.BIN > ~/minidump_image`
>>
>> Once you have the resulted file, use `crash` tool to load it, like this:
>> `./crash --no_modules --no_panic --no_kmem_cache --zero_excluded vmlinux minidump_image`
>>
>> There is also a --minimal mode for ./crash that would work without any patch applied
>> to crash tool, but you can't inspect symbols, etc.
>>
>> Once you load crash you will see something like this :
>>       KERNEL: /home/eugen/linux-minidump/vmlinux  [TAINTED]
>>     DUMPFILE: /home/eugen/a
>>         CPUS: 8 [OFFLINE: 6]
>>         DATE: Thu Jan  1 02:00:00 EET 1970
>>       UPTIME: 00:00:25
>>        TASKS: 0
>>     NODENAME: qemuarm64
>>      RELEASE: 6.18.0-rc2-00030-g65df2b8a0dde
>>      VERSION: #33 SMP PREEMPT Mon Nov 17 13:30:54 EET 2025
>>      MACHINE: aarch64  (unknown Mhz)
>>       MEMORY: 0
>>        PANIC: ""
>> crash> log
>> [    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd4b2]
>> [    0.000000] Linux version 6.18.0-rc2-00030-g65df2b8a0dde
>>
>> *** Debug Kinfo backend driver ***
>> I don't have any device to actually test this. So I have not.
>> I hacked the driver to just use a kmalloc'ed area to save things instead
>> of the shared memory, and dumped everything there and checked whether it is identical
>> with what the downstream driver would have saved.
>> So this synthetic test passed and memories are identical.
>> Anyone who actually wants to test this, feel free to reply to the patch.
>> I have also written a simple DT binding for the driver.
>>
>> Thanks for everyone reviewing and bringing ideas into the discussion.
>>
>> Eugen
>>
>> Changelog for meminspect v1:
>> - rename to meminspect
>> - start on top of v2 actually, with the section and all.
>> - remove the backend thing, change the API to access the table
>> - move everything to kernel/
>> - add dependency to CRASH_DUMP instead of a separate knob
>> - move the minidump driver to soc/qcom
>> - integrate the meminspect better into memblock by using a new memblock flag
>> - minor fixes : use dev_err_probe everywhere, rearrange variable declarations,
>> remove some useless code, etc.
>>
>> Changelog for RFC v3:
>> - V2 available here : https://lore.kernel.org/all/20250724135512.518487-1-eugen.hristev@linaro.org/
>> - Removed the .section as requested by David Hildenbrand.
>> - Moved all kmemdump registration(when possible) to vmcoreinfo.
>> - Because of this, some of the variables that I was registering had to be non-static
>> so I had to modify this as per David Hildenbrand suggestion.
>> - Fixed minor things in the Kinfo driver: one field was broken, fixed some
>> compiler warnings, fixed the copyright and remove some useless includes.
>> - Moved the whole kmemdump from drivers/debug into mm/ and Kconfigs into mm/Kconfig.debug
>> and it's now available in kernel hacking, as per Randy Dunlap review
>> - Reworked some of the Documentation as per review from Jon Corbet
>>
>>
>> Changelog for RFC v2:
>> - V1 available here: https://lore.kernel.org/lkml/20250422113156.575971-1-eugen.hristev@linaro.org/
>> - Reworked the whole minidump implementation based on suggestions from Thomas Gleixner.
>> This means new API, macros, new way to store the regions inside kmemdump
>> (ditched the IDR, moved to static allocation, have a static default backend, etc)
>> - Reworked qcom_minidump driver based on review from Bjorn Andersson
>> - Reworked printk log buffer registration based on review from Petr Mladek
>>
>> I appologize if I missed any review comments.
>> Patches are sent on top on 6.18-rc2
>>
>> Eugen Hristev (26):
>>   kernel: Introduce meminspect
>>   init/version: Annotate static information into meminspect
>>   mm/percpu: Annotate static information into meminspect
>>   cpu: Annotate static information into meminspect
>>   genirq/irqdesc: Annotate static information into meminspect
>>   timers: Annotate static information into meminspect
>>   kernel/fork: Annotate static information into meminspect
>>   mm/page_alloc: Annotate static information into meminspect
>>   mm/show_mem: Annotate static information into meminspect
>>   mm/swapfile: Annotate static information into meminspect
>>   kernel/vmcore_info: Register dynamic information into meminspect
>>   kernel/configs: Register dynamic information into meminspect
>>   mm/init-mm: Annotate static information into meminspect
>>   panic: Annotate static information into meminspect
>>   kallsyms: Annotate static information into meminspect
>>   mm/mm_init: Annotate static information into meminspect
>>   sched/core: Annotate runqueues into meminspect
>>   mm/memblock: Add MEMBLOCK_INSPECT flag
>>   mm/numa: Register information into meminspect
>>   mm/sparse: Register information into meminspect
>>   printk: Register information into meminspect
>>   remoteproc: qcom: Extract minidump definitions into a header
>>   soc: qcom: Add minidump driver
>>   soc: qcom: smem: Add minidump device
>>   dt-bindings: reserved-memory: Add Google Kinfo Pixel reserved memory
>>   meminspect: Add Kinfo compatible driver
>>
>>  Documentation/dev-tools/index.rst             |   1 +
>>  Documentation/dev-tools/meminspect.rst        | 139 ++++++
>>  .../reserved-memory/google,kinfo.yaml         |  49 ++
>>  MAINTAINERS                                   |  13 +
>>  drivers/remoteproc/qcom_common.c              |  56 +--
>>  drivers/soc/qcom/Kconfig                      |  13 +
>>  drivers/soc/qcom/Makefile                     |   1 +
>>  drivers/soc/qcom/minidump.c                   | 272 ++++++++++
>>  drivers/soc/qcom/smem.c                       |  10 +
>>  include/asm-generic/vmlinux.lds.h             |  13 +
>>  include/linux/memblock.h                      |   7 +
>>  include/linux/meminspect.h                    | 261 ++++++++++
>>  include/linux/soc/qcom/minidump.h             |  72 +++
>>  init/Kconfig                                  |   2 +
>>  init/version-timestamp.c                      |   3 +
>>  init/version.c                                |   3 +
>>  kernel/Makefile                               |   1 +
>>  kernel/configs.c                              |   6 +
>>  kernel/cpu.c                                  |   5 +
>>  kernel/fork.c                                 |   2 +
>>  kernel/irq/irqdesc.c                          |   2 +
>>  kernel/kallsyms.c                             |  10 +
>>  kernel/meminspect/Kconfig                     |  30 ++
>>  kernel/meminspect/Makefile                    |   4 +
>>  kernel/meminspect/kinfo.c                     | 289 +++++++++++
>>  kernel/meminspect/meminspect.c                | 470 ++++++++++++++++++
>>  kernel/panic.c                                |   4 +
>>  kernel/printk/printk.c                        |  12 +
>>  kernel/sched/core.c                           |   2 +
>>  kernel/time/timer.c                           |   2 +
>>  kernel/vmcore_info.c                          |   4 +
>>  mm/init-mm.c                                  |  11 +
>>  mm/memblock.c                                 |  36 ++
>>  mm/mm_init.c                                  |   2 +
>>  mm/numa.c                                     |   2 +
>>  mm/page_alloc.c                               |   2 +
>>  mm/percpu.c                                   |   2 +
>>  mm/show_mem.c                                 |   2 +
>>  mm/sparse.c                                   |   4 +
>>  mm/swapfile.c                                 |   2 +
>>  40 files changed, 1766 insertions(+), 55 deletions(-)
>>  create mode 100644 Documentation/dev-tools/meminspect.rst
>>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/google,kinfo.yaml
>>  create mode 100644 drivers/soc/qcom/minidump.c
>>  create mode 100644 include/linux/meminspect.h
>>  create mode 100644 include/linux/soc/qcom/minidump.h
>>  create mode 100644 kernel/meminspect/Kconfig
>>  create mode 100644 kernel/meminspect/Makefile
>>  create mode 100644 kernel/meminspect/kinfo.c
>>  create mode 100644 kernel/meminspect/meminspect.c
>>
>> --
>> 2.43.0
>>
>>
>>
+


