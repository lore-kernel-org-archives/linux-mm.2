Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC6FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1006B00A1; Thu,  3 Sep 2026 06:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C99B6B00A6; Thu,  3 Sep 2026 06:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808666B00AB; Thu,  3 Sep 2026 06:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C48A6B00A1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:14:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9412404AA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:14:49 +0000 (UTC)
X-FDA: 85172042298.10.62789CB
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18D6C1A0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:14:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJRoVl6v;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788430488;
	b=Y0+AeVBaa7dVuaqt4Rv1MGGtuWqypbee1bCyuMktd1nIogoKwTaz3T+IqhD9Bx99VRr26c
	oTlLtaNMRxiJzadMeO2u+AxbGMiIG4XiKhULyj1h/m1WGlGSiiKFvyBk5JCb46E2G/UKEe
	fIWFaxbQNMDa3a1DffGodEyhOVajACU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rJRoVl6v;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788430488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3owqBbLN7wIxWV8uRXxeYJQqapN2luye/1oTJ5GGsA=;
	b=6u91rnTIkENAQZ7xS9Kkp5ahRbZ8e9ljpcMeOZZffynaTISYairX2F7EeWFXUtUyDUZb7F
	GVhufncep86HRKRsodyvcsCMWup1Xirn41jPVa3OSoAyLy88nP78SyFb7MzzPzSemPcPZ2
	Rpw666oFGVEEthx4NDM1xK4b/1t0msI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788430484; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x3owqBbLN7wIxWV8uRXxeYJQqapN2luye/1oTJ5GGsA=;
	b=rJRoVl6vDQlQ9nS1Y7+pMkJs/p3e0lLpXmk4uNWDuWr6rKtxntcdFRWE4pG23uMEKnM+mcLLxfhlCCWeCattsS+FIgJ9JWQVoCFV+jm/XZh1udlEONczbOkyAs5oTWijgc5o2sxRx5BqM1AARAD0/VjqmZBibglAfueQmEbIpKs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XAFoMgi_1788430482;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAFoMgi_1788430482 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:14:43 +0800
Message-ID: <818ebe42-c53e-490c-a18e-955cc85a0597@linux.alibaba.com>
Date: Thu, 3 Sep 2026 18:14:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] mm/mglru: make LRU folio prefetch helper an inline
 function
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-6-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-6-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18D6C1A0007
X-Stat-Signature: k5x3qszf7yq3eprx85hsu7bm197r3gn1
X-HE-Tag: 1788430486-308080
X-HE-Meta: U2FsdGVkX19TlKshQocBgA5d5Od9b+QTQdPeMVCXjCc7HcdTCiJKCbGlk8l1O0/b97+1FUAUNb0N8zp7O2zJQedKCx0xMl0UiijfrkpMIRNxZh8yQ3BKgWtOE/keu4xw+BLPmATY6hgTffzy204oX+WcjLMR3K+iERZTeTmCGbjSmGA2XsX2BIV2WZWUMTcE2yKaOOfG0NUXDfdiBn49z0H23dCL/hbLY4SytHM78GxXiqck1zBgTtPm+5ElbUlaoUS6ACCJDeTlLcllAgBt625HrjD6cny/hkxkjORbbAIAoBbHTb9oiUTh1m72WogPvxRqJeke4yv2HMe7b8UIBQ6+qD2NiG/TUNvrhG6Yxjp+eD8BbdMsAbD3Z52R/KSpTJnLAOQjZwMuutM7p/PBJM9IWIDz4EwK2uh2IJUDqMknpRriCZ2NzXR4eEO1pT4zfLcFxbiC+DxFTtK6Z6eRNa0UxUB+/uUzm1GNxoAsbChQnh5v+ztwWekOfiwTCh2EsmN2EYM/9vR2qD7I4XXRztrgXzdh0goABwIiTIn8AFwkpmqSyaH0zI77gDrxsvZfyESbEt6nh3tAdCSq4bx/LJCQ0aUIN/WTukRBSDiDSkE6vCYahtjEJ8TSIeSoj7eMZToL/yJRxQCvNPphqWegQBKkoWIyjBgv7qN+vf1J7JYuyCrVDScSjPvt5BgLdDvRK2JFgUr3u5ctiOP15oQ5shymKNJArQ/C7sj4KWc7W5Oko/LU6K771aUFNlSg55qF+4XpctSjYpQZ/xUFao/D9Ax5Jk7GILT3i5qOdzrDLaf/6vf3wOCDHQC/6PylgypRG77uk7rh2Ig/iyEq7wJxyXQkaVPfOFcn5gS69HvxqqXHlmk1pWEjNYuk9gD50o7Q7Q9GGsqDg2AX11Mk4OGuowYZkC/FDv6YQxIY6xaXJzC9P6b5LglK5TxL+sxSqkfhyIlMuAZUMf8MX7Frw5x
 EQr0cw6e
 gqW522vVeHOnZye7Csdl3Ndsob8J29lwyh52xnh6MBHRziIAh8OziXZ6VDm/HH/Zf6YrGn5xQF764qslMn7gD8PIEWgE5o2ZJEeGXgYmzh9j/DdSHduAlm0xd1p5L51jMSBKaLbQUrYTgZAtiI9/xK8ld2w5gmjni46y/N/67s+gnJOLkyvXKaCqD6sfPhJQFF/DEgX3UqtQQ3x4iOfuvyDjwJtpylcKQz3HFxnhmlRXQzk5uCmEIO+V5GD7MnzXAC15x6LDAGBYPtZAaVt1KTRXz3qJ9UrgXLqAtpaQEf3qSZDJTGWtYseQF9bBg0nAJ2ovrEB+JsXhENXqrfnhuoiKR5h4vjPOxhiUKx21vUkMaIB/fKVnLkCIL1OgjicJVXzpP+AAMhZoRGN7icgokYvyLrP3GLpnt1Bc79hxTqoxDp7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> `prefetchw_prev_lru_folio()` is currently implemented as a macro with a
> potentially unused argument. This makes the helper harder to read and can
> also trigger checkpatch warnings about unused macro arguments.
> 
> Make it a `static inline` function and remove the unnecessary `_field`
> argument. The helper always prefetches the previous folio's `flags`, so
> there is no need to make the field configurable.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

