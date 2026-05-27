Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7772CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79E96B0005; Tue, 26 May 2026 23:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A513B6B008A; Tue, 26 May 2026 23:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9671C6B008C; Tue, 26 May 2026 23:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870E66B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:23:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93472404C1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:23:35 +0000 (UTC)
X-FDA: 84811754790.05.B97C568
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf27.hostedemail.com (Postfix) with ESMTP id 283B44000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:23:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SvhdZ4dV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779852213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYBaKQ9ccBbHdCr6a0OICRGnaQys5sHWkVVQgUBQX+U=;
	b=cwrNAccakxeMirdqDVsnoGBXAQ9wkhbaL+y9i9G7crZFzq/HGB96CT3MByXh+rWy6MMirF
	RIDeyOUKUDwQHpFQTSUeu4bZywkyR0QVMwcAJ6GOnwkRt7edsuBFTnUk2zaQhDLL9REthE
	kjYVhwtBxYBwOca7VgAwxCpFEzDDjew=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SvhdZ4dV;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779852213; a=rsa-sha256;
	cv=none;
	b=J5oNjKcWa5NN6wyGyi0+IIJpX1cu/yDONk1qn8JdI6bii6H0ZMXUL/ykgXZD9y9G1auqsw
	ltSKVbJjwKDOht5DUoJz5AKC3gwjHFu41FMSFey9gZvVwNAh+HywULfsZhA3eZ5HuuEBFt
	eAcshbTithU8YmST3ccUBCdPL4b5Kk0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yYBaKQ9ccBbHdCr6a0OICRGnaQys5sHWkVVQgUBQX+U=;
	b=SvhdZ4dVyKphnwQqMX9rgSopXQbycSxFZQzusfA0+jXddo9E9Q4vXqvzzxRCPT8J5eVZY3oVc
	j/EoLwoFXyTYdtOdHUeT7eJxn33/m/SqUjuv/KQnMCD1dnxHLz2eVZeEZThGcXHeuZsXYmacVlz
	t0ep+08BubuX8gRLmeYnGD0=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gQFB23jX5z1prLx;
	Wed, 27 May 2026 11:15:38 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 84C2D2025F;
	Wed, 27 May 2026 11:23:26 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 11:23:26 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 11:23:24 +0800
Subject: Re: [PATCH v8 00/37] mm/virtio: skip redundant zeroing of host-zeroed
 pages
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang
	<jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
	<hughd@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
 <20260521100313-mutt-send-email-mst@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <eda29390-94a2-c4f6-a3e3-32bea8c6b363@huawei.com>
Date: Wed, 27 May 2026 11:23:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260521100313-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: xoitzf9t93q64wxcoqgburjjbqpd5fdh
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 283B44000A
X-Rspam-User: 
X-HE-Tag: 1779852212-113906
X-HE-Meta: U2FsdGVkX18EMRZhzgphWdw5ASdQ1X6+kI7aobJvZKIoEIQAOfwI9bIiiuMsB12fEAUgMuO94gYYsOr1llLCZV/akfkFe99aLFGxJO6I6cg8hRWyoh95VipkutEBJWgw2Gu9a76Nb5s2IxaDHTEqKfsHa2r50NhLCmRvRO+N7xPsphRcg+KVEyDsTL066bPwfAx7An2TxaTalA5cHsjzhLvKqvV+1//q9TkgKarCdML9ZrRKVmK/+aOjtkEjKjKmzKN6d8rr6Z+paXoR80Ka5SiqXzbccuSAkBAAdCuienHiSp9viKVD0azS1RIW0cD8KHI+l+KCGqRDk1iSAYerbcjiaQj8hdCGxYvbu2tBJrbhUKw97RFBODH0BLOswTpsmFkRZ+N1D93ZVVMvlz58U/3xb8V+P8c7/FxUe/HSBboqHkVT1/hcrbJV8xhz956EBk4sVJAcdpuB3MJZv5G3hz1E8nAKtM8PIzx+oZcWNf5RfIMxkg1rSbO0NPSxUEtqWmM/UlXPzpFYm8/EpBVRZh9YBKy0KBxQ6LbKg9Y5RQJY5dmC6R+FN++0ZS9QLZVPS/sngfubuy2pbQSKmJntpKkXrDDm1SMebu1ioQqM8NasHaYt18eCIeL+yuHa3ZCx5SK9meP6+IpLCQSEUB1SlGnJ9isDjdU2LDzhzSwXoGYZlkAS6KCA06jQzG3xlBqDGws3jWGKKh4yYI0AiS/b28MD965ChDAOHkdKFoql2f8vip9yh3OTnjK4gmjG2Vu31o/CPW84DOyHrfS3tZHOVefFuqbt7PRLkoonfoyMhpiwGUastZdMD7+JJwz8DwXrDZRHwjssGjmLdGSMlxLAaidX4UxfWDSXMTebMi8dDhnjLSW/lbSWsyCyMT2xA6SHk7KNxfCVX10J4MEBojqByrTP5JUllwSRP5H8383ChxnzhZAaCFu8qJYxJJQmtTgzk8f90iTJqA7k/xzY8fC
 qf7KKk85
 q6TF6EDyQLeRhgHV8KhKEyc6Tn/pSK+GBhkI6bSdRNdAXJMkKN4kQy2PO6e66wq5lnlM3O0RwCKvcG0X2amLt4kRpu0CeYqKz6vS4vw6C2LpL2VWCGyhhojF7jelfNJCXRYMIOEgPBxf+A2iB1JU3RiH3+ToZb2/aFUheleknSeCBm45mooKiGvlT+jwnu4AZqz2O8yWqScIz2LnKMr2U6pKgs6uz39DStI9GlhSdwfFRJhZUdYYXgtZXWr/dRyP/7sL0Ju+Gpajypujg5p5Qo/BqUO/2ivJ+4NnIbriSwOF0D6M4+0vV2VUcu+DhpOFkFLqZE9wvsnvrddlLctXxaOZ8IAQAUf3WO8YP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/21 22:09, Michael S. Tsirkin wrote:
> On Wed, May 20, 2026 at 06:20:13PM -0400, Michael S. Tsirkin wrote:
>> When a guest reports free pages to the hypervisor via virtio-balloon's
>> free page reporting, the host typically zeros those pages when reclaiming
>> their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
>> When the guest later reallocates those pages, the kernel zeros them
>> again, redundantly.
> 
> FYI Sashiko reported a couple of issues. Mostly false positives but
> I tweaked commit log to make it clearer. But also a couple of
> real issues. So far I have this diff on top:
> 
> --->
> 
> Changes from v8 to v9 candidate (code only):
> 
> 1. mm/mempolicy.c (patch 1: mm: mempolicy: fix interleave index calculation)
>    Combine vm_pgoff and VMA offset into a single expression before
>    shifting, fixing carry loss for file-backed VMAs with unaligned
>    vm_pgoff.
> 
> 2. mm/memory-failure.c (patch 2: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock)
>    Wrap ClearPageHWPoison in retry path with zone->lock too.

It seems TestClearPageHWPoison and SetPageHWPoison are missing. Should we serialize them with zone->lock too?

Thanks.
.

