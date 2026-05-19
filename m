Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30553CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801CD6B0088; Tue, 19 May 2026 15:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9A26B008A; Tue, 19 May 2026 15:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EFBA6B008C; Tue, 19 May 2026 15:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F9EF6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:04:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2248014097E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:04:59 +0000 (UTC)
X-FDA: 84785096718.06.961030E
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0691C100010
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:04:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHDcGVTH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779217497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cojGRWW/Ex1hiO5wrDav3feItUxRSAUPq9EN/ARWbRI=;
	b=FNn/MKwJ/HmqYyCQ1i4aaYPWeZE0rdtSIB4M6P7nJxIC1TbyXX0x4duhL49+m3hzdk8bEs
	6rsOrY0X7DAAp7XgiQxqwK/Nm5gQj9DNj+2r+qoVoZeP6OgA5EJDUyqb1dAUXlxh+K9GPm
	l5kh6dE1/X6Eecj0B07Ed7HzC6M6TQs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779217497; a=rsa-sha256;
	cv=pass;
	b=U3rYWUQPVZRl9Nu8GPQRK0aFSjyzAaBW1IRz82midasglc9p0zHfzamh3wf4z8cADlJWLB
	wVKV/ZRbX/kbEF90gOGhkFYNRL/q62TNDlIudDdfMF6GxqNQp0VvYZ6I6KpJiwh1+IUq7G
	5pLRwqW8mDWyGKG5Q8sUjbqr4C7Qq6I=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PHDcGVTH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so33151935e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 12:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779217495; cv=none;
        d=google.com; s=arc-20240605;
        b=Wc9c/VUWkSePdSNne6ZmOzuWjK6lBDYr6Bw8eDdc02flqAssQiHJ04kQjq1QbkHbRV
         KENuYNGky4jZfDNU02znWSnLFtKTn+7/RGpOQKpHhWZt4jQrHsdpBuPqf4qjIuuzxu8+
         usKR0snxXbDsvyCkQ9tNRsB1R4XOlfTfwne5KGz/9LTrt1ac/pz88wfu9B+FaWpP65Nx
         QVzEhCK9I9/KrUSMdwr32BqgolpdtovHDi5PuqP+YCQj9JMm81tm126cwVzMg9uMtYze
         IH9PB5p9qFyVsqZwcyoYB9Hxg6GAecaPDd4PLTSvac504qzz8wC4DkDoLUVBTKIKPc7a
         BX7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cojGRWW/Ex1hiO5wrDav3feItUxRSAUPq9EN/ARWbRI=;
        fh=OB0CZZUfmys88+ySeZ5MmbHzLZ4L2aXBfai5epHpW50=;
        b=cJoggUxtYBN8hAa19s7MwXyCnSWg89qQkombdMQrcnPwD5mQBNQGEJYSMNiLsK1ZR5
         82jJqUJgUdPojbt5re8BYlmeHgo+XSMT/5OsgVTUycuy/hFen2WqdiH4vpZxKCD96cJZ
         SG+ofKSnPCYFG4KI5RwSe6C00iVkXrLtRQQXc3liC5KzBLfClvPXACmjMXAMWqPkaWUy
         kfRGxtURQZ3wCTzKPXOw/L+QnEvu9B+/gMShKd+sQokaMONvjIN/NUVaVhSACU/mrCEa
         ZdjZwayRr1VEQMb1sn45zAv0wUWegdEoF6tYEpugoMHcoDgZP6BXrzit1tCAGm3TKVyD
         P7tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779217495; x=1779822295; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cojGRWW/Ex1hiO5wrDav3feItUxRSAUPq9EN/ARWbRI=;
        b=PHDcGVTH6+ZSlfRhlizlOVUhKdDp8SpF371GyvKj4J9mX2H4Bk5wRJJ1o6iN6YPvJe
         5uIWdnioF57Cvj/0R6v6d/sabCbtADvu+F3vXj7qYATqt8c+DgQKjcc5eG4KaSKXLftA
         BThE47GHaf/eJNruJuAO+5okRFsaWuXoRp6pbCf6c6l/mLEYZ6KQSsIDT1fUITBqkrn9
         NYXhPa7/TciKxuQJNbSflvaNkJ2R5KA40US1rPCJrA5WfJ7AUQUuXbNwUoyjj2MICTPV
         g5Aglg4EHf0tkohMSG7p+9EBz7ST2QepH+oGzAyxbBtumukzruF8VREZXW9GHFN5m69y
         oxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779217495; x=1779822295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cojGRWW/Ex1hiO5wrDav3feItUxRSAUPq9EN/ARWbRI=;
        b=kk5clNng5jZyNK4uKbBVNYfqEHvJNE4Xgqml4MOabcCdV5YbHVRDqAMbd7crOj3rQg
         r9PzqcUJm12zwWiPW+AjlYyvXnANUFqzE10/xYRozO/s3/JdnnMBFQhxKKepaIx1P2VQ
         PLFzM6Lbqd2mV4LK4OnF7YqUZ/kfWPhYvR/Ktf2SxaaCLGH9GXn6iHcHhR/ueyx+xyqy
         9nwml0Si4zVe1pa84+Avke7pg2e63jNgkbXqr3SI9CV/p7souYq74D1bUdclsAqSpn4e
         vNZHJeFiDeqth/VCoZdE8YRXomU4BJXapioGN6RYRPvePS2SwDLcdmJI8LEO6lIsOqqj
         A08g==
X-Forwarded-Encrypted: i=1; AFNElJ9VDsMQTYRdlYsZApiqn+uU8awpz7bmD6P3eMTpWLnggqk+5HH28UlGrQL6lFpXSkQZYsqsBLwgfQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1BKkmm7AfkdIuoD7EhHURmrsUU4sZw5IyoX5DPTaleYD1CGZy
	iYDykKP6OBzDZp2KBmRy4vhb/9lHqT83uy5NBCOXN/HwwHQFY7dj97Q3JO0RuzekFVqHjXN0Smk
	6WIJUmcu4B4dWgGW1geLmi6AOhlhrJ1Y=
X-Gm-Gg: Acq92OGpe23CdU2U0OmgftFFOpDxqYQT4FLbNzMbU0opMpDqhsABaKdHt+0wbcKD/px
	PM82qs/gKZijwIaLJoQCMW6kzMdhr1W+K2ZiGLoH5HnnBApzHc/3HA0F5qgNEzebgBMuSITezSU
	Ul3cDu1nbs7cEzLSwGkRJ2AixWW4mYpfoC+tgp7SdTtYbxLKoeWJgQVbtGhjKLEUgL0IiASCypn
	o/A/vjsNokON3YBCdNUuHAnfMHYR1bifqBzcDbXMNh1J7tCxC/NWKHljiFjJp8luDshVcyPZ4lP
	UX9kgTDZHebZuHR0gbVRxGut73kqRlQyg+FI2nMA/xSokxJ/clCpWSqAUItNZDh2pRxZ//g=
X-Received: by 2002:a05:600c:a00f:b0:48a:5301:bb5c with SMTP id
 5b1f17b1804b1-48fe63263dfmr337569515e9.16.1779217495209; Tue, 19 May 2026
 12:04:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260517211232.1670594-1-tj@kernel.org> <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org> <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org> <297658c4ae2d6e7103f5968efc936224@kernel.org>
 <04b03066-86d3-4c0b-b077-307fd0f3bc9c@kernel.org> <5590fd3d-dae1-4070-b52f-bc40982ac678@kernel.org>
 <agyZxmHoueGwBAQg@slm.duckdns.org>
In-Reply-To: <agyZxmHoueGwBAQg@slm.duckdns.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 19 May 2026 12:04:36 -0700
X-Gm-Features: AVHnY4KnCVsDx1rhJ5Rhju09kIJne6tHjry-aCcLnmL6aRppUmxM6vRJAa3dciI
Message-ID: <CAADnVQJt0p7hSn2G074QZRh2LEdthy3RKYJ9j3w5yeJ-e8UQLw@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot installs
To: Tejun Heo <tj@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, David Vernet <void@manifault.com>, 
	Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev, bpf <bpf@vger.kernel.org>, 
	X86 ML <x86@kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0691C100010
X-Rspamd-Server: rspam04
X-Stat-Signature: wqity1gtieu34wo1yzn7yf55dfj1z3es
X-HE-Tag: 1779217496-250817
X-HE-Meta: U2FsdGVkX1+V0ZeWSTMdgIMArroP1ksFZCxhpEMo3/55LIrS9P5Xc9r1CHvg3wkMhCW+/6vTD+BPhOxxXS1S8+Wjbp+8MLUjrm80MFm/Hi0BVyzVK90/KQbOmOMiS+Aeu5MqH+xcFSVCxve8Cuus/fn+NUOgvGJYo/Shk2EgVjewwbi1vymxPicQEr3gVt+0NGDdq20v4JndIl3qch+8hh7D2/iHXWFJtXb/qc6t1IHc68xnS2JsXfNU/p3RrgFqFVSrVC+1Cz/xeg747eDSId4V+xBn5qUwCml1lsBXWUChh2jEEwUucJ5rPk+hZiA+CYxPXKk+SgWdFQ5Nsr5YIqPocAiEAeokIfoa4yojezIFcJFkzP1b8W5OA8SsLkF6UlCZrGwb14XIWf7i3HDuldqQLufxRj6HAO+hnZjaP0NlLi2U0cFU8HM0BMlAJW7r7gAfZ7TMZwPRaj02X58mbiS7MwfamAgmbz+wLr8ZMVS1R6V5r57/09gek/KVhycPitgrdhzN7nLoH49EMDM+xPgmMYtcXvnKb4xWgOww+9pEJhmlSgS7BEI4kiQdMcEe/hZgiN8tI94U1hwSADFvR2bepeCh+dwqPwNSOymn+FsZ3VaWZQkuEd6tKRLl0yWy/VFuiCZYNFRyrgcVS4jrYcwi4Ycug+wZCw7z/WF/ehT4hcO2y+mhTTj+lu/UWGWXRXUeYzAe+Y5MsYRSpSIQTHO1s8+dAHzu1GzWrSfXkzDpNIl0LcmQKNAZXD7QCjor2UesGfOY6yGDbs/3dAqf0DMWCliAFuqaqTIs/ydSaaH52GxomLv7C5rWLkIdTV3QJ3Mvy20GyfvtFbwJuyPElXL24K2L9+64BAHdSwPwYU2SmsNZndsR3Sx9s3yc303Trcd2PdlDpOaz1dSznLdJS2LCXwYaXb8z0lAvHH9PQ4lWn7fXe14Nem43iOgformHfC7f+rX5iK2uEEMsA20
 mC3VWH+i
 BkkTNaegfHhhMhWD3c0qXNxl/HYVsp0B0XdjplHQz/KUOdd3dNspVGCaOBsXiDLOOAriKdtmszdPQTDjNHYqCUkp0+D6Szm5cHJN1HhCyyjUywRIMBP5QnpmMbkKKng+ewWUh8i0cNEO7Ldmw/yHKJzB6qc+K4fs0/qums+aazAJUJarr3Uc4xjZ+jUA5UeUimCFmIT5s4i6FgIdAr1F+IZe8It/OIVaEo/t/WMQEg6fxp/NFLEbABy0md9ldcV/7G39qXXiwZAOdodT3dtA68THQEPcEmrOAN/TsIKwFzjOzysWxf5RdyZjEh2Wsb37zjgCLGQUyeMl7tKeZiH9P5wbuYqcItsy9ri3BtH/vdi0hPNFBhgrClBpCx8wlsmuUU2oTSYrOp94YWK22IhE+rlX6kZshm7/lOUVC8gViJACLTUxZpFXR6Dee9iDOW1cgwFg3iaGzwliZuJyqYWLyN5NXomb7LJAAwYL0D9/he0XoPA5A/FuhxRLQSB58DhHDK+jdbP3iPuyKdq7FuT1XMhb/EtrS8NKgkZwMDeL5vcXNNbxshiazg23bC1kyfjUroezJhLqEfjjzKyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 10:11=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> On Tue, May 19, 2026 at 11:40:48AM +0200, David Hildenbrand (Arm) wrote:
> > On 5/19/26 11:05, David Hildenbrand (Arm) wrote:
> ...
> > >> The only requirements are that the kernel doesn't oops and the
> > >> violation gets caught. Beyond that, behavior at the address is
> > >> unspecified, and which installer wins the race doesn't matter as
> > >> long as kernel integrity holds.
> > >
> > > You'll have inconsistent TLB state.
>
> Wouldn't it still be either or with both cases being okay?
>
> > > I really don't like that approach.
> > >
> > > We should really try to just take the lock, and remove any code under=
 the lock
> > > that could trigger such unpleasant deadlocks.
> > >
> > > Is that feasible?
> >
> > ... or can we run into similar problems with kprobes? (I am obviously n=
o bpf
> > expert ...)
>
> Yeah, I mean, that was just the first TP I found scanning the code. Any
> kprobes or other TPs in the path would behave the same.
>
> When this fault triggers, the BPF program has already malfunctioned, so i=
t's
> not going to be a high frequency path and performance isn't a primary
> consideration. So, anything that can ensure that the kernel doesn't crash=
 or
> lock up would be fine. Any better ideas?

As you guys already figured out the trylock is not an option.
The fault handler has to install _some_ page and let kernel continue.
Scratch page or arena page doesn't matter. Potentially different CPUs
will see different page. It's not a concern at all.
bpf prog is buggy, but the kernel will continue to work without a glitch.
bpf runtime will disable and unload misbehaving prog.

