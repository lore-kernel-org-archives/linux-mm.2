Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310E5CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FD58E014A; Thu, 18 Sep 2025 10:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827BC8E013A; Thu, 18 Sep 2025 10:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764C88E014A; Thu, 18 Sep 2025 10:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6483A8E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:47:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D137139CEA
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:05 +0000 (UTC)
X-FDA: 83902648410.22.03CB4DB
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3BB9240013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:47:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pe7J2FyGs/B6Fm4TGUr7vhsLhuL2p5cZ6KJdOdhnZpo=;
	b=JiOcbV2qfLiiJeIK4Ls+GBH7wwY2Dbo9pY1kaCSLiFnonidvpS75EBHC6nld+PCU/1FpUB
	lUGJwsa2PQ8l3DObgTlFnMLBNQDztvsAQWGysm1S2NaV2MF4wb7rWOclCrwmCYOKakzoQK
	HClePn+LuYYW5OeSOPU6bk/GLhDOWmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206823; a=rsa-sha256;
	cv=none;
	b=TnvrCNGwv1hzfH57qIRdyClXWaC37bZVWabPBgI8ZmJ48F58FbqG16jJEdif67VP9b3Upy
	ng5rTrWgoWQs5kT2PUjiMU/qAU6y56+581iF2+t0OoJqdGLeuUvGcI+8aR6i/Y1EpegGaX
	rdmiyxK36OxgxXCAj9GGCIgrJzKzMTA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0F07C01D8;
	Thu, 18 Sep 2025 14:46:59 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 64C5F20026;
	Thu, 18 Sep 2025 14:46:52 +0000 (UTC)
Date: Thu, 18 Sep 2025 10:48:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, kernel-team@android.com,
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
Message-ID: <20250918104800.18682dcb@gandalf.local.home>
In-Reply-To: <6x64jf7szyy52gug6qoixhhjq6vsrcqpozqj4ambsehh2jprj2@qeye6qevem4g>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-8-kaleshsingh@google.com>
	<20250915194158.472edea5@gandalf.local.home>
	<CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
	<20250916115220.4a90c745@batman.local.home>
	<6x64jf7szyy52gug6qoixhhjq6vsrcqpozqj4ambsehh2jprj2@qeye6qevem4g>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/SPmSGyI4YAHSVF4EBeZrT9fbg8i0D60w=
X-HE-Meta: U2FsdGVkX18tsNvH9bJDAyFjkOT2HA8ufoSMnckqu/PF/TMziwSBt6ub3HcDiaqCsBki4oHrVzGzWJgZN2TMafKiXzJFbwxNCtcijv/2L7usqvNreFB5cSMdaUx+V14enzYHmfTtY0OvIOF0Vg0J0H/94xSJuSaXEO3o9ykMJ9ZLZMPvBdMDl5Ws5yhHI1hjp0jHnj2XG/BfWP9WMn0eexomyP+td/1fW9VFhOT1kcCBFbRB7Afnn3ByETKi3Xwoxn8m29j0Wlt7indu64ikhql9bauxeS3wdvSqX0FmZNfQAUSyAjpZi3dQYT+/3fmf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BB9240013
X-Stat-Signature: g59kxcztn1r7jr5dm8ogyzri6gb4wph7
X-HE-Tag-Orig: 1758206812-260855
X-Rspam-User: 
X-HE-Tag: 1758206823-829158
X-HE-Meta: U2FsdGVkX1+fF1xFvV/o8ESUyA/HtFpHRcNj4Qq6CCkRpQJJpdRazSA8I7NQW7xhCIBvcEiROLe1ow0kyVEECKsRd+roM0kA1O3ujSO/YL/hV3E/fC6eHXPBriWw8+ON1nPANZ71pwwKfZc8CP5JZuTZGfjjhUBmewoJfo3iBYGMdALa2B3FW74GdI0rLmPZ0EcABlYqxyRqgopaqC5vMEQ0DfSyyYBRADBRbcMiqgEnvyjxBUOsuvw7mgC6hslgCN/LkMgMSqLhSPxPwl+sK3byZ8uVWpDc89p5/ZrhUzXXfMxEPSympF0lvtxJ1MH2efmeQNpAIEOMtpDICCvUEWWALLg3ojZvHKi+YiC8uMjj6lADOZ0pgUdoY7GSHZBBtxXtvx378/IVEuclM2PyKMVoKDzwhCBb/Ws3boaf+9ilBdXSKy+TVBafO8kLZyfIqAZLAYgKASTb73spcG3+6E2lLNraTiBwBGHlfwJRKVVsfsZpbu2WhNa33td1uVeB0FP5nVBqynCMUvw47gkw0lVMK2OGX9z6xVAiR+/kBa8DTPsxq7oZleNqmLhhvzo30QLBYbVi62lj2z/IVXcqc2RkC9jbB8ulH5Ft7TzNWb6EWBBbWtlaDHi0gLkIgMe591ql8WOUHO10nPpnZyiLPOyFQgtXeUx7EAOTjmRuwp+gkZTltxAJYuzpzWKKU9QyDQz3VLS/jv9DxTNAGpw/b4VClBIqxWTqbc6yyywAOfj3lx8n5p6DmohEUjFt7GKwBqCVs3lWMllWTorvERtezG2eNKxaVoMq4ZZsVyD30d2iCI0qeYjY/66pTMB1FtWaYFK/FZYrWddLRZm6TA155EL01SR2sBVfWXh/cng9DiIqExDSTuuRHEgGiYAKYdZrfYBMiSnL4ahtsRPJuH1JDsg9SkQnMpGD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 12:38:56 +0100
Pedro Falcato <pfalcato@suse.de> wrote:

> Isn't the usual problem with that approach, that of static functions/static
> inline functions? I was tracing through a problem a few months ago, and man
> I really did think "wouldn't it be nice to have a tracepoint instead of fishing
> around for kprobe spots".
> 
> Not that I particularly think a tracepoint is super worth it in this case, but,
> y'know.

Yes, it would be useful. The issue is that tracepoints are not free. They
do increase the I$ hit and take up memory.

If you're going to inject a tracepoint somewhere, at least extract some
useful information from that spot. If you can't think of anything to track,
then it's not worth a tracepoint.

If one really wants a way to track something, they could add a static
branch that would call a function when enabled that could be traced. They
would also need a way to enable that static branch.

-- Steve

