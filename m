Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C17CCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC808E0010; Tue, 11 Nov 2025 21:14:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535A28E0003; Tue, 11 Nov 2025 21:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE0F8E0010; Tue, 11 Nov 2025 21:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 283008E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:14:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECBA71A02C3
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:14:36 +0000 (UTC)
X-FDA: 84100336152.17.4DF8189
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0EF5C140006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:14:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KxN8yjRA;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762913675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVQBcx6xFjlJyhg8EGvnzlqkKD9tleq1IsOwgdEnnOg=;
	b=TH/+KLB0hJc0YByUuaTPJPIfr0/iqwXwg0KCFi2iWD3vZZcgyxm0Bavl036QPK8a2nu+ae
	0G2vuPTwPFeD8sV6BltcviNMyuUCE6hNi/ZdU1Z6dWD9JeskTx/GeyJpvVAEF7hC3hbI56
	oiIUPTMVnGdOHHL/KZCN9DC1UUGxkUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762913675; a=rsa-sha256;
	cv=none;
	b=Z2OHSKZxj5KgUZ6TQYOTvciNseefMblLzEwgz/q9GJHParQgvJBF9S4vN77RxQLw79NYKa
	56ZPSMFupgLCYXyL6/xZjpboFApHT2xUjnXX/PAJDz0AGDYFkRGcDkOGpMs4SAKD0DR9/x
	R63CHme/NtwP+sEzL0ZBZejhZ7NcUdQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KxN8yjRA;
	spf=pass (imf09.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3437ea05540so349674a91.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762913674; x=1763518474; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lVQBcx6xFjlJyhg8EGvnzlqkKD9tleq1IsOwgdEnnOg=;
        b=KxN8yjRADbYUFP04uMRbR6BDq00bOi88BKbGDeKs2iQAbViTYNOb2F7u/8TimiWHeP
         Uk3yggmsOuUQZNLWApPtKqfH4mXrErGQPUUY4jXOT2FbYxlYmRT122Y59rEzsTkCqZFY
         xTivADVkkbJCgUuIml9k99AXom6Ioz8qjql0kpTPHk4xnA5LbmefDmP3QT7s2QU5FOpe
         izIp2dejzNdVkPldtKADFHwtL8SzlD7ftou0vZc2PPY5ds2JCPWXBL7ra4tuXo7H5ql5
         Acq7LgmCatHMWxOHhDo+a1p6S933TdvNSRFffqsS+hnE+ZzvfqKmG7uhOPNHHR0B611v
         oUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762913674; x=1763518474;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lVQBcx6xFjlJyhg8EGvnzlqkKD9tleq1IsOwgdEnnOg=;
        b=bXo8k73Y4m30Hb+61hpqs2QNvnvuISJGm9WToNeZirNUUV/RjgSrfinjGcqg9I/Sze
         /KVhrkI2ytdEW8QuK33HBugh5vP6KQCqiD8Q9zUw2IgrBj05+f64ddkP5zLaEWjN4x/F
         zfNGfRLr0icRJ1onI9uYCQoAmaQHj5+SRV7hdrQVEYhSIOIZeJFpzdlrFWAXO7OdnHFf
         IppKw+Zeab8LFaROJHH2oYb9nnfLQmB3uXTq+NrReiMJoGZ1Vs2giL9Aq2uuPA9aEKAM
         9rv6RoOjhSubaV23QbekwOcsN6HJ47EzBdVB42OL6vdXaed1aGdy0EIBj1YEbvouoYSS
         neog==
X-Forwarded-Encrypted: i=1; AJvYcCWf2HnBMpXYUVa3h7f9Oajmu8mv9BxnUR7AmaSeWMrZq8kdM8fV/dRfpaNogsQ8iJoFo4Z6KRkI0A==@kvack.org
X-Gm-Message-State: AOJu0Yxl99KjklUgLmUNJwDF2hBD6K+lkiF7yPPCkWlZF/UtxsQbXn2U
	wNXzJwlbSDqaKOvK8dawULHB+GkqvoLYDM9YUKyxMZcFXrdmTHpJdWEP
X-Gm-Gg: ASbGncvhG81zvBYE8fQ+IYfvhcuKwMcfAAasMpBWG0c2x4Sc0RmW3GA8j8/dAALAg0k
	12ybTB9nYQuES4ZvsePTjXpwS6fAfJtYll2YBO07ADd/oo+hM5Xga6XSuceV7CcPQYbu8Vp3QLS
	NZCjycXjrq6/J5wR8AWyfgK/+dxpNXUmexBF8gkItcHfZdZrOZENmbg5uWUmOXLlGokmJbvLHIR
	kgXUPERqmZWECtJW2QgERdrn+uKVrsp5bEnGbWqWdtXTIXR9mOwV43waoKqLKShKCxmkdl6UETw
	Gc2/r17ZAKPiK2pHwg+1Ncbucb8lgw+D5b7fpvTRLkwbN0MzCJ7Wa9+4CWciU/tXXbk1n2sA3Dv
	oLuCLCxxJGC1YkO9O4EtqYQBGAay6z4H8lL9VToGRsnku1SXI8H1Ng8+H/5mQEeU4atTu6fM4v+
	zLDA2xZYfsWkw=
X-Google-Smtp-Source: AGHT+IFqj6mSlRUdzokZ1Fx9dnl2ksqvuqBqsXipooXRvbblexf8W6duI6LZnIuMeBzrfzf2MAr1ZQ==
X-Received: by 2002:a17:90b:1b0c:b0:340:a5b2:c30b with SMTP id 98e67ed59e1d1-343dddf6caemr2117777a91.9.1762913673519;
        Tue, 11 Nov 2025 18:14:33 -0800 (PST)
Received: from localhost ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e0714267sm559591a91.6.2025.11.11.18.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 18:14:32 -0800 (PST)
Date: Wed, 12 Nov 2025 10:14:29 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>, Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>, Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>, Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>, kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Liang Kan <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>, Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>, Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 00/27] mm/ksw: Introduce KStackWatch debugging tool
Message-ID: <aRLmGxKVvfl5N792@ndev>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
 <aRIh4pBs7KCDhQOp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRIh4pBs7KCDhQOp@casper.infradead.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0EF5C140006
X-Stat-Signature: 4kjcp563w38w78kjtupnbx81due8k1ia
X-Rspam-User: 
X-HE-Tag: 1762913674-861199
X-HE-Meta: U2FsdGVkX1+x5JF1qhVuKgYZEyoyRCNhrWmEGaVC2mSmCICkeOShEVkZldNVQpiMmF3E3Oz1dxLBB9Z+2my6f9pazxF44D3OlupV8YZPQ29oiiRrfICQBS0HSFmJ8WgnG3zzCoRNowjR8efa6Mtfl4MVUEtJnee8/82Tw7PJVN6rvKgVebjB98lV5jie/j8WTVy5plVFikrOvOhWU7nCNNrt1NXqa0f3Htp0U8qSoEq6JCyqXKKDPJD5Q5YSTVZ4zQMYTtN90+a9OAcLxSLHWPp8NJ2OxYokBzJDiCpYZXdGRXpSvjdvs8tN6KIz2OPLhoyJ1xqsjzN51yrFx/vShId3+mS9DOdSkCTHZKYXbMEvWPj/WL/3Af269T4ziqzv//D09X7jCNb42JZt/F2cBRA/8jD8Pm0ZNjlNi+CIRLtsLyVJgJKfAuAbBRn3xgf3/BYRNm1o9g0x5X1bWnOSGKUXK28GhV0d+OFmCXucXGUawczywu1VHmcEjvdygtHkaP0+ZQyRAAim0zf4WF/TiZ5uQeF1cmM1BXjUEDpQ/QUdl3gtgGIgeIRAYQZuq2L8l97okVU5kUdHfiWDicSGGGyU6Z29BOcTI35yVgR3kvQwfz//o9W/ce/kmIRNwkGyaNhyWU/e7h60x7iie0ygYQgRFyTZdfZLNTXGn9+A8Wn5CuOYmjyRzdUN8fbBjZpqNtdvY0H8EEkrS6N9KqmqQT3mepN4562rbhXq2IGQy22nPY7BqioRknVdHoEwkJh9XSHLOus3Lc63ZRWOxV4XYbaRn+mfp4V+90ecY4QA+M1nH1lG8zWL60IxIjumV7oRZLLmpxHk10TGAij7+MXCWrfgQ0MrzPU9hRwIr1IhrDDDSQm2JTy91LaM+VVRA77I3sNeVLlhTqp7s2ewznOf+PoyShFVlmYP/OMz9kkD+3Nw4a5Tm2YxpahtuFpwnXxcSJYTFt07Ed7omf0gvHZ
 hlKC3uX3
 oqxvoGvbxDaAbwnerQt/2/UQswv6mUC1bcI32BnTQMGtvt/7FH/8Vy/LdWd1TN2GOh2Frff90cNR93W2FEviifojDDuteQkcOzIKPv1c2N0T5rDP3RWCh9HGK4KanFFN4OiTlG772qG9+PyefL5f5j/0ba4/hknyM4KYh0xJihVFtCmzabYUnARmaGhBiQPKQHz3SVPNN5STHRrtMagXSAypvSJVbY0lcxr1vn9G72V9VMFV7GtjAKFDxtFTcQyAaPIC8k9f3j9JV5tHNq3TzI41WaLgT6YxH3Fi/UCdUr34G9XfaRpse1269QeJgnclicHMQoz/8vRqylL9AtIRN0YEs8M/fMmDzx8uM4vtKGtEFUYQDWqb5sq1gyypvu1DqgyWvRViYPke4GqGQea3YJn7AOXbBzWtE1yHPOFpqvZUTzxUKWs/GnAY+3sxDNAFZkJprrhloXNkHBO7EEbIabBkCLjr9noMUBeKyJxm8ej7CLQEx2eK0pfAd+Ok9viik4fdQYdH7VL24PCFiE8txgTrCWNDbdDW47VpvL4IUSGjDPuSmech6ghoHMpr1rGtve8k5g5+rbOjO4XjwoparXIJqbohV6WySt5Wk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 05:33:22PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 11, 2025 at 12:35:55AM +0800, Jinchao Wang wrote:
> > Earlier this year, I debugged a stack corruption panic that revealed the
> > limitations of existing debugging tools. The bug persisted for 739 days
> > before being fixed (CVE-2025-22036), and my reproduction scenario
> > differed from the CVE report—highlighting how unpredictably these bugs
> > manifest.
> 
> Well, this demonstrates the dangers of keeping this problem siloed
> within your own exfat group.  The fix made in 1bb7ff4204b6 is wrong!
> It was fixed properly in 7375f22495e7 which lists its Fixes: as
> Linux-2.6.12-rc2, but that's simply the beginning of git history.
> It's actually been there since v2.4.6.4 where it's documented as simply:
> 
>       - some subtle fs/buffer.c race conditions (Andrew Morton, me)
> 
> As far as I can tell the changes made in 1bb7ff4204b6 should be
> reverted.

Thank you for the correction and the detailed history. I wasn't aware this
dated back to v2.4.6.4. I'm not part of the exfat group; I simply
encountered a bug that 1bb7ff4204b6 happened to resolve in my scenario.
The timeline actually illustrates the exact problem KStackWatch addresses:
a bug introduced in 2001, partially addressed in 2025, then properly fixed
months later. The 24-year gap suggests these silent stack corruptions are
extremely difficult to locate.

> 
> > Initially, I enabled KASAN, but the bug did not reproduce. Reviewing the
> > code in __blk_flush_plug(), I found it difficult to trace all logic
> > paths due to indirect function calls through function pointers.
> 
> So why is the solution here not simply to fix KASAN instead of this
> giant patch series?

KASAN caught 7375f22495e7 because put_bh() accessed bh->b_count after
wait_on_buffer() of another thread returned—the stack was invalid.
In 1bb7ff4204b6 and my case, corruption occurred before the victim
function of another thread returned. The stack remained valid to KASAN,
so no warning triggered. This is timing-dependent, not a KASAN deficiency.

Making KASAN treat parts of active stack frame as invalid would be
complex and add significant overhead, likely worsening the reproduction
prevention issue. KASAN's overhead already prevented reproduction in my
environment.

KStackWatch takes a different approach: it watches stack frame regardless
of whether KASAN considers them valid or invalid, with much less overhead
thereby preserving reproduction scenarios.

The value proposition:
Finding where corruption occurs is the bottleneck. Once located,
subsystem experts can analyze the root cause. Without that location, even
experts are stuck.

If KStackWatch had existed earlier, this 24-year-old bug might have been
found sooner when someone hit a similar corruption. The same applies to
other stack corruption bugs.

I'd appreciate your thoughts on whether this addresses your concerns.

Best regards,
Jinchao

