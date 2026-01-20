Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6056D2628B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6A76B0492; Tue, 20 Jan 2026 13:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075196B0494; Tue, 20 Jan 2026 13:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE3956B0495; Tue, 20 Jan 2026 13:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D98B66B0492
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:48:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 848B814070E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:48:13 +0000 (UTC)
X-FDA: 84353227266.08.0A79B32
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 97E3320006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:48:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ff4gV0uz;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32T8g5Z2a+COFbjzTZpCqoJaWL2em40m0e1QJ2DjQH8=;
	b=xs5ZL55gZr1fohw2EZbiwuIp2zQUT+j31tg1yxevgtBh5W1gp5+tkga0mNCz+bAKqfdTLW
	5pr0ryeoq0y3CQBb93N47zQT0cZx1hqx1IQJmYh6d+oBB7QpzxzZJdebrNvS3kP+ZIB5AY
	XWRJR03fZ2ios3TbcRtS3jtWGUDjm7I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ff4gV0uz;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934892; a=rsa-sha256;
	cv=none;
	b=h+YaKnr5argz5Wz3sh4rmdnuadV/UiAvBApotxn/V/CY9jj3Z3whu2aIKS+w5b9s/A6IIh
	sIFqsono1wgTEN0VgOzrpmLDn7Wc/FhRF5+JJIhYzImVm7rrNzjvTTtcG0hkp6aVAOlMDJ
	5X8Av/Sc0GYUpT8DMPHsW3CAGT9ycpM=
Date: Tue, 20 Jan 2026 10:47:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768934889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=32T8g5Z2a+COFbjzTZpCqoJaWL2em40m0e1QJ2DjQH8=;
	b=ff4gV0uzB6STXVulXC+E25UKJvOFC6aCJVpX6bdgvUuTTCrXZehmVzbQKhVwdZUleOTWDy
	SXvnLq+K8df3D8ul7Cvt6enNm4AynJEzsdiAHlK3bczDr3npBOUAzqRRA6twzaG1ymUZWv
	oDFdLhF/nqFKH8xw8rUbsfh2TPf276w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
Message-ID: <moupi2ch2cpuyrurthk66igh275ks62pltjk2zfngxozj52oxs@64lxvcgh3ays>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
 <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97E3320006
X-Stat-Signature: 6a5xpy1ayatwb5t5x59ceewdupzcgxic
X-HE-Tag: 1768934891-183248
X-HE-Meta: U2FsdGVkX1/NANoNli83ehMoWNd+zsoowpPRAZvKcTAReY+LDNdCi83e5VWPWxs24oeWwe5m8Frqrs3Y5G2r+K0AN2gzqqsG+oVaKpPt0I4OdVKCPOJJNjtlSpduU2iG7ZopASke0lqAk/RKtSkbw1NdBMthDgpiXLpFmnMOGsMALkHQj+yjxgRA4vGHe9ZAvL4Ufd2tfMFRsfsiYz4gtxEEPpH5UitUbJOX+C5V2+oR7+Vr1z7Zw6zNa4bQLEr353cbYaoKr9yOzzHxnbBq1ljy1AoHasLuRblXdWXJ8csg1PPORkbwwAx3T+ROR25KXioba0ZV+cX5+Ycnq5IbTkK4xp8V8ppBoFVn/M7Rvxkl9/tkqGsV+k7qgcu9IhHkzJhyui18SXRXclm1gSd+cNrKa3oYRxdYbi8v+09ZZdnPi9LEv41i9sFAEbTSg2qp7JGJAIHigV5xhC7lcnRgvFwSNJlzr/yUPiD+FVPhfHY4TmmUiNytJfTYItLNWY33+JByCBO3u4cKfpOmCHM7s9qeQguz6BqtOMrc5gC4o2cKeh8pRfhJhV3ZqHFoflSxxII6Gm2kqakSuAJvslBUnpPUXhMJDJXqYi3tJjhA3Ro/KscAM8W80mo20+Kr/vwuYbKKbFHVbtsjRy1X5fJa8twQo6co/El3H3B0i31/UEmoH4Mn+fWuifXShwSSU/LWhoqKg87vx73Fixk6sHWS1P7LtBzWDIKFXAjUkTbxcE3ibNALaDgsbThufFApPGSLgNO61BWMmhHc49aRe0z4EalGvYfl5NIWLY8d34DZcOHhufon1X68afdafDuTL/CjEv5hQfKrtsir0tLR9WbpYioD325O9mdDr6WR6QAVM5dap8UYwNDZEari+k9OhIg956Sdkhtp6yd8cKcTKemwFLMY5oruu6fQUxaiHvbCML6gcd8kPcDSoJqS28RtI9kiRAT13qcY6NzRtFgh7bc
 cnqJKvcn
 vDZ0fS2bb/LmXBGkoqhmdOd1oXbcMYJLraK86RoyuTVfuNBtJxJo19M3HVqL5wED3oOHpo3XP/dh8cj6mIAczxKUMaHzGEap/5UsgvqW+MimSOmjof9cM7+9w1FqFmAZXq+8T9lRvwO9XxpV49Shcl7UZ5kG86I2VSG2iZ9q+PlRwOCR2Q60n09PAAtr/87ort04vqvOnzRa+Ov5F/lDRJ3/kGZEIEssvVOueutokNqw4grGDDeInrhRAiFX8oev39xHn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 03:19:00PM +0800, Muchun Song wrote:
> 
> 
> >> No reparenting local stats for v2.
> > 
> > It seems that lruvec_stats->state_local (non-hierarchical) needs to be
> > relocated in both v1 and v2.
> 
> Here we might need to elaborate a bit. Specifically, in the function
> `count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
> LRU and SLAB pages seems to also require these logics to work correctly.
> For SLAB, it appears that the statistics here have already been
> problematic for a while since SLAB pages have been reparented, right?
> 

Thanks a lot, now it is clear and yes it seems like SLAB is problematic
but now I am wondering if it is really worth fixing. For LRU pages, how
about using lruvec_lru_size() defined in vmscan.c. That would at least
keep count_shadow_nodes() working irrespective of LRU reparenting.


