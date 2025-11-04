Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0481CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13958E0123; Tue,  4 Nov 2025 04:51:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBDD8E0118; Tue,  4 Nov 2025 04:51:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28E68E0123; Tue,  4 Nov 2025 04:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B238F8E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:51:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C022B94FC
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:51:00 +0000 (UTC)
X-FDA: 84072455880.05.BBDE0BE
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id B4FFA1A000E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:50:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="w/wF74mo";
	spf=pass (imf19.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762249858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8ryYqzNzuomFM1qI/F9XXL0yM4A3U1rNvzkeTZ8nMY=;
	b=tlL+yn/HHqm2xs+El+dKMIzIfBltZuVSmjzYBrsG3N/emGPMMK7MZwROroM7FtzbIUuahF
	GCYE3QytXdAAix2Mh8HOtX2x/EvQ6sMSpQjUFVYRKPcd47rA9OSzXCHwLXSefEjW8gCVOj
	qqR5YmzeXKfDz+VbsIJKyyCziYFJ7Lc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="w/wF74mo";
	spf=pass (imf19.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762249858; a=rsa-sha256;
	cv=none;
	b=KmkqGUdAfOaUqOt0YPIY91DliLDIS50s25D5YvkKoDz+gFg+EjFsclNKhR7vnU1MdkUuen
	GfVeJS+yFOOoJ4yieM+YKb8kk/8WP70HnhFsX8x2+PXH5Qn0k+L7vnujhFxPIZxohqCasj
	DhZIDSR4LjuokmSVept47XG4abn9Hlo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t8ryYqzNzuomFM1qI/F9XXL0yM4A3U1rNvzkeTZ8nMY=;
	b=w/wF74mo1/KwoyB4tDKQy8+xB8kViYjE1uL7ZkflzS+/rP/iIWNQoEXBIzZjAZ3+X8X8iOLE9
	WnXgY/JOX/VGQ7dBqCOVHVi2P5xnsvukEBmMytUG9LEDroc5xVe3QENpNXf1HWq8jp+kA7FHJ3m
	DaRzAsYEEupFXMccVPL+ZcA=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4d13ZS5RNGz1K96k;
	Tue,  4 Nov 2025 17:49:20 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id B6A6C140155;
	Tue,  4 Nov 2025 17:50:53 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 17:50:52 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@kernel.org>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
	<dave.hansen@intel.com>, <dave.hansen@linux.intel.com>, <david@redhat.com>,
	<hpa@zytor.com>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <luto@kernel.org>, <mhocko@suse.com>,
	<mingo@redhat.com>, <nao.horiguchi@gmail.com>, <peterz@infradead.org>,
	<rppt@kernel.org>, <surenb@google.com>, <tglx@linutronix.de>,
	<tony.luck@intel.com>, <vbabka@suse.cz>, <will@kernel.org>, <x86@kernel.org>,
	<xieyuanbin1@huawei.com>
Subject: Re: [PATCH v2 2/2] mm/memory-failure: remove the selection of RAS
Date: Tue, 4 Nov 2025 17:50:48 +0800
Message-ID: <20251104095048.119012-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org>
References: <01b44e0f-ea2e-406f-9f65-b698b5504f42@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4FFA1A000E
X-Stat-Signature: gp84p6w5xxrbt33c1tdpdwpeppkxrkyg
X-Rspam-User: 
X-HE-Tag: 1762249857-594391
X-HE-Meta: U2FsdGVkX1+THUtAtTDB5RAhhY2S4WkgPvaV2NnMnx8q+SQsypJnS8nerXdo/mVxd9/m+Lshkx5Bvf+dR2L0Y1S5cCM2GVplXLu3rS2sLUGGffw8nQnxo1GhzyWA4iGWRLF4tzi4pBeV8EHFtYitbYRLMq7i3rGy870TKtyzL3d8hOrFEoMVJ6aH0ICG/fR7MgGApeKtH7CWEfi28IF4tNThVBPCBCWkD9FaO4a7TX7Tqs0UQt3SXqs1uqEhR1BkdZnQHAViMFsCnZJb//o20aVKuuBcIdeqbNMs7LHAVF3Ctv89UhcBcOO5tr3oACdbmJyc4A6IO2w6uMwUlhY1WZQPellM+Z1u3fe+ccw6fOZ0nYxMUM6v8mWSQBOdudd8sWeOFuGGV8Uwsdz07r6y8KxUxwsHSE9bd7AgtZolXAMbw6uY2mv0J417ml+QVZQD+q81WjMel3qUuyzRbMSpCA/mcjntlBCT1XaIcYDeOMW23Coe55SaMo7v0/tCl3+wpGOeJ9o/WOXFViATwBVTmZVefmChOyGeJcUsQ8K8s8Jz+wHvZ0e40RVpdfzbk9uF+nrYHpR7dRr+NLKaR3gx+/b514jS/ChF9QO+f7Vsq/pSh48kbjEirqs1FgDCPfJYrmuL7bIaMJXkUYwNicTuHtv/xK0Ynj+DemXNq5qv3pZP1XMKc04o+39pFNrq45Wsz7yxo31wizdkjmZYdkEimqH6PujV+g0VuydK9dxtgmwXO4S9e0n2yN7uAkMkQBlCPDiRpsElMj2NKqmI9hsUSDFCRWO7q2021D3qLt5dTv37P7MbZB9ELgq2Dm+ghNBouNpxUD50Xxwoyc3Tw65cdyiyEyktFAifmLfZIEJ3reLKWF/oEdOoTBChk37dm0eWKZoHSX0NUK7esGXUl5PGnaFIlMv4kzhA8RsKsgtbqq8/FC+/jS6FvBb7KIe/x/PlVfcoc7udqU+xzXPdVuq
 cyRB1yU/
 Wu6kh72ZfCsiX9dDTpxK1Y1DAVssPoBOd7K/EyN6PgHsCB33Zx5+oHec5gGlViXzAIQs3wjxY2sCwUzgkgmFo+RUb2guS+ZKBsB9syGAph8DpVRKCP/iUwf67iegQyiQarA8AS1io7/R/vWKrXrTZE+u/8Xa0Y1rorPG+rRvviIrCkSOjxAY+tHcQ+suLxaQJlkW9TnDtxA8MAgnpTbpQi1p5XTQYa3Ai87xVCpONqbRzjQ2c+XNkS577Mn4EPqSswNltSzhbkw0WgDC0uBQuzwqdaLD67usUqMU42IMGZJVklSW/y7mAeGY7ZbYTtWorGVzRR+gzfAmfwQJbmtLXSmLs7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This trace system should not be called "ras". All RAS terminology should 
> be removed here.
>
> #define TRACE_SYSTEM memory_failure
>
> We want to add that new file to the "HWPOISON MEMORY FAILURE HANDLING" 
> section in MAINTAINERS.
>
> Nothing else jumped at me.

Thanks, I will modify it in the v3 patches.

> Cheers
>
> David

Xie Yuanbin

