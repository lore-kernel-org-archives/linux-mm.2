Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144E5CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECF38E0010; Wed, 24 Sep 2025 22:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4218E0001; Wed, 24 Sep 2025 22:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B36C8E0010; Wed, 24 Sep 2025 22:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3809C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:07:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBC0D1A0208
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:07:32 +0000 (UTC)
X-FDA: 83926135944.25.680FC34
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0B8391C000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:07:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7HDxj8D;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758766051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3v0KAw/a5VLZK8q/426U2Svx1Ly/zqTFJD1qMEvdMs=;
	b=vHQzJ3EF4nGfqMhb2VF3aa0av40dAf8fPpFGnl3kFkyt4qRtYUdP+m6XlBTVhtAVr8/miw
	n2lDS7eCwDnPJ7dzLka9WFzuspVExzwBf6ZyBlOrebPmeVoHq4SPfXf2xhcZF7fgzRH9KF
	ek9V7FNVZtCXYUyDRID2obeGNlIDeyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758766051; a=rsa-sha256;
	cv=none;
	b=SnJj6TWZy2eEI0yQdi723WnhXlu751woRf9slX+uWSQORX7LwQa7UgmNC6h0QRQUA4B5Yr
	VR4TuNyrPbU8oo0csIHTq20Nc58jRtSuLAUjYXluK2cIBEvJBEZ5EcAr+bC+xbm10dgEeW
	UXX4eL30is8SlMr8CJJCtkekn+9yB6U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7HDxj8D;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso291343a12.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758766050; x=1759370850; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z3v0KAw/a5VLZK8q/426U2Svx1Ly/zqTFJD1qMEvdMs=;
        b=Q7HDxj8DivVYVnc+Yh70MgHaEcBUfdOehptVXeuGlzkTUB5xEyJDgktKHQLRgtX4I+
         xjcR9tJLe2fsd81wqxK+aC7Uxidb4Nxe7ox+992MSrnlflEWT6dor/wHgZ41cciWifnO
         A+yDTA+loJHl7GJW2HBXFIhGP8hQ+AqENvBlkGuFtJi+VN2rfrZdTz5eejMDZHDqkBNB
         ZH0OgCcNtfE72dNGXLfCYB6aw9P42Acb5fgmvfxbXhEoAnfZMXxVVZyhzkdb6M7jLdlm
         tJjuNpDyUtsr4v8DQwBrAWT8/gb7NiDXAjqYXosUwKNG9KyvocwTZH0GXVtmJKRwJK+1
         Vh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758766050; x=1759370850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z3v0KAw/a5VLZK8q/426U2Svx1Ly/zqTFJD1qMEvdMs=;
        b=UZZpx2YXTGx5BXkw8JfKZDZ0IlYR+uws7SnVg1ReVGXLAUGqbW5cta/MT3L52wleR5
         ehyaGY8Sxc3kJz5YGsVV5PF1q/KgnNfs4U4Eo7ofbDbGC2RVhzQW0NPF8/PJdiXp07du
         3wUIRbfukVjpf/fYhc0+Ocx1j8v9/xk+gRmgGFGlPhgsFqCi67BEwlUu/CdQRtc1Ms1+
         aAsAuYHCDUEuRmtwD4uvaVEPS/BP/9rKmFfw3FL1zqNScpaz3i9egAS0mDWy3B2Kq53v
         UBwKp6FrJdj/SnQyTfkjmPeadLxWdWuSSWDuLOw1AMSMGT0XHk2mFw553V2WEDouV0M+
         6MdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzm8JhW8ldSxu1IgPa+OZAvXlmlxiRteh0llh7rquEvHV5scZ91jai+3tajU367Mmg8VHx12xDcg==@kvack.org
X-Gm-Message-State: AOJu0Yz8LEEqTOQyOfEyMsCaj5o/aRhEMvUHSNpVLehOzWPjdR2K/ho5
	KuOsM9cxHqJZcwjy6ePK1XAyyXp+wR6LaJG5WLjFRE9aqqdJrsip2qUU
X-Gm-Gg: ASbGncsW+VwEdKEIsXADwRUTc1gPo3DjRu2mNiRtNks9M+LxIj7EU+thSXwzeqP34bF
	aicgwEBBuhtjYVwgNIb+BNYRqr/uJ2XptPE8KrKoWg88JZX2u83Jc/oBdILPgCWSdt32Z5Xwhd1
	fy5zRk41Mmo7o9UYgLoL/c3BwBYJDsEMieTdi/tlejpEJXuW6IYLnihAkqO621+h0luIyKBGFOq
	z5mCoF02WeX2vCjxy0pcNkBi4Yzh3ifl3G9X+d5H92GGhi+KkXyfrSG1WbbVLu2yjLvKwJIqv7H
	7cuWmsPVduzU7729ryNEN9liVW0l9phTQsgxX5BsYzJStqV7QCMzPdVAirII4XZ0Zod12qb8d7d
	8FkP0CJveqFrAAOBobFSSiWffiRKVDcIP4A==
X-Google-Smtp-Source: AGHT+IHZwY+E9Zl/mOnS/wW2XcXo5Et3bKXZYRlw/VXukF+oo1CmX+XrzU+9/LJydGwruFBdmu625g==
X-Received: by 2002:a17:902:fccf:b0:273:31fb:a872 with SMTP id d9443c01a7336-27ed4a06cefmr13125795ad.6.1758766049602;
        Wed, 24 Sep 2025 19:07:29 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6abff9fsm6469775ad.133.2025.09.24.19.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 19:07:28 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:07:26 +0800
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
Subject: Re: [PATCH v5 06/23] mm/ksw: add singleton /proc/kstackwatch
 interface
Message-ID: <aNSj3j1P9O-XWbRE@mdev>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115124.194940-7-wangjinchao600@gmail.com>
 <CANpmjNOuA3q3BweB9kTUpAX4CX1U25Pqa0Hiyt__=7zio81=Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOuA3q3BweB9kTUpAX4CX1U25Pqa0Hiyt__=7zio81=Uw@mail.gmail.com>
X-Rspamd-Queue-Id: 0B8391C000C
X-Stat-Signature: kpddqkhs4m753a1ffhbb7cgbcbgsduow
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758766050-525322
X-HE-Meta: U2FsdGVkX19SMtypsVHLFK7Oh5J2nebzf0JcMIl3JOHu8NcQA4Gss3XCVLxUEtEn+H0yMpYF3pOWjXPLonRK+jEKQS7WE/Aln8sxvTdUNj7Shg9g3sXCRz2vsmx17kBImN7/+NG78eV3IKwPwciY/ZuOG78s08LLkI1YnelOXTo7zjwDAdLUBr5zVu/DKnPj3138yZylpZFG9EJcHir87w7GSM/ZGfWmjOCqvdJcn08gI1Cq3e7Hcc7L/x880g+F6soz26EdHRaI8UYYzlWGINQnHCM2edK0OlLz13hRnfkmv9yxWuE2K9TBUy1ES5iYOnJ7ZPP5HgKukqqJfHptKl2zr5+JSGtIfp985KAfNvZVJ5e7d0I97o8Rja3YQzXzrNu3C82H4u0906XmMd61Xw78kVacaWA7HQubCq/lvLX+Nq9lWozpQbXYHN7tYPQXaY2/z7AHv7OTPfE6Asq99z6eCR+T9iT0n0fhYlJ17ZiQMPO1H+KSNOEC0JaOl6qCo1jOi5mahcobo57uP9JZIQXm2qVmMsQtziutP/mexzsIXbuKGtiaRlG1XQwjp53Wk3GSmTY6wMkFKHiHF/aB3mNVag9JQ2xzOlIlHkwLAPzNZNILVE/YH/c3SlHJUH/4K4F7grVmOvBYZg2nN3uHrOclY0J9BKrd1DWjQRNARTiT6xGdINkUsGTAxTmU0go2D4OTStj5+7H9pp43vJ1lEP2EYQpiPVTt7rjqBCaLXvfDHCi+Y1OACLJ6oEFd8m8KBA2PwrV/V/c1hjolJmMICx9oR+85GPPWo3GEJoGROIHV1uhRhHDkO/yg39d5sHRZns83BAMQBLwMFAmgw0nulQoVTgz3x8YnvajOUoZRcQvzuHUUoyik6N9bAzldMduWgoTTC5N59PkQz6euOw0lTRz+scn5jnzkuLuIJqSZdW503IdHz8ZrY7q79398gewmhLoIBDJYxxBA6nTAUUC
 4AO6U12o
 1l8XkevrWRFzq8Hm1Ij10xgrKyjkUWXo7jelJ8jKCms0aHe56tOjFEBXIPXxX9yXtDF7N01FRsBWJ11mifoRS/SAp8vEncrLguu4Gc/C7tmhTwW/H5Wl0HlLjN35c6ovIY8XXDMte8MY156J8PFtw4birDzx4eQXRZolTAWJs9AhWBrRiNukMlgO1VSTawEqka6Ie51+fn60zpKd3q8AXu2GUUJcheFswFJDbAO/WCQ+xkY2rIZB3uKVOXcDpRWNhNkg4oC23S6BW7Aom0+ShuBZWBtm2+8UFN8/p+MiYDD6h2IgqyhXyasFZuwb+6uQW2jxipgWoShh3mUc9yjdUB7U2t4v2v3CJhvzGRTAP09hKQsumwS7UhJ2lZYWCxpZCpfs/ztJOLkdPa2X7JxGhG23tLH+S8+MRSzo0+qq5j0xgoaay5ufKNXNbhSztHQSDCPWV2FckrSsianXZTanCL1KaQSLlPpgq+GfNrbLzLS8kjCKVOxm6TnPiG8s90wBWISdZAAn/5tq/HxEauiPCaVlevwYnBL7/gw96nhWAlwd04TmUR5Dt9YETJFhScwK7Eao+dwEcbJtiUjeSj2XeHUTPTaz1VOdyd8FMHOqcQ10Uog07EO6dlFitmDXmWZ2fHvy5GIYfQv76VapvCisYV9rWp3DfodeS28HyPyD3K0mm4HI/jyYbAwBbnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 10:49:35PM +0200, Marco Elver wrote:
> On Wed, 24 Sept 2025 at 13:51, Jinchao Wang <wangjinchao600@gmail.com> wrote:
> >
> > Provide the /proc/kstackwatch file to read or update the configuration.
> > Only a single process can open this file at a time, enforced using atomic
> > config_file_busy, to prevent concurrent access.
> 
> Why is this in /proc and not debugfs?
Thanks, will fix in next version.
> 
> > ksw_get_config() exposes the configuration pointer as const.
> >
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  mm/kstackwatch/kernel.c      | 77 +++++++++++++++++++++++++++++++++++-
> >  mm/kstackwatch/kstackwatch.h |  3 ++
> >  2 files changed, 79 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
> > index 3b7009033dd4..4a06ddadd9c7 100644
> > --- a/mm/kstackwatch/kernel.c
> > +++ b/mm/kstackwatch/kernel.c
> > @@ -3,11 +3,15 @@
> >
> >  #include <linux/kstrtox.h>
> >  #include <linux/module.h>
> > +#include <linux/proc_fs.h>
> > +#include <linux/seq_file.h>
> >  #include <linux/string.h>
> > +#include <linux/uaccess.h>
> >
> >  #include "kstackwatch.h"
> >
> >  static struct ksw_config *ksw_config;
> > +static atomic_t config_file_busy = ATOMIC_INIT(0);
> >
> >  struct param_map {
> >         const char *name;       /* long name */
> > @@ -74,7 +78,7 @@ static int ksw_parse_param(struct ksw_config *config, const char *key,
> >   * - sp_offset  |so (u16) : offset from stack pointer at func_offset
> >   * - watch_len  |wl (u16) : watch length (1,2,4,8)
> >   */
> > -static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
> > +static int ksw_parse_config(char *buf, struct ksw_config *config)
> >  {
> >         char *part, *key, *val;
> >         int ret;
> > @@ -109,18 +113,89 @@ static int __maybe_unused ksw_parse_config(char *buf, struct ksw_config *config)
> >         return 0;
> >  }
> >
> > +static ssize_t kstackwatch_proc_write(struct file *file,
> > +                                     const char __user *buffer, size_t count,
> > +                                     loff_t *pos)
> > +{
> > +       char input[MAX_CONFIG_STR_LEN];
> > +       int ret;
> > +
> > +       if (count == 0 || count >= sizeof(input))
> > +               return -EINVAL;
> > +
> > +       if (copy_from_user(input, buffer, count))
> > +               return -EFAULT;
> > +
> > +       input[count] = '\0';
> > +       strim(input);
> > +
> > +       if (!strlen(input)) {
> > +               pr_info("config cleared\n");
> > +               return count;
> > +       }
> > +
> > +       ret = ksw_parse_config(input, ksw_config);
> > +       if (ret) {
> > +               pr_err("Failed to parse config %d\n", ret);
> > +               return ret;
> > +       }
> > +
> > +       return count;
> > +}
> > +
> > +static int kstackwatch_proc_show(struct seq_file *m, void *v)
> > +{
> > +       seq_printf(m, "%s\n", ksw_config->user_input);
> > +       return 0;
> > +}
> > +
> > +static int kstackwatch_proc_open(struct inode *inode, struct file *file)
> > +{
> > +       if (atomic_cmpxchg(&config_file_busy, 0, 1))
> > +               return -EBUSY;
> > +
> > +       return single_open(file, kstackwatch_proc_show, NULL);
> > +}
> > +
> > +static int kstackwatch_proc_release(struct inode *inode, struct file *file)
> > +{
> > +       atomic_set(&config_file_busy, 0);
> > +       return single_release(inode, file);
> > +}
> > +
> > +static const struct proc_ops kstackwatch_proc_ops = {
> > +       .proc_open = kstackwatch_proc_open,
> > +       .proc_read = seq_read,
> > +       .proc_write = kstackwatch_proc_write,
> > +       .proc_lseek = seq_lseek,
> > +       .proc_release = kstackwatch_proc_release,
> > +};
> > +
> > +const struct ksw_config *ksw_get_config(void)
> > +{
> > +       return ksw_config;
> > +}
> >  static int __init kstackwatch_init(void)
> >  {
> >         ksw_config = kzalloc(sizeof(*ksw_config), GFP_KERNEL);
> >         if (!ksw_config)
> >                 return -ENOMEM;
> >
> > +       if (!proc_create("kstackwatch", 0600, NULL, &kstackwatch_proc_ops)) {
> > +               pr_err("create proc kstackwatch fail");
> > +               kfree(ksw_config);
> > +               return -ENOMEM;
> > +       }
> > +
> >         pr_info("module loaded\n");
> >         return 0;
> >  }
> >
> >  static void __exit kstackwatch_exit(void)
> >  {
> > +       remove_proc_entry("kstackwatch", NULL);
> > +       kfree(ksw_config->func_name);
> > +       kfree(ksw_config->user_input);
> >         kfree(ksw_config);
> >
> >         pr_info("module unloaded\n");
> > diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
> > index a7bad207f863..983125d5cf18 100644
> > --- a/mm/kstackwatch/kstackwatch.h
> > +++ b/mm/kstackwatch/kstackwatch.h
> > @@ -29,4 +29,7 @@ struct ksw_config {
> >         char *user_input;
> >  };
> >
> > +// singleton, only modified in kernel.c
> > +const struct ksw_config *ksw_get_config(void);
> > +
> >  #endif /* _KSTACKWATCH_H */
> > --
> > 2.43.0
> >
> > --
> > You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20250924115124.194940-7-wangjinchao600%40gmail.com.

-- 
Jinchao

