Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74CFCCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 02:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409B28E0019; Sun,  2 Nov 2025 21:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393C28E0015; Sun,  2 Nov 2025 21:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B038E0019; Sun,  2 Nov 2025 21:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F11F8E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:45:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A320712BF3A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:45:53 +0000 (UTC)
X-FDA: 84067755786.10.D52FDF9
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7DADB4000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:45:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Bc/dXkhn";
	spf=pass (imf07.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762137951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLsNdV5msKuuZDhVKS6JixW7JdJt6WuPTHBa//DL1Zs=;
	b=5IZfikJE12Ri5jpsJDwIg14eeK7XQIRIbWEGwHCtjb7FuRYr9Ax7AMH0JZ05wQcu+ADA6d
	0buqHFmzB6ag8+P7rDDayZLQ3sK/YNhp4bRtdeIimqAKX937fHt7in6srRf0yhVwaDIDPp
	sEbhDsIeL4wKvacdUDT5U1CmGRtsXMA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Bc/dXkhn";
	spf=pass (imf07.hostedemail.com: domain of libaokun1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=libaokun1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762137951; a=rsa-sha256;
	cv=none;
	b=7iuLpp1uxXJ5sS5Rybm/5dvCoFh+o8cuwyRI49GixcS85fFR1wEMT/7ZE4RW2n6z0rY43K
	BCO5o/sqjBiSnmCteSy6BcuklpvOwvjQWhnFJyuBj9UbT/HVJgu9dTzLIkkZahRnZ0Nxg/
	CZ3GB//A3NOdBGW325tI9fvAoSqBVpM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NLsNdV5msKuuZDhVKS6JixW7JdJt6WuPTHBa//DL1Zs=;
	b=Bc/dXkhn8ilkZLFe6YzY1QCSQAJJJwKteCLud2KsWiytzOJe2HR+BaGQHhmNBZ9Gdq/c+o/4h
	fFHbI1leHPUoP0A2KXJ/+quk5SEfIjImUhqGRXRkbqx7122uwyEPP5qcrf6D6tWFVLmY+QS1720
	b0IWjPHV9G4LqsAQzNNwwkQ=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d0GBM10DjzmV7D;
	Mon,  3 Nov 2025 10:44:11 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 22AD5140230;
	Mon,  3 Nov 2025 10:45:45 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.254) by dggpemf500013.china.huawei.com
 (7.185.36.188) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 3 Nov
 2025 10:45:43 +0800
Message-ID: <2a383d7d-e4bf-4762-ab01-4bbb2756e764@huawei.com>
Date: Mon, 3 Nov 2025 10:45:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka
	<vbabka@suse.cz>
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <surenb@google.com>,
	<jackmanb@google.com>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<jack@suse.cz>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<libaokun1@huawei.com>, Baokun Li <libaokun@huaweicloud.com>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
 <aQRkTKTm08lSJZZi@tiehlicka> <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <aQTqELGGKCN3JTIm@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.254]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500013.china.huawei.com (7.185.36.188)
X-Stat-Signature: p7x6s4cmcygrz1zfzijrqpbfjsbi9ru9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7DADB4000A
X-HE-Tag: 1762137950-238219
X-HE-Meta: U2FsdGVkX1+/rxmPrFy7tB6QE35TCLBl3YmsbISKWXEQQZr4qaQHkyyVI2u6vJt241c9yQMyjr2uxDh3UxL9yOzjLdX6rvhwNBusTWYqArKBLmyRRfCebAyMJYbnu+zZX3EX7J5Ti5i0uMZWilU5hjKy8KEagZXlBC7RxFnt8x5FEa5dkxbnKj2F6N8exM4ICcGmyYzbgvLE+mRv1Pn0lpRN7FlBDGPaj3GuQ5sS9RS1bXw1N4Nn4N1oTrKFXjUqUzi2xJll9/EirowfAWgIxB1i6/F6Q3qVHpnUsaZPHpBaVTeBovfnhKSXTdOmearxiTqwmdzYDodzibu+cMuCgRVvGK9J4wmIHEN5g4tb6niQNo/zSQOxtu/+G9mmzLZx8PYmHKFaXMc1JlQ9FtONxS/8aPcgvvO31ea8sbMSEeDgGVYydMhbPPnPyQ7Sl6aM49ZkNq5HA+b/QYtETEue2eJzAPJ3bAm9DlCWbBNEF4EiX7jEAKNnF0WoMXA8xXSSgFV4+gG5g+QGiSu63rXspJ3cHH+TR9nvKLxHpCaQP2+8Ni7MP0EtcA7lLNuj/4RToWszulaDZB0iECZok/EFs/clYOi8uNPvS3VdmgEdaMgKw8JXvOPESylLOuUkfwb/zSOs5WmROfA1DD15KvGxBnAjsk1qJnEYgPXJGmVB3hnMtsTbN0ohDoJeIif964aYzUfHwJfu9TSpZCiXdkn9ugUN+eMMBtQveCTqFSkoo+cxmyAODUT5VkPzvee4yJsZM2kNRzWB8gc9JtN9LP6r3Qt3Jtk0haXFq4qmc1TPvLIY3os8to6AzNYzbx9xfpHLr8Pbyr0LRj8//GZhk5X3iGn0DB/5koYGhe3gHiTtYyvlSqqcmi0eIMkMLaaHL3mrtdVR+HRS9MdQNUwv7IGvn02v7k5g0GpkEJ/I2IPl8vMls4E5LZeV4XgWbztXAwXdesHDYFb7Phyu33xDptl
 4yo0xN9p
 gv+7p9vbPsXnEQtQ7MckOXY203T16DhutwLltnH1HSmuquuS+eUaIt/MiSYd5XchPjXmQ8VXXaYHNiDVc5swUWtodrN0BZNfbV7s7ajDgJUDVHQjfL8LC/m8KHaiVMzsXGOv5a6cigy0NgKMHRXkSZUxuQHrBUdhZMXt8r5XrA85t2hk30REyYzKHEdCo0BvoAb8qvLb/vzP5CZD8C9HwrGJrd0tFPyVkKmhXFzLXWEHevr8veq78saa0bqAw7anmHZ+orHdZiQjQVPZGA0y7VDVhwN2TiF/IxE/m6KIOTgXBnwkIr7N6UhDGh7RUrw3YH2o4wMff6spL8Qr0Rkhsl/ojJfqewEmySQbs79EAT7nGBQxWMndXhy9pVVVE645BToOLftps8ekPoAppHahGhxAPaKHpa1lur3be
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Sorry for the late reply, I was traveling of office.

Thanks to Matthew for helping with the explanation.

On 2025-11-01 00:55, Matthew Wilcox wrote:
> On Fri, Oct 31, 2025 at 09:46:17AM -0700, Shakeel Butt wrote:
>> Now for the interface to allow NOFS+NOFAIL+higher_order, I think a new
>> (FS specific) gfp is fine but will require some maintenance to avoid
>> abuse.
> I don't think a new GFP flag is the answer.  GFP_TRUST_ME_BRO just
> doesn't feel right.

Agreed. If we add a new GFP flag, it will be hard to prevent its misuse,
and __GFP_NOFAIL is a good example of this; we simply have no way to
monitor all callers.

>> I am more interested in how to codify "you can reclaim one I've already
>> allocated". I have a different scenario where network stack keep
>> stealing memory from direct reclaimers and keeping them in reclaim for
>> long time. If we have some mechanism to allow reclaimers to get the
>> memory they have reclaimed (at least for some cases), I think that can
>> be used in both cases.
> The only thing that comes to mind is putting pages freed by reclaim on
> a list in task_struct instead of sending them back to the allocator.
> Then the task can allocate from there and free up anything else it's
> reclaimed at some later point.  I don't think this is a good idea,
> but it's the only idea that comes to mind.

I am not familiar with the MM module, but here is a rough thought:

What about passing the minimum folio order to the allocator?
We could then ensure that pages are freed and allocated using the list
matching that specific order.


Thanks,
Baokun


