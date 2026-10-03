Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D742ACA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 23:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606626B0095; Sat,  3 Oct 2026 19:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DE16B0096; Sat,  3 Oct 2026 19:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2896B0098; Sat,  3 Oct 2026 19:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1792D6B0095
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 19:13:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7EA41C3E16
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:28 +0000 (UTC)
X-FDA: 85282868496.06.2A89969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB264160004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJSJZfuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791069207;
	b=LP9T51gbtfXWizqhZ1Q3EOYAnY5+KWJVGh1lLK8TFzkcGOlruIuALDCuMcfjLEG7/q3jTc
	DvLzCwCZ1VPKFxC7SCDUKwETGAcsf/EQDdi9l19fa0KwV4BVG26di+zHWwu300uTJzuXcL
	FwuLiWZBGUYgv8bI1sM5xjn4NtAAdvY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GJSJZfuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of netdev-bot+sashiko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=netdev-bot+sashiko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791069207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEvGVkjJzFQ0aHmQXFQPEujNs9Tyg+JaVUsrq9l1VIM=;
	b=N1ATxyNOpp9dZObTihPoOfRcdjAhos6G7cdxJt4M/w39PexhW6+CjG1/Ey4GcKyPJyROIY
	cD5N/UdfLDuHudxBkWykWO2jU4oTiTrhva2wDfF2HEnr8lMx0Y9mRzL2W2BFvILeqfN5bg
	eFF9sBOQxn6XkjI8fEgzoz+rhjxUym0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11B6644591;
	Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6861C1F0089B;
	Sat,  3 Oct 2026 23:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069205;
	bh=WEvGVkjJzFQ0aHmQXFQPEujNs9Tyg+JaVUsrq9l1VIM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GJSJZfuTQIRM1fr+0rl5LHjZAJyqd4InMjLwI/zFJvIuv5T37W0Q4zyR8ewpgXlyN
	 Emd/SeeL1MakfSB7/zU4yzPaVMIWa/m4cDg0F2yOQ1tLwt1IcvAHUr5L7RJV9iDShB
	 /DLiVokz/HjfEL9i/jB1Ljjuw/mcFKeqshkRKihvTcit8VIEHiwmL2Z3gUxxiPcY01
	 slSnCIqcilboDr/L36IMdwjN0l9ehq6MUd0varD8JEarJqFX+MDWaKmXX1sfdT9TyB
	 7eaQhg1mhCod7b1YTiKqCf8WqG+uv+D1OfLWfbBkD6DwHr2SO/Fa/tr816rvQgw9Od
	 5gBy+sWQDbReQ==
Subject:
 Re: [PATCH net-next v5 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:23 +0000
Message-ID: <179106920397.434549.7271409150598093746@kernel.org>
In-Reply-To: <20261002231132.1646573-6-kees@kernel.org>
References: <20261002231132.1646573-6-kees@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: rogeohrie7iqyscbbftqsj8bjxk4qn18
X-Rspam-User: 
X-Rspamd-Queue-Id: EB264160004
X-HE-Tag: 1791069206-498076
X-HE-Meta: U2FsdGVkX19dxqVwHj7yIyf8h9HVyfzjteMj1kPGm0fy4CDn+zxlJAw0D+pIc4LNNoaKgccCZJoJvWvsZNeXxIfxWpyljarRKdgvwJh7Ke47P6cWjc8XrD0gUSn1SIGaHwGiBmzBnYUmaL2mMAeKlW/6D/9sze1FVY8T28jsnloQjX86GYXTgY/rveWUmg+d/6ortI4gjSxxgHXmZJKkz2F1lrl2BWh6GjKFfYGBBiBmIIh+4M4uQ50mqg4DyyxW6B1WmmV4imQV497aQ/xEbYnu+schYSgqWL/TXUJzzrerQmIsPKkt7L7n6a/yXJH9u/m1knODLRcOaAjYdDppDMniSmJf9OPa79nYolTZ7jNvXBzdNFOy1CasbrMpu6TuyzCtAl6hxFjyUx04LiJbTlTze6O4hCUErMrmVKAQL2TS3IXOYnPhPx2d8KVfq/RJwXyElzyLioEo71piHyTIILgi3O1U20dvQGfdR2LW0FJepaOHSqipw0Bhd8gMdk8dFBQJh+43NL4iy9+M+jyuauSuDnLbZkFQeth5T+UZREKlvm7gosbXPD6Zde5vrAPJaKRc/9Gwu+JSICZBG9hTN4jcWDrhG+FYo72dgaCNMaMJAcErDjO3xQVEF//ahbjrscYTZ9Q/ia9zh+S/A7DBJHmmAzdv5ckN4IrcWc6MWPe8NeR9Gn618swH78PzqqAmP8NKGBaN+IBot98LtAEnqLGwqM1CVW3UWdDCxtANp7MPlF4leGyxXXHtPKRZuiGuPlEZXJx8wEGFs7GcqDsIuVB9A9meBtaG2t1cEPtCwjxQgyBul6Bt6qdRiy1w7c/Z7QYPk7lZrHVDbNFlKjk2SFNyHQHKgtdMjn6azNCGW63j5qcMHvqkE0Um8VPBMca/me8OMCDEtSCEXnIY7fJrBasaAYtb5N5CXf2boyGf2k0Q3hh8j6N5vv4XC1vtbTDuVd5aQ4unC9SZv7wy2hk
 qnhhecu4
 PW/xe57fhACIybkjkOYBZFwJpjd2CrbCDPgMkz9u7CaHfmnMS3Qr69yaBpVzPNhN8zVJU+MMqZhfNtJ+1wdgLlJLYYiqOnNl01ZczItaXQ90Vtq2vbXT6Wa1vyS/iRQDTdIg6KtAHRXh0QMyKsMFRsTLC1WP9dkOK3o53hoegkrp/MJKNdncm0YSWXFhYVYirOIa5Qs2/wFsDIS3PaOOCoi3rfP5BiWCj/Fgl1mXIIVVVaqIYgK4CxrParj+OVPAa/VvaQvB/vcpOGi4PEHvrkIOMfBsM70LF6fihkCOeLVn4TwuOmei4reojQ30zSGmmxMcCpN+5wh0/C6E8jrEzk3ehH94ZEjz1s2QJLA9/Yo6Xc5DJb1Xp+ciJ/HGq+3S5rK9yefqh4SdG348nh6y1zCd48hpWlcQfrhFy3GLkUa4wEuVvIvR6BfByBXymoXXWAygVbANwGRmzjWGUwvqOWgwsOqqF6mj6PH6+tZj3K78LBVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch adds a WARN_ONCE() in kmalloc_choose_bucket()
  (mm/slab.h).

--

mm/slab: Let a bucket set handle __GFP_ACCOUNT

This patch adds an optional accounted row (KMEM_BUCKET_CGROUP) to a
kmem_buckets set. The row is selected through the type mask of a new
kmem_buckets_create_types(), so __GFP_ACCOUNT allocations can stay
isolated in the set. kmem_buckets_create() becomes an inline wrapper that
builds only the normal row, and under cgroup.memory=nokmem the accounted
row aliases the normal one.

> diff --git a/mm/slab.h b/mm/slab.h
> index 7f1bfee83b92e..2af44e09edda1 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -435,10 +435,31 @@ kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
>  
>  	if (type <= KMALLOC_PARTITION_END)
>  		btype = KMEM_BUCKET_NORMAL;
> +	else if (IS_ENABLED(CONFIG_MEMCG) && type == KMALLOC_CGROUP)
> +		btype = KMEM_BUCKET_CGROUP;
>  	else
>  		return &kmalloc_caches[type];	/* No set holds a row for it. */
>  
> -	return &bucket[btype];
> +	/*
> +	 * Either this row was created, and holds a cache everywhere the
> +	 * general caches hold one, or it was never created and holds nothing.
> +	 * Test with the KMALLOC_SHIFT_LOW which exists in every configuration.
> +	 */
> +	if (likely(bucket[btype][KMALLOC_SHIFT_LOW]))
> +		return &bucket[btype];
> +
> +	/*
> +	 * A row this set _could_ have held, but was not created with: the type
> +	 * mask passed to kmem_buckets_create_types() did not cover what its
> +	 * callers actually tried to allocate. Report the mismatch but still
> +	 * fall back to the general caches.
> +	 *
> +	 * At present, only __GFP_ACCOUNT can be missing.
> +	 */
> +	WARN_ONCE(1,
> +		  "kmem_buckets: __GFP_ACCOUNT needs BIT(KMEM_BUCKET_CGROUP) in create mask\n");

[Severity: Medium]
Can a set built with plain kmem_buckets_create() reach this WARN_ONCE()?

That wrapper passes only BIT(KMEM_BUCKET_NORMAL), so the
KMEM_BUCKET_CGROUP row stays zeroed. With CONFIG_MEMCG=y, take this call:

    kmem_buckets_alloc(b, size, GFP_KERNEL | __GFP_ACCOUNT);

kmalloc_type() returns KMALLOC_CGROUP for it, including under
cgroup.memory=nokmem. kmalloc_choose_bucket() then maps that to
KMEM_BUCKET_CGROUP, finds bucket[KMEM_BUCKET_CGROUP][KMALLOC_SHIFT_LOW]
is NULL, and warns.

Before this patch, that allocation fell back to
kmalloc_caches[KMALLOC_CGROUP] without a warning, and
test_kmem_buckets_type_fallback() checked for a "kmalloc-cg-" cache. In
this patch that check is replaced by a comment saying the fallback warns.

The documentation added in this patch still seems to describe the old
behaviour. The kernel-doc for @type_mask in kmem_buckets_create_types()
says:

    Allocations of a type that is not covered are served by the
    general caches instead, so a caller need not know in advance
    which types its own callers will ask for.

The kernel-doc for kmem_buckets_create() in include/linux/slab.h says:

    Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
    are served by the general caches, keeping the type they asked for and
    losing only the isolation.

The commit message also says kmem_buckets_create() keeps its name,
"leaving existing users as-is", and does not mention the new warning.

No in-tree caller appears to hit this, and that is still true at the end
of the series. However, kmem_buckets_create_types() is exported, and a
caller that follows the documentation would get a WARN splat. With
panic_on_warn set, that becomes a panic.

Should the WARN_ONCE() be dropped to match the documented contract? If
the warning is intended, could the commit message and both kernel-doc
blocks say that __GFP_ACCOUNT allocations need BIT(KMEM_BUCKET_CGROUP)
and warn otherwise?

> +
> +	return &kmalloc_caches[type];
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org

