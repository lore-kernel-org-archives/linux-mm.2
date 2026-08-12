Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357D5C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D626B012D; Wed, 12 Aug 2026 06:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DD06B012E; Wed, 12 Aug 2026 06:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD9E6B012F; Wed, 12 Aug 2026 06:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC526B012D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:52:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 869BA140290
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:52:42 +0000 (UTC)
X-FDA: 85092304164.10.D68F5B9
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF6A814000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:52:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U0vSnTAg;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SXNks2tZYXAMlHzcZVIQbNtii10CEKmrX+VrYK5fTo=;
	b=g0oz3Z562c74tusCypdjIrxogEsLblCX8ZHc7cSXJbDjB6awv1sJ+nGmSgQDTuwuZ2hU59
	Xs5eMItXYgg2iyEAoXIfOCBfGdI2oekH6nwnPE1wJeY06hoVcnNZZ01z6ZJkFwgitYpAel
	HP6nhh06q+QKRHOc7QkRiFOeLiS0p+k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U0vSnTAg;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531960;
	b=lHWYhSl4TiE7XCzIpglRIUGsAAczJBf46NVRWBhRtsZX8qmZJPkIe6ZXRMqXHsUa7ELw6+
	ALGhc4X+i1+AIW3LtD9qAWMiEBaxV3gYT9d8biqvAAAN6B8dABH8JrjLmbzWjFqfIN5E0t
	Os+ID6NAuUOQwOSBo8CJLtMBqv5IC8k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786531954; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5SXNks2tZYXAMlHzcZVIQbNtii10CEKmrX+VrYK5fTo=;
	b=U0vSnTAgPiSpgi1EHOsSRUh6lWjwd4P/T8CIlObPHeLZaHxVHyK6sGU3qNZlNZDrfn7zFk1DQ9+1vJXTJ/0FOCT38BP3/7M6Fgf9r0vQfrXP+l9CI+L6RTYk4Wkbimqp3FAjeUry6DBvzsZp7h/k52p79j3/AgM1OXytv9RGahs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X8rQc9X_1786531950;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8rQc9X_1786531950 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Aug 2026 18:52:31 +0800
Message-ID: <6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com>
Date: Wed, 12 Aug 2026 18:52:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-3-husong@kylinos.cn> <anw8ASKdPWW9v86d@lucifer>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <anw8ASKdPWW9v86d@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF6A814000C
X-Stat-Signature: 6nrmkif379tnoindtenj8cn5opwhchga
X-Rspam-User: 
X-HE-Tag: 1786531958-522615
X-HE-Meta: U2FsdGVkX18r11CscWEaT2l8jy6keg1lgoYsfUL3pWTH4tJpf7KVVNGX8UPx+qudLNjUoyqXYoyFUC64oR0Ki3guN8i4Bk0OdkFo6JYO/XsX/WqGe/d1Kzc0ImXhcT+9RCNGcxgJoK6sLFWmeZALCJYCwUjNJvqC8vfHiYkA/YAW8WKQacSYUKNKa77yDxOKFk3KsljQMUJte+5zG1zR0jUj7wEGowz5+4v3H77DR6pEjXsfsaAUxLgYwNjmo7ZiYRKbkhJ1ddLwWa3bzWawcQuIlLJrmrrzgNs6/b0t2Mpvze736BOscS7rAhgPiFIUHIsbu7M3rJaCAvsWFR+gyHdzLHuWk8wWBCQo//UpVU4H0d2ykIDjUT0uqVOCTpA+rVaRv6arpjwgtPqNgkkTia5l9U7LX6mA1sFEm4fT5MJB9FRqL1qVvejbQYGRJsqQN7qZJYXPTwAVt4tEYdJHYPzUw2BblbdlRdHqShi2JbiRwZvQGsP6w43GPrU1tt05Okpk72e74IQkKItuz4JkWlyoSGy1s1DbSFaqrrKyrqVxLuxd+t5WDiuLJk4DTvxSiT/ZPVYhiHYAf/GurOzWsHsysNKHmWwyWVVP+zXgxxTyToPN99TU/IdG2OaGv6LU0LHJfMvYLKECR53RMHcrBnp7b2te2k7a3K2epnO9nqKQoC4hxhplq/cOb5GvupnZPoyFqFLWfFyvYpJhifsn9lomIBei4eGg/UEbFPg+Cd9GOcZej7FM3qHoxXd/lQS21n5fi5E7uHi0ZEb2n1CL1sNC/naulJj4sDjj8V6R3uLWcQ8Pd7dndmePedJllKJlGCITlzvC16CWCKo/RFQRl0IJAfp0Tim1u4z/nk4ZCPQbXO8TZ42sQWDOzW1/7seKsR4HlKh6sunwj3Gr44xsVmwaLo8uNo/XJj35Bz2HkTcPwrS6H/JvmtO6EIoRh3Xxy6fn2tSWwiPBddt3I+p
 TE6Rx6FU
 86HDspVoVXrHeNpZgdPgxN+m2aqtPBu4w08SA0bnJ8P+p9sMsCRJAi4kvnSrvShvBYj03cad0Uy4gKtgY9gEAh43q6QmC12/ENWNWDZER5yfCmYpUzhP84jxdTGMOqd/K99kNKnqsNh74b93jaunU/SYV2wxgaTtFapkJ3Pk5bCS0Iy+cald75SFyJS8lwm4LiTfaqUnJjttMK1X+QqAYlyPaRIUM7kTSZJ7SJPIsJ0wnLyZxlg6Op9FgcIUxDZQv0Nq00k/RP98Pi0hvevcqqrfATKfJX4vOix2o0sgfZ50JTh7jWdHYjpg8KHZnG/MtswAS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/26 5:27 PM, Lorenzo Stoakes (ARM) wrote:
> On Wed, Aug 12, 2026 at 04:03:13PM +0800, Song Hu wrote:
>> transhuge.rst claims seven policies for transparent_hugepage_shmem= and
>> four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
>> shmem_parse_huge(), which accepts six: always, within_size, advise, never,
>> deny and force.  The "four" applies only to the per-mount huge= option
>> (shmem_param_enums_huge).  Fix both counts to six.
>>
>> Signed-off-by: Song Hu <husong@kylinos.cn>
>> ---
>>   Documentation/admin-guide/mm/transhuge.rst | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
>> index b187d618452f..72e944f49da5 100644
>> --- a/Documentation/admin-guide/mm/transhuge.rst
>> +++ b/Documentation/admin-guide/mm/transhuge.rst
>> @@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
>>   Similarly to ``transparent_hugepage``, you can control the hugepage
>>   allocation policy for the internal shmem mount by using the kernel parameter
>>   ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
>> -seven valid policies for shmem (``always``, ``within_size``, ``advise``,
>> +six valid policies for shmem (``always``, ``within_size``, ``advise``,
>>   ``never``, ``deny``, and ``force``).
> 
> I'm not sure we really want to advertise 'special' testing modes like this,
> sorry. These are not modes anybody should be using in practice especially at
> kernel boot. We should probably stop people doing that...!

Yes, 'deny' and 'force' are testing-only configurations and really 
shouldn't be exposed via the kernel command line. I'll clean them up.

