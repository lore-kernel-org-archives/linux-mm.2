Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CF0CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C426B00E9; Wed, 20 Aug 2025 06:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6347F6B00EA; Wed, 20 Aug 2025 06:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570CF6B00EB; Wed, 20 Aug 2025 06:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45A106B00E9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:20:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7D9B16042D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:20:04 +0000 (UTC)
X-FDA: 83796740328.03.5AF4D6B
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id A701E1A0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:20:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mVfSSDsx3oIfacPYoX9crb2bkb3QiBdGbwuRL5XY7Bk=;
	b=JxFxIyCKX0f0DExKXGdlD58F0U1YGs9Tz3GJI1azMFGyAfRnuMmmXAM6KD6TynXdC5FkxP
	Zjzi5Ld0V+qZgZ16rHcUvbIA9vtHUp/gQ2JtrJHlflvOyodJLgwbHMAFrvlHqMKEpV1k8J
	pD0cXRGoI4Al0vwp92MMDGRlmmw+7pE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685203; a=rsa-sha256;
	cv=none;
	b=zrd2ghKEm6Fz52Xjv4qK5zG6c/jkiLROJGxehi9lPx5WQTbrYMeMSpzVLTo+yt6zlTpxcC
	3zeAm36kqx0TIKFAYFC4zoO4M+fkZZywUAg3cyWyO7Rj6aME957Co9MtZFZWEWf1sE7VLV
	eD8SPJ6FnqLFPrpsKvl9hd9tBKz8GyQ=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6Mqk1B1zztT9v;
	Wed, 20 Aug 2025 18:18:58 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B2AD180485;
	Wed, 20 Aug 2025 18:19:57 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 20 Aug 2025 18:19:56 +0800
Message-ID: <3a894ee7-0d07-496a-bbb8-abcc431b849b@huawei.com>
Date: Wed, 20 Aug 2025 18:19:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH -next 00/16] mm/damon: support ARM32 with LPAE
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
References: <20250814160429.67476-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250814160429.67476-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: sh1bss1ouq93fx73tk6wfouhw4q9eqfq
X-Rspam-User: 
X-Rspamd-Queue-Id: A701E1A0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755685201-347757
X-HE-Meta: U2FsdGVkX18Jx0m+Wv/6OabZ/SF6KjF7u5td8u8rCnHrdruEMTnCxDjgB+qK44yvZxSmCY8rdk17O8pJJiMZiLbprSKzsUftsPvBgUwupgekz8ppjKPz1FdcIKLmZ0fcrhj0kX35WK/0OqyqVehRyl9U+/lfdIoL/d22Nn/+hshX0o/RBxcfb4AUvW9G+PvbaSHsJtlo6wn0PsDCUAiwyn+cmxYWgTFLbCz7s59WlUdXVoH1BdgrOsHvT4llz2FDIAQbdg21BxIeLfit2Jpu3W6zwQ9JvcKa46JbhmeWFWBFxeyL05wgHpoywU4u9/gScbepe765IVg+20wJyeDb4j7P6uqIIWck24+y5G6k/HgWMvKvinD+FcGE2rtvL0JbX+rTNRncdwz96VjPLzNte4Jq0sWslPHesb/dBUBvJEQyOP8+NzZWmym2Xs4tcEBdLyurV7MRq7hj16SmgHSN3eVNE6jwUi7Ywjld3g42eSDsKU7kMAiZhxI4r8kS02kbsZZRyf8nIGON7Lz/hoK+cSDdqo5scH3COiVsmqjws3EhwM2WKC3tzzSKwV3uX1Y/sXRzZZWPIeWb6YgyNv+8Ob2L6aPhXT3dFhUheEcAYSWofcGOYqva2CJQOO7jgQ4UpDcEvlm6ej1XNpOlAnQOO2DGCtbb2meKXW/33MjKB5Tw2nWW17MaUzO7dBmT730jaSPjTmPFoNbfQtB2kIB0etjIJD7gN2hPUZ7TiRFs/GsqP6NWBRayKpUDt5OtgXqkvZ3IJQp86NIffZyyON3Com3LTiIAVD0cfIyAuqHJq8ns+cW+1EQoksVLAQXYRaAIRkkY371zbr3tyPii2Dhm5BMNCLYzrydK2SBciKmQM+g2Q9X/rhF9EHjWcT1FfcgssFuZfzin1VvXJ7RpDtVmSKE2ESl08sluNHyrPV2iv1u//97whyHJZxyUyjecJsciBxMIh8YD2McLhJw9wlo
 8um0P8IY
 jJNpKnHHXLaRVKA5IoqNktFTOHLdX5gWvdk5eLA4lpLWo7Bc5HW5ZuTKmWRhJ5BvDACMp+Gids68JhdHOGROUWgnkGn4lkwlJZcLdRihLU0HIbC0MunLNM4O/Pnk30TIP7jVDYOME0AVQXIJTdJr5ZgzYINpWUlHQgB5HPTihIIdkD/0K0l2PFBA9lYdHbcp0tfhaNRfi6t/KBO2JkCYYIGVd5uL/BJUztTnqUSFtaubZ5Kcy5u9E2MG4ozfrv6P2rFtrBF/tymvTuUa2FpxgwaA9E3MXuUWQrkI/1pjMR4coP53+/bMfKKsnUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

在 2025/8/15 0:04, SeongJae Park 写道:
> On Thu, 14 Aug 2025 22:07:12 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> Hi SJ,
>>
>> Thank you for your detailed suggestions on the patch series. Please allow me
>> some time to thoroughly review each of your recommendations.
> No worry, please take your time :)
>
>> I haven’t responded
>> to every point immediately because I’d like to first attempt updating the patches
>> accordingly. If I encounter any questions or issues during the process, I’ll promptly
>> reach out to discuss them with you, very appreciate your patience and guidance.
> Sounds good.
>
>> By the way, this patch series is based on linux-next(commit:2674d1eadaa2).
> Thank you for sharing this.  From the next time, please use mm-new[1] as a
> baseline for DAMON patches if there is no reason to not do so.
>
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees

I've prepared the v2 patch set based on the mm-new branch[1]. Your valuable
feedback would be greatly appreciated!

[1] https://lore.kernel.org/all/20250820080623.3799131-1-yanquanmin1@huawei.com/

Thanks,
Quanmin Yan


