Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8191A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=EHdbSKZv
Received: by kanga.kvack.org (Postfix)
	id 9F36C6B00EF; Tue, 17 Nov 2026 17:27:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC716B05B0; Tue, 17 Nov 2026 17:27:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909BC6B05B1; Tue, 17 Nov 2026 17:27:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2596B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:27:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C58A1A05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:27:54 +0000 (UTC)
X-FDA: 85446049668.29.60138CF
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id 39CCC120004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:27:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794954472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko/0t8Uo3cYIjjNrJtn/Btsh4RwXHj5exYfcCPg49hM=;
	b=dXEGMRDErG7qyjdtYjyQsoqccb2qu8Putnqqw9EvwpoknqTT4rkYUlgpNzqLm05ecpDmA/
	6aov8e8yU66Vhw5bX6WT5D0ztcsSbO1VDUAHPO4WWU0BxCs+HId5TCfiPN3pLpwEvYELkA
	ZUtlN8h6hXhRSwyBrgJGYcqv4EnxTas=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794954472;
	b=h3d4PtObD7kBjh7inkidYgwHfbjTUQfxAD7n0vFRdPXACxsA3EjuwLAOt7HybMylVyv7sy
	aspSHmK17zEbl4OHcmU0T8RBUSAag+we8iiaNovAwfNmhZynenM+myNW7SU9B/p/pCQmCO
	AP61SNJmdpcu+Jftlkk71SyREybMzEo=
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C7691605D3;
	Tue, 17 Nov 2026 22:27:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id D729F20010;
	Tue, 17 Nov 2026 22:27:48 +0000 (UTC)
Date: Tue, 17 Nov 2026 17:27:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Chaosheng Qu <quchaosheng000406@163.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] tracing: record jiffies in writeback events instead
 of computing age
Message-ID: <20261117172746.42d075bd@gandalf.local.home>
In-Reply-To: <1793157924.328974.4869096@163.com>
References: <179299543891.294518.18224691820856958686@163.com>
	<20261026084709.26f7737f@fedora>
	<1793157924.328974.4869096@163.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX198/NLHb3rmfOYPbcxeL4+SJl56B6U+SzQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=ko/0t8Uo3cYIjjNrJtn/Btsh4RwXHj5exYfcCPg49hM=; b=EHdbSKZvsn4//OVY5FY9Ahc2Tr8C4l4YN0lT74uTZqOOPhLacf/5lPpne0rS3RvEfZ9Dz6hWOaY62RNhdEFR28cKvlVDus+WOszi56LR5mxRHeMY0/efedKKf8hZ2BVH6nl82a8iGgpjZ1JOrX/PpVzRZKvfWLyKVdkBMGXG5ZE=
X-HE-Meta: U2FsdGVkX190m8CaKzES5kkLjFQxipcm1qgoflPGiCdFdHoV/FJOi7oPWmrW/1uY5DfHuFUsYYtdOUrf/ZK9RxJzapxWclGLxgXg8MEjes2VO9bI+ZVkW9zULcpftBVXpjpzJ5c8oN5jNpC6NyyvI8On5ZS9EWXaoE5tZjHAVYtfSMhC1kjbXuSroDAB8o7oHlSqwwbdpSbPA3ApcT9R49GjPH/6IC69a94Cwb1AlRJzo1Bu2B+60/hZ61I1WTDhjHevSD0Vxyi0Hqseuwm+z0N4+0wvVg90mZX7TKi87U3wk5yplLLOqFVSHrsELlSJWvql6CScXnA5SczNE0BbcN5t730IAdBBHrPJaIKIcGRanX1kpbl3Yb7z/fLVweo/aIv07eiOBJYU5rm0630Jk+led1HWzJNow0UzQMUFkjA=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 39CCC120004
X-Stat-Signature: s4cdizhjhscjqygk7q3m9hwq93831cn9
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag-Orig: 1794954468-512238
X-HE-Tag: 1794954472-953887
X-HE-Meta: U2FsdGVkX186LF7ZqMzZbUTPnq1AH5fNFX2iyA+TwY6zX1ZnYk2xEPojQT2x5GbTPzZ04KdrASGI/iVGfo/+eHovoeEdw0eBFQ5fyQATrXOh/1DPRrTomDXvsBlgr2BDg0GLF4ihsf0Tht9Sov63L8o1JrYKu+SRlHkx1oXmSpswizDpiP9ZevBD00NCbhzkAi1VY4hpeUkczAqtjWCYBXlBfCyVpaERfX7ugnS2z6ncPEMl5Ye0ggtZiMlhYM8WRvwtGocUb829/9XVEw46dQ/gFRSwS7hAI13MW3c0/pn29xGj0g+EIp56Cfrjz0Nl0zPtsmTzKbzTVgwNsynzAsA3fgzjX/Z+CeY6o61cnG1+bHqkAmp5hUW7/w2djZonYzQrOnI37oIsGujHDH6VzYmrZGUqWEQk0ghPNtt/Vpbp9jf+5I5hYacC9SpOlhgmTYhZaokz4GHHJy2pRBnQPhDdwkD0oPExO7yQqrG1mKziN8RGAuPqRUwc5YtG9h9nl5j3QMdh6PRxIWyPjIYEstnk6q3BPD/UnsPmO5M1LuzLu/ayhXXoedpbXabLHUJXwwyXzNas2QD1cXgPavQ2jn67JCu8wPaz6F4wT1j7HF5349SCMQmTy3u6aDN41OcCosJo1v0DfPtHKqz3cBG5uQIl2TNXPvMW6GDTKMo+mE4NHcXUQH/m7xYgkLJdoOwJPbfmRCaYoux93UxqZbgk3BJ3q9+sx1CzVHH6bCAkJiiBKzbKVust+/pjndZ1DiTYcQ4IpvC0pi1Cff2DEToniT3MgY6XrJY5uFKSf0hY14cVushH/bsqXK3Llc/tGhXVEdAXggp4SOk15rYheQS053OhXhKmGUIAyKQwo1OFzBdmckCd7mXivCz5iFr/Jj0/uCKAkiJ8SUYxDk/prMi+jAEOuFC4qY4wm5Q1ZoZRiN37e8TMIIU8gKNYmpfGLdbAh6VMJM07+Lz5+Kuy9dr
 oeRyLgeS
 ScJt57HbuVt+5OiYkbHlMTNXkN2+bFnZZxaH6hSl/EAOWgNnR6bTQrkt99Asr+u1GCvr3joDnyIAhhGKB5xWsJvhRKOwqZNPuzFEOoTBlXDPYHGrks03fVERDmdT5wLziAxs2WT7yzAa74DI7iu9TSkJVXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 11:25:24 +0800
Chaosheng Qu <quchaosheng000406@163.com> wrote:

> >From 677560a14dae0d9581effc5cdb9375052902bb21 Mon Sep 17 00:00:00 2001  
> From: Chaosheng Qu <quchaosheng000406@163.com>
> Date: Tue, 27 Oct 2026 14:28:09 +0800
> Subject: [PATCH] tracing: record jiffies in writeback events instead of
>  computing age
> 
> writeback_sb_inodes_requeue and writeback_single_inode_start/() compute
> the inode age with:
> 
> 	(jiffies - __entry->dirtied_when) / HZ
> 
> inside TP_printk().  TP_printk() is not part of the recorded event: it
> runs when the trace is read back, so the expression is evaluated at
> formatter time, not at the time the event was recorded.
> 
> It is also evaluated outside of the kernel: tracefs renders the format
> string once and userspace re-evaluates it.  A tool that has to resolve
> every symbol in the expression (trace-cmd and the parser in LISA both
> do) resolves the bare "jiffies" to its address, so the printed age
> becomes ((unsigned long)&jiffies - dirtied_when) / HZ, which is
> nonsense.  This was reported as a wrong "age" value in trace-cmd
> output:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=219839
> 
> Nothing in TP_printk() may depend on the state of the machine at read
> time, which is the same rule that keeps ktime_get() and friends out of
> it.
> 
> v1 stored the age itself in TP_fast_assign().  Steve pointed out that
> the division then runs on the trace path, which is where the side
> effects have to stay small, and that recording the jiffies snapshot
> instead lets userspace compute whatever it wants from the raw value.
> Do that: save jiffies in TP_fast_assign() and keep the subtraction and
> the division in TP_printk(), where they run on the slow path.  This
> follows the same shape as xprtrdma_req's connect/reconnect fields.
> 
> The new __entry->jiffies field is appended after the existing fields,
> so no existing field changes offset and trace consumers that index the
> event by offset keep working.  The "age=%lu" placeholder keeps its
> position in the output text, and the value it prints is unchanged.
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=219839
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Chaosheng Qu <quchaosheng000406@163.com>
> ---

This should likely go through the fs or mm tree.

-- Steve

