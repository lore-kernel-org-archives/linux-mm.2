Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A622C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AFD6B0095; Fri, 28 Aug 2026 21:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AFB6B0096; Fri, 28 Aug 2026 21:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BDD6B0098; Fri, 28 Aug 2026 21:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D741B6B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:10:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 513831205F5
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:10:40 +0000 (UTC)
X-FDA: 85152527040.06.A37E4ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 84C8918000C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:10:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B8E/sx0Q";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787965838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O81DWSElEdPe9SxBy2pFNHAg83+44YOp6jW+Y/wLfUE=;
	b=UB6LJ9cJRId6CnOcz2q8OPbjkGd912T8K71VBn1DLirRpdf0VPxmUbFXSxTvswMVWU9eV6
	cSXye6oAU3sMiWFTZCvoMQ1O/fxQS4kvB2Vwh5MsT+GvxFiT6XfFJotrKcU7ZpKo/oGZJn
	TzOWhBiZqkAZGcHnw2D8ckydmSTQKoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787965838;
	b=Jj4rNK7cHxxJszqoTyhLBKsGEEvUjGaxfILGRIM5Gx82Ft46xCr3YuZUkz71EfK7OFRgLS
	RetZYrDqyl2xoXlAdb5pCEBTguvpPyPKSnJP9CMQthiYCLk90pYvow3aUR7GO9JPkXUoLg
	4jl0OLH0sBHDL4DHUj4/FSxymHcJB3k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B8E/sx0Q";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 776DA60A6F;
	Sat, 29 Aug 2026 01:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73E31F000E9;
	Sat, 29 Aug 2026 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787965836;
	bh=O81DWSElEdPe9SxBy2pFNHAg83+44YOp6jW+Y/wLfUE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=B8E/sx0QdZDERSseGfwloHK3EaU9ArsAkSsTdjuCrjUQJzvzf3fKgT3y6lyHSCJwY
	 IliF8AaxY5b9HRN7StKjWYIlzN90SFpsZi6cMSvfj4aTO0Kyg75LfuybwlbFfHyoEn
	 9tKVarnSkWIhi0gbNndJSFawV8J/QZdHLPISL+B0=
Date: Fri, 28 Aug 2026 18:10:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org, Wenjie
 Qi <qiwenjie@xiaomi.com>
Subject: Re: [PATCH] mm: filemap: tighten dropbehind completion context
 check
Message-Id: <20260828181035.ce6e23970d37e38b64818f10@linux-foundation.org>
In-Reply-To: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jki77h9gaexig4619kp5s7qcsmtw9y4c
X-Rspamd-Queue-Id: 84C8918000C
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787965838-111715
X-HE-Meta: U2FsdGVkX1/pk+/6t417/oz/9+3NCaYvP+NcSJiA5dhfveY5gJpPe7cgJz7fZgIqrvk9bp12LtHmKwLlralkJCETpLOmBYgFLSs1B/3Qx15hJuXv2aqFKxCTYbIVPM0JwMiEnS4uALkxJckRCDgqE4gfBZ44MF5Q9fRn2+LIqp2IVMhjfQho5vOm/BWYV4GdtXfxGYAcqkpJ0vGJa7D2dpF+NlJhePXxuwjLLRMnk5E4v+Ku6gzGam4//1OBWB1zNkEGr6+AXFb5NSs4XGDp9xUc9M9Kqi9Eyu4da1qHIll0WIzb2Dk4sWyjRM00MW6Dpb3eEoSxaSCwsAo/kLtbzmzo3mSawFAPRZ8GF5EM7B/nTy5SnmbmuuxakZxKJPUkiDh3/0B0lFl8hLLuUy0Q4beQe/Kl83V1nH1m8isgm+oozeXURd31oqDLncxISGP6G0SolyCm8ifTaAqQCCkNZitvJcmZzI3LboDEDqISEiLHGlzBZIHo17Hrgnt/dj4nZrl0koLPx7cRgX60DIsL/vvncYmXfINu1Al3GDzfFlDwGmugPu/5+CyGSwUxyk6pOkcubs0saC9as5U7ammperub2lTzP3Wyk8HzvtaRlGgXx5VR+XxFcUi036QZmRdEMrmC/qVnNT/Tfhr5sSGMEJcOeTf0pn54VBoBEmgXy7W+xq+Pdn4bZHUmPgTVBXddcjyC60yCphqTts+z2L+cB+C69yGzR/ADDjkxrxy/xcgwEgBylFpUhjl+dNWX1sHrj2udBOIkjVwkf2zS5uk7DFvwbBcOWWe701/MWtU8iYKPaRVxn87iGM4M0vmJ0ZUZgmdKwD7ehgvEgejjtqPYgW1neKsO+St0sqU9U2L5dUScVe/2hyNRDP7D6BPh+l2MqrlSzd4VRsiOcktaLkyahPVOEE9i+b2BljioVRiSdJNJjMAT6aMk6MyFTM0khbq9oiykQaCGZ7AiWzfCjxC
 yObfD39c
 Cdwr1JdOOqDGOWBjOvEYMKOH1LUuMgJqjisUd1dFG5WuX7hqdKe8KMEdsjWO+OZxyMFGg9hxJZRDHq3i2VYsXnAlR3wYY3O7tuzwY+oVkiQhcz+2VgAE7JgjSIr6UehYM7+i5XbaZbJQ9lTiwuElk4QL2bVudi9XVek5uTZ0Of/GqhXMp0qjhyQFxeVAYOBzL8op5PZnQRIZMR2Ix8Led2wS4FXxh/UgGoXElbiYwuHZJaHcTCubpZdwuqaFE80Spvr55upYiGkHjBNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 22:29:56 +0800 Wenjie Qi <qwjhust@gmail.com> wrote:

> folio_end_dropbehind() uses in_task() to keep folio invalidation out of
> interrupt context. Task context alone is not sufficient: preemption can
> still be disabled, or the task can be in a preemptible RCU read-side
> critical section, while filemap_end_dropbehind() may reach
> folio_unmap_invalidate() and sleep.
> 
> Use the established conservative three-part atomic-context test: reject
> preemptible RCU read-side sections, reject configurations without
> PREEMPT_COUNT, and otherwise require a preemptible context. Unsafe
> completions retain the existing best-effort behavior and skip invalidation.
> 
> ...
>
> +static bool folio_dropbehind_in_atomic(void)
> +{
> +	if (IS_ENABLED(CONFIG_PREEMPTION) && rcu_preempt_depth())
> +		return true;
> +	if (!IS_ENABLED(CONFIG_PREEMPT_COUNT))
> +		return true;
> +	return !preemptible();
> +}

Cripes.

There's nothing mm-specific about this function.  If we have a use-case
for such a thing then surely the function should be kernel-wide, it
should live at the sched/rcu/etc layer and it should be elaborately
documented?

