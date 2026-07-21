Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91650C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E966B007B; Tue, 21 Jul 2026 08:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF076B008A; Tue, 21 Jul 2026 08:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B73D6B008C; Tue, 21 Jul 2026 08:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 304366B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:48:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C93E61C0043
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:48:37 +0000 (UTC)
X-FDA: 85012762674.07.1CB46E1
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6EB9C0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:48:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=COxyS21S;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784638115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9BdUyGIX1sBYdd4LfNbX4BHjyUWmMKKhhuvfWpGKTI=;
	b=oUzd5MW0tUGxCQjQcCScJgdIaapXRQ4w/GBk3d0Ww2ecT4Ms8fMtqf8Nq/zUX80hBFK4NZ
	B+3qPGhUacKFlE88TwPZjU3GO4awA5ZUHzyIW9RV29U4ON7HUZdNGw/xiEPpKAHghPgY5d
	GUZsx02gtcxV55gcdXF2JfgOiT5xv+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784638115;
	b=bMF8+/EgI6ZydkVQMmbMiK/o5usIKL2PFiQlOx6O85ZnqRRXulInpE9EKqBtwYGYPofWPk
	z62imYW/M6EueivbLn/WILyqeK1Yl3cOPrW8NtlgVE030nOgROq9Tpe69yeUDLBGRzLC8P
	7xCCRJYF4e7MSWQa+Jk7TN4/5xghsU8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=COxyS21S;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a384e29a20so369486eaf.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784638115; x=1785242915; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=f9BdUyGIX1sBYdd4LfNbX4BHjyUWmMKKhhuvfWpGKTI=;
        b=COxyS21SuwcCnIWPDyYVXazHEUlJ8ydJq0DCwaaf0UMdO4YBbkXw4rY33I7D/ff8i4
         87AyTHz5YqNuBs6q4yOSlW7BF/ZBh2hckeY97s78IxwhuDxejX1tIQBuk+S8auixLmLv
         QPWXkBItpK/x/0E1cIOCTNUBX4WLgbzXj38nXPMTh/doWzbmGf7teU2mgnu2AAa2av48
         Xb+l0T637BobuSRx0lCrlnh7THxFjfd4m3f5WWLU3AceOz75E3gXehAn6b31liK/AUO0
         2KP9LJR4sQke/XM16axovIewyOOePvuMJg/gIMF/3MuOmpWTRrdphkQHd0HNu4lG5Sd+
         n8iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784638115; x=1785242915;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f9BdUyGIX1sBYdd4LfNbX4BHjyUWmMKKhhuvfWpGKTI=;
        b=DoCbLFFxKeq5qAjudbPicuxgrR7mZiWugsa23uaPSejC1iarJ47TRReHIvnUeLPQgV
         pon9vSaKw6lS0laBsSRm1ovbWxbbqKyjIdXGZiBnrBn50mETXGxC5MenHgA/9cK9Bqp0
         5bib/zwAxCVO835ZXLv68cvHKyRXxH89l5gpQgo7f4kUeR3NWGIiLxVuNztvc2vj7sqc
         LBJxxn3V6jiRuwKxmPRiniha/dcMATH7791WGt59PRKZk6odw495MV5IacjmF3vW2VTp
         QFWy5CrJFK7xUR6A93jb2DOmVf6f6UIKQ4MhCmQxRdTRSc9VFgUR4nw4MsfNwQoJH2w1
         TFdg==
X-Forwarded-Encrypted: i=1; AHgh+Rpv0AjoL6NuBT+DJrhuNynNqWFjDVm4yODbzSzReR4n2oDJwifg80gsyKSxHTQsIWriQ24DTxjTxw==@kvack.org
X-Gm-Message-State: AOJu0YxNSUzo2OrBHQwJmjT6QGvNkClyuRj6QTK0RVC4ZrWxk3QkUft/
	kZHXUeyhXCtFeUVw/aJOLWj4xPxQiKM8Rm/M2X++3qjsJbPDwmZALCME
X-Gm-Gg: AfdE7cmuZdL6OZBSAlOgVkglDUHpUU+92VRMVdfK9/8rmHZ1IJHIyrkk64iH4WpCcoH
	tnkynJIh9B+IIGsQiIYVRWMgwfuvX+lDM4w0zMS+BBgQRTLIBT9R8zyEGJvUwydux1UyO7Ex6kK
	sQfcV/+lcbQMhCSJ1wTiga33Q4QeBVzbUHsQtgPwq7nzrcKOoOnuR1hiQvdFOFt9DHvv8UlQZig
	pLfSMXKcQMYFXOm1pXCccCdAdciRsKcxEZUIvoP3w0yA7JJFS9t8oK0DN0aNNwGDiNyBW5Anz8P
	BLHYkNKcpJ1HuxExo18qUq4VpriyUJ4nA6j3zqxa3ShCH7dIKCuwMr66i2ehM5dGISB3y1OwyKt
	N8eRhWkYMRISJkK03L64Zy3XF+OFBzZVkrSWnNng8xO0R8A/sHozfiCJ55X676SR6i5RtohcZ4C
	VcjlKp6Q==
X-Received: by 2002:a05:6820:f02f:b0:6a1:8cd5:c9d8 with SMTP id 006d021491bc7-6a536ada646mr9327016eaf.68.1784638114876;
        Tue, 21 Jul 2026 05:48:34 -0700 (PDT)
Received: from [198.18.0.1] ([144.24.58.22])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4568e0bddefsm11251568fac.4.2026.07.21.05.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 05:48:34 -0700 (PDT)
Message-ID: <f23b0cf4-840f-4fb0-aab5-750dee42a7b2@gmail.com>
Date: Tue, 21 Jul 2026 08:48:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm/kwatch: dynamic hardware watchpoints for
 hunting memory corruption
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Alan Stern
 <stern@rowland.harvard.edu>, Randy Dunlap <rdunlap@infradead.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
References: <20260717125023.1895892-1-wangjinchao600@gmail.com>
 <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <91f3486b-3b85-4b43-b099-0a5325643352@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6EB9C0007
X-Stat-Signature: n9d5ujsarpbhrw9c1qtjc8bp7nmft1ci
X-Rspam-User: 
X-HE-Tag: 1784638115-351532
X-HE-Meta: U2FsdGVkX195gx7TuGf3QNyGKue4P6OLt3uiM+NNpGLL1/5hDXDmYAVykCRlChhkhxDdmnVfjCxkv26PSiJZAIZL9uNcFg+BKt1qGg/hQXR9uID9koSysA5Ho3K8QBFTZcc3T2jIOBNfoF7JbntAcZ7ef4hx2mGU3kxia6vCMwbGw6a5PSjW3Wyz9q1UVd8apEcIyGov5Ih86jVrkNfHtd26lfDexXQH+bUkc9Iw+VL02v9K8bOKsVVsSgGxPwUaLpgXRZmJ9XLJfUcFdcrsWjOnqPAfVZb7nv6xUvce6Tv3Bwo8TMQcWjJm98T+uz2N9EHnjEJeeAumH1kxq+2ebropds1lU4gKsedy1KXkw2eyBQfDHbdw7jnjVINqHi3GDeoLg+HiIvR4S3nTPnlq+EtQLVTUXhprxCNrfYirnJTajNclQ9Cph2fG79BCQq1H46VRYkjKM1Tv85g0d7gFpu8efGXDpTr5NoQVepaG/7eK++94dtHmAdACCv8QSGxCGZ8ruM3VQSHfn/Do7IqtnBotPzLRRvG8Jpc+wCjz2HopfxN/AxDbsjKCcgcEKiSEYDudbMbXKj60gi6GhW5XTAFrrSgA1Mlqy/pyaQEZMo6Xrhnby8miplNtl+Z5xFeV5/TNxKJdZOzkDtl1IeansqZkzEOeEBYxIBbtHk5dM4JARAM98DcnHoiP/KNUJdXyxU1bYu6AJ+6ObwCwq1hK0moogAhjXZssSE/l42clDpNEcvYXa54Aei9+rF8SqyHBD88peRDdufEtHCoVkXiPI6T7AXXoMi+e5+F68ZW5Wr2giD/gMqW/095pHiE49VXg1SkNx3zkFKqxgqFWfqXPPOrQ3Jsa2HMgTfmqg4tj99Pg2Mj27jboFOHL44hsR/gHg58GVzwWANskA2kwwYcnPK1jznLYQm/3ZF55o92mSn1sTaZfD8ZLdGjHEYRcN3cnPRuvrmY0usNolhU+B+Y
 chD9yxL9
 vUha4HdtobxphxUHy2mKUtUgk+o/CxghcrGh5dyOEiVJ3DTbpXdFIXggNM8rMBGFrv1SHsdzOw6ZSnG1xY4G0uxNkqGiWkWarvR5+h6kjlhPQ/3aosExNBRmExxK+jIf9A4XqSIZCOPDYmnanhaOT52YkjPeU2X3H0Go9d4q30B+516eSYE44xV+irMNhZHLTyp1mhUXxgec+10DLhZX1prFKvJPNYZCcSmOIqcSlU2RAyyN519VvD3CgofXLhnLmG7I3pZsLrpTAd2kULbmiIlr1pK44N4qxGeIEfB/CCDQkF3TOqTIrUSepxIXbKumAWNhNLNWcBqGBXHiw8gyA0QyLF7npp/vBy+5XO3f8LPFcelP/9WvlNCrdFST+DOdmECy//Li4pJCVXaUpccRJrCZ1J0utVDxLstBNrCjysfEIJdPMD72fedsOI91bbw5VqcFxdFmou8NMvAzL+yeqORnbHw3Zzz8+R9aErBaQzP70s3bsCJADMFWDcU442d++ExPV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/2026 9:41 AM, Dave Hansen wrote:
> On 7/17/26 05:50, Jinchao Wang wrote:
>>  24 files changed, 2115 insertions(+), 63 deletions(-)
> Reading this, I wonder how many kernel debugging features we need. I
> don't even think we have a centralized list of them. They all just live
> in their own silos.
> 
> This one really seems like a super specialized tool. It has to be
> enabled at compile time and specifically aimed at a specific function.
> 
> Maybe this should live off on the side for a while. If folks end up
> actually needing it, they can point their friendly LLM over to its tree.

Thanks, Dave.

I agree that adding another standalone in-kernel debugging facility of
this size is not the right direction.

The motivation was practical. I have encountered several silent memory
corruption bugs for which I wrote similar one-off instrumentation to
identify the writer. KWatch was an attempt to make that technique
reusable instead of rebuilding it for each bug, and to reduce the same
setup cost for other developers facing similar problems.

This approach proved useful for localizing the dummy_hcd corruption:

https://lore.kernel.org/all/20260714064829.172098-1-wangjinchao600@gmail.com/

It identified the copy that overwrote req->complete and recorded the
writer's call stack. So I believe the debugging use case is valid, but
it does not require a separate KWatch implementation.

As discussed in my reply to Masami and Boris, I will stop pursuing the
standalone KWatch series and work with Masami on implementing the
necessary scoped watchpoint features in wprobe/tracing instead.

Thanks,
Jinchao

