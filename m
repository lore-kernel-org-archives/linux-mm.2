Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B5DCD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 10:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047EE8E0009; Thu, 13 Nov 2025 05:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A918E0003; Thu, 13 Nov 2025 05:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28FB8E0009; Thu, 13 Nov 2025 05:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC57D8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:02:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A026212DC2A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:02:47 +0000 (UTC)
X-FDA: 84105144774.05.27C97A6
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5707C140015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:02:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UbtSxQ4S;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763028165; a=rsa-sha256;
	cv=none;
	b=AOSoEcbGhtnwhXYogdttBsx3MtWXEbbgrW7Db0ARuYxz0z/HQAf47jRSVi/JPrq88T60sI
	cwrZGLn432SvrUiUGDeQwxJ9Snljt73AfSif58/fFRmfA4LU/BuTnwb1NU0PbG9pVG4PUY
	YgT+dRkD5jzvQ1wt2e3cSanjBIRMCRI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UbtSxQ4S;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763028165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJ4GxbkUghftUZgz8LHIpmZo8o/kmvfsJg9H+9W9+nY=;
	b=lvv8iD+ScPzwzbZtxDN/2VZYxv0/9ogy5mqd0zjsMzeZ4V4gBvrh4U/DZk+lGCYw+f9CL9
	oKqsFAwDE2Xp2qv0quAIRqJnePhSbPDG8kAYkKS3w+eNS2bw8GWuM/rbM79+yIM3PuHzVZ
	qNt+yx6q+bdAQD3+O+366F2SY70AUZo=
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-b7277324054so78007066b.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763028164; x=1763632964; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MJ4GxbkUghftUZgz8LHIpmZo8o/kmvfsJg9H+9W9+nY=;
        b=UbtSxQ4SHfVkiD9E51EUcur9OX/dg4VrlyeAaFt8qVBmVMixp9wHPTxXJpCXIlnIfh
         qmp+TkATGGVQXEMYn6JZT0QbLTit3zbuIEUib99R2h6XfiT+EH3qsUAfUINH3eGZ49BI
         x941CmPsY+vBl04HBfSXhbA7gCNrWXid3i9J1Le7ZyRzlaIBBdummwjieAc2kxOrh9CV
         XlXt8cevHK+rdGZouFYf0FReXzWw0KKoO62CXH6QzK9RAdoWAD/VVBeDLILk4ZOP00c6
         T64cG41gxgiNc1PoStai5hR6b3uUozeGK4OFuU0nUgCKVaYcyOeyoCJYdpzynHnBAbOM
         /d+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763028164; x=1763632964;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MJ4GxbkUghftUZgz8LHIpmZo8o/kmvfsJg9H+9W9+nY=;
        b=xKCiKBhZVwh6EDaa7wF3z21ls1NFxwT96UdbjGNIGBqFLbIRY5zIvOj7hQ2a/ddoA2
         /SfXQIR0g+fSXQeqdtYxonGSKsnom75aFEIj+InkmtOaSjbiSX/Yt+L/3JaP3BYZj5uh
         WHDB8cexrPPxeLKR3hMjZGrp8fim+JzAdJaSHhYQ/Q9+SlXheJWJ0UE4CdkVG/pHNIpm
         P4La0M7RSSus4AakW7K5fU8UgY/cAY10fprs5qykAFQvxM7m3pOKTlzkYwo2bsZ+VnpV
         bCrgJR6em3D9FbInxrSAltoKhipRu/prQgqZ/DsCZtjPEWOXZfv8KpArmloDUX/Ydr3V
         1Pig==
X-Forwarded-Encrypted: i=1; AJvYcCUYFn4YhoqMPg84hNEpDmuJulr8U+U6AmqzI/sO8dg/bX+npIMCePrnzHaOinCPEOuFi0DJNYjX7w==@kvack.org
X-Gm-Message-State: AOJu0YzkuqLHv3mfLhSAIWEVyi3s7PQtSDQ2Ghl4doqk9jN319ujwdJ5
	ro8B3j3KUPxI8LoaArc4SBQKZYNP5AuBaVneYBdtm0GOZWD0RsB60q98xOVBdrfD26E=
X-Gm-Gg: ASbGncsHbm/c7vBmi9m8TJMCy3rlQRG3c1ujVPe9Dc0YogzZgvCmmM5gxamTl5FUFmQ
	trXG2PG+r+mzazZ3PC3jaOPlF7yhJMK7r9V0dIMd8CHQ2MNNs29bZHrdV+y5bs+Gv+tISj7WAxy
	jrmCWTzbxy62zy/4GyMWeCi0OzOMIoDj+2Nb1nIbXzyvda6ueBCO3aARvpvNu61Drq3IcRT93X+
	/0lwHNESzBZHH5z75XqaIGmelHDutizzEXtYcOLC69KHibrDNREe4u+DL81gWhWKpE8zcxi1y/P
	ko6yhj8GT482IlpYENQRliDBGA5De8gWmS3z5St80V77sLgBLAOQXH2xW1Gxd/pmhp/JChag9K2
	SoO2yI4EThRZUjCktFA5k00G3yWqN5YHQ5scO2TYBtNJHoWaNeJPUgpSCCLBzTVzKe4RtaTZafl
	hy5Of+0Jw5cO8kV5VrymYxcC04
X-Google-Smtp-Source: AGHT+IHzMgr8IXl+lxvWL/AmsNusVkAzjm9LLmMgRR0v6716of7tCRPkKpAGaASPUUXN6pEg5IRywA==
X-Received: by 2002:a17:907:848:b0:b73:4fbb:37a6 with SMTP id a640c23a62f3a-b734fbb40b4mr169500766b.64.1763028163438;
        Thu, 13 Nov 2025 02:02:43 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa81223sm133331466b.4.2025.11.13.02.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 02:02:42 -0800 (PST)
Date: Thu, 13 Nov 2025 11:02:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <aRWswVgIaAqJEvQB@tiehlicka>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
X-Rspamd-Queue-Id: 5707C140015
X-Rspamd-Server: rspam07
X-Stat-Signature: gp1onkp5mg86mippf8nb9hiwqt89kh94
X-Rspam-User: 
X-HE-Tag: 1763028165-248335
X-HE-Meta: U2FsdGVkX1/8e22PeaWQK6bS9gU01GWjpEkXtjZ8k/lU8bJiJ3NuBPndmyZHzRkB88d9/3vhL0pcI6esfWL7v1Len9LiO3GZf7SDkIWyuLdSQPtERMUJPosxMhLWxlJJFQB8mQCLeI4fbS5MJcAGM0Y/9d3zQAp46I0wFOIV3+cKcqCnGUU3IjVKM2GLxavQvuHWxYcTtem7ruBWVr8Z23roAPhFiipMEheajLT0LJeI3pfJ5lCJ2V2kMdXnjDBYPn8+SUGeRMwQLxePZJt64u2OXf0A3WGh/22oEh5Gl6KjIEXQ9nKlK178ld/3P440WWYNK+JX0D9bNYP2OmswAz65cjx5y2l84a/Il4U3aLSVF+H4LTtXdXlzVSEFT9QNE055++yM6spNA8YUmJ3aKXWLMyB9FJjfqbnkD5/o5Uewm1nKYIrtygbbPShnnIk1exN/T+rptN5hKCKy2jNuBV2Aph6YehgfVe9swcFyk4lieoiEULUUfFDGHWyXcoaVgKY2e1/lbtWInmjqTmMiQ8USw6joxv49H2bfwlvNRTgdd+71EsUKtOlMwGLtLA7ZVuJ9lqxwm+EOJTig0DK8/NPN8LqX3M+vAFKhQTXqylPjIYKsQGGE+vUMc/zhescTANUie5P2kzC9pizV+BRIrzIfb0hP6UhrxJnhjvRxuS73+FrjgUNzUNU0BxO9ZzxZ3LiMXj4fPjtJx1W1Lmg4obUQUhD0AE87NwoUysof+P/bHo7zp8ntrOSH7PkqgNFocSuh2kj4zL7zdEQMSmC8bS/tO5+8HwsZ1lNBtEUfaWumDDB6KChIiMlNcYdJeCxp7vx4wLpcabnlz/V6JwgzjLNM1IsPezmR7gNOJJNIX7OFxao9s+o8DrUNgH2WrSbxnJsGJOssZ+q9hcVnK7v83MsNLziUZcXkeqhAGbyMUK/4ORGAJy25rGto8bQR6uGMTCLJCx9Lh0Fp27VJVbM
 KXmxWQ3q
 aZ++Rope4bGXemR94XlQYg9mC+QBpvHF9Em+Qkg252v0PmYXLkQiRvd7PNLoFU7RJRfWBg3KHitbgZpGLhUMw81CPcH8ulBcxr6n/hR1SW5c0HDBhvm99PVDhjYhawZmi14tOe6F1qOW5Wz7JtYguc5orP7heNMfFWlKLaVrb6XYE6bpI1l1PVkk31uc0NGKmJjDyyKOixW2TrBa04yEqEOjLk8Psu2w2BLO95YHbFcZvvxHDeoz1xzNd0cX2IiVOIUHbGe/pNXeNJOagBsW5zhP4oZpGLWZPYy+fIOuvwfyW3FH2MnZmaVdqX4dkeekM9NZe3so3qx9X8lEn/BSLeChmwtP1KySVqjgaLStbecHDsNehmNgMYo5I0pPlvVbXhrf2QckugqTsTibimQab/Ugd7ryAJ8jKroA/3Leefs+4vwS+4fqQBqCe/gYaYeVF16cDOt9m11XPFh05RtjLN64TDZqYDFVB6dYOY082tthbOy8EqZde46FttM5WwRHB82zgiVU/9mm+ao/qoeaU2TuMt+FbuBMr37bCPDwHHEea3A9UfPYmbV//sx/vUmnN9Q9h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 07-11-25 17:11:58, Shakeel Butt wrote:
> On Fri, Oct 24, 2025 at 10:27:11AM +0800, Jiayuan Chen wrote:
> > We encountered a scenario where direct memory reclaim was triggered,
> > leading to increased system latency:
> > 
> > 1. The memory.low values set on host pods are actually quite large, some
> >    pods are set to 10GB, others to 20GB, etc.
> > 2. Since most pods have memory protection configured, each time kswapd is
> >    woken up, if a pod's memory usage hasn't exceeded its own memory.low,
> >    its memory won't be reclaimed.
> 
> Can you share the numa configuration of your system? How many nodes are
> there?
> 
> > 3. When applications start up, rapidly consume memory, or experience
> >    network traffic bursts, the kernel reaches steal_suitable_fallback(),
> >    which sets watermark_boost and subsequently wakes kswapd.
> > 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
> >    triggered by watermark_boost, the maximum priority is 10. Higher
> >    priority values mean less aggressive LRU scanning, which can result in
> >    no pages being reclaimed during a single scan cycle:
> > 
> > if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
> >     raise_priority = false;
> 
> Am I understanding this correctly that watermark boost increase the
> chances of this issue but it can still happen?
> 
> > 
> > 5. This eventually causes pgdat->kswapd_failures to continuously
> >    accumulate, exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops
> >    working. At this point, the system's available memory is still
> >    significantly above the high watermark — it's inappropriate for kswapd
> >    to stop under these conditions.
> > 
> > The final observable issue is that a brief period of rapid memory
> > allocation causes kswapd to stop running, ultimately triggering direct
> > reclaim and making the applications unresponsive.
> > 
> > Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> > 
> > ---
> > v1 -> v2: Do not modify memory.low handling
> > https://lore.kernel.org/linux-mm/20251014081850.65379-1-jiayuan.chen@linux.dev/
> > ---
> >  mm/vmscan.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 92f4ca99b73c..fa8663781086 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7128,7 +7128,12 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
> >  		goto restart;
> >  	}
> >  
> > -	if (!sc.nr_reclaimed)
> > +	/*
> > +	 * If the reclaim was boosted, we might still be far from the
> > +	 * watermark_high at this point. We need to avoid increasing the
> > +	 * failure count to prevent the kswapd thread from stopping.
> > +	 */
> > +	if (!sc.nr_reclaimed && !boosted)
> >  		atomic_inc(&pgdat->kswapd_failures);
> 
> In general I think not incrementing the failure for boosted kswapd
> iteration is right. If this issue (high protection causing kswap
> failures) happen on non-boosted case, I am not sure what should be right
> behavior i.e. allocators doing direct reclaim potentially below low
> protection or allowing kswapd to reclaim below low. For min, it is very
> clear that direct reclaimer has to reclaim as they may have to trigger
> oom-kill. For low protection, I am not sure.

Our current documention gives us some room for interpretation. I am
wondering whether we need to change the existing implemnetation though.
If kswapd is not able to make progress then we surely have direct
reclaim happening. So I would only change this if we had examples of
properly/sensibly configured systems where kswapd low limit breach could
help to reuduce stalls (improve performance) while the end result from
the amount of reclaimed memory would be same/very similar.

This specific report is an example where boosting was not low limit
aware and I agree that not accounting kswapd_failures for boosted runs
is reasonable thing to do. I am not yet sure this is a complete fix but
it is certainly a good direction.
-- 
Michal Hocko
SUSE Labs

