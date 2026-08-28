Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03639C61DCD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6286B0088; Fri, 28 Aug 2026 03:43:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E971B6B008A; Fri, 28 Aug 2026 03:43:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD726B008C; Fri, 28 Aug 2026 03:43:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B831E6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:43:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CCC840272
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:43:04 +0000 (UTC)
X-FDA: 85149887088.23.97821AD
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05929140005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:43:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kmtXq9rq;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787902982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEgQo3eOgny9l2o03/iYJGapWWoFEc2N9vA7ux6jHA8=;
	b=jiJwjXqbcLw+g3+At9cZI1TYd5a8dFjgjt2/AnJjJfrZ5LDES4tlXA/cC7Sn0oMlbvbSUG
	qIhNFmiFj6B707sPTdDj5gBnyWAkz0BXP7MfH++fel3qyBYbkh3kxV+geWXQUvvB4PDm2j
	/u9v2XCdjhG5hJSaDvBGKSRVaG71Wtc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787902982;
	b=MjoR4PW1GyD3tgH7dKgL1zUEN276421JmpFg4A/keOOh9+CNQ3d9NgGzJTfZOVKI3o6+JR
	BdRyISf2l41GZmoDGfLsFgAjzCBU5Px4caEyrOtaaNaLdQEN/ttw+/U/i/5sGujMNtdg4R
	PQyQlG5OvdShJib43oZqmpBXvjPxX4A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kmtXq9rq;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2sUnP7K6UjR7ZhmvbxXJVYjsxzXd9zkgTE8q/CgsGKo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787902980; v=1; x=1788507780;
 b=kmtXq9rqTX8f7CdlBzuDLF9fkr549DvBNKCDOC9CjO10E886liY26KtrfRQx+i2zSNIL1Cl8
 q5nCf8o5/5FhxlJkJavyD0J7n/NcBhVNzJvlAO6sKluflPxEMhAQZDW/gsGKjMp+ZDn+7mJ/hIp
 6xQH4v0QwXk4+QcYyzE6//jw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 69c5c08b3e19d467;
	Fri, 28 Aug 2026 07:43:00 +0000
X-Mizu-Trace-ID: 69c5c08b3e19d467
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 15:42:56 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, rostedt@goodmis.org,
	mhiramat@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 0/9] mm/mglru: suppress empty page table walks during
 aging
Message-ID: <apE8AAk-nVwa4tvs@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
 <CAGsJ_4yDgCt6C7tS5YR8Je0OEPoYFgXNbG-T5KLmF+EdBHA9=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yDgCt6C7tS5YR8Je0OEPoYFgXNbG-T5KLmF+EdBHA9=w@mail.gmail.com>
X-Stat-Signature: t7asnbbsh7ocsw9ci9d56mipsscjq394
X-Rspamd-Queue-Id: 05929140005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787902981-773590
X-HE-Meta: U2FsdGVkX1/WPbB5lKyGNWrncd3U6KgIlx/gwovigNPzzL+YRNOEZ8+N+7X+U5ekXJa2wvsw6HwOfPWKNYRBsJKIPHAHpCH2M4i8mlN/s9xQhFRTU6zwhcCVtjV0H80IyZPN7QKfdlqRtw2DnCVdwDREaT9NiNRyfPEf+lBJgkA/vLkMe4+3tBshlI6MFFiH7DQN8gpt2g+AD2sBbjT8CFh3Pb15lyqI3SZxNW8qmlhl6lyUYpDo/fbMS/MWJHiYq+uy6v3p7kxORnaM96mib+80qD/bdCPCDoS7etQ8SJr+aOrqLmxFy1GEdxRRTR++em3q0FH6uQjwWJXhXJbL/IgQa8h0GihHFD+mmVejexAX4hcMi8/IckrEYoGQeJ0KMlmrvA5rowEA+n91aOLdeQMOz3qnK00VW3P6lhd9rvXF9dOYTtKf+pbBamGDRzIcw/gNCa4JVsv7c7WWcP614Gmal5abI+oGUnV3kfum3ghjOsK2IXZqBcfEapJRupM9CURVtDAr6d/q7spJ3L2TPVlfie9QCo88OGH3712au6gTmUbe7sgu6AKn0fnaT8U4Qntg6MblDTiFi7oCSwOpE1hK8gJbD7fnvEkxjJ+FDiFOM1Mw8tcoVU8gZGvRBn9w/vDtQc92JrwiHNIdOuxVwdL8pMMkJjXmK/d+xk5TYCUOzKbcy/h6iXeFkICfmPSIuJ9shVPmiy4srZkDYoyGpLxJsMVys3t1oYjcQuBP+nQkKa4xb+bpUZDunwdomzp1hyfQ6Dz3PfUv6/buQsC+0XagNFUdb8WUxbgAVg04uVaLXe0vJFod49Zk7do8D98hfcmizoEpde6V5z4Y2n2gnwVNlU5EibU5XYA/iVCXj+RuPWufjcUK0Sh72pUM/hqQ3K0YFHCAjzqgDzxoDEBeete/ZOxTz4xXFelm1ty3/hq7WCDUeGqTWmb19G5YCM+7nGdXv4GAhdpSnWxpSzY
 GcvcsLmr
 T5X3DCdqHoSHqBmNF4J+6Ja/kWRxA0HBKKzgPDtD119kxYqE5hhWAVannqrJ36+e8/S4OIKDiCIJq2ereB8EJHqQKWaLiq+ZYYMIDJrTqd7QYnTZSZWIaYq+NAV8A9lz6lOsr0RD+uWjZ8a19bG2WS8zYLJgaxcAlOrgseCJcifpSgQF4xTa2y36dq9iwOnoVhwVggENtNl7Z+ARA1Tw5OwaE1qW5tWTVwtkgGGtr/ucl+QzptH/2zVq5lt7/fQ3TumwvMdH8zJMZBE5aWRTHEGluruAVIqcq9mEtZeAUb5URgMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/28/26 at 02:11pm, Barry Song wrote:
> On Mon, Aug 24, 2026 at 3:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > In the current MGLRU, lru_gen_use_mm() will mark an mm for all nodes at
> > each context switch, so on each node aging will walk into each mm's page
> > table independently. On a multi-NUMA node system, one process launched
> > on one or a subset of nodes, its mm is walked by all other nodes's aging
> > while finds on pages for their lruvec. This is pure waste (100% walks
> 
> I assume you mean “finds no pages” rather than “find on pages.”

You are right, typo, thanks.

> 
> > are empty on those other nodes)
> >
> > This patch series suppresses these empty page table walks with two
> > complementary mechanisms at different levels:
> >
> >   - empty_map (cross-node specifc). At mm granularity, one process's mm
> >     whose walk found no pages for one node's lruvec is skipped on that
> >     node between re-scan passes.
> >
> >   - PUD-level Bloom filter (general). One level up from the existing PMD
> >     filters, it skips any 1GB PUD that had no young entries last
> >     generation - namely whose 512 PMDs all failed PMD test. Cross-node
> >     empty walks can prove its effect the best, but it also suppresses
> >     purely code PUD inside local mms. So it reduces unnecessary walking
> >     in any workload with cold areas.
> 
> I assume you mean “purely cold PUD” rather than “purely code PUD”.

Right, thanks.

> 
> >
> > The two complement each other: empty_map reduces the *number* of
> > cross-node walks, the PUD-level filter reduces the *cost* of the walks
> > that remain.
> 
> I wonder if the PUD-level filter alone would achieve your goal without
> requiring the more complex `empty_map` code.
> 
> PUD is already a fairly large granularity, so even if we still do some
> redundant work, I wonder if the overhead would be small enough to make
> `empty_map` unnecessary?

As replied to you in patch 2 thread, will take PUD filter alone in v2
as you suggested, thanks.


