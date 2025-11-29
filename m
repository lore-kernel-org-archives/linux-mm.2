Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A022D116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1F46B0011; Sat, 29 Nov 2025 04:26:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6890F6B0012; Sat, 29 Nov 2025 04:26:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5126B0023; Sat, 29 Nov 2025 04:26:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B27F6B0011
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:26:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13E9A8A998
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:26:28 +0000 (UTC)
X-FDA: 84163114056.03.9A9A00C
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf12.hostedemail.com (Postfix) with ESMTP id 223B34000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:26:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iAWqeivU;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764408386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9dVSOpcR3NajjbHJM0v+Jek+ZgTYIb8ZcFiF66ekIA=;
	b=xtvvfnXsI4fGVxF2iE8OI/sTRrxC7R4cZpepxoqdOeNWxByma8PcLmajmviXe8jl7UFHY2
	ZCMfHV/iDclhF8znZI2qE4VWmcxPs54ZOIhHZNbS98efEYhItTwo2u59Fbry95Tz3sEN3u
	zLjDQg6xEmtxMRDnM8xdion5/d8WSWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764408386; a=rsa-sha256;
	cv=none;
	b=z1us3Ux+N6+tTbmdRDYcZhfgWhck3PNfVFkJlKD1F3A4nbvRo2zRm5FRCYHrumRGN/IRnB
	gmD1eTrTjFchKUiqVeBBx6cHZB/oEDIksW/4gLVnHh2fdzYnzFZP9dC4zoC8j57d0X9Bt/
	n+EJgCrSoLFvN5Oh7GibHxWHNbiGJRM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iAWqeivU;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=e9dVSOpcR3NajjbHJM0v+Jek+ZgTYIb8ZcFiF66ekIA=;
	b=iAWqeivURbpGsCaVtOtNoNhK+3A3QPdc5EYzynM0vqm5qsEhctuFpESwUvj0IsTqCEVGPJrqD
	TjamLg1p5w2bEtnjHO2Dy2fRNExVPHlsJe+yDf8oL/w2evWSdtRf4WV+Xk4uI3cEXGJmnixpM21
	mBUfN7UzPFTCweFA0c+Ysak=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dJPrD1WKQz1prLT;
	Sat, 29 Nov 2025 17:24:28 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 22071180B3F;
	Sat, 29 Nov 2025 17:26:19 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 17:26:18 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <will@kernel.org>, <linux@armlinux.org.uk>,
	<bigeasy@linutronix.de>, <rmk+kernel@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <wangkefeng.wang@huawei.com>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Date: Sat, 29 Nov 2025 17:25:45 +0800
Message-ID: <20251129092545.5181-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251129090813.GK3538@ZenIV>
References: <20251129090813.GK3538@ZenIV>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 223B34000D
X-Stat-Signature: 7fiztgkjp9rezwpqw4jw1k9z4pjz9uat
X-HE-Tag: 1764408383-110533
X-HE-Meta: U2FsdGVkX1+7qnYr05rzWBxTELCd3AxNhkHQrS7Kny8DB7DQyu2a5moV755ZNCIZ6OVD+oghAWSkEXhN9fxlgRA87m2i/sO4RZdpVA+NQf7CAcUxbd4xEQpbouL+je37X/1fLmvt8Z+nkuasaJATFQU6siMw/tPC04lgZJDLurqJXPI9Y3W/cRQLXxSQk2RTRH2x0K1nVD26I751MdlOLwdmp7cTEDq428r1Qj8l4xGYqfLSUF8YCKjqTSeTg6kM/Kr7wZCFikq/gMxlMuSW5F71kihbT2wvbSAuuBWRTaDgJLp/QAvxhCOZJvG8D3IHyaY2yu0/W7vJXFOpvxwbW3Wj//oi5Ah+JPHLnAJkJVhk+zHygpcit0+4pQhiRVUc/5OeXF32fS2J9au2e8B+tHHtU/TStVwEUrpu230YBUqfv2q+nOZ2/VyNAa2ctUroPBoTp7XBz0FydeM1diXUJqvLDoLXfBaz9hb2HezuW3g7jOy+eDZYfRCZran4pQHkEqpEfkM4QCfn+8KOO3eAiCE5mK8itXJUw5w19/sX8y4VSP+lTXC2yUxeYWws0505viYIZAUivIhHGsr5Hc0C8cJ9tQMwKnASnh22m13qO+qhiARt/yCtkFK4G5JORv5+yp5gsRIANsvViqVVlO3cEgmPlNW6+9Ird/dLsyfdqvwqRYe0MqKyPvSBK6GTpOlDswr3LKbGoP8vLxj7YjEihnrJTZ6d2k4HAz4IL283qdghEQVF1IsB2YHM96G+jJbW7thIwGyjDGAgTOtK+I1CAyx0uz9tT1gsllwcrBw7KP9dTYzoJYOozErnpPLP9ETKEW/Zy3D7POP9CwqGHRdLGJmihoRlfJOBNAKfsvDIncpgRIM9jaFIFV4/vvoVgq4gd562jzltAelsNfxza+iAojvmZ6mG3xJtmAAIscfd5A48LBRSanhEsv6L2q6u0X8uQF5b72Y5huQJRw4rOfQ
 M8Sbo02U
 zsYFEjxJTnqAz2YN16HETp4NaPuBJ8N7t/cYI/cGhc5A08HsC7XJSNByobMZb6J/X8vRB5ullfN+AdHjFvyunJ9K75tCfYXnNUqgcuc32Wpv0GQCXCIQLFGjaIdpidcmG9WjNaDmZPvs1mReyn9Q89a5rVIxwfgfwuCpE2CIKgzwFfOQUX3cdviIUKuLyytnPeAdF+qTuBnUwsRh5cA63lqXg7EfRQK5jiAo+PBQFL0YBYQWmrCfEem+iBreWRzuFmWWlxnALTeBVdgzafH9cXgegeylknV0DZEvtLjx8CY56ELThiruRE8thdL9ZmgMMCrL39LjV9V+wf5avQc7SvkEotBXNyvnQqW4OasXvHAfU2Q34chj3s/wIzD0JqYaLKl2ZhmeMig8gmo3RpTjWYN+RL7zmbBduBSvmeljJ07Anj5mLTPtXZ4oZzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 09:08:13 +0000, Al Viro wrote:
> On Sat, Nov 29, 2025 at 12:08:17PM +0800, Xie Yuanbin wrote:
>
>> I think the `user_mode(regs)` check is necessary because the label
>> no_context actually jumps to __do_kernel_fault(), whereas page fault
>> from user mode should jump to `__do_user_fault()`.
>>
>> Alternatively, we would need to change `goto no_context` to
>> `goto bad_area`. Or perhaps I misunderstood something, please point it out.
>
> FWIW, goto bad_area has an obvious problem: uses of 'fault' value, which
> contains garbage.

Yes, I know it, I just omitted it. Thank you for pointing that out.

> or
> 	if (unlikely(addr >= TASK_SIZE)) {
> 		fault = 0;
> 		code = SEGV_MAPERR;
> 		goto bad_area;
> 	}

In fact, I have already submitted another patch, which is exactly the way
as you described:
Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com

The only difference is that I will move the judgment to before
local_irq_enable(). The reason for doing this is to fix another bug,
you can find more details about it here:
Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com
Link: https://lore.kernel.org/20251129021815.9679-1-xieyuanbin1@huawei.com

To keep the email concise, I will not repeat the description here.

Xie Yuanbin

