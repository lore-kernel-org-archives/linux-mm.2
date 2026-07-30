Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCAFC53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5ACC6B0088; Wed, 29 Jul 2026 21:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C166B008A; Wed, 29 Jul 2026 21:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922CF6B008C; Wed, 29 Jul 2026 21:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CE2D6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:13:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5741A140872
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:13:53 +0000 (UTC)
X-FDA: 85043671146.11.D419573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 553D540009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:13:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pPzXvTG6;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785374031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEKInAQKzOCXSMv2lRBe8VhnqO6M22pZNQ0AYXxYIyY=;
	b=zbxlQpNiqSrRyYcJarEy3HCpneJjkrUhVkwha4MfYic3DNxw6GCbkZaEGoOrRyMn65bLre
	cghj9JouLsoxK71Ut7UUQZD+/Ai37zNFmy3mnv439fwN6fheAPFbN0TNaTMcOs8x8o7k8b
	0XF5aly2MixjXKSe/OmSstAxz7RyhXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785374031;
	b=Pr/KrADxuq3Lz1cB2vCTXIAPH/IiCBTZFqb7VrYA58P44rIestC/6jf79VnQgbBGz7F4e5
	EPcb7i+8sff8ZZW/2OVWOyiTtPpSvkkfWSBIE0F6riby6WfRTh1oDhpcUl7SBvPTVKJWX/
	LkEuFHxNjzjuuifh3bl2HGNDh2MquUA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pPzXvTG6;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CB924133C;
	Thu, 30 Jul 2026 01:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3C51F000E9;
	Thu, 30 Jul 2026 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785374030;
	bh=lEKInAQKzOCXSMv2lRBe8VhnqO6M22pZNQ0AYXxYIyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pPzXvTG6+b362ZbsjEcde3W2xCG7KopSBKL8+bwuz790ugIjtB/TJOJtTtDvxMLzf
	 7j/LkpPG+eoJ5aBQwNMJHqnaRsIuwJ/x2lQNiUjJTbTwo+ag5Ur3QpGu3w+qBMnoIe
	 QbIwcdRR8su/kUzxlBikPvJeY0GGUfDHEvwG4MDc=
Date: Wed, 29 Jul 2026 18:13:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Suren
 Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, Rik
 van Riel <riel@surriel.com>, Nhat Pham <nphamcs@gmail.com>, Meta kernel
 team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: bypass the reclaim and oom killer for dying
 tasks once oom_reaper is done
Message-Id: <20260729181349.fd41f1a09ec19c9cfb0c412f@linux-foundation.org>
In-Reply-To: <20260729024612.3369005-1-shakeel.butt@linux.dev>
References: <20260729024612.3369005-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 553D540009
X-Stat-Signature: wy7dedkcw65ze837ni5eupbkz8uxren4
X-HE-Tag: 1785374031-803509
X-HE-Meta: U2FsdGVkX19iV1FmnHDO0522Y7qPZioq2uOeor8HpNAuKcCqnf0DJaIRmuPnUr0DlBRazd9ifLhuZpm2N1HhQJdlWnIaE+C6qKKfOfl2I+Rf+lsQrxuTFlUheOdcRk15v/4RwnM8AGtpfBIDiiGfVL2ghEE6CgOYwR7k2i9pHhB7oVhhKinS452V454iD46KvYtQeeDuh1joXOQhijKBCKNA6LCu9OYUJ0A46qqjYkj7632ilCrzaL1xCWwaE83hHYNzc9mu06/H/inhxa26ydg2Z7dz/VfKyP0PSiqz1Q4MxxWKf2gI3iNG7eDQGCnCM1iNI8XF/PdFY+5Oq0DVHAqs34CHEa5tEOjV6xpSh2CzDHSeN6n5xTdXAo2KIhjkU57VffCH26LxFBPTShpGH7csYx/yGUcRX9354tauM75TXkFmo7Y/02TQCYipf0FM8dsL01FHOySf3l/sWDcDjpak7mgEQGrD73LmaC2OBp1EaLBcruS07XL2VypYcVaKixAzJDCH7kCEtcP1l/NJfVghMY5faEFF60SZEQb7A2bTt3D14jrgF+XQBpfFvy3Ms1gN7uBppy0pkkiucXjYz401GCkBXXpr7Uz8TcWbJu20/FETcK/WO2Pt9LpTSNwUuZtBPn6JgY8D/VjbqUfzSCan0Pn+v8rd5iGl533JVxiDWzvCw0CLdVACnhO6jpLBJMUftkS0Z3EwHlMf+PJmfvg9fbN7uqVDJz6mwOe0Bc5jTMgNrtve3RQ1RIukJvo85RiBdVuVauO9sra8Sh+sfRLHTHihi4x/RKqwHHDT+tSh1zC9qtSPyip57FMYS1oDOCXgCdADBl/hiC5a1MjV7rlehMhBm64tp2IKi50oLYKViFcCmGwu1hMkv7VWZMgqeB6tylSgT9oQBNaOiN91x0yN6buwxS4VvTgSUt6RZ2x7fQJegmbrGxgPdC8t34vL+9AJrLxa0ipqmmVYDSi
 jJnlRHTv
 yoD/DvuYXiVZoyJwYdjET2UmVdmN5k/d8Dxc7OmWWDvAy1KGne6FMW/0VrdkLn4m+aVaSSgXfJgtM8BSRDhBWbIzKLYHq53WZyL9v89K85AEIBYtNCO1QPgKRgFz/NA03wKHDLClmanOtay+LdPR9qD5Sl7m1WjgQj1dU5KaKCSHP27/SVSYHDgaAT2xF+6piuaRaxFgF9Gsvdq3R+yjIBNYQiCnqfsrndnvFTNqx/csjKdfZDPNTIeFrMyHhOkTNGq1XQXYQQeVaECdGcqGsJJiDDkRFJhhEGNJDxFD5PhWCVks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 19:46:12 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> At Meta, we are seeing instances where an OOM killed job is stuck in the
> exit path for several hours. In one particular case, the job was stuck
> for more than 8 hours and I had to manually remove the memory.max limits
> to allow the process to exit.

Not seeing the problem here - that sounds like normal kernel behavior ;)

> Reproduced with 20k threads, each parking a robust futex head on
> its own zswapped page, OOM-group-killed while a sibling holds mmap_lock
> for write so the reaper gives up and sets MMF_OOM_SKIP. Tested on
> next-20260728 and baseline show ~90 seconds exit time while with the
> patch the exit time reduced to ~3 seconds.

Very positive.

But it doesn't sound like you're fully confident that the problem is
fully solved?

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2653,6 +2653,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't
> +	 * contribute further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) &&
> +	    mm_flags_test(MMF_OOM_SKIP, current->signal->oom_mm))
> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;

Should we backport this?

