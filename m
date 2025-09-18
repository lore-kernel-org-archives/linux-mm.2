Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DAB6CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B44F8E00CE; Thu, 18 Sep 2025 04:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9653A8E0093; Thu, 18 Sep 2025 04:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87ADE8E00CE; Thu, 18 Sep 2025 04:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 731738E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:31:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E25F1A0821
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:31:34 +0000 (UTC)
X-FDA: 83901702108.20.C002D8B
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 283A31C0004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:31:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XOu0WkU+;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jjiJUgOdqQcZN+L/ySOi1U0QoPVQrpVp8UxDsjbiI4=;
	b=tqdWYkJpZiaga9yMg1bqcKxvjz8tFD7xutpBPSRnqUXlXE80PlxfAs3ypp4f5wMMmWIMPh
	RccQMe0iduzYtv5LCI8aO+3Ryskner2hmW1/pWDyKN4hlXi3rVR1ri5O8oFBToBXICoMrm
	eua3qgUHfwjpNEjGflQY1CgovIURhc0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XOu0WkU+;
	spf=pass (imf21.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184292; a=rsa-sha256;
	cv=none;
	b=XtR9QT3Ay9ve6cBgg5ZCPL9jisqV2ORheeqcuOADrB0yKqTci1QyuPPhvfJNkMQJFbyfJO
	uD+I0rdKQS6XxROmMqA3eEOhLBcW8DS//3jthJoGs8K8K+l3aUiKs7gZkBmJ0DKiNSJnQh
	Ck13F+gS6JuxFO0JpiyqRiRYwxpHZEI=
Message-ID: <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758184289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9jjiJUgOdqQcZN+L/ySOi1U0QoPVQrpVp8UxDsjbiI4=;
	b=XOu0WkU+plWpFLyGyEkqg6QdAh3SC7FRzxiMgrf5YnFsA+iV/iIlOIMbbXoED2aPkC8BPU
	yUyGHOwGWN6G9P5TFwZYpTHzTxSlD8TdX83JZZdnJXfEQVGL/aQT0guiay/jy5aeOnSrH0
	stYtr5IZdNnRCdVaUUDCWH1yMktmVE0=
Date: Thu, 18 Sep 2025 16:31:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
To: David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka> <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
 <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 283A31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wrkmd9y61nesuzkr6qggecwzogmpnddd
X-HE-Tag: 1758184291-355667
X-HE-Meta: U2FsdGVkX19a9sfLov9n8ORtIJSmOjJO/J6sgCQimT9DrhmM558+5KSe6Bgvz2Kl7hCo20VjKNIhdGnqosB6wRqdDpBVUrjcV++ruihQQs4kg9WFKO6IdqfmMxbul0g82zxmJVORXv6d7SJAmdpuJoDtB2wjOj+4l+Mq5hShNw4ctdrm6CAGve0rrYAJrlkIOqsvJq2hO6XmqwLyWKYxG3zrbd1fzZtJNvUhgpRf4B6+AvTcC4YpWQVYi0kZQNCCw/mewe/lPpdBvuVNYbtBXUo9a+A90yNXnN23eaicTQncGW3g+8s7y193rJoWPp+QR+yBQgjsgJuCz2gk2aT4jCZWa9k+w35wsZe8XlX+eEs1zDVJBXmkrqWxQUDHO0jj9la12mPTJKkQ1FO5N8/NY9DYr7HtZ0JUGSxszdGuX2fBWghEnSP02ZUO+JDiAkBgzwE+jRBEiwfnBvJeVTBGo2rHmr8Qc4LUJqOYoh1NxEQXpku7RxyUFfSdC2uD55TparFaZVNFq/WEqAloQLEObJ0OJZKmSN2B4/VqYswRYi4iIhR0H7JFEO3mQg9LPwhlCgKNyBZC3C/kEnaGbu5X1yqqZAE27nqcXrqZbWVNx8LCcWEE44xjRPoWbKZZqAmdIrvia/4pX19fLWswZ31clPYDCh7UjM8fAtJ7bYh6v21Ejaafb1qe7FSuAOJ2+DdM0+yskVvjZzXDv4UEQCcotWXe1n93F8ZeHsZoP6v/7A0PP3WXH2bzaFx6a9FVo3IVW4Q2yxRAlCHgUkdeUuUSh7WwWZ5xpBCeJzmRpvoy+iU9+qaI8qG2rGr1MXOI3GrHcRHyZRr6y0cEn6wJ2WIDM24Gb/zRk90HiaK3gt9aG1jDZ302Mf63R9WJRx5RMHtqas34vz5OaVy7vuOLQDvD17lC7hD64TzME7Qm8ytAEkZjn88wFQav21+0us0xPB14k4Z4NdfXfsxhZ5yd44m
 gA9bFijC
 ylL1qnZJ4toBirVpxwW1Bgd5Ap6KZYBKoNdV0iymZd0bfMqKZb0FzfOoEHeaj05rHtaMJREIvT+Q+twZ7BlZrxxdxkiAwa86uoHerBVBZngbt/6GdOFfsVemtJYU3R48fwy4bW4Feh2nlj6rX0QxNGhym49MAbsEL3u5Vqc5pghvMVIWZJkv5ZaKefWgaPyi/Sg1a+IyMdVl7bK0IQm4I/cxO0fLuc66ZrqRqJtjb7e94n5Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/18 16:16, David Hildenbrand 写道:
> On 18.09.25 10:11, Ye Liu wrote:
>>
>>
>> 在 2025/9/18 15:29, Michal Hocko 写道:
>>> On Thu 18-09-25 15:17:40, Ye Liu wrote:
>>>> From: Ye Liu <liuye@kylinos.cn>
>>>>
>>>> Add a header line to /proc/buddyinfo that shows the order numbers
>>>> for better readability and clarity.
>>>>
>>>> Before:
>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>>
>>>> After:
>>>> Free pages per order       0      1      2      3      4      5      6 ...
>>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
>>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
>>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
>>>
>>> Why is this needed? And have you considered tha this might break
>>> existing parsers of the file?
>>>
>>
>> Thanks for the review.
>>
>> The reason for this change is simply to make /proc/buddyinfo self-describing.
>> Right now you have to know which column is which order; with a header it’s
>> obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:
>>
>>    Page block order: 9
>>    Pages per block: 512
>>
>>    Free pages count per migrate type at order   0 1 2 3 ...
>>    Node 0, zone DMA, type Unmovable             0 0 0 ...
>>
>> Regarding existing parsers: the patch does not change any of the existing
>> “Node … zone …” lines, it only adds a single header line before them. Most
>> parsers match “Node” lines and ignore everything else, so the risk should be
>> low. If you know of any existing parser that this would break, please let
>> me know so I can address it.
> 
> What if there is a single one out there that has hardcoded to skip the first line only?

I understand there may be no way to be fully compatible with all existing
parsers. However, /proc/buddyinfo is essentially raw data intended for
human and tool consumption, and parsers are expected to be robust against
format changes.

Adding a '#' prefix to the header would allow most parsers to skip it,
but it still changes the file output and cannot fully guarantee that no
external tool will be affected.                                          


> 

-- 
Thanks,
Ye Liu


