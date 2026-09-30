Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7701CA5FAC
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1E836B0088; Wed, 30 Sep 2026 08:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCEAB6B008A; Wed, 30 Sep 2026 08:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5826B008C; Wed, 30 Sep 2026 08:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACBD6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:25:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29B63140778
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:25:34 +0000 (UTC)
X-FDA: 85270349388.20.A88C0DE
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5DB8740004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:25:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fs8odDhx;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.76 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AE3TJ96gqAayN6Olyj2FbVbcdzFNDjBGHX1lD/f5unU=;
	b=KJx8ubdKXKZ/XBjHW5sAXmpLfraLeVGiJFPPadc5iL1bjzmzlalqrDxL1j043nN8pWvEFo
	m37L/ZRm/T8TVFRHoe+azsATOGjcyZQXyAZzyKVWzu+8MldbsTYli91+yL3Mjmb7652RMD
	Rkip+o+pbbl+fP7NmohB9QQCRq+8A2o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fs8odDhx;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.76 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790771132;
	b=dzFT6NrkhzCjP6TPhibR4bf7TDGmWBVGZASISHAAB92ve4IBfoHzbFe1dKtUdPGgHZSWyA
	Hgbu3NqJRItyoMehgb0zxTAHZs1vDu/PvlNhmmRoD/D5KbPWmsd09D12z8vIrlGOSyIxf5
	s0fxRn0FYT/U6mNQL/5jCWTid/Gl3jY=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so3085239f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790771131; x=1791375931; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AE3TJ96gqAayN6Olyj2FbVbcdzFNDjBGHX1lD/f5unU=;
        b=Fs8odDhxxbnyzSOLrsriI+OcS4ceDG7v6c0RocFb6O4NnHh/IDeyWigwBN7vPCz5qr
         /Ft3R+UiezMNMiakw5/kTk8paV8EKB5ZA5BWDsmOVykuMxdTL0luFhP1d5YyQUwejxR/
         WBxTfZx3XFgigifhmy1GruVZFiByW61bZXwDd9LFSceHDr2As17T/DkbGb/JANCOJvT3
         U6m5TkkSersTT+IpcccJ0W6fhcqGJjBS/xKJPBoCkKBIMp3bffiTtloXNBaCXAyesTq4
         nzb0HJNy9JOXZ04V8SgNJ3LATN6K8stVYi1sSfT7RI3X/AdQmjzxVMLrWK4d5NBq0IQW
         soqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790771131; x=1791375931;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AE3TJ96gqAayN6Olyj2FbVbcdzFNDjBGHX1lD/f5unU=;
        b=AbI8DHZ7SgHJzEhFhk63xIgE6xL97BxAiZ1lmfmgQFqTDlMwiMu7y49aLfloKP09II
         6L/wRBsruxambgnyHP9xQYiEbJ4bSYnc55fCdQIqEL5uLUxETVL5tOcdFy1UtgWSLFR9
         246D0YbVnJfZ05vfUUgP9iNI6psjfN6p0WDO8hL1Iv9ujDHt3sHVNRvZDTjDGuqLUeVn
         qduStMzT7tIKEVfVErWMdGA3PP+o3LdtwpvuUpvljri1YmMH8ggvXCyxtLHgwDMOV0ay
         FaBajYVwEyxhOz++z6pbDMiLujsx2RyuCZt4AlZ6maDTpS3meYRE9neSxrO9spG5WPk6
         /o2A==
X-Forwarded-Encrypted: i=1; AKwUvByPxlmay1GekVSE07z2TzjColfBla9fw7iH0iTsn8Xu+3obqRF0MGJdYmaZcey569AecXbawv5hqQ==@kvack.org
X-Gm-Message-State: AFq9FYKTTnp5RIk490gVfcS5tWAq5OfZ7hziZVr5RIwg+gBXsynuofr6
	l1ZhKH3j1jZpjaT8kRRuSVKwGVClm6/6pAF72X1CfhDaISEsmUvQuaesG7ERXcTKWlk=
X-Gm-Gg: AYBFou2ZLFwK+HmEZPpDS2c9MrMDlMPURy8+mcTvoni1JOCSmUnVe7cV3DB/GOTe/ez
	sXDOEUNcnex6W+u/3IYkjaJ+a8o69tcGyIxEoPbILPM01w6+4TcX7Odw9KO2JOimd557z9jGB+O
	sX2PKyjiolvtv1fS9fcubf8RZVVsha4ENpGYKA/N6FGcnHVURQA8D87m/wWY6JW2ZCCNn2H7qqG
	v63NGCPYz0ROhqvc2+yDVYx0kXaSkTgmEBWDbUpRTiW6diSY/djuLehkBEYpN18ETVRchRPUXc/
	8whkDPcpS0+ZW41xmpboIDrJnETf53ZaxB4Bom9i1/MFGfx1ZCSzzdMDhsFa6q6Z0TDSTzRmDJ3
	wBDlFW1okiQvPjKelONdUuyjHvy1Jl8AR23H8T+8dDffYt/i2Yhm0W66BUUR+tLUESKRpzEtgI4
	B0PMVHQzgMP/Fvrpmq1hgeath0wHz5tBSFO47kZ35RSd8d3aqMuX0CKzFLTbGgvJfbIls=
X-Received: by 2002:a05:6000:471e:b0:488:5fca:a837 with SMTP id ffacd0b85a97d-48b024d96a3mr2492614f8f.20.1790771130871;
        Wed, 30 Sep 2026 05:25:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b029bf85dsm3449812f8f.13.2026.09.30.05.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 05:25:30 -0700 (PDT)
Date: Wed, 30 Sep 2026 08:25:28 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <arz-iKWj1gRO3ALw@gourry-fedora-PF4VCD3F>
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <arzLw18RiTN6Hmey@fedora>
 <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com>
 <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F>
 <e195b784-8a78-4bbb-97ed-168dd86b3d89@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e195b784-8a78-4bbb-97ed-168dd86b3d89@bytedance.com>
X-Stat-Signature: nqff8gme91ti8s7ngrzqecabffmc1tx8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DB8740004
X-HE-Tag: 1790771132-574037
X-HE-Meta: U2FsdGVkX185juP7+DmYyCxhc09xDLtXt5RkGK/o0N9yTpR0kgZSjQZTCx+vG0I56nFq6mWJSBohehhaLps+D+dR7rLaOr3lGugZszfBmLQ6bq+j4VK7HZh1GpQAe/fMGd92TrsXWW9cAb/h84lTam+1AM3MWAy1O3CMLJsDOizMK2RNZasDbkzHZ7IxhBPrsXCLO9uhF9eAM5X6KhMOe4aP+mRu6fNWerM4FuVZk7YqxbwIKGudOy7fsgZfjn8Cck5yG9GjPHksH2BbavwD4xUmSszkWFPuvEtGFluvtPNfqB1or7IiWBzFeJSocNRmR0mWg0ahg1IFR7t3XdJuwMSq3BC/3qVPC05CVCQBPCeSs3Gy9uSq50T4WhgIIUHwR3+N8Hh9vyx+ml7c0FlFLUkGM6LHMfrKBUTa/VI1TFiUoiZIM/xG4bfxZROfdfl0o/uFIFLBM/MtfndSxRpfjJ7GI7o8uzznbXMS6V4zLzNdIFspUFXDhw5ckaeHMCTMHZLRTlv+TDlAv023m+ORi+tg1qQu7G04gGZDsH5okOoHYJckNAQaJPko0gaUpph9lZBbP5qma1pqeb3xt1u1o1NzwOvQgWOrS6nCbpanB2MlAQK1w0xyoTmjK9EJjF+qU1l3jfrdUN6Lrd2uwxWMee/ObkP9Y/b1zi6Coz4UpvgCMsVM6xua+oWULOoyK2YVVNBK73xfRdD+JqUUn3vwtJeVc/razubrndJBUKj70u5PPk4MpWi2gOB5xRqLV/m7MoqrG1fwv3naYzJS8xQI0LMvjDOiDUSGOHeu4gmdCi7T9xw9pZTXr9P4J4CUUmxd/q+i8/+8lvXqF8bqnzLY4tTWkT96ZBuK37ehqjakmbTOMTz8ftJDlDBqQCbpnfhII7WeKTW/ciUEWa0nB3vmZy44I0Ms4rsCfIzFRS3xbAexX84F9rccdktdvTm5xiHqRhcc0Y0HDEyvSD9GT9e
 ZekuJLZN
 RQ12EmL+CaDxi2RqQcsDZNqqGeqRzgtOTrxGdCjiFspbrjEogLcHjot6783Q7wonPBq+/B+gHsCiOB0dY6D6vQt/XG25YelZXjbosZS+/OfTZMUhcHZYpQ/sIIdjhwLs9EOtYTOYg/FE6ucawZXVmEAnqBwyPEbNe7ti1QMmcfRfJ+TqG68tT/CcxQjFRyv3NtqV2Bv8P5oA05Va2dmz8H4LrOHrQT+QR1Uzf0PT2Cko7CM4OToryDmkA8J1Z8hvVRyhi5yVdCuI3AibMpMJfzudgGsu7QEcblmVsp8vthXhmbmK9xsPlGxnxbcgkE72FPyBx19HxLrltknIOqXpKORnwAw0kZmMsyiz14GSAbfezwDAM4kvQUOwju4fVFIkNnjvJntPGOBuT3mn/cR+7VNWdIZ9ebGL63N0vRltUarUucaMa4cBlbBU8OCoDriI7akUe7HIIZ79Wp8GUsN6VqXGJbEsyDNoZNucrcomZkxBam2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 07:22:10PM +0800, Li Zhe wrote:
> Yes, that makes sense to me.
> 
> I do not see a reason to keep the MPOL_F_MORON handling limited to
> specific policy cases. The flag already means that migrate-on-fault
> placement should target the accessing CPU's node, and the nodemask check
> is the common constraint we want for all policies that opt in to this
> behavior.
> 
> I will rework v2 to handle MPOL_F_MORON before the policy-specific
> switch. Then the switch can remain responsible for the non-MPOL_F_MORON
> misplaced logic, while MPOL_BIND, MPOL_PREFERRED_MANY, MPOL_INTERLEAVE
> and MPOL_WEIGHTED_INTERLEAVE can share the same migrate-on-fault path.
>

I do think it's worth breaking this up a bit, we can decide whether we
want to apply it to interleave separate of the larger change.

there is also slightly different behavior for task-mempolicy and
vma-mempolicy, because vma-mempolicy applies interleave via index while
task mempolicy does it based on a rolling counter, so you'll want to
think about what happens on repeated faults

i.e.

1) fault in a VMA interleaved based on idx
2) a bunch of tiering and pageout/swap happens
3) we fault a page back in based on idx - that means this page is
   forever-faulted onto that location rather than taking that as an
   indication that maybe it should be local

Maybe we're ok with that, but we should probably think about it a bit.

We may also want to limit this based on NUMA balancing being in tiering
mode vs normal mode.  This only makes sense in tiering mode, in my
opinion.  In normal mode i'm not sure it makes as much sense - and
that's probably where this all came from.

tl;dr: If we want to change this behavior for interleave, we should
probably give more thought for how it should apply more generally
instead of just hacking on support to one or two modes.

~Gregory

