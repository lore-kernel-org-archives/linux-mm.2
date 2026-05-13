Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD6DCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6256B0098; Wed, 13 May 2026 03:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE7F6B0099; Wed, 13 May 2026 03:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB0B6B009B; Wed, 13 May 2026 03:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3B426B0098
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:54:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A301BC27BF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:54:56 +0000 (UTC)
X-FDA: 84761635392.07.4665F9E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9F3C100008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:54:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G39F/AEo";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHjnHtYT1B9g6E5G4TNVYNhOjM3EynL8pg/KTVuGV6c=;
	b=yIBGklmWPNH0GEM618eCyFP4ZAj88HpPHr9BqNM7yUMkA5XZsK4UDaj7d3YUZtWYrCFbNk
	eLh/lK/jsus7ojISDGvGP/DLivH+jSqdXvu40+fevBHchKRWX1H2VeAZgeXaS7oqc8Y5Rt
	Ih3g0YaEibM6BaJGVUF7+cRzgD8d5lY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658894; a=rsa-sha256;
	cv=none;
	b=zBC/qszzSMOTVKMoFqNW8js/UKdz2RvVgNiGCX0qJ4R2SAUNYtaVpnwmWDu+8iOmieQPCH
	QkBzi9V+eT/iyimpuEjFlQ/CHVc3gtci0eq84tgLTplWYKtENzlr+NKKI8K4Y46jGlYofN
	rAVQVF3hhyu8EkZYnGZNDqhvb9l9BXQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="G39F/AEo";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18810879172@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=LHjnHtYT1B9g6E5G4TNVYNhOjM3EynL8pg/KTVuGV6c=;
	b=G39F/AEoJkcPOY/c+/N33ECm47hcA8qZsmXI4tMYQhr5rbfcRCEIoFWwHALRj2
	cIYGKLp43Qk5NS/0Rb/yJ8EDcIUkwl5V6kAcuWzsduyg28cGtVX8K9FU/MUX/2jA
	BL8XWCG6MTrk6np9YZpYCETBiwQxyIVe59U+GDSWSp+pg=
Received: from [192.168.111.49] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3lwBCLgRqXp9HBA--.4805S2;
	Wed, 13 May 2026 15:54:43 +0800 (CST)
Message-ID: <9f0dc54b-d26a-4b0a-9503-c41cdde084bc@163.com>
Date: Wed, 13 May 2026 15:55:04 +0800
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
To: Muchun Song <muchun.song@linux.dev>
Cc: akpm@linux-foundation.org, david@fromorbit.com, qi.zheng@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 wangxuewen <wangxuewen@kylinos.cn>
References: <20260512085546.368911-1-18810879172@163.com>
 <616E5E26-BB36-43CD-B086-0F238903B1BF@linux.dev>
From: wangxuewen <18810879172@163.com>
In-Reply-To: <616E5E26-BB36-43CD-B086-0F238903B1BF@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3lwBCLgRqXp9HBA--.4805S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF15Cr1rAFyDuF47ZrW7XFb_yoW8Zr1UpF
	W8GFW7Aa1FvF1kuFW7ZFnaqryjyw409ay8Gr97XFy5t3s3XFnagr4xtw429a4kCa4xGFZ2
	q34jqr129F4UAw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRP3kNUUUUU=
X-Originating-IP: [183.242.174.22]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbC7wQ4LmoELkQohAAA3V
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9F3C100008
X-Stat-Signature: 6mc1qzosqbntbou1i7yhez7tajzknccj
X-Rspam-User: 
X-HE-Tag: 1778658893-958119
X-HE-Meta: U2FsdGVkX19L+cSbxi4j+Wj4vysWi1Tl1U6hNAmHSykYI8H+B4zMjBGMa1yhr0xsbaTbcAvcS48NWMFjjyy+dRei+qMRLBIjMfP8sJw9kLpLGtP0QpHoM4YI78mJjBAoQx7Kk1IeyLem6o09byLygs81Yduyxz/1MgoXXzq5DDO+ytxMrrFkpxPP2w4cnhAHZf6eEcb9AogQ207rD4mdpVmQmXp91xALeqCf6/VSoL7sbpaMzcdnWBZBb0J7VAyocPEkQYRoXQhJN+lpr2uTTVQ3a+PJj9trd8Dks/518rlVf4hIS35hQKGQTKoFTSw2vK+DjkNXUSxrwyGdbgpPVeI36aygF6zLq30MDtfUrHPqRwCSwAfJFcd8ClKKqmOhA0lihYBn0/2BKmxhmyo3Z5Igh+IcimaO+Honq8OsPecFD04rmh+sfLswhXWrTBMEkFndpvDgm/nZUmPQhCGc0bdX6+flCtnF3RQaqGmBPA1jTS5BVdum9uNxhfwqVBRcZVvJz0APgI3MzBklJv8qS03WEFiFK8eQvhf4EucBRMpQks8EpDW2m5ZywPB/kMTlNSW4njJAHPEq+L4Uce+3pBJPjwHTyBKC2HtXBqn5eS7HcTN7KVQ6nRU9+P4+MbcrtJnXEhU83RulN6YC309X5ATeRlFdmXScbUyuzPHFMFViON/ewFwwfru046Py8h/D8sDEEFuhY+FV+u6AF+gOu3sGwNTv66v8KSSTgPHbgzbBtunY9xgaBGVC8/LhBHLPcYZyfgwguUnqG2KR5tfy73N2ZcRkz6Rw5r/cekVvBai3CMRIHRvzVPQjYOCJ/JjurYnY/Y2Wjo02HxEPHkqpXP87uno9BO4mAF3AL3bmlQR2dE6Mao3yUZb8dfnOmAdmt8SlIXfkCdlk8KjBAaozajc0t6dNx3eywPIeLAuo+4qhky2pMGaW1INqYArh8eCHfhNmCP+PVdjqgaDpSaO
 XnAnx3Zx
 euk9NVVsfYgZjtNb/Ch6ICBb5WJlPIMI/jB3xDXqJ3qW+R9S6ygC0Fb9AXyG1inbkOpV+LCHcy7dZK1NA8sRf8C7QdbF29dM7Ar4M1T4lTsAZlgXGC0DeQOuKDgjH+Ng42CZccGoyYIMSvF0n/bWwtoBwnfNaxx4rIn71C76sOT7CGiZL2uiN/kV7KqzT3uigVAxFVBTtppITPHYS4v20ZvER0UXMtLC4CsZXkvNr45g0VD4gA1M5ysw+MIJ4saYc91n8NhhIcebwHP3OIGyEXKAwAWfiEiVmbC36aWmPpVV6O5GGLKwBTtdV0SOw0ScjrD5aUEaiRog3SLmv6VQ2oaeVxAOyHCr5xf030YJH5AuV9+vBHQFHuYbtkaBuhtn8wrS03hra0XzvJnVTLrBYVpOTAc+ZhatP44nfaM95UhYusMF3D4KDQ+HOvDHk+dHukc7K7ZdatJ+3neqpJMelmgzW5kIAks2T4SrEis4NgFd2/Uk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,Muchun Song,

Thanks for your review.
I've updated the patch to v2 following your suggestions.

This change is only a local cleanup for this specific function, not part 
of any large-scale conversion to use the guard() mechanism.

Please review v2, thank you.

在 2026/5/12 17:10, Muchun Song 写道:
> 
> 
>> On May 12, 2026, at 16:55, wangxuewen <18810879172@163.com> wrote:
>>
>> Use guard(mutex) to automatically handle shrinker_mutex locking and
>> unlocking in shrinker_memcg_alloc(). This removes the explicit
>> mutex_unlock() call, the goto-based error path, and the redundant
>> ret variable, resulting in cleaner and more concise code.
>>
>> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
>> ---
>> mm/shrinker.c | 11 ++++-------
>> 1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 76b3f750cf65..1274130323bf 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -222,22 +222,19 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
>> if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
>> return -ENOSYS;
>>
>> - 	mutex_lock(&shrinker_mutex);
>> + 	guard(mutex)(&shrinker_mutex);
>> 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
>> 	if (id < 0)
>> - 		goto unlock;
>> + 	return id;
>>
>> 	if (id >= shrinker_nr_max) {
>> 		if (expand_shrinker_info(id)) {
>> 			idr_remove(&shrinker_idr, id);
>> - 			goto unlock;
>> + 			return -ENOMEM;
>> 		}
>> 	}
>> 	shrinker->id = id;
>> - 	ret = 0;
>> -unlock:
>> - 	mutex_unlock(&shrinker_mutex);
>> - 	return ret;
> 
> One small thing: since ret is no longer used after this change,
> it should be dropped from the declaration to avoid an unused-variable
> warning:
> 
>      -       int id, ret = -ENOMEM;
>      +       int id;
> 
> Otherwise looks good to me.
> 
> Thanks,
> Muchun
> 
>> + 	return 0;
>> }
>>
>> static void shrinker_memcg_remove(struct shrinker *shrinker)
>> -- 
>> 2.25.1
>>


