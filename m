Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10F8CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2228E0001; Wed, 24 Sep 2025 16:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9648E0021; Wed, 24 Sep 2025 16:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F073A8E0001; Wed, 24 Sep 2025 16:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE4C78E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:45:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4025139983
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:45:31 +0000 (UTC)
X-FDA: 83925324462.07.2C92761
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE1D7100009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:45:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TUae03s1;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1mp7LI1ysXg3EhsS9eEgLmna2zUSv012OjKVUUaPuY=;
	b=7Wf5vhWUCDbBD0IdOE4gBAYUaLK/mLvKi3s0BS6GnTaMoex0ADlgXqbmgXcqCGYG5qVf4f
	UYqb9gWsNsObGNzrVTZYR+MCWixxDKmmAJefO+EcTWdSPTJES67TSqCvale9lIcm4qnYDe
	LPM7mFLtapYFBx4YxqkJBKlfqbGOuUU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TUae03s1;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746730; a=rsa-sha256;
	cv=none;
	b=spgsIHzlaZNC4nFQGXfOH0OLwmcnDVXp5+kcjkbfeIxw9jk1/yjx6go7sarnpU9eDCKstI
	4iD5KHAMfLeqUxBwx2Mt5q1Y0y2TAvLsvu5SYCs7KlElssXNSXmeJWUB3I5eBOtSXDDEvT
	TSSuJzNgfgqFLSNtPtfZLs+PzmIDuXU=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-323266cdf64so272635a91.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758746728; x=1759351528; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w1mp7LI1ysXg3EhsS9eEgLmna2zUSv012OjKVUUaPuY=;
        b=TUae03s17c3VfEZ0OQ/hlTBtsjgQOehdTSD5P1VHFodIbzOL1FOlpqcgTATa18C/ym
         rWm/yRTpJFM+gXMsSfr9y4hUSP/7VlsSY6xBaVCpcRDmWXzwLb+1ijaqFNQsNx0biZNp
         LwK2KHAinUpChK85vv+JA9wnvTck8i9ZRJD/QC10d7mbdwtadIV+B6XQHzmofw7p2DLO
         l0n6LL9AnnmD9/QepVEyX55Eik1Hs7t/kk1VGpaoWDYDoqcImyrn3LphwUwFgIwZ139Q
         nQ7PvPvYvpRWj3y9CdDcZ3+RSz7YmWy/hy6/mKhvaY6VUVyQNGqdvZIXkgFU0OZhwZqd
         Ejqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758746729; x=1759351529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1mp7LI1ysXg3EhsS9eEgLmna2zUSv012OjKVUUaPuY=;
        b=Io9EMhOCqW+IMbRI/L7GM+uNxFueo0sTncIVmTG72eQhvF3/cdNLgP9dNMDWs/8ptk
         d3WtSaVM++KxtoI/LWUvNN+k+om38PoBfHNT8OtS1H/YTvcs33+fBj3cLQYMkzYiioQX
         4bgKGfNRAdqYU6lky5beAmeJmNw7aZmBJ7GdOsxWb19MxIW9SFBDf55sNTPmPzbchpr2
         Xnp3D9C+ejuf8PYmTrTeGKsmnPgHGtZp/4XH1HX7K3yQsv3BwlgE/aPStqX96HZuUhnD
         ZOk1eC5oNoGQMaDMKaciY4q3elw/TduSboem36m+PnNv12Uz6U+zBXBJuG3rURqA+yIX
         GaOA==
X-Forwarded-Encrypted: i=1; AJvYcCWYcUAGMlo4icRrrOVDjsz7vAQMBPRJ+g3hL7m26ZD+KPSpjo8YdZJx6tTgfBBWJuhS1hr11w+f4g==@kvack.org
X-Gm-Message-State: AOJu0YyIc0/N3PPDTwU2YwN0IsV0AR+8cl556XeGxa7IHkY96qP9yqwa
	MkRiAsm+K/BB1n1apTOMuTO+p+p6Y8ObY9KxBDKxAVBS28eMOColsXV4enCJShyhoOsmsyOs1qF
	dttXrYGJLUAns63bkcBcLQSrliqYAXGEAuM+EsLzk
X-Gm-Gg: ASbGncsup+vcFv/UOHk7UujCA4inF9SDXM47x419tla19d7+F+42Lev0sROrxlzyhKa
	IY5ZswtHSta1ZVuKguC2sMGpC82ry5k5eaKI/WIRjrUwx7nF6WmeWaEyrqXmgQ8kKYGk+HzAvLt
	kTUQsixpmjAPoPRA1wNyhu00g6GbvqVftH0nbJPysub+iPwqa40bwYgVUdNYdayoSZdNdDm7O+p
	6HqQ0O4icVzQYPatSpKe1fg4CIn+3bFkd8sU8Mtutrcc5hh2yfy0a8=
X-Google-Smtp-Source: AGHT+IG5FWt7iq/CV/zlunKOA9NXinKsoKdyEfBdiOZJ0QuQFE99G9zMO7C0YiiJ5ESmkgWunqzf9iW2ydB6TJVee/I=
X-Received: by 2002:a17:90b:2249:b0:32e:9da9:3e6c with SMTP id
 98e67ed59e1d1-3342a2f9230mr918488a91.23.1758746727946; Wed, 24 Sep 2025
 13:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com> <20250924115931.197077-2-wangjinchao600@gmail.com>
In-Reply-To: <20250924115931.197077-2-wangjinchao600@gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 24 Sep 2025 22:44:50 +0200
X-Gm-Features: AS18NWALn8StkZt7OAMLGvWBoEjnvi0uixTT5lbJc-ZUHb99wQUtu6-AQu7N2zA
Message-ID: <CANpmjNNnVx3=dQsoHL+T-95Z_iprCd3FXeYpnHdmi4d06X-x_g@mail.gmail.com>
Subject: Re: [PATCH v5 17/23] mm/ksw: add test module
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Liang, Kan" <kan.liang@linux.intel.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Sami Tolvanen <samitolvanen@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, Rong Xu <xur@google.com>, 
	Naveen N Rao <naveen@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Jinjie Ruan <ruanjinjie@huawei.com>, 
	Nam Cao <namcao@linutronix.de>, workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, "David S. Miller" <davem@davemloft.net>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mra3wnc7yg9yebuenxdzprs671pffat8
X-Rspam-User: 
X-Rspamd-Queue-Id: DE1D7100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758746729-102295
X-HE-Meta: U2FsdGVkX187zgqw93uE5rN8N1MzlHVoXyy1vRIqwZXGEsp5H9J2hrvf6A4pEWtRUv6sojZiwFGEZP+6Z8mDzniqBn9puleCUFmcAWUBSPfsgxGCVLuJwOglv6dAOFFiBiA8CtPfxhrmCh7sQhPXbQ7g93n5Eqle5/OWLXiUplbeo2SLwTggYvF+Vx1AUZkWey6/OteCrVWwyER7XmZ3eZ3wgPU70aiXmoqGc1vwlxIC9EtpUf+80Bo5FlHhFPt/obRo/ge7+z2jkmjQ837MzSy14KDt+fCOlhE3ku7feJZn9U6oKP/977PrW3JEk5pAmbmX2KCbiDYh7GnOEx1FZilUmri5X+6okWvu/w5zLx8G2q8aGR4bX36X6mAAr3LKD76oDvZ8wk5y2wFvDGPNiESeP2jtBTSGF4a9h/Un/i0hS8GdRu5GoLxf40ZvEEMoD0bfzlu64gpox39VAf1VkZNF4YwQ/XZqF78SBD4iuvOEUNnuFxmZ+VNv/EekgfCFdtpW6G3iNmCpIvux3gP9/P2eULRGwUt4f3m+OnHD1qDDGRpkMjOweSD9M82iQORibC9zwVCuGR1jQ8S8IbjBPVzRxY2Sx8tngkOj3ytjHzeSIr57fsckJK1Ntn4Z3o57vfAX88tdJpRan0+xksEUGkoEAZHTHZY8X+3uLVE+OhfytOG0+vSVu0Qq93hXuL9YNrrrfGFGh7fRwBvioCnWKWEh9np79LhMNQcnkWa914dVvCsz4FUvakqMaLsBcJ0FKOx84TqhS1xWhnV66rx5LRSVkRGFtS6d3uYxKqKXt160nTVbvHlanELhjZ++BMMs7Btas2FR+vhvW9zOXZxNX777nx8MKy+yMvle99lAOOcbxfIK/eTlFPi9yxcrWqOa4hzI8WgAYQMpTuS9IG5MPEaGePxb0QBpaTmSVxnyftaeOWwgEPVjKixvu01N3YcPcEQ+Wx5kduvf7dXjBbL
 X3oz8atQ
 4AV7wvfrLUjg/GGFJzZg0ZkSsSKRcGwv5SsJG2zPSMJ12zC8ZhQfqIfFfei5tDHLBjf0lNXv8HCnyOPeliFcPNlyzMncMzPgrDkHYKQX8UBPu4B51UFF2dI1mpQhd/WG+mkLPbxzT9VMQSGBQCx5kutNonvkG9MUomjULUMwbSM6jQl4i7B/5TxNHIRYhq2alQ4piDYqqVgdtltlp3e/ADEre+agnAUnAWZd1kn9KiODFIdhy+QR39GZ7Pv2Sw93SQxxg0vpoTfBwltz/TPov6dFLPJGO0qyHCryM8RfQXiORyjhIYfv+aL+fGwOImPbLnwiGrcRTcc8ey1wSpke35fW4z+iiUK5dYNB4w3oLQPrBDuSIj3Eayw79Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sept 2025 at 14:00, Jinchao Wang <wangjinchao600@gmail.com> wrote:
>
> Introduce a separate test module to validate functionality in controlled
> scenarios.
>
> The module provides a proc interface (/proc/kstackwatch_test) that allows
> triggering specific test cases via simple commands:
>
>   echo test0 > /proc/kstackwatch_test

This should not be in /proc/ - if anything, it should go into debugfs.

> Test module is built with optimizations disabled to ensure predictable
> behavior.
>
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/Kconfig.debug        |  10 ++++
>  mm/kstackwatch/Makefile |   6 ++
>  mm/kstackwatch/test.c   | 122 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 138 insertions(+)
>  create mode 100644 mm/kstackwatch/test.c
>
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 89be351c0be5..291dd8a78b98 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -317,3 +317,13 @@ config KSTACK_WATCH
>           A lightweight real-time debugging tool to detect stack corrupting.
>
>           If unsure, say N.
> +
> +config KSTACK_WATCH_TEST
> +       tristate "KStackWatch Test Module"
> +       depends on KSTACK_WATCH
> +       help
> +         This module provides controlled stack corruption scenarios to verify
> +         the functionality of KStackWatch. It is useful for development and
> +         validation of KStackWatch mechanism.
> +
> +         If unsure, say N.
> diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
> index 84a46cb9a766..d007b8dcd1c6 100644
> --- a/mm/kstackwatch/Makefile
> +++ b/mm/kstackwatch/Makefile
> @@ -1,2 +1,8 @@
>  obj-$(CONFIG_KSTACK_WATCH)     += kstackwatch.o
>  kstackwatch-y := kernel.o stack.o watch.o
> +
> +obj-$(CONFIG_KSTACK_WATCH_TEST)        += kstackwatch_test.o
> +kstackwatch_test-y := test.o
> +CFLAGS_test.o := -fno-inline \
> +               -fno-optimize-sibling-calls \
> +               -fno-pic -fno-pie -O0 -Og
> diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
> new file mode 100644
> index 000000000000..1ed98931cc51
> --- /dev/null
> +++ b/mm/kstackwatch/test.c
> @@ -0,0 +1,122 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/prandom.h>
> +#include <linux/printk.h>
> +#include <linux/proc_fs.h>
> +#include <linux/random.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/uaccess.h>
> +
> +#include "kstackwatch.h"
> +
> +static struct proc_dir_entry *test_proc;
> +
> +#define BUFFER_SIZE 16
> +#define MAX_DEPTH 6
> +
> +struct work_node {
> +       ulong *ptr;
> +       struct completion done;
> +       struct list_head list;
> +};
> +
> +static DECLARE_COMPLETION(work_res);
> +static DEFINE_MUTEX(work_mutex);
> +static LIST_HEAD(work_list);
> +
> +static void test_watch_fire(void)
> +{
> +       u64 buffer[BUFFER_SIZE] = { 0 };
> +
> +       pr_info("entry of %s\n", __func__);
> +       ksw_watch_show();
> +       ksw_watch_fire();
> +       pr_info("buf[0]:%lld\n", buffer[0]);
> +
> +       barrier_data(buffer);
> +       pr_info("exit of %s\n", __func__);
> +}
> +
> +
> +static ssize_t test_proc_write(struct file *file, const char __user *buffer,
> +                              size_t count, loff_t *pos)
> +{
> +       char cmd[256];
> +       int test_num;
> +
> +       if (count >= sizeof(cmd))
> +               return -EINVAL;
> +
> +       if (copy_from_user(cmd, buffer, count))
> +               return -EFAULT;
> +
> +       cmd[count] = '\0';
> +       strim(cmd);
> +
> +       pr_info("received command: %s\n", cmd);
> +
> +       if (sscanf(cmd, "test%d", &test_num) == 1) {
> +               switch (test_num) {
> +               case 0:
> +                       test_watch_fire();
> +                       break;
> +               default:
> +                       pr_err("Unknown test number %d\n", test_num);
> +                       return -EINVAL;
> +               }
> +       } else {
> +               pr_err("invalid command format. Use 'testN'.\n");
> +               return -EINVAL;
> +       }
> +
> +       return count;
> +}
> +
> +static ssize_t test_proc_read(struct file *file, char __user *buffer,
> +                             size_t count, loff_t *pos)
> +{
> +       static const char usage[] = "KStackWatch Simplified Test Module\n"
> +                                   "============ usage ==============\n"
> +                                   "Usage:\n"
> +                                   "echo test{i} > /proc/kstackwatch_test\n"
> +                                   " test0 - test watch fire\n";
> +
> +       return simple_read_from_buffer(buffer, count, pos, usage,
> +                                      strlen(usage));
> +}
> +
> +static const struct proc_ops test_proc_ops = {
> +       .proc_read = test_proc_read,
> +       .proc_write = test_proc_write,
> +};
> +
> +static int __init kstackwatch_test_init(void)
> +{
> +       test_proc = proc_create("kstackwatch_test", 0600, NULL, &test_proc_ops);
> +       if (!test_proc) {
> +               pr_err("Failed to create proc entry\n");
> +               return -ENOMEM;
> +       }
> +       pr_info("module loaded\n");
> +       return 0;
> +}
> +
> +static void __exit kstackwatch_test_exit(void)
> +{
> +       if (test_proc)
> +               remove_proc_entry("kstackwatch_test", NULL);
> +       pr_info("module unloaded\n");
> +}
> +
> +module_init(kstackwatch_test_init);
> +module_exit(kstackwatch_test_exit);
> +
> +MODULE_AUTHOR("Jinchao Wang");
> +MODULE_DESCRIPTION("Simple KStackWatch Test Module");
> +MODULE_LICENSE("GPL");
> --
> 2.43.0
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250924115931.197077-2-wangjinchao600%40gmail.com.

