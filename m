Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C35CD3445
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 01:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730B36B02DA; Fri,  8 May 2026 21:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1506B02DB; Fri,  8 May 2026 21:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7176B02DC; Fri,  8 May 2026 21:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE486B02DA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:07:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E493A120436
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:07:33 +0000 (UTC)
X-FDA: 84746093586.06.7D52C68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E09740003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 01:07:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Krnqi5HC;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778288852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex8x9rcsapA0X/Bny6BiTKA9Hp/bDdC+IQV89t/4yxg=;
	b=JIPDGg/GgQ4/PsFWFGDfimt/UkRMp/nWvxO5sndQK/QdL0IoWTkhqwCPrgeiuH3hUi7gav
	mRAL6PE5g3xsQRaVjQ4c2MrAKVHINN+wm98w33aq9MSM92FohNmJ/0GK0JoWUWTZJgOQLq
	7ZN0FyZa2X/vGq0SUL8NIUtSW7ualDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778288852; a=rsa-sha256;
	cv=none;
	b=f7APOT038AXc4B9so/4vg5SJ4y+HGwLJgx/Ht22Ohxv/PDj9/zNhBZANdI/5iju75jXHWB
	ZeveA6DcHqYALTuxEmHS1f0q6HblGHgozddTpquVTS2TG0cSZ2OLaynWquwxiocl/rMRYC
	1D704rDJZqvYPE5KB07lGJ+XkhNJoic=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Krnqi5HC;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 128C241917;
	Sat,  9 May 2026 01:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1477C2BCB0;
	Sat,  9 May 2026 01:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778288850;
	bh=2we0wfmewVjEzY98udpopwqzsrMOslpQoy0p1QISyz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Krnqi5HCNZBb56s0oa3WMaF0sLWUatRFicFZm+7p8yQcexa7KnrCEdo5sBfihvj1f
	 bbH7Im33OvZeWPFw00zae6s5Flo5zL3wI17Xc+QachQtIsuOkGTSk03H7Ng5XAbCZg
	 OIEFvoLhHvdmA/X6hWef6g+yVxJDisLAamrJcmmOYPxALV3yWoG8cty3GEjvWzaE5V
	 Z6C4JmoAvkkLZsLgF4qj3DnPiHwaUkowoJZyI71UQo7xQBTgedPWHRrJRDX4f0Jnar
	 meObzWlSTQerIWjWXyelJsd1DlXmqsle/yPdehr/71kc3lCMQKFLfhaW99iM3Fizzg
	 q4s5Fk5OXpyLA==
From: SeongJae Park <sj@kernel.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/balloon: expose per-node balloon pages in node meminfo
Date: Fri,  8 May 2026 18:07:28 -0700
Message-ID: <20260509010728.84832-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260508094736.142467-1-hao.ge@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E09740003
X-Stat-Signature: fe7rpotey79sjsj45g3nxqpiwrj7ycge
X-Rspam-User: 
X-HE-Tag: 1778288852-268878
X-HE-Meta: U2FsdGVkX197LnM5aZRpGdcJw5n8u+hpSmHCoQsC8KI8dyYkRm5njUaqUSNNPuzChHYxCb3ISDUsSWJxYgkS1w1oFnvx8tCcTYoIq7LUauEAzahMe63tzU5PeBKku9Fn9hCSf5msYIiubDaEr1yn6Zc9GB65YT/zrWKOmV9UJ3gtbwjN2KmskBowI0H5TarORptHk8drZB6ru8fA69m33WRMs6JiK70bimKZQX5DzIVMYqfuk7KrgwXzb/wd1aH/gc58W+gYBp1nrQq34Bh6huvb7DWTO0/8GOc7KM8bxVVTjUfWW8XMrlesvyUKxqanQNlKxgroUXtU0QldZbRNQHW3JK3bbjHg7VV9zHopmSTTZhRuStZWtmLgBwH4ovizFvym0vdaliD7ngP3Oyhk5uoXwmNe0qRsfu9TwJF5bX+dr7AzVHDbfrJz3FVbwzBKidj870OHMeAMTkPlQtUyP6BOYT1dcwBhmCuJ0WJvAc4aQ4+Ldfem1SgF4SWb5rZI7EZu4U18JaHU1d1qm7fyvPC7E+SbsR/dYxhLuSDEAJtGeA4MNTJl2cr/p1yDkKy1vh3zESXKE100321zSKSMOB4GQ4Mtg0wbW4zZDTI6t+sN3IzzBI2gQF1s1LYCkxOI5iwlCLk5Zw2tW23ZQlBlzENXWtbdDgCuAKcjqaQfzhHSfloPFy6PggPkqPFMBDO+iR2Epjp+eKwQWO2u5htOrKX6uCmWHdEsLa1zYIP0/YvJngr2I3zMIbXTCbExPjpUcz+l33Sgc06w9lpMcFql8TvwSQJEBvtsxtXWBwwqL6k5HhcDu8Mulj/FkwPYkt2i30cruMq62UvgEypy744VrMpgV41McKwz/OJRdXqvO79AyITQRpvV/a1ICYSNJbyuHdyxT97gEOV6PcpqOz1925e/nTvSrECSm7ko2CM7LxvnAfq1ULwVDFfgRtUaOMKitdvhvQjUNJdMgQOtLxf
 C8lOwNa1
 K2qTma8XxxiHwPbDQgTSc0zLSphioGhOuYWdgRJtgRHufkYZ7Ze3xItv7aCYf2oLljmWqXd0vFtTAfJRhKhjbS7c7EkvWCO5L4n+O/1BXNHoNaHl6MCBdJgHJxh7y2iFEzZj4g7HIInEqdj7+L7kv+gdZwl22wNuMQxjUk1Cht/5LqIwcYb9rmxGPs1ejJri7NHglmMfJaUNcc7UzFhhwEREbPyTgHtYzVEsfAaHQopSGegQKSjtLKnlixqjyU+3AQXEI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 17:47:36 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Commit 835de37603ef ("meminfo: add a per node counter for balloon
> drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
> However, the per-node view at /sys/devices/system/node/nodeX/meminfo
> was not updated, even though the counter is already tracked per-node.
> 
> Add it to node_read_meminfo() so users can see balloon usage per
> NUMA node without having to parse the raw vmstat file.

Makes sense to me.

> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
> v2: Move Balloon field after Unaccepted to match /proc/meminfo ordering
>     (suggested by David Hildenbrand)

Adding a link to previous revision [1] would be nice.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

