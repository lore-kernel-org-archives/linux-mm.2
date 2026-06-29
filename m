Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DC35C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7826B00DE; Mon, 29 Jun 2026 09:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0893C6B00E3; Mon, 29 Jun 2026 09:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0D86B00EB; Mon, 29 Jun 2026 09:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CAA0F6B00DE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:56:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57544A011B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:56:06 +0000 (UTC)
X-FDA: 84933099132.01.3BD087E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68047140005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:56:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vgBC37IY;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741364;
	b=EhnDzM3GIDlV7a4KXLiXsM1p43J3I4DRbjUXC/BbS5YzDeq2fbDt7J1Kk0yb8T3fRcPlSA
	LRKtkZC7s375+956/PSMpPCME2kms24/1WRyiifKpgSsnDr1k7MuOewdbXJgc3eZsIXJvf
	Jwk5pfiEdvikMO2cSmlfz730eX0uqI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeFjIxuSYF8J0DkeUYc5tlTp3RN5B8ri+h7u1iPzWr4=;
	b=RxbCs4WXsgnDb1Kl3ef4c0RAZqEhWPF1rY5VwIirYrt2w456/ZQ9bRY6fdCsbODS8+evNS
	fIIHYrrTKqNBvzelKAX0AEIlRgXt47yICE5p/y9ZU9QOnpWddNMLrZxQ6oJvFHVhssR3q/
	TptXiqRNkJ16nZg/I8zgKQW3WBH3uoA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vgBC37IY;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fb000c9a-add2-4c31-afe1-b6ec416c9058@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782741362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeFjIxuSYF8J0DkeUYc5tlTp3RN5B8ri+h7u1iPzWr4=;
	b=vgBC37IYOOiKPtFawXBcTU6sMT7fDEffIeVaKr/sh5bVKq5JrJGadZpjOZisxsXgexuD4H
	tTZzz9bXBnjufHE9XusquZqKIeZj7c2CqDNVCBCZuDbxz9i3zoO5YIhP4d6j5tbStT2OoP
	hDVigcnLBKFNRjQWd/mkod5upskV/00=
Date: Mon, 29 Jun 2026 14:55:57 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, kernel-team@meta.com
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akJzXU52XJ9-F2IB@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <akJzXU52XJ9-F2IB@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q7kp3bin7din1ssi4jw88hza7ftmn95k
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68047140005
X-HE-Tag: 1782741364-201534
X-HE-Meta: U2FsdGVkX19us9bkJDLu9I4I7tKAKMegThRYZd6vmlGhIPkyPRmhmo+fcpvfVbuNCsnncqsCZmvxRE0+OPp1yZnXW13UpTSR5hmkjsVkE4H7pelOTIqqsQfSeW/tuxYFBw6rtURKftBbY0TotOsXiTCn60Ru8p5y/zC6+N++hH1EAf4DhE5tzk0oXcvWA4nrFXagvE03i4tSKePGv6ba9gbGEBDE1lDblhQObOJplF31pwlLmYpcCQnh2BhfBle2M7Z84TnyIV0JOPqISvmgplpAzXlpXaJpqNqBlOLaO3t/gegph2ThEc7jRpu0Iw9rRTC4ka5Ld8JPiGM0Rvh25eRf6UtMOnaHAWiooPnAYqibC5eyNiAD7tBMXvydw+IyFhlLW0NOuz/fClB7TedWOzGe2nNLgcU7SMLH0EzZ7lD4jWSM0s1/Et9fskc6C9jdriYB+MHxt0fHJX19bCMg6TU/60k/4NKJ00jNEYdFBnbs5GgqhT4UgCaAy5fWATzP7EkgCFrGrg/w+06AZbd5/cwAF7lqyUkxZV599+Jx4QVWSdPayEKMwG+lepmTnjmtWUpFHEWH+MW1G+KL5XoZDYsG6BBPFDPlz/AwQ867unS2RzGIriGsrPVna9PoxgwYurzxth+mk47RiLm2zT4fhaKmYieNrvsHRZ/WpUDdwyq4nbdzCSORiJ2m8G9p+PdvNwiGVc8oKxMPw8wMMjKVR/Z6tD4KyQGfWKOEF70/kiLjP55mMOZCID9zWXniA2c2OS3oFzgSJf3tSprjMwTbBVGv5QXmUjs+pyJ1INciWmap2sKv65DzAVsB0811XXpjHT+7PA9oVsuGC74o1kypUwo5SPd+PLUiDtqHmKzIfwxUKgiiFFUnp9OBiLFeFxn2+6X+vuqdgmCmKsLwXLyXYFfTMK+0+4ypfsZHMl3oFYkMtGMHS5Sw/CxYCtiIMazSzvyMYUonbYbM7VhIUFt
 lp+bEpFj
 BG4YlcHMNNnsbOVssUry8fgDbOX3dGbrjOrddoPw9fvkZMgNAGDyWr6obGHhygrw5Mc3Z7PQV8DoCq5bwFbal/s8rIYqqIjnQCRq2H2G8V7beaNlFN65+Y25eCg5HgVW/PHfnaEDk6KjISTO8vob+p/CEbLj6TGq/8QvJTTlAhSmDV15jCILKrqBZYkJ2g1+RNlZmae5vFTcG+YygbcUsgkoJjdWlgyS6Xk//d26R7sBBPfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/06/2026 14:34, Michal Koutný wrote:
> On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif <usama.arif@linux.dev> wrote:
>> This split is the first step toward eventually making vmpressure
>> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
>> (tree=false) cannot be removed today immediately: PSI is not an
>> exact replacement for vmpressure, and switching networking socket-buffer
>> back-off to PSI
> 
> (Here I understand PSI is a different and differntly scope metric) but
> what does it mean when you write that tree=false cannot be removed but
> the other patch bails out from vmpressure() (i.e. nothing is updated
> anyway)?
So the first patch bails out for cgroup v2 for tree = true only.
For tree = false, it doesn't bail out, and is still used for networking
socket-buffer back-off. I think that is a whole another scope of work
switching to PSI. Hope that makes sense?

Thanks,
Usama

