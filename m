Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6891EF4368D
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD046B00E1; Fri, 17 Apr 2026 07:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5256B00E3; Fri, 17 Apr 2026 07:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC35F6B00E4; Fri, 17 Apr 2026 07:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB8266B00E1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:43:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 720DCC02B9
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:43:46 +0000 (UTC)
X-FDA: 84667863252.22.238E835
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D411180005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:43:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rh1kWv/p";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776426224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XZA8Z7Wwen7bvvhGV+9K7epD3nJl6JbbaIA3EMgD1Q=;
	b=tGODEP2uAvoBW48/0sFs/A5qhp4bhZlGrHaeEVfOiqVHo6nE5iLNo3kmh7a6DRMOIvYwhJ
	P2geR0NMyG6MakNtcuYFMnDEGp8lfaf1QcIzISJzOi4oQ4/CsYEYw9ypiGTSgWrM72Krp+
	3UKlresh/vG/LuWDLHqlYFniarkYFM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776426224; a=rsa-sha256;
	cv=none;
	b=xTVFLc/wDN5W1XFbxOE/22XqJ5l8v0QsTgHMOYMO2YHr4JdU5kfDyCAagMcAPTrhTPy7/p
	HwNUq73Ww105eH1nVLPC8E151fcaokvvwRdEOhkZkzN1btwdItxphYd19BGNN8+OSEHx+v
	cWA0Umct9Dt/OF5Ld3IZSGH4TSCTQ98=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="rh1kWv/p";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88F454370F;
	Fri, 17 Apr 2026 11:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65EEC19425;
	Fri, 17 Apr 2026 11:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776426223;
	bh=JGgbvpvWm+Ik8ZBTXf+YL1qrGBJYpDxeijGIxjtDHkQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rh1kWv/pWbdLIgEVHPwauDYHLUIFVZUP6FH3zD4hG9r2CQf6vxykMagcdtJFPSIIh
	 tvy0ByCX5em5C880qRgnFn/S8aaUQANfgMCf8to2uMjMCmTq2s3rrHdNmb9hInzEHJ
	 WMIIFTxxRM3gWA7aH/HuEO+uIXvDNsBGHX3agIUwDr2FHjMtyg8Z4+nod8NYhvHVyY
	 HvA1V02mYmjnHe0YwVr8667tXr1ErTSWKzesTg2Nd0qQHyqrFx43Y8UNCVAvkN9ctn
	 CF3h766uicbcARhlCRZdj/jdFjB+2gYrJdUX0NPbizpPhrgpBKqOuWk/uv54W/F0xX
	 OHjknsEsvoAnQ==
Message-ID: <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
Date: Fri, 17 Apr 2026 13:43:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation> <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeFCuLJXT8VOkzH7@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8D411180005
X-Rspamd-Server: rspam07
X-Stat-Signature: crdj5u1m7qoktmmxcebn3jedekrho8mj
X-Rspam-User: 
X-HE-Tag: 1776426224-117323
X-HE-Meta: U2FsdGVkX1/8U0Cni5rMeyyoU7Apko2beaBGb1KOc9ne31vQ4WdjvilchE8wxE1lzyRrWdepYPlVW45KT0Z8YCKmsIunoKSd0tiCIzrSnABkPOk7eoNYwK3X8lGDotdNaYu8BqLkdtit2BdDMIqdMjfSenfxJZQmvd62niS5bE88LS7l0lapMOxdBBPw5ZibLf+HfI8fNgOtnr63m+207om9UJGIGAdirD5oNX4mBIf+WRlCPP4XRVXtwHvXfWxL+sS1L70OuIWwvPP2JiPJbA3fFS8F2FWrjbMSxBxc7IzjTV+SP47T5mvTyB73za5X0PXFLyDc7NDlTvCLlcMYeWqVgBP8Y2pDXBNDdZY5a3Cb9Z+giSzGoxtiCGHND8zvF6JxbbMvN7f2d+6PiL2RGkTVzOt4vNG5JQyqgF5rm1MAxJ3OEdKNsLWY2MwHE5dGxtF91OOMDAdI54s+YlUFf8bAAFvO1WQdjab4SYWLSRddcjgDZ1bEjgVG8h+ZcBwhggHAN9Z3IzUlaps5XP1wvU6sssIU1C4IhAnuR1i6+wbpZCeGnQ4qnXFefo7vAvNYDuXiACO8+G/LKrZZwN9Ur9222sUzhMGTSsAUvBAxyiymGauJaTNgX9s+mLI/wI/LjSuSqwhYiPsd8SSMvzYjv0OKGZbxrz2HKd1dZIJ1WRy9Y4GHTT52iPhhZiv08uxe9DPV54/+V0F5b0EdSQLrAc7/HxOobBrLBtn2EkQRxSuG3aDtzMMt9P3cRFYYKrH7ZqycKiEEHfcw/3tGqpEszWND5KOSFjcP5ZEEYtuNj680u9nYSTpxKIikYQiI9mgRd42nqWpMeWN/kg7/aiEB2hXxY+PESDhmIiLZuOremyqRJsJvGdu/remtNjEE+msnpeG8EE5xjx7/J80NzEESYATvczqcH/S931b6bbai1eL/0V78oEVzYaMpt64L7nKASXnlcGtJAFXsTA290oe
 kYJcjwBV
 x8KUmBuF+gxBmSlLEmleDLJqELhI2Rfe7Smzxu+rs4G3yQRtm6WGkX7y8CxFhSpLC+QtJA1Qd5yIudL3vhFWT+UVwx5TurmGOBkP2n1mZL1Ftq7v8ENOwCSHp/ayAbsUibGKzk8lE6RZz7XH69hcQweWlH+5NWtOuMDpb0MWiXnO1oMwuEwq+FT3FaYIYyIuaCAdHD+LA5GikQMLo5jpZnBoxg5NknpyCea/3keuKvMCL0SfI4EDEm6PbQVJviECPbFORbTEKDCTkBWHqNvh8K/ygLQXG/Nou5LrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 22:25, Kiryl Shutsemau wrote:
> On Thu, Apr 16, 2026 at 08:32:19PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/16/26 15:49, Kiryl Shutsemau wrote:
>>>
>>> Here is an updated version:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=uffd/rfc-v2
>>>
>>> will post after -rc1 is tagged.
>>>
>>> I like it more. It got substantially cleaner.
>>
>> I don't have time to look into the details just yet, but my thinking was
>> that
>>
>> a) It would avoid the zap+refault
> 
> Yep.
> 
>> b) We could reuse the uffd-wp PTE bit + marker to indicate/remember the
>>    protection, making it co-exist with NUMA hinting naturally.
>>
>> b) obviously means that we cannot use uffd-wp and uffd-rwp at the same
>> time in the same uffd area. I guess that should be acceptable for the
>> use cases we you should have in mind?
> 
> I took a different path: I still use PROT_NONE PTEs, so it cannot
> co-exist with NUMA balancing [fully], but WP + RWP should be fine. I
> need to add a test for this.
> 
> I didn't give up on NUMA balancing completely. task_numa_fault() is
> called on RWP fault. So it should help scheduler decisions somewhat.
> 
> I think an RWP user might want to use WP too.
> 
> Do you see this trade-off as reasonable?

One reason why the PTE bit was added for the WP case was to distinguish
it from other write faults.

I assume without a dedicated PTE bit your design will always suffer from
false positive notifications.

Leaving NUMA-balancing aside, a simple
mprotect(PROT_NONE)+mprotect(PROT_READ) would already be problematic to
distinguish both cases. Zap+refault for shmem would likely have similar
problems (we'd need a marker).

I don't think a design that allows for false positives is what we really
want, especially as it would diverge from what we already have for WP.

Yes, using the PTE bit (that we already have) implies that we could, for
now, not allow the combination of WP + RWP.

-- 
Cheers,

David

