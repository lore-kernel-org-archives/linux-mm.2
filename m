Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10CC4CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A9F6B0005; Wed, 10 Jun 2026 20:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C1E6B0088; Wed, 10 Jun 2026 20:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361A56B0093; Wed, 10 Jun 2026 20:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 243866B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:47:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3C811A0354
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:47:21 +0000 (UTC)
X-FDA: 84865793082.13.06B9F6A
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4D0A520003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:47:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RC9HIQLB;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781138840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWG6oMmx5zN0/AB1q4LhDBi8DHE0zakSdImy7TPdrFM=;
	b=rBjPyRg7/qhRz+t/Jhh5htvu8H55pMwXu9lxUO6OkZ/9cuI3K5oxq77nM/Uoyvb/3v4aEa
	Dcv91c2rfNqppJe/Q8Mu0SlTiXts9owyRsgMQeR+VWtTuor0b5lB3DOCIbY0jJwCYJ34Yo
	1SEV1BRVO4fL70+3oJnTTa1Kk+eCLmU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RC9HIQLB;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781138840;
	b=38YW1tIG904pMb7MEeArl/yyXEmNdiBAKhhgsrAZdUE6dXZtEg2Vgk7PCpUNKkZuvLUhuu
	WUMcW13jE8E8jK2a27CuzwutU/2Grcq0KNqBKi9VW1HBYa8Xg293vEDJQVos1X5kzRO6v6
	ehtiVQ7Is8S7UpJ5YEExZRa1LV3faOw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781138836; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TWG6oMmx5zN0/AB1q4LhDBi8DHE0zakSdImy7TPdrFM=;
	b=RC9HIQLBvhSRTxRoOgZyu1ei3PipEzKVGJD6vzKovNmWtNJ17ppjvzFjVhpETseUPVXt/ncVla9qd+iu6aWIZZnLK090gqdhx+cmowkN6GL7QR1Ka7qXBfWMs0yZQ91AJDsfYwSZ4xPcIRVQwcyCYCkZnsQ1FpqWxZl7br70xgY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4boTcb_1781138834;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4boTcb_1781138834 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 08:47:15 +0800
Message-ID: <00bdc0e2-8ce7-4bda-aca3-c22df55b4979@linux.alibaba.com>
Date: Thu, 11 Jun 2026 08:47:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 06/11] mm: khugepaged: allow khugepaged to check
 all shmem mTHP-sized orders
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <b4d0c1a5a49284b1f0afb0810e056f6d88b17d30.1781083630.git.baolin.wang@linux.alibaba.com>
 <20260610113352.25352-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260610113352.25352-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D0A520003
X-Stat-Signature: 59p7n5uhx9mtnngbepfyohhupuu7ezwt
X-Rspam-User: 
X-HE-Tag: 1781138838-610151
X-HE-Meta: U2FsdGVkX1+oASdT4YLv8EpPp/MK0S7bNBZk3rs+i18by+kl/HHgHV6RjVq2wdMHSDngSueWq5ExWmA5yet0KKIA1N3fmkIytxKSbgX0EgU8qrBF+lgwOkPFSCP/qivctueXLhMD5w9rAnnxqByBW3F+yPpXoQDy0D+cghkR75jNvqlGqlS+I+mp7eTm5cgYkl0ioiWu1rUVZy4eSkRqrMP/TkVsbUBjqpvFjN96nGkb4Rotn7hOiu2IbvyaJnItJMdbpildJ6gBYPwgicdIiZonQ/tv+tT2537JEFeQNvFFhs8vpwiMKSbAtKk2x6nlBOeYPTlunCfEmAthee1AB4hmt4XUYG0flVem0GywIxUA4VTAGH+zo2VjCbOQh/iosqVYXc7muhh3BsvIpFi5ce2dKW+77B84PjloR7PR2joeSbibvKr8WuYXKbtPc+nfBiWbibhMBuVSPjcBXt3is6HhWV0vHec3m5xlndppi9UT/Jiw90KRMCDcDy/r4XhiH2ufVZwpHyWJ1mYQXOdFs2s7RqLZZwGxdk/FKGJLzl5CAPiH9/1DvddQ1wOh9Z2VydsM9qMf7ADA4hj9ZbNAoCfWhFUlvg1dGYDjaO4Y3iD6Bxnn/t/nvBjzlLLhUJO9k3dzdK4QbsUx1OSynL/0UnzVtPi9A6z1nLm+VCUpobGz0eerNrDEw6HRcg6aW8xxIvK1zOOx3iqP/Zrtgp0yxB6Frz7iTpgG1HDMgJuanH10VfbT7prcbv9cYp5jxvvMctu+/kJfidFUezvxGy33jkdnGUmXn4FIH9+EDHA4mRl8JSt1oArm9rSlDU9JxEpwkIW1/P/dpflynQg5jUQ4OQzwKJ7YsmkKbGFUO334a2lJJLzQRMY7espb0x2R1zD9ynEfOPDwyCWhlM7ac2lB8VybmsAE41oFnJgkGYUGkrnM6WWd1UISY0xwQxOaB2AlQBz+bEJLglbPeryUw7E
 Fw0FfUA3
 VBzBvfppLZMb+xezEYBVNRvDjabCcvZ50O1faNuN3LKbqDD1RZt0BGy2B1Er/jimxgT0LVv51CTyvpJtkOkz2ZbrO3tTeo/BfOH3aAiDxOJfpjONGRiWwR6lL4iEejgCO1BUmj/VtMpRCoTn+/ReeuIBnjzXkBd7XAj6gqy2GMWd/13mFK7uzcyapFO+biVsiztVzp2zbZosprILHUygrK0BadP7i2NExj79i0Rn2ka05PV68FhcDGAyk1b3jixPS/fzXrs3iL+DfLn6/m5gW93HBdgeOW85WjBS5RUHgfaqLPzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 7:33 PM, Lance Yang wrote:
> 
> On Wed, Jun 10, 2026 at 06:29:14PM +0800, Baolin Wang wrote:
>> We are now ready to enable shmem mTHP collapse, allowing
>> thp_vma_allowable_orders() to check all permissible shmem large orders.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> mm/khugepaged.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 75b18ec4a6c3..a87918b7e18c 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -578,9 +578,14 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
>> {
>> 	unsigned long orders;
>>
>> -	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
>> +	/*
>> +	 * If khugepaged is scanning an anonymous or shmem vma,
>> +	 * allow mTHP collapse.
>> +	 */
>> 	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
>> 		orders = THP_ORDERS_ALL_ANON;
>> +	else if ((tva_flags == TVA_KHUGEPAGED) && vma_is_shmem(vma))
>> +		orders = THP_ORDERS_ALL_FILE_DEFAULT;
> 
> Hmm... for shmem, is the lower bound in mthp_collapse() expected?
> 
> #define KHUGEPAGED_MIN_MTHP_ORDER	2
> 
> #define THP_ORDERS_ALL_FILE_DEFAULT	\
> 	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))
> 
> KHUGEPAGED_MIN_MTHP_ORDER is 2, which was introduced for anon collapse.
> For shmem, though, we're feeding mthp_collapse() orders from
> THP_ORDERS_ALL_FILE_DEFAULT, and that only filter out order-0 ...
> 
> 		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
> 			(enabled_orders & GENMASK(order - 1, 0))) {
> 			order--;
> 			continue;
> 		}
> 
> So order-1 never gets a chance. The walker stops at order-2 and never
> tries it, right?

Good suggestion. Originally, Nico used chunks (one chunk representing 
the KHUGEPAGED_MIN_MTHP_ORDER range) to record the bitmap, which was 
inconvenient for shmem to extend to order 1 collapse. Now that the 
bitmap has been extended to MAX_PTRS_PER_PTE, that earlier limitation no 
longer exists. I'll fix this.

Thanks for taking a look.

