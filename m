Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB90CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329298E0021; Wed, 24 Sep 2025 16:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD458E001E; Wed, 24 Sep 2025 16:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213328E0021; Wed, 24 Sep 2025 16:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 108428E001E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:50:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4FE956E57
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:50:16 +0000 (UTC)
X-FDA: 83925336432.05.5E80417
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id D5B562000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:50:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ewj7azEp;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758747014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUtonTzH+d6Koc9tBSC0pPXzcPpJLfBt1hfJF5PLabQ=;
	b=DzWDw+8kSnPi4Cgkk42wsKOwyl24pCQq9xA/rv9SjEKARinv/CevM3UCY6YQK9Jqsaa779
	lzzNCVEQX+GI3RB6SXYy72jvxpRIeKdUUkBLQTr3X7UuoK0r7g+LOpanCeRy8GHE7r39vn
	Y+9G6hy17hDc8ap+wMC4elMH8UpxfMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758747014; a=rsa-sha256;
	cv=none;
	b=gqOku+rqX2gy9kGSlRafcHxVwGSmpjr7RteuE7D4DnvTRhsKuM/9kzwS7Og70soqvory6X
	LWeGVUYC8icaD7XElxppjMo8IKYvpHhh9ZmdOL/lmuL10WdM+6ZegMB/W10pdomg1UdrCT
	hgJv2xG0BFpFHhlLd8Pa9FrlTczyews=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ewj7azEp;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4fb8d3a2dbso197406a12.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758747013; x=1759351813; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yUtonTzH+d6Koc9tBSC0pPXzcPpJLfBt1hfJF5PLabQ=;
        b=ewj7azEpG/4kZ5xmLxUbyjFEo3o5VoEx0XE6YH9OAHN5OsF76TADjqW8VBEC3vxSg2
         /+96stE1Gvq0LvwoAxW/Ey6JMHGS5iZqf3l5sGT64y5ws8wsCUi1xUd3/9fru4iW6RST
         lhADBJ9eUOZRRgjz4xombMJpjrN5mecbVDn5DXJHLJXEGVtnfY9oOjV9TxcvAO7cToem
         jGKrB1ZAMH8IpHvQVp6/4eQ5FnbfxyiIOQJg8KPq1reNfqukvRYe0Pz484NFl0u3iA0s
         ByaFUUxADMbrEyeOGvisREwjQETtC0HQgtUbSDz4jfX8+GtZO3lRDsOBJpugxdKxUpho
         vlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758747013; x=1759351813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yUtonTzH+d6Koc9tBSC0pPXzcPpJLfBt1hfJF5PLabQ=;
        b=J/YEgQv7u+m2EgaMAFqTD5mCg90ay3cFlOZB35jbe2moLSRNChP7MBia8daBU1qLQ2
         A/6Y/DA4K3ICanWB/wn/Cb0jpG2+tEstzxR7hWo1bc79yTsZodEZQjx3hpmWPHP+l7FP
         4e6gZNMSolVYBP3tJk+j4QC9OacfMD/NJ9zsFiYb0hDHsEkieGlSiwSk6o42rsFoHj5l
         Gy7H6Ibua13EFlRlZnA6db+OxMi4qmlJsUrD7vyQMnOq0IThJQGpTfws3F/dtG7fJ+W+
         u19cF4RPPbSoo4UP1wtkWf3Mf8qqSvYPAhXsXvJqIFFO80flN5nSmv95nCkYlrRbabKH
         fz3A==
X-Forwarded-Encrypted: i=1; AJvYcCUmIWL94sW+X45pWTWQ5AlbqqHk6aTLk8wdcC764bmLWK5i+2I//SrdIUVGkMxQdmuxhD9rQewa6A==@kvack.org
X-Gm-Message-State: AOJu0Yxq2k4JiwkySuwjOfIyFoECZs8xCaRMWOF+1tv3KGiISXu4AaiX
	XiJXwJuNRt9YFnohdhdJW69nbxC97UQM2AS/lpNZV1CWZYBPXFp1VdZKUHVdSI6QZ1RShEN/U6w
	kZugZXVIhYzhMcuqmQbJK7I1VdNZsnKtqidz+9pgd
X-Gm-Gg: ASbGncu3mBnpQ/lcxeRvchzGrUu++xdOt+q4I65AikcurPaLHIkVK/lBy9DwArBiBsd
	AB/lscSbDkt7GR/29LNSaBEq0cXuxUtq8BcnJCv8wr1ER95/dbB3gCwVcQ6rI7+7ZqpC/joenA+
	xJ/+CZt0sCteSwmGmkP9ttKTnJClUFuDRuLGaahkVbZRR7CyXRgsx5HTj9YA48FbAu3lxTGtUrT
	lkQF47nMkGe0H4qhf5LDx8v6WFoVjZM0gmNUyZdnw0pz7+2MuptwYI=
X-Google-Smtp-Source: AGHT+IE38fi+Fg0q1j7Ol0QGEtgHPSQpfsofFwHAAg/Zt4ZhCmzeJrbUHHkyUG+gDW1YXxPVgRa+tkuyDrRHf/9act4=
X-Received: by 2002:a17:903:264b:b0:269:8059:83ab with SMTP id
 d9443c01a7336-27ed4ab545emr6206725ad.51.1758747013201; Wed, 24 Sep 2025
 13:50:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250924115124.194940-1-wangjinchao600@gmail.com> <20250924115124.194940-7-wangjinchao600@gmail.com>
In-Reply-To: <20250924115124.194940-7-wangjinchao600@gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 24 Sep 2025 22:49:35 +0200
X-Gm-Features: AS18NWBgUAm60x7jbnTDK3WCQpUXDCFu_1mbN9k4BD6qrp1olQW-5h-0n2U9Y9E
Message-ID: <CANpmjNOuA3q3BweB9kTUpAX4CX1U25Pqa0Hiyt__=7zio81=Uw@mail.gmail.com>
Subject: Re: [PATCH v5 06/23] mm/ksw: add singleton /proc/kstackwatch interface
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
X-Stat-Signature: 9udbkhhcrfy5qd44g8rdxq8bgyzhc84p
X-Rspamd-Queue-Id: D5B562000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758747014-605957
X-HE-Meta: U2FsdGVkX1/6Fl62dLMARhF/DRvHLuEsI2FSV7LpcAFlVwncycZwSQgbMq25jLZBLQzCiDr5KOjqz3l0Mhl7DqK5gL4kNf7ZLeI2Kju4C2JQbsC7FMTsLCR686ptS8YoeQibuc70e73NRnBlWWiq3yum661SmjRTOWJWWBMDtIPKAKPKKkhH1DgLM+Y05d4OmDrpwm/3WpFRpL/3+OsPS0yXospMSgw4d5gFkgJXva3tM3q+plXFl3qh8LAjSxJZ8M8xeRWSiwfsj3KmQlK6tPOY42nVoKcwlccvdAylFzXV/gO3xrlHEfH/tH2qOP4JhKuCnZXzHwzHwJBXXDbZoNUaw9RLcEfnVW3vOHadT3sKHNc/DxIC+D1m7siR5b09y7jTwTS+2vDgCNxcpxyThD854DHOnuzL9w4Dqk54TLYafvWX5FxweOLBEj4tQD1jWhSzcbNjz7qz48UFiL8o4SMD0Qfq1CK2qrPDzzpY6y/+Rnrn8pUsbarICNyfxZ7iDutykkDSU/7GYlzf7h7uE16PsI8X+ZX+ZGVEQNo7QNP6R8qmkvnhZr2S0TrsdXgLi79SUWIl6duF8pX0qH2KFZsZaQX1AmmAyfm/CJstfa0h2Id2hhwOv0CjRrrOBcdJ5cxcV5yMHzVsXbzvlxslHRpW07S7xLALzFFEC5opGUl/jTWLSKTYbBYaoWt2o7A8AXJPBw+x6KXTaAekBEI6C9W2uKMBXkuLaud6Uw+vQloX8HjugUyx6oqFibTBMhjC3yvCJxFVTfQsDY3rnBMqiOPfTY07ce7G6k4jy2t9SkFP8GoFMikBjHMkgZgs58M2YXC/x0JOCAjw3vZ1Xh8iZSyVfKniF/05Ec1nQxFpTRy2nAioJ6t2sc3WesJAf8+nrejbFrjbOIHXUW8aiIs+GD5p6xS3jn9Kf6uli1jB4emBWmEs/R0P63Z1YtKEF0vY1Dc7cGMLkPWcUJEykWe
 D+eQZ6rv
 PJ75B/WHHGcjKetHSATMfhrGwTiXM+zgJV3058+b0UxOAjDXx4YQ+9m82IKW9M4nuXOeetl+DWc6mERhFsthmO0DbrtMJRMBiT8qpAz614UJJm5H7aknkZf1uJZze2yo3Fb9QkwqrxYoCEb33nmNlV6oCCfAzWSO4rAznuoDcoxonR3d2IqxNuOmk9fiWi3oY3VHrtNbh5d7EafTCvbBvToa+zoyaaeVdP5jvxGcQ67hI0UQ5M7HBPpqMhz5AA4tX3i23BIY+N1gukjRxl6XLljG/8b7qOkcbaJysUG2CPjQZXmTdvyXn+q3cQ9zNMclDflAlFTTVL5qbiNdn+ps4d2s3HW2Nr8oy2iSzckbu1DU/ABPleRLK2YAn1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sept 2025 at 13:51, Jinchao Wang <wangjinchao600@gmail.com> wrote:
>
> Provide the /proc/kstackwatch file to read or update the configuration.
> Only a single process can open this file at a time, enforced using atomic
> config_file_busy, to prevent concurrent access.

Why is this in /proc and not debugfs?

> ksw_get_config() exposes the configuration pointer as const.
>
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  mm/kstackwatch/kernel.c      | 77 +++++++++++++++++++++++++++++++++++-
>  mm/kstackwatch/kstackwatch.h |  3 ++
>  2 files changed, 79 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
> index 3b7009033dd4..4a06ddadd9c7 100644
> --- a/mm/kstackwatch/kernel.c
> +++ b/mm/kstackwatch/kernel.c
> @@ -3,11 +3,15 @@
>
>  #include <linux/kstrtox.h>
>  #include <linux/module.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
>  #include <linux/string.h>
> +#include <linux/uaccess.h>
>
>  #include "kstackwatch.h"
>
>  static struct ksw_config *ksw_config;
> +static atomic_t config_file_busy = ATOMIC_INIT(0);
>
>  struct param_map {
>         const char *name;       /* long name */
> @@ -74,7 +78,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
>   * - sp_offset  |so (u16) : offset from stack pointer at func_offset
>   * - watch_len  |wl (u16) : watch length (1,2,4,8)
>   */
> -static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
> +static int ksw_parse_config(char *buf, struct ksw_config *config)
>  {
>         char *part, *key, *val;
>         int ret;
> @@ -109,18 +113,89 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
>         return 0;
>  }
>
> +static ssize_t kstackwatch_proc_write(struct file *file,
> +                                     const char __user *buffer, size_t count,
> +                                     loff_t *pos)
> +{
> +       char input[MAX_CONFIG_STR_LEN];
> +       int ret;
> +
> +       if (count == 0 || count >= sizeof(input))
> +               return -EINVAL;
> +
> +       if (copy_from_user(input, buffer, count))
> +               return -EFAULT;
> +
> +       input[count] = '\0';
> +       strim(input);
> +
> +       if (!strlen(input)) {
> +               pr_info("config cleared\n");
> +               return count;
> +       }
> +
> +       ret = ksw_parse_config(input, ksw_config);
> +       if (ret) {
> +               pr_err("Failed to parse config %d\n", ret);
> +               return ret;
> +       }
> +
> +       return count;
> +}
> +
> +static int kstackwatch_proc_show(struct seq_file *m, void *v)
> +{
> +       seq_printf(m, "%s\n", ksw_config->user_input);
> +       return 0;
> +}
> +
> +static int kstackwatch_proc_open(struct inode *inode, struct file *file)
> +{
> +       if (atomic_cmpxchg(&config_file_busy, 0, 1))
> +               return -EBUSY;
> +
> +       return single_open(file, kstackwatch_proc_show, NULL);
> +}
> +
> +static int kstackwatch_proc_release(struct inode *inode, struct file *file)
> +{
> +       atomic_set(&config_file_busy, 0);
> +       return single_release(inode, file);
> +}
> +
> +static const struct proc_ops kstackwatch_proc_ops = {
> +       .proc_open = kstackwatch_proc_open,
> +       .proc_read = seq_read,
> +       .proc_write = kstackwatch_proc_write,
> +       .proc_lseek = seq_lseek,
> +       .proc_release = kstackwatch_proc_release,
> +};
> +
> +const struct ksw_config *ksw_get_config(void)
> +{
> +       return ksw_config;
> +}
>  static int __init kstackwatch_init(void)
>  {
>         ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
>         if (!ksw_config)
>                 return -ENOMEM;
>
> +       if (!proc_create("kstackwatch", 0600, NULL, &kstackwatch_proc_ops)) {
> +               pr_err("create proc kstackwatch fail");
> +               kfree(ksw_config);
> +               return -ENOMEM;
> +       }
> +
>         pr_info("module loaded\n");
>         return 0;
>  }
>
>  static void __exit kstackwatch_exit(void)
>  {
> +       remove_proc_entry("kstackwatch", NULL);
> +       kfree(ksw_config->func_name);
> +       kfree(ksw_config->user_input);
>         kfree(ksw_config);
>
>         pr_info("module unloaded\n");
> diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
> index a7bad207f863..983125d5cf18 100644
> --- a/mm/kstackwatch/kstackwatch.h
> +++ b/mm/kstackwatch/kstackwatch.h
> @@ -29,4 +29,7 @@ struct ksw_config {
>         char *user_input;
>  };
>
> +// singleton, only modified in kernel.c
> +const struct ksw_config *ksw_get_config(void);
> +
>  #endif /* _KSTACKWATCH_H */
> --
> 2.43.0
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250924115124.194940-7-wangjinchao600%40gmail.com.

