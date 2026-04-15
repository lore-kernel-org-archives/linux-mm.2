Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA486FA0C30
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 06:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BF8F6B0093; Wed, 15 Apr 2026 02:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2708B6B0095; Wed, 15 Apr 2026 02:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185E86B0096; Wed, 15 Apr 2026 02:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 092C86B0093
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:17:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A50248B645
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:17:35 +0000 (UTC)
X-FDA: 84659783670.13.AE0297D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A41C1C000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:17:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ynDQi691;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776233854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2HHnAsQZ4MfYHDSO/spA2qHLwiRh3qZPNKbpsbyQmc=;
	b=gwhKQew4E7munrQqHkvYTMfuIXWm1Q9Yt99G/VYpe+JW7h8wtPz3QunDEjtVZ0yHnt1CLi
	jeZB4JhDjjq+ph9GlTqH49r2vkKAaYRxpx2LBrMlmQ6H91UHPYgygR2//yDtAGAwqgSeh/
	dNyoJ0bslJ+qn9cIM+i5OVQYeT3V634=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776233854; a=rsa-sha256;
	cv=none;
	b=4yBqlu+tqzFck7/yPu6kCP3vf98Sf4FNWEjKzLBAs0DtgVmR7/2Ms7obTaQrLIWVwabU2k
	OgSg0tERRSSsklxo/i0RxxTG08gpp37jxAjD8k3Fr7SU2db9DyWn+WdGz9wM6nii1sz8Gv
	dv3TzNYJP90/86rzqSLU7x8HRjP86mU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ynDQi691;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776233847; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=x2HHnAsQZ4MfYHDSO/spA2qHLwiRh3qZPNKbpsbyQmc=;
	b=ynDQi691ow2I3Fu/4pdfhP3OjMauRh4943hu2ZXZRfrvu/wP+NaoHzTSUEdFKWbS3mcOVSreILCJCGijua2REguj9Jmvw6f/5CJAbQeoQPV0rG+BJCHinfsyQ9GpIq1UGWpPlNLpmjc8jwLvXhEhf8kzrXol/mKlqe7rAso6MKs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13dQMQ_1776233844;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13dQMQ_1776233844 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:17:25 +0800
Message-ID: <19f2cc25-de3f-4a32-bbc6-44dda466f615@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:17:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5A41C1C000A
X-Stat-Signature: d718eeq9dd663qftmorue7p667csjct5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776233851-703710
X-HE-Meta: U2FsdGVkX18/IptNIAo8a1L22TRo3Y7ibo+ci37dKAFY9M3abQ2313VOgbqYZ0ekQfboUM/AaCTG7vCf+8Iw91bmW1dJvYYo9nV2kbUxChS4yKdT0AJ9YQgmjqEKST+vlmAtl9Nj8YIy7YzGD8i5/qa5T2z9Hqt3GqF6BUkEmh4nT3lpTcgjrqBjuyj2fOMHddLMg265NFPZ0thZVEhPml77srcsv67pZtClTggWt0wq6FMHmLbGSUBDD2OrleiVBmiB2fS67OBVBRlRYUMOsl7j2CMxsgsG9nKQSWmFTmf0mCcXykFfqFwCQH7rJZjDFV1c8Yc4chRlsU8b5aA7DYbrttOrlSbIGL/mi24FySVpqnIlfOCCt9/86XqG4m4a0W2s8QjzkctYWcvSpxwViKxjkCtXBsukCkBYHRXd2Q0TeL1zUJyqh4/43fhY7feDOpsMvmLMW3+jtlG9+MAhmLvbP3notxuhIhslHOHpI8f3OHlezrWI7uJfaUUh6j5u9aoVpStyuh4BFzQMyiWZ9Lkj0BisgSZhQL+HIzCqMj4fxqx+Z1NDt4WYGPM4s87Cig3D/SwymukRp0xXZfIn1NAjUkqaURIfdE/0aakozD2dJ6WHT08SOlZd6rtnGDisRpVu/5uecPxavkwPeaHP6g8TeLh1+Wpd2m21pHIdmnvviTRV5WRFrR9qL3NZ1SGms2XfZ6v8fdh4tgdxrDTh+zLx4H4Y+NsNZNJmOpheh5TXb1N+F5GQEG7OFzyDMDQNQ6Rly52Hv36b1lCR2uHjLRENiAkQcQ7lH+L+PA0yxF8mtbL0MKVnP+Y1RWucNtdYcEdWiHy7ljY5fCOLW+JaWfSkh0H847btzjdP30Uyk9dfTANoGBadUczptuYbmIekBho4lXRahI8HdO/ImcUw+14S0Qtjr0+Ub/ebbkT5qkZyBUBLr7EqJa3aMReETt0lINcm+teY5OsfiV0L58j
 rn/r7gQu
 PtLPN7+OoISRZ2ZFrxD7v9WZSJoTTvN8WK0dpwX08yrGETPPmzQa5CHPf0ulggg04fpmObaqeeDG34HtFcxMPjnzF+OkhYOHWn+18uP9sw/PgLYprwzoVg4l0ep2s04qK3++LMNWpwgAgClTyrfwUrLorTTSNxiMT2kRvjuNNQzUQOpR7zGu3U0MCAMrk9qFWOXSWmLZb/jWfRX2OoRaj4yxWa53kuYejG0hgW4/i57WnIPOrzR775peIWn/wSQG0a3wU9RqQUSHn+YMhez5/dh2cIPWqKLmY0xUlzSxCvAMzVupGOYGzfSmIHYa1G3J1eg2c2dsXAmuizDuzIqugxEwuu4X7o0IPU0GM7VSBqfSurgv+EM2MG+za3OvtKfaeuHvUM80aT9zapMYphxqdEEK2eTbLaVHLIAmyFIuSre1C9MHiFTjinXV8mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/14/26 3:20 AM, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

