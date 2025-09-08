Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3D3CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907478E0009; Mon,  8 Sep 2025 01:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8358E0001; Mon,  8 Sep 2025 01:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A7008E0009; Mon,  8 Sep 2025 01:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 676298E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:36:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F042913B4F9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:36:10 +0000 (UTC)
X-FDA: 83864972100.29.AE3A2E5
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E58418000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:36:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c6PQ/T2q";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757309769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O//184ekENNe7/TMMlx7LZa+w+2boPr1l5+lEZSHfQY=;
	b=z1JKd8JJOB2TY0nPLRLbdBA79TegDHekZac7sdYckjvKXBlqH1Xn6BR7huiItrTv83DOv1
	JcqpoZ8NyHLl9hxtZc8mgzYK6NIlJXdbzKgYBWQoYi6ddrwl5iewXiiwAlP1n59zdA1+Er
	xFeiNEBLZnezPTFdB/4y8AY7f2D7VjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757309769; a=rsa-sha256;
	cv=none;
	b=zX1a7UH1Dl8SslNGQrLv8KLgPlEWALoQp1FcrgI8m7iq6QWgIlXPu0Cvia3IJjkKVKiI53
	k6ynT5va22fE9j6dqPo8c+ykRCUAJx04kVOzRRC7SpuVDuAPGFNPyLyUr/LV3QNjaoec13
	KFNtY7HDDnz3rSi9DnrrvjUPG07qbGg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c6PQ/T2q";
	spf=pass (imf24.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24b21006804so40874215ad.3
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757309768; x=1757914568; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O//184ekENNe7/TMMlx7LZa+w+2boPr1l5+lEZSHfQY=;
        b=c6PQ/T2qjUiFK5OsRCAVJDemEqByl5Oy5a6tIq91ycy5D9Y/ZpXmdRDjyMwhuvj4Ja
         Pc3ztf5J7Yq4Bb3zG6oNuQZ7cX+mu8x8Xp5EbZsaYg1hDlWUIjXJXXCgmGzAQOQRrFqB
         MWvGoFsn2f40DID0SKKlMO1vHSSbTMv9GXxb2PTAUTQsNRHMPOGTYmy89jL3XBuQaI8X
         aggOZ0qJ9IfxWWVWbcLekWtYwvQxeU8Yvmas6PPYMDE5qwHrCilA115AhPUDaWxacF7d
         iHNUj8V9RWp9rk1rUaLR4xSFTtLXFmymQwfx3uoYu/33mfpDB+Vs8uhCuwkNfLPNA0en
         nkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757309768; x=1757914568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O//184ekENNe7/TMMlx7LZa+w+2boPr1l5+lEZSHfQY=;
        b=Axs0QXbcVKIskJKOBxh0o079Rcm0hr8n7QljhB1OHWdDeuJXoKimafwnotUb8UXzs+
         ldg7/7oLHx54XEmUbtMDJ7wIfDv2SMt5NOdiYs71ScXyE80jRY240f18J2phjjuor05y
         XAywo3jlPPq/UK8twwMG1rRAERTTdMHAYMxQj4m2LQfB1UnYLxsPSdUCyThdPceixaWb
         wmuEPTJlT3mNuVeueB6itorqKAesVOfqq8JQ3JrBjq2eITDViVBYofRoVtA2978VVGbQ
         Atlz0Tg4mmzDDiEIBNqu8calwHirzkpIQewTcCW7KVTEeT83wZlsiIoAnmtW1HwjLsoW
         Z9BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVip5DLK/OOtyyDb36A2/UbKf14feBB0NLOi6w5keZprSfiChHRve2BTZlv+gjNw131w1WROiPxVg==@kvack.org
X-Gm-Message-State: AOJu0Yy4IHqM5DjAfD9TF79fO44H/itod4f0WpFrcljfAyzhRGy1HePF
	aJa2Gg1RAW5EISBg/8P7HTrm7P3yYu60yFwSaFcw07NY4Luzfzd5KM8W
X-Gm-Gg: ASbGncsqWhm37ElF5LHdsR+WiauLLIaHT3NsVZoQU0by6QFaVXXoUYXb28U/7a+rOrE
	wos5B6tyHlYhWO57dQPP4wp0yhVnsQLhhWcDoUlugAJqjBfzaK5gtQzI4Xyjw8ObpWlifla7Qdb
	34vCPh01dXUoIXIk39QlJ+VIy6yRIZC7Iek4b5S22mpTMd/KGCC8z0J/dnC1m1a2NAh5BJB5+zP
	nrmpYRYy2K7nDpnekf35+YfPJdbNkvZ3oqIqlnoAPFsp+oyw1r9FMMKhRzwua0t//qo0eTehDcI
	RzTPjcyBNrLPV5pnuvnxW9wMlAdGnNLITDWBv8wvsk729jFa1TMiusqQFm+5N+2ABJcq6SgAZ+9
	CZNLbzUt+C44Oz5GlesZEqhSgWkO/lRKn+AeaxghAzyQO1Qo=
X-Google-Smtp-Source: AGHT+IGJU9Rvc1SQDq43MWndwlklSyYn9Rwd+n1UlZjvW/FMqOjBhAEM/Cn8qNaaRO6JuHkBkj2esg==
X-Received: by 2002:a17:902:e881:b0:24c:ed9f:ba53 with SMTP id d9443c01a7336-251734f2f80mr92370065ad.29.1757309767705;
        Sun, 07 Sep 2025 22:36:07 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ccd655823sm99646425ad.114.2025.09.07.22.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 22:36:07 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:36:04 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
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
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent
 hw_breakpoint_modify_local()
Message-ID: <aL5rRIXYiFd8_Tz6@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-7-wangjinchao600@gmail.com>
 <20250904064448.GU4067720@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904064448.GU4067720@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E58418000D
X-Stat-Signature: 5bmqoxi8f8r9pznw46f3h3zj43th7hny
X-HE-Tag: 1757309768-974642
X-HE-Meta: U2FsdGVkX19uUMHCrf1pbYHzO3vyPZUL2QRFuDyLZpryg2lhM/I7IoiG+JtfkvkNDQetH+yzNlSW59fuiX7d+YHSvDqlG0eAicMIq9hLXog2LEJrEa7n13Bcs3fm8SmqHSZuh3dXqdoEIwpbx79rW+vKdrfmFet7JPKWw1w9BnYMwE3WO2ZbuC8gEtY74HzoyktJwNmWhuVQOTZmqyoEVr8vgUv4JTRCdqgnuLACrQoV4+2E2Sm/Ww+NgA8xPxr5PmMLhcfJyed7amrhE9d1Nh5hS/i/K97uyC1mJ9lcUF372J03aam9wgPZ+HmBRCUuDKln7abfZ4Q3z1BscQIKt8SdNVVVpvEfkrJGK2cpP779YWQJyb3aBoD+7CcRrfbXRu0t+9n30r6J2vGtbqo4KBgVjf6dpO2VAesH6yYju4H/O9JNUZNBPo5Xw1N3k5ODjTPgbLUE5bAgbHBFQ8FCRCWKMWvNWt2egPJ/JBW7qyohZUl2ZFmxoRgiG8JWbX26zxv98TZtyJ3GFzsZ1peoNSE2Ovx3N5hmgSp2Dpc+CuZTq+QTkvaklaSuXeZ8znh4DlvTIFeVly41uSvlOEWiRE9VyBhRpLyz4x8BAlCEPJiA+nk0m6qsULyul/5/o07ItZ6Kq3jco03vXY1mGIxUHKbGprzgi1iXMmgpQPMLcSPsKZJwM2P9ZnoFc5geuo58Pj1uN3qR6lLAZayqjKjV5rhFPHAdOPnp10ckMBcsA+J/bdRF2DAAD3xV9aRiX2TwNJ2fFOKDh2LcEv4yzEN0/lD4TQYlZGsvsHmrTzuTwnnJ4OHrT3HUuJQVAIQcxO9qx4PeZK4/niXBtsFj/OH8tThANG4EIfemfpyipys7iCBUc2z/wpn/hPfPyV8+GcOfUX+3MpN8SenHIPlda9azJm4Ie5sKZ/yvxB2ozjwSqdR1Gm2JH5XjZHf1JKLdK3Rr4PwqREqAf2CyHGBaQiC
 z/aF4Ywk
 4hZa3CnV4KKfiSJVVQAg94dBK9fw/2E8mE0FpYtEVoRTXDeYxYg78YNNBtw3CatvD6KtOqTKbuu+03Gmp5gx4r7l25M1dIq89YJTYq/aEEBNXlplZQ6zmSoQYHsfEllmxjJQ/OXsjnBnVVrK8BL8mGl6qxyaVditaDxGu7zUUbN2mU9QzFVBZaQQAeLFIcdP19LFTxeOkS992jsTczKi1IE0L28O7GyFuufpGzpSW+eJZ0D+u/EpH9iaw+bsZ2D1QjPT++7zKCx2IxP6UiZkN/4aZpK0UKTAB+F0hDZdFB9+O8IsLc46lVSXOJUx5PdZcRg1pvL0CgD/lheg5qETXu844rJnHzYXBu61f0aqT6OchHd3giW/e5Kq5RyRe5srersS8PIj+cYOrE3QIIOaZUWLQ24SapIuAa8hSc4VAqtr/Y9ybtHNCHH9zLIC98RMMqi2BuVFY5A9VH/pF5hW8tbR4EE8jO6tL6dHP+epzBaYTZIPlCUJRPqO9fogwB8T+R0kbinzJfEnwwVRGOZ+Z0fDJr8WTX0S8cIga
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:44:48AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 04, 2025 at 08:21:03AM +0800, Jinchao Wang wrote:
> > Introduce hw_breakpoint_modify_local() as a generic helper to modify an
> > existing hardware breakpoint. The function invokes
> > hw_breakpoint_arch_parse() and delegates the reinstall step to the
> > architecture via arch_reinstall_hw_breakpoint().
> > 
> > A weak default implementation of arch_reinstall_hw_breakpoint() is
> > provided, returning -EOPNOTSUPP on architectures without support.
> > 
> > This makes the interface arch-independent while allowing x86 (and others)
> > to provide their own implementation.
> > 
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > ---
> >  include/linux/hw_breakpoint.h |  1 +
> >  kernel/events/hw_breakpoint.c | 18 ++++++++++++++++++
> >  2 files changed, 19 insertions(+)
> > 
> > diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> > index db199d653dd1..9453b5bdb443 100644
> > --- a/include/linux/hw_breakpoint.h
> > +++ b/include/linux/hw_breakpoint.h
> > @@ -67,6 +67,7 @@ extern int
> >  modify_user_hw_breakpoint_check(struct perf_event *bp, struct perf_event_attr *attr,
> >  				bool check);
> >  
> > +int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr);
> >  /*
> >   * Kernel breakpoints are not associated with any particular thread.
> >   */
> > diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> > index 8ec2cb688903..ff428739f71e 100644
> > --- a/kernel/events/hw_breakpoint.c
> > +++ b/kernel/events/hw_breakpoint.c
> > @@ -983,6 +983,24 @@ static void hw_breakpoint_del(struct perf_event *bp, int flags)
> >  	arch_uninstall_hw_breakpoint(bp);
> >  }
> >  
> > +int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr)
> > +{
> > +	int err;
> > +
> > +	err = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
> > +	if (err)
> > +		return err;
> > +
> > +	return arch_reinstall_hw_breakpoint(bp);
> > +}
> > +EXPORT_SYMBOL(hw_breakpoint_modify_local);
> > +
> > +/* weak fallback for arches without support */
> > +__weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> 
> Again, so much fail :/
> 

> So we have:
> 
> {register,modify,unregister}_user_hw_breakpoint()
> 
> and
> 
> {register,unregister}_wide_hw_breakpoint()
> 
> And you choose to extend this latter with hw_breakpoint_modify_local()
> instead of sticking with the naming scheme and say adding:
> 
> modify_wide_hw_breakpoint_local().
> 
> Also, again, that EXPORT is a fail, these other interfaces are all
> EXPORT_SYMBOL_GPL().
> 
Thanks for your patience.

I was misled by another family:
  - hw_breakpoint_add
  - hw_breakpoint_del
  - hw_breakpoint_start
  - hw_breakpoint_stop

Since this logic was also added in the wprobe series by Masami, I will
adopt his version instead.
> Also note that modify_user_hw_breakpoint() doesn't seem to need new arch
> hooks. Yet you fail to explain why you think you do.
Thanks for feedback, I will study existing code to better handle the arch
dependencies.

