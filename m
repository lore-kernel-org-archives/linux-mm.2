Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC07F531DB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C68C6B0088; Mon, 13 Apr 2026 18:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7769F6B008A; Mon, 13 Apr 2026 18:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666A56B0092; Mon, 13 Apr 2026 18:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E66F6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D74EE139CFA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:29:01 +0000 (UTC)
X-FDA: 84654974082.05.81C2BFC
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B78214000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:28:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Acn3ot68;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776119340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0C0oTbgMZYbhrAvkMy0ApjkIhijnhBgwg9sMmLsR0w=;
	b=ajw1fK1SaHvyp15ntokJoQy+NqTQDKE7zaroSF6fjyZIv3p/kxDUayCfs40xbpyj37okBH
	hRL+owwrtajhbaD3Y+kjy/EWZmD0PSlcjQiQOaeLVQf4Oe10dd2OZFIuYpSbeW3KbYXdTc
	13KH4GE6EbWeoDXg4zWN767pK7V7lss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776119340; a=rsa-sha256;
	cv=none;
	b=WuHuaPlI5v8U7y9ivZYYglg4BEpXQfZO12V3hgGdR17f+cqd8xSkmYrE2YXN2BwiV4BXFK
	wsLXXncjaAuR+7Jyq83Vw/de5TAcIy6F1c1cLtZId1GTtstMk4oWEJzeUBjxAu9DRjWFDT
	dURHCZK3GafYVWScTc8VXJ4rl05yETk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Acn3ot68;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 13 Apr 2026 15:28:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776119337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0C0oTbgMZYbhrAvkMy0ApjkIhijnhBgwg9sMmLsR0w=;
	b=Acn3ot68zMGKTsDYvK5Aa4s1RXOMEuYQGZqR09u3VG6a016vJp8EKZeK2gFbESKUvWoT0Q
	0SarXFhI/s/uQHW9HYZOEIS6bKHCakE8/CMF4YrhNIlAFdkEoKqBkFrIOdowTV4y4HWI3M
	mOVL5DjirDprGIsRuX9t3ZRr2Rhp5gk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: syzbot <syzbot+1a3353a77896e73a8f53@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com, 
	yosry@kernel.org
Subject: Re: [syzbot] [mm?] [cgroups?] WARNING: bad unlock balance in
 lruvec_stat_mod_folio
Message-ID: <ad1tV5WpFhxbQ86N@linux.dev>
References: <69d54494.050a0220.3030df.0002.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d54494.050a0220.3030df.0002.GAE@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5B78214000B
X-Stat-Signature: cr5wkrm8asenor7zaw15wx5s3wp3pxy3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776119339-848534
X-HE-Meta: U2FsdGVkX19Xfx4l5HQk5upVOwIfLs13SFAMI7w/epp1Kx/iwQGRdzx55rW4sYVa8wUCaHYtKr9fiVPuT5omHZY6VqUJfT6pGQNEuf4mF6b2LkiNnsft3FPQ0BEsiCCaDmtGCXLIYgSpxusJLBinCQGNQS6nOtTeJ47nffBf1s9Xzi1kvKuvU2lHPDyjJDOTvkC3Y1dmue3Et9y3W+/atJ8urTD5e+JE0trFm0e4AvYYEQIaIAU9xh4YDANT1ECnoSsbRPFP3Pp1T5YPSUTp28obYsAKtFUq/BQnUQVkQiGsbKcxgDBezFzndnuY7YBLv1qVrbA0kxZzmtKKP6bnYKtDR501iYzRMB3FXc891SXT8KHf/gFD1ATlyUMNXDqf0j8R39G/Oc0lUkfy0f87WPAu6DGSzas7uQlo3mfA8EzXh6WxiHGGIM1Ev6PmcZDhgpFX4qMwrY73OFaE+Mt7EKJUkIeZCckQRIKfw3dEBWnVsTjPDb5T1zuqSLFO8ywcs6uV4uG6aDKfIRwwJhe8Fep5Q27QqNvv13oxchTT9zbW3Wk1pjySE0GFH9hQ4MCKR55JW8nlO2Vuj4tNAGvI4xk1VxtjYpoiuVML0aiQN48UHz51O4YczAPcRZIKNj5zTU393IE531ysnFUsIMol9esAC0yOCkYut3phMA2vuBzlvWfQGydgYxcaRgm1qBRWVSrlxjuwDbJoHSnoXv1w+JvgKm6fCoEMYpG4u3ursrMv3vLLiFAlHVkYbalROYib2W2uvG2HA7ynpINVGNcU7OJvybhJ4Ze4EtZ9aLS0xA17wEX7XbrZNARg5z0Z2TePWcrSmz+z2HrUyFlkUTxo/YsXvWECLDH02xMbuY25DoYr8vpuIh4qcmpEbIT2aFL0FJh2RdtWqfeVytTtrUO1DjpBIIj42UAnNRhfvXrW4cT5DLtJuo0Pv+X1JOo6jqUMBbqW7hIKnNBLKEcWPID
 bZ7x8Jgy
 Urq6So9cVxA7QPUpe6Gsjna151t4FxjyN8jXb/HorjqzSs19JbP+uSTsQro0cMmAF0Ay9Gbdl2wapWgsfjhqoh8o3vmKueBvuScn/sKbSSKOsKhgV5/EUyCyJVCM8TKyca5zhSioP5gpJohWmzQ5An1NKRPqmV9pBz1YdQArfqkbyWHW9TLxRNvAFb9OnK7w1j3yu8/wv2D9SS+sv2wiKmMEvYg8sf1sIoOH8oe86mEAgF7hNd0+MpGanCFS81+wyp7/yY1+injJGEc8VzCYKjabKrr0c2oesXC1U1JLXm+R45SfOpOESWhc6FyduMwsVHmzCaHxvUGpaclCg3v6leaI3/4XXbcZ5IX1x8PFoIGbIfHBTGDa+XXCPKwqDkOz2C2haUJwl0pshV135iGhx9DS7J8AyUylXQStZu5uYU4tjNkel7sKXLURXQe0MNZcl0uxJSurxwNihcJ3BLJyPXoSfLSbGuuM2Xf81AD54yrK35AmR2X/0DZNFPmAFAWsfceuIVO5NJjI9oaz6ooVJ0kuGiPP3mW1p1t+HeWFgpouVTJ0odLc0qpIN2eGOHT3OEfow
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Qi & Yosry

On Tue, Apr 07, 2026 at 10:53:24AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cc13002a9f98 Add linux-next specific files for 20260402
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=10d8946a580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4e6c8be618ab359
> dashboard link: https://syzkaller.appspot.com/bug?extid=1a3353a77896e73a8f53
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Let's wait for the reproducer. I can only think of cgroup_subsys_on_dfl() check
returning different value in get_non_dying_memcg_start() and
get_non_dying_memcg_end() to cause this uneven rcu unlock. However I can't think
why and how that can happen.


