Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D54C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4916B0092; Fri, 18 Sep 2026 04:31:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC3B6B0093; Fri, 18 Sep 2026 04:31:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA6D6B0095; Fri, 18 Sep 2026 04:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1309C6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:31:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 18EA21C28E5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:31:40 +0000 (UTC)
X-FDA: 85226214360.11.034A9C8
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63411100007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:31:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WRghnYYk;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789720297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGJV51rngyzKywv8yDe/42c8NOW0jQAbCo5gyMHbDMI=;
	b=l9Pvsfj0pufx9gjabDKDgUaGN90GMOaulipm+iRk87oI0GMuwapVwlnjS6o7/wBB5LyPz8
	gccVWjOQM51OzrSsl78gKFLnrQ/oo6EYWH2CwL3iTQwqfSMp60i0AiWbgB+R3ppgsTILSN
	+QZDipy7PFgYYHQwaEQJtkPWvkmlRtc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789720297;
	b=h3CLhMg6rghpup9VSHSKZ0jqyzdK9ph3e7YngGKrRmlbRVc9tdUO9wl+RGhwBY7O3FLpgx
	qAGsmxhBTJyZkEsT+cICzfs/p0V6kEnrg4JEWeEtwkUG2xL7kFzgxTi1dfqY2gbb9BkS01
	mpI/vEENIKYoPWYD9TECFg6EvXTtlEU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WRghnYYk;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789720292; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=FGJV51rngyzKywv8yDe/42c8NOW0jQAbCo5gyMHbDMI=;
	b=WRghnYYkw5jkqencF3djTGbhOVhH72Nr1o1FiRECz1ltM3L5YK/cjxQciMN2tZ+tJDGQ/JXJycsbC/5kw865QLp1U//e9F5bdPzgIErL4EJYI0xLK3ug5vd10uliZf0j9Z6LZBpYwOh3WCc2VVZ2/AguEY9WmTrPJhNdFqcfIqQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XBAf9VQ_1789720287;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBAf9VQ_1789720287 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 16:31:29 +0800
Message-ID: <6c9d4520-188c-42da-841a-fdd160fed008@linux.alibaba.com>
Date: Fri, 18 Sep 2026 16:31:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/12] mm: shmem: don't expose 'deny' and 'force' via the
 kernel command line
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org,
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
 <eeb806b057f2097a4d8d2edcb9ccf850aad8f38d.1789701677.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4wRWYx8QkBNQqLUDwcBr014dErSqj4mmwL6u+3w7U2QPA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wRWYx8QkBNQqLUDwcBr014dErSqj4mmwL6u+3w7U2QPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: w7y3us6khibb3irujt3qxjntegk1dnwd
X-Rspamd-Queue-Id: 63411100007
X-HE-Tag: 1789720295-262606
X-HE-Meta: U2FsdGVkX18YmcCz5V+oy0U5IK8k701DKd+8qRxFP+xRlROAJ4fnxzSO2r7dzSgztkqnlRC2M8q3947V1cUv6CB+//C6JioAZsaNm5o9vIQ33KNfM9meUsJdviD/sGsl2bp511nn+eg/xrpK87b6e2j6o691ufDCC0FRqUJSetVl0WI6S7N5b3BjQfMR9B1JOz6edaOo0YxQN5G4+pKTBJlHahBKkjAEg80Now9WFKWCI/2fCLxgfHgD4g/hxIXkI5D2Vmo5c1UsaC0ItDpiByKiTGomaEOUxjeXiUyDdGwFnYlW85mvOF4l3KRxfmHYYLZ3FWNUZ/GDjBBMuhNFvcVHYRUboIMIvJIEjc5viAZCahb3mE2boNpH+VlMhnAH/K4agbnJk2rNl1O+/C4j/3/gnsZFx7RWqYWm5jrRVwGgmj1vOdDsbTSMatxi+qLmKOpyvtzWdv6xzALVZpFSYMnPWNES2k1Mj2BsGbHiqXjBIsrYRPrCnkthhabNMgPu9A/lzBwv7Vh6JeFHqrtpCBOKIBtsM21pqllDtYZmhNitCWzUphhhTL1SORLzhFWotCUcytesIHy9/qaUA5ZD53dPmQSfDahI8Jr/J+dWKOTgNzhHU1fSUpSI6Q7OB8FhPZXJ4Q4qle+wfYHNaQYmB7nD73M/Pr1QzF5qMDiE2bJz4iKT7cLeHVYKgvKycXrrjnrPFAqO+fIoetx7WzbPjKeJmuy+tDDPkEoyYGurkKPcJSj+Db7L+p0yUpvnuia19lgaYH+dXR9bbZQ3jOzlyWiEp4eO1p50EmQhkd1Jm1zvNSLr0aoB/UnHXvpQCUS169NAfgr5ainUiwhHPJtxAioGpLvMzZUyQqwOGXZlalKsJzc+6h4VR0ruVsKliXEakaXCZzyiJM0R5JBL3HmnBJ4m3ZdhVZXtTXWt9IIA608wqMXHaTfQBqfYmWOP3LhV5FA99d5/bI06JYWBSQD
 lLIrp2hr
 aOmNGl47Q8uujTpjAfIxsCnOqNq88qzI7qfR/sj7NATO4h+D2zM89AZWSfwg9wXLUUo6Brp8eF8a6Vkn7ipisu/yq9pHFzbqBm6dVjF+n0PTXtar7tAckrvoDWhdIf+jsiF7uj48ARiqSRP3xONDBp71LTUQ+IQa5iQtPakmS/ZkZiI0Cagr/S3IqqPMo62/Bn2eWFtJhnzZLOZWzN6Be2UiTbAxGhlob7yKcsINeGVMMbYJOBlzt4+OXvtjO1RnScr9a4L733SoNsSnN/1Txk++6b+7IdO8BJzyD3NQzq+WvGIX+q4LFaQkyXHy4ea4lAiCv8x1RQUbhSRVgjhqks1sO/uFpSCtRsBGI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 1:45 PM, Barry Song wrote:
> On Fri, Sep 18, 2026 at 11:58 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Based on the previous discussion with Lorenzo[1], the 'deny' and 'force'
>> options are testing-only configurations and shouldn't be exposed via the
>> shmem kernel command line.
>>
>> So drop these debug options from the shmem kernel command line and update
>> the documentation to make this clear.
> 
> If it is a debug option, it should not be exposed through sysfs :-)

Ah, let's keep it compatible for now.

> Maybe we could rephrase this to say that it can only be switched at
> runtime through the `shmem_enabled` sysfs interface?

After the changes to transhuge.rst, this is essentially what it means. 
Anyway, I can make it more explicit in the commit message.

>> [1] https://lore.kernel.org/all/6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com/
>> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
> [...]
>> +static int shmem_parse_huge(const char *str, bool skip_deny_force)
>>   {
> 
> The name is a bit weird. What about `allow_deny_force`?

Sounds good. Will do if no other objections.

Thanks for reviewing.

