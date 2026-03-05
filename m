Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6E4EEF338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ABC16B0088; Thu,  5 Mar 2026 04:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659796B0089; Thu,  5 Mar 2026 04:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565F06B008A; Thu,  5 Mar 2026 04:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 430E96B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:06:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E148DBB50F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:06:04 +0000 (UTC)
X-FDA: 84511427448.07.286E8FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 378B9100007
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:06:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J0/k/B/Z";
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772701563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qF3e1InnA9jjGTtBQ1m/ilqjtjb3Rq4QGSzvyIjwE9M=;
	b=dS+gAdlVmNpcCvzCntHlyT6aBMUkqJ2Lgw7d0wbEFa+FNvldc23UGD0u9oKe7h4BkJVYGJ
	dtbFmqweiUooTqYq+kuCIoToZiXIym1jfcQvE/KredKiXwrH9XjbEO2aTGW969w7oG1nih
	E9C9NhsPndjQhX0SHCZelgB/RJElYV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772701563; a=rsa-sha256;
	cv=none;
	b=to6PDyMEwkPKCPNls1AR2V8oVkcEQqU07JG9olRYMKxHdCZ7Rvvyoi9ZudCWgO3IHoJPGF
	mto4Axlf5N5eZbzDxpfVB742Aw1afS5Vjtcg+a/qYA1diOcXFUOGQZr05gy0NXiaAuCHZq
	vEVt5zlrm9zHzy7ovs9NH90BOMQIFwI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J0/k/B/Z";
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8009561339;
	Thu,  5 Mar 2026 09:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4BBC19425;
	Thu,  5 Mar 2026 09:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772701562;
	bh=mmssFpHsTTTOrOd4y+zoY0xhIkR5xO0zlcS/SUuUFGk=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=J0/k/B/ZSPtOdp5SgcAwYMgs6ZHGAR7ZKKSC7akGX8lelqRptgjCjk35rnVHtV9vn
	 OjqT58W+8i38KUlkTl+8QgpdL4fS5bWQ/77tChQAxbPHmyCIR2wJsPN6nurzvh5NkC
	 bmCzPhNi6tiSzSGlIZ/91rk4UXr+XUgV4D/JfmSx/L5nG25VTEtqAJEsAknmxHJtqB
	 bmhNQPj59f4VLdaWyJb6ZhMOVvti8qisA7fhRkABFxktOo7GqOA1+mdV5ecv4CuraM
	 g4lSJYMxB1wT23qft7LhnNt+jaWIqvXYeYd1vFovUAOcQ4WPM9u8KQ+m2oXjfip32y
	 YIaZg15SMyhhQ==
Message-ID: <985005f4-fe5e-4ad0-83a8-14ce324db58a@kernel.org>
Date: Thu, 5 Mar 2026 10:05:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: rtmutex deadlock and memory corruption when running gcc testsuite
 in next-20260303
Content-Language: en-US
To: Bert Karwatzki <spasswolf@web.de>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>
References: <20260303222127.2992-1-spasswolf@web.de>
 <f4591e7b-d07a-402a-a051-8ff12b0ccc09@kernel.org>
 <9541893b588ef644a06cf01bb65005e9efcb3427.camel@web.de>
In-Reply-To: <9541893b588ef644a06cf01bb65005e9efcb3427.camel@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 378B9100007
X-Stat-Signature: rcx67tucyz9tmrassj1i5hutopyn378z
X-Rspam-User: 
X-HE-Tag: 1772701563-399976
X-HE-Meta: U2FsdGVkX1+8fkCFBJLjazwwb3OcVen/d/83oGclP4vU4fiyqr/UvBBRrrmqfoBAqCqX0kWRNFH9RENM1Mmqh+CDK86q0Eyi4gF4fBvhRyRRM6IXOo/X1qWUhxsAPY3+iZGZPwzTV2VwlnoYTxyJ+DpJAqUhiJJc1ghp7ntZ6aEiUoszKKftdA+Gup9ow7oTKll8JUo6xMOI/YCHvGNvDdZh0UMUWRLgf++j0tcEIvbUnOUJByl5q45Cf0wnFwTMPC55+dQO8yFXd2tG+UWz9Gb0WIOyqoGOcNFBHu0gNRq+8zpAjeTySp3YCJNfwacAc/y4E7OPfL6cFcfthqSFYd6ARIXbbHX5ImB7uYSZMq8GHn1hWUSvQqED2NLghyyA3/kWMfkN+c4boHxA0Z5b0qPaRtR80JXoaVWAl2oVUPvwsOY9gXNZbnAhDLcFJNRzamQy/nb9kdlA4lAHebWWtSPnHyv4esyIY84OkN+6Oo4NeF0WJ91LIORKtqFiKfZAze/htHx5UzyM9RUEDXhVP+L9OcDtsLXT88i32MoJ4jxPaTHNYipgUs1GSHITj8W55161v4vUnm4AKSNReoPddDigd1z+l/bZbpV+07FbuQfkKNqO9GstSRbIf2CtyBUezYUSnkpQJ5E7Gp1tCw6ZjCIGV4PT9oiCM3c+HUgvtFd0Bdk+RNotsTJaGJ1WpSrtI5KBRD9fC7OlATTbUWmE8bYeT9g40NkN+h+cqiVwNNmRRZnj29WLWC62ctbAdWKZdcpqbO4/6dwG1GacRjnRzJqEZK02LwWpxc5/d2ewp5H1AaDGb2/YjO2lrDz15lLEELzH8SCYmk6v0OXa+wFr3zIUPbHs3u257zZ9HQNtAZQBiP+QN2nmZbDHKXYNaY4jzlV+h82Tf3JbCuJwUxPPOSJehB0srBZO6pzf8+DzvBvE1efhfRwnucEEr8AlQWI1pBzxuIhCUt1LAxmoWjd
 EAGQJbu+
 EJY6X7gxcqZbAZRh9/hm2ZDA1Ipc+RrR8THZNi36A8IqRtXq5r/XVgFfgubNt2rHk40kXTTwaTbTU4SuJJIJib7nsPMFN9SNNTGgAwT65NggSiLR1Cu55KyqhuTMZ126pdDf4BVkSOB6BjIYaJS4jLdDN3NmwgYGgfrw09/RQxZCwRZTgDyNlU9K2jKyAvfnUsRzV2YeGrP9Qb+ssBqeOq1Dcfn0GXrvMPsfm+OKqvWa0KeRqc+Fthu+zEvZwD5blC3BL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 21:44, Bert Karwatzki wrote:
> Am Mittwoch, dem 04.03.2026 um 15:15 +0100 schrieb Vlastimil Babka (SUSE):
>> On 3/3/26 11:21 PM, Bert Karwatzki wrote:
>> > I tried building gcc-14 from the debian repositories (fetched via apt-get 
>> > source gcc-14) on my new and shiny zen5 machine (Cpu: "AMD Ryzen 9 9950X 
>> > 16-Core Processor) running debian stable/trixie and linux-next-20260303 
>> > (PREEMPT_RT=y) with the following command:
>> 
>> It's probably my fault, sorry about that.
>> Specifically commit 666a739089c from slab/for-next-fixes.
>> Does the following fix it? The fixed commit was meanwhile
>> queued so hopefully will be in next-20260304
>> 
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 740edbad0475..1871c5ef354a 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4610,6 +4610,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>>  	}
>>  
>>  	local_unlock(&s->cpu_sheaves->lock);
>> +	pcs = NULL;
>>  
>>  	if (!allow_spin)
>>  		return NULL;
>> 
>> 
> 
> Yes, this seem to fix the issue (two testruns without errors). So the problem was __pcs_replace_empty_main()
> returning a non-NULL pcs in the case where it can't take the lock (&s->cpu_sheaves->lock) and jumps to
> barn_put:.

Thanks for confirming and sorry again!

> Bert Karwatzki


