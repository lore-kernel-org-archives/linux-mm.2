Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CBCCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394E26B008A; Thu, 14 May 2026 06:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C356B008C; Thu, 14 May 2026 06:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A98B6B0092; Thu, 14 May 2026 06:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0636B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:10:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC010C132A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:10:56 +0000 (UTC)
X-FDA: 84765606912.24.93D12A5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id A067A80005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:10:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LnSmt210;
	spf=pass (imf30.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778753454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0BiJi9b4Pe73gtyOaUPtKrNPLIwMUgnAn24gRrwgVI=;
	b=oy2qJpA2gdkQSzZXQbU6BnsxLv2XscbmnhQKyO8IX60d3YHWvANllWVk7+tDEezrFpGpqM
	BLc78saCubf8YKQNYPHlCucKdEFV6F0yUUqA/Nbp32ZaqWVnML1UOUrpO4YoYTdDPEFA4J
	5ITRrpjf5LwfuRvxFsUoJBM8keLHOPA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LnSmt210;
	spf=pass (imf30.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778753454; a=rsa-sha256;
	cv=none;
	b=7BqzPGdreTEKpdcjbO8aP4mjHJFGST9fxykPGCatByaqugOKjjvgYLxmylam/7R52Z5xte
	ioJ4PXmer2idjw9O/vYRK8xrqGf/autMlT27pxqKi4iprqzKIbmIRVEQSp6TSyedXbdkhg
	LaefgBJYHnEjoRwXwoakskR9RcRS9Q4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=H0
	BiJi9b4Pe73gtyOaUPtKrNPLIwMUgnAn24gRrwgVI=; b=LnSmt210mtjuTOX/ju
	RiWUHRgNLih/hj/9rkL1BocOExZD7gheSVUu1NpkPLWvakbLrfC51aR8sYBibaRW
	gQXdgoK0hfvk3h2hGM1afeMrBqeddMnau8H7kDIWYCkMNMIgDMBQcizhqpafxg93
	+iwZWkHcRJ1pmsSLrGPxSqjIo=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wAXcsiLnwVqEuRYBQ--.10592S2;
	Thu, 14 May 2026 18:10:20 +0800 (CST)
From: ranxiaokai627@163.com
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Thu, 14 May 2026 10:10:19 +0000
Message-ID: <20260514101019.52078-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6d6b1949-fb11-4b05-a01a-9427019b3ae0@linux.alibaba.com>
References: <6d6b1949-fb11-4b05-a01a-9427019b3ae0@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXcsiLnwVqEuRYBQ--.10592S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF47Jry7CFy3CF45Ww1kGrg_yoWrWr4UpF
	Z3G34ftFyjqF9rKrZrXF4rtryFqrs3t3W8K347Ga4fJ3Z5ZwnIkFn8Kry09a4kZryxXr4I
	kr18WasxWa4DArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpa0kUUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxg3mM2oFn43z0AAA3A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A067A80005
X-Stat-Signature: z8qroca38efku9k9edt3fp71zaru8h13
X-HE-Tag: 1778753453-674089
X-HE-Meta: U2FsdGVkX19Vp6nUKCE6tXj7AbUJQVi5QYyQrHdD+YQZnU1oYOSB5LBL24BjM4UeeYfPWv3QfZkP47LSY0zpX38k4JWIxk2dnGnG08QJw6cp4FZD7n7BmpbP8nM6c+Q55c3LgwPDDB/A0IL+KjXdqkCz4i6tWWDCCWY7nTJWfROzYfSWh6wir/4qBEbykV9vnn5Q7MiaTSF5Nd+k04ZNT9njxdHHPjDb4xooWddASYqlsVBclwX3CLl0zuiPQL+Iymxdo5/nmsq7FoLpIpG6Ro9VC4qm4bbJe240pgTwqYfBJH+KPtbuc3kblVPnlrVEZPtlLYXAjRBDStrtr50OkGyLUdBoAemOh4y4aKEquJ/fixnLxM4nLDOu7Bs6tCJkx3VHNJKjjkCluLBv2mbQDVlv7zM5+aV5p0Gqy0ncZpdXXE9tNzgQGu3Fy5GytiF18Vk/AAZ92paw1BFkoM7FnO8FH4yntM/DtO0htQlwp3QU7KBXgY+IZy5/0FRkCZ888GNp7497LheaYy92T8Ms9OIWDDWCB050Bw7CFQIzy4T+IrwMWzHcfhsQ+KrOm8sBgsno9tvKsyYR/NJYdqchmfG89pmd+FGkUz+bkV42ML5QXR3bZtzHF/4dcJ/QzydimVRMLu2DEAzPvT+v+BrNRQcJhu+X5eT28XMhNmsCflwYWOMhTyuFscWKgw7ZicQl1/lkQf8ByCD9oamtVb3GFGjopz/6KtGxKr8avYLyq+TPIB0Z7y74adGJecnV9pKh7Itmj8Ts2lz0t7/S0qVCWr0bTLb69LoNVIKAExYTPy7asM85eZ2qcWnUBvL9xwIL7sIsHhVbg7RVn19t8sGFOptcw0ll0y1ZWvFdsLrb1sxpUb2NKeacBw1BhWHpXfzM9SqQ9/VQUcrUFrn8wXIfSyxB8lMAU4WcueBJF/HJrNqeBiUp5i/XKNktyGT9GVKt0Vhc5fFbKD/zv5HsuI1
 ecGwjBZI
 NKTr4ouZA19ThpdHtIYWUytZs0fdgDjajJl0Ghr1kFX9XZ7t9keM2WwdcdTEzX96CdHs41hnm+KoZJ6FTlU4illSFT8Affg6swnwibN0PwGLFo3q7heKWxQMLF2SJiMpZl08y8VoXnDfnOPBOw17yvjD0ZA03S1LULYPhrFKGh6E1dI0nyqhbg+QHvMl2Vmn7ylQc9ZUAa9RrGIfLwdA2YAv5Wl29oqXbaJ5PY9krYxRBVvQgMxDiAiVxIY3647NDt3oqOtqW2U+qxOFWr+BshjhQoZDpSx8EutBD/1qBWUxU9dUm3OkJNW3rTMY/1ZMA0TP4fHUsI7maK2mYh6+JO21i8kacxTBpiZHzIRVe1HSnN9gZw9pD/6oNgzlC9Fuqcywjkv6jER6Yr8mxrLRiy6YMWEBd6kLw6b0tZaqL+cFA/RoP8qksyrMdLuTzfWM636liHy9UGM2t6gsOT4dnbzsxp6+XglTBk52WIFRTogUR2II=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>The subject line should be: "mm: shmem: xxx"

Yes, of course.
Thanks for your review.

>On 5/13/26 5:45 PM, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>> 
>> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
>> all test cases passed.
>> 
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>
>You should document your changes under the '---' for the new version, or 
>ideally, include a cover letter describing them.

Thanks for the reminder!
Will do in the next version.

>I did some togging and works well (some nits as below). Feel free to add:
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>
>>   mm/shmem.c | 94 +++++++++++++++++++++++++++++-------------------------
>>   1 file changed, 51 insertions(+), 43 deletions(-)
>> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..60cb10854f11 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>>   struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>>   static DEFINE_SPINLOCK(huge_shmem_orders_lock);
>>   
>> +enum huge_shmem_enabled_mode {
>> +	HUGE_SHMEM_ENABLED_ALWAYS = 0,
>> +	HUGE_SHMEM_ENABLED_INHERIT,
>> +	HUGE_SHMEM_ENABLED_WITHIN_SIZE,
>> +	HUGE_SHMEM_ENABLED_ADVISE,
>> +	HUGE_SHMEM_ENABLED_NEVER,
>> +};
>> +
>> +static const char * const huge_shmem_enabled_mode_strings[] = {
>> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = "always",
>> +	[HUGE_SHMEM_ENABLED_INHERIT]     = "inherit",
>> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = "within_size",
>> +	[HUGE_SHMEM_ENABLED_ADVISE]      = "advise",
>> +	[HUGE_SHMEM_ENABLED_NEVER]       = "never",
>> +};
>> +
>> +static unsigned long * const huge_shmem_orders_by_mode[] = {
>> +	[HUGE_SHMEM_ENABLED_ALWAYS]      = &huge_shmem_orders_always,
>> +	[HUGE_SHMEM_ENABLED_INHERIT]     = &huge_shmem_orders_inherit,
>> +	[HUGE_SHMEM_ENABLED_WITHIN_SIZE] = &huge_shmem_orders_within_size,
>> +	[HUGE_SHMEM_ENABLED_ADVISE]      = &huge_shmem_orders_madvise,
>> +};
>> +
>>   static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>   					  struct kobj_attribute *attr, char *buf)
>>   {
>> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>>   					   const char *buf, size_t count)
>>   {
>>   	int order = to_thpsize(kobj)->order;
>> +	int mode, m;
>>   	ssize_t ret = count;
>> +	int err;
>> +	bool changed = false;
>> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
>> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
>> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>> +		return -EINVAL;
>>   
>> -	if (ret > 0) {
>> -		int err = start_stop_khugepaged();
>> +	spin_lock(&huge_shmem_orders_lock);
>> +	for (m = 0; m < ARRAY_SIZE(huge_shmem_orders_by_mode); m++) {
>> +		if (m == mode)
>> +			changed |= !__test_and_set_bit(order, huge_shmem_orders_by_mode[m]);
>> +		else
>> +			changed |= __test_and_clear_bit(order, huge_shmem_orders_by_mode[m]);
>> +	}
>> +	spin_unlock(&huge_shmem_orders_lock);
>>   
>> +	if (changed) {
>> +		err = start_stop_khugepaged();
>>   		if (err)
>>   			ret = err;
>
>Nit: just return err.
>
>> +	} else {
>> +		/*
>> +		 * Recalculate watermarks even when the mode hasn't changed
>> +		 * to preserve the legacy behavior, as this is always called
>> +		 * inside start_stop_khugepaged().
>> +		 */
>> +		set_recommended_min_free_kbytes();
>>   	}
>> +
>>   	return ret;
>
>Nit: return count, then you can remove the 'ret' variable.

Agreed.
I'll wait for more feedback and send a new version.


