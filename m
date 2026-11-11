Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0009606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SsJnrqvh
Received: by kanga.kvack.org (Postfix)
	id 07FFC6B05B1; Tue, 10 Nov 2026 20:48:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030666B05B2; Tue, 10 Nov 2026 20:48:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E638F6B05B3; Tue, 10 Nov 2026 20:48:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5C396B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:48:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AFB21401CD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:48:43 +0000 (UTC)
X-FDA: 85421154126.27.8D65AF8
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47C88140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:48:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SsJnrqvh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794361721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2RcHe64LeB/gnyTEhJrBfe4ypF50Xcw5AhrrNUhpVI=;
	b=7LKIOx5O5Q8jmNFY5cYEM/qo1HhpRs9sWf1x2kgY+vKDCk2UusCuGHLWYiWi7EXCcYQ5y7
	cEqtswdEUmf0U3gGYIAttF5XGmfdJIxyYccXVMrUzzrwl/CtX8lVFAYd4GbfQPetMhzD46
	qtgav/uxbmPi685l1NvyX08aMnhi36w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SsJnrqvh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794361721;
	b=go0nLpUrTyOF4WJ6lKny8RDLWzSIPOzyps7zW5x+ACHkU1VTkHbr6NQA7gLYNhzuN1WEiB
	Yp1NH31LKDPG+cC7J4WAX42edhqx2MTUiQBdqlvq9EpeCzKIXvwvfq7w9V04OZLbOE+J60
	Gbc5oDtYmi2Um2ZhiM5kQfeGIn9p30c=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36a315ed211so3008438eec.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794361720; x=1794966520; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f2RcHe64LeB/gnyTEhJrBfe4ypF50Xcw5AhrrNUhpVI=;
        b=SsJnrqvhitSUw4/MwjjeN5DA5UrXOLB/1DDNQURqvJZ+woGQtv72nae6r401kRIlSO
         E5Fwvp3pqtLy2mKLBfSgBOybe9AA+ohHDMkIlNboBB8cTf3pLoG2p6oJUV2KpZMpuvXl
         vgf5nIaEG2ACqvbJ01wW7MS3rdhDtm8sYCsIqXBiKm2GTLEa+c6qlFd6CxAKCV031MQT
         Qbv4MNMGeJWU7SKje3hG9giP+g8oZrC4IxITHKCHBoZVJ7Jf5AnitQgi7n3MNe5x3irA
         5WUVeF49ooylKV94A+ySQ+FYNnyBk6jo9taQc2kuR7ZygCfJwBIwHUppFVzamA7FL/SG
         aFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794361720; x=1794966520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f2RcHe64LeB/gnyTEhJrBfe4ypF50Xcw5AhrrNUhpVI=;
        b=ztvT9rBCdBylGXYRKQ9hxTIgRdMXZg+Dc+sxC/fUx4VNUhOu20VobsF1+SMpK+cA9Z
         NG17iE6LfrJc2ByeHvvpmTJnpr8fRrKqBH5YUPk7cg71tRyOlCKyEurWXXAO2OW0PNah
         rBV1VgJYgMZkJPFgq8LSIJD8H8LDQJNYhfm3ttbj5Uk2S0RhJBvyY3V/Wutu4FFzv7Nj
         RJGwtM3X11wTzv5TAcwJjZO8hkKEWpCJ4lNAtqghRv2yeB/JBH5lVODWloPM1692ToVi
         RX/wLgV7pAj8jlIPNUKgnq63AeLC7xyFrPVlVY7WgyLQ/XflFZ/IZ0FQp6yOqZMoDDWr
         S6Xw==
X-Forwarded-Encrypted: i=1; AL+hErGfwjij4QpyKUqfrhtCF58PxgFfLlwnU3eVWMnxb6bNDb3zmbh3UaDlUkTRrcxRdxVVDhWo6H8/cA==@kvack.org
X-Gm-Message-State: APuU4Z92W0DpJZ/qmFwArHYZLov42ZIBWZkbh6JKJ3ffqokw9Y1EE+KW
	5/VHr3yUqLRXvCQ1/pWzt1Ld6VyBKWV1VPgR5SBxR2o0I7TVCpoJ0XTW
X-Gm-Gg: AYBFou0+3Ix2JOBNUIZ43Qjkx37T/6WqYz1M2HW4UZ1sP3DHep0O7OepW5lJzHsotOJ
	z6fVn6Z4mByWPPrlhEx8tOtddCar/eAbj13iMPJdAQ1dDBM12GhxfJEO6VQLLavO+TV7gb6rmKm
	9yRdcacMm2SLcwyESGAWykEUwrvu7/B1SnJFaT628cvPSpMRiAyngpocsB9p/RPGNaYHIpMz3YS
	+cw2jdq6bvckx4wo/70DK5vAMZti8oUqfYxR/9CYdWL/K9rTj9PtwOb74lOioHqejbMTWhnNOWk
	/v61w8OntY7Ny4tMv122bKj8zae4b/JzGtNo/qmvJFZDgKQT3Ig5TxRxahj/046353MEmxnUZOf
	7TyJFaE9/rFDbdaw66XIjQs+ddLZESMl1A8w0J8+lwxJP5bclqwNMfmTrjEDZBg+sw1I8dRZ5tG
	rG+Sky4TvLj0xg2ZK+LEWGQGI1xw16MRWFFfZR9FL6GDa+058CQWsnXmUY5PHqOWLVjqsGRlgIk
	uzSseGZoOAmxxKbN+JCrAf5OObZKzNVnjBfyHaiLcYW11hOlWbrZuwjNfFX/0jNIQ6WopsY3jJU
	+OFPYMPcvrQzc3OLktymV5fvI15MxECO5Bv9hKshtpX1m/w=
X-Received: by 2002:a05:7301:e22:b0:36a:37:1404 with SMTP id 5a478bee46e88-37686d2fcd4mr1959136eec.13.1794361719645;
        Tue, 10 Nov 2026 17:48:39 -0800 (PST)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e76e2sm11902533eec.24.2026.11.10.17.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 17:48:39 -0800 (PST)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hui Zhu <hui.zhu@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	Kairui Song <kasong@tencent.com>,
	Hui Zhu <zhuhui@kylinos.cn>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Wed, 11 Nov 2026 09:48:33 +0800
Message-Id: <20261111014833.2661236-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAGsJ_4ybXskWKDLHkeeuVGirGaaZ8TdPEDX+xQXZcYmPMSjS=A@mail.gmail.com>
References: <CAGsJ_4ybXskWKDLHkeeuVGirGaaZ8TdPEDX+xQXZcYmPMSjS=A@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47C88140003
X-Stat-Signature: gd33otfbtnupqwtakid519kt35rtsd7q
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794361721-329237
X-HE-Meta: U2FsdGVkX19Mbwv14MwU9PW0mNWv2ya7KtSqwckMCBhcQFxCUR8bDZgxoN8aGxgavPj4UkFMwwdKxX4LzknaG8WQlN7hbQYMz96SkakIHYSjqCKQE33RWf7w+aZxiN3m6Q7t3kGVEPVN4RST4E3gBkpOTB5KHSQzNlY1Bl9aqjtJ3w2PW9ps13gLUSaJqRcXg5MNNjMCmpmh7HafXEzsQFDxg0WHkEspTfUoulcAPmQbmIXblODhz2ww3OkFRPxGNXDFkh2FlJxbmotTJ9Ku6ua6NAxn+xr8YFd3VGTzoQtobBVil7h1PUVLpi1B3EGZg82QVi/0QkBcpCkccuVeupjciyVOeGoP3s/6mAzePJEG/1EEz3Bpy014EZAjc32goZljxRdoAgLOxjR9lpudaWbHyXLu2elo292y8WV97ZblWo5z5eYjjxumZuLLiHvlYw0bpZXxYX04pOhuwJe9lrxA5/V99zuEEWR1BDXVYIgJfyPVXLKPUkL8aMDKXQAUCKSN3e2hY9ltWA5KjqT3+362OgRNHC2ZIkpMrzu21TDipChWZhQ/GtV8mZpGG3K+fGICONkzqYR+XJ+xEaTwGlAvB44kb7/xmr2qFxJ6/0DYqnPNCkbwFu0k/b6+ByhpYnAB/x1oYMH5yVi8QBl98HQ0nV3EmamCq+aY7M5uJX6SI9k+i1HkWa6UU160fY4ej2fpQDFnhdzzUoqHLN9rmXpuEY1IEDE7I48cHvlotLspfmlqC0AovOPE4wt6zYRm67dkO80YNAQV5EG2vtxsch+6NoX2NIEw4K2Lgj9fC4g3iMAU0FMCO028UemPq/HKomNNpSreFbHUycJZHzHHbeVJbnS5q8oA3kuvY8HYeMaf1mVMoXMvVELLUlEHFIlP66vf0rcO8p23TNBcfIse0VR61s2lOsdWxis2A1cOLvNXgDTTgfBKqAiC0hxcpEp0mFyhk8FPreABg4+8q7k
 4Zo18uSD
 qjIQsQzlv/+8iA5AE4VZTSNyOjOG/G7ynXng5NOsYvrj78K93qboA5gSLkbFzWgWMJzEtrTSCIuLGenAGCpdTltDiNLHmWyMt/Mdg/LzpYrCS2p7oFrmnXxfVZR3tiS+ElzglEbJKa+5lddUtQOVaBPwNuIQ5fj62G6kTBZSPdpHpvxsJ8KQ8lEYngixit9Vp5+5h0N0H1mEEi+xLeZyCLRR0M3vcQ22sTSftwWQTqaov/A2do2QI9EYix0iuti+MqqfRKIT0Akav7N0J/irlUfIWr+eg0xmSmrYjLKrz/5YD+y0NZDHQwb8scsufYFjpsrnMckT/6W5TRboTM0SeIA+8LJbro/LUemO/yk95yzQlPP9hpjeq5hSX+kDqMg6hAR8PH7LEgT2LFracGSbEllKJ0meN/Xp10jHqo3tXNVOUyEcaYdS/DOQYaus+en+6rcpX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 1:08 PM Barry Song <baohua@kernel.org> wrote:
> However, real-world workload data would be helpful
> to demonstrate the actual performance impact and make
> the case more convincing.
>
> The patch itself makes a lot of sense in theory, though.
>
> I'll arrange some tests with Android workloads and report
> back once the data is available. If Hui already has some
> data, it would be great if he could share it as well.

Tested on a Xiaomi phone (android16-6.12 GKI with this fix backported,
MGLRU enabled). The workload launches and scrolls 26 common apps for
5 rounds; each run produces ~7-9M MADV_FREE pages. 3 runs per kernel,
same system image, same sequence (fresh boot, then back-to-back), only
the kernel differs:

                            without fix   with fix
  workingset_refault_file      44.7M        29.0M   (-35%)
  pgmajfault                   13.9M         9.0M   (-35%)
  pgsteal (kswapd+direct)     100.9M        75.6M   (-25%)
  cold launch (avg)           2436ms       2034ms   (-17%)

Without the fix, lazyfree folios keep their stale refs/PG_workingset
and get protected instead of evicted. Since they sit on the file LRU,
page cache is reclaimed in their place, which shows up as more file
refaults and major faults.

Tested-by: Bo Zhang <zhangbo56@xiaomi.com>

