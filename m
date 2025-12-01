Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC7FD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 23:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57826B000E; Mon,  1 Dec 2025 18:01:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07FF6B0011; Mon,  1 Dec 2025 18:01:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF7D6B0022; Mon,  1 Dec 2025 18:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 981A76B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:01:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C6EF13AD36
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:01:55 +0000 (UTC)
X-FDA: 84172426590.23.A1C8F06
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D782A001E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 23:01:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KF+aoW7k;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764630113; a=rsa-sha256;
	cv=none;
	b=0nkg5fB1giF2wfgRn8kHFfccvPAGq4/9uyPCnjMEmZdhjbNBTwOmsN/oqZ3OIuwXo2i/ps
	PRQnz9Ue/eUYS1Omnu/BixxZJKLHJNX/yGtCFLX38xOOfWZ4lvEc2v+FLA2OZBrr7CnY3x
	/qNJZNBn6CVISRyItjBlw9IiZXH3ybA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KF+aoW7k;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764630113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FM9m6+shkrVZWHZFI/zkz3EgwkEbfSOBAx27RgqiH4=;
	b=8fXpFQ7DS4ZZhRYMXOvbgyZWdQxNKIFxpTbQbHfshR8t3cCsLkyYnyin8Oc3TGJeB1othN
	9KGp+AUvYbKLU6sLqkdm5TuxKgQ0hMSXIyhBP4iicdeypjVDwvh4tGsuxP6arAVGJDKyVs
	fv/8KBivdUnMPUDtyer3cUgbqPdgqas=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-5dbe6304b79so1776011137.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 15:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764630112; x=1765234912; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0FM9m6+shkrVZWHZFI/zkz3EgwkEbfSOBAx27RgqiH4=;
        b=KF+aoW7kDN/vEmN1KQhvkWBdjRrHEnJPUJxFy32UVsggjZXxyLxZkjyalNccJaVXW7
         G55K0MDrVkGkLdlUcxtA/3rjILVk5G9E0Zk5F7S3DcOfuxihP9VNms8VjVH6O/uiUuOI
         Rs24Z4yhLIwu3tepofpk+xn2vQGbO9R1e7tp0/hTkY/UHQ/1pxQMbcn3dZNx6mhVNu40
         T4O4J3UxMv6wsX+UQhMSVApsS2HzueEfFKc6u8+ouvwsszC4vFaoxNLP0/DSnKwaFWtw
         qRsA7Ytt9U1cbHRFBXOWxFZZxDxmGGxzEZKIZr62CjhDsCHmArvS16PByzAS7GagnaFn
         JvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764630112; x=1765234912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FM9m6+shkrVZWHZFI/zkz3EgwkEbfSOBAx27RgqiH4=;
        b=OuGRsfj0TEztJcXinx6jeAflkW5tIsh7QaNsY+Pip1s7iRux3272PGYZCAg7+tHZL7
         Gbdf4ADYBygBiIOBvKpQZ9FEUJtiRG+L/HBAYaVnyhVg14RRuHBrPjjwT4LnTSChmJf5
         JoQIJpL6ZzxfSlG4LiX9jBUrj57YNBw0l42vXRu5otNA8rE/7z1OifYbfSprjTAIQ/IK
         Q5nN7ioM5bbadfi/xJK23xuesM1JiNnSPr5gcmfaxP5QDk4K1R+MBpWn9oXL0TLoTFD8
         DZ9+fZeNiXYkosw0TQ6mFBZq4ek7BjpeppGcgqpcNNqqpU/3WZTskzQxfvN0o0dt6t3A
         RjKA==
X-Forwarded-Encrypted: i=1; AJvYcCWWRAbjvsO20CxYkP000up7MmE0ZokvKeZs4Z/gLLIY05NzFc2c7dtVx3VgkSlEt6rY8ohGZ7mVWw==@kvack.org
X-Gm-Message-State: AOJu0YyRIIPhSmJxLvldS/Qh1x21I2TC2bFDzJ6EFJi8Tp71RmgHAwAL
	OT3T8ulXDM94glqss1fi6lRWbEm3xGtPLXRgqTvyK2t8k20dKNtoUQNDpvWZtpUNuho=
X-Gm-Gg: ASbGnctmvvsjoJ8eIjNPQUMExWyqkeoH4bJBDsiMSji0vtK4fUI+SSHh3wpkhKWu1Lf
	oHUl2YlW4iynCHc/nD7JSoRxAolWh3Tg4mhqoab64fDgL8SUXHZSV+QWyICv3UpRI4KPBlv1qXq
	eeZcW8bsyYNgQ5M9zKNSadVWP5IAns7zXOmLeToxHTBzjnV8YoqTycaiiaBpqHmHh25phg4m00M
	EJoIDmoa59COM9qjOJJYKVF+pOqJlIuHvOV5gw1UpJ5rTbgywjmoga91tCur/NcFQjFjRh3Ja9+
	V1i4QAZ/Eyh7oeSDiG2N6s1fYKRz3vwGmhlrllYzIgYBuaXVQ+hJ9v0AcznYScPGwNhe/HpXJGn
	w2CYQPV5RNcGWZ0GgJSHfwgdQNVFIeTEXtpdC7UGDRW8ZyqBAOL3uqn6/SY2jZSol2FlneENkLE
	M1/WGAQ3AHprJ16ox2MmkEe6I2IzKm2m3dUso0so42z2Ov+tGwtYl/KPjMi4vUl8RoYFDU1g==
X-Google-Smtp-Source: AGHT+IEX0yBdvL/OGp8i/pkCfIknydHVdNWVez8S7zvu1JZCPMc53SdulfUUjHQjqfE/lSQ1WK7jBw==
X-Received: by 2002:a05:6102:918:b0:5dd:b317:b433 with SMTP id ada2fe7eead31-5e1de0ed47bmr14385931137.9.1764630107354;
        Mon, 01 Dec 2025 15:01:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b90ebasm91346316d6.55.2025.12.01.15.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 15:01:46 -0800 (PST)
Date: Mon, 1 Dec 2025 18:01:45 -0500
From: Gregory Price <gourry@gourry.net>
To: balbirs@nvidia.com
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com, x86@kernel.org,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Ingo Molnar <mingo@kernel.org>, Kees Cook <kees@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Bert Karwatzki <spasswolf@web.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] arch/x86: memory_hotplug, do not bump up max_pfn for
 device private pages
Message-ID: <aS4eWZ-d4tyjVzul@gourry-fedora-PF4VCD3F>
References: <20250401000752.249348-1-balbirs@nvidia.com>
 <692e1297e3b6_261c110064@dwillia2-mobl4.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <692e1297e3b6_261c110064@dwillia2-mobl4.notmuch>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D782A001E
X-Stat-Signature: 8e9hhw4ocjn9foi5aobdu66i5f3t7x6z
X-Rspam-User: 
X-HE-Tag: 1764630113-892592
X-HE-Meta: U2FsdGVkX19En/nSVty8eStKBgFQDWKHxR/29vdPbz2XfnwHoRC5BGmVks+BUaLz85HRnT4cfxBEVcytzfv0M/tgSPcK8Y2DKiGKG9Su+og6/qCtyFWJNcwB49Bj27W+Iq0HJ7EWadkMSlQ6Tr00vhsLw8sdPh03UYg7Q22OPIFZGkY2pjFGHdYmCUTL6G5S/yvunGaiS6UnOioXmnO5Mk8NQIRpKxFpY1X4Iic7PGJvXP6Y8hjUaUQd0qJye7aM0obiyixabD90Agd9PypxgNXlGgGbYSU7pZa/ybxWNCwCuRi1RU66Ti6L9tWOaQFHEAUfQUQFMYbVxichA7TFFS/BYdDMQwKI5jHAtTpQssm1DcDQcX5adBKw7T5Np8sYLECndFGHVs3r4/tu1+MFFD32XTatFn5FaUqVN5qumeP1d+mYquMOfd75MV+74w0rxzv0j5dh2BUoRJ1p2XG9ylWd/t+/3mJj8CyDDjEC2mVw5HxwI9LjHo9gGLV7UOhsjwbcUAOkxjGqRZNzPvlguhpsvbDTSuNpV9qQPMcPCo/WVX1JR8ea67MKrzi5/6cGMyGGLSXKPojHGEVoml6KU4hUHhRS2yWOuOk9OC9I6iVAQes3/nycv67fvWWlQhnCRzbLGvyQDElEybwKiLbgEOaQx5slSWw7223VPEteMo8owvoQRd8UBT3i+kB9wvOyevq4WqqJArmoYyCWJewzEo1r60Ue8c5yiSbvZjtVpoOCPZqnh6NE4RAbeHh+tfEE2gfUM9BpERDVSc1Yp1uRHBS2vf8U3OoeGWoE0Rzs1Ll8rJ10JBZVLPGLSRTSU+acmpm5alMWgPGjFpiYxQf4EslyjMEdIX7YhECjAm1+cTmYVfbKqSTQ8dCkApVKXQ65LKsVn9+FkQoqlOcAe/CE43wKugOAXhrzkktNVyDVNDjljCs1xz9pL1HNvgWZbvI5Fff1VgV+ZPSFbhwiEU3
 uL5+Vk1c
 Z8UU5NsHMt721Nn5gb1IYOkFtulaqSctWbS3mcKj0Xf8XoPVSnYfO8llL80L7u6sZzu9X/jCSj1jpS5lLX3o2TogaTK+YzvUkE14qu3cOfHDiYplvRCziSKsMTlSPKYV61uir3E8C6vEtpJy/00I7hJ4p/BJknlKLpy5DbMsGcwa36X2cyDrhncKq0v5mDsfKVrL1p26rPw80ryeMHgOce+bMHSxANRs+O7oYyHr2b12zUDcJ5PWgocXWvv30oTBW5VuWmcplU/aXkENceNJVKjFCfyX2IjQuKIZtRwrsJsbeYSROqlIYHw+e8nZtyRBwYVN/bxvg0lPMRaYyaFo9Fu8zWgl1rNB5PuVoaFztVNc2GgljocHaBY45UoGDLDwomkYz5H9kew1Hpu3CckIRL7gv/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 02:11:35PM -0800, dan.j.williams@intel.com wrote:
> [ add Gregory and linux-mm ]
> 
> [ full context for new Cc: ]
> Balbir Singh wrote:
> > Commit 7ffb791423c7 ("x86/kaslr: Reduce KASLR entropy on most x86 systems")
> > exposed a bug with nokaslr and zone device
> > interaction, as seen on a system with an AMD iGPU and dGPU (see [1]).
> > The root cause of the issue is that, the gpu driver registers a zone
                                         ^^^^^^^^^^^^^^ which one, iGPU
					 or dGPU? or they managed by the
					 same driver?

					 (sorry, stickler for vagueness)

> > Fix this by not bumping up max_pfn on x86 systems, when pgmap is passed
> > into add_pages(). The presence of pgmap is used to determine if device
> > private memory is being added via add_pages().
> >

Concur with Dan's take below here, please check for DEVICE_PRIVATE so as
not to affect DEVICE_COHERENT.  Or if there's a reason to affect
DEVICE_COHERENT, please explain here.

> > arch/powerpc is also impacted by this bug, this patch does not fix
> > the issue for powerpc.
> > 
> > I've left powerpc out of this regression change due to the time required
> > to setup and test via qemu. I wanted to address the regression quickly
> >

At least +Cc ppc folks to take a look?
+Cc: linux-ppc-dev

> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0e4270e20fad..4cc8175f9ffd 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -989,7 +989,7 @@ int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
>  	 * addressable memory can force device drivers to use bounce buffers
>  	 * and impact their performance negatively:
>  	 */
> -	if (!params->pgmap)
> +	if (!params->pgmap || params->pgmap->type != MEMORY_DEVICE_PRIVATE)
>  		/* update max_pfn, max_low_pfn and high_memory */
>  		update_end_of_memory_vars(start_pfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
>  

This looks better to me.

~Gregory

