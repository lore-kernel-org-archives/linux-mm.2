Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E95C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992626B00B1; Mon, 29 Jun 2026 10:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969F16B0118; Mon, 29 Jun 2026 10:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D236B0119; Mon, 29 Jun 2026 10:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F99B6B0118
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:52:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDF361C0AB9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:52:49 +0000 (UTC)
X-FDA: 84933242058.30.8B06D57
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70BA9C000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:52:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="dK4IOP/K";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744768;
	b=SBFCHw0doNGZqyswubVWyZGkXCLuW09vRc61pSmtwbg3EXw1M/Q2pjipAGAmHqW5vAnywi
	JbcQhWzsPaYpLszkS2YxtaQ5HW3s+KBpluFeJ2aYTe5lQRsj83fYAt7LCabhImdx/YTCKw
	0c9bb6+e1IT4vIA2W46dFXjHPjQXJ6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwYRkjNitWaWf/u5dgSEWkgJNU+anMwoiUn3RtlC/o8=;
	b=JgmYwuPJ2yXNBnSzX6p81Fe4BH9YK5z+AdGKBVSdW1L9gx/4iWgpDRy47yuRaMr4JWIgDb
	g/kMq5df+0//uCpUgqAo0H7puELFVlmLy5wqQZUoOdEOyG4Bj++7L1Lac/usAd2rt0VZIb
	t/L3cVvPaJkMSUcw4ISc6BhRyPkm8So=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b="dK4IOP/K";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf22.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65TEq8ww461421
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 29 Jun 2026 07:52:09 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65TEq8ww461421
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782744730;
	bh=KwYRkjNitWaWf/u5dgSEWkgJNU+anMwoiUn3RtlC/o8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=dK4IOP/KT91qfq5gAJIymtQhJ+E7dYNwkOpkGSFgllbgcpqTc3JKX058I2Bc1mJGT
	 5BLtdRaLkOf7Z9bsdCGW+kuvm8/df5mlJJN/MZoc27YJbOHTNLPekPQf5MgJbsy8Xn
	 U8JamV7JSNRvHsgOOrzydpa6ETrcW9OhWT93JyTS0BqVIxeeHrzGCt0uAlI+9VRGqQ
	 ExcTM9VnV+hQQqnh3KHSNZaLRtr6+v1U5EwkwdwG+HkZmdV4IbOoNWndzyJ2nKsGCH
	 oJ9iThzxy2YtJqCu0vqpdiDH88e/i4pFmGomxB7lRXrbqarENlhjcjPV4KNtXOCcHO
	 gBaTKM+bA/uEA==
Date: Mon, 29 Jun 2026 07:52:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Thomas Gleixner <tglx@kernel.org>, David Stevens <stevensd@google.com>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_12/13=5D_x86=3A_Add_suppor?=
 =?US-ASCII?Q?t_for_dynamic_kernel_stacks_via_FRED?=
User-Agent: K-9 Mail for Android
In-Reply-To: <878q7xspqu.ffs@fw13>
References: <20260424191456.2679717-1-stevensd@google.com> <20260424191456.2679717-13-stevensd@google.com> <87zf0hgc3r.ffs@fw13> <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com> <87ldbyhatz.ffs@fw13> <888C322E-BF59-4C72-BFD2-2E71FD8605C0@zytor.com> <878q7xspqu.ffs@fw13>
Message-ID: <7D930EA3-54D1-41CD-B547-8A2A69F89142@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70BA9C000B
X-Rspam-User: 
X-Stat-Signature: pcffncd7gw3se3hpuoo4ounh1rd3y55o
X-HE-Tag: 1782744767-619539
X-HE-Meta: U2FsdGVkX1/xJITaaXiZyjSse+Ga54ZOfeg8K1Bp3u9iszTdFcEZJNUmu1Y+KBZMINFfYe6IViu08iDJSTsNl4kdvYePIs5SCTQ/rSCKYwV9gdmKCrODML/RqMg6oswZGG0fxI59DnKQbL3jyCECQlqU5ZW8jfAzNUTtegUiHH/d6VdG0KIJzyQ+8pOSmGcvyJJxQ+hvIha8TWbr/htxUYgFJUinTi8rf2qvjEQMqrNheGSu3LJPcIBrsseTIaE8o+g3hqpPtzosH/JWadohXzz7s0gV+Fs777eUleMEkuEAfaGtQ1iiuPvXIngpfmVENpRJCIH/aqmuGcZU1mDWNf9mOpT/D0OafcYtOKWJd8sj4FYJtjlFVi0grq+pZoRBCgCPfB6DRaTN0AHSU+nWDiV5h4ct9I1gd1p9OCiLNa2xz4fQj7m7kHeCWC7pZ7N+epQ2wE6sfEFjONLfeRGGdZ49uLpQh84HVdSKrHrxpf689NtsEEGD0FwaC+CpJ/0i0zVDSG2h+SVwuWkDtpMa5zeOcbkVXlSZvnySPUbh/a9uHTbsHsWPCiBEF4QIr7t0C5ch2kNTGIkXQ3raBT42ng+YVbifiJm3uI+X8s1KGUOGcLLratM1XEx+Ml0f8kB735WWLp2rFhsWpHz1eU4lRWfLMlb3a40UC6CAaRe+fUWQJjxWaNQ6wpddiOK1ORiLn23kCf77L4ntMx/z1nbNB2wPJk9pkHioWoohrY7R0PtJX+JdFyJWZ/utJPUzW7BhV/NhUoXZTrhJg7TxNYKyR/ItUgMxlj99uB5/+tNfwj5J2/egQyCyyGfUFfKcoMxD6WfF0waFE7fjGljG5teNW0mB8KSyUxb//wkvxzRY3yh4ldJhzo3093lmvuh/O9F5WjONCxcJcbSP9/fMrZwhXQ+YV1jSBoHjRNx/pa8Tide08gRkP7vsQokJSAap4yinGn3p7yX1LiN+EmEJ2WB
 3rZckxzw
 0rq+IxerSzctrGqn0Ie8YAykVTgz9X/FZOg1tPAYB4mAFyZ/326yHugGOU/0JeFEjal0TrnXJklX1zQt8AE6DiAVYJr4MRWzHqElfDCW4JED56j1MS4zb+pS2b+roIz3pN8r/BYLpo9Nm6Gt20SDBOqphi2Oaoj/39C1hzSKNVolC0YUFNjfHPWJv+1is75broXVXP50keO9vrzWR3ZX5IV6BcUblhfW9QWGYTP8mLfOa+WXSlMHJ9ZbZQ9JrYtFJdHN45acXudXM+fkmee/NTCLHMTbmDw2CFAEDJCm08QPbiKm32K4tC9xam4TTybDEeffY69xogHLRar8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On June 29, 2026 1:41:13 AM PDT, Thomas Gleixner <tglx@kernel=2Eorg> wrote:
>On Sun, Jun 28 2026 at 13:33, H=2E Peter Anvin wrote:
>> On June 28, 2026 9:46:32 AM PDT, Thomas Gleixner <tglx@kernel=2Eorg> wr=
ote:
>>>> That sort of fault would probably end up either with a
>>>> page_fault_oops() or risk a context switch with SL>0, but we shouldn'=
t
>>>> make debugging harder with UB=2E
>>>
>>>Definitely not :)
>>>
>>>You can avoid quite some of the problems right in the ASM entry code=2E
>>>Instead of checking event type/vector and then going to the stack switc=
h
>>>logic, you can check the stack level on which the event happened
>>>first=2E If it's not 0, then there is nothing to do=2E
>>>
>>>
>>
>> To be fair, for this *specific* case, memmove() does exist for a reason=
 :)
>
>It does, but why bother doing actual work, if you know upfront that it's
>not required :)

Of course=2E=20

Then there is the very open question if this thing has legs at all=2E I'm =
still interested in using SL1 for the interrupt stack as I think that could=
 be a performance boost=2E

