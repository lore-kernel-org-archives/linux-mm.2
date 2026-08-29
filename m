Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03383C61DBD
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 00:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF936B0088; Fri, 28 Aug 2026 20:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739746B008A; Fri, 28 Aug 2026 20:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9CC6B008C; Fri, 28 Aug 2026 20:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 249A06B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:18:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 804AAA05DE
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:18:21 +0000 (UTC)
X-FDA: 85152395202.18.065F096
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8D38F1C0005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:18:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jCfK+3gp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787962699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92zwtXlgyBYYVN9xkl2KGrhKya15L+GyHSeWZLE5yFc=;
	b=MIESQf9pW9eyGVrT0lKdSpFuWM9psAs4jmD3Ib8l++ckps6+rowwDKiZKtfrJZXrFqJt4D
	i3rv5AxOxhladoM5CaYqcN0kzpLFt/Cnt9cHhDomg9Wvfihh6uZdCPMpdgff2X1v+trXVa
	BjOKUAXli9Ba0jSaW5/U4hjYE4i+vAc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jCfK+3gp;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787962699;
	b=GI/SpRg2smtWlWQkefSe4yC8oUKj9dNvFBiewthip9sBMwYTztfkn1DSf6vxcMDxaYnbg9
	AN18EmcjMysaqh5am2swqP94PEJTZffe9gWRWDESye2W2P5Fa1OWXaWOLEHhuEnEV+UwOo
	LA1wPIOkcFplPZCXWKBV2l86qvvSGZI=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-498012a61f6so16605e9.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:18:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787962698; cv=none;
        d=google.com; s=arc-20260327;
        b=ImG6uWplPh6fo+JULb4iFJUOPuMPljSV+n9RYQ890pwpusINM/Zalb5q0q2ZlpPMwp
         KXpwVGeqpZTtHfLxrPyvjyr4onevNhd4UDw5IdRjtewIHuFSEbDsMKlVhusgJw7dsTP8
         pul/qai/e7sOg7LmOLRylLXtFcJ2E8etWK60GxnrYpP2rU2CIVXFC2fsNetb/82USMHI
         iNWO0/AtyYUsMyqA1MhBWlnzUO4sA10u/rkF1yl6Rf0ogsRd6CcSurkI0v2ynl4MPgYB
         hsAgLXOar2ehO5g/BIclFO5opUcTxAvPIsPuxRM+NjtYUh5VKwyEz6DskbNBino5zXVA
         5g4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=92zwtXlgyBYYVN9xkl2KGrhKya15L+GyHSeWZLE5yFc=;
        fh=cZHWiSbmQEInFNAm74WFViGPvXU4/CiTmKVGgcjWGH8=;
        b=mL3+D0BjPFzp51GEYiToYFNklXJlyArf2MWwJMQkdA8MCfm8iHOVxuepEOj+PcBr4f
         c4IctX01sW+KdMNVZZ5NhY8HB7p2PWCMlVKaN4EhSrpt4QQ1cqSIN3lLzipe5ocqhqj6
         56u4oUm+2bTXccNGkDKMfdRxE1puewuEDZGgV7pTzq8JGZTODHlXuS/UaMRHxayXSpKk
         QRnVC3xuy3h7NTmThsKt3qgsTxM2M4DU9tIndhPoWWU4piYCNcauvq3yeVSz6WW8YDvY
         tfp5H0aHdDNuB1NHC5OfpMVngPDP67dEKzUies8oVCstlc67xxqHB0VlTtsE8G2ApVxL
         HVyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787962698; x=1788567498; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=92zwtXlgyBYYVN9xkl2KGrhKya15L+GyHSeWZLE5yFc=;
        b=jCfK+3gpYCucWWJ2cNvIRdL2tPk3SMg37iPIaU8lC+DxSHwX24gXkRMmwewi0+SF5T
         oHUEKKelqx82BCj9L9MS7Y7bBV2ATcMm3Of+Vm/DosD38hRhreh249bWrTUJCQ15niML
         UfAk2IJAAY3Z43uGUt4hIukn+eOKHNUDOT64Hn9HK8RMYHzgStdDm1iHJUIOdv8SFpHD
         txnOOOaB2CoiPhT4HhkLo0vBw3LEvyCmUEsiGcZmZgiCo9yrDhMSvgKO3BeLIgjBIYZ+
         5d1zI/VdUWMM5tbMLesDW/2UmTj4w9DL7ZcFYH8QFjqJnRu9GqXic20zknrEnlYz/VFt
         7G1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787962698; x=1788567498;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=92zwtXlgyBYYVN9xkl2KGrhKya15L+GyHSeWZLE5yFc=;
        b=JSVuV06Ef8K6ItN9Hp+mMEWWmWaQmc75MxpfFE7AVKgXKPgoxUQv6YeCsJXENywB+I
         4ZdcpWfl3B4nNZY1RAtdzRY+F55JAId4HBzYhdXSFKJtq9BGi5aImOz+QIpB6ISiEG5d
         laj6EwOe1GNQGZ6rt8ceSOY/V2HhySEPQNOqTNDFLMj+NULuLJ2R4bqpfzeetjiNJvSk
         3qP/0/zHJZ4lENmGYWOFNEJCKuRa9Ubf4RnpPrPfoD+9GAZQ+1AnIGTGRTbF+2CrKuLt
         9S/soYdNKbsWCWmnj0frema5Fe9S8EhY4woRvgyi4JwFB8ZX87tKi3uyp0qMtGJwA6Yq
         khUQ==
X-Forwarded-Encrypted: i=1; AHgh+RprQyk05PnN9m395YmXg5n0Cr6/Cq3/YOrRjnZ3mRKvxpgyA1adWb+0R6Sw7vh+uRrMta7d7cZVwg==@kvack.org
X-Gm-Message-State: AFuF++n3/EiMYmKtGx/A7Q0LKG10pp4yl8LlEHmBhDT2oU8CthrbH33f
	j6KKH9XhSpkagyE+R+RTK0SAolWv3K9uf+5DluZApyb3Nhf85L0ya3C9tffMdoFW2m9VFPkReWN
	S60NibjzNCfIqBly2lQtc0UPiPnaDkLHQnu8qcXVc
X-Gm-Gg: AR+sD12S74SOXsF6WQN77iiInAmxBCfmr5jox15yboTUue0yJt8/pRoXn5mxHNbfYeC
	8KRbJE9j3x8liakMQdh/hA2o/pArF1esqlC0PUpF2asLFSAIMflf1V4jW/uMxxpXPL26mjb8zSS
	taQiY6aBDOPu60J7xikXpkK0EVMPGVA4jFT8QzTU3MIoYKVWZpGI8DpduoUKptJTzhdC59EFUj1
	VFyMWcD51uHM3wHWyw9IPrzxLpgqzH2gO5Nu7v5wxLBri7+VUP03RfidQgoIpe/9zt6KZFLutT8
	OW6Y1rFRhbqqsCweYC9bVxxHdKPAAcxU7+d4egzCz2xG8MbRsxctZttfUX90a19V2FuvsQZJQYY
	=
X-Received: by 2002:a05:600c:6051:b0:499:c46c:addc with SMTP id
 5b1f17b1804b1-49ccbb107damr428575e9.2.1787962697528; Fri, 28 Aug 2026
 17:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828120408.GN687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260828120408.GN687043@noisy.programming.kicks-ass.net>
From: David Stevens <stevensd@google.com>
Date: Fri, 28 Aug 2026 17:18:05 -0700
X-Gm-Features: AcwNN1U6VBNd8zJTEq4mYD8VweLtljSgvulTToePYb44m-5Q8rEJ_yFqUyGXmiE
Message-ID: <CAOiLmNHWGSwAqH815X3JWMrQCc2nh-fRNsNZ0hjQGv8JvFndag@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7nsmyj7wjaja9rgp3qhuh7bcwf5rupp5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D38F1C0005
X-Rspam-User: 
X-HE-Tag: 1787962699-246986
X-HE-Meta: U2FsdGVkX18Dmw3dw2iN1Sx+qV4blFu+PswHcGjToA0x404rPBe6gcoDIAULRkpnrKMWoy9V3F3odlvoHV2g3/TTSTNU2joWfESOxTlz8utKGVKszwbHV1Cp3HtcgXkisQkvN7a1N8++s4nCKobbyrCr/B2twfEz7HccIS2hTao4AOOcup7SjHU/ZVT8F9wp9r2Gk3NiBJv9yYTUgipha+lSoUizAh6JxbjMx5wCVQcAnaQorY0hH++fm5iA+97p7Pg/lj4lzYYOxXTn+usE5wAqvIJvvIhDt4qt5Q8bfEVaoa2HoPbxT1ot87fhTnef4mocU6y5OCK3PPLoS+cCcS2ZbinMingr0PTT5J8K4CipJJA4FsZaIRVBE0P9d+NxYwTGEwwUbwTEIViGIeSrNADXGCKq8hmliYJfjrkWaaxQYTGwlN6BBcqScmsZFB4EjmIWLG3r/zlWVFEVgzOqyM+NtfSJiF8g84Nl0Wh8FPkcMvHLFea8IuaITw30DcF2ACsR9osH0WnIg/THCQwSnF6Hm1k0LT2OsSyV7UoXBWU+Cs/NvjvZju6wUmW+RyI6wejyYQKb2+fNCAT7oH5c9t9rrRefQQZqbeUnbShqoevijFflMfpN0/A0H5tjQlbsCEe3SE67WQ9ouzImV2Z2ZtX3BrKI8Bsc1ssg6Jw56wLpSxfYqS9EXpYNZeGi++++ycY5+DrfqNhMKAHjVg3MU2/hDlkUxwelkOcDmCjpd8VSDs2Pa1HHsSOoLXgB5hApqnOD+73AKDD2+8Rm9eFrKqGPxr7dgGmqzDKW9EBTkql23SZjOd1swn/Hca0FApT74OoxHCA+1DWrAL2SwKSJs/cBz8olefDbC0uE7a9PwMGKADEFk5c8mVpyVcxXmj4dNTLFRjLZyFYkLqp7cmJipPri2tW3KF2/CpZqgDMiyvXf6mvoTrEsua/px3FtAkz7x3dk9ewCvbY0C0qfky2
 s2sQ+c4X
 /OpFzy+VJCwivfuCwochvES4yDf9W+lpvRmFYVOUEaxvPL2gFj5miO6H6rHfx2NAJSghc2PEn3IMcIflpHta9F/AhQepYCLyAyYs+Ef4FDXWzJoM50nJgNSc9GK/P7fndHGl+QDmLSgcGTb9+ya1BQGv0BdtwN0rrCZ8vqw64c1ZR1YNXrkgjSZQp1Gr6Agy3zTusKo1t+aZgtNigKankYGgLTJdv4UD4Qod8xxf+jV/5YXpvKG9/Y7EUW7Rm1y6qjP2O+fnyeDl29EBqNvZEThswvTlS6BtmM6X3VTu0/Tlack4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 5:04=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Thu, Aug 27, 2026 at 04:29:44PM -0700, David Stevens wrote:
> > @@ -4320,8 +4319,18 @@ int try_to_wake_up(struct task_struct *p, unsign=
ed int state, int wake_flags)
> >                * A similar smp_rmb() lives in __task_needs_rq_lock().
> >                */
> >               smp_rmb();
> > -             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags))
> > +             if (READ_ONCE(p->on_rq) && ttwu_runnable(p, wake_flags)) =
{
> > +                     trace_sched_waking(p);
> > +                     break;
> > +             }
> > +
> > +             if (!ensure_stack_is_present(p, &need_deferred_repopulate=
)) {
> > +                     WRITE_ONCE(p->__state, TASK_STACK_RECLAIM);
> > +                     do_deferred_repopulate_wake =3D need_deferred_rep=
opulate;
> >                       break;
> > +             }
> > +
> > +             trace_sched_waking(p);
>
> Absolutely not; ensure_stack_is_present() must not call
> repopulate_stack() while holding ->pi_lock. Not happening.

The optimistic fast path for repopulate_stack() could be modified to
try pulling from a pre-allocated pool of zero'ed pages. That would
reduce the function to a couple of memcg_kmem_charge_page() calls and
then vmap_pages_range() to repopulate the stack's page tables. That
wouldn't require touching any locks except a raw_spinlock protecting
the pre-allocated pool (or just make it per_cpu). In terms of cost,
this would involve a couple of atomic operations for the page pool
lock and the memcg charging plus non-atomic operations on 5-10 other
cache lines.

Is that within the scope of what can be done under the pi_lock? If
that's still not happening, I can see how things look if we always
defer wakeup to a workqueue.

-David

