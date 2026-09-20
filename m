Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69149C982DF
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 03:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4053A6B0088; Sat, 19 Sep 2026 23:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38F026B008A; Sat, 19 Sep 2026 23:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257CE6B008C; Sat, 19 Sep 2026 23:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDCA46B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:14:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45721A59D6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:14:05 +0000 (UTC)
X-FDA: 85232671650.14.5A395D2
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A23E40004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:14:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="vdnPyXL/";
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789874043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6VD7DCnH5Wvn+wLxKkGYY5QQQQVDg52h78IKUBAQi8=;
	b=hkq14hEkIZ1o2YEVEwhA4dy9fmXEIA4FavC5mwolGyWG9sa6Qa3b4YYB2a+SRVyfWFVig2
	VkebBQtoorSoQ+B5JBOg3TTTNFWdcNdAOdA3WUvEDEvvzXZrQlXMRTYS8D4zUfdqOC/va0
	8XHTt7vW8Ty2FU27Aq+oeNRVOI2YTU8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="vdnPyXL/";
	spf=pass (imf01.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789874043;
	b=sswcmjSZHYRjw+vFowgvE7D8VTF/07RboUnIyrF+f5gIunFmJsCLmIohzIuRmAMhEH58wv
	6ADfXguUWgWWHFLLJA5vDBrz/qNOaNMSE0ky75uIJzgHzxvb4BFlTf36Aed+eaUqOOP3+Z
	jRUlbxygkzewipzG2myGTBwFdRa4hgA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y6VD7DCnH5Wvn+wLxKkGYY5QQQQVDg52h78IKUBAQi8=;
	b=vdnPyXL/sZl6KsrVijZZPPrCyCxRV/tFodClDTuKzGvY6Af9QA/vmT7WI7iRz+JtR0iJaghc9
	rWMdPn+sthbDccaL/g5uqlDOWi+EKPS9b8rocHseUe3ni4l7EY17RAxGh2/pEBTk4sDiwv9WLI3
	CaDH9HqNKl1QubrRmWw4cks=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hnWPr3jKKz1prQs;
	Sun, 20 Sep 2026 11:02:56 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id C57E740537;
	Sun, 20 Sep 2026 11:13:58 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 20 Sep 2026 11:13:55 +0800
Message-ID: <97dce1c2-827a-437f-bff0-9c7057cc2923@huawei.com>
Date: Sun, 20 Sep 2026 11:13:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/17] crash: Rework and add arm64 crash hotplug
 support
To: Breno Leitao <leitao@debian.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<gshan@redhat.com>, <ardb@kernel.org>, <james.morse@arm.com>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <robh@kernel.org>,
	<coxu@redhat.com>, <tangyouling@kylinos.cn>, <liukexin@kylinos.cn>,
	<guodongtai@kylinos.cn>, <maqianga@uniontech.com>,
	<zhangtianyang@loongson.cn>, <blum@kernel.org>, <adityag@linux.ibm.com>,
	<chao.gao@intel.com>, <kas@kernel.org>, <vishal.l.verma@intel.com>,
	<seanjc@google.com>, <piliu@redhat.com>, <jbouron@amazon.com>,
	<me@linux.beauty>, <mclapinski@google.com>, <graf@amazon.com>,
	<bgwin@google.com>, <eric.devolder@oracle.com>, <hbathini@linux.ibm.com>,
	<takahiro.akashi@linaro.org>, <lizhengyu3@huawei.com>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <driver-core@lists.linux.dev>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <aq0UR62q6gGJUQ49@gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <aq0UR62q6gGJUQ49@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Stat-Signature: 784aq1ce9tq8hpgstyt3fb556apcep8o
X-Rspamd-Queue-Id: 9A23E40004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789874042-540909
X-HE-Meta: U2FsdGVkX1/wxqiy+ifEaaW5bHXflX9VSD3EBBYh+oTsB1zKGNCa+rpzcMTmmljp8Zi4Q1Y9PFsFHSvr8CW3mnSTfxAhRz5VWnFIgF05y8MwKqiwp8BXdGy19huJRYqwEXhhZqNoJ9ef4JdRo/Dy3uPIJHUMUDxF5MqIKXUk9p1iMtF3bsUhO5JEccR6oo8OuZhpqYyt+3vHWy0l+/gIXqYJQ9zTDbFfFOJK9+2M2sWHmDplCEIP2QgET9Ajd4HyWX9KUbrWsW8sU2njnCRreqAgXcDTcwTvLFR74I9BeaM4bm6Q4KAE17sh0PusEhLwAZePkdIjRGnLKgfEjZbk8f9+mUZ3Tsl0iFrqrTTi7wBRnM+FXVWKTz0I2z3be+CaZFK3X12vfRJNdMXWNp/R7GfVw0R+3+ugY4CUQHiF4Jdoh4aCljA7X4Qggc5ffLwrtSIpB67rh9ZXBOL19/VV4leWbdF06mIJ9yvBUk/iYz6XHp+9VpBDFMKJ8bi6FISHzcYqTFWH3I7dRvOvkmcjYry5eAweCYq/Irv5LLv6qberGFcW2jcSueIHr6gCLx6pMYBtl/AxFhEhzwZdp+gC2/E3ySJcWb8WLs8DjqOgxvsq//YeYM2qcszQGfF3XubT1HiU4ttLBWarLhL8Z5vc4rUBt2nYiDkT7KqwRpN/1+lTP6/QUi2PMo4Ixkbf4URsieyqFSJOtrM2LjeRFDsT9bQN6jx3Q3Sq1boPrPUqdNGrlRyqZvWn3Ttbkh0ztGMg43H+VbB2QvGwlUi7UE8++Zujvgub1qxWi/QoN9lZd8NX93BrdNIj4rx3D/GI9GEJC2HqV+prcrIgYk73W0FZgKrVW/iotypgKsMI6ubW3fDGFysdtq1PRK2+Vdn5JIa8uwxokaNLX5ZSkj7z5iDTtayc5NRDO2JpJXiz91UP4g5HArOHNfBlhp2Czl6YzX17IzW545nfAd1HxZAFWhn
 civ6ycHs
 lPp1SX912r2kgyso28h9e3pfzkhQlqRM0jqvcYUQoysNvJrG823WurTSY6UVCogTXZHkv6wbBtk7/oGG2qSGTYqe+9xFvgvDu/DlmzXdr5CTc2ZTTB624os7UwejPIWIjd2ih+r9dF1DA9QAB1/Wx2nkSeU6DOjOFHwPFp90HpcFBcEqmnaAKbTzN/eRAgBoWhrAazCDQqM8MW0T9fa9XZx4G+GKktixRHOkfC9+kQhFQT3nqt5KhRIlheOZoKrdlCpidqe1VfdzV6i3/Exi8VkEzzUVPlnUaEo5m1TOVp/DpCQxXUlP2Ud6ruABeHJD/i7h0zEo6sC6fvL184n03bRDV8Fh6TWCDd0vncrPlDD7QUkWNYs6KFci6AOMRYWoPVMwwK4yvjwGQbBnExt5UN2GpROxKqVl6hLM/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/18 18:41, Breno Leitao 写道:
> On Fri, Sep 18, 2026 at 06:04:25PM +0800, Jinjie Ruan wrote:
>> When CPU or memory hotplug events occur, the elfcorehdr in the kdump
>> image becomes stale, potentially leading to incomplete crash dumps.
> 
> Looking through the series, it seems to mix bug fixes with new
> feature work. Would it make sense to split out the fixes so they
> can land independently, and keep the new features as a separate
> patchset?

Hi, Breno,

Thanks for the review. I agree with splitting the series. I will
separate the bug fixes into an independent patchset so you can pick them
up more easily. Please note that the arm64 crash hotplug feature depends
on these fixes, so they need to land first. I will send out the split
patches soon.

> 
> I'm currently rolling out crashdump CMA across the Meta fleet, so
> right now I care mostly about picking up isolated bug fixes. As it
> stands, it's difficult to tell which patches are fixes and which
> are features.

Only the last three patches are related to the feature, and all the
preceding patches are bug fixes. I will separate them out.


-- 
Best regards,
Jinjie


