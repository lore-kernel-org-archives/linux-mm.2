Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B474ECAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD688E000C; Tue, 16 Sep 2025 11:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D9F8E0001; Tue, 16 Sep 2025 11:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A41E8E000C; Tue, 16 Sep 2025 11:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E908D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:52:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86561160139
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:31 +0000 (UTC)
X-FDA: 83895555702.05.E5DD82D
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id C5948C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758037949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qtbNPjEOfborgOTmJsTEeZ2/kWagRAPB1CKDuvuNaGs=;
	b=apJ4iS8Y7kYZFh3RiVORtC8vFHYJ2IvEn8+2KCulPqaZpY1JaFmbHMlKxof6UojS8nL83+
	YtszyVtCJE31mINnFbA+j69QDc5qXVwjzsSDtvdBiS8h0XBjVzlHXhTqXFROO6NnW+jvVL
	Ebm8jGZWTcqEjwuosSiMka7JjRoWZvU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758037949; a=rsa-sha256;
	cv=none;
	b=3vnbW+DrGtFEF+72Op/Hbb0BoUv1aDDzLfrMKESCVrtfgjEa7GBLv5QvYOC/4L04Ngcz7h
	MPxHMhYyYD0XelBKSBkf1EzUvdomWXFdp1CK1r2Tl4Hfgx5GNIBtPJUnQKl1a4kiRDaxb3
	or8h10iKXSolEz0o4TxfGc+0q9z5TIE=
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76C69C012C;
	Tue, 16 Sep 2025 15:52:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id DBCCB20028;
	Tue, 16 Sep 2025 15:52:18 +0000 (UTC)
Date: Tue, 16 Sep 2025 11:52:20 -0400
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
Message-ID: <20250916115220.4a90c745@batman.local.home>
In-Reply-To: <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
	<20250915194158.472edea5@gandalf.local.home>
	<CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+kM4JL2HuW3j1rMjDU+rkD+Z61vYxnluI=
X-HE-Meta: U2FsdGVkX19km+vx1Nw4MwcIQthEUwC8H0Wt6kTx/baNVVGl8r2XGU4DxKRou7Uph/fciUgP4mcn20MxlcPUwB09x9cscmjabG8HOjm/TLpPLYcCGAle/Iw7MOKi3Lu2GGiJkB3FwL4S+6HhQEW6+LjVqhb5aZ2EPVErSYilPj9pQfOzyDA5+f20FTl3jO+CprUVjkc0a/xVE+9rZMbTtyUE5uZPO/QZ+kRWOthubie3Hz0tF/NThrRH/gfSFkcVdbV8VjAzIHal65+rIFJjzr56ME43hlsU2/lPq1FLyz6Qai8yuprzGJ9qZ3f4wPCHMYK1+ZMKL97QJCHscskViXrNjc9Qpu8t
X-Rspamd-Queue-Id: C5948C0006
X-HE-Tag-Orig: 1758037938-962884
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 56md3infxwgqeb9ibn7k5p7hb5zi8z6u
X-HE-Tag: 1758037949-139653
X-HE-Meta: U2FsdGVkX198s6U3uxL3lQZg8OkzaVl8xbrUdYmzNd2zHsYk+yaLxp0M+GGC6fnBsOmV71mFlJZHqPsG8vbQN1aKL5neUda79CxXfFzCW/QeeRXorpyMdPSeVBTDmJzTYaqUfmmRwF+f43JI1MddUrMshvHTyH9qukL/0heH56GazyD60WU7FyclFm7fSuy1afPVbbxFLkGqhWv/Q9YW0GPRTEHVPEdHYpmmb1CYTK/mp3vKDv6XJR30s20O+a8VlZ30/0A1NoD71YexQAoDeh4W4KEeiIMaIPVAmm8EQYCICYLJUNLx/sY0aFlAySXEuhsgDZAXKJuAhg4m/VZGZjmMpS5t1+zdWLfVHZVj7wWzea7nyA605qVhF75qtP+lszXWwu9cu43Z3rKzZwBsd9wev6751QPdoSrz1MKt5wSYYhWVoXd1It0lwP+BoctJZDbzkeoffaIyauNW8PCaTBWRxz9H6Q6mvQDoGZ9RGAcsBXBbFaodvjmcxYjRqTHeYqe/rRdeCRINL2QIAmmQWlvlQX7uMdmPfrJWVhsCgLL6K4Ffq0EtPp/NhBIDETUsNBQPtbw4qTdFERPLuifuzP8XpYalsRtzurZ6PUB/G2PJzLXMLoA1pdFl9O4+rFB9Qc+yc7VBcjiJMEKpk5ug+dpSXeyamZOLADMeRMTa46aH/pt+wp9TwRjbiIrOZ0pYShzjsrr2l0m/lG51lglmK0eOP1oYCtYg3NyARBejspaMaIVdvEKWP/ccZxuJ3MW6Sosnip83d+sH8qg70fhrKLWjGN7u+qAJMIziOrTzxHvYre4lC/wPBON+0FdAO5PDrBrgKvW6aiGR1eUQjzuyS7Mv/yVboq06k3gMNATJJJzpEGJBSrOfEEziFXRw5eF2nZywJ+GdAwwYxhIaaFPDE36atzK1sNkHld2WqTo2uzErzuIaPGLzhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 18:19:53 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:


> Hi Steve,
> 
> Thanks for the comments and suggestion you are right we can use bpf to
> get the comm. There is nothing special about this trace event.  I will
> drop comm in the next revision.
> 
> The reason I did the task_struct parameter (current): I believe there
> is a limitation that we must  specify at least 1 parameter to the
> TRACE_EVENT()  PROTO and ARGS macros.

OK, then this is another issue. We don't want tracepoint "markers".
Each tracepoint can take up to 5K in memory due to the code it
generates and the meta data to control it.

For something like that, we highly recommend dynamic probes (fprobes,
kprobes, etc).

The only purpose of a static tracepoint is to get data within a
function that is too difficult to get via a probe. It should never be
used as a trigger where its purpose is "we hit this path".

-- Steve

