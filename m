Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D48FF4927
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 01:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B666B0092; Sun, 29 Mar 2026 21:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403526B0095; Sun, 29 Mar 2026 21:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F656B0096; Sun, 29 Mar 2026 21:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23A4E6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:32:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5539C8C20C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:32:55 +0000 (UTC)
X-FDA: 84601005510.23.5C5F2A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 818ED40009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:32:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0S5pvcc;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774834373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JB/k5qaQ9QJlYtd2vur+zHSkKyFh2QYO/2MlQZcz89Q=;
	b=4wIdpNqAnDiFTYXB/S3O9PQlhN6xO7qHOKRc41+Y8SOXzv2IKy3VutI2QEz3Q5YPT1jJtx
	Z1CCr1HNDTN4boRO0PT71OZr5xHjpgzIvrzZf6JByduo7RnlldHUJW0x+/58AHecB0XeLN
	qJxEeVY6z1RrLD4B6GU97w2bK2ss/AY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b0S5pvcc;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774834373; a=rsa-sha256;
	cv=none;
	b=u4jAU2kWfJEhOESNdsxOm+ndkiKBZWZPH3d1A85DcHylSJsrFRCpi2vxkdRHY+PjOap3hM
	nQpuLe6lAFMoo8K8qn+fHn6ovYslYGPydWS+/hZslrA84BjOpes1j+EYxaKasqWEaLprn+
	o9Te4PmKyxVMkDYG9w/WI9HIdzKy/ac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65D4A43564;
	Mon, 30 Mar 2026 01:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC218C116C6;
	Mon, 30 Mar 2026 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774834372;
	bh=5Y+t+MMtsA2kRKlu7yUW+ZDUXrORqHIVBhIHlTBE8H4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b0S5pvccwm2rqFD79GDl7WUA3OnwcIHeJEt926WI+bVBOBoa30Oib9f3dgkn/QxS8
	 MAUZLTJdGnkTdvtdQl1ylP6bStvI1esAut1FvqGnDb3gqh8gqFZ2Oreivw5+ExZ/Io
	 nzYHY1WvTiLbFdl+s3bNFTsBCCluxWHYGpjq6z7ZYZjZ6r4/nhfvyqTr/TDwLEJhog
	 3m+4Mwtqi/b5vqzbdV6Y1BWacx6CGUMOm/zb3xt/II40DfuoIhYDUyafgxh2IpWcJ0
	 RtMwzOn7Bgy6mamsLdYxph+ocTfwYAIEc5zFY14P5KeX0xh57bWFLyUipFrg6YrGf4
	 //HRdakABfFiQ==
Date: Mon, 30 Mar 2026 10:32:50 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 3/3] mm: memcontrol: correct the nr_pages parameter
 type of mem_cgroup_update_lru_size()
Message-ID: <acnSwgYE9BWTBmNj@hyeyoo>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 818ED40009
X-Stat-Signature: a4gdpqqgb35bkgwuw8bzzrb819womnxm
X-Rspamd-Server: rspam06
X-HE-Tag: 1774834373-980217
X-HE-Meta: U2FsdGVkX1/pSPfrnvlCDk1lMJKQFkrOHw7zpzJK1xHrxc6dYafNk67uCj23ipg+/lNZRg6D9e1wRTIs1XZJV9O59ivpHZmqUct+DVdS4Fz27IW1OnE6SDJr5VojGFBsfbMphyz59Ao53hearNiW6tNRN4qJCO5aeV54SzF+Sswax2vZI5funR/GgYXQijXJJq1WWkCurIuArpp1iir0xDVKFULFHcS5X6SU8Dhxa9aWzmRhVHiR8vziN8swT2fpqMxuVumNlNRfwicDcdWiLB/SYwJO0R4pFbQN8jQ4gJ7A8eF9fZYkOYaPIDzLrgqwA1cbMeRh93bvBWXWzMccyi4agSNV6V/aO/E0aXwvTkctlPOBUY8vBdnP9+EIOj5U/D0u+wGYzrHfv5OtR/sMtSMou6RA79p4lJcPIafUCqmH9j/2Iu8IXXcBb45zcvVBYMLF1Kb1xuE17MFOCg9a6tjTsj+qRfkl2Nxt+lDUcL6q0VK7s4ev2CzOcyrl3Dy7fJgbjygaHnKTtxEZvIRWoUrEtnwGZmmtBl9mkZF0SrBsoLK/fHK35CGnXsuaIdCvmj4uQ5aBFcuZX3JqmGlievL2ijcBOt2aXlmgdoMm0nAR70VV0Ngi7k1WfiSJl0eSwPgBQFPY657lRUb/Q+6W7XAYoeECDSbcr4DxdZ+Pk40IyGPTSBEhb1ha1k1YaR/hXx/KHV95qS5Rsl1abl0NNnPao0kuKFNyrpx6AROTDIJtt8mCk6ZL0HbHXGT9w+tMDeXKHb4Jn9Ot1c0l7RO6/Rf+QY8ETpWEUsi4NEt8/ZiBSG/wI7I+n6FRAAcqCOU+6OgxNpJV3/Yvx4mBT8rI3/TAmHc4ncHr07Ryn1uAE2I9+QZXhsJtKR+QLsLH7xLOIaQAQ3WKbvGgMPnR2YWIhehW6BaozmtJOJp9pvOqI5RFI5eE9Jh6RF96B3qtDpZ+JrspGS87kXL0zlEwmMh
 LQ4/8OYL
 oosu0Bdeh5aglV3xxR5oHp1DXiiculBte2+JCgGFCJaGoiXu153JnQE5dt4B0ILjzb+BahSdsXFTowraw1hL8s+CxBx0DVLX8vWJ99Ejl7aUBi+drCufNI1IwnsrcjPtzVdJeQgu+b97x1o2RpTylDOHHpi+Aa/7sGyW/UlOhJG2QjBVfIE7DRQoikQgFdczRnsSqkgs9wBXQgDXrA2Z39EeIi7MCAjMl6ThoTy1N4noZrEU8tdQRudfO8Yf+vfKSgLBOlIMtxggAUUX3mdcv2CFRYKi3pzgt6G1WD/ojEFJp7dX8f4YIfCJFWBP1v0IGex3QiyrI1PJlM9f0TVZq++O/evpHh60XubTV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:16:30PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
> count. During the reparenting of LRU folios, the value passed to it can
> potentially exceed the maximum value of a 32-bit integer. It should be
> declared as long instead of int to match the types used in lruvec size
> accounting and to prevent possible overflow.
> 
> Update the parameter type to long to ensure correctness.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

