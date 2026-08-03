Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7DEBC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9776B008A; Mon,  3 Aug 2026 08:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD06E6B0092; Mon,  3 Aug 2026 08:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6166B0093; Mon,  3 Aug 2026 08:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99CE86B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:47:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B8D91A066D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:40:15 +0000 (UTC)
X-FDA: 85059915990.26.FBB5E06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4C0124000A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:40:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnXi1r5v;
	spf=pass (imf11.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785760813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w08UCbkWtU9TfXhclWa+F/QyElpPyUvaHz012wzyT/A=;
	b=ZWY9vi/zrVEPad9nNFG1PWXKBFAbDyaMOFCWlQ9BqSSD2Typk/RfGsiMiWC3mSTN9fPjby
	eQzbPaT6GGzMo+2/ab2hVuQGO3+RGlTYxxHNdp/VcBA6J8hvD+fV3+Ha0py3dwrkBXVSZ0
	Ce1jqxEYRn6mBVofNB9l5SgYmXO4KxY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnXi1r5v;
	spf=pass (imf11.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785760813;
	b=MLa5yXU09TNUfcPSj3ZnlkFaINklCUK9tK77r/+H02PGnMaD392sC1ll4CMLBaNOU003fQ
	fbp3w376VLU93XEggf9AdZbGKkrE6lztIKluOjZyt6UIHT4aZIBfHhgGA7ycDZ4Hxzf8DH
	wm43yXfCz1kOxTEH2ls5+nLvDUsToKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E57E40885;
	Mon,  3 Aug 2026 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B80F1F000E9;
	Mon,  3 Aug 2026 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785760812;
	bh=w08UCbkWtU9TfXhclWa+F/QyElpPyUvaHz012wzyT/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dnXi1r5vWkuDOhzSCp2b+ev8osnacMTCyVJ53uwAR3oByxd4tQuEamsTfPnCa/Jzu
	 3Zl+cnX3oHU38DlcVRO/kSegMX6N7B+FyDRtso/shPwmatZKvrdAJTT8W4VVse5JQW
	 syrs+SlD7qd6aBPwH43bQ6NdQpXTsvctVJWsCec3R7xr7IZ+iBgPvWdG6RikGS7BUX
	 7ibz+YYIspHC/xYRSJ/eUijkuGsMEuUlmhguAAIxHVmD/b7x1IG30VXQmF2t1sUKw1
	 6l/dmsBjtEpDLUIUML1Ra2jW6JOkQl5Oo91npLaptq4YBr5UGiuVhnLPfUYGyt2GCK
	 mau8bCf4NUDew==
Date: Mon, 3 Aug 2026 21:40:06 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Eugene Mavick <m@mavick.dev>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Gary
 Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] tracing: add ref_trace_final_put tracing
Message-Id: <20260803214006.d6e03e8fe220694709125157@kernel.org>
In-Reply-To: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C0124000A
X-Rspamd-Server: rspam01
X-Stat-Signature: e9f816h9wj95hkdz9gsqzi3unjorh7i7
X-HE-Tag: 1785760813-826165
X-HE-Meta: U2FsdGVkX1/IDghsvUhagC+Pe77J0z67dlu4gqm+VWWLOb51qZhPY2JELEzCXggI95wBXDLvnXyWpNfEM1OgIMDt/Vf4VRV1ufF+m90ATt3goHCBSdtZXdSKAuT9ZjGUw3Lnky/ERVaTx08zMJXO/NVFBb4lE86KZQ5LbpvZa+zG+NLZsftgg5m4AhPY3FbYB2rTvBu+8VIgBBVtwHYplj236hn4QYkVFIjJo1IkGPOPhO3M1wrLzo7ljP3BH1OliKyaFFRA7DjRLcvzusJP/6pX5BWIHhz6cPhGb9msqlR1zDC1MS+qBNZAM4Vor+HvCZizP97j80l1YgRZXqz3mrhxuozGbPFel+NPwwJGQ8/LU7FyxIeRTAXHOQ3v8Ft9DxUkx1PYDOKtXai7cjuW0S+U6iuo8FkbHiw2cxHpConX+IYgBatwjPVSjhbJ+Z1IYOFq6/JYbUPUhZE/idMR6kdDar8KlmiEh0DxJF145MbJNhh5vDOOaVpSbOseQlwnUz7A+M8GOfiprskJGVI4jdSU5u7o1JOO3Xmdsqr8b0FlW9kYcZLAOwyW1sCzUbBVkSWOGXfJ7ObyGn88dCDdGa0cJLybtRsKrGo7h3+fcEaJWOB5IMNNSM0lPn8bzt/zIXIu6uVVufNdknVe0iAoMWGnLwxI656rNJe/o71SGRx8GzhHGm2vjNyjn7IYqzuT+LCYL2moneiZ5iyg6xLDo/MdTjHBAMtjDCU8UcOlck0bj7DNJ0AxYuEh+6k0VebHKnl3LLLu8LaHnmUmw132WNmMj2uQU8RuRmjxvsNQQmVOXrTp5NH/SIPkOAHV6au9NgqI1wKYCrqA794wnpNnmD0dzdhSMq7JnlcMISRK+VHPfwQFJ3iJhKYn/Hs2GLBI0HrwDM+t2QJriCBppoCfQEGcC4v/phO5DqkH6v5MTtT4kFEIkexwR4W9XUPW8619u6/aRq5NykCR41ddH00
 t3m55Ffp
 mvPYV4bQpP26ZW28MKyWsBrkjg2N6hPO5NsCbtifRJqmgFF7m7vybwBEvu0Du0QDpatfcNCvgAbbuUTkmPFenPP7XYnDLIxCjjvIYstsSfTJpbJN6tRgU2OGbjxEOVdt90eYUIkr5NQOa7zIv05KNwVy7xdacD7rAX7ycBhpXtOyGxLWdZOIZFQojbpZtY1ONh/A+b4W4VyrPq6cIYolXBhpYPMDDt+pn2c+InrNUqqvAs3fr5oest+VHC7uoBqT0RmqMsGyV3mfw8yC2Rt/dbl8r1AGN6JIojjWPhLCN2DNn/XT18ogjTohTM2eXwFsT2vnExLxOFCIbn+TxeBLoRH1gHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 01 Aug 2026 18:59:40 +0800
Eugene Mavick <m@mavick.dev> wrote:

> When debugging use-after-free(UAF) bugs, knowing when the object reaches
> 0 references and enters final release can significantly aid the
> debugging process.
> 
> There is currently no universal way to trace this information.
> 
> This patch series implements tracing of the final puts in the
> most widely used refcounting implementations,
> refcount_t(and thus kref which uses it), and percpu-ref.
> 

I have a question regarding the event group name. If this is related to
refcount, wouldn't it be more appropriate to call it `refcount_final_put`?
Even if it is currently used by `ref_trace`, it is fundamentally an event
belonging to the refcount subsystem.
I believe event names should be based on where the event occurs and what
actually happens, rather than on who is using it.

Thank you,

> The tracepoint records three fields:
> - caller: function that called the refcounting
>   function(refcount_sub_and_test, percpu_ref_put_many)
> - ip: return address of the trace wrapper macro call
> - obj: refcount object(struct percpu_ref, refcount_t)
> 
> Signed-off-by: Eugene Mavick <m@mavick.dev>
> ---
> Changes in v4:
> ref-trace:
> -remove fn
> -add ip variable
> -change trace wrapper macro respectively, _THIS_IP_ is used for ip variable
> -change relevant code respect to fn removal and ip addition
> -fix style issues in include/linux/ref_trace.h
> -add new macro do_trace_ref_final_put_cond that only calls tracepoint if cond is
>  true
> lib/refcount.c:
> -change from do_trace_ref_final_put to *_cond
> -remove if statement above since _cond already performs the check
> KUnit:
> -change relevant code respect to fn removal and ip addition
> -check if caller and ip are valid addresses
> -change timeout from 10 jiffies to 10 seconds
> -move didn't timeout assertion from before to after probe
>  unregistration, to prevent it from impacting next test
> 
> Changes in v3:
> include/trace/events/ref_trace.h kernel doc comments:
> -caller of refcount function -> return address of refcount function
> -ref_trace_final_put->do_ref_trace_final_put
> lib/ref_trace.c: add include trace/events/ref_trace.h
> kunit:
> -change Kconfig depends from FTRACE->TRACEPOINTS
> -EXPECT_FALSE->ASSERT_FALSE for calling percpu_ref_init
> -add tracepoint_synchronise_unregister to test_exit macro
> -added timeout to capture.count waiting
> -remove noinline and __always_inline from function attributes
>  (added for testing, but accidentally submitted)
> -add period to the end of Kconfig help text
> v2 link:
> https://lore.kernel.org/all/20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev/
> 
> Changes in v2:
> -include/linux/ref_trace.h: change macro name, use direct tracepoint
>  call in macro to avoid double check
> -add tracepoint to refcount_dec_if_one
> -kunit: make significant improvements to design, fix critical bug, add test case for
>  refcount_dec_if_one()
> -Link to v1: https://lore.kernel.org/r/20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev
> 
> ---
> Eugene Mavick (5):
>       tracing: add ref_trace_final_put tracepoint
>       refcount: add ref_trace_final_put tracepoint
>       percpu-refcount: add ref_trace_final_put trace
>       kunit: add test for ref_trace_final_put
>       MAINTAINERS: add entries for ref_trace_final_put
> 
>  MAINTAINERS                      |   3 +
>  include/linux/percpu-refcount.h  |   5 +-
>  include/linux/ref_trace.h        |  40 +++++++++++
>  include/linux/refcount.h         |   2 +
>  include/trace/events/ref_trace.h |  51 ++++++++++++++
>  lib/Kconfig                      |  10 +++
>  lib/Makefile                     |   2 +
>  lib/ref_trace.c                  |  13 ++++
>  lib/refcount.c                   |   6 +-
>  lib/tests/Makefile               |   1 +
>  lib/tests/ref_trace_kunit.c      | 141 +++++++++++++++++++++++++++++++++++++++
>  11 files changed, 272 insertions(+), 2 deletions(-)
> ---
> base-commit: df685633c3dbc67441cc86f1c3fee58de4652ba2
> change-id: 20260624-refcount-final-put-trace-49bd7c39bd5a
> 
> Best regards,
> -- 
> Eugene Mavick <m@mavick.dev>
> 
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

