Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF66CD041F
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 22:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F356B0005; Mon,  5 Jan 2026 17:46:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2C36B008A; Mon,  5 Jan 2026 17:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE2E6B0093; Mon,  5 Jan 2026 17:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6BF6B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:46:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A42D1602C7
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:46:54 +0000 (UTC)
X-FDA: 84299396748.08.D3143A9
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2BFD40004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:46:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m+ier64v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767653213; a=rsa-sha256;
	cv=none;
	b=iyrK+F2L5YB3XICps7xZwVsOJU+2E96NEGygymhSpCXMJOtu7EmnfVucd9A7kDDwZ9WKzy
	EBCEt7XZpoc931SMOhS4J3Qs0HSsJo/rgSjWzuMVar8RvMbwAndA8/jYqWtiK7KApEMwZT
	wh/dYkiqrTYFplF1xzBIn/W2T6SywlM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m+ier64v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767653213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79XQ6RhIGnnd6I8pgKkQJHOMbLiB8lF2So69igEwoAA=;
	b=FiLPKkhLoPa981sIjRqL3v2CrQiPa2lqGO0B/CJKIN7xCv8gmoHz9nNZRSPiU3KnTab14O
	D6OmZ4bT9zn1KqYXuRrg1eFVTksw5hv9dltgZcztUGGY1LKNff+406PmEvv6n815z0Solb
	Lw/2G4jtIj0WJeUDaYUgOSbbQNe15bY=
Date: Mon, 5 Jan 2026 14:46:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767653210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=79XQ6RhIGnnd6I8pgKkQJHOMbLiB8lF2So69igEwoAA=;
	b=m+ier64v0ySqhJplW6HeK3ggP5za7wzEsI8O1Mi7sF7RtzARaAI+0KouF0WymvLfEpoi8q
	c/eE69n5lmrQbmNm0pZMo8QOfRVl22T8I5vPS31HaY0wIFx5eVi3Nj4px35wU5+0ahtUrj
	8F9BnapdxHXTjcKjQpiD/rROVMtRgcc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 1/2] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <62ia3v3oduyt2srkaneccoei7cwimifwduarteyn2ugpmmbw3p@rivcqvcksgpt>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-1-tballasi@linux.microsoft.com>
 <20260105160423.23708-2-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105160423.23708-2-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A2BFD40004
X-Stat-Signature: ekbx9o11psyoirgwoujbhwtjpsoqmm8x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767653212-955728
X-HE-Meta: U2FsdGVkX18PSx8UekOB4LrQILx28dQaDpVerZKJw6HfsqTJORTFBQoy9V3yAbs2aLiwg4ZR/aQo/lMXUatYHb5WHm5G13FvGnyk7EY4SFtX2rJvscBg4+mnz/zywOHIOHAqRWaZjDm+5bC/myifw3MeIijGCg8LY4Zh1jB/nsz2ItCRGnvSHMja3kCt+zAopCNs7A+b+BAmHc7lE/CBgYNd8EoMPqtQewzlzDbQ82QbERK8Cb/pXrgb8USmhkeLeEX9koEO75uO6us/NDlpmCc7OBNOzQragj6Zp1iYRC9AVA0Smw6wm6HtejWgXU8Kixv8i9W1berAthwyXX4LTGiPUlHEY3mHlgcRqnCyS9OF9PU1lsDhuLJ3FYciBECLY37QkkXPjvnJeXV5BE8DNhH1Wu0bXXZW2GPBKiOgFxmslUfpbwsB9xQKTF+pHHOmV4teemeAGyXoIBOR1/yLDuUJ9Pn8YBTrJCAgzeu7OU5kxV9xEd7mTApjiSTpQMPjLww9bSz7Km5+NY39vEgAOyHzZ49RusxWJiUChyq+vwVLj/zBVjdj4IlkM+pbrzYPb2HBZNSfiHdufRORllHlGVN6cMDw2LCm2+FQBftNEu4tAXm/q9fWo/lOTuMcFYUVVdilvN65F7KhGKsfs2k+Q9+EIIitq+eoiKB0rqQhHYWTX5IXfWMeh1mJQyJIf3zuIIL0fJf6JCeSzmr/LPzCET5hM1eAXDoEi6KhLvLEEDtPPkBFCasfmXCS2xyhoe7M5lyYVSGW3zZFK6LWKsRO2nOK7nxfMR2I8oBYXy5kQLHsTTss5VSk967zuu5RYPPBiS1LxxccGX37hDRC2X3hEkbtbonZk7EekLBQKYFbRbydnF8L5SrRHh3fS6lsQ3zDTXA2zjJ6xtRKlIw655QcetoSKVvZSFY88BEq71MP+2/kwl1Xo+u+r1lz8nZfJuHJpN6pPjJQiId5mJ+bpXw
 QnFuhrmJ
 7YSmxlPPqGu3TVw311Uh8VCa9fXo1HpcB+E2sXCX78T1oLi2sRdcDDt8bWq7U8hWaHGHDciNcLlrhvFDCxZzV404629UfFuYQWoBZrlAA13/DZo8h3hzR8MMZoPjfoUAgRNwnF+53oOhyE91cmiOiV1i11ik5AXLUqL+6awf3occ7CbDuZpBrDl2hUuFHk2JgNJqCsFjh0RLyZNSTkB01SPmLwTNfmzenVhaf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:04:22AM -0800, Thomas Ballasi wrote:
> Memory reclaim events are currently difficult to attribute to
> specific cgroups, making debugging memory pressure issues
> challenging.  This patch adds memory cgroup ID (memcg_id) to key
> vmscan tracepoints to enable better correlation and analysis.
> 
> For operations not associated with a specific cgroup, the field
> is defaulted to 0.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Couple of comments:

1. memcg_id is u64 but the patch is using 'unsigned short'.
2. I would prefer memcg pointer be passed in tracepoint and then in
trace header file cgroup_id() be used similar to other users in
include/trace/events/ folder.

Orthogonally I am cleaning up memcg id usage and after that cleanup,
mem_cgroup_id() would be preferred way to get the ID. No need to do
anything now as I will cleanup this usage later as well.

