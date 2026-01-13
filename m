Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D70AD30CC0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 20:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BE16B0093; Tue, 13 Jan 2026 15:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE60D6B0095; Tue, 13 Jan 2026 15:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8576B0096; Tue, 13 Jan 2026 15:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C50356B0093
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:05:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7708088BA6
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:05:04 +0000 (UTC)
X-FDA: 84328019328.05.4C40BA5
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DBF3100003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:05:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0muJ4312EJ6gGXEPQdwyzyI8xQcdUomK1P5HrD6iP7k=;
	b=ubculZwRKmkOmFgLnSLFZZaj9Jw2Rj6Ts9relOKR5uJflTqviO/Ff7ZncM9g/x6Xodteth
	M03HgimZrTjGabZMul6LLRhQsA7sO0M4X9ubngYtoP9xJTmuLnh0obzfrbq45Xompxhw9/
	8KKwBQfLQU8ir5na/GAcoOpk033R3mk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768334702; a=rsa-sha256;
	cv=pass;
	b=S4aEd7yNhnGcgb8lQP3GrBLAQ/LjvJKQ75DE5OPCnQaZ7yo3I0lK3osGiXURHFYEC8eqqS
	AC5gxKrBru97iKYbzEm402dHwdzKf8Fg8e4nbk0Em7+bUoaIp+4fsLMsaiEmyV+ROqKYoK
	liUyGSRMRSqfKONdDAVgiC1pi2x3Nwo=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCBCDC1462
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:05:01 +0000 (UTC)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F3B0B7A0B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:05:01 +0000 (UTC)
X-FDA: 84328019202.18.C021E41
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9031A0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:04:59 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768334699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0muJ4312EJ6gGXEPQdwyzyI8xQcdUomK1P5HrD6iP7k=;
	b=fi/uWs/qKmcG3I/66F6NtmzZ12FSfqEPo38xDn+7yQtEzu+Zw7nVQJka1XLQM39I990C9R
	/YMG2SLA5silXk84LVaLGa9Cu+zIi1locFFFKT5rq95r3363IWD1iWMdzBc8eiFbD11OZ7
	z+c323GN+41lYw6UCX5rSJ1pSDiPNvM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y6O+mDMi;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768334699; a=rsa-sha256;
	cv=none;
	b=ST+RS61hzfwkNGOEjh7Pax/lgQXkiDxCe+03ktQbP9EaYJEQYCZGezfWsZ8+kg1Y+Xlbas
	G31OPosa7cCxBFabRWEudR49osWy/2Ji6a0dTltVVQ/ljQmMU0k99pLovR29J9IB1tdkah
	AXwTeGgyXWZ8fu4u/9n8Eh0ZrZl0HgU=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso36635085e9.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768334698; x=1768939498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0muJ4312EJ6gGXEPQdwyzyI8xQcdUomK1P5HrD6iP7k=;
        b=Y6O+mDMiRmG3BUthkh1BH4Qo5dVABKWjQXAx7TJwDS54kOOK7lfEPNv/ckhxI8uiXh
         Nd6QOBjsDFffKErGu3jjv/CA12W0QXk+sGv1l5roVadwZ+k7ynH002JyF8OsRc1Xs4Hw
         MsHOlgxF2EyZekqLdCc+R9dTJeOnfEqeZSh4p/mmGhU0ua7vigaqaYOq/CJE5eshNGmO
         gpa3CgxUqNhlirvzY384rF203BbQFFb2+nDW8P6BPsSA1kOm8Pfy3zUq0lBcFTaD9rCg
         XyOjkyr7puWJbjJR3rL5Lp7Vt0cXv66bHklA/Cmu1GXHZI0hTcjALu+ESLwjPJRl38Ka
         +0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768334698; x=1768939498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0muJ4312EJ6gGXEPQdwyzyI8xQcdUomK1P5HrD6iP7k=;
        b=CYnNyppnZDatsSpxeR4gAudIqO3Ra5o2wq6Rh3vFY4EY29T/pVwQUywZzWFFwPyN/O
         LFTEvb8w3rK3mp/JBjQ+b2CtplMzkW6NeKml1IDX86CVOQMkzVsW8Gfj9QKCBSm7DV1U
         Xs8GSH1FFD+rCPK7a65UxDH0nCcFyL4rgXN6RMUFPZIfADHeWJBhTtk/uYqZPVotBhTL
         /k0/tmuSuSDE/XFdZ6pE/77hDW5kjch/u+hm6HHKFz8aqE8YkS7b8KZ9GshXGNDDERXG
         M5+7cfysjqN7XWqXvjXiUs537mnxRy+wc75u3lXNJCHpCrJ7oXIVSjENfaiod33KRpPO
         4Mpg==
X-Forwarded-Encrypted: i=1; AJvYcCW+PReL0f00a8sy5ved7y2pM8Gv6xldQ9lv5U/TVtO7nKa07sNPq7ndrndEXA3IGnt8JPmBDMsgNg==@kvack.org
X-Gm-Message-State: AOJu0YynSJ0GQHialLZVuCTus6+CESOf7WYyBqUh733er808vv/4fSHc
	92mC+CP/Rb/NeYZUPusdFTMg5fcQgN+p+tCwM4/MGoMKLUuibmCNOpWL
X-Gm-Gg: AY/fxX4UjkQFGGUU22psETA2fwXiZYKHzikSga5a/fmnEh4DEyVlrqemIFCPwyq7Tsd
	9RSHp9X86ifYXxawu4Pr0Vj5ojI5a8+v2CBrhUqSva4JyC2m70p199lEVLNH+mb4NaliCLEqlf4
	taBjan08q0x3Y70d3QoCVwtJXpz9HTWLtKxHYcUjrTnaYEz9X9CIagPj3cyCiHyoHLQV5iUn80S
	hajGgdZxd2wBnn4xQMK4+f8PHzJ8Ym5iYW4iaM3+ep0CPK0KAe3nSggZUgU2gWEYQbdl89HhGWu
	dzT5YtFo61u/d4wUREUnbio8F/i/Lqh0ZwQpq4I2b6evtIeJIBIng+eGZVafOCraMYPBiovQHf9
	lyJtKi30b5r/hXFacZkUSQueEOsorT5Jcf9WfFNCKcQvj/SgAikFhubQbAlyNONjw4q9KEigQIm
	Qd/8K98ZJRWobWrVijYf6sW1eUbzKt+tcZNdvdMT6gr4sTgyY239k/W6dg9nxtyvo=
X-Received: by 2002:a05:600c:4443:b0:477:9392:8557 with SMTP id 5b1f17b1804b1-47ee338d53fmr4231585e9.18.1768334698044;
        Tue, 13 Jan 2026 12:04:58 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0daa78sm46840666f8f.6.2026.01.13.12.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 12:04:57 -0800 (PST)
Date: Tue, 13 Jan 2026 20:04:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Nicolas Pitre <npitre@baylibre.com>,
 linux-mips@vger.kernel.org, tsbogend@alpha.franked.de
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
Message-ID: <20260113200455.3dffe121@pumpkin>
In-Reply-To: <202601140146.hMLODc6v-lkp@intel.com>
References: <202601140146.hMLODc6v-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HE-Meta: U2FsdGVkX1/4WZh3csDRkRRcuRqqST7tEr9Xlm+PE4DBFKhG96rcLvE8Lqh0s3cMrkQbap/RHNkMY47Vx1FDsbEO57ODUpjp8swPdGwcZ104T5Qii+hEpg/kOCV6hGuYI38gI3DGUco3sHGAcyGt38Gbtc14dXqN4VX2zHvaeSsjOpgtzNbJGnXmKbUKlIX0CCpr4wNb8xybnslbhE/6PBo9/faZxt84uIeYNLsenXRyZSS82Scz+B3RY4zNrXim1eedu35So1LD1rrZ+vmwseQaStLR7uXm9Nawg72/FOp/mRWawsA4Kw6AMG/VjPbtnlbtE7ykXthtIdyzEbsLb2/bs3qRkjCSO8/fq65oK1OcLPKMGqitVh8c6/AxBhWFXwL2F+3o7r3R+LEdEFLkAEDBcVECckSh5VRf9lhiA2EuBTCwLkcrutLMl0bCj6OUt64Q191dsZCRhc3+6II47+DNsRh7xEUVJwSzUZJP4AKz13CQ+O26OdEbX0v42sMbt2qWQFKUGhsU7ZxW1h9GjH2gyV4kzqc+LqNyMdY8vFPX5Qq7Xe6DWYhVcbLw2xmF8NwX4oDstKlaOxC5j2ri6Ti02wgllnP7eHEyGoe8y9wPdlyXnYvor+ra9I05EusaRx42YtSJGaYGD6FeBc3Q14AAvhJcd4M+n+T+4MqdnfL87OV6wwUCCHY7e2NQLsHVrPMf8GL+lU7uFWudWNynokkRfdbwC+rYPtfLmSKpY2s67IMMfpZyYncCIBR9VePjlpIwCas5BHwEB/++uJQ4544XHZNZw+im08pkno3PIY9TDE/Y5hl/PsGNKheiLJL2WTs+/JcU9wJpMrETMcDKsbeyeEu6HVcoUrzp8fa/Amp3hAIG2/NtI41HRWlFqig64oVQWpbUSsT1K0CqAYsQvp9aUnqGrFhLQmmkjuFTrVvSBk7rGC5GRa6xdM9yagWYCe7UV1Vd9KBPa47MSNy
 1rd9Iu9a
 AowhtjSPcAgkNz3Pb0PVIuHHVp0NPiaIoYXq5iPqUMXCSPTTx24Db7NdPj1+Afis58e7ycDkUSB4E0h3Flbr11GbZ7/Sm99FlIDL3yYEGdIbMUJrLmdewflVdx0xtlDuWZUGGQsikPtpY6U8bI/8cmJOF0HovktagB9XMzumJlKSSknqZ0KD5UaCcrjY1jYQ9IVD2zZoUVLvEFWiPkRrZoV23QFnXBBsWWOFoLCUPjf9Q2YKR/YWBDQn1E2pFg3Y9x5dPKh1wBW+8MXGCOFOqG0+I6DUsQq3gBzSHDsPdMDEFMD3MYSTJalwkU2SijJ+PzHfdg1kHghdCcngqxrlfOffb2QLYRlw4zSmSoDZUEoYEOEV+Ma7zIE45o0MPhgt7ykrKPd3yNYvUqO9H0oXZbZsSK9HFXOYheOFLb2qs04cE5Tvv1KwHV9MM/DFRygk4zvj7Ka/uxSftX9uc8+lrvY11AQOOZEJ7EhLHKlTghrUX+5aqH74+KHeL/92/YeETkw/g4ApDEAs93m06I42QKOrBy7Nw7VjZrtOv8W8MSXA5Xm8VVMVqN4U7RrdFBJmcgg+Q
X-Stat-Signature: ppfpxyxejadrf9cwj9d18oatcefoqrx3
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DBF3100003
X-HE-Tag-Orig: 1768334699-741476
X-Rspamd-Server: rspam08
X-HE-Tag: 1768334702-425411
X-HE-Meta: U2FsdGVkX18mFiYFvqDB4hJ2nymXpjR8USxmqcXP3+UDIwmKPP9QKSlf0GlqntuIzDjGJHmBuEIkMmgoV4lTt84nV5CB2dUjDs7zYsdeZ9atpcnIy1qCLV/LcJMCFXxM/2+ZxbCy3eeVjX1/ceRsTk3+v2pjazGhItFcjQxtWDpOFeMppJT1cGCmF7hkE56ctVUN8NvuYISy67kHHFRh30+V0Jeabtzc0t5eBfOmNmj7+R9YTe7foX6dSEOac/m7j9SuwZKCQXLrQFd67Ofylzwrdk5kWlSf2bzPtw8RvxXcGpp5n3oYsyM+84n2MWdkPNwdPkO7xsXrKZZBlIbNxECXuajFj52SCKf9ZFjUEH4i6UuqB0H762yrKgT3LLK7wqJAv2Y9PljvLOtkIs0Z/GgGDtLkzCE88dTt8GPUsbAKeGJJgbzYWDX+4a/tRjBCIgFxswnVb7epHggnQdyVcPXVemAa8vXUIddDjgOnhB6YWMmxOfw1hNhvKiiejzh5PsRHaybjj4FfWJW6Ryk9NNo6Y0UdS8Ihwv/7yQ8jbF8i62nMjXkgYlCQqV/mwDgLoRbgA8qbeA8cIXGf1uWw4KbxFE8kdI/EzeFcRIl8MApQM6iFCmgtKVzvOtSBVj3hc2Pq7wkMEaw3AqmwZMk62V0tf6hLI4SjYJ4ZpOpcDAaQs1vbmMPTmKAntv3K0t84hFzzsCZArOdoScqsahQRw28XpRlc67Ifvuy/V0P2S5H7dcVLK+MtcJuCYJjl4VRioD/rCSPBBenjFQz6iYRkvc3VS7/xR/ZJR2dK6ZLJrrRDUzZs4KWOPNMevDg7r5bUe8dVeAKTEKq2rAiiNNPX/hEbYOsGsReqAYcE+AJf+w2g6i3gSUAzU4JLSBWTCo0vw33Nbt2etB8u3eRF5CthLpeucejqsGt3MNhYyKxT7W5USMk4uL97KK3AVlbl/E2m2LKs4BG1y8A+p70XuaN
 ny5xqNTV
 TL7ieDMGkmEkhhpmWElvQZMcMaeZz4FQidknxhuOpIgPL829YxaMpcqWGueXQ4XQskk169I8ZOArIGfnyA3AtiYatOBZQo9QeqdBffhioHLS0miw4XxR78Q8lNwssH+RjIpywo1RGEHsEa9cNgUawp0wRRZ61WyFaRBplVqZ9Lbon0ivlwCv93GH1eiox6s4RJ0fHJcvXMCpPyIkdQ6j2xlLjCRiZ0IDAxmYRkyfncICSu3yCtI4SEFyKaMTAGaFePaxMFuKlfJHzhoD48rFI5YpxXUmCfapc/HQnRilOTPo7pQRUJohBkfQLiaV03T5St2oV3LRrSSqrkdTBRYqEtp8S1067rPV9n6HGdwBHEX6cpgddi5kb3ipmLN7PsEEQz/MhxDJJxAFWo4xPUZ2YTvauwB1iE7MFgIWeNH46WcCzGWvvWds0reCP+0iortAXRSUKqhlR3wakkOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 01:59:24 +0800
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   b71e635feefc852405b14620a7fc58c4c80c0f73
> commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
> date:   8 weeks ago
> config: mips-randconfig-r113-20260113 (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/config)
> compiler: mips64-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140146.hMLODc6v-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601140146.hMLODc6v-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
>    div64.c:(.text+0x84): undefined reference to `__multi3'
> >> mips64-linux-ld: div64.c:(.text+0x11c): undefined reference to `__multi3'  
> 

This looks like a bug in the mips 'port'.
arch/mips/lib/multi3.c has the comment:

/*
 * GCC 7 & older can suboptimally generate __multi3 calls for mips64r6, so for
 * that specific case only we implement that intrinsic here.
 *
 * See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82981
 */
#if defined(CONFIG_64BIT) && defined(CONFIG_CPU_MIPSR6) && (__GNUC__ < 8)

So this code is excluded for gcc 8.5 but the compiler is generating the call.

Looking at the git log for that file there is a comment that includes:
	"we wouldn't expect any calls to __multi3 to be generated from
	 kernel code".
Not true....
Not sure why the link didn't fail before though, something subtle must
have changed.

I think the fix is just to remove the gcc version check.
The code itself just adds the results of four multiply instructions together.

	David


