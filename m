Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CF81091900
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029A06B008A; Thu, 19 Mar 2026 14:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000B96B0092; Thu, 19 Mar 2026 14:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E802D6B0095; Thu, 19 Mar 2026 14:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB89F6B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:01:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34D701B8816
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:01:52 +0000 (UTC)
X-FDA: 84563580864.14.91CF1B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9042D80023
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:01:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vC8ZbpRC;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773943310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS3wev+eY2RmB+NFZLqCzPpcdWMpN9BLe1HlMuAMQnE=;
	b=kZQn9WzSYztNQKEJre6JrYJtz/3f0iw0WxaRgWalElyhfvt+7FeRLbm13q6/LKpp7vnynu
	NTAaXp+YRY1KeOyzq+BNjPFad7FEM/Me+FUbxlyFy3cbl3j9ni7/hRs15YS0yBt6nuBSqO
	JFz9iIkJ+agNxufzgq2p9MKOMEXKik8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vC8ZbpRC;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773943310; a=rsa-sha256;
	cv=none;
	b=SL5ZISuRYwx3/9NmAr656qAM74Iiw4jtf6IUniwo8Q98LW1Gh/M80CqcN9HoVkK3FpqWo7
	2GuD8ipnMrQm4eqX6cWP/cK+LSNFWcJ8Q8YhDQ2DeUlvbPh276TswFORzID1qc99ZQD+XR
	ug94TyJDFzm2J3Ij6Mpva+NYMmRIUPo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05C2D60053;
	Thu, 19 Mar 2026 18:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19108C19424;
	Thu, 19 Mar 2026 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773943309;
	bh=d8Ua+A/ZmT7ca7E47NnupRZI3JWgVY4ZVGJGbFjL6pM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vC8ZbpRCDasLUGHIy/bphnAPICpvqYVhHZnYtFWNW8grGwKzNgU6HZxuwWk43FoKd
	 O0cegRoluqUInzy3D69im9C70FBrZUu5fhRjy/YDU2gcuEbYTqVadnoyI+0IJwf2sH
	 tMOtJ7Dkrql095BjESNqPG+PBzFOBLZ99lDEBZL/bwzk14UEZ9buqFpOxEdmOQZUCd
	 j5S/UkZNemidFsCodBlc4GWhydx+AnH+gLLrCKKP1fRka9bgiu91qortzioS2wpkll
	 lmYjCkbfKI+vZQS3T9p6+M0puLhw2EmI4pYQfGvsitc2Xyk4eIpvmHONcB2FBwwPxh
	 v5/RLVbLIFmeA==
Date: Thu, 19 Mar 2026 20:01:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <abw6ByiCi9mOZQof@kernel.org>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
 <20260318190816.1811325-3-gpiccoli@igalia.com>
 <abwlsdgNWtDeasLT@kernel.org>
 <9066d011-7dd6-4d2e-26b0-72f83d3e5862@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9066d011-7dd6-4d2e-26b0-72f83d3e5862@igalia.com>
X-Rspamd-Queue-Id: 9042D80023
X-Stat-Signature: 1x63fhzqqoxc5zbp6kmbqju3bhz1azbq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773943310-988793
X-HE-Meta: U2FsdGVkX1/GKxyvr9HbIv45Mplv/ZiLSy2cArOjspT/m01CcBwaxrzG3F61HCYTd5vqEtlAd3eZo1vv2KA1gnxetgC9kBxGBke5Ug2N7C0IS6FwE9FxPKXIAgwPe3U8s0EW769ojRhnYaPDFsZb5RQA8ahpfqq1oFc2sjb6Qyt9pS181kKmX7ffiPUQw+lxUIHpneSrUfs1sHf6fHiYSg2zA/kaSHiRHeqCnlxQXzl4+PKFZcwwP1TPI7l47KUkV024XEAZa+P/nknfBEoHvTfLTmUfYu9Id8O/RaRO0IYdyVCmaA3n472Pcx007Qa5hyLysNHA5o93WT7+IDg6/Vnny5s8SPHGjJ8qB60/kw6tV3U2K8AxR5i1KbIDwZQdbWTckzvcRiCXlDP+ktY7zXME9wXl/B+C8dZMr/Z6017rZwn+ZEnOLAXvr719r5jIMWMOSAZvnWYrT0F2LevPNLbFiNoz3PrmDxRij9+k1/DID+zoRTBzsfUwEfJsD9UMmLrNBmq3iwCWHqKXMgRMFDEJ038MrpZ521np7n+/qkt/Pn0TwOZjjdle28tQfA01PZcLxKexy4UE4MZOroZxV4bPy0WL9Nyigo/vonpcQZukgvhI+UNQvRDHq/cX9aU/k2K0j+nsoQuQqA3Y2v41xtmUKmFBKfrJ/xWwnVg0rekxSzOZXq3lLRdVzqO08lo1+gXSlR28jkF65sWMALQJsoxUljwDa5S/O9Rkj/r5fRH9anRxlVoA/gS9Sxqoyd5GQyFKRXZ5Uy9dF6eDGG8IO5/1GfEwm/Iz9QpOw+wHVPwo9pXiJWPk0w9bl4ZZYmDKwk6BI7h4Vn4dcYi4GB1ilahB5lfIx9fSbwOm9/RJfouACUWXVmQ570L2II3bBw3v6jnsrUnBtcfP++rtCDjhAnYrbm54l6ntfKyCbQx/CaPAA1Eza2yhq48mUGe5guy9z4dPp2QUacc0pBhdy9u
 wBZY2PYp
 RRH6Fgcqn98MyIVsZ/dn5+suwLbihvTzOMKdBxIrMaMiSShra9Nd2jz9GVtqYFlrBnuHp6yf3ZMUq+f3yifvs3kG3N4Sx6CUzGc+PSoR+R8P612NCBojCImp0ZDXE7phv0TMTnVHfXHYGTjtHaLJtWn22wqpBXbjcIM3XtyodxYqTYMDhZy1A+FTZq0okeFjoRuTMmPBUpf0Rf6ByOBnKf73Xo/jdV0TYnHGo5NcjDWxeXY4bSMdvW4b4oGTJWoIDnkvPlliCUNEmMatF9VGZdc/VkxwVyJ2dNa2lnYkWS0Sb0fQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 02:14:00PM -0300, Guilherme G. Piccoli wrote:
> On 19/03/2026 13:34, Mike Rapoport wrote:
> > [...]
> >>  {
> >> -	struct dentry *root = debugfs_create_dir("memblock", NULL);
> >> -
> >> -	debugfs_create_file("memory", 0444, root,
> >> -			    &memblock.memory, &memblock_debug_fops);
> >> -	debugfs_create_file("reserved", 0444, root,
> >> -			    &memblock.reserved, &memblock_debug_fops);
> >>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
> >>  	debugfs_create_file("physmem", 0444, root, &physmem,
> >>  			    &memblock_debug_fops);
> >>  #endif
> >> +	debugfs_create_file("memory", 0444, root,
> >> +			    &memblock.memory, &memblock_debug_fops);
> >> +	debugfs_create_file("reserved", 0444, root,
> >> +			    &memblock.reserved, &memblock_debug_fops);
> > 
> > No need to move these after PHYS_MAP attribute
> > 
> 
> OK, your call, will change it in the respin as well.
> Thanks,

That's actually more of a rule in the kernel: don't introduce unnecessary
changes :)
  
> Guilherme
> 

-- 
Sincerely yours,
Mike.

