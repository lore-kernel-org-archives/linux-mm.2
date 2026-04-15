Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56071F9D0CE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C90D6B0092; Tue, 14 Apr 2026 23:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A626B0093; Tue, 14 Apr 2026 23:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FE56B0095; Tue, 14 Apr 2026 23:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5710E6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:16:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04ED114031B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:16:30 +0000 (UTC)
X-FDA: 84659327382.06.265F4D9
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1337B180004
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:16:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KY437Mun;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776222989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INOKKU/DUYfCs/lHfTk6eEwVUS5M/lRl2T8/ng8E9CM=;
	b=VZ8Xk0A4AA3VDarP9fKBRbqG3ER3bywpob06TKRMXEIqK+pWsO4Xj37QOQHeTU/Y4EcjiC
	Zr3Ot6m2F/SPE5CEgHyqE0UR/oR+7nt7zY9aYtEE1MesvA+RQ9vnrGNOR5FRX+Do5FQITv
	IqwAsfHq0PKHplUfVjdv9/5Ig8ohaH0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KY437Mun;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776222989; a=rsa-sha256;
	cv=none;
	b=EWhwt+0CLu1gtwMkq5ufSumlfoAmQOM4+62+5PXaZprw7alG+uQliRL8S+YP+D65SYuiqf
	fwSGgUlwgIBqGULUCZy5Z8VVGQXzGl+o31avI5UFuLMNRLeQ0ZCzaU5xY4cXh4IuZ5aZOy
	P2xNlwtRtm4BacPvA051IIL8lTOqP1U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776222981; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=INOKKU/DUYfCs/lHfTk6eEwVUS5M/lRl2T8/ng8E9CM=;
	b=KY437Mun3O4QuXVWlEs4M8Emqml8F0VkSiApHsNzIT6xmAd9t+50mpIRPrWnPWyIHJJ3al/7d8IpdvNGgK5jdA4v2eaIHFZwgSJPbOxNKQMNuZvWZyBkY1teeJzINvywkuMDAdGNbLxX+wtj7b4FfuthnSAsv0111rFQ+BH//kg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X138wtU_1776222980;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X138wtU_1776222980 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 11:16:21 +0800
Message-ID: <a6114618-4bd0-4459-9c53-450ceeaa3711@linux.alibaba.com>
Date: Wed, 15 Apr 2026 11:16:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/14] mm/mglru: scan and count the exact number of
 folios
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413-mglru-reclaim-v5-5-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1337B180004
X-Stat-Signature: afqfwwwc9ud7b5iy8z5duhbpg554q1o9
X-Rspamd-Server: rspam06
X-HE-Tag: 1776222987-972736
X-HE-Meta: U2FsdGVkX19sn2gUYto84iPExI/td58ffVbywtJlwMNPPigcRhe3qJ2alMUm0+25m0pMb7oEbOMF0Wk33aIgnBYgh2dDl/QdlCamWcTSZQ08LDmvJWUGALY1PiuF9R1B2tGVYlt+v2xQjP+dPxsDM2D0juKpd2s23QREU/Eix++JsaBImecJ04qV4vwlVWyz+KwtsS5aBL71SglQY2bOxSy70oXyDQNRAWcVKsXM1p8vtBHdtJprF68JFwPk+H3e/KyVUiEYXkBYwB0ixi1pIOoSM5NGWi+zXRV8p7fQOazGAzlHVCPx3GL7O7RDk38xk9InNwf7zg+TkdB9rhoMNqPhfRJQOuZqDs231NFUIUDtdnmtqa3ST41ga1SyblgbeNaJTpaAo822OiHubr5iPz3uxL8pbuYf7ihi/e+Tita8pRMngWQL1bZ/EUKmRB6AAZbbx5fxbLSfv8lJ2YIlfZJlInqx6SF1Tl7iWUczrKB/HfHmAy7/LGH2jC3WQLr1mKA5n/9jDjMI6wopaniORfzXc8GZMH3NWriDvw/jhDN0Z8P82d6Pg0hn5a8foqDwpZD82kLHED11VJa4lp2+fcw0G9HFsIcU3gs7IAOvq/rSDN897piEeNswmFzlct4HZX/V3rkpdj7l9MddUI0AzKTBW1V415pMfqfCQqwQlXzSc7juPu5qJXPdF02Ck9eRIXNLneupxf5FFlogIdNV7Nyya5UDltrFE1RiPoPGZI1HAfxoJ3L/VcP/kwsnkENhln9EbUqTPfgxo/0OW2geUaQySrRwJUuL0hYStrO7cxOYb/F3omse1oIffwKL1yqxVYeO4Qh1CbxgE4wsSnvlZQvuig+/rRjdQGIF3llR28Su7CLqh0kIVK3NUbgOdJiTqi3aFU7oFVYRF3K9pYg1Mq7MzXGLsXDILtQU+hggbJDqA+eZxIAkDmnSdObez+JEe+Cyxf5ens9q+xIVnn7
 87gQgO1r
 z+EtcUkD9iiUKRGFK2A2HRSwsh94tcTypU9I3JolIhQ8/tE4PIhaLDL7Y6Yq2Ashi9zLImuuYrFDzbEstsVDxXFCYpUVNFn7iVBYmixfvhV24VzdOpspuQUIEoqJ6NyJ0bnCplnvMAUe3FYQr2MqkmJnt3iQ5WXexp+c7vVxljwDlE4BtufYUwbylCuTgnlXxdHK6WBjD+TFmNFVKcCZtsBWyvb4zGx2L7GwbBhg8fH6YsKVcslKlJUvGePFkITxMyrzLcwbpDuBFQc6jwDcVMwA1pMxZ0h1ICelvceTNmzYQaJb6IGkOV4NUdOHaOZwmeOeSbttfmDLmZEBu2VNtAiMu+uOX6r9c5Es4kDwAAUVjGH+8QrwL0OLdQ7jjqVjoDXKZ+Pz6cP4EHoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/26 12:48 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Make the scan helpers return the exact number of folios being scanned
> or isolated. Since the reclaim loop now has a natural scan budget that
> controls the scan progress, returning the scan number and consume the
> budget should make the scan more accurate and easier to follow.
> 
> The number of scanned folios for each iteration is always positive and
> larger than 0, unless the reclaim must stop for a forced aging, so
> there is no more need for any special handling when there is no
> progress made:
> 
> - `return isolated || !remaining ? scanned : 0` in scan_folios: both
>    the function and the call now just return the exact scan count,
>    combined with the scan budget introduced in the previous commit to
>    avoid livelock or under scan.
> 
> - `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
>    scan count was kind of confusing and no longer needed to, as scan
>    number should never be zero as long as there are still evictable
>    gens. We may encounter a empty old gen that return 0 scan count,
>    to avoid that, do a try_to_inc_min_seq before isolation which
>    have slight to none overhead in most cases.
> 
> - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
>    the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
>    naturally returns 0 when only two gens remain and breaks the loop.
> 
> Also change try_to_inc_min_seq to return void, as its return value is
> no longer used by any caller. Move the call before isolate_folios so
> that any empty gens created by external folio freeing are flushed, and
> add another call after isolate_folios to also flush empty gens that
> isolation itself may create.

As I mentioned earlier, the try_to_inc_min_seq() changes here indeed 
fall outside the scope of "Make the scan helpers return the exact number 
of folios being scanned or isolated." However, the changes still make 
sense to me. Anyway, I don't have a strong opinion on this (there's no 
need for another iteration), so:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

