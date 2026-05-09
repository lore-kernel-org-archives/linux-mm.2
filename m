Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39045CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 02:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D45C6B02EC; Fri,  8 May 2026 22:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585EB6B02ED; Fri,  8 May 2026 22:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C446B02EE; Fri,  8 May 2026 22:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB506B02EC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:29:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2DD016046C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:29:03 +0000 (UTC)
X-FDA: 84746298966.04.635BF4C
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FB92A0002
	for <linux-mm@kvack.org>; Sat,  9 May 2026 02:28:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ww+c9pdn;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778293741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1srowB0pSduQoa7nVivwOT+8TgG0TfDPqYQDIh/X9JM=;
	b=rCP0aHH9+ZBFq4puPOPJrBrjKZbuRY8bmRuMbABNZx7PyyGMZ7U/K3Ms+2aLq6BvuilRO3
	rSLNmQsl/K6Gb9c/GiXmFyefWno4HoMbzlMOAqYxzlC/mqUVhdam6r2Sa3M3D/2qrigdIM
	TER+IrhzfVryJMCptf5g/iKxiloPCbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778293741; a=rsa-sha256;
	cv=none;
	b=gLRxV1s6WNxdq6yvZR3HIQ9zDsJuHnYtTiuYPbY82eh7GTX8O1Hst7x00Tr2D6lN7Nk1dd
	gaZbrWl02FEnufoJurUZaNGdgqZcXB1QFsZQcpit7DlHSEYvKeOy/Wg0bZa5yRHDORvWjE
	QWQvM95vytgqhHRTcMousXVCnX27v9A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ww+c9pdn;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1srowB0pSduQoa7nVivwOT+8TgG0TfDPqYQDIh/X9JM=;
	b=Ww+c9pdnDwNHLWwi9QPoBBSa3wUh/7Jm+RLyL80YEQhtQyO58EHJkVhLQz2vqdI7b1h5AR5S7
	9xcvN1RKgpaEl0ixBYre7J2OIWMtBR8qjKauAXAfYcPe02Pgo1wwA/idRdjeTJ9TBcxAP5OCQRQ
	rkCWZZVrDP5LdRaeYNwKegI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gC8qj1ZrJz1cyQc;
	Sat,  9 May 2026 10:21:21 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6BEF340572;
	Sat,  9 May 2026 10:28:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 May 2026 10:28:54 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 May 2026 10:28:53 +0800
Subject: Re: [PATCH 2/2] mm/memory-failure: use bool for forcekill state
To: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
 <20260407020715.2269255-3-ye.liu@linux.dev>
 <9d022499-2a77-f8c6-b86d-d9de838fac32@huawei.com>
 <20260508170854.a845bd71e7ebd5d2f6927fcb@linux-foundation.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ec25f11a-7107-4fd7-cc9e-768387da6fd2@huawei.com>
Date: Sat, 9 May 2026 10:28:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260508170854.a845bd71e7ebd5d2f6927fcb@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2FB92A0002
X-Rspam-User: 
X-Stat-Signature: wd5c5a385cd4hgks6kk68zyde1irwgaz
X-HE-Tag: 1778293739-470209
X-HE-Meta: U2FsdGVkX18Y8YzTVJMb0+CacWH8L9jXB/cvEabzCflNoJEYuIeIYN+0EMKqPNB/KPS1D+8teScvvBO1f8DUfJX66mQU6ZE4x3ZUtiJ0IF3d+ZTwjcjmR/DAtvJw5X715egXW9M5gQFTYLiI6+BfKTUqx7LfoBFXMfaL9i/o8VY47jGEG6QJeKa59lzBcKMfv143xsmJY1dD4/OttqWInNWPod7XKKYWY8ZyWTKrqxcmFpCOpNRCGntWvu2xJquTlLD9ci29g9JWbBBXmWJH7vUULV7BwfNKH0dFXYCH1+W5K/YkLzz0HGUXwGCP2ooKv+/wm4w8OQ78rFQDnb+emy7OSBnIJnB0UiBRUcpqfQcqorZnVjkWa5BrTq0RW1oMQiPb+/XQdezehE6vilYpavdKBNczSYdcCmx0FTzgA11BBBIJWAwCadvcO85xjCHpFlcWqVqBfG7KcSfHJDAwT/OSB7EBgScKGBhABWfHKYek1IU+PKNfHOJxTh0Qe2AHtfDMKC+7cBXcpOOwXsdm96Wkp5z04hI5eiWXSdmJasO0sDR4w6FXRt3DsJ0Q1RsUaZP2p/7BhhPnhvjMPRLXojWBTbBCbNTIYsxOzN4oDSAV3AD0Wl6UB5jsQCVcP6cw/CfFifbOmGcZ7ur6q7tdRcUHx9tx0WVkqjaHKrqZ6p7i/ViloIfdYbgv0TSwdq+lXuBbyKvfQibsaki4/6UTYFpIOKszMUdDZPORbbiLoSSQaSJ1HEUtkHaSHI0CGK0Fag/IOa5ugf2JR8T22jnBlLEU2DKRuhvZRQ46bWN6C1f5UePW94Uy4vZWeNXi76MGSic2RitLUoDfACul4jMltVGOmevan29wJDfMKOMcS/TtyuV6AkvcLnwPcl31kLKBIabZ2Cau2OcpLT8by6Uifg33XCHICcBSqY7+mxVEaoy/6hcSeQPg49jcPSg3ZgIVtmEYagR605ZJedrFCIv
 u/qBNhSU
 hmWnMnYl8HwjRpYdU/xvEIctqWfbd8CTkNXsWEuMZyd1UGyl5ofC08bWCe0LbduFjfFpRec+EcDHcRyjkaCf093OIU83CgMltage5qollXiGFN+eel3x3xZVAZfD/TGbcRi8Njz8CwaznleCUsuV72k0B9Qqsg1t57HTQNqWz8y3BoyvKhASA95PWgrbHFuMbxS6u2uf9kVywOws+tySWaxJqJoND2B4YZprqlBoMf6P80pP00NnJpRvkZidxULcfYn5w6YEtUICeGfgxCCMoReyd8+dfHOmk+yz8sNxyyafAGeFfNsbGqHoX8UVYbiAO3K8oFJjt4sFkmYWSupT9bZscW5xvY9dpy7rwx51DwPexcwPIvfJCJvJ2fScxpK8itYGj9DjIkmlfyoQy+vnlIubk9/og6zqn6J3/2aj5yrXZCVSP0TOjW0+7zWBconW7ILtn7/fGwqIdBRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/9 8:08, Andrew Morton wrote:
> On Fri, 10 Apr 2026 14:45:47 +0800 Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
>> On 2026/4/7 10:07, Ye Liu wrote:
>>> From: Ye Liu <liuye@kylinos.cn>
>>>
>>> 'forcekill' is used as a boolean flag to control whether
>>> processes should be forcibly killed. It is only assigned
>>> from boolean expressions and never used in arithmetic or
>>> bitmask operations.
>>>
>>> Convert it from int to bool.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>>> ---
>>>  mm/memory-failure.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index d25adb390c3e..f355642bc2b6 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>>>   * Only do anything when FORCEKILL is set, otherwise just free the
>>>   * list (this is used for clean pages which do not need killing)
>>>   */
>>> -static void kill_procs(struct list_head *to_kill, int forcekill,
>>> +static void kill_procs(struct list_head *to_kill, bool forcekill,
>>>  		unsigned long pfn, int flags)
>>>  {
>>>  	struct to_kill *tk, *next;
>>> @@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
>>>  {
>>>  	LIST_HEAD(tokill);
>>>  	bool unmap_success;
>>> -	int forcekill;
>>> +	bool forcekill;
>>>  	bool mlocked = folio_test_mlocked(folio);
>>
>> There is one caller in unmap_and_kill():
>> 	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
>>
>> It seems flags & MF_MUST_KILL does not return bool. So maybe we should change it
>> to clear semantic conversion?
> 
> AI review was wondering the same thing ;) And possibly a changelog
> glitch.
> 
> 	https://sashiko.dev/#/patchset/20260407020715.2269255-2-ye.liu@linux.dev

Thanks Andrew. I see there is a v2 patch [1] that has used a boolean expression to
align with the commit's stated intent as AI requested. I guess you might missed that
thread.

[1] https://lore.kernel.org/all/20260410074740.2524718-1-ye.liu@linux.dev/

Thanks.
.

> 
> .
> 


