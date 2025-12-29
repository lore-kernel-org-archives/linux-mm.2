Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA73E92FD7
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D016A6B0088; Mon, 29 Dec 2025 16:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9486B0089; Mon, 29 Dec 2025 16:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06206B008A; Mon, 29 Dec 2025 16:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B20A66B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:36:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 664B4C3077
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:36:32 +0000 (UTC)
X-FDA: 84273817824.23.C14D73E
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf04.hostedemail.com (Postfix) with ESMTP id D037240010
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:36:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767044190; a=rsa-sha256;
	cv=none;
	b=J9oMgNfYdA4OeUU5xTBoYwYChR/M19CrfcegJLQ/2xa5XAuSB0o8n8ukFp0HFCTkaW2Dx/
	hrsl2giavdilVUbVUPEbe1D6tqZA9ewRcl1YP8kc7H4OpmcukA7fpuCMygPT32WYF0J/Gd
	W1CpSOSBflpsfpzlO2/fMyvDNlF/41g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767044190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QIQWg1BR1nBO48qlzw3TFLY1ORTuBQMCyTR2DoO5/1w=;
	b=ufmSxNtRhpUVWxffWqGrxhUe5N/hcu+ksar0OvKsr8nW8EYDySnIKl8XPlH7Za0wxXy7US
	KmnCAJ3wsrslls+jqdIGJFrPdKgUtZSfWQkhUZuYhr7firuBIZ2tPCFyYL3Cl677SKZvi8
	k5RpvN0DOUFRSyiJAmvVLLJdmWcxoJU=
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 123098C92D;
	Mon, 29 Dec 2025 21:36:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 4B26B20027;
	Mon, 29 Dec 2025 21:36:28 +0000 (UTC)
Date: Mon, 29 Dec 2025 16:36:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org
Subject: Re: [PATCH v2 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Message-ID: <20251229163634.5aad205d@gandalf.local.home>
In-Reply-To: <20251229132942.31a2b583@gandalf.local.home>
References: <20251216130302.5202ca81@gandalf.local.home>
	<20251229105427.14720-1-tballasi@linux.microsoft.com>
	<20251229132942.31a2b583@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19vnfwECd9VuIth4+80pGK3VKZT8RK3tWc=
X-HE-Meta: U2FsdGVkX18RJmiX90bjSIbUOSI+5lqzsjlB+XCYcHOhwxKZOfh+PsJu4HHuHmUhEqJbzYbVsl+y4pnQPqMX1g8eRxmEV2V+/7eHLEhptSGnI0lJh7ztu1FJAJnZvQUeHH7w6Xgj+7gOQsC+wIKDCEoYYC9OE6B7H52P5oGvd7qFwDf2Y96QflZq+g1xQ5wRehUTB4Qo5a14+Qys0RiANezVk6HV4G/bPw463h8sJgAWyW+VOa9DaUuvkeUGB+jqoyFNTjwkiKSRqOR25RrgEJcUNAFpqWLW+d5o8MByUrJ9Bgrn55v2d6PfpgwyOJE8wTcSVRwpNmCrYjm/sJQsxDwAPEbcSV3nr5Kb/hk/tSRSLmEmBjHj8BUORiF3a6AfZrcHVB4xMmoGJMNKvrUzUQ==
X-HE-Tag-Orig: 1767044188-228809
X-Rspamd-Queue-Id: D037240010
X-Rspamd-Server: rspam03
X-Stat-Signature: 9dme4xk9mahdzri46js3x51gu6gydzub
X-Rspam-User: 
X-HE-Tag: 1767044190-614961
X-HE-Meta: U2FsdGVkX19uYayAdB+dCEg4olX3phllstzfXNdkmSdls9fNZlTonp8HWKjLmua7gLDCR/rBqq0klFafwha3G52Vo4nNoQkuafmdY0t2N1q5gonPg+0WXVFIWkse9mxgzTvOXcyc62FczufWoUsY71t98dr7ojS8Hx1JAG/LclLIhCPssqXhWTPYPrrOUjLYvWsg/ytjaOcHDk0wSyyv0vMz21EojvfgXE1XOInMtPRdxB1x4q8ZmsgE+nZ6F+SuErgOeHxl85BrnIwlUIfkr3GjaAawhXT5Xat+XsLJMi8vdG9l9bsnRDeYZPp0bOo2jFHaQwR251u0mIQiFdCz96PdxuPktvcxxH6cq/YxnnOaI2bCxB1dOkCD1DZl2+AwwWAzfUGQzZfIOx9ENRrQq8lqi1E85e4/yc++IfBucSKelmZWD5rDNZdlF1nq+f3PfKPZNbc0ZGLoOMJcidxSaAUpXyIA6bAABGX2iOjM9Hjo77GXjRUhWFu6H97D5qhZCvN4susheTSB/6faL/v258Oq9tzlNoVgc6vg6Sy0RlMQls7/TIDF9RiB7iW6UMy5hRmnzHOScyoWKEZsU2PwDjsk6QnNu+UUe00jEnE1Y7S3SFBDW9Oubmb0EMGWerFGkETCEPDNfB+0ZqehjAevDJM/zHgzF0amz0uTbpyirog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 13:29:42 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> I just don't like wasting valuable ring buffer space for something that can
> be easily determined without it.
> 
> How about this. I just wrote up this patch, and it could be something you
> use. I tested it against the sched waking events, by adding:
> 
>  		__entry->target_cpu	= task_cpu(p);
>  	),
>  
> -	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d",
> +	TP_printk("comm=%s pid=%d prio=%d target_cpu=%03d %s",
>  		  __entry->comm, __entry->pid, __entry->prio,
> -		  __entry->target_cpu)
> +		  __entry->target_cpu,
> +		  __event_in_irq() ? "(in-irq)" : "")
>  );
>  
> Which produces:
> 
>           <idle>-0     [003] d.h4.    44.832126: sched_waking:         comm=in:imklog pid=619 prio=120 target_cpu=006 (in-irq)
>           <idle>-0     [003] d.s3.    44.832180: sched_waking:         comm=rcu_preempt pid=15 prio=120 target_cpu=001 (in-irq)
>        in:imklog-619   [006] d..2.    44.832393: sched_waking:         comm=rs:main Q:Reg pid=620 prio=120 target_cpu=003 
> 
> You can see it adds "(in-irq)" when the even is executed from IRQ context
> (soft or hard irq). But I also added __event_in_hardirq() and
> __event_in_softirq() if you wanted to distinguish them.
> 
> Now you don't need to update what goes into the ring buffer (and waste its
> space), but only update the output format that makes it obvious that the
> task was in interrupt context or not.
> 
> I also used trace-cmd to record the events, and it still parses properly
> with no updates to libtraceevent needed.
> 
> Would this work for you?

If this would work for you. Feel free to take the patch I posted and use that:

   https://lore.kernel.org/all/20251229163515.3d1b0bba@gandalf.local.home/

-- Steve

