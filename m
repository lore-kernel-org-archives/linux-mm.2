Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1421093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9146B0427; Thu, 19 Mar 2026 22:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A2F6B0429; Thu, 19 Mar 2026 22:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17FD96B042B; Thu, 19 Mar 2026 22:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2986B0427
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:13:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A81E3140826
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:13:28 +0000 (UTC)
X-FDA: 84564819696.30.6B2CD25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E46C5120010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:13:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmkscYX9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=941DVfXRyG6EWPInEPIW2ckITwtu6cMJ2I3ZHfPDmUk=;
	b=HutRlAVb0VbX5sewNP+f6YF1a43lJxB3BIszhTd7accSAPgdlAFa+MtlW586EP7w+MqaV+
	tcjbyyDB7AaT4n8UPNvFHbdmPiwq3bm5C5sDZUGKF/dkkDYWCHp6lXSYUv0HTwVrDldAMF
	RVJLFgvX4NaVC20N83STWI7p7D2dnvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773972807; a=rsa-sha256;
	cv=none;
	b=f/sBp1OM3yBo5FrpOPeBZwk8YQFfXHcMjOuxiFv9rsEEetqcA4awgfXle6BTnZU/2AQqmB
	JBkPDbwT/wqSTg8cJzFHLMIF2RNWlyhMRoNlv3DGbnTDUAyjH4jRy/2MjLxFcW+FUouGDR
	XmujNOqLYV+K0/3t8qfiDQqjmg8Mp4k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RmkscYX9;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACC5C43A97;
	Fri, 20 Mar 2026 02:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C88C19424;
	Fri, 20 Mar 2026 02:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773972805;
	bh=Vi/b99yYNUlENEYL5J63cn44y04E5N4WpBICGa/lzpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmkscYX9tcdt9a/9lgS1OCThyHM6sMQCkE8vGxzHEHuQ9NPxv2EI+qz3aTWaBfm2V
	 m0UiWOB1C8wlCDXHOOM5nmEzgHacA2XbmWwLAFacE73Dq++Hwr5jzqUWWFDQJgFqLl
	 aAv6zBvbXXLs3ni1Bx2P5L6cFsULMzKFMAMYRF1yboKUwIi8FRfpA4ixk06fO5EOYC
	 pXaq1VzFDrp4D9gdNmBZaj04JgDUeTHKz/fyl6e7c4dmshw9xMhGJwbK0qyamnWbbo
	 gHG6YnQfnKPfwwP19oOKtUUIjLAlIxkgnryXdAVK9H1UcKKOCryRujH68VBjAyQo0p
	 OsH5ag1QGrPRg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/damon/sysfs: check contexts->nr before clear_schemes_tried_regions
Date: Thu, 19 Mar 2026 19:13:17 -0700
Message-ID: <20260320021318.1117-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319155742.186627-3-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E46C5120010
X-Stat-Signature: 4fjk965est6us3psd1zr467a1aedperp
X-Rspam-User: 
X-HE-Tag: 1773972806-218630
X-HE-Meta: U2FsdGVkX1+90trEI+FowXvbZZp0Iht8+aKx6CajfHMCXdRBER5hZJFg1IgL0OVwbI2jodaobAXG+O5fDG8fjI3Ca2dbGwEf+KzQnREnaU/mwWwHxYr/L+/u3alrSvvjs5c8WM0sIRlykBA2jRWUYFJ3yZi2C4gP2I8Pods0IE9Vvajfd6Y1J2tpi3pRPt13tKtWhXrDF0g8IPje06QNzgL9hPRlE2rAc0g/9LaZ98BvFFVCMzrkyjdhAmMaPOunhUvBpK5EDM+piRxpJ0yN+bIZNHEZkprTCJejL3aGYslE/Ix3phDcbPpfcZsJN9UfO8vmk9r+1lxAtCLWb8u90VSqxaWfq3NcXpIz+vtQdB604dHeT4Y2xA0M89NM1zAs5MVlT9bBXv+BfizjtDeSgi0p+cUKSoQdVa4ouHrKx0aXI+WNB+TVwTEginmDtEElCThhHFDQQ9+c8y5cWeFvEWb4j2jlPQvkykUDPC9Ixwc+TiALv0qsLJuMwy0TkvZ3P+AGeXhHTujt95mW/xiU1sMrj4yytajQr9jopJ/WL0uer44HwtMPhHOzutoG8Lp31lgP9USIAjwNQsLb30xkT02I8Y8NS0q8NLF8RQlsdYCdpxtV8XM+AQZwP5lzGfaHOh30extzLvNKTDvCpURd59Fvd4hVo8WG9HnA6YE/cM+ZZrI6OLyHXyKhjEDiLHCUtlrs+cISI2tZApDS/joz1LE3r7jc58uCtXyUh+jyI8b2D+oHjSiOVBp8/fSqmQ8khmSL9qEj4kev7NIA5k7ckQhFUXyILq32klD55GbjnQw7uQyLss1RomfStEpBOO6B/Gb3PkluSb+u1OJ7NaBPejGCCDTIhUzwBbFUX7BzkImfMIj4vIUOdrWwb/qTRMmJj3m958BHwSJQbbJnmz0/P8irKGmdr2E68u2q4le8cjcWl7/lnvNEQ+8+0zRvYTVKZHWS9I7TjcP/xdePbNm
 chweoJdu
 GVkaj58jW+8T64YBswBoQhK1czrkTCJaraNwBuqudeCbG4j+dpmHdvOwR1H3rVg971RgOyvnXg3O2nBQ+IzNd30hHtpd6zjZ3ASXPvdbivBmAXY8W8iCCm25KMHxFfyQYt0DrzifMhLukG+q88WQ76Y1J9qP7MpLB0pmlPKpVB6DkO0L0wY88JKsJbPrsfYNeZ+h/qyBrmm2RHsDT9zTAb7ak5VRr4Q79I3+A4mCblvdiMekRIU7Cqt68YoC13aJKLxvlaCOSKFwNjvoBSTIZuZomRLt1g/gCMcBH99uvEBwZCWXalyIB2LQ/xM4wh67Dg7dU1RyfAIZNH2kWkz5d/6GK9D/Tt9z3amR6TIOhZHQzbw2pf/C+SYTz4dvwxAbA75NC+6XFYdDdJ1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 15:57:40 +0000 Josh Law <objecting@objecting.org> wrote:

> The CLEAR_SCHEMES_TRIED_REGIONS command accesses contexts_arr[0]
> without verifying nr_contexts >= 1, causing a NULL pointer dereference
> when no context is configured. Add the missing check.

Nice catch, thank you!

Privileged users can trigger this using DAMON sysfs interface.  E.g.,

    # cd /sys/kernel/mm/damon/admin/kdamonds/
    # echo 1 > nr_kdamonds
    # echo clear_schemes_tried_regions > state
    killed
    # dmesg
    [...]
    [63541.377604] BUG: kernel NULL pointer dereference, address: 0000000000000000
    [...]

Privileged users can do anything even worse than this, but they might also do
this by a mistake.

So this deserves Fixes: and Cc stable.

>
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  mm/damon/sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index b573b9d60784..36ad2e8956c9 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1769,6 +1769,8 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS:
>               return damon_sysfs_update_schemes_tried_regions(kdamond, false);
>       case DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS:
> +             if (kdamond->contexts->nr != 1)
> +                     return -EINVAL;
>               return damon_sysfs_schemes_clear_regions(
>                       kdamond->contexts->contexts_arr[0]->schemes);
>       case DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS:
> --
> 2.34.1

So this patch looks good as an individual fix for the individual bug, but...

Sashiko commented.

# review url: https://sashiko.dev/#/patchset/20260319155742.186627-3-objecting@objecting.org

: Does this missing check also affect other manual commands?
:
: If a user writes UPDATE_SCHEMES_STATS, UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
: or UPDATE_TUNED_INTERVALS to the state file after setting nr_contexts
: to 0, damon_sysfs_handle_cmd() queues the corresponding callback via
: damon_sysfs_damon_call().
:
: When the kdamond thread executes the callback, it appears functions like
: damon_sysfs_upd_schemes_stats() access contexts_arr[0] without verifying
: contexts->nr:
:
: static int damon_sysfs_upd_schemes_stats(void *data)
: {
:         struct damon_sysfs_kdamond *kdamond = data;
:         struct damon_ctx *ctx = kdamond->damon_ctx;
:
:         damon_sysfs_schemes_update_stats(
:                         kdamond->contexts->contexts_arr[0]->schemes, ctx);
:         return 0;
: }
:
: Could this result in a similar NULL pointer dereference if these commands
: are triggered while no context is configured?

Sashiko is correct.  Privileged users can trigger the issues like below.

# damo start
# cd /sys/kernel/mm/damon/admin/kdamonds/0
# echo 0 > contexts/nr_contexts
# echo update_schemes_stats > state
# echo update_schemes_effective_quotas > state
# echo update_tuned_intervals > state

Not necessarily blocker of this patch, but seems all the issues are in a same
category.  The third patch of this series is also fixing one of the category
bugs.  How about fixing all at once by checking kdamond->contexts->nr at the
beginning of damon_sysfs_handle_cmd(), like below?

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2404,6 +2404,9 @@ static int damon_sysfs_update_schemes_tried_regions(
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
                struct damon_sysfs_kdamond *kdamond)
 {
+       if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+               return -EINVAL;
+
        switch (cmd) {
        case DAMON_SYSFS_CMD_ON:
                return damon_sysfs_turn_damon_on(kdamond);

If we pick this, Fixes: would be deserve to the oldest buggy commit that
introduced the first bug of this category.  It is indeed quite old.

Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Cc: <stable@vger.kernel.org> # 5.18.x


Thanks,
SJ

