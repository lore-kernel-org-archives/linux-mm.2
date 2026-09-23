Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE78C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5C16B0092; Wed, 23 Sep 2026 10:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D086B0093; Wed, 23 Sep 2026 10:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3ED6B0096; Wed, 23 Sep 2026 10:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE91A6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:42:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 837CDC0803
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:42:05 +0000 (UTC)
X-FDA: 85245291810.11.A72FB71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D13B6180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:42:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcVZOIKN;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OR88A52FEt3lOkvnEZ4uK2ghKDHsLZlk+8865hLTCG4=;
	b=TqzA8i79l17eGTYit4NG6Eotm/YOSWLZREedS/OCy6lX6TnI3sAMbUN/2I2uaXhws3CXeI
	GU5FBVZwzhKaqsYskPMPKITyUzfzs0KLvtc/kmLMt7XnIJEcH+AtgwLzqQaS/wS6/Nq4t1
	rD8qqm/cHtzKLeoRYFsz2Vf9jzBtblw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QcVZOIKN;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174523;
	b=eWRAcj9EhNOIC350eQ1FCaaa7so9NWT4DXEVrl2tHuwjcNNg3tQn1Fmd7fq0CJrYhCR6Rc
	1bbaTnU/7INN94LPI+h34aJcMifKVQ/fjvlCQWtQpJvb5H5bfs0FggQT/sSMHIv7l9QscX
	d6MiSwTQ6XZsMNkDlTBF6G1cSyYgPqE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FA4443D7F;
	Wed, 23 Sep 2026 14:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2961F00899;
	Wed, 23 Sep 2026 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790174522;
	bh=OR88A52FEt3lOkvnEZ4uK2ghKDHsLZlk+8865hLTCG4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QcVZOIKNnkHsMtzRW84CuzwqKyR1jt8ezbPvTyPhkRFrP7wXCKIcZtML8YHKAvRZv
	 8tmDA26fqEmDxJfTb0y+7FMG7l/V3xbVf+Lb7TbfsfkmHqOA5aaZlKiU2WrAeA6Y9t
	 pcnLaQV66lMzU4Y5wC2VwGcyVosiqHCXAiDhNdpSMAeeX6M8n7+WKxuDhWiRExAIoV
	 Oj7a67DxYNB6ZqPwTJsFXTYRHC7fJRHzYhoadCScagkQlZFBQje8zGpCCdmC9bZqx/
	 kGBpayNm65fYIe0ijg8pHCeRLOl9lQ9EAGh+nN490WKqUDJbLV0B4tX7Lu8LOeq1Hs
	 0Og3Prdju3L1Q==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
 Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>
Cc: linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>, 
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>, 
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, 
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20260920084946.3266279-1-yuan1.liu@intel.com>
References: <20260920084946.3266279-1-yuan1.liu@intel.com>
Subject: Re: [PATCH v10 0/2] mm/memory_hotplug: optimize zone contiguous
 check when changing pfn range
Message-Id: <179017451853.5582.14450577931941446538.b4-ty@b4>
Date: Wed, 23 Sep 2026 16:41:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D13B6180002
X-Stat-Signature: t9zajzjwogxhfghw7wnoob3pzbihmbqr
X-Rspam-User: 
X-HE-Tag: 1790174523-947874
X-HE-Meta: U2FsdGVkX18BYb3FBDwfkQQ3Cr9Q5y8ReitNC9oF9wYCjvMyL7NAtRx1awkISjFp3+6ild3hqSIFh8spDqppYxoIQKekXzmwn8XbUStdF5MDG9fX+I1rmi3ywfO3LQSaTjtC7RXknBicbiWwqSWGCnzJTs4/bU07ADTTkJDliP+WQ5jNxu53vQgWj1OXG9mfT5YvmGTkLggqO7eJVVkFB9o9UKBdyu5OC5cvCuUGDk3elqiou3a5XHqsz1N42s9UB4Hug9loT/9p9/6Pe+0YysoO2ZnxCS4vOZ9LNsVM/YdOm/7z/+vd0q1B8KX8Qp4DetyQ0DXDeYQcvq5O1oqpaZ6tbjwDP2HTf7rtkG+JOnPqOjV1gOdTfgY6qtNFfzPTjaogwlb1Z3LBaoAFGRR4nFsVJ7acFjFEMp6vZSwEW2NPVA93fYFwP8J8y4aBGyYpKsX5kSp+OzXtSARI7YP4oQdNfkUpCyUDrRuhG6rdGrNVMVfDqr5OMjsU7JLSMxhnySMK/+na4jDZZBb3tSR0DDk6G/lWqyGYs9cb14xfPHYQ0cON/eXxWnx6Y+lOjqA9zOdwHn27ZHpY/rrVryFV93JUA14diWuJm8JvXSksa/H/f4+SuQjfnwD5Zcltma2er3inqmWyv21doGFOoJ4fy4L0ebF3xqMxnKXTn2el0iWdvPOYjxCod776TTX6TspyAZmhQeokIFTqPs+KOOHtZyOk3zvjfSgLHnJJugY8Y43KlD4I0ZR3PbgaF5BHGeLI4NNi7BXHhL2yy43ueEih/gElncUunL7IsVHeIFR7S89HLOrgeyZwlpkYAWpW+cDl2cRU4ypTjWf/m5jVejaqrC8qjKBQNHcptZ8hjtNc5C04EnGXVWJ1eEB+mq4HK/vQhsLWeF1K88c11q2uOBM7zqsunrNVA0dhDDhoCQaOaidIIiNwhqRFmO80qAlEiYsNoSiRK3Z45ggmY5JimQV
 Cv0u/gmv
 hhYTJE9FCdl1ThCGxBUKcfcr+PQjymVw9WM8IM8q9UE54iwAeEiW9Ggd92NWegAoB/ue/SlBPQA/C0AHlHasx0bT32Z2euIn4n1caJGCqDGqAwcMoHYMo/xgupi0rvEV7YBcqJJQCuD9qbooOxFkMGEZhXKKP1MNWhrU5MnWWClfi+v2U6AaVXyHnHP46GXRuhmSSaqAe9H2CAUfHhspl62A7Yh5JEZTBE+L1cmKjAvAbB/iUeVFVtiWMAfPkpoc/699/U0D9nWIgTguepwCWn+6cUZtod7Wu4ucNWwItnQYcAvEk/C5dnMFx65ZUJKT4Hb6Dd5ofyuaRUubES2PYHwreC3RgUya7QDh2lA1rgmIhnt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 04:49:44 -0400, Yuan Liu wrote:
> This series introduces a pages_with_online_memmap member into struct
> zone to avoid pageblock-by-pageblock scans across the entire zone and
> improve memory hotplug performance.
> 
> Approach
> ========
> Add a new zone member, pages_with_online_memmap, that tracks the
> number of pages within the zone span that have an online memory map,
> including present pages and memory holes whose memory map has been
> initialized and for which pfn_to_online_page() succeeds.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: memhp-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/memory_hotplug: make shrink_zone_span() more robust
      https://git.kernel.org/mm/core/c/1a3fed34
[2/2] mm/memory_hotplug: optimize zone contiguous check when changing pfn range
      https://git.kernel.org/mm/core/c/554e941f

-- 
Cheers,

David


