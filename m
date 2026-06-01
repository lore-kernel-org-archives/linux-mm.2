Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0318CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7756B0357; Mon,  1 Jun 2026 08:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAB06B0359; Mon,  1 Jun 2026 08:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFF96B035A; Mon,  1 Jun 2026 08:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE60F6B0357
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:08:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F5E11203C5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:08:20 +0000 (UTC)
X-FDA: 84831221160.25.1190F83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF97880003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:08:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lpqujfv9;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=An/wDA8AsCdCUiXymnOuMQg1DT4aFsF1KD9SR/aaq1E=;
	b=4yCxnc3RY05et3YFcyGE2GIhKOVyEVI+kq4fqPi+75hL+mAYfrD/ReZCc84774dLLjhe0e
	Ff/ICVBG8psY/2WFehJQc/SG+u8LjV/bIesnJbFx2LgVssCiOltpjsiU4GIc0WVKgoIZr/
	WPOQAVDJLpwJY15OJMbWDs+t18DZZ28=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lpqujfv9;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315698; a=rsa-sha256;
	cv=none;
	b=Kw2fQ3oR0el80DVX9rgq3zYvViKk+nY7IydWXoJx+rLBnI16pI+p2XEGM86UTkdVauqPLr
	x46uTTvmgzwGVV/WfItkJZanem0bhOkRxdQny6Ku2XFzu8w9/dr8XcOo/HArEc97sBg8ko
	M7UA5B5YANhVpSmtOfPvfZaJEop/hl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF3C543879;
	Mon,  1 Jun 2026 12:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B13B1F00893;
	Mon,  1 Jun 2026 12:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315697;
	bh=An/wDA8AsCdCUiXymnOuMQg1DT4aFsF1KD9SR/aaq1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Lpqujfv9f3T9AQKyLt9RBY9mZ7AE5lBPl2h6PvVSgWXNemWyWxMfxI6Ua7Bc7Abci
	 Pg8EkYrYz4RUDLLk29Aov3cpx9R2c1Km/diKQQy1dFv1aoshGOna3uH/GaJYlAPG4I
	 lMaavQ+UZrTvUXkmqtpbi6Hzmm5clattk7BWGWNxglf6q/MVtSlacQMEdAsTNXQyuX
	 iFAtRwnfnLw2HdFFHfi6nEdjvoIbuXByiXWCcRt7XxLa1Hsxv+26cE9t4WK0zK7PnC
	 ovl6LcROI4mrYWuhrgsZnYdPTPzcenTEnYyrAd1zfjhW48civNtSvFgwVKKodnNJ7y
	 zVy/gZeTwmC1Q==
Message-ID: <951ee4b7-3fe6-4b41-ae5c-8babeeab38b4@kernel.org>
Date: Mon, 1 Jun 2026 14:08:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: delete stale comment about cachelines
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Christoph Lameter <cl@gentwo.org>, Johannes Weiner <hannes@cmpxchg.org>
References: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p6d6ckohy4xo34p6eumhq8fcmruksfpw
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF97880003
X-HE-Tag: 1780315698-557625
X-HE-Meta: U2FsdGVkX19ltwy758O9LimOadbXNY8gMwtR9X6zfZLK1iwG+hKezXrZmXAJIIihUkursRHldnj5Cxnqk1i8yYcoodxxjoYDGg/I/nVclRLZdAUEyqS9uhQKMYvVnCTKCRAiY6vpUnXthJ+FapoKNkb/EN3wsLZPdWyKRlJd8a2FpqHZE1aJsGSWa4Z9Yh+v78WF97yRNTWHjFnAX7RxH9egO0Ikoswe5Z8ADnwCdDgH4Zqh2A2Dh9lHH7RRmMgTyISyEGih4ooDPnZD84NOeG3hGHQDhoQyfgNgyWA4hOweAzuMTKm8r7iNax/m8Cb90fEbDCpfCKXSYrNhkTAx/CPvR/dMUQCl0/lIdXDEQmNQKGf/k8NRFxt4Wanq9LAYVtK+MLMyLAyRO1hbJK5V0xSFeCI95GLnOH7O+wH4Hr+N26/yQ9l1Z770vlHQh8qlgt7HRNF3Ry3mPFPv9EvC9oT3uU09hfI7Gkj/b+EkfF7Ivxo7SQTdqGRM2vTT6jOS/XcjBoAyZVP1EKWdejbD0bWfT3E7QCbS7rVDTWMDR6RPdMDX6Hdb8cXp99+LwpTQYwphiZlVS2d1Ukgafjl0svKL+wOOow7q5+juVPluXc26+F0UAcQ3u+orjSZhjH3/FTHB0DONvj0y3OZc510JPceTUfoHaNB2DCIGibUotf1p8pSZKl3UV+TilAqhrS30zpPN8WZljHPWw9jk/ZpYi2ZXReL53KTgcKz1sTjWQiJgtHtOwOHL49iFWD7u7d6L+2b00u591inCGAYsrIhN0TL8dySJg1S8oQnDea8Kp7to0YYNU7+B84qqS4vbgpB55V8sPRbctK3OLQpMq4XjV9sA6wtKrf2oJ3+1OpelVCw+PMY6+KP3eNQLDbB0qTw27akgmCYX8Rp3Wzmu8HyESHxLi+bIKyGNHacrcKq/oxtRmhZNXYBxvuF2XqEibd6dS9twtpRE3IfZnpD5J9H
 JarMVdp2
 4/s10ftm/JZVfroR/1zVrIZgzm1YqPBi5wp+CpPQ0CXnWaQYm9N6ZjGS4RDL0Xnjrx/u7Sywux0ycNqQMIjqLd6ZuoCqRbDQfAfaLPDcFJnEqUILa3sP10KZJytO26sFHvhM9s4pBYJ5iWPAP18nLeTUNSOR0QopqiciqeDNEQculz0qi2CzFmurXYfwaK6HeA2S8AuiTPcF1Rc34nfIuykhstWPat1qsw9+e7d5hNdPwvAkVcknK0K2yqH68ZdViS3Y8xADl0+EJbkB+3+z99DIlFuBiaW4H4413
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 13:40, Brendan Jackman wrote:
> These comments have been wrong since commit a211c6550efc ("mm:
> page_alloc: defrag_mode kswapd/kcompactd watermarks") added
> NR_FREE_PAGES_BLOCKS. Since nobody has complained about it in the last
> year, it seems unlikely these comments were particularly useful anyway,
> so delete them.

Agreed, let's just drop them.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

