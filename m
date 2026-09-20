Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3ACC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F756B0088; Sun, 20 Sep 2026 03:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6E86B008A; Sun, 20 Sep 2026 03:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733336B008C; Sun, 20 Sep 2026 03:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5153C6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:54:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B05A803E6
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:54:00 +0000 (UTC)
X-FDA: 85233377040.23.2875D29
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1CFC3160004
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:53:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BtFzRmqj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789890838;
	b=5duS090w1McC3P+753Ha38niMpsQflDcLWiwKsPDd2jDCWwbORLUQk1JJvcmFTH6k99+Af
	IWY/nDU2aZaEdkmOFOJTjjbQUpSJvMQ9Ech7JZGbTZdKQV/Ud6gwxQfE2XtxxABcZc4ALU
	NHId3nPaEGyNjX75dciM4XWNzb0EdtQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BtFzRmqj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789890838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBz8EqeoI4WPFMaWg3Saazz9hVBehFhoLWtPiArTO7Q=;
	b=dfHxBkJ5EXQGUce7ifKvVJP+cQKbyzqqVdnHMaZlZCycVTQeh8F31BzutQfqR+K5RST8gF
	UDhKR7yZTZ6agcmXoyPI/4FmURIFmhuKX79O/3Ff1nKEeWkIfqooHIY264u9PZfz85EClY
	D9IrB3CQDMGg6NT09DfLEArUc7/AO10=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ofWAQlYpdWhjj6U/g7ojcf/VhSZsLy3f4wqaySbylHU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789890836; v=1; x=1790495636;
 b=BtFzRmqjOuGi3nY6+LrGvg2D6woor1Wj1x3+8W01p4ezFyEymtOZCNNY08T6yd1CUOLvXmAk
 toc8uws5Kx1IGL8+1LN1WhmHrZ1LjicSm1yQPYU7IvJeYNh86QzTNV0a/BsLL9i8PNB79q8w2gH
 3qjLvvr2QCLeYB49jYH8XQ5o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1afdd80ea8a24a3b;
	Sun, 20 Sep 2026 07:53:56 +0000
X-Mizu-Trace-ID: 1afdd80ea8a24a3b
X-Migadu-Flow: FLOW_OUT
Message-ID: <17ab543b-2067-4ff0-9505-46ad2837ab73@linux.dev>
Date: Sun, 20 Sep 2026 15:53:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapops: remove unused is_hwpoison_entry()
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>
References: <20260918165642.1014988-1-ekffu200098@gmail.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260918165642.1014988-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CFC3160004
X-Stat-Signature: kshmu94wz8zpn3r89g5owitb7jzeprjj
X-HE-Tag: 1789890837-263159
X-HE-Meta: U2FsdGVkX19kNRxaq9aG43uBwRZI4jn40b9/PWpDRLkd17gk7tOjgqVkZUK6E9y3Ob7uGFYH8TB6PhCk0leXRwp0DWpwovce9qsk/XQ62WF7WFckPIpRvfF3++tcrrsokon+T1K6A6ojut9ODq/0SHZ4ncY8t67wM32b5VGAEHZwTzJ+8JiR0NJqicZTXFI0VnTprQ8oEAd0litxLuqEgvERvLXkdB28g0aLmLDV8rcWkKxjLgn/B/me9E0Y47G58jlCXOOVyY53NGeEC8iC1yvFhDtGOQtu/upfo4LsNwyo08Stdcmk+AqJmMwDV4XQA07MFBYjpUJ0eUdyy+/nx4QnjstPhmHpX9lXHK/89SHLBEg42/BvNBUkcyEVLl0XaXZQV4VB/Ule1mLwpwqZm9Kgh118ePgBdN7/KH5cEvnqMIdBcriPQQM/TJFQEqu2jSdQJby9S4rQqgTQNjiX0rWMexohysV+VSplAONGT0lfbAC3GqkvvhUhVgKmIs2dh/T7daUuilcV8kvfJAUHtuXRoNZxG+diutFfy+DSvvEpxU45eFNrwc1lU7kW4kNuWQi7JFuWlsE0Qf08FmUGExBjFcgsG4zlEJnEAV2yHu7lYfdUglWiUgYKGJHLSOiBPZzoCs0XVzzI4QFAMDkszA+Iw9Bg3jZcEMvaFQpWgubdwzw3KFhlLBCA/GFJJrVZkTdXMlWtZiXPVtDQG1duahM4x2M2fOkPBpCejh28dJgdDbZrTtqPVs265HwYCXreZla+ffKgLz4veAI03058gDVFzcHilgYBHAAuchkcQXiVoOTk8yYBiM7skjmL2ap2rtWjxwDgmlOkZLJ+XlUt61Lp2IysZGIVG0B/SNYbdwZV8tiFZ7KVskIQiYxj/VhoG5PkDN2GoibIizs0KjBlfv6PDCzSLz2fpZhxo3zGA9oxACLThrBbJzo6FgSfIGD5GNwaSvE+msFkQhM3Q0A
 fG1bYz3s
 yUThZg5DRgWse5Il0cCOkcLQuTyR3s7NJuQrsk3/vB2+FgxlwL27znl50u4R+8Ahecjq9D1Hq0zzsG+mCaOLHYk29uIMFEmztnrLbjBBLYXLv4tWoY9arZ2Oareirp3zj08rRzMfdt3ZO5+BAyndzBQT3NgpJ9miW44+cYr2d0NKz59QQGw5cUoG3BP6ip5mCQT22LXEb8VNETsDfah3aE6OrtOSM7j6fNL/giLAnjgst4mvXxV55+pabGBjz1SUsl+We6A9g0TTF3Bc3Gq8bt30uO0d/J2tnqvsTTOTe3Z7wD2ojsJGMVjSPRlS+0rRaU4nPa163nApdEVHmLB1+NBgCZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 12:56 AM, Sang-Heon Jeon wrote:
> Since commit 93976a20345b ("mm: eliminate further swapops predicates"),
> is_hwpoison_entry() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  include/linux/swapops.h | 9 ---------
>  1 file changed, 9 deletions(-)

Reviewed-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

