Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8860FC79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9356B009B; Sun,  6 Sep 2026 23:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881B66B009D; Sun,  6 Sep 2026 23:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE846B009E; Sun,  6 Sep 2026 23:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5752B6B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:05:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0D5840462
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:05:34 +0000 (UTC)
X-FDA: 85185475788.21.AC646FF
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf31.hostedemail.com (Postfix) with ESMTP id E120020004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:05:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PiC6HyEQ;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788750333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVlgjFyr8X3oCWakePj9eLcqUMiSwXFx9x+NdGeLY4I=;
	b=K6IExRS0XcBFCO2AE/R90EtpxmYsw6UX+Z08ss+iP12oWbZ38rt2wmkawKAsg+LBY+SgxR
	EuCPvQdHI481ek5nB7MXrMCcXMZWpeIeo2UY2WrjA+91vAhHh/y4/Q+f8Diq0f6vt5Pn/+
	PNgHHgJ2KtBIzQSe/xAYbEwyIGU7+GA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788750333;
	b=BtTUPEVHYFQz1pyibgvgbtORydurvKEe2DLR6uFZJqTfcA2D8bD8jxlTMsA6eBkGD7Yf+4
	XRYBV0nJGoGv6J/f3O19LkZTSwkRDyYVgxiNb4Xt5YdRKExIVP0ov48bx4nik137iXXR6W
	m2VoSaD6QXSTLmS+Bn6jXHPjqZH6RvI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PiC6HyEQ;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qVlgjFyr8X3oCWakePj9eLcqUMiSwXFx9x+NdGeLY4I=;
	b=PiC6HyEQi62P8vWr3VMiTe9VyyEKf6iXKJdsCLfQpnpObLXCcLee2cLRhB1uPrSv4MCnf/gwm
	F5udepC2YFJ+PQ5fObcZpoHPX7VIW1qeuaT2XwFcMgbJgxWjk8F0EDIcA+a1XFYoKFowiTwOHRE
	qfOuZ4rl2OjE4Vd6rnOOVgU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hdWrB1CZSz1K96b;
	Mon,  7 Sep 2026 10:54:34 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4077540565;
	Mon,  7 Sep 2026 11:05:27 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 11:05:26 +0800
Subject: Re: [PATCH 4/8] mm/memory-failure: convert process iterator to
 for_each_process_rcu
To: Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20260904083001.553587-1-ye.liu@linux.dev>
 <20260904083001.553587-5-ye.liu@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <cc748395-95ea-a7d7-d1c9-9678d2eaae21@huawei.com>
Date: Mon, 7 Sep 2026 11:05:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260904083001.553587-5-ye.liu@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E120020004
X-Stat-Signature: 6e54gcon3h3x5p5cb5udff59fhohkobw
X-HE-Tag: 1788750331-16672
X-HE-Meta: U2FsdGVkX195HLhoX7aAup4a5CCrp6oq6mhbQiA7bt3fv/rdjKh+VHU7MFf0rOAvqzyPlyAEi/68NI+xl5Y3qQ06u2eOcjcGajZ6q1vPjwvc8ECkoheq7Z7o9nufjPRdb9EhExf/ATSQyPEe/eMQ1tNS1izhhYsV6QKiboEwr06J51IPXQ3YkE1VmqkIokMpD1T4kZLUTWZYLuaZ0zWC/puhmjhwcD4Ca7YTsPljXBEA93eRzD37Oj9rFHWNFPsjjizrPRRfHjw9Al7aTeUa92Pn3qirHnWlVSN37+EDzC6HSLD1/3WXFgV9xjI9gqBJGNIT3ezGsnupWGHV3iDb+QoA+2P2DxUv28QGGBtBO9w+rtIMrlVokZbMAt73BZIBSJuCfBs0H7uJW34OGRuMd4XI41pV4SAf7SOUoXk5MJG7SqM3OolIJKjzAauBsuFbCIBXAcsg0EytMyekLcpaMkfZzQ3S9EXJADRy8fBgwtkWcZftESKaNSG651JSqtR3vi+5fMJNxhWt6MX8hzeY4OgB7hwZlqJqkXKOai6eKNScxYCr+Hn/eMcFCigmlActINdTr84W2PoOca98cAhCo74HiMDlK2HaQwQjJGKPENc8KkFvlFZBqB0YgkjvzCd32J2lynybDIqACFMkWAZDIsPC5F2chc0MH1O6O3pAgUSIXWMVioFiRj32JChJwOuASmx4kKpRegZLsJqcmBZ01hLyL5kyBM8bR7NQ/Av82XP1kTaCWezqmN/AaCgUH5SkhlH7hbm3QyYqt468yyYtwaHfsDc6Ejom4BiSHAmAVXKh4O9u74ZbBNQLe63Xcx4WJ1SgEcUHPIfV+6dKLW779H+cc5wN4xJepqDx/jr+o8lE+grgJUSJe72kPonGwzk0LhEXPM/lGiP43+Qy6XZdnX1xw1zwQSf52RIHPx6h9xYSHQkHc/wPVAwmLbQmmbu3tggdU5v883RCPP/vwl9
 yG/dMJqv
 zVvqGFeGL4qCz83Mo1T8RGpDiTegYUdKsLwbRX6tq6mX85gm9nIEkGYD4lurETj5v8QnGmypl3+NpMcndOkgEDqE6EAUxBgOSfXO+DTjsEFSb/gWz/+lgj+cBGEohBowJXQP5LdLdSrrhwofublSL2NLLXL88lNoJtZZRiif8m32eqhcwCl4mK3L2N1eaJTvv9PObhVZiLOMDxYI+BAxpH8ceRT/C2eDglHU6K0nLsHWwTtgRguODa6+huNBeV2F4ru2SxSw64sDR0H6lTuT6Ktl33pO+1YoYN4Od2MVjmuLRjowpaYYc/OBdhJmFaOZQX3GncWIcjLMiuynAvxpT70mnzo0aHPD096KjLnObaaOLm6kM50RYB0ZEuudwLDPJs4/D9Si6QkvDzIc5Kbx1ZtHdgDx+OM4Ty/gagNOrb9IcSpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/9/4 16:29, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rcu().
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

With SJ's comment addressed:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

