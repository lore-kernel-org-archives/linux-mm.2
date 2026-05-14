Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E828DCD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F5266B008C; Wed, 13 May 2026 22:36:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD416B0092; Wed, 13 May 2026 22:36:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3696B0093; Wed, 13 May 2026 22:36:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4024B6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:36:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D94101606E3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:36:45 +0000 (UTC)
X-FDA: 84764462370.22.734CAF0
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf13.hostedemail.com (Postfix) with ESMTP id DAC9E2000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:36:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gxlizb8e;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pZEled4JvLYVk4shjV5jBHeZWtGWhhaTA9+4lMRxCg=;
	b=kH4q1d7W4iu5aym+N2l1kADKuclFRmKllYyiI5il7ORge++oJrWyqvvV6msNCCdo8UXDkj
	uD5PvpOMw/t9zXo96JnJzI7ATArKcaud2cfRBHef0HB7RjJZ2PFfwX2LaHCJf5A8KpbQ7r
	pWAOC7HRizE3zDLRadPdv/6C3n7Io/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726204; a=rsa-sha256;
	cv=none;
	b=xrlra5BeW7GPMv3dvKdTNDBQmY1mjsqFDrX969c/nx6kM5o0se3Yd8ZnpuTZ75+tcr9jlp
	Gm91qUngF9xRUmYliO8UmZA2HDTBicpuu7ZOP8evj+hAHN/nbtE8EJpBoE8JBLK/xfe/7E
	s3ZiVNrxRYRRWmsWn/i4hV5auoimRwY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gxlizb8e;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778726198; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9pZEled4JvLYVk4shjV5jBHeZWtGWhhaTA9+4lMRxCg=;
	b=gxlizb8eUAKlKWqwOQRQTrvR2725Y3K+9eccp8x+qseva9jRde9g1modwru/q6Oyf0QDz6g5JnzU4qBaqooRsCthNsUjSEif6cW/ZbXZweVcTdB3AirnaUsLzjplR8nHqEDq/io8gMtZDy5t0yLfpukuxumBAQxUg838fKLVrgY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X2vK2P5_1778726195;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X2vK2P5_1778726195 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 10:36:35 +0800
Message-ID: <6d6b1949-fb11-4b05-a01a-9427019b3ae0@linux.alibaba.com>
Date: Thu, 14 May 2026 10:36:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
To: ranxiaokai627@163.com, hughd@google.com, akpm@linux-foundation.org
Cc: leitao@debian.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
References: <20260513094508.50888-1-ranxiaokai627@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260513094508.50888-1-ranxiaokai627@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DAC9E2000A
X-Rspamd-Server: rspam04
X-Stat-Signature: izt1h6mwkbfjhubn75oedznnx9xk1ir3
X-HE-Tag: 1778726202-883436
X-HE-Meta: U2FsdGVkX18Vzl7M6pPUJoHXtmJfopcvV6/8SSSwb2CK1u2lkIjpvJmk1/pNAUGastIVvEvvq/R0U97YHbQArKNOKRB2lsJbunnvDd13rc67My4ZZ21bIR4Wcq7hXeJtcn8TtqwsdwHRvzN7vAwXbQ7LG7bIyL+jnJ5bL9QX/5tJMwOj2tkV04C7GefobmeifyaBWy/Yy/YQ3SW4LIUlUtSZ0uGiuQda0yJbFiTAP34KGMMNu7h/Y5KihmzzZW2jlsZZ6qte5lj7Mv2sTI+G8SjXlBnsJ+lJayZHtVvKhhJ4L8X8t2L3TO0rHM3yoVohveJ9IANrGylglMTxveg1wliA/ClD8XguCKsrPAvzIX7JUMcLsFQqltoQQ5617OIRapUJd7+MoniMGqfEk12E+eLo7xlyEE1bW7ZACu4LDHv1Ba4kG8BF1moPW8L3oHf9BCjh+HCN3whxEa6iXmAwxVxzyU2eo3CX3Lrgr3jteTPkgsDki3auEK+bDchtpO4WmxiSNu3yuBE8S/V5t1mYd0mhQlfWAK6J+wkZKyezTyZDartB0pjbgSsJsiINTlaz6kTkwsI0SNGlYI24MOpsmhXfUku+DE/Y4jkpmLulSDCvRUYev5x+xySEschSOkKBzxOi5jXHwDrh/QM0N87G/1f/MvkfP5M+IwgOzGiEC7nr69GqPx4uacy4absKrAXQQ+/0iglQR4oMhwlarqAt52LfQlFf8o63tWJ0/Kww54i0P1niuY+tPzHjsDD6/eJ58laq8mv3CDGApkqTzZbY0UlnbfeEgQPLkmOqPCqTGINAyOSEo5UxJmm6x2pxx1YZLwv29PRVpYuaJn+TVNB1beiPRhyb4fBCtJZNtfR4WzsPUEuTfu2HEDv4G8tJDqAvtVEc5otFp9os2XACCd4msZsOQd7LE9y+Tg9jWP02FwoUsa1l2S/dhflkCZRNSHZsxtmO2Gch6IXzDFLY1jR
 KElEyI9G
 1iaPrZ72QTIp35bWU+IUrJO4d+Yh+OKt6uAFcY6lZR7M4jAtV2aPboVtKVnApgZCMqSVCkU70GBg99SmAv5jb/MiAD00AsciQ0pdBh0PLBjqr1OogkE1pnvKCTNHW8iPQjrc/WcyLd5dvoLjKlsBRd1qDwGYqdGyY9sh7NL5mbxdomDNULWqFtGLwHfmLq5+u0PNsi1w5DjwSzlnDIET5yq+w3/WZ8dTrLBe1yan5V+hvUYaLENQFDelKN1nEbOFJJOyS2Ao3NYOc24G9yH6YSix9GOYsLXXg7qjWzUcUT9bA/HKhQdeQeFS27qslXRSRR9j88m9/WNEdflAWU0C1t7AD1qmVGrZqDkO7S28eLCw7zt1xHIgTjivd7F/L2ayQ3aQJhzD30NAnDlKI/ak0urNyMuQFF5SSQiv8bwFroxO5pN8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The subject line should be: "mm: shmem: xxx"

On 5/13/26 5:45 PM, ranxiaokai627@163.com wrote:
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

You should document your changes under the '---' for the new version, or 
ideally, include a cover letter describing them.

I did some togging and works well (some nits as below). Feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 94 +++++++++++++++++++++++++++++-------------------------
>   1 file changed, 51 insertions(+), 43 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..60cb10854f11 100644
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
> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>   					   const char *buf, size_t count)
>   {
>   	int order = to_thpsize(kobj)->order;
> +	int mode, m;
>   	ssize_t ret = count;
> +	int err;
> +	bool changed = false;
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
> -	}
> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> +		return -EINVAL;
>   
> -	if (ret > 0) {
> -		int err = start_stop_khugepaged();
> +	spin_lock(&huge_shmem_orders_lock);
> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
> +		if (m == mode)
> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
> +		else
> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
> +	}
> +	spin_unlock(&huge_shmem_orders_lock);
>   
> +	if (changed) {
> +		err = start_stop_khugepaged();
>   		if (err)
>   			ret = err;

Nit: just return err.

> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode hasn't changed
> +		 * to preserve the legacy behavior, as this is always called
> +		 * inside start_stop_khugepaged().
> +		 */
> +		set_recommended_min_free_kbytes();
>   	}
> +
>   	return ret;

Nit: return count, then you can remove the 'ret' variable.

