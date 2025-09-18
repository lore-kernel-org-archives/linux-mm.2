Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BC0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23118E00F7; Thu, 18 Sep 2025 07:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9CB8E0093; Thu, 18 Sep 2025 07:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A778E00F7; Thu, 18 Sep 2025 07:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75E888E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:39:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29627140144
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:39:05 +0000 (UTC)
X-FDA: 83902174650.01.106E8C2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id EAFDE180007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:39:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="yAbG/z53";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wEOWNzPt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="yAbG/z53";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wEOWNzPt;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758195543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXXknVDpmNYnLUtM1qz0zJi5d3AHN3Yxt2BrVK20pvY=;
	b=N16LU4GgiGBuE3SUXaooIWnEN6bcVXtLOpq2mcdVLb2vUivW2MsTR8+wGlqzZPotF68feL
	CBhtW7+rENl0sz1mCt1/G4hzFg41iTEd8pkxcftldewAMc+txC2PC7tAc4kcpf9Y33hlyO
	pqfYm+nDIJ9DYmBtDMtLwasm5F0Xl1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758195543; a=rsa-sha256;
	cv=none;
	b=Nd7IgnOr4exAVwfLhTXZ5b4z/rA4egpfHUNE/DJVcS3EPMc7ATSCLiFkYmTJfRzakfYcUc
	QdiAwQHQtI2mq6v3sWDgl3UF9yePcRoqUTJZuoPjztnQCCVRZSGnk3E9Ig947qEIYWtXTE
	7fEql6QSgwlksDRe1/YGzOJSsfa9l6s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="yAbG/z53";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wEOWNzPt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="yAbG/z53";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wEOWNzPt;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA3D31F393;
	Thu, 18 Sep 2025 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758195540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXXknVDpmNYnLUtM1qz0zJi5d3AHN3Yxt2BrVK20pvY=;
	b=yAbG/z53WbruUxX/3ies41/VNu2qWdBGFLaPMVRN80Cqe+oNynqfJXnyf+t56Cx0mM2SdW
	+RVPmSGF6YFbQCt9A4UJ5/Jc4haI1+n43JilnK3sGxohsgBrAS2Jw3Ki3js3oL6P4rR15/
	f5tG+7EqBS5TJH4OmQlCKzmqFbTeoe8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758195540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXXknVDpmNYnLUtM1qz0zJi5d3AHN3Yxt2BrVK20pvY=;
	b=wEOWNzPth5hUlnK6FcdpsFJbnSHl9DOJAzXfjeo/GAewIY/wgz1P66A196GZT8LOd2sBZM
	mNY8RzOOf0aePvAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758195540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXXknVDpmNYnLUtM1qz0zJi5d3AHN3Yxt2BrVK20pvY=;
	b=yAbG/z53WbruUxX/3ies41/VNu2qWdBGFLaPMVRN80Cqe+oNynqfJXnyf+t56Cx0mM2SdW
	+RVPmSGF6YFbQCt9A4UJ5/Jc4haI1+n43JilnK3sGxohsgBrAS2Jw3Ki3js3oL6P4rR15/
	f5tG+7EqBS5TJH4OmQlCKzmqFbTeoe8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758195540;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXXknVDpmNYnLUtM1qz0zJi5d3AHN3Yxt2BrVK20pvY=;
	b=wEOWNzPth5hUlnK6FcdpsFJbnSHl9DOJAzXfjeo/GAewIY/wgz1P66A196GZT8LOd2sBZM
	mNY8RzOOf0aePvAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B186F13A51;
	Thu, 18 Sep 2025 11:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id luEtKFLvy2i6BwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Sep 2025 11:38:58 +0000
Date: Thu, 18 Sep 2025 12:38:56 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org, 
	minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded
 trace event
Message-ID: <6x64jf7szyy52gug6qoixhhjq6vsrcqpozqj4ambsehh2jprj2@qeye6qevem4g>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com>
 <20250915194158.472edea5@gandalf.local.home>
 <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
 <20250916115220.4a90c745@batman.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916115220.4a90c745@batman.local.home>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAFDE180007
X-Stat-Signature: 57gzxdg4nsbzdz9big98akoqqxdaf5yq
X-Rspam-User: 
X-HE-Tag: 1758195542-181561
X-HE-Meta: U2FsdGVkX19IxUSP4p29C1TP0cLzkBjUeBF/3gKxh+rcpXdBvKBYbdXw56ILnQOwXb3YUNdIiUnH7ub31Ogu5F6KRC/qqFQKtiHrx9wrjosA6dRQklglXcOdo3DEEjCLsX917huhuaUrgUi1SbOGCwGdAN3qAHedCARWiKuJcQi8lv82MhxGcMFQ1BaLmGQCzqqm3Ss9td5VWflOLcJ1UFm/47iSmYE8ZIDvtIV4mBGWceOcocLaZ+ABdNby7NQcA2E5+VAzoP+05TblRxvGaTLzOt45w7kDrmqpRKSPpyHoIC+AmijCr8+rRzAR2hYBEjSxkU8Xu4Ja6Ub9Z3TRnF/jt4Tw7OCs14QFI/ChuxhCMy/1PrG1v1X92gtL/peW11hTfFTNNbz2R7j0UCYLi82nM1z2paDVcVR6ZmI2tPcqp2sW8f8uiC6XhCkkB4RPj1fBcGVukoYiiX7yQtZb0FKneQConqMSLIP+5L/BNhtycCe+u5Nfj3zwXletuqNBV4j7ONAtvcbyM2LmtIdj2uBiWzkJG5rV1bGr6XMzZd2cB/yocBZirl7dOt2ztCIlzLf8T1P4vUFQcKM3gw5ZYIjtXq65948s6XbszX8JCAKtfn/CANQSDmVzJ0X8xotQwWSE3T4/wAg9h2sgAeQvPgdZcGFyPnKCu4wccvoLFSPGA2BEZkiXpDza/Xuh7AEe1nuQ6sKrIi3DBipweisELkWh9Vvye0D766B108knra4qUji6Lp/8lnzdJoHqlptJOV8lBOJ0WdaUhn1Z4yPpNP/LCjPrIaC1qOkwCA644TBojXhQViY/oyr3BXfq8YVKP0potu67B8+KIRl5pADeWObUk4TrnzBRa167XYgqUYXnN/FY/9/9kIrWFGcudROkEoBapKkYGdjgzhe3Eo0Ol9p4QAnmusd5RpzU0HyCy6Dt6JiaXNl4b9VXkcwIzy6lwYSozeRUsoKdznUoYac
 LnuMCgGW
 yedf+HySRl9AeJNylq2Xq3qQBBllMdM8o8WoskydnsrotGOmlHtuufM7/Gc/KoLuBecxN0mHCfi8BLjJ5J849y57mTPe/S7PBrS6URiKl+3IYmsvFrlgYDd/9WRJTBucVJec/HUdzZX3CWglhExtpHRexs6j2fkMJr6NAE2en5tPvCsQ1JqDqUCiwpyK09EAqNA/xwaY+lI10p9dKanup7w6ypKl1mF7n2vOlMKiYWexuKt+fDEAmf8K71aB2z4MffwoPv4OseBEyVU+mp+jRo/MhGCF76o+B3hr4+ebAzdCbJDZPZwR/yw1e3Ejz2lxO1LgQlu1Ay4/R5vI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:52:20AM -0400, Steven Rostedt wrote:
> On Mon, 15 Sep 2025 18:19:53 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
> 
> 
> > Hi Steve,
> > 
> > Thanks for the comments and suggestion you are right we can use bpf to
> > get the comm. There is nothing special about this trace event.  I will
> > drop comm in the next revision.
> > 
> > The reason I did the task_struct parameter (current): I believe there
> > is a limitation that we must  specify at least 1 parameter to the
> > TRACE_EVENT()  PROTO and ARGS macros.
> 
> OK, then this is another issue. We don't want tracepoint "markers".
> Each tracepoint can take up to 5K in memory due to the code it
> generates and the meta data to control it.
> 
> For something like that, we highly recommend dynamic probes (fprobes,
> kprobes, etc).
> 
> The only purpose of a static tracepoint is to get data within a
> function that is too difficult to get via a probe. It should never be
> used as a trigger where its purpose is "we hit this path".
>

Isn't the usual problem with that approach, that of static functions/static
inline functions? I was tracing through a problem a few months ago, and man
I really did think "wouldn't it be nice to have a tracepoint instead of fishing
around for kprobe spots".

Not that I particularly think a tracepoint is super worth it in this case, but,
y'know.

-- 
Pedro

