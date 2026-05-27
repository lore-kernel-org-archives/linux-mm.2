Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87834CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 20:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56EA6B0005; Wed, 27 May 2026 16:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07956B0088; Wed, 27 May 2026 16:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D0F6B008A; Wed, 27 May 2026 16:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 847916B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:46:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D192913F2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:46:41 +0000 (UTC)
X-FDA: 84814383402.17.52F20F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 95BFA1C000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 20:46:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O9koNAPw;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779914799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zT6s2ZfDPFrK81hDTyTon4JdpXGE/BWdIUEPQ9B/F7c=;
	b=w37irx/OcCAukYtlB3NwruiJtkK+MgGKnwAbe8dvxoSYOCD1p2zeThllkT/jFy2HAyQiR/
	34gj1D1mxzlQwvn1wnm7SpTZSxeBXklP2dLMp+qlrsoD8w78JUGvLnX4Xp5Gb2C3h1IX1G
	f523SGHeLiMerf+g8tM5tg0q2RTRp0c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O9koNAPw;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779914799; a=rsa-sha256;
	cv=none;
	b=T2Zxp/IifEND5F7qXT9kniQ5wzUmPu2Zzgb+xCi6H2NLoQlxI//zUCUA038VsJ4Ces5I8f
	ZRVk9Vpm2ZjvVF9x6kW+8yzn1F5kAbUQFZcDUkx+iJMonJW8FgAkoKJ7ODEKd7YnWjtfSG
	x0DN09oC5wU93s0RIFTjNqjC1rvOSU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0743432AB;
	Wed, 27 May 2026 20:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C2D1F000E9;
	Wed, 27 May 2026 20:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779914798;
	bh=zT6s2ZfDPFrK81hDTyTon4JdpXGE/BWdIUEPQ9B/F7c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O9koNAPwuL8ckwpo4FRMzwxLdJDvUGlF79kpbznKq14OMdiUBct4+0GX9BFqefHGe
	 2n1H0CCz4iOm4W43yEysMDaQWFWTTkrYL9CQVzHy4TrDrXE7guiMGT13zeoLjeBASM
	 uowS3m5h30FBmsWNJvpY/m3Jw9EQcypAJG+w0PZU=
Date: Wed, 27 May 2026 13:46:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <bp@alien8.de>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>,
 <mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>,
 <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v3 0/8] mm: speed up ZONE_DEVICE memmap initialization
Message-Id: <20260527134637.29621cc94aba22eb02f3a544@linux-foundation.org>
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95BFA1C000C
X-Stat-Signature: yep1uezc7afnwztfgtncx56u837wa3tf
X-HE-Tag: 1779914799-370441
X-HE-Meta: U2FsdGVkX19PKIIb/UZezhDN9Sykn2b1ww9hKzCYFWeClxdRt4EpX0DZvzPo4NNtpQNjZ+d+4WfMGnL+psPPGZlxJ23IUy+uwA+SZ6HfyGfeMh3oYJ2SwZlPPIofIct79+EoGMUw8j3oXBI7x7EfVlUv9kNzK9zmVjACt5+CI5usnnPaBzsbe+NF52lD6mqYfKuOCSIo31UsLsPb2Q2ogqN2TTZy2aysX59+ViMGjo36FSIIj4pd5SPYrkRGP86KXL0yQWvVBE+N8jso5TaOIHTek4xyAK1j1+OvUbRxvrgcpJOIHgOsnK9gKFAklhaue/BrBWLosczaOnnMgm+OLTSQAUuGmKhUG7tDoDyER0T4LHd4lcKrZOtbSn/Xu6CvT7o21OSUds0aDgxoIxAtwkNbWWCZEYr+NLk1C2T7mJfiiPDUnwSO0rY0evfF/o5j2LfjUEM7eP3Ow2t4OVVxoufkpTt02RBCcvo5T8AdE/hL2FxoKj5SOBaFe/E+B6yRfjVZ4eaWknNkhHv8rlIGCkbTobSyNjQC/Smtzi8jmQSnY7i9PdIA1VpJVl+0ywRiiHbLf4xWb8y1J1TNc6yOzLzRtpHiAgT3+sZfm09slvixmY02z6T0fWixBOFnQ/xhEENP9yq8jVcl3uvnU3G8Lkgbig6pkWDE+jTe0Bdewi4sa/xD06hneqD37pCOANmumrjjCJA8jaWi14nNA+2lp4oKv7axZ8ybsbFoAx+eTFCuGTY5/S2U9avnUTNCfxM1I6weaTqO+gLDt5KnXaKa6eWKDdun0R6JT4mBG3RNkg9ziqOYwEgpmIwByU6QiklOPU03YitwKGQGLI4VDvK7DXG14Ys/uRtgFY9ylBt/9agvMsmvxzKUXDk0OpgEZILrHuwXA6NiECnShaESfG463wDW+bCk/mWMF43CSxsATo66M0InPjh5muI/eTBnks+ibNFDgRJkBG30eiZck9N
 H9dljIpa
 XKRdiJ3SM9zrHB3aAB68UWQ4k2i2M7AmPNalI2wMqzBmgJ3BxPbA59BzU3N9Ipl+6Qc4fEGCLc8KaIJHN+wmPPxvIZ0e7ZdIC2LF6OQLr0C+E6gZ1HorEq0mxvmfAVt12CmAKqgWXCMA/E/XLb7GLDcDoiK8Z8ANP6UpK2+4tf9gl9SNBnwOXX6njTqywfRXg8lqbWJi8d0y+nJadp4veKjunHUuv9v7X342C+IBonPGUGMPIAZG2sLNd6eqs/vTS0lEgNSy9DJOE9Rs2KEL0ktoubgkP3nUnDWT49D5m5gj7p61oX3XI2P06d7tH+ldtPRXJHL8Vledlnth3xtj+wwS8ZiuC5wlKPb4p+IeYlM/9xlXnGOSS5y5m8Ik2O2Lxsj3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 11:36:28 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> This series reduces latency in paths which create or recreate
> ZONE_DEVICE memmaps. Pmem hotplug is a concrete example.
> 
> memmap_init_zone_device() can spend a substantial amount of time
> initializing large ZONE_DEVICE ranges because it repeats nearly
> identical struct page setup for every PFN.
> 
> The series addresses that overhead in eight patches.

Thanks.  I'll take no action at this time, as it's getting late in the
-rc cycle and the patchset's review status is rather thin.

AI review had a number of things to say:
	https://sashiko.dev/#/patchset/20260527033636.28231-1-lizhe.67@bytedance.com

