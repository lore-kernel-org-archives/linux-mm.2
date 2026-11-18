Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06E1E606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o9/s13Wi
Received: by kanga.kvack.org (Postfix)
	id 29C5F6B05B2; Wed, 18 Nov 2026 01:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2272E6B05B3; Wed, 18 Nov 2026 01:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE446B05B4; Wed, 18 Nov 2026 01:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA1E6B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:02:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B582806B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:02:21 +0000 (UTC)
X-FDA: 85447194882.28.FC99239
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8E7EC40003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:02:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="o9/s13Wi";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794981739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaBm9JAGPw/iEA5LuoUSy3PZbBdZOK0pwal6A+I9F3k=;
	b=Pqe0g3Y4hPPp1hOE6V5lmKXJOwrH0FzsSDP7HgkNevmk8EMNCFaWY90GfvRnLnpBOC4EfO
	xFq+dbBB1OrtAQsOjUGePpWeqyvfoG8gjOrkAbT8DnK0gzAXU7xsz6Z//JrgKFjCSkdQ+s
	wO/laHxLEaVVGdxDnxkcq6ai+WrdbnQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="o9/s13Wi";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794981739;
	b=ociHNRBYRMOOHsZ6398cDINeNeOMcBaKpH9hevfGozQ2SjHX+zP+yHBIN+e/51oXM5kCnl
	+sVsurHaqvbNjiO1QfMXmpPUDiVXp9tn+qvf4xYqW9qchB5PkhL+BMY2dIgh/Km3er56Kd
	GO1N3EO7xF2rXF/mfU71MG3l0baJ51Y=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1a607a2e2bcso10311c88.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794981738; x=1795586538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LaBm9JAGPw/iEA5LuoUSy3PZbBdZOK0pwal6A+I9F3k=;
        b=o9/s13WivO/u9pr9opwhRntpYruu5GAG5SWm0VtAhi5JYVGP1UCFNbpt2+YhpGIgqz
         IoiTr5fvXaLunyK5nG0IXYgs/VoDff2Jl0lW5Z+3te7oBYvceAXtPD0sNyoMC6UIfhvY
         WW4SogT2vyPEn7cGiq4s8OCzEJ7820KPDNCFXtsAKm85rI7WE+3Gkpa9LopGGSiZyEA/
         Iw/MiBzm+Elm4OAfndftScb+YPphMCp2/QeDPDUQvCBodhC9q1bcT7B18biNa3j2QpBm
         iPoLQEgy2VqDtUc752kHCwNSMcqS1iDQGm5nj0o1WHBPOHBbuljzVXCU0lrkZTANrSM1
         IWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794981738; x=1795586538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LaBm9JAGPw/iEA5LuoUSy3PZbBdZOK0pwal6A+I9F3k=;
        b=cgdGbTt9DmIi1yMOxAF4Uf0qoJT3x4nN7r+mgpVn1ZqQ3Rc+7d5PAdTIqXssubxoWY
         mUyVOm+73aWv/w7hDivKvmKwaxIBRitTrOmPuMqxvz0iSCEbUZlSZcBCjbiM8qMjoD9R
         cVESyuhoBXd46t+s232b5uJzBGSKgh7dcaCJGa0quZn1l99wzUyWGNq9KfD9VnFskqjV
         6buYKzbQQ2uOWrlWBzSOg/xogtUDn8uCxjQrGAvO+bg/kKKL/iy6iDy3VwG/COCUKE/y
         8Y2VnrSZLBr14Wlm+72aeI0JPHD/HK6iMTWqZAFeZOg+CI3nbeU+oMyNfehxrdxiPT0d
         a4ng==
X-Forwarded-Encrypted: i=1; AL+hErGYTRuxiHs/cG/PmZI2WnL7ZEUNKJ88wi2oAuaXc9CId5EpsqfWaPFBlGgTU8OMH/84bz27DnZIbw==@kvack.org
X-Gm-Message-State: APuU4Z/1H8w4u2jZCF4BAwuuwv5E2SUJutct7hPQfgAU9G5EdqcdqsY1
	G6PW7wsVPvhbzaL+kUUmG4wbA0PhzUYLopr9K9d2ZVi7PINIK2O6qUtq
X-Gm-Gg: AYBFou2htAC1lLltXMCycxSg2vbHo3kT/eC8ev+Pt82Ol5uiSkJr+crwK0u1eXKTTXn
	kQpm1X5kidrKTyve/01i+CePrZsYn/0dGwnhD6zoyahU7BP4+6giRNBnlrGm22QHRHvtK4P6TLZ
	Npv0GkyXLjoZCh7hv2rlUcmeJYwEZCK0Jqo53bD20KArtoElsEQksaEFuZpklx3jISHM0yv7lAz
	2M8O6gyf6cfeuJ4qF5plwfO9a2eApB8MyeyLQ1l+XY5I9lMuCGZvLenUpvE0RQEGAvJtFcN1/+X
	o1FKlgw4LTKdgu6BTxCsPvt4jRGtHDjphopTim2hQ+VfSnggBQIEF6QmJytsRq5OQ2+3sHmSARl
	xfhae/N7EwZRRZV6mn6MKc6ufxSISii1acAuiNc2iSSqhExatr7UfSDY++z/XIKuWdSd80o0u8C
	lwMh9QDVy+BKyadfw90tdv5XDOXegRCiL8xa9VoV/+OLfw3LuKPYbxrmr9KrMQw4PtIXHeGWmq6
	XSvtZIktY3kUDLFuNqMKuhVPXXXE8AolawiMpM0nb48GRhen49CUeXXyIOYuM+GPyDGMJSsWUSj
	Cj289HN+zkSpo3WtDj7D4FyKYDTh8z/vZCNcoCIvvmxGXCiRQbV8
X-Received: by 2002:a05:7022:f202:b0:16b:4f52:a08 with SMTP id a92af1059eb24-1b543a14345mr3293891c88.0.1794981738026;
        Tue, 17 Nov 2026 22:02:18 -0800 (PST)
Received: from localhost.localdomain ([27.59.52.137])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447f4e19sm5317147c88.13.2026.11.17.22.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 22:02:17 -0800 (PST)
From: Sailesh-003 <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: add test for damon_call() with repeat control
Date: Wed, 18 Nov 2026 11:32:06 +0530
Message-Id: <20261118060206.29439-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118014632.95656-1-sj@kernel.org>
References: <20261118014632.95656-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdou5w5stmcnbcdtwnai795widxzspnf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E7EC40003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794981739-730151
X-HE-Meta: U2FsdGVkX1/8jojd6PYyHlJys1ARUPjv9ZctxDN9WHvOMdtr1gt7Hi8PL+GBNG7cDMGWZ4/IS8jmKN94OY7KfiUDvHNPzJaWTCcuvuZnemFgyp9bzR4j1mDf7d8AL/hc5qHo3xlVg4rrUfOBNu8MuryZGd5HmsI28wYTEYV8VhaXDYIKqmqhP3RPDQrg2iMTw+5Lsdew5/Qx4pBog0LIjKx1oMk8hc5j8WoeeNJY+ErJMRdZ0CauvGZoefV4zSfwcP7fsRXs6ajcojXavP4/aCq1FOpPvaL8IL0HATGpUeTyIkxOLG4m9jWpMYbeOlZwEk3FBZSeIHlxe7kYBClyTZVAXfU4HG6l2CBq5lbj+CauDTZ1UgBT0huz3xIWxOqFPd7c2+JdjZXPGamph9T0ntZ1ZSmPoyigJ5Co9yCAbwG4jq0DrV+CsrWIXzigrT9sRi7l0oERgPZ8ua8r1sknSiYUy24krjKRS6thztGEBk5cl612/U9YGN6dWbSF0GiKVW0MJuT+iVW01gM+WQOclw9a8gosQXBS50+tau6+kFiTidv0ymNPYP+qkGtTXiKgrcAcw4bdxiq5i75UsDBahhAlx9wMn7eXWeGvE72DrkY9XJ1WZg4AOBmRj1gZtz8niYdwcdHcI9JkOLFsrR2K9MjxbCY3/O9Zl8GOzZtEKyOBfsgTjpZBIESH8IqaCtlpEtOhPvSw9xR/j/cj5jg1cupVWn0TKYkIaypSK+/k/5SEbW0CIqgJjEAVkQrjTxkBwIOkgihnBY5PgZVTwsGS1VpLPfDncjznPH4qxQedbCK7baylmXegGbNBUat2r7XRcCMBhtslJNyhnzZSqGQ+Y8FTm6YHpBlL7ZBKkRXn0a+OkvR4PRP4kMC2pkedQkNHmf2YAGhnNa+JxjN6Lum8hfxFlQhvfTLI+yxF6YffypOh9GI6cCcCuhzT3Z3LhXYTeN6MzJjQ82TuRDhfGrN
 URsSviAz
 Ua7Ep7lnP4l3czcG5k3cYEGS8HojWqW+ThMQTy28HeW91b6Vc2Rtvsfe2LF8gmK98z64jl1LBiTPiOwT+uJy1MuLayva91J19DlGn5plD6ymtwuVWRyo3cZ36KbqyFXRC8tdlirl5uQhLFYmSHL71YQpRSMGW2ETpOIIikmy+fiy1EBLLu/SH+E3qY6v9oUarnSsGwhxxE8/9z/t2qZUYVHQAD5ckAiyTFEsUl+Mwl9uXVohvz0R2qc3mcjS8TQbt+Q9qIvNGfFyIquIkC42AfXQ2mcw0mWeVsdFFRokLLemQQ1598V/VLME95CbjQB6cz36HNUOzy6e/ll8HfBdBbKozQoOSg4TdZcXxnaqRzxHm0m77tpo22jPTAXBCo/K9acb5mVR5kKIfZTXtyEoIFQa3vwDfGtgNFb/F3mAaSWlT2fNqtV09rSg8OD8FEH6jn/P2CRyPTO4lRZPu7f1K6Smv01215VJWGUC0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>

On Wed, 18 Nov 2026 SJ Park <sj@kernel.org> wrote:

> I think the above last two expects are somewhat too much implementation detail.
> I don't think we are promising those list status.  I'd prefer dropping those.

Agreed, dropping both list assertions.

> Can anything leak or corrupted if we don't call list_del() here?

No.  The control is stack-allocated and damon_destroy_ctx() does not
touch call_controls, so nothing is leaked or accessed afterwards.  Will
drop the list_del().

> Could we merge the above two tests into one, say, damon_test_call()?

Will merge them into damon_test_call() and send v2 as a single patch.

> Apparently this patch was meant to be sent as a part of a series with another
> patch [1] but individually sent by a setup failure.  As a result, this patch is
> not reviewed by Sashiko.  Could you please repost as the series?

Sorry for the mess.  Since the two tests will be merged, v2 will be a
single patch, so Sashiko will review it.


Thanks,
Sailesh

