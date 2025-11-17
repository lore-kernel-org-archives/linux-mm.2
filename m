Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F31CCD19A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 02:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654EA8E0037; Sun, 16 Nov 2025 21:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C748E0002; Sun, 16 Nov 2025 21:10:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569338E0037; Sun, 16 Nov 2025 21:10:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42B298E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:10:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2E9B140BB8
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:10:09 +0000 (UTC)
X-FDA: 84118468938.24.6613DF9
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf05.hostedemail.com (Postfix) with ESMTP id 585BC10000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:10:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GqKMFn4h;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763345408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7Y6XYREVDrTlIKlXW2v3xJEZxi1M/dJuCWaFDLWagU=;
	b=lmh3H9gc/CJpep0uTeyJ433vXxkA0shdqHrol002UznP2CkM4ksFSa9/VxLCn9a9jnACy9
	j4O8F+RrvqQRJN5KqZVHT+9T77QIh/yucXZOl0Z5uQrGiyxAVqpGj3Cx/6ESfpLbhubJKO
	nrxN3gHfff70x6tAejItXMa+cpNShwM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=GqKMFn4h;
	spf=pass (imf05.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763345408; a=rsa-sha256;
	cv=none;
	b=kpK0lZ337MCvHctnRzL2zbV4OyCEae2p3zQiwP4P0hyoBRFgNAVMeNxZ+lW3peYaJSETvE
	8/OBHrZYYekxHI2TxRxSBHvvJqRlVhNgzv+dgxkjuNVped3c4WqBp0YiYnrDEdEc/tfcny
	t+V614kjJMCWOSXsdgM6ikYzKQKU92A=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=X7Y6XYREVDrTlIKlXW2v3xJEZxi1M/dJuCWaFDLWagU=;
	b=GqKMFn4hrgz/7+a7VlTwkZ7LAy/YashcLHAR6DihClhzZs1HJ2ZGohFBRhsAFDJqzNF9xvzfj
	nMqGwtPGA9Eed26rzkAheMWNngjxm2ubWY2xV9cn5D4jW6FIF2KZje8k8hnm7GhUvjlRFrXaLZ+
	5kbvK/uBPS9UEVbAv48nNoY=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d8rkn5F8pznTW3;
	Mon, 17 Nov 2025 10:08:33 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 86224140296;
	Mon, 17 Nov 2025 10:10:02 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 17 Nov 2025 10:10:01 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <xieyuanbin1@huawei.com>, <david@kernel.org>, <dave.hansen@intel.com>,
	<david@redhat.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linmiaohe@huawei.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <mhocko@suse.com>,
	<mingo@redhat.com>, <nao.horiguchi@gmail.com>, <peterz@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <tglx@linutronix.de>,
	<tony.luck@intel.com>, <vbabka@suse.cz>, <will@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Mon, 17 Nov 2025 10:09:56 +0800
Message-ID: <20251117020956.7071-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105090536.11676-1-xieyuanbin1@huawei.com>
References: <20251105090536.11676-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 585BC10000B
X-Stat-Signature: ehgk7ubcrp5ffmcjyjktyuqx7xwywdw7
X-Rspam-User: 
X-HE-Tag: 1763345406-193355
X-HE-Meta: U2FsdGVkX1++FQbtvmnVJW8UoW4k+T6c46YIqQUJQQnGBebexROuwYB/0rvcojVC0LyGFjhxoYeFm/jB8Qn623K6IMyx04S71Iup6JT7dKWvRKeW7oS8xJ2JHZ5Dmh2EO8uD39IPTQnq5hNF2PvFbQvVpc3C45XZfn8AcGWxGqv7W/Kv53LLWNW1zgfSJdL57XSlMSBexMd3scovSxRkHH9rrYbUQxB8JG0FXp2sPs8/3ozkKAHNACFTwXrCsmlunVDQwKdHYUIRC+TRc9ECjlehPzdgIchIxDkNbP9hhGgJfJsXkTC2KJqjU+cKsR293IPg7Kd4mNSb5WQBFHVcQQrVVQtUXUSPnLcIAJI3eVFeSf+LM5rLLToafFbIaHHHS8pRPB1HAUyUZt1DoT1RRy6GjlRsR+ZMtx0rtOpttZk70uZsq3SRehb8q8/6VMYgpdHUqMVGffTFb85Hh6sGMta1UBQQEAVTHEz+33StaaPJhOhdOFxEK4c9Y3d3v50Td4/4e2/MlEpHoM5ddvzNVzTcbajcrZEO+IBcRKpUM2DGBaHYU/2l9M8FxbUnLbdeHCBDJhKLp5P5kgssH5hO+sSEsa2bGk1PEGu2pboFVxXUk8P0zmNnmQhf1D+wfNJTI4W+t4PNI1CJYWfI9Q+vh5RKKRXb4bx9nVyrXR97dKIP8DjFvLNEmdyZ2IMR4N3tzbnWS7X3Qco152NE37O8gtvrTmG55aOJ5xupBeLDOx2u1vB7fewYXXu42XVKNaxn+09G66hvxf3tOhXy93xNMgzRbIT082JRY8DNdaytjLH3z+GqMtw4X3VwiEu4c87W+culjO273fTS4f+Fw+O7qW9ZDEC3032hhJYrRePcAh62Z6pF04DJVip6Mi2lxlgaMzud/RD7q73oz2gkr87hw27Tj8Qo6eIwx9jL0cwRo8QrXhBECLZqbLi5j/CZxrsMcu5XyB1Cc6S8EyfKY0s
 wOYccK/Z
 8aBG7de7rT1wc70/pBaqoW/iee3gw6ym/r0+JgSHuBFKBTHIRmc1BP1xPrAjstCqeeGndXwW0aZJIRP6YcABXQRE6HnKF5UJ3kc2CImldHtjigBWmvVbBH9q9zx+NmxK578QFzV6P9eoL0Ad2SJYzWkPyJ22VVgq5Unff9VpahOm5mt9eqOwU6nV99Ce74obq0VEnGste/satOxLHHsRrRFkVp8Qm2HdiQxASRw7+lcu/fSJmCtyJWEHMwU8zVmCBlw3c4S2lk6g+7GXqAKf6heu+EWmldHYfd/uli7vCSRkz5g/KCIpo//JWWDH1gISwt2DqetdIqPm9ZLlvAYMhh+t9aNZggeFKiZEebwBx+ZF1SfwnpxY1cbbOqI4zDKTYULgV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Nov 2025 17:05:36 +0800, Xie Yuanbin wrote:
> On Wed, 5 Nov 2025 09:12:04 +0100, Dave Hansen wrote:
>> Let me clarify what we need to know:
>>
>> Will you (or your employer) be running such updated 32bit kernels on
>> hardware that supports MCEs.
>>
>> In other words: is this change driver by *real demand*
>
> Thanks! Asking like this, I completely understand now.
>
> We won't directly upgrade the kernel to 6.18.x (or later versions) to use
> this feature, but if Linux community approves these patches, we will
> backport it to 5.10.x and use it. I know that the page-flags in 5.10.x
> have been exhausted, but we can work around them by adjusting
> SECTION_SIZE_BITS/MAX_PHYSMEM_BITS to free up a page flag.
> Another patch I submitted for arm32:
> Link: https://lore.kernel.org/20250922021453.3939-1-xieyuanbin1@huawei.com
> , follows the same logic.
>
> Currently, there is a clear demand for ARM32, while the demand for x86 is
> still under discussion.
>
>> or just by "oh
>> look, we can enable that now, I can come up with a theoretical use case
>> but I don't know if anybody would actually care"?
>
> It can also be said that way. In fact, when developing the demand
> "support MEMORY_FAILURE for 32-bit OS" in version 5.10.x, I found that the
> latest version already supported this feature, so I submitted these
> patches, and hope others can benefit from it as well.

Hello, David Hildenbrand and Dave Hansen!

Do you have any other comments on this patch? If you think that
supporting memory-failure on x86_32 is meaningless, I will only submit
patch 2 in the v3 patches.

Thank you very much!

Xie Yuanbin

