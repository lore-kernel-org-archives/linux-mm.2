Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D0CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 06:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DD88E0034; Sun, 17 Aug 2025 02:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674808E000A; Sun, 17 Aug 2025 02:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BD28E0034; Sun, 17 Aug 2025 02:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 458A08E000A
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 02:27:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C3F2B9E9B
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 06:27:44 +0000 (UTC)
X-FDA: 83785268448.23.0C752CB
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA320140003
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 06:27:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4XdW7xb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755412062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5AQERq5OatpVNiNUItjF0hacw8nU1T7OW4izVD9NYbw=;
	b=JEMYiJyBJPwhJh+qbfyEiBulxEKdvkkLa5LaUlC2R4EguPW7r7XOchPFxuh2vwQozjk9jJ
	YLjSeuOP0kJ6xOUs9ODqXn8CFeasGgumHmc+o/HvkPoI53X20G9aXhd15qBrkCT2dRZGRM
	MKVTDlZXiJ+bKU2yju7xiIclPQEfBWA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C4XdW7xb;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755412062; a=rsa-sha256;
	cv=none;
	b=z3F30tJ901RgqYsHuZA1I0IYeWxWg5Ioun6z1xpu3Ido2zuqd9kKBZnSzae/ZnDTEdWKGQ
	6640vHKPtk4vwblJZBx7db93UeW+0bGZw9+HF2Iq3fznobhAVUKety6AU7wAiZRQ/VxjNk
	q2xYv9iz0SM6hDLzjlD+CTXAPB77NUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8E1DB5C1660;
	Sun, 17 Aug 2025 06:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0C1C4CEEB;
	Sun, 17 Aug 2025 06:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755412061;
	bh=TpmqSwdZ371xVQIviS8OQTjs+jZME4B/LsCHX3bDftw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C4XdW7xbTBpqFEORPxC1v3F8aSWpsZ+Ea/95jk9ry8PCZOXJVI+ZamyYFNTPxhbEQ
	 6INhZjVaNkUoxlfLOTIBvpRSlhgB4QOPTStKhXz4gtG4AoiHUW/hMgNK3LW3DI4oX/
	 ksMbj7ImH7mHfYimQfwqymhHw1c7TCzEpOrEflQbr/ABlhHGWv5dKkU+P6OXz4Bj1u
	 LgDQ8T/aDiYzq2nDIC3lR+KqKxwtjg2TFon0nNaRaR7/GcFMEGdVce8R4hFxyFt+Ha
	 QT+1F+o1GJapakOZSMqtE06huxFIx7w6OS7Mro9hVMlGQm5OcciEYHM6jN7jtJmxMP
	 yEgE2yPtudFlA==
Date: Sun, 17 Aug 2025 09:27:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: robh@kernel.org, saravanak@google.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, david@redhat.com,
	Jonathan.Cameron@huawei.com, devicetree@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com, chenjun102@huawei.com
Subject: Re: [PATCH v2] of_numa: fix uninitialized memory nodes causing
 kernel panic
Message-ID: <aKF2VZ1y8OuEChmw@kernel.org>
References: <20250816073131.2674809-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816073131.2674809-1-yintirui@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA320140003
X-Stat-Signature: 9f9ofwqe57rp634d6teidyzo6uk9sh6b
X-Rspam-User: 
X-HE-Tag: 1755412062-904132
X-HE-Meta: U2FsdGVkX1/aweBLzJt/P/B7o1801vus4Xpz5rNtuUpjgziErb4o++ML6hWyUxNMVrQmVWVGe4eb4j93k3RMLYCOmkHE/1PhEgFRTC/37F4VqzR48Vk2bhe+96JiCU1kxkT/kNEKtd8+tL8GzgCm27d2+dF5iySAxPV/gWYNYxR1m7OhmRbz49EZBcmi+ccTioGY1zTdSCoYMN7o9r+aAnMAwA5R3RFbpm2DABnh92Rf5A4XC7va3uEaCplKbYacdt52yHkyhrd9uvyxJcVdPae0mrKVcdBgIzbriWAjisGNsa675rXfUg2KzVA6rtQ7mvoVtRrS1TKA8aEC4yBNQxmGDa7OAKNpoaifQF/0DmalInAaDa/gQ/yoNUvz4MyozR+ImPCZBE7lR2tZareiDHMxoJ3VEK3/Ufb2yp1YGjMuzyuLckkfXjgU7+wUVEzIAFwzoBZHe9JSDI+V+Iq/ShYQv3spICfJ3oXC4uWdO44eoGLhantrCYdDaPL9KNyw78wQ4SIpd610BA0y7kFmT5vSL5/SBxQOK4TgiKIzEx0tmYNOzu7pWlfBHJMRFBncaoNwRhPZOcGsLsHZY/ms+SzKK0ZgEOrE8cF//f6fyiq0Cej0moC2npO6mC2JGsy+sWvvw40LWn3fifT7jWR8ihbphUDuOv5KGk/drYaw/Un4PB7CJHGF1R2ab+yze44PxmI8ur3wPfoE35SEL1aBCmNeg+zbZAH4GUeuI2rTg1f1Abf3pEmlHBZsRawNBvsWvWM7gLdSweCRoKgaeQ9iY2HfeFdI4xFFKlJ5dfQ0nbJelCgHKiFVDna7Y1NqKeIQvG6MQztDqJLcHUyjibdoHaIA9El4FVgZc3P8G0shND5XPO6zy7x9GVHIlDzzF8/JfFGlEk4eLG3nO7zjelHOzhuXcE1n4NEfspltb26Z7GGtrTh0kC6uOkGhqrkdEnPybzfdY/oWADaeWkCyvVB
 fCId2/t4
 aUCXo96mCfEqAkEvj0g20Svy304ql0lZ+a0u5FcfpiK+F7xoW/UwG1BTrUuX3thI9uGGOCZhZEOV/F6HmWttmoDdvGFgJyR/oDZ7wRwy5zEnyKR3mdL33ZlwUyYvx5ChzQyiBA9bHgFQm5EfJNdBZPo+ejPC2f813OVV4iMINci3d8wxCSg8Huf/xbfZCzZcWv3vVFcRuFs+ATJ3N/06VGhF+OMwKaWrmlkCkbeYqEKmewREZPIZjRDLjDgq2+P2OI2j9rDrqjtA8o6/c8tAcoaYr8FYJz5HwqjuS2jJqn3Z+OKhqwn6gWKaCkk70KdAPE2V4+i/IVWLxkbjYAITYbXkQOsyOQ0CDQ3T4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Aug 16, 2025 at 03:31:31PM +0800, Yin Tirui wrote:
> When the number of CPUs is fewer than the number of memory nodes,
> some memory nodes may not be properly initialized because they are
> not added to numa_nodes_parsed during memory parsing.

Why the issue happens when there are less CPUs than nodes?
Does anything updates numa_nodes_parsed when there are more CPUs than
nodes?
 
> In of_numa_parse_memory_nodes(), after successfully adding a memory
> block via numa_add_memblk(), the corresponding node ID should be
> marked as parsed. However, the current implementation in numa_add_memblk()

... current implementation of of_numa_parse_memory_nodes()?

> only adds the memory block to numa_meminfo but fails to update

maybe "... but skips updating"

> numa_nodes_parsed, leaving some nodes uninitialized.
> 
> During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
> panics when free_area_init() attempts to access NODE_DATA() for
> memory nodes that were uninitialized.
> 
> [    0.000000] Call trace:
> [    0.000000]  free_area_init+0x620/0x106c (P)
> [    0.000000]  bootmem_init+0x110/0x1dc
> [    0.000000]  setup_arch+0x278/0x60c
> [    0.000000]  start_kernel+0x70/0x748
> [    0.000000]  __primary_switched+0x88/0x90

Would have be nice to have the full crash trace here and more details how
qemu was run.

> Cc: stable@vger.kernel.org
> Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> 
> ---
> 
> v2: Move the changes to the of_numa related. Correct the fixes tag.
> ---
>  drivers/of/of_numa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> index 230d5f628c1b..cd2dc8e825c9 100644
> --- a/drivers/of/of_numa.c
> +++ b/drivers/of/of_numa.c
> @@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
>  			r = -EINVAL;
>  		}
>  
> -		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
> +		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
>  			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
> +			if (!r)
> +				node_set(nid, numa_nodes_parsed);
> +		}
>  
>  		if (!i || r) {
>  			of_node_put(np);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

