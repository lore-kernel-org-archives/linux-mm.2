Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCDBCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB976B00D9; Wed, 13 May 2026 11:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C29B6B00DB; Wed, 13 May 2026 11:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700EC6B00DC; Wed, 13 May 2026 11:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFF06B00D9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:41:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2828EC04E6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:41:46 +0000 (UTC)
X-FDA: 84762811812.29.8F372FD
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id 52B251C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:41:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gMLl68zSqbv4H/nZHomhhCZieKUsP39xJM4ABQ5wWA=;
	b=DQC+QE9BKi/LuXmdRkeL6l4g9Cb0jiQ73CbKrB9FRND9H1jT6CJAMCzBJnrYPD1UXjLcAq
	gQcRjaae0z8q3xKjn2V6rfDnxLkIjOLug9NoYehcfRFIcfI9VxLlA1Qk1HPX+D+JVo26Si
	DF1JteYck/vf0vkVzSlRl/gfNEREwbc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686904; a=rsa-sha256;
	cv=none;
	b=SDE9sVfVCPkDYOaVh0l/P8PCclPW/Qef7aOqIi8nYyrd1H4nrsd3uswLUk4ZlSsc22HNA2
	/Q/Yw+JMuVj0QB90Ffvwc1mAXxOhhdnuxMDIwZ6Dsr3QpvJI1nhHSiNHAGCCq0z3sPAZP/
	CdGFV/AVwifpLCCeuTLkWrPoSxQXVho=
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE937A0183;
	Wed, 13 May 2026 15:41:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 0FA8833;
	Wed, 13 May 2026 15:41:33 +0000 (UTC)
Date: Wed, 13 May 2026 11:41:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>, Broadcom internal kernel
 review list <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner
 <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, virtualization@lists.linux.dev,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, "Paul E.
 McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v6 6/7] locking: Factor out
 __queued_read_unlock()/__queued_write_unlock()
Message-ID: <20260513114137.0a569a47@gandalf.local.home>
In-Reply-To: <8e88613c73f0603c4440ba3a62eb604a5dddc57b.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
	<8e88613c73f0603c4440ba3a62eb604a5dddc57b.1777999826.git.d@ilvokhin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX194La6sVd8fLI5Dtndp8CiCROEVNoIrQNg=
X-HE-Meta: U2FsdGVkX19n47HJ3PRsL6Y1RvJxJXJLdtucZN5M7VjX/LIIs6A/59gCiliFB9zKBz9Ep6v66pHEUltY8UmeMOUl5LL++AIx0j9uhDBUPpAXSFMX7mK45AC7G4GiEJkqoGxYiMzfhIHlwxnmdlZUHWgLwcrWH9EwfXbx7/0TorRGtWFLrX4Quk3cbFnjhOO10cwuECQLqsaSIBJsPbaCYRSZuPHX+KlDfDXjlcVK2sBfP+7G55KdHtbdpABHw56YHDSJyQ1ObeE1yvbzMkJsT8TJlFdEm9IHGx0z20CELoNZwBTlDMB6AH87nswXkizkxx3mfdt+Azjt7huoKRykluWHevIQ+4LrAE6jZh5irGo6F+vGEm5llaCbJ5wnjrqEqdiIXyB1NdQ/TTvk/MOgsA==
X-Rspam-User: 
X-Stat-Signature: pfjkmt17ybgjohzb1pz9u5mnqn35j1hh
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52B251C0005
X-HE-Tag-Orig: 1778686893-373441
X-HE-Tag: 1778686904-905200
X-HE-Meta: U2FsdGVkX19JtO4EsJv2ikydIWVcUWrop0WG7KkWLEDFaVQPp3heuPsz9kDw9DzZnTyMFI0pY9DGbkN/IGFOy46doxphL+Ppk4quT+GMs0USFCu00VSf2A7q/WN0/hU44oOOScw7K6vJyixIUxLPE0f3+ln4ykcr4vSYRE92x5E5rLT1ocHycrfNCqJ8UKAbfPe4oi+Qze+fUHQBiuRb3H5HFsSBITxRY4y0vvFp5Z1Y742u1QtVLRe1kjnCgvqsgVCCcJtnpdczRR/tnqNHqwKvu2NME9IegCj4fm4y+qXd4VE7cW37v09l6I4xWppN24DW6RilQ1N04BZDDjU3AoKQBB+5G+x+9ftLVl2PNKpccU0KWpwD4YNWb+TAbA5EOyhDe+l0q8WakVkNR3451oQX169w/bTXeH0w2Ls1hFQAgTLWf+EyuzBYBAe7ZYeaYR7/kq7pRj5N+Mrx2JGM8knE9/Gn0xSaoWUcusABzG5TrhCQzG8JzlVVnYgaJRNYqWcgujdX+zvgZFIdCfXSBOacBmPT4uubLkvNipd1R7ocb3uZZ4/hNxMhXUy4+jztyenlQ+U994CWu71jelSuY6Rk3Pz3gLHSnMbmPrXXXiCcp3qwchOHwGyi5oicuBrrFrO64ns0Drv83PAST4K5UJR5E+1IP6sVLBWjz185gndtlp6UFYgHZQpPt6XU/RogG40D+l5ou3+kZQIqXt9HqvofmbpERsar8/Nsik7HDeB2T7b43yN/UTwc9WULpmXo2/zbslqeRTp0kFbFSt/mzopbTUxvpZ7SIjI0A2pkxzTnP+dLwbaA6CGZK80krGZZZVKhCSg+vM9aa/GIqdpvjrgUacPipBpR+In875MFCjgyCMmE+Tas7MRdYnVwENMs2j5q5tyDEBC8Jqy7AuP9sCSGapoQ6f+6JsRrwIncqsTaTzX+bgOtcW3rKNPK3qlT2Ra6xq2HExkkE18QXCN
 cYOa8D7h
 THBZRRqKeMytRiAT+qSWgoRaL0VczbFqnGNasa451f0khn0g4WIjVhdWpEEdTHsbuQfNx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  5 May 2026 17:09:35 +0000
Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> This is a preparatory refactoring for the next commit, which adds

Same thing about using "next commit" in change logs.

-- Steve

> contended_release tracepoint instrumentation and needs to call the
> unlock from both traced and non-traced paths.
> 
> No functional change.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> ---
>  include/asm-generic/qrwlock.h | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

