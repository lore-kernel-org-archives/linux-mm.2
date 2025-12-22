Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D61BE6749F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 12:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC896B0088; Mon, 22 Dec 2025 07:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A4E6B0089; Mon, 22 Dec 2025 07:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385946B008A; Mon, 22 Dec 2025 07:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 237B86B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:12:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A28E013804E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:12:27 +0000 (UTC)
X-FDA: 84246994734.21.1B402BA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id B61BD100006
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:12:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766405545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5xx5gLKtz3avxpa1jA8m+F9t/9SSDFZ8oYRMX6e2fsg=;
	b=CVdxrWxN1ZvxJe34m9SLVGjIsIaH+sHMxE+d/FoKEwj6EjLDRZ94GVCwhzu9dmHTosjdCo
	6H0V4KC2Jt3jaOjyvG3pPR8rgTecZUYS1wcEzkUSqCouVmupDrE894jSOSMGwJY9GrzuEb
	xIwuWu4/kRCKpDh086y5yIxzcP5sLz4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766405545; a=rsa-sha256;
	cv=none;
	b=sxO1GdGOo7ELMP02/+4tvjdu6V7mHGNKwHUAYvVJFzoYc1YCz1ZaNO1nAs3Se8NxAKPLTm
	blRiFfKP5CArhoTCdgbKzHj2DEOZMDH0btJ8vFP12vdlSm3vcyFdU3elHisdS4AofCRLFm
	QQJEpYxPeaEag4k1Bl/WWc0dW0rD+/A=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dZcSb3cZlzJ46bM;
	Mon, 22 Dec 2025 20:11:43 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id F0A3E40569;
	Mon, 22 Dec 2025 20:12:20 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 22 Dec
 2025 12:12:20 +0000
Date: Mon, 22 Dec 2025 12:12:18 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-cxl@vger.kernel.org>, David Hildenbrand <david@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, "Dave
 Jiang" <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, "Ira Weiny" <ira.weiny@intel.com>,
	John Groves <John@Groves.net>
Subject: Re: [PATCH] MAINTAINERS: Notify the "Device Memory" community of
 memory hotplug changes
Message-ID: <20251222121218.00000b1b@huawei.com>
In-Reply-To: <20251220000327.3502994-1-dan.j.williams@intel.com>
References: <20251220000327.3502994-1-dan.j.williams@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B61BD100006
X-Stat-Signature: ps9pykjhx1j4oqoz93wfa514kb1z8ygp
X-Rspam-User: 
X-HE-Tag: 1766405544-645260
X-HE-Meta: U2FsdGVkX18ehwzN1PSmkhAiEJPw9ZMbQZa3DHko8xJQfuIuecNVVAS6W40N9eiXoEylT/8ThfwSYfsnpnlI6FZtk9jA8YIr63JeRWZ+KAgRx9SC95LpQ6bmZYdNuPC9cp6mnUAPlPEJdFwgsRg01c0Nf3lEtvctio4ad5IV5vn7asD0F+8ktI4x0hg950/0/5cFAvgRY8wErH/VCfHXGsebjuSMAkPFeM+q8YO8qTCSJWhrqa2zN5ep2PmbKOigvLDxQjyUDJWu0NC9Ika03p00kTCDJC/4CmdB+OXkZ6MbGtSRBDrHKacP11eplyoO3w3XF06bDEube9P9ttryRd3kNibgF8l+lrs6dXZ24tFAKQMy8qBcB5Ly++iS/NejDnP94U1kGdDeqCQi+4Hsu9LcbmzMwW0DJWVp4mqJSY9RH9VaAeoXdAj6sIdsdj9ISRYpE3klGNGMxQ1oShISSP2DJobg6Kz5zv9e2QckdvsVX7O6JyFANqvotjV71lZ/URZI45y/3Y/Tfwgp5QP1rtlKMDUrlSg+Pm7AT0zGXg0GqicGCS6amuVo+5IHMfzbDfCqov9bqXyS7VL0MMdIutKHdxKp54OMfTtxP6Mapqelon4dNhttXZKWjwoY8h3aLOPEPYQC59TRyW/7CTPSruW4rsKE9aex8bk0CnVZrbt2oCscEg4Dpu2KQqC6XM78EKk6T0HyYQrFX4iAzWb7Jsd/rL3DQ9wW5f2fzFFzyVXm52Mdcxu/Ac0X1UuN8CaHxcdGCoi0w4IYNwTqE4MwF3Htp+0MBNgqeoTUAM3mu79qqauuhj2C8rY2HQp1+NxhLtIipERHyeadAL45OmemeZxXVfEFaoIqGsyzJaVBVR7BNun4KwNcP6gYrf/mq3/u24y1WZCxxy/Fw/CZUV6IpZBKSKFUol2jSL6xjV8YEO6BipULIotaG9emr4ZiAfW4bCR+H5chMF+j6W1arSI
 ITConE91
 j2FM/i2rmBXj/G6tYI6720BYFx1dPpvpXgQtnrtbtdEBZHe1qOgkewI6fvoEFG/bAV6JFfUrK2EaurxqmdwGHDR71cmZfBugeByJN1zoDa80dIwe+HWrrs69tlyTp7/XxQ4X3SyiogDNN6JSLXUWquRXxN4jpQd2J8CyYn55tAy/0w7BKMBz625kby+EnzHsRvtXfvFr8rnXZCbX6SevsGUobSC7gpVQgBlYIDCWi2w+1KlcJC3xMB/fkB5znYAFtVa2DaQ9trf2F/4UGknc2uldMvGr8QdsWLQH9oKzdl6sfzhySJYQjcRiR/9KSykuhjdFOp/CStUqTkH9YnKoXfy9MY8JnhIrgul14lkMn9+OdDNh8XsDsh3YHfR1sQ7uOccIOAqK/epDhesU5sCWG2zvXLl5N1ziJJZDb9cFbjukissNON5/Y+SOGwW5+Wj+yTvBexLA7xZjgju1WpeKWm8CwAQYzWcWm365+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 16:03:27 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> The recent episode of a warning regression in memremap_pages() [1]
> highlights that relevant updates are being missed by folks that care about
> core ZONE_DEVICE changes. Yes, CXL folks should pay more attention to
> linux-mm@, but it also would not hurt to copy linux-cxl@, where most Device
> Memory folks hang out, on memory hotplug changes by default.
> 
> Link: http://lore.kernel.org/20251219123717.39330-1-john@groves.net [1]
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: John Groves <John@Groves.net>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Makes sense to me.

Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
 
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b11839cba9d..076322fe91de 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16426,6 +16426,7 @@ MEMORY HOT(UN)PLUG
>  M:	David Hildenbrand <david@kernel.org>
>  M:	Oscar Salvador <osalvador@suse.de>
>  L:	linux-mm@kvack.org
> +L:	linux-cxl@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/admin-guide/mm/memory-hotplug.rst
>  F:	Documentation/core-api/memory-hotplug.rst
> 
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8


