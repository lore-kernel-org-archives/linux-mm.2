Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC9ACD0407
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076C76B008A; Mon,  5 Jan 2026 16:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037256B0093; Mon,  5 Jan 2026 16:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0CE6B0095; Mon,  5 Jan 2026 16:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCD416B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:04:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F7D457D37
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:04:25 +0000 (UTC)
X-FDA: 84299138490.27.1B65DF1
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54D3814001C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:04:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uu4aGY1s;
	spf=pass (imf09.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767647063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Pu0j22Ua6/B/af/fCm8aYXRd0QaCIL2/BGIXkmKA6g=;
	b=h/7LYDrG/2kjKR5+S9SeYsklKF995WvF05hqi0HS2xEKsRcvhpX++yG8bB1/qdUp28qK0K
	XFTkuvbL63Q2FL2Siaz48pegH9pIns6qfHYItp1lrqrlU4Agt0+NabJLbtJ7ytow3oFBrW
	AxGG1xkpZKychYkhWKFharY0PAzY2bM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uu4aGY1s;
	spf=pass (imf09.hostedemail.com: domain of mattbobrowski@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mattbobrowski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767647063; a=rsa-sha256;
	cv=none;
	b=jL2M/yUXw9H8SydoJg1vU95Cxno/XvvdJMytQCSUPGXInCZKtvJWYNNTBkgfaEyHujMfzJ
	p8hJg2cBvjkjpd1DLw0UnjToyxqSsE4MgEOvlyvMe29LXdlC8ea5qMhXijF1yBBHTRgO6e
	F54uDjEvM4vJX3AHzTLaCbdS6KZF2kQ=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b79d6a70fc8so67406666b.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 13:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767647062; x=1768251862; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Pu0j22Ua6/B/af/fCm8aYXRd0QaCIL2/BGIXkmKA6g=;
        b=uu4aGY1srocOzKHhCa0iIv2MFAZ8B8Y5vgX1KzfoXqPV2ek/V2a2jDziidX4w5eXK7
         E1wflKj97CFZc9mJyCC4gHkCp8bM7JZSXcNgBu6tJjSHQpIAyMPQ6jKTlf9gr9G2sOrm
         Qa5LlQDA4dWU/n6Bxy30kL4pDCEVNIoiFr348b7Bl8k4wma+4+QlwaSmnkAoEvUypkKT
         gLjA/W/ynpOlmGTyHPCKdSvE0eyEADz332rzFeN8oe4x3xKZwab095WOihyPgzj9+o4w
         bMtLODGZCE6ssuKz1wrxZUtQqy+AW6Za6fFhL4KiWlGeQj1BFIGncHfSNPFxgQOU3qTh
         UErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767647062; x=1768251862;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Pu0j22Ua6/B/af/fCm8aYXRd0QaCIL2/BGIXkmKA6g=;
        b=Faq6cqNmq/cOQ8MqiCZUetFmXEFhTzlH7dyd5onpHH2WNVgT14G+FceRtZDneNISRY
         CX5x2lhJTmjX6IpzYKBybE5FciyA9KckoZm5gR2rMgW5Mt3wn0jXhaWlEmDhGksEN1NO
         Qw9RLRWlLW9c/T+yrPla/yaN1ytTnn/QPwcBOuzBG5x+sjESDua63R2bdlKQOFh0AAxj
         wzYMnHniEi9c82JOj59guSjzMpu4FkpNT0GVCX1VIIi4LA9yHXcxRx1+lvOz6c1/S+GH
         qf8Uzsba4GFEISGEoUVt3HgEkzzQqP4mN3oDS3ldMlf4HNwrraE6Saz6NUUqgYWNOCx6
         1gHw==
X-Forwarded-Encrypted: i=1; AJvYcCU0BsAM0M0GXLNt9/68urgfmVmfyEj/9ILkr0FU8o8pNDGGp652wtW2f7IK1SnWZNknUHp6u/sYsg==@kvack.org
X-Gm-Message-State: AOJu0YxObmZ0IdBFxF5vCz8atv7aO4tKv/rRE5TTe+1p54jbeAcdWqUD
	aT58DElDVBuasdJMkgVc5XmgE9AJj7CVc6SvnymkExb0hyQHs1WFH6UNgC9k7+RHQA==
X-Gm-Gg: AY/fxX5mOfUpT4sqb4CceQnPH1haG+AI1xaDbjguE44s68SL65JC5rfcbI5BZh7+yrQ
	+fNugP9npIBG8DCilTUJHIYVQsms+eMEBUcYReKuRAWFbpP92cn+4f8Htd/eWWDlIwQSKBwXX8V
	ReS2uGRZlsNKafxK1iYGedbHWlk7IlxC+DYYlqbtqCgsZc9tzPtgCP1NCWty6w16FP6r6cBlY4x
	OAhe7pkyiLgHcNKy9LRUIPgpvnpzMzYE/fVZCU7/C8fWyV9oIQYR5asNZOnRLMY4Mim5v8FXcqY
	FKlRzqPfVGwnwZ3NgUZLIul09C2Rn/vgDlAKnZ4ZvTLV27aFIUKA+GsirfLGTWdOA7x6MbAOZgB
	2jPBtLRuTAAOe8I9Gexvg6AqJ9z55C0fYUtsnYlhAyZWesi1FP32spp8ln9hhmOMaSH/zneH5ak
	D9p0kOIurYDSIAvmsJ8TsUdFQUsQeBxcsF34GRGwATpkh3z/jSmGkM8Q==
X-Google-Smtp-Source: AGHT+IH5WTn41lg95uujB075zzBoLd9HIlELS6iNanZ/1oj+Lg79QDlEASfdo8DVdErdLUKvHN7/MA==
X-Received: by 2002:a17:907:70c:b0:b73:80de:e6b2 with SMTP id a640c23a62f3a-b8426bf10a8mr113572266b.31.1767647061473;
        Mon, 05 Jan 2026 13:04:21 -0800 (PST)
Received: from google.com (14.59.147.34.bc.googleusercontent.com. [34.147.59.14])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2bc6bbsm29697666b.27.2026.01.05.13.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:04:21 -0800 (PST)
Date: Mon, 5 Jan 2026 21:04:17 +0000
From: Matt Bobrowski <mattbobrowski@google.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 3/6] mm: introduce bpf_get_root_mem_cgroup()
 BPF kfunc
Message-ID: <aVwnUUXmgE1uOOj4@google.com>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
 <20251223044156.208250-4-roman.gushchin@linux.dev>
 <aVQ1zvBE9csQYffT@google.com>
 <7ia4ms2zwuqb.fsf@castle.c.googlers.com>
 <aVTTxjwgNgWMF-9Q@google.com>
 <CAADnVQLNiMTG5=BCMHQZcPC-+=owFvRW+DDNdSKFdF8RPHGrqQ@mail.gmail.com>
 <aVts9hQyy-yAjlIK@google.com>
 <CAADnVQJr0WqmqA2fQeC0=Jn5F-ujWmUkL-GfT6Jbv8jiQwCAMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJr0WqmqA2fQeC0=Jn5F-ujWmUkL-GfT6Jbv8jiQwCAMw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 1qwdoxe5cgtej6u9g9sffj4fuq9ye5bt
X-Rspam-User: 
X-Rspamd-Queue-Id: 54D3814001C
X-HE-Tag: 1767647063-599498
X-HE-Meta: U2FsdGVkX1+TvqXXymMhD+HA97rPmFNFb6BJHoiJKJj1JxvgZ52UmguMExLWuk9sUxHQc4+pPZl9thOoV/k3wvicwIpznJZaZrFAeaq+oYjd0I3aV560IHqOZcNmsHAG8UYVzz38sk+IXeq3RpKb7LDElYffy801DjHfgdEOCtnouQ0r62Srr6OHY5ogGiA5gXs+AD0++1/I2B2QwyTWDTSuHxxH8mgcL2Ee2rf37NKEU+PexpzI4TwwTFxOzOiWds+JQMDxqbm4wo8fu6iYjaYbdR+HQUml9tUf36BETu0clwifnJ/TiSkqpYRymQqQiMrhfILcPOMaDbm7wBhExWINtjIezb6+kv91NEtOs+HZ/OR75XX33Tl3ZnJdoASzicN7/dOP2lxImpU/8aSwQKiZjLTP2idq7dD0kF15/sf+/ZaR9YwKadoakqn6Dqfk+C7eYNEXn4e95nEuINmVtJk1nDuYCJNOiUuFPQAMFnar4sUPs1wmaqMOmDR1hd617+x9C3LEWDH+3K6UDzOLGrWvADXTrkvsE2cr32FruiGJmcJlH5SkHxg3kxlhDGZJ5mPXgjTNlD0GnaJsI4stU/ps5Y9yx9YA+iCf0pg8/66I8SI3h++YcCYGwRtI6vqhxdytxMGY1bqOIJ87v+IXnZrYloOZ8mAerWwrjePpdVTSlQerWukmEeAxpV8KNPwqUwqcs8rZvX0E3b1SOABSPrb7Sl5RXtGqyOc4QSuWPN23vdC0tX1ewxLqDAoIzIMkNANf9RbgqDkr349BFAhpf4ui864EmoteGXyz1X/3aXpjesbG34JYREGiEjXdUCQ/VsnXJ35XlJN2+veeCixmQM8Jo0K0rtoToKwK/9UvFn/Spmr+DV9hCcbOsfO4TqcTOPki5gGn01n1cj7hWtFhx8V10TKqzeG02lZWLHeI18Z3MbEZO5xkZerNB/2vV7gfw0acTm6gw+/c/Su4hJh
 saKz+hBh
 kQAoPpzuPgml1inGYMWihQ3WkZsSvWAvmIPrB8FAv42MFk3AZzwpJ2FN/+kU8DMgYSXFkgnL3i0UeKG9CPJB7H6zCJRy5pikRvVlsH/PbGgQSZaY6hddmAFsRYVV1quAkyBHwWZZtw73Gk+y3jaI+nIiIzBlBEh1e3xiFfitVWLTGbE+9mNdoGIrJRSa2X4/HqyeXhWpUMYTl6Zy9ie0ah1m98ik2H1S3f8aXg7AjGM6ZJf7hXtVGFfXr1ZoFI5LkG4Rlsm7hjJ+mrU4rz++LAleaMYcO1GxiLpNUV61OU1zxn7Qd3Wc/wK23lBr/TlNGDQDqDkgHQBKszKBcl//bbKJYIeP21Imizp+dQTnhqzoBVKm1ogkI+C5T3Eqfqzo+Kv+AJcTgIJf2Oa9zOxjNpwHqHowy6A+9Rc90pzYz0a9QXv00JvLWIOZed5UVsVIgGAgkHN0+SDtSGW+vZcc5KWlypDX7cMck78eC7bqylSNeSXLWV/94QzHaT86Rt5VaYY5K4vOyA9IZKWZAF8/JbLwELEXg0OLibdiz8tYXLYEC6byZrVA82E0bncbCbiumaSLB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:05:54AM -0800, Alexei Starovoitov wrote:
> On Sun, Jan 4, 2026 at 11:49 PM Matt Bobrowski <mattbobrowski@google.com> wrote:
> >
> > >
> > > No need for a new KF flag. Any struct returned by kfunc should be
> > > trusted or trusted_or_null if KF_RET_NULL was specified.
> > > I don't remember off the top of my head, but this behavior
> > > is already implemented or we discussed making it this way.
> >
> > Hm, I do not see any evidence of this kind of semantic currently
> > implemented, so perhaps it was only discussed at some point. Would you
> > like me to put forward a patch that introduces this kind of implicit
> > trust semantic for BPF kfuncs returning pointer to struct types?
> 
> Hmm. What about these:
> BTF_ID_FLAGS(func, scx_bpf_cpu_rq)
> BTF_ID_FLAGS(func, scx_bpf_locked_rq, KF_RET_NULL)
> BTF_ID_FLAGS(func, scx_bpf_cpu_curr, KF_RET_NULL | KF_RCU_PROTECTED)
> 
> I thought they're returning a trusted pointer without acquiring it.
> iirc the last one returns trusted in RCU CS,
> but the first two return just a legacy ptr_to_btf_id ?
> This is something to fix asap then.

No, AFAIU they do not. These simply return a regular pointer to BTF ID
(PTR_TO_BTF_ID), rather than a formally "trusted" pointer (which would
carry the PTR_TRUSTED flag or a ref_obj_id). scx_bpf_cpu_curr returns
a MEM_RCU pointer (via KF_RCU_PROTECTED), which is somewhat considered
to be trusted within a RCU read-side critical section *ONLY*.

Kumar/Tejun,

Please keep me honest here.

