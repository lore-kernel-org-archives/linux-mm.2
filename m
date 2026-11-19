Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7628606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 01:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogTMimAN
Received: by kanga.kvack.org (Postfix)
	id 686496B065B; Wed, 18 Nov 2026 20:43:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635656B065C; Wed, 18 Nov 2026 20:43:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523416B065D; Wed, 18 Nov 2026 20:43:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21F676B065B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:43:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C466C07C4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:43:20 +0000 (UTC)
X-FDA: 85450170960.19.6DBC86A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C81DD140014
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:43:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogTMimAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795052580;
	b=LoiLkbm5CyF7QecXUEOAfZFrU1nbM+ZsiDBx4RToZmXOcnXHq9aj4bDaNzlqMPCIJ/lbXn
	Btc4cpDyJoTH2E9Er2hKukaqzsB/tI+Poyzb1PL4aStJy2suNWobyBlDHoPwxL3iBb0W+J
	Z1Y9EOXFZiNCltsk/qMyTHVWN46NkZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795052580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNFMtGegQbyx2nsp7e9y5ycgaKcKYuwzocjWkIqM9lc=;
	b=TOyIT6g7XbpuLF4XAp5HpuZCnxgI8TNbi73odq4dfkMLD47es3h50Huoduat9TJasaW7rj
	SxKAD5DXJ+ydG5XHj6Am7dvRkVpN8iWGfMfPQEeO8XYzUHlAT3tNZezz9j526cKBUEwUfJ
	v2y3Ep4ekf/lTbNINOcEGqEPIqJEXNc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ogTMimAN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0122464643;
	Thu, 19 Nov 2026 01:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FC1F000C9;
	Thu, 19 Nov 2026 01:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795052579;
	bh=uNFMtGegQbyx2nsp7e9y5ycgaKcKYuwzocjWkIqM9lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogTMimANOmUqTobBj3k5z8Ybv4Sh/Xzn9W2Y46iWRHZAq8ZB8I05tso9X74qShZT6
	 C0JLDe2ZFWfOypRJIf1IBHloNLxCqdjWfad7+raqfL051GS39hofagtpNq07QEUzFD
	 0TTduLSQhFZ9HYYyLbRcglWv7hjStpr+TpmPl54iPaOgU4lfQzL5aYOZqrQwGy8icy
	 Uv6UQPQV7ri40GIlYw/8UiVUQn3YHyBvNsnct20EQxRsGxjZ8R6lPRskGd836tWDB3
	 NWOmghVmQMAqI8eKNcurb4kPqlL/lnk86fcWwOeMeGUuFHCm26LaDV9vc6Oji563JJ
	 wMbx9qswO7urw==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Wed, 18 Nov 2026 17:42:46 -0800
Message-ID: <20261119014247.119946-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118235012.14859-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C81DD140014
X-Stat-Signature: scgu1snmiimodgjrpcz9appt5u11ydbc
X-HE-Tag: 1795052580-820298
X-HE-Meta: U2FsdGVkX1+EXfZNSzFfAifgeuTIF78JBm6IVWE4VWq4ooni++tsU+ztBTiqI81usMq+KMwtH1Lp+0XuZoi12zqsRL58Ba+W5wjiQyDfW1LNKs4mwx51m0/4gsxqVNqDAkVEKF/8jWvYyxC9hgmUxUqKECznX1T1w+G9nRoI2RSuaF4ljEvtyGke45wP/zw67FefLZB7R4bFy4lDlncSXlYcYzlr6IXk3yPYz2CDxFBvkuc/BaOV7UtBE4ju6K4AJaN6WkzfpAZBmDSsFVRJJehJSGizVNc7/MOHf2hBGa2+pkKG4foqiJzgFVjgK7H0FXXw6gxFduBL6rzOqwfQtxAm3XdsklXix+9n8LGbhPFz3agucJyHlLI86ONOLt/l2NjT6npOs40LMd52lqk9+zR2X+Phi9HUS8J91cefqruh5HYRv9sb5/2y31mqiljBTUX4fZ5Wx+/4Nm/yoxAUnA0qmtbg5Bg+4ExyRYOB4XFZVnwNFS7AVWPzOVBWl8AJIyBc9kqxrgHjZ1O9p4PLQwCqlzdqfUkulRTRB+qPbizwkrdy5Cts08tt4WHXYf5G8ELe1l0L4BXjrKb4xJblij3WUP1gLB7BfZh4LAS2kL1I4/Af/wacP6RhI4UKCyVmq/Yo6wyTv4yi6H0eRPAHV7sw9GXBK+mtScR06yIx88uFhLh6oq9oGrdRUzF+XU9XEpKcIvfuHaMRnbH+2KOAPu1uxkXDuNM10mbowg2hzPWjYSls3q2V9QpECEMZ+cxAZun9+si9+/e05FqV80Q57/VieoRwPvIdlaUmU8hLzGr5aDsPBvvXOkg02EMtH0mqrEyMNuE3yRtQRVLl0/jA0d0/xhdVX5C7vo4Hh+k7TZaSJf5rtpsxVTH3hphv96SlaEQBYtk6/Bn/c58vDlx2nlaCI2Gc1jgO093fH9WzgXq2dfGXGbq2NIeVQN7+MOf2QCNIIGMxwpacOYAksiB
 zIKo7JEb
 2evfGBVaKXV+lCiTIL3QSk0V743LJWrUyo6OEJEVu2C2GnOX9v5gl8N8qrRiYjlJDxm2w0w9WBBwbmnOqRcdOUnEJBtyQvxhs2ZzINL/t7aQIHzgu+XzAbdAKgasdlZ3ViyZmPKBthcKgHoJKgjjgZsqfh2tZGhnVf+50z+f9855eBuU7V3FlY6QeqE0amWtKDyTLF/810LxzyIzCIYSdMEsNX7jl4om6tVRbA9hUuZBeHo2a+5PSjd7RqmGC6PyXE6DwRNq8Dc7Hgb24zOeTOOdjhbN+bYzjfhcubgAxmAbHezk8dV+yM3Wo/RPILolQVSkzd4auBXlnHMjWk7xJld8Di8oEEIrQWkNyOgDBKNKJyKaGADpOYFuIbO/5rQzs3jG9cbz8T/qIXbJZ9eHZ8xnSGM2F3oTWWwrBhHFYkC8IJ+FdatfUJF44XVBuuMwW33efhOfN3Ml8COo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Yifan,

On Wed, 18 Nov 2026 15:50:12 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> kdamond_wait_activation() cancels damos_walk() requests while all
> schemes are deactivated by their watermarks.  But it returns without
> waiting when the watermarks check interval of a deactivated scheme is
> zero, which is the default of the DAMON sysfs interface.  The kdamond
> main loop then runs with all schemes deactivated.
> 
> In that state, kdamond_apply_schemes() finds no scheme to apply and
> returns before it calls damos_walk_complete().  The walk request is
> neither completed nor cancelled, so damos_walk() waits until the
> watermarks activate a scheme again, possibly forever.
> 
> For example, with a scheme that has the free_mem_rate metric, zero
> interval_us and a high watermark below the current free memory rate,
> writing update_schemes_tried_regions to the kdamond state file never
> returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
> other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.

Thank you for finding and sharing the issue.

> 
> Do not skip the deactivated schemes when deciding whether
> kdamond_apply_schemes() has something to do.  damon_do_apply_schemes()
> still skips them, so no action is applied, and the walk is completed
> with no region for them, as it already is when another scheme is
> activated.
> 
> Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
> Cc: <stable@vger.kernel.org> # 6.14.x
> Signed-off-by: Yifan Feng <evanfengff@gmail.com>
> ---
> QEMU: the write hangs before, returns after; kunit and 13 selftests pass on both (2 need drgn, not run).
> Found and written with the help of an AI coding assistant.
> 
>  mm/damon/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b8678a53b0a9..12578fc3280c 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3498,11 +3498,11 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
>  		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
>  			continue;
>  
> +		has_schemes_to_apply = true;
> +
>  		if (!s->wmarks.activated)
>  			continue;
>  
> -		has_schemes_to_apply = true;
> -
>  		damos_adjust_quota(c, s);
>  	}

But, this could make has_schemes_to_apply has false positive.  How about
calling damos_Walk_cancel() when has_schemes_to_apply is false, like below?

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3849,8 +3849,10 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
                damos_adjust_quota(c, s);
        }

-       if (!has_schemes_to_apply)
+       if (!has_schemes_to_apply) {
+               damos_walk_cancel(c);
                return;
+       }

        max_region_sz = damon_region_sz_limit(c);
        mutex_lock(&c->walk_control_lock);
'''


Thanks,
SJ

[...]

