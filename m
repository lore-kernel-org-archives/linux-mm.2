Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1F7C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D0A6B0096; Mon, 21 Sep 2026 02:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E436B00E3; Mon, 21 Sep 2026 02:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0176B00E4; Mon, 21 Sep 2026 02:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 756856B0096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:20:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E02EE80580
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:20:20 +0000 (UTC)
X-FDA: 85236769800.19.3DFA18C
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	by imf30.hostedemail.com (Postfix) with ESMTP id B904280005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:20:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WM4tumaP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WM4tumaP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789971619;
	b=Rjutdot0CKp0XMl1QxE3e58cjIhWbn+dk3RzFYW+GWfSrpfo6V/P9vj6zzTneso5NlHuw5
	wwbzLNgrN4HIfjJ+EuejUPmfC3eQVhaEClIp//lLgwZIX/jCQqtDVkkoMl7jMAGyfZYaRD
	TsXR6tS5oDI8cp2ttov6Izq/jT8PjS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789971619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/bj2URMYDlKhYuvrT721wrKXBMPsMox1kg2X8L1Ozo=;
	b=sSXgCTlGO2v1zcJOYwdM5T+Q5JL/ScVqzAqV/OL2/+hZ5M9xC0RVtgxXVKpEqf8gNRWKZu
	FeH3/yq3MvDgwlHvoV0c4GkG7WwgX3HNW4y6cpa8cXPgui9j8Q1VvwL+v4wmakjcApvanz
	rT7A1/PVMXeVkluYnEleipw2W0Zp0k8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n/AdnmXxXRbpGFInqaTSJTt65XZiIYjARrVazbI6Wb0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789971617; v=1; x=1790576417;
 b=WM4tumaPUMfSkp2/LhSaz0bfqlBPUiGV4paOgePn6ocrt2vV1GqT5T660mj1aSQ4tG7SXUpn
 oUBa5L6yv+db9pePHr4Zgl7QpdzOMDO6OX6zyMSI1hNv1jDl8OkTPSLdvKANRJf+Rd2nk8KboAc
 ieKZi6SvU5Pl1XufUEyEgVpc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f802e06ae86065bd;
	Mon, 21 Sep 2026 06:20:17 +0000
X-Mizu-Trace-ID: f802e06ae86065bd
X-Migadu-Flow: FLOW_OUT
Message-ID: <32b465d4-0881-425e-a199-f40af05f48fa@linux.dev>
Date: Mon, 21 Sep 2026 14:19:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/17] perf/ring_buffer: stop using PG_private as AUX
 page high-order marker
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Nico Pache <nico.pache@linux.dev>, Peter Zijlstra <peterz@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Kairui Song <kasong@tencent.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>,
 Vlastimil Babka <vbabka@kernel.org>, Muchun Song <muchun.song@linux.dev>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-2-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-2-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B904280005
X-Stat-Signature: 6rs7y1jgr9n9cwesj4oxxbeist9byf6x
X-Rspamd-Server: rspam01
X-HE-Tag: 1789971618-40069
X-HE-Meta: U2FsdGVkX1+/GhaKbbMZP4Nw4PZQT/y8zCRtyxtOR/Te8Ugbz/hQarxwPaDQohJd5bFltXzADQEsrY+EajQi4UWgy0yceASUzp9Zqs1KFcLZW1RYacFTzm+yYkXy9Hlz13HjZ8ZkBV5x2j/+vliPx/3EnW9hBolGZmbiEUGuboBpFnBY/sVFZcZ6TbTH9blGu6dPWuFJ2KLyyxZvi0eD+UZ+c5yLHKItRgNeXxqf8haYS7T2UQ4JkTLqRLBR1HoRJcvw2tIpXpPNb367lycAPt8jSSYRFUU2vDrg1KGr/1vx3l4PnKFOpAj9xGkB8SBfPfsrDQHKqzIrG6Mw6cg4Bo4milFUtYpxrQjDpUFoqxeDh70gg8Sl6S9Fa/UoaiY5IjGxoIoFq8Lp6Syp5u1QVV3KbT8on2cLdaWQ2GKrZXkd9VQw8YaG62sDgj/qJAhSOdusncw6g2y3AIl0jjvdemo07nO5YWyNF6BomFGF57ffgyMLDAFm1HvGgeVo+2mtbZOgTa25eRlnj1M0kFR2unscgoS8+gLMCztcaVUqObkQcaOdqTdm/fWYttRislENcIL8nGMPXADCdCxW3F+p2fg+vhhzPCUpDNDfb8P3DFkLPxc7DWlE/LpV+vCysWEMl1Oo06EO+shfYJcX7Y4pmvaOzE4pKEskGbjBv5qiMmdpvqxgu1+GMK+tnIv+XBUzRqnJuNtCFK/sWKanLM4/EEbtqEyaxwoUI8H7gALQuSFYePPRI/FGWPzWleis4vMuVfnSjMwmoHMvoxcLry4YVZfEw6QtzpSNCYzfPd87KS/3sTkE9r3pj8gh7t+9TqGnLLzzK/NQur5Qr3EOkchJbefG16kZ8zgXNl5e3lyBf/u5XTN3OZzaq4teRcWe2EJ2HvLVojEl5FbJJaIl6GygkHVz3XmwNSEJPnhVFqceWW9sz8yUFRbibFG83TgSQEBjuWjCTfzGaIEb43mtDvz
 OXYf6+h8
 CmZgUHtP5RSYvlQ4ll35CBTsIzKycM+jTceF0mo7cPBjBozI2FqmqXUeZpHTSZsbnP88qhvD94HDAEA9zjDo4lSOpNwLziilgoIR/7ZAciB3Gs0/0M7VLtN4ihunn2uXjFrFKOuYuX6w6B4IYwn6+i8OudxCUZviztaSENqbBz2dM25HsJgXKBRiEuOOWeOzfge3+tkR7OsRqPc87B6vwZVqv07JB6fufyZUQvrJKzRoN/kV1KLdHOV1TbHpygfNq1An7mE/27s8C9YcnOt0NF3EZIO2uqhuputDuUQR9rwNAaDmc3XBs2b3ahU+w1lxB5sKXmhzRzg6X96dL2D+Pj6JY0gQHpS9V1h7xi5OBbUa82MDX5X942uL/9Wfv+XdeXzst0NEwOanJ4YRt1NL785Utb57HAPhvVWbzA5ru+kdaVKBtVqBDNlSnJq+yfuox4A6bI7alH+8SjAUn1uO4RqAshxWqmOPfW5qmITGgDIiFhegjhN5WHnCPKDSHMpKr9ONk1Bodq+uHtG1aQk3W6BmHb4DXjShOMVxpXcQRF2tv0STXyacESVYTk53+pwQ1/2BDoTJ4DuunkoFzRDGTFgclhY9CSi1U2Ozdl7r/+8is6ktZqzaCn6dTTjcRqtKrCzzRwaTOql99P6OEG5VO3bsRpk+mKGjYEce6O1LPJSMkA3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:27, Zi Yan wrote:
> A high-order AUX page sets PG_private on its first page and stores the
> order in first_page->private. Stop using PG_private and check
> first_page->private for AUX page order only in the ring buffer and its
> users. This is fine because page->private is 0 for order-0 AUX pages,
> matching the page order.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Peter Zijlstra <peterz@infradead.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Arnaldo Carvalho de Melo <acme@kernel.org>
> To: Namhyung Kim <namhyung@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> To: Borislav Petkov <bp@alien8.de>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: x86@kernel.org
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: James Clark <james.clark@linaro.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: linux-perf-users@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nice cleanup! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

