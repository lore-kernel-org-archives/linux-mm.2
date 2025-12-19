Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1110ED78793
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CE016B0089; Fri, 19 Dec 2025 10:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77BAD6B008A; Fri, 19 Dec 2025 10:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651206B0092; Fri, 19 Dec 2025 10:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F2D6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:52:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE38213613D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:52:16 +0000 (UTC)
X-FDA: 84236662272.04.5C3EF9E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 56F768000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:52:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tftoA0hk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rZJf/GG0";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tftoA0hk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rZJf/GG0";
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3N0o00Tf5sjF085XA+u2xOgHgaYEz/LAzNspJTiomo=;
	b=pTdDYKnEDBIWUC+hPtFQz1azZrommaMt4BVxp7nfommScK3iWQJ+Q9WKvNylP1WqJKwXhY
	Pz79bTKkSrFUAc8H+SQZdeHlqnGnr2D20U6nXDV425q0LVq6mBcz0Imh32bPj+NP89k/la
	f2z7r+f3MeQLv9kGAELUflcF8rOJhrw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tftoA0hk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rZJf/GG0";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tftoA0hk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="rZJf/GG0";
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159534; a=rsa-sha256;
	cv=none;
	b=euHnLHRXJxNr0ClwxHqkkZKyTwxhpuZQQrLGnNHKBB8DRE39gIoewubIJMGt6WbIty4+ie
	j+69SFtn1YW8rm15p3WWDuqG9fp2y9yxGjQ656n+VjJghXQDwNBwcbW2DXW4l4RAYyx7dr
	gjvVQobdbJnEpN/yo1f5ZLdaA8UB6HI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 84080336DD;
	Fri, 19 Dec 2025 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766159532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R3N0o00Tf5sjF085XA+u2xOgHgaYEz/LAzNspJTiomo=;
	b=tftoA0hk62rgcoB9d6BHmGHPt3U0HXUncNezt2zO1Yb7PpLlHsUedBe+QURPcdqakOJQGP
	+V9tXxJEaymRaEi6ivGk86aTvrqgMhd2k7hbNRkiH3J2dKyLSsKsqA5B2zFZJSXtRiaqxf
	Hx0t5SMPon6F07J+l/GkvajudO8LsSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766159532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R3N0o00Tf5sjF085XA+u2xOgHgaYEz/LAzNspJTiomo=;
	b=rZJf/GG0h/fkDyfV+6i5JEnZ8Vw3Uq7msfPny5coq8Q72qu3xotQPFQazrHKgPAQggDzvO
	jkaPLYrJw6syHTCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766159532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R3N0o00Tf5sjF085XA+u2xOgHgaYEz/LAzNspJTiomo=;
	b=tftoA0hk62rgcoB9d6BHmGHPt3U0HXUncNezt2zO1Yb7PpLlHsUedBe+QURPcdqakOJQGP
	+V9tXxJEaymRaEi6ivGk86aTvrqgMhd2k7hbNRkiH3J2dKyLSsKsqA5B2zFZJSXtRiaqxf
	Hx0t5SMPon6F07J+l/GkvajudO8LsSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766159532;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R3N0o00Tf5sjF085XA+u2xOgHgaYEz/LAzNspJTiomo=;
	b=rZJf/GG0h/fkDyfV+6i5JEnZ8Vw3Uq7msfPny5coq8Q72qu3xotQPFQazrHKgPAQggDzvO
	jkaPLYrJw6syHTCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52DB63EA63;
	Fri, 19 Dec 2025 15:52:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hqZYEqx0RWl8SgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 15:52:12 +0000
Message-ID: <5688d766-94b6-41cd-a3c5-909c50f3483a@suse.cz>
Date: Fri, 19 Dec 2025 16:52:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Content-Language: en-US
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Alexei Starovoitov <ast@kernel.org>,
 "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT"
 <linux-rt-devel@lists.linux.dev>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
References: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251219085755.139846-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56F768000B
X-Stat-Signature: x77ayhaoxpi71c58jzao8g9taybzwwyn
X-Rspam-User: 
X-HE-Tag: 1766159534-565680
X-HE-Meta: U2FsdGVkX1/f/N7rJKNs8dUEyCScbTibzVHVDPjnyjb3VKF+daGyiAuUPYQzvBrtn/IuwXlBbEA8Cf2tv2o5GmEgLvpNWPeGnpirWWpKVrlzV1lcoRRAHjrC73Rg4JltbU8OZ+edd/O/sF0JTKx7s2hIMrLBnAee1OM1D1Dpas2tIsPb9RqH6s1H6Jb9GnyiaCYx8P1q3kby9YvjPH8PFrgTo64n7vEnp5Ew8OiWnhBBd1EYhDZjfnyshfwil1R+GXjeWMgf4Iny1XDkqVv4cvRvMyRYVIB2rW5H8bJehStCqoGs1xRhKf5H/2QJfYGoS5fgib/iL6n01tRcZKXM3Gen5URY+g7MJ/3ZdO0CQwTamf8WyMAMiV9W+SdVEnJFhLGTDhn8koOFMmgDCAJ+34vfHJ91dcyVtsY67Od2yIwBupqqKvgKK3KpUReEN2L7DjZl1n/OmXc6A3Bsm44dvMITO1ip3aDjmPDAuZJu5MWOH3LFCSuSFavk4pmAc+gg+ncA4E4suiSwbFQj5HEX5LSq82Jx7Oh4xUpMDyoxXbgRyvjQBAYgH/ubqBhb6MUifj5ug3GdzhM2tbGkMlGHRdD+rWUq1f2CFvzEFdTW+Tdf1uZmuAf0pwVwE8Nwo2z72IOXyLnRu6azc/xI+0SkDh5mmPoqrdn9IzK8yzeA+WMKIE6keQzPGwEChooueI2VL+8z1jpFSqAuvR4IPVr3Sp4ns//6Ei6IxuaKGmNyJauxoqB6vYa4eBlTm3Vdf5JqLg7h4qIcWWJb7yiPuN8bH5d0IT5DXjRy1/F+bUK9SeG+vi6UseHIMRlx810laIISkin7nPMr9R7u1Tf9zCgLdgKTmjkYktE5sLiVZKwFkfHdDYO8qbuX82xv3nMKayuFrVDaARggEzsP9hUwFWUUhsaYekZVt9M4yQbIpniASSAzAaizecaRQ0AvTLOq/Zhn6KaoDC/HGeFew0dy/sd
 ec/iI6XU
 PFxar+pFrO8bJXXUcMkGaHgrhMyKZ5WofBofAJKiveN0s4DKEY/WizWH4Ryj6uNMX+b2/oNU1VkAC8ClcTq0wbeCo84OzGmL8OJlBXkEcclOWnTyh71nQgkuGgLPUvSrFdhEIaU3DbA3UirUIwN4x/OIVnh/vcWMwOGtiAE6S4sLIuXuHNn/ntEz/jD8ejEbXuAMVhIpY6FlaSrtpgmTL2TGNf/Uqu2OaLQlnP6GQJ7a0WbS8wFhxTet4VtZFqk59fvDU+XlgbrquBz80jAxsJUd+vs/A75j2RRoG3zowpuFW3Tt6wf9JMSB2KAjx5k/hnMsSFmiV/SI3hlzTqQRXAWAvN1Sfk/KbzT8DR7Q8bmOhY9/a5Iw8pjKS6CeORHYzPEpHt2cOd4rvKmQP5vmzc1a1uo8xpjpf/8S0NXitkp66F/dBFFXyZz8fpyx6vY2zajkzb3Y0ZP6vLbAC9k2etdm7FqNAzhadgnI5rIhKR7ipxqBn/hUFgKFr22fAritEgAKbGqg3IPa/fupET4ASPA27YPFDcGy5OTBi5SfJKVSqh9iQLoiekHzCyDSafNGEG6Sz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 09:57, Swaraj Gaikwad wrote:
> On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> context, but misses the case where preemption is disabled.
> 
> When a BPF program runs from a tracepoint with preemption disabled
> (preempt_count > 0), kmalloc_nolock() proceeds to call
> local_lock_irqsave() which attempts to acquire a sleeping lock,
> triggering:
> 
>   BUG: sleeping function called from invalid context
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
>   preempt_count: 2, expected: 0
> 
> Fix this by also checking preempt_count() on PREEMPT_RT, ensuring
> kmalloc_nolock() returns NULL early when called from any
> non-preemptible context.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e

As a side-note, I'm puzzled why that report says it's bisected to commit
0db4941d9dae ("bpf: Use rcu_read_lock_dont_migrate in bpf_sk_storage.c")

I'll reply to the original report though.

> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---
> Tested by building with syz config and running the syzbot
> reproducer - kernel no longer crashes.
> 
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 2acce22590f8..1dd8a25664c5 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5689,8 +5689,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>  	if (unlikely(!size))
>  		return ZERO_SIZE_PTR;
> 
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
> -		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq() || preempt_count() ))
> +		/*
> +		 * kmalloc_nolock() in PREEMPT_RT is not supported from
> +		 * non-preemptible context because local_lock becomes a
> +		 * sleeping lock on RT.
> +		 */
>  		return NULL;
>  retry:
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> 
> base-commit: 559e608c46553c107dbba19dae0854af7b219400
> --
> 2.52.0
> 


