Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A748AC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB396B0096; Tue, 15 Sep 2026 02:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2AA6B0098; Tue, 15 Sep 2026 02:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B426B0099; Tue, 15 Sep 2026 02:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96DE66B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:57:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66DED1A0336
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:57:06 +0000 (UTC)
X-FDA: 85215089652.13.071C719
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52468A0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:57:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BhkXEgr+;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19gTsJshLkl6xms1dIGVk+IXi9BTm+f13eumbdPgk68=;
	b=vMFJ8JVDV3VJbRA1qRCQpO0F1lo1k+Y/PoMZSIp5EbcRGmIzFU/dGpw6SKGviwBchCGacR
	fx1+AYWuYcZGV1ZG6jfOIZVEcrpWLEQ060e3zvsJTqMflmr4wmCpgcaztPKE4h6Fcdugje
	c8xyY/AyfvhALhjr79XVmUgszSh8P5I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BhkXEgr+;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455424;
	b=20WehWf7kxUfiQXr6ic3KC0TV+5c2W38vsBcPF6r0tQqNIAPbKGi71n11EatIORGr5cOCr
	v44LipBLdZjgynvCBh7OSqMbcPbuoVG7/SoLyo7Bzu1KyGwd+vb1NPWsB7eQhHnT48zSb3
	ND4adR6A3lyd60kFiV5KoAWrj3napTI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c29c49a977aso127683066b.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789455423; x=1790060223; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=19gTsJshLkl6xms1dIGVk+IXi9BTm+f13eumbdPgk68=;
        b=BhkXEgr+gdaZkpcSxNUTDbIrYpGX9tmUaApG01gOlIrQqJYgMdR5kffTyYCI2eGsA9
         mKAXk5w1b0+vm5fo6kYwnLyCvjI5hU/LjEwuMR0OJeiMBPgeu4GMamPO886NsHqUY+72
         t3kF0KILOxEPnYJT+qEYegq+iqw0dohtmeoMNkNIQbLmwVRpmCjork2RrO8A1A5FXxIu
         Z3dhILq8A1lhYO7CoOXwW4fezC+L6qzCWs0AryNzLhRli2y5P5DTraMdw7TF2oi3VDnC
         nm70FzhdL0EYEly7JBn6/GvDkRqqLedQnKIvYwcS0NjDoL6OdNiRZePEqyggXxaTwXTP
         aPEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789455423; x=1790060223;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=19gTsJshLkl6xms1dIGVk+IXi9BTm+f13eumbdPgk68=;
        b=I7hhEDv029opmG/Pfh3sHiFG6gO1y9wy2rdECydR1Joc/X33mGBwUIQmUhEzfx5BPT
         tBmEKVeJuQL0smiu9Z2GjAhM+2/OKpJflqEkzeYMhdyEDercj0a6ryTw9D8wLVbvFErj
         xcwbdvrB2vOE4coBCY32DfGL335TjjVEKFORCU9HZKtoEa5+3NLJICs/6JBZkQESQBKv
         JH0Jzd19Ng3sqnFShYmOfO7g3CxBPI24SzeY+Umr1Hk8DPwXdCdISkCmMtqZp683Asl3
         8FUWEt2MopvP708FMrIZl1tB741HrzKIFGHk9sPkliQVlBiiws0/+ueI27JquMwaWwjG
         +OCg==
X-Forwarded-Encrypted: i=1; AKwUvBzHy+a0jDnkz6/8v3iKls05dY5mJLGbhcy+2oAcXJtO1ZACYT4HEE29yuk/2rOJyl8k/qT9A8Y7lw==@kvack.org
X-Gm-Message-State: AFuF++lWraxVCge/mE8x3dOMghsYtmSI9T/g+LX24+FeAv5mJdFdn/kB
	rN6NSXDn5DOu/MQkVj7RfYVCaQh0qmNfNTUNEHTEkkl861V9fwEEcc7crY3ze3Y+lEU=
X-Gm-Gg: AYBFou00uoPuIQFEpCpLhBlU/gvvHOAEBJhk8jJFvEBggkMSWkqdLXG2fFbDdRgtFAt
	s9n6Rldg7iWsybadg0xodZYaUu6wb00tQsJA5a7Ehx4QLbvG5MPZWWCSUgPbGBToU6uf3aiVA5d
	1X0hrtSypSPb+cdEnSRQtUwY9RsuL3ryNVZYt8tCirrXtitwrDPGBI1CZXCNRW6i6ZeAAkhStdR
	M8ZucIgh/1fK7kiTrQrXRbEHpiC2bpXs9Q7HW/hEZF1N5txhzAxVGeqAbU8QLgkmgK/Itb6KyyE
	8OV88oUUMZuTzn5diEtZkRepCC6DZRMCM2ZclRfkmsbuoMkR9SB7W4FpFLeRoM8HPrXEYoP+RBY
	1D7Jkedgg1dLuiKJVONPQoCCuTMHtZlQv2kSUyfqS5EVo4udPBdaYM6FYUsZVlDxfiDTnqghOch
	IwRtvtR8Kdf6xCUMlw7BQ9Wg332XAK2TIVT4scoPVJSq+ozY52LcFMSqSn/CqR
X-Received: by 2002:a17:907:1c27:b0:c26:22ec:db92 with SMTP id a640c23a62f3a-c29b876765dmr355857466b.47.1789455422717;
        Mon, 14 Sep 2026 23:57:02 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966067101sm537544766b.35.2026.09.14.23.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 23:57:02 -0700 (PDT)
Date: Tue, 15 Sep 2026 08:57:01 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
Message-ID: <aqjsPW92SgcHONKO@tiehlicka>
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
 <aqg-oG2HDIUeK5Us@tiehlicka>
 <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: dygigpty3pgnk4s8so7hn33cjwgomejc
X-Rspamd-Queue-Id: 52468A0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789455424-785520
X-HE-Meta: U2FsdGVkX19cZ4X8AcOr4R7vy4k/n3E6ITkEqUpC/7kGTaIwEZRhM0HAyOz7r+AaNiu5us87v7p+ri6dB9BgWEt0aaSBT78hXDDUH1QK0qFSNg1lN7waQW6qViVYPCkyYvzbkOtycZ8EvklOU682fP8n0zib88bIZ1nt0g6NoG1ap3K900CzSVIpsHDCrEotxNp5HYMQw6J3yWOBd/Y84Zl/jpY8+bLt2XKoCA4WeZwh3jWEMmCx32oLUhpwTDmRlok0DotCxrkP0ZVh57ETxVfYaYqK1BMl9In6mVZ4kAFayBkjnR5Njy2PnZ89+EVgmrsZphdGIdCNyuAA2wYnsMg/67Hi4sVkEHrQx480JH/xk1P31rKnmTTELc4IMmGMYA6/HOZo4mTrEtIa90yjiF3dEW3JxOve+1YbjVE2VQhMv6EAJnONLeO1rPuRkdJHPhLFg0lLdwIq5Mp0fgJpy9s/kKzQarKc3ZHq5A7eWyi5TWu0pDsfuPeKBgiabM0dQisqFJngZWBUjEEpdLZKvAA3GJJUvgZjY1bLpKUoO0Nts9xTxnvanKMFvo/++7H24mNvMHe7wdNyyPta1rtKNfZB6wcQhS3MBgDEXABju/ehFNYLQ7nneGL3nGjnO8Qidx5W6QewvrqyntGTNig6Oeuy3cr8UfMXSRYsRx+VWrzdBa2ASQ/gyD9XUHc8pnoj0+/EZMBJ9mQWtCpBsnGkWkKt+WjUQa5lorwyScUFtHcZn0rUbAezMtqLBho5V/W3asjpQMWHFOR7fD3Cv5QeGpYgfY6BKw0sKG4pRFe3WFfFApzqzIo1LymlOL2wU9RzQRn03HIPtyXifOFxYnO6U6JZibiqUA9UJtlSBRmYOSJ9hlMy17Xf8pGe14a9zcdzlRkuwG0bk0U+ymrJynClYSeJ+llDXEuMUu+MZhnFz6pVlHDeO/7xgMyxikvHa7YhZRPpm8yE5s1XcKjyReY
 Cun0ZPID
 6PbR3kkxwGPyUQ3fmxazM0AEC2IXCVJD8Rr5tu4w1wu3GsH8EO/D0+SH4K4L+WVCKf7CcoiwG8Y+LFQlQWWUdBik4ms4QTF/67qtbw7lZV8m2e7lUhgoc32XkBXFRjTYvs1I0W/TiT42P7aTa3qkrwH4GKVSBhncpAtMR70H9NB3ZXrMEhKVNi02c4dnNHkzspBOZeg9vX5R0PJdKAEfFcDhoANDMD2uEhEGbukm0j1FFhr2Fr/KweNbPvI8gjrhWtkFmY4RMmHjaqfo4v8AXXMaqZuMIQFRVa5GNl5DqN5fIbbBZV7LghbWB3hQlHb7r5bWtiuZOSKO+oLJvQmH4qf6pRdm3IVnWHNIcGVaolNtlaRSiXM+VWJZANNvtaPyoY4W7LnmkXMOxdLe2YR5BeQBil91JwdaBVVRSIIbUn9/cOpJ5V6shJ4pul3e8BcgN6wGRNdVpo/YrBkdvx1+S7gKRRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 14-09-26 20:35:33, Andrew Morton wrote:
> On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Call Trace:
> > >  <TASK>
> > >  __schedule+0x487/0x1870
> > >  schedule+0x28/0xb0
> > >  schedule_preempt_disabled+0x16/0x30
> > >  rwsem_down_write_slowpath+0x1d4/0x750
> > >  down_write+0x60/0x70
> > >  __ksm_exit+0xb4/0x230
> > >  __mmput+0x12c/0x150
> > >  mmput+0x1e/0x30
> > >  do_exit+0x283/0xa30
> > >  do_group_exit+0x34/0x90
> > >  get_signal+0x952/0x960
> > >  arch_do_signal_or_restart+0x41/0x250
> > >  exit_to_user_mode_loop+0xd3/0x560
> > >  do_syscall_64+0x385/0x470
> > >  </TASK>
> > > 
> > > KSM is just the one LTP happened to hit: __khugepaged_exit() has the
> > > same write lock cycle ahead of exit_mmap().
> > 
> > Why is this a practical problem we need to care about? It is kind of
> > natural that the oom victim exit path might race with the oom reaper. They
> > share the same lock that is mutualy exclusive. The whole point of the
> > reaper is to ensure there is a forward progress achieved. So before we
> > start modifying this let's talk about any practical/real life problems.
> 
> If this situation is expected, unavoidable etc then perhaps the best
> change is to periodically poke the hung-task detector?

Right. Reaping 10s of GBs worth of VMAs might take some time indeed and
that could trigger the hung task detector.

-- 
Michal Hocko
SUSE Labs

