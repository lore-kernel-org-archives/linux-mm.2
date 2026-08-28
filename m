Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123C9C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 14:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11F846B0096; Fri, 28 Aug 2026 10:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0016B0098; Fri, 28 Aug 2026 10:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F273D6B0099; Fri, 28 Aug 2026 10:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE7106B0096
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:32:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5ED051403D0
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:32:53 +0000 (UTC)
X-FDA: 85150919826.11.7BA5480
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7B759140017
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:32:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787927571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txgaP3eXPwGHZiNk+kzD9nMiqpi6Z8kpuswwMKDKk10=;
	b=V8pYFXdVTGSqDhXW/UnjNmlJDtenTC925VCyrK06mKuwqzzNLFr6q26u9zTfIE15vz0eag
	dDxsbY7guD5bjazBuTN//6IbxmMUFEzEglv2f9c4puKZOP79E3x+Ba8MHClzAqh3GVBBKq
	SXK8hA9ERI/m5nye735QYYm4/0UufwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787927571;
	b=boZCOvwDTDToQnw9+xjWW70z+kNpLWstdOdcKfE5Cdz+v3+0PUDSkiQOGNiDq9cY+2Xilc
	wAzqQWMtoooriS01fWKkRWgMyd9Hy2EiY+ZlkF7PnsxP2pl45n0vrydZ0vr63DmDx6OD8V
	IlcTuhSi19ehA+764xEOaAIFSg+X52w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
Received: from omf08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56281A03CB;
	Fri, 28 Aug 2026 14:32:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf08.hostedemail.com (Postfix) with ESMTPA id 68DD520027;
	Fri, 28 Aug 2026 14:32:38 +0000 (UTC)
Date: Fri, 28 Aug 2026 10:33:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Stevens <stevensd@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, K Prateek
 Nayak <kprateek.nayak@amd.com>, Uladzislau Rezki <urezki@gmail.com>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 suleiman@google.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, jstultz@google.com
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
Message-ID: <20260828103328.633bbfbc@gandalf.local.home>
In-Reply-To: <20260828124758.GP687043@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
	<20260828124758.GP687043@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/SjYl3uwJx4/ioiGGgwrjcuLujqecRKpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=txgaP3eXPwGHZiNk+kzD9nMiqpi6Z8kpuswwMKDKk10=; b=PTsDfFpy3Vn67qp+64dLKVjQMOectY5i18n4Kp3f0JbzDuDbg7QuhtcfWz3fQ0TXyhJjaIW8ExLbYtONSHMQyC1lyZxg1V6i+rr5HmbeaXTfnqg0mSKpLe1M7Xz4Ctw9aeW54P5Vi/KVRNyogahr68RbAAuK75JA7ttYZ7ZvTJg=
X-HE-Meta: U2FsdGVkX1/ynCiK2eODLPrYZ9tK1G7fze2omD18GRMu+p//Za8+4H8RGGJDHLXLBjpOVe3LkBV8eMOFg5z3gwtX0OJ59kPUZ1lXGuPE1Jngey2WvrHtD2Ios5dJmmCOW6/JzjEJjZR90rWu8s+8+rGI/f3PjKGR+amq7feErZbTZBZRK1a0gZQoVjeHxPsRe1WHdO9gAWNFsSVvOHPGAZ3BLjjMhQSGqs6mMT5JrzNV9F/rZcZ43kHOPupCbE6Oeze20thPJ6wIJ05cvfQ3P1S19nukkkme0//ZjrjG06nJBIEqqfBqKclCyd8maOH2IMWUNDJmDCxPXN7KuEq4eel3RCvHJX/rMXNPrmNloIAPLi5whsjRBjeIKs43ysEB
X-Stat-Signature: ztkfmnrpgu49shqhx5dux69fx5guyh4n
X-Rspamd-Queue-Id: 7B759140017
X-HE-Tag-Orig: 1787927558-448627
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787927571-773903
X-HE-Meta: U2FsdGVkX1+CWYl+RzKzbO91AyaXAnbgMSJaWs/v5HDQRiZxkLoBDAHFbX/LE0bCpwQfP9UiNtxGjip2+csP3k9N+fas1/P4ONobQxgvu3i/xOA3Ko9e/B0VwK3IDs1HvKSjp33JgSkiX/v342qAimOZ+JbWoBhFh6vyLBQTdi5gkLQP/2S3Gkb7QClxFuYX0w6EpnEA8F/uR04GPN7vUlzOWzLI+CqDMJSIjOqwJnwuMwYTfLVWWgNTMOpkAzDvIKvwObCaOUgIExx+Uvai1TxWf6rnm4aGlJNT+NpJ/gyxk8kF4bg4e42fMk6oJWUgPUaQvJTI+Ei7X8yGiI7y4uukXUmkAK5fcaAujt8UngT65jGq64RdCz0tLDquGWUaNk4/RqSkSwxIANc7MPDcSbPoyToVsd3ef87SaGx8aVQF6fv3PPY48k0icX9xLt0E6lvF47tmAkmwgrxT0yQWQbd3n0op1Da5EJPV2bOg/rWleq9YMQi2qfuTqnYB5GQjpTf7V+MgyxuIcw12UCUfsJepedcJ9ruD1Jl0o+fABwCGq3PGQO9U98cigmTLqF1ofTeqwfUmfU30KJNQ3u50aIsBNlE7bGyw/D+MgPss4kKjMeVHpv2QXQj5v4jSGMxPCPfg4DvUfvocMZBxWYLwGIFPJydIuTFqjPItex5MbMZ1GPm54V3cjT7HvSrDvBefxp8jVq03FpmutNgN4V7kBP6UWk/bK6Tw9nZtplPpiJHvyhnkenAZ7+FnQs1dJWaFkMtIHMJ2cWmswlKqKdgl+iU6b1m027CUkBdLWaNKn66R4KqvJ/J4+06wFbfCnMLUuuZHQK+FHtCNDMIbccO0BKqUFkD7UCJhlxw6/u/kuTw74KY+hocLrVtkcd9fwmS/v5EORAG2nDJbvm/AkZ/M4oFMolVkF2R6wM640lGW342iPV6v3J8EGaJwskOZ1v6XFjnh2h1mGQrvj2FThHq
 anivsi59
 A4o6nup9DjzsJ6iPitXmNdbUumd4mMcIoy+njYu4t7KEJ4g/wXbAW2yIf/yetikA/GOktD2RZj2K7nxINhq8LQtcbH2BhK3ytqgkng7olpaztK/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 14:47:58 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> > On Android, system processes typically have 2000-3000 threads. App
> > processes add 1000s more threads on top of this.  
> 
> WTF ?!? Why does that all spawn *that* many threads? Perhaps work on
> reducing that some?

I guess you never ran Java ;-)

-- Steve

