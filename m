Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D70D73086
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 02:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F366B0005; Thu,  2 Apr 2026 22:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C404F6B0089; Thu,  2 Apr 2026 22:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55CC6B008A; Thu,  2 Apr 2026 22:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A463F6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 22:19:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 251E258353
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:19:39 +0000 (UTC)
X-FDA: 84615638478.02.A0AA3F3
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id 98961180006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:19:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jNHl2+Bd;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775182777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzPvSN7isY1kE9cnYb/DLvgcN5NUYAmq/V6b22yv7Q4=;
	b=Zb4PYvoIBzM3d2FQvF6rbnpMhr1Xg/IEQq6vXApYRBOclCgZPdnaurpa80ZlQwzo92BQhT
	vLIRymoBKuHgivhAAqQXBTzxrTP6Rk3TgN8lWjtIhYQk7uCdfu1dzlyXaiCKe3sL1XEh9L
	GNSWVKPjFdMnC2qj11cCHx48VOy6e8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775182777; a=rsa-sha256;
	cv=none;
	b=uRoTlRQuEFPq32b/NuqRlTkXLOARjvFzUbpWzyXYHwOBapbZISRkuOkYCr37QrH6isOLfu
	aWbHmy+pJMVQMtkZ8keAqYK77GwraR2Sej4VAyVpYEwSsdCSIhHxOjfQqlQrJtRv/WoXFu
	MGR+UAHoAxXrPuo6CelJyPuDmmFhprI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jNHl2+Bd;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hzPvSN7isY1kE9cnYb/DLvgcN5NUYAmq/V6b22yv7Q4=;
	b=jNHl2+BdQU0OkIxxaYOCSvztOfahUY+N/DC1EtdCs9TrKzM06bvDffy19mOQO++A7it7lzqAq
	aQaQfxYtJHfrWEaXUPXdQ/aZizUzzSbpvZxl78MLihcV4UrRSUC0IDnCA8f9iZ9RKO8DDkpgSru
	eFO0FWYMD+n8rLXQ//v99mk=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fn2M21cL4zKm4q;
	Fri,  3 Apr 2026 10:13:18 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id EA46A4056A;
	Fri,  3 Apr 2026 10:19:30 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 3 Apr 2026 10:19:30 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 3 Apr 2026 10:19:30 +0800
Subject: Re: [PATCH v1] mm/memory-failure: replace magic number 3 with
 GET_PAGE_MAX_RETRY_NUM
To: wangxuewen <18810879172@163.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, wangxuewen
	<wangxuewen@kylinos.cn>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>
References: <20260402064946.1124250-1-18810879172@163.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b1b37da0-c93a-80a6-d733-d6051b42cbd4@huawei.com>
Date: Fri, 3 Apr 2026 10:19:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260402064946.1124250-1-18810879172@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Stat-Signature: e8xzo8qhfs11pzzqxj3szypz1jgaa8u4
X-Rspamd-Queue-Id: 98961180006
X-Rspam-User: 
X-HE-Tag: 1775182775-392305
X-HE-Meta: U2FsdGVkX19OydNP12Z6pvPiY6HyjebuF0qI3ro0jsaro4DY9pTecqdUtxAunT+Zwgi+d0oBklnhQtxTBprwlonTNI39GvsrhWrffmqbk1cu0hsej1EStTMJdnj+97a+hh5X1YdC3qJ/jA0ZOZgA+nivka+P7Ju8sHOknwwvipKdoxNbgVsKDdUvY79HslhKumtTN4nzuXWFujn7RpgjxHC3+ioymTf/hbw2Uiy3uXuMVd5jYFlkmXTlFqhJOVHW9ZsQTxd3qbo5LRVbGWowxkju2yzN42gqP7eBxzLmobeChEvrm31HVat8lEKSF7397yotqSJ99s7yB1+slaaEoK/nGhgPJMs6Kej8npM2zktH2DBjZrY3TigDGa+nfQvA9XMyu5c8F6f3y9S8H8CzSn7Ls1eWUm2xYAF4Cy6UL42f0sEGwqmU90V+yulawoZu34Grocoh5MqcTSosS3BrLqY3J97xccsP50DGHVjY2L1m4UQLhdaBDTLCa6fYigRO+xvKB/j9ANLQf4YFaGrE08tQicjgJ8wImrhzmqO4MoCIw0cA2lbOD16+EUCxE7f4ug2N9MyYl6jir0FYHV7Rse01yaVw7VTDnD872HS6jopMh6YXhx7Z4rRecxITF4AQQxlc8LoIn8Lc54JxJevCU0N16TlGuSZqdyJS9grLga7ah3IOfgWlWjHACbvCh97gBM2Wls4Ry2MA5WLGB1XcNwUfQ+9Qmp433Tng6PzLBFqCcQFJGK48YcelszeRuzopL54/s2gU/aMKfY9YAJ+9oPAJCHdB54tyV7y4SOARKvY5PB0PYu0Ox99skuX5pju4eeh5Yb0Gm/r7y4A8xIrH2wM9WEZGVJu+r4OMP+lOfbojmaFeoVACNezga9oLxzjhA6UzFCQvf5QeRJNBsb7P4Scx6F7pYThlLlnHrJ3BrNz6YQU/VvBeToiAyQBlp0N0/a+hYuWzchrQmN8ENKQ
 FujVHWG0
 hn7Dx5etvC09n9DZSeWwdjKAja1FIDgAG78kN5t76mNF5OiPzEJQqsIwaP8jTXs6L2UMi9V8TXvULw9Os0kdEarV3qvrV0SCw09J+NySvjDkVzzOcjEdT/84CZSa4i1eMIz/WxiXx/XqntJx7MF8sUuHIFvDiJZn7pEUznVnHIkh9aTp+jHbaph23K3d+iQLmh817lhvm+41L6urHtHOAgXzKVrymcrDTkyUyL1u4GdK7FiCs2rUAKjRIQq0w/9+DrwU+ytQ782ckrpt2N87iV4Vc0EqjwqBTRvhQXoTL2Spx9hMXAM2pLYFVcwzxnhrelEOV4+NjchthEGC3SnqkagZiTnhcJ9RCJ45TONyhDi07B4SyfQbgv0KaKNNw0t4dvG5EepLujP4XSxTqbqEB9fRKCDOH0H/9C3JCQTCygqbEul/Zub1voAb1xEa4pdQMNxC8AII1uKINspQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/2 14:49, wangxuewen wrote:
> From: wangxuewen <wangxuewen@kylinos.cn>
> 
> Replace the hardcoded magic number 3 in get_any_page() with the
> existing GET_PAGE_MAX_RETRY_NUM macro for code consistency and
> maintainability.
> 
> This change has no functional impact, only improves code readability
> and unifies the retry limit configuration.
> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

> ---
>  mm/memory-failure.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..e5a6b1353d9e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1418,7 +1418,7 @@ static int get_any_page(struct page *p, unsigned long flags)
>  			 * We raced with (possibly temporary) unhandlable
>  			 * page, retry.
>  			 */
> -			if (pass++ < 3) {
> +			if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
>  				shake_page(p);
>  				goto try_again;
>  			}
> 


