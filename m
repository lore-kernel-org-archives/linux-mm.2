Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 679B1C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226756B00BB; Mon, 31 Aug 2026 23:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6BD6B00BC; Mon, 31 Aug 2026 23:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C79E6B00BD; Mon, 31 Aug 2026 23:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6FC36B00BB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:12:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59114120303
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:47 +0000 (UTC)
X-FDA: 85163721174.28.D468975
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf08.hostedemail.com (Postfix) with ESMTP id 649A2160006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2FuUIMv8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=868doxc2TiEPS+iWdp2u7jWKN/mr8YzZMB03OTDKqEc=;
	b=6+X0QzTMw09vnQHDU/psFBUGgPjsaTKcYS6CUXY7itiNhXT++kj6eI+5wEQOf3Nqtr6WZz
	nCULwp2n1gEOmgx2R/oZqrr6lzEv5JTFbE7LLwQyuAufB2cRpHrUm5YX0sby1xLqc6aiF2
	vGoNb1qCRLnAUZEeASghdg1SYAd4LJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232365;
	b=ESA+j2AUM1L7MfzIiZ7CKCbv+Sveqkeumz/Gsib4usULVi4dEhlpNmc6VmOvph0052Bda3
	A0GN3YKmNHDemyMAurMfe1CSzhRF2z2vye1ZaIc/nxSr2UX1RyM81OOKZRYK14cwpjX7kJ
	4sbk9fFQiqdXl4+eRT7WxxLrLFDxnLM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=2FuUIMv8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=868doxc2TiEPS+iWdp2u7jWKN/mr8YzZMB03OTDKqEc=;
	b=2FuUIMv8A45fN1Fg256xHW+FbTGN6KYBmeNOwXkCzXVvCN7SoCz8scEwm7lHDLIsvFM2jyQjX
	W+/0iVF57vRtyyFEUup9ar5K6RDt7U7qtaJd8vzSOpzNCGp5uQ+M0vLntMN5wsSRE8a3tr48RZ1
	n4cfmHC1EburblLfu6xnlwU=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hYrHN3fGZzRhS4;
	Tue,  1 Sep 2026 11:01:52 +0800 (CST)
Received: from whupemk200018.china.huawei.com (unknown [7.152.184.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 9EFD34057F;
	Tue,  1 Sep 2026 11:12:39 +0800 (CST)
Received: from [10.174.177.15] (10.174.177.15) by
 whupemk200018.china.huawei.com (7.152.184.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 1 Sep 2026 11:12:37 +0800
Message-ID: <ecb5978d-977e-46a6-96bf-fb993a7804ef@huawei.com>
Date: Tue, 1 Sep 2026 11:12:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <mawupeng1@huawei.com>, <liuye@kylinos.cn>, <hannes@cmpxchg.org>,
	<mhocko@kernel.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hughd@google.com>, <mgorman@techsingularity.net>,
	<yang@os.amperecomputing.com>, <zhangqiuhao@huawei.com>,
	<wangkefeng.wang@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mm: vmscan: fix scan overshoot and ineligible folio
 scanning
To: <akpm@linux-foundation.org>
References: <20260811070849.1332165-1-mawupeng1@huawei.com>
 <20260811184241.e423b81c8a50d5f212af1c3b@linux-foundation.org>
 <ef7a72dc-fc5f-4b08-833c-05c4ab416605@huawei.com>
 <f53b5d3a-9f16-460c-a7d7-a0f518c2f21d@huawei.com>
 <20260829201809.99fe79c4725413bf80510fed@linux-foundation.org>
From: mawupeng <mawupeng1@huawei.com>
In-Reply-To: <20260829201809.99fe79c4725413bf80510fed@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.15]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk200018.china.huawei.com (7.152.184.119)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 649A2160006
X-Stat-Signature: sbjyiwb86ishomrcbwfw7txepshbhwz5
X-Rspam-User: 
X-HE-Tag: 1788232364-340486
X-HE-Meta: U2FsdGVkX1+0KPeJMd617nxQ+xhXkPT/xeyVRG1WUKPRhioinKeM32JHEthIejeuCL6U0zM4wdavKR8avse/LA4puPErY8xcjZb5jEdL9N1lxh2QMW9McAt2uJJU/5zCTXbBWeNvMLLnHlerTJGoACQ9gfNmAOyHTnOw1hn1z4GwXjtDf4CO2+kZywJxtmgIC+4uba6OXY6IEErldSe49Pk3YEDc/43bzYAWOrm6XiLoKwzj+KMcTMzfvDKfx2QDjFdFuHY1+Ajd27mA8CtCRwVhketoW4OytmG55LB12t4UKY+oFnKrOEPr/3mRboo0PsE6tO4KVM/3Lp5iaaEJewxPmKWWC+d0jTgKXCK0ZHLF7mSIELPy+4Vizz7JdcU0CCie6q/d8oPUALZug6iAMmSjfDFFNvgE896MS1Qq8F2/joYoDz9J2HTD/3QOTAVUX+cvsrX6DUMVVA+LwP9SDuWbYDxUBsrMZx/p6Y0sreRVd57EJiNMzWS8aqGDxOxCvpcGwF/2PgMYxo47TsR4AESoUJaifVtUGe/j9XiiAaU8SmPciqh7nLAWub0C1MaaZ2o4mSgPCXkFopjaNBGw71loVAsX+sYcsRLEPSo+eBQSWMYcJ1THR7X9dN34SotZBwcEB4ql8thStjMORsNsZra6MaGcayLi9OrXnpbPNPw0bQvs3QeBYL32kvdLLHYU/w5DuaxTBHKMYrol+xAKVrHm8VxHS84HqJBjx9clYzz7sMzNmsO+Tp1rfjdivhkxaXPq2LEKUCe+FYJwIomN+cwDOabZjciod+bNl7ZO083mjvxcU7RKOLftEa+INMHEyZw/uQyvT715RSTfTOlxpzFBdNbsgGmiXZ129VvBDpTs8BrIzIrmD2WsAqpRsCW8yzeXkxz4fNJSTChU87Yc7TkGcMwTHDgwWYWW9iy7vojeMElBD5Lib0Bz7sPgu+Hg7YZ+SotdTZnyQzMxRvL
 Ts0O6tpR
 Lnmc1mxGMZUZYoyC3MaNBwKoOs71wOX120MZQX980zE5YjpQbrx2uNxch7dWhmYYVPZhhLLq5LRILcWozs2weXefJzcco3XcJdY4vbZ6KSEJT5sTvFr1n+WsfW3FPj4MDkQeqvFqBBVaG3X9IoP5dKzVc3rR8w6g0ocitzqlq0f2wHAkPVw3fwssFoFngyJ4oN4UZ8SzAk+8hUU6JCw5RVep513aoY+IBll/9zNHJQVyDc7dHFm2dYUzV4rc51ED7pxNEUMiswnudxUCH5o9nKV+cpqbLiIX5PHJHDcR480C1CZxpJ6nvOeVJ7qU181nmtqf44kjAwPg3bBNRCXTAu9E3LavOHzzghTBosNUB9ne9p5VuU5V/pdeNjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 周日 2026-8-30 11:18, Andrew Morton wrote:
> On Tue, 25 Aug 2026 08:59:54 +0800 mawupeng <mawupeng1@huawei.com> wrote:
> 
>> Hi, maintainers
>>   Kindly ping.
> 
> It's been quite a while.  It would be helpful to refresh/retest/resend,
> please.

Thanks, Andrew. I’ll retest it with the background (situation, end-user impact,
reproduction, A/B) folded into the cover letter and re-tested on the current -rc.

> 
> While doing this, please update the changelogging to help reviewers
> understand the end-user impact of the issue.
> 
> Please also give some though to whether we should backport these fixes
> into earlier kernels, with a cc:stable.  Given the unusual
> circumstances which are required to hit this, I'm thinking "no", but
> feel free to disagree!

On cc:stable — I agree it doesn’t seem warranted. The conditions needed
to trigger this are unusual enough that I don’t think a backport is
justified, so I’d lean toward not adding Cc:stable. Happy to revisit if
I’m missing something.

> 


