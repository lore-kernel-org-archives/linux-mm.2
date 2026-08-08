Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA0AC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 15:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A152A6B00C2; Sat,  8 Aug 2026 11:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD8C6B00C3; Sat,  8 Aug 2026 11:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5176B00C4; Sat,  8 Aug 2026 11:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 683826B00C2
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 11:53:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5AF4140398
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 15:53:30 +0000 (UTC)
X-FDA: 85078546980.11.89D9666
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9280240007
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 15:53:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786204409;
	b=0fdyAfB+mTHVm+L5tdSiyXxLbwEJQBqkSh4CH4ns4Gu8jqh+3u/TR7HGD4cqns1ylHj361
	cxc9k+4EqxnGIy5FsO9rsdaKF7xJ7xIdPGPYjGopWzmxKvhtvWvYgS9WU5iUqcE+uhP77c
	5hYx5BEOJRsUwJQO/un0rok2WWJrJM0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786204409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nltNiX6rU18IHooivbDgvc+FtyhiQr4rTMa/+aorgts=;
	b=u0JxEKdDKx2BMMvK6jSG72iK6eq2LgIGRQgeAHPfzrPcefN2J8Y8SbAer1Ym+7HMxHkj/r
	MttjLNIHBScDA8xX5GV1hLGgxSTb1EphofwVDOGQ8Vg3YRfIm7T2Y5RB4lMZNo6ZM9cyqH
	ETqH2ywHzspKajIZQBAVvTR14kUdvRs=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.53 with ESMTP; 9 Aug 2026 00:53:23 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 9 Aug 2026 00:53:23 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 9 Aug 2026 00:53:23 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	her0gyugyu@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <andQ8w/B5DCSzKKD@yjaykim-PowerEdge-T330>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
 <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
 <anWabobwPyAXvRe5@MiWiFi-R3L-srv>
 <20260807144256.6fbdfd15f7ed4f518af7929f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807144256.6fbdfd15f7ed4f518af7929f@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9280240007
X-Stat-Signature: 9p7uhjp1esa8ot5occa5n3ksg6qz9cbp
X-Rspam-User: 
X-HE-Tag: 1786204407-596469
X-HE-Meta: U2FsdGVkX1/5EWN159Q2hPF/VmJoT11Eysy0y/97ImLXyZcgpLten9Q5q5KEG2pHwGM5sVvdCY4hutuhL9YVGAOfC1PEHmBEhesA3C7T8iRoaKTmyyjNCgEZeHveRC1OaAOY0zUXprX/arBR7Dn6YNY/XCZdnnF/CPE6t5CNJECIpjXLGEWQo6rIaO2jSCiSGgjACsVoyXMsc1XAqmdtJNGCEiMHyGDEf+Nu3QSesq+I4giwni8XyTf1EIV3OOz9h1RgUT9aWtCqQpNQ2SwvLPTmecNbrQelRxPgYmLYXJd2GvsZRMEwgsV7u4HoFb0XTEgoNbcvrEFep5lSVwXFFz8MblXhsBMNwYrVqn1dKONjduXJSGpqgX4Me6A9M9k0PRmypV7TMPsYC6ZyrirMbKcfaVq1fU74RwwsWbHQgJgiCnmb1CXgzh/B6LkuH87DOOkbAchJAZfULlWxvfbs5EVnlC177/LPWGFOr2sRVEShaZbnIUTHA8cN9An1gWzEQbSLL9FlXrApFQuI068zQWmrL87Eu2DgtPSdBBc00yxB0RF58JXulTZcW8hX8+EJwiuhbUsy5m8clm2OEGkYJ85mPdwrQEtsKXE0khPLfLcPev5Pii4aqtNOXVV3grXqA8icjelXRNNCqvOr95es3jjQwqezpB+v3jiKaoD8ZYr0mtFJGgNvUFSznEPXXLNDvCF2I2npslOzpn5cTirn4zynYGMmIgNLg5xI4j8NJD2FRJ/AUWbbrG6W1Vgt4/PKOwiJoUgnxUmcskRjWoO1sPihGseoFhAD6dGPTf+hKs9P3UWWK5HsUbsgiMMdr7xCitNtY5zOZ+abkYyuBVko+hltj0/DM8rWD9MzD4+nmh5uP0JdfJo8bL2mAa9RtiBrzl1CkBVp6mYwfJMNUxr9AXH5x/wm60pixhNbneb84o6E2Mfazm7nraCoMGBzEQO2bPCdmaciYyv6t77w+Uf
 37xAhSyK
 i2+NzooU9uz09bZ3C8U9AzyUL+lfvzbIVsBc9+vI3Up9YxsU9JNwbgc/t3dmhTUX8ADlJK6UQoAbq7a49kfSqFeBo9rVCEj5H/x6Fne+FpDMKUHduTwGlESkcC7rYMEOdEyWXiW/LEPKIeN6FGpDt+zCWU1OFU2fkEPF+b7Z450Q0epBuORcx6FM5hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 02:42:56PM -0700, Andrew Morton wrote:
> On Fri, 7 Aug 2026 16:42:22 +0800 Baoquan He <baoquan.he@linux.dev> wrote:
> 
> > > I have no measured times yet, since that case has to be set up on purpose.
> > > What I did is the arithmetic for the case that skips best,
> > > For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
> > > and everything free but the far end:
> > > 
> > >   - today:          256M table reads
> > >   - with the skip:  512K counter reads
> > 
> > 
> > Maybe just use time to measure swapoff time consuming, just like below
> > as I did on a kvm guest, I guess a bare metal machine with larger system
> > ram could be more obvious?
> > 
> > root@fedora:~# free -h
> >                total        used        free      shared  buff/cache   available
> > Mem:           3.8Gi       181Mi       3.6Gi       924Ki        72Mi       3.7Gi
> > Swap:          2.0Gi        18Mi       2.0Gi
> > root@fedora:~# time swapoff /dev/vdb
> > 
> > real	0m0.101s
> > user	0m0.001s
> > sys	0m0.017s
> > root@fedora:~# swapon /dev/vdb
> > root@fedora:~# time swapoff /dev/vdb
> > 
> > real	0m0.014s
> > user	0m0.003s
> > sys	0m0.001s
> > 
> > Not sure if Andrew is asking for this.
> 
> I think it's helpful to include such info.  The audience for changelogs
> is more than swap developers!  It's also an MM maintainer and -stable
> maintainers and other people who are all wondering "should I backport
> this for my users".  Let's give them the means to determine that.

Hello Andrew Here is the experiment.

7.2-rc5, fill a 1 TiB swap up to some amount, then swapoff.  

What is left sits at the top of what was filled, so every slot below it is free.  
Those entries are in the swap cache and cheap to free, so the search is most of the time.  
In short, best scenario my patch shows improvement.

Medians over 11 pairs at 32 and 128 GiB, 3 pairs at 256 and 512.

      filled          swapoff 
                      old        new     
       32 GiB          92.4ms    66.3ms
      128 GiB         157.6ms    94.4ms
      256 GiB         209.7ms    63.8ms  
      512 GiB         391.8ms    73.4ms   

old grows with how much was filled, new does not.  

In the ordinary case swap still holds real data and swapoff spends its time
reading it back.  I tested 4 GiB on an 8 GiB device, where the scan is 1.4%
of try_to_unuse(), and there is no difference either way. meaning no regression

Thanks!
Youngjun

