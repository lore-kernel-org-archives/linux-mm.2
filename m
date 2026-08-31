Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE11C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577846B0088; Mon, 31 Aug 2026 10:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F806B008A; Mon, 31 Aug 2026 10:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441656B008C; Mon, 31 Aug 2026 10:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 205C06B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:35:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89C7EA2D66
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:06 +0000 (UTC)
X-FDA: 85161811812.16.23B5E35
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB715140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:35:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=FhAo1yGr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=reRENU4a;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf09.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQCpmpjuzvHZKeDSxOgR4WXgjVD/z/uOxa2XNFhQrvs=;
	b=WJQvwWTy0JXbLzb/PtkfEWycMckHu8q9cLUN321H2qhtZXK6QYcITXMhtMwUmPvJJa8EsO
	LnPqUy87H/69wWEfMqP9bSICRFuD3LOFaDf0F58qc/OpBjviZczX4L11E1K89wdZSCK+ge
	ryNOruZ2l0/l2amIg/NaAmlZ+SVUsYI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=FhAo1yGr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=reRENU4a;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf09.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186905;
	b=W4ew5pGZMnMXnfEVdIfvir0hCtsisJvUiidOhTPGXl4fyx9dJGlqzZfAWmOzILUkRJHcuo
	EhySddXAJcf1y167jsosdT3rWdkqrAdRyohzcuCEhNKTs1Qsnn7X9APNyGOMrqGMg2lfpI
	unSrlHbLwjgEDYqotBaUNye7cfVa65s=
Date: Mon, 31 Aug 2026 16:35:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788186902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQCpmpjuzvHZKeDSxOgR4WXgjVD/z/uOxa2XNFhQrvs=;
	b=FhAo1yGrj9SphkX9AgYWKr+BHHuPUfBmwP9Dan1NTqSDH/U5fXvsYHSuFynU6gVgg0WIYL
	+ssRsiMlqu3/n5cC4pnURxb71wJ8P7AN8G+aBDEaYMo0NWTzVmYxTSctonb5Qjzc7XVcg/
	otydym7L4ADCgWyhwyT5ExJuHbibM8D5/ER7DdQrDWA3KSdnufKo8SrI94LGhbuwd5qBsS
	/Wsy4GoQZo53SRUvf074yivr9StvQFtRW4uNiFOFByCWW3vA8oTc+pr/cSm+esOW9LttRX
	mrxBiwjrOnYJP+2X2Qbqmc0gtIk8Ahc4lLV6sylGOYb3yJdUtzf78xtoEzyueA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788186902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQCpmpjuzvHZKeDSxOgR4WXgjVD/z/uOxa2XNFhQrvs=;
	b=reRENU4aOqlwB68Wj9QIk77rut8hhjnkPAQX7aFzOZ76ib9xdFd83UL1in678UNrSl3nGF
	7Zf4PHqa+3Kb8lDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: ThangNN99 <ngocthang2710.1999@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in
 kvfree_call_rcu()
Message-ID: <20260831143500.x-saxdAs@linutronix.de>
References: <20260831130057.HLukQ-zm@linutronix.de>
 <20260831133222.8637-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260831133222.8637-1-ngocthang2710.1999@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB715140008
X-Stat-Signature: 8yzzc59erbfjp1s5kt8up1z8s9rptfjo
X-Rspam-User: 
X-HE-Tag: 1788186904-343080
X-HE-Meta: U2FsdGVkX18JDWgjZ7smiVIeRYk05mnuQ2FkWrNd87GTswRT9E6Qvy3GZCniNPJjm+7UlLpCWhPuxT8/Zjfl0vHOTyBLIrtPhPHj6Y1v4K26L4xWBDQyOUHPedvikYO2geRoyE9qsZMPvJswCyv7EpNBikRP8c0zQpBzSitS04ZQHFcKhDrW7MsjZNyWPnH96tRCbtaluzixgfI9jl3WqeCCVukv6ZYu+CWyySUM4YHH5cXY3hoHh0Iz4oC1P6OlRe2gbxnmrH5VB9Mriw4EZiK8OUS+QHQ9MXP5Dyxa5HImmllme3vrYGRruOn3Q767x1KgWeNd9QUtEhox4xGLpwfhDQ/Cx+dlNGJyzgHXlud8mp+WHL/e6n0yTgQIqSkKgx7opvLlzdQm4UWC45+O2O2SIvQCuqT82+j5vIS9yyOe6qfEq6oqlTbBa30O3W5bsvlq8+GoZTxCnnsCOObnZtyCPhFSMDpURZyzsNHalKa496CIR+qCX4V1ABfZylFeYEVrwCOeN4f2zrR6xfknIkcdtBmA90QDD/vG1YgkByFKqLIkEmvTHiEkVe3cddJZLI2JVmUa9O64jWS795vw5og7i8n142VQiyncz/bJW0D23/oyE2lH+x0iYALgMOeCXSkXR4fLv0OmWMOOIKAxXrY4rUVrK7sr6fFDjemXgqegBFWrHzf/O1pFXhUCJJvxkhpq/+xNiWACI88W85zrby3Iya3QqvOok6swGw8Tj21YmGYcr0MZnu2HrmAXdqX0WYZEcqqAO9gd/0gMKWaEHjBQEm3yEMwTxOxJlDffiNwbQQ8Po1UmRIC2kOOhQjTBgxyBD10YYp6q0Fdv36lBlEcOdXtnOBlA1g07gDkf1hLGNse81ocaO5sodp7PUjXyIs0mVvQ7OYkpjugxkHDJZ1Ebvi7Zdd9tCy2EuNJz5uUUaGZAaK38DGYFdYYL0yb5/vQRK74GdXpGA6Npes+
 edtUtYTd
 X/oBzAZq9PpJ5ZtF9DqOthkl049NCLMQauhOWlUHisBQCsFox0QwYIVJB8i8qtMz6bUFscPLTB8m4Wyzc3Brmk55DBN+afWdIEJYk0JMUmzw1LrRqMg6U82OZl5Akkxvam83A2Ooi3tyAJpaioMUrUZH07653epdZyy90eolVRSAIwj7oKsMPD/Vf4di5r0poxsMMhEJRklkm1/GuxKNHaCkH2QHQPvwzwwzgbN7HEFv9r3MQrRxhnoBaGNY47QNSrSszjc4cvTrZeRFzHkcVtIcksnkKct5BdRZONKflffwxqLYb6xRbQNJ0D/5TDXAOzBF+CX/osyKP+rt9/EQ4rnAdpV3dDaHs+Q/0WA5WG1+eYCsM1DpoDQUkcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 20:32:22 [+0700], ThangNN99 wrote:
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
>  	if (!head)
>  		might_sleep();
>  
> -	if (kfree_rcu_sheaf(ptr))
> +	/*
> +	 * Callers may hold a raw_spinlock_t here on PREEMPT_RT (e.g.
> +	 * set_cpus_allowed_force(), whose callers all hold
> +	 * task_struct::pi_lock), and the sheaf/barn locks are also taken
> +	 * as blocking locks elsewhere, so trying them here creates a
> +	 * lockdep-visible ordering conflict. Skip sheaves on PREEMPT_RT.
> +	 */

You mix up things. A raw_spinlock_t should work in general and should
not cause a problem. The task_struct::pi_lock is special: It used during
wakes and the inner waitlock of the rtmutex acquires it even during a
trylock. For PREEMPT_RT we don't want to acquire any locks while the
pi_lock is held.

What about
  
    kvfree_rcu() is called by set_cpus_allowed_force() with
    task_struct::pi_lock acquired. On PREEMPT_RT the local_trylock()
    usage below will acquire the waitlock which must be avoided.
    Therefore avoid it on PREEMPT_RT.

Vlastimil?

> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
>  		return;
>  
>  	// Queue the object but don't yet schedule the batch.

Sebastian

