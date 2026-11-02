Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73563606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3B7gDsJ8
Received: by kanga.kvack.org (Postfix)
	id 3C7F26B05BA; Sun,  1 Nov 2026 22:41:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377606B05BF; Sun,  1 Nov 2026 22:41:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B50D6B05C0; Sun,  1 Nov 2026 22:41:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6D056B05BA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:41:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56E2740B64
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:41:17 +0000 (UTC)
X-FDA: 85388778594.17.69BFC97
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf10.hostedemail.com (Postfix) with ESMTP id CFB23C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:41:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3B7gDsJ8;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590874;
	b=lnofonDJcqP/+sdriFN+75hR857S6Mnphq0j5jttPYHDkwzdZK5J+cJeLEVOhwlfRrm9ZX
	uNc2GKbwK15JwaHyCMm1dT44P9wwU9TKRDCmt2PG7tEv/4S3WHYY1IxiEcPohdlXLViwac
	fDHzhqUXb9pk7VREmCjJ/3xXN0PqbWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR1jOcsnI9GCpe3QQ9dt+U7gOwd7hIlEUMvUAgLiWqk=;
	b=ca3guoc7/NYZJXH0S/Iz4t/aM+MORv8nu6ikq1TwFRwbvsdcGHOFvXuuvkZyLPy6uP/pC5
	W6s3RCnHT37BKo1XbZvXnMBcqBnAOnF5/POseceh9peGP4fvqMH3CwYXLyusmA0H909LHH
	QS3a7uvEk3K9VZI8OUo7ETe7yiAOkJo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3B7gDsJ8;
	spf=pass (imf10.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KR1jOcsnI9GCpe3QQ9dt+U7gOwd7hIlEUMvUAgLiWqk=;
	b=3B7gDsJ8xfHqkgi3KkG1yOe9d8WWWW7/nlC1Ss0M6f22Tv7aoxjlEB6VhpvS5doM2vHpc1pZf
	OAcSMTbQmnoy3xQgM3M6uNnrU3NUPAl2UzG2haON5M/Jye34C23CUIqK3tZaQEZV/qg0Vjz+omn
	8jasrRGVPG43BJXOMtiwL0k=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jHyCs18hqzLlvp;
	Mon,  2 Nov 2026 11:40:57 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 91DED4057C;
	Mon,  2 Nov 2026 11:41:06 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 2 Nov 2026 11:41:05 +0800
Subject: Re: [PATCH] mm: memory-failure: update statistics before emitting the
 trace event
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
CC: Mauro Carvalho Chehab <m.chehab@huawei.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, Andrew Morton
	<akpm@linux-foundation.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	zhenwei pi <pizhenwei@bytedance.com>
References: <d472a9a3ccfa8c0359d7d7acabed92c8927d8e47.1793174996.git.mchehab+huawei@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <85af4757-745f-08d4-b896-d38f9fad632c@huawei.com>
Date: Mon, 2 Nov 2026 11:40:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d472a9a3ccfa8c0359d7d7acabed92c8927d8e47.1793174996.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: iqk9i5n3n4ytkexjddkbsain6f68dtw8
X-Rspamd-Queue-Id: CFB23C0004
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793590873-396062
X-HE-Meta: U2FsdGVkX1/PsBvv4p72hBQ3Fn5St5pkZGYj425YybryQz6ZV0uKbUS3wW2B/6vrDKL0dg5qgLAwp0XpFpDXbmu7Sno7L+leO5QISW22Cl0r17/iZm2zvnOLTD3bume3pDexIdqDkjPNYRZ4lGL8nwE7ocfOsTLxkc/SayLxs/xCfb+0ckd1karsl2KQtmtuGnKh4F4rZrcodEEAN5VFL7BlLRdNOeu9QLggnEJo8ssaCiFQrntsEdhGB/YMxiC8TuMQIwg7muoi/ZULT8BqXQ/g1FlRk5/ehSzjkcASSszQUCIODVRcTiUkDIVRMqUZxN6/GZzOqvaKRNf0FT35e804gVGm/ODxK0OmeQSx13RiT4taSMp9ceZvtI1QlgSVIHchey6v5+Iqx2gpB2AEuamWO70gDD/ZVwSMUrDLexwA58gbOfptAXIPN80Tj+FASmuH6+qu7RO6yXGSUUJQ+BzKvWYsCMSMSWkS61DO6JY69hTmLlqRlkz9zurhtc31jdYZk7vOnBdjNQc+K4/yWGv2SCJmDwxQvC43Zp1OIaK0qZWHCXpjK+Y6D0cLCDBEXm4B2z1wKmj+Cf8HitbwRC6SXT6FT5aToDmGglQfq2rXLTosr21g6R/n3bRYb0B4ZqzEcIKwCyE/AKNnKhmK1uNkTAodHfdQUjnPi8JjYymIIM97ClidPo1dTVCJrS/6tYEnH1aVm1Hc/cZyXxtUGQW/1TyAa4tDPVAch9lHqUXopmcAzet0XSBYP8vnSRnqGCbL840CFZI8QbCvamL01/7IBE1paWWzb8z6NgTMELI+Mo4ILPmR2UKPDZM8zHEiYCckSaV76d2esTcIpWSb/joqrdKP3XvA7h/B7PrOFWcMN0RbOU7RHU4odw2DwsS4WJNEQRbvj7tHKD1evQUqWotlq4fl/adhicWoBbyNPIvqL5WxivP5jq+6hKOvCQTKjgJoAxZKKsruksc/3/V
 4rE2ojMz
 LMlF63lY69sxha+9g5fKzyQM08l+LkLWpQB2ACAMzK5swt+Osm9RqsTD+VVRYPraWyq7ZKEZ7lwfopKgHMQiM3KDXXOzaRMYtR1iL6FSS1BzFd8X1Z+I/5D+4n9PAO44ZQ/y41fdfWLlDjwJCyJunebI89SbXlPCdwTrRD/dNUYhnMvwe+0nbn8sjnP9aLLMyDMxHfdQUhIQXfHLINlMvH9PF23rUqDAd6BF/f1RWc9T97kKUYi8ysx8sYe6Rr/yLbsHimneNY5ntsbyfLCYRCVM/zoL/kj4trfHqDMhbnsA/jYQ2n6P2yp3reQNPCBN33eqAseReTxJBKI49LvBpYPDJjb0sn2Xtr0Rln2DzShaoy5JhT5UEA8UqlwhM4GZelguUchTu4jZKmIoZShkWaXaYdqR009vie1HnDevIwxYxZAjPGXX+eEovqaZfkVNhH9uQiQIde8OoTyeyMJV6cKvcguemBbxgnUwoEec68g7zKTuqTaOEB346QXqYANBm+Itcwtj5Qi5eX02FnGpPca15tb0G9q9zGJuNAuDUmvIIcnXRoNJdvok+v0E9jYxyiwu7Rk+A7mpyvGN5oe44uJX9oZXXYbV7s/xViSEyMMSC/sMANCbNwhhMp9lUDFtyJ++y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/28 16:09, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <m.chehab@huawei.com>
> 
> Today's rasdaemon-ci run showed a race condition at the page poison
> logic affecting userspace (rasdaemon): action_result() emits a
> memory_failure_event before incrementing num_poisoned_pages and
> updating the per-node memory failure statistics.
> 
> That causes userspace to read /proc/meminfo to detect HardwareCorrupted
> trace events to warn if the value exceeds POISON_STAT_THRESHOLD.
> This works most of the cases, but there is a chance that the value
> not being updated in time before libtraceevent notification is handled.
> 
> Root cause is commit e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
> which changed the order of updates.
> 
> Rasdaemod-ci run up to Oct 27 worked properly, but on today's run, it
> failed to get the HardwareCorrupted data from /proc/meminfo because
> it was updated only after trigging the hardware error event:
> 	https://mchehab.github.io/rasdaemon-ci/failures/20261028T035110Z-40629018388/daily/aarch64/consumer-poison-page-stat.html
> 
> E.g. it failed to log this:
> 	rasdaemon: Poison page statistics exceeded threshold: 4 kB (threshold: 0 kB)
> 
> This is important for rasdaemon, as the consumer's action monitors a failed
> threshold before poisoning pages. So, if the counter doesn't update properly,
> it will end not poisoning pages at the expected threshold.
> 
> Fixes: e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
> Closes: https://github.com/mchehab/rasdaemon-ci/actions/runs/40629018388
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

