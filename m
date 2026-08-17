Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B66C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EC76B0098; Mon, 17 Aug 2026 03:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767336B00A3; Mon, 17 Aug 2026 03:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CCB6B00A5; Mon, 17 Aug 2026 03:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 49AEC6B0098
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:25:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8BA0C06CC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:25:01 +0000 (UTC)
X-FDA: 85109924802.01.11005F5
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id 62EAA40002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:24:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rk30CB/9";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786951500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhqyhFdgQQVpP+EUiPAsg/29XxaoBS6WYqF/YGzX0sc=;
	b=46o/pjL90fn+PkzcT28P8zpQijhdEnp3DOrFE/gORPSW8K1P9eKAfasIAO0NgDGqdx1Ny/
	mzdqr3nONoxBXwyGGNGG+TDPGFtSKnAy+B8MZ2H/HOeErA/Q1tGCB4GQsxTImflPQUJm9w
	7v/j/g3Trbk89dxbyIQHjh/85KD/Ttw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="rk30CB/9";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786951500;
	b=Glu5w8EtEPnPvJDtpWQcUJqAVRQf1iUNjeuAcSZaG3yohfre2Y/LiNn7JKM/qTbDsAHIIU
	KiLLSOz+ETGQg8ogrqOz/NgfQDvL49NvIubwTvRu8+R0MNUzoHURp1v2KZI322/87ZITjX
	oeJqFNp1H5yYiZcgG9T20ie3mtiszwE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786951495; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yhqyhFdgQQVpP+EUiPAsg/29XxaoBS6WYqF/YGzX0sc=;
	b=rk30CB/9fQTiaBMqINWq0uEjmSOmBEYvPcP1lUI0f+FgAbkmN4xzlGGOQ5FKfPWPIYmUd7EOhHvJYCut3tKdTNJu5auTUR8cY1pylBhZlaTE8UrnqcibjkA/fV6oqrt9kPuXwxpWEmUBcc31YddyIjDC809ocQh9HdG/AlFgCGE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X93ZATh_1786951492;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X93ZATh_1786951492 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 17 Aug 2026 15:24:53 +0800
Message-ID: <bf0063c7-8db1-4e35-a785-d9a0dea9b2bb@linux.alibaba.com>
Date: Mon, 17 Aug 2026 15:24:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
To: Lance Yang <lance.yang@linux.dev>
Cc: vernon2gm@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260815174444.4164-1-lance.yang@linux.dev>
 <20260815181632.21453-1-lance.yang@linux.dev>
 <0c4125f4-fbaa-43ad-9cc6-b9c5ae4af89f@linux.alibaba.com>
 <811a8454-daef-4a2c-a1a8-4374e83f8c35@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <811a8454-daef-4a2c-a1a8-4374e83f8c35@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 62EAA40002
X-Rspamd-Server: rspam07
X-Stat-Signature: rk6f7iucoy13m1ytzckng8npfsyyxt3b
X-HE-Tag: 1786951497-115750
X-HE-Meta: U2FsdGVkX1+6UL6vhC/Yp2C3dpO+YD1YGlnVwpgae1IY9UEGBp3Kw2v+mk3OykROJH7yYUfiXdJs+P+ofv8PitXkDK3Y7N4npd8i3Hi+Liat12WqJ9q8pm69ELIiqJ1YbIWxsziCP6Sva/6UsY2s9ODsDudD4artkVUPshE9b3R9S3wTLTnTk888ig0SjUsv7mKA3CW45V5+Nb4v691YW7OiZQTw/uo4pkBnsjgvBIlLXg52SSLJMPNh4v387gzf3nAt9xsxnrVSfzsIQaYMpaCbl1D6cGKUSPF7cbUxDBK7fa095LbokEyScX8b+uRmjOVMUcpdsVbSHgh+h2hPwVoj7xVuHHFWJJN/f0RNCRHs8IbOrG84eZJFSBVyKph+2tZ40HQNGB7Bm/Ey6Dly7GHhTJ7ZgBt2yeq+/QWGffMuyBwpEMhI70inDdWPc9y33pgTFmB8J4GdqzGJdjwsAi6PSz5F/WvwRRr2kd0dGH+r20V6BtwvU6FpOnfg9gd5ioPk0aClIC4r28FW0qjes7rwib2Kkaw80Uo7q7t2g13rF79OvVdOJwkrtQPK4FcgTLvWjVYjRVYXO1pOnh+jnSrYFDXzRpy1vNrXEJlRo5li0nFQ3Ktwj6W0NRqCEl3+hWDcOh4aJFKiKHQUYH0DsXKoMT7sAXpJjQ1zTuyRGhmpfpieNzc98CRh/mDLmeCWEo2ySxG0+6cShztFXrxJeBs/3JolEwytRXWGm59vlUmEvc6pBr54g4QrPX8FopvmjK6WnWO2z0s4SerR6V8K523EPTLGVwHwedYQXbMj8P+sRVuIpPuXuRwpYTDHYDbVCCT9wlOxWOSnBaffDvWwffDeXpnHiPtZtvzxpB0ao6jF6691wj/dpTPy5C+SfvViOHuHoUbeAmtiLChU91OEcM0JMGGnVMkWjVCC0+ND5JEdPFXs0+XIo5smWtB+4PmPQdlWTwmOhNvpb0BEm0n
 fzsXS2bb
 pJ4jykBzFbVwdEDSQbXoB1rI0tr49+2RN04Xnm8uFzd7xMAFRUtORYAqdDxvsmMToePwpSK/2/NTWs3lfeIiA5qaIxAeAIaBIBhC1t57u2M62P/FotAoAn1FylewS9hxQwGwl13r8y3nMbgNBFIvqBL7KzKn00SMsM5hFycJSZIcMtRYiwm8kiL7kH0Ttgqbh/JSPcPC+s2wKyCpe4+d/04y4+85NJi+WyOJCbHb9Qrbr3j8nC1bc/tIllk6X22VBu/7jS6SqG8LpCpqDRnyW4GfmNL3VF+UYRbzZtnlR73Opob/HzoP1e0peJ0oS7UHZXWVS0Mqg7cccu1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 10:53 AM, Lance Yang wrote:
> 
> 
> On 2026/8/17 10:25, Baolin Wang wrote:
>> Hi Lance,
>>
>> On 8/16/26 2:16 AM, Lance Yang wrote:
>>> +Cc Baolin
>>>
>>> On Sun, Aug 16, 2026 at 01:44:44AM +0800, Lance Yang wrote:
>>>>
>>>> On Sat, Aug 15, 2026 at 01:19:21PM +0800, Vernon Yang wrote:
> [...]
>> Otherwise, I can fix it. Thanks for your report and analysis.
> 
> Yeah, please go ahead :) Thanks, Baolin!

FYI: I've posted the fix and verified it resolves the issue from my testing.

https://lore.kernel.org/all/ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com/

