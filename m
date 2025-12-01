Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E76BD116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDDE6B000E; Mon,  1 Dec 2025 01:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E5B6B0010; Mon,  1 Dec 2025 01:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8D646B0011; Mon,  1 Dec 2025 01:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1EDD6B000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:50:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD3EC132CEA
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:50:33 +0000 (UTC)
X-FDA: 84169978746.01.598DBA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D430DA0006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:50:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sVk/USQ6";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764571832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xGPtAEsH5859bvx4L/cdPv92IoQbH8Nmh2Kqw9y91k=;
	b=DNMgT8LvR7arl0a2J9l+VZgAXD7d5vy6S9pR/WGkIW4mTDkfj4U2fouyX0eK6XffbEzDJn
	liDex6FgALwU565Ex2TKnnhlpacT3NheXc0P80X8UlczXLBucZ1xBjU+xcWMa4iVFf8D+D
	Y9/qZ9eQuG8Z4uJajAwQxe3wbWQY5so=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764571832; a=rsa-sha256;
	cv=none;
	b=Df16nNH9kCRS8Aho3SgovB3982wyoJYlI6yb8yp2YNbrmdtYeXXn19Tj1dvCeRsHn2Yluy
	xrQZ76qeVMvKbfjgajOQkZ790yY9JnjV7pSlu1Z1QFgRDYWLDhUw7HFLud8H27n50JGSa7
	iYbTBnmVGrCjlmJJ5gdD7vIeAWgdZ7Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sVk/USQ6";
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 13D386014F;
	Mon,  1 Dec 2025 06:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D065C4CEF1;
	Mon,  1 Dec 2025 06:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764571830;
	bh=77kPZg+Fi5iO/CYTWecR13T71hr5HYPvf7lTx+iWO44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sVk/USQ64Orrpyfz0mu6ZUa1S1fjZPZtMuDdj5fmZEMCViOctL4J3ASH0iOMb2pJG
	 PkI9LlbNvQz3AuBcYuaVkeh+7rshP+zapdg3gsvXV5S4ViHwAssXWmuYHFshZWRDNJ
	 Nh7RST06ST8IGkG2M0bgQC4JVFHbVztyjtK2ha0bNdb6xffvqcEf+j/Aa6BgqHvfeX
	 eSgxvppJpPiEaO19+AQ/DK6oDxXIpSZcPejCzf0KpfFS26wxcIlb1HVmpCuJrSgBHU
	 LzDa4lk70qAkQ6u1elXClbFjDLIjqGSljol4fZdbDX69nMKSpv3VfvHlpx2R8lump/
	 FGOeDCGS+G1mg==
Date: Mon, 1 Dec 2025 08:50:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: akpm@linux-foundation.org, david.hunter.linux@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH RFC] mm/memblock: Fix reserve_mem allocation overlapping
 KHO scratch regions
Message-ID: <aS06sCvwSkcn1XcE@kernel.org>
References: <aSxcs-jCnkrm8o0M@kernel.org>
 <20251130211540.582343-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251130211540.582343-1-swarajgaikwad1925@gmail.com>
X-Rspamd-Queue-Id: D430DA0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: d1qe1eyxeoj8jea4ft6z77fsjzdym5ec
X-HE-Tag: 1764571831-383849
X-HE-Meta: U2FsdGVkX1/w/a9AY79ri3j6HiGBE5q7LTMDuMERhWqKpotFuXNVnX5EtV+wwmNB+zvwf9U+SercIhrqbeVNnzeqat2u0VSvNZoPrW8dKpDR7HjRVYBBlE+Xq0pBi6XoOyEDMA6xe95jVRwg8kgW6H0dHCeCt2uV1cPR5UzeJcBP5NmztgiDpa4TBHPoXLHnmfLoUSP/yKcfsVstYWsxrK/wh4V9H1LcNQnnX+/FI88hniH7/9F/TbM2QVuFQcsWDrNP0oB4ZK4dTNTwcmqqz5+tplb3yddaw1C8M8ApjmdF7hGX1p8T0Yjd4s4WwDjPDJ+5HXs0wbwNGLD99wSCxV6I7zAbWuFInfLiBxJ5vcUqKwzG77H6Yxgz1gPsMgGWsodbokzBMnaQOhkCukz/Jw+FSWCwy1JlPo5ZutQuhfU7tuIwgGY0jz/uDI8XkT9pnF8NYLu+mOYa/ZRxF/g8YMod3v3ggE0ijtPORlnbRpazhrN2p+Rd21qLN9EFLVkF/nWB6tPj/VUsDTDg5HFJAbHPJAQNLCxTIFsjfS9SMc2lXwS9LP0Q5tgogcofgXfUI2teKJEIrundgzjS/GIYzlp5qw2PCQxys96wgs1giDNNmblaGO/3sHu2Qu7aBGpipkpF2uXGE1mwTfU7LNabcab0yEqSu/OqT56BAmO8gdtRZR5w6DG82YcIByqUQ3bv0gfz5J3J5XVMHWGv0Fj0+yPH0xdNQRYfSm1SZ2IDSjGlXNeXHcj/RiUyIBw/vl5mcCfmFJCNbVUjTT8clan4oQL+rGJHykjWwgc/C66h8bLyJGCvY/V1syLg4Rn5wVN+90bL1e2pVMFfa8+bhhQE8Dh35/MN7yMASjGXqvFlKJ5u3eAIpKBET5hNpgpa1QswcfSwYnyZPtE6320+Zw8Co0CDgw2Sj3tTxbyym6ugbHJ82rcjRUHV+OJzzD79N4FPhDVmb88mYMRhg1WnxpS
 2X/kLXjX
 bTTDtlqFA4wHZlXHDSVrWc+gwLEA06f2w6NmVB7Uwqq1LmihZ+e5sbAYc82RymDko0pQ9csaloSBJ2rTOkxuuX3JjksR6xZ5dwWPh1mHk/RBc10VrU5baWAd+yIOlBt2RJ4JaXkQKadbdrDtIO95PiEKGkLL6iaQ1sGfbAoOhBZknPkF11inNNt31ogSB7ih5NojSqgzDPN89PvHph9No6XUKRtb/XgMAYlTqlSU3WjWNzdPctoDwBgVf06hc7bvu47X9pBPO3ClK38XVc2WbKhlbcZVOIhEzVl9Q6jbEnqtTxBFjRgbifYSB7nHCQEjkXfrisGFmxK0ar0TJf4JMWswS0MtxfEB7AkE48uITVCueiIQAHhikDvWt/FIJpcC4ONRJ/VibK1m+LqU5rj92hHC2Sv0lVjgEDkJtElBpeNLdAZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Swaraj,

On Sun, Nov 30, 2025 at 09:15:39PM +0000, Swaraj Gaikwad wrote:
> Hi Mike,
> 
> Thanks for the feedback.
> 
> This patch was sent as an RFC because I wanted to confirm whether the
> overall approach is acceptable before preparing a fully tested version.
> I will send a properly tested patch once I get confirmation that this
> direction makes sense.

I didn't look into the details, but I think what you propose won't work.
The first kernel allocates KHO scratch after parsing reserve_mem and the
second kernel allocates everything from KHO scratch at the time
early_params are parsed.
 
> I’m reviewing how reserve_mem= paths are exercised so I can build an
> appropriate test setup. Any guidance on recommended testing for this
> area is appreciated.

In general to test changes to memblock and other early code I use qemu and
some scripts around it.
 
> Thanks,
> Swaraj

-- 
Sincerely yours,
Mike.

