Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3420E668A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E956B008A; Fri, 19 Dec 2025 18:31:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C496B008C; Fri, 19 Dec 2025 18:31:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A086B0092; Fri, 19 Dec 2025 18:31:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23EAC6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:31:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE25AB61BA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:31:56 +0000 (UTC)
X-FDA: 84237820632.30.AFEEFF7
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id D333880007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:31:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZWZp3BGO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766187115; a=rsa-sha256;
	cv=none;
	b=XpUQY1TaHUjiCfxqUYbI5cEF0quTQm9gB4XrVh2mC8qCq20OxYASK1jDWa1RVtdRadHQZU
	gV82P9icfzGEkMnskHuWIe0cSv2N5mmHjpcbKrCT2oyZezUoa2zRs8hxppGqEkfXfIvgbq
	0zHMNrww+KPOyuUgeWVROM1hOhWzhCw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZWZp3BGO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766187115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7vOgNTsLKhausqFQtwp3EgZuPBkHhNtQ3ISVh7bYcnY=;
	b=wE8sEu8hefZqvY+8RvqUPNXfHFdd3cd+WjgbM7uflcoex4UuEbRt7XAUtdR978FG1QtqyP
	KLXl4sPaoiojVpKJgo3DqdEapXmbGLrvVAfxcdPtH+MS/3NFpe3vxhNqYhNtVk2usE59I3
	lB7flvuqeT6oJWQOJwVjURntRyd7H4o=
Date: Fri, 19 Dec 2025 15:31:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766187107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7vOgNTsLKhausqFQtwp3EgZuPBkHhNtQ3ISVh7bYcnY=;
	b=ZWZp3BGOxJ8WQwxJg2TsZfRWziizPCWD8adQ31MjlcBekLIqCb9Cd/7MCRgvgURLOGmRXS
	R2ReQ8DTmIreOyurwVMJSmfRMQ5V+GFWhZrhfh/f3P0n0//PItZBHEaUQwqkQ7bYTpuhqJ
	pRnkdAD5xbFndyAeJLsFHfsj+ciGU34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 11/28] mm: memcontrol: prevent memory cgroup release
 in count_memcg_folio_events()
Message-ID: <th24uujlegbefmxlz2gngavlvddyfls4swm6zolqggtfoauztr@jhawlcvuiqsy>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D333880007
X-Stat-Signature: djgbwf6e1jmqpg9eprq9sozzffpsh3xu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766187114-558670
X-HE-Meta: U2FsdGVkX19PPykYQQWQVPRqrDKA4Ji1KHuCecO1yrpN3ndSEJNEOu32rHWRvfITyYPAU7VsEsjVU+0HYqXF1rwH31bBdWD4F9zk+9Qmi52Js5aTQGBkF0Lsf8muM/Z8smsDLM0i6r96chhGzI+Jmf39dpxGkSqwGL1iTfoj1sjcAbJJnZ1uFL/jsNbba+SjCn2rzYeIThu1bup7X8ofyLF+bnIBIRoCopYt6OQXtLkSFbWa7/Rzm9702aiLgMK0gWeJ1pn8RJDeETgaLvu9D2nDvMgoZTsmSa+g9QP5LrLyFlXgGeo1F7S+Jru5ea7HTPVmI9YhKL0OFZ3STqQgZ4TdrFD2kvM14Qot4jQQA3g8e+OUlQA8aV6wazY6A3idkS3qyrj9MJnBucK4zIbZJgQTAZcvfZmTa5Fa+7pigCfLZ7A0D8uwbjOLabfEPcTwgc10j0TakmivB/RyYxuqJyKtNhY8y7CJWfaBcvJzPxjgohBACWXmidKl+GH3XsiJ+HhEXORFwnSFh2VmlrO+BWHBytyv9cRAhJUrFyg5Fhrc8YLcipHMPxDf8N+NTkK4eOxCQtWn5DAJbSl4bgpPumdXgyLqY8CblZ0czlxW2tVnxnEzYQig70zR2vxcxuccGRNIH0q+c/f5FzHfin+mUjlAZ1EMSNLtx0KObPd/5uMxCghG0Vzkr2DMuoZiJ+jIccupoIn0jqZyGiQJDFWMFSsRwjnHDHThpbw9HpJ7yVEkQ0nCRWISXtBD+fc9O09MynrwJIjM1nhBWbyYsQtaMLRkOpsRzDmJqqe7OPlLKmzj/hJJindojl0PVWPgHAYdMkDPwlFQe4S5VXQ/IPqU4LaMr1g0FXx6G9n2qjahoJU1EgXGXr3PaOtZzkc0Tm7ONcAQTbZ9oK7E+A9gyXZcKruG5feVQ0mkJ+BCEy6be7B630Ck1RkLKk1BUkvea9SawtIuqoKX4bmaa8iE1Xd
 UNj71FIt
 c6sF6i0BHb5QeOADrytlVFm53aS1H3zl8trM2uSqXX2otsKKTjzM7+bbxrWGyvaayYOGVbTlblDwCCZpkYIg8EOG2SkXUoGHZ5KA5vgnVtu6cyHK1/9S3jpLzwpxwKhhn31Mz6MIS2sga+7UgGex3RBbU5sa58EzzddsZf01S+OqZilFX1EWKQC0JJEH1tEGAUsLZnnpygmuxcBURtfX/DdrwB6MMvnz0lbR95sy9XneQU3wIQTYQbieCrmCo1mgrvoeX1ax43TjO/mP4GAlxASjjLFeyEcWbgWpot1VsiJKLK3jgOY21BvAQWz4BEPvo3gpqxHl8ppbSuic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:35PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in count_memcg_folio_events().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

