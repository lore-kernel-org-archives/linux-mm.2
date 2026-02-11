Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5255DEB5947
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 00:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C106B0005; Tue, 10 Feb 2026 19:17:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729DF6B0089; Tue, 10 Feb 2026 19:17:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6359F6B008A; Tue, 10 Feb 2026 19:17:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E64A6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:17:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA2DA1A0191
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:17:51 +0000 (UTC)
X-FDA: 84430262742.29.7BC7E5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 244A3C0007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:17:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3fBm5Gv;
	spf=pass (imf28.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770769070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwSDm0jLIQl/Dzlvma40bCMmh0XbO9qBdOum/94FVCU=;
	b=39V0Twjud6cPpu7d19I/s1T+vJCTAfrIE88GWFpiLbUs7H0etvBmDE6tgp/LyV38z5zISR
	9cT6e4E6kghDCPezoUBM4ToFxlrnuMDMIzGxuFgZMEpQboPwdoqtT4PBQmnalRFo951wQV
	vclLCUIV40932sREkkASc+D3y0YbQ80=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3fBm5Gv;
	spf=pass (imf28.hostedemail.com: domain of namhyung@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=namhyung@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770769070; a=rsa-sha256;
	cv=none;
	b=jqPURKw18cjlVBReXGRzOI1GZscNVMdeFxCbXSYUdGm+2qxlwzVUiHdshrXZ69GswNMALP
	RkUf63aAs4jQMhV+7a59VPbwkKinwKBPjmJZREc5BW2jVOiUL4q8PLbUsCbvmpUW5h6VVN
	imlA5K3rLu0hpn/eK0lJ6Dvkl5dgzeE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E86142DA1;
	Wed, 11 Feb 2026 00:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7E0C116C6;
	Wed, 11 Feb 2026 00:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770769069;
	bh=X/PX6FbL34s4xBDSZ/RSuiPyyQFzkoB8wVlhJlcXfNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3fBm5GvY71c46Z3yyUGu+knRQsYtlO5acDvD8eb13R8BszofgVIMcbhTiBqShC9j
	 MGZNauvOVF56+3fYEW97TuWq+7OD0vYBzw8f1POL47D7+I2V0YVc5x1d2Vc8UdDxIq
	 tHatD8oxuZOMW5QfnIogRP4pCr7LrJjCX8mimi5Ji3h5y4t5IiEvaAhE+0A7AWl4zq
	 gPPWSULN9qiU0gGtb21aSxTUtSy+/2BYMPSB8AV+P2VH8qNy9DhFUw/v9B/2XBaPY9
	 cr9cVvNq/TqEtAOygG4DS0oTDFY6qUdQbfiMwzLkhTEGk3GXQMae5eh8Uy9n9TGtxB
	 3T+LQYaWYipBw==
Date: Tue, 10 Feb 2026 16:17:46 -0800
From: Namhyung Kim <namhyung@kernel.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: Steven Rostedt <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
	x86@kernel.org, linux-mm@kvack.org,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	"Jose E. Marchesi" <jemarch@gnu.org>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
	Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
Message-ID: <aYvKqse1aXxGqFwR@google.com>
References: <20260127150554.2760964-1-jremus@linux.ibm.com>
 <aYTgwoyRl8kxQShT@google.com>
 <20260205135411.5fb22df2@gandalf.local.home>
 <113e4e4d-8b7a-437d-a3a2-de74acc9ecaa@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <113e4e4d-8b7a-437d-a3a2-de74acc9ecaa@linux.ibm.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: ygspezbcqgpx3oy6cz5k1gaawkoisc6u
X-Rspam-User: 
X-Rspamd-Queue-Id: 244A3C0007
X-HE-Tag: 1770769069-558410
X-HE-Meta: U2FsdGVkX189fplRdC6z3KlajBMJ0mVmTrWuITO9FZAIih4HP4BYbcPpKRfELQ7Tfsa3CIeLS3JMfphHKXuBntgJOjaKeRRVh9iB66BQY+uNpWImxgBTjcJ8keP2UZEYoHwPTga7JHw/DqF8ikOcRaWKbPHS6A2bDnCp/BFVOMocuPbnMyNJjBCvl54cMJAwVdP1KnQqQ7CQBOZQ7Mbut8ufPf4gA/9F3tcOI1YZh6RfmdDseDCLrk2XhmnUfRQoK4wvZ9gWk02H1i/DxKT1tzksrs+gx9LX40BblQQHaoMW0SI2+UhJb0NcJ1EvBUdBwkmya/Er0GvodVVi6/NcKFku5RhkGc/84Marq3K5h1dvF/22pFwhzXfRc+q/oF5lArhOakhjzgDdUoLYd1E+GZdA1Kp5Wd0xhshStMa92FfBtoKzzalE+MGezfHXpZr9CM5AfECQsIWR+rknGgMY7RO4r1ORhUhwlI70gQ2EADwPRlryDSaYuyv431RRDk427xIr//w8efZHLGZE/o6sqdlnKeXqqJCfSCjAyWYI6PDMW6ERsMMLSGtAMvQBaqWzsLSw7EPmj2TktAeVyW0ECgHMhzXM1DjBdP4cFnZ3F9TQVMo9iLl3sdBC7jPgfvUS3Tbl6F53gRiCBCZN61HIeD+udSR39vxs3ClkAsejjZ459ELOJZ7VD1vWBcBh69hMCuysbVJB7nsOzfEREY0N0d5/P8dkH6dtlRnsnaawuhGGu4wQ8e7KVgSwrUMYvV6QYkF/5RhX+P5XwlnWtnTwieYgm0OO85xBfGpG+haOlbJtGDYy78VsI/TKUVQLaA3Rm9Na6xqMDN1ijjdqC4FT2sa8+YiIVAhE0HKEyp/npXh/A8e3v3iJn//tS+Lm8BcZOZpNt7dM/FkJexFRzZgQUgoYIPX0mr+Kb3NOC1O9KWPqk8BaUPymVqHjqbpe/6HWjDDY2IxocZjHVN6qF05
 edkivkiH
 d1V6MKH5JOY174IsYAabQBEHkwpTGkL/Z1hpLr82Rf+CQxFFiqKbTpz342Z+0k/3tne3Vw4Yil7vtUVI/JoOBpKKdTu8Ygagw1M1BoizQ6gNzZpxuJO7nVD/zzWIgz8Y6R4S4VzBrkKEEWOYeRINF7D+czK4arbDz7bTGvEJnnc4k7lazE5jO+77cgnP6gXAwyUWgyNAi0fz2MvKMso7JTLAjy/z5CPqFK3zftv3uYJalr3AfIsk5K9+EZWanFuyf4MpmEeIwzFl3F1LHNp4gnOVznUicD7Jp+rUzXp5EEkJwiWzopU3qdeLWsZKhOjeDdAGi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Feb 09, 2026 at 06:07:59PM +0100, Jens Remus wrote:
> On 2/5/2026 7:54 PM, Steven Rostedt wrote:
> > On Thu, 5 Feb 2026 10:26:10 -0800
> > Namhyung Kim <namhyung@kernel.org> wrote:
> > 
> >>> Namhyung Kim's related perf tools deferred callchain support can be used
> >>> for testing ("perf record --call-graph fp,defer" and "perf report/script").  
> >>
> >> Is it possible for users to choose the unwinder - frame pointer or
> >> SFrame at runtime?  I feel like the option should be
> >> "--call-graph sframe,defer" or just "--call-graph sframe" if it always
> >> uses deferred unwinding.
> > 
> > Currently no, and I'm not sure we want that do we? The idea is to use the
> > best option that is available. Why use frame pointers if sframe is
> > available and it's being called with defer?
> > 
> > If there's no defer, then sframes are not available, so it defaults to the
> > best option available (which will likely be frame pointers).

Users (me, at least) may want to compare stacktraces from FP and SFrame?

> 
> Maybe it would make sense not to "overload" the perf record option
> "--call-graph fp,defer" and use it for all deferred unwinding methods.
> 
> What about "--call-graph defer", "--call-graph any,defer", or
> "--call-graph *,defer"?

Sounds better.  But I think it cannot enforce "--call-graph fp,defer" to
use frame pointers when SFrame is available.. Hmm.

Thanks,
Namhyung


