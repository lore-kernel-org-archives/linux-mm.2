Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 031F8E9A05B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 01:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6106B0005; Thu, 19 Feb 2026 20:17:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3ED6B0089; Thu, 19 Feb 2026 20:17:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B4F6B008A; Thu, 19 Feb 2026 20:17:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 125626B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 20:17:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 953748C951
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:17:05 +0000 (UTC)
X-FDA: 84463071210.06.12FFBBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 005D5C000B
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:17:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQehS3Da;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771550224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3h5Ga7oZVQTZW27w2Xs6xKwDQKeVthSFM7qHpIGIBM=;
	b=zS1JdR82BMLk00Lw+gnxjqgG3NuINiU6z9zRdXmZMV+J/7Xn+NWmHgR/1Z0URCNavraJvg
	MwMpzRL1CU2q8MfyM2nD/Tc6rB0A5eEntKNq0qSNilsROn2IpuO/KrGzjz/zJlpCLV36iR
	iuk0iqCBLNcHXINVpu7HdJwczyfLbcE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iQehS3Da;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771550224; a=rsa-sha256;
	cv=none;
	b=avRl801yvXbszUm0SJ/4V4Dy9QCIVhLfcURVcYAs1Dle4gYT8mCSX/KaTbUXHBE0JfjJdr
	DkaefGmchb/GZpXAFaPEl2/clJFHqS5vtGRt3AQo55k9JduPdzl8tGHh592IeNnRX5pc+J
	saY1mGE36ANjo3XcSFTpxAIhazb7Jq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E20C60054;
	Fri, 20 Feb 2026 01:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4BEC4CEF7;
	Fri, 20 Feb 2026 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771550222;
	bh=RRAq7nHO9cD8+j6WLthwWQnJar0PvnyK39LfAXzcAWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQehS3DaD78CseiEbUV90VwQuHE5Die8VvF7FCdYzxybkdsTpRnsnd70Z+zsipjlc
	 ONMAtSbIkxrrMjxeqctc9cOqYRDcopYWuMGC7SMgTwwtqfeNgEBgigkwYOt1H106IX
	 oow2lZwx9E/4M0EJUmZQ0lLD2//GLZgnaHqTNNO8SGlR7vtypHiGqYdiM/AQJn/Ddu
	 UZQo7Qg1J6hZ5ka3D8UYZYwtC0+d1cRznfZ73hZ5NxhQwaa18bZSCnT7AdpX5OCCRv
	 mzPQtHlQvtjE+GsvhMJyZjXcjyg3pX29FUn7Vc6RoWY2W85d6lsQ3dxcramrmFtFa0
	 j+C9+1VGLp5Hw==
From: SeongJae Park <sj@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rostedt@goodmis.org,
	joel@joelfernandes.org,
	kernel-team@android.com,
	android-mm@google.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Petr Mladek <pmladek@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/tracing: rss_stat: Ensure curr is false from kthread context
Date: Thu, 19 Feb 2026 17:16:59 -0800
Message-ID: <20260220011700.127763-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219233708.1971199-1-kaleshsingh@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: naqpxfnut6tkwccahsygrw36g69i7dey
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 005D5C000B
X-HE-Tag: 1771550223-181249
X-HE-Meta: U2FsdGVkX1/dJR4rOh56SFKgdLCADTaw7Ur7SaLID63zLnTzdGrOdf9BJ9DcM+Dc+960+Fg9p8DWzIObpvoE/vCnFeDn54DUcg050w4vsmn7YNXVqsnQBLCbjGZWGs1qqH+vxbJba5o9qGl9xNdyszJDWxTF0CMIiv6BJQZEVCffJby40V5EnU4VkF5fEII21JhLzxV0g1c0+9n1fwnR7jAw009ixRS3O5R3SZ+YS9F0aWBvmEber6yWBWud6boPD0LfRAlvaYNfZyiy+J6XxcGKY/G+heAKMEVwWsb7BE4pGgwtq8zjaGxXOogUJUwOj4B/Lqs5fYdOcsjLv9nMEG6T9I/n6T8icSSKaiRFVcL17z57zcmUIkeDNh0yxa/yyZp81L9fXZSUQoDv8dqouZ6J01ZyKpATeMbfO4+M0eS7YV0wvu5Qus/u9FkqIZXzYun4MbdsfewQiVYTk+xydyR3+q72GEIDPiSqw6xFxyA+Q4qN0v5pyY9LxPB6HNmuexI4Ufxk77abU/AdtP3kEOFgz4OX1yriGxKQXgth1vVZX67MPDrdZlK9lEBW+E7qW5MK4Vx+/bZfKApHrJO+J8fhU9qMlYesX2bAnUv/oHEHGgi3prahkQYsZQu56OblJTKs0lXV63wYd658C4c/u9QSxMTSOpVM6T6dOtYvFz7fNg96rHjUaSl/0pJKfoXOjggbSGs7LYGDzPWNskJ7+7mMbIAZSlssmgMOiqxn4H/SvmCnOmQd+7X8pFC7N4DzhPBsun2iGGI4Gm59MphxxWRyLtHMbU/Ydr32bNuTDOh8cAQWnN9RzogvLjQtToSGk0OWg17mCZQBOONjB3Y0G30c+BjieUmfN2OOw9CRldpYR2CUbGEPsvO46BJTo7LZ3DVjIk/0Y4YSB0aCBjUj3+kksm07ByJtzol7FRnuxPvCCqcUBZSrTN73MOX4vZ7rm4UcEOlUSdLzk7sLAW/
 AO/yB3fa
 I2eX4dDjD0gjAojBYiNdlWhLjwuhoAsQ/H8Zt7n5UqBpRy6dehHSCY5DjLAGdgWJje9X3pFc97KcZST7w3L+cLtv7WuwYmPiS/hF2wB/Nlx+b8v7j/9xMq4Vdws6BeTPVWIBxiR6ri3D1EdnuMU0FG2TvaZeZkfLnIjQ/A70/K2/ZhmvHqg4pvlGHrD44RoQLRoO9pPq2tugmrtqNZfkQU52pZnflxyyOp5VpI1NodQLSSX5Dr1gFE6bPogoGCfxmJOSgfNwtcpL9g6gfFJBS9WunFDbm7k/vCjwrYXbvzGo3xo2tXGYYi5FpFAH98FHwwBjy5rnW/EWDpmHyTFMtVdTAz+vBLV1lr6hncxebWKsdfe5wrUWTxAx8NlbwmJD1eflaDQedPh7oFyARE4p05BTpH8IvFOFo9FxDcgJbmHJwyHBBnE4aI5w0IWNd9QdWRvnjtR7A0Q5UmOCLFaaW1GnXk80fiVDAKkr2hJvTNGd4z3OlTcts1xm3Nbcq05oRe8ga/VcvbPPi/oOTGkmn361zMm2GhEyJDEj8t/ScX9q+hbH43WFTPVnyAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Feb 2026 15:36:56 -0800 Kalesh Singh <kaleshsingh@google.com> wrote:

> The rss_stat trace event allows userspace tools, like Perfetto [1],
> to inspect per-process RSS metric changes over time.
> 
> The curr field was introduced to rss_stat in commit e4dcad204d3a
> ("rss_stat: add support to detect RSS updates of external mm").
> It's intent is to  indicate whether the RSS update is for the
> mm_struct of the current execution context; and is set to false
> when operating on a remote mm_struct (e.g., via kswapd or a
> direct reclaimer).
> 
> However, an issue arises when a kernel thread temporarily adopts
> a user process's mm_struct. Kernel threads do not have their own
> mm_struct and normally have current->mm set to NULL. To operate
> on user memory, they can "borrow" a memory context using
> kthread_use_mm(), which sets current->mm to the user process's mm.
> 
> This can be observed, for example, in the USB Function Filesystem
> (FFS) driver. The ffs_user_copy_worker() handles AIO completions
> and uses kthread_use_mm() to copy data to a user-space buffer.
> If a page fault occurs during this copy, the fault handler executes
> in the kthread's context.
> 
> At this point, current is the kthread, but current->mm points to the
> user process's mm. Since the rss_stat event (from the page fault)
> is for that same mm, the condition current->mm == mm becomes true,
> causing curr to be incorrectly set to true when the trace event is
> emitted.
> 
> This is misleading because it suggests the mm belongs to the kthread,
> confusing userspace tools that track per-process RSS changes and
> corrupting their mm_id-to-process association.
> 
> Fix this by ensuring curr is always false when the trace event is
> emitted from a kthread context by checking for the PF_KTHREAD flag.
> 
> [1] https://perfetto.dev/
> 
> Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")

Sounds like the issue is not that critical, but user-visible?  Would it be
better to Cc stable@ ?

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "David Hildenbrand (Arm)" <david@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

