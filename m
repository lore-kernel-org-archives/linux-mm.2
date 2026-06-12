Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC09CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 08:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71166B008C; Fri, 12 Jun 2026 04:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21186B0092; Fri, 12 Jun 2026 04:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8C26B0093; Fri, 12 Jun 2026 04:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF2746B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E88B1C37FC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:00:49 +0000 (UTC)
X-FDA: 84870514218.28.902940F
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5732C8001D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:00:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="J0Q/ZZfP";
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781251247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnRvALqwspnqi9RT/gX4yfpYLdFKrxcGw8Lr0DwyYvw=;
	b=yuURHFRTLvfH0Dd7HFAft8C848NuxHK1ElduYEYSYNosbr8EOrEAdj73W1cAmdLl67A87K
	R1aHrPtyCKFCXXragm2BluPBgncSFNqgSmzyo6DMX4pnykW1bIcTje488LCNWce/EwmSWi
	W39IBVtoFKOWbdm3VN4v+hUfIsP7Bes=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="J0Q/ZZfP";
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781251247;
	b=KZVKuYRPmb4En5VRORn60R0ga+XPPDMorsGE6coiw6F28O1U8I0QK2BCd6W0QwX1SuLWJa
	+NjcQ4bWk5hibT450kfw27SzmeWYUANkzJyCtUY+xFow6CPrG4Tbgn+mfYoDUEyCmd4qct
	FqbnJPONb0Wc7vEA8c/FRZmWa7gC9c8=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7dc67a5e102so6681647b3.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:00:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781251246; cv=none;
        d=google.com; s=arc-20240605;
        b=b48g05YRTpXaCjb/v7QukuTO+f/JHLilxxtyNIhjFyg8dF2ZoCnTIqa6SiwGamuwgp
         jrGHJA2sGK9AnPVy1soMDF25ZgkvIQ9haKpTDwogkPDe1wsMGDAi0tMftrnpMqIbElQk
         KlR3MhFVg7GG8lranPSg7PCSzGaz5/kt+V0QvNzeQyHd76x1GpzDnlthrNjqw+wtFqMg
         UU2a9xBA/SyijFYy9TJHoZUYYsV17S+dhGMX8mb2QDf6HvZnXi50YPmoDy/2rWRjMAmz
         bVGqp+6Xq0FpceWc8kmRzMSSIE7mlrCjNlhSsyaxYd5G0YnTm5xQaJdWxBlVq9al1fQd
         y0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KnRvALqwspnqi9RT/gX4yfpYLdFKrxcGw8Lr0DwyYvw=;
        fh=to505ZLknEa5TCg33xaWYKkF0G/opaOWHRH+5pWOHXU=;
        b=P4g22QEiClVXILTqh66CAuk98/mGeCDIBu3a2fLttNCLWDk4bLw70BVTJLzN2IE7+d
         +x9HCEd9snyh0wI+H7iCy1eq4pbyGXVm1DrCE2y8P1z/yGaN/lWtLikl2bL26eW/exg1
         ARDPP4c75K1TqpDdCDjPBXFtYsGshwMXskeXJ0tAbhiUP9LbhZLRHXET84uXxHboaJq8
         0CO/TH8WQAnmgi3W21xptT/pe81ZGiF9UHiNm7le/gRSbaerYHKpocTikoTbhXEHj7bK
         ur27kfF/d3CNSQ5jiB14jPyhbnxSsR/ycKeyZsOfvksMu/0ysgoeGmZMjoy4EuARSguz
         lg2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781251246; x=1781856046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KnRvALqwspnqi9RT/gX4yfpYLdFKrxcGw8Lr0DwyYvw=;
        b=J0Q/ZZfPYQ3OYqRcYPZtYhGz2I0dE5jIN1wTKYVWSqIX4+hZtOuNxSQUlMoWnFWPVR
         BeMhu8wlRVleh8m0u66MgPpkx/j+EgIRwl8bw2dG1cOcigFrciTWPdHIhV808QgD+59y
         t34i//fk+RbrJJJzsIKgNr6tZo06C/ttfZt6SPu+qlYN9WZYlhLM8Fru/FKqWnSj8idW
         DbxBA+LeqeBjYmiySj8GQzbO/SrmAVrlopOgcU+5MtQLmcpNdyHJbLF0XprsrgCYHHiM
         6Mo6gSF5AU+xlR6bB6slbbz+NXzKFCOq8g0bM3pg0Dt3/VLRwGK3YAkmrnS6eJv7OsYI
         I71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781251246; x=1781856046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KnRvALqwspnqi9RT/gX4yfpYLdFKrxcGw8Lr0DwyYvw=;
        b=nGzJ6jANxFrWGqod7YWTt+jvRbSj7DPCkFhssqaIn6ua/qB1bK1grumFuelr5iVdHM
         3Xolcjyksu11d0zeI6W4xIt2Iqxi0IzSY7Y/7z8mA3exehbVKVVeGCbrJPXgMWtN+pAY
         3vVz0DccRe1anFPE6IdH8YKIKnQWBG7lOhiIV8VX+4pxvS+FEwLzIK1eA9XUrcJoMBuV
         LZV6varKWs29VTondmDLdmDOUhWI4eolDQWK8M5wLoZVQ0zGR2rwLWR5re94JCnWwDMR
         VeuWUqJwUThfac+5X4Rkb9fSDLjA8vByUJJlvGd+S8uK1WVN+zGZ9rzasLkqpWUtTM0j
         wRZw==
X-Forwarded-Encrypted: i=1; AFNElJ/ILGzl3LOhAMUCxIUVYG5ODan+PHYLgMeJBgGVIigMCkTN0GfLhjRPo7I3Ap1f3ZNZuYGoYJz3qw==@kvack.org
X-Gm-Message-State: AOJu0YwGIjeMBfo1m/v1nkUeEeTedyOHAKoQ0TmOUpdnUW8uIG/Vddxg
	8I1nBHhSDIY6IoNmGLY4iDenl4vr+foALTxB6C0NeBITDJaF34erH8lAu83b0hEfMEO/oXA1zrm
	EQ2l1feDSuipxaB3aHnjdI497MRJqqsyLTy/BZBZM
X-Gm-Gg: Acq92OFiWREp67w+n9khiXXNqmu8PngqcD1G1KhnRTIk84tMN6dWC/oNVJ2oWLL7jGE
	u7lJhsCGbYNcqiiPqfvS56OIkcTj5RLpl7K+tMXwIP76vj1QW4XT3DIGkCxjkwqFmEj/hwBnlL6
	SsW1CItJZOxaAl5YONRZxapmvRB5s7iGzL/JmTcZuVqYk401DDIhRf3KXz1MpLDByo6YELNQJBY
	gYElbdgsZxQkz3+PKkZ4MTs8AOSqB9AGKdi+a/saoNzxTOG7Vk2HvyN3Xnl9nrWqlMMJYlCGVUH
	BN7LQHuP23xfXegMnhZIxs6jjsn8MXsFIPzTkQ==
X-Received: by 2002:a05:690c:6201:b0:7db:f8b1:cd80 with SMTP id
 00721157ae682-7f7bac02970mr15863297b3.2.1781251245971; Fri, 12 Jun 2026
 01:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech>
 <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech> <CAG_fn=V1+_xLgCZgdLnT7Y-muRO0CXkrNKkC8AzrqzWoL4eR8w@mail.gmail.com>
 <5fa7a528-a4c5-4fdb-9a17-1b0992e955b3@est.tech>
In-Reply-To: <5fa7a528-a4c5-4fdb-9a17-1b0992e955b3@est.tech>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Jun 2026 10:00:07 +0200
X-Gm-Features: AVVi8CdEFjoun-R64CqbvYJPTnaS_E7TDNryUpyw-2UHJoZxcDfdiOQP2RCPBTE
Message-ID: <CAG_fn=XB7_zbjGzpgwEzm5dqcwehqvB+=SpJhHvw9QdETberAg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/14] kcov: fix INIT_TRACK race in kcov_dataflow
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>, 
	sashiko-bot <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5732C8001D
X-Stat-Signature: btqor9ajw37auyorghsi14emppk5eo5h
X-Rspam-User: 
X-HE-Tag: 1781251247-87657
X-HE-Meta: U2FsdGVkX18rI9hZCoXCPNvV8xAl/UJQYWXpiX8ada++YfhUCCBvwJupu7DJKqHc9B6AkejNZexRKrFZAO+Jy0QkmTIBaTXRYBjIX1fH5v0QoYzGyiZ+JjGFt8zoR6D2m1h2+jGSijgtqdYsjY4w7O8Y+4khe8beIYr9kVKnxn+9H8io/Yv9nBCFDLFEHqTxmEiofcafCIldbqhulBR+aEqFPVDhycDgXm4jbKMKhkSFsRzCPEhhIB1HMFuhfuwEv5Ym1r71/M4v72mYA/Cn0TVRH2wzgEUYW3b4g/J9eStPahqslHVyrXCkSs2W04XxailqiQGkprTcRi7kvo2Rete7ozcdYV6a2T/5DvbEV6clUs3XUUrw9Fl93yTLeZIVFguS4e4OmgjPR+2xv8LMqMp621fbhMTIANaMGoFNRcoKzYWkGI5uDfknL8vFs5QS+lRuQcaA4F3251fAOi/hFXZh3L2Mq/PEnPZtCzxiZuRgzfl7cywSlaMw8oDOS62wNu0Dafu8qTvybHjJznUecUG4CdwMzmnIdNa7/Pd+BqEFcXkhtjp8xZROhREMbfTj8jeNXBcRZNYKADISqbZ+6ZxfS9VFs1xk2VWkwDTX3OlR6/J83I8UI31q/Jdj/Bp4+zHNXxfHOlwjrIeut2L4QbfU3aK6ayx9EAIl82skX4kOaUcpoBD6AQai8Q0dDqsDk8EphRfKbuON52Ye+WwNpJ9zKB9LCRC4hOFbS6w+HLHL3zKdIAu+x8OGhCaNdIxKu6sNxvC22SHakpBJFjhMw7bmtHPT6ZCBGTXNEMVP/og5qXH3PaqywmYBIvyR+M5xvDij18WKBBd6FXl5Jawu5aSmFY8emaxDMLciBZZGJSV/j9qp22YXY42Jc+vy03AYOs2Nr/SwpZEdjuIJavgmfAAMOSjHFnUnH8JKCAhQDMvrMucKbTBjjcqed3n+m2+7S1G2zqWDjOgqVMXTZBI
 1RsGAY5x
 0RMQxrtEmHh/bRNAtZDsA7h1y0/1s07loM2bwJD2GD31pDYGMVMfsLTt8+RFFtmt7/fYr2tm0tNhD2RR1OvNdUXpFfIZgvUuDTFELkcsnIgFoB0bSFjgkkrOjTFNS1FMReS+4FXMU7++WNjK2qRF4g5xbDvQuXDz46Izr1lAfZceLjw8nmiNgb/Unr06NfdpfJNkE0gA04pVyv8/mlONxYpQTC0J6bT4QAV0vzKy40LhFmVkr/ZSNlgGOiZiehV0zvmQSa3zcr4WVyvtKCt4HIjG9k9Em5UPOL7kMtlyd71z4Dp6w7TnIYPUuzohJfhKRQtVrd84Df1I9UFTl1Hy4G3KgKpTtaDpuv4EGEgcA+56an5eh3hLnYsVASLyTAilWIM9RAtFbOfWAjlcrfL/KdDmJ5nAQ9tJqBxuhYDNcWhyTUVrW3ykL7MHPJ+y8RHRRpmS4ChB922M3OxPmtklitTMl+ipSLcjK9VilDShTDNde6NzjsvnQgxEpnBVMWhykFaar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:25=E2=80=AFAM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> Hi Alexander,
>
> > On Thu, Jun 11, 2026 at 6:21=E2=80=AFPM Yunseong Kim <yunseong.kim@est.=
tech> wrote:
> >>
> >> [snip...]
> >> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> >> Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-202=
60603-v2-0-fee0939de2c4%40est.tech
> >> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> >
> > Can we please avoid this?
> > kcov_dataflow.c is being introduced in the same series, there is no
> > need to send a buggy commit and a follow-up fix - just squash the two
> > together and note the changes after Signed-off-by: separated by a
> > triple dash.
>
> Thank you for your guide. I'll remove it in the next patch set.
Also please make sure to update the patch version. It's really hard to
distinguish between "[RFC PATCH v2 n/6]" and "[RFC PATCH v2 m/14]"
when both series pop up in the inbox.

