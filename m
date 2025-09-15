Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743E3CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52188E0008; Mon, 15 Sep 2025 18:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29DA8E0001; Mon, 15 Sep 2025 18:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66D98E0008; Mon, 15 Sep 2025 18:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6FA08E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:34:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F2E716077D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:34:07 +0000 (UTC)
X-FDA: 83892938934.20.37EFAB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94006140002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:34:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rh6tW0PI;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757975645; a=rsa-sha256;
	cv=none;
	b=kBJgqSxFYoVgZmU+QEma7uYBgz3Qi6b68MAdAnUo30KFh44kb2BjIwKxQ3nculkNbqC8Px
	x28ohAA4u0PddZTWUwI8nZjuNob7OBqhrc5t7WqaDTcj84vR+pWz2NO0HkTIQCqChvrLgA
	ZlH9+bLI6K6h/f3Sr/5fwJ1H8WmEjns=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Rh6tW0PI;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757975645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wQ+1wl/LkgElSlkrOY+ZM30a68u6YqZZltlat84xTk=;
	b=0JTdhADoSplFbiHL1DCyzR5rmho8JW3onwVyvKrtTshgl30ko9rohyEDIEX9ql+TCsCrnl
	M+D1yCkSWrjqYpduOevBsXJ1VzHL3xFdHhSPtEkznzJ2/tdVC7LjOLjqBycLRp3Ov68BXP
	KwylLeETKZfr/AtMF9sjdlhXpnzNF8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76474600AC;
	Mon, 15 Sep 2025 22:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95992C4CEF1;
	Mon, 15 Sep 2025 22:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757975644;
	bh=Stv7c8b21tAoRvHnLcswUUt7FKb98hyMbg/pjdBteec=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Rh6tW0PI2bUr3YphPyaqLZMRahxrmrHJA4vmKG+cCDGnzQ5wdpxsjt30Ofyx7EOra
	 XgccpGxXANJbzL3iUnHWy/wFP9bY80F8jPHHo3GMadzGP1bbBbS17S2C0iXHWDfbIC
	 q+8BTw/8ahYs5HQFL/4BC19smyPMw5+optpIBBE8=
Date: Mon, 15 Sep 2025 15:34:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
 kernel-team@android.com, android-mm@google.com, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-Id: <20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94006140002
X-Stat-Signature: xjc71dsea8fid4upktjzwcyo3qzuw571
X-Rspam-User: 
X-HE-Tag: 1757975645-812605
X-HE-Meta: U2FsdGVkX193w/7eq/APxb3lO2LuEhEV9AaxyfWmQ3BOeNebWGQp7q2o4xxQWpx3DLPtymedtYbU59sPjCfNL41wDbzZN2sJigslh0dREB4nQ6PF0gabhEkWdRaDJEEHGhCycGQfHU0HyMnmyGDbVTSfrUegR6a0wj3j1WLmWBFWCEyesYCRu0renhu7LOrY9KkI7SjY8IEJlZ2FTHphuBNlki9j/UdN6J0xTN9ucKvxlovGHha/JZh6Y/0sVCnsuHjIgtt/q9nT7GD3EMsu+eZgc8pyZE5vWWy8cJ56zQ5TyoQHy+G84AEqFPH9hsCoLN3SXoikX9rO4I8zHQSQZVm1Ry3IQo/utsFvg8ZqdjgwZsn0NrY1mkgdoi1jg8Drkrx83LjAqqSEJ5SwFl82iHkJxYrydyj5OaUeO4XaP9DzDo4/M72cAoPRJV7e6WuWRvG+q1Xg+98423lBbqPeS79uhFPiMWSpAYLao1VGreml8omEBElBn/VoMzEoqszxXSg5hYwtNqNKj0Sacc5Hhb0SMDRrIKkkeODjHuULzHHlkEk7hybCDxSboUTGlttMNW9TtM9CxQSI7+xAIbsr3ePz3O0IzYX6R1w9HrZi0nGlw6+6hkjM9s0CPr5Pa7yc7+8QHAXVIil9lc8qjJmtKJoeHXBOpUc5k8FFUzkRKFWArdC9epAZNqf7BzVwRGydXALgbm+EMLvYQ0xp34RTGezxu9NjasBNO2SSfA9nPKuIgbnA7hLAGU9PjaxfqVC5QL5Z+QVHg1srctHa/PxYR+vRxujKqOV7iNxqaV7XEKjG8DRZgIpoOYbnHFnHxKDCTaOciyD1WmXVfu+5IBQatQWYP5k4Q6KpA6RARxSdX4sLzbEPSFDwt0Uw25CGqiBHpT9SO13UfckOfP5UGmvGWwnTjDQ5aIndOn64L9LlruT28xUP8hRAGRPoLigm6qILcwfcqPSsqAmwrLQ41jj
 IYHCb97P
 RPMq2BwUzR0BpwsV3/rbMFiGYGuF4KmGkg/y1eDFImvKZek0tIgEStRXKZTtsrQzGHtOjRYS5EeeI4QlrbAksKZGzX/W7vKt2VYd10n9q1ofGD+XR6YnSD++auIXV/NfaN3h+6TWE5lq4cYSpBYG6sOtBDQq/m/QAfYMxWUGoFi1sB/mmTrv8KXKZ17KQMuhn/JOZ+F1nOTOrUHjVAQNODv3yBnSXJgd3O/X85bUiHTbazUuaODjr3MNZ/DzfLG/oVqS5rZDHKZPgL4TJbRTcmlZuoHMyFqDzc1JQBEsUTCz31d0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 09:36:31 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:

> Hi all,
> 
> This is v2 to the VMA count patch I previously posted at:
> 
> https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.com/
> 
> 
> I've split it into multiple patches to address the feedback.
> 
> The main changes in v2 are:
> 
> - Use a capacity-based check for VMA count limit, per Lorenzo.
> - Rename map_count to vma_count, per David.
> - Add assertions for exceeding the limit, per Pedro.
> - Add tests for max_vma_count, per Liam.
> - Emit a trace event for failure due to insufficient capacity for
>   observability
> 
> Tested on x86_64 and arm64:
> 
> - Build test:
>     - allyesconfig for rename
> 
> - Selftests:
>       cd tools/testing/selftests/mm && \
>           make && \
>           ./run_vmtests.sh -t max_vma_count
> 
>        (With trace_max_vma_count_exceeded enabled)
> 
> - vma tests:
>       cd tools/testing/vma && \
>           make && \
> 	  ./vma

fwiw, there's nothing in the above which is usable in a [0/N] overview.

While useful, the "what changed since the previous version" info isn't
a suitable thing to carry in the permanent kernel record - it's
short-term treansient stuff, not helpful to someone who is looking at
the patchset in 2029.  

Similarly, the "how it was tested" material is also useful, but it
becomes irrelevant as soon as the code hits linux-next and mainline.


Anyhow, this -rc cycle has been quite the firehose in MM and I'm
feeling a need to slow things down for additional stabilization and so
people hopefully get additional bandwidth to digest the material we've
added this far.  So I think I'll just cherrypick [1/7] for now.  A
great flood of positive review activity would probably make me revisit
that ;)


