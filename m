Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774A7C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 18:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84AFC6B0088; Thu, 23 Jul 2026 14:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB006B008A; Thu, 23 Jul 2026 14:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA1F6B008C; Thu, 23 Jul 2026 14:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 502B06B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:23:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06AB880168
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:23:04 +0000 (UTC)
X-FDA: 85020863088.15.DB6B156
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C8E018000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:23:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iM9vBO6d;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf06.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784830982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FA4mBsQKWU8EQ2CYmvf4S68ZIMYsAwryF0Kpl/acuZg=;
	b=ayq2ommuClq4Qq3jqiuq6+L1PgMDONItimF/PoyLKgYtNroN8xWPs2soUFUDu0Qk3h0KiZ
	GdEZpsoLnoXhJw7hgw8FSapz1Q1BWOFCjRl5SBsaVUyVpicw9vmUwobMWM3R/25hWXQBfQ
	5M3hOAY9jFpWnxU+3lv1lyvdlUbjfkQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=iM9vBO6d;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf06.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784830982;
	b=pO9T6+E6jXtuXJ+m5RqRt6AiRqzYTrUZmq19AGYKl2evHlmzEjEGhGpiErUY9G+78e+w5l
	HRvi6poxo8XQ3zZd7oDB7iIcVFXFYs2gnTQb3Mzu3bOvEOy+x0yz92J9uBJ+nX2yvqR845
	XzmqoyGrS1xpf94OrrUc7nbeW3NTir8=
ARC-Seal: i=1; a=rsa-sha256; t=1784830944; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=ZgRGsO1vp6I1TA9lbR1q6pJfXbhHuLjaFrYZd8qa+XXlXa80NrxDt7Cqc5/Yt5Z7UTLtKiLJ+hgvsbwP4zywt3gpGimYObhfJyu3/YMjIzfOA6AaGo9MJXYP11iSrZUs7tSrhR7122sbkBhG/1EiH1DwJSom7/1Okx/ee30NJi8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784830944; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FA4mBsQKWU8EQ2CYmvf4S68ZIMYsAwryF0Kpl/acuZg=; 
	b=MP2bNNy8+PQBX7WOQxriWaQLWkosAV0VtpMatnrve8Dbo29zb/lvcoKEr4xMTgaX5+tLVAwpT9vVbQXg/MzTo5E8A3chDfi/2kPKZ8uBAS83cH/J+rdUwuDzj3mHNRqkPT5CF4pLZTiU5HX3+tasGEKC05DKcpdWrVxBRfEU67s=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784830944;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FA4mBsQKWU8EQ2CYmvf4S68ZIMYsAwryF0Kpl/acuZg=;
	b=iM9vBO6dIzMfZnoQW8s4KKgA/LgKEm6GHomoRfr8+/P46orAUQ775dRIJKK7tATu
	xJTCJLZnGs2a7VoSXHV8I8WGK9MD/fqSboFx/9n7GPSgY5ESzFBXSdT2D3LIIua4mex
	YalR7HXYecgJlrwIgxEzJLuUCRPeHjLS3GEHsxUU=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1784830943510389.2736694427938; Thu, 23 Jul 2026 23:52:23 +0530 (IST)
Received: from  [14.139.128.54] by mail.zoho.in
	with HTTP;Thu, 23 Jul 2026 23:52:23 +0530 (IST)
Date: Thu, 23 Jul 2026 23:52:23 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>,
	"David Rientjes" <rientjes@google.com>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Juri Lelli" <juri.lelli@redhat.com>,
	"Vincent Guittot" <vincent.guittot@linaro.org>,
	"Dietmar Eggemann" <dietmar.eggemann@arm.com>,
	"Ben Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
	"Valentin Schneider" <vschneid@redhat.com>,
	"K Prateek Nayak" <kprateek.nayak@amd.com>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"imbrenda" <imbrenda@linux.ibm.com>
Message-ID: <19f9036e10d.333785164640.2738459517257915395@zohomail.in>
In-Reply-To: <20260721171724.56f1aad5@gandalf.local.home>
References: <20260719185409.409685-1-adi.sharma@zohomail.in> <20260719185409.409685-7-adi.sharma@zohomail.in> <20260721171724.56f1aad5@gandalf.local.home>
Subject: Re: [RFC PATCH 6/7] mm: add tracepoints and vmstat counters for
 async teardown
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C8E018000C
X-Rspam-User: 
X-Stat-Signature: p7h1twc7rc4ibx9annitg3xqg48dupzc
X-HE-Tag: 1784830980-702543
X-HE-Meta: U2FsdGVkX19EjG7MhMVf2HxO6tbMPwRW5f4xapAd/tAHR5YjUV3VKqv+5bUPQmh0hGZHJZV/gFeW4cCwtuakVo2mjtQSeLABvM1qI4neelk4/irwcUAa9jP6xW+zOU9B9+/A1whUYt/2g49qEK34XO0DgYKFB4l8XB6XRNEoZlAZHgL5bWjHz8Ssir6yHY11jbGMP1sErMOFAUeRmQQM7gOfvS+oADFi/GopJMDNRqc0uiEkgOLNnn90J+f42oYNuJ39ocvpRAm8roARVOjFqnykSa+nF5xpnVJD2gvJWRGNmZW4o5iRcOqoO+nyWkPUGF7Z71o+quDvaOEmB1sI844MF22gwLxPnZvlHUQxV6TZsz0vC6w/fYmK6vT6OLOe/F/i9P+rCswRxBW3HBbqIBJtyzeQGXYhf6+84HGf+vbX+DoRwlvaXN/XQPfzs4ArnHlFvhbkvF7daNS4O7EDolJSI+UMWr+SWXmy61ScFjbQY0evlmHsRClR/ymV6Fvl9zzya2bMYSaSI8tkbreCAPMqFipu3Z7GpOzLuv/VYSjrrnlDienWkaRWdPkPzsKpi6zh7rAfX/Mz4LHD8DrXhWFyP1fXWsd86Y2Qxybv8gzdzbyHrPQJcWjE9d3ebjZ4kusDXebdWWlIhusuJGJey8wu834d7ABG8Jc//fPCWZKSG1wEZMOlM6xkTBzITon6ctatD24Fs7BQ38MvaMoNovt6dMWQAwdOZhq84K+c5gtaujrqgPKzMyRu1b4wTMAmvtgK6Z2sfGnMRBNwQoLsKLqrTtrOPBD5qY/NOCz61SLKG3oMl/Iooy8v3lNmqfKxeZwQYMv/7PNt7/R0ruFhlfxnK+5m6qNRaCX7b0AUPWEx9h8gKcLapYuT9EjiKh8oJ7I8MFP2Ap6+mcFHCVcPLLiRq7icbUSHp6jZ4zX0t5j8bIlfwcNxApoL/uIhyTsABvvW7vvzLOcDMgT3zFN
 Z35ypK14
 Q6bvMtEC2SmM99HUvbc344fdazFK7cEdl34DaHgdRyBpFCuTT/n0p82M4+QoeHGioCmDA4C0yzeL9jyd+FvAA95l29zNCDbdLWxAfpN3Q5hBPoMERZW8BceKbs5aWqx649xzaQgSfbTKo1/v5FCYrH+0epB8//yvypP8TNWYXupqOWOk6jZrldfVhp9NAFE+Ksqylu0Lj+W1u1+s9Zc08zLs2vjM7UmgAXsxhEHhjnuOIg4mjn0+xiAydTtXAC48/KQgsCg4DCOWAJIw7mpEG7FQLBvpizuKNFNARmmX7oVtGLrkcc9XoDrc2zUZruomNE2JNfYNaPHzHQ7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 > > +    TP_STRUCT__entry(
 > > +        __field(struct mm_struct *, mm)
 > > +        __field(int, pid)
 > > +        __array(char, comm, TASK_COMM_LEN)
 > 
 > There's an effort to make comm size more dynamic and we want to prevent more
 > memcpy of the comm based on TASK_COMM_LEN. Please change the above to:
 > 
 >         __string(comm, comm);
 > 
 > 
 > > +        __field(unsigned long, rss)
 > > +        __field(int, node)
 > > +    ),
 > > +
 > > +    TP_fast_assign(
 > > +        __entry->mm = mm;
 > > +        __entry->pid = current->pid;
 > > +        memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 > 
 > And this to:
 > 
 >         __assign_str(comm);
 > 
 > > +        __entry->rss = rss;
 > > +        __entry->node = numa_node_id();
 > > +    ),
 > > +
 > > +    TP_printk("mm=%p pid=%d comm=%s rss=%lukB node=%d",
 > > +        __entry->mm,
 > > +        __entry->pid,
 > > +        __entry->comm,
 > 
 > and this to:
 > 
 >         __get_str(comm),
 > 

Noted.

Thanks

Aditya

