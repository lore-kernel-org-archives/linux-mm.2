Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A071DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006B48E0008; Mon, 15 Sep 2025 19:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8CA8E0001; Mon, 15 Sep 2025 19:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7EE8E0008; Mon, 15 Sep 2025 19:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB7818E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:41:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 953D71607A8
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:41:08 +0000 (UTC)
X-FDA: 83893107816.05.593B098
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id CAC3240002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:41:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757979666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBDBTQmgKDvQk+DXRmP6sHjHz3ZGuMfVidpv6UW3nl0=;
	b=hg1fe7l7fKRJlJI7OgsbVU9+mDv05Fux5RM81YvPoKhWZJPeTQEWygw1Qu90v2iMkissQ6
	7L3AXEY4+NVRDlA9bIlexRO/U6XojE7NKIBn+hEOxvR8u2vMRlR3/z2MzJW35oULVmx77u
	g8HSOu+3z9bwghguu2R/W8Zas4uBv4w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757979666; a=rsa-sha256;
	cv=none;
	b=jHo6xdZylgxKTqjHdwyNq3barjFtxuoB2N3fT4kAliOr3+scNyWIfrm9xH3Bhsn/XIr9sC
	mntPVLQoeAg+jxYGM6Q/SoVzKTqESY4XThTbJHCOdZM54sRFX595P2MsU5/yBLQiLwPnTx
	+AU8j5DXvdfB+YubfU0BvQhDtDdFB+0=
Received: from omf08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F89CC07CE;
	Mon, 15 Sep 2025 23:41:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id E2C4D20026;
	Mon, 15 Sep 2025 23:40:55 +0000 (UTC)
Date: Mon, 15 Sep 2025 19:41:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org,
 lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
 android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded
 trace event
Message-ID: <20250915194158.472edea5@gandalf.local.home>
In-Reply-To: <20250915163838.631445-8-kaleshsingh@google.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX182V87XcZg9olTniRrbK41HEticcPkYuYw=
X-HE-Meta: U2FsdGVkX19Zx1if+NNOzNVMgDMyEiQRf5KCrWoxEDdLlNyy025itEj2zjYJBMkNwUQkqjVFWdtFRA5Ynf4Yz52t7Y1DGnQ2OrwsGDN+DfgeyZ/AjYltT/l+Fuc8hpc2wOnrMa4yD4BId/vidyDiRLVZf5kH/cEGKQMrhL9USmC5wPTmd/XZBCPSslcwAPZSJYKJrh1jOkhQdQrzGMZhwDuGvOx64jO6Sdz5jN+n3mxHtNycmWq2UKphdEubae/8110tkn8jyhlLd+mre6+YjdQCeFduvdoPDJUesJYNt8Y1VSJVf19uZJ2Wze55wXrfVIdxUSD+IxDLITtQ30dzIQMUtN1rlpTd
X-HE-Tag-Orig: 1757979655-928162
X-Rspamd-Queue-Id: CAC3240002
X-Rspamd-Server: rspam05
X-Stat-Signature: df3ccaam1mxrnods7yhuxspu6mdbkrdh
X-Rspam-User: 
X-HE-Tag: 1757979666-687890
X-HE-Meta: U2FsdGVkX19SO/ixxYh80jjib04uSe4Hl4/kV8eRUQshnupOP7eed8fCyMTI4NR8L2Kq1uGS48YRuIIp4EfQ9Xd0XlcVKSjtPKCNGAOA8RhX3ZCdLEMAQFERW1OD7qOptKPtJ4JgHfyuIS0wNe4MDOKMQCDrphjMNM7zNyf2bgaOy+t2mkkztBmbsSodsDajGJP+PVLymHNYRmmzbVn2SZlhq4S0avUzf953ZSJE91xKzZuduHMg5GdRTTGaP065B/cJ6UY/9gOrQNCw4lfgSJW6Tt9xbXSe/wqXONpQzS9bz9w4IKYVdxBp9YH6flvD57Q0JJq681+runwX3rGW1HBvVfPiv+K3Bs39rLoN/7bnhQvFSI32ZWyOmUCKGjp/f2fa2zrty2D9cme5IXYUptiKSmT2haBaZftVbA6nDxfRXMwHotEgYEm6pCikECGLkpNh0T2Jiv6Zu9P5C1l6+yYGisILKNQAcyaSi5C7d76p+fOgG9glNXIyf0Q2X1WCgK2hW/9jLIGh9jTnqOpGLuCEm3LdQJsqTeq/Zw3POaK1xC6LbunoRREdgIlhO6yM4V05eQsAxYirg88skNa0aCj+nIi5KbEF3MyBMQrbCREA7PK0eeSLwEROuKDLkWU4zCg3lTmlfl69sG3hkKz2SIfGXw6jCartMV2WL67m17OQzxi9OUp7kB8I+NxKDPFDnF3ppFA3DpMkbvbGC7EiCV+fivWho2lo3HBw5pmt57yejxSKzOOqBXazl3FKUKExP2NPFvAr8OsWwFDp4saWjoO3eukRM0Bn9laS4tQYgDFRnYU8kkbgG3qjAf9Ah8C+hH6WBHVBwyFA13KhePApnIVLQ7JauRBjCO3YXsE2PYVXTTpV9rdz1CUeDAJVsy7S6pCMIAQq1ilTObmPSrWej8ar0izn8BOIMv2ukfcht5AvLILrCgT8JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 09:36:38 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:

> Needed observability on in field devices can be collected with minimal
> overhead and can be toggled on and off. Event driven telemetry can be
> done with tracepoint BPF programs.
> 
> The process comm is provided for aggregation across devices and tgid is
> to enable per-process aggregation per device.

What do you mean about comm being used to aggregation across devices?
What's special about this trace event that will make it used across devices?

Note, if BPF is being used, can't the BPF program just add the current
comm? Why waste space in the ring buffer for it?



> +
> +TRACE_EVENT(max_vma_count_exceeded,
> +
> +	TP_PROTO(struct task_struct *task),

Why pass in the task if it's always going to be current?

> +
> +	TP_ARGS(task),
> +
> +	TP_STRUCT__entry(
> +		__string(comm,	task->comm)

This could be:

		__string(comm, current)

But I still want to know what makes this trace event special over other
trace events to store this, and can't it be retrieved another way,
especially if BPF is being used to hook to it?

-- Steve


> +		__field(pid_t,	tgid)
> +	),
> +
> +	TP_fast_assign(
> +		__assign_str(comm);
> +		__entry->tgid = task->tgid;
> +	),
> +
> +	TP_printk("comm=%s tgid=%d", __get_str(comm), __entry->tgid)
> +);
> +

