Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEEBCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186D68E0002; Wed,  5 Nov 2025 04:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA388E0015; Wed,  5 Nov 2025 04:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA6C8E0002; Wed,  5 Nov 2025 04:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFB2D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45C48140232
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:48 +0000 (UTC)
X-FDA: 84075970776.08.107DD6A
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5CABC000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=digW+BM2;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FlapW31xUvlYGcS13O4QYIQ+CVaiW6UdQ4SgpkTZtM=;
	b=xHAwGoZulURKrIcFnxx7jms1EJzACjOS2bGs+hCQAjjV4Wf/5wsxqZRcFGyoQQtsZsRJVF
	VpH/f36QJikXblf+IxRwiHleBVEk4h1B0jWuBScyiZhkBxTcg+Tyx/LR7ktDTQl4SJXrpC
	vCFuWA1mTJ1XCgEVN4lwH6wT89TKO4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333546; a=rsa-sha256;
	cv=none;
	b=hqeBoli7ftAI3NzDKzMgr3ErSBBvs+N2YNxGcbU3pv2UThV5Bd1X231vFXFSLnUfpXvMAo
	0ggDexwDfkK0kgIskWsfaVXcCat/Fs6ffLtjr1Fr0Y60BeXRoeyKhKT9iGaqvsvJ12M7+u
	5j5kRbBxz93efFoL4et4fjCIAQgaF64=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=digW+BM2;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3FlapW31xUvlYGcS13O4QYIQ+CVaiW6UdQ4SgpkTZtM=;
	b=digW+BM2jXGFYwMb+mh0hAvtN8QXWjSh/9jUJARGrMOqr+6QkXTRwADjHW4rgn3BecgoYOiH2
	8W91ZtvQtFeDl+WNHrvGjlaXTaaGndQ9MPCidMcblqSTMDdrJHj6+w6FM/GUabQYh+OiDVH0CJB
	nPvXSZyvX5s+5/k65fCTts8=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4d1fWr1FwPz1K96G;
	Wed,  5 Nov 2025 17:04:08 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id B94E1180044;
	Wed,  5 Nov 2025 17:05:41 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Nov 2025 17:05:40 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>, <dave.hansen@intel.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linmiaohe@huawei.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <mhocko@suse.com>,
	<mingo@redhat.com>, <nao.horiguchi@gmail.com>, <peterz@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <tglx@linutronix.de>,
	<tony.luck@intel.com>, <vbabka@suse.cz>, <will@kernel.org>, <x86@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Wed, 5 Nov 2025 17:05:36 +0800
Message-ID: <20251105090536.11676-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <57936358-69b0-4028-a0df-b5f5acc32ca9@kernel.org>
References: <57936358-69b0-4028-a0df-b5f5acc32ca9@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5CABC000B
X-Stat-Signature: 1cfdbmy56j8shccppkztwx5x8zuzmm1s
X-Rspam-User: 
X-HE-Tag: 1762333545-642163
X-HE-Meta: U2FsdGVkX1/7LFQKyytVYJyIE2CaVLyRLHXLNLlTKQGR6rvtqy+i3//anXScCHtJ/KxXhSRdtN2fpmo7Er82+n5MgZizy142RDC8ktDdpITAnVrfb7ae5Asd2sTWcyAUZXYbHBYkVssArsvKt9wWIl92SGA6zKLNqtSnBMvZbHTtsLZqvIYCIIbxu6mmSs5RH/kXE2Wjcxn3FtTXGJLBEpK2tVhTbgqaEa1e8hLeb613ubqOQGeb2oORN0aswd+DIiiag5BSBemO8rcBnmgoXth5VIBMXyF+EWjoRNZaadRxDJf3I+QP5PDEh6S2MeEXbrMoqij4/wOR3mqb/l+dYMXyHWJZFUMqaWv+aot1S1W74XhqULteBzvGayW+TS6aUSslicS/N4oxvm1MJPK1chKnsL1aE6fT0P1JpGnF1IWtVb+pD2oDt3zKTBhQeR8+eSzctBPv0uYUL3DDcOnHrnzyxJhI6M8JJYR6NL0DnVp4rBqp32YEmULZ+dgIOTagfrF/TjDx2VxsNhlTeDaF2qaoFi6XU95FPhhKYM98ZwPFnfWaEM//K3bz4GKKhBeYgcz4U/e+qtCn56qZ2Ymem1Qs5XdcnRKOR7kaw2ZzpHF6KND0QGCvkOr+BLqlXMjouAL9/m798fTlshLomUar/EleXBksvvAgEKv8732+jF4TkphFoafN44OrmZ5f3IAMCNQHUgpwp1TIPzSRE8nl9czU0lDBlH6u5MweLQshzKrxha71ljYUWXzmTQQ/pijlxj5iJbotyLOwFckid/Owl4b6vYXmyDTDdock4hquky3TAR5fGObCp/Med0JdcZFDRbpCwWG8sXX2w/6NS48nmARSQtl0mpCvSPxv3G2PAekmQiUcYJdiJb23tz60hBGfRpUrq1UjZjrph8nBFXG4L2Za07RHZv+wTZIK8HCWq2a2mbnHsKVXXa8ZL1iGe32NSf46EWDNnrFud5x3JEX
 J2CR+K6t
 xiHle3YPXvl3Kqc42TdHKP4KOEzo60RM9DwivB04R+wkbYkbY3tIIVcj2o7Tz800jIMWenL2iTVbtHJ5Ye2kIJbMI5eWJnyk+Ofdyn3DWhB5OSKFqN39wqFvgAborQQBArO/TQ7dJGvWiiI0otRkhaKAjXSCxkabHqcZ0DbJpX6AkNrz4y+5aO+/xj8p/ANF6XHEDtHm2rUNhCiBRzIyulhgnN+A00Hur/buC/rA+n76Ldvqa4aBbHfU4cXyJw5SQADr3A+O4dIOAPKYqpirfav8NYM4GyeYtyePPM2qRw/r1+h4PcSgem6C1QjFQvH4MH7pYVLWCb2UgiQ8Uz9oLG2lg6yX+xuUHBOm3Xf91mhu+/yUiQzV50snY1Stf/ag3vKtM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Nov 2025 09:12:04 +0100, Dave Hansen wrote:
> Let me clarify what we need to know:
>
> Will you (or your employer) be running such updated 32bit kernels on
> hardware that supports MCEs.
>
> In other words: is this change driver by *real demand*

Thanks! Asking like this, I completely understand now.

We won't directly upgrade the kernel to 6.18.x (or later versions) to use
this feature, but if Linux community approves these patches, we will
backport it to 5.10.x and use it. I know that the page-flags in 5.10.x
have been exhausted, but we can work around them by adjusting
SECTION_SIZE_BITS/MAX_PHYSMEM_BITS to free up a page flag.
Another patch I submitted for arm32:
Link: https://lore.kernel.org/20250922021453.3939-1-xieyuanbin1@huawei.com
, follows the same logic.

Currently, there is a clear demand for ARM32, while the demand for x86 is
still under discussion.

> or just by "oh
> look, we can enable that now, I can come up with a theoretical use case
> but I don't know if anybody would actually care"?

It can also be said that way. In fact, when developing the demand
"support MEMORY_FAILURE for 32-bit OS" in version 5.10.x, I found that the
latest version already supported this feature, so I submitted these
patches, and hope others can benefit from it as well.

> Cheers
>
> David

Thanks!

Xie Yuanbin

