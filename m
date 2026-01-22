Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAAAC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44136B0133; Thu, 22 Jan 2026 04:49:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04346B0135; Thu, 22 Jan 2026 04:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930816B0136; Thu, 22 Jan 2026 04:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9336B0133
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:49:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53FC01601FE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:49:23 +0000 (UTC)
X-FDA: 84359127006.20.A768886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C470E100002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:49:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adpgN6sN;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769075361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niC3ZIqPmgZvU8hV6cKqnhTP5zK/OcvEwYBFEMQbG54=;
	b=Q6jNMgfjllqraMTYERara3R9ZO0hCxqcnJ9vadV1W1E5ocswarC3vmWxnCENODVwodnZo9
	O1Wwvl/w/51Bs1nD/+1hyfnJgxepZNgIXBpnJIr1pUP3Vmj21xqOKXLxzdoupOQyL0ht5D
	pqlJELct11Z5O/P8H97bRxGmIiyMORE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=adpgN6sN;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769075361; a=rsa-sha256;
	cv=none;
	b=7QFJ7qonc53v2BAogfoWXAskqIH0QRNxCSkhdx4FSDtumOG+yfweUV2gwlMI//YdYCNY1t
	OtKBriumz0JWaFe288y6xmveBFJzulVrdWiaKOGwNS6EGknEe4R44trPAtCaVM0wo/a+L1
	G5CpBaclvSCxvGmZUl7afLuwc4cRcAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A453600C3;
	Thu, 22 Jan 2026 09:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51AAC116C6;
	Thu, 22 Jan 2026 09:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769075360;
	bh=dRV9tsm3tF8BwNf3UZE4OCSsbX34H1Ma1dmXtxPs/4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=adpgN6sNFvKPNN7MVXkTYjmvS7P8vMtwXhlHIVBZdGwJBKaAEnuGI8nZa9gurLgYV
	 +/N/KStwJKlul9n+sqTe2xlS4mIlhArYBVVXWBWk+C58cOzBMjgqJ3C85gwMAGvkeF
	 nHh0xE5eQqR0prbEAN1ChRBp0PAyeZfzAt4dV71ixCsihLoCiW2fqbW7eXb6Koq4t5
	 k3lBsl3+7qrsKwXXbFIxOoImDdSA8+lrbgh7ZhgSGS8Nx2GW+mHpkTPsb/Zn98TtYy
	 VnfMZbm515Lu9PpnuCGkS8+QzYU0FV+pomcfSist6Vl7zNsQ+smELTTlrnIB/Rt1UI
	 LvqlwwZVDYFBQ==
Date: Thu, 22 Jan 2026 11:49:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc()
 warn: missing error code 'err'
Message-ID: <aXHymXWEXY4Bia9C@kernel.org>
References: <202601211636.IRaejjdw-lkp@intel.com>
 <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121123922.c0bb0ef8505c70b99998c324@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: 8esbw5n53qhbru7ys1njbhybeodi3oks
X-Rspam-User: 
X-Rspamd-Queue-Id: C470E100002
X-HE-Tag: 1769075361-107359
X-HE-Meta: U2FsdGVkX1+2O/Ylp1+2Jc8dpGUAKXzwzB8xRxvuF+Tp5iC7UfKvsDVYRoQu0XKO4Ly0ggbd4DnxQBTRE879PnvEnpwkL69LDMyV+qtWh4UW6m4mGANfgXXMdVHA2RQEOiEog75NkfyMCs3vnqyw4vb10ziCxfWU+cuBYaoChe+e0iuwf6FnY69Sg/hvzmKgeVg9a/E/O8bEJKCDTZwwMiMFu17A+eCF5mjAe7kWxlbAU4YyNlnByd9m7Je/VEOc+hVCgvVK9yylN8kN9eJlGEaScV4B4I2cT2NowqhG7qnhy0UDLqOWw9NlVjDtEWAavA/n9SfkpEAVwR2hRv3PXP9EN8JcTw1l1wWVrnOqDCCemJufxLUgJUNDifOFeeXuKRxG2oKcjaheew2hsyn6Zej44t5I1/f7aKYZZyJHfcHyvbbsQNFO2DyF1lo62ZgmevAqFCYhAgrHlEPLZvU/1yWl/9P+PKoufvuvw/ilrZo7zS7bWhenL4Mb0WwttqnQkUqkY909kSPdNJjTZfNPQ42RrEghPhx5dMVsGuM4quVhMXY1AT+tU2SnborNR5n2OcFrzPI2hkwKI7/Pb58GFmUcrpsZ/wB/lgQKY4NYPrCBZrhT8C4I+gDtf07bDS5JkYA108t3xNdxUSE/SQvcUEbpNeJugGdOSke6lyCffEGhrp87xz3aAYNE+5GT06s/HuijdgrnTMIVuNUvhrpP6OukhEBFM+72vWfYexjL3cKuqBOY/A0gtFKakA9x95ZgicvvSmlDjI36A9A3wG6ys6jpmihoySKvoP635eTVkZTEp3HWb/YmUzl8yMay/UBsndlWKdHAqK5PNaj6U7/sS3o89kVu8T8tdVMKV45wuSxqLEenj4ZyYQOhKS1caJQLfHWPs8GVQGG3Tj1xCpLVDxMjNZ7ZBE3RJ0z5z4rJhtWpTJkrxKWjFS35GUVORLTJEId47+glt/ZFJj/7TTD
 V3i5n3rW
 IM4cm1mjOWtNdOXgEzaeqUjPus1GBDDdfk47dIlab54nrqaLm/LGLThu9crf68AsG+nbukiSYN1AMgiTO/A4dwz7giMk80wDVBvIK9+/U/dJmyPvpUBEOnk214CHAUT4MzL+FjVmelSnSryk+TJR5+IMogmXFKW9mU3vokZpzGbHdjtdF56Kpr9rtdgcBlpM4DQAOAJWlBIsimwJmCaNGfmsR8A3EGTsOtNoWLyi7iFGYG6xMchOyRAyF2BQ2H6CumwmH3oNFBFiisWz1rzBQCbxdS1PqpCPCdFOC4epanv+MJYovkNc2lmdwNmdHBVAJdtcd1M3yGBtyassW2ssbW1Wyp/s7Ji4kJsCUEOxnSqAxaXpQcb7llXsMG3OQwEL8MVXzolc+U9AHRNYIEV2QFWb6Lpx3RO1sqOxYywjdOjqfgezOVDdkhVg4zOCmhlEMFLvCCyOTKlDuH/b87HTz3jpayPjLctdDKQm7LyrTfuoBffDUQ7jTkEA9THG7oXzhAWaZHEEv2qLb0ldZFTS2DFxVelLAdPGvlD7IdOzuRUr6HRZCMWf8gAtoafHH9SpnLvdb3QQmqsk2/vvQxaL+XJfkSKccPtYmDhArqnC7RhpT8qBz1jdPvj/9EDxU6Bt7Pno4Ja6cmdSAFdSJR/ncqYUAeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:39:22PM -0800, Andrew Morton wrote:
> On Wed, 21 Jan 2026 11:58:20 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:
> 
> > Hi Pasha,
> > 
> > First bad commit (maybe != root cause):
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   6c790212c588fddeb0d852f2790840753bb604b1
> > commit: 48a1b2321d763b5edeaf20bd4576d8c4b5df772b liveupdate: kho: move to kernel/liveupdate
> > config: x86_64-randconfig-r071-20260121 (https://download.01.org/0day-ci/archive/20260121/202601211636.IRaejjdw-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > smatch version: v0.5.0-8985-g2614ff1a
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > | Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
> > 
> > smatch warnings:
> > kernel/liveupdate/kexec_handover.c:994 kho_preserve_vmalloc() warn: missing error code 'err'
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
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202601211636.IRaejjdw-lkp@intel.com/
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!

> ---
> 
>  kernel/liveupdate/kexec_handover.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/kernel/liveupdate/kexec_handover.c~a
> +++ a/kernel/liveupdate/kexec_handover.c
> @@ -1011,8 +1011,10 @@ int kho_preserve_vmalloc(void *ptr, stru
>  		chunk->phys[idx++] = phys;
>  		if (idx == ARRAY_SIZE(chunk->phys)) {
>  			chunk = new_vmalloc_chunk(chunk);
> -			if (!chunk)
> +			if (!chunk) {
> +				err = -ENOMEM;
>  				goto err_free;
> +			}
>  			idx = 0;
>  		}
>  	}
> _
> 

-- 
Sincerely yours,
Mike.

