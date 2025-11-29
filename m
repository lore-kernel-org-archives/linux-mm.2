Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104E6CFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 10:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2742E6B0023; Sat, 29 Nov 2025 05:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BCE6B0024; Sat, 29 Nov 2025 05:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188866B0026; Sat, 29 Nov 2025 05:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0973A6B0023
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 05:06:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71ED0C0944
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 10:06:11 +0000 (UTC)
X-FDA: 84163214142.24.A240467
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3660EC000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 10:06:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LKw3pcCh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764410769; a=rsa-sha256;
	cv=none;
	b=jwu+B3Tix069P+s85t4ynYHiIcttxQYUsAaRQBXcDF5wGufgrC/BuAyhY+gI3VsLV2E4x4
	1iggUKHv5Iqs5vsLg0HOQktwojchXW2TKc0RWYgtO//sZL5km/RfrsTPCj/hHYLGUgkfEI
	Ov8LRLghiMjtFBu1tt410pkBSe+M6pg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=LKw3pcCh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764410769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BisTJGQsAm8JxGS/FGbNQObzPYii/zoODGDdLNjCUjY=;
	b=ykGpZjchtSF97fO2CvgHrHrACmeFqnIxLGVWtwoTCiyZgldlGJMkso9zZqEd8dla+bnxb3
	NyC8k+F9f/T4WOOOTXuiT6FOdRrD5dj5cG7dcmN/b50e29hacqPaxYqkqobj99MZUGYgr+
	wFR5Tr1y8t7eAhIl80jAZgd4TVjmGFs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BisTJGQsAm8JxGS/FGbNQObzPYii/zoODGDdLNjCUjY=;
	b=LKw3pcChJY2cUq4YiMXDkqNKW1uu83CtT1Cn4XFrVavk9ZQBIgR9Sk+X+35pioEYv2visZasm
	L7+qSHl9jVwbawTaPiWHj9ttZntzmPQGQrcL95wodeDPDdbzBFohB+QJAOkM4kypwIn+YrfvhCo
	2pm5hyMdQxDlt5ORb9dDcS4=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dJQjT1yWtzcZyW;
	Sat, 29 Nov 2025 18:03:41 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id D16C8180B4E;
	Sat, 29 Nov 2025 18:06:01 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 18:06:00 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>
CC: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<bigeasy@linutronix.de>, <brauner@kernel.org>, <catalin.marinas@arm.com>,
	<hch@lst.de>, <jack@suse.com>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <pangliyuan1@huawei.com>,
	<rmk+kernel@armlinux.org.uk>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>, <wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Date: Sat, 29 Nov 2025 18:05:57 +0800
Message-ID: <20251129100557.10610-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251129094448.GL3538@ZenIV>
References: <20251129094448.GL3538@ZenIV>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3660EC000D
X-Stat-Signature: 5ji8exnbcgmwyq6o534nuth819y53e17
X-Rspam-User: 
X-HE-Tag: 1764410767-560464
X-HE-Meta: U2FsdGVkX184MWpCj5Z0qOsS9NnSwUKf6AsBmMCaDDGDV19vI6r6z0hIE78W81Lg76m/li02KoXIpwNUmtyIVOkYA5P6XNyqGz3TjgS/aQVC85QGNUbQUbK2dedg9qFz5IkcSsGdL6vY5+qCTS9rSHmsx5TTDxAbNRbaF1fWSovC88RThWM7QBqymM7nVle6H8ACnfZilDCR7cuA3HcJxLeUUHlKlmgWhxyYPkAeDG2u23OCzYcKn/koXKY2odxisrcBAuMZFH/WjZM//yuyPULervpYkmyA8L2P+XDgm+AoQ2ayFVL/16W6DoGCghqz4KX0o+8kmMkmORYQd9DalAVeXnSguFt4z/W+w02dJfzwIpRd7nfgSN/mlEC+gQpZCxC/oFUrEPAWmTzX4KRG1hJzkcjCGDvDFXe/kDbFxKhHk9RmqrB6E+8tMiXR+5EjnIfIyxU1EgOFZvnYDULAY5gBr9iOWCNNyigPCBq2p+0ky8jQVb/RUp65ArfB4iKoN5Bm1euTfcqwAV6LOg9jLccvQbVa9HXp0kJWjOat6XqfdgZLwrGiWdvWzTi9gg/IQfas5J6+b5XH3RIjDcHQTJWsE0AovUl3v4dsA8DQZiQS+vaVgYecBXSlSEL7gnG0M2mWSoVdfavl4BjbAtKe77pn/3SEpHnXLi2OPNraLhZnOrFKMvdPOCvOLGfDEl7GoNlxCn2V7yqfSxZmSw3jw0zy7mMStZ8HEZso2ih4IcckLk/GdV7Bvq82c7zmsqlHZcg0kHsZvNKR1Y8I4VCb6rM14VlMsrX7bFSV8hzdTw2GPXUm5xlRrYFduduFDZLGQUBo2isXDypBYJJ+VN2z3PilGKKNg7jateWsa51OyiZ0zw0tMsGhm/d8tY6xSCpLTXFJq7zdnBpZvrNpuRMPGN4xvJlgRBvB439cKvOcbLe8ToFAFpHu+mXh3Wrv4j6Y1bHCgi5ewzdI6Z9S2ue
 XiNtU/mg
 SGcuh9GlmHYco/MXoy6u3Q3tnqbkgq03GujSsH7KP/UPQ9Jj1ytufmYdGItN7tjv0CGj2MYDpdZW99Z0kByLN7Kiw1ib5OPVNH+NY9IkqkYsrX8QPSOrv+PRmLqsBza++g/7SRfX+Gl4/95QjHnGHFigkdjG+1BrqpkngNNHl8dFal08FMTbIrMP8+Migkw6AjiEpmYnZtzQDS2IYO/mIxbhmeYuYkfh8oT/qCvxhuXHBsN82eZy5SrUY3q0QqaD5nC+jNVY6LkMXXPxpcMnNDSUOGq2IpnRcu9tKUe6taGdefxMDg9y2U64wAZBYMxBtaJJKP0Van4wVn4qrkNNmBcDsuKM2TWGsCWf7QDd9FVM00S5+X2grRwjRmND+LD/4JbuSudqqOyNNy5tNJVoyT991IenrMUdt8M1sjXV7Api4ch+4fAn0SoOyCIWZlNsGvuFXPofGNTRUX3mPf3eO3lT/VA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 09:44:48 +0000, Al Viro wrote:
> On Sat, Nov 29, 2025 at 05:25:45PM +0800, Xie Yuanbin wrote:
>> In fact, I have already submitted another patch, which is exactly the way
>> as you described:
>> Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com
>>
>> The only difference is that I will move the judgment to before
>> local_irq_enable(). The reason for doing this is to fix another bug,
>> you can find more details about it here:
>> Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com
>> Link: https://lore.kernel.org/20251129021815.9679-1-xieyuanbin1@huawei.com
>
>AFAICS, your patch does nothing to the case when we hit kernel address from
>kernel mode, which is what triggers that "block in RCU mode for no good reason"
>fun...

I'm a little confused. Which patch are you referring to?

BTW, I'm trying my best to fix both of these two bugs (might_sleep() in
RCU Read Critical Section and missing harden_branch_predictor()
mitigation):
Link: https://lore.kernel.org/20251126090505.3057219-1-wozizhi@huaweicloud.com
Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com
at the same time, because I feel that the solutions of these two bugs are
very similar in some way. And there is a preliminary solution in place:
```patch
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 2bc828a1940c..5c58072d8235 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -270,10 +270,15 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
 
+	if (unlikely(addr >= TASK_SIZE)) {
+		fault = 0;
+		code = SEGV_MAPERR;
+		goto bad_area;
+	}
 
 	/* Enable interrupts if they were enabled in the parent context. */
 	if (interrupts_enabled(regs))
 		local_irq_enable();
```
Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com

I'm not sure if I'm doing the right thing. Do you have any suggestions for
this?

Thanks very much!

Xie Yuanbin

