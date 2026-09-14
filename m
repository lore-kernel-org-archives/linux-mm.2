Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E1CC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA366B00D1; Mon, 14 Sep 2026 11:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2366B00D2; Mon, 14 Sep 2026 11:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A26C6B00D3; Mon, 14 Sep 2026 11:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D93726B00D1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:11:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A473160173
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:22 +0000 (UTC)
X-FDA: 85212706404.27.F011F91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5BD6F14000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:11:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3tSTWGH;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CNMtyKSkXJHJHhjRW8A+X7egnO9+AYGH1BwgbSgK4k=;
	b=cMZTb9FRNwDsEG1eE236SBF899sIUxUJmvrKfBpkLu9LJiWijo2/mUDgVRw8mGHvmVtAEh
	UJ/YXUdlMXaHXrDlgHWbzW99QMaru7bnjRT0Iqx+mTQJA++wthMSFB8q5zMHkeHYZBoGG0
	va1ohAyvVHF3iORTkqAWSbmQtKLz4Cs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3tSTWGH;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398680;
	b=GwcOYLg6UMUnFl/fKDamcuJytk1tr4ybvJo7xQ6Pk+L86b8pa6ymcJRQaI0c/L67X/+tdA
	kowkrkZYGemiRC2J7fAJXfEGVtzmFVDZdACrOmhXy6jSUGEfE+ucVDwpcge+20+3JkyjVq
	CjvpWMsTdafSAbSQToSvNqjf3mMMB7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C6E74131C;
	Mon, 14 Sep 2026 15:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BD41F00893;
	Mon, 14 Sep 2026 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398679;
	bh=4CNMtyKSkXJHJHhjRW8A+X7egnO9+AYGH1BwgbSgK4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e3tSTWGHHI90XtitElyznVcsenUFwjuut1DFmFZYEx6CB4RiIpbw75kct3DayHxPw
	 riKvLj4KWn5uNgFgvdjI+tkzPl/28bvb/lv6vuDs1/NY1/aXX6BEkzuKJxwUZ2m5uS
	 I3rNE9OOS/LYz3y/3wqFwQZfxGF+eK1ss0yyOey9/YFc/EjyU9VGeckVdGAXNYDi8Y
	 7Qomk3UXImb7ge11WpVZb83FhHBUBUczpqVQZGijGyXka+l9ZrBgx1/+/xtqLEG72q
	 3clX9nIioX8iEXE61rrK49ZwJKP3vLs7BrhmPbL6TW5JxZzUhYre0nAqm+gpmXguCS
	 JoRD1L9XjljSg==
Message-ID: <85c24a9b-5116-4c3f-9bfa-ea8356890c9b@kernel.org>
Date: Mon, 14 Sep 2026 17:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/16] mm/page-flags: check page/folio->private instead
 of PG_private
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-10-848550f7574e@nvidia.com>
 <37f9a01c-4f6f-429d-b221-73ceffd55369@kernel.org>
 <2CC856D0-3B58-4C84-AA3F-58D457344A73@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2CC856D0-3B58-4C84-AA3F-58D457344A73@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5BD6F14000E
X-Stat-Signature: 7x1mjg3obap1o8b9h9gkphxj9b4chtjr
X-Rspam-User: 
X-HE-Tag: 1789398680-319747
X-HE-Meta: U2FsdGVkX1/IRGXTXvwUaewXhvEgxATtxaqvYxC52dAgNrPF7LraE3WXZElpiGCDDdf95KMAbQ9RoEK0vs6gh7vap3yuoJYd+XOillhuYEH48DVGGaFqN9q1Trx2xXTTCVRmcjaSMs+fxjs4zrT6cWVS+fploWeuIg7yjB1CmlibcxoSK6jfbYLURLbM1A216qytwa9SoLhhnTPL0uJEg4QnZm4uwl+o5OzsaB+I31I060w6XlCF34JCVql/KpLMWqpymEtnda/cYqcwgsLbO0yuH4SHpkve/UXiLhnvKYQonH1DO67gLv3Ho/4jpL5kYUgm0sN7zgA69NzXobrLnCCSCzFoZlp4PoxAYBgN0brTjshaLFogh9ufxR1GIqwkyFcLMJ6bbNAf+XSgKY3zLm0FOlHf1gPDxrNh2GRBnmnQzCdvxmosuCjBpqDOhdfkDn2z7UhBn/ytIn+WiHSIN20+cZJiWgkYxhkgVabuWOXukKRGnn9YjTv1jsOK0FQIpOT/bGkip5pTWYBwSXA4hVssk10KRzT+y1EHQYqrZQCx+etAlsqbQaJ/eRPy+SrzMy5Un2dTpRNdF2ve0z60EikmqEwHCs5e5qWTZJAGqhgOSw0eDHgFhoeg8+w6XDcLJ5X1sy6fjAzoDlYIGE5H7MZSc6tuXOqOKRVvrwijeAJG0wUGuQCH/sHrMkNx8H9nde9yl/rOfgiz7gizzhVAkvE7CQs/cQd4AbNiLzEwNWVxJ1ssKE3MAfEebZl/A34P1dmqNzgA/o+A4OVMac9W3U6GmT2RpkCm2Cg6A88MfBByStH2RKJakMZYIU7untt9wQI5h89ITLboqPkFAiWhOg8GYSrVRrV6jbeBzWaDc0N4KqqvVWk+tc8EYcH+AYPUuAMwMtYZMqQ/03OwmO2ACfts91xYQg90V96KvQXzR4TjYMU71CIvA8PveAq7pFmXd+ks1j7LxfwGiWvm3FW
 YTf7LGWd
 Os1zsL4T0JwUnBePIEdA8mfyqeRPyWNbiC5H+CqMOm8Q4Lr25+IJt1DKKd3zmB4uj7lpcsoJen+xRI00FjObullXdAaNpyI+dUuiH76m90BQ46kIFy6ucq+NZuH9kLa3Y5DnNiHtjBc6PuWNIFeONNShZlDhuzvi4xyKw+rXJypU0wVYfAKJCvC/C9uqkKiF1fXx5ArOHEHcC1h4zjHSci4QRIZTJIZzmZn6MFlXNyIpY/nRBzYIKjntA9cU26Ey/zNKI1qcUcHYG1LyALee6PqQgv0ZgLJPT3zgW4HmM8unh3F80KNIvxKewVt6lI/BYr3k+TJ+eP0098mGksawRFSoPg9V2i1kJSydRDvUrcOnlLT3hUgLri32f8DhNASc7+QOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 16:44, Zi Yan wrote:
> On 14 Sep 2026, at 9:26, David Hildenbrand (Arm) wrote:
> 
>> On 9/14/26 04:24, Zi Yan wrote:
>>> After the changes of the prior commits, page/folio->private != NULL is now
>>> equivalent to checking PG_private.
>>>
>>> Stop checking PG_private on pages and folios and use page/folio->private
>>> instead, except swapcache and hugetlb folios, because the former uses a
>>> field (swp_entry_t swap) overlapping with ->private and the latter sets its
>>> flags in ->private. Exclude swapcache and hugetlb when the code is meant to
>>> check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
>>> as a whole, so excluding swapcache with folio_test_swapcache() is not
>>> reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
>>> stable when a folio is added to/removed from swapcache. Add a helper,
>>> folio_has_attached_private(), for this check.
>>>
>>> folio_expected_ref_count() can be called without folio lock, so annotate
>>> folio_test_private() with data_race() to avoid triggering race condition
>>> checks. While at it, annotate folio->mapping too. Add data_race()
>>> annotation for other lockless callers too.
>>
>> Shouldn't we just move the data_race() into folio_has_attached_private() and
>> document there, that it can be called without the folio lock as well? Having the
>> data_race in multiple callers looks odd.
> 
> Not all callers call it without holding a lock. Before the patch series,
> it is fine for lockless reads because PagePrivate() is an atomic operation.
> But after the patch series, lockless reads can cause data tearing of
> folio->private. I think I need to add this to avoid the confusion.
Okay, but we should just keep that complexity internally.

E.g., just teach folio_test_private/PagePrivate about the data_race, because
that's exactly what worked before even with data races.

-- 
Cheers,

David

