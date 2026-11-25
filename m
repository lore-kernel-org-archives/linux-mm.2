Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E4E2606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pnh0dVx/
Received: by kanga.kvack.org (Postfix)
	id 2E9026B0A11; Wed, 25 Nov 2026 08:32:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273226B0A13; Wed, 25 Nov 2026 08:32:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114206B0A14; Wed, 25 Nov 2026 08:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD87C6B0A11
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:32:54 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38D90407AF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:32:54 +0000 (UTC)
X-FDA: 85473731868.28.C102892
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71CA418000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:32:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pnh0dVx/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795613572;
	b=l6EbHwCpoR9f6eY7X1E8urgZTUDzD+j+gar4Ir3CRn9Qbm58t6MOTvrk8Jbp3WwGOvkfIq
	dlbLtoG1evK3gCfDNLbaI77EuKWby77/mvRl4p0TPcJYSgCu7iSHF/gFFBP1r5U1m6oYWn
	AZu5lJZ8kN6yIZz9UwyJ+yVWDb2PNj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795613572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiY+GIy6MY/XGAOEhBQIf2DUGSXYYkQR+i74zNHuAyw=;
	b=7QabTxXLMfSrJMXJrj+g9EmmkfLsBykSQYeI3dFrWeiubsTo7c6YfDIaiz1wozHUUd7Iv4
	+uUZry4KvtnxsY5dthBrvcQGfmHicbhbCCya3OeTAW6vShY5+lvQOxkYuVMh0Kc+arzwc0
	CzhQoX5r4czPw3TrTbVyeX5FAdarDtY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pnh0dVx/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D86B06022A;
	Wed, 25 Nov 2026 13:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2241F000C0;
	Wed, 25 Nov 2026 13:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795613571;
	bh=jiY+GIy6MY/XGAOEhBQIf2DUGSXYYkQR+i74zNHuAyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Pnh0dVx/+8VfiOTS2ZdsY706kRBMNLH71+Q/sILCBMjoG49P3AdvAMO2u0YKlphxI
	 VA1YknQ35/KLVbde/qu1XlmEm/XW4krkfAlRYg/RFOWgPrBpyNeB+a33j2Ae0XDPuv
	 fsPO2hKErwMds7qPSoNpOpCIUjqt5mdxDqI8ubZMgSLa9Tl8oY8mlXBAqKZXmhV3cn
	 I9ZUjj5zEHcusqG0gnNjGShxX6mnPBK/JAzp3mey8ft1/iTfLWHPFs6ZygSseOP7LH
	 njy1pzbKH38mJCggxr0Mq0B2GW9E/JWp4PleQ5J6KLgm7wLatJw9EBOXGaBeQxCvKI
	 9MWT1Jyy+iZRQ==
Message-ID: <2382beac-077f-4393-89ad-580bd09a6314@kernel.org>
Date: Wed, 25 Nov 2026 14:32:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests/mm: fix false-positive and racy KSM fork
 test
To: sashiko-reviews@lists.linux.dev, "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-mm@kvack.org
References: <20261124130143.128411-1-xu.xin@linux.dev>
 <20261124130327.131410-1-xu.xin@linux.dev> <sashiko-outbox-233438@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-233438@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 71CA418000D
X-Stat-Signature: ciq68oqxtn49wgh1da1um64gqz4pcdtu
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795613572-441397
X-HE-Meta: U2FsdGVkX193KWGxAx1jLs/K4EcE0IbbEaI3dxqd7tv5oYOySRFiyxf4tg8rlH+I+Q6Qtkt7F3j9qf9TWgJGtZWwQ8T3UybvUJ20fS/JsD0L9nJjKxcSL2fPbdobXps1mn/8Yc9+BuFnj2j6l9873B9ZzelAcFsrSDRI6Z3KXy34cIQUjFeZnlp8gCj+oYb9MydPQGyrVc7ZjlYImEFKuqd/Gf8tu/9QRIq+NLzPicliW88d8eUQ3QBS8NOM5ZPu9A+OcYy7+lNzUVJnNpHJCbRaPFj4lyhCbSzm47kHIRAhRfxWjomV9y5ljonFcywrX1UYv79EcKZpTCXH7QojCV7cVj0sITIO1fyyg+W6rIEamTgd4/s/R333PzFPKjkDnZq5nBHKVGdQkTGRQiUORHItXgW3UbbwwIsHnq96D0XD5DNCdzddtm8NwrqtzVFw2+5CEN4aTWzsEDeKoAYIk+12w9crYv40D6H4pK1lbVUcSaWCU54D8kDrJ0Y5sIG341Xsy8ThtEWx0ZETNH23mgLcu1DqNb+io4+MYLx6CiVJen08vUsTOaF4BPIOufmxkxPuMoH4oDcrbHmn9CoUWahal4fWDPug2mdw56aJAgdbv2hWaclBMyTvNv6bwABYpFw3X9DjueY9XUAA829dfrt/E5S+XcEx6bAvXG3wVAiOJu8jpkuIWFNASHMDhigoPJMUWQiT4WEJgDAhtPzPLUk85Vo9OOzJ/+sWubN4biFyRwh+NdRp0PXXjOwBXq9HMGNWk02RUgi1xqQMohFTqGn6f6YkdvEfBTZjBGQWZsU5Y+a4xkHK8fYxwM8ZW7R+Ku6dsjlI8oI/iUa+m0dvPaXmjf2M6bJFDElqDrGD/QBnE+54dj2U2N3j1oWB3FMlJLlNC0qoTkLx4mlwRz36BsMZ/zAj/1WQM7OAWKoEltsScbNK4ykYrECEC44OHP4aby39/SpZM3omUWHJIq3
 +Lo5kHvI
 1tAq1/XGNHNfU1Y8ZflL/egVHlx+HXdwR6g5IHVaGo5+b8VzIjTg0q1bWctdZxzetpAghX6cW3RDywPZ0vUCid2uF3syY7P5gupaYt1ARPfQbTPR2nT14f4ddwlW363bwO1JWDN5vcLu34eA2WqTuwEGPQEfY4ydwfwA8MQFXUK6eHpn3/d+mz5+Ddx16dw7GDGkuXJzVRrqncQy4kUlD2Zb8n7ooe0Xt3dx7eBK2+KJvtHt07Rw1tNdfCPxM2uIG795ao3TtsOUnxkma8hFi4yFlK5cAhFgKc/VON3R6ZpvoCGvL1t1OiURA3/mKjVvBNRr0XcvRhYgMuY3aSh6FYZYDHrsE9K1W3H6hGgZtA+x+x/I26wnedl40ZLYWPolPUpcSa97Sq66l5ajPCVv4NMx2t2nRZ5fvq2ywTNi5+kSQcwmAXOwL2P0Vzakww2BiR4WJ0zIye59i4FavSY/DSRfrnhtmci3ZV++XlAqSk7K666bsAhbiGrGVDHTwF0vYYu/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 14:04, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] selftests/mm: missing Fixes trailer for
>   test_fork_ksm_merging_page_count() fix
> --
> 
> commit 9f91c40f8740268fa4e48f24e3a50d43177b045b
> Author: Xu Xin (vivo) <xu.xin@linux.dev>
> 
>> selftests/mm: fix false-positive and racy KSM fork test
>>
>> Currently, test_fork_ksm_merging_page_count() passes wrongly even if
>> fork() fails to reset mm->ksm_merging_pages, because the child process
>> calls init_global_file_handles() -> ksm_stop(), which unmerges all KSM
>> pages across the system before reading its counters.
>>
>> Fix three issues in test_fork_ksm_merging_page_count():
>>
>> - Drop init_global_file_handles() in the child process so it does not
>>   call ksm_stop() and mutate global KSM sysfs state (unmerging all KSM
>>   pages across the system) before reading its counters.
>>
>> - Use '!!' in exit(!!ksm_get_self_merging_pages()) to avoid 8-bit exit
>>   status truncation (e.g., 512 pages on 4 KiB systems truncating to 0).
>>
>> - Introduce ksm_pause() to pause ksmd (write "0" to /sys/kernel/mm/ksm/run)
>>   before fork(), preventing ksmd from scanning the child and incrementing
>>   its counter before it is read.
>>
>> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
>> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> [Severity: Low]
> Since this fixes defects in test_fork_ksm_merging_page_count(), should it
> include a Fixes: tag for the commit that introduced the test?
> 
>   Fixes: 08ff89b5659d ("selftests/mm: add fork inheritance test for ksm_merging_pages counter")

Yeah, makes sense.

-- 
Cheers,

David

