Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718ADC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 15:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108579000A8; Wed, 13 Aug 2025 11:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B968900088; Wed, 13 Aug 2025 11:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38709000A8; Wed, 13 Aug 2025 11:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1786900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:45:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F3C0117498
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:45:13 +0000 (UTC)
X-FDA: 83772158106.05.945C62C
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf03.hostedemail.com (Postfix) with ESMTP id B93BE2000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:45:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EprmuzHO;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755099912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsPDwhSTBJoReLg/9/YKJlevSdDByn1CpS92UikRLrs=;
	b=FCqlVIfaPrXnWiOGeTr1ptMztgmiYIDnf+cnzgS6ptKlD3KqqleeTYzW5q9JSoyBkt3q/P
	tAg6pD196nNuxO1LMo1OBWpi3/Zdixvnb+6YyEROVyS90Ieg1xbpgYnleMIyF/YB50MP6t
	wKxrOgywqTcbWw9bcBq3IWBgHHDr6Ms=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EprmuzHO;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755099912; a=rsa-sha256;
	cv=none;
	b=BkJjMD++ZxKl2TFPseOQbbCUtqMDV0i2NmtWjJ9Mb024w+QpV668y0oUCB0KQisG9la/6t
	kADPaz1f7GYeDOgQ03hubj+u7IzNaz7EMgAVb8oczLN6FQpEK1w1H7KEUWNa7iIe3+sbAp
	VzjzCha8OGWmHuFp8TtatHZalNEdChc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755099909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SsPDwhSTBJoReLg/9/YKJlevSdDByn1CpS92UikRLrs=;
	b=EprmuzHOFgXR6T/Un4d8FyvdxlSvFwXlSh+XmMWLyARs9/QurDnM9B2l748u+jSFn+YVu5
	cGeYlgobVLC9l02O58aMzTZc3Sc8TbqTVd31gv7iOf2l5w06YraQo1dkybNq4ipvKctMRC
	XXUItOdleZVof38aYxrbhvgEPK93qX8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org,  LKML <linux-kernel@vger.kernel.org>,  Peter
 Zijlstra <peterz@infradead.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Muchun Song <muchun.song@linux.dev>,  cgroups@vger.kernel.org,  Andrew
 Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Optimize exit to user space
In-Reply-To: <87tt2b6zgs.ffs@tglx> (Thomas Gleixner's message of "Wed, 13 Aug
	2025 16:57:55 +0200")
References: <87tt2b6zgs.ffs@tglx>
Date: Wed, 13 Aug 2025 08:45:02 -0700
Message-ID: <87ectfgr9d.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B93BE2000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 749ndb3zoqymha1hh3u1ggpizsufgynw
X-HE-Tag: 1755099911-50593
X-HE-Meta: U2FsdGVkX199sTaZJ38QVsb8Wg35XTdeFdu6+TlemdXD3XZl7pjLpM+6/5cagSPku1oQLrODWPkm+FChKN5Yos0lJNrlOHln3DXSY2uIMoOpfCfTD8/7o2kuxZofukV2d7Ow3yedYpl4om32jN9RmDGAAc8jFK5I8nbACUMmgWcKSjC1jCw6v96C2hnksrmSqRTjzh9V96ZO6oD7omc4QcA9yOYy0tRdlLGtOZGZ4FfR3GlZz7pjDugtRDhb8N7oy8Xw3usTFMjE2vs4z9gTY0PgU2HgZF23tj1yK/4kwUIxnd6xAAujcCalBaCX5HPvjRc9Y3dgYi7HjG+EoDLrgtRiXoUz8zyhhYPHBGVNQ5QAENnp4ImyvUZKhPxn53wcmmMgbZCWCHlhYQJoMVyooAIMymuA1mPKV5dzCtskxzPLSGhEhwGXQk3f4FQtND9/VD5wjdAxhJSgtkk6LeGuSFvwfrcztE1N141mp7wh0gb/7ky2hXoTIksRSzkrl4i5PylNx0Xd5j86GrBmNL7zqGIuIuAuUYGjSCWQQrl+5xtJrPodm3EdA5S1XQgUiZqg3MuQYpKsL0pWEsMd/MIcFNO1JO4iOEBX9fQErGuqqFeHbLPiih0Iw9JDWGqpkyuRAzMo8CR+s9W6Bft8zzoBy+9IfdFE4vQcY+icJi0kVPyw9pzyggWG6WNd2r0qAsLSoVuco4Owv4BgK9jr1tJ1ZTR0W9eOVLSvEsYuxCEmRZG8UqnTQoPWMvFvjJ1AvZoPlEiJs26He8qxAGupaaoYGXSdaDJSpTwGW1qKuc60dtOBLT0C6pCocLoXlAidRU6HyftyF+tyBrxPLMe1YWdlCrGYPEbYjFD+h5SEbC8ibAZfjtRZScxx6+0HqtQd1XcMX/fpKTgaYmd1kC/Prq2ZGbX9q6GG/kZsYgBnkYpeuZsd9ePMo0dVkGvFr1oc3Z6Tg0yz4JleiqWpbX3FKdV
 fPivFYy5
 KMEez3D64yE6PcGEzUtpu1JHKcrw35qAe5KDEzSWQp5nqOVz47EE5f2gwgzRZlCM7HT3MJ0YlVFH5RSxA8YLUm/S5f941TT1ukXwHRRP900BmnuNwbwq3K/qXoZ/b8PujM5z+/QO6Qutb3Kqf75HUcMKsdZa161uJCAlFrUMSh7RXzfCetze00i1KlZrBsrHbfWKBnAIz4dN4qQiSLwRwO3bAExmJ6+fcBpzl21BwJwSw1b6uuJaErFluXt5ncMLyoNYWeoWzRMbOFQ9Qv9xUdA54z8b8UGUwMEuL7aIZT65J7Rs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thomas Gleixner <tglx@linutronix.de> writes:

> memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user
> space. TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by
> other entities as well.
>
> This results in a unconditional mem_cgroup_handle_over_high() call for
> every invocation of resume_user_mode_work(), which is a pointless
> exercise as most of the time there is no reclaim work to do.
>
> Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised
> quite frequently and the empty calls show up in exit path profiling.
>
> Optimize this by doing a quick check of the reclaim condition before
> invoking it.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

