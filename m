Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2799DE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A1496B0089; Fri, 19 Dec 2025 14:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 524966B008C; Fri, 19 Dec 2025 14:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414A46B0092; Fri, 19 Dec 2025 14:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF816B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:05:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F04B8C0684
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:05:15 +0000 (UTC)
X-FDA: 84237148590.01.08A5095
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03FE120011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:05:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=boeNGRJs;
	spf=pass (imf13.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766171114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eV7MMJjNh+GgBWpC1KWI4e80gQbcoqCCVdMqswFoyR0=;
	b=Ew/3b+ogLRzdn/9ex0XxHVfC7xPHFrSTHb9HOYSaABId2ZEjiIcl+HlEDm2CGfbPw6NRft
	p3tzrH2ksUhlvbkB0XAleLmtUtpkZNdrApNbq6oOyM+LL31TL1mpBtO6GnX4lX+XjX7n8E
	Szo/NQr5DBO2HIJFfTJ46ISwuSihW04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=boeNGRJs;
	spf=pass (imf13.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766171114; a=rsa-sha256;
	cv=none;
	b=qcZXo/6G14fEHF61zrStMLBWsA6Aij/WZfLpmPEm0RtizPWM0fBhk5oSLJ9D637RSFJ6vr
	xqTT9gZX1RpXXbEr8l5SPKJBVXJp+Aq2T6pPFmZwW5qFrAnRGhWVDlzcu9uxciEOEIXSjj
	8Nz1sOrN5hbFtt8VdZGOQlJTax8/1P8=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXxn46t8hzlwmGt;
	Fri, 19 Dec 2025 19:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766171105; x=1768763106; bh=eV7MMJjNh+GgBWpC1KWI4e80
	gQbcoqCCVdMqswFoyR0=; b=boeNGRJsgKlp3hLFPG9KwlpxMPgC9GvTxoYtra57
	fDZ5/Bqc/iY9il04qGlocz0VkE3ZY0ptfRFx06N+FIezk1JtMZ3yKWbIFU5PSGIk
	UkPJ9FseM/A0PwzH7CpKNEDAubZI78GvBdRyUYqj2Qo7RYbpuEPQ9TQYF3ijUtlQ
	9tbrbv7L8aAiJLNzhrDWlnR8Ny4jKU8I7gAcKMVaLEN66MDjRYS80V/oKh1jBmmz
	PXK8NOKIrEfnkpeqJRkA+METSqRvisYP2/Jc4prbjyHvgvE0WRWMxCSCoRrM2jEm
	DxjjdTfH0hiFBN/vWp9lz2GI2eF7GRfL8o5zH83z5GTa5A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pu13yLEvt3U6; Fri, 19 Dec 2025 19:05:05 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXxmf0ZcWzlvwXX;
	Fri, 19 Dec 2025 19:04:49 +0000 (UTC)
Message-ID: <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
Date: Fri, 19 Dec 2025 11:04:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-3-elver@google.com>
 <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
 <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: f5o78abja9fb6s77myznje9rzexgho9r
X-Rspam-User: 
X-Rspamd-Queue-Id: 03FE120011
X-HE-Tag: 1766171113-864406
X-HE-Meta: U2FsdGVkX1+ARbhOGGefCvy0p5VrGVm4POzkcnmPXZt+zbxTr4IEG8HERGEmhU0iPh0TWM6polldaVyAOT3HfQSaJaBjc8H1zRIyygV2FBqNg3Yageomac1kxXruF1uGh6TUTmz43C8Tk2uIUPo/Xm9H1wZVMuCc2/1gky2jBznbkvcERdoLhVHyAkHHvm/8P3ZueG4dAHJe+p8Bn5M0BpiyyLfHioN9oNUhZBq0m4VN8asZ4bGhnE5CjVJcQE6jZl+/Y3Ghi2kqlgz3bUMS1Yy3QwBs2ydZRJXDDY+kZtUhF/u42aT0ZhsWJpZkEtvxX110kZASUQAZx42xqizQfMbPaq0zbpWNoC8e0TsbRFbtLSJ/ixmzp6I5mhfVYQ5KZAmJblwF/K8ZJ1q/Sii6d7xcwwi1F01+YZKyJGuF9A97+ohjN10rQg0QAzxJxuZoDPs2Edo3Hz4DFhhqYxwtVsW2o4qLcaorx75EH+JuJZjikACG1SIzA4yLI/MkMdnxuArD78XF8s988WI80kWItIHw54SLWs/ryJgp7FKaJclzSIObuSHIs7lBmrjjPyf6yA/5nyaLQn4ON9FsZ+uAqBLyX88/seCNzKFjCL5Ht8uwiAH4xvmbSe21ALjFmVelvFBl9c32S8y3XH271jIWGMWy7YBYVEW55NBXQKQm3kq6hHEsXmrI0+0hWuCIdaOCGWbsf8aLzPGlxdxJoD/BJ4321fN5BtjGwbP4wfmWwwoLHF/DQ4v4tC5v44MTXXqOx3Gb27A+U/7WkXRSiSArVdvcq79lyr5X++VFUhUxTL8DdVk2Dxo75nTenXoozwl1pfHNnTFvw22rsh6SfD0g2AxFzPjrs5rW9O9pmOiKbhilZz1YXkrTrf1jOplCrSXVK10Ey20rzBwDvwmJG7UC7L48uQ+M/Mc61NyyFW4na/LXA8iwMgNAdUkni3ytvlnwJ5y+GTssap7fjEAL2o8
 V5VFdNMZ
 Trh30Vgk42Woj39iYLUQeYr8Z3FSCiB9FmfJ7JVR0LwRmELwpzQA0eZF4unfSwWytQydzVVbeNIfF2o7ivOJghiJKSOyW8EIPoJi56Y0mBUvkLYdi/p+loGZ20K/TRr0inyBVdss4ojOPRTVHpWalKFQ2iM8O41PWhEK5Z+mUaunAheIvjhN7t1gXHPuKky8TrzulWlT83lrLVhK0YEOYgoV5JAJRoLyJ1E9VrPmCPBDO60LMs8i5eTLHnC9B5D8n9WvAn9lXi3G0zRf8n742xnyrW7/lC9U/imlOefWOd5EzXFkktnwA5Mz6CCSgcYvwtR0KIp2w+7a+mzsVuFqKnboIjCdtrO9SSFYoaBqu9sXI/goGUaGutKuDF4/61xKoex7dqIpZ5YPDQsXbKiVrA/jyedbo/sMXqZsvMUkRkSg4yiEnROsYrgdAyNvv1+3qGd8t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 10:59 AM, Marco Elver wrote:
> On Fri, 19 Dec 2025 at 19:39, 'Bart Van Assche' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
>> I'm concerned that the context_lock_struct() macro will make code harder
>> to read. Anyone who encounters the context_lock_struct() macro will have
>> to look up its definition to learn what it does. I propose to split this
>> macro into two macros:
>> * One macro that expands into "__ctx_lock_type(name)".
>> * A second macro that expands into the rest of the above macro.
>>
>> In other words, instead of having to write
>> context_lock_struct(struct_name, { ... }); developers will have to write
>>
>> struct context_lock_type struct_name {
>>       ...;
>> };
>> context_struct_helper_functions(struct_name);
> 
> This doesn't necessarily help with not having to look up its
> definition to learn what it does.
> 
> If this is the common pattern, it will blindly be repeated, and this
> adds 1 more line and makes this a bit more verbose. Maybe the helper
> functions aren't always needed, but I also think that context lock
> types should remain relatively few.  For all synchronization
> primitives that were enabled in this series, the helpers are required.
> 
> The current usage is simply:
> 
> context_lock_struct(name) {
>     ... struct goes here ...
> };  // note no awkward ) brace
> 
> I don't know which way the current kernel style is leaning towards,
> but if we take <linux/cleanup.h> as an example, a simple programming
> model / API is actually preferred.
Many kernel developers are used to look up the definition of a data
structure either by using ctags, etags or a similar tool or by using
grep and a pattern like "${struct_name} {\$". Breaking the tools kernel
developer use today to look up data structure definitions might cause
considerable frustration and hence shouldn't be done lightly.

Thanks,

Bart.

