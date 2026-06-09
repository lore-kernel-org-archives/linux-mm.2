Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB8DFCD8CAC
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1BF6B0005; Tue,  9 Jun 2026 04:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8436B0093; Tue,  9 Jun 2026 04:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE886B0095; Tue,  9 Jun 2026 04:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE4BA6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:03:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8D2C1C1E87
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:03:38 +0000 (UTC)
X-FDA: 84859634916.13.6DE1B8E
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4DDD4000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:03:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xQAuBxMb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlBlOHMPbvtbUB1n/vkZ2Ftsfcpe6TvbqLXbZg5mnVk=;
	b=xDBpGWvtameVv9C58Ut/hoOUKYlsuxcnQYe8+jEhqO1eT8fB7ByR6k3bC6KsUC9FOeJjIj
	SsQL8OGKJJti1YWzmleASdfSuUFoQRzhS0Yj39xKjthFyfRBuCD535l6mnfULSP8GfAV2U
	J459u4GIqCpttt9BgyMD2j3MiGbM5Hk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xQAuBxMb;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992216;
	b=wg4Qm7HunPRoDBuvqT6uoSJxvs2QJ09tHcT0DECeFQxljosurXD1wNJFX7hm9hlpkNUrgj
	MMmWZu/aebYLDsh1KTSa4TxRNNE+dH4+1nWPtf1oSk1fCxljy9MoDmoBqu1VTLv/z06qTK
	k2iybvecsXPL/vckmmZAzbd6xnWjfNc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HlBlOHMPbvtbUB1n/vkZ2Ftsfcpe6TvbqLXbZg5mnVk=;
	b=xQAuBxMb8mzsb7Jf7ox4zUkRKG53+Cimxagzt8XKYaOjdENJso8ZC07weXNRQH5oR687sy+m6
	uXXB+h8Fi4Kp8IbHwqYAtIXlS6EWgn4Ic3ovMEgUrzAUwgGaWTXAQWhBYp6VKMDgM8ICPj468nr
	/yxBP9dKfByAYRac+9pNCAs=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gZLn15GD0zKm4s;
	Tue,  9 Jun 2026 15:55:33 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C430940565;
	Tue,  9 Jun 2026 16:03:29 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 16:03:29 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 16:03:27 +0800
Subject: Re: [PATCH v4 4/7] mm: memory_failure: Generalize extra_pins handling
 to all MF_DELAYED cases
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1fcac146-cb21-7012-3eeb-e4bcc6d9ac0b@huawei.com>
Date: Tue, 9 Jun 2026 16:03:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: D4DDD4000D
X-Rspam-User: 
X-Stat-Signature: 7do7hns9xz76wop87e87yc1uunzjwmth
X-Rspamd-Server: rspam09
X-HE-Tag: 1780992215-128834
X-HE-Meta: U2FsdGVkX18ipXUkbvDQjB78h01/z978308APvm8OQy192XgXfihSgPtvesvpdYH6tCL9rzpY+fdtxXjnbkCKXG3jvUvocdb/EsPzlNQBJs6vpYFlhDtVlxdvC9NQMEs4i7/ycu6BuKD6K+uqlMquBUqsSK2r+P7Wal9awyTUW+NPTgFFPi3EaqGYNwA+F2CUxqXyyEW38Ce9Ab//2WEkiYOY/URnzSJi7wCbCE7cSs6/rItPCv92ho+Fm07lOjFG6kRCAcIqTwHhXW1wHaAQKJslodSywbU27iaINtQRM1U6DsNdlX47jLgtLp898QVzJkHubC+yDUf58M1X76wYEoH8N7c05r/xV5J96vQu6a5fAMBW9F6D+EMxH9jKD1QEKVfSYXj+3nteA36F61Vo95bdHY9dbU64iFfoE3WLsluelNa/tPzn6X2sYZOtybJpXOHkjrZJHh94ngRmZcFZnekKvQuNmbhcnQUxsEEikmZaMOCgn7NkB3N6XkQTJtHslDrahY6DtefUCIYAcCvFhH2MFkozHR9Wwa7JVdZaEAArT28RYv0IgUBEqVpgECfOqvKO/0/9kEuxmG98Cc4q3PC9eFB999I1Nt60DCg4UAkpqq4qXV+s+0vRyMuGSf3SGX2E/Pb91Nbh4co+W5gvgiJ07d+rMRcWy57wXg0t2sYGIHlgXsA8KO8wWVFWVJ3F54EzovzOR2E4izAYDP+YoKLXZK6zRxzqM1A3bXJXP6KZG0O6CmrbdpGe4dwcMWHftmCfx19RjpgsoAX2RLlbaMC9p+WQr8+ZZoS16wx2Pgz50jmNHgwRwkN2b9GcQoULF/x7itDSObpY7WqypWt6aTyrqnjZodpFWkGyg3AKpRnIeDCjUpopCZfnaxR50sKNLgJDsVwMwK+3Y8R7JC2wkkVfV9GpQj5bIYQH7f97G3dztLaIDul8L2XZmVmER6fPfF1EF9AGFccYCAuvbB
 EV22MJzt
 U9YDh2TYReEyyANfiBu0lpeYtAh/heFvCULu1fBVmOI/6uz6376o5g9RLkQUa032+dL1bTlhgaGRT51ULciBb09pbVVVwDMlweHIELs9bogX+Z3wYYfQCkliFLCtczNJEYQ0bGZnh6eHwv2I2kDYT5t224F6xwkUROEozuzvSkbGtk7ut2KhX+GxD2GFE1xtCj6p80KIkMIioK6COHl+PoYFJS+YKrUAgwLiwU1lpvdcWy8t7DgjflBAuA7AUgkb6LZgizpp3DI0JsjcC7fmvqAaRqsO1+XLEs0MHuLYtZxE5rba7gOBf4EnmAWBWHa70SedqLOAEy/Sb8CiofXkxdqC1rXU1aRdMFQb5Y2vM0zqWYU3i5zDIuFCxtM1MK6Jjz+fo5SnStVUg+wd/dmsouyzszZWLwoFvs6KfIkjB/iKvOeOVwPfJcsPSZaUna/iTxtwXVWlU08Mte9PNNcfU8TaDBvrBmhq2R8PvukzfuwvNJAy245aeCFWrOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/3 5:55, Lisa Wang wrote:
> Generalize extra_pins handling to all MF_DELAYED cases not only
> shmem_mapping.
> 
> If MF_DELAYED is returned, the filemap continues to hold refcounts on the
> folio. Hence, take that into account when checking for extra refcounts.
> 
> As clarified in an earlier patch, a return value of MF_DELAYED implies that
> the page still has elevated refcounts. Hence, set extra_pins to true if the
> return value is MF_DELAYED. This is aligned with the implementation in
> me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
> set to MF_DELAYED and extra_pins is set to true.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

