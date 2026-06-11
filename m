Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B20CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2A06B009F; Thu, 11 Jun 2026 13:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53276B00A3; Thu, 11 Jun 2026 13:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C901D6B00A4; Thu, 11 Jun 2026 13:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B63806B009F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:21:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57B681C21C8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:21:56 +0000 (UTC)
X-FDA: 84868299432.29.17EFBA0
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3A258000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:21:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QHcieltN;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Yb89dnim3jwXQsF33yzL/m+QYNw/vWjAYzs6MeYtKM=;
	b=VqZDmsqgdjkBILoh41P7+wIc99NMswJKaGW4vq/8Qmc6ZhfxolNwbv5b+hM7t9iBr7YVv1
	wD9xfNJGWtYq9he5Z95+19Hq0I0aDWKyBLuTYkBVq6A4mz76lC0MKjU3vuLsEjqjCGs32r
	PDkf36fZSkxqIHXxxgNHgWw3oN/V3c8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QHcieltN;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198514;
	b=TxM+nvLFfzkdPe2NtmWP0baEd1vgDf2IO80ZlP7G9Vr8gicCFlPICwNX9aQOzDCb47TmSR
	/41ltW2zNW7+RbWqjsQaXzq5iEqu/zsbSEzjBH78JYg084UVvMgH6icJfi38zDFkRwbWrZ
	K6GVEV74yA2GYPXnbXVtIfe//JU9mag=
Date: Thu, 11 Jun 2026 10:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781198511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Yb89dnim3jwXQsF33yzL/m+QYNw/vWjAYzs6MeYtKM=;
	b=QHcieltNPLyCj0doMAB67sVHLu2JhfhsnDfAxc61otPSi+Bm0Gp39yKZFr4vbb89v0xhNa
	b+eRQxHN6ksv8sJtAfXWxi9riE+TggyCxkY22OMoMlQicEZ376fzEW5D7j07Iy0YUj8FIS
	Vvk8zooGke9eFJLBHj3f6znMIYsVkyg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] INFO: rcu detected stall in count_memcg_event_mm
Message-ID: <airuQ36pKQ8x8CZk@linux.dev>
References: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHPqNmzgCY+sHOOG8YVrCFO-7oh6TBeL4SCHEcfVvH6J1SUVdg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A3A258000F
X-Stat-Signature: 6npcmrgagn8kfmbk9edaas5bop49ii1y
X-Rspam-User: 
X-HE-Tag: 1781198513-175620
X-HE-Meta: U2FsdGVkX19RcwzmQ09q+m9p8UN/nXlQIiUh1bp7sRig6xjssd+Ea2Pg903E8pqUfzqPSAPzQecOxgvFeoTU1fIw1sqKo9WRSLd/qVBsZxLe6anvh3BTGqdPkZtfXzcIlnNaOijhDCD76MhcxVq0ssZXlf2mqneLUGXTt3fohFFfMnuN8y7ll/2iHG4B5fsS3TW3l7kmYwRuuAt0FSAQjfHAAEwp2G9xPhz5eUHlPT0KHq51C3SZw8qzkXxcAzdmY54toj3v4bPEBqlzKQV+CbsFbs5Fq/HWni06XrxRL8kt8wgfqLQ+ASswbbcTVrmOEIeP/GXeeIKs1PO08euw9Ju0psZMF+PPepbuErrI6vKJxqpgM2llpHy62Qb1aPAwcGJlOA9j1o+E99D9rRqBvIGfqf978ZGcjjh7SY5MII26bpLUdGo6WMe/zzhw0Hh1Fjy31XLHl3btuaXP4oF6A/mRcsZ10i6nH6LXtQvBnJ4QvI9DFg41dY+7cf+QnkhuCew+fpnPCGDfa7I2Wa3O/OarA11Gqvp9P18NG4HXT+DidDHQa/XdgfakEN6TQHFUn+GeVvpC52cgiSm5EPiqByySlqMEltk1ToWkH4HbSyp29hFDJBtOh+iY7nacHVEET4c+ZM03uS/hvrLjZpI87oZcVjvUf6p44FJygBFYkmDNx+gkOSPuX8X543V7VwjgRIaSs6YLjTEpyq4WyJLNdEdSdC9KblravPPhfgPP0XYFIFZSTImZNpP0WgLffz9xuqC5MGTkbuLqHy10wfrBa/eoLRYh0Ca7z9rYsWafiFDyjfM3sKDY0MT81zqlQOEymk/1ok3PYwTaDtOVV7G9/NwslWY/Em0pIonVUCoKdfQkB/Q3xwXM2LvQlSpD7z+xKTy++sIGGrRZhW5NwK7R9UPSW7wDg4HXO25EHMMCZdaF1Lgp/VOtwfn1sFD1uvDLkmIGy61UUaUWVuY2zVM
 1EWfKl0+
 Y4iIgGr/AZPOAUazUGXazl+Oge8TJhaYgbg3gyCHM7aW2b4EaesLTHqn9fqkyj4ujSnKiA1G2T1uXjsYvODOON47NKlvDHfQi/XHCorXcRlhuTjwCgFejsMXqpBvRoGmeohaUOTYwghf9tWSTHjoteWE/NhFZUVycrt/4Jh53htgqPrbQQrVALmOl4dQfR1rsqg7BdZ/nAHIHAMsIXtsSFju7rM+6AfsnBDrleaRirsCgX6rAQ4o3tK97ZvZO/Y6RVixS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Longxing,

Thanks for the report.

On Tue, Jun 09, 2026 at 07:57:56PM +0800, Longxing Li wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. INFO: rcu
> detected stall in count_memcg_event_mm. Details are as follows.
> 
> Kernel commit: v5.15.189

This is an old kernel, can you reproduce with the latest kernel? Also at the
high level this seems like CPU starvation. Can you also describe your system and
the workload/test which is trigerring this issue?


