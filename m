Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C278DD358DF
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0C46B0088; Thu, 29 Jan 2026 03:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09F516B0089; Thu, 29 Jan 2026 03:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E326B008A; Thu, 29 Jan 2026 03:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E28096B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:28:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A915BBE15
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:28:43 +0000 (UTC)
X-FDA: 84384325326.18.76CAD92
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C06B140006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:28:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769675321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OfesjZ250B18WDYkFxjvTixXUXcWF75EXI/NBVPajRM=;
	b=yNcBLoUMwa802tbBfg4isITONz+oz7c8V6LXpm5nKJpBBittDsGixyAaAWz9vSV7mGo81W
	hecLGkDK8YZDYmJvnCPS3GQPq8h3a+QV3cJt4qQYEi0Y6flJ0ML3VgX+KG/S0qB6r1glo/
	PoMHBXRPq8oj7KNG6GdRPdgEqiHn5Qk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769675321; a=rsa-sha256;
	cv=none;
	b=vtPfcxSZ6HmpfkZNER6jmaoPh+2rzXLbbiFwERoFXP1w7uqJDiG+4Bg4PmRplyLoxogLii
	SDV3yBn74Yj2kFNeL/beJY0jQLXuJ/k8D47Sr0drYVZHkYi8F6nbWW9Ekqip1+Ng+dH+O1
	s1N8fLIAf0E0dTBphiyE+Et94/6mpZI=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Jan 2026 17:28:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 29 Jan 2026 17:28:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <aXsaNsUFCiHYrECk@yjaykim-PowerEdge-T330>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
 <20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com>
X-Stat-Signature: ph9xccwc5qfdycngyzjuywr3sorogusa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C06B140006
X-HE-Tag: 1769675320-251218
X-HE-Meta: U2FsdGVkX18SZXRMkhGJHMHT5UVEeUurDfZRU+07BxJMDkFsEOXj9YP6TrWGd6RGyWn+ovfa1tF+kh4gWhS7L+K1+YRd4mY/N8q+rAhXI4V8BHfw+Xc/p0OIC+HQFEP+y4D8abI/S92e0hJj63uWBmy01NnojDlZcnT0t/lctoHtyVf9XIb5W05Ptqv7e+4dO6XBObofZc3Ax+aT/hyP8XwmxFlLa7gwtaQig+N7I0iFSOR6XRnUDGShSOTFFZZ5U+DLD0TgtIF7TCndMN6Q7LbcnezN10LfAjDsPsqVwSE47mIA31QJ16793JXqgXmGU7Gd1+fPLmDO/XS6ktlVWEA7FCmxIlQmCl6I5QbE+lPH60YO0LonJGtaD1EmechamBIziYFK0LjAuaex56gp7tcFXLin+UCfAVduFPDOhYVeHd1JA8Px2/6RvcLQiDTePBGWfjWWTFRPap0FxtuGhcPk1i4sebCXlQmpzOsDq6qCWLokLlCzIlHa3FyPunx3BfOm+khRSIuy1rTqAYi4fBW+YRVjrUMB34aHhhDXoCVNVv+BVy7ICmdRa1RyvtdV0vE2NhiDqYZDuV9DxFIP778A6gGcHd/aXZZNHX6HdWgVIi4IPqxXzK6OAOCrll1cbex0mJM1/RmV627zV1MK1o/FYexXYN2XrLyP/CBihBJ9Q3QPveu0cYiUGU2sQrw02CEGygyQxgQkUV+9MWuI0YPQavkZuSxRY+Fr0R75Kc6AQqs64QFlNsPYeAEooZz/M4oe/NT1FwspVst9eloqQkSLVV68qLbtFedDEyP7IDrtKh3UBTOSzUW7tpxIurlT/4cruWHW5vub9hSDVcRoZ31A+La1fapfU+gJzglbHtcuLYsee0tFZX2B6YLd4wEw0kzO2n6lgqEdHbzt0i8MAC+61ypg4JBalF+JDXLCBjuRo8wY7BufiA3Nf5ZiJcDXptCzfwQIZRReOiBnZkC
 3InSfTnd
 Q0w3DHMyiLM9aN9EgIoMrWdd6+YVmXWuwt1tqZOGvU9KsleJJqgVT5pw6NrwovNNpQQH2Cs+sxOCuz+B+CJIPTbtGLc2lE1kQ9G/WoRVK0A+U+SX+E9YkDSkOrWqDDVwE+7LfUDHQUaMlOPylprwirx6ZRtu/zf4Tev82HtTo+K1U67pkRhsTy4ptlKc+yEksqGXigmt0zeVPEPsLFH2WGpjMRVA/mtfZUP3ZfYGBlEwdS1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 05:28:33PM +0800, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>

> index bfafa637c458..751430e2d2a5 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -37,6 +37,7 @@ struct swap_cluster_info {
>  	u8 flags;
>  	u8 order;
>  	atomic_long_t __rcu *table;	/* Swap table entries, see mm/swap_table.h */
> +	unsigned long *extend_table;	/* For large swap count, protected by ci->lock */

I assume using 'int *' is to save memory on 64-bit architectures (8 bytes ->
4 bytes per entry), which aligns with swp_tb_get_count() returning an int.

Regarding the extended reference table.
While I agree that a simple array is better for speed, readability and so on, the
2KB overhead (assuming SWAPFILE_CLUSTER=256) might be significant in
constrained environments when only a few entries overflow SWP_TB_COUNT_MAX.

Have you considered using a resizable hash table(example. or something others) 
instead? I am curious if this approach could be applicable 
as a future optimization after the current code is merged.

Thanks :)
Youngjun Park

