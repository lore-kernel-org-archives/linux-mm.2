Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDD4C98330
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 20:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5015A6B0005; Sat, 17 Jan 2026 15:01:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7B76B0089; Sat, 17 Jan 2026 15:01:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA636B008A; Sat, 17 Jan 2026 15:01:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272F26B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 15:01:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA2B4D1BAB
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 20:01:20 +0000 (UTC)
X-FDA: 84342525120.15.6CE8417
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 164B5120010
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 20:01:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vsbwAn2H;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768680079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIAI/J9JoA2qY4ACb7rrwn9F73GTYkqP3ib203Y7byA=;
	b=ULLyWZw5pTFB7zbyVndxPRYYOtdjaaLtVcG/K3pkvsHU9YMVO546z1u3mye6tkuqx1iUt8
	9gBDyA64Cu24OGTbBbDmCucQ9HYuzqqSIhV1njmQ72H6Y4LbAcGyc+eodT9EdlartAoicv
	FJ64UlE/hGvcCe7+aoBSV56+hQ2EVNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768680079; a=rsa-sha256;
	cv=none;
	b=GQlkpBrSQ3FXR/4DmiY5pyDFbN9b/XfwXu4Ln3tvphwxN/BDdHNGC2BLiKzM5/l36WIBS8
	ToGjdr6OKoGdozUhDDHBUEeJPhLej95Ka3eeBS9tVAsjwEw0EBr4BcTMc5V1qB0gVaaUSK
	+GHYD/sP4tVnRrcdvWrfJwS6iVy8lnk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vsbwAn2H;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Sat, 17 Jan 2026 12:00:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768680076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MIAI/J9JoA2qY4ACb7rrwn9F73GTYkqP3ib203Y7byA=;
	b=vsbwAn2HQlzPeCXjqaokL9JkWcH/xiCkLxNZ1alZhQCmlz4tjWL/KWTs3HJ8QsthQfxfqi
	hUwgufHW90+0X6BOHcdwQtT6dhn60CskRdD96pYoLW0rnAnhEZSFbrObP5Q/uJRPgAjAUf
	g9U+qMJL7QPMLp8Stxz6US+qt+pp5OE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <hu7mfsqyeuh2txp6vt5dvfsdrl37jeualew6slefyfqslg36nn@hysym264wfof>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 164B5120010
X-Rspam-User: 
X-Stat-Signature: rbxjcp5a85axih96wzwk4homra9o5ddk
X-HE-Tag: 1768680078-753982
X-HE-Meta: U2FsdGVkX1+dh94NAmRnKz4aluR8Hl071IpGrATFb1wgXzakleGzo/7//JQx/O74YKwdMwQ4uVK0UK69AsY4cbQnHIQxINAc9cqQ91/JMlxSy3c9ku/BP+goDV7K8H4PVn0fwqGuVK1Ha9XO98LEL+kPyRCaZyCQb9xvoNolDz1u5TskP1I+TUvkk4E3ttKMegX5Pqdk8xxmq7lSnd31MWJ44voAz3VmY4FdeFOCmNHcfmOX7E7joWCXApgrSy6F5Y6g+PiRNzs27mK7vulOeuZLkLdKA1aaoZX9kEOvT7cEW4MnzSHD9Qjb/VkLW8o6XVbU3EIAgSivicYrvT/ZV0Iu49KPLC6OYgvPlhFAy4/vB6Hu/6e7Tfp3Y0Y5liVLTDsRTX+tqOeVjLVJpAyEEy5qy6UwkejwugjOhsn9nd8NfrnTmuGfIyZmBoBTWP+l0B67BJUrMxMofiIbPYRCzM9SZX54pfEVZ8Ql5YUGjrJb0ZbmKisDYMaVkFGgTeYPOUKp65Sx2B69RTx90ESooJn7Rdgxye0b806eQdvZNUOygYDnjPFJq8y12yJmDKQ3ZWpK4ATmOk5VPoIl2uWsZX6TErQr/weLMckxbDEnpOI7iuMfOAOhEzQGVa0m4W+ag4tvHZ/KIDaoTrR3p5DvtUlN50A3G8D0k7tM2DHC4bvhHGET8CO24LN9mVxNOwLSbxThondrYp/AbY/KJ8VjQiJAQNCgN0JUDV/7VCLhKiu3m2sEvMpVX46aRAMCsNkHpBlVYYE2Ds5q1SrhDD++j4iWIuSyFh4LaJ5VvjnE1fGLXVyfgzvy7CktgOrpu/8+y9iqR85PYxbhAgb9WG6LkKsr1qZnZpr987uSBtiJt/j3vSTT7P5hBNqKvJYiuU4VPYRxXxjvwPu1cQm+MzP02P6leR4G+F0o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:35PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in get_mem_cgroup_from_folio().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.

This patch is adding a retry loop as css_tryget() on folio_memcg() can
fail because after reparenting functionality the folio no longer holds
down the memcg. Please clarify this reasoning in the commit.

With that:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


