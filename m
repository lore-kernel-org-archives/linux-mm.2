Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9118DC982CF
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 02:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A6756B008A; Wed, 16 Sep 2026 22:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557166B008C; Wed, 16 Sep 2026 22:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BA36B0092; Wed, 16 Sep 2026 22:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 239FE6B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:56:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2A461601EA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:56:30 +0000 (UTC)
X-FDA: 85221740940.21.5772477
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8B9E3C0005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:56:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNlthdPi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789613789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXjNvfbfvMQLStGSco8GHavmkRqXpU9JCAETdbNf2BA=;
	b=lfocXeBsWgRRAOesMpCdI47d2QP0BW0sKq/oo/cBUBPqBzDd6w1//Y7c0kBCs0ClT9rwZc
	mzjzYMim8h9EXISOgtDcTIFKM1SQQ2zcwH6ID2WLTG/nfQaxVmmICX31OeRm8L9J80HEPk
	prrkeH9HoR7Hj4QrWyrCZfWqt68gnxU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789613789;
	b=UOW1dSKR/iglTCVvFDs6JH07/XnYPeyzDd7idnmdibju3DzOHBGzT/TOM1FUAy8OD/IiVK
	XpV2TsY5fLZhB1mOr4bD8h2nP7J0MExHWiQ6bo8li0/wntUVRD3dQn0FjXtLfO4hLGPfPJ
	B/JRI5FVvXCHkKk+VaP1tsTOdLDXPEs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNlthdPi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FhTMxEbI+Hm7knFbU8ZHAQCuFqyobe/xTUTkOpgFmSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789613787; v=1; x=1790218587;
 b=pNlthdPiVvdHJYAlRecZ7TL1llP87xUxqNpIkLSE+6eepTAZvDqLnq5PKlZkTH6LZcF1SM3I
 ChrLTF/oD/6ccEwe4oUKZD50ZM20VZEvybBS/OrRTQEy+QmylvyGM/vNhu0rztvE5hxXeM+IkVd
 LGJjp5XtTQ1XxOh4Kx8qUWqI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id af011a6eef206229;
	Thu, 17 Sep 2026 02:56:26 +0000
X-Mizu-Trace-ID: af011a6eef206229
X-Migadu-Flow: FLOW_OUT
Date: Thu, 17 Sep 2026 10:56:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ridong Chen <chenridong@xiaomi.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning,
 again
Message-ID: <aqtW1iW9WLJfl7hp@fedora>
References: <20260916083456.4136132-1-arnd@kernel.org>
 <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
 <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B9E3C0005
X-Stat-Signature: smcau9urnpm4uub83s3fkrux6osuww3h
X-HE-Tag: 1789613788-344628
X-HE-Meta: U2FsdGVkX19RnbUPoCsoacb9ZXh+a/hyY1Jjl794QEzLLj5444aSxSOUjSNrTFi8PSEZ0BrSbooJ85X6Oi1V7PaEfGubzX459dmqmxL2xA3EoJkz58OEElEHdx4Ib0G9L+ouBrVcRdejHWcivoA7JT8Q1tTe3Zl8gKV7hOz62yIC0fco0JxWNHYk2lpkuvA5Jw+MNX6jLBAKG+O+4hWTDi4JLkJt+tJhHktu3TgQt9E8tQU2s613k2bTPdNnJz/VjD8UsRkwVdC9d7pemxU+MFD/DeIK2nOhHjf5knFQRvA995yW/FwY15BoVVDobLhT13kp03WzoHJCqA3Y2Rmz8asJ+vW1ci/jkFWdJlpE0G/e8QoNymQa+MKyIaxLxQ1pfUpT1kqOcENqT4kFfZO4z+K6npqiQKdc3xOnaUjqooPRJnmS0kTO1OyVsCxx54d0JA7XybWXTWYMguLGFSVisqQ1ijbYDLkYlfzx40g6emoP+eVEohND9ncr/WdcjfMOozIiPq6k3+9g+LxEdHAY4POKY/suxhc8lfgapZNzKERwo96T+FpYoIm2gLjeOcis+OoCyw2Pu0wN1x65U4aaEp/7mjwhdd2sx0Ldr1EOZSnSGQT8h7bi6X5Tfcu6ifO8p9FUYzI920yqMTevLX+0MS1xf+Nv/Az2rmev3G33qiM8A8wrHSPR+cckaL5pHoG1QVyh49GlZjx5n1SwV8dMLJ8fAeCnYqPV+1H5faTOReurcj48v1n9cK1wf9HAl+F45UFBwgjmswBt86s1hnMxM34gG/uBAVsnVXXsaehQOxFOEIPt0GhPRkJcOt+Le5ZleQD745QYACZjW9vwMxXhPBe1gaeISx/TtrRBgx2cRgaZKvNDGqnMfC9nv/otQmBT8vXdnlRhmVVQF/Cl+QxXA0qQyvshXQwfYRo90X+eK6DU8xllP3lLpHK342knzFPDHCADjXqy6mwcq1IqAA5
 Eps39j/k
 HNIwddoFHtxc4nYfen3c76Q+7hHndzymSLksn7uKSeyH21hGwJsUNZaDMLIKimisLYbQuntTR3Pkc9BSyeeOopvjRn9YoAn5zky8ataEt8WDkRa+xEPink91K67Ya+Lm15BFSeH7puFlKwiZnj2Z11p38zsCEzME3o2vRjI6H7ZOGJON21i6fiaGkJnVhujc8FTUr4AJ9xgMgdMeI8EjAAh1SwfT23znlFS3jN1GPmqgMJnNGEEj+BuwTwRlt07Z2vdIhiaRGcbTdOiHGpxbFEt9my0VHskWBBcO9z/SPhcKl0ixcdvs9rqN9IAscRYKTkXPkDNnAN50PctXEbhsEnoqZ//DOwLp8CAqX8GueleVzKZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/16/26 at 04:30pm, Andrew Morton wrote:
> On Wed, 16 Sep 2026 16:28:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > >
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3274,8 +3274,10 @@ struct ctrl_pos {
> > >  	int gain;
> > >  };
> > >  
> > > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> > > -			  int tier_max, int gain, struct ctrl_pos *pos)
> > > +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
> > > +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
> > > +				  int tier_min, int tier_max, int gain,
> > > +				  struct ctrl_pos *pos)
> > >  {
> > >  	int i;
> > >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > 
> > Current code has changed here somewhat, but I expect the error is still
> > there.  I fixed that "uninitizled" while in there.  Altered patch is
> > below.
> 
> 
> Then the build blew up in unexpected ways.  gcc-15.2.0.
> 
> The failure looks like a legit min() signedness thing which has been
> there quite a while.  I'm thinking that __noipa surfaced this for some
> reason?
> 
>   CC      mm/vmscan.o
> In file included from <command-line>:
> mm/vmscan.c: In function 'read_ctrl_pos':
> ././include/linux/compiler_types.h:702:45: error: call to '__compiletime_assert_798' declared with attribute error: min(tier, 4U - 1) signedness error
>   702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |                                             ^
> 
> I'll queue a fix to switch this to min_t (yuck) for now.  It would of
> course be better to use more appropriate types in this code.  Unless
> tiers can be negative!

I drafted one to change 'tier' as 'unsigned int'. While in mm-new this
issue has gone away because Kairui's patch change 'tier' to 'tier_min'
and 'tier_max' and remove min().

commit b447513eee2f ("mm/mglru: use explicit tier range in read_ctrl_pos()")

I personally think your one line change is better for backporting to
stable tree.

From: Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH] mm/vmscan: fix min() signedness mismatch in read_ctrl_pos()

read_ctrl_pos() declares 'tier' as int, but MAX_NR_TIERS is 4U, so
min(tier, MAX_NR_TIERS - 1) compares int with unsigned int and min()
reports a signedness error:

  error: min(tier, 4U - 1) signedness error

'tier' is never negative, it is a tier index or MAX_NR_TIERS to mean
all tiers. Make it unsigned int, then min() compares two unsigned
values and no min_t() needed.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..1844d92a6732 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3195,10 +3195,10 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+static void read_ctrl_pos(struct lruvec *lruvec, int type, unsigned int tier,
+			  int gain, struct ctrl_pos *pos)
 {
-	int i;
+	unsigned int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
@@ -4801,7 +4801,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
-	int tier;
+	unsigned int tier;
 	struct ctrl_pos sp, pv = {};
 
 	/*

