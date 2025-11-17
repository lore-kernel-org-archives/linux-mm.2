Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA4DCEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4CE6B0006; Mon, 17 Nov 2025 11:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984996B0008; Mon, 17 Nov 2025 11:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A726B000C; Mon, 17 Nov 2025 11:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71D686B0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:58:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D889160213
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:58:08 +0000 (UTC)
X-FDA: 84120706656.13.E17BD93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C19B140015
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:58:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dPT+kdRJ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763398686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTWh6KCVX3IOUXWMKrKtbyQgmh8U9cfwOHWJa+mV1OM=;
	b=uEMOjiAtfkLDDEsOBcttyYZ0TSAPePg7FDsvD///J68umauu/Ir1z0bYi1qd3Dkmdmvdb9
	QdCfwvalMT8jN4GvFyA3XfmQTL8fv6wCEGWMgStXY8PmyzrcqxVgZrvR5MXYDZmY59XgIb
	KQRLEaBgBT9a3yjRM+wVLkRCm1LZjLc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dPT+kdRJ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763398686; a=rsa-sha256;
	cv=none;
	b=npBovq7j55exFZfiegYNRw7Gk5BNWmpaixg4wwqt7lVvQ9VBLFF8+N9MDTYKa5JIn4MOug
	j+KN5xpcXHPlSGnhXF+/wQgTrBHPtcUuix/Wo1fdUi4+B0CSGoZBnLQTBeCkMs5RSOU0+L
	txTb24mBfw+CHun/Gb9MHeNvimIoDZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CB7F41AD1;
	Mon, 17 Nov 2025 16:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11DDC116B1;
	Mon, 17 Nov 2025 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763398685;
	bh=XI7Dqc8hDG/imiQjwpaa5L5QUXIhiYHcmUsbHNJq770=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dPT+kdRJmrc++E4JgaDg0HvOn87ub1fN81aujiL3JuYrC+XABLmrn8IKbujtOxjox
	 06UW28/7RYwaB1AdZehoyv5pTGVprSBAXjHnoKbjSL+FhOIiMfHk/eazN5xF1ef35L
	 iI2y5+BgESdTBJPjDJ0iyZWOBGh7c+XsGh6M04pYgwNZsjWk51POupKSyh33gdm0EP
	 45y5/jkWLrEhutdIoC4OWF5kMcmkisDNjsD7jjLCsAiCX9ZO+pgaVPoMulUmJlaGb9
	 4LERACYZwJIsl5lju9+IsQAyONXCgmYbWkB3p/ehSBdOllMUN3kNW2OC6dfYrgwBMJ
	 Dugsm9vMMNdlA==
Message-ID: <355d3bf3-c6bc-403e-9f19-89259d868611@kernel.org>
Date: Mon, 17 Nov 2025 17:57:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: make PT_RECLAIM depend on
 MMU_GATHER_RCU_TABLE_FREE && 64BIT
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0a4d1e6f0bf299cafd1fc624f965bd1ca542cea8.1763117269.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5C19B140015
X-Stat-Signature: xx9p1u8x1nza3fmwqgqxno399n67sk3r
X-Rspam-User: 
X-HE-Tag: 1763398686-997378
X-HE-Meta: U2FsdGVkX1+iW0ZdfbPH81yNG7zZTTNpdT9BpjP/byoYN/frysb4mX9YvpXp/QueiIsDwMK3AxgBUkBu9aMPpTtV06yS2d8JbFFAcnoCIOo6an3QTrNd4mFRzvBLCS+LcKH/1CUiz4zWkOoK/99oI1wUB2s9EQC0GtjG+v1A3Fn1MHBJtSZ+CaEmt/3Vk1BTKwukv3Cxe2osHdsCTT6iNIeU8TJELhJCBFNH56iv/EWECsEHRHt1eCI9y8vmVsJiIVD+x0VIP2b6fAnqS96x2deCD6+eMhbw7y1VeHSd+/uk2LeUEOWMJUKtPAUYeuqYfaE/C/yu+nUjF5q/r9wmD1byJiHdOqjL0OUOqFQqppyp9Jc3yy4rlb1Pf0aWKA+qSaB6ehQVtnbrMHqXui2wYakATrX6XICf+P7FhY8MUhQ/9toeT1hHPbs/9VNpp1NZfR+KHMqKQnbD+RvZXxUxCJfke/Utalo5QmpeipzemHJjKVluk660qBNSWKBX6m7loEspERBHD5hrXuZyYWanWpnLDFn0zX000vnfAAXN5CBPnA14oDh4tP/wfJGadGOeyUGr0faij60LcFjcP2r+JCj3Iz4fnPpDgshKEFr9UcYeXn5DIfeZ3Y8yjyWb8RtZkEwZScw762wQ4gK7+aJO4DnC5cW4SdTTWzvStXWK9RTCV4bdpsHmMeYd7EAhMqBzumE5N2TGUuPCWJvsOOeveoHpl5m/KeDMXQ/kfvBqZpWX+XwF8rr6F+Wr9iL0x1d0Te0eYULam2ki6Q8V8ogO7jXmHAHKQ3FXjf/WNbnjVkb7ykfPYS/C/B//DFNG6pHOIdOxC1fateUU2LO02YFHeNs+VYEPCAs9ivnqefKXkQpH86CWNPeKrJ12J4eJsugEJ3Y88SOOss6ESh9KHj43OhWYnmDdZOu3WKAbjOB461217n0jK2KpuY8cd/t+SfDpejsY1zyMNPWnJhpnUig
 ZzKYsDtu
 5t65FxOvfbJUagpMad+ZW7PrWAyt0uRfZUZZm8v89LKoU6S3nXx89Lwrq5ISdlIDrkVI3IafaO4dK+9dEWbh7ThJCPiPZ5cwOXLL6KRWGYl/wrjTwAkjOZTDkVlx+k0GZwq2BAu4s/SLHrLwgWbr7l18TW8Y6PH07CEGckjNMHWlzzp/eO2+QhbrJntuzqH8N5cGWBfAbCaaXd0tQV7caVrGVCsogHLoHX3xWTqvp0cUqEToPF+5Gg4QD0iGhBiR3p3TqphvlOHR9yqsyTIWGNRyo2L8Q/+JwuklIlIjk5eGE4jjzCMsIzjI0Xb1CtXWkysRRWrrbuUTvpTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 12:11, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>

Subject: s/&&/&/

> 
> Make PT_RECLAIM depend on MMU_GATHER_RCU_TABLE_FREE so that PT_RECLAIM can
> be enabled by default on all architectures that support
> MMU_GATHER_RCU_TABLE_FREE.
> 
> Considering that a large number of PTE page table pages (such as 100GB+)
> can only be caused on a 64-bit system, let PT_RECLAIM also depend on
> 64BIT.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   arch/x86/Kconfig | 1 -
>   mm/Kconfig       | 6 +-----
>   2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index eac2e86056902..96bff81fd4787 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -330,7 +330,6 @@ config X86
>   	select FUNCTION_ALIGNMENT_4B
>   	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>   	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>   	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>   	select SCHED_SMT			if SMP
>   	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index a5a90b169435d..e795fbd69e50c 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1440,14 +1440,10 @@ config ARCH_HAS_USER_SHADOW_STACK
>   	  The architecture has hardware support for userspace shadow call
>             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>   
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>   config PT_RECLAIM
>   	bool "reclaim empty user page table pages"
>   	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> -	select MMU_GATHER_RCU_TABLE_FREE
> +	depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT

Who would we have MMU_GATHER_RCU_TABLE_FREE without MMU? (can we drop 
the MMU part)

Why do we care about SMP in the first place? (can we frop SMP)

But I also wonder why we need "MMU_GATHER_RCU_TABLE_FREE && 64BIT":

Would it be harmful on 32bit (sure, we might not reclaim as much, but 
still there is memory to be reclaimed?)?

If all 64BIT support MMU_GATHER_RCU_TABLE_FREE (as you previously 
state), why can't we only check for 64BIT?

-- 
Cheers

David

