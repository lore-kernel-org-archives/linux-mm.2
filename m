Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C8DC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2286B0095; Wed, 16 Sep 2026 19:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3236B0096; Wed, 16 Sep 2026 19:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA8B6B0098; Wed, 16 Sep 2026 19:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6954E6B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:30:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B99DD1601C6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:30:47 +0000 (UTC)
X-FDA: 85221222534.23.FDA8B5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3CD640004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:30:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xQlhKezl;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hL/QslE9kXpw9D0DG8KnR2S2Wv56IDU1UfLhKDJBSo=;
	b=wYOVBjpk3YA0x8lQaT2ZtS0mudn2njB3+8TwAAmPu68I246k7GukvucrMBL3a2BhmgpLwB
	m/H8YfZrM44kuY0mJDHZqrxDwSyfKjsxSC2ka/27fOKab/cV7na5VjNebwdQsA5DEAruM9
	32yub5UWgl4U2z700wAbK1xbKBbtrZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601446;
	b=x838GnwgfYWDMMPv5a8o9EJS2sywylQCEhBT1+rXLRdDwen8iyYkQ2bPjxnU66QLnPcBCU
	GidpGuOdDUFOoV5+5GMR+RpVOs8nKDdylTUarLJVwJO6eKypHAVtM8ws8ADD8Cw34v4+ia
	/kUc14j9Y6ajPje7y8P6KPFFheAPr3w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xQlhKezl;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AA82601FD;
	Wed, 16 Sep 2026 23:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981681F000FF;
	Wed, 16 Sep 2026 23:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789601445;
	bh=1hL/QslE9kXpw9D0DG8KnR2S2Wv56IDU1UfLhKDJBSo=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=xQlhKezlmUcqndEOYoCt0jz+DZelOEfUckPTIkvJoqSoDiwI/IqpwRQ8W3nUE0eW8
	 0W82MpO7GA99H+VvobfbK3KYtK36x3SrmPu6hfG9OhUpoutjsq01rqiLQ3C+PTVkbj
	 GXpglFoS2igpNM8j+TJl3m/Wn+5ny/ZpiQ4xQC/4=
Date: Wed, 16 Sep 2026 16:30:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Michal
 Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Kairui Song
 <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ridong Chen <chenridong@xiaomi.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized
 warning, again
Message-Id: <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
In-Reply-To: <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
	<20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3CD640004
X-Stat-Signature: th8angm6q6ku8mzjqfn9hyfamiak141e
X-Rspam-User: 
X-HE-Tag: 1789601445-957136
X-HE-Meta: U2FsdGVkX1873jCj+luMONR6H4uC4gpbXz2aybDEuKFytMI6QoDi15xpmDKm6qmjeICLZmxUq+QW4kP3uTxDYH51qEHIbFfmSMx2Gr9nYl4A8L1kBSJqVeoNzPqH7ScKQ+kZKSf+gMF/ffayPS56mHBc/yLDNqzt05y2qAdSmesJOXsaD0b/UlEAXvlDcAX9lHHTKP1VIsPY0IRM0+OMrdRdF55cGXXr3QcJNdfbmUQW2RC6z98p3A2Dx0SAlElU8vveSt/M/P+v7wm0iBjCbjnvgj995IeDZKa4GW7QQfEMYL89VF4XLNG7bXYgiPYGvo2XvTo91rdpOUMAd2/PZ5ILSGdfEca2ofaK/sZDG8OZsJsJXAoE+Bd/Mpd5MToLQAyZpTtz8d+YG1v5lMUGy4XvFNYthJsqiNUKWgq//N08VSDxd/Vzy58t2GozvI6C+P4TJ+g1z1Yp1McEClsv8Pud/ABEiaFutRzicIDa0gXdFYkInPgxvKuuX2aP6q09H5hmZeF8VAlj8gdPWcXRW8YKtL/IzXw4t33dzQnfqiuCm86qmvhylTDT0yyQ6vWhpW9ae1dwFdgTarUaX22N1RrDFvDAwCp9kVXkd4oNa4YRB3eWq2KGMovS2vLMjMVp79mTbsuGod8wH7Kuv405ale/MFmsSU/eMw4GZgYnhxqWEAnl8NWP2F/6fbGoSnEKTt58AXXlzQD1mLQIydf1W+EPFkP/i+CwTCZ6CkvqDh+QRSEwfabFNJlxaW15U5GajyRNBT3UlVUoL0Q6fv+N9F5m8jc/1N13EH63y+b9Um5R0r4CfsVC/zSMk1SUkGWB3uByXs5GyOmktEg48GNqYM/CqWAepPBVvzyAIp0/e2GVkWvOdSPi5qP2uCBMIlUQtOvbMmFEggBG6NOlxxJDHWJ7GbAJo92KLVROq1JIXOX4ocLX/fJkPDF26/iGu2PdkDhsYKdbtP2qnf5itXN
 2yiLv6c3
 WA6IhILhaXGuQH27hE7bOKyJ0vyTAyvAu9/Dznl4kaaUTAt3olYTpNvZmObjKPwQ+yh8kkMQ5J55fEep2XJZ/P7pnKvRcfA5rUxifxjnq9paYDWhu3xrLkWudU7iUzailKl4v1aOSzJ4i0pRdZSY3azqiQMMpN/Zyh374ZdyU83JaaobG6IjDhX5kIexC0dy4FCJVxGddkFU6r7qfW7pXwT10xEl4tMGFrVWlpt6qRr6QmUaeiTvLfssrZi/t1QgsRA+yza3svpyJQe6UTiU0Jp7KBYSnjmcaiVKnHdeNqwsOt9REPAFy9dLe4wVweM8tDKNWTrIL6RyjtnIPlL/E6BfZ4mGikcA/lL0elkYTDjkpH+M7pWPDpDQPtjCt/PG/5ZxkfdjVhByNbRHDEQ0KVwk3hFcip7PKXq6sBzouAJlNjvSfHu+XGmFa5zmDcYRZRRXZo/53zdVjo2ADdG3dRou0Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:28:16 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> >
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -3274,8 +3274,10 @@ struct ctrl_pos {
> >  	int gain;
> >  };
> >  
> > -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> > -			  int tier_max, int gain, struct ctrl_pos *pos)
> > +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
> > +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
> > +				  int tier_min, int tier_max, int gain,
> > +				  struct ctrl_pos *pos)
> >  {
> >  	int i;
> >  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> 
> Current code has changed here somewhat, but I expect the error is still
> there.  I fixed that "uninitizled" while in there.  Altered patch is
> below.


Then the build blew up in unexpected ways.  gcc-15.2.0.

The failure looks like a legit min() signedness thing which has been
there quite a while.  I'm thinking that __noipa surfaced this for some
reason?

  CC      mm/vmscan.o
In file included from <command-line>:
mm/vmscan.c: In function 'read_ctrl_pos':
././include/linux/compiler_types.h:702:45: error: call to '__compiletime_assert_798' declared with attribute error: min(tier, 4U - 1) signedness error
  702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                             ^

I'll queue a fix to switch this to min_t (yuck) for now.  It would of
course be better to use more appropriate types in this code.  Unless
tiers can be negative!


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmscan.c: fix min() signedness mismatch
Date: Wed Sep 16 04:21:22 PM PDT 2026

A __noipa conversion from Arnd [1] somehow revealed a longstanding min()
error in read_ctrl_pos().  Plug it with min_t().

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fix-min-signedness-mismatch
+++ a/mm/vmscan.c
@@ -3205,7 +3205,7 @@ static void read_ctrl_pos(struct lruvec
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(unsigned int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
_


