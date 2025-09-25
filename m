Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFBECAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC158E0007; Wed, 24 Sep 2025 22:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D058E0001; Wed, 24 Sep 2025 22:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B8C8E0007; Wed, 24 Sep 2025 22:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 181918E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:05:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 677DB1A0251
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:05:37 +0000 (UTC)
X-FDA: 83926131114.21.2A7833E
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8415A100005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:05:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OBNlL0AT;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758765935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHHL33LsFFZTfiqVPHubJTFh9Ll2HmMvlyBTNdInq0Y=;
	b=tn8H3fjumxNYJ8jc3ZLwqV1tBKz7o3QSIw8JIsr7sJ42/dg+hqId7+8OSRHxmMZqTRGJb7
	U4GFEWeIPC2y/O+gbRphhfZi+gFDa97qPl1EZ0OgON95pAZ3vu0RnWppNX8C/D5iqwI9W2
	jqafZNdWfEJuHaTmmxnWy7ere4T9knI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758765935; a=rsa-sha256;
	cv=none;
	b=sk85czmyWkv2XbTgRAo/ehXZCfchguFDuGAFUuJXg69uzJJoAXvUpmsabrRq2cyQbDaXeu
	Zz5JEDKBczvBTHPVmOYS1vk2fOffpu2fkiyrFvK7KpFgwa6T2Ks8INZGQorzNE+rNPZWmt
	oup8myz31aAayI3U1qTrIomimhn4ctk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OBNlL0AT;
	spf=pass (imf05.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-279e2554c8fso4496645ad.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758765934; x=1759370734; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JHHL33LsFFZTfiqVPHubJTFh9Ll2HmMvlyBTNdInq0Y=;
        b=OBNlL0ATFO16qd5+rOstZS6XS0e2qyH8BZUPbX1KFV/97NvrrZzlj1W7sF90EYJiPD
         rd4nBOnk1an/sLoqYrchMrHNboeyJrRw10f7NEC4eiLdXGWE+jBgLmRSawdw0Sok/Jhq
         shgpkqrDOfox70LUF3fSVAgVv2isFlem/RyXSx8Am5Ulu7LpwjaYoq5vC1QFPYscuUz4
         zzirkghnvivijMTsDj91msnDmf+MjJYPFYP1v5XuNxpfez3LW8CvCLsBTzPPILeG0TDs
         F1NaQx1pjvNskBg992lP4CZTCSrgV0k/YAr6ml9nI780FMIM3/uaF1P8nY44/NlJPDOu
         IDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758765934; x=1759370734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHHL33LsFFZTfiqVPHubJTFh9Ll2HmMvlyBTNdInq0Y=;
        b=G1PQhzjgQan3QdyetzC+YlVAXBkJnWNNcMGhgET4zo+ncEjdwQwvm9pB+Ri9U/2lFr
         NpBqLM+thwPuepl/ADSl6VZmtK38EULCZdY5tOwaAZWfJ3WHRV9TcC6Dgtdbr+6AiGFk
         vR3Ss4UHc/qUy97d9l8NdHERhQ5csB3YYkPHysF4L1Th2gnCPAPxEHP2FaGX3lbj47kl
         Ou3RKFU3aK9t622IQFX3RvaY1bj1XU8HM9DKyr+IPEouasUGyZII4wVKR7r7JDN9NFiy
         6OPzl+OvIMCwj7vYLkORwti3ZSBX7uj829loLly15AAhNl7He5KPSGdGbse/nP5c+4Ef
         Mfkg==
X-Forwarded-Encrypted: i=1; AJvYcCVhLW3wbG0JjwVFU3XGChGmXWF+qZ8mcm2BdvuQBKBJj4gmjw/GElThbas9XlEOg/uwb4ssxBvtJw==@kvack.org
X-Gm-Message-State: AOJu0YyAxZU0CZ92hJOXkO4OV7lBw6OYD+Ifx0yIQfREkP9EgdB1TXSS
	8RL8YZfA4HhgVAS+pDVEjVH7HhC16q1t+vd1ylAbnO3HSV+A6/SeHxpr
X-Gm-Gg: ASbGncsFEdVofDz70ny9JVduFsqHQvYwdn/FJ6lhZV+8dmTmQY8KEOWvHIFP4f8z5vU
	Rht8X6Gen+sLewaRxVpp7g1Ui3NqFYu8lTgr71Dl2KJH4qjOKtkBzje0H2iIo+6XR40BqoKUVFC
	KVMdkQmHjTHWJZ88KxhXMCdX1CIhkElCAnlnp7efDNGDrEEfc4M8Fa/1/MzuBd3658DAcPYMYc7
	gFXqbey5owui8bAnTs2eR0sGedRifw7RItQKwWntHmejpTM/k/dDvDti99vk2FDhH0Gj8+kXyzL
	MFGyxuz2BmzCcVWOKZ1u4gXTE2ccxU2D8dLURuCRr02mAvWNqT987IzZJDEZ3FGdY+/+OTKPLBk
	rEGBDd+NG+lQuWHTxZ6dDxO2sM0wPipVc4Q==
X-Google-Smtp-Source: AGHT+IH7ui9TJXKQ2pJIcwuIZvxvX8PqduYqo+2cQ68cM5ywCGeSLrO3GT6IefQ6CqCfyu2awBs3nA==
X-Received: by 2002:a17:902:d50a:b0:267:da75:e0f with SMTP id d9443c01a7336-27ed4a06dd7mr20974665ad.11.1758765934070;
        Wed, 24 Sep 2025 19:05:34 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78102c26faasm387777b3a.93.2025.09.24.19.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 19:05:33 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:05:22 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
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
Subject: Re: [PATCH v5 04/23] mm/ksw: add build system support
Message-ID: <aNSjYrXXO2BjYA87@mdev>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115124.194940-5-wangjinchao600@gmail.com>
 <3504b378-4360-4e55-b28d-74aabd4308d7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3504b378-4360-4e55-b28d-74aabd4308d7@infradead.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8415A100005
X-Stat-Signature: p9ata9j89ir3p1tdb61fgq5qtr8uqxxa
X-Rspam-User: 
X-HE-Tag: 1758765935-830111
X-HE-Meta: U2FsdGVkX1+8WTWjiB+TVAr3sVOPWMqKmTpd6pIIh6LFIDrZcyAKcYwz/1tMH18mjj0yIMjv6NIqcYFapFCWtsNSWrAXeY7TF/vftaAyfVpBY17JQoET8NAUBOe96MRku15Qv0nTlONq8piZKU0mY90Ck3wbfKk1TN7KukA9R+XhTSwy3lE9Mgh8my37UgGfF110J+YkuKGXeBB76QCPqDw5jVUVoDTIaHA0QSLjv3s23UGEotLLfSNhZ2KTFIjHDE4y3NNLbAM0noog+1eMdCaIDyuDRr8qvvhQWdlJScsQ/zMonsM221keGONgxSRdKBoQntR4aAcTOe4aafj74j3OkDevHeWhkKOtgwuqMYMFG2zAtryZa1xakQCjPgS3bweaY9UTwcy5a6OD2Vn68meH6kLkENkbrosJ9eS3WqGrgx3YWIAHhwAFCC/bdmqbYpq78cklOBu/ImfgeTKbxeU2J2C03hMGbZ7MWtsXrzVz9d+E6tU+xFqKXgYCc1ZIXesZ/JSGadCiNKF86PgGchWmw2n6GonJDJHtUik6oZnoQMeHJMSDZIhZwz0RxzFsHOTMgmY67MSDBLjPZgPe3tlFVUsn82wXoH+HXbex0KqKjquPCJD8YhmSWeTWfG7s/N6TxEJYnv7NvG086ahS2nVyg0fFV1jnbLEVRBZFHIKKv9jHq+so8nMb2B3Ji6ZRC1HcNSqd48RfLuOoy60UGpoHltqr5ANe7osojzq+elcSIxHpvIpl/OnQTAGmKG0hjjGKccZ4S28UscvPgyLxGn6ibJpMVGyjIqBzWt6YAKJjmdBnrsMyiOjNVqR1CQZCkX0Dh1W0u+FX6HSo70pbEDmavuipHk4GXt/DnYH1q81V9maHYiAazunUaSHLLLwDIPbfjRl5vpSQ+Rdg6h/Nhc944PJBXxY3dXRYpdlqn8vBnsAl1tdIkC7WRmslPButllAFwKi8gP8tHg1dfH0
 553qpu0L
 D0iMnOFIzmx1bhDbeAbMoEXzQ849lveHjcPAxBpIfL3wzSwYUvtPZLei+vgkVz/9ixuYZVKqa9hXpVRLcaROn5q35UWrBioMtZmMt6bO3S4jIIL39LizVX415/wl8eMjDGBW3wAtx4b07PoqRy0ZPvWwwOz+cYaFa6ZHcw6XBapO8rEuY6wyZ/RkicjJNMxbHmBV4h71AKzgox69oer/VS0aoeLNXPodWRFjxkGxcRBXw/fr4F4cVDbBk4d3PcV2hyeZhbeDMqeGzTM12yElgMKlnF/c26Q3drzEqmBDynLZVahwg8DLFB3owOB4pPzvEDNHwFyBwS/4a533aSSVewZDct44Y6zzHzTCnnS7GnTKA5Add47eFEWpRRbHY4wBFG6UoKv2MlikStsMeT5Qy7clFbMmbxFyegp35ngsxH4HwpFtEKaSi43GVcfgRI6UumSrZou7yz+hcMVDHf5fH19OwS7xQG1E5rWn3WXEaDOvx41ogLsNpq0yqvsx7Ld5kPt4YIrlo1Bc5v0LCfSmxcE5OM9Gz/CrszkYidQt/0ZR1dmjNyGM57QnJKE1kbcEOapZt3P8AomzGN7Kltx+L6eC90aEWNTPgPus0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 10:06:10AM -0700, Randy Dunlap wrote:
> 
> 
> On 9/24/25 4:50 AM, Jinchao Wang wrote:
> > Add Kconfig and Makefile infrastructure.
> > 
> > The implementation is located under `mm/kstackwatch/`.
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  mm/Kconfig.debug             |  8 ++++++++
> >  mm/Makefile                  |  1 +
> >  mm/kstackwatch/Makefile      |  2 ++
> >  mm/kstackwatch/kernel.c      | 23 +++++++++++++++++++++++
> >  mm/kstackwatch/kstackwatch.h |  5 +++++
> >  mm/kstackwatch/stack.c       |  1 +
> >  mm/kstackwatch/watch.c       |  1 +
> >  7 files changed, 41 insertions(+)
> >  create mode 100644 mm/kstackwatch/Makefile
> >  create mode 100644 mm/kstackwatch/kernel.c
> >  create mode 100644 mm/kstackwatch/kstackwatch.h
> >  create mode 100644 mm/kstackwatch/stack.c
> >  create mode 100644 mm/kstackwatch/watch.c
> > 
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index 32b65073d0cc..89be351c0be5 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -309,3 +309,11 @@ config PER_VMA_LOCK_STATS
> >  	  overhead in the page fault path.
> >  
> >  	  If in doubt, say N.
> > +
> > +config KSTACK_WATCH
> > +	bool "Kernel Stack Watch"
> > +	depends on HAVE_HW_BREAKPOINT && KPROBES && FPROBE && STACKTRACE
> > +	help
> > +	  A lightweight real-time debugging tool to detect stack corrupting.
> 
> 	                                                         corruption.
Thanks, will fix in next version.
> 
> > +
> > +	  If unsure, say N.
> 
> 
> -- 
> ~Randy
> 

-- 
Jinchao

