Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C940AC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 10:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164BE6B013C; Thu, 22 Jan 2026 05:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C9A6B013D; Thu, 22 Jan 2026 05:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E716B013E; Thu, 22 Jan 2026 05:30:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5C1B6B013C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:30:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59DC8139276
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:30:55 +0000 (UTC)
X-FDA: 84359231670.21.4032DA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7C8C140013
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:30:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IEPPxBuZ;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769077853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sduvtt3pXg704z8GPOI1TTWW1Oiqiob70YQjjylMVtA=;
	b=8pMzQ3WMyVODNBc3PN6uh2q+hDLQXAMXpvYWId9Goc73/LdOVMm6t7Rpmn36snz8xhdLxf
	LYWDKnBmiz3OG9qSKZNiZugx/MXzcnffcwsg34X7xn2SdyYBvIBy2GjfB5QN57umYVZfag
	fsEHDecyr71xo9RcAi3cpfpiZ++r0ho=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IEPPxBuZ;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769077853; a=rsa-sha256;
	cv=none;
	b=fVADKi8K6RgK/Z7DESU9690lsjSN7iSvJrL9j3mOtTD2++GuMz7hysdABQK/jN4N2pqqpG
	iBqc5tpvmwLOry6aa3rkekgEg/Ur4HXFkdmmim8DEm+3oZBsiM+nf/vSgJBs9mcgDoARH9
	Dqvu0mLrxjA7I/2fPuWQRTJc/ugcmsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D818600C3;
	Thu, 22 Jan 2026 10:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365EBC19423;
	Thu, 22 Jan 2026 10:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769077852;
	bh=oob4836ApX1NmCp6W5wN39YQoJSroAdcAzkzIA4BG4I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IEPPxBuZeQAaoWrm0Q/0yacJ6g8aW1SaVBpZxnVfWGy+98v4PpmapYdHzAUnOPgb/
	 9A1htMHuYPV1C47RCzZ5adWPCVUaNSmY3Dq26rpXwBiBP4KkmTg3mE5ocLIJJKeV8c
	 ccUksZFyagWuncViM/Edd04a7N2s7a33xzRZTVSUOX/ovxbsMMjaSDIiEyRCjN+/pA
	 xEH0yu19hHsYXNuDX9zModUUvano+eQfwho4D9p51O0iwKavo5DFq9ip8BZBies1t8
	 Y6zAdUcX0Pc9r3Gqu3+mYqEvOlTMA6s7H2VIOWmWN4gQeANNFqJPLCqgyynoFVU5n7
	 jNxA3pGCMQITA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,  oe-kbuild@lists.linux.dev,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  lkp@intel.com,
  oe-kbuild-all@lists.linux.dev,  linux-kernel@vger.kernel.org,  Linux
 Memory Management List <linux-mm@kvack.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Re: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc()
 warn: missing error code 'err'
In-Reply-To: <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
	(Andrew Morton's message of "Wed, 21 Jan 2026 12:39:22 -0800")
References: <202601211636.IRaejjdw-lkp@intel.com>
	<20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
Date: Thu, 22 Jan 2026 10:30:49 +0000
Message-ID: <2vxzh5seaqhy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 791hc55ffigi865eupikocaaet7zp66k
X-Rspamd-Queue-Id: C7C8C140013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769077853-247676
X-HE-Meta: U2FsdGVkX1/U6oVAAnoRwsHc0Jr+XyajYnuw8Awru4PJydkZALI7OoFYvHrH/sSAKcTpdVCBoR7wzxSYF1P84HGiaOheb5aydCztYGiaSZu4Cu32Rb8Phh1xYYeo6mX6OEElP/iaHuzU0dyOQEmdnTBmA+ncsCOmyeulPaufy3VVWoUxpWlnFhzGe5lknWQ5ivhqgdIygEThLYa3WjghP9OL1ixFiOLWRFIDeOdyLtRHq7gXXG8ICsC5BOdZQYEbYC8D7j39LbA14YAKCeRbdvAiVWAzZylwwv/zWaCHMRpR4luILUJki+n4xYT/9/nUhUhU8WD233kg+6/9kZ9T6xEkOn0v0qxFxw+o6U/RQRrLVuJx1QyVHAxZTExrIvA+CHa56fVesZ3Vy0Chl8+rWpTQfC0zWSKPrGXwZKzcqzJm8i1nYN0Dv7ANhdYWXzhFtILu80qfEtjtcJb84hyj2WJG70yU8f3+6PHdxhwNJIpUXn7cShfOCRrXzcGz8y+cLv7QVViE4IhseH0sWTmJr7rjX9iccGQWy8q4XAZZ51I10usIt8EPqrNx0hJZH8CLXvTBm4E9yF9f3cFfGNnDBfdYhHGrQuVdC/lNHnBLkFWjgFAbGuUSe3VfwRfnbmBlbduAzFcSrMuxMrxSsJdlQbAkV2GaE2lMHBMyG47L8M6AgoSvnYJwqb/cB0SOLqNJbjPkAPZD9JAvTB7zDbtpM/34tcaCKiz7Bbu6GgHNVD2cgwz5BNLhjHKcboW37znvklg33QBRgIajTSx2oeBlXFBo8ilRBnds+W1u0QQ8hPyjUQj7ecOqv/Ae7FWVA5ZkUm/4wUEhd2MU9O+M36V5PvHhEeilIgZiN4N2du5qOAA1YO+DmTfNtgAwJON/0dbw1G/SImH/eu9PJXr2Y8dstNEOX5G4bqOuyC+RIW788O+gOBLZDmEWun6yzJguIMowQ5WXLnNoVB3RPzCpNI8
 a4dULmbC
 Mqthhg4EUELaqKN6JWsRSxIJBBJlgu8WAbiA5XHx6QS97EoRoh0p4kUDSvQ2BATkYDSwcND+yJSMDwPOcEfUfwztElmO0s9dK1nDLY61xz7ucp082Y2VS2W0H7dxhCnc85B1RJgn/5yjK7lZcc8cetOjUSAAGAGeG+XofylZ2Iwjmlv3ZirgT41iCc+3Uea16B96hviY408IqqtjHYZ5I1SnnXxtYFmzjOYrTV4h5n6GHLk8wTSV3Lh9ZwsD3eS/Osp93q1vySsbfYeBxT7Pv1MhhvajY4uRTsd8BuoBg9WKn9ssQ4ANpgTDfCE1hYeQdY70B84L5aO/KCVKuGM1mphq/f/pgdqXBKDPEU4ouZebLc+Bf4R62lAmqohrGh1Woc3BoDoJ47qrg96NKjl+Ujnnei6sZlQgPCchFTUbMnWRqY3UPOsZi4hOawjFwOvkr/RMqopIe1i8PNphi6OrhjBdSoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21 2026, Andrew Morton wrote:

> On Wed, 21 Jan 2026 11:58:20 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
>> Hi Pasha,
>> 
>> First bad commit (maybe != root cause):
>> 
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>> head:   6c790212c588fddeb0d852f2790840753bb604b1
>> commit: 48a1b2321d763b5edeaf20bd4576d8c4b5df772b liveupdate: kho: move to kernel/liveupdate
>> config: x86_64-randconfig-r071-20260121 (https://download.01.org/0day-ci/archive/20260121/202601211636.IRaejjdw-lkp@intel.com/config)
>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
>> smatch version: v0.5.0-8985-g2614ff1a
>> 
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>> | Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
>> 
>> smatch warnings:
>> kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc() warn: missing error code 'err'
>
> Indeed, thanks.
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: kho: kho_preserve_vmalloc(): don't return 0 when ENOMEM
> Date: Wed Jan 21 12:36:17 PM PST 2026
>
> kho_preserve_vmalloc() should return -ENOMEM when new_vmalloc_chunk()
> fails.

Thanks!

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

