Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC31C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 00:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A121E6B008A; Wed, 19 Aug 2026 20:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2F16B008C; Wed, 19 Aug 2026 20:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B12A6B0092; Wed, 19 Aug 2026 20:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 689B36B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:14:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D19E9C067F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:14:09 +0000 (UTC)
X-FDA: 85119725418.03.6CE5D66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3444A40005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:14:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAcEbQSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787184848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrAZoFB2O4ijHVXZLxifKgZ8fU8/Rsiq/ZvJdgv6ZAw=;
	b=nTXFqIaau3+cRsx8d5LcmpV0zjFJNwPCqIyb12wIAWxUpd7IbHf1xdE49Xtr6R+0qnz4PT
	pl3yWxvmVTQfTUj/JfzfenQgnhucws0izQP3UbSnl/3ZTDi4Dnzh/ywhncbm8wZCKO9dfN
	u9I4GH1uBGIapsTnb7RYbFl12g4o/Pc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aAcEbQSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787184848;
	b=bkcWytZqYmcfCuXPPE0JXiJj7VIDiLg0ylVoB8v5Qpy38bUi8gYCtnWmbrvRu8yTf2squ5
	KsuM1HmqF0YdEZ4mtCVeWK6xHY3yLfyrWyyt1O9SkaoUxaxRfZmEC5unC0UKLa4O3OAdH0
	KtqtOM5+eCdnawv+pZUJnT1mmmn9L50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA69F40E1B;
	Thu, 20 Aug 2026 00:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39601F000E9;
	Thu, 20 Aug 2026 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787184846;
	bh=HrAZoFB2O4ijHVXZLxifKgZ8fU8/Rsiq/ZvJdgv6ZAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAcEbQSRvUAdr33zTA4FXccyAXg1kygJsd4ah3MBPqCNU7I+IgvLQhsrZY0AUSjvC
	 4nlgQSrhQZlXPxhekgLQSirgnqyqvkBgyAg/f8tETcCmz3tSISyr60zD1MjjwzpPT/
	 lFnei0Wp3GVXDjUGhk3F7IZO10YADXCYMu19p81phqAZ8eckNmxoTTTRjKj++er/oW
	 hVrhyFBXowh9pJc6ftyOkd8H+yoRnwz5kU7RJwEzQe4nAjoIbq6DwTQqUbvtxAmK5q
	 eS8NgTadFlgfiwsn/kRP06Owzd4gBBkKcgZgtVd85ktUAKGm/1XDi4oyKMLab3/hVn
	 z9wBt5zOf/jxw==
From: SJ Park <sj@kernel.org>
To: Anshuman <anshumantewari123@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] selftests/mm: check stat() return value in khugepaged get_finfo()
Date: Wed, 19 Aug 2026 17:13:55 -0700
Message-ID: <20260820001356.87221-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260819121426.49500-1-anshumantewari123@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3444A40005
X-Stat-Signature: 6f14chf96ienuapo9mdxzrkt5fc54oqy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787184848-554119
X-HE-Meta: U2FsdGVkX18DHSeaLUp9sQoMaB2qwnkPwZ3P9VHPcB6tIZhTg90wI9KS9DoXqs18S1vd7NjBXmGGADe7U2Fo4ZFot8mxmMKMT76p3RI3NOptABA92Xn41kmyZ6IkbgaKpjpMAmuegc1/FAmgeOF0CgRM0zw6xAAhSGKRloAf+XYRuZO2pX728LKgTHcnfWGva9tSYygsr5KkDQetUxkrIVb99xRvrgRQ44xsfMTPelzf9a4hwg6ONuAalRwrSu5iofbn6lo3Lv0W1/gSxUDQMM6Q7XKACBJGaGE5LpgSvEekJX4mRAE8JpCA3tW7GFuYilAlvX/DNj723e+58JM6LMt82FLCO0SZZwfUJIgOJH7kPIOd2cLwGCJosfQvz8bcfrMJKrdx2jHPDkMQK1drpT7HSF1s3AZJKiiywQs/TERuFHH342dtyCMqFUgfeTtO1vbkZrdDQ9poLHDuJ7cUz9jxXbXJr8nNbmkTmPlfpqZiXqPZlkyBcPOrCYRyFirnXpSVSvpwUHAWVU27m4gys/akinbsmyY28Sq2+9saODmZEKODt4AOO5tzJqrG8kIoEjhDjdjGXJNYyWAMwByQo+m986IJW8cVwnFJZ5DIfZm6TmyECqgO1y5LNfzD1LhQ5QXH0mXAjC75HtrrW/T4mAA4+iwvwBnqOHgDQUllqdij99stJnfp6dIVnyunITF81ahJE9e7b8vvaIMmesaOwZ5einJ7sw74nKz412FN030uVo7D4FoHqDDfwcY+5bmE3Iamq6W9ynWn3oyMd32fZcN65Qh+h1vpjSq4QZCHFey5Rqee0THi6Q16o0fATV5Jn6JZiIR6xXVI6jYh2xzqU48cBfpZO3S3k4IHx8cE24DCfr2TQLaOgCGLoOCZTX2duf4GX/rKbF+u+9KepyJsuCuJHvu6w2TxOtljZMIXzTP3Y/1OyfxdfnEwvMtJ24cPFHOdm5kLIF0svToC0+D
 gM8L4hOK
 mlc931xGv/wWgtRoEgrrQlER3bI6urOi1M+OrjXqUFcOnVafJHlaM1CDi/N8w1jTAhGkIrwgQ/eCHFhTZWjIceYaiu5VTi+t+qf96+Wza0MYAgtQXgqwMICLqb9xpOMF5V2oxgqiK/gePqu39HeINOjL6YJ1V89zaAchsYyZCudaW4KDkpjxJIt+h+ctXt4ckieBSO3sA2DFCq1AbxewLgx7EM1dJqEnpXkWJuELT1CsSL59y/YcwdPtVFmhLxa+BcF3i+Ma4WaVwgQKdE4MuY5w8Bqm+CUViK5KitQ31fLZCdrEzvoVpI2b5/1eYEK7I4djgTEFBcgoRZ+dKLUvm/+34tv742ShDYfSot4uINaKlD9d04EuDqV/toJYdfl0tE83SDYjbb7YBt2jpaharGp6Qvj5Laq4AkxfR3OSwrQTBSTQ7e5Ihi5q3pJSN/T287/E/VvQIpcj3nFQPm411ozoukDa0WLGG+Vi+ISHGIjueXdR4C5V+pTwQ3YsSIFZ6ketUzweJZhaKlafmQFSc2ib4Rtt02dV9lY+Y5ORUMOooItE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
I added them.

- Zi Yan <ziy@nvidia.com>
- Baolin Wang <baolin.wang@linux.alibaba.com>
- "Liam R. Howlett" <liam@infradead.org>
- Nico Pache <nico.pache@linux.dev>
- Ryan Roberts <ryan.roberts@arm.com>
- Dev Jain <dev.jain@arm.com>
- Barry Song <baohua@kernel.org>
- Lance Yang <lance.yang@linux.dev>
- Usama Arif <usama.arif@linux.dev>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>

On Wed, 19 Aug 2026 17:44:26 +0530 Anshuman <anshumantewari123@gmail.com> wrote:

> get_finfo() calls stat() to get metadata about the target directory,
> but never checks the return value. On failure, stat() returns -1 and
> leaves path_stat unmodified, so path_stat.st_mode may contain
> uninitialized stack data.
> 
> The code then checks S_ISDIR(path_stat.st_mode) against this
> potentially garbage value. This can produce a misleading "Not a
> directory" error when the real problem is a nonexistent or
> inaccessible path, or, in the worst case, the check could pass by
> chance on garbage data and let the function continue using an
> invalid path_stat for the rest of its logic.
> 
> Check the return value and fail with a clear error message if
> stat() fails, matching the error-handling style already used for
> statfs() and read_file() later in the same function.

Makes sense to me.

> 
> Signed-off-by: Anshuman <anshumantewari123@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

