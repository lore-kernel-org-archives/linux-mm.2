Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B17AA106FD9A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8636B0088; Fri, 13 Mar 2026 04:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0DF6B0089; Fri, 13 Mar 2026 04:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38A26B008A; Fri, 13 Mar 2026 04:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF66C6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:37:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CB9A1B8ABD
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:37:04 +0000 (UTC)
X-FDA: 84540384768.14.AA3C754
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2382A160004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:37:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="GpSkwo/L";
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773391023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcDxLG5uEtNMt8xXPoJ/gCvBirV4EE92pOMRGDkziaE=;
	b=zCKelz2eYOt3KRZT8e8o65ml9OKafFCnU5B+5AR8qlxNsoAdO7c23u0KDRVXT8R1YLJZsE
	DtDFgDi4ETo/w+w3Rt+S73pt9inXjF/w1P6GzbWKBBKL637+BP/5UN1rRGYGHSbkjbu2dw
	4vPLSRJVtQBasgpKfLSZijZZbq1zWoc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773391023; a=rsa-sha256;
	cv=none;
	b=Mrbv+a4oi4GtWMMFcdvfXhkQIywf2biW2xHEH1YDcWfaw0iTIaTJmegU4CVBrHsWPbZZ2X
	gnEf5YoqxCdBnbqwC0MD8yUuSr58o1wmWMj902SrmnqeXzk7efgRE4QujuyfuMcB6aXH48
	dda2kZ05vtEHChTwnvFNKGzDrGp52zs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="GpSkwo/L";
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QcDxLG5uEtNMt8xXPoJ/gCvBirV4EE92pOMRGDkziaE=; b=GpSkwo/L2sSnDnVnfSKWuHvFAp
	P6sXe6koOWOcMu0noMrnxQSEswq+HzXtaZmGp94O7Nfu0NqPmEvRG1TAAOG5xZjX4mrza+kg+2/MU
	GqohM0p1yGqwjUdvcuM2C3OFRENUwD73fbmW9RB+j7W6+/tQyPAx7bijo4bdIEyWFMaEjNyDQHpJF
	6ZqMAI88RpbrCA4oNfWoi4wDYGGDXfBhKNUXeS4wc/5/LHjZnwZNZjAoOdVUVIElDoFtfrAH2pT7K
	m+2K6VouAhxn8rZIUK1H5er403cqB9/neIM+yIHwSyn+XbXbgyKlPpOmsS43F3070xdguxXcpTuWh
	Od8rNoPw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w0y0s-00000002sTv-3H3S;
	Fri, 13 Mar 2026 08:36:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B6634301BD5; Fri, 13 Mar 2026 09:36:53 +0100 (CET)
Date: Fri, 13 Mar 2026 09:36:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <20260313083653.GI606826@noisy.programming.kicks-ass.net>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
 <69b34efd5bd1a_213210038@dwillia2-mobl4.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b34efd5bd1a_213210038@dwillia2-mobl4.notmuch>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2382A160004
X-Stat-Signature: 4jjbsa9jkr5w96t7hzxyq4mmnzqhcu4x
X-HE-Tag: 1773391021-591204
X-HE-Meta: U2FsdGVkX1/lh/3iAvB4RjLUePFf3lxcgSqczyNVI5Lg40pcPq9RoPMHi95S0gMyhCaG6iyfd6yNPdCFlaBOsgxs1Iy/L5vUIH6Ricwekig4DWvgATGOckY6PBbCO9h+4z+zDjCuW6N0M1ZvLW01cN/chEjOTQWLvb5mIsyTzu6J/0jydJhBQDdYWRw4MUL/tVrEEb5K0qgJxYeRltb7e+6byGwepkHEGaGZVa+RY3Liu7qbOsra4otMszX5chzkP2CrPUekQlFuQXqalKsjmTF7ndP8xOYLcFWUNpAUn2onF7vYXdCWFvJOJpwmyt9RwBWcxD45c6c0WV6LF1bjEShcIzBM23pg349AcgYfjcSonk0EdzefP7bFRUgZyMPI61GkovkZ0DdyUmfW038R0nuiwtH429vmkb8vbgrKRy8SsjXonyfyfPmJ3Q3+vPLIwXFK727A1HqgNBIkL91kaGbIGhuofadHdwK437d29WKWp+OhDq9x7xly8nQAGhOT54+EIp5Pa00U1QYBoqcet1A+37hv1cl/HyipmLMBcbiBNYJJe1Y42LZqKWbCMB6NpERz0v2ySutjrfADIheP31b/pCL/7t1ak1Tq1uqxpFACtfqojPCVfJsIYzTNga3VFZoXM5Qbgk9ebB7hZwBNFdwinygATPu0vCvmCP2kb+a6nKZGscHEaRybTG/ec/GtZD0rhkYF6cZ5U6y9bl5pF9iLlTFBgyZ5LQlotY9wIQfixY1Crgx66MYByexLmN50ubFysWwOQh+AWuS6R1ZbsnKXGOHuGWaPLmoonVm7DL6iok9p6wwZ+meAyAu2WeFK3X8SGMQHW+CuvFD6SSk2n/2mMcckSMZv8QS8iy4YnVIq+O7svfNiPJEiwzjn391h7vGF+gZMaDoLNYUMfSVIqAZXEh4DqDw+dP1eBbAWvZzKEPdAkZmFOqg6JsrOjBhdzZ2NkEdaVu6pKcyKNpM
 6A3zmddj
 1Wml+I5jtOITWTU2Hh8rvMu7TkiOpgjYQkIWBkjzpMUOUDQFAX+IEF898IK4MHj8e0XZFNrXmJLZP9zaN3WS6n2U3I79Zcry9vA2gezLcCdTXXOJjI9CiUgRsrPwFxHaeU9uO3rpxfY1kKi0ComIzLvlI1SFv1yI9vSbzZhavRmtLJVmG/vnhOou+1pqBAoFLvOP+SjE3CJfYEysgL2+UH8CYyMUAK4rnoZC5k1mP39zlQ9HBzUWI2S56Uwz2yEuld4fKceoUpgTImQ4nFdI8PqJGXhg5svCRYAiL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 04:40:45PM -0700, Dan Williams wrote:
> Peter Zijlstra wrote:
> [..]
> > However, looking at things again, I think we can get rid of that
> > unconditional __GUARD_IS_ERR(), something like the below, Dan?
> 
> I think it makes sense, do not make everyone pay the cost of
> __GUARD_IS_ERR() at least until a better __GUARD_IS_ERR() comes along.
> 
> I gave the below a run through the CXL subsystem tests which uses
> conditional guards quite a bit. Worked fine, and looks good to me.
> 
> So feel free to add a "tested by" from me. Not putting the actual tag
> here so that b4 does not slurp a tag for the wrong patchset.

Excellent, thanks for having a look. Let me go write it up.

