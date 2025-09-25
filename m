Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0908CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5068E0008; Wed, 24 Sep 2025 22:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C188E0001; Wed, 24 Sep 2025 22:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2608E0008; Wed, 24 Sep 2025 22:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA8EC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:06:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E69614022A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:06:52 +0000 (UTC)
X-FDA: 83926134264.30.3BDC505
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86F5E8000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:06:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SELDOif2;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758766010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDDNQxOCofAWfoIkXGgKX3OgUnzUt3+cN5qe0WBH0Fk=;
	b=8m80bFW0DAAd/5dXg2oNZ0TOBNhwitxp556snTdpoYOU2WNGv7JXVhVCn1w2fsUi/Wwb8C
	wDFBKxBrl3QAdn1xuoFK+3ZdnmrhrkrO1B6XuNCf/cBf2dJNmrvADfSOHOZhNuh6N3Mpfn
	gSP0ly5YFk52ee4Hnafej4JfmmZlum4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758766010; a=rsa-sha256;
	cv=none;
	b=ftFKISHvpX5PZSrF6MqppEXE4KU002Oqb6MfsxJGQqrhLEeyW+UeZCYw+jk7kumio1/Bsm
	tMTEEPK5peJVgWUV9qeB9cqHgUQSZ+9WFod1ilUydBStMW3sZZkwFZEwhrYpyoNY3oPP9e
	E6TuzF5QT2SjOdYsdU5X6G2N90/tsyA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SELDOif2;
	spf=pass (imf02.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b550a522a49so435184a12.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758766009; x=1759370809; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDDNQxOCofAWfoIkXGgKX3OgUnzUt3+cN5qe0WBH0Fk=;
        b=SELDOif2xNP0LP7BaLFBw0HwoTUeY6mMwU0VeF/d2pM3HBU3qEKvV9vbTZiYI10RR7
         9TawP9zPNhm9VnwYsWzIdZxrSHUtpHBHfUPdHVTH5J5SkbPsQt8RaUgXsv8Ine9IE41c
         dLkbSsymJRbU2OKe1emnIFo4angti5TuO1qNROh25Bqbgqvu51iKMYSsxzo8360yzroF
         uOwhnQrdgc+qg0S4bQwxOKg7YuBC0wxE0CagacZIBsOBj+hpTSgMOr+EfbHUd64d0rQF
         1Fs72By7Db8658tVhSdRt2lIPEkQN/VClEzjlCCR1B/R41MOzBLeYRqMpYcFBLEPpsuI
         x1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758766009; x=1759370809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDDNQxOCofAWfoIkXGgKX3OgUnzUt3+cN5qe0WBH0Fk=;
        b=rwuA4+JFUuEsz5cihdaOJzIZJcdrzPXAd0SVMjk3NC1M9B9dE1I3es+lK5TKyfFZEn
         xL7Aldc9EvglsgK0Z4sByYIVCJU6kr10SPYX1Z9tObLCRcA+FcH6qQlN318YpC+n5eeS
         JzMvdTeU2jZJejfBUDKmMr2jG9enlexaywJgieV7uQkiwGscKVloK+Wv50sMnaby1rKD
         hWyLmWiQYbToOZ7ZF/O0eJ14FiS7Y/O21MLsDiVMJzHWzDz40riwUeE3hPjWM+TRyB4E
         HTFzg299AhBgY/p9qLKFLiMCLBQNGIkRZo9dvDRbBTxDDUPV4z3i/UdRPvkR8HMBwnO0
         jAEg==
X-Forwarded-Encrypted: i=1; AJvYcCUHxjCZ09obOWsWu7v4d/GHIl7jnzdryzhPWaFAoQwZcMZ9SoAGsDwjsCeXdQ5jfUmK5nMiKwSaZA==@kvack.org
X-Gm-Message-State: AOJu0Yw+zvBiJVg3XtEPTRWPgrdRN7PKcCk/oyUhoiR+xyoV8MEVVC8h
	dOMK2UOfES7GoiZ9flkN2OGF8IqxkT3layzrrcSxDxwyA74UY1TrE85f
X-Gm-Gg: ASbGncsjkLGZ3Jmu5cDi1zCEMEbpmd6gK6n4v/jFDDknsvWx44hdQZtBHnNqsBfWWI8
	t75o+aM3L96qnSfgZULsNfhvGaeiM3fJupjVfidY+xz6D097B8oi0C6ztmao5chGHB91aNfs71i
	HasFxK49H/SGPAPOA/RsX9gldIIH+c+xsVgyoS8j36uX423k38gE37DB2BxY1kpiwG/y+BidwcN
	GX49W9+Vsj1oRsLIgKwbY+R6g0QTtPbiUMTFw9rA5Bzsojsvp1t0EuWznuRzL6ctNx175kjXaat
	rydUU4T625OST9SNIIS1TORxg/I9C5QPDcZFDGzeBPff/W+uuNo1lF1u8brievtcVMYKsjr771Q
	wk/EFAShTsibohjk3u1lNgsM=
X-Google-Smtp-Source: AGHT+IGmMrm8xksFP6ju22OaumMbD6YwInELL6WKXRm9IlZDS3eIrrfgfG3Q7BtCL53wgsMXve+VwA==
X-Received: by 2002:a17:902:f54c:b0:271:479d:3de3 with SMTP id d9443c01a7336-27ed49c7763mr18733235ad.12.1758766009065;
        Wed, 24 Sep 2025 19:06:49 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cf181sm6940845ad.28.2025.09.24.19.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 19:06:48 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:06:44 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH v5 17/23] mm/ksw: add test module
Message-ID: <aNSjtMdxZXdhgPRA@mdev>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
 <20250924115931.197077-2-wangjinchao600@gmail.com>
 <CANpmjNNnVx3=dQsoHL+T-95Z_iprCd3FXeYpnHdmi4d06X-x_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNnVx3=dQsoHL+T-95Z_iprCd3FXeYpnHdmi4d06X-x_g@mail.gmail.com>
X-Stat-Signature: 8x6si1tjfru9rgjbq4hbodtunjo7yzws
X-Rspam-User: 
X-Rspamd-Queue-Id: 86F5E8000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758766010-796905
X-HE-Meta: U2FsdGVkX19kyHOWmUKqAbBLzNy86LRMWvjLyxd/zuNYof834KpyDOKA6qt+5j6xQjvUmn1kmhmz/neqlyN7bD+ic9jHwKfWa66tkcYXqYCIIPCmAUrGjhnkgH5wdIxitI5swQR5xzxRbCAN2DAbbsfQggBB6WVL1bQOCElfjg0VD+D7BiAwfdiv0qIE9nAwYJnzFi4uiqJLo/wVq7dZ6fMA82tmfljW/5mTjlwaQjFiIzPPxTC/6BFHqHnBdOXAZDk+HOB//JQr+C8ZVUvJe582LZRq9YJ4P6e7+GaWWT/k7Mv2Vr9fozDAWy7nrA6ZldJIa5qzPnBPUES/hjzrdh752cdL40jbIRELzR+vVoFo4/yVTfhIEpYEba6qg8fvMRs10AfPZMYgl8veWS/sKP1uQ+duqc+y0oziUxwmKaSKV4rWUi+DpeZCmCYPGwogwK92z6L5jrGIkpXGx7ol0FvWm9HR2VjwYdNfQ24IgdFpDgJoEMlLLD8QjXqI8amTxSqYLvWkgzq5jvYxNlrwLxU2sF2wY4sFI2LBid8HhqiIX9A09Bfl2ry79uVyMHRxEUtzSguGBa0G+EYfTiD6KpZrj6qgaf5SgXHnELEFDjDW7KCGyUIdJjGXHxWZk0ThSlS38yU6pu0yytPwElt+wIIBkbrG4sAgPIGfp1rU5VtWWWwNuTdG2+tsXQiRRWaeLIAbBFtVRyYqzTSKIw69ZMmPvEFc5iMoBArDTbA68dYjBcztNKkJkraQYJhhDUxxuC0E7pfRBapOvnzyWQx312sv7Nst/bLzBqJ1wRTcrGENpD0z/gnV6oJR/52BF1WwKJIAeyt5E4NQ7UMENlLMEA2PGb234azQAsOAStEn6nVL/5VftIwXN30bgwQTQpTjknzy/IN7gzaEgrJLgSlrec2mD99e/jeVboXq07ejeukBpKtdlxPtT7mcFoFA4sFWqYg6xMhDSDCqi4QxhU4
 sGv8gnqS
 G1xT6ukKKI0UD+RlyJkcwjlkEUO61Wh0oGDDR/4fVFQrCceMEzjFT7CA7xjAaccEnctos2dCq7GJYiVTQXnz1jimHVzLgH4iZ82rtsHGJ4fX65/ClFApcts+Gc+lCW+Z30cxWTvTwtI6x9xzxWnrKOZ79wop3YIp96BbAkTddmHoA4SWSQiCXmdybTnp1YqNQGsZPv5z64EEuybtJztD4Sqk2lgJVSUqdQYGulutqF0sCgy7DeQAdvBocaUebSV/+aI/miWpzeFNCjC5fPEq+D6qGQeob/cZyQ8AO5/bzpF3oYDZ36rbfhlt4DPc0885Q5osxwVklIoy0mLQDRJbrUfk7bc6iYBKdFTY8smHXuVzjuXmYN2jphqffy/aCta1wc1MxLeKrTTyQoCrN/hZ7lvOsFJhKHE2fEtsPLXzXBKYz4Du6mauT13A7+NzCA1QKpX1wAOM3XdR0495LJmy43/QVtmEbytqHaePsYMSppa4/xnMj9QUVVYh9Jv+xmPBl8Gg4Ds8R1d2OrjTKawh/M2yYEoOcSKVPRUkI50vTcv+KzVaFPSgnU/JQBob6T/uS2YboaQ4JzqKqNgUM7xeSpoR/UIWP+76tri3HYRKQ8CpCAw0f/RmFZHn1/zuEdBGJ0dOlcm+efA12XtPaVBUnFfqB/Eo5xZLuZ7ZJ8g8UTE2o41D/dCLMbIhSTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 10:44:50PM +0200, Marco Elver wrote:
> On Wed, 24 Sept 2025 at 14:00, Jinchao Wang <wangjinchao600@gmail.com> wrote:
> >
> > Introduce a separate test module to validate functionality in controlled
> > scenarios.
> >
> > The module provides a proc interface (/proc/kstackwatch_test) that allows
> > triggering specific test cases via simple commands:
> >
> >   echo test0 > /proc/kstackwatch_test
> 
> This should not be in /proc/ - if anything, it should go into debugfs.
Thanks, will fix in next version.
> 
> > Test module is built with optimizations disabled to ensure predictable
> > behavior.
> >
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  mm/Kconfig.debug        |  10 ++++
> >  mm/kstackwatch/Makefile |   6 ++
> >  mm/kstackwatch/test.c   | 122 ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 138 insertions(+)
> >  create mode 100644 mm/kstackwatch/test.c
> >
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index 89be351c0be5..291dd8a78b98 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -317,3 +317,13 @@ config KSTACK_WATCH
> >           A lightweight real-time debugging tool to detect stack corrupting.
> >
> >           If unsure, say N.
> > +
> > +config KSTACK_WATCH_TEST
> > +       tristate "KStackWatch Test Module"
> > +       depends on KSTACK_WATCH
> > +       help
> > +         This module provides controlled stack corruption scenarios to verify
> > +         the functionality of KStackWatch. It is useful for development and
> > +         validation of KStackWatch mechanism.
> > +
> > +         If unsure, say N.
> > diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
> > index 84a46cb9a766..d007b8dcd1c6 100644
> > --- a/mm/kstackwatch/Makefile
> > +++ b/mm/kstackwatch/Makefile
> > @@ -1,2 +1,8 @@
> >  obj-$(CONFIG_KSTACK_WATCH)     += kstackwatch.o
> >  kstackwatch-y := kernel.o stack.o watch.o
> > +
> > +obj-$(CONFIG_KSTACK_WATCH_TEST)        += kstackwatch_test.o
> > +kstackwatch_test-y := test.o
> > +CFLAGS_test.o := -fno-inline \
> > +               -fno-optimize-sibling-calls \
> > +               -fno-pic -fno-pie -O0 -Og
> > diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
> > new file mode 100644
> > index 000000000000..1ed98931cc51
> > --- /dev/null
> > +++ b/mm/kstackwatch/test.c
> > @@ -0,0 +1,122 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/delay.h>
> > +#include <linux/kthread.h>
> > +#include <linux/list.h>
> > +#include <linux/module.h>
> > +#include <linux/prandom.h>
> > +#include <linux/printk.h>
> > +#include <linux/proc_fs.h>
> > +#include <linux/random.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/string.h>
> > +#include <linux/uaccess.h>
> > +
> > +#include "kstackwatch.h"
> > +
> > +static struct proc_dir_entry *test_proc;
> > +
> > +#define BUFFER_SIZE 16
> > +#define MAX_DEPTH 6
> > +
> > +struct work_node {
> > +       ulong *ptr;
> > +       struct completion done;
> > +       struct list_head list;
> > +};
> > +
> > +static DECLARE_COMPLETION(work_res);
> > +static DEFINE_MUTEX(work_mutex);
> > +static LIST_HEAD(work_list);
> > +
> > +static void test_watch_fire(void)
> > +{
> > +       u64 buffer[BUFFER_SIZE] = { 0 };
> > +
> > +       pr_info("entry of %s\n", __func__);
> > +       ksw_watch_show();
> > +       ksw_watch_fire();
> > +       pr_info("buf[0]:%lld\n", buffer[0]);
> > +
> > +       barrier_data(buffer);
> > +       pr_info("exit of %s\n", __func__);
> > +}
> > +
> > +
> > +static ssize_t test_proc_write(struct file *file, const char __user *buffer,
> > +                              size_t count, loff_t *pos)
> > +{
> > +       char cmd[256];
> > +       int test_num;
> > +
> > +       if (count >= sizeof(cmd))
> > +               return -EINVAL;
> > +
> > +       if (copy_from_user(cmd, buffer, count))
> > +               return -EFAULT;
> > +
> > +       cmd[count] = '\0';
> > +       strim(cmd);
> > +
> > +       pr_info("received command: %s\n", cmd);
> > +
> > +       if (sscanf(cmd, "test%d", &test_num) == 1) {
> > +               switch (test_num) {
> > +               case 0:
> > +                       test_watch_fire();
> > +                       break;
> > +               default:
> > +                       pr_err("Unknown test number %d\n", test_num);
> > +                       return -EINVAL;
> > +               }
> > +       } else {
> > +               pr_err("invalid command format. Use 'testN'.\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       return count;
> > +}
> > +
> > +static ssize_t test_proc_read(struct file *file, char __user *buffer,
> > +                             size_t count, loff_t *pos)
> > +{
> > +       static const char usage[] = "KStackWatch Simplified Test Module\n"
> > +                                   "============ usage ==============\n"
> > +                                   "Usage:\n"
> > +                                   "echo test{i} > /proc/kstackwatch_test\n"
> > +                                   " test0 - test watch fire\n";
> > +
> > +       return simple_read_from_buffer(buffer, count, pos, usage,
> > +                                      strlen(usage));
> > +}
> > +
> > +static const struct proc_ops test_proc_ops = {
> > +       .proc_read = test_proc_read,
> > +       .proc_write = test_proc_write,
> > +};
> > +
> > +static int __init kstackwatch_test_init(void)
> > +{
> > +       test_proc = proc_create("kstackwatch_test", 0600, NULL, &test_proc_ops);
> > +       if (!test_proc) {
> > +               pr_err("Failed to create proc entry\n");
> > +               return -ENOMEM;
> > +       }
> > +       pr_info("module loaded\n");
> > +       return 0;
> > +}
> > +
> > +static void __exit kstackwatch_test_exit(void)
> > +{
> > +       if (test_proc)
> > +               remove_proc_entry("kstackwatch_test", NULL);
> > +       pr_info("module unloaded\n");
> > +}
> > +
> > +module_init(kstackwatch_test_init);
> > +module_exit(kstackwatch_test_exit);
> > +
> > +MODULE_AUTHOR("Jinchao Wang");
> > +MODULE_DESCRIPTION("Simple KStackWatch Test Module");
> > +MODULE_LICENSE("GPL");
> > --
> > 2.43.0
> >
> > --
> > You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250924115931.197077-2-wangjinchao600%40gmail.com.

-- 
Jinchao

