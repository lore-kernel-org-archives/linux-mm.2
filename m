Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A21CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D686B0098; Fri, 22 May 2026 06:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224956B0099; Fri, 22 May 2026 06:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161426B009B; Fri, 22 May 2026 06:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043776B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:39:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2E701407EA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:39:48 +0000 (UTC)
X-FDA: 84794710056.09.343D6CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20199180005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:39:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D009cGPJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779446387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOB72dlqlqYpR/qANJf+/wa0s2VmGfVQoF7lhMB2V90=;
	b=W+nnKMcdJ3aoFw65mzmmPy5RHKHIWTr2Blne2DZE5S60fecvtPqpBCT+UPObDQMUHLnv3Q
	hc15eBItaZL7PJU+Ttg8N3DHD7ysgP8O+lQycVcjjRwhjHvAZQwW4d7/Tj1C6WZTIDDWL5
	64i/3Q+L5SysmxMgpB4nT0nN0jjQeIM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D009cGPJ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779446387; a=rsa-sha256;
	cv=none;
	b=WuoqSudIfutdIMV1AlM4HtZtURcG4q6t8raQ+RkP9EG29+HJQz9yXXlO9TVS2qzwVDqDZh
	zxfXDTxG3mE9ox5P72xWImi+riDvZDrvS6rCG1gXcOMmHW11KdRB//P9qhOpWdzCbzkh6Q
	bT072nYOWHksNsGrOnvEdLvy/2TvOb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7084340852;
	Fri, 22 May 2026 10:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C216F1F000E9;
	Fri, 22 May 2026 10:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779446386;
	bh=KOB72dlqlqYpR/qANJf+/wa0s2VmGfVQoF7lhMB2V90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D009cGPJmNETl5qBLIK58SoZ3BGJmoTnIBumAi/YgRnBJ5Ag49f3w/kZyMQP4aWzN
	 9hBhW+FH4TGyjBLCpDIFuuGJ2dJciJG6n+bAHyHJgLhAvSda8b6sl6NMt+7xgJDDdS
	 PuiXzk0wWNbbpxITKLsIjnk/BZR6VCFCSMkE2zbYsqWNEI1CoQq18wVcgWGjIxDWi8
	 sn73Qjp7LOl243STYm1mxrYRhNd3dD0iyzGL4iSxRl3Wu9T8TTXpjqu0+J3e67lFqE
	 Z8FXaY/ILsmYzsQxDbk2QlB7FMQLrKC2bfnMSN1CWXjpTUdIJQpL9/nNURd1XhyG7m
	 F2wuDP2xVVtLA==
Date: Fri, 22 May 2026 11:39:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
Message-ID: <ahAxasYwrGvwQLKs@lucifer>
References: <20260518123238.56344-1-ranxiaokai627@163.com>
 <20260518123238.56344-2-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518123238.56344-2-ranxiaokai627@163.com>
X-Stat-Signature: wimwegjmsdcj1nnyswmxu1mb9ai5okpq
X-Rspamd-Queue-Id: 20199180005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779446386-751769
X-HE-Meta: U2FsdGVkX18ZsMXmZ+b1zXBlgjw6AD4/qFlrVulAcmWrMRmEdY+mcbbFhWkRL8wFLB5Zcz0KQUkmHUWeSOnlKVbnHDNwu4vvL1MX/lJkeoabdH4yzXpaLIbB42AErt5849qtlKzf8o9BI13hCMi3c/4w8HM0VJp9iC+DKOCdlyZNQwDq86WgQoecgs2OTi+JipjBxYMzblTO7lcUujO44mMRt77/w5CnHh1p6FpmeKum4tSPFpTwvMZjfdAgunHZjoQJ0/H6IpIvbiaelfxynXNLERMiNBx1k7TUqGZ4beOHcvXDTcxYgPgNRJS3Tv/x59FJlam1XRLnwpYPR/TZNS2tzUvKFMekdQ2y4bkWNsh9sDDoy80AWE8N7nZMrSG5rdXxPmUdGlxQzzK5RToy8E9S9OdGQkNphnTVOnJmka8o4a9jGE5GNleZzgYooQPpKRhotFKwTVQ2tU1ae8Oz5H6kH5zfhH6oHaqfL1aE6Z2ktcLvfTy5CC/0qBuGtQ4Sv/ZAbvQa0QCboNMqNpe6ZkEh9k/Y2EZ0YXtP0noytyBz2ZEHp31w8O15r7gX7H9suN8D7kOBy5gL0gpmXJFXIz2vL4oHgTOOoF83zMXmTOQol1yuk4pYwyZo3EK1VQ+3RQv+TOSpvEOniYbaLpVxY+wUY256ozsaq1Hc1W27qlDTWih2Pv73vgsPyW4WHjxzwDPb/rxpr18z9NRlTFeLaudwTRNPieoeo7BdbR2i4tNCv95vcXKGu4YULN3z/Srxd4CbaRHhoxRHzv5nxbqoTI5j1IqV1xyz4rOfVyTd+PndXB9A2xjJKVfprFJrj2kk16e58KLS9jfRVmuZvhxq+e1WdJjkKbzx97Hy2YPO2bnqKKwjQzCsgpL2s50sAuRGnt3IHwwCuK/uV3dqPcZScGrRWEsRESeC0nkVdoOzElvC9eWsU0GBgGIQ50/z7h3N2RofinToI405sVZ/tiq
 XzHVvURu
 LPIBUnPRKi2nh/o/RoY9+hF3H74ttS9H/7zfz3YsRT/xUj+YGYTZh7ec1HPyaYlmUHchJ/m2f6wN/SSTrLDxqXHF3AAVVfl560zL++xEY8IMG930b5WK1LkXtrihx84qQSmVhr2OZaOUtvI7P0xnzuJrTbEfb4+uyAXIESrYzupxZJl5edvP3qWnKMuso/h5fssoqjPzFqCnKMXVS9DnZftruxaGq/qzYdlXRxTeRRlS9Kk0Fo5wAhyG2lX2WRXpPKS0puTAHSgfTwIqz8sZBvQQDnYgWhDWjK1Q7rDEpTah8pIyyGm1LgonPV2d90hkgyqgJY47sT4fRNVGHT+AhFleD8DxHl2/sd6BV2rN2K+aikW2TOHS7iAwAnUBiKN+ALoBX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 12:32:37PM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
>
> Behavioral change:
> Call start_stop_khugepaged() only when the mode actually changes.
> If unchanged, call set_recommended_min_free_kbytes() to preserve
> legacy watermark behavior. This avoids unnecessary khugepaged restarts.
>
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Your From: and Signed-off-by: differs. As per my mail to the 2/2 this violates
kernel process rules. Please either update the signed-off-by to your @163.com
address or resend from your zte.com.cn address.

Logic generally looks good, but you need to fix your From/Signed-off-by and the
rename suggested below would be good.

Thanks, Lorenzo

> ---
>  mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 60 insertions(+), 47 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..46d2cfc30823 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
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

As Baolin suggested, we can probably rename these for bervity.

We know it's shmem, as it's in shmem.c :) so drop that.

huge_mode, huge_mode_strings, huge_mode_orders seems good to me?

> +
>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  					  struct kobj_attribute *attr, char *buf)
>  {
> @@ -5546,63 +5569,53 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>
> +static bool set_shmem_enabled_mode(int order, enum huge_shmem_enabled_mode mode)
> +{
> +	bool changed = false;
> +	enum huge_shmem_enabled_mode idx;
> +
> +	spin_lock(&huge_shmem_orders_lock);
> +	for (idx = 0; idx < ARRAY_SIZE(huge_shmem_orders_by_mode); idx++) {
> +		if (idx == mode)
> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[idx]);
> +		else
> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[idx]);
> +	}
> +	spin_unlock(&huge_shmem_orders_lock);
> +
> +	return changed;
> +}
> +

Thanks for separating this out! :)

>  static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>  					   struct kobj_attribute *attr,
>  					   const char *buf, size_t count)
>  {
>  	int order = to_thpsize(kobj)->order;
> -	ssize_t ret = count;
> -
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
> +	int mode;
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
> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
> +	if (mode < 0)
> +		return mode;
>
> -	if (ret > 0) {
> -		int err = start_stop_khugepaged();
> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
> +	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
> +		return -EINVAL;
>
> +	if (set_shmem_enabled_mode(order, mode)) {
> +		int err = start_stop_khugepaged();
>  		if (err)
> -			ret = err;
> +			return err;
> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode hasn't changed
> +		 * to preserve the legacy behavior, as this is always called
> +		 * inside start_stop_khugepaged().
> +		 */
> +		set_recommended_min_free_kbytes();
>  	}
> -	return ret;
> +
> +	return count;
>  }
>
>  struct kobj_attribute thpsize_shmem_enabled_attr =
> --
> 2.25.1
>
>

