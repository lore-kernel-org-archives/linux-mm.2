Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13BDFCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 13:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3478E0008; Sat,  4 Oct 2025 09:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299798E0002; Sat,  4 Oct 2025 09:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6578E0008; Sat,  4 Oct 2025 09:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4918E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:12:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A25A783CD2
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 13:11:59 +0000 (UTC)
X-FDA: 83960469558.09.61FCE1E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 03AFC4000D
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 13:11:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759583518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCI8Ngj0uJx3jhwkRo0s71hK0X8UJ3DKSu+pKeMhODU=;
	b=k8K/CCj+kHzgVc9vtegDKFTTuZcPGFDVY00BehtuSZWxn9jeMsQfikDUW9JsDKht4iwbZh
	1n+j8C5D4MvD0xOuUWpA44F2tXNZNrk/fRinD2IHMNt43QWkg9FYXC9RpRZv91XYtln4Cc
	4ErK0s3YhBdBxmjcOJr+ipfe0UJfcIs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759583518; a=rsa-sha256;
	cv=none;
	b=mGB7EcEW08hav0cOk69AneCd62+eBziiWG8DugvhGcZopFpcqXTeXnAlA3nJORrWKcOYFU
	tmBAsg94L0bjheQsrXEymxEDUu2R6FjKPQtynY4dGtGLOhnoNjaIjXUI6jHBZgx9YE84v1
	yMBU1Ob1jHJcpWsZk+VNIwUJwCYbB+Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22263153B;
	Sat,  4 Oct 2025 06:11:49 -0700 (PDT)
Received: from [10.163.66.97] (unknown [10.163.66.97])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B35F3F66E;
	Sat,  4 Oct 2025 06:11:51 -0700 (PDT)
Message-ID: <f235a557-d031-4fcd-8c68-81d9ab7b54e0@arm.com>
Date: Sat, 4 Oct 2025 18:41:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <20251004094217.bah5q2zxczrqontm@master>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251004094217.bah5q2zxczrqontm@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7qhi3csbuyr7559x3zhfwfxayb9diq9t
X-Rspam-User: 
X-Rspamd-Queue-Id: 03AFC4000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1759583517-553384
X-HE-Meta: U2FsdGVkX18idK+pzHbbLC3QNoUOoTJzuNmx/eZDlQbsxH6Wi4FVzSS/fpNcSyJC/6j7WTq6FYWz0U/KSm3A60fvdrG7kmnwXtmhH3yFl1cNC3QaVhs4QkDoG/BZ/6VN0BEhyn1EKic63wOatk2ZBugbNWVdp2mBcmdHhJWbAxuu8qL4umqakxuLZBAcWY3wl2xJD1jSAf29bt8iQ0HeU7MnrmXh9fi09aDlIwsR17AVn11XPyPk4iPbcsLZOoFCDkUCYX38O9EK0h9ETIhPfGkdq8LqPAJ8B8BrmNZUlNE1ANEQhociJc9Z3ZC8cy5jD/sGq6Gf/Fev15SnxefwRWEIn/GgBIUr7DJrx3mAvErjxxuGTnU2bhjT7P0PJn2V3KtgT84yOaiMoLZUKiO98HanQgcTDTk8EbvT/azoyiZ+1l3aaOO1tyiDKKjl5eOrbz+jARWkmUV3eJiD1SPwDVudICipbch98BlOq7QVzjZZlz6ANn9pN+VDr5k68sgKstTuTP8S/KvxXPIsRjpq53pdeauCOe67AiouPF5JvyCT8R9j4aA8TdzF6FzjZmDp0ZzriFtrgj6k37URVQIC9GDbSVUZWCZGzwqdepw0Hol0IubQuTjq5ruCjJPInBULJOh7Zo49YM9jwf+PvS4JJk8IVnXofIGnIhYjFchiltvLWRfV+Z5/Zjlo11Y6RrZ0nuT4s3MKakj0DRLVlbwn8tMR77i5ZMmgv8fWCAv9jrWPBG6+ZEInfvF8oev+Zz3FjnfiiO0WCfdSqh5jk9TIEtibxZBrHUWPC3lld9H6NhdvyXrpDaarZJ+fQ9rB9B7h308YTUbsmbDy4nC7wpGRUholp0/Say0VkkDWsOi8CBFlyzL81jmAZXzFZ/6sKmrOLhrvn0DH3Yf+141jI7rZdX1QTLoUCwLnmrkS7bV8vwnmDtSTt9wc7h1EpLU3S+iBATZDgaOnTdotX8RROkp
 exyxhTy7
 EfgoeZvT5A8rVKxxVRXsn5kRBAk1ojeJrMlJc4YMxsLwqFcQLOmxF3oDaj2I2wA8u02N98QPtNbaWxLrq51BfXCMA6NSqr01JrK3Q8NOyoQDO81UmxNNgo4TRdg8DSbgZj+g+Cl5y03+GFXklMFtMMipBWrKbIQlBKK8YGg7W8MirW8Sv1I28AvuGLS7Uaj9SQMqpn0YEOMr+XSM9b/Rklzmch2G97GTFnxvUwpSa+bnQR/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 04/10/25 3:12 pm, Wei Yang wrote:
> On Fri, Oct 03, 2025 at 10:35:12PM +0530, Dev Jain wrote:
>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>
>>> This patch cleans things up by moving all the common PTE checking logic
>>> into a new shared helper, thp_collapse_check_pte().
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
> This is true for the first loop, but we will unlock/lock mmap and revalidate
> vma before isolation.
>
>> an anonymous vma, is it even possible to hit if (!folio_test_anon(folio))?
>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>> till the folio_maybe_mapped_shared() block?
> But it looks still valid, since hugepage_vma_revalidate() will check the vma
> is still anonymous vma after grab the mmap lock again.
>
> My concern is would VM_BUG_ON_FOLIO() be too heavy? How about warn on and
> return?

Frankly I do not have much opinion on the BUG_ON/WARN_ON debate since I haven't
properly understood that, but this BUG_ON is under CONFIG_DEBUG_VM anways. But
if you want to change this to WARN then you can do it at both places.

>

