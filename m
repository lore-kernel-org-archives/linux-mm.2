Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A770C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8CF6B0088; Wed,  2 Sep 2026 18:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A97F6B008C; Wed,  2 Sep 2026 18:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BEB36B0095; Wed,  2 Sep 2026 18:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E63F36B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:05:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F3691403BE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:05:05 +0000 (UTC)
X-FDA: 85170203370.25.80CB0AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C086E180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:05:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NvdhBAgb;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788386703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q10ap3BJjJmXb1B2/mUS9+xzKZ0SLxvApYs4zp88+e8=;
	b=KHQ8riV7s48SDd+lPyLiPppQsBLvWDd1z1TNd6mzUfvpdLqnu7sA3BWaOThqmtB1LIwiUC
	7rCjx1iyvwZKUUCrtd2VEBdotwUo1wBpKskTjJogdHLrKS3ALboo2tRwRsOclQgBfxcZRw
	OcmB9EMRvwZWDvYGaAbibLrbmZKcnBM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788386703;
	b=cHffo9qK27F4fpQlz7bvPoPKHXXlFOS43KNSURa1PEr8AWmvJJfKBTpV0wHSRHqPu+Kl1G
	TzmV9TmZMH7AhMfEZJG4PLGr5r0FPNBHOIaUh9jSkIr6cd8Fh4uSWhjbtsGSFIe/gsuzRI
	uYQHPYNfUNqJc+MueTRmOR6J5TX4pM4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NvdhBAgb;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1268600D1;
	Wed,  2 Sep 2026 22:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB681F000E9;
	Wed,  2 Sep 2026 22:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788386702;
	bh=q10ap3BJjJmXb1B2/mUS9+xzKZ0SLxvApYs4zp88+e8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NvdhBAgbgO6F3L6t0gQuYc0SqaEJhHiwXKzF/hHQiK9xpKZ3bv64aofAX8OqJvWoa
	 nwXT23Hi2LTwfMTAi89Db3NSklOK6zLHYREM8rTDie69CHVqLePeYIu1ZqSud8DEmZ
	 /ELfN7dp4BsyH7DYmey93odUsZTGAfoF8co7mRxw=
Date: Wed, 2 Sep 2026 15:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen
 <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, Suren
 Baghdasaryan <surenb@google.com>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/4] alloc_tag and module codetag section fixes
Message-Id: <20260902150501.d589742ba33d0beeb0cdb21f@linux-foundation.org>
In-Reply-To: <20260902081802.146145-1-hao.ge@linux.dev>
References: <20260902081802.146145-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C086E180003
X-Stat-Signature: 637yg5uqfpuryiyq8zi1853dacamf993
X-HE-Tag: 1788386703-598379
X-HE-Meta: U2FsdGVkX19E9njDL4cNWN1piWFYXku/M0JybYiIQcKnVvEfY2ZZ8KL/BgfZUI2hbkWfRuJDE8HRN144580UKC5zz6mLo66tk9G40/Qy42jW2COaMA6FZr8TIdK7d+2tGyBpSgUfou397Br33UilHORyclpC8NY84epXUuuXEiitUUIZ/3bkxK+/nnpg/cHuXctVKps37Su8lqFmOlGDBxabsvv1TF25kf4p7vkoHdTobYpgZaCboETy7KS3GBfeHc9omS9tNaEeuLN8xsLJJmMf9Kr1XoocfU6fHd90RAS1ySkfUbKo+06QqJjT899f41vCdrOzjMZZfvBQODho0eW0em6LZtKyASCu3vu2ka9Oquooyzzv7GN0OdiaZH7kFoPxm5t9KHsWA191MBbzaJCE1nNPCQJ9FQvi+uHee1Z0i1FJ+5FIv0N/J/qNVASF2HNyOlcLhwGK0MMw2QMTnySyZ7DtN7Es3DY/IWcQGJXGxdzITsZ3o43buZ2HYvkwNgZILDw0rBe808BhpcTd/mpQtOshZlz5EvuxVKDU2kfcneCDeXZdpxhBGxC2f/ovki78+JYRp8IGnBLnKul2DSEaMF8txMhoOmpoq6AZP7XNrF/MF69UXB6sIcVoEBr21vHy1nDnq2N9RBmN12M5dG2Ss5tUDfKCoO+En+fBns6S/0/zvswUF1iQkkP8jUw8VEDoUiEQR/mD9MUjHuIVU0OSTF4v53BLeHAHJJxEbno0ztaXkeQq7e0jR9OudkR0GoD90IUS5Xrc2pmNL/oDSQmTBXXkbDQ7cPNNj06M++4MpJP1Qov0fi5oyeQvZxDXGIh8coVHD9N7I1jdEc3WYlnITg1gQedABgswXT2iR7C86Dk5Jj+DQ0Hf/FAwtt3JEI2RISuwc5j/EkcP3LC/LUS3wtdLN6zoswxTvhxV+k2GMlzeZN43ob2hHfDLFSJ31Huz15Gw76sbt56c5zF
 SKU1JFaP
 TS35cGCCCSuEKvj8GSdbZVsYmcNs7mLjVpva0c2w6fBHB+ZeFsPEsH/X7QeYb29BOkvgYXYyfWJ/PexSJVmDG8xfkHhRJIVETzELpDTyMryBDGNX7GimyhPIzGnLhaobBPTuL7TyvnIV3DvqhKLKm4I9ZlxsfTNFLaxqDcTuHTUtSNJfMQhnOMJP8wmrZ93UJw2/E61Ce5cTvo09vmYfrIf+TGacHKPswami2FYDzXAWgXpED9T8ixolw9NhiPP/BK+hN7DbJVett6ac7hZ33E1jCykLkHd3OvNOOgM3EHKkPIc1t2yIGUaV7frLl3ch2U5sbVF9yIH0I+VcwpLsgzL3W7zF+QkWHvJN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 16:17:58 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> I ran into an overflow problem in the module tag area. With profiling
> toggled off, the overflow check in reserve_module_tags() did not
> run, a module could load with more tags than the page flags can
> address, and re-enabling profiling then silently corrupted
> /proc/allocinfo. On overflow the fix shuts profiling down, releases
> the reservation and returns -EAGAIN, and the codetag section lands
> as regular module data in the same load, so the module loads without
> profiling.
> 
> Review of the earlier series by Sashiko turned up two more problems.

Thanks.  Sashiko had a lot more to say, as I assume you've seen:
	https://sashiko.dev/#/patchset/20260902081802.146145-1-hao.ge@linux.dev

Also, "Based-on-a-patch-by:" isn't a recognized thing, although it's
been used ~30 times in the past.

I'm ambivalent about ad-hoc invention of new tags, although it happens
a lot.  Perhaps it would be better to do


	Based on a patch by Petr Pavlu [1].
	...
	Link: ... [1]

?

