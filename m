Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1E7CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C600C8E0007; Thu,  2 Oct 2025 07:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C106D8E0002; Thu,  2 Oct 2025 07:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFD68E0007; Thu,  2 Oct 2025 07:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2128E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:10:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3174913AF95
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:10:18 +0000 (UTC)
X-FDA: 83952905316.12.431EF6F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D6031A0004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:10:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759403416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWliwx7sdOJCfrYD7i4anTfRAiTL/yXinZSB6LjUpjE=;
	b=xrUBZVbTLIP00umva+u3U3mkkVcwi3MfBqVqZj0gvj+WXf2WbXAp9c4IOKN2GX3Ik12ogi
	GaJTO+x7B4n4cZovOEp7aqFmQzCDcOjEImA5U8FpHy+vjpAnGzqTvRX1CO0wdCQl4cDTYs
	nZCmFsvj7dKtdEsJyQmtQjD2LknHKzc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759403416; a=rsa-sha256;
	cv=none;
	b=y8Km60ZiZ1xlb4RrainMaoDd0RGvzT/HqlFj8WM7v1OPRkZ+/3JH5Bj/oBf+Re0RZQ0zZJ
	jesjF1J+FPdEXJqW03SqflFZ8dn2IJqteGtBPED7ExzXUiiv8WJhYc6pqhnPpcW/nVClAv
	icEfpmsSRFKCVIAYpTTcs+J3v38SrTM=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccpwc6Ycxz6L50S;
	Thu,  2 Oct 2025 19:09:52 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A705140278;
	Thu,  2 Oct 2025 19:10:13 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 12:10:11 +0100
Date: Thu, 2 Oct 2025 12:10:09 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Shivank Garg <shivankg@amd.com>, <lorenzo.stoakes@oracle.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<willy@infradead.org>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <vkoul@kernel.org>,
	<lucas.demarchi@intel.com>, <rdunlap@infradead.org>, <jgg@ziepe.ca>,
	<kuba@kernel.org>, <justonli@chromium.org>, <ivecera@redhat.com>,
	<dave.jiang@intel.com>, <dan.j.williams@intel.com>, <rientjes@google.com>,
	<Raghavendra.KodsaraThimmappa@amd.com>, <bharata@amd.com>,
	<alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>, <weixugc@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC V3 5/9] mm: add support for copy offload for folio
 Migration
Message-ID: <20251002121009.00005899@huawei.com>
In-Reply-To: <20250923174752.35701-6-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
	<20250923174752.35701-6-shivankg@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Queue-Id: 3D6031A0004
X-Rspamd-Server: rspam05
X-Stat-Signature: ya4mayws4y5aqiry6iwqwua93he4cezm
X-Rspam-User: 
X-HE-Tag: 1759403415-911517
X-HE-Meta: U2FsdGVkX1/XkIkrKYJEuictW1qH8Z7+lucQhmodFM/2pp2A2P8UKos9SXVqunVLgvVWcLf/o17SLyOrJgxkRElp0LQ7AzNj67tED/ilbgQSiZKuRvd9gzF0ijXbW+qQljr9FROVnybgPTqu1AY2BY1M9KhThm8NaYjDvUXkajBpnafMB2wP7lnr47pLAt6E9Bz9osr+1+knVQBExLMsCSKvkhzL951Vd/3795u9OeHKn9ejYOlB5Cnr7GxwEWiMZq/FVgANmpJOSMDNMJ1bUzh6ujnMU41nTgkLa9XP9YBU8gZshkUTC/op+End0IzGFtH92K24k29sucEXuV96gPvtOEjt1nkkh0H4//45NZVh+dL5jOelVWcZDjeHimJOvbyV+KPf2AgMBZCB3SMLWGCEOt/OL3uUhJW6jhY9O35AStJV544cV1RFHgo0UaqWRZZlPKRXuh3yq3D3PsQb25C/YyE9yLNHwomWrdSUcHwCjuKtO+6xHvDUVTkv/gfvSxX4ch8Y9oiJeR7uwjeLR2uNNQDoCwKT+VbVmGaQGtcrAvfd76oInhuCSqyLhi1gU7WlUMjenoeEzREDxIMhdBkbw02DDYPacrDd2PIv+wSbxlP+V5SOhGfhKXzQuHcQIN1giS48+vReAT8x+SEii+TLiQUi2vn8y39SXJWv9p4MHFF3WYEssv6i8ejp8CFdwnA/6Ib57/iexgTqJ/f/uQ+ooOUpQkW7TXPObSh79D8PtX0g+xCpAmhDRfXis4iZgvy6qz2Bx200DxTGoldPwYrD/9ZUe/4HJLG70qPuJil6yEaXJRG9E2QDlTZz53AKo48QiHP4GtK48bFM8ncw0AvC9/LVTk/qQB4dX7QLMflHNEusMAogZEATT1smdkLOmpIz3AV3/y05nZSdNn6gZCGAPxYpLWbgFQU3ai9JaaRpwe0nm/zcgp/AMn7b4YhDQ+yxWtjGjsGvLuZ/GBR
 5df9W1U7
 grJwLeq9/FWZJ2pFda8EHYdGSgX+q62PHFPqgosIUKf+/ULWY+azzBzhd4iPcjPEMsU4w+AZuvmVUuQN7V2v8GCGUPdDI9F1CjaY13Ih7vIG0SIUZPlBpZ7xhltOaf79MItYwfgo3nPdOWuBWMABpbvPnQXL8GG0UuSrfDQU7cElOZ+ImkAO7jBcOZ0PupLpv9jDwlOd/19hQiTKcuo9TpEkON39O7lw5wbBU2lslFThmXpHs2C2Soowu21NKsNYAzvNxFOLZEubsqjeYxVhB+oZGoDCp0caG5NoI7gABrCEuLfQRz1Q0v6kasJXFtABubgRvUdA8hdXr8XW3sVm/mkkizD054Q1tDC4J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 17:47:40 +0000
Shivank Garg <shivankg@amd.com> wrote:

> From: Mike Day <michael.day@amd.com>
> 
> Offload-Copy drivers should implement following functions to enable folio
> migration offloading:
> migrate_offc() - This function takes src and dst folios list undergoing

Trivial but I'd burn the characters to just spell out offc.
migrate_offload_copy() isn't exactly long.

> migration. It is responsible for transfer of page content between the
> src and dst folios.
> can_migrate_offc() - It performs necessary checks if offload copying
> migration is supported for the give src and dst folios.
> 
> Offload-Copy driver should include a mechanism to call start_offloading and
> stop_offloading for enabling and disabling migration offload respectively.
> 
> Signed-off-by: Mike Day <michael.day@amd.com>
> Co-developed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Just a trivial comment inline.

Ultimately feels like more complexity will be needed to deal with
multiple providers of copying facilities being available, but I guess
this works for now.

Jonathan

> diff --git a/mm/migrate_offc.c b/mm/migrate_offc.c
> new file mode 100644
> index 000000000000..a6530658a3f7
> --- /dev/null
> +++ b/mm/migrate_offc.c
> @@ -0,0 +1,58 @@


> +
> +struct migrator migrator = {
> +	.name = "kernel",
> +	.migrate_offc = folios_mc_copy,
> +	.srcu_head.func = srcu_mig_cb,
> +	.owner = NULL,

No point in setting this to null explicitly unless intent
is to act as some sort of documentation.


> +};
> +
> +int start_offloading(struct migrator *m)
> +{
> +	int offloading = 0;
> +	int ret;
> +
> +	pr_info("starting migration offload by %s\n", m->name);
> +	ret = offc_update_migrator(m);
> +	if (ret < 0) {
> +		pr_err("failed to start migration offload by %s, err=%d\n",
> +		       m->name, ret);
> +		return ret;
> +	}
> +	atomic_try_cmpxchg(&dispatch_to_offc, &offloading, 1);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(start_offloading);
> +
> +int stop_offloading(void)
> +{
> +	int offloading = 1;
> +	int ret;
> +
> +	pr_info("stopping migration offload by %s\n", migrator.name);
> +	ret = offc_update_migrator(NULL);
> +	if (ret < 0) {
> +		pr_err("failed to stop migration offload by %s, err=%d\n",
> +		       migrator.name, ret);
> +		return ret;
> +	}
> +	atomic_try_cmpxchg(&dispatch_to_offc, &offloading, 0);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(stop_offloading);


