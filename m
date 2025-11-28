Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8771ACFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 01:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2FF56B000E; Thu, 27 Nov 2025 20:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E071E6B0010; Thu, 27 Nov 2025 20:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45656B0012; Thu, 27 Nov 2025 20:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C28326B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:41:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 667AE1A0300
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:41:30 +0000 (UTC)
X-FDA: 84158313540.05.50656AA
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEDDF40007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 01:41:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VuQi7oK1;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764294088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=In5Ymo73nmHkrOlmrEIqIHf+K2Funf1kBVHFkcyRhAI=;
	b=nHCyOECaO8xM/R/BXO64mP8Zrhy0FUZI+OgWJaaMdaVIVeaPYDgYgbCXq6kZsixAH3NA0P
	6ecVRZTDFSyBknAtqaqFnyzowz12+ND/0U6D5Uy8pbIdUQiJ3IRRon2/YAW9scnKC5+YFn
	SftEMvgMIdy2i8exC9xbJHKKYYFnn/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764294088; a=rsa-sha256;
	cv=none;
	b=Wa4IElTCLG5cfjTVyvEvUAdwc9D42K5ghCb7JioIa6RXSX4k+ameJUjXOwWyHeTuo2jeH8
	kx9lf84iI/1Gb9WBY3jKPFOFBJ8Pj00ChwGsGOwzEVwMW2mg+DDFUvJZXNrs2QGb+ROLsF
	gfNCwv8y8pJHDa7AbDTpy6e+eIIcrZo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VuQi7oK1;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=In5Ymo73nmHkrOlmrEIqIHf+K2Funf1kBVHFkcyRhAI=;
	b=VuQi7oK10MFLxjtp0Nt9p8KnjFRw3EKbb3nAypChtdHZ0Eb9wiY6zpsaHTUrZ0nlAs7ltkXw2
	xB2mlmV6Nx6ocAZNWJXvl6gesQs+AsWLpVSxLHN9nAjH2wIzhi3eE09l+OtettYcZ8bzrFnI4jR
	g4OGgo8RVawvK0gG7bh4gag=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dHbYr66WxzpStw;
	Fri, 28 Nov 2025 09:39:12 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 0165B1804F2;
	Fri, 28 Nov 2025 09:41:23 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Nov 2025 09:41:21 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <linux@armlinux.org.uk>, <will@kernel.org>,
	<david.laight@runbox.com>, <rmk+kernel@armlinux.org.uk>
CC: <bigeasy@linutronix.de>, <brauner@kernel.org>, <jack@suse.cz>,
	<nico@fluxnic.net>, <akpm@linux-foundation.org>, <hch@lst.de>,
	<jack@suse.com>, <wozizhi@huaweicloud.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <catalin.marinas@arm.com>, <rppt@kernel.org>,
	<vbabka@suse.cz>, <pfalcato@suse.de>, <lorenzo.stoakes@oracle.com>,
	<kuninori.morimoto.gx@renesas.com>, <tony@atomide.com>, <arnd@arndb.de>,
	<punitagrawal@gmail.com>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>, <wangkefeng.wang@huawei.com>,
	<pangliyuan1@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad() with rcu read lock held
Date: Fri, 28 Nov 2025 09:39:35 +0800
Message-ID: <20251128013935.3539-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126192640.GD3538@ZenIV>
References: <20251126192640.GD3538@ZenIV>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: AEDDF40007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: bawnhf9k71xs3imkg4pznxbo8uptdjyk
X-HE-Tag: 1764294087-426608
X-HE-Meta: U2FsdGVkX1/O/i8xNCyxfNxaf59CeommWzUGwBo+dHk75ul8fFKUcuZk7nGxsXS9wllld0ORij5WjyJzKqY4oFYLbbaVlW1jo95MZJ/qdpiNo7ukjRcmT9dgO3VCTDg7JPY/H7KK+qtzuxDjrr9du903B5ffAz3jNesWb1B+QmumjZR755d7S2+YCFoOlzpYtp7dKDlhL49oCXwYaf8R9iGmcxqsF8eM9O2VJhdxJPl/jQ7xxNFo+vLIrxsKyn37kkmH5C+b+CMPiDnHV+WY672o2ZsUnJXeCrzqUNt0dlo6rif68sMm/HtuK0HCsXdlMyXjPtuflqiEb7HrhUR5ms1PTu+o11NXtd6d7vLuTEWSm6HIrNVUKevnG0nFVsfbPdYR+nothFzjc3gzET4fR7CK95dRmLuZK216b9RMcfvrmOzmbi3qIKqRuvLp9zCKM+5TH6A1zkvAF7wDlKr087tcX88XMtZZXeFXWdKL/gCQGh4WUMO37pwFvBsF2g+LVwD49WID8WeA4U0UQkSG5yWnSjgr3jYKSwJtOa30rEnvjNF/nX0enVkyaafhLnae1QAdXSwNAz/yswP4LpYy9RCv6qZEv4wRKJLo7sbnhb9k7Nh+w3nOTZovod7v0APRTN3CtmAxnAMV6/shjQQPyBPABYcMxuC23KfoKQbL2FsvyZ7tuhIQ2cxZhSOBsJEfEh9G5oNiRyW2+pfwt0aK2nbIP5dZ6wnuAU4wnYON98aZhlzZw/VatdEshVLtcs57CIutcr3L4TfzVTmv5IXb12k7kBSQLMGJ+wDqvT5OutksuBzmw6RkpsNxF9NINo135C+r3nUYCfB1ozH+ZjyAaS/VLFfEWVeApUT87oCe4+kRigmO12yraARVH5giIz5p411ImEnkxR0tywE9OlqDeWx3wN645nQ3PheMoY2CoC1V3qxpt9Hmt7X3Nj28mJkCGaVfIs3pDZyTPhYLoeC
 BuCTlJ9I
 TqOvszQGvjnhIilbkO1qYTnayXSkWfs60WaebkYwBHBW8gsTy50x2wGBhn1ewhFfxWgPN9I0QQabRYyGQEIDGenhJr3345MtgaXrTeenSbd1QTz5Pgdn77Q1GEGcJMo5O9NJZxvDT0oNxT2hjlWuu4RJGvgRtxOCV9nsMgjA0yF6Ao5KbWBOcBMfcUgGsm3LbuB9nd2S2Rb6RFoeKjganYkf1yRB+Gr4SZ1ImDABsV1RVpagGbMKduG3jccwmuulk021+sk5++F717sCIV38HcbPLWPhmBt7YKVFQlezkG51Vg4fT1ywHVYWtPRbSlhhyUNAxoj77QKM4h87tKEH8LCZQu6Os87o/6Lw6yVg/z/aM0VM4q3a8UWZc9x4WmdHaZftAAfBqsj2dc/hKzDG2DwqQL5y+6VWO56uenmUsbT+BAnn4NBjPGDPCWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Nov 2025 19:26:40 +0000, Al Viro wrote:
> For quick and dirty variant (on current tree), how about
> adding
> 	if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
> 		goto no_context;
>
> right after
>
> 	if (!ttbr0_usermode_access_allowed(regs))
> 		goto no_context;
>
> in do_page_fault() there?
>
> NOTE: that might or might not break vdso; I don't think it would, but...

On Wed, 26 Nov 2025 23:31:00 +0000, Russell King wrote:
> Now, for 32-bit ARM, I think I am coming to the conclusion that Al's
> suggestion is probably the easiest solution. However, whether it has
> side effects, I couldn't say - the 32-bit ARM fault code has been
> modified by quite a few people in ways I don't yet understand, so I
> can't be certain at the moment whether it would cause problems.
>
> I think the only thing to do is to try the solution and see what
> breaks. I'm not in a position to be able to do that as, having not
> had reason to touch 32-bit ARM for years, I don't have a hackable
> platform nearby. Maybe Xie Yuanbin can test it?

Hi, Al Viro and Russell King!

I moved the judgment forward to before local_irq_enable() and submitted
a new patch:
Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com

This is because there's another bug I reported before that also requires
a similar judgment, but before the interrupt is enabled.
Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com

I hope this can fix both of these bugs.

It is closer to the x86's implementation and works well in current tests.
Could you please take a look? Thanks you very much!

Xie Yuanbin

