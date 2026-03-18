Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE317103E16B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC996B019E; Wed, 18 Mar 2026 08:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D40B6B01A0; Wed, 18 Mar 2026 08:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410DD6B01A1; Wed, 18 Mar 2026 08:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA1A6B019E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:22:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFA4CBAB88
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:54 +0000 (UTC)
X-FDA: 84559097868.06.745B6CF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC5EB40005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:22:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773836573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hguOLG8tXpzBnLBsPAWJ8LxN455CBQZdyyZ129zZHaY=;
	b=nrQBx/sgMqh3VwX+IwhQw64ybx1AS/Ausr/FmduEMicT3CIfiyT0BJ2V1R9KRIvB8zMhxU
	SmdhmpuF2kHjp+uuUfFNoIg5rxvzghjLQYS7n69Q9lwxhG+dKYF8m4fyqgnuxWBE3HT0wS
	zZY6tozx6cgVhBNspfo5Jgxw416mz9Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773836573; a=rsa-sha256;
	cv=none;
	b=GcBXkTkmnFcrHltmpNAtV1eApUxpmt0SKkMucnnjyFuD3jqv7HmELXrmu9ZV1QsS5mVAql
	oDtJhI9xY/DHuoY0gqLFAusjcTX25/gj8wyQmx5+HRJwFhvjz8Fp+uSOYH+0dTNCm/Jfi0
	4bEUHcdt0/0x7AY7yHg1IXmP70jRiM0=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fbScW3QDJzJ46cQ;
	Wed, 18 Mar 2026 20:21:47 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DA0B40584;
	Wed, 18 Mar 2026 20:22:45 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 18 Mar
 2026 12:22:43 +0000
Date: Wed, 18 Mar 2026 12:22:42 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Rakie Kim <rakie.kim@sk.com>
CC: <akpm@linux-foundation.org>, <gourry@gourry.net>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <kernel_team@skhynix.com>, <honggyu.kim@sk.com>,
	<yunjeong.mun@sk.com>
Subject: Re: [RFC PATCH 2/4] mm/memory-tiers: introduce socket-aware
 topology management for NUMA nodes
Message-ID: <20260318122242.00004e0d@huawei.com>
In-Reply-To: <20260316051258.246-3-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
	<20260316051258.246-3-rakie.kim@sk.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Queue-Id: EC5EB40005
X-Stat-Signature: 63g1zrso565jcygnb3onuitb3ik6t8br
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773836571-419248
X-HE-Meta: U2FsdGVkX1/codNkUAg5taSGZzFYKXl+bUjo3Fq+WLPyQBXZi+L1mLHZl/V6Uy0tVqg00OZieXCfPVAk6w3bP2m7BIApfyntP6GlKzY32EZvR14em6EPHbf3ZrJV19xD58xfNMNHoHqP+AkwfZMnbQUbcQIqHeDCxoJ1/r70qrG20R8SVLgklnXWwh18LkG4lwdb5aekFuYbUw3mCfkEhmwhtwEMQZFsS+pCXViOllhtsh+oGJsyoYAGMWqlKG7EWIg0jWAZJrhbFgs3POInMdoeP3BjgXEt4Ljvo683mDi20UGt1OfqGCH3f7/mNYOxBceO8JCztOeq7m3LbBK60XH/iZA5BTXxX7f3YLqHSwR6JTG02quuuM5HbR4MYDSI/Ecf8DksG1tJFc8f5qkdaA/b02nEJ7i5NZIjoQBl5ucjumYFxEUH1/axi+1vzTxWmP9K0pBtTUPrCXODVGZrFOCVpnZvh60Gcx6Pqxc82ZtCEj/uJPnXKdk1y+mI7cTdZQFgL8FhPy8chuI/VGisBLV9cPUjYJhyzHF2GZ1MDwpW6dAjBtpa3LRyg2S4DUuJauPOgz5aNuCEL1iNzNGeWcf6k5nwiHCwtaHIJOSHl/wUUuf95Sd9V8jxGi3oiYhvbBBV762WQaw1504DJDDHNz5KgBYqO3eh4QUJz7StwNIWJ83GaLBclB9Zjk7/mBsyzQyamtMJfJMMMR2aPWJQRlBN8KlzXDWGTLua4KrwOX1JpSNoiRhe9iUdrUiCxWfCwPkT1vkyXyfgHLxn6cY3CF7uNGfNtrr7+LZ7H3CDLfj0ObogIgHjI0oM0Pmcphk+8ZbXwm0FOUAMnY0ezgS2rmYDyZST/eF7BCFQp6bYh1fQHHyhfFErh/ci+e5cfkJydQp9KVh21DiPwbMTz1e3qZPE8s+YLjiLZVMSFW0TEDf1uh/QE70dHGv0C8WBaizgVrNXfwnjIMscKEr3cZj
 f0OIXmcB
 oMGiBpdKl3lYxvyt95ILJmtxvDZj+D4oIcmYKICguIxdp+n8OfWd6SD2PE3da33aRjyVG7o3BSOdWhcNoPBYsyXUF5QAsDWl6TsQ3f5EusKp9Ku7s9OOVLO21QkBDQDc1/vWfJalzttn8e6ZkzNxYVuA+EW91Yhuajn3W27nAMQMZPkFbAfrCmVA0peHHWJM5pX4iyOhnSg+dhqlM/vhP2f8DIOqrmEgs8GK46RylBSYWGhou/34qpTXKkXRy84HxwpVrDNhxggBfGdSx7ZP0OA1/qD4HOYfdiXBJV2nExCvltU/gvFeuciS9Nx8u0I6Wekt96MbT+7VrCotLRunYcRZiokEFqEs95uYzKplEcWIjpkDXh5AT0SwAr2SvQZyKythal9WG35ADCs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 14:12:50 +0900
Rakie Kim <rakie.kim@sk.com> wrote:

> The existing NUMA distance model provides only relative latency values
> between nodes and lacks any notion of structural grouping such as socket
> or package boundaries. As a result, memory policies based solely on
> distance cannot differentiate between nodes that are physically local
> to the same socket and those that belong to different sockets. This
> often leads to inefficient cross-socket demotion and suboptimal memory
> placement.
> 
> This patch introduces a socket-aware topology management layer that
> groups NUMA nodes according to their physical package (socket)
> association. Each group forms a "memory package" that explicitly links
> CPU and memory-only nodes (such as CXL or HBM) under the same socket.
> This structure allows the kernel to interpret NUMA topology in a way
> that reflects real hardware locality rather than relying solely on
> flat distance values.
> 
> By maintaining socket-level grouping, the kernel can:
>  - Enforce demotion and promotion policies that stay within the same
>    socket.
>  - Avoid unintended cross-socket migrations that degrade performance.
>  - Provide a structural abstraction for future policy and tiering logic.
> 
> Unlike ACPI-provided distance tables, which offer static and symmetric
> relationships, this socket-aware model captures the true hardware
> hierarchy and provides a flexible foundation for systems where the
> distance matrix alone cannot accurately express socket boundaries or
> asymmetric topologies.

Careful with the generalities in here. There is no way to derive the
'true' hierarchy. What this is doing is applying a particular set
of heuristics to the data that ACPI provided and attempting to use
that to derive relationships. In simple cases that might work fine.0

Doing so is OK in an RFC for discussion but this will need testing
against a wide range of topologies to at least ensure it fails gracefully.
Note we've had to paper over quite a few topology assumptions in the
kernel and this feels like another one that will bite us later.

I'd avoid the socket terminology as multiple NUMA nodes in sockets
have been a thing for many years. Today there can even be multiple
IO dies with a complex 'distance' relationship wrt to the CPUs
in that socket. Topologies of memory controllers in those
packages are another level of complexity.


Otherwise a few general things from a quick look. 

I'd avoid goto out; where out just returns.  That just makes code
flow more complex and often makes for longer code. When you have
an error and there is nothing to cleanup just return immediately.

guard() / scoped_guard() will help simplify some of the locking.

Thanks,

Jonathan


