Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB595CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC736B0088; Tue, 26 May 2026 07:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E0B6B00C5; Tue, 26 May 2026 07:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5F26B00C7; Tue, 26 May 2026 07:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE4FE6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:22:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B6841603C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:22:40 +0000 (UTC)
X-FDA: 84809333280.27.A5C8DCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2932C4000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:22:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AINgodxR;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edtMl0k6/AxJMdXk+W1fbU3ZPltq/7vhq9xYg9auTlw=;
	b=6aZFJhOlXmtcIiO604n3hXDOrAQjQBDOB7Olec3K4vQH4eAsx1U6ybfiTCFtsOw7nQ3WHr
	FahAcd4mVkCSdPv3gC1D008eMxpG/aBZlIY93cs15aC1KgpKjcu+k07HS/5BUMZv30V3FM
	koj8DCfAQNvKYnPoeLvZKd4sq9voph8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AINgodxR;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794558; a=rsa-sha256;
	cv=none;
	b=hDeKGK60kkougWpj5rcUJyYiCDpAsymzfWmLcjBqis0kMf8HNmXqjroiOmlLqUmdMhQu6g
	FZa4fVFvO6EJ62dPxzY6TQGdpZxZOJ0o/p8A11q0Yu1AEdacrBOh1tbTzM0g9az1ArGVTW
	/eCePfGGmGsrOH101G6ufYSn2IW7UP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BEB943B5C;
	Tue, 26 May 2026 11:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D231F000E9;
	Tue, 26 May 2026 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779794557;
	bh=edtMl0k6/AxJMdXk+W1fbU3ZPltq/7vhq9xYg9auTlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AINgodxRC2K92xgnNlj3DqwmDj736yWVpDLEcWDXIopQTHVb7fGM/1IwAMr625HkB
	 SquHMFJZmioC8PJUydGZ0zYNvfDv1Z1upjkkEyEH0YkRJSnkLmt4UJ0qLUSgJx5Li0
	 ispi1RDBPz0N0thtEb6qawMp4JdUthyhV7hDVMhgaB/4T4ltmSpKPfJ6Z8z6nR8jRO
	 vbXGqBU2TB373rbZEJizjPq99aQ0d1sThoBepA3kjgibEjquCLuGcAUx07dxcJaWKB
	 9Vg8XhdFTov+UrfhHWdYZr1ok2qEJ7HoRn8nnU1j0Po7tQBKFiPWEmzXCslQJouTHc
	 LrOK20+kwoRVA==
Date: Tue, 26 May 2026 12:22:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, leitao@debian.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v4 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
Message-ID: <ahWAZQBbvNeHoBXf@lucifer>
References: <20260525102700.68707-1-ranxiaokai627@163.com>
 <20260525102700.68707-2-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525102700.68707-2-ranxiaokai627@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2932C4000D
X-Stat-Signature: x5jbe1jiuh9au5du54cer5qkh8pg44fp
X-HE-Tag: 1779794558-896536
X-HE-Meta: U2FsdGVkX1+PCyqscNmzLR3D+Y1akR8AlZSGIm89auekUzqTk2tTBz3jeeBjraCG3bU31ZRBYaN5GlG//BwQoPJrZBExfy09yJniI+VSDao+PSqzEAjijWQ3Pz7J54uLCtiTvvhaTVUUYUGNJaJ2c+OD7zWz1KOzYwRFny4kFP9mHDGm2gWlhdNgMcYbrKZGBhjV9JfU+o/A1U0bxNb7PxsVv5qeE3Z6nT2C9C4GP8r2oejKcnueTL9/bnU7GomI+CmNzzmY6SdGgivd1+TIVd1so7GTyd+yPBBLgB1OaUHD6HhkXNppVOI6t+Gclt67r7DZZf0D37VRCCpAZ/8ld2Vh/mZo2QNwzGqFX0Xg/MaGCYD/ZSJrp/5gmsL0RgsVofoAu1+GbiRMVfEAqY5y4yHa5qYaSNgQPLPzNMfMsj9ujtPJnf8daBILNRZCeU9+8zXoNtdjrUdV3T3o+aYzznmE5SEmhB6dNwGsWBRyhj+vOI9rCf5Eh7UR99RHPipFrJWylyEV+ZkJ2HaUs0aiTWggnPWPuwzWTXuyqsv83e6lcR4md82bhfUSXsTzwM2LdClEFSqll48YTd0mzMn91rQW22Syzu9+xKGoAcyr+jT7qgO5m3a/+7hvr6m6AQ6aT/HzsbbHNG2cHc6yag0YazpAPzZ1giiUl2Gp1CYowm2nLwwXlD4nvvZkfKGOTtVWWBw6Ne/5GVsgvB9n0cvLMltm93JmXwEUZTIvIb16BlBpBUKi3a6SFIc3tDPjpimQ5rIxPI+Z5g7GCSym10Z1RAwURiy5+9ALlN1QIeZDhxRitS1MOvrA7zTcllVzm2enIt2atiY1n7vSD0wBmVsHY7nhi8HP6+cff4xfJgWfB2/ghOZnVx+Wg7BJ4GaNIB0Dzl5vKOjyZYguriAKytomIFK2U9LX+00Y1oGMTXko4KPHa8SDvdZtMEy3cNThSbyg5u5Idb24cbEeMm5gUj5
 qoehnKZl
 gRBQjyaQo+OB3uEzIHt9syu9hluaTD6MHlHFxwplgINm98zGbY99571NBIYLgknQSI9ZDCYCxK4Z5JGE/Scy/DhZCQUXsPdT2CxseS6xekCdT90bphVHhznHQIZqQqk8EPibWqq9RWPPJXplMPSykEGnbbs15EukN3gFRB1MzOxoz/OeUmn2KiX0Hmlp5d9Mi8g9nubXi/byHX6PHIKCvfbfeNy9C1H4fFnaoqde+gJawoHWsH6NXOOdiyVWgR01byVBnG7KFdv7ipaFzM2KhJSMJIOgYMApjbTMIu1XnAH4/ITZZK679PRiEziudi4usSJgPhBFq8QB5fzLW45Ag/9+aWLeFCq9BxBan630rkb7zovtBdT/hp0/6By6OvSBr+yUOWZm1cPxV9uyW+24rNeXMH23bfvJ5wsfNBW3D6J4wThY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 10:26:59AM +0000, ranxiaokai627@163.com wrote:
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

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/shmem.c | 107 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 60 insertions(+), 47 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..288942b44db6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>
> +enum huge_mode {
> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
> +	HUGE_SHMEM_ENABLED_INHERIT,
> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
> +	HUGE_SHMEM_ENABLED_ADVISE,
> +	HUGE_SHMEM_ENABLED_NEVER,
> +};
> +
> +static const char * const huge_mode_strings[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
> +};
> +
> +static unsigned long * const huge_mode_orders[] = {
> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
> +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
> +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
> +};
> +
>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  					  struct kobj_attribute *attr, char *buf)
>  {
> @@ -5546,63 +5569,53 @@ static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>
> +static bool set_shmem_enabled_mode(int order, enum huge_mode mode)
> +{
> +	bool changed = false;
> +	enum huge_mode idx;
> +
> +	spin_lock(&huge_shmem_orders_lock);
> +	for (idx = 0; idx < ARRAY_SIZE(huge_mode_orders); idx++) {
> +		if (idx == mode)
> +			changed |= !__test_and_set_bit(order, huge_mode_orders[idx]);
> +		else
> +			changed |= __test_and_clear_bit(order, huge_mode_orders[idx]);
> +	}
> +	spin_unlock(&huge_shmem_orders_lock);
> +
> +	return changed;
> +}
> +
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
> +	mode = sysfs_match_string(huge_mode_strings, buf);
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

