Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C11C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 18:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9AC66B007B; Tue, 28 Jul 2026 14:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73F76B0088; Tue, 28 Jul 2026 14:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963C86B008A; Tue, 28 Jul 2026 14:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFD86B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:55:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA3D61C0C97
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:55:58 +0000 (UTC)
X-FDA: 85039089996.19.17C7111
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 061681C000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:55:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJkspsqW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785264957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyDi5xQA1AMyz6Holti/bfjxIF++j2+pJzGhsHUHlqw=;
	b=6iwAF5S9TiFfLUF84dDYoTPEtEok8vA9sqrmSlWHuBXIPcDvF5USEcvK1RFSF6BxVcCELQ
	7E8BtQqHUbSq3IK9JTwlxggPK8e7dK0UiG83RLKFcxRv0cYwl0m2QJP4vhLfLqFrN3tLex
	ZjSUNuXAL1xyi7pgkpr8gPBUJYDHZVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785264957;
	b=LmmOyM52s+CpzwsKZYJI/YSzXhtTcqW5f3N7o9zuetQcuJCOl6RsujmdL4oF+deeXpbrre
	mQTibx9SjQNg8kwW6wF2xlerlO3tJiwEX3kicegEsHmANKv4qKwEQDOup71OtLOnxwUewH
	QoHe4IHuJqOnGyJPBgrHcgR+jG6I/bQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZJkspsqW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C98F540BC0;
	Tue, 28 Jul 2026 18:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390521F000E9;
	Tue, 28 Jul 2026 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785264955;
	bh=xyDi5xQA1AMyz6Holti/bfjxIF++j2+pJzGhsHUHlqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZJkspsqWXjWjFcbFYiktTjt1XKmKGc8738BdLNGQ0FnV5wYHoEdUZuY5EJmD+ATGF
	 R5AZmBSuh+BLQNox+qjFxERXMl/iNswBFSN1mJ8hA2GxfsnzZdIGTC+S4lE0ypvYMp
	 E92zF7hQc3nOn7QX9SMS6fFLOyF5bxw2Q3ySZeErMn7jJo3mzXbB8yGysJQAiAjAIs
	 5yUuNU/zKJMz8755pkFjLE3dGh6Paw3Q0J4QX93kt+jantx2f8LQqtMPJfzJcUvF+I
	 lthrriD7UbeIE3no9F1ZfV6tPuujFJoxald8/LXO9INq+L3V0baPqZQtrwB1XtwG7w
	 k3Pdsz5VRQiOg==
Message-ID: <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
Date: Tue, 28 Jul 2026 20:55:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, pratmal@google.com
Cc: akpm@linux-foundation.org, vbabka@kernel.org, sj@kernel.org,
 corbet@lwn.net, skhan@linuxfoundation.org, anshuman.khandual@arm.com,
 gthelen@google.com, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260727230545.262579-1-pratmal@google.com>
 <amiN82J8p5z9l_Rm@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amiN82J8p5z9l_Rm@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3oi5spoebiyxzrbtbxoybeskazmi59eg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 061681C000A
X-HE-Tag: 1785264956-897303
X-HE-Meta: U2FsdGVkX19HMV/cSKBhdFyn5QUs3NVeh2Dk4nwBAJkigQmjfLlYW4ENFBZNis5MOmIUYKWTy/MeTw3s2W1OKjcWF9LaKa+wSNNus6eJOJdwu+4sOks245SJ5YwFJX+cAzF7RFlvSujNXchspFZAQNs6kKDiF9qX91BGWOKbF69w18R7HoZ15FJC1UYtE7S88uIWWlBOopTd6Q6wLW9zt4xgupgWw4I8ySrQVXUCulRgnwn64jI3408cUy71Atfh7zrjYzwp9aX1RWDWFks3R5oEcgc9JAMqYCieJo+xG5UpZu5moPpyVEbfNuitkJuU77yq8c0oTqBWaTrey+iN+1nKx2reJ+pTwSItuDzLXPt1hUoGGE4AoiNVZWLURdPzlKBdfmdOvpqzG9xSDdaZrJ6USNBVPJR4ziBEuhaORqFm4VBv9UyZhbq4sPJx3i+na/w3M6JhrM8z7fZFWtEOm9BvX22lyhH3/PvdzAnJHNxlgg+kwmFNzY0XtsZ7OOU7AdQ5za20KCZjeknVrA6y7f2SwChjuoYthf4XAIQlsYXYccdAJ83YfoHVdTVhFH0Hr8qIRMjWZ7wALpmhOLk2jOaB4By6YcCO59LZbojl2CjY1dx9fkf6TF04m7evYBDnMosMSPUOcjHA3yj0miJG5c9SWZtoTeqVXKB0mzf1N2PFb/YTs3UcNw+/hyl7pWkD7kvRb/CMqSpN+hhL7Xa4jK0bFoGwT9F4Y+QOerFa++6yyO3kxwf5v7AcWOMNhMjURth5hoehNAC7G37HWlh1RbDnWQeMBzhvmqAbauLCgGshiz0CnldL5q0AXk4RywfDJDNtCr2yqb0SJLtjEYCYm34CzvVXgJ7p18QJoRDcjIvY28cpixIBA1tCK44uyyxCfnxYq+XNKR/ie67+nsawb0OSqKZ2Q5B2h+MgYYh821gqlO3QP2/n3+96r9jMOpEkXTjQrZtG/pXw1tX7UCb
 GG6GYXEM
 M5B7ccp9lRmKzImp+h/ypAL0H0JefzzmypXknzSfd02FzDORhNOZeg/0gNKcLmRhEh4vmIZjR8b7Kshwwhf0yrqa1VevCF9K8AuoU953XaMY3nyIDEHj8yQYEUnUpHQnmgn/rXCTrQD19KVI1MAUn1XNVEkbXNH+nUbVhLAQjox2o14DLTId9LteEQ1MKDtheTK3smXcnraIwN9tYJjohGmo0DbRdulVnJHBE2uu0y02aCOmDNArIqLzBDJvVT4nCYw8Axa+V+pt/SIi+13TCGJwKIVAN2cFQxCRSOlD/16mlS11/nMWE5UbKDV/q/96eaF+Qxp9yHUeCfqRA2wYIXa74PzIxGSdZ4aoL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 13:13, Lorenzo Stoakes (ARM) wrote:
> On Mon, Jul 27, 2026 at 11:05:45PM +0000, pratmal@google.com wrote:
>> From: Pratyush Mallick <pratmal@google.com>
>>
>> Currently, the free page reporting uses a hardcoded delay of
>> (2 HZ) between reporting intervals. While this is a reasonable
>> default, it lacks the flexibility to adapt to varying guest workloads.
>>
>> A low delay allows aggressive memory reclamation, returning unused
>> pages to the host as quickly as possible. However, during spiky
>> allocation/free churn, this immediate reporting can lead to a severe
>> performance penalty (nested page faults) as the guest re-allocates memory
>> that the host has just unmapped. In these scenarios, there is benefit
>> from increasing the delay to batch free pages over a longer window,
>> absorbing the churn without hypercall and re-fault overhead.
> 
> Since you're talking about increasing it, maybe set the floor at the current
> value of 2s?
> 
>>
>> This patch exposes the delay as a module parameter:
>> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
>> in milliseconds and defaults to 2000ms.
> 
> I'm not sure this is great as it means we now have a parameter we have to
> support forever and autotuning becomes harder to implement, also if later the
> implementation is changed, this might prevent a reimplementation.

While I'd prefer to keep the implementation as simple as possible unless really
required, I guess auto-tune could be enabled by setting the parameter to e.g.,
-1 in the future.

> 
> Have you considered actually adding logic to detect the problem you're having
> and delay in that case?
> 
> It seems like this is the "easy" solution but it has a price too.
> 
>>
>> Signed-off-by: Pratyush Mallick <pratmal@google.com>
>> ---
>> v3:
>>  - Converted page_reporting_delay_ms from a sysctl to a module parameter.
>>  - Dropped the max value cap (PAGE_REPORTING_DELAY_MS_MAX).
>>  - Documented page_reporting_delay_ms in kernel-parameters.txt.
>>  - Updated code comments in mm/page_reporting.c.
>>  - v2: https://lore.kernel.org/linux-mm/3da27fde-25dc-4cb8-8e05-74cd26fc2f7c@kernel.org/T/#t
>>
>> v2:
>>  - Documented page_reporting_delay_ms in Documentation/admin-guide/sysctl/vm.rst.
>>  - v1: https://lore.kernel.org/linux-mm/20260722192935.1646848-1-pratmal@google.com/T/#u
>>
>> v1: Fixed feedback from RFC.
>>  - Added lower and upper cap to sysctl value.
>>  - Reverted the reordering on page_reporting_delay_ms.
>>  - Dropped the mod_delayed_work() change.
>>  - RFC: https://lore.kernel.org/linux-mm/20260714171456.2350037-1-pratmal@google.com/T/#u
>>  .../admin-guide/kernel-parameters.txt         |  6 ++++++
>>  mm/page_reporting.c                           | 21 ++++++++++++-------
>>  2 files changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index b5493a7f8f22..364c2dce8e70 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -4810,6 +4810,12 @@ Kernel parameters
>>  			Adjust the minimal page reporting order. The page
>>  			reporting is disabled when it exceeds MAX_PAGE_ORDER.
>>
>> +	page_reporting.page_reporting_delay_ms=
>> +			[KNL] Free page reporting delay in milliseconds
>> +			Format: <unsigned integer>
>> +			Adjust the delay in milliseconds between free page
>> +			reporting intervals. Default is 2000 (2 seconds).
>> +
>>  	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
>>  			timeout > 0: seconds before rebooting
>>  			timeout = 0: wait forever
>> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
>> index 942e84b6908a..a67311468204 100644
>> --- a/mm/page_reporting.c
>> +++ b/mm/page_reporting.c
>> @@ -47,7 +47,11 @@ MODULE_PARM_DESC(page_reporting_order, "Set page reporting order");
>>   */
>>  EXPORT_SYMBOL_GPL(page_reporting_order);
>>
>> -#define PAGE_REPORTING_DELAY	(2 * HZ)
>> +static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
>> +module_param(page_reporting_delay_ms, uint, 0644);
>> +MODULE_PARM_DESC(page_reporting_delay_ms,
>> +		 "Set page reporting delay in milliseconds");
>> +
>>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>>
>>  enum {
>> @@ -76,11 +80,11 @@ __page_reporting_request(struct page_reporting_dev_info *prdev)
>>  		return;
>>
>>  	/*
>> -	 * Delay the start of work to allow a sizable queue to build. For
>> -	 * now we are limiting this to running no more than once every
>> -	 * couple of seconds.
>> +	 * Delay the start of work to allow a sizable queue to build.
>> +	 * We limit this based on page_reporting_delay_ms.
>>  	 */
>> -	schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
>> +	schedule_delayed_work(&prdev->work,
>> +			      msecs_to_jiffies(page_reporting_delay_ms));
> 
> Err, do we not want to limit this to something sensible? What if the user
> specifies 0 does it just hammer the system at that stage?

IIUC, 0 just means "as soon there is a suitable free page block to report, start
reporting immediately".

With 2s, we wait 2s before we start reporting immediately by kicking the
workqueue immediately.

So "0" does not mean "report all the time", rather "start reporting immediately
as we are notified about a pageblock to report".

-- 
Cheers,

David

