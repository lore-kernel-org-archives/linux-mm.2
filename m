Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D8ACF45CE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89006B0005; Mon, 12 Jan 2026 16:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CC86B0088; Mon, 12 Jan 2026 16:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918936B0089; Mon, 12 Jan 2026 16:04:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAD96B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:04:05 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 346AF13C3F8
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:04:05 +0000 (UTC)
X-FDA: 84324539250.03.615E7D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 705D9140009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:04:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7om5414;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768251843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sg1jn4h7rh29gTlfTCYT9o7eG2SX1tpdkBL41s1onM=;
	b=OwZ2+SS5lcWbTxj1ldhOsVTYaARwxFsld+HFDwYCdEyJxGvQalbt955Eccoq0FtCL1AFyg
	g1Tvx0F3lM+A+EEMIPa8OJoEnGg0dhoybEKlfYqkDkHdDWpjqP5arDAXBZ4Az/1XkPShMh
	uANqYF9yQr3JijTgYvx8O8+8Fh9azwo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7om5414;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768251843; a=rsa-sha256;
	cv=none;
	b=kOaVJCUGjQI5cOMAYbqteAnh0g8FuYFFr4eOc88xFSahSQR/8D1j0WM6stKYOm42As9uG0
	OfXHDLmBXGM5nwca7aBu8v1K0UzQQekV2NXWGw6eftE5e6QsE0n7bys9xyLzXFKlgQp9J8
	vCJWzRbAI6ezYeC3XOyf8+Py/Bo5SsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC01060017;
	Mon, 12 Jan 2026 21:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1CCC116D0;
	Mon, 12 Jan 2026 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768251842;
	bh=Jup1Omb5sLymm05ATlhfAfwm6f0U+ePkTmvf947znfo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p7om5414d7KdaL8YfBjMVG5a6p9mS8GIWN98LDosbnDyr78i1WKGzlDc8GqMHv17M
	 45rkMYcuq7pytyqE6V06R1SixXfveojDRBcaOcTDYcNbKG4kIvYwhWegn+WlvjcC68
	 3s+dugaiOLRJC/zfBnPBPkbpr9rPo/QfH0Daq5VM=
Date: Mon, 12 Jan 2026 13:04:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
 <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
 <bp@alien8.de>, <dave.hansen@linux.intel.com>, <kas@kernel.org>,
 <ardb@kernel.org>, <david@kernel.org>, <osalvador@suse.de>,
 <thomas.lendacky@amd.com>, <michael.roth@amd.com>
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-Id: <20260112130401.a857fac6abcf104ea9bb5c68@linux-foundation.org>
In-Reply-To: <20260112202300.43546-2-prsampat@amd.com>
References: <20260112202300.43546-1-prsampat@amd.com>
	<20260112202300.43546-2-prsampat@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uhtnu1dxi1d65jkkh4akeb8yt911k76d
X-Rspam-User: 
X-Rspamd-Queue-Id: 705D9140009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768251843-625111
X-HE-Meta: U2FsdGVkX186nA28c+H480JiTIZUDyrzt8PpU96XjBhEsMGNOQ/mftoHLkUhCoD33rGLcrylmvcbH1TzYXwPkSw7IQGnfTiJDxjlVrh3TVRKG+wtjP5OdZkZluRtvLzG+g7ZXKtGD217fgD2zNGZorC/9XwNG2pzUx8964dmtVCQGuzj5ivjynSqhYjxO9wquoypqbIXB6wRm7iL0quiY9Q7IWkfmSFp+D2eF2GkihtL5j5GSGW5yyJvOln9pS8vMFRA5jsQ9BdHlQyUMHCmQfRD1/by/axpz2SOBZAdQHODG5y/gLKV5DJf4wbwnzeyVBzpDRMVhpJ03JOBgFlAty0IT/yiDCAggvI4QKsMfYowMngozxijLwExu0GrCaY/vg8hzv1vCr7nbNXoAxMOUCBkkHwZf+HAXH5oZdijacSofBIOXkHlQS7gDFUtOrHTraJVsYCu5FWusqJfKDikIVB6zYxX6lMx1QsznHtli6HCVgzqFvUzcfZrHhJ0VNoyHO+WVeU1jxJwpQod8we4QWxpZEtTmILcnJwkU0hosAE2zd2WlFpcNgMgAEFYy4ddxsw89Or6klCYy0WGVqaqL5bGW7Hy7ov8UNdRDpxH8A3y/rdN0i8JKE8+mZHIy3RX+ANWiL8E33ILevOl1VjkagfBmCa8PWI2tjnRN4uxbW+J0uh/FdUVt4kcaBIkkEPuRXYMjFcF3g98qZpAwi4HspdjOSlmNbfPicFdcroLj5MZViVuKVZpq2ZVF78pEZVAHStgmSmHx06KgLyeixtuvkkbeFrDzqkf8Np9L/vFFp61qH6JWP0lw+5u79xn0PSysbzT21DKAwjUatjZiEkIMeDmeT4yY0akfNQ3AD4Wcbm5PyUswXi4NS8+YVihdgN0Q6a8qaeCMKDuwPjcFPS1uuCMGt0awqf7Q9lJGGH1b9Q7J4yLuClcTU/xATkkDCjTR6Ejkzy4hudZZ3XOi8v
 VFTxY8t5
 QJYaR9hE9KUyEG45FHdutVcO0EXkSsQhnGsonO6SP0J8shq99eQNtcw75BfBJvVY4E2P+/sEN8gwZGRlDPvcMs2AXvp2Q8suCL4zHtlmkZoThOw47wk5iVi+WkbldclfNBKVgqiQYnmWIk6JGrmlRKbq/e+TM88JUO6g4/A4eGpv5Y19/RZA324jJvNU9EuFxu/CVuZiH154yvnt6fny+5qqcjkfJGcWDcpLGDZPKxXA03DgMoR45S6RZPoOc6p4xdRn4KX+L7FA+YAQ3geVcZfbwdodZWEbibGp/Fx9ZBClpr2OKG1uTdv5sKzTVyCxEEXA26IFvSaRYu8U6Zl5BHGVPs1nZ8WFQZHCP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 14:22:59 -0600 "Pratik R. Sampat" <prsampat@amd.com> wrote:

> Confidential computing guests require memory to be accepted before use.
> The unaccepted memory bitmap maintained by firmware does not track
> hotplugged memory ranges.
> 
> Call arch_accept_memory() during the hot-add path to explicitly validate
> and transition the newly added memory to a private state, making it
> usable by the guest.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>  mm/memory_hotplug.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..8cfbf0541430 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -38,6 +38,7 @@
>  #include <linux/node.h>
>  
>  #include <asm/tlbflush.h>
> +#include <asm/unaccepted_memory.h>

This only exists for x86!

Otherwise, the mm/ changes are minimal so I volunteer this patchset
for the x86 tree ;)

