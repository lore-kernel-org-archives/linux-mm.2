Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43458C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C52C6B008A; Fri,  7 Aug 2026 05:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475B86B0092; Fri,  7 Aug 2026 05:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B566B0093; Fri,  7 Aug 2026 05:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 178086B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:59:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 950EE120226
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:59:12 +0000 (UTC)
X-FDA: 85074025344.01.9599EC7
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 900B8100002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:59:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786096750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypiGKhZPoPjoUNX2kkBjkM4zCmq9M2RjDCcKYYSDbwg=;
	b=5ldINJiVvIQ1Khx6NL3+fZU9+a1A3OllJQ20OgGxSG1N57tAXcJPW6JVoEHLYtGEwoSy28
	9C33acnTEEQ0FPadv9hm3manhuHBKkMsVHWit1NXtjFWu9WPa1Po6PTWu5FM5mxdKbMKFP
	rYAtdlJ7hxXzAK0j7iv7fTnHxEYHgk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786096750;
	b=taxeOVdldKbG7uajPAXelp2ppJXjbiwQvQ36COJZNAjTRrXfSzr+55pVZjEm/KXGo3De66
	4L0fIbpJmGVBGHehzOg/sXPzNnz0G4xN5vkHPYH12btzj7px4Y+oAkQmJnNnNpaaSGehpb
	sw9uOZf7y+KBesHcnkEkPj9qRusV21Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 7 Aug 2026 18:59:04 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 7 Aug 2026 18:59:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 7 Aug 2026 18:59:04 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <anWsaJcTjVah8ySk@yjaykim-PowerEdge-T330>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
 <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
 <anWabobwPyAXvRe5@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anWabobwPyAXvRe5@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 900B8100002
X-Stat-Signature: q6z5cdtmpqqnmyzmddnng9p77ytkziid
X-HE-Tag: 1786096749-851335
X-HE-Meta: U2FsdGVkX1+SKKCUqb06/sQyRvRCf2rzkvgluoSWpsvhiMV1KbolZ7kFLHkTRrunvQvZTjAUIscKluAXQ8GvVosUjcqwCkIMCAh+cT63FTFx37I9triYCFgC8XK9iu3jMz1XEVk5kYllrirwP0Bfj2nsnDR29VOc/Lp4CqxBiF32z5ybw0GTdnu2KfeIkM0kLAMrIJMX4+Xqxcji0Pzl/709sL+m3VWLzq/M/pe88xcv9L8ZHCDjn1Lg88ifPjC9XFMsCVIwm/eik3vgWJwJqy6iy3yaAlFDBE3a/nYIlAk0cmE3w0kzXNb1TBbVVS0FhSpP83lg6abbQMmpoF4zAG9AvXNFF/ysZvnzV/3JHnngCFiQnyMdcWbo9Pd42G38U3jM1wk0Ym6HoYlgfKJg/dDvFg0C5B3Sf7yVB5NqfzyqT7ExHZTelt2bA4/J+lRMJjTVw4mn6uWXqbJZsOHbShdcYGXwfiZCyBk9zcGbqPF4kt1Z8IzPdyBmGdymhXL192o/Xyvk5iy7X2LBj5S8o+wlgbtRuXX3pyTuFWgfMOAWgk6D4Z/jLziq43YVb8w2dlph36d2AmszONX9j5woxgyCPlagyG2zGn71mNEclj5Ish1G+BAP7H64uQXk3WLsQtvUTyeiBexKSXRDITz43Z5IkdWP8CVXDeDuPX/9tDxn/e5PjAADHo07/fNEZWqaCKV5tyH5bJQAr670EnCaE4gQbqj2vQvfUsYZKPLT+t8kpypaDk5yFL7DeEw7zRF/ehsGhK20FxJMVIQtKG4cWDakZ8SDaikHA/uXFPni5NJcZQ5+HEC4CWlhqpckX2xmNmTSXkhyn+9uz+nv7kWjwvdC7w4oh/6Nd1ZVsV02ZFND/p6ZNmJwAuF0lt+sn4cfJYQh4oVJ411NYkguSf7KUqdC1DglHpHoO+4jqmHaG4BA8kz+rlS/T1R0VQzxHkHvb7q1UzcyeS4mjPPGNnA
 DOqpbZ3N
 gyJ0vsX0Ou1l3Et4/5ZOHNHwSwDMnoeaLa+Imx39x6odrTgTmwZeWyx5gknOyrECgqUJiUGdA7Uo36NS9uhdKTrRxT5ciK/gxuKuIArqKfWldj2EFOiCuNqLhKpIZc0Jz9NTMjITNqAgz7mNR0rkxybhSszd0NTO8v9RgDlLrX1SCo2plfCT8pFPCnkUEK7zeKwjDpeC5I/Y7/Qmh7SFOAZceftdzSf2wSAnLU9hKlbbdWTFbIS9AXhK++w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:42:22PM +0800, Baoquan He wrote:
> On 08/07/26 at 03:41pm, Youngjun Park wrote:
> > On Thu, Aug 06, 2026 at 01:06:55PM -0700, Andrew Morton wrote:
> > > On Fri,  7 Aug 2026 04:32:26 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> > > 
> > > > find_next_to_unuse() walks a swap device one offset at a time.  Slot
> > > > state now lives in a per cluster swap table, so patch 2 dismisses an
> > > > empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> > > > reads.
> > > 
> > > Thanks.
> > > 
> > > Can you help us understand how significant this change is for users? 
> > > If "not very" then I'd prefer to defer consideraton of the series until
> > > after 7.3-rc1.
> > 
> > Hello Andrew
> > 
> > "Not very" in the common case, though there is a case where the win is clear.
> > No bug and no user report.
> > 
> > For now I would rather defer to after 7.3-rc1.
> > 
> > And for your reference, here is the details.
> > 
> > Every swapoff does a little less work now, because the scan steps over an
> > unused area one cluster at a time.
> > But IMHO most of the swapoff time goes to unuse_mm() and to reading the pages back in.
> > 
> > The gain shows on a large swap device that is almost empty, when the last
> > pages still in use are near the end of it.  The scan has to walk up to
> > them, and today it looks at every slot on the way.  Now the empty clusters
> > in between are skipped in one step.
> > 
> > I have no measured times yet, since that case has to be set up on purpose.
> > What I did is the arithmetic for the case that skips best,
> > For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
> > and everything free but the far end:
> > 
> >   - today:          256M table reads
> >   - with the skip:  512K counter reads
> 
> 
> Maybe just use time to measure swapoff time consuming, just like below
> as I did on a kvm guest, I guess a bare metal machine with larger system
> ram could be more obvious?
> 
> root@fedora:~# free -h
>                total        used        free      shared  buff/cache   available
> Mem:           3.8Gi       181Mi       3.6Gi       924Ki        72Mi       3.7Gi
> Swap:          2.0Gi        18Mi       2.0Gi
> root@fedora:~# time swapoff /dev/vdb
> 
> real	0m0.101s
> user	0m0.001s
> sys	0m0.017s
> root@fedora:~# swapon /dev/vdb
> root@fedora:~# time swapoff /dev/vdb
> 
> real	0m0.014s
> user	0m0.003s
> sys	0m0.001s
> 
> Not sure if Andrew is asking for this.

Thank you for looking into it.

Yes, it is possible to show this. However, it cannot provide the saturation
time, as that depends on the swap device size and swap slot distribution.

Since a naive swapoff test cannot provide stable evidence, I addressed the
approximate skip time (and also checked whether a skip occurred) using a logical time
calculation as shown below.

I try to take some time to measure the swapoff time under experiment conditions.
I will follow up this in the next patch iteration or sooner in this thread
(depending on Andrew's decision).

> > 
> > That should be around half a second of scan saved.
> 
> Yeah, a concrete number is shown.

Right, based on time complexity arithmetic.

Youngjun

