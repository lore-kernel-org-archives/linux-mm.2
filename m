Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9A1CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 07:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124968E000F; Fri, 10 Oct 2025 03:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCC78E0002; Fri, 10 Oct 2025 03:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D628E000F; Fri, 10 Oct 2025 03:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E21FC8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:58:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E5165632E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:58:13 +0000 (UTC)
X-FDA: 83981451666.02.AD7A59E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id D351EC0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:58:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JfHkuGBG;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760083091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Nucw4E7LkwzxjCbFb3F737DKijbeBN9zMwZ0PDOoZQ=;
	b=CKvNBlEKf+vOFSs49IZ3MjsrNlNNcNSZ9mCLuGQEn81V5Y33JKVRL/wsr+D8VnFSr4KV/I
	+bRDPml4FRK9bFRUys68y0iRN9QgARIrkxWxXl6I09c3gkToPxgVCmVSYsbLnnB/GHjSVr
	5p0b8aomVEjoTd9XMxjoF+wgz5ooiYc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JfHkuGBG;
	spf=pass (imf22.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760083091; a=rsa-sha256;
	cv=none;
	b=F+eTIgkvR1+L1Eth5TusJduZKMQMB2M1S7J17j4nUCtx1NhWNydWA7MudIW2MYMLvzbVK7
	E/HlWJA1q/2hdF7A9ExsE2t75thqFK9kvoiIn/eEwMQ+Ewkktyu1Jv58HZWG4EXZftK2id
	J2W1rS9fsWGSqpmpCTw/VMrh1shrBLs=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-28e8c5d64d8so16987585ad.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760083091; x=1760687891; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2Nucw4E7LkwzxjCbFb3F737DKijbeBN9zMwZ0PDOoZQ=;
        b=JfHkuGBG2C1l2PFZJxmxixHdcHKj9OJdQuYyTBmGQ7CLN3R/UJxRfNeNXFzNIn3nDI
         lkEgy2K1AuTcezHsYsc5885HosUnUdlrM4z6TlZfnKxEppl4l5GDT32o8+BfC8RC3QVT
         mNjXobVF0sL9GjSDf/+fZyix9pj1/B+3ANxL2f7WvfA8vScXDJCo7UnAI5CCIc6dYO05
         //5qH6gJEN7eFCUGFNQaKb63KTRihATTuaACBMHE+sKTuIgNtAYfk1Lk0htn7nEqpA2C
         CnfdA/NC8W9PaPWTLk3cUoVFtIMz6r6Uy3P/ZDn1K9ypSZFybSBhhE6SYwfBoQAtS9z7
         SUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760083091; x=1760687891;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Nucw4E7LkwzxjCbFb3F737DKijbeBN9zMwZ0PDOoZQ=;
        b=DalYCps4sLYGLaHUIbZ5Bf7Z6lDHnCvTwjfc465clZK+Sx3lx/UVixZy+g6zPFQSao
         1kiuFQxiONpPgGZlxCf9tHLEKguauVsHw+FEAr4HaJSglXkJ8qbYkLnqEbuZr/ztov0b
         3biRM+LYEwTSTuvu3W9asDXhMQioyH5xS701OqB0m2lLLEnVOtu9uxJ9Uw31BecydOVR
         GsiEjqiw+l9YTFT0/nViLnCFPtsiXF2pnyzFCkHZ9HIXFpm1+JV3LAtSJNRY+t/VTETn
         N77kf/yACoEHLcrYLQG6m3rZPLkyrADIykKWAJR4AvvFixrzNBivgIjtlpZl8yCfDdny
         pkZw==
X-Forwarded-Encrypted: i=1; AJvYcCUTCV4frCKuTEZEEHwf4PIn0KrFn3fPFYEwWfQMtdeojsBvIb2sbTjIkieh+LHAYz7Kz1Jif7Lx+Q==@kvack.org
X-Gm-Message-State: AOJu0YzVYkiugLxm0MUT9WEiN7sXacF5z92JOcgOBsG6Gz4p7tvMv/55
	lPCrZQFEIEK+DAFIruduAECH6Ap6BTjjFIqbKPR703ZVr+Fw7TSbepqI
X-Gm-Gg: ASbGncvRq+MoPelrUwqnNgsCyl6RE5GhLBliow/Ecx5/KQterEw67EnmXa8R2Hl7WGp
	8ep9sY0CwgktRuTkw5dq2xSa/pcdM1Q912EeB4f3sdbk7fAuZc0qa8xxXvzIiY4523oHY7JVkQB
	a6zXcgbNOtSsK0FWnbCoGy/lMt2jFaHBkqq5OB8K34qpqqQIXo83IHLCBUs+CM89wa3YfvZtv4p
	HxWMhQLt6Ec5St1w+25chNouAIElbUo7jtJyBh/RpAFATqKowt7AbgQ4XQg4xLk6VPrU8i8UmEe
	Cf7psa3ZgSzG+6jXmMGf/7KCl2ogqUkrg9FL46iu4HALrHeL20W7APOIn9B++w6plIL2oYZpfn8
	hOBkDsENKPqtO3Vx8SnksPYLJENIIR5+kVKYpdfBtwRlqOd4VcN2i9LVVUkc9gFZZADY=
X-Google-Smtp-Source: AGHT+IFeywA6gB4/SQbmJGvT2KY5YTMhXWywBtcaIqaAsauF4r7EzLqcGRXLsSas3aRqscvIRrL6Qg==
X-Received: by 2002:a17:903:298e:b0:28e:756c:7082 with SMTP id d9443c01a7336-29027374b38mr134966335ad.15.1760083090502;
        Fri, 10 Oct 2025 00:58:10 -0700 (PDT)
Received: from localhost ([103.121.208.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f070ecsm49587725ad.60.2025.10.10.00.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 00:58:09 -0700 (PDT)
Date: Fri, 10 Oct 2025 15:58:03 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>, Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>, Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/23] mm/ksw: Introduce real-time KStackWatch
 debugging tool
Message-ID: <aOi8i1Y0decaamaX@mdev>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
 <20251009175107.ee07228e3253afca5b487316@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251009175107.ee07228e3253afca5b487316@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D351EC0011
X-Stat-Signature: c3njpdwc9hewsp4yz89a6gibbqtzp1ur
X-Rspam-User: 
X-HE-Tag: 1760083091-411717
X-HE-Meta: U2FsdGVkX18bTojqG6KBzfF5KxleNezK8TDnTyJM8suazlGvrzoHhRP0isIj700PwtzAJw3ZXP4mvC0bs259r2NKwyTUE/dRD+3+c9GM0CigPwZ0UHR+g3cnEoy/Nnl44EvN5yk2T6HF07SUoaymRFJii3atKEXbIaes0YZfneT5YtZOk4ZVLfC/ycag7iwRWEgk9ugkMpqk7VDUXNy03HLDR5oYdsEPB4dOL4sIZl2ZOWzgsoMfIQ2ZQWq6UJJx1/TWqcQmzjUj6cjG2wP7DrQh1K2HpbMcW+FBk4NjmLPZr1O1Pfwho7ZEalevjy6Fmg3X19SafPxhQb4FHOGJrAWqvcZ61M+toMunAkwiYn0q+B5O14YsazA5Bq0OL5HjoH3hT42arlo9AsrpdpPRW++HhvLCLBBbV7AAXIUTaKSCSASXYdwEadaK80HOSeAlaCTsFpHpartj+faXR2x7c9fGf1yuU4nXeWJbqOfnffA3vuBfMQ/wJ1vy5ahIU2v5B7uJOC4yQadMaSZnH/4S4Mfaj8leqcKEysl5xzZs/i1k8uorRjYx87E4xd2a8xNFajgBD41GNqRY8PbpWQF3ncTIn0j5zIXL5Q+biBaFvEtZlIKmDcJ7QbRy6uzceyY4h4bgms0yZV1LM6r6gn1gBK1RsTfJEU/PrAKV7J2IrxYCfDNYXsGzwQjRFjYjB3FhvuXKEo7SPht/yraEUS/CEskzFceZIOr3OitcrRoMPnu6xFX9qjAAyGIIAuP4uBZEM1MCq5OFCrPes+KrXoY4U62I2SNRj5eTGVKL0mw7LsJmKKZ82ot0dqNoP7WRl1EkVygRd0IUcXEXCYvKmqh1Y3M3qElnraVK11i5xfU7RO6Zsh9e8JWjlkd4kLjAOzz/mP8gFGGqQBDNTxCxzn0qCQYzTCEvhDSoX8wQt/FvypY+C6hI/3HyTJDyhUZFjgN7ca9mB3iU1pRAysGQE5R
 bsk1g5HD
 CeT/3U+oeTPmZ4jZdRnNc/u8qBg6//YHL/yZPhy8vTCvprPlqERXFNY1MTzoZ/jo/FhM3iA2mQxQ7OmAcoLotxB7vzTu9HEgsF/vdnUUJziuy4LTqdu8vHODQtuipbrTL6r3Mm0XlZBAZdo7+PX/Ah+Ksw9719AwnM81H1mKpjbGB9xk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 05:51:07PM -0700, Andrew Morton wrote:
> On Thu,  9 Oct 2025 18:55:36 +0800 Jinchao Wang <wangjinchao600@gmail.com> wrote:
> 
> > This patch series introduces KStackWatch, a lightweight debugging tool to detect
> > kernel stack corruption in real time. It installs a hardware breakpoint
> > (watchpoint) at a function's specified offset using `kprobe.post_handler` and
> > removes it in `fprobe.exit_handler`. This covers the full execution window and
> > reports corruption immediately with time, location, and a call stack.
> > 
> > The motivation comes from scenarios where corruption occurs silently in one
> > function but manifests later in another, without a direct call trace linking
> > the two. Such bugs are often extremely hard to debug with existing tools.
> > These scenarios are demonstrated in test 3–5 (silent corruption test, patch 20).
> > 
> > ...
> >
> >  20 files changed, 1809 insertions(+), 62 deletions(-)
> 
> It's obviously a substantial project.  We need to decide whether to add
> this to Linux.
> 
> There are some really important [0/N] changelog details which I'm not
> immediately seeing:

Thanks for the review and questions.

> 
> Am I correct in thinking that it's x86-only?  If so, what's involved in
> enabling other architectures?  Is there any such work in progress?

Currently yes.
There are two architecture-specific dependencies:

- Hardware breakpoint (HWPB) modification in atomic context.
  This has been implemented for x86 in patches 1–3.
  I think it is not a big problem for other architectures.

- Stack canary locating mechanism, which does not work on parisc:
  - Automatic canary discovery scans from the stack base to high memory.
  - This feature is optional; a stack offset address can be provided instead.

Future work could include enabling support for other architectures such
as arm64 and riscv once their hardware breakpoint implementations allow
safe modification in atomic context. I do not currently have the
environment to test those architectures, but the framework was designed
to be generic and can be extended by contributors familiar with them.

> What motivated the work?  Was there some particular class of failures
> which you were persistently seeing and wished to fix more efficiently?
> 
> Has this code (or something like it) been used in production systems? 
> If so, by whom and with what results?

The motivation came from silent stack corruption issues. They occur
rarely but are extremely difficult to debug. I personally encountered
two such bugs which each took weeks to isolate, and I know similar
issues exist in other environments. KStackWatch was developed as a
result of those debugging efforts. It has been used mainly in my own
debugging environment and verified with controlled test cases
(patches 17–21). If it had existed earlier, similar bugs could have
been resolved much faster.

> 
> Has it actually found some kernel bugs yet?  If so, details please.

It was designed to help diagnose bugs whose existence was already known
but whose root cause was difficult to locate. So far it has been used
in my personal environment and can be validated with controlled test
cases in patches 17–21.

> 
> Can this be enabled on production systems?  If so, what is the
> measured runtime overhead?

I believe it can.  The overhead is summarized below.

Without watching:
  - Per-task context: 2 * sizeof(ulong) + 4 bytes (≈20 bytes on x86_64)

With watching:
  - Same per-task context as above
  - One or more preallocated HWBPs (configurable, at least one)
  - Small additional memory for managing HWBP and context state
  - Runtime overhead (measured on x86_64):

       Type                 |   Time (ns)  |  Cycles
       -----------------------------------------------
       entry with watch     |     10892    |   32620
       entry without watch  |       159    |     466
       exit  with watch     |     12541    |   37556
       exit  without watch  |       124    |     369

Would you prefer that I include the measurement code (used to collect the
timing and cycle statistics shown above) in the next version of the patch
set, or submit it separately as an additional patch?

-- 
Jinchao

