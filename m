Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15A4FC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFD76B0096; Tue, 11 Aug 2026 08:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260D36B0098; Tue, 11 Aug 2026 08:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152606B0099; Tue, 11 Aug 2026 08:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3F6A6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:44:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D830E120411
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:44:52 +0000 (UTC)
X-FDA: 85088958024.17.7EE562A
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E7F6180009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:44:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntNh+Y1bgklM+/gMUnlAjEuI28WBEA7wmiH0UCF3kD4=;
	b=nHpOv+9v8v874yCanUqP9/u9/MEbFhjoYADvqIxZbPd9NFQBVtVN+k+T1xq0GqtY2kCEuS
	3CnbXhmUCl36qsdSmp7jW8QD34Vd3LZ+iK0pKNOvjqWPG1gv3GMFkEVj9eoZK25jfJrpKp
	rv1eByav9WXxOcLVDnOam2Yp/Xklo6c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452291;
	b=2wIEDo5dg2y3NEgsFSLQlBJ4GcrWiSl5AjhNDBK4bhu4/CxXvEX92Ir/hOu+BhQNGzLmO9
	bpRPHiR6piosY7mawt64hEXC4PHKOMm+kAvA5N6f+iRzx+HaLhwyGLp8KhNc7rAxMIPCJi
	8Yj8V2kkIRok04eEMVbSwh0Q6VQmnXY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC4F9C03D7;
	Tue, 11 Aug 2026 12:44:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 4C25530;
	Tue, 11 Aug 2026 12:44:45 +0000 (UTC)
Date: Tue, 11 Aug 2026 08:44:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: gao xu <gaoxu2@honor.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Xiang Gao <gxxa03070307@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "liam@infradead.org"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
 <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, Xiang Gao <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] tracing: report buffer memory in /proc/meminfo
Message-ID: <20260811084456.4699daf8@gandalf.local.home>
In-Reply-To: <anrPJN-V8K4fhGzZ@lucifer>
References: <20260810094025.136705-1-gaoxiang17@xiaomi.com>
	<69df3080-a719-4131-a247-62bf47bda8a6@kernel.org>
	<anm0SMuVpBz7wLac@lucifer>
	<20260810105710.6ee5e493@gandalf.local.home>
	<9bd98f51abd44d81a569d95e907070c6@honor.com>
	<anrPJN-V8K4fhGzZ@lucifer>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19HxeI945sFhSHFXG6kqaLmhtmw1vOhsII=
X-HE-Meta: U2FsdGVkX1/QjJUC/xnbXiOaV/S1Xe/nUTI/+y2jkEBo7+9ZhQxZh0f+Ysv2BBzu+vo7p+MSGyQwxfM006wwHKxG+1O4q65prgZZpDF2KqMTVadlOnu4ZjfkyTTIPY0U8uEsw2lPcpQ1bV8bPeyqrfCTrG+jj/EdbXoMsPh1MOYvCRaslHcG/WJC8MY0nztbI4pRAVrWT8i6DgrcC/yobtfcd4fHvTeFy2MMVcCyi8KAgTi9fnyB4/6DJatcF/7hrYHaTg+V2K5jmJR77kgPiCDaFDyIjePLuB/rNEz8/NZDZkFUgPy82Q6Fs598C/6R/iSLMOSmCBkukzUK5n7kijLObhY1x3eQ
X-HE-Tag-Orig: 1786452285-923997
X-Rspamd-Server: rspam08
X-Stat-Signature: wokwckj86gfnu3ccfwaiatu7kxoxoetd
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E7F6180009
X-HE-Tag: 1786452290-334542
X-HE-Meta: U2FsdGVkX19KSeLCjYcN4T2EaLNmXU1ZRd+YXXIu91JZTTgtC++gy99NbFB2dA1UPyvmvLPLlwf9yaXKkmDrHNsJn4OtGXR0uKFZLV5LiClU10HnLAUz5VkgqSj+tHDEu2XyqRTmUhMmuf8KU2Qdf0JOkzZXRfp7IfgBi0EMQ4bYDvbGZHPEjMfKi2g62gTLbXOU2QsUs3Byp4KbifltPNsyLllfaPpzI1YQQY50quJuQvARTAiF80fnapgDX4R2948od54iOek5/VPeN4vfoE3pzUzaCoqNKJBS1Ro/gqVyOqEDeenij+crDWF3hSJc50vCBynK1GXqyRiCAbRYwyt7Dal8uuULCVhwwV+TBs5bdA7QPtngLGFav5I673HO3Xu+xNz1sHBlWBDWRqVX2R0YAFkf2JCk8oHKS2ZcszHwKkrRR+y8rA/FFXSMo0v/WAAR/nQOokBpvFgCYJS7migLVQWcv1W4nAVKeqxi09sk9NlraZb0t6p1aMiNVOlXDB0AuhYUd+Vhme/bCvBErvcE1KLAqDzdqVf01B5f8W6cXfN9pntD1rbm1qztLQ7IWWc2BRmkC31qRCy921Z/YyAk3S6AiJ8NzGIOpOTJPAhDGxTYW4eR3DizzM6wF6BoZddipX6qtM1A1rpNq2saZfYoGTa1oN8jnBOD8DdrfVlVcTcO4XnS80t7PogF0PcfBzfW46g3sS0IDtrRTsOcPN2opy/rMMiaqk+NOe2Klm/b24FySOP56XYXzZ/7VY0rBjSjmk2oG6mdV/V7jK0GFWyR7rH3Jg8r79P+4kI01ht/3bnnHBTctqUuflkaLXtRJMMzLaY6Sp2oMIrLKYVLzOvqRvLodW9AiRKhU9qwK2VXlkUynpFLyVej/CEvhcUUxviu2JZWUEKPaAEOS2cmD+PN5PrhlSOOGgdpPxPeeKBzI3ENEdgHWxMsohAw6JSzafmCOZ/NjXQHWnvtHfA
 l5MOV0a7
 4IATrid3qETr72oy4LUGxtDkvF9jlwjr2rVK2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 08:34:13 +0100
"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:


> > > Agreed. This doesn't belong in the meminfo. If you want memory statistics for
> > > tracing, I may be OK if you add a "total_memory_kb" file in the
> > > /sys/kernel/tracing/trace_stats/ directory.  
> > Would it be possible to include this info in show_mem()?
> > This would be helpful for analyzing low-memory and OOM issues.  
> 
> You have to back up requests with reasons, it's not a case of 'please add X to
> Y' and then we deign to do it or not.
> 
> Justifications are required. We could add endless crap to show_mem() until the
> CoWs come home, maybe even list the number of emojis used since last boot
> obviously.
> 
> So - why are you asking for this? Is it only a handful of KiB used for tracing?
> Is it GiB? If so maybe it's because you're doing something crazy? Why does a
> kernelfs file not suffice, etc.?

Well, it can be gigabytes. When you boot up, the ring buffer is set to the
minimal amount which is two pages per CPU. On a 4K page machine with 32
CPUs, that works out to be around 128K.

You can see the minimal size by looking at the buffer_size_kb:

 ~# cat /sys/kernel/tracing/buffer_size_kb 
 7 (expanded: 1408)

(it's 7K of data storage rounded down after subtracting the meta data per page:
  4096 - 16 = 4080; 4080 * 2 / 1024 = 7 )

Notice that "expanded: 1408"? That means when tracing starts (enabling an
event or function tracing) it will expand to 1408K of data storage.

That means on that same 32 CPU machine, if tracing is started, the buffers
will expand to 45M. That's without the user increasing the size of the ring
buffer (by writing a bigger number into that buffer_size_kb file).

Now I do know of some companies that make the per CPU ring buffer 1 GB
each. On a 128 CPU machine, that is 128G of memory used for the ring buffer.

> 
> You need to engage with the discussion and back things up rather just asking
> like you were typing into an LLM prompt...
> 
> But in general, no, it makes absolutely no sense to randomly output some trace
> information there, unless you're about to offer up the most compelling argument
> since the invention of marmite and butter on toast.
> 
> show_mem() is for critical memory information displayed at the point of OOM or
> sysrq-please-help-me, not random stats.

I wonder if it would be useful to show the tracing buffer if it is over
some watermark. That is, if the ring buffer is more than 10% of the memory
in the system, perhaps it would be good to show that?

-- Steve

