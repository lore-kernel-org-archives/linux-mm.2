Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35E4F53D7E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D71F6B02F0; Mon, 16 Mar 2026 13:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5336B02F1; Mon, 16 Mar 2026 13:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27D26B02F7; Mon, 16 Mar 2026 13:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1E916B02F0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:40:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D46A14032D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:40:53 +0000 (UTC)
X-FDA: 84552641586.30.8F0880B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6F62100005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:40:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dTS6csCv;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773682851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYKf7aY84Fm2Usf9vwKrE8cpw7bghTbRx6rsJcLbz+c=;
	b=yzAkunPuBry08stzWxqX3cAXHNCshGrnqXhgktHTtM1obl9L6ftdUSu9Z/eL+8Ugxvk90s
	DVE4aB20P/NYDuUleOBCURvbze02jFRujF8jiFX2rggCUN27I7NTuVUnUVejapfQkxukMZ
	Db+ZDgAXmw/QzpzFhnZ4vBlite0EG7Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=dTS6csCv;
	spf=pass (imf14.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773682851; a=rsa-sha256;
	cv=none;
	b=gtsJLYQGiWYtmQ8YBYgmb+r6pw0cv4oSQPi35TgjDTB6Q0Y9wP95wfU1aMw9qZ0si/MqA8
	tqAaFRNM7OX8IMZprP0iwUig8qb9FBFiSOwGkF+Yc2E9rufkVzm2ylrGUV3Qrx/S8Qd7Ue
	o4BvlZJAerhiFYQ92HuFgFzDXgn7HpA=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id CE69CB3C52;
	Mon, 16 Mar 2026 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773682850;
	bh=PYKf7aY84Fm2Usf9vwKrE8cpw7bghTbRx6rsJcLbz+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dTS6csCvLTM1SQTIz3SKBrpcK4/YVI8zJ4qyJCVZoEHV1Vxlqnqgvu9skkc2esslD
	 kPcBYa04hvvJJkdQNZF8Ul3irDYeARFq9+DGb6fdeupxhpdV46YjtsdJjsbnUv6nf2
	 VFicRtsQGemIELk2SvKmdV2I0TqcYlkkroeR9yuQ=
Date: Mon, 16 Mar 2026 17:40:48 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <abhAoF5EpiPigsx7@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
 <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
 <aa7dgQDMEz34eadj@casper.infradead.org>
 <20260309151317.7bba06dd@gandalf.local.home>
 <aa8xawMxLeUjkyHx@casper.infradead.org>
 <20260309171700.063318b5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309171700.063318b5@gandalf.local.home>
X-Rspam-User: 
X-Rspamd-Queue-Id: A6F62100005
X-Rspamd-Server: rspam08
X-Stat-Signature: ipu8dyug7ffh88dzcbuhk4wh6grg4yz8
X-HE-Tag: 1773682851-375608
X-HE-Meta: U2FsdGVkX1+84762bIRc3u3XEZJcMf40cgxAbOHmRWf1eAX7c1B1Rz2x7196L4L1IS8gCtHVt2lNHiIAQOmzp/OBas4AU7kmuv9arwc5d2z1wjkOMufUm3X1E101GLQRzIJj6o8l+KUUBY7YQ3Pzf6HOBI1tcRCEEopeK5PX2zYZ0842L8JA3iL4o6l76NHNlbcY0CfgwenHTz/pPUSlYhS9JEcRBnP3E5DWANP1iYxlc9awNWhTuidDLuMzclNZhyGwZ7GO4+rnWCc2CMbbtBcZAj9nMz1I7hGZNx2dRd7t0069Vl0kv5Ts967mcDLskH2oKkus3RtECaxumGl59bo4+gS9LlNo07TKFj3sUg7lPJlRTdKVV+dGzXmLmcRQYAq3P6ieYhyRG2pflyNPqszTroPf+tX5EDDQlTTQPOWnFSOB6pD2vWsPj6uJSyGY8Q+2rE+MPUmfyd9+BFiDr7Y6yRexXlBUmwITu22lIY7uq0QvyzKv0sVCeQmKExcKG8IAY+RKaY/u/9DP4amAGOtgclWZ9LGbAzdSOm84pjo4+UT3MGMX0IOFuLWw4G50JMsdxzYxOqj7KeeNKPlP2GI4yH8C7737hACPSMQeTP+PHFi5DlaAyuWO4VT0Nuo+qtC4hU/uAUFZMhIm920xwoVPVkSmUCg+/9kpcDxDvmsrzfqRqppPPJaMcquDHy8UNtJiCUnNY4/fbrHvyRs2Fz9pdRbHcOkQcGlxvnRx9cEPTta3J1w7KcdxbM7X8jxgf0pK7gxmMY8wCWOXBuOxYLEJ7ILCf1SxTFEiytxlXi0vyIO+lM3omxpbHKAtuYgCgH5tVIL+PIW3mLL5VBI/TtjAcFywIoEFFsITugUFcV09IPuMFp6gvFsKbd+m3ADtsXCk0Ypty47mYbYW1CTA+1stHugjh6wuOUlT4Aq3OrqcvcnPMPXrkjeXxaRfjKUNelGk5OW831uvVbbabgK
 ncVX4UQS
 TOzwuodvZu3WWLk9bRJ681fFwbQ9t/G8te/TGnnBOg/tOWVEWNLaagoP07Uf5fDZuj0+UNi+2XlSCd7faYjYKBd6sgBkUTGGGydQTQceNhxiPjhcRsfCmdpcCLd6pPh0mnnWnMkAJ6xdsO7s8gP3XBncostNS9S9ioAM7q09RhVXATLwgiEY41QT1WdcBL7YZpLE2dY8STb6u54oLwcVIuYjkZoeHpIIsJItWYKk7T7Ta+20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the discussion and for the feedback on generic lock
instrumentation.

Following up on the earlier points about lightweight LOCK_STAT and
tracepoints.

While the thread has focused on spin_lock() calls, the real gap is on
the unlock path: there is currently no release-side tracepoint to
correlate holders and waiters or measure contended hold times.

A possible generic solution is a trace_contended_release() for spin
locks, for example:

    if (trace_contended_release_enabled() &&
        atomic_read(&lock->val) & ~_Q_LOCKED_MASK)
        trace_contended_release(lock);

This might work on x86, but could increase code size and regress
performance on arches where spin_unlock() is inlined, such as arm64
under !PREEMPTION.

So even a generic release-side tracepoint has nontrivial downsides (not
to mention lightweight LOCK_STAT, since a disabled tracepoint is about
as lightweight as it gets, the more stats we add, the less lightweight
the mechanism becomes).

The zone lock wrappers provide a practical, production-safe solution to
observe this specific high-contention lock, if the generic approach
proves impractical.

