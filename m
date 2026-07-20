Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5200C4452D
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1696B00B3; Mon, 20 Jul 2026 10:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B88FE6B00B5; Mon, 20 Jul 2026 10:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F846B00B6; Mon, 20 Jul 2026 10:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 873596B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:24:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3131FA01D1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:24:54 +0000 (UTC)
X-FDA: 85009376508.07.60FC84D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FEA340002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:24:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsSNjfz8;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lLIgvF7isoDrIHYELuREN+HQBBazSvKwi4llieRlTQ=;
	b=W8u32+4ppfrThGWzUpfY0zJqMZAi6JQE8ZKIdGkW6cNmzC4gyx0P6X2oh/0PAoF1J62CfK
	u3X1BBBcn4j1sajQvOCrLOmmLdPH5wtdcTaSUfpz/KvEbpzZYoHr101hlkfOlNMQuYlTt3
	tg3aoWqwNifQP/VXPgN0iyWfXzOdH5c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MsSNjfz8;
	spf=pass (imf01.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557492;
	b=7foQgHr4oi1i8sNiKi7M6ZfVE1pyYA4cFH7fJyDS0aWVjsI/IzerzDgGLU7VqgCXfoBHJc
	1eRMbOxuu00h0Wh5dvA0+6tIz1Mq4Kk65mxmzjqgVruv1STu5DBwRTbezf5Dp5jKpHB4rY
	+6qCQQRxV91R+W0tsOLcgpjcPw/pmwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7EB743BE8;
	Mon, 20 Jul 2026 14:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E511F000E9;
	Mon, 20 Jul 2026 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557491;
	bh=+lLIgvF7isoDrIHYELuREN+HQBBazSvKwi4llieRlTQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MsSNjfz8CPauPsBrPPnzqyS1VH+0A9UWJqD7L1iF6tyvhzIb/jz0baKBESIVJBGAD
	 yptYErPNFkTEiv0NdMvO6OcIg7IJ8kzHiPKuGQMRkehMENptSLMNpYMTmpBCkRuAXZ
	 9ASr0FigbTdA1CfMWNObYA/kf94fLgIzufv+lYB0EoAGQKwtXGbEXBCn0ugYp2Nt7G
	 kukqroRNQPge15mi5ncw1pgZeRWzNZ04jQrEQlAVNxKM5niBfG/6oLIFIJXZSEoSyI
	 KlNCqryhTp0XO/qH+/ZRt50xw0Lo9EBzpFREwzl+X+lRolgr8XacgXrs+csUvxZvUh
	 pwiNxH60a3Q8w==
Date: Mon, 20 Jul 2026 23:24:42 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Jinchao Wang <wangjinchao600@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Jinchao Wang
 <wangjinchao600@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox
 <willy@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Randy Dunlap
 <rdunlap@infradead.org>, Alexander Potapenko <glider@google.com>, Marco
 Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints
 for hunting memory corruption
Message-Id: <20260720232442.3e6b0e70c6939541b8362e05@kernel.org>
In-Reply-To: <20260717181004.GBalpv_MOaAflgFxgh@fat_crate.local>
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
	<91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
	<20260717181004.GBalpv_MOaAflgFxgh@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FEA340002
X-Stat-Signature: s77ww9xtwmegdn1e9sn7phh1ei7xyogg
X-HE-Tag: 1784557492-401327
X-HE-Meta: U2FsdGVkX19+wyvvZidtRgfYHXiMvyHrTiaFU8TAY41aEW3CEfiO5HQpZXfdk0PtbViekw5SDlGy354BASixexrXD+RphxsyILo6gG1K0wVFqAHCW/jNg5q5ZyiFo9mPUOE6ZUEJXu426xcKCX1SC2kXCutVo6CC1mGEptmnuzARxFgSgU5ESFaohN5KWqbPLn2nspVEXcoXNu89Gxgw9YHBLXurgz7DdlyjV8nm0UZN3VXsYol5zj52+MjftqWSnHPNodHPBZj80uslu/cD/QF1L2ByuIYj5B26opfDoAy0dKsgVQOuZ+b6qhyGnltpSvBHwNoPlQbiC7darYF5Vk9oC/QSFu6xWiGl7HtwQ9aXAKfgrhM35szLPe1Ym5bYR1Sn2MB3xVPRTLUPXJrncwYoBnu5ktmmA/8FotP+wIkQvJZHlNlUp7pgebP5XVklzTf8bRb57hOvbJWhDy33gN+VQq0rvjDYq7aJgFv8kkwLUXbNuN2lkkiG9k8f2nOcgHLQ3t2o9B6r3DtdLT3xHjKPnU40RRKyNKYdlYGWxzuQ/2HVVrVOpAGRDwl7W7GA7D9pgO09gcHSGq2sB3IDHwbZgb1UshRgoCtDGvgc+L2ehy2ISKpQE+3oB+6kQ2Vsi4xQ7nlgFArYGMSlep7bS0sKurBDQf+pnNVpYSbe4/LYrxfwfmloXXzhMdTGwCcK3M2mO38ncYidkfIuEysAlZJr7DKJ5gw+5r9rDF+EeQRFSdki7jg6iiKt5cfrHcaWdc42idsH6YhmvFdlhrGBn5m6cAujC2QJVlYw+u2whiDu5q9Lo10ivk1+enUk3atZYxmIT8pW0q9gngocAHgp8bstTcCL88CuGNZAKhB3DWVfzLyYfz75kDhtm5UfYMfY01mUJ1zQLA7S376X8lTLYv95ANEfanY4+JIyjg6nPPENWalxSvAyIN0n9pSvVpiq6NyFXVSSwFD8ENsPZ3u
 tTR1hgNM
 ReH0M8wkF4SE/sgci5qLMtfe0ko378/mlzpFt5h0X5CQbWkJQvPLo4W8K63SPAJYR+bwB7f6poJzadaEHILG/cKod4Fp/Lgv2SXtnE0yIl4wM2zjZPyJjqPTRkhvT6EO1SHmA/sIZhrIq7eDjW7+BAcWspWQoJSav1C+BPAH042ozRp1yG60TQCciLw/NwxuruEMN1MnJXh8iYpQ2DlU9vrEInRwfxnq8BYGj2pIvM+33Q5ju83aw+3vuysw5/2QkW9+PSpbHBUIwnlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 11:10:04 -0700
Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Jul 17, 2026 at 06:41:49AM -0700, Dave Hansen wrote:
> > On 7/17/26 05:50, Jinchao Wang wrote:
> > >  24 files changed, 2115 insertions(+), 63 deletions(-)
> > Reading this, I wonder how many kernel debugging features we need. I
> > don't even think we have a centralized list of them. They all just live
> > in their own silos.
> > 
> > This one really seems like a super specialized tool. It has to be
> > enabled at compile time and specifically aimed at a specific function.
> > 
> > Maybe this should live off on the side for a while. If folks end up
> > actually needing it, they can point their friendly LLM over to its tree.
> 
> Right, and in my mbox right under this mail thread there's a
> 
> https://lore.kernel.org/all/178429796992.157981.3393977217853767915.stgit@devnote2/
> 
> which Masami has been blasting almost every day this week which contains two
> of the patches from this set here...

Sorry about that. I tried to fix the reviewed comment from Sashiko,
but I should wait for someone's comment.

> 
> Looks to me like folks need to sit down and agree on strategy first.

Yeah, I need to talk with Jinchao.

Like kprobe, wprobe itself integrates watchpoint functionality into
the tracing subsystem. Jinchao, I would like to ask you to redesign
the kwatch tool based on fprobe and wprobe events in user space?
I think that could reduce redundant efforts on the similar feature.

Using fprobe entry and exit event trigger, we can make a Function-
scoped watch window. Also, since fprobe and wprobe are having BTF
typecast support, you can access to the members of data structures
more naturally.

If you are interested, I would be open to having you handle the
development of the necessary features for wprobe.

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

