Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA1F10BA420
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217866B0093; Thu, 26 Mar 2026 23:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C75E6B00AB; Thu, 26 Mar 2026 23:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD696B00AC; Thu, 26 Mar 2026 23:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC6246B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:52:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99AEC13C484
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:52:54 +0000 (UTC)
X-FDA: 84590471868.10.B151EE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE532A000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:52:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJsUPkFX;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774583573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVoJucob4s1AHrGCPzLVXAsBEoWDwBIyp7hdI3gmdX8=;
	b=FjRGixmYH9kCMkZSut2koP8TUIMRlEfBMJUYqapZyJXb9/KUrbgQmz7wdpoXExebEBOCAY
	LA50k8HZ705FtVZrlSooLHxEOf6yA9oCgxhpvkUSPgNl3AXp0/J1rPBquiVsN9Ag2ns9fX
	Lvux28Ng2iBKlc2lSbkmXCM3r0Jjbrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774583573; a=rsa-sha256;
	cv=none;
	b=h3LW+GB236t/dIq/eUae9f53JzeMQP8iNFxDuJsdDwrr9THsM46ZRzLxfFOfIVanBxUVBv
	WwNiIrMltCSs8cFo/Ry+lKdokWfZ8SoYCDKYsLqhRWeq6gJznsDSS/hllhFq7RX+IrvfVJ
	1/VIjG5p2oz7gHNSSI7J+i9LSLQ28ak=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJsUPkFX;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44BEB60121;
	Fri, 27 Mar 2026 03:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFB9C19423;
	Fri, 27 Mar 2026 03:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774583572;
	bh=wVs7w3jdxXfOD1RlM9zy+o9MlvWJ3DIZG90l7SC8t+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJsUPkFXIjMKbMuUhuV0IJjXQQROMInRb+ewrGDGpmI+hCI2hHd9rGhhamPJARZ27
	 94NDDsc5EuO3P0vx9qChUGsmOYFYV+nKIjmS1HE0PE9ftLmzytBftW7Y0bT1GoNs9I
	 mhK/p7RNI07MVnXf1uqOfYI+crZvyN+A+r96K0dkWYoV2yoyW4egCEnVe/3LkVOBbz
	 UpZ1JmKQnTTf4EQH59hjTneOYBch3xEtE3d6LNWvADJy/xjRxxu1ikFi2K6sEeCix3
	 icyeF2lGJ1eSei4l6FLZEH+eKNVvdQyxSyFRZLBgL6pdOY1wSn56B9Bbr8fMYLVGG5
	 VysA9nC3aF7Rg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
Date: Thu, 26 Mar 2026 20:52:49 -0700
Message-ID: <20260327035250.67961-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327004952.58266-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE532A000E
X-Stat-Signature: goyhc8uw14tebtytq9kpkcpwzithjyfg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774583572-474798
X-HE-Meta: U2FsdGVkX1+wO3dZi23UiK1kQOdldycFGw8ldF7Vu+gzSYu3ku5FeJMGoh7GHezsd9XHCLMkY+K1V/AtCCa/TKVOIU1X9WuOFFQNsjekTelwLY9UxfvX77JeV/kiO9QaurOv0yidEmxX3+ngZGTz79ATjgUO37Tscu9nPQvUMBYDvfRQMIOdHQGsiUCxIpHE50U9JGzOjsH13JryI+VJ4vQldIpdMV5xHHanmF03Adm4TuUiO+d5vlHX9xOPK+AmPpMmABusLQ+Mqm2H84K205dCvmcL6V9IO4cE4ii/hFW+SuI6MJCSvIPZrtr2crk5bAGWhhVBMY0VPa0hdZkQzLZybPCHoOihQZXN15+5dyFPzUMw+flvkZCIALrz46oKyGFk9pKETJVjAfAs9yGe65PLz9L4UAqXlATKCRtV9LBI+XpIn0kSWKqsT612ja+mLOkIOzWBBtafoSecp5AdvElVVkkrv1QMQQOI++qs+SdZyAZGnHPQAQcsRr9Tp2Aj/CGgQwSW5lM2b23ib4nYytCXz3FOoj8X37dfInTirrc2SPD4hB7fTdnlEtATzCTgyyNrVxUqVI6wNMilmzWGd5oYbuVkvDXIZGeJrQzEDzLUGC3H1PyC0GSukle9Y3+lnhR4jS4O5Qy351GFWouqUp2FPhAYirvM0GSEpZQPtcjkTRL0PBIgKZ7/rCWIMwKrgeTn3xgJd4sZFIDSBi6qQ5PB3PqxP/Dx8kdCeCDP+rcs/HqC+CGaNv+LNiFh6wBPkI5UZ22If7hjS3vXs6zJ+7UEgbuK+V41g+streD4G7QRUcSpE8iu93kg7aPmaJgGAY7q+wbXQiwoTGqm+m7HEeoo5uZ+Hg0ymPBlKzsCOBV8OlxDWMrIC3JKiXv4TNrfBtaW/QuwNDLda5Y4neVtvSKggJ7u2jz9cgh+GvjhS5riwBUKZXUmBEJIA4h6qQXPkspbDCKeofOoK0OMwrx
 5+3LXF5Q
 GbAGQISFtC0J+zcteB7Xv+Hr+UCY1Fxr/5YZy5NknHC1GCcDZXRBAJ/HSUI9jQo5WYJBFQEsPwuKvT9uRGSwUPBe8Aie3nqGcOe2N/n6FzeF02MJEZBksBNkM22e+YLhsZvZeEqQu5XAEe3ozBvfSDg/DoI9xhPRROYG0ppxQWkFh4Rj9OqT7CGabMyfsQFJEoawmtvqGHfn9bYe6RWpPI8iPOxOtHlv+SespwT8gyuxyTsSr5u8Tf+d4VWhfDP4dfcn+d7U+n3XF+IS64HU34mQ+OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 17:49:51 -0700 SeongJae Park <sj@kernel.org> wrote:

> When kdamond_fn() main loop is finished, the function cancels all
> remaining damon_call() requests and unset the damon_ctx->kdamond so that
> API callers can show the context is terminated.  damon_call() adds the
> caller's request to the queue first.  After that, it shows if the
> kdamond of the damon_ctx is still running (damon_ctx->kdamond is set).
> Only if the kdamond is running, damon_call() starts waiting for the
> kdamond's handling of the newly added request.
> 
> The damon_call() requests registration and damon_ctx->kdamond unset are
> protected by different mutexes, though.  Hence, damon_call() could race
> with damon_ctx->kdamond unset, and result in deadlocks.
> 
> For example, let's suppose kdamond successfully finished the
> damon_call() requests cancelling.  Right after that, damon_call() is
> called for the context.  It registers the new request, and shows the
> context is still running, because damon_ctx->kdamond unset is not yet
> done.  Hence the damon_call() caller starts waiting for the handling of
> the request.  However, the kdamond is already on the termination steps,
> so it never handles the new request.  As a result, the damon_call()
> caller threads infinitely waits.
> 
> Fix this by introducing another damon_ctx field, namely
> call_controls_obsolete.  It is protected by the
> damon_ctx->call_controls_lock, which protects damon_call() registration.
> Initialize (unset) it in kdamond_init_ctx()

In this veersion, I updated the initialization to be done in kdamond_fn()
before the damon_started completion.  But I forgot updating the above sentence.
I will make the update in the next version.


Thanks,
SJ

[...]

