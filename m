Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D66C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA8C6B00A2; Mon,  7 Sep 2026 03:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281DC6B00A3; Mon,  7 Sep 2026 03:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198286B00A4; Mon,  7 Sep 2026 03:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED2086B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:11:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80AF3C0683
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:11:07 +0000 (UTC)
X-FDA: 85186094574.26.433B610
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 47FE420009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:11:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=myjIoRI1;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788765065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NYiIdoA0clTQtdI5G5CycyM+YaApfB4aFiNuht58Cs=;
	b=dGAzz2RxSwXC0M/iXkgbsLR1gv3LpMZzC6e4G4x581jO36216REqXI3X4B51CCAHxKu5Cs
	4eUyhO8z2mG9Dw9zhdPC8VM7NKZy14EU090onVpF9pk7a3k/JiSP56hdHwd0fCGY0yOoZ/
	zhLpQxRUr4rX//H4zy3AMMRZZHErvUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788765065;
	b=StxCs77fFcL2GSsSmyUJIGrmzNe5jI5FvjJbF8d52LdPddQlxlm3k0E/H2B6HZuiD105Sv
	zBdWquJ55Y5MjO3Af1YU/uHT8xznwBqkL3s08AIs7ObI9APmy7cOMf043vXmk4Ivj+9W8Q
	R0dcZpijObK3jQPyGbvUMaJFguRaoHA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=myjIoRI1;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788765057; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8NYiIdoA0clTQtdI5G5CycyM+YaApfB4aFiNuht58Cs=;
	b=myjIoRI1mh/KNXuOlUnOF1hTMQA4Ey1eosSFYCrX/fnXjR+la1ZKOwkItyUXyf81VP34m+j3yTlVcOIi4ciIXCqZ/Qn1VXN8fYtfJgbY0p+TJFMrGdRwW+rXdkMsYnX9WEupr9yC1GAQciMyV83UaKgr1wS741hR7948/NtdIBI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAQvWM0_1788765054;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAQvWM0_1788765054 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 15:10:55 +0800
Message-ID: <78b338da-d700-4457-aab4-8b051343c981@linux.alibaba.com>
Date: Mon, 7 Sep 2026 15:10:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
To: Qinyun Tan <qinyuntan@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Kairui Song <kasong@tencent.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
 <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260904033503.4067283-2-qinyuntan@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47FE420009
X-Stat-Signature: otys9u83iuua7sujcz7juyt7xmm4g7rd
X-HE-Tag: 1788765062-126862
X-HE-Meta: U2FsdGVkX18Ql3JukXtgQXDJkWk9da1XtgHmmH8EIcObthh9AHBgml3rA27zpDENnKMFYRiR06koOGqN99ccs+Nwbh0bbd1v02Ge/FgYf7nOhSHHLhn9yHzzFVYfb+uqZRGRJWycjiCQ+3fGWNi0FondbpXho16pdsGf8QadSSdoiPosqB/6YEw9G6xrejzGrYKVbheL+RrUETPtRbEiXMHXP+HD3Hdokvluc4gFFA8RJA28KbiprD9hJSMRr2AU3JY+70C+0QcrS4mU+IYBdfxLxDGq8wd8DyaHscTMAt1TlhpMJdV6yzfQbyIQkVkHJOhrEtfsRq2+9Q37ohBrlhnXzG7j/GDitvxvxBfe9lcPum5Y0m/Bfxq2I6EKv81w2AtNbyeZhMFfAM5t1uwO8nu36IKycEHLtFnqhV2NAoz4GtAuJb0WPQFlgJPvfyAmiFvYmsz/5RTW5U/OUYoYmblIA2L1n4Vjn8njufWW1N59nUdx1hnSSrTN0TCWakQGmDpU3Wt0n3l8h9CF3IY+n4FiwcAnEA0xYZfWJhuVjd5YO7sRHTCboTTHZKq+z42bZ5Zp72Pmtx/FgDuyLbJYh3FCJkmaNu2MuBIRTaAC8lIbeshjxITH29o69e6L7VGf5pj0v1guCO+wgEVOSSlhQeDd6BgtTS7iVYsMvDcnU+iDVmIZvOu4Zs++on5ypUOrAM/IK5ctMNVzIlYtS8Gb1idB2P5Vo+ray5jpsNdI6L0yPVa/zFN7Joe5x2MuRaCh3rvvDHUyp/BbtKDQ7Q2QovWGUR11EOsyhdfsmBig5WvJdH2HrSYjyy379XglDi+AgIbaZgEoB2SAh5jlFI8aGm+OgCDrwv13Tb29B8gvoLOf8AMW1AJhjuXYVqofUqP+YmZNWwzX8wUhFxgIP4FO1qIwtRAD32AQznklclbu2vbpaaxXKjecGR1+DNcYsO0GJ9+4IT6uv5zMXM6iaMv
 QRBvg2GW
 ycGuX+OiLoJZagUyV/0SHtDpBsENGFbxl9cvq5XPN2DqtO14spSf+22IOOViNUtuXNM5JKt37bk8Cea0lwlZzj4aiaAi9FDxMQ3yR/X36H6vJEe/0KXXuDauD5ppZEp4rQy/TIU8pDhnPyVH5rceMaPCrK8L3MJhyo4/9v5vYn1dvjEc9xru+eFeEXVXOVGo8b8B8wcSAMQNi849kBFAFoOL6KQJcBZ0BSt9byLbCc4TPrevD/D19O+djOBz+KSMSyVkUlBVgStGWU5eMdbHMa8iitNbQ5l1goX8huH568VrcMgV2kYbGn1oKWEyL1yd8QJH0LRPPhZD56NRONq7vkiXqGEy0rJYpm2Pf89HSdeQRpNgVlpS7IL5vIH6IxCnriMnvE/N8jZ8qwdmVr2xeM5vVBDeMbdVRDe6YC0WWhUYD9jby/AJBYM166SaJ83jhX3cXdLnR/NT3pUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:35 AM, Qinyun Tan wrote:
> On a system booted with cgroup.memory=nokmem, the deferred split
> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
> partially unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
> 
> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
> split shrinker to list_lru"), which re-registered the shrinker without
> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
> precisely so it would keep working with kmem accounting disabled.
> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
> nokmem and the shrinker loses its memcg awareness.
> 
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Restore the flag.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

