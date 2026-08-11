Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59240C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 07:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33FCC6B0093; Tue, 11 Aug 2026 03:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3175D6B0095; Tue, 11 Aug 2026 03:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257AE6B0096; Tue, 11 Aug 2026 03:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22556B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 03:34:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A97A4037A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:34:36 +0000 (UTC)
X-FDA: 85088176152.14.5AA6EA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BBBA540005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:34:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYJgr4Uj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786433674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH6cZGx9LYOHeKQhFjEwx6tN9N1GG4fsvAMNHfcjr+U=;
	b=Wi2fGg+zRngcafU0cZWxSoPqxU6wOEfbekiRP+rteyBZ3VMYcJzumaWnWkEPtk/RNJ+8OK
	lb4Vh8cwwzTz0NoM93XJWEgxzG3kIECDKwQOqDqz6KzTKkGS8CSjURuopix5nJETLWf51M
	KPIsaVHhxJYbz2iEc3XlbrBaV20VvZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786433674;
	b=qGbFqcAElLb6t29Il7pKWAvw2pzO1D7HG0n1buyIJT07HPMvzPTk0rhV/DfjFsxsr5Mtdi
	mY/lIUsVWA/oNPdpNvXfpLlUBovkYRmPzWmsOIiWw6mHUcK6pqWBGQURooH1xRNyunBd0l
	xziTN4VRyqA+znLLFzbWDIXGR7aCkeY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYJgr4Uj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A73400B3;
	Tue, 11 Aug 2026 07:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D727C1F000E9;
	Tue, 11 Aug 2026 07:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786433673;
	bh=PH6cZGx9LYOHeKQhFjEwx6tN9N1GG4fsvAMNHfcjr+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hYJgr4UjkDDJmyBrHtvX7sMiaB1LfpYKkoqma4LEDLxn2vAxGmcG8HDbfm0OcPpxO
	 /PoguVv425iXNK1y+28ugx44Olws6TLU6cVlLpWCRA4qYDbC48QiYt0ue9yMu7yDPM
	 hrgSU/23qphxumPAw638uBx+m5KQpLwy+pcczNPXpwAbPpHWu1r2/MQlKqDMuShDXC
	 Ar6BiBaeawo3AAzB/piLKYsbf3BGkLDLEIet4ooFD7eH9tpOi/maVnpldU1wkj82qL
	 fHHl5ygVUwlgIugjSD7Wr4SAmC0pX/fLfjhcGI+SdWugSlHhbNrwQBI1bbUzURAnYF
	 +DX/gNrlHxk9w==
Date: Tue, 11 Aug 2026 08:34:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: gao xu <gaoxu2@honor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Xiang Gao <gxxa03070307@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "liam@infradead.org" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Xiang Gao <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] tracing: report buffer memory in /proc/meminfo
Message-ID: <anrPJN-V8K4fhGzZ@lucifer>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
 <69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
 <anm0SMuVpBz7wLac@lucifer>
 <20260810105710.6ee5e493@gandalf.local.home>
 <9bd98f51abd44d81a569d95e907070c6@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bd98f51abd44d81a569d95e907070c6@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBBA540005
X-Stat-Signature: ph974f3hegimk9ak6ou5z5d3grp78zeu
X-HE-Tag: 1786433674-451561
X-HE-Meta: U2FsdGVkX1+jzDsAJxwcrrDsFH9X7Y5J06/NEFZeZC1qEoz3SzzzmUTYjld0J5IPlrUbFC1HV3JYDa/TmyXeXR14ivUyG6bBC7aujqLm6G/obcpzMT+cpNQ+w3BmezBDZAG/6SjKEhOPXgm8EITJoYNoIee3AtW43fpeYw1vIpxNUffbz2fXe2ze6pMdelGOaq0qEiHME4QDdMiqh9uXxZbNm9Zx2gFnJOBCOobuGOqbLge83CGbafDH9mwFU0DOrQVVWt0m3om+Ctvcb2MiYKpEfX1/FcURY84HP633H8TMMp/D3bx7zuRhJ0lakQlwVZ2Vaero3lSIAGRa5x9Rl/pMFawTw7wgDKXlNVzlyIVXXvwr7qZPCs1HZHCzjcBtPhIKQ8/2QisUDFgS5eolEyyCMXcRGVE/aiIBPbRMuZRX4Vl2F2WMPbXzZtA8wih04y1Qa/doDSz2hddvnHhmnUpRw9IDkw40C69w2jbLTx/nxsyBFgmlM+wGRZRhAFhL59jO1vLDw7/M2WSlkYSVCLp7y0/t5/1bb7LYqGeRTIPqd/kT18N0iGWYWaOSxN6JNwT140iAgkvBUDoryWlsdCBsiCH9ba9LbaYj1R1tXnaJV+qv+zp0FR4qdC4iUyNo1RKIa21gL4vm9B2GAdz3D6HbFqnV5PA51XZiYkTnWlfWkpPbdIEFIsiE0v4Y8mPqfN32xJEs/+zJdPTsIp7H7aK/WgTkeyVFVp3iLJvAE0Mg04XLWA1T8OJeTydFZfAERW9AddkkmoJuBcUdYFhgFF3xAvn5asVIe2SyWgoOGZnhrRn0UBi6965zUUEtfgvX0eQksDe8g341QC7D/bEANlZiBUD6fhGKq0MVXaQfgFvWOuH3pth6pVARzmHSBF99l7BXjtBZhm3UvVawo/61+P4K5VrvkAws1uYY5Zn+NKV/F6IF+sW5JxKLHD2Pvit2jSmHi7d1knFRcMxaLvr
 AHI00SWe
 xpgR7K3ov+kYvDcqBblNUSFJDbi+IJufYeglfeleXk2cl7uNdyQQP7QqRgpCXn5C9NBQ9eYm0YmRunl2Jaxt82tKXgP1xsDrMyzGSWrT/EWK/8YuOtJj3Z7DEztGCcSqnhm2oxRFDhhcD8b0K7fSv7lBQEK83KJkEh/GmoYAa+AoGWZxSET618jGGMf1kWyKFRJn2zzNWejf6gDDB8h9QewxRkv06pvKszgDH5D3ZTv909Lsm3dplf7cn1QMQY40KZXQ/uJOzBJ+JdFmInzbBIxqSsyAu6WVTiRzHV0212edbkWTKvkElelG6sUZrYnIyTFah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:22:58AM +0000, gao xu wrote:
> > On Mon, 10 Aug 2026 12:22:43 +0100
> > "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >
> > > On Mon, Aug 10, 2026 at 12:52:38PM +0200, David Hildenbrand (Arm) wrote:
> > > > On 8/10/26 11:40, Xiang Gao wrote:
> > > > > Report the data capacity of all ftrace ring buffers through a new
> > > > > Ftrace field in /proc/meminfo. Include the main and snapshot
> > > > > buffers of the global trace array and all tracing instances, while
> > > > > leaving ring-buffer metadata accounted for by Slab.
> > > >
> > > > why? :)
> > > >
> > > > To report a handful of KiB as in your example below? Doesn't sound
> > > > super helpful TBH.
> > >
> > > Yeah I think we need to stop with all the proposed additions to
> > > /proc/meminfo :)
> > >
> > > Also something like this where you are making a change in output that
> > > it is just your opinion that it is useful should be an RFC to see what
> > > the community thinks first.
> >
> > Agreed. This doesn't belong in the meminfo. If you want memory statistics for
> > tracing, I may be OK if you add a "total_memory_kb" file in the
> > /sys/kernel/tracing/trace_stats/ directory.
> Would it be possible to include this info in show_mem()?
> This would be helpful for analyzing low-memory and OOM issues.

You have to back up requests with reasons, it's not a case of 'please add X to
Y' and then we deign to do it or not.

Justifications are required. We could add endless crap to show_mem() until the
CoWs come home, maybe even list the number of emojis used since last boot
obviously.

So - why are you asking for this? Is it only a handful of KiB used for tracing?
Is it GiB? If so maybe it's because you're doing something crazy? Why does a
kernelfs file not suffice, etc.?

You need to engage with the discussion and back things up rather just asking
like you were typing into an LLM prompt...

But in general, no, it makes absolutely no sense to randomly output some trace
information there, unless you're about to offer up the most compelling argument
since the invention of marmite and butter on toast.

show_mem() is for critical memory information displayed at the point of OOM or
sysrq-please-help-me, not random stats.

> >
> > And break it up for memory used. Ring buffers, events, etc.
> >
> > Perhaps even add one per CPU as well.
> >
> > I'm always conscience about how much memory tracing is taking up in the
> > system.
> >
> > -- Steve
>

--
Cheers, Lorenzo

