Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578DACAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E7C8E0012; Tue, 16 Sep 2025 14:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15BE8E0001; Tue, 16 Sep 2025 14:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52B48E0012; Tue, 16 Sep 2025 14:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 976528E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:01:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A2D01DDD30
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:01:56 +0000 (UTC)
X-FDA: 83895881832.07.249882D
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6E198140011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:01:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758045713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPICNny9vD7GoNqzbdnUFnYbfgSbSasLgcFPowaEJLo=;
	b=q+MzIR+bE7r87NwLueUASZ5k4mmE1lgafQerYkn+oNawLLc/4rViumu4BUgF9xh0SDoPf6
	e7GGdJO170KLPLSGxjhevAUK8S72BojMJj3PwmmjMpGqyLlE3eSXB/c8D5PPhPEI6pzte2
	XqHEhdKj+1E1b2fY+RX52N7QYnVrsX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758045713; a=rsa-sha256;
	cv=none;
	b=AaIx25i9JoG3eZcwGoFP6ldR4s3Va1tGjYi/JYLwrarZYc9ucgIPJhXikRemvsFeH0y79o
	p4yIiFvhv/0terfSVj7ibu5iRwJinu9Jw6nqyNHRtMJll+9P5ERmrZir4hzaaCgXG4pImF
	+1HTfj1bIsawIVmMWdvLSez+1YGvllc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	none
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77450B7BA8;
	Tue, 16 Sep 2025 18:01:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id EC8C420029;
	Tue, 16 Sep 2025 18:01:41 +0000 (UTC)
Date: Tue, 16 Sep 2025 14:02:45 -0400
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
Message-ID: <20250916140245.5894a2aa@gandalf.local.home>
In-Reply-To: <CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
	<20250915194158.472edea5@gandalf.local.home>
	<CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
	<20250916115220.4a90c745@batman.local.home>
	<CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
	<20250916134833.281e7f8b@gandalf.local.home>
	<CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX184S1CbixJjC2KL8Es6WaYGgHiZiwcrjEA=
X-HE-Meta: U2FsdGVkX194keMitKg7LUzLINew+H+ggwXI6UErbwL6DJC2Qc2N1u3vgQ6avirBipCv6qql8jJjFsRfYkRIEbGPP674VZJia+m4eEbg7FJ624UkaVK5tzhZordOgOczqBPCfS0AXimy2A/yGYmbbnYJBhgU3nWQucBtOsdUTFbUChUCEWLS21Pfype9kVW+AQ9/CP5Su535QGVZ00t3MwljzxP3T1AA5ITpWCW3CFuH4r/URZFVWzcHBK/T/t5UC1HP5bnZpuY82GhJmo9UOU3kx5i+3jfQ9aBItntQkRzuP2RrvFX+rzjj6lFl5SNdG3z0vPMEkXif/fLH5zExUgEoegrEiISD1MfnclaRhga73QBG4Kqr2cTxcUX6PeICSWQ4Rehj8Ew=
X-Stat-Signature: nsb591nxt7gsfzyeio9jph366iygy1fb
X-HE-Tag-Orig: 1758045701-643605
X-Rspamd-Queue-Id: 6E198140011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758045713-245168
X-HE-Meta: U2FsdGVkX1+qOOln/qEkcuGtziFv0G89iNS7kWgl6zEKo+JuqJsu26/KvefTVcUDQo7R0kV/rRXk02RyYTralPhPZJzxUBpJZBUNxPd35vNoJLkn9Ph6ntWbmjHETJjJua6Mz8mDbJPJMIcz7mRecilxWEgOedl/oizDJrHjix6Ltnhryn2mWh+KnE5SFMtDAoT7roJCnS5s3bnMv2Bc0DZpmQF/xHFRJmJZ2Q58EZqHm+JBh8EUE2Xhs5zQx3eDjullHPgiNlQE/ywDho6EFn36wza6pl2hORxgZHcaPBsjagTxwHdhtL48v+4qcn3yqPPNuVGH6NT57zpLWhrnp/jh7G8+Wad9VslvTRlhgdi48+afaZbb35Ky1phhJbkKKDSsdbYjOV3cOOSQYejxBC7L31GRLnzPQmDvbblY+3RTDXijdWG85hz+HACkr8FEG/U6hWAUN8X65DGwQ0lwS9oWVwLiZczx7AZg30XKyrDP41FJe+/+maA9v5NT7PdKVEAqt9hf3KOgPHi9ytV7lq4bwl5cKxJiNYpeF6C0uZsDadqnNrdnnMou0yA77rbgEyesF/L6c05RNcdnoZYVi9c31HvVmQnJsDSxzJTaZpYGfB/tE86CbzinqN/ohNQgRa+4jxx3zF9TjRSjCJ6p+Llv5CdwwMnF0Z0zAVe2fPASHTO2AjstILrO0jIfcswwJ3gd+2QjAZBnm261uH3l5PoHC5LZoMTkx29ZL2IOhfVrI0IOwCNDyPscUl3SKgbmOcE3Ol8FcF7P2ti4dUzxrflV4jUUSCUlw2qR9ugZ3Hc/fzO9AYXtzhcYNgAPbMWyFi8Sh9+HKyblzCytxFUMX3UyCVJxem2AAWLPFd0QyTH5u4vYFz/+EG372f5oKtEZsmB964luf3XLZ+BDR0Zw7dLkw3S2CE5hGMXXiMN8JS2qMvXaM6tD+dYEYImngH9H8nHEIKFHkRnTI1msVdJ
 IpYkFv+c
 I64pv2VamcOyVoL6ro+7km5Gsm+1E3WGV6xLoYMu2mJsrOPlzXDmEaiBxjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 10:57:43 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:

> > BTW, why the hash of the mm pointer and not the pointer itself? We save
> > pointers in lots of places, and if it is the pointer, you could use an
> > eprobe to attache to the trace event to dereference its fields.  
> 
> In Android we try to avoid exposing raw kernel pointers to userspace
> for security reasons: raising /proc/sys/kernel/kptr_restrict to 2
> immediately after symbols are resolved for necessary telemetry tooling
> during early boot. I believe this is also why rss_stat uses the hash
> and not the raw pointer.

When it comes to tracing, you already lost. If it goes into the ring buffer
it's a raw pointer. BPF doesn't use the output of the trace event, so you
are exposing nothing from that. It uses the proto directly.

Heck, if you enable function tracing, you are exposing every function
address it traces via the raw data output.

-- Steve

