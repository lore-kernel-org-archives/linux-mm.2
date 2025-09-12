Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC42CAC595
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 08:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7BBE8E000A; Fri, 12 Sep 2025 04:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CAA8E0001; Fri, 12 Sep 2025 04:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B7B8E000A; Fri, 12 Sep 2025 04:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA5598E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 04:15:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5C0011AA96
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:15:46 +0000 (UTC)
X-FDA: 83879889492.27.E917641
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id DDC0DC0004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:15:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjiQe1K0;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757664944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2EuFHC5+5B8ohKz2yz145rUlrp5xKfqVTKvvn+wKTM=;
	b=VHw5N3AhLRXXkIPpdQrbx3e/Umwm45Js4T/ROdCy4qy4owATj9xZPUGPMPTLSqPsPagTB7
	JXaRvDH62ejdWUniyZVhJrd23mqc9PGLkK+RQmGO6jtnP5OfY8BvV/RMLT39W7j734YSwo
	DPleecUuPC/QtAsa3ogCag4TWNfIxBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757664944; a=rsa-sha256;
	cv=none;
	b=l6secDyYz9iiuET9ujT3tLdiEtAMt+/7i63oytBu9I9X/89rZi1AbeBhQY73eCDej04Jeb
	hsgqPKv4+njnpKTqogqlH288ABX+8pzCGwWxJXiW2+QPHyJf2fJ+0CfTL4t5M59aEbc+it
	RdqYDdMjsQwT6B3xE8T7v+STZoXhQow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjiQe1K0;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24457f581aeso16635655ad.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757664944; x=1758269744; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b2EuFHC5+5B8ohKz2yz145rUlrp5xKfqVTKvvn+wKTM=;
        b=AjiQe1K0MzAt3YGlrsUL+eJVrYG4+J/4IxMnazfIC+ii0lI7LUT1rxJjmYRPj+Bh5A
         U6M6EwnaNdABKsQS99m4hQac+tvTUQtvzFDoydT7MU+Kxdg7xcwTVVU1ZQENju2jBuwS
         5quw0CZuY4LB3Oc+WY6DyTLqHZRkZrxgoQfQjhmyaMxwUN2YkT1W0+YyE5gUyyJ6i3kE
         EfbtlrnFIagPStKMWyaLffGIpxDg9UM4Ov1vAyda7O8w7lGc7dTr/qF+r3SYBXUtyQb7
         +XTZQrPUCsaPUoyeKtMaNF+p3e52QGfYBZKN+3Qs4S2dgmAk6lTxWWB8xHC5Uf+QPixA
         NJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757664944; x=1758269744;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b2EuFHC5+5B8ohKz2yz145rUlrp5xKfqVTKvvn+wKTM=;
        b=J+YLaPIPO3Qe1w49rYtFTQPEwzb+3IM+enpqip17lGG8FHiXwiT+VEycyP7RfEwhaH
         hskpkXyhJk4fMcqpbEofUDxigvSmwrkxO8z5Nl/2JpB1NRrzj6OP6XZ6CWyJR1yfBojC
         9JJ1rxwkK/0CWXuZMrlf8uY50DwKITQ7bBsF9bQpgmZK/pdB8GVumc2xwqeozwJIn6LU
         FlYkOaZt4EXFpcVYo+hWMd1KzvmHjnXyuNf/GHxuPtjp6/HGsSDo9GW2W22SuDpqtipB
         Rb/7+Ecb8FNeFXCEiPnIYjAFkZ4tSdbN+yfcJDT2Jj3gWHEzix2qN+Fq7UBCEXWL8CSs
         h1ig==
X-Forwarded-Encrypted: i=1; AJvYcCW/0TQYXbBABu/pztUc2JS0BBTcQQoICO9hI2ALhTN+cW7nr0xZDggs8V2eEdB1+d8AhbR7uVSe0g==@kvack.org
X-Gm-Message-State: AOJu0Yz85c7gt9kRYjNQgZp4bpbFMVUWBC8sq6R/T2vuChqAfYdzQ+2Z
	VaqTF/Z+QIa6ft0Ap8H73mVFWM2s/It6QroRLulncth3+4OmPPEvMd1h
X-Gm-Gg: ASbGnctOfy5YAD9sSRRgkmiFUZWQqs3O3vE/purE0NfTLiUWSqlCIK24aQ1BzwJSQW6
	aHqw/lArE2gMNi5zaZFAHGUmGNwIHOAGV4k6LhpNsby69vtJNNUqG3nvEYiNcUP9Bg1PRoQsaeT
	Jm78I1TBAhXlKfcrkbuRTM3ay0aZpji0JOfMXSQ1ebfc7mRqlGGeIkCYZTnRBtHqv64JA76DZpY
	B6IG3kHRiBWyJk1EjzDXREVDN7JQm/1nvd9kssctId5paAtbWbjfjauK9NLf8zYvGWMVddd75ZB
	9i9XgEjx4SW8uFs11zp9B3oHO5kn56zaKRMDCeQvDnQQLuw22tgo45iEcuqJKphTKqMxTZ1gdHt
	Z2wELseNIDiTYoawwDQ==
X-Google-Smtp-Source: AGHT+IEbBMlmn4X7zEmlKlP8C6ibHYXtACBPItjKVzlA2dNacKH531krqQgn4mB7LrrpYHonZsrfZg==
X-Received: by 2002:a17:902:f707:b0:25e:78db:4a0d with SMTP id d9443c01a7336-25e78db4d35mr3480525ad.36.1757664943639;
        Fri, 12 Sep 2025 01:15:43 -0700 (PDT)
Received: from [127.0.0.1] ([2403:2c80:6::3079])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc580csm41503445ad.10.2025.09.12.01.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 01:15:43 -0700 (PDT)
Message-ID: <8c047b5f-f4c2-4795-8ceb-a556ac6647b2@gmail.com>
Date: Fri, 12 Sep 2025 16:15:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/19] mm/ksw: Introduce real-time Kernel Stack Watch
 debugging tool
Content-Language: en-CA
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 "Naveen N . Rao" <naveen@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 "David S. Miller" <davem@davemloft.net>, Steven Rostedt
 <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Liang, Kan" <kan.liang@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <aMO07xMDpDdDc1zm@mdev>
 <CAG_fn=V5LUhQQeCo9cNBKX1ys3OivB49TuSeWoPN-MPT=YTG6g@mail.gmail.com>
From: Jinchao Wang <wangjinchao600@gmail.com>
In-Reply-To: <CAG_fn=V5LUhQQeCo9cNBKX1ys3OivB49TuSeWoPN-MPT=YTG6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDC0DC0004
X-Stat-Signature: zb8cyhb9yah3hf7n8z4gi1ddnsyh8fc3
X-Rspam-User: 
X-HE-Tag: 1757664944-242225
X-HE-Meta: U2FsdGVkX1+TzftRarWJElfB6YIWlBgsL33Zwxs31+2fO4MaTNgxh/UdRpxXjWXr/j1MWp2fyt5o6oKkzea/PlmW1uhDnN7K7AE4sqLFBonBVCGMtJLr1tyNYBtTPB/4VxCDCQaD3QE4VntJLYRbdSETIvmMeHbcmEw54O7NN+zgXBW29TLYHkhwaFNglqCPf0WvR3W60lNRITe/7YYSqXtKIWdvSKEsISY3vC2yq7rYvRgprytYvH47vRyrtMXgPQOaz3E2UHVv8QWWeF8k3cjmKANKx3O71sb50TU95uxRu+s/1n/SCMSmpu+9NWEoNoC5mg0uTZmesiZGrvjG09FIUmYa9GBKiv2MS2KDwPNMToJWfdD05cxvs5+Fnw6l3IMSwlDM+kWSXc3hbBTCq037vZfY02XEAaAmJfui4L7UZTkAzWJN7RILKZEAyXhPyo5M9JzI7ZGj8T3vyoSsZUkPg2MeXzP5goYvT3KeJstg/VeANUEP2tjqO3LhUJTP39Age1wiNejKQnbvpFQFfozTC6LPUHAezOvfbp5OZD9nFIYW+fBtE5wdMb+V70EjOhRBsMOV9M7/RAQOYZGwO5SzwD40lcT6u92LmGS59RWtrqYBCQwHBTgs9cQFhOO98/OAX7bTkme89ILmP18EEmBvNKd/jXq/v0xYeBvHoLB//8Z7hjYjg+c+rU299CG8kqd7FuVrkaMW4RtLB2jEUaW3z2jDLV7uVMvQ1wxjhEThAEtp+iDg63fV/lif22RhIzP7ID9RN99Uo/G0uOep3LJYR9w2L7FivXfpe1F2wEsot7gXtGMoQEyaSWpKrRcqj/PXYYzAeAsG8xqNfCoY4YTe3S+N2zOp/os9gIlEeClfg902y9vioILtHApvmuxqPgzHTZg1LOcQ4PEPUrh00np5zl4R4XUSIgywyNopBJsojygigLUzyNZL5XY/79dVglFYiANcHtiYgc1M+Ci
 bh+H9GWn
 9Vqlf40tk6fxg0ARr2lQv9GBtT95jeg0So1AEq2Oq3RYeheXHZhCAGF+8IxmJZOgIQhW6LGq9OxwNGLvoBbIU1BclGu7GQtBD/TCOOxWmkjzxCuBZ3Gx47jnRvOYfmmBohKCRNk0EoYfHDhO+5hV4cYuEIS9UtSXfrMAXhcAJLwENVd0RDDpQjy8GdsAr6sOmtrNdkBXCjwB9bieKDkfpPgpsaSYZsHPgrBQFuUX1587uAZF7ohr7claaiDpx6QuoAAd51WcV9FW9jC5nUI4FrqypsIh/660e4CbWQkaU1oeSHOH0T05B1RjmAKggbi28ve22Jk2uQCZoPhCGxqhDfsxkgh6Ju7XPUV/afh1/bs5qZ+0ICrBaFr0s/i0IJBEvn4ajYtm6xMCkksJmHLqFt5xgloH/2YFuk7Lk4C7Ndn0lsNNOCaz9OVMfBMq6tFe52EU0u684dzWUqX8495OTz3tVaBXJDILvN/4XttatZD9/8cxDkYOhwxVpy6dHEKWeogW6q92Oc55KCuzzs+wb4mNQbMGBO5hLBHUPGZEQzzSk9FD0mm2t8wYtvzJaJwmuowkyl8VNDqtGokwZV4wjlj8RtUOe1ijk4Jp4VdW3C8NCf/FhGDhCXEK/TH78iEQJIJ36T7HO0NobZ9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/25 14:41, Alexander Potapenko wrote:
> On Fri, Sep 12, 2025 at 7:51 AM Jinchao Wang <wangjinchao600@gmail.com> wrote:
>>
>> FYI: The current patchset contains lockdep issues due to the kprobe handler
>> running in NMI context. Please do not spend time reviewing this version.
>> Thanks.
>> --
>> Jinchao
> 
> Hi Jinchao,
> 
> In the next version, could you please elaborate more on the user
> workflow of this tool?
> It occurs to me that in order to detect the corruption the user has to
> know precisely in which function the corruption is happening, which is
> usually the hardest part.
> 

Hi Alexander,

Thank you for the question. I agree with your observation about the
challenge of detecting stack corruption.

Stack corruption debugging typically involves three steps:
  1. Detect the corruption
  2. Find the root cause
  3. Fix the issue

Your question addresses step 1, which is indeed a challenging
part. Currently, we have several approaches for detection:

- Compile with CONFIG_STACKPROTECTOR_STRONG to add stack canaries
   and trigger __stack_chk_fail() on corruption
- Manual detection when local variables are unexpectedly modified
   (though this is quite difficult in practice)

However, KStackWatch is specifically designed for step 2 rather than
step 1. Let me illustrate with a complex scenario:

In one actual case, the corruption path was:
- A calls B (the buggy function) through N1 call levels
- B stores its stack variable L1's address in P (through a global
   variable or queue or list...)
- C (the victim) called by A through N2 levels, unexpectedly has a
   canary or local variable L2 with the overlapping address with L1
- D uses P in a separate task (N3 call levels deep), which modifies
   the value of L1, and L2 is corrupted
- C finds the corruption

The only clue might be identifying function D first, which then leads
us to B through P.

Key advantages of KStackWatch:
  - Lightweight overhead that doesn't reduce reproduction probability
  - Real-time capability to identify corruption exactly when it happens
  - Precise location tracking of where corruptions occur

KStackWatch helps identify function D directly, bypassing the complex
call chains (N1, N2, N3) and intermediate functions. Once we locate D,
we can trace back through the corruption path and resolve the issue.

Does this clarify the tool's intended workflow?

-- 
Jinchao

