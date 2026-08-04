Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D557C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC1D6B00E5; Tue,  4 Aug 2026 09:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA9956B00E7; Tue,  4 Aug 2026 09:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7A06B00EA; Tue,  4 Aug 2026 09:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8625E6B00E5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:58:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1CC3801A4
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:58:38 +0000 (UTC)
X-FDA: 85063742316.28.18DA6CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4BE56140002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:58:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtNpQIZn;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785851917;
	b=ZfMLeSLplJJnVaSSWwT742yGl1pwm0BwR/qibPCkA2V/HXZ64alhouGOs17NACUO6a0oep
	IixIcu7lLWM1qV4llji13FA6oZGp8paXx/wnlhRwkXEtNpY3fZ7Tq5KWFqbSHvPKI3D8H6
	SSfWsclGRdMqHUYvZFgAgNpe73MfBS0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtNpQIZn;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785851917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DU0+E3W+eQadbym8RaRuTNZS2KUE2FrjK/dIbBsihDQ=;
	b=5jLKmDEHmBIir50seZ+mhq6pVcaj4hzPc/wGCTAsqkFqYZEK4KlqWMfSB4YMmO0NOdY8GP
	Up6c/g/fogILurQV8gn4a8SxUrwwhzTQOy38a+5YJug0Wi0dNRXYtyhYrfFJ/pI/eA+6pO
	jFYJfyeYAjNCF7ppsepL9fgPpMjkbBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA6A403ED;
	Tue,  4 Aug 2026 13:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDC81F000E9;
	Tue,  4 Aug 2026 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785851916;
	bh=DU0+E3W+eQadbym8RaRuTNZS2KUE2FrjK/dIbBsihDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gtNpQIZnQh8lQRERkNoHf2vK5fudFe8UQgx70t4vhPWxz9Z59y/QD9ta3hYGWrUDy
	 bPHF+fViw2S7vLmZU+GxAJVbi9anE6OL+IgkJPKjv9sbiEsliUTsl1ogNL+4yf/drr
	 ahsJuQ8N4RzJCuoQWSN1lVHSoGZHSgL+/6ohrWMxrGph8KyMnTVUjeV+6WvSoTw7eo
	 VsOW0IqYAKjG74xEuXHm8Ck6Nbe3qZWkasiwWrQB/MhlekwrTFn6OIqIfCUmq4b0bs
	 gUwNBx9on663FjPRFGZO6TxmNj4kXf2DKPuNQcxI7w1VNRIaWQcToaR7IulstmBNkt
	 +Uhq3tGtA68kQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: introduce damos_sort_type for re-ordering regions list
Date: Tue,  4 Aug 2026 06:58:33 -0700
Message-ID: <20260804135834.86511-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260804100719.116538-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BE56140002
X-Stat-Signature: nyizbowefi7g7zp3wnssmuptwqi7qw84
X-Rspam-User: 
X-HE-Tag: 1785851917-433445
X-HE-Meta: U2FsdGVkX1+aRv3m4c4GcAt68KkgnaBkgeT0CWzVNEZdRoiPpGoIA03nvZvPNIZRbzlSet30uyNyUVX+98BkHUessAymFx7mbK82UwfDStSUK827eKkqX+0AoNmdHz5Dghc+1RrmFugB8MCHBRnSHesZuWshTWc1inx3wx11TWpTwjSYJsRM7PFoOTMUmU4uBaRlg94f/v4amP6DQkmwb8k9KrtLFRb3Kem2ShuwnDn735q5Timbtte5mVD3oJXds8VH9aYVQVO3R8cNtre6VKFYk3TdXsburYpqf6YZqlQtyKFrnJrZlUScm+FZ7mQ3BpLuR61Z94oxYXR+w2hikOaEYTdD58pmU6UJpPzigMiJOclwHocPYWuB7wNAsnIu21s8yza8TIuCA34ES3xHUEgdV1tkcBhL5RTKtzd3/kVqw0NuXpq7ZDX/WmBFo17szrMCKpfADzMqAzWRgbgopfPSLIIY1jJV3rNDFzHU3FQHpr1Y7FQnXiqfWSEjQaggmowh0+2B4qDTQT+SbSMRJwTeFS9HZ+q0PddB/e/F3q605RoBdf4DncCtO7RjmDXphoiL4129hsWkWVl9LlfvEj0WKqpb7Z7KJdLvq+Q3tephQgdM1pSC4y1l0dCDnLyEcveMwrNyoRxeNCsnR1OXm0d2bh7qIGnU99EWZQiDWqddlvizQ5qj+VGRmZ9CG/gzu6LEjZr0ZyFuIGVkeUIuZoCYTKrhLBb5zHxpR/W+b41JfkVV6Z3bYDYEg6SW2nIcfMPRpHTpMN6wRDy3mUNsafoki81K4mduf1vfjY+d1+fj7Cq+b/BANtk3GbwfV1N84ZTTWSvfPs80RjIZFB79a3m1q/6/33xxMUqRUzYYDUrYti5LtUpmiIShEcwH9NfRZTKPxevkxxpaOlptltpWlwS6qxxHpLeZ9Q1kju5aUaJQxi7CCorwCc8NHO5Arqxqe8mxlAPffyvsg49cqQF
 hPIRy55+
 wSJDOEmp7ZGDuq/Xp/RQMtT2Ujrhg55lGQDjd2F+887CeRkZ1zldfcCMJUZk3svVjQ7vQ7j/8db8LsKoDUOyit8InSuBjKxsswbyIDxQaBbtPmgCDXeh1xU4cPtoIWugv+cqotAs3Wu1P2f85m3tWz+Kv2fF8uJLF08ge+OPwszr/skC6Ah4HJPtl4tJQxuOxaCbHQwtni+W0oi2zC3OpAsiIzNVDDMnDjP0X+l5AHNarMHacZaQbnlTktnQv/1iDyF7Gua6+9sE5GIWyBndPmz71yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,


Thank you for sharing this patch.

On Tue,  4 Aug 2026 18:07:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> 
> A DAMOS scheme filters its target regions using an access pattern, which
> is constructed with the size, the access frequency (nr_accesses), and
> the age of the regions. The age here means how long the current access
> pattern of a region has been maintained.
> 
> For the pageout action, the age.min of the access pattern effectively
> acts as the minimum amount of time that the target regions must have been
> unused.
> 
> The definition of cold memory highly depends on the devices and
> workloads, and thus setting a proper default age.min (e.g., min_age of
> DAMON_RECLAIM) is both important and nearly impossible to make suitable
> for all devices and workloads.

The recommended way is setting the min_age naive, and auto-tune it using DAMOS
quota or aim-oriented quota auto-tuning.  Have you considered using that?

> 
> Solution
> ========
> 
> Add a per-scheme sysfs attribute, schemes/<N>/sort_type, whose default
> value is 'none'. A scheme can set it to 'score_desc', which makes the
> scheme to collect the target regions and apply its action in descending
> order of the regions' scores, as calculated by the ops.get_scheme_score()
> callback, during the application. For a pageout scheme, the callback
> returns the coldness score of each region.
> 
> Instead of modifying the region list, DAMON copies the target valid
> regions into a temporary array, sorts the array in descending order of
> the regions' scores, and applies the action in the sorted order.
> 
> With this, the scheme gives absolute priority to the highest-scored
> region. For example, a pageout scheme with 'score_desc' reclaims the
> coldest region of the target first. Users can thus keep the age.min
> relatively small and let the score ordering do the precise
> prioritization.
> 
> Note that regions are applied in the score order, not the address order.
> Therefore, the address-based quota charge resume mechanism is not
> available for such schemes. Instead, the quota is spent on the
> highest-scored regions of each charge window. Applying an action
> resets the age of the applied regions (except for 'stat' action), so
> those regions are naturally excluded from the next window if the scheme
> has a non-zero age.min. Also, when a region is split for the quota, the
> age of the split-out part is preserved, and thus the highest-scored
> region is continuously applied until it is fully reclaimed, even when it
> is larger than the remaining quota of a single window.

This sounds like very similar to DAMOS quota's regions prioritizing mechanism.
Have you considered using DAMOS quota?  If so, could you please add why
proposing this new mechanism, with some comparisons?

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> I am currently running the corresponding benchmarks to ensure that this
> does not introduce too much performance overhead, at least not on my
> device.
> 
> The purpose of sending this patch is to make sure this is a right
> direction.
> 
> About my device/VM
> ==================
> 
> CPU: AMD Ryzen 5 5600H (12 Cores)
> RAM: 8GiB in VM (4GiB + 4GiB ZRAM)
> 
> I currently foresee two potential issues with thiss patch, though I
> have not obtained the test results yet, so these are just guesses.
> 
> 1. Excessive memory allocations and deallocations 
> 
>     The default aggr_interval is 100ms. Executing at least one
>     allocation and deallocation every 100ms is very likely to cause
>     unnecessary performance overhead.
> 
>     I think this issue could be resolved by having the scheme maintain
>     its own buffer.
> 
> 2. Performance overhead of re-ordering
> 
>     Although on my device the number of regions is not very large, and
>     DAMON's default limit of 1,000 regions also helps avoid performance
>     overhead, I suspect that large servers might not stick to just 1,000
>     regions.
> 
>     A solution I can think of is using a Top K Min Heap, though that
>     might significantly increase code complexity and reduce readability.

I'm indeed concerned about this.

> 
> As a reminder, these are just my __guesses__ and do not necessarily
> reflect what will happen in practice. I will send another email after
> completing the benchmarks and micro-performance testing.
> 
>  include/linux/damon.h    |   6 ++
>  mm/damon/core.c          | 125 ++++++++++++++++++++++++++++++++++++++-
>  mm/damon/sysfs-schemes.c |  57 ++++++++++++++++++
>  3 files changed, 187 insertions(+), 1 deletion(-)

I to be honest feel this is too much for "just guess" based patch.  I'd like to
get clear reasoning of the change and/or test results before reviewing the
code.  So I'm holding the code review until the high level discussion is done.


Thanks,
SJ

[...]

