Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7285C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 17:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4A46B0093; Fri, 18 Sep 2026 13:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4C46B0095; Fri, 18 Sep 2026 13:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE146B0096; Fri, 18 Sep 2026 13:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC006B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:14:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FBEE160747
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:14:48 +0000 (UTC)
X-FDA: 85227532656.08.F384266
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F6EE1C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:14:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VtLwXeno;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789751686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N2EBrOEPhJDMG+Ue8kzI3utQ9aWttoIiAlmCBoRDrZw=;
	b=LwvyZNmIhmtnNOgcYNIph9Eqsfm7LiN2Jdof0DlHj1P0NdQI2/cP3wlumL2NlGSwGrbHzq
	b5Z3GBRF+kDl9ljuWstHr6nnhmpTfd7OYDgPZBa+6HJOllja2yiHWgmqzzllV6kDOujiHq
	TOMtp0QiH7A7bFPLBXIE3loUAzQfs2k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789751686;
	b=yD/rt0/O8WaNeDxgqwsFyeqtCOWxiOUKNQw+Q2yBaRZCv8cizMMnwmUi7PV0W4iJxqOCBJ
	jg7tkcBDAJvYau6NmsXQ6VRxpFS8YLFoja9OfJcZfoDmkB7T6eTc2Mth9RDDmabZ6FzKZa
	DPgzePePLsbGP/RhCR43q3WCpwFEAJA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VtLwXeno;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ilKUCNcdIV4WAXoOcsb8yjDuQjldO+Yd7+nPVMQEjpE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789751684; v=1; x=1790356484;
 b=VtLwXenoZo7UkDBFwdP3YNhdV9laGNaweh7aEmGnZDcHQWEZiLzYqqMpuyPNKp9NCbfnuiLQ
 52CEgh2gcWpBa+7SpyKPXWNpeQbmJdLpRGBzsdQfyuN7rGZOQNOrlcp9wYKI7asXxoFOuR5x0fT
 /6POQAnWTbHBRAWXj9xaihWs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e631f011be8d44f9;
	Fri, 18 Sep 2026 17:14:44 +0000
X-Mizu-Trace-ID: e631f011be8d44f9
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 10:14:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
Message-ID: <aq1xZu9-QtHDO1SS@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-3-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918165601.1014666-3-ekffu200098@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F6EE1C0003
X-Stat-Signature: cwojh8pojqet9cxeape9e6eu15ejebuu
X-HE-Tag: 1789751685-481642
X-HE-Meta: U2FsdGVkX18Rx/rMeC9+PBRb2Xu97YCFmxTXXUwygD35E1S8ejruWd8AIUFQXJ5GDiZIG7lcLh6SCA55EU93BmSvPMy/wnWzc2bpzMUzvF4Fh1CML2ILldOQTdTUa3NVJqpkc5LVeTCQbNJeTc4EqPBw3OGGI4VMI2NXBtxpY0xvwxIlO1zjdHX7i2vnrkSPCSYLJaClQLaPRMqMuV7ekxRg1koRj6q3xZp5ahyqHizSlCRaYdEYqhqXfOSeB9904GnP2OhO3NgxD8urqqj/BuXnnlpjquMDJYSBhZaHyr2K30RwhEXw6D3ab/XP5TLpkBeEvLWce9FxozBDvAoYKsKwEENqt23lui6oGDBObFf4anMw13TOB1WPxGS1uPw0+YKf8wDJ/AcIox80MrPy8rqogVye2P5ARg1TiR6dJXYsV7vUTHBLzXLGDJEFVuo/cGYuYOw52tLXHEbsNoSgtbgu7KQSE4zXHxL7qkRil75SMMHa4fAgyj8OdGOAH5faPpWFME03qVcUeFGSdw47ShNrM/mAnFAIe73m+g3UI77G13Gdpk3Fe7NWpNnA+WQWl3LFT7PGZkHVQ37dJP3x6bwm9EMEOwDsg5CWG5JmkYqWzAYjCCZfBoIyYHtTxVzJRpEdvLdnpGVS1CDwFrsQd1bos+LLvSMWlOshasMJqb79ZnXQhBbqEIi4lh+x4LA+S0KYwveGiSAMZt8X65hueXvqlCbaiW7yk0YQItTATytI2bS8BYZSfoSt1E/xJ1AhR9FuWBEWG72fA0hqTQw/2lsxqp/fuNdJQbYm8onIHUssdYU+4+Gwj2iXQ1uJ+iA0821N4KYdTm68TB2f/yXpR4+gvwzFGnn2AXpjj4DPEhnbpRGNR2PnixyhNLEKY3j1VOOv3AzVx02hWTAzitrEUcyqslykVs3tDJtgKOg7p6DzoR3i6HQiUzLBT0/WExcCYAsR8EyPU88TJzVL/q+
 HCziUTRD
 8629CzaB3r/IWwZ/Bx752J9bYoE5IuhJS4b/cnghe1HvRkb24uMomH4wJYhWdgyq1l0CTdrFq1Sz7LutXkBlHuWNqkKArXJSQgv0fnSqeYswEEqb9ydANQ995UzJ9wFF1CoPcF9n7aWarAIdFtQPdcGHRj4RPWpUby92MYHy9oxwDBHkYEE4lzRNBWr9mleCNCjpcKUFG64tcH0oiBFx0jtLlV2H5UECG9Q72zVaUwWG6cVfKDCfKCntL56gkGVhcdmd5J4GvJ15tZqxuZ24eceL9OOjfdRIm67A/FsOyrV9lyw1vw+tTVJFwGxhEKPeQnY+BPVLRHDoBbnFtz3aU4RwSEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 01:55:58AM +0900, Sang-Heon Jeon wrote:
> Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
> vmstat counter"), mod_memcg_page_state() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

