Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269A6CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 19:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BD76B00AA; Wed,  3 Jun 2026 15:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723B66B00AF; Wed,  3 Jun 2026 15:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639AC6B00B5; Wed,  3 Jun 2026 15:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 515E06B00AA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:54:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18EBB4045F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:54:40 +0000 (UTC)
X-FDA: 84839653920.24.672CA49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36B50180005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:54:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fuVKQNQQ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780516478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6J5DA436y/HhFA9gpiCgTUa/dySnD1o7NofgEPrjxg=;
	b=r2wytqIhFBuW3ru234AJUbldGGSaiZtwr7v98QhNQ/2i1VPsfRh4hplWfjbmKdaXhvxXWL
	kB0kWHjhLzkn+RlXr96NTdeBrIFiSs5ayu59BaVxA3TFBAXOonW3BgW5jzjhtQlBYX+B/g
	Y3/WVj1B4sPY6GrY+DxFIbDcF3f5paI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780516478;
	b=1q5tcDOrl7o9zEVJS9moJnYglJ8YoTMQvDOsW5TpYaCWBr443atnjgrwutEaG8+Naro8yz
	HmLy0ZHcOTr1S+BJczYstbuZKt2vc8Jgl/G+SRIUHUdm31qZFvjV4ZefLNBuDbaxBanL5z
	MW5FDRdyoHgD6pQ3OVbtrgWAKgEcUqU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fuVKQNQQ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4620A4372A;
	Wed,  3 Jun 2026 19:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F3A1F00893;
	Wed,  3 Jun 2026 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780516477;
	bh=W6J5DA436y/HhFA9gpiCgTUa/dySnD1o7NofgEPrjxg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fuVKQNQQ2buo8lmNRBk5nzewJOYysiTyksg5ZBUVfTAgHamPi5USG6d47Z7pXZxzN
	 6D3i9HYbOLXd4BeLLbYP9P99vkCtRm5Q/I8PohStr0whqg0qhOXKlG58oUjP0JQBTQ
	 2os4/2qrHYnucfdLr1VFs+g5j7MNVdjQxt9/MJFY=
Date: Wed, 3 Jun 2026 12:54:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Borislav Petkov
 <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>, "Luck, Tony"
 <tony.luck@intel.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>, "Lai, Yi1"
 <yi1.lai@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
 <linux-edac@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-Id: <20260603125436.22a4d5763052f8f4933be91b@linux-foundation.org>
In-Reply-To: <20260603130006.7d2c4a62@gandalf.local.home>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
	<b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
	<20260603121707.7eccb9fb@gandalf.local.home>
	<20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
	<0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
	<20260603130006.7d2c4a62@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36B50180005
X-Stat-Signature: ryo1hyyyjhkz15tsaf69i58d9b6fxm1q
X-HE-Tag: 1780516478-150286
X-HE-Meta: U2FsdGVkX18JUkQfYNAc5metqVA/V/h7RuHCZSkKQavZkkg9enX3PXa5/V59FLJ14QXKSpTAvyQIhmSKRWurSNijgpgQIYnx29194dSjHL5pDTkq2KbCnN0t8a/4m02TbmKXrgnXw/1lTvs4Kv1hx+TWBIfXbbLE40iPfqTMo/ZM9Tkp+GrJdDogaT4SuOS1QYImtBYJZ57yeXoSuDTCuoCqwaTlirzrWbNPKXyOCW8v5A6fJ1t7yTG4MH7aK+jHrkprNRKtycneLese8aRY5pXtfrAhVYw96E9/IaWjwr5xFHzi16zkQsKme1iAM11TUpAM5/rGjJR8iEH9IxlVa6GdryR6VBgtaFLEEFiIvBFZf5dnBiDiYHzSUexF8QtMjoS2Z/HEc4TK+dvgzn1eHj+V1QmnJiQa0Y2/IYspeVKDU2PMlMaeeLBPxBshfUYilQxldNl1Ah6cND1Und/sQ+cmEQqeoe0R8HsHv2jCyOmtoOWykIXx7Ho4BdgRs4nMcSN6LH26oQRYfnED26zVrs81eXJX4wfE+f/O1zHCEl0kaV/QQAn6SXihrf+5fR7hNMpfiLyESqk7wOwVXSPzvfKzxETQUMc+pRgQxmHR3TBpJFNFtJ6WK/0oPThXH3nrxSFzxTP6w95gsSj/ZmXvmHVBhcVTgfudvUTeRfAlSdg9s6WdNbHXGioNrrCkc9PXTkgnaweNrP/jizcZXYdtTP0qCRFvE3xT6u36nKjXlU5/hWgjkghfyxoORoiTB1STPuUMoX4DKgAoEThfMvqAPl8EgxEV1z1B9j0iqHjXgZSGir3U4zZ35PezcG+rd1YwWu+t1N9dWZKLVbwbnSfXCfEb/2VGoJ/1UOCTBiQi3qDmvovzbxMmteHHxRvzEgldzAHXyFrsM7huiwFgt5sfQ5uw267o5NtKGo7VCgTvud66KLQdlHzkjbhMoKiwBS98Wa2EJfJNOw4M2g958ux
 lAWY9lNO
 +xoCSqm6cpenbaZusyyaE5MNjGc5ifd/o8ZMY60768AbiSlrsVGNEPW6X4hMbQj/+lk/MDj0Vm8udAtau4rJC+6UN7dkz+J9TecAfGUGpHCH8f+f/eqM7h5k6Krrl5UwmIaoT/Qab4071xttTEeLZkqq71a0Yz+lMvfONJCJ/wRTxhr6bEOyUCywWqt5C1Rj2Tbj0qBV8Ko9C+9EROkrRkBVfMJ3QskTS7LRMqnz1zGP6OpLMX+cdedRAjlQ0I1/xNUhREKJkzNfV5czCuXkcud8oCl4arHNLCt0lWjnvoN5GrDWylxNJ74ZW6/rdsi1rjGCXExxGfzaDVtcAlVvxhWf7YcFR8HtYig8uZLmGsPfcgeR6dkcuI1OGgPdZsoQMcTFHKZ8oeQdoqePaD9Ip6wSRlYTMJvCieq7D0nJSrpQYfJzGyFkXKNppJNOqaW2KeV1o9elTeOqBMGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 13:00:06 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 3 Jun 2026 18:26:24 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > Yeah, I was fearing that when I read in [2]:
> > 
> > 	"It has become clear in the past that this promise extends to
> > 	 tracepoints, most notably in 2011 when a tracepoint change broke
> > 	 powertop and had to be reverted."
> 
> Technically the issue is with trace events and not tracepoints. The
> difference is that a trace event is created via the TRACE_EVENT() macro
> which defines what is to be collected from the tracepoint and exposes that
> information to tracefs which applications can easily see.
> 
> A tracepoint is simply the hook in the code that you can attach to. Trace
> events create a callback from that hook to extract the data from the
> tracepoint to fill in the fields.

The problem here appears to be that "ras:memory_failure_event" became
"memory_failure:memory_failure_event".

Perhaps we can add infrastructure to permit aliasing "ras" onto
"memory_failure".  So if we make these namespace alterations we can
easily preserve back-compatibility?


