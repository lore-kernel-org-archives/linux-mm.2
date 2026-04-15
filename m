Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D4AF531E3
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121446B0092; Wed, 15 Apr 2026 05:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3576B0093; Wed, 15 Apr 2026 05:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F1F6B0095; Wed, 15 Apr 2026 05:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E49AE6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:04:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AE09160410
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:04:17 +0000 (UTC)
X-FDA: 84660203754.08.CAD6070
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id E04D114000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:04:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UR3usZWN;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776243855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZXCR3v/1e2hz4wXUuiewvZGR4/jMr34Rcd+pZEUtH0=;
	b=JhWDybXqrbYrvwKCwKfjoyQulmN3CYdC0K0PB/ho78x3WO2aXyl3CPJhIrumdX45XEGqUC
	2bs2YJ3OG0VUbE5U6fSaytQ+VwK1HSDNroS6CdRrGr51icWH9mMgEun94Jk/f3FtN6S+ez
	LvluP95rzca4CF9RZAXUoycePovG0tQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UR3usZWN;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776243855; a=rsa-sha256;
	cv=none;
	b=gziO8BiOi4Wnx6t8BRRsxSO/H79TvL/l0vjTh4YSjEi2N560dO2EhA10TtanKTRWpvslib
	4nVxDMxu28Zai1PsTvdC4G5QFpZ40ZjA4bVmjyKlr97Pel+cGFSkfkGT94uEM0W3zrwi1J
	Un6FS1mLgbu2gAMdbTkFRfZPwf881NE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776243851; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WZXCR3v/1e2hz4wXUuiewvZGR4/jMr34Rcd+pZEUtH0=;
	b=UR3usZWNaX7XSItQyyHx8cucRuF3f0BhiWAfhfwcFo5vySPLUvH4013YkTUXMrXldV6f8poIv3bqIBoEhA95lG5+to28Kw/bF+y2qAJ49Td+uC3ldaA7w/KYXU0Tk/ScLlJsjDbGCiGblAMY3/fecVc8p1nwE23/pAf/wYM/j4w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R331e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X1448p5_1776243849;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1448p5_1776243849 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 17:04:10 +0800
Message-ID: <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
Date: Wed, 15 Apr 2026 17:04:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3h3efknuxw3kjd1zpdigo4nnnroyrk43
X-Rspamd-Queue-Id: E04D114000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1776243853-751078
X-HE-Meta: U2FsdGVkX18+/QZK3uFjewWSBuAgCDvSiMb+qDIBZiths/9JiSwuzNj3iTJ2YRdI8uJXC/BbYSgBynAf/HmZAxx3rpiGTMf0jujVip2NGovs+hYraODKzqLZkZihzKEuNUhWumLgCabi8lkRoklvpzm3SPqdqSyw23qfdxJFsXarP9XR1TrxqJQ87GC4jLdYVI/zpKFdUDzcJyOs1ptc00NZJtg9A0sglSdOnXx0L8L2qPamHiPMtiF7nscMCmrpi7xLvm0b1Nx/8IHu6sxzYCu9kVh4w3JGuusepNtOosoShDT6BagZb/Tp76nAbT3lzThmOMg2Kzcx+h1iLm+akROJw+uOYkt1UP+ZuWuPH9w9c8qu9h680Aq8oAII2HgYdCvzZBkzfvWI8IEKFtvi/iFQozBRYf8NUFRvmBkzgclbeEZRSxr4FZ+RNaoWKX2nv6+ZSoQ+Qcsyz9To7kn4BZ9Zhl8fXWFgzY1ttbVgHzwjpaVGV7VmLl9BOqtmOPvgo4AbHHVom7BOkotdkBuhcwD4Vw5zLkRSKfnIVKgdmSRK6roesLI6c8firiXbcn9aU0fu1HVTC1hs5/DqQMp30a0j02cTNtGLccGZ0mwgk/XWp7EvQ9L7NVDryutj+1N0oWUi6IYgkUpY6cyI5WU4x4EIE9DBetrfBsbNB/keCxRF9ZWtCLkhJp6wFjVFzMRShJ1JEifomiwKajkuMaXWKw6zcTtDjiUpm5ENeiBk7ub/uZY5pYeRHCgTpgy7kKD3+dDJ+XkszX091XRqIpVqKNNzSsnqWE69KLdW3nUUmIiNMwvNDyRM9+BPu4X2MJ/vcEcMBEoUrVweqMroBimt1EaLWwlJ1J+l7vPyQEsD+azgfImumPfN6e0Nm2XsV6EEpepjzfuAe9IpzYTFtHwoRSm8PHZDy28MYaJt46gSc786HpklUAlUPNNpgWvFnJlUsGU1lnKM7TVmmsKruDb
 fw1LmHuj
 NTEZZ9WpIz2Hc6SEEAI4Teeky69Nsi3o838XagltzMq5FsK6ehesmhTdGOJIL/AEVQ7iYjrtrax3eSi8VU0PGCzriBd5fecIj9U3oQAv06DGI3K2ooIQmbnEiHaNjR1o5T71okm6r5MU2mPC1xVGs/weXcO2gg9+8lSc+6OMvXrXMxEjBo31Ekv5Tr9AmR+2NL/paCimcjbj2CLmga+WpoTfdFptTioGzJm01MFIw76Ll7vwSItp+9gihzog4x/oASdHaXzOhH2O8SfSOgXtxPqCNhZwcDi1+nvrz8Y631ALEdmyQdTS7HU0MPrUfvbuodQLn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 4:47 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 10:22, Baolin Wang wrote:
>> Anonymous shmem large order allocations are dynamically controlled via the
>> global THP sysfs knob (/sys/kernel/mm/transparent_hugepage/shmem_enabled)
>> and the per-size mTHP knobs (/sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/shmem_enabled).
>>
>> Therefore, anonymous shmem uses shmem_allowable_huge_orders() to check
>> which large orders are allowed, rather than relying on mapping_max_folio_order().
>> Moreover, mapping_max_folio_order() is intended to control large order
>> allocations only for tmpfs mounts. Clarify this by not setting a large-order
>> range for internal shmem mount (e.g. anonymous shmem), to avoid confusion,
>> as discussed in the previous thread[1].
>>
>> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Changes from v1:
>>   - Update the comments and commit message, per Lance.
>> ---
>>   mm/shmem.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 4ecefe02881d..568e1baee90d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3088,8 +3088,16 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>>   	if (sbinfo->noswap)
>>   		mapping_set_unevictable(inode->i_mapping);
>>   
>> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
>> -	if (sbinfo->huge)
>> +	/*
>> +	 * Only set the large order range for tmpfs mounts. The large order
>> +	 * selection for the internal shmem mount is configured dynamically
>> +	 * via the 'shmem_enabled' interfaces, so there is no need to set a
>> +	 * large order range for the internal shmem mount's mapping.
>> +	 *
>> +	 * Note: Don't consider 'deny' for emergencies and 'force' for
>> +	 * testing.
>> +	 */
>> +	if (sbinfo->huge && !(sb->s_flags & SB_KERNMOUNT))
>>   		mapping_set_large_folios(inode->i_mapping);
> 
> I don't like that special casing. In an ideal world, any mapping that
> supports large folios would indicate that.
> 
> Now, which large folios to allocate is a different question.
> 
> What's the problem with indicating for all shmem mappings that support
> large folios that support, but handling *which* folio sizes to allocate
> elsewhere?

Thanks for taking a look.

As I mentioned, the original logic has several issues for anonymous shmem:

1. Whether anonymous shmem supports large folios can be dynamically 
configured via sysfs interfaces, so mapping_set_large_folios() set 
during initialization cannot accurately reflect whether anonymous shmem 
actually supports large folios.

2. Calling mapping_set_large_folios() here by default makes anonymous 
shmem support 'MAX_PAGECACHE_ORDER' by default. However, the range of 
large orders supported by anonymous shmem is also dynamically 
configurable via sysfs interfaces, which could cause more confusion.

3. Currently, no users will call mapping_large_folio_support() related 
functions to determine whether large folios are supported for anonymous 
shmem.

Therefore, rather than having anonymous shmem call 
mapping_set_large_folios() and introduce so much confusion, I'd prefer 
to exclude anonymous shmem from calling mapping_set_large_folios().

