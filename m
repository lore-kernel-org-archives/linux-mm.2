Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA61CD116E2
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 02:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034416B0022; Fri, 28 Nov 2025 21:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C476B0023; Fri, 28 Nov 2025 21:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B896B0027; Fri, 28 Nov 2025 21:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB5AE6B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 21:34:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A7BC8A83F
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:34:35 +0000 (UTC)
X-FDA: 84162076110.20.B6FEF48
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B0ED20008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:34:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PWKrg9CI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764383673; a=rsa-sha256;
	cv=none;
	b=igQTh/WsiXeAcWGkQ3hig+SMGGCgnGKN6MgKM9B64fUAJQOOv6huDgvPz8zJPiAfXfYXua
	2/oXhUs7/t67HxNkO3zYTNEV3fESTlwi53s9lYy7dtlMrZlLXLTOy9e7iuhz5Wyxy3+R5l
	8LmJLVfNMHKjjOOj9hZ4SYZJY2YRWf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PWKrg9CI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764383673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xJNkDPeFZ3mqQ8f1vIw6iwLF+t+AtPw3ITe29YVPNE=;
	b=4OQYJaIZCJkvqzarZV0f1iB2GJUDLtnF3pvwEkxk7aMpzytpKbSFJhPAErykCDhWBfdtt3
	o8Vopdbs9fUVNlPCxnn5jfrpCL4/SQ7Ajl2ht7rz+3XkpzyNf4dxdjFO83YwEnCA8BRZWz
	T0gxji3lQU4xTXedfKwzLCKSsGOpqPg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6xJNkDPeFZ3mqQ8f1vIw6iwLF+t+AtPw3ITe29YVPNE=;
	b=PWKrg9CIIKX20SkXni2m0WgDvyVF7rPTKkM8q3Ou9evSEb47iF2go4uoiLhBwVVwEUmGd+R3o
	sAmidTA+oP96b6qoyCWa2bWw1iJaN9or7npTp+ATi/v2O5Oxn4KZsWal7NWsybJOWATLZia+yNY
	f5pn9OY24M3ZZ1JMdsvYTaw=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dJDj11ptjz1cyQk;
	Sat, 29 Nov 2025 10:32:37 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E5421800B2;
	Sat, 29 Nov 2025 10:34:27 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 10:34:26 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <bigeasy@linutronix.de>
CC: <akpm@linux-foundation.org>, <arnd@arndb.de>, <brauner@kernel.org>,
	<david.laight@runbox.com>, <hch@lst.de>, <jack@suse.com>,
	<kuninori.morimoto.gx@renesas.com>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <lorenzo.stoakes@oracle.com>,
	<marc.zyngier@arm.com>, <nico@fluxnic.net>, <pangliyuan1@huawei.com>,
	<pfalcato@suse.de>, <punitagrawal@gmail.com>, <rjw@rjwysocki.net>,
	<rmk+kernel@armlinux.org.uk>, <rppt@kernel.org>, <tony@atomide.com>,
	<vbabka@suse.cz>, <viro@zeniv.linux.org.uk>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>, <wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when handling with page faults of kernel address
Date: Sat, 29 Nov 2025 10:33:23 +0800
Message-ID: <20251129023323.11612-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251128120359.Xc09qn1W@linutronix.de>
References: <20251128120359.Xc09qn1W@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B0ED20008
X-Stat-Signature: wobakxfpegx6wcy4inu4jd3xfcuy1d1j
X-Rspam-User: 
X-HE-Tag: 1764383671-152808
X-HE-Meta: U2FsdGVkX18QqBuR1rXJX7zFYnekwwWPYbKlVO1e0v82Hbg1ZVFnEyj1XcOBebU7Cv+O6k//FH60+DpbPv5lnPpZ4l76fpQn9NjjO4eBX5e1gELvrhwkL9t3koIPRwV9jdbYucFB8tk0kAXQcpYxkJ0ylOizNEbFDhg0V6RlWJzN3ssnz4YkoYcwjGmmCgbRFohSNjN8HN8lQcdWehMwO7SmGSxZRa/3lZZaSD1QiVyh+Fv+sTHroHUZpB8GpxiA5tIQ/aUK/SaNawJ3pKf98UJym0SODvSoZSpMq0rvt8nhIiR2ic6KL3DvbIMG+WEBvca+xFdMP0M58Bx4bkplLlTK1/ZFAI6+D7rwLlfRVBGozDOzNqpU9O3vIh3PnX+Ge+ZD3KRvuA37MFNVl1qZ/qU5SlsR+vwvU/Z7TqwIveYJt/wOfszueBib0+WNJV9+S0boEdNnFe6fRX3ez/Xo+Y45yaaBr4IqxVebOS8dAPgUlVXkiKR6xxsMlhPXWSgs75JKGFSUtkmfluCJS5gBhnsNUW7hB8HPVz1tDwxlAVxAxiNBMv5f68W7H+rDYtS59sfSs0kpD3bynxR0yzpyA6dSQLPu3JR+SjeAWhmY7+GV7LoMwh76li6nOesy9H7p2dG7akPNqOkP7ToqaIkWtwZbKekW8sf7PqSIvIvTI8pIQop6i9G/i8lk1Rk8YNObXXXCGEZYuk4G2G+VCLOAOh269M8esooKaeg9hBAS72eZkja0pI+UwC4mvKaEX0tDW2Fs7lqU/7OP2xp3yDJ/9FH7qj8vKI9sU5dMZ0+E/Uf/Csb0O2CR+hlTs/beOHV/y19LYTE3tlYK00/zgxx29UtM5ZPj5c9flrofZ7jcq/Yl2dl5aLNlSii8J3m8jdm85uWWrOqCB1qTuCKNdbvCnHfh0a6/7ERgdVV4JiXc/U4zryNebiBcn6S6e6y+aWGBDnqL0SS5l7smrxirY85
 6SAGlvT3
 mVsml+zd3+/lGjitYTI6sBlBqXnwN7G7RfDrXuhqWp37zXjsq4GNPNoyiMrfk/ZpGBM9aeOj/doTEQ+z9vKHWLQzCxnZtqiu7JSuiZ7tsY6G7cLc/kZd4oVpMpk44a1GjiAwPM5wbHJOd+YiCq2MuZmfLA3OCCSex9IFQtXNjUHiBaAeHqQTREkIaQymuLRWVRJwFFNtD2zVLhaVAbFkP9x1Gvd1n54UjkYyQBFPmNnCNqBwnQUZMEWz2A1tazwn9vygat5qZp5EOxQRJ5CgjSh9iOmwj+0rmq9skhODwLO2BJUWlh1+cq8gnJqT1TxmDqYdSSwYqHc4/KoTU5aw3xmbMXNVzZ0OgPlXd7hUG+3LmvYNrDZNVLpCdSthXikgdhAWVyGQZx8uDySA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 13:03:59 +0100, Sebastian Andrzej Siewior wrote:
> what about this:
> diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> index ad58c1e22a5f9..b6b3cd893c808 100644
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -282,10 +282,10 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>  	}
>
>  	/*
> -	 * If we're in an interrupt or have no user
> -	 * context, we must not take the fault..
> +	 * If we're in an interrupt or have no user context, we must not take
> +	 * the fault. Kernel addresses are handled in do_translation_fault().
> 	 */
> -	if (faulthandler_disabled() || !mm)
> +	if (faulthandler_disabled() || !mm || addr >= TASK_SIZE)
>  		goto no_context;
>
>  	if (user_mode(regs))
>
> We shouldn't be getting here. Above TASK_SIZE there are just fix
> mappings which don't fault and the VMALLOC array which should be handled
> by do_translation_fault(). So this should be only the exception table.
>
> This should also not clash with the previous patches. Would that work
> for everyone?

When it is user_mode(), it should be goto __do_user_fault(), but
no_context goto __do_kernel_fault(). So I think it is not ok.

> Sebastian

Xie Yuanbin

