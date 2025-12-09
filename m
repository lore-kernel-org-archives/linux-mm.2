Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC46D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59EB6B0005; Mon,  8 Dec 2025 20:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A476B0007; Mon,  8 Dec 2025 20:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FFD6B0008; Mon,  8 Dec 2025 20:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80B8E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:30:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AC52589BA
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:30:34 +0000 (UTC)
X-FDA: 84198202788.14.E422B99
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C335120006
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:30:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S0Onu6kY;
	spf=pass (imf29.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765243832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaN56bNHDdaDU4xaAsWBhkgyh1tI7ov9fWzaVcBUtA8=;
	b=oB5fzgsw2zedDKzInpI8DX//AKnoPsjNd1gmz/lJGUVgZgnuiq8+jZjl5Nhl7hoAwneqGO
	oxeZff6VyTIFCQqLpMw9FBlUxRAHQDr5rOgj9YAs4ZUuOn78T3NpS3/sH16aticRyRM89A
	Sfb7kqA/bzroSWeS9BG4PwbAegCREYM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765243832; a=rsa-sha256;
	cv=none;
	b=mu1EURaEcusDtVyylchlhSyIsjyzrsOu8Cl8sM4/ElajxN5k6piSB55eEnfuHy20p/ShWM
	hUqaDdgtm4nXeBtN65xEP+gDGR1FTpFBJYoGApEj6+YTthsvQ3+vRztqtONM8wPjBnXbUQ
	gaaqjIv+6tcC7/9sPU9YGroBibUEYdM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S0Onu6kY;
	spf=pass (imf29.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EaN56bNHDdaDU4xaAsWBhkgyh1tI7ov9fWzaVcBUtA8=;
	b=S0Onu6kYl9D8cUbpZTYsCtWPafYB7opD91x91GJEgAsQozI1jQu1RjI3r+YUxODEgOrBO16G4
	4rudE/tl/ISBlGPl73FxPE7obeVr4McmRTQApR9kNXgBFAfoNDCG51gTbJjvPO6iIYhfcJjKNJ/
	i74oJ0pNGViS2Nr3mDxm6bI=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dQLpK2wChz1T4GD;
	Tue,  9 Dec 2025 09:28:25 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id D0A49180BD8;
	Tue,  9 Dec 2025 09:30:25 +0800 (CST)
Received: from DESKTOP-A37P9LK.china.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Dec 2025 09:30:24 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <torvalds@linux-foundation.org>,
	<viro@zeniv.linux.org.uk>, <wangkefeng.wang@huawei.com>, <will@kernel.org>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Tue, 9 Dec 2025 09:30:21 +0800
Message-ID: <20251209013021.2537-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aTbyPNINxjzU3Lua@shell.armlinux.org.uk>
References: <aTbyPNINxjzU3Lua@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C335120006
X-Stat-Signature: m6oot37huaxno1yzckb88ecw74zgssek
X-Rspam-User: 
X-HE-Tag: 1765243830-889732
X-HE-Meta: U2FsdGVkX19XtNGVDekkhgaUgyAO3E7aNDDrRlm1fZZS4CZ/7noAcfFS7Bj34a6+fGf8sFCSe8aQOFMq3U07f1IVaEIPS94PV81HDxLnH1eghsKygQnJyI+Gerv4VhGcV+Vip4ZoiByeI1y27eq3nvVDXaLaVl8EZo6lc7W/MAXhIZTlqZemw4GIg7iaSE7f8ethxqZonmUJQUvt/PXJC4N7bLA5zA8RtHmZv1u/9jXuwAToFKaMSRtVH0PRF3NbQzeDrwO3Gl2Yc88TWJi0l47lvaCL+F2sfmE1gPTpno0jB2ZsEJpx8ysUM8QKUEPMCXzEj3g1lHNx3KAll5iWTYq8Po8xFTF1z4Ml6AtEtkctWJGjl7MqJToZD/hrN9YXMY4XVT3gURW2jdmKDf121diFbsEHzkwvpqd+NvxNPGIqC5p+McX9jQuw4dC9t9Ac3dC+7iQfb0oTicgC8/Y/TjMSQYVggZCJTRf8xxFpEO/lIucH25GVA/AxYG1/g/B/JKRzOTZbWtRLV1il3aloWIQbE3YgqCLxIXeU84r5lN3ZswvtpmGZTZCAE4YfWX7pcBX7H26/WL0snUzet3pZEZ8RS3pj8d/75lWqJvoJ6I9ShyR1xsEXQhPf7/Jr8EpJ+0jML4CVEucLB5bhou8dyuWGr3E6F5XQ/k98x9b89mGiTQrJNi2d7XUHi8N87HlYGzAc1IztyZjrr/2n+Jqn3JKNtt9r9MBq6Qyv3Zji1lLL/SHcxU+75KcKZlItEqoUcWaEj72n/rBXOsNm0lrLo94MPbcsQUpPGDzAm0uZFmEm1+VUHaA4xCtG8BXSwGHiritmOqoaxEGSPMqWeIWkahdYM/edkcrtphRxUwl76d1VpytBLzbmhVVDPcZ6u7CLvqh8tWWtABUlKzj25vxeclcJbZ5oCfwTqr0UHKgfZBhuo06vKFYcU9NBxMt53HajmxV+SWCQCdBXFdqTJ0u
 cwKfBh25
 yYYYiZ+tVISAYZcYzGdDGz3kzGPCxPeYLiZ+7d1PTbyjFFCA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 15:43:56 +0000, Russell King wrote:
> On Mon, Dec 08, 2025 at 09:18:42PM +0800, Xie Yuanbin wrote:
>> I had indeed been lacking in consideration regarding do_alignment()
>> before, so thank you for reply. But, may I ask that, is there a scenario
>> where user-mode access to kernel addresses causes an alignment fault
>> (do_alignment())?
>
> If you mean, won't permission errors be detected first, then no.
> Alignment is one of the first things that is checked if alignment
> faults are enabled.
>
> So yes, if userspace attempts an unaigned load of a kernel address,
> and the CPU does not support / have enabled unaigned load support,
> then we will get a data abort with the FSR indicating an alignment
> fault. So do_alignment() wil be entered.
>
> Whether branch predictor handling needs to happen in this path is
> a separate question, but as it's highly likely we'll take an
> exception anyway and userspace is doing Bad Stuff, I feel it's
> better to be over-cautious.

Thanks for your reply. I know it now, and thank you.

