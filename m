Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5EBCD342C
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 04:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204816B0088; Thu,  7 May 2026 00:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5AD6B008A; Thu,  7 May 2026 00:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBCD6B008C; Thu,  7 May 2026 00:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2FB36B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 00:02:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 870688C2C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:02:49 +0000 (UTC)
X-FDA: 84739277658.13.631D47F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 13F252000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:02:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkN9OdPX;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778126567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EMPTtliGYiIOJXwj0Ukvict6NrnW4DB6HEwzixLUal8=;
	b=vwf0GUKVaQP0vYGyJ3hBJpikn5Emc1NS51t/8s6Gtnv+3ZP+o2jR4aiqHMs1qNDg70ofGu
	ots+q+36islmAq6C/bCoW5lqmflMrWigxGk9RJUNwBGC8JFc6IX3cKSTQRl/VC6g4zxTTE
	M4QP1g3HI2JoXZFyH+XPZWQTP5ERh2c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QkN9OdPX;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778126567; a=rsa-sha256;
	cv=none;
	b=58sbGsrtj4j6rf4fBlP/W5tHUToXzqI85/WSe2eTojm4lqQ+Pi717qwHonotDnkPEbVAnc
	PGE7N4R6DPi08x2xPFCcSykcArflh/2Ln7OW5RPzgVGbSsoDA3m0rekl9PjS1WqMlqyown
	kjvFIKQYib1Ns65vZU7rT/ro7ztE+OI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E679E43D21
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB84C2BCB9
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778126565;
	bh=EMPTtliGYiIOJXwj0Ukvict6NrnW4DB6HEwzixLUal8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QkN9OdPXwfKVntACgG+BYwaCitM4+EgpL1e9AmHXLjWFAmPgcP0mmWAa7J5aeg6Yx
	 ISATnb0fzCL/6PfOV9BASTNxxoQ5qGO/laPraS+q3Y2Hxkc0DCaldDj1hHWXA8DhaQ
	 bx3Pdbo7kHD4yfSvvldvjcdUDLiRH6MnYt8xGGcTJnCMJ21dzEP+uIuPG6tpqd2CrI
	 UxILGCtISfhEnIHBxiPQbwfDpmTUkXE5/X/sRiz9ZJNnlS6Jzwg8/5uN2lK64BOSjv
	 i8PS1Gg9+WdkP6Kk2x2i5GE/AcYUvPHXkFUtsd9998E4dR6w8wMl+JiMcJPTZxAOH1
	 sTo5xv3UKspuQ==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65c477a3278so353649d50.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 21:02:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8W3XdK9wCDiBPkKJi7DNzXhG9X4d4C+OEvCgvrOdVsWlrIZikf6rlQWBPmLmbc8ywQaV81vmS1zA==@kvack.org
X-Gm-Message-State: AOJu0YzRlGVaa+Qo2WMNYTlRhmKytuOaHwIJN8AN79AokgIal+iCBOrH
	x2xDL8772cawGpQvB6O3hRVLBq6cHaq3SuYW+ttXbfN6LKwxntQZVYm2z7P3E5cJ489WCmTAJo2
	xW8tcoUY72s1OfrycGo+na5XRwG9ZcbDT9NagmOaqeA==
X-Received: by 2002:a05:690e:15cf:b0:651:be50:af09 with SMTP id
 956f58d0204a3-65c79ad6df1mr4840979d50.3.1778126565140; Wed, 06 May 2026
 21:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <afQTXPLbNrB3NOqe@MiWiFi-R3L-srv> <20260506130919.2298807-1-kerayhuang@tencent.com>
In-Reply-To: <20260506130919.2298807-1-kerayhuang@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 7 May 2026 06:02:34 +0200
X-Gmail-Original-Message-ID: <CACePvbUy+rg9YuDAikGiV1_W5tV8XJnpdcZ8qy8zRqBY0x74aA@mail.gmail.com>
X-Gm-Features: AVHnY4ImmuIpWlSTuba7pb4BljLbehWoKxbO-1g-L0twIUveEjDcV5BucUwpE5g
Message-ID: <CACePvbUy+rg9YuDAikGiV1_W5tV8XJnpdcZ8qy8zRqBY0x74aA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swap: Add cond_resched() in swap_reclaim_full_clusters
 to prevent softlockup
To: Zijiang Huang <huangzjsmile@gmail.com>
Cc: baoquan.he@linux.dev, albinwyang@tencent.com, bhe@redhat.com, 
	flyingpeng@tencent.com, kasong@tencent.com, kerayhuang@tencent.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t6awd1jxtk6aa3t8cfnyst1orbwtodz8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13F252000B
X-Rspam-User: 
X-HE-Tag: 1778126566-206254
X-HE-Meta: U2FsdGVkX1+GlSZW8hh1+NgGjl0kYmiKlMwZASXYE3tJkXaOHW7XidOgg/lPvkN52kFFwRkLg/wr0cow5s5roIaTee7pH565RgrIav62kCJyYmri9EXhgP3FO72q1gL/C3nmuA7ZN0/XfeONnnJhQ+/opG3re4VFGQjWqIOqAW4SmgoQrzJO+dEetG8qjcnHLOzLkzekEy4cfeH0PVwcsLT7A+EvP71sYBDbe0H+zY5lgr3E5hkFKb2TgyuzUi/HeLx6uqMt9iFNAzLNPwfwZA8h1i8eqCdAvuzI2jrKCi2kWyGIao8uARGi8UedpYNhKY/jam5bLRGhoD8ymrAiX2ENlFVWM1mVYeZ+QhRK9LichDRY+Gso/GRzMz6Zhk+Wxh8eMU3PKANBOZGjP3wZGWLyVlMcTpz82y1R12jyMU1igWidA7qK1ffXOgI5X4jkO5QDBuN5c3xUCoXih2h/7OdVgJtWGk7TuTzB3oCm4ICPcFDLzqiw/I5+ep4rYDpy4UCyvRhpe5BKW8BqQZO4dZB8/tVMKEiFxBGNoUIXN/8RKg2i4fsFeNaKnADWvV6geNB2xh3k9yJJxJXzK3E5fs28efqgc4HUCVIWrrHErdvFcksyBu2X6SmkuphlttGk7L/VKMrCh5fM0BNmmsDT1MFElSnSzUS1AkZswCM256nKldIeSivoOGDiZcJudvLbLo6Y+Y/v6pWLxB2XEW5z4CheFZ52nDtYR5nTvIZo7Rg8Issmx1DbLfjWwg70kAAuBvyCM8HT1EAAg2ALdGhtLtosdNswINgEzivFkKj/gnskSKeIIQvmV8iXq5MN3P0YVZqoUpWDX4mxC3Ep/Us1tosXaZLffVD58JAwvjmAk+FEQA6YDorZeAoDU0JWOxeLYdnOQzWx2fhz3PkAkTafcM/7rwphUKu50HzmFN6JsQ04GqicfH1FkXbsJrbzQwurUPzI8JnYSm1VeeWA5Zb
 IIpKKRuI
 nv3iEnWxBjwjSy6bZiuDJ86n7SPaE3Tf08ucNpcL79HCfj7Ln8XYP0JE0zaH3teg79fWoHARHYc2m/9GmNgotr3ckg6086P7uo1KqwQqUrIYzIftdHpCyibnayQmjInLZ5mKFQ7zq7JqhROOY4RWq+f+BPsyl9P1P7fTI6JPcbICQ0jmDlDp9uH7seeBAh0p5y+WGJtEnHl9JGQkX8AyZEJkfnPBFRk2BRMy2Jgl4CcnvhzpyhAb0/+mFfagpujljZ2EXQZn0q7yNFPZ9lJjPgijUgixNAHTCv3qwV8bhgunJ4weQkcMyG8xByEcDeGaxviTvL0jSa6uc+Ap2pKfl+ECYV8PFPVtRGFEm5mAdPHDfQekgXFSeyJIy0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 4:56=E2=80=AFPM Zijiang Huang <huangzjsmile@gmail.co=
m> wrote:
>
> We hit a real softlockup in an internal stress test environment.
> The workload was LTP memory/swap stress on a large arm64 machine,
> with 320 CPUs, about 1TB memory and an 8.6GB swap device.
> The system was under heavy load and the swap device had a large
> number of full clusters. The softlockup was triggered during
> a stress test after about 3 days.
>
> So, add periodic cond_resched() calls during large full_clusters
> reclaim operations to prevent softlockup issues.
Thank you for reporting and fixing this issue.

Can you add that to the patch commit log? This background information
is very important for the reader why this change is needed.

Assume you will update the commit log.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

