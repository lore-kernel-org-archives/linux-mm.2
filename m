Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E12C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101C06B008C; Sat, 29 Aug 2026 20:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BCF6B0092; Sat, 29 Aug 2026 20:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95006B0095; Sat, 29 Aug 2026 20:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2DF26B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:53:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 361308021E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:53:30 +0000 (UTC)
X-FDA: 85156112580.20.238ED99
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	by imf30.hostedemail.com (Postfix) with ESMTP id B565180004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:53:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gn1MZAVE;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788051208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gs5AUPZu6Qlf/aA/abYQxkyhmO3pqxhHWvQ5t5reXrM=;
	b=fP329Uq+jNPCAU6+MaLzucXNBmtntL4Y5IGvUYii7KRSv7LneM0eynOA+CaY+DasmTrQAv
	XKvFQRmU3cXY5Ux1IWDL+uAcPeqks1ln8NYYHdYnfUGoTKoaLi4I+GOHYC+e/EprShVUzK
	JiUSYeRad3h9vgLMiLxch2QxfXA5NZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788051208;
	b=0YDQZhdOoogDDAdzn9Fcw54BHfUijjFu6GsvZI5RhqF/yJ4c22FKmwARUgRtChEuY7mGon
	LuDgu9zdtKRnIzxTekULEECAaC12+mI7VQCtzr//UAkSvlR++nFNcZKb2T/ySJVH7+Fm8F
	HAhBAFttruNmEzYcJx9KcubDgPU66bg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gn1MZAVE;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fszXetNW+2890fJc/nTMASrc22mNEoZ8RTNdl5L3LRo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788051205; v=1; x=1788656005;
 b=Gn1MZAVEFDsEiZmnB/XwDduREr+NWTNJ0Da9MP88K4q3StgmO/LiYUjjheFq/fU1YWBeBwyS
 /9qmm3feoxocvd/M87c2yItvkn3O/s4MjqpNYDYiFVMU+qots2yC2dEc/F8z2lpaLZz+6q5NYlk
 yjYqQLsc9PZ+0RY8IxRrzBWo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 176b837cecade791;
	Sun, 30 Aug 2026 00:53:15 +0000
X-Mizu-Trace-ID: 176b837cecade791
X-Migadu-Flow: FLOW_OUT
Date: Sat, 29 Aug 2026 17:53:14 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Tao Cui <cui.tao@linux.dev>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <apN-zc_5SIEkdzB6@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
 <aoSLxSBUPbEqimJq@tiehlicka>
 <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
 <aoVUlFdZYLFn_gvJ@tiehlicka>
 <20260829174220.204771edba7c52511dc08641@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829174220.204771edba7c52511dc08641@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B565180004
X-Stat-Signature: gghzq3k3kta6csji9gmmtwsin7gcx4uf
X-HE-Tag: 1788051206-403286
X-HE-Meta: U2FsdGVkX1/lycNpkoiV6XDDpWwtS0x6B4HW5COVB8D5AM3pmZ8+V+OX93Ktw0YMynJiq6TpSvaeNf2fe8KjG07pRKFKfQSSQxf43Dj0iUlj1oK56M+d/2bT0NOtuiPS9RhWjAb7+gfh+OZ/VoSyCShHZjx8b4nkjsuUrsuIsxN8eGIPZXl4y6w0PHs06ovBgDgGWM7v8adnMMeSjzByD0IY3JmuftFfV0E3twVudz6NQmsvzjph8MbJZ77FIvtfqCupq164bNSeiaKA89/F+mDfcxSjKVnj8y0GYP2vddTwk8hbe6AE+BbXfQSmDktAPVZctpSH4JqDh9yUDy90n2otBjkWLwK+tMGEZUTgP3wi/2qfgzSxu58aRcupLiztBe/OjudPcLml9YHzheY3G3k+gHQhg4VhKbEZTx1Bs5q6d7IHJQcV42lqiP4xPqOgmes8gZp0LNL1G75G3G5zMm5IH7NyFnEI26CV8H7FKFVx/S1es3vNROfBcBc7tZ7BljEMeOayTpJDJ6HNfqhBkwrVPYpBZJ9qrpUpEY37w6WoHjXaZ7SRbSUlmFrK0Uf87xZWOarem4tgSrMInZ+u7BwRSmgBeLCPmma+ebI96iZCj5wc2oNFjIb7DRcBeqWbEIrJ2zON6cI/0Xlnc0ugYLkr9r9khLXCaLVwlC0YKtdch2tYN0R8UGvnCeccM0DrkeKAFp0s4PMGroL4Ua6S3Q/TTS87fZufzu4UAh05ggLX9oUWmJb8EwxZl6V38AZTdZhPyLu26mz62TThQstWUaf5G8+bby8bC2I6trUTI9YwVPT+iREonViEe4T+WaNp3ilCb0OiSWx1SCQsagmnZ5h8W/BEkGX8HN6TcGb/+pbvJImpnR6B0RgxHBAJxYXRDE9gT6lrtdBbxr3t6IX6VXOj8xkPmtY/lXaPpdW1MiOCD5qa5Hn0Mow+W6FI0vDFA/SE64tJR6177XVFWDh
 hNKuS3yk
 c8GHyhR7BqGlH8uHm2f23H6gorXnb+2zPMymKROQ2/TEBl2WDFT2vaGYJG2YtdxWXNO0Sh6yNzwO+xE5KcpeeI+0GPNvr6LIhpqpogsuA7VG47ug3YAKfk0bPshdLCyoAAyKozI2MJfFEgovXJFpwBWEfr+LVYnwHRAcx3sg7K+oqtKpwt+vX3oW3jv9tBo0Q+3a3a7e20Ih9ghtHBZQT4Tbq2eWfp1n90orhXF9Ltm/NiYgMbkFuDAH7ZytAHVVfJQS4cQAv7Sak90L/o0lTzS0JM4/3RZzpiJY1hugYd+ZG7WVqaSJJ0SyvRYJT+LWZco9T0uc07UHKaMkrPtCCktKmWdt1082THMaDbFKVv3M3eosqIvMtnvbhGNGUdS1sizLWWCFMdGNiOC8TXSb5TvixoE2heYy76TrMh3+ykosJDYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 05:42:20PM -0700, Andrew Morton wrote:
> On Wed, 19 Aug 2026 09:00:36 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Whether that benefit outweighs the compatibility risk is not mine to
> > > decide.
> > 
> > And I am still not convinced. I do understand your frustration from the
> > debugging the issue. In any way, if other maintainers decide this change
> > is worth I will not stand in the way.
> 
> Shakeel seems OK with it.  Other other maintainers are being aloof ;)
> 
> I'll queue it for now, along with a note that additional poking is
> needed.
> 
> A v2 would be nice, please.  Add details about that production incident
> and make the requested update to
> Documentation/admin-guide/cgroup-v2.rst.

V2 is already out and we decided to make it a documented behavior.

https://lore.kernel.org/20260826021753.197871-1-cui.tao@linux.dev

