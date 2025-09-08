Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20216CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 03:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595078E0009; Sun,  7 Sep 2025 23:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E838E0001; Sun,  7 Sep 2025 23:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D1B8E0009; Sun,  7 Sep 2025 23:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28A3E8E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 23:42:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76AE813BEFE
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:42:04 +0000 (UTC)
X-FDA: 83864684568.10.B02E99C
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0691720005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:42:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FxSao6EC;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757302922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p59BzXNdtsBBH4YiiOWeXAEJSDW7oZS3ScEZ3ZTPVpk=;
	b=OEeQFaUQ9mCwqIoKizB7y1CBUIMPTyf/FXbHD6waxLTF2qgwl1JpHyo4lJ4hoz2vHld9nJ
	HGKkoDvQwxtwWh/4ZEyBSvEIj2kcjvu9WuZqroFzs0fOnkVBvcUyyvahKJa5PU4rro1TLV
	UUkRD9I+1RgHAUz8a6zYfPumdDJQZnQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FxSao6EC;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757302922; a=rsa-sha256;
	cv=none;
	b=Pi31ezqb/PocB/JUgt3YWMGPFEFnhpt6omjA1si9tNHfIA0zLwIpaVOeUCfyXNO84FOxkl
	rGnUmdvOzYh+kpwQJWAjfkYKQHt0B1rnMLmndO2Qup7g2gWGMkRoLH2owEkZQ277aggcOi
	mAo5thHq09Qj5ERkUcyMg0D0fZzLlOI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757302917; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p59BzXNdtsBBH4YiiOWeXAEJSDW7oZS3ScEZ3ZTPVpk=;
	b=FxSao6ECRjGebVd0LcDlAQkpYfYsWvIRjufLGpXoid8idpu9CB4EGXmItZYs2VPxY1vGsYYie7DcdlR1ZLxRmpWclojzGFcuLuqn4cVMrdnth/7dTfhp0MLilFgXKQ1CBpDjIefPbmEbtYIcgQ0Uycel8CWKF2d33//AXjyrMFw=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnQj7q5_1757302916 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 11:41:56 +0800
Message-ID: <f8051ae4-1b9d-42dc-8272-24a05741d86e@linux.alibaba.com>
Date: Mon, 8 Sep 2025 11:41:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a
 helper
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-11-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250905191357.78298-11-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mpur9hbmf4b7ewt8hwatfo14hw6w83b6
X-Rspam-User: 
X-Rspamd-Queue-Id: 0691720005
X-Rspamd-Server: rspam05
X-HE-Tag: 1757302920-217044
X-HE-Meta: U2FsdGVkX19OthFdvqjeJ3syIc71hzMpOYbaQqUUCC5yS9lg+QtREL33jYkSLlN4sU8QuevUf9xF4g8LbMCc4LP8AOn7DJtqGEm2ewmks953XVAuTtzG0aZdEPJmKdyUoqs3qTE1TdOGMCWuWUFoK5bb+ATo6aB5LlBmeVj5g2i/JuYuZsCk7xvvZ0qh+tAXMQpz2fRYDxh2DQlJDbGVBbTZrdCObpLaDChNC2cggecTCqBTzA6z8fCIxwo8RbBwZvI8HlR7PnXtaQyq1bKQsvGBrbeEzPP9qXQ1jYD6dfrLICd8BFxUp3IWaXkiXmarDhGiNK76wExIEFSJgS0NazyulkPhYX9/5Fh0nTpZYKHgeZ58XbOjYW6qCQcJpLfV+9HFYX8nml4ogiZcSyIHRlu1c9+3UINBfkP7xCIVggq2LddUF1ItHK2Kvl2u9nOcKVAIFF1LaqAj7AC7Vae13fP3nCq258rcaer8SFZxK0pvtsX2mf0OpJW8Df1e+co5FCvqw7u8zNvTtqo4fNg533au5ZxCIpOfyEGhCtKl6DYRbUsLkr71j87dLnyoiNjvE25hmnp2s4yLVNz6YYV3IDHPDXHHeY6cCVp5BVL9DNKH5cdL2mHln0HVoVZSqVi4/HTBrZYt80ICfaUEIA8b1hBEHC+ZQal7vwS6gy+4vCHIoZxw1aSAiQjSDDON7MrELAi4CWCDn4rNlYi3Hm6jbTk/hGUJxvUMkwyL1zh1sBOrLkEBAusyC7HWYouBVogrFq4VziUkCY9mis4GHnvuFPJquecgcLF2d24ylRFM9viF9xpWcLsjYtx56kM4XuhE5X71V1FFpOzRzC/G8G9I1cVfsismCuad58yzaz0WSiCQOrVDSQm9ETfzJhg2rqNFrU7vzx4lVpjSBbT8u0ZfpJ9Bz+UYNPbi3WjVMLiOkjl6MsW001dpi+ExU1HHNL0Wn+tRSlPlMsZUCe+KtV2
 tcv4xTQ0
 Wts00PX3KNd2McvqIcS98sDTeurmeRAaddjXyoUgTQgOee7NTr3MPVPldlhPaQS1cjt61D+zlRGDfZrjxmupLuyAb4QLr0/QWfF1Kh2oE1RFjkPuipBaPmXlwhmbf0+6jGQS3m3+Lrz4JieBkn3Y1/0WbR2tgZSqVyN03Py2ZDOd0qVgP3l1Ch0f9MGdaorTb/YopDohiN5XydDdfcV6Eoy98GBra/HHQ2c5z7YF1AHIw4gLE/7nCRx4vAqVpGzl29JMFHmwPkR5iyMJWuRsHsofP2NPAcROrnMc5+RnYDWzATjtB18WxfOyCSuZUeuoP9LIlzN8MoxIH6QZb4kKB0+Sniw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/6 03:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> There are currently three swap cache users that are trying to replace an
> existing folio with a new one: huge memory splitting, migration, and
> shmem replacement. What they are doing is quite similar.
> 
> Introduce a common helper for this. In later commits, they can be easily
> switched to use the swap table by updating this helper.
> 
> The newly added helper also makes the swap cache API better defined, and
> debugging is easier.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/huge_memory.c |  5 ++---
>   mm/migrate.c     | 11 +++--------
>   mm/shmem.c       | 10 ++--------
>   mm/swap.h        |  3 +++
>   mm/swap_state.c  | 32 ++++++++++++++++++++++++++++++++
>   5 files changed, 42 insertions(+), 19 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd7418..a4d192c8d794 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3798,9 +3798,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   			 * NOTE: shmem in swap cache is not supported yet.
>   			 */
>   			if (swap_cache) {
> -				__xa_store(&swap_cache->i_pages,
> -					   swap_cache_index(new_folio->swap),
> -					   new_folio, 0);
> +				__swap_cache_replace_folio(swap_cache, new_folio->swap,
> +							   folio, new_folio);
>   				continue;
>   			}

IIUC, it doesn't seem like a simple function replacement here. It 
appears that the original code has a bug: if the 'new_folio' is a large 
folio after split, we need to iterate over each swap entry of the large 
swapcache folio and then restore the new 'new_folio'.

