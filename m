Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471DCEE6B70
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF06B6B0005; Fri,  6 Feb 2026 20:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7D56B0088; Fri,  6 Feb 2026 20:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F12E6B0096; Fri,  6 Feb 2026 20:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 901656B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:28:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59A271390C4
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:28:41 +0000 (UTC)
X-FDA: 84415926042.29.D90C7C1
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00E4AC0002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:28:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n4EoziCy;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770427719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KiVjlTLbuL/enTYJjSv25CIgwiMxffKNXItGReEOzA=;
	b=oeUbGofD0/eHOy6y8NpkAHMUTH6pJkUl8Y+g8sXmtQYTjieBAozDIndvHSF6H5Pz0bsQMI
	g7Apf8UWGaM5QKPLg/H70YNJXBKDRMcdFWBrES1ns5m+RsUMSI0QyW5ayBrUsa+HLFPJOi
	SlYNVipYwIpXZ/F8Iayt7aElXWISLBQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=n4EoziCy;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770427719; a=rsa-sha256;
	cv=none;
	b=QgGCSyW0iDbdPd/JJ9j2N3d1Ct/HrdCMTfubBekAyG6/5EoQf5amPqEuUJjB2+jrUrn4fy
	ai9n5UwYqbFYuZu1N6ocPhGsx6jJKWhvTVoN5WiEBRq+0r6KCBsrEqE/Z9p1xHD67Hgdy1
	gSnF/7ALkVg3oGkq5YTZ4nlN/ETQMqU=
Date: Fri, 6 Feb 2026 17:28:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770427716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2KiVjlTLbuL/enTYJjSv25CIgwiMxffKNXItGReEOzA=;
	b=n4EoziCyzN/t2U4wGbUHcReaoO7DAa3lBUTeTN0xmGggQkj4GpFIifcNxOQZIPMpyqy62h
	Y8AJXjO4Im4zHX/X2ysMVeg9L6eLyZ/0bmocJOb/s16Srn72gZPh9TsRv/nm2uRGrP8Lrb
	2Fm41jY3+QZScxISbwECnTyZg2/k4n8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 25/31] mm: vmscan: prepare for reparenting traditional
 LRU folios
Message-ID: <aYaVIzw6cVUO72A5@linux.dev>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <26efe2997261631c951d326bef6a20fe0796c43c.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26efe2997261631c951d326bef6a20fe0796c43c.1770279888.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zyx85wmwbj95m7geymc3d18este7qe64
X-Rspamd-Queue-Id: 00E4AC0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770427718-771387
X-HE-Meta: U2FsdGVkX1/53G3t6CXjBk9+EY0Hq/F/w/hworv0GVeuBFsQD3/U0Xd87jbVT/AyJJcF7N2MdgQg3ZNVmmBMBqXAq5zsIvbVs4a8SfR+7vonGKcnEA8BLlr5yiKX8IOUzrUCxQz9uucrXNAsN2hkRUouryvgHOntWd9JbC905pYRPxWYGEwJlFey+R/MvJtZUXiF+pQaWouY7CLeYpmnH1NAN7I2C9fyzbnfpQ9KzlRvR/2rfCUZBG8lYppEIXGQEFch62eoj5Z0HxrkNzvbTXiFW8H7JXHnJL9bBC/+1CSjGs087/3eL8U75+m4/ZQPnEztcOkEfzN8/aquwfAwD2HJi5BnHqdukyOLTdHdlGMT24GZFW+0dkWjFFCzMfLOa4H+C9b6od5k7rqt00vi7qWELmz2cQIqvdLOMOwCBbaTMRP7mYTPkPMd488/ivw9p9VqQB70CqVRitC1jZHyVSQlt8312CtE5c49vdOhzK79N0UvgXbZhcJbltrtCazjMxz9ad19L6pJt1ik0yhOd2DMk+HZRFU2yk2tt/SWoOhpbMCVz5GJa8oW2820r/vUXZah9VVC3dPH4y0tYpwUqGhw2kcp1XVL9c4p/jxrLUz8BLhg6k+QWeGJ2+rCXDpZwaug7QPhGxL5iTChq6W5j8xm5WvtwZNxtR7wZMjaAhFtJGMLegmGRpY5DUaaKu2/Ybjb3xdb/fOsrnhY9QCt+s34hzjy3A4sNownxqCK1Eob3BpAlstYZPLkKD7qMeYmD3XzPGxSfxUl/eC1nrSX93/H9oC8yPaTywaFcmVyRrNrST9Duyg02m6AslpJm9v4L6mJ0SOPqzVjPB04RFgO2F20d58W1fnvnTD4BR6zcoHM7U+s8WoGMoRpE+cL9aEkIy/y6HhpgDlSFZs1DuAdQGCWWfGEOV9pYQVlh8UFNy0IKBc3FlnUuHt83wZqMoXipxXgw6X88fV3EV02waz
 vbswPNrv
 CW0NuamP8PhHHPG2XuCpEkhc3xSrmhJDGeRM39JNMl9U4+w8WJpPFoYRNNnz8aX3jPDu5egv0zS5nNkF2KUTr5XxcPpu4Lbht78XVemSpa8N6uvfhHc3FgJKC/woMply1TOc4vQ9PlV3Hmh/L1OqQFN+pCmyPGOzyvtH9vGSE7YI6buX14JBNVT0n6anF+6WDp9p5DFlvfCBQnFIan10w02C3k4KS8jtafhO4kxFyZLdd+wEqyCDslXb67Q5kh84wr6CSEq9OZE5RX/DVlNpuJrWyaHfiF66+SkdpqNaIUjkQtDIaD1DEsJck5jsCH6BZNTBqi2dAPypArhtMBYXdBv0E6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 05:01:44PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. For traditional LRU list, each lruvec of every
> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
> is feasible to transfer the LRU lists from a memcg to its parent memcg
> during the reparenting process.
> 
> This commit implements the specific function, which will be used during
> the reparenting process.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

