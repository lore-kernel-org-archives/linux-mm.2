Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0698D3E788
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 02:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8B96B0005; Wed, 10 Dec 2025 21:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89736B0007; Wed, 10 Dec 2025 21:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E866B0008; Wed, 10 Dec 2025 21:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A44B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:53:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 196DD5AE21
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:53:25 +0000 (UTC)
X-FDA: 84205669170.13.E14D3C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9107FC0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:53:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J08opOng;
	spf=pass (imf22.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765421603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54bOQMjE86a3OvBo4Z5xX+IGN2GAizUFzbeuDsoGB3k=;
	b=4FOx61wTpzxd8D/x+0HSgD8WFGd1QfH5TlwC/sdwLsF4S3VebETfxomPMtOh/kwhxs48Uz
	ViZQkie4EByYgP1TJQWB9FPOEJNjuyLMkDAvGOBGaCg21KLiMBRLTPyszVevzZb/fD+eDL
	bhNZ4iskrNmFLQvcX7LQnmIp6K5Iwdg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J08opOng;
	spf=pass (imf22.hostedemail.com: domain of ricardo.neri-calderon@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=ricardo.neri-calderon@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765421603; a=rsa-sha256;
	cv=none;
	b=eOkszgwCngbiyOjRnI0LW2kuAB7RUiZunYDA7MC55IJpZAFYkLISVNPAd5F6ySkCw3lxmj
	zgZkYk4p7tdpAiIIUVrZCIzNL3DXv+BjvIN7kY9BOOjluK0C6X41oU02ftDjxOzlMi66k8
	KE7A3bl+3+2dbO2sHHGDIoPbuxMhHgE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765421603; x=1796957603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nCP4Qrkpz8bVZqCHE4sJmyUXXrSPtXg/5yZwtOzX+cg=;
  b=J08opOngke1umBZevExKoS8Q+VvpR/LnN3aELgMmGqYPtpvZ4a10x9JD
   1/Rn6r98ozf7YZO/q6VPvpHBC4W4GDTnqyHBtXr45V3E6V6/dio0IVWUA
   GBUNMR1LGy47QxNZs3DvTZW+wEgNEXqhUCPUjfpeN0y+65C7IKBcaPqcz
   9fcN75jBTxHu9Z8ANXu3hWa2h8F0hy0Ji1mwqorVhK5gPzExY2XJoRoqW
   dNWx2R76Qb1r1EJpWF2bAUMGTOdjMNDHQOzqm9M1mLCb+Ha3+muJDU9CQ
   vY2geRZ3O05OljZxkV+EjvpfLnCVlOle7sVto3RzoU9voT6YOHnsv/Kfd
   A==;
X-CSE-ConnectionGUID: c+FumnzhQIOoFw5TB0Daig==
X-CSE-MsgGUID: +4iEVMfNTI2P+SofSO4bAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="78765554"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="78765554"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:53:20 -0800
X-CSE-ConnectionGUID: Zev6oIoBRpaOqU2xDpbw4g==
X-CSE-MsgGUID: oROrgDILQmSBZQ6XsbXTuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196738003"
Received: from ranerica-svr.sc.intel.com ([172.25.110.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:53:20 -0800
Date: Wed, 10 Dec 2025 19:00:06 -0800
From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
To: Changyuan Lyu <changyuanl@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	anthony.yznaga@oracle.com, arnd@arndb.de, ashish.kalra@amd.com,
	benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
	corbet@lwn.net, dave.hansen@linux.intel.com,
	devicetree@vger.kernel.org, dwmw2@infradead.org,
	ebiederm@xmission.com, graf@amazon.com, hpa@zytor.com,
	jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, pasha.tatashin@soleen.com, pbonzini@redhat.com,
	peterz@infradead.org, ptyadav@amazon.de, robh@kernel.org,
	rostedt@goodmis.org, rppt@kernel.org, saravanak@google.com,
	skinsburskii@linux.microsoft.com, tglx@linutronix.de,
	thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 17/17] Documentation: KHO: Add memblock bindings
Message-ID: <20251211030006.GA9333@ranerica-svr.sc.intel.com>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-18-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509074635.3187114-18-changyuanl@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Stat-Signature: hdaiz59afuei1hmosq33gkw8qd5d4d1z
X-Rspamd-Queue-Id: 9107FC0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765421602-885284
X-HE-Meta: U2FsdGVkX19t7JuQs0S7hXeAe6iHqyEUiSrPiCCgWrbHnuh7E7H8siBEOGmRpngdpkgfNrNga3fb19In5O3mktAvrYoIgtmlhfNu1xkckIQnCPP2/hdiE84ptLLJ3exJeD6GrzxYvUKmEaYvPvCcaTi9OoDz9loh5DTnjVt4urA44QtM7p1AJ6iQxmeHd0GubAZCQy2HFQjd9pwtrIQCxSvrZPdjm7KCO1KN4Wo8H5hU1Py1TVvSluGcTRIHdLCvkIXa/UoNqUa3eHpirIxpwsndOuw8Ft/1iATkV1KXS73Wf09096MamsBxpBiI9qY8gQPtP4p8sHuBYzJU4X/ZbvICSXmV3mqiLFNs1lQ9G4JBESpWRib8+R4if0ReiEIV7mbLyhNKeG0arcEmevK2xK133+L3tWRDjNK82cFQk4N0wKErtv5/7NMkLOOA/hz/OPFcAsjYDK03H0+6Fwq47f2eVPC7ZdOL8siptwECHtV3/fZsMX5eiyj0AyMXpJlUhDptNEZ3yCbMGpkDBADecrITON4F+0s9mfefTXw+UoRP6mKzo4s0TJfJbl/w/GlEP+oGIHOBU+Qqyn35hOwWKDbxFsCqdrQHce75xW6Q+FaxeWW6druPH715VAiLZWaXDTmkG0gWNx4zHB4fbLbLhjHXzAMTk+eCIRDs1+qimWY+Z1MqeOK4lFS9t2d7GeZ2LPql+it4vhpSeSeCwJkjTcULPeU2yoNP46szITnCRajJiuWg1LCk52Ir30K/vK4P8BLdSifQcsOO7QQ9Lon+mai2D+2DyiKWzDPtLuiKEKcqQJ0rSGFPNodTIGZOjZPvuTvHg5fFV49lp76qGIoXVpiOqpUonh2mCHE0Dgthp61J2PJbTf0WWoXwZ8Q5h0Dfiv4rCxVZZfN4jrZ43g5ihn1EJ3D1S6pzzlXNbKBa1cmM0ZiXSWtHvzES8E1A9pQOv/VPxuo0+lzma5nYCwP
 TQuBfl1y
 jMS3eQiGQJFBpKMtr7Tp9srZUwc8jvZyQ7Z9sHo4mlMol/JoF/zDevwnL9mqwuYz1yBY3oC/GeXmseggMZh11El6m7UmuiquGtSd8XPM4Dt2AJW4l3yvbXCj1hobVULbvG7Sn2Y0tBYMpzu558mM+lTJPyIBokH/zYludoghGjAw5SC0DTTbvNHgNnunv8HzWIFd/IzQp8h75CUTcknjpG/CBoQFiMLFJtyuI6d0uUma4xQ4qE7ntUTpi+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 09, 2025 at 12:46:35AM -0700, Changyuan Lyu wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> We introduced KHO into Linux: A framework that allows Linux to pass
> metadata and memory across kexec from Linux to Linux. KHO reuses fdt
> as file format and shares a lot of the same properties of firmware-to-
> Linux boot formats: It needs a stable, documented ABI that allows for
> forward and backward compatibility as well as versioning.
> 
> As first user of KHO, we introduced memblock which can now preserve
> memory ranges reserved with reserve_mem command line options contents
> across kexec, so you can use the post-kexec kernel to read traces from
> the pre-kexec kernel.
> 
> This patch adds memblock schemas similar to "device" device tree ones to
> a new kho bindings directory. This allows us to force contributors to
> document the data that moves across KHO kexecs and catch breaking change
> during review.
> 
> Co-developed-by: Alexander Graf <graf@amazon.com>
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> ---
>  .../kho/bindings/memblock/memblock.yaml       | 39 ++++++++++++++++++
>  .../kho/bindings/memblock/reserve-mem.yaml    | 40 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 80 insertions(+)
>  create mode 100644 Documentation/core-api/kho/bindings/memblock/memblock.yaml
>  create mode 100644 Documentation/core-api/kho/bindings/memblock/reserve-mem.yaml
> 
> diff --git a/Documentation/core-api/kho/bindings/memblock/memblock.yaml b/Documentation/core-api/kho/bindings/memblock/memblock.yaml
> new file mode 100644
> index 0000000000000..d388c28eb91d1
> --- /dev/null
> +++ b/Documentation/core-api/kho/bindings/memblock/memblock.yaml
> @@ -0,0 +1,39 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +title: Memblock reserved memory
> +
> +maintainers:
> +  - Mike Rapoport <rppt@kernel.org>
> +
> +description: |
> +  Memblock can serialize its current memory reservations created with
> +  reserve_mem command line option across kexec through KHO.
> +  The post-KHO kernel can then consume these reservations and they are
> +  guaranteed to have the same physical address.

Hi Changyuan, Mike,

I am sorry I am late to this patchset. I am working on a patchset to use
KHO to pass reserved memory regions to a driver after kexec and I have a
few questions.

> +
> +properties:
> +  compatible:
> +    enum:
> +      - reserve-mem-v1

Shouldn't this be "memblock-v1". IIUC, the compatible "reserve-mem-v1" is
to be used for the memblock reserved memory regions, not the memblock node.


> +
> +patternProperties:
> +  "$[0-9a-f_]+^":

Shouldn't this be "^[0-9a-f_]+$": ^ at the start of the pattern and $ at
the end of it? Or is this a KHO-specific rule?

Also, IIUC, this means that names of the nodes are hexadecimal numbers
whereas the example below has a "membloc" name. I assume this does not
refer to the subnode named "n1" as this does not follow the pattern
either Moreover, it should have been documented in the reserve-mem binding.

> +    $ref: reserve-mem.yaml#
> +    description: reserved memory regions
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    memblock {
> +      compatible = "memblock-v1";
> +      n1 {
> +        compatible = "reserve-mem-v1";
> +        start = <0xc06b 0x4000000>;
> +        size = <0x04 0x00>;
> +      };
> +    };

Thanks and BR,
Ricardo

