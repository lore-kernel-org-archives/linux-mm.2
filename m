Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40021C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051B66B0092; Wed, 16 Sep 2026 19:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C446B0093; Wed, 16 Sep 2026 19:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB106B0095; Wed, 16 Sep 2026 19:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A766B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:28:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12D651401BA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:28:20 +0000 (UTC)
X-FDA: 85221216360.08.2526C54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57CD840006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:28:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=srvA9OXD;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789601298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPs0AIc/Ul5bydtRCdm7Q9haA+pM2MhBAlRyqbrA+uo=;
	b=wez0qWyfzECnAkrtN0vFSQ2p6X2sVcXTwPC8/TmOjf7efrucIwRrifW+/d9NjPkXl6qXhu
	4YfQ4H+1wOFIKfOLo0wVYWXKnjRl/amAcxCcWJn+2NNJOHGKLBEMT78S2gYYluhCUaBhIg
	TlAW6+KGmKgOWza0+Jmgd3EJ3bnKgo0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=srvA9OXD;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789601298;
	b=72N0xn3IzZ3ARMrMB+y/jqHkWiGN9SPNa55o6IxxYgomQPIOiR6z4dWnl8HpqKpS2p16DB
	6LPKL4xvycErnFePcFYRK+jbRclF3GI3r/NY9Yi1wSfhj4IcLMa1C3IAN5ft7U7ePgd6R7
	OqIJ9QCsjbGWaIiF9up/H73YpmYnWtY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DDDE601FD;
	Wed, 16 Sep 2026 23:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886311F000FF;
	Wed, 16 Sep 2026 23:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789601297;
	bh=UPs0AIc/Ul5bydtRCdm7Q9haA+pM2MhBAlRyqbrA+uo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=srvA9OXDoPzoqx9Pib4l6v8rqaRVTEd6e0c5mvHaxz5vdsP2Mm+d9TCxc+TJpMPRu
	 dtEuSBeHPRpI3Zzlu3voDCT62LC76011AqrTfcp8LFhJoRO1s+rP8ah1qikeBWXr1v
	 MTzLCu3Chm+GXcLyiPXTYGZCG+dk7Zb8Hmg4qrgk=
Date: Wed, 16 Sep 2026 16:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi
 Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
 <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong
 Chen <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized
 warning, again
Message-Id: <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
In-Reply-To: <20260916083456.4136132-1-arnd@kernel.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57CD840006
X-Stat-Signature: o9mp7s5hkp5redkkmr5sxnjstcuihdfw
X-Rspam-User: 
X-HE-Tag: 1789601298-679710
X-HE-Meta: U2FsdGVkX1+uMCDl3+AgRBuT9sYPnT8Pystf/Xb/jv6mGeeUlYV2SrBgZuY8nCBYuNSVbmoFOipc6byA/HD/fKAKuON7DNqIUd1pVqew7zIywGE3B1qC5l5UyUTBcCtVQnq2kz2PQtnWDU74fPxO3TKZdTcTOvfzvl1Zl5DaRwSqMkYIb9Mte04JqmosUssPMZI1M75N4An4wkriRO+eepx/xuGjeu/gCz8Nvc1xnPb3hBGqUh20feR1DliZSP49HQGPLXm5RhO5oyba3LaW5GUw48Jcch9cwltiGQyV0QFwR7nQjVK3XLVOev2V1n3XH2mwuDRVUQv5RfKhV3GDQbXvBtsBYY0B+Jzx6H9xZ6UZDlgb5RmAr9045rd+ypLAaPj8Qws7kxlWIBIXDSKSrGz10Ylf6QfGM1RnLpdGfevCbedsTdREML0QPTWIGgtp0nJ6RQwjWKhUV2VWeKANmJ8KQdZNv/ran6D6G7C4jwOyxCfkxW3YMHu5qOQcZT7PC8ioggiDZeiXgSs8ay39Vue62Nl1ZcmBF3qIDEiCs5YZHX0krFadzfpot+toYeWGkqEtbxyIq3rd1F1ruIsjdAVLjD1sjxOlnuSzYEGK2k5CfSgQci8VMLT0mTH/ihFHrhKmchOmuNOvbf1XTUhLB3fNB1vDvRoSABzcLXG0fDcmR+paZmdc5zduGIlwKprvB9clIbw5BSGNg26YOz/fG6wyPu3RraF9ENzVWiemlbxTbRhIHe4c5fco8X8lxMyWNv+lLNR4bdfdSfGxmLNWuFVdVqrFArPatAYKnDrwn5jVhom7Mfik/+VHPzFxbmB/Udh/TGnbsiVZ+pat/FWWIi8Cxh2ymcOFQvRlRYhqRu1RFHTeadX0NW9fwUhqce4xieZ8+ln+9QYKjOlB8py+VABoSxptjbEb3OseuA2Ma2wrp02uP/cYSba591c4YBvEXnEEXwVfCeHbPFnMgOS
 QAgGwPk9
 QsqELLJZfHeb7F0E7aqq49mXANyBI2Z7zAQ5q/pMuiBMVNjYOyqc8MzY3kF45Brn9zkqooyhhBe1f/d/wRtcmKfsAnz+dk6kW1llC91sYS2ygFCOUQpV3Fd4TTZoIksUjfyV6xfx8wCmJKFnLPDYzEyhjjwPcSGrYEKRLnjmgh8YpaA4DJlq3xhIgJ9oupH9u5wWS+Gwgdyjubs6VwirgjMX8IkgSdt3rR2eygLiMYURI75aYZigCm2vNANX4Mp0OP+4sY33S0WHHl3a8mQRbDUSL+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 10:34:46 +0200 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> I previously worked around a false-postive gcc-16 warning in the
> get_tier_idx() function, by adding a fake initializer. This happens with
> the -fsanitize=bounds sanitizer when the compiler creates a specialized
> variant of isolate_folios():
> 
> In function 'get_tier_idx',
>     inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
> mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
>  4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/vmscan.c: In function 'isolate_folios.constprop':
> mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
>  4946 |         struct ctrl_pos sp, pv = {};
>       |                         ^~
> 
> Adding another "= {}" would solve the problem as well, but to prevent
> this from happening again after the next code refactoring, try instead to
> prevent this by forbidding interprocedural optimizations on this function.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3274,8 +3274,10 @@ struct ctrl_pos {
>  	int gain;
>  };
>  
> -static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier_min,
> -			  int tier_max, int gain, struct ctrl_pos *pos)
> +/* __noipa works around  gcc-16 warning for uninitizled use of pos->refaulted */
> +static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type,
> +				  int tier_min, int tier_max, int gain,
> +				  struct ctrl_pos *pos)
>  {
>  	int i;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;

Current code has changed here somewhat, but I expect the error is still
there.  I fixed that "uninitizled" while in there.  Altered patch is
below.


--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning-again
+++ a/mm/vmscan.c
@@ -3195,8 +3195,12 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+/*
+ * __noipa works around  gcc-16 warning for uninitialized use of
+ * pos->refaulted
+ */
+static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type, int tier,
+			  int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -4802,7 +4806,7 @@ static int scan_folios(unsigned long nr_
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4821,7 +4825,7 @@ static int get_tier_idx(struct lruvec *l
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
_


