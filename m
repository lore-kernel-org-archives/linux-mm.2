Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A9ED2CE17
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 02:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015E46B0007; Sun,  7 Dec 2025 21:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F996B0008; Sun,  7 Dec 2025 21:33:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45946B000A; Sun,  7 Dec 2025 21:33:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D3BF76B0007
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 21:33:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83A75899E9
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:33:05 +0000 (UTC)
X-FDA: 84194731530.16.059DA07
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39F13C000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:33:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=op1FV9mh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765161183; a=rsa-sha256;
	cv=none;
	b=1afr3UCx8KIE/XyxG+pEUHd0mBGudEFq7DmCjZTVF435QWldudzeJCkzOfn0DIBlPrT6tk
	FZ7HESPC7net19CMWOeWjOXOpJ3RuZRkD+ujkFzIhUQWwE9JHm38k8atlbB6x/nysdBO6Z
	bq9QxinzvTwvyDnVWO5uSHdJNpjz36U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=op1FV9mh;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765161183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InKH1/gynvVQk7glFamhjKgZ5wYewPEcLp8Bz6n3g0E=;
	b=4P6fDqv64i69JzxOywgrFsxwGlvHpLixG7LxUtoL7rnCT1Vv2+1WGQWySj3C/snEeMknZB
	SA+9bifZ3T9JTgl9blpzND+qS32yHKNWSrkeNcldb3sL7E3waRf3E2dJeVck5OhwNBl/T5
	7pAFDsfD+wXcAjEol3+SwFpQlRZTa0s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=InKH1/gynvVQk7glFamhjKgZ5wYewPEcLp8Bz6n3g0E=;
	b=op1FV9mhWKOiJNfy0ymBe3cwCenJiplbd147oSBh5IvbJX0GynPf0KApsHSnlDjDq8hX/Jco6
	4r+TSLkKlwoZIAPybGNW6uIFwPJ4p07fGbN+wyjzLkBqqn+StRvmZ2zc4cH9EaPNq5XZx0VhhlS
	P3UREAHZNBweKmeyLGGkNFM=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dPmF14b2jz1cyPb;
	Mon,  8 Dec 2025 10:31:01 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 072BD1A0188;
	Mon,  8 Dec 2025 10:32:57 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 8 Dec 2025 10:32:56 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>
CC: <viro@zeniv.linux.org.uk>, <akpm@linux-foundation.org>,
	<brauner@kernel.org>, <catalin.marinas@arm.com>, <hch@lst.de>,
	<jack@suse.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <pangliyuan1@huawei.com>,
	<torvalds@linux-foundation.org>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>, <wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger sleep in RCU context
Date: Mon, 8 Dec 2025 10:32:06 +0800
Message-ID: <20251208023206.44238-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aTLLLuup7TeAqFVL@shell.armlinux.org.uk>
References: <aTLLLuup7TeAqFVL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F13C000A
X-Rspamd-Server: rspam10
X-Stat-Signature: 5spgi69mzoqaqmn87kakg4sabmftcd49
X-HE-Tag: 1765161181-564733
X-HE-Meta: U2FsdGVkX18Wt6tjHwxhAiK09omdXAnTXd3eMP5KXgb9KC/njd1rux4wzrCG/NNLDoan6bh0qCv4xe61lx8HPfWR0b5tB4LsvZOf3i0JkLJq6Agl25LPwkUhqlljkxafpLNJqLpctUjqyWgUqTUpTrLrG0/NoEB7MvYGLPRJ347Zsqa5OH++ksA0xnYUklxJreNCpIvdSsUnvaMCuLcHYR9Q95KLXxB7jbKGGMb0vEZjIGmbZ4LsYR6BxZ4ejnJ0d+CQ9luLbZeARgVq9IO57YGSW5zXA5s1thprtc4CvB3HIC9TqQFSdCH33ajL5qFOY8q8iRqn+N+aXPUeGHrTsBM304L1greVUHZdNFZx1VSkY1dh6QSO/aSGQOv+Ba6m1Jhj1tGzNmjglMRgobJVDpi7mw5qBUwBIUpMp704gVCT9BnBKtVbgsW4UwLT9dQer0t5+i9N9QPLR0xRYW973m5YXeWCXBH2W3ogVGLt4lLz+1/A5GR/75Qtmv1seyuJtF3lIRuYbdYgwEbETFZf9m0709+5ZmEVaaKI4qTLJK9j7Q/6l7AG6Y0Nqd59o75HTXVR2+3p9oa37jUIFB3it4Y+2foqMSyUupBPyJWlBRIk/4amQs1Bb+Y/t2D+dQY4zOXk6pJZnwQqnd1krgqPSyaIa7jPohCIq8IZ40H+IolB8S5EBvUhAXcFoutLyQDMChaE47qbZHaoqC349s9kVcLoILENEgM7bmcz/QQm+/ReJWnBoks0Ckhh8fqCjlKFinPbt5fbc6XxaKI4/KZw+FOLzYNxhkNkZw34K83SLV4zSqC0sSiLofuVGGuiWur/PpwMRKgrx4DFJYZnaVKhNe94wyAffCTRTG8zfJJDdBqA6MqRi5lU9b/Ll3MoZXqIDQz4jmJF4QZ8XTOvoWVvupKElBGGTt+TABsaMpPcxTuTsBHJ9KMWQRrMSLOVdQ2Eh/Pozovej1cO/KnKVic
 aXo8yd6W
 SX3r/HoiuxCgqCCLotExGQXiyKZ5wBAO43guwsBeYxkQA42n28P87iBn9njv9o/ucGXtfreiEsxlviu37/FQYtojDQKz+NQMKE4A8VCrqYCMmxRauXKCfx4hmPNk/7YgIvfgm1ayiN70PwH1VaC/L3OBKsthBtkGpnraZVFdrOcl4mgGfhR1VwWPJviTpIJImvOLwhPu1IHPWiKC+JA/3dsii2hYGTRwCsylbF8iQPonx4DJuMdVDOpaii3H1K0Ezp6EhHMFuDQCCKUo3rjaINVrTfVNIVI4EpEqd5dRWz2zTesaifaRvcnI/4XBZTUefbhNlQjFhXpuWCgi6dO0HlvOVfKz4TaJDK8LFdLeANjruS6cEwrLCffhRW6rL4XGaT+Og9ML1pFgr4RLC2R1fHsBrsypVUCh29MJJ3XSLsa8qjTc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Dec 2025 12:08:14 +0000, Russell King wrote:
> On Wed, Dec 03, 2025 at 09:48:00AM +0800, Xie Yuanbin wrote:
>> On Tue, 2 Dec 2025 14:07:25 -0800, Linus Torvalds wrote:
>> > On Tue, 2 Dec 2025 at 04:43, Russell King (Oracle)
>> > <linux@armlinux.org.uk> wrote:
>> >>
>> >> What I'm thinking is to address both of these by handling kernel space
>> >> page faults (which will be permission or PTE-not-present) separately
>> >> (not even build tested):
>> >
>> > That patch looks sane to me.
>> >
>> > But I also didn't build test it, just scanned it visually ;)
>>
>> That patch removes harden_branch_predictor() from __do_user_fault(), and
>> moves it to do_page_fault()->do_kernel_address_page_fault().
>> This resolves previously mentioned kernel warning issue. However,
>> __do_user_fault() is not only called by do_page_fault(), it is
>> alse called by do_bad_area(), do_sect_fault() and do_translation_fault().
>>
>> So I think that some harden_branch_predictor() is missing on other paths.
>> According to my tests, when CONFIG_ARM_LPAE=n, harden_branch_predictor()
>> will never be called anymore, even if a user program trys to access the
>> kernel address.
>>
>> Or perhaps I've misunderstood something, could you please point it out?
>> Thank you very much.
>
> Right, let's split these issues into separate patches. Please test this
> patch, which should address only the hash_name() fault issue, and
> provides the basis for fixing the branch predictor issue.

I conducted a simple test, and it seems that both the hash_name()
might sleep issue and the branch predictor issue have been fixed.

BTW, even with this patch, test cases may still fail. There is another
bug in hash_name() will also be triggered by the testcase, which will be
fixed in this patch:
Link: https://lore.kernel.org/20251127025848.363992-1-pangliyuan1@huawei.com

Test case is from:
Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com

Test in commit 6987d58a9cbc5bd57c98 ("Add linux-next specific files for
20251205") from linux-next branch.

I still have a question about this patch: Is 
```patch
+		if (interrupts_enabled(regs))
+			local_irq_enable();
```
necessary? Although this implementation is closer to the original code,
which can reduce side effects, do_bad_area(), do_sect_fault(),
and do_translation_fault() all call __do_kernel_fault() with interrupts
disabled.

Thanks very much!

