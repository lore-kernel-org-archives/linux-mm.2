Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C99C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 01:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28D46B0005; Fri, 10 Jul 2026 21:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFBA6B0088; Fri, 10 Jul 2026 21:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15336B008A; Fri, 10 Jul 2026 21:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79FA06B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:55:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1EBB140609
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:55:11 +0000 (UTC)
X-FDA: 84974828022.16.EAEB176
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id AAE74100005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:55:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EZSxRzaK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783734909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h+RWZEwGISLwt7tN7hsUaGDCvVZIkviSEfS2GkcrVCs=;
	b=1st6rAYH/mQJ80/KhNjmZOHQ/eBZkq3/lnJd92oVeWdBPHfczurfKfLrFkQYK4NQR+5S0l
	dvCndzQHe3hFIz288OHnz24XNNLEJjDv0wu4VqGB2ZzenLevltPGp6/x7qRG/TEZeVOPlG
	h8FhoIKyzHbJwHHqUnTd8a+4hWdpU10=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EZSxRzaK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783734909;
	b=H5EX6CIQFv++CE7PQHADvrTPOwp5X6YgiGUW1I7HVEWS726ZQdTuTFXosfsAIlU3MSRpAy
	Zvyg7ui79feCccdX7cOlzvvVN3oM/ubvNKR1q1hYdtQIrAwITPoigq3nrR1QdSZKmnkwng
	VDIT/AvmEEzTDXiJCY+vT2zFQph3f34=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c15a5b265so104501cf.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783734909; cv=none;
        d=google.com; s=arc-20260327;
        b=COgfHVeahzyQLKJpXTUIAvl0wu/ZE1K1QrYa4SP/doD+FJ+SLe+xU+0wcrhR3GsoWN
         am2b8ipwasARzAmY06cqOVi4cbJ5buXVi8fl9rj6fg/g5kBvizf9Pfd69yCk+LyqeK+w
         ZmuOFt5iGTMTzYaIb1MBUqyl3VywzZtRpQqetC5te8UJWJVtXVxOhH6UL2gOHN2ixO1S
         2GJy7/nsjHA6c86bo0ryka7ZW5HtQdyweLf+sqUXP7zVsGO4AnfwlVXf0n/W3Mcqgqxa
         x/iB/HPrZ4wvspHVZi98K9fB6up4qYKL+xdJtDVH+YKz7bsWXCXqgImXgDrYUrLD78Gr
         C7vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h+RWZEwGISLwt7tN7hsUaGDCvVZIkviSEfS2GkcrVCs=;
        fh=HSyM39IJfraOUyC0jAH4ILNSQA/ToQhnl93r0+bGVeY=;
        b=QvaB1ZA6m67IqIR2X3kNPsn7aa9Wxly+8hAlJp7LuQlV8D6GBSKp3hDPK7GNwteyfv
         zFr9XcKr0smEMzBQrWSGMF6hgnpc+UPWBwHOu+UUK97yCvziF3NN7v0+KhPEDGW2cUap
         x3EwMQlpD2sy7wzQt+TeNvefPAnvZLCr1tMfGlqOKgbT/Wy/9yWBquL4CtRwnBPNm227
         rjPXP1DoixAbNJV/tpPxKcY8Qdz1P5FF7N9/pJHH51vJ9BI3T7PZ7712swfCnUIThYWA
         fi8V5v8HFO92Xu6UpMv3ncpZsCndD4Gn/cgSYrIxR9WRdBTClDA4QBxSxoVWtwtsUNIp
         f3lg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783734909; x=1784339709; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h+RWZEwGISLwt7tN7hsUaGDCvVZIkviSEfS2GkcrVCs=;
        b=EZSxRzaK31x5e0UysEgXW383qccFHFbloBjDQQgMFIzdoMcM+6vb4LBDhdvUFST0pV
         WPNni7vN6EQMvsNTLuMu8dPV+86GUUJY2WMk4xNP0M3EbNc3xCYvtIOpzoJA65XGwwfU
         3yBx6BYeh3N1S1HH8vrSTuQ5h0URpl37HJj7iG6MSjFXvUwg0fUxc4WQg7ffYR3Nle2k
         fxLj4obUqC1fTnX91hoinMA87c5LtORcvIXi3/q9FoJpuQA04lI2pEJufcejpX75GxET
         meQZc8Uk/4c41SbkVV2Nsc0OkuUOM9EZEzr7qGsp7V6ZzZuyiuBPBLFyS+g5KjQip5N4
         Xmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783734909; x=1784339709;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h+RWZEwGISLwt7tN7hsUaGDCvVZIkviSEfS2GkcrVCs=;
        b=pUU5xHBl7sd3j8CkryljXpduiesMUVQwS6CbP1wKLVBmOHdtGYETfxQUoQfJGqukhZ
         YaVVz6/Gd33oEDKkK7T8rDH66RAGpmSMpiv0o45rModDyPoNEzBQ5YBwZil+FzLg0EIo
         ax0J1u6BG6zLsgMF5gtYmdQo8rDO2wd7qdPt+uFGQaIgeMZYS2bjRKbZLefpLg4lFOU5
         kjBExHrJWXCjcnr0c/7SArYTH/1KO0I8iEOcAXT5IbGCtpLAz5spvEM21oCGwEgj93wx
         iJrLhNUI5VlHNKRZv/2iMl9sRh3tpqq4bcbKrsAFelkcKmfILIMuW7vcHgdAmdFolRLQ
         zQCg==
X-Forwarded-Encrypted: i=1; AHgh+Rrv7DC8MjJAXXUZerbFLhx59MWmVj2V5jrwbRy/sEtoj4hr3bArCb23d4BX5H11aoTzINx7hvc3tA==@kvack.org
X-Gm-Message-State: AOJu0Yxfw8onUf4jGWjEF5ba4xc9NPHKCuRTSAFLzrfPHNZVninvf6xU
	W3B+kg4hVMsSccXkyJvQ0pXQvYdPYD4+DOLiOq//LPLlpQCHbHOXnCO9n2PhuFu+BM23G238ZQW
	w6cRndmKhnnSUXkVgKWfdIs6D9yrzNesc9Mb6r0bi
X-Gm-Gg: AfdE7clSUKv01vZmlUO/Q8/KOouFmHAUL6cBlyNcm/jjleq/L0feXYdh58UEVKUNLSY
	nZHcDYZqy7DE+PoXA6/6RdlQR9j4ZloD68wYV5dJ/8PvZt7y1riq/gR7ZYfujnjPDGRL4f2q51S
	OdjKnPN2ZDbKcvHuYF8FXTzLRSY97tCUGLBHZsq4ojyb+NTffqDDR0SHzc7JoxOpo4/tIbnidmw
	9c1zvK87cMaJCW+ilFWx6fxE/Xqt4VKvWHgI1GmZJjQNNDXz/dsFzwRzNjNo2xnQizXxCU=
X-Received: by 2002:a05:622a:418b:b0:51c:d16:b48e with SMTP id
 d75a77b69052e-51cbe53fc51mr4445171cf.22.1783734908023; Fri, 10 Jul 2026
 18:55:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260626075019.1833065-1-zhanghongru@xiaomi.com>
 <ak0Xl6q52exX9sBH@lucifer> <CAJuCfpFqQc+XbkpOiFb9Xap3VME1BevndWi-XyVAVKAfGMhRNg@mail.gmail.com>
 <CAGsJ_4y8WH92WMV3V6Yd6+Q2GKYfTyw3PbNdBSQPTj_hcpz93A@mail.gmail.com>
In-Reply-To: <CAGsJ_4y8WH92WMV3V6Yd6+Q2GKYfTyw3PbNdBSQPTj_hcpz93A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Jul 2026 18:54:56 -0700
X-Gm-Features: AUfX_mzrjaqxxkDBO2hXq9Wl5cIMp6N8TMyRSXlfo2l9cUr9dimLMP1eH2sDJCg
Message-ID: <CAJuCfpEZv3oeGB+5Oh+D0xX1sgEfeyYw_u0GC_apmZQ8ORLpgA@mail.gmail.com>
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when
 mmap_lock is not required
To: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, shakeel.butt@linux.dev, 
	linux-kernel@vger.kernel.org, Hongru Zhang <zhanghongru@xiaomi.com>, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAE74100005
X-Stat-Signature: xzq8rzd4rezf5n3wxbfu7atkdci5xrch
X-HE-Tag: 1783734909-222990
X-HE-Meta: U2FsdGVkX18qnxUF1qtphUfPwvdqcLuyr1XT7ssDZn7+oQHGbxIjjMrD1lEP8ARP/hRIPQDR+dvkQ6ZQePZm8EASzLovPXS/EYRxyjFJ6mOh3aunEdjTIZ5wNDRq1upmye6CS/A5y4/+sIJ3egRd7LKZrgIxkFS67f/0KdBk6MsSC6uY6B84z8It3zNnaoLeOARyy142KVVQcnF65/EXpmU91yUWfkWVo05yopml3+y/tE1I49NCQoQny7f4A1+FVg0NHUfFgExYqsMbfM1alNh68U3RpA5nGj0iXzpUVydKcXezcpaFhuSgjhAvceKgy/YIemVs8t/mq47y+6DhR4P5GEOLhdhSHfTExQissvl51vWq6xayvB6VhQSFhCMB2zx+qC5hccPK3lJ9NIod8xHXUpItMJGv8WwmonRh4Dw8wCZf5wYDzey/cno4FFg4I2FnHarBAGN/K9sj9KyPxSGroHZqfgyAylZ86sNImHGhJnsynwKsmG1pinuQtFL5KOJWBE4jak3w0BJLNYtzplbLpMCqIg1f0f4lecjwwquFHQRy85p8fMeyjWwEv+Q/5F9+gknpcWZxdnG17RmQEpXKVJSIXKBkC7SHLWUAwRKy6vTq56Fa2FCCz+GCeaL5vfyPje7LRNj18QMsIWKoazJLYNL4NMMD6fHPszzu7S2qFJSk9XH/BUrPyLWIxL611ozPgrYvf6/V1SWlWygg0kkVvDsWcC2PHA8C2fJUVQcUIeC3MntY8UF2BV+FFCfma8IhPydAHyTTREZO3OTZqIx+f0dWao+jnBb7f3FmecAUc2n/VpZ3hSf1SQKw6IUdRJlHLGXCbPn/96vRQmTF6mt573HIQAKtwm6Ffu1oD89gcF+Xv6I7Yol+sqS1Hu629SpBbtPJOvCeifgiGzeNvbJX0zDR5rEWB7aREUb/aNj56XhyGmZAge3upnecUUvgedaUmjYFVRIQkm8XxHI
 Vlxc58ua
 Zn15vWNvIb3nzQx1xYOpKytMX1l+VYO+wKHAunBcbQ01OcXdn1aQC+OFG9jdV6IgYZ6+OemXbgO31BT4QJ/AEoCJO1Ive8BEZVQbNEFH3vsnumfUISjwlWj8B75133MWMdeBjKE+kHD1PYOxUgBJJ1H3cHCSiy8VdHiczAXZymZaKpvVrgdDt8EQuGZbFn4dO61g1iyQMui/77tbQuxthkO2iSxU8PbK08HLl2FdX+95pLOty0bkw1oBsBryUNI/ebgykKtInQ2s0XIImXXhK7sLN4/l1equCs0aR2a5lLEDbPWYRGA7izJDs7/3HK+WBFvyo3GohnhSILgYe+KxcHcbTnrkX91yjfR0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 4:37=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Fri, Jul 10, 2026 at 10:54=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> [...]
> > > Have you audited every single VM_FAULT_RETRY case? Because getting th=
is
> > > wrong could be a serious problem and break things. You should include=
 a
> > > list of call sites in your patch and explain why it's fine in each ca=
se.
> >
> > That's my main worry with this patch as well. I think a better
> > approach would keep VM_FAULT_RETRY as is (falling back to mmap_lock),
> > introduce VM_FAULT_RETRY_VMA (or whatever is best to indicate a retry
> > with VMA lock) and then convert individual VM_FAULT_RETRY cases to
> > VM_FAULT_RETRY_VMA with proper reasoning and explanation why it is
> > safe. Less churn, gradual conversion, and happy reviewers.
> >
>
> I am not really sure there are any happy reviewers here.
> VM_FAULT_RETRY_VMA and the gradual migration to per-VMA lock retry
> are exactly what was done in the previous versions, even since RFC v1[1] =
:-)

Right and the pushback you received was not due to that approach,
right? So, why change something that nobody complained about? Unless I
missed another discussion asking to change this approach, in which
case I would really like to read it and understand the reasons.

>
> [1] https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/

