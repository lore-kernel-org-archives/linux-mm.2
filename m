Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D6E606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHqd8jGo
Received: by kanga.kvack.org (Postfix)
	id 845096B05B2; Thu, 26 Nov 2026 06:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F61D6B05B3; Thu, 26 Nov 2026 06:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5006B05B4; Thu, 26 Nov 2026 06:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0926F6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:13:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7599A9047
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:13:28 +0000 (UTC)
X-FDA: 85477009296.28.1034237
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2AE8E120005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:13:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHqd8jGo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691607;
	b=kjslJdwD/VMF4owN3b7TyOZLlT2Id6UigEBj5otTx0solWVyqJKnDY+giHtup7vTFM2Iwd
	4wQd6vnE0gVRaTnmGJqngARYZLnP9QnBNIAW7VFymeQvaq4cLQvnitsXIdJT71/MgfiMiM
	EWuwqajSnQIPWTbj/uk32cqtVs98Pl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyEzruHSk3PWNRGlXxnoXSvBzuBF1VHW0e91SegwgI4=;
	b=vOZh7HPPYvOWBPAKjztF6wUHqJZaHL2J2y399ZVp+SNECNGniuFqGHZhSecD7Vz8GfIISn
	fDuKNZLClLrZxveXLFJrXDn1EN/EXwl2/8m+GwIn+W5XemjTXSL7V4ibKxsX7K5SsN9d34
	4wJbukirxRBJDdRuTybGZxcT2ErOydk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHqd8jGo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A73F4618C5;
	Thu, 26 Nov 2026 11:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750331F000C4;
	Thu, 26 Nov 2026 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691606;
	bh=QyEzruHSk3PWNRGlXxnoXSvBzuBF1VHW0e91SegwgI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KHqd8jGoK63FBGz6hruXqVsJj0+OR5Kg92zKXvALh22HB3TDrcoyFshXfuUHkjShG
	 X43MCgVG6Ql4ImY/4qE+dBYhOUtvDRdQ5Wev2E9cRKsZ6KE56T5+f0qr/tW6uiQKbW
	 hVaGU1yCLlVKfSlzPravL9m5+aPBHHTQGkVJ8Ux9BezoV6AQkCI3nItKg0iJXcd7e9
	 z3KKWdCcYd2b+f17PRrxM5csYQg9fJ8v5RHyyq6mxVrzii7ig9D4ko62yh1MVahScK
	 B3lfEeMOIyw0XxB7xd7Ep+vMDo6FusSnITcevpn8wBF65Z76U2DPREUVw3v/TSJmiu
	 HTpO4GMb6fWBQ==
Message-ID: <d1d7e82c-a113-48e3-801e-61dcffc4c747@kernel.org>
Date: Thu, 26 Nov 2026 12:13:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: Fix the name of the memory hotplug online type
 configs
To: TAKANO Mitsuhiro <takano32@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261125193039.2437025-1-takano32@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125193039.2437025-1-takano32@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pwo7kdmn8ow8xufmqjcrqfkrirkja6ja
X-Rspamd-Queue-Id: 2AE8E120005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691607-89118
X-HE-Meta: U2FsdGVkX191WNYZngB+/+si9iAoKTyHxoeqBaCfkV8OYxORHGRtCQHKQe5V4Sda+o0lvO4A1EjvQBMsAmi4Ms7Zq+TYECvbrHwgM6V6rkRwdf1X4TVxwTSJqqNFiwVbRL1y8stoSESR1EWIviiRg/DKRMVQxImYmYMOlfCEJ8ajlDq6SUtvKPLhQzMsmMPPyNSUgT2RLx/co9GiwTLUReXxOR/fn9DFZP3bMyuwBvh8yQCAJ82vJPn0RYvzvqJ/dtoZERoINOuHmcTKkIK+VeHK9gPUKb79CNsXRKEfX4ZiRH4efaa0XR0zuPRD31P296TVyFQssW1r1whD2qps0qCC/9mL1KbNodLkSMCMwF5UVdeAB9615NeEi3obEDIefhOzQNffh42DWXxeJlfnUBUAWhL6eD+jKIOF9RIjZIL07Ngf5LaNuWVyHMpXmnKKuwur4apog4hiMqtDgDGak+buaa55yA3PAiEHxZ5VSNkPGxsdWCwfdx7UfCwxNQpOC+V8EPBfW7vbAUI+riTepcINs5uRWEKKl6/tB/wLqWrs7lXQhDu4C3ANU5RrZKFiodyFlV3txbgcXB4QH9uT180EVGEMmIXvZ11jlBvWv65SKFWqGOxqpOHCHboG3a2GCSJ3sjIq4Tsahwf3dmiUSLCsMKK6z/cy1PXY3JGQXY2Yx3vMO8n6mUygikXQDIYB0s6VK7Txh1+6kABtP/BnBVeVkwnjqbHKSO/8h3hQnCpx59OLA707ZFlwwowqmt9XVC/r4kaLyPheLIkL2K3CSxGSPYG1WOGf/WcImZOlcx+qX1tOmITA2wX774tcdEtJL+/lFgztYvvodlGxdXsM3Q7KkOy0d2lQsjWUlzG6r2bY2jR6sryV/pFW3XksuHDSl7XiH9tiDzjujHmbdDGWwpdooOG/zOtsKp95A9yFfV0F9ifGMg3Gq8V0CSXlUSwAbKPCnDz7QSjb89NaxOS
 wFugAbAP
 ccGz0cqpw7FpWJ+uQcJKuD8zRNYz2xphWZo8Qh+VL2wMHxX5fXEapYmvCO3rflxVMxoxuRBIeoHd6MrYGiorUClHid+lGg1etuqYBMxYCA6JKFfWvqn5ibWO2Gzfn/4aHbrIQh7gWryzAYipC0w0XTu5zRjJ/Lx5rlgrqXx5p8mPSvt0gnTbjYEW/ZH/G+BUzNCSN0A1cwF3aVbn1RIjSBjL5EzPuxuOBQHVWK+kOPJkO5v44f4P1/s7TDaMwn7iAuiShRbtmFoSLOSHIG64+Dmt9O2cASAV14PTWL+eaObvS/KzUZk1HY5jrPlBah69d2MGjK1OgC3gjRmqsOtCYTcjZpwDSn/G4VApOZ3939gEMELhMEczcEj5At/Kt2h1ctYC9ia0eQ0NWIY4+PfHlWJMxhJIoCOpFECPBtZc340+mMiL+ZgvicUi6eTDHhegG52ben6tnIa4BJGG/KUphRhhS+30j72/ea+63AyYciwZ8ZbCXkpDRTB5Jw+9VhKs6fP+mhWjz2SV+zD6Pysyk2dWqIFTQ2V6iuMLC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 20:30, TAKANO Mitsuhiro wrote:
> The default online type is a Kconfig choice, so the symbols it defines
> are CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE, _ONLINE_AUTO,
> _ONLINE_KERNEL and _ONLINE_MOVABLE.  There is no
> CONFIG_MHP_DEFAULT_ONLINE_TYPE symbol, but five files name one:
> 
>   Documentation/admin-guide/kernel-parameters.txt
>   Documentation/admin-guide/mm/memory-hotplug.rst
>   Documentation/driver-api/cxl/linux/early-boot.rst
>   Documentation/driver-api/cxl/linux/memory-hotplug.rst
>   Documentation/driver-api/cxl/linux/overview.rst
> 
> Spell the family with a trailing _* so that a reader looking the symbol
> up in a .config finds one that exists.
> 
> early-boot.rst also gives the zone choices as _NORMAL and _MOVABLE.
> The symbols are _ONLINE_KERNEL and _ONLINE_MOVABLE, so write those.
> 
> Verification: a build of the tree defines
> CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE and no bare
> CONFIG_MHP_DEFAULT_ONLINE_TYPE in include/generated/autoconf.h, and
> grep finds no reference to the bare symbol under Documentation/ after
> the change.
> 
> Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
> ---

[...]

>  		       See the ``state`` property of memory blocks for details.
> diff --git a/Documentation/driver-api/cxl/linux/early-boot.rst b/Documentation/driver-api/cxl/linux/early-boot.rst
> index 414481f33819..be9d5e510f99 100644
> --- a/Documentation/driver-api/cxl/linux/early-boot.rst
> +++ b/Documentation/driver-api/cxl/linux/early-boot.rst
> @@ -34,7 +34,7 @@ which dictate how memory will be managed by Linux during early boot.
>    * Linux Build config option that dictates whether the kernel supports
>      Specific Purpose memory.
>  
> -* CONFIG_MHP_DEFAULT_ONLINE_TYPE
> +* CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
>  
>    * Linux Build config that dictates whether and how Specific Purpose memory
>      converted to a dax device should be managed (left as DAX or onlined as
> @@ -61,7 +61,7 @@ SystemRAM.  This will expose the memory to the kernel page allocator in
>  If `Specific Purpose` is set and supported, :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*`
>  dictates whether the memory is onlined by default (:code:`_OFFLINE` or
>  :code:`_ONLINE_*`), and if online which zone to online this memory to by default
> -(:code:`_NORMAL` or :code:`_MOVABLE`).
> +(:code:`_ONLINE_KERNEL` or :code:`_ONLINE_MOVABLE`).
But combining "CONFIG_MHP_DEFAULT_ONLINE_TYPE_*" with "_ONLINE_KERNEL" doesn't
make any sense. What am I missing?

Maybe we should just spell out the full config names then?

-- 
Cheers,

David

