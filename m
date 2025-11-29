Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78A0D116E2
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 02:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB5E6B0010; Fri, 28 Nov 2025 21:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB1A6B0011; Fri, 28 Nov 2025 21:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1626B0012; Fri, 28 Nov 2025 21:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 584996B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 21:18:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06D831407C4
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:18:28 +0000 (UTC)
X-FDA: 84162035496.18.DBB4F9C
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0062240012
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 02:18:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rDScHZVC;
	spf=pass (imf07.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764382706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn01DPqEWVsRKnyDlfL02PwCBxz8cu2USXRLYTQgCgM=;
	b=SbqT7rwVgW+Q+oqUdodC/suA9NkG2/ZB/7zwg/8xFMSEcj7sxPSib0wZQaG9TDcZ5qbNaF
	r3mGDFrnMcX8hxmFGc2VHz8PMduWLHFn+MrbOq/cKkZ4s8JVqStgyBfax7z0v6DB87Empa
	Fh7TYmlyuYn3SHSvXhAtFW/1AbNVAj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764382706; a=rsa-sha256;
	cv=none;
	b=LjrAH1+lAvgnR7hChTDeA5mBfs0pxes5rw9MXRl6DR39rqYIgn1lk0dXUVNalltrAwti1+
	rEaCr/rRUxhBRnK5OZW3YmYsQ2T9avxXHshVUNbZiFrJDUpqe639mpIgNuoEe0zU3MeTrJ
	qmElgmgX9NvYVvPcYOXwgu1CjNhu838=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rDScHZVC;
	spf=pass (imf07.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kn01DPqEWVsRKnyDlfL02PwCBxz8cu2USXRLYTQgCgM=;
	b=rDScHZVCx+yxOePYn8Wcv7pT5EneAyhEXpKgyfyNlZdFO+SZjIfif2JCM3YYpKX2AogeDsnam
	/17hK+QDSVVTcvAMpeNH1ZD5mzB3UTmEMrJEwauBJgQWVmdxVILASAgXYxRyzaIgfUZb+JMrv57
	oTVqNBOiz4Z5xvjvvJvwaQw=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dJDLT42p1z1T4Fk;
	Sat, 29 Nov 2025 10:16:33 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 18451180B58;
	Sat, 29 Nov 2025 10:18:20 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 10:18:19 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <torvalds@linux-foundation.org>, <will@kernel.org>,
	<linux@armlinux.org.uk>, <viro@zeniv.linux.org.uk>, <bigeasy@linutronix.de>,
	<rmk+kernel@armlinux.org.uk>
CC: <akpm@linux-foundation.org>, <brauner@kernel.org>,
	<catalin.marinas@arm.com>, <hch@lst.de>, <jack@suse.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<pangliyuan1@huawei.com>, <wangkefeng.wang@huawei.com>,
	<wozizhi@huaweicloud.com>, <xieyuanbin1@huawei.com>, <yangerkun@huawei.com>,
	<lilinjie8@huawei.com>, <liaohua4@huawei.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
Date: Sat, 29 Nov 2025 10:18:15 +0800
Message-ID: <20251129021815.9679-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
References: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0062240012
X-Stat-Signature: zyx44pimpt1s97347mgzhozi99qebu6x
X-HE-Tag: 1764382704-527059
X-HE-Meta: U2FsdGVkX1+QjpsfCSAbWnpEUmKt9qWNvvK59F2KDruVJ5Vgbiuz6iW5nsxaEoM3QHqqQDOwma4d8sfFJhNjlvpg1im+8WECLvT4GatzzhAj3aTz0FuyyamS0MTyIPWYJ7wKD9AmplMikl4wX0cN8k6JAgNd89xd2IudfkP3rVbYLv8jnqDEJGfDT5tNesnvmcIYAzl1Uj/3I4xkKETTZoY2yziRe/2Z9q/RxyeAcyrh355zNCMKkre+FoxAA1ZCkzl/333WwCRgmZrBuoXO7NC6KOEzHsEvvN6cvQ3zdfZg03mtIhkOMZvTc21iVJ2iIphmprtp/naDVz0p4W5SPT1nQlJSY8YvLFVH2rKPWf6UJecF9G8pvKPIy6OU1QfsIRSHGhSfYItvGfGGW0V2ODD0Sj2relG5puZQ1mCSl/bjQy5rw9sRnOdGBCIVIdMEDIAtFQeKdNALIO7gr/bydwm9TC4U3EWAcPXeLtglIrlZIfrmUbWRR3/4iXIWekHxbj2kjNjkKsW5Velz1F91i+rH2epbCImhRBfTqWIesJdf9OkYQMc8wVXFGdidJLIcJfKoHvfJ3lt8KFXXcx2igFDZ7Y5NgurH8NrPh1dNQCICbZDCmAB6UfDGlVfbZ3V4pgjPWIhyXm+QwQuyP6GZLUKVjhuqWFPxSJ6yW5vj2Af/q7jdFk5fkW+W6qbKGYoVgdhbPnbiE4kPELJC/dPVSdEqqgVcjmaLbntKMhPUFpmGxcmAEJntQ9JnOYAz7TEeSUD1vyk4HIVsRzI6G6SNyP14okWY6Dz99RQ5/Qg9OLQzDyzVgWu3ZOiRw7DZA86MspeJFYhMZXuqeVfgIRTNfItleaW7ckm28OkUbRPF6ayf+KzbNrn7OiDSnezbLFQp9nuuUcAScJp35hrvtnl2uH9LQJLpsvi48ch3frIydeJNNaZWCqmz6KHT5m5TIpzlp4+7jYlLvckY2ec0wuh
 4GQX9x+o
 ZfdgXGT2911zc7rlVRoKve9ABW9+fzXBllaGs/gLi5G4X48E2HJUMNVLuAk3fKdTAACvuHBxhbpleg/DMSW11D2LFsX3JVzUiefQWKpLBA8rIze43tg/X7XB4swPwqmnszYL+qcnj+UAQ53PrP5efMYJUJB+32426CTkDWLiRVMkiWfUnjcCb1cHbH7VQLui2/k6WuC48Tj9dh87Oz7vMdMxxr8RL6lMxAHzLVKaJYGWHNA8WAC2sYDGw004/gAlHWzzUaehKykmECt8ETqMdeEvLcE8yzFwN/fpBI0BgDbdmrgzghoNvijA3ej0zhgnuLduuw0hBgTjHtgClELkxa/W3wTTLI240ql/pym97Yf/7WHS4tqpkYpnHwi0oF97gYtxgwRxsqdWdZxBVqig5R0y3mO3onBB6vYUzkMipV12BSuDghvql8EYK5N4iDeTzNUKsj38Cbxh/U7ZmFa0JG/IroA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Linus Torvalds and Will Deacon!

We have some discussion and solutions on other threads, and it seems
that there are somthing missing on this discussion thread. Therefore,
I think it is necessary to synchronize some information here.

1. There is a test case that can consistently reproduce the bug, which
might be helpful for us to do the test. The test case is located after
the '---' maker line in the following patch:
Link: https://lore.kernel.org/20251126101952.174467-1-xieyuanbin1@huawei.com

2. Al Viro give a suggest on 2025-11-26 19:26:
Link: https://lore.kernel.org/20251126192640.GD3538@ZenIV

This patch is similar to one I submitted long time ago, which was
intended fix another bug: missing branch predictor mitigation:
Link: https://lore.kernel.org/20250925025744.6807-1-xieyuanbin1@huawei.com

My patch was not accepted, Sebastian's patch:
Link: https://lore.kernel.org/20251110145555.2555055-2-bigeasy@linutronix.de
fixed this bug, but Sebastian's patch has not yet been merged into the
linux-next branch, so this bug still exists in the current linux-next
branch.

I hope there is a simple solution to fix both bugs, so I submitted this
patch on 2025-11-27 14:49:
Link: https://lore.kernel.org/20251127140109.191657-1-xieyuanbin1@huawei.com
This patch is based on the linux-next branch, therefore it does not
contain Sebastian's patch.

3. On 2025-11-28 17:06, Linus Torvalds provided a solution similar to
Al Viro's suggestion and my patch:
Link: https://lore.kernel.org/CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com

Currently, all solutions have been tested that can fix this one bug.
I still hold the view that perhaps there is a simpler way to fix another
bug at the same time, because the solutions of these two bugs are very
similar.

Thanks very much!

Xie Yuanbin

