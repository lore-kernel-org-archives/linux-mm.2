Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459A9CFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968326B0029; Fri, 21 Nov 2025 01:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917F66B002B; Fri, 21 Nov 2025 01:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DBB6B002C; Fri, 21 Nov 2025 01:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2CD6B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:55:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B73E31604EE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:54:58 +0000 (UTC)
X-FDA: 84133701876.10.081896C
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E2F0A0003
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:54:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763708097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C1nSvXIqf8TaQlmr4f6P7PEM3Sy71R+pr4KnY/6YmKI=;
	b=QCr7Oyr87ByBf/FsJaW375tt/yjoqwwrqlhlv8G5wY7sYCwUHhbAi3L0gwJTl/WLEjsIez
	whM0+N9hbejnz/T7kNH05oH0rzKzzeth3cWLI/+BXT3iItwwKY0lrly84B3wTpmo8cYdV0
	KDdRTRBuvcSGHzMWi7VWNNvpxxO535A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf15.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763708097; a=rsa-sha256;
	cv=none;
	b=u+i2FdqDdcdd6YLMt8AT9//M84KMzzVbIyrHwnZh/SLRZpLvRBgB52ExedJNLOp/GIooov
	eaT6n/maP2tY33y6IEz/0cdyRQ3s/bMsWZjR4FFSJ11Awsw6cMASpQScxqWbQpa11uEAHa
	50Wvamt27ZZBSg6KqH0hJDcHNe/klQA=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Nov 2025 15:54:51 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 21 Nov 2025 15:54:51 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
Message-ID: <aSAMu04In6dLboPs@yjaykim-PowerEdge-T330>
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
 <aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330>
 <CAMgjq7C_ebrZv73VNBk-mhaSJwQXJur96R2OdW96YCM7vtJkzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7C_ebrZv73VNBk-mhaSJwQXJur96R2OdW96YCM7vtJkzw@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E2F0A0003
X-Stat-Signature: e3t3a1d8wpteuqenqce15dyjytujuj1u
X-Rspam-User: 
X-HE-Tag: 1763708095-877575
X-HE-Meta: U2FsdGVkX1/HIFrVASwlbLgTHbG0hLH0eSfU9qlfsAEyjBKOOalqD0TmvtDLvYkj1Z3twJkJbogifyzEbKaTNT8WEf988EQttZ5AcJsCty85PMX1co0R7d70DvN+ffECmtvp9csRPuHhv5tarC6uoxUzgVjDYISwiKo7xh9nEF2/nOO+eCeroG+jHnHL9OCuBe6bMxHuhuJmaTdbkw1J3J9NwZZX496vD7F/tLOBgiaFTRUs28IW+UNB8N1WA9JEk7kj98eMhComiSRaaFRUbFRrTjstQ9din05+1R35Yf3gGtka09mLYhS3lypwEuAHr5bKIOOFXDCszU7rgo+r3nxZb93vs0P9q7TYk0db6AcUlkfMgNLbAMfXqP3BxuuyfKGl4I70Tq77on0gQVspbRF/hCuSsDnHBd+cP9AN63OgMG00XUhoPZaIpTv9KrNdG8CMahCwhEID66zhiq5hgXcvRMo5vXEH+yr3Gf98FIBxyZpt+ulGG34w7Kq3MSv47wrVl/sbiy8HVgSrRtgBEe3p+4AWLvrQsPEOggHYSqyZkuwSFVPrvP7hAwrEuio89d98gbRxUttoIgnqPNcboKVR0YYl0HbK3GTh5Qa+pV0XxVuy4FT/CIJGeshpL/ld9uaI/un/FeOMmofmtf8hXmrr4opiu44MuQafpY2LRxcX9SyObcQLfn/BkSmgJqgUGu4ip8cvjRSHGTSe+yGWMx6GOtXnFFXeR7tofE1GOD6jfleUwL9c9ud4jzl9vNYBlg5UuxOxO6/Qp3eeb2bj/mocHJfOBa6Fy8ZVBaF/LW2Qd8B00kT3dgCayNnC5UkQpXFDZPuNBNaa8A6p2+rcPiG0plu5la6JlB5Az1a97FDz8nCPvN8IEDBeSdtEltATy+Ou0fiPQgFwL/OmHuqujSCprb0XoFeY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:18:34AM +0800, Kairui Song wrote:
> On Thu, Nov 20, 2025 at 10:06 AM YoungJun Park <youngjun.park@lge.com> wrote:
> >
> > I've investigated this further and noticed something about swap_sync_discard.
> > During iteration, it doesn't perform an empty check on swap devices. As a
> > result, if the iteration exits because the next device is full
> > (deleted by plist at this time), the
> > operation(swap I/O) fails even when other available swap devices remain.
> >
> > Should this be addressed?
> >
> > Best Regards,
> > Youngjun Park
> 
> Actually after thinking about it again, swap_sync_discard should be
> looking at swap_active_head, not swap_avail_head. Changing to
> swap_active_head and also checking SWP_WRITEOK is a right fix I think,
> and should be good enough.
>

Hi Kairui,

Let me confirm if I understand your intention correctly.

It seems the following changes would be made:
- Change from swap_avail_lock to swap_lock
- After sync_discard, reacquire the lock and check if the list was
  broken using SWP_WRITEOK instead. If broken, since we can't know
  the next si, restart the list traversal from the beginning.

The advantage would be that it's only affected by swapoff changes,
so exceptional condition checks in this logic would occur less
frequently. Also, using swap_lock would be better in terms of
contention compared to swap I/O contention.

I'd like to confirm if this is what you intended, and if we agree
on this approach, I'll submit it as a separate patch.

Thank you.

Youngjun Park

