Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34F8DC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB6D6B009B; Wed,  9 Sep 2026 13:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3026B009D; Wed,  9 Sep 2026 13:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8BF6B009E; Wed,  9 Sep 2026 13:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B97D6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:07:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1F12C0288
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:07:16 +0000 (UTC)
X-FDA: 85194854472.20.A8F3B8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0032D20009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:07:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxcbi68h;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf4uTyqT87ku5vwudo11FLL7Lqrs0P0zt+IQw+/sbcE=;
	b=32Vi5qgTYPrmphJC257pm6gnACQmZRP66ClXs4M7KtI2nW+qzfTZY5dFB+/acYefSCjRzQ
	ceUb1hrrKD1HIAnTjkCxuWK6BLo+pBmVWuEaMIeBWsWZhHr2xwgMkedE3dFijAf9KaDHd0
	jJTixXm6CNDuPoXPwBK6/pgXtsJNGII=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nxcbi68h;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973635;
	b=6Z0bYLW5mYy+axjAaP/RNGbKizi8XPCiZYAFVMioHJZD4ajBfbCpVx+VDdnkwbtnfYbtve
	fiSm9C/g3qliZnDm2Bs0nI4qJ1dP44+0y3MonCkBoamrw3aDv4BzPnrlihIS63ElTq00Qo
	CNshVmSEv5XQ9HYv1oWogm0CJnc1B9E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63F3660200;
	Wed,  9 Sep 2026 17:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD2A1F00893;
	Wed,  9 Sep 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788973634;
	bh=Sf4uTyqT87ku5vwudo11FLL7Lqrs0P0zt+IQw+/sbcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nxcbi68hK3D5ptwb/7Tb6HNdafqiy74gebgeHLIX23sJcb/zttGk/laJdPN6faHzQ
	 fc6a9zRR7C68uGT0PhhyCqJlsfF8LLptOtCn4gGx1CS4RRq5TTRztZc14dDQTM64AC
	 uT4SN9+bXKNAolpYaCheToAqF5mOLbh/CoUyes8LwzdV0deqW3QWaGoM01ORkeHdkL
	 Fb/lFHCDMCL+07pjiRFZpF7O/NoGWAEK3H0hfMEq6avAQ5hurA1YUE8UxlOFYf4rVN
	 5keKNkX62+JUOiuAw7ACxEIy8HBCP0NWSWRnom++dJI8CMHLFcoVbFgkHpnYsskkvV
	 6WDCe9Cl/7dqw==
Message-ID: <4964f874-3f3c-464c-9977-0d004f6ffdbd@kernel.org>
Date: Wed, 9 Sep 2026 19:07:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] proc/task_mmu: remove unnecessary inlines in
 function definitions
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-3-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907063918.3432401-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0032D20009
X-Stat-Signature: 4z9nr5sf6e4d33kmctrjmdqfdytkhiuo
X-Rspam-User: 
X-HE-Tag: 1788973634-215461
X-HE-Meta: U2FsdGVkX1/OeiGbcmPmAIR1kHmquXxcMCqC/tDIiB85PWBoqrfD0JEfEKPSOPPxz0YtDMm57KpFzX8FxsE6Agh4tmXTyHZ2UaCyd/tXkTIdl73fKlxC4iW/q4T2fDOgf04mAfSwgSHfJMenEO+3qBi//9RYdRza2RDmIiUuIiSI5WeIwoakB1hQoRKZlrAH73rQNZGfhLJzZm4FPCn70t6yrqukGbkSTjfVqho63uuwE1EqZwXqoWIxsV5UdfU4dezlqWaRtvc250M88aaoXA9JptsrRz0Gu75l9BB2vNCZejzTgIyWEgFF91r2C5y73E+bB2KEY/2plVXv70rM+LQgkii+AEAXpZ2Q2tdfwXOp3yMPbjpymXugzmQGmmVGkm9iWBUsna9jx89lRcTZV8BLeWE4o0ICtvYzuGid6ogu19nJg0e5rL5FiUDMwbOWOy1umlaPfuJtPKAr3y7cAck1ULvyIH5Q0xIketOibV0YcPlGgOP+QOfXzaLX2iFIQ1r9PiJGlmyKe04rGpw45BkLEq5X9FeIXsP8aLuspfd3jLJu3YV10eTD8JnG/KG7pSVDq7QLtFMsWG3OG9VhEmMmpsXnr/pAZOtkhDqzuSmCg5rohllmtqOk2U2R+0iDDtheMe5pbdPaRuVC1oFaHao8fuOsDv7S+bolfWY2LWgIsliTzKWG0BT18rdbtfVGF70WjedjZW14eDBWOxJIkRPGWodVsKH98Wwgnu/UljRMsiOGacDR7Cu4vPVPZDpa8pJjZd9zJlH8JpJKwn5JxHsDKoKHU+lMaxSUpI4wbOPx2J+DiWQr+yJZgpwDIKejfafZMC/OMSnoEjyzO14Ikxt302VzRPuWUJcYcbDHV50/3bn7RUiW49yAY9Ydi/ZaL3iIE3YcsJ1NRc/X9De4TFeimcahXbPDcKxfcb+qo5ttZ2VQM14tTJWmaqvo+m76Dat/IOM23jpuZSvm4aI
 ieu2e9Pm
 z6wM+ReWuldzEewKDKx9UN68fFn1IdAPk1/dsnaCDaW2ahkVJloOxmjqf5Muq6ZeObOZtlTJM47Q3XEVVtegTUWJe+KV85xf2V4vRSjCGB3EtSkxPkCq4F0hGOCWVNSC+b3R67ejUCm7woi2dwE3msq+t20cYmlvcUGjjYizSztsWX9w0UUmxogeeHnUPeB08nHx84zVbO2m7sVoKkjEfRUAFg5GAdAytIhDaWoQUt3KTzr7dpLCqNBwDOkWjSL2myJCUupetICzKb2MXFmYX/8IRtQd7rlrUWK7YOpqsarHBtf0dABz/8lLl7lRJggP/kJRMzk00f7GNwbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 08:39, Suren Baghdasaryan wrote:
> It was pointed out in the previous reviews of this code that many
> functions are specified as inline, which is unnecessary as the compile
> can make that decision by itself. Cleanup these definitions.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2f500d639db5..9908ba32f180 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,7 +130,7 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>  
> -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	int ret = mmap_read_lock_killable(lock_ctx->mm);
>  
> @@ -140,7 +140,7 @@ static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  	return ret;
>  }
>  
> -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> +static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	mmap_read_unlock(lock_ctx->mm);
>  	lock_ctx->mmap_locked = false;
> @@ -177,7 +177,7 @@ static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  	return vma;
>  }
>  
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> +static bool fallback_to_mmap_lock(struct proc_maps_private *priv,
>  					 loff_t pos)

If you touch these, please convert them to two-tab indent.

-- 
Cheers,

David

