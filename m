Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB93C55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9647E6B009E; Wed,  5 Aug 2026 23:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE3B6B00A2; Wed,  5 Aug 2026 23:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7356B00A5; Wed,  5 Aug 2026 23:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1500F6B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:30:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1AA751A064F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:30:24 +0000 (UTC)
X-FDA: 85069416768.04.67D55B2
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf17.hostedemail.com (Postfix) with ESMTP id 615454000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:30:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xvnedJmH;
	spf=pass (imf17.hostedemail.com: domain of liqiqi23@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=liqiqi23@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785987022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wus9n0+Mpv7rQWIuIFpoGHkgxM6w2e5wGqel/1cJaU=;
	b=8izhx2Ih+OhGh+llED7hULp7FrhTQJM8sxWcpLxV1MS3a+3kolunSfyu98MPoK1gxhN9KG
	cA2fYWqh/b+yv1Oi59YZaLeunA3h88DK1+bITORNb8NVjgLHxsx/v+9OlnVuNx2JeNxi3G
	0knHQIY5wdPw/pYRazHxknd5PRUCTCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785987022;
	b=n7x8oGQkaNWx8VavygIRoujM3Wfklbz1NVP4mcOJc1HZYgFJpwfvT/C4+Pd+Av1cIFHMJU
	kLMFdWCaSpjizXPTdgVDX0mU6THhEz8iE7LJFB5LOd7bkHurYuH33xHJIGfaKfmsxSDaBK
	j8qE7Pczb80fNOZgeAyAyWBALhXR3pQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xvnedJmH;
	spf=pass (imf17.hostedemail.com: domain of liqiqi23@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=liqiqi23@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5wus9n0+Mpv7rQWIuIFpoGHkgxM6w2e5wGqel/1cJaU=;
	b=xvnedJmHWhePXoOFObXkvLZJh87bx4MqXErY79eOEcbrJjXMeD32rgcW+e1+Mzp80DMGfqr0p
	H5FXDNNf1FtCAkZtvN0zOyEW3ZqTIIFL63xHsatM7LYQOmJbAX0l/KDbPYMgxr2Fhy00WgHcfHo
	1HBeTwRYcVunCQ6fWo8o/vc=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hFsx50g2bzmV8f;
	Thu,  6 Aug 2026 11:20:41 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 14F5F4058A;
	Thu,  6 Aug 2026 11:30:13 +0800 (CST)
Received: from [10.174.176.101] (10.174.176.101) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 11:30:09 +0800
Message-ID: <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
Date: Thu, 6 Aug 2026 11:30:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE node
 hotplug
To: Gregory Price <gourry@gourry.net>, <linux-mm@kvack.org>
CC: <Zhigang.Luo@amd.com>, <arun.george@samsung.com>, <balbirs@nvidia.com>,
	<brendan.jackman@linux.dev>, <yuzenghui@huawei.com>, <apopple@nvidia.com>,
	<alucerop@amd.com>, <matthew.brost@intel.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <dakr@kernel.org>,
	<djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <osandov@osandov.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <pbonzini@redhat.com>, <osalvador@suse.de>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <yury.norov@gmail.com>,
	<linux@rasmusvillemoes.dk>, <longman@redhat.com>, <ridong.chen@linux.dev>,
	<tj@kernel.org>, <mkoutny@suse.com>, <sj@kernel.org>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <baolin.wang@linux.alibaba.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<lance.yang@linux.dev>, <usama.arif@linux.dev>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-debuggers@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>, <damon@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <kernel-team@meta.com>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
From: Qiqi Li <liqiqi23@huawei.com>
In-Reply-To: <20260720193431.3841992-26-gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.101]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo500018.china.huawei.com (7.202.195.199)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 615454000E
X-Stat-Signature: a6x5c5nrwyjoeftm3mk4f5cqw7mef5p9
X-HE-Tag: 1785987020-285595
X-HE-Meta: U2FsdGVkX1/r8QwFw7ANV97Mjc4kXZE6WYYHzV66hF2NyVFUdnhk9gG/IKXxf++GbRbVITabbC1vtuFx0PFK+gLgyucKgKL7mrtNC8dckzy1ZgMJBkwvtYRYFGna/x9fY+sqdkiy+GtYeMC2dIp0eU+n15gwZpI9RvJzZsm72mSZML7VcOlOnCyg/cf/g7y7FNzkD/zQ427Q5zihlx0whLoBtPgJ8DfJtT3uCj0rhBqkRwPUj+lQ+LI8KTm3MS8y3dA/+jDcKUrjKNDlu9bUQfJoWqihkgsny8M0Yb2iw6eFOr6lHPnLbdqUfDnjFH472Wjv6zM7Sjkmhg9SVp+XoVJEHOK6Ok0UYnc3lfM351veSzUJYS2QaD7ERhG7ftuFEMSmNFmN3BujVtdE4sEwZLf/Vr52PmbLl02U1oovK0al5wjKi6j0EGKUV7UMxxzGiH/aYNJPw1eRZBdTuhENTTDu+L/Ab/UyFzarSFiNzZth7NlDewdoA+iJ/DKZ9P3lW5x0fsX5wbpxEh9YFWhdXrgJxiq3Yqb7sjsIsrHOoMqB9Qqmo9coblLZ8fpyVhpCULdhoDQo7d90LyOXjaKpomFCUEPfpeGQKy3h4s5gQKqjCb0bYNAjLyA9oX0DWp4+nF/jbrBqyHcRo66rpqpZ5VRzhHHAENsZ/TFv3aMJeg8GVLDedS8YFye2wbjF0SJXYQRZBDMYa3qSF8WSg/ID2n1rQ7Ugv7jquSIOqHsBc7qdF8oLea4HR1QCIKSBE9qOb2A8c1GzC8XQez9LuaPPaLqssHRfm3Dr2mknXCMNnJI4ZMvX5n1ykvmHTmfFqaBY1VwCseuUE+QJaqI63vkJXGRhnhfLlX4NtRsBntCK6/COApdxIJnwZBJ6qzGZnSXXGc2UL3lShnEzwDboEociCXPvATyCudmgO+m0GVsHyQ1lBtrUBhsVglVT2N2//3DrDYu0GU6vhg1WEcBcBZM
 Cts6m4yF
 5KVmZ28SCqHUaTKqn7FOpGflPZCzqAdbM2cB2hMj+ufd5L+kr04qZPRoeHNlcSSCSP0FneEI8dVYyoQ5wWYZ7vkCeq4AOyGDaBKTb9rAOGuu1geDLXpOycP5SNBZ91L0ogCAkSd0nKy12L52T0WKmpcA5xju91x2cK9CvatCm3SEmTisT0x+Zq1Dj2YwvH4jDTBAnf6MQkOpFEeVB39Dfa6Qhkl0LBwuy8XyGLoVxki73LB6SNMSbUWZIrJoEgKL07od/ChmIfSusLnbXvv+KXyXbk3eu0WN240BiVjmGeb74d8i5sDF0k6Dfcl0/3LqQ+7VIMXj98nySnTJMI0OdwsB7iA6cwo+o7Cf/BFpUGZpkqK+oEuNYxHVSVilF/qpsUi1iCyykHKKEf9P9zmA6+rHOvgQKveGGjV+rMSaT55IKAZgAUk25zGv9Zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,

On 7/21/2026 3:34 AM, Gregory Price wrote:

> Add add_private_memory_driver_managed() to let modules hotplug
> memory onto an N_MEMORY_PRIVATE node they control.

I am trying to understand how the nid passed to
add_private_memory_driver_managed() is expected to be provisioned.

From what I can see, both node_private_register() and
__add_memory_resource() require the nid to already be present in
node_possible_map. My understanding is therefore that this patch
supports hotplugging private memory onto an existing possible node,
rather than creating a new possible node ID at runtime.

For example, in the use case I am looking at, the device's private
node is not described by firmware. Would its nid need to be reserved
during early NUMA initialization, or is there another mechanism that
I may have missed?

Also, could you please Cc me on future revisions of this series?
I would appreciate it and would be happy to follow the work:)

Thanks,
Qiqi

