Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20975CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79BBA8E0006; Tue, 16 Sep 2025 13:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7735B8E0001; Tue, 16 Sep 2025 13:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0D68E0006; Tue, 16 Sep 2025 13:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5F78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:47:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08E7F1A02D4
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:47:42 +0000 (UTC)
X-FDA: 83895845964.05.01271F3
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 472E88000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:47:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758044860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Luzzkyt6Hnwy2sFnprSs3yb5dkNaDvgMVbJE/r2jec=;
	b=DWLJtF+v1yTSYFyBImlcAn1HZTzQum0rlXdgqG9AfpxIUHR4KolNPpaq82/Unp2IAVc2w3
	aXRPS7RtaoBbmWgIH/ZVNcYdilz535aRTSFFUNF5uLmxn4IjXkkKiQjIy+6GFItvwO+vbC
	HVCjxYnra5tzHIh5q2Icb3o7mJb6bGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758044860; a=rsa-sha256;
	cv=none;
	b=LfPg1TL7/I5QJa7f28s/ujzxlOECLESQzVHIQIJLhpvSBGJnGnK0wpQ38qp9YyfLYU9n4g
	0MAmZRQRyHmt8vYiYHYbcLn14bTjbABPfXNTJRkIzxrq6YXnl6U42Q9XTOBIPNa3T0qj4w
	BgVTKbsx+D/yLBvE9uPMueRzmldSJFk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F291160281;
	Tue, 16 Sep 2025 17:47:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id EA69C1B;
	Tue, 16 Sep 2025 17:47:29 +0000 (UTC)
Date: Tue, 16 Sep 2025 13:48:33 -0400
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
Message-ID: <20250916134833.281e7f8b@gandalf.local.home>
In-Reply-To: <CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
	<20250915194158.472edea5@gandalf.local.home>
	<CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
	<20250916115220.4a90c745@batman.local.home>
	<CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19fYVEo+TQfqoFVoPY0drWwFJ5ox6HfaHo=
X-HE-Meta: U2FsdGVkX18pAhXbWHugGNFQkb4HsbkpHA3LSK9XLE+vsmwTM7qPsZjE2Q1AkokCaSSM3kECB5AtJoNuafNVa4c24DllJqRZBRvH3Zmhy5wNh7TxTIkWD37LWX+bmFtCcebRBnxRuw3/k7vvz39wmpkcHu/7IwevVpAu7R0GogngimDsXGbeq53gsFUSv11MEKrEXvPbk4fw2Y+CyjjJq7TcrXucdUHUeHf7eiqw5uLSPBWimQmNj30QjsGtyMec/D0hb09wfSYgY56Wz5pEFnLq6GYNKSiHSG5mPzJ0+9udgkbbXo4zTaOyLKWUXBfDcE7VEMWXx80P+tQi6apDTcgD1TYy32eR2VKzLPG+ZszbApg+pHDZug==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 472E88000A
X-Stat-Signature: 5uqotgt5cqbtb693tzenck8fsp784zbq
X-HE-Tag-Orig: 1758044849-648048
X-Rspam-User: 
X-HE-Tag: 1758044860-297276
X-HE-Meta: U2FsdGVkX18q+IXjAE2ZfotHUQ8MSvBGrYDJ+5Ozcmeg8RBG2yzvxN9NGmnfcUAvnFZOnfgwenlkjgI1FnSqVLJKTmgfkGNSvnRMZz4xLrUpCaYQLg6g9sk6r3b3XAc8iNus5Dtn0/kDOGqwOGzZwpi+wjaojpL0Kke3Jjl12HgafA+d/dV6zG6TOb7VojJe8K4Li60brCuAKVAQyhoLUCF+R1d0VtC2a8xuvXihMsz5RGycRoj4BnVAxeJ1X9t0aP94bMB6p13saRyvd5pdWFEGRdZ7e39LTnHRPW38RQdCnlmJ1QEpQmuQMCWxGMzOy8VQwKeOPBBLtoGzK+KyHMeGPpzI0U5Iu73MJ1FbL43ITpS2+odah3nWt2VPAXuN3kSDbZFmh8qSSMvYj/5qm3FEdjjlPWX8dTmDD4fNBwZP5YL6LzrLJ7HMepX6u0uj1X74ocZl55UvBJv0Rs0Ir3dPc6r0sSrVD4z87+IbwDW6Onm97dD6bG4NyeeOjHoAx1LLeKL5HdubuhgEAbN9QqfTXfvdk1Vjq9gHHm/Tl7q1+BeBgOFiwiBZQtrqxwByUSdYVEXHwjlRmPAoCUqaAT3gGEEZArjvvKh271aWPhRs7NyxncPgUpgfXATSwymRjEs8YKZKrmWFQt15Ac0FBfi4YewOFo0fOlHfH3Z/ictsaYsf/SNisC6RVbg56879tFVDZDQRquo3t6XaT3MtcNVli0YIsPOJbN11vM3tAkDt9zG5V5SRZBDcVdzXNEe2o4XiMNjD/yXRc4SwD3xGJHyjg2OxVzP+UP7odrmllgqtBKIxbEelYEajjX4GoL9JkmiO93rypMLq30xNLuRI/wgXb2PrZCvooofU+dtvnwUMTNr5abE4ip0ylmJ8d9u+2My6/4ZwA8fvKtrDoViS1huWIXZCDsDaXOPjlEUmP2XpIWIwTqwSKsQZSe3pcUJohft6KbtKb9vv+ZDF7jz
 D6yeQVXj
 KcSNMMT7PHIu8vSacfPM86li24z53mJMZBOYH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 10:36:57 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:

> I completely agree with the principle that static tracepoints
> shouldn't be used as markers if a dynamic probe will suffice. The
> intent here is to avoid introducing overhead in the common case to
> avoid regressing mmap, munmap, and other syscall latencies; while
> still providing observability for the max vma_count exceeded failure
> condition.
> 
> The original centralized check (before previous review rounds) was
> indeed in a dedicated function, exceeds_max_map_count(), where a
> kprobe/fprobe could have been easily attached without impacting the
> common path. This was changed due to previous review feedback to the
> capacity based vma_count_remaining() which necessitated the check to
> be done externally by the callers:
> 
> https://lore.kernel.org/r/20250903232437.1454293-1-kaleshsingh@google.com/
> 
> Would you be ok with something like:
> 
> trace_max_vma_count_exceeded(mm);
> 
> TP_STRUCT__entry(
> __field(unsigned int, mm_id)
> __field(unsigned int vma_count)
> )
> 
> mm_id would be the hash of the mm_struct ptr similar to rss_stat and
> the vma_count is the current vma count (some syscalls have different
> requirements on the capacity remaining: mremap requires 6 available
> slots, other syscalls require 1).
> 

BTW, why the hash of the mm pointer and not the pointer itself? We save
pointers in lots of places, and if it is the pointer, you could use an
eprobe to attache to the trace event to dereference its fields.

-- Steve

