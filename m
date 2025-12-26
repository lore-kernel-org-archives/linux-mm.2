Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E3AE8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BFC6B0088; Fri, 26 Dec 2025 03:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9C66B0089; Fri, 26 Dec 2025 03:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016CA6B008A; Fri, 26 Dec 2025 03:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6B2C6B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:31:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75A455D67B
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:31:25 +0000 (UTC)
X-FDA: 84260952930.12.503D919
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8F03D4000E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:31:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PPgFFT5V;
	spf=pass (imf04.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766737883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MFpTUQOIiVw73r2AMb2gz8612oplsZa5lGVUR7l7Qo=;
	b=bWBcZJjDnlBOF8NXH1rtuNl9vKA6g3i2keInX3+fLyjvoWyXQ7nuT6sw6WXmdtGSv4A6zm
	UlMAYYfTuWOHA0FNEDfkK1T9fciTvFsoW2M2rbl2BqapMOgJ4V6iqVamdfnwzFjWZ+QnUv
	oZRP2uRXDlBcYC/Jz4WXQuraJDLxv8c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=PPgFFT5V;
	spf=pass (imf04.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766737883; a=rsa-sha256;
	cv=none;
	b=brIlEu8TT7MTvsmgDNzyxLpUtAxFkdylD0fWFvT4JfBVD+pQns479YMarSK4L8DeNgcOEy
	PeZg4DKs3m1DcKnulo4QmFhNMsEfjO0YfGxzM7nveJfAVZWWUaCFJrFK/+hLjBXmfg5T9i
	RiTbuOxKglrv65pvyGzd8Hl/FSkMBa8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766737879; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6MFpTUQOIiVw73r2AMb2gz8612oplsZa5lGVUR7l7Qo=;
	b=PPgFFT5Vlwp/Rn3NYafmyQ79tK8axAsDHtRFTVNUJc5em/uE2OeGh+iZcvgGxdKUxDFwbtnA6aXBQN6eTcE5jRmI49Nrnfck8WTkRaqaK4JMmuQ/hUNuI0tJaSlcHFs+FPTCcoE0QQZeq6tlV6D4gG93n1J+QL+DbRo1mOzKcoo=
Received: from 30.74.129.66(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WvgxF.J_1766737878 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 16:31:18 +0800
Message-ID: <bb9592cf-bb3a-4679-8dfb-973fa6e84bad@linux.alibaba.com>
Date: Fri, 26 Dec 2025 16:31:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm64: Kconfig: enable ARCH_WANTS_THP_SWAP for all
 pagesizes
To: Barry Song <21cnbao@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com
References: <20251226063759.4020782-2-tongweilin@linux.alibaba.com>
 <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <CAGsJ_4zd+SMa4Mj23tjF5OwsP3LQyvYTrwN4y81=k8FSFgbH3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dsg6ufed6s97kkwraut3654h51s3fxa7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8F03D4000E
X-HE-Tag: 1766737882-667806
X-HE-Meta: U2FsdGVkX1/OnKJqmW4dtFsBUjx0txb9WQjRWkb5Pppf/9eN0VoPQq4GjEYBa/0lqbWjD4Pi3GWKwa2whm2Yy3XmR3/WMCsgsmC8BXlQv/4M53jIK+7mUNmWP21A7davMhut3CSDZtzBsgwhqHaY+nuGAL+Rd9ib6COEgiCFN4qLy/+6sy64Reb1+F+OSzkrB+dUvfHGgGHdEr3tMW4HiM/JDpoZ5vnLoOiWaIykG+wPChKhRUad8KFPCmz/OLazQhoNArnDLUCAbzEOliCzbPsZojV/9w2dDpqsEPN3BraC86CwBjQ5E5q2cDlPJDxiSC8e+aESsr1A6BKQetcIMI8uJL53p7/c0mHecD9tklLv9MZjCU4cSx7yipblyJ4U0M5dUT2Zyr9wSPy2OIvzzBxtLgcMWW3PawwKZKBo/ZC+5y1jHx0oK01roopryfyEwhAIgjC1dKCjVnOAX86MuwW+KLa3NXNIIePF1ofHMX30X6Y16ozq96TZNm0TdBl1AAQ+BCsUUBtiS+x6rqxqZ7orGg5C0OH9pK8A8HIlMxlw0kTZ7cdVn6QaaeGIRtHmmFgwXzLJABiN9Fks+v0ndKPHqjxaUN/lktTiyaINRwFz1NmP/L95Eqpbyl7kOoIZilveEPZEF/xeTnFGfX4cj5mMfWhJ+9qK76UAfEUxYW6IRiQ+NOIBWQr3NXvt+BeUJKD7VBXX0DzlT18SUvQsVyJygE13wMaD8Wrx0XDYDI/GuICrXES52NiBuMncXhxw1ya24jtK8e6U7bUNV0EK9QAVXe9Fc+NAoAns8GVSp99dg+MwaTpgzfXnWTgzklh9cnBsUSAVxiBNiUUzKx2N0PWgk8n9bfuTxxHJT0lSUS4QMyltzoxjZ0sVl9ymFmBprQ8hm4k4fvOMOOJ1w/BFN0u9Eei7YnNZslFbRxxXQuihjHeNfwm7Rx8ZuYrCpAuAp+fGJyr9iD0Fko9Ih6r
 LK9NXL4f
 Hrx5RMq0IRqbaendGZU1q78uQmB1szwwlyvp/uP9KUkh3mczPgO9uDG/0QpPeTU9LLnymPBoPYM135lFJqjbbDqx2Ufu/9xmNP22rqlKe8r1YkHjAN+xhhPY8ixNhAyrVpZ0dRdMAWUGEwyXA/7OMrGyBIT6TJBnVm736R4+C8Kho9ytLaZWxN4xTQzAolPtFWlGcvZsOWVn4KV4KJ8oFBKEmAptlMSnBJKHEDyGfR3vZQPoyGMHSvHbJSM0kYGmIOtBdlTYyf3I14HRGsNP6HH1f/lKrQj8hyipN24XDTsByQD9ZZSrvJJ0MDlYL+iQz3MXbnDkcvdnKeg2sSi+op0P3+S1SjQYleFrNzG5BbwvlJa0QiyZK3gTKEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/26 14:52, Barry Song 写道:
> On Fri, Dec 26, 2025 at 7:39 PM Weilin Tong
> <tongweilin@linux.alibaba.com> wrote:
>> Currently, ARCH_WANTS_THP_SWAP was limited to 4K page size ARM64 kernels, but
>> large folios requiring swapping also exist in other page size configurations
>> (e.g. 64K). Without this config, large folios in these kernels cannot be swapped
>> out.
>>
>> Here we enable ARCH_WANTS_THP_SWAP for all ARM64 page sizes.
> I no longer recall why this was not enabled for sizes other than
> 4 KB in commit d0637c505f8a ("arm64: enable THP_SWAP for arm64"), but
> it appears to be fine, and the swap cluster size should also be
> more friendly to PMD alignment.
>
>
> #ifdef CONFIG_THP_SWAP
> #define SWAPFILE_CLUSTER        HPAGE_PMD_NR
> #define swap_entry_order(order) (order)
> #else
> #define SWAPFILE_CLUSTER        256
> #define swap_entry_order(order) 0
> #endif
Thank you very much for taking the time to review this patch during the 
holiday.
Wishing you a happy holiday as well!

I appreciate you pointing out this optimization. We initially noticed 
the issue because,
on ARM64 kernels with 64K page size, if large folios are used in shmem, 
they cannot be
swapped out as a whole during shmem_writeout() due to the config 
limitation, and are forced
to split instead — which is something we wanted to avoid.

It seems that this change will help enable better swap operations for 
large folios.
Thank you again for your feedback!

>> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
>> ---
>>   arch/arm64/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index 93173f0a09c7..58f7b4405f81 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -120,7 +120,7 @@ config ARM64
>>          select ARCH_WANT_LD_ORPHAN_WARN
>>          select ARCH_WANTS_EXECMEM_LATE
>>          select ARCH_WANTS_NO_INSTR
>> -       select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
>> +       select ARCH_WANTS_THP_SWAP
>>          select ARCH_HAS_UBSAN
>>          select ARM_AMBA
>>          select ARM_ARCH_TIMER
>> --
>> 2.43.7
> Thanks
> Barry

