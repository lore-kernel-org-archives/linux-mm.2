Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A57CC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308226B007B; Tue, 11 Aug 2026 00:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DED96B008C; Tue, 11 Aug 2026 00:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7146B0092; Tue, 11 Aug 2026 00:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECEEC6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:50:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76A6B1A033C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:50:39 +0000 (UTC)
X-FDA: 85087762998.02.580F72A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1B8891C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:50:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JM0bf/yL";
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786423837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNxfQN/7Pd2hBsPg+CrM6dWoXUrxbVMu9411VE83FHA=;
	b=YvnVSy/sDO6f9GWd9dRKDW58PgG8gkg7KiFRgcYHlZij8+fUSRTQFwlRZLbfR5lQ5XqIWZ
	Tp+GuUpS4enx4r0vvgZIkbFA8Ud7pGYxbFqOHry5XKvuuUeY/RmUCS9UWhY71Nl4T6o8HT
	xEXtw7ySUOn00YtNab2T0gW3UyiRZn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786423837;
	b=FBEh4BnRJssXSZXJiEwLhw4Q+FTBu6IKlHxp/7wStKgk93CALKysVjMCxLmkuT4qLdhQZq
	PNEdcpCypId9tlfuEKDLEpeRq+KXc7dKQMa5CgW5y1Bk3biZ0oni6Cs2okewHdo+6Qv0k+
	xB+3RjwzzbSTZdeDqYN6gKyaCeu0fjY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JM0bf/yL";
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e7d02969-9ac3-4269-b00e-74ce4039def8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786423832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNxfQN/7Pd2hBsPg+CrM6dWoXUrxbVMu9411VE83FHA=;
	b=JM0bf/yLstZNmSUedAnleJMC/yOJDlX+ksOmoqFJOIYvOV48sEqeEf8hASDK5OLPTvAsL4
	9nU7y+OR0v4euFZvIEiGlu9lDRv+f4KuEggccw8+q/aZFjqvOWeRf0LWgURlNW7N4sKnRw
	jqFdk2tmQQkzT5Uq9bWy5UUmnV+2mCk=
Date: Mon, 10 Aug 2026 22:50:22 -0600
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] mm/khugepaged: several cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
 <20260804161204.140bb3b8e482c43cbbacc2bd@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Content-Language: en-US, en-ZM
In-Reply-To: <20260804161204.140bb3b8e482c43cbbacc2bd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: umjzuyjpbm98uukscxnxwft1jijq7bb9
X-Rspamd-Queue-Id: 1B8891C0009
X-HE-Tag: 1786423835-220680
X-HE-Meta: U2FsdGVkX1+QC42VO0pRHZ5HqUkzDyEzSK6+QWCQ3XWABB+1pTKdCCEviNSAZx1JWnS6dmMX6Uw16W8dAqJC65g7o/M//HCiBIm5lLkWpUNJWshtuinKaSJI3QkhM7qr8gNZUHu55n5+tmNZu/SUs21l1ed6QssSjcs6Wxb+Z6Wrpt6pq3minsmx4gQGceGuUoRCKEzuT2ZywLySBUazWrzoJyvOzjfNOBXvIKwPQWwz/QxXSiZI9ilr1lYAJoSWbQMDd2BD1UnNsW9P9qTHsiBKL6JESqvkL8StTKl1xwdN8+vNAnX4sKR0zWq7gh3g831DH+n4gOvN5PriXTg+ij1uzGPNRlm7HmTCnGj43WIn7xYwk4vVhJ53sbHyiSbN9RPyyti0Sm+3Tm4eYk5J9P81/Vavl+M9Wo5x4fN6X2p24mLbcAKI4+LcMrwjAvy3ztbea4YtlXm0Y4+izKFJ5fuLK0/przE6ktApN4iRmVNT/Z2ShE7MKhg/wUm7DigiWtwVGiE0Wmaw3RiZdXOyZ72pRoeD5yvYB/TFM0num6WTBrMl0ARVn2VX3hZrVxDKy8QvzodlDBSVOnfpTO55+n+Tl82JK0rOS490XI5uyBHtOFxyyih70ai2kbVF/vwx1dgKCKtHdCvShH3cxw/DVO5scTEyY6FV2OQqG9ZtJD2tjVLa9cIm7C8yaF29alikDbQL1Y9P+M5gmqyxB0AbAQ6HS/VbXSuUaR7Ym/8CcrkpAFgSJiLXyi+5I/Q3JJNtobF78ssByOz7f/6ofdBK3pnkShEDXPwX/9xSPVi+5H9yz0jnH1aQwPA5QSWMlldUpgeFw7WdQ7gnUoXnEygC5ybWjZ0we7jYXTD8lEl0UH0mnqZ47MCu+FInJtMNwR2IUqmc5u2rZD4F/F0cNXJjDRkZWeI6HTu8JEn7Cgc7mnQYDs8MJ1kKL9JOMPBFgumPYHvPc69JgiR1wHBkUt9
 KS/O1VEy
 +CyH5uYbMkdgT7kEenC2s1GBz/PBuEGn75ud4NqwMY/0T9fQGWEzF55b+c7qjrEa8PpUjOqmR9bsQ8CkFdE3+lMEz/FyJPARAfVV1hojE8sRvGYU/5QJjOB9M6S+Xp0gvBwV+PMJCHkF95Br5dSXFlPKgI9Sv0xw0eumGpACFUwwsvbsED5nVrOfgTCkLoRlUChmkogl+V+u/qyEK8uMmlKNZJaO4fvbjdjZWNM4nE/UpxNpWUrBEIpUNDXkRrspMcFfnRHkz1uQLdaFAc+SF1cD4ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/26 5:12 PM, Andrew Morton wrote:
> On Tue, 04 Aug 2026 13:24:58 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:
> 
>> The following changes stem from a number of reviews during my khugepaged
>> mTHP support series [1]. Some of these are minor code cleanups, issues or
>> reviews that we decided to deferred to a followup series, or in the case
>> of the more major patch of the series, changes [2] Lance Yang attempted
>> while my series was in-flight and we decided to wait till later to try.
>>
>> The first 3 patches introduce helper functions to increase code reuse and
>> readability. This includes a per-scan state clearing function, extracting
>> the young page check into a helper, and a count_collapse_event() function
>> to reduce a repetative pattern used across mTHP collapse.
>>
>> The 4th patch was the byproduct of me throwing Claude at all the
>> comments in khugepaged verifying and looking for any outdated info.
>>
>> The 5th patch is based on Lance Yang's commit series [2] trying to extract
>> the PTE state checking into a helper function. This required a bit of
>> rewriting due to differences after mTHP collapse was introduced. I also
>> took into account the changes requested during his patches review cycle.
>>
>> The remaining 2 patches were review points during my mTHP series that we
>> agreed can be deferred to a later series.
> 
> So "no functional change intended"?

Correct, there should be no functional changes, other than the warn change.

> 
> Sashiko had a little doc niggle:
> 	https://sashiko.dev/#/patchset/20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev

This doesnt seem to be relevant, although it may be good to move that note into
its own block at some point.

Cheers,
-- Nico


