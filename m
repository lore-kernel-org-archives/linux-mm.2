Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D53ECD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A586B0093; Fri, 15 May 2026 02:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC076B0096; Fri, 15 May 2026 02:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927ED6B0099; Fri, 15 May 2026 02:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81F706B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:21:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1291B160F7E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:21:58 +0000 (UTC)
X-FDA: 84768658716.19.8F6C1F3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27E5A180006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:21:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MaqyQ0lr;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778826116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBxEknQsPnbdB9J+1aQgcs5bxw5LG237JI0ZrgWvRTw=;
	b=gR/3y5WqH6k4F0HGzSVNmmGs7nMCbcr1MU9mJuf5VkzxRhDZa3vpk3l6JCOYFPd2rJpfJW
	tJJDj7W7cPy4M7V3yxEpekRuj+Sq0h7hfYgjXnl0EfEMM5YOUw1kV555Wi/99oxEogPadw
	dqm0LaOMD43F9/Y7udh/+ZxjjnDlflA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778826116; a=rsa-sha256;
	cv=none;
	b=8CzGUfDz1IAD31M8JjW6h9ouWxLUIA4RS2qL+HBGMP1YW0UicXGJ3F0qzRFlq1RuBdVGJQ
	TZLD+2sg8D+RFj0G6Pspgu15U6RJ5A/nFyvxvRqZ2tE20lH5IOvgBclwR7rmHeD7ALS4Ct
	37E7VXvqnsM7MJgzfIXdfiE1SHJuifk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=MaqyQ0lr;
	spf=pass (imf06.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=MB
	xEknQsPnbdB9J+1aQgcs5bxw5LG237JI0ZrgWvRTw=; b=MaqyQ0lrf1bFxGBqq3
	WVklfSzcr3j3qzGZQWNlMA6glgsqr21zel9gnAbccNL6RzqhosxrjcAcLQP7HvSR
	eHYMl3SxRpN7EJo6klq9qzX9bj3DqUVgTJcz48hhS43JSWhmjwgbzXC+J/FjhV8Y
	zKtJSdSP0k2cdumHoNwbLtZcw=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDnjwpUuwZq3nXcBQ--.25703S2;
	Fri, 15 May 2026 14:21:09 +0800 (CST)
From: ranxiaokai627@163.com
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	leitao@debian.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Fri, 15 May 2026 06:21:08 +0000
Message-ID: <20260515062108.53231-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agW_BR8qNsxzAKYi@lucifer>
References: <agW_BR8qNsxzAKYi@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnjwpUuwZq3nXcBQ--.25703S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKFy7Wr17uryfJr15Gw1rZwb_yoW3CFykpF
	s3AryfArW8JF9rK3yxXF48tryrtrs3Ja1ktrWDJas3A3Z8Ar90yFykK34Uua4DAryfXr4I
	kr48WasxW3yDtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUpa0kUUUUU=
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hYgbGoGu1bangAA3x
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 27E5A180006
X-Stat-Signature: otxbydhsnd43dh5b6tqz4xn8waex3ohe
X-Rspam-User: 
X-HE-Tag: 1778826114-709972
X-HE-Meta: U2FsdGVkX19BNDgFd7NBuIe0jX+PwPKtpDkQkRhu1jHXeznmtJHcFgmqxiaDcaf4FFrm1us8ZajJovmYbIE5xWMhFceqkoluEbpsV4H+cgjuXin3LBAs7rhzwXEw+ppo1WqRGpOxvjRHXPtmAFkrmr4hr/M50lXafjjE4Mgabtv0g6EAmd2nWk2mmS2tfejWOer0gsyGxF+1CNXOJsq+XNNoCmU9pZP11+DBCK4JnZPIHBeGUJCnTU7Tdg/NEsxxihUJHV+OyZiCfFmoISliRAUazAbxqBF2C9cPzjNXUJU3Vdk6SjmfJ8yKxm47IaT5vukmQQLDSUtTxln7i9P99aRXgqN67wThy5eXm+fK8YWyzgk/CougoEMBzxkO6F7LgQKhHWeLWyNyWJLX7YrlyZaNzA5kJM9mHPHWHYU+50MsdPF3YtFDpdgIw92CiqGO9gUfiLf6URrtxJsbBr8f2mDheuHrhBoMRKbFzZZslhPcDKeT8tXXseaTl8dKq+3jjKpGOL02dPCjFPmZJ+5Q13GaHS6RzO335I7HGJ8rGyLaJcuitvkxFOxJtC5Q33QIy1UjX76QRdizhol2UcrlL389urj0z6uTAkwDeIaHKhsKB1f6GUyATKEZ7wWppGQEb52rnRCubev6YNS1D6T96rRilhcQ2hXi0FtryXVN313DZhSHMLaIqdRyDVvnsV83hlH5kdrevUa2o5r5BLDaZ2Uh3bs/FfPR0xw8kT80H62gU711GKDRc1KT/xUllU2qJGbOuT/jmBJJCt04AZYNXuP2MzRkajc9ZPKnQE5jfArNnx2WXUx7TVkDpYDd/Xic7StN/58yysJzpdzD8D2ZC+EnA6YnwAhaquyzEfniFJcQfCMoFH/XOn3igTHjs4XHfNbFZkem0VNfz6mSF40iow8c+5gRCbhFS+w05PSfGT2aot9fnAialzhwMcfd34kNHe4/SWNHVwnpmxqu0Ba
 GhonDlGS
 SHz5nympF/SB922BptSQB8C3rgAFXe3FnfjcdwN8UthBzc/wE9H7RAo1s6+ebZ1PHYN0E1jaXUaYN7KtiVPwtvndmE98Vh0dYTWmRrV5YunnT8iuXeczbe/mHUbScoZL/JkLkdXyUA/LyPf5ywmIIH5cK4pnEuIsc5M7F6KeEOz8NwDi6Vrj/AFCjpojXoGHUB/R3Y7CGowK61efKDWT4CDjI1d24ugEEd3iVlBDZVe7oyFdyPFyi9uzZLxfepeC0Pdldn/UrNubRzuBJ8pC/yhG0iLD6RVMKusy3i5WsZcMhDk0rRVFYNLuYqqsRDgbTWl7d3Te/D48RlD41oCz5dUdoPGXWS39u8gD6N2qewKPOdemDViM0yFXaxLFsSevNoZPS+08S6PT5QWITQBi2re3mCR4MXzkPCN5U4TXi9Fjooc62cMf/3JA5Q9sX3vcT7eZ05tqO0VrVMNFTgKTtSdJW1ySatjaoourfgXGKUAfgMzx/lrY3LBZYOGjJzbrKRzmX/dgsIMCWH3CBizqQCJXdIvU2RCKC5gakpZ71JDATcvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>>
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>
>You are not mentioning that you're changing the stop/start behaviour. This
>is a fundamental part of the change that should be documented in the commit
>message.

Hi, Lorenzo,
Thanks for your detailed review.

I'll update the commit message to document this:

"Behavioral change:
Call start_stop_khugepaged() only when the mode actually changes.
If unchanged, call set_recommended_min_free_kbytes() to preserve legacy
watermark behavior. This avoids unnecessary khugepaged restarts."

>>
>> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
>> all test cases passed.
>>
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>  mm/shmem.c | 94 +++++++++++++++++++++++++++++-------------------------
>>  1 file changed, 51 insertions(+), 43 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3b5dc21b323c..60cb10854f11 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -5526,6 +5526,29 @@ static ssize_t shmem_enabled_store(struct kobject *kobj,
>>  struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
>>  static DEFINE_SPINLOCK(huge_shmem_orders_lock);
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
>
>I think it's perfectly cromulent to put this within a function rather than as a
>static value at file scope. See below.
>
>> +
>>  static ssize_t thpsize_shmem_enabled_show(struct kobject *kobj,
>>  					  struct kobj_attribute *attr, char *buf)
>>  {
>> @@ -5551,57 +5574,42 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
>>  					   const char *buf, size_t count)
>>  {
>>  	int order = to_thpsize(kobj)->order;
>> +	int mode, m;
>
>I hate single letter variable names (yes I see set_anon_enabled_mode() has it, I
>should have reviewed against that, oops :).
>
>Please give it its type of enum huge_shmem_enalbed_mode.

int main()
{
    enum huge_shmem_enabled_mode mode = 0;
    const char* type_name = _Generic((mode),
        int: "signed int",
        unsigned int: "unsigned int",
        default: "other"
    );
    printf("enum huge_shmem_enabled_mode underlying type is: %s\n", type_name);
    return 0;
}
 ./a.out
enum huge_shmem_enabled_mode underlying type is: unsigned int

This will cause the following check to always evaluate to false:
if (mode < 0)
	return mode;

So i think we should keep mode as integer.

>>  	ssize_t ret = count;
>> +	int err;
>
>This is silly, we don't need ret and err (the ret is not your fault
>obviously...)
>
>On success, we return count, on failure we return err. Drop the ret here.
>
>(I think Baolin reviewed similarly :)

Agreed, will simplify return logic and return count in v3.

>> +	bool changed = false;
>>
>> -	if (sysfs_streq(buf, "always")) {
>> -		spin_lock(&huge_shmem_orders_lock);
>> -		clear_bit(order, &huge_shmem_orders_inherit);
>> -		clear_bit(order, &huge_shmem_orders_madvise);
>> -		clear_bit(order, &huge_shmem_orders_within_size);
>> -		set_bit(order, &huge_shmem_orders_always);
>> -		spin_unlock(&huge_shmem_orders_lock);
>> -	} else if (sysfs_streq(buf, "inherit")) {
>> -		/* Do not override huge allocation policy with non-PMD sized mTHP */
>> -		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>> -			return -EINVAL;
>> +	mode = sysfs_match_string(huge_shmem_enabled_mode_strings, buf);
>> +	if (mode < 0)
>> +		return -EINVAL;
>
>I don't know why we filter this error, it returns -EINVAL on error anyway, just
>return mode in this case.

yes, will return mode directly, 
but the type of mode needs to remain an integer variable as replied above.

>>
>> -		spin_lock(&huge_shmem_orders_lock);
>> -		clear_bit(order, &huge_shmem_orders_always);
>> -		clear_bit(order, &huge_shmem_orders_madvise);
>> -		clear_bit(order, &huge_shmem_orders_within_size);
>> -		set_bit(order, &huge_shmem_orders_inherit);
>> -		spin_unlock(&huge_shmem_orders_lock);
>> -	} else if (sysfs_streq(buf, "within_size")) {
>> -		spin_lock(&huge_shmem_orders_lock);
>> -		clear_bit(order, &huge_shmem_orders_always);
>> -		clear_bit(order, &huge_shmem_orders_inherit);
>> -		clear_bit(order, &huge_shmem_orders_madvise);
>> -		set_bit(order, &huge_shmem_orders_within_size);
>> -		spin_unlock(&huge_shmem_orders_lock);
>> -	} else if (sysfs_streq(buf, "advise")) {
>> -		spin_lock(&huge_shmem_orders_lock);
>> -		clear_bit(order, &huge_shmem_orders_always);
>> -		clear_bit(order, &huge_shmem_orders_inherit);
>> -		clear_bit(order, &huge_shmem_orders_within_size);
>> -		set_bit(order, &huge_shmem_orders_madvise);
>> -		spin_unlock(&huge_shmem_orders_lock);
>> -	} else if (sysfs_streq(buf, "never")) {
>> -		spin_lock(&huge_shmem_orders_lock);
>> -		clear_bit(order, &huge_shmem_orders_always);
>> -		clear_bit(order, &huge_shmem_orders_inherit);
>> -		clear_bit(order, &huge_shmem_orders_within_size);
>> -		clear_bit(order, &huge_shmem_orders_madvise);
>> -		spin_unlock(&huge_shmem_orders_lock);
>> -	} else {
>> -		ret = -EINVAL;
>> -	}
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
>
>You're copy/pasta'ing anon_enabled_store() but not the nicer refactoring that's
>there.
>
>Please split this out like set_anon_enabled_mode() does. And put:
>
>	static unsigned long *enabled_orders[] = {
>		&huge_shmem_orders_always,
>		&huge_shmem_orders_inherit,
>		&huge_shmem_orders_within_size,
>		&huge_shmem_orders_madvise,
>	};
>
>At the start of it like that does also.
>
>Please don't reproduce the single letter var name though :)

Agreed, will extract a set_shmem_enabled_mode() helper with local array.

>> +};
>
>>
>> +	if (changed) {
>> +		err = start_stop_khugepaged();
>>  		if (err)
>>  			ret = err;
>
>
>> +	} else {
>> +		/*
>> +		 * Recalculate watermarks even when the mode hasn't changed
>> +		 * to preserve the legacy behavior, as this is always called
>> +		 * inside start_stop_khugepaged().
>> +		 */
>> +		set_recommended_min_free_kbytes();
>>  	}
>> +
>>  	return ret;
>
>return count;
>
>>  }
>>
>> --
>> 2.25.1
>>
>>
>
>Cheers, Lorenzo


