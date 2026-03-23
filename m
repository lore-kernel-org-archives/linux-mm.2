Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 950C2FC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8712E6B0088; Mon, 23 Mar 2026 19:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821E56B0089; Mon, 23 Mar 2026 19:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7372C6B008A; Mon, 23 Mar 2026 19:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62A0C6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:45:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E126913C291
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:45:39 +0000 (UTC)
X-FDA: 84578962398.24.929E9AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2827D20008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:45:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wu4eNhCq;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774309538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKJUzeiKbrK8c1526HtAYeSkkTORbI+HX/o1csO4YBk=;
	b=aDTA402JtgZr1luNtyCUJHG98xxHpZPnBAzaVU7fXiF3y/xiXdPyjSWuWxaRH6SzJ+Z35l
	BHrEZhyJCNJvRzljtYuJXfZJ+7SaSu+SO/GJlx8auwbO+3M0waOwtNQkKDl5RhXTaFXxVG
	srezFd692FY7siBaq+IGL/59jnaTSwU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wu4eNhCq;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774309538; a=rsa-sha256;
	cv=none;
	b=7zhBuvXD4YOt5zMrwpa9ZYpxwrZcQnM5BnbXmsl4zT/b77khk4DQhVprae7z9xZQrHSi/s
	MYfOP2/XuN7xyYo4Z9EyyY+w+mE36sKxSAc05Z17tIEKn3OwrT0MQaFS19u7ql4PzYmuFO
	G8r2L1aTimp+UMxSVHB2pXlQufNb54c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 407FD437B8;
	Mon, 23 Mar 2026 23:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE097C4CEF7;
	Mon, 23 Mar 2026 23:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774309537;
	bh=wAhrSG+O4G13mI6rUqEHR2ZQ5aOUUhnwCEn157FgXIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wu4eNhCqey6dvy9Pj3dGKa7HfQmwK6p7XQuJ1/3jfIY2eB6q0lo6Oe91eMmiBOLYq
	 U+0pyryBL0yAlBxDmOGWnSVBpWUH+JPsKEqGJXL2Ig59wTGicUwqEAN0EVBoJBagkC
	 ecV0T+ZOQT07+KKeFUzahXS9DinIfzIfOhvQSdqJC+ZK5cZ5kjLl3EgtqaCBeham8i
	 bXMCTGTW5QI4qiwGdcV2zpcACP3Fsooy3Wu+62m8QyWyw47bDYvkdS07FupCEKLhN4
	 N1QNllBVwPDvxAuNv9tG56HQx795yz8TcwidO4GhteH7BEFL/BeK5pgH21Ty2HrNVs
	 bvrehnewkVTPg==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 0/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Mon, 23 Mar 2026 16:45:27 -0700
Message-ID: <20260323234529.85790-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15sBCyVgGKC5994-WhS31nahyT=8uitDPG_isZ7sp_g_w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2827D20008
X-Stat-Signature: 4c4z7jp6u61tf9kb5ok6abmtjzdjzg4k
X-Rspamd-Server: rspam06
X-HE-Tag: 1774309537-973772
X-HE-Meta: U2FsdGVkX1+v5voAPVxXzr2H4NFrrkOUXBlFMsicVvu2cHXfieG7SiHi0YE3HhYmV5saJpiRObGR1zDn+3Mii1fBcYRJHTuJ7eGy/re+6A1F9S/Pn4afzJccaXLseacmJ21CXV6HpJSkJkoTSu6OnhqKxWZk/xMZH6FjZUKWVrViMy6Hx0ns/R+pt0GI6mFmgcI1YVJCa8+qQNDEosgFpqYKdiRuT4pgiBIsUjdBEYeYtelSUoDMpPVRVdk7piIJwFoj87DMqGAScJSUYn2cplL3R9nhxphmWWWv4/Zda3qtiboIn35yu3HC7A80QqelcvtoQuQVAAvDfDGrppnq9Ckp0mj5Dh4zLo6szARYGnGEi/SZkOhcxmU7ieITYOEa+yG4NWx44kKHxFnxt+QXWNmY6NFB/NIfGPaRueFXEWFkTeY6UJYd+SpIOVoPe2+qeFy7PCKJjPmx58ss/4LDMqrKHMqfnvkR1vwnGWaq3svNFwkRhRGrEDLxFMvUGvk+ofr4vdCMchQ5XoTPouLMvG/jYosBqLe1BWyHuOJQ+XEmd2T+dBmn5aI31GCaw3jlhTASE00Pm448uCniRTRodIESOF9Ye8vnNeUAH3CvVRe5HkjLPZim7yRUpzjIRSn8j5jczDavL5wuqKyHPXtvxsWHFnudY7P02TwCXc04oqAnO33YMFrIDKmYR+uPz2laq/LYV1nwsejeM0U1uHTAW5ThF8LQTcrcK/nVeQUP8F+3E+VVq6SKNBvsDV/aG/YIPWwC7huNSDk9PqlKq0Vs3kIvzkOH1+eCbtE/6b8yoBNp/8Nh23xYfpv+xLH1Os8RtP0O0EsAjL6IT393mUX80y6vTpcp0Ty0oeVfm0V/JW1SvSiZfJvDd0laVSp51t0Y7vtOTwC9FxicUFzTHmllAEHVUw9d4SDssexrFxR8a4KXsvAVU7x8Xd2sem3Zftqvl1UzJfleMir9aJhBwu+
 udNwsUeH
 RIokkJucBvtm4S7Z0RkeeWEq58E6/1eLaxYO5dKyIIPerCs0XPqlwaLnQd9ZEUylQVZbKu9stVO+U7jFnhAetVfD6mKOgBUMxNyFm1a++tuGX9Z2dTAOc7xyLiwAFpjkjh9P47mRQ+Sbj4cL+rPss4AAdDwpGe5vwuu3Q0eoBzg7JpbHYqvp84H5xIdXQKDcdJemxY9dJUejeVQw1zSj9rLpgtbSNq/nQo4FaQ4X0mfWNvefLfHhKdCfSGh//pvVsEMlxG4+mfVQr9tRX1yC1HmegZI4t424l9IPH/ZXsx1oLa87xsC8dSC1/WefhdJiDBBb4yiTCQOBvKeLOJwkBKPsc/2cfFVjfRckQlK0zsM2m9L00Z0vFTB4nfjuUiBkTJ7fXGCgfkUMbf6ofpFRloxk5ST8nH6DBILbh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:23:49 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sat, Mar 21, 2026 at 9:57 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> > >
> > > Changes since v3:
> > > =================
> > >
> > > - The first two patches from v3 (goal_tuner initialization fix and
> > >   esz=0 quota bypass fix) are now in damon/next. This submission
> >
> > It is not also in mm-unstable :)

What I really wanted to say is, s/not/now/

> 
> Good to know. Will mention this in the next version.

I think Ravi understood what I really wanted to mean, though.

[...]
> Thank you! Will drop the RFC tag for v5.

Looking forward to!


Thanks,
SJ

[...]

