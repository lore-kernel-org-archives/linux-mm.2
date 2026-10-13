Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC58ACA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CB56B0088; Mon, 12 Oct 2026 23:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343FB6B008A; Mon, 12 Oct 2026 23:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259EC6B008C; Mon, 12 Oct 2026 23:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0646C6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:04:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A8F0A8A2E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:04:27 +0000 (UTC)
X-FDA: 85316109774.11.F204267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B37C51C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:04:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dp4DZu0m;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791860665;
	b=TYIDCyz5mScqUFyH/02V5gBBihTn+ErmdLzDSJ1w7sfC3BNHRbFggB+RNLs8e/p28Jrj/C
	WPlYL8BMKiXsE0ti9Gi255XL0t3NinR5TzpiYywWliRKtfk8hz6qt2wMm2Vn0A0k3UyLvr
	JWgS9tXsj5LSbgDQAZ7ROyh/t0lj3jI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Dp4DZu0m;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791860665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMbR3+Id05Igky4vbLXfR35xZqtM1S3j3pEibVOVSNM=;
	b=sGAnMavXdIxDixVRo4J/6W0z/dz6tKG8ewquhrz3xGie5VFeXfNVqh6FfejNrzL7PxhrKO
	ZtsQp/eYcD3rmEwIkpyx64LwF9JbUcvEEOpff7hkTYDiPDWsJ+0k2cY4Axybk2WT1ThoWS
	dcKVfAiyQ5fDmpTzgeIrk8MWDiSfCtM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC95E407CE;
	Tue, 13 Oct 2026 03:04:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8261F000FF;
	Tue, 13 Oct 2026 03:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791860664;
	bh=CMbR3+Id05Igky4vbLXfR35xZqtM1S3j3pEibVOVSNM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Dp4DZu0mNxJsBrW2q9AwiSYaTa11YdXTJtcAdopb9fOXfo+IK7LV+k13Ha2frsOm3
	 By2LcBQJ01isDRZknmRU/PVfJavmgaWBhanCKMxBGFRair98CrWQpNTDwqj4GXBSBw
	 HAGDPR2eDnVShv6WJ/21DuHvUjQe4f/yUjRtWrYM=
Date: Mon, 12 Oct 2026 20:04:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com>,
 david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] possible deadlock in igrab
Message-Id: <20261012200424.0c88c16c44059a8c7ffd86d3@linux-foundation.org>
In-Reply-To: <103d5ab1-b9b5-4cf6-bf87-87771b91eea1@linux.dev>
References: <6acd315b.8cdf6287.1eb53.0133.GAE@google.com>
	<20261012185640.5568805f927f4de127bf0f28@linux-foundation.org>
	<103d5ab1-b9b5-4cf6-bf87-87771b91eea1@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B37C51C0004
X-Stat-Signature: rhsxnbuf7rwnrafkiaptnr586pt1orwd
X-HE-Tag: 1791860665-52764
X-HE-Meta: U2FsdGVkX1/pmERAf1UW0is9XAH+5BoPvgI6t+94475H8VjS3S1N3bY5B0GX0XPtjTLZ1TqXEaWz2ANduqM/uNDjlVsxw/Zp6g9dlHZ0qU7GZFPa8kC+3uV+sq1eCMzblq0vl1mwIj9ixPR1L94eYH73Izwu9Uq3o+7FYrv2397m4zlTQBAQ3C7MSm3a5p2Ek0vpEpFJul4zeEHAOy5/0Q9qC5bKG6GaphbSr4CXr7JeomT23V5mq+79r8zrtQePYqtg7uUZ+d0MYSlKMiZzRWiY2mlU4PlFGQC2XCPxxoehO5fg0E1RZPukyS7vMjmIhNVeZ2vJFUyXj4qmtizRAowyQQwgKM8kEzMOMnpu5SLba3zEiBr4cADKXQIQDtyrwDOirrc6DprnEyHqRlm99qptgqDD7tTURC9GiX93iBy9Rc5xujnKubX0OGnbG9o3tctuxIFWUEtJUu0kSryjmZomi21H51+/BO+I0HUTx0mIsLvIRYI0hglCHfvNIkJe6Qeh+CzHiTwxPWvrmqjIW9MnQKvOQLi51sum/rqqfkJWY0I2S5FNwd7nddPpQ6p7ev4H8i8JN3YJ2aS/LxpkuGHiKUsGJI0AO8GNKtepqo/s1eivBpniOJrWhDNye0RTMtTBCLew40z3vppRSVZWZsNoN7gK0AbvqjEtJnJTOavKH/jiK6EJGFpQzi47DFVpkVD9PAJgVCFeMmzTX82patenuGnPBG9/aYOMbL50ZYmWzWYtx/J9innMyIgZFhhZfq8oAxjy2YZdHOR8lf3RtWe3nF/jTZ3BiBeEiqD3UTbV3OWZUwZBFW7sz4vC2zUoMnqQsRiVO+E5Aub2e8USAyANxF9ZcRBJ/jdeLzUvgZ5szyArknH6IJt+WsuVwlokpFxOUoFi/0b8vLlphay6KXdyc7V+/zsSGubY4W1fCOPNlXhlt5FzAQsLfbeop+j48Z7VSVENGZ2Vd7R6yYO
 f0QGfRwj
 VMiR+PgtKHCfOeY5SbHznkMDcxeDfbd7QBNpuiuqvj+Lmfxo59cBZd4Rt7EMIA5b7WHFqHVDyXbugugsunaV/Y8dtEzywPmg3aaSsvcKZH2o+IzmXTnSMb/0pxRS7gHi4l3DkS3oar02LPPWZjEYgEc3YifUJYJ7/3By97D6udOzsrdQHDzTBtBn6FN0lyZTTs6ekqSpicC7yquDlAn9YN0fV6bVTW/7dznJjYUlT2BJYqW/nOmbdTX8Op6knVJJbQHfDu1U2Q6ZBHzseDtimNOc8FTPUK9QeMkizp2Uo5Si93GSspaDgvTwn+Zmgq1smVHHmT7aFxN+FYSBnpOr1yD0BtFDD7IyLgg6+2FcjhFqsjsARriQ4cLuB/gzGvBt+N2I3B6VQhTW2XYdRCUFMauou8UDW/lUslgE7sTf6r0nlBoRcH7VxEapraWRHcu+RgVYqx4st3CtV46ymi2U2F6h6R0XBK6lvHJAolh4gOKQco/BWvyBBso3vEX2F/i007kvD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 10:17:47 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Hi Andrew,
> 
> On 10/13/26 9:56 AM, Andrew Morton wrote:
> > On Mon, 12 Oct 2026 12:13:31 -0700 syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com> wrote:
> > 
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    b01868671970 Add linux-next specific files for 20261007
> 
> Looks like this doesn't include my latest fix patch in the testing.

Damn, sorry, I forgot about that.

> Fix patch: 
> https://lore.kernel.org/all/20261011045956.30277-1-qi.zheng@linux.dev/

And this has 
Fixes: b9b1861d4f7a ("mm: shmem: make unused huge shrinker memcg aware")
so all looks good.



