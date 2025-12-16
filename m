Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C6BD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 04:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70536B0005; Mon, 15 Dec 2025 23:16:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D4B6B0089; Mon, 15 Dec 2025 23:16:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46CE6B008A; Mon, 15 Dec 2025 23:16:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B16CB6B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:16:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668BA135D23
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:16:45 +0000 (UTC)
X-FDA: 84224023170.26.54B0902
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5E1A120015
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 04:16:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765858603; a=rsa-sha256;
	cv=none;
	b=LewprIFDS0Rd+owi8fw5Ps42a8La5RXXoAV2yDPh5IRU0qaMIfOi2FT3FTdESwa4bIyIsJ
	oxFgPhjAgoNtiB/eSHGpjF6UmnFmBskT8y12SYTj3IvV9kGg04hykrVobqI+qb2FrM0Al4
	TQ8UoBJcX4/q7XOydXX/DSWr+IL+cB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765858603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LRoQepTTveRGU2lDfrtpY1CS+ndT+8mYNlsc4xdCDWc=;
	b=VJvNX9NqokYAoKXvoik6GgykMIGN54nJnzc+nozIcvqAwokCPuONWVALRSgd1Bqm5s/vKa
	N9CqHHfuXLLAFeLCQTnCbUa0CVOo76o9hDnTbwniQZti2uKV0FxP7RygAq9pDmvXeZ9WWk
	scYv1ff23fm/WEW8zHcYZzLMJHrksuw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF353FEC;
	Mon, 15 Dec 2025 20:16:34 -0800 (PST)
Received: from [10.163.80.100] (unknown [10.163.80.100])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 739BC3F762;
	Mon, 15 Dec 2025 20:16:40 -0800 (PST)
Message-ID: <66068425-c9b2-475e-81ad-98f410d33b45@arm.com>
Date: Tue, 16 Dec 2025 09:46:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/vmalloc: clarify why vmap_range_noflush() might
 sleep
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E1A120015
X-Stat-Signature: w4bahjxg8ewr1bz5nqwqxyp9wnkhmr4g
X-Rspam-User: 
X-HE-Tag: 1765858603-21877
X-HE-Meta: U2FsdGVkX18tIKU7Mey1bJx8Y794EMLS7XvwE8w7MgKEA5swxZQoRPvBpKoX2O7wgT0c0OpL/z575YCj4XmRPxhW09fL62jTbsHmMdWMS/rXn0Z9aWUxIpQfqsgTZTYEk48KRA4YNEWCsWzZH06IryGL7lYor50YYV+NUwZoxkCWTNgnctXJYzyLZgJ84VQ7e30mYA5QgYNUYCA+amPUpLNPKKw+cxjyJNmRvXSST5Djk8w5UyblvD4mVFHHj2p1pkfMNubvlA2ieFEWJ125G4WBKo8Ooi4133uqn77WPvwkhL7P4yS6VIi8yQ6uKCcfRadmvSUSgW5+Zf3DmsGFp+D6glOrBCgDvZh8rr5gfd1MSDsPcWLqSbKEpRNAMj2DYbniZ+uv3GQ79LSM/zfvP6sr9X5bejIXVQgySszG0y+9WOztMHGYSdkYju4C28GMCPPrqpjqV+rDOB4i3U4bhbADSB2cLG3kaeRLz6oii2qwT84LHawiFCr0I0HAY82ghBHHr76qPF358rCR9Jwbyy8lCjMUZUWHt9Dujk4b65viOS1d3ajkNsAHVJAKTfwdxrfNbeC0BLt8+m2uzNEGUj33Lyiz6utsc9CALQYSxl5uoKFRAJ+KyBgI++3CIMm7xrbd27fbMLaB0v9LGzNEtjH49/H7vgLW/L/SIK50l06PAcb/LyBsvKPIgMmtR5AX5Tn2qcv9wocDM3OjioiprU6q+0Wvci4DWZl6HcC27QA/Qg4XXgYgqAt/j4L6jfqLDogXOOXqhGZ0xg/bQlm3sHLZp+lQKgBkrLVJ6TnznNYCmJiAmggyOcV36csPNWK22FimTxtCGWrCX+5oRqY7hsKMJjTAa+9yhR1hf1f49Gzb2tL8i4H13yftbueyj+GZWxFZyE66HuwtchvnHewwG0kBKBTTSmp9+vGSJ4aHGSvYcw1/42Uyr8xtdt1gITI5278kTSEYshYEwZIPphg
 6VDcBQCk
 FchnY0XGf2jvscp6pGU21X/o0p0qL7OWJi5et7KprmZrwm/1JrQkipsMMAe9VhMjHH7q8kI3e6JnMMkUfWMnY6pddzJCQSOrCBuzJaCR99o3arjvENzWvOQPDAcs6D8NdB3aM0vWzheznQN4hJcbBDE0DJVsZj87PBWJr2/aQokdFBfhRWwA0ajm405bTFEDaO2IdarT4yaluImuINXb10pWTikITM2Ouc7ZPl9A7UohGXsx6lv+10LK3EJYh8RbotsWUlDwvtI5YHBl8P3jPtqvOT3KBAtrZPPjR0IsNS5r+1Y0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/12/25 4:10 PM, Brendan Jackman wrote:
> The only reason vmap_range_noflush() can sleep is because of pagetable
> allocations.
> 
> The actual allocation mechanism is arch-specific so might_alloc()
> doesn't work here (what GFP flags would be used?). Hence, just add a
> comment.
> 
> Also note that this might do a TLB shootdown. This is not actually
> sleeping but it requires IRQs on for x86, and might_sleep() incidentally
> serves to detect violations of that too.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Applies to mm-new.
> 
> Changes in v3:
> - Added note about TLB shootdowns and x86.
> - Since the comment no longer fit on one line anyway, also be a bit more
>   verbose in general.
> - Link to v2: https://lore.kernel.org/r/20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com
> 
> Changes in v2:
> - Switched from might_alloc() to keeping might_sleep() + comment
> - Link to v1: https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
> ---
>  mm/vmalloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c548167d6123f6ec66bf798f20eec..be4e5f2566a4490d45de29568df538b7c8515b01 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -305,6 +305,11 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	int err;
>  	pgtbl_mod_mask mask = 0;
>  
> +	/*
> +	 * Might allocate pagetables (for most archs a more precise annotation
> +	 * would be might_alloc(GFP_PGTABLE_KERNEL)). Also might shootdown TLB
> +	 * (requires IRQs enabled on x86).
> +	 */
>  	might_sleep();
>  	BUG_ON(addr >= end);
>  
> 
> ---
> base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86
> change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
> 
> Best regards,


