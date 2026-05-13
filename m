Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC6CCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2901A6B0005; Tue, 12 May 2026 23:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A1C6B008A; Tue, 12 May 2026 23:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109296B008C; Tue, 12 May 2026 23:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0B0A6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:04:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 976508D323
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:04:20 +0000 (UTC)
X-FDA: 84760903080.03.5D4132B
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A73040003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:04:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q8Yz9AXp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8I89Xpzs5pMAfJvHlBqmzYYu+58ES7p+Uy/1CCiwOo=;
	b=YOHSupi5ok8J1xReksFFBAcyGek+nCEOvZ56xdNhn8A5QsHH4I4KR0QdJH3Dyy7IkjwR/X
	KmeqRkVwOGhMibODjQuXjbabxKCfL/qaodRSfKoYeuXx7TsKJj+lcI9KOO20UseE73YSYN
	yjy029TV6KBeJYpRdKQiPOPi34EHagY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641458; a=rsa-sha256;
	cv=none;
	b=pKjv57GZbcmlNzJOoE8zWI6MUw0s8LH334hPXD1Eh0UZ8Smu1I6lD6NL647wRT4xB4BM7Y
	ZZhZrGWTEZQWVUWmoKxSI6DVBC7ppK1qO4wCSYteMtdG1IMHBGy4h+fibNFv/u0hEfFdZ1
	uQqjcOdOIxn5clBqOJPIo5FgG4Qyec0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q8Yz9AXp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778641454; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Z8I89Xpzs5pMAfJvHlBqmzYYu+58ES7p+Uy/1CCiwOo=;
	b=q8Yz9AXpQJXofcrsr20Jn6pAKg0gh45g/MPL4mTFB7BhKSQrMYWJjn7aH+EAi2YrxWG5v/cOpWoIaY7UVD2SrKlqdjjjb52WaYK8aNnXlkQAvEN1N0Y7foppLRR0BJuJTbARC1JPAAC/a0aVh/33TztdwWWQFEXHx4JrjYYhL9A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2sFRik_1778641452;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2sFRik_1778641452 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 13 May 2026 11:04:13 +0800
Message-ID: <7b8cb44c-a098-4430-a8ef-142fa7a19087@linux.alibaba.com>
Date: Wed, 13 May 2026 11:04:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
To: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn,
 "leitao@debian.org >> Breno Leitao" <leitao@debian.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260512120557.49995-1-ranxiaokai627@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260512120557.49995-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A73040003
X-Stat-Signature: 16ox9q99ctrjbtb3ki5xmqkdqz9mh3qe
X-Rspam-User: 
X-HE-Tag: 1778641457-531923
X-HE-Meta: U2FsdGVkX1+yF983qpme9zK+hMyhp/t09MCqkBLUA/jTcT0fcYa9ez1MJGsc4xOX2+D66YYSikQB7jbdkjT2xOCyUIf6PB+ZERHmU67BtGt6IBaaepwCQp63GISug0NIAloDpS9UnlBFQNDiCK4dN7JzwahU7TuR4CJYDM/7ffi9csI3ns+IIQGJ6JqURNLW+uaLWOUcvQiWMiUnhbKVPOtBM5VoSs8gXsr5fy+w1d/7q+2PRxRJfOzUDQQ83vOc14/PzBWf3AGTpbpsDFUG4ehO/pA65qgJ+23jnlqy1CdWg/TRA68+zVVeGlBCbIUD7PjnfQ1TzjVb+voBfPklVAIJr5L8KyATBcUINAYpDRn1I7xgF8lflIKCt751ACou2JujS65iwiv2Aw5Mm9O4EWCaEHJ7RMNn81xdyaQ5NEy86F6d1oCodAcMTfhr/HxbVkBkumcSshWt1N9PlKUhokSqTHpiyz/F59llroh1/8hc/cirz6BAuJ8q9BasLk72cfq+KuEJGyYachFsFdZKkwcg9Y4LFy+kjLUcT0gM0I+rSsbp10+BAKBXOJbozm0LzSXT2Hrrizo6QlHlhhmKAHEZlgg6DG3sjsLtIgdHNYgNUBVfb9+5QoJ5CXCfiQInu2CJRHqCLFA/LVaRReqxAUQRMyDqJ1TogQyJ6zWuvTfEDoOc5QDnt/xVgffTkbuNiplPD6lAG2EwsVdRJL9BG9SPGkmRHDDwAo8oQm78Tv/EP3BBXBv3Dmzs5i60mjN+zTFJOqK/BXDomvJ6G0zkpQ7Mvlx7ySmAzXiStmoXxJbn4lanQxPPlrMHn3rGQtS1/DDRPrZ+ZG2WLg57e4juZrnH/5tfFjfu81GKhi+yKjqHVrbLPFOEwoLvPjmkX98dN4ZoTpzLBTHoSNVBjp4BQrCtXcrGGsCrHxBCe931qgCnPqaR/YvXREbc9X7ri8VuNULYY264SlYKJL3Uf+q
 Cf9NiaJU
 Hzk6m50WKb2npynKkkoiNgkS/ah2dsLa9wQO3ijkvJwYKSrD7DWOZ7zFmoUUf0q8oDZeh/hmxEf1SFZ7uFBd5Sj0dEgol/srU3xHjlwPRTBgh0rx4kZ8zcPQx3upBejW2tV+DwUu/tg1nEqnTFuHNXv+HzWuuvXnZlgcjPPk2zOkfj9z32bz4ou9rmA7+L9onpY7cDN4Si3TQRLPUqMOmz+aUOrNokc0tDNVljp/sL4ZqHCSnIgY9EMDc6OYQsvsLQPxsoH5FvIOOvEH3VvEAREeLgjC7PF/AbLgelCwtbH6OrJL1T0/+8+vmqfVAPmH8WPMgdR0cJugwVc5R7OT7Mf1m5ScUkQDMv4d7bLGgpFmuJCF+JXSmvjosWIaqM9JNQ4NhHqbkmVY8HW8Mh0rWZBBlwS5tTLIg1rLt1OTEO3xL4SUa7fJQq0Fr+ctQwzFf+ut8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Breno and Lorenzo

On 5/12/26 8:05 PM, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
> 
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---

Thanks for doing this.

>   mm/shmem.c | 88 ++++++++++++++++++++++++++----------------------------
>   1 file changed, 43 insertions(+), 45 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..0cc7872cc576 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>   struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>   static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>   
> +enum huge_shmem_enabled_mode {
> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
> +	HUGE_SHMEM_ENABLED_INHERIT,
> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
> +	HUGE_SHMEM_ENABLED_ADVISE,
> +	HUGE_SHMEM_ENABLED_NEVER,
> +};
> +
> +static const char * const huge_shmem_enabled_mode_strings[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
> +};
> +
> +static unsigned long * const huge_shmem_orders_by_mode[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
> +};
> +
>   static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>   					  struct kobj_attribute *attr, char *buf)
>   {
> @@ -5551,57 +5574,32 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>   					   const char *buf, size_t count)
>   {
>   	int order = to_thpsize(kobj)->order;
> +	int mode, m;
>   	ssize_t ret = count;
> +	int err;
>   
> -	if (sysfs_streq(buf, "always")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_always);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "inherit")) {
> -		/* Do not override huge allocation policy with non-PMD sized mTHP */
> -		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> -			return -EINVAL;
> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> +	if (mode < 0)
> +		return -EINVAL;
>   
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_inherit);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "within_size")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		set_bit(order, &huge_shmem_orders_within_size);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "advise")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		set_bit(order, &huge_shmem_orders_madvise);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else if (sysfs_streq(buf, "never")) {
> -		spin_lock(&huge_shmem_orders_lock);
> -		clear_bit(order, &huge_shmem_orders_always);
> -		clear_bit(order, &huge_shmem_orders_inherit);
> -		clear_bit(order, &huge_shmem_orders_within_size);
> -		clear_bit(order, &huge_shmem_orders_madvise);
> -		spin_unlock(&huge_shmem_orders_lock);
> -	} else {
> -		ret = -EINVAL;
> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> +		return -EINVAL;
> +
> +	spin_lock(&huge_shmem_orders_lock);
> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
> +		if (m == mode)
> +			set_bit(order, huge_shmem_orders_by_mode[m]);
> +		else
> +			clear_bit(order, huge_shmem_orders_by_mode[m]);
>   	}

We are already under the lock, so you can use non-atomic functions like 
commit 82d9ff648c6c does: __test_and_set_bit/__test_and_clear_bit.

> +	spin_unlock(&huge_shmem_orders_lock);
>   
> -	if (ret > 0) {
> -		int err = start_stop_khugepaged();
> +	err = start_stop_khugepaged();
> +	if (err)

Moreover, I think we can follow commit 82d9ff648c6c's approach: if 
nothing changed, we don't need to call start_stop_khugepaged().

