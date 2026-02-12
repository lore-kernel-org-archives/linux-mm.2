Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C74CEEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AB46B0088; Thu, 12 Feb 2026 13:33:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D18A6B0089; Thu, 12 Feb 2026 13:33:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9026B008A; Thu, 12 Feb 2026 13:33:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693296B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:33:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CC321A02D4
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:33:32 +0000 (UTC)
X-FDA: 84436652664.09.8A438BD
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23DFC14000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:33:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwmJaVLb;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770921210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXzPF3f4aLQzyl1T0HyTc/XDSv+U4AXrgCyxNwfcU7E=;
	b=WDg3A1EwI/xeaAPo8oPKShirrwoS89e/cPlyTZAZ2GU+yF5YGi1TDz8OTWYLoWEBj1ZazE
	NqImWjQVylgHHhyfDnducqIt0WLeUq2G8yYIF6yL/unwrUEtPvSjSejE0Pj7TNsJuNFAkV
	2kGra5J01ZyJxxkvFWWc55YGAPiL61c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwmJaVLb;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770921210; a=rsa-sha256;
	cv=none;
	b=tc6nlQwPJZWvWWNSMpqXxeBek+kZ+1p4RSaC7aLuhTSHZpdsPxsVk9jaq5iZWpLCFNgxOK
	6oRrnff/x8hQfyCZiFjbII8nDtKlVeNYPSRkHNnf72il9Hp27MXoNmrgH8v/Kaz9xr9n+p
	+v1zzjJ4IYVKkzuYz9TA1aibG7AkvaE=
Date: Thu, 12 Feb 2026 10:33:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770921207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XXzPF3f4aLQzyl1T0HyTc/XDSv+U4AXrgCyxNwfcU7E=;
	b=cwmJaVLbWyRFnkSO6jdQ0jw2PJXmi+ZibshYLhhMOz8SP9fBQfJjEY9FXE8/NyBxIHGJIR
	b/6UX9Sfk7w7NeL/uuoWyHKm5SmzW+CGpQBrD4uuVpVsZ5YgYF6JK4N3j4Y6xh0OtI0faT
	xekazG/OU7YsUEd3v0QEk7YijvmGW2Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, austin.kim@lge.com
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
Message-ID: <aY4bQFvpPRWgnOTM@linux.dev>
References: <20260126065242.1221862-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126065242.1221862-1-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nzxojss7eptm88sjn47qbh7f8zshxdyr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23DFC14000F
X-HE-Tag: 1770921209-8216
X-HE-Meta: U2FsdGVkX18LFyAPpSRto6C6YUo0BC0SiONHZiS37dHkAYoANGGjl3ckN4dHZO70Ii5T1XcDnjDCGcY+VGQWr61zx4H/yvvYhwataIdIFQs68ifmxFiplvEPU6UkVSinqqXD/7DQOfV29wSa7AvJVRcQZPaLZFewFUlDZ6p1BAnmEE87GVdHXeCuYeDtGS1NfWO7YyhjH12VPkJTgGoeWtUyE47CBRNGohmZOLI/T4HJJkvpGBPdt30VKhPcnPBmi23TzvrvSgl2m6388Yumur+B/76THWn7T/v/GRRGaAzm6zxFJ002kskWV95ATHWyZNpwZV/VpnkJAgTocyg7/wYbRqOSIyowfx+1oIuaG0/azVVUM6aGpzMbD3hqVXnHZdorEN5aI+hwulI6N3IHrI14+5SalYAdZol4vSfIM1PHghTKYbcUxeWB2nWskjHx8ZPoGKdMRmkx9/Lq2UrjCcGgg9ZT5K71FeDb9vSsaf9niCaDHMRDsr3E1EWq2ZWU1ZghRu1ZuBkMgFD4V+owuxLzDPe0UMMTECC0XhVDA4HFbhMjS5GTuxkpF7RXvmuv3iUl6MCNFXBBU5EM2F1gFFsQSnT+CFoO6Xz1j/G1YX/7xBZ8K9LJ2rt9Got62gM4WpjZdpoO9c7reKzvkYduV0GLOrO7tdgSTCCmYZLlYuZ77j4svrOdx8R/2p38kpi4zzWoQRqREZTi4hklk7M8F9HNbpq/dqTFGVrss2Omsuc9EZSc/ZO0RRGnypOUYuZdzoVR5ypJGnfGlNfT/8bJNYgP/upJLs9qMY5F3HCsZ7/su3+WzuLhG55jsqXkvibEKSb+oNnTVU9intD8xEPERe1LJRF+BIU0zQ1rchdxFlq5TtxGEPghYEuIOgCfoKM6ifsHfx5nE6RrM7pt2Ce/Jt6zcpHtjTwSuVfzaKUgBMN6W5PlEn6owEchvaRim4VxYmg4fRq262+gL1Va2bH
 XntK4Zx3
 1lpL2Glgt+a/3yLcIVX0+uIJmDn4f/xnb6wmgIaNqnmsB0ahjpUGzCE2TGm8i2uDT/gJp149haXSFOyqKLiTHAQIUUpSMxBf1Y6MZ7QAGHmJV0TQ8t8r4+sgGoSrErOYAYD4EEyWIb0g7CnDNbwF2FVZz6PDqmspRx3G/dNe0C5p7dkFPlcyItpZxZC5TQ3F+xOy4gwLtWYTDZiEgkhttWllWAEStrbwe91m5rjUQvn0PL4Vj82+6RbvE2/PI3v9dcttbZn8hHN9zwNLZcofToK/AJxy0T1v+ahzL8vCdwI4CpL7sVquVn0mVI19i3KSEnoJdh0foGVmg1pvFnzbUxsOviw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

On Mon, Jan 26, 2026 at 03:52:37PM +0900, Youngjun Park wrote:
> This is the second version of the RFC for the "Swap Tiers" concept.
> Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/
> 
> This version incorporates feedback received during LPC 2025 and addresses
> comments from the previous review. We have also included experimental
> results based on usage scenarios intended for our internal platforms.
> 
> Motivation & Concept recap
> ==========================
> Current Linux swap allocation is global, limiting the ability to assign
> faster devices to specific cgroups. Our initial attempt at per-cgroup
> priorities proved over-engineered and caused LRU inversion.
> 
> Following Chris Li's suggestion, we pivoted to "Swap Tiers." A tier is
> simply a user-named group of swap devices sharing the same priority range.
> This abstraction facilitates swap device selection based on speed, allowing
> users to configure specific tiers for cgroups.
> 
> For more details, please refer to the LPC 2025 presentation
> https://lpc.events/event/19/contributions/2141/attachments/1857/3998/LPC2025Finalss.pdf
> or v1 patch.
> 

One of the LPC feedback you missed is to not add memcg interface for
this functionality and explore BPF way instead.

We are normally very conservative to add new interfaces to cgroup.
However I am not even convinced that memcg interface is the right way to
expose this functionality. Swap is currently global and the idea to
limit or assign specific swap devices to specific cgroups makes sense
but that is the decision for the job orchestator or node controller.
Allowing workloads to pick and choose swap devices do not make sense to
me.

Shakeel


