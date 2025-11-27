Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD130D116F1
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 03:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160BE6B000E; Wed, 26 Nov 2025 22:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAFD6B0010; Wed, 26 Nov 2025 22:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4236B0022; Wed, 26 Nov 2025 22:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D88796B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 22:03:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E2B08A762
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:03:40 +0000 (UTC)
X-FDA: 84154891800.20.8100572
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26D54100002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:03:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RFgcpNci;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764212618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LZy+TydcqSmvcD0OxLxJaigZpJM+j3ByE+efESnjLA=;
	b=VcB8OlHk7xsG6tt7VrHUX66AyCERSH26SSLXvnkunne8N835jM/vuLYZAgXjNTgcGGYO9H
	jQmGxIr3XvxdLoT6zh+fqkII0kmiDMRkJWuCwBomaYHurcR7BkTLXQvvCy/559Lg7ZJBka
	tkHOyERDp+fJMUTmpIzpoj5Q27F72ec=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RFgcpNci;
	spf=pass (imf14.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764212618; a=rsa-sha256;
	cv=none;
	b=AoWKDVNrfrqAWjYbj4D36ZkDsOZQiy2oCciP91fZMeHnpCxr/qmdOEUv4TNejO5KGPfhnc
	6f2MZgaWRnPw3I8WzeU7VlnfbMjT8UPGJS1kqFt/4AQO3DR9xCaufSimzgy1+hf/ZJkrl+
	9Fsd8/mA4VB+gZ7nmV4qeiKco9nEi/w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/LZy+TydcqSmvcD0OxLxJaigZpJM+j3ByE+efESnjLA=;
	b=RFgcpNciTsUxTzW0FEuArat0oaFMJJ2ugPWHX2RcAh+P3gVPQqGvig+Pft78Z9ZRMCBbBALKf
	V9yv1Ur4Pry9lkqkiELK28rV3mOVmIfVuZK7uDYZmC/dZYQhNILrGHIyk/KOkMMDi7K9bqeRIhq
	FZJJ4NJqQB4A9/pEEKeUV6o=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dH1RV6VBszmV7N;
	Thu, 27 Nov 2025 11:01:42 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 719521402C4;
	Thu, 27 Nov 2025 11:03:31 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Nov 2025 11:03:30 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <viro@zeniv.linux.org.uk>, <linux@armlinux.org.uk>, <will@kernel.org>,
	<david.laight@runbox.com>, <rmk+kernel@armlinux.org.uk>
CC: <brauner@kernel.org>, <jack@suse.cz>, <nico@fluxnic.net>,
	<akpm@linux-foundation.org>, <hch@lst.de>, <jack@suse.com>,
	<wozizhi@huaweicloud.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <catalin.marinas@arm.com>, <rppt@kernel.org>,
	<vbabka@suse.cz>, <pfalcato@suse.de>, <lorenzo.stoakes@oracle.com>,
	<kuninori.morimoto.gx@renesas.com>, <tony@atomide.com>, <arnd@arndb.de>,
	<bigeasy@linutronix.de>, <punitagrawal@gmail.com>, <rjw@rjwysocki.net>,
	<marc.zyngier@arm.com>, <lilinjie8@huawei.com>, <liaohua4@huawei.com>,
	<wangkefeng.wang@huawei.com>, <pangliyuan1@huawei.com>, Xie Yuanbin
	<xieyuanbin1@huawei.com>
Subject: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad() with rcu read lock held
Date: Thu, 27 Nov 2025 11:03:16 +0800
Message-ID: <20251127030316.8396-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <aSeNtFxD1WRjFaiR@shell.armlinux.org.uk>
References: <aSeNtFxD1WRjFaiR@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 26D54100002
X-Stat-Signature: 6rhg9g9fawub4qxhjprk3foiwy7nnom8
X-Rspam-User: 
X-HE-Tag: 1764212616-689830
X-HE-Meta: U2FsdGVkX18InWATmSLZ8uou4GLzvM/WRhyftDbEPRgOl4B2LcQbDm9SKLz1p4bVGxPs0A7GmlL74PmyTyVfvPWaevibMbNyIjJUVWy7IrtKxj04vsSummCr/hECw2bj66n+j04ZjyU5HVMLlZc3kSTI+auBdIf6ZvsD5bFVNSqh+9VDic9dUEjIEXvTziAcn7sN2SaXvQNevlfvMfiAIXlRQrd3V0+QWJ8tWv5I6GxqmKbM/KrPBdJf5U1zIs6Y7dZuN9TdKFXYXfAXZ/Fo+LyDrq05BjBw74cwWMzIFPp5PmjSdb6sMtMM9Xn5OvO8S1Qj+NFyRK6r/VTPZdjbIu9BhAlkOWRIOyz+6Al5Yixb0OQOIxhhoyUxmAzOiAUOEQiQvot5MzQUAlAh+mHz6O/K/2Zu6r22b5pTbc0mQ2cyyw5C7CZJnv07DEhS2cZ6oUJhI9JVgyPjJO1pn7SxGqBX9x7nz0hjFtnzQeFl36BFEBgMy6L+/U1y+YClGqY24UxBxbyo3sPLk+Qr+xNpa9zvjl3FB07jKYttO/ZuZvVI9k7dOY+gRftyOvCy0AJo+zQ0ELipkupWwTnf1sZtaVvXzusgwP/PlpT+GadAWoCBFM0Q2sJZYIo8PRSe56/TFZg5usTJ4kWCB4jA3sejOm+x7yzshnHRR5w7crVxd5BtnT/KK/cT1HyIYS9KBFMIYfEK1pcPNyneijdDxzh3dIOnbjlKY48xVoilD5x31RZctM9/lTJ5yWOf0y0ltfwE37aq7yGGQ20FDyvj1sCcUNPqLRhokDqMLUZEv5ZF20PXLR1KuFiQWtvB8VKgajX/9QYD92M32/fWqlsTulW0iOLb/XNza/+U5v1AxtZqf79yabMGrWBoWspxiED8ryHLuCaSObYEieuAdMcZhPsK1EIAGRKvAjuoaKcMX7RQiTdcNmqxs82QlM2ir2AS25OxFBPw1JE6EkJ8odfKBZ9
 7la/hSE+
 TylJIqrUDYjsqCJTCln2VHvcoSro+BtOYFrVY1vy1bfCs3QbE37nfBXZSPqzwOUu1Qc/8Qq6QCx1dcjky6cWZiMB1fJns5MQ0Rq2gASwLZwMjiFL97o5mELvrOwSn30nEvxeK8HymQzLKfoHl+H9cekeVsC3zTMTm1qY2WlBC+r6jdfdScNM9t7ZTrWAKq0Ay6FZECqUEk9Mwtm6gTcOMdNYI2wYL1A5Vq+donWHnAFzsUceZlz+iwqFnCRnpgtuGPRGIAeeMf21Yx5ivW29rKbNrcNHv5GvsBhBFfIKmI0u3AXG7L+kq5PjE+3MEhJGh1b8w69bvbVa2vioKgjkVLH5ETU1FT/gA91S1f+cdtvQZgqgOclMBrLcZcFyvHxQ4vwToGwHJF7upiIW5Yzgl6QXQlhDf3FnZsvG8iT/OCTMUOBHjwu7m9OoXag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On, Wed, 26 Nov 2025 19:26:40 +0000, Al Viro wrote:
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

On, Wed, 26 Nov 2025 23:31:00 +0000, Russell King (Oracle) wrote:
> Now, for 32-bit ARM, I think I am coming to the conclusion that Al's
> suggestion is probably the easiest solution. However, whether it has
> side effects, I couldn't say - the 32-bit ARM fault code has been
> modified by quite a few people in ways I don't yet understand, so I
> can't be certain at the moment whether it would cause problems.

I think I've already submitted a very similar patch, to fix another bug:
On Thu, 16 Oct 2025 20:16:21 +0800, Xie Yuanbin wrote:
> +#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> +	if (unlikely(addr > TASK_SIZE) && user_mode(regs)) {
> +		fault = 0;
> +		code = SEGV_MAPERR;
> +		goto bad_area;
> +	}
> +#endif
Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com

However, the patch seems to have received no response for a very long
time.

On Wed, 26 Nov 2025 23:31:00 +0000, Russell King wrote:
> I think the only thing to do is to try the solution and see what
> breaks. I'm not in a position to be able to do that as, having not
> had reason to touch 32-bit ARM for years, I don't have a hackable
> platform nearby. Maybe Xie Yuanbin can test it?

With pleasure.
By the way, for the config and test case shown in this patch:
vfs: Fix might sleep in load_unaligned_zeropad() with rcu read lock held
Link: https://lore.kernel.org/20251126101952.174467-1-xieyuanbin1@huawei.com
the warning can be reproduced directly on QEMU.

Xie Yuanbin

