Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F56ACCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8C18E006E; Thu,  9 Oct 2025 05:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0218E0002; Thu,  9 Oct 2025 05:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5AA8E006E; Thu,  9 Oct 2025 05:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 49B1A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:13:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 520031A06F6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:13:02 +0000 (UTC)
X-FDA: 83978011404.17.9D29E1D
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A27810000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:13:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/nD9o3V";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760001180; a=rsa-sha256;
	cv=none;
	b=089mPe1Sh1XUcGuBV6X4hroxUEFDaCcLsL1k7R6awsr0p41FRq0YVtjq+ATqE1WfIrInxe
	Eo1hCvk/bNx/rjILAUYInqHLs+RQuuZ7OMqxnZK9UzkX0Y2sFA3uOKC1avN3ExqZScsovM
	nf65a0UNMkmDNmxqc6k2kqXllJl8/+s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/nD9o3V";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760001180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noGJIDsEGpbT4mVPtLItOHBIizt5I7YMxK5vpTBOvYc=;
	b=qRuYc9mCNzVinbuIBKxcW38gxhneggC5O7JnFKR7ev/5HNKfTLXrNXkByTD9hgF55y1CDj
	A4iWpoSevvpiImfsN1FIpX9G4HNCxLP5RSCT19JvKB9QP3UpScl10xxoYgoHxpLSEXpyM7
	j/OBiee8gUsvjkc1DNOjhDNCPDuexgs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-271d1305ad7so11925255ad.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 02:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760001179; x=1760605979; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=noGJIDsEGpbT4mVPtLItOHBIizt5I7YMxK5vpTBOvYc=;
        b=M/nD9o3V1LWfR/L7fo7thR+T6ZFtggw2KW/Zwdb6RLaFNQjbZZ5KcLJAaBIZ4f+KKr
         fuWvIPQBV9aJwCJLOnXXVjJShcvnJhFuFURS1Xi99nYU35ik1T5jqltZcJU40MODJW6x
         wKvVQl+rV8gEspFdUS+ky05Bbxzwzw8DVpKgwfNT45j7bNlqHQ9YhcanqsPbzst/9UQY
         ym5cjSfoTNTxpVmJhiNgye7x2A7HAR8Fnuv1e8Za8bZdBHfCHVh+k/DAoYlYl5TUpUtT
         cr8KDISvk4RJ3TZFuqSO5jPuF9F069gKdSeXpSbMkuhXjVCqYQLpal80j9RdQ4VQC1mJ
         figQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760001179; x=1760605979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noGJIDsEGpbT4mVPtLItOHBIizt5I7YMxK5vpTBOvYc=;
        b=ZQq0l2PUO0TyueORo4OsbJw0iJ4xGxUJoZlq+0J29wAKrCEG+X8IawtP21uAkb25Og
         KuQOBC5cmQyM3Qo6bkdvBwHhWAmJY45OgjhCuMCN++O6siQ+uWAWw1N6BRmPWi6/rXIU
         Z/o7lwuE6e7QxvNi2C2G5FbMOiilbaBpaKQen5Zzn3Yymh/BrizHynw2hjjxI+WnvKPK
         ZvNIa36t9z/bVEzRPjiYrxp37V2Z2ODhpZZ8U6ZFKM4TANMqJc5yFazEkI/gCp84R+h8
         QLMUH7w2SCcnUWdJ0yFAUovp3JqbDyPUxrq70vCTWq28NHLX5Q8+d4OSW8ZGsYFAXQEH
         7Yeg==
X-Forwarded-Encrypted: i=1; AJvYcCWGYFzhnXSwNbkMWwwi1u0RwdhUywQvUrO8zUKd0A1f3ubSbmSdowdQOQbx2XlLGRf1QoWR06652g==@kvack.org
X-Gm-Message-State: AOJu0YxwBx/34JLj1TQITawbMdXCSxUh9EXAjrtDrVBqG/ZGkf5PGjNh
	tHzFXaLRJp2Txz+nr03ow629iOsgQ83toh0wtpQrpf1hlweWbgzFNCWJ
X-Gm-Gg: ASbGncvl9UZFeB5UioSa19hZymyu1EdeASVcP7VRQxmclC4MRW5xGFh+hDQ0M6SbR08
	XswCW9oo1IapGbvOoGhG+R7Af3dHS7c07OmPDSbBkjZHCMpeKfdqaAwgXlSPLhT//5oC81Ck+3k
	Medc1YH2LaOwDS3i9NP29Agh8hGHEvXpujrkB/TuAEghIaikP6b1+7Z3Zmx5yh+mAc6t7B/8k0B
	K8KZAZGrMQxLSIrlwifdBljM/BWmQL1ZrF4KsKQoodyGn8Q7MHPlXhzFt9xPx1TU15nzzUwtsVy
	RJ33YUvmf1vN8WMe7Ubk+VkXRO1m+kkiz0RhOhAXytLPJ40oX89EjA5fHG0p1LY6cjzzhuvtrem
	taLpIVoP6QQAmWVeRUy5FvypyTlZK6D0xUU9dty2bImmyS0CIsEa+0+nZtcc2QQ==
X-Google-Smtp-Source: AGHT+IGgc722wX6cnZ4WMCp7pNtwV85yDs1WMyb3Ue3/XLDo0+KBsbutwCUcBiVTue/uMgVkYBWZbg==
X-Received: by 2002:a17:903:8cc:b0:267:9c2f:4655 with SMTP id d9443c01a7336-290273ffcf6mr78713905ad.41.1760001179036;
        Thu, 09 Oct 2025 02:12:59 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f3de4asm22026565ad.92.2025.10.09.02.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 02:12:58 -0700 (PDT)
Date: Thu, 9 Oct 2025 17:12:50 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v6 23/23] MAINTAINERS: add entry for KStackWatch
Message-ID: <aOd8kvWYIROq99vx@mdev>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
 <20250930024402.1043776-24-wangjinchao600@gmail.com>
 <3913273d-12e2-426f-aec7-263b7f49008a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3913273d-12e2-426f-aec7-263b7f49008a@infradead.org>
X-Stat-Signature: o4goqskk8cd7xhezxk8449bygqt98ukk
X-Rspamd-Queue-Id: 6A27810000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760001180-545065
X-HE-Meta: U2FsdGVkX19mgYqy5qP2Pw+qXeHLob4NJK3jg9a69syS2tGk1C7ltqImmc5MjaTAwtt/N7OTou0Vc31Kc3G2eSqNiWx8dpnh+6/rDF5Nqp6lCbGDA8NJeshzojlRgvJUvU9TCHlKlpOVewA01u2Bl4EDw/NyuNy+Alwm041AIj2Vb1vptWDpVCnWc9XTiCR1BQbrjzIUJQkbMY1ACMxa5sHeQgr2RbFRvI2CjPZCcc5ut7jfw+MYUKkHbG3wS2mnn8TGRXgaX3lhyFfkMHJxz2ah/ytuzOLz1pdCCHkYntZnrE2TU/Gvl9xJ845lG56WyHy+D8FxyX5bLjNr6sy4Yvd7MH5xq79ghFFXBtpqWFMkVIpLkra1BHiUxHMz/QTqFOJ1p5KD6fT9S6j/A7VKq9SDYwmcNJVY/fkydMSIPdSzeItHpVucweLgRJF5a+KQ0J2ah5NoNhopwsxM3THOOQOAc+P2P62L+MJHL1YTpbaPGRbqhgx55KBSO6731FeWCQzCFJI60dqWol6aLCdig6UBSvVVk8f4iSe+DxNYaiIB10JtTtL4ccUxb5mOL0XOPGxHs5dX4R/SsLU8pKf6MRndENgQhwFZ9iuD8ceZPqWB831PSWFs2hHzSSk99duoCj1mRGj2z2SWp6mMeIDdo/ykuOBarmepMc6pVxEarstq4YqUad9SdMFgGQzJBEsRUtE+5UiVWXFR5rUrYRXaa9UvEt7zqkkV8wi9UR+DtHZgdf5UQfVB1DmsPGp9vM3Syh4HlhgVhNmzSsdpShNM8JFoCkTfgaryNrXMqwXXiX0RUdhgIiKAbedmFkSv72kWK3Ypouq17Uufd2jz33414iFCWY/M9UWjHDDe4v9k2l2MIApi4uXliBfMuRveWkr6lwSyiaT17TemqmMfQmGbOwTg8TKco7y9OsNVdIqhXBnRlVEUc1KgbhSBviwDGqWqiqrI/J/VrUyJjFww/12
 apfCiFPb
 2fiSwtRSBwtzT8gQlQmnbbJzJvUhevhOLM8Yrm9Nu4ivIeDF6ulpViKjIMUghmQzvKi70MhUilgGUIU6wDe7OQ7yJHYKpMpUc+/JVOvIvst20BqGkAPdj4by83w0d2K0Ai4m58F69Q5/ZLhv//da291bq2hgVBgLxREKETsSr6kpuyr6jiNKdLdU7YolwPYAFFfEtN7sHblZMHRX7605v4O+aobJw/I0uBh/hoMs/zihtum+uhcmwXnjwocTNf9txO4h+7hEnsvW/+CNpFccgIUM6J60ajM8/OAzyfA3Q4CzJXfRzFH3As2jJY6t3I8anyT/QtC+sh1uSpcffDT733zGDyONn+Kwk34Dipf6NU8zy+pSIquBvd2C/p54k9FohdBMU2sgPSkQf9W1o1GSmJWOwamrz1arlxU/JIc+EKQ6d0YnlxGeRlAT+Tdkn7/v/eCJPpqreG3HM0YEoCCzgEdozyWYXKyW6YLcos9uUmICVMDRppvjHlItgQrG6Lww1igRwAC3ti/VACrpZhzpq15eP3XKq1McnkOODAR2Gb0AzWGMaxFPpvXOG94mg3YsthcpVBXbT3CoRAaaVVyLTTGFOrca9vqWc1TyED1NQ9mPTBIZujGfm88MtmVcjGNQaGmZ5/DWhDbjcV/JdRYsmYX/ukbLSX6+A5kerlDRFIJqOwOeQjk4h+b7hQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 01:50:43PM -0700, Randy Dunlap wrote:
> Hi,
> 
> On 9/29/25 7:43 PM, Jinchao Wang wrote:
> > Add a maintainer entry for Kernel Stack Watch.
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 520fb4e379a3..3d4811ff3631 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -13362,6 +13362,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git
> >  F:	Documentation/dev-tools/kselftest*
> >  F:	tools/testing/selftests/
> >  
> > +KERNEL STACK WATCH
> > +M:	Jinchao Wang <wangjinchao600@gmail.com>
> > +S:	Maintained
> > +F:	Documentation/dev-tools/kstackwatch.rst
> > +F:	include/linux/kstackwatch_types.h
> > +F:	mm/kstackwatch/
> > +F:	tools/kstackwatch/
> > +
> 
> Add entries in alphabetical order, please.
> 
> >  KERNEL SMB3 SERVER (KSMBD)
> >  M:	Namjae Jeon <linkinjeon@kernel.org>
> >  M:	Namjae Jeon <linkinjeon@samba.org>
> 
Thanks, will be fixed in next version.
> -- 
> ~Randy
> 

-- 
Jinchao

