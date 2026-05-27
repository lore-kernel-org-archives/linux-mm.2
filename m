Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F61CCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B4F6B009E; Wed, 27 May 2026 02:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBA26B00A0; Wed, 27 May 2026 02:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAD06B00A1; Wed, 27 May 2026 02:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798586B009E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:40:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 206A01204E4
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:40:53 +0000 (UTC)
X-FDA: 84812251986.15.0D91480
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9301180002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:40:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MATKi6Ci;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779864051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPNbX2SUFH5m3MJbTk7cfi4r1VdowVrOjxlCOTcinjw=;
	b=nrqy7ZIWhztBog+0e1IBQR1xRj9C6DbTENV9CRhN3HU/jmosoxwSKAbnu71YbDZaXqwLIw
	92EZ8bSf2hsCmqNtBaptcLe/G9Y8eqQsxFfXt338S7ZQLOYI80GwoLbffAYiPOFaFyDKHi
	XusuuCuBAy85ypk4zbTs+o7SAxjfWsQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MATKi6Ci;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779864051; a=rsa-sha256;
	cv=none;
	b=of5y/jn7ZQUlSPQvXyVClbBuxKiahgYYWZbLX9BvumKuteq8ULoHEcbyTKk2UEjrTUonLp
	5Ys6tL11CQcLuqijVCup0bt9+YKSH9DaXRyz+Dloi8wRqgnm3pfWEuLakOmytscr/Co9lF
	4vjSn+zs7iQGHQZUVUzFXXFHcBlVuWM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uPNbX2SUFH5m3MJbTk7cfi4r1VdowVrOjxlCOTcinjw=;
	b=MATKi6CiyOY97oC8E9hLWBql0R2dJidPc6AsVABVKYPLjLFmNrBiOt9hr0zbu5ypB/kAIFsa3
	tLy9KruRxtXWCE47y6rTmx5e2qwSuHxnhyA+7SHAJfIoZTUgzWNe80XuxoU4zUUfDxGvbBRKxfX
	9apSqaEng0HWInJb7/lYlUw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gQKYk3pvczmV64;
	Wed, 27 May 2026 14:32:58 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 568DC40565;
	Wed, 27 May 2026 14:40:45 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 14:40:45 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 May 2026 14:40:42 +0800
Subject: Re: [PATCH v8 00/37] mm/virtio: skip redundant zeroing of host-zeroed
 pages
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: <linux-kernel@vger.kernel.org>, "David Hildenbrand (Arm)"
	<david@kernel.org>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=c3=a9rez?=
	<eperezma@redhat.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
	<osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Brendan
 Jackman" <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
	<ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
	<npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li
	<chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	<bhe@redhat.com>, <virtualization@lists.linux.dev>, <linux-mm@kvack.org>,
	Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
 <20260521100313-mutt-send-email-mst@kernel.org>
 <eda29390-94a2-c4f6-a3e3-32bea8c6b363@huawei.com>
 <20260527012249-mutt-send-email-mst@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b26314f4-4a1c-c8c0-eac0-48be984ef8be@huawei.com>
Date: Wed, 27 May 2026 14:40:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260527012249-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9301180002
X-Stat-Signature: jh5yfxmzzqfhamtbm8yghpark4bn9679
X-HE-Tag: 1779864049-786045
X-HE-Meta: U2FsdGVkX18ZyNfxQ3689UCxizpco4LW2w7WU/5ID8fjnttNZlgECWDE7rVqjeApQPc6pFx5VkBzUOf6Iki1DbLOYvBvFKcK1k+kTln8UjH6D14jU/syR8BCOhyHcJo3M2BnOBb1Vxe5i0wV1IC+26bV9ihL6dY6VIAVCDT+7TYQcVE5bNoyFIKZNl/PlB3Iq/aScV5wSQ/1SzXMAuIYOh3ZvS93G9s3Hbnl14obuDHN5L5EwWOgVg1KgYEVzHlHqOrKUY2y72S6inriqCiG6JR2UJst7pgoB7SGRWTmegIqIKpzVRl7CqrLn7tJsZphMl1VT7I+v3KG69VFMRqJa0fEq3rfUjv1vHJd+9nESD8snT9xSa/vn5jAMbfGynws0GFb8M+x89TA12eajhHT26gCRhM4YfzLZ2/ROC9k8M5SCowTyIeCB4uF5h1Ru1Q6ON48nksE6UJQgmMd+Y8EPax0X3SYKqmXyd8sItJJj7EVV1gQoJ0JoCmiZybhSMKcYJKVP04GBijDeH/3iQFFsKBwWnCIubb+pRwI/Ttkzw8RLuWLU17uYCy5gZ7+wVB7Q+NuATfQvvPc9inVmkiMDqYckftmHNWA5C+2W1giqi4jYp639ZmXwH9fEAh3KK84T+luKYyVnS/nHRvJOhN0KcRSj6uTaKZqsNt5gN4LbTvVySd9GB85w+3ccJoi7hITrLlI4NobfvB8fUv8UGRIxSr7bkgZOCfdxCZH3k7Lu471ZJAcj1uMCvqS9NnsPw4TTq4BidxELxdMzFLcv6vBuVqLyvsU3WgUng22VHcD3n0qE5Famu6fvN7q6GF7C985r4oEm3hm5xulIWUZA6DJzOmVm5M1Lor2HhJU3dPwCai/d+7jiZMPBgP8CB1C5KoJTzbXejGgHmb65CcZKi7gKcJeS8CC+bCrjfVJv5kq+4iWOePvsne65LK9vCifBLkt/0PDTZe+egQnzmyvURg
 BFGlloSJ
 hNIue7PXdrY9LHzmvhlaApH5H7dptIojU19U2VnvpwwRrD6vI09BgJLtlgT7htaMpnh5IXXJBJNdwaOmLEeLPlpj0Pfq32LswstAEqUm57Gmckj4twOF+p36xKYbsOQKWsGZpvhbvFaCA4r+Dqt2PlfqNgLETC7cPdGdxFU+9r2Db+TolmiKNtkkQtzhuMm+IvjrIIQcQB0VjJQCza1AAUhMD6hl2KgjKzMIdYpLjTijVpC0juafTg7udueDaF9ew2AAs/HBvRPB4UnYpRyk6XwGsr7NPAJviF1vGZVEsl6dJOEzATPMlht3HMRrtAvPk/fE/jN+NBsBebcnWgDygQ/eN62+9dD9+MpSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/27 13:25, Michael S. Tsirkin wrote:
> On Wed, May 27, 2026 at 11:23:23AM +0800, Miaohe Lin wrote:
>> On 2026/5/21 22:09, Michael S. Tsirkin wrote:
>>> On Wed, May 20, 2026 at 06:20:13PM -0400, Michael S. Tsirkin wrote:
>>>> When a guest reports free pages to the hypervisor via virtio-balloon's
>>>> free page reporting, the host typically zeros those pages when reclaiming
>>>> their backing memory (e.g., via MADV_DONTNEED on anonymous mappings).
>>>> When the guest later reallocates those pages, the kernel zeros them
>>>> again, redundantly.
>>>
>>> FYI Sashiko reported a couple of issues. Mostly false positives but
>>> I tweaked commit log to make it clearer. But also a couple of
>>> real issues. So far I have this diff on top:
>>>
>>> --->
>>>
>>> Changes from v8 to v9 candidate (code only):
>>>
>>> 1. mm/mempolicy.c (patch 1: mm: mempolicy: fix interleave index calculation)
>>>    Combine vm_pgoff and VMA offset into a single expression before
>>>    shifting, fixing carry loss for file-backed VMAs with unaligned
>>>    vm_pgoff.
>>>
>>> 2. mm/memory-failure.c (patch 2: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock)
>>>    Wrap ClearPageHWPoison in retry path with zone->lock too.
>>
>> It seems TestClearPageHWPoison and SetPageHWPoison are missing. Should we serialize them with zone->lock too?
>>
>> Thanks.
>> .
> 
> I don't think so.  As far as I could tell, none of these are called on
> pages that could be in the buddy. And all the non atomic page flags
> games we play are only on pages in the buddy.

I scanned the code and it seems no one breaks the game. So I agree with you.

Thanks.
.


