Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87E3CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 22:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2D46B009E; Thu, 25 Jun 2026 18:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CC16B009F; Thu, 25 Jun 2026 18:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2656B00A0; Thu, 25 Jun 2026 18:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 225D86B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:50:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E8C14030B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:50:49 +0000 (UTC)
X-FDA: 84919931418.25.53FA622
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91DAB100007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:50:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mNBN0j7G;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782427847;
	b=kZw/RfBFI0cqgCPs1PW1hlRA+R01D0+e5PWI+2N5yHwO12wJ/EdXpwrRHEx7pqDz9c8fV3
	7r6jm5GaG/0Ekr6mfNSeL9ZN0EI9+ViACW9wIZ05Tk1VaHTBrGbw5yuS3vg5H6Nnk+kngZ
	DJu4t65hUM9Op3OoemMt0g0mNwOrZZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782427847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxugoFo5bqWGfuAQPpw10nJpdmlXTDTiQ5GmXQgQaLU=;
	b=rtlSpS5mQQscSIKxxVqdVawjAW7gdUSYEQIUVszn7glV78xc5pSNTAcPXQk0MVlqAIRLhX
	4gG789J0X40OZXsT/JSo/QuKggs6de2J1caPkfmyC8EgmzoWPRBp7iqez/TKAErayiQ+A+
	9K1hNUu5FAZ8/1WhfRCbBLPTt8rpDvA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mNBN0j7G;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A46940870;
	Thu, 25 Jun 2026 22:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190451F000E9;
	Thu, 25 Jun 2026 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782427846;
	bh=dxugoFo5bqWGfuAQPpw10nJpdmlXTDTiQ5GmXQgQaLU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mNBN0j7GgpctvyjQ2w5f06YNcCpyBHNU/r3g5vXcwPiMNl//R/ET/M9fG0Fjkx33u
	 2nYBBjFz1uqrRpWFg2M47qQerTeWwfuyFTo1qA1zaoASYMy+5e1RjrXVTNqku7lXwu
	 Ipu97B2gCfWaxtsESsQrF7qElwx+XkqOvebxDNRw=
Date: Thu, 25 Jun 2026 15:50:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
Message-Id: <20260625155045.b1e2262c552e5a5e0116f884@linux-foundation.org>
In-Reply-To: <fbe1e70b-2a33-4db0-b390-3841c1a84522@kernel.org>
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
	<DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
	<DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
	<DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
	<DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
	<fbe1e70b-2a33-4db0-b390-3841c1a84522@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91DAB100007
X-Rspam-User: 
X-Stat-Signature: 7xa91kb11oap3szk4q8rhf9who7tk4xe
X-HE-Tag: 1782427847-334638
X-HE-Meta: U2FsdGVkX1/8de1LcJgx0aGa+jgB+uUfiP/vrpk1I4HWOGLYlhBEhA4uh1Rv51yEXO0sunKYqNq+DeqnGfQ9HX45qEawfVkjnaCuHl6VaRZ3Qzexbvg4/Uel5GRl05WUpzrm1tr+/zkPHxzLXgCCA9qaIAu7AX2Mb6O7FmcEyblof7lf/Vj1E5XCNOWXNsK4CDUrrmbMiGvjE4CXXtV/cNn6/l2mEXwW2zpMdPXapPDPT+agzq0WqD9S7S1uQBHtWU4EghfwBmTdl9ZUtnCWh0jQefxkq6LkiRKwz6jAVWzrXckHqREuV6W5FLVDxf3pvkOKQ8dsLYMXD3kEb+IQWMAGAd1qtBRXZVMRFkEhKutKarpIyW3bW8H8beetoNRs2EXWaQpg0Bs6cfmKABvYLhVepTkqg5aP3Av37nHJWkEqtrQ9WV5LDtNYnFZPM1WyeT1sI/864DcJ+9jxjo5TterZF9gOsgYhQGRCnJOk10xbEpweNxS/6gELU1czhwkPL0GK0+yLh1kcWfhhTpuYIi6OJHhGwUrIb868ysNXgSX/KmucKArdCtAYhFUL+pe9taXLRB8f/H4/E5RKzmGyB5LRuZ4JA6Ys+hJrdy/5/hDg1UV+HVw79mJ2mHLC2LQBQSxr7EfC/CRz9rBJVLg9GxPsFXFqe5Gmp1XyTuPHqmK5fu/xd+TtEDjYi+vJl6FZJptaAmQFNRBk5V/8XEqXj8pvZ01PqVzHPg68zBi5xIOBC19m2ipSgC05EBK1F9g1yf7payKt8dG59aJZ1wugqOQvd9njSn0XooWTmHDzCjppknO/7JuU7mfJH9MN+CntInV3iPaupbGqm+sff5c77vrzGWyy6XFMZIZ54OXJX6kAzeyBFLa3Sa2mHJTYkQli+koJ7LHxxb2pbFHFUD+rBShAqqTtmYfg5SGT4E9m1fWpJBY6J+vs8pbKKgERJl2d0LUEBoBrGdwuBexTC3j
 HxqJO0ND
 G9IugV8DMhYJqmaSWZcXh6z8CBjUqdKDUAGadQJF1xz/kB6O0KKzpc8S83gzBLCVvit7+6FsDURhHHapo+QA/cJAc4sIj6/ne5WbYG4zOKzzMYQvXYPvBiC2Z8CKet+sX5qDXntjiu4B5JQOvQWto0ISti67lU7E96FY9WS8ErlelQg8rDVyauHnk0HqMhvCtudkeuF+k5tgR+qXIilii8VSb5H83Dr86YxSuwAocdC/UrU/8pBpgQz3sWtY80gOLus6FBjIRJw1PPze+Q+i893o259h+mr6cS7/IpeIb+UCPdaW5eVK6QJcxVKijgVn1kNyx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 16:53:41 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 6/19/26 14:34, Brendan Jackman wrote:
> > On Fri Jun 19, 2026 at 12:27 PM UTC, Zi Yan wrote:
> >> On Fri Jun 19, 2026 at 7:53 AM EDT, Brendan Jackman wrote:
> >>>
> >>> Hi Andrew,
> >>>
> >>> This one didn't make it into any of the latest mm-* branches, is
> >>> anything blocked here?
> >>
> >> It is in the quiet period, no patch will be picked up until -rc1 is
> >> out. If yours is not picked up then, feel free to resend it.
> > 
> > Ah, I thought mm-unstable didn't care about merge windows. It got
> > updated 2 days ago, but now I realise that's probably just coz Andrew
> > was updating mm-stable and then rebased onto it?
> > 
> > Thanks for clarifying.
> 
> We're targeting for mm-unstable to only have material that is already upstream
> at the end of the merge window.

What they all said ;)

Officially (and for good reasons) we aren't supposed to add new
material to linux-next until -rc1 is released.

mm.git has the mm-new branch which isn't included in linux-next so
after MM is all merged up I start working through the backlog which I
accumulated during quiet-time and merging some of it into mm-new.

Backlog was ~1700 emails this time.  Most of which gets skipped for
various reasons,

This particular patch looks nice to me.  Code is cleaner and the change
reduces page_alloc.o's .text (x86_64 defconfig) from 46571 to 46443,
which is a good sign.  So I'll add it, along with a "needs more review"
note.

Thanks.

