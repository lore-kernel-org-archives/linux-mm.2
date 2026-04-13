Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89340E93805
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 03:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB176B0089; Sun, 12 Apr 2026 23:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B256B008A; Sun, 12 Apr 2026 23:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1326B0092; Sun, 12 Apr 2026 23:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 777196B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 23:31:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 277431B8D89
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:31:50 +0000 (UTC)
X-FDA: 84652108380.29.5B202B9
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf19.hostedemail.com (Postfix) with ESMTP id 001B71A0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:31:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OoViFbHe;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776051108; a=rsa-sha256;
	cv=none;
	b=uXDTpshBchkzqeXWgA1dwwHnDGlzOfLfq9kLatb1iTviukvUSO9xDCB1GiJzzFth+MCvv8
	yGM+RgZmtCT+TOpniEu+i9O9IsJx5sL/J9TR8+w6AMWdRbqQwXy3sU8/Spz6M8BP1C2NRi
	Fpq8jJ0KOauBMh/iUMW/w8omLe/ow0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776051108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ueLlBkmMTgxuYXvfj3WaDX1n42xw4xqdgGRvpbeG28=;
	b=OzYQ27tXRS1ruT3wVzMbKI6IT/DS8MSaCrxPKLjuNmk5TVfbzM/eRI/z0bTdLdDvRlrjKB
	oimZTlVldpDX7xNOzrWT7WQEYH2xMK+8ni/+UcfnqTLjXlaksxCYmlwqhvRecxTF41t8sO
	l0ZfGH+okhIQci+1sm2oAo/aUQRoMS4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=OoViFbHe;
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2ueLlBkmMTgxuYXvfj3WaDX1n42xw4xqdgGRvpbeG28=;
	b=OoViFbHeEYjIOe9TmoWfe8VsscyZQ/cxdjJruSbTVUYqztZ4UFIhAKQghnPfYRFAIMQYvxWM9
	1UcPllNECPTN43FTCWp8sRl6k8zBdpNTEI59i3YgCyfgzgtYN+5oH4oEKxkH97mBiJeNkKFzXoi
	ksGmPFilpW7TEwDTe/BxQzs=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fvCTY4plFz1prLm;
	Mon, 13 Apr 2026 11:25:21 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 72E444048F;
	Mon, 13 Apr 2026 11:31:41 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:31:41 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 11:31:40 +0800
Subject: Re: [PATCH v2] mm/memory-failure: use bool for forcekill state
To: Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
References: <20260410074740.2524718-1-ye.liu@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6b58ae30-e83e-02e4-1311-78d7e63649a8@huawei.com>
Date: Mon, 13 Apr 2026 11:31:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260410074740.2524718-1-ye.liu@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 001B71A0004
X-Stat-Signature: ttybadg8z3bf1wxskto5e4nd1mmo6fj8
X-HE-Tag: 1776051106-290699
X-HE-Meta: U2FsdGVkX1/gbZ3FXa8qLZ0VeaN5sSWxammGbZYfZ0WUedJCIfVFA8fe8EtAAYfMNnTexsdxb8ERWhzVJB7JS1bPBZFsQUW5htG18Voajch/vYiyUuHWOBgMb3u4EpwquTW7af2okAQu14DWIB8E0a/yIK3i/G4PXUsdaPi/9DWkuHJqgobnrk2j1cKU0e/lyNWmFazzHnZRBAR26fK9LNPYVv2KWEuZC2NFBOBMkhs0d95O6hN1PZ81J/w0w/EMbzUzr1AZmn5rjHc97H7nFi6WOudVFOk0/YtQf7FIDHbRjpro0ifDV6lA5b2TjWmpErbfCz49Fd2DzlQHrEGZBxyffwD7owdoxZkOzcNZMphAQS3pyzfHJ4NqaGT0cxAf+qYBbSu1w6+wI2OSKBLT8uwrf43Y+rNSpFjaiWESDejrKw/Q34r1nR0UZ5H2LbtXP3nyHL/84AaT/M1KKJ5v2XjQubjEYhbiw34+azOFm4kcPjXPw1E9aJ2VZWMmvqsxWXR7qgP8VWybHSGIp09jjgE7OrnHGZgXQ3BrpSExZYojQlbEBzgmPBNz56mEJOSPOnUq22RwD7/2siTqUKJyJUqFrEE0Q4sDfA8Pd8Hyp+Rt08KMQTxcWTkk6Gfr2ULC5/Q848WK68h1xOO205YSRKYqWOL6hpHEeu0qEvDRCemUFtBf2MdjhA+Ng+8GEHLbtjt/2YsEdJ5NJcD519M/CVmEp61OXhcfPec5hDgd+0AhOjxH44iCrNZbaXcJ377FogII6OSHax6Q0iRQVS4SMloLmzzPpAY/DQoNnx4xsOSnnaaYe2flcnOZoLdMV/V735AF7mnWSdv/+OVZ9Sw2iKKfKeZRZaUA04u66IwO5WqzbJhMNludeYJf32l8wQIrQpFfu9z0Qa5TFK5v7pWXMbJLzi+UXIQo5u0ge34yLATSCaOV8AnRRY3IcYd0iMBHjw2cWpishYcJHz7DU5X
 phZf1gYu
 G312AJC7mFliKOC52A8JwiyjVVR1DPrEa+zbNV0rP2ZojzFgJWQEICWWO+2nVRQN5n4d74Vx6gG26T3anZGBBoarwkMvR+iAMnE5OJMdc/2osLfr/NM0nhWvAjn7sEu0mLJSgE7MLDRtp4hFNU43RokaQ77v2dUMkoNsSqd/tQrTcFPtE9b3evk9QIsf0Dw2LQehlaBhWejprNEKzhKMECpSyoP8JgzE/pCTARi6o2fJGXmjd5UuPcrAD3Hi1md+pF141Cq68J545/mfys84KjMI7IdPYvb9jOAuOuJoC7gCB4xaF3GTf6x5zNChweupDQQBKyva+XVY4SH6VKVHlXDQ+5ti5EWAudUiYdrKywkrF6dqKsPWwprgpIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/10 15:47, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> 'forcekill' is used as a boolean flag to control whether
> processes should be forcibly killed. It is only assigned
> from boolean expressions and never used in arithmetic or
> bitmask operations.
> 
> Convert it from int to bool.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

