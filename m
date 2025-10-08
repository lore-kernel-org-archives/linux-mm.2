Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B9ACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087008E0019; Wed,  8 Oct 2025 10:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F668E0002; Wed,  8 Oct 2025 10:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05368E0019; Wed,  8 Oct 2025 10:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF5028E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:15:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A33D11A3B2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:15:34 +0000 (UTC)
X-FDA: 83975144988.01.B8A710E
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf19.hostedemail.com (Postfix) with ESMTP id B1D0C1A000B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:15:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759932932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dWsF9AP9XVqM05ZDiK51ynUjOwqQnAXu64VzwNd2ii4=;
	b=p89Nm3gX3GDdiQf9ganqWMUEseWkne8bO5xUJLnf2jt0LJg2Q+mUrwRSfOXUdgosVUC6rZ
	+HFfTGrL/4gA79DPCo5l9yRk7z5U4g3oRajEFvcCEwXjsu6CbbF2mTlJJ+SkR5kubiTH0i
	+LLSxS/uQQaNob8FOKBBUpbO2vLek6c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759932932; a=rsa-sha256;
	cv=none;
	b=KusUnETplnxslyPmmeyDf+WaiHvEBxzI/UgrjrLOKKAPoxP/o1uQSA+KsXfNNNgCowa54U
	wHh7yO2J6IBfXWTqoxIjePvUdemphaigLQYJA9t0i/ctKQgdC/lM8RE2Gp1FoLcFth0bF6
	egQlCOOQMcbpYD/KA11qcWY/60lq+ZQ=
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2D02877B7;
	Wed,  8 Oct 2025 14:15:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 0E50F2002A;
	Wed,  8 Oct 2025 14:15:26 +0000 (UTC)
Date: Wed, 8 Oct 2025 10:17:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jakub Acs <acsjakub@amazon.de>
Cc: <aliceryhl@google.com>, <djwong@kernel.org>, <jhubbard@nvidia.com>,
 <akpm@linux-foundation.org>, <axelrasmussen@google.com>,
 <chengming.zhou@linux.dev>, <david@redhat.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <peterx@redhat.com>,
 <rust-for-linux@vger.kernel.org>, <xu.xin16@zte.com.cn>
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <20251008101720.6c68c5cd@gandalf.local.home>
In-Reply-To: <20251008125427.68735-1-acsjakub@amazon.de>
References: <20251007162136.1885546-1-aliceryhl@google.com>
	<20251008125427.68735-1-acsjakub@amazon.de>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+qoUNA17ejSntFqW0JBkTCQ/TFqzc90T0=
X-HE-Meta: U2FsdGVkX19evAndJnR+3t5nvLm6JeXv1Z2HsiSMqn0YkhTDtMA1K9uPQfa6BcTjTk0CnLStGPAePV4tk0jTIiNS9QOljZYVJ9Jmu6BHDHyrURNB/hln4NJsL4GSPpopfWFOzYIwW0AlGV3Va/xPaWwxT/QgbMyZ76ai/jDHr9+3ldfOqwB1D5S4DDgemztR1x6zgc5xgRTlsjEf+qwC19nTYKbYzzwyOjYr+5ToVsFXoLIHWY90tQwwAkGtv7iTK/vKDVbTJaxI2UYmNWccreqV5UxEY2lAcArMkN4s/PoLF6GLZeqINP1Pdn4Ta1KB
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B1D0C1A000B
X-Stat-Signature: iiethtpdq4tf7sa7nrtdtkbd6kayaaqq
X-HE-Tag-Orig: 1759932926-798415
X-HE-Tag: 1759932932-59431
X-HE-Meta: U2FsdGVkX1/8H6Xx56xdIqhdN8Yynn7l54IZdTjhh3btQ8sshyyole9/TL07HO+yiEdNdj3DK1ol6NYHlNsuI2v5nuP7I1kA7T99z62oodylqCw4JbNeEEKc5p1904IBk4Rvf9KLDJ0nvpy+tD4mX6Kxgf89UyxvZCQV6osEYWxgyunUC+Ow9p5kxgCdDWFNzQ1gjyU/+PnOpsRr0cEIPslymOR5O3522LWUmqpBiozeG5iEetFrAcJQpy06KJIklEb1koq2lg3cg+A6NcmJX/mGSZY7CCzBPht6HMV++T5hLcq7gBImy3pBGsLBkrJecj/Vh+SjchzlA23x0ZG0Ex+I4VFtAmgK6P8w4RAHJfkBVSqsSx572p72FdzA8vDWM58g3FaqQXbyrdcWi0STGd4HP1N1yAeeFVcWA39nonC4m8kVm2r1A6qMW7Db1NuHOTHxdpVhnSd5YRRZdsRn9LY9dmKk5WeFXpAy377VSeauHHakjZCNFgH91WuMowWlMGGlgKJBgF5336qGhDx/xkMt98T9v9dofOkwR1qktG4LsjwicydtO4ZH348tq1jTgrXDGa+P36VPz0o8EqULzDsOZ39lRUh02rv72pBrxvVya2zD1Yp/6j2xHktzrc6WNu/d7CGgG7Di0HgNOQBqEPhvW+ABb+aNzrfXGiIZrX2TK/LhKKywBETxOaD+82+lScm2bj89MmLnPUBGgeuJFm9Jz6wwnGw/1SG/Fj3Tfh1lj3NuIGKGih/kgjW1qCUMdGLymzbuE9iGvq7QTJHy0AA5q+gAC7E4Q+OPwD0ml9o6zEqtUNhT8/bkC+30Hdmmwx1rtMhh72p8ZtwoQEUBM2zKo0HsCAsJ8FsrkwJoqI6LmDW6NKR96CTQycp86U3V+IPvKRSoMeuTiDLn9jjEBvYHpc7kUd/L6SYDxxbCjgWEWJ8mrtDW8hT+xGIGj82IioBSM63Q1pQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Oct 2025 12:54:27 +0000
Jakub Acs <acsjakub@amazon.de> wrote:


> Hi Alice,
> 
> thanks for the patch, I squashed it in (should I add your signed-off-by
> too?) and added the TRACE_DEFINE_ENUM calls pointed out by Derrick.
> 
> I have the following points to still address, though: 
> 
> - can the fact that we're not controlling the type of the values if
>   using enum be a problem? (likely the indirect control we have through
>   the highest value is good enough, but I'm not sure)
> 
> - where do TRACE_DEFINE_ENUM calls belong?

It's probably best to put them in include/trace/events/mmflags.h

>   I see them placed e.g. in include/trace/misc/nfs.h for nfs or
>   arch/x86/kvm/mmu/mmutrace.h, but I don't see a corresponding file for
>   mm.h - does this warrant creating a separate file for these
>   definitions?
> 
> - with the need for TRACE_DEFINE_ENUM calls, do we still deem this
>   to be a good trade-off? - isn't fixing all of these in
>   rust/bindings/bindings_helper.h better?

There's tricks to add a bunch of TRACE_DEFINE_ENUM()s at once. In fact,
look at how the macro TRACE_GFP_FLAGS_GENERAL is used in that mmflags.h
file.

The reason macros work but enums do not is because the pre-processor
converts macros to their original values but not enums. The TRACE_EVENT()
converts the "printf" part into a string. The macros are changes to their
values, but enums do not get changed.

The TRACE_DEFINE_ENUM() macro adds magic to map the name of the enum to its
value, and on boot up, the printf formats have the enums convert to the
values. Note, I'm working on having this performed at build time.

-- Steve

