Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A761094495
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DCC6B012C; Sat, 21 Mar 2026 16:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EAD6B012D; Sat, 21 Mar 2026 16:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24196B012E; Sat, 21 Mar 2026 16:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 919656B012C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:10:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B6ED59736
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:10:40 +0000 (UTC)
X-FDA: 84571163040.26.F2C56D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66737140007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:10:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBgdRi4W;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774123838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tY5KapYvO02wGU5/XSu1UujKhgfH7Vdqdwkr0RezBQ=;
	b=wZRc8FaeOJvLxEta9N3xjiTAUivYTyvtU7jqyy6dIpLt3MhffE5WjHRMH/bATEg2TiEKW7
	LogkqDiGF2hNlUYc8gXNiomQGfDj0dP/gKm1p4noHVNJT9gXA8aVNXiq+yN+29KM70I+ZL
	8pLDGv1fl8oCfGKYCxkiVmNvCk6io/s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IBgdRi4W;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774123838; a=rsa-sha256;
	cv=none;
	b=6j4LRCMMbX2qI8M58scrtO9YSdEtz55+nsySHwEhE68HthRHMak4hhHDtL17rEyxugbb3g
	kBH1qwRIMMQwtOg9w7NglByAHXTiPnDj9YUHl+dj4yWHZM91wU3VJfac2qd5PGWKoJAHdD
	obWXizLcvzmbdFc/KiqHCZ2QJOLsagA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EE3F408E9;
	Sat, 21 Mar 2026 20:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAC1C2BC87;
	Sat, 21 Mar 2026 20:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774123837;
	bh=OxaNBhdTjMauWWAcWeiZVLFc97MstGfxacW4qKz5Lxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBgdRi4WLL5c6IT9JCcsrC3Etn/VrD/bX+BZIoS+CjgstzmHcjujz5l97WL5TfpU7
	 fAt65hh/gBSEh7fM/KYlHa/u1aaxXTfsEBHQyH1wme0LH2ljNatZyN30ZmxATx78gL
	 JZfniWKCAfrN7cvGOxmeF2Gf7X0lcDP47sjIujCXJgqhIqKWa6IPJ/tv+yL55ustIn
	 nt09wisv7/gsy7cps6+JtqYwox32NOYU1QqKVkgaqXZ2HIXmgdWvpaao3ihRDcorQh
	 /gByy1jglZnEIABPB9WGbpWi94BjrBQq/Y7DI808G3cOWeXO9XhkAwVbIX58pl48Vu
	 cEpM+0qu4YhpA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Josh Law <objecting@objecting.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Sat, 21 Mar 2026 13:10:28 -0700
Message-ID: <20260321201029.95644-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321200522.95395-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66737140007
X-Stat-Signature: yhur5nigus8363s6qr8sw6tz4bg483yn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774123838-852121
X-HE-Meta: U2FsdGVkX1+9JGqawiS9i/nEO5gZQRpJGA+tzshVJojWoHcljpT8h3GYlqt5vTpTwOl5ADpAC5LQJv9yYyTLBB2nsoqO0J1/yhSN7v4SzFOkm5CIAespgBsKs59ilnIXuxLyIBChFTP1bAgMbmzdZc4ZnekIgokzp9IdKvboifGx18+A2G3HWnNsPS4VAojW4lkfh49eAyWhm/Ad7QX/gDk6L2wItpHWY2zEwDuNXLDVcHxdhtXD+c/ySGDjHzcGra8hUXEwMsQc3X/IsvSs8osHAQVmcxfgl0j8MLPPWnsi8y5q9u2xFui2SA1w5n1bHgIR0YIDG+zH3p4v0MEF6gSN/h56aXmRk3J9rpE5i9V/QLCFfDI3y+EFEa9AhmKf+Dg5btdThgHj56eGixQdFSYKvChCudjUxbDKEeXAODZNB2GGAfB4Dtv3TKZELb0u8xVhFg9qkcZUEC+Lgx6Kt6yC5FCA7h0KDExuj54gIGbeqzJou+dI0dJhE7t7bfpMHW5HOKmwBgzubiz7jvsqkloxxpNtZ3aw2E1cMlPgX+2/W4g0db8KpS+gIEJQVURVOsI5eXgNtrzalDWBMRG5DVXdmvcqNdnieokfKMFNnnvCdDTmajqcQUoEKpdznft1tTY5ExYef5z9gaHQiO+uT3Y0PeBiv+fIXq8Xp+yPXkQEYozIDGCfc1kJ8JNy75wo5DobJ5OKt5V9ZRz2hZsOWW/wK3X+31bs1BcBKL5WZtXonw22iOqeGLZ29XbRpsO+KjA8M1o4fiDtCZueQEyYpFG+Mdak44IrK939oEWPyKlyAn5A93JLZHEeu9oc19sOzBmVUX1myakd06K6hgnEEBkWYX8sODvV2fL3By1tF1No3MzYK6JMVP5CNdzaWgHwm3SMoQVNzE8Gqu555wkGauF6qSBCYy7UMaFmy7st/TwgLyJjdc4GnmOJ5p8wFVVZnHfZd3A8ZovCH/C+sdt
 uVoFEPFd
 gG9Y/iyK52Kvan9We3P8nO9VCXpq/qnLZdn9JbXF/DGm3J10xC/0cGhQDQcvOo2KrAVyfV8TqXiAHgla3pjxfW8Y78WSZ1IjaN2s2JVeJ230r5cF4SinjmJfzPUaPwLgsovSBwOlTMxeMkgngL/NBwHrF5GPdcGY0NEfeEkqh1+ZRL/COAlVpiyXjLTFeoHJp8dNmK2uqofFbqhwgSeUbpM0qkE6zQ+PICtyHpMYsEF5rzHavLsS8QRAY5Egb6xV2Q7trqOSohKxeD3L3nJoN2E7AEx8++XGDDkhuTs7Iml41g01p+8hePzw25TFHqnvQckHIoV7JDQHEKoG+lmL38lcEAKwc0TbVAT8739eUr1Q5nvs/cZ0aAhLwkLBFEr8qbs2PPaWmUSzEntcOvkk4HvzmSUFAyX+l84kDpVBxFb7VjlMc+711zKmA3fNAl/4RgAZSANLswN0yVibw43Aw5xQxnB9bbbaScw9Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: no blocker for this patch is found.

On Sat, 21 Mar 2026 13:05:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> Subject: (Sashiko) Re: [PATCH v3 3/3] mm/damon/sysfs: check contexts->nr in repeat_call_fn
> 
> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260321175427.86000-4-sj@kernel.org
> # start of sashiko.dev inline review
> commit 349107c02ee8a122119ac77a51451bb3d9311a34
> Author: Josh Law <objecting@objecting.org>
> 
> mm/damon/sysfs: check contexts->nr in repeat_call_fn
> 
> damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
> damon_sysfs_upd_schemes_stats(), and
> damon_sysfs_upd_schemes_effective_quotas() without checking
> contexts->nr.  If nr_contexts is set to 0 via sysfs while DAMON is
> running, these functions dereference contexts_arr[0] and cause a NULL
> pointer dereference.  Add the missing check.
> 
> Link: https://patch.msgid.link/20260320163559.178101-3-objecting@objecting.org
> 
> > diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> > index ddc30586c0e6..6a44a2f3d8fc 100644
> > --- a/mm/damon/sysfs.c
> > +++ b/mm/damon/sysfs.c
> > @@ -1620,9 +1620,12 @@ static int damon_sysfs_repeat_call_fn(void *data)
> >  
> >  	if (!mutex_trylock(&damon_sysfs_lock))
> >  		return 0;
> > +	if (sysfs_kdamond->contexts->nr != 1)
> > +		goto out;
> >  	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
> 
> Does this code cause starvation or incorrect statistics when multiple
> kdamonds are active?
> 
> It appears that damon_sysfs_next_update_jiffies is declared as a static
> global variable and used by this function to throttle updates:
> 
> static unsigned long damon_sysfs_next_update_jiffies;
> 
> static int damon_sysfs_repeat_call_fn(void *data)
> {
>     ...
>     if (time_before(jiffies, damon_sysfs_next_update_jiffies))
>         return 0;
>     damon_sysfs_next_update_jiffies = jiffies +
>         msecs_to_jiffies(sysfs_kdamond->refresh_ms);
>     ...
> }
> 
> If multiple kdamonds run concurrently, wouldn't they all share and
> overwrite this single global timestamp?
> 
> If one kdamond sets the timestamp to a future value, another kdamond's
> thread might incorrectly evaluate time_before() to true and skip its
> update, potentially leading to starvation and incorrect sysfs
> statistics for all but the winning kdamond.

I answered this in the previous version of this patch.  In short, good finding
but not a blocker of this patch, I will work on it.

> 
> >  	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
> >  	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
> > +out:
> >  	mutex_unlock(&damon_sysfs_lock);
> >  	return 0;
> >  }
> 
> Could there also be a memory leak of repeat_call_control in
> damon_sysfs_turn_damon_on() if the target kdamond exits early?
> 
> In damon_sysfs_turn_damon_on(), repeat_call_control is allocated:
> 
>     repeat_call_control = kmalloc_obj(*repeat_call_control);
> 
> If the kdamond thread encounters an error or has no work, it can exit
> and set ctx->kdamond = NULL before damon_call() is fully executed.
> 
> In this race window, if damon_call() detects that the context is
> inactive it calls damon_call_handle_inactive_ctx(). This removes the
> control from the list and returns -EINVAL, but it does not free the
> memory.
> 
> Because damon_sysfs_turn_damon_on() ignores the return value of
> damon_call(), does this result in a permanent leak of the memory
> allocated for repeat_call_control?

I answered this in the previous version of this patch.  In short, good finding
but not a blocker of this patch, I will work on it.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260321175427.86000-4-sj@kernel.org


Thanks,
SJ

[...]

