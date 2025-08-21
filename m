Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 456CACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0F96B00BF; Thu, 21 Aug 2025 11:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1DF6B00C0; Thu, 21 Aug 2025 11:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEA16B00C1; Thu, 21 Aug 2025 11:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF3A6B00BF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:54:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA4018363E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:54:20 +0000 (UTC)
X-FDA: 83801211480.09.90389D6
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16265140004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:54:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qeVMHno8;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755791659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fN8fFqbbfxw/oj3xUy2dOVhcytSJepW36qzZ5F62/r0=;
	b=cKjtNliZLMaVp2Z0K7wXYIRPppkIw1R6XbbIQwOQMe9nJNzLCtgsb5NhidNmScVuqyeh1w
	R+nCknJD2LwpPV43nHwOueSW7U7d6GvT7lbX6T/UUaDx57Z7Mx24T8gqNXBKPZH5704Iwx
	EMM8fki00rk10M+ZR7ppSblBNcYTvs4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755791659; a=rsa-sha256;
	cv=none;
	b=3acSENYYR9CoC0Ozkd3YAdITeQe+TrDr4tFCOU9MuE0Pd5h6+1P4FTeRY1l8srZq2sk1la
	cu3gduaiFicyHY7Qa0P1rB6Hmz5X0vVcOSTIEb/kfmdI7MuQtzu1PUiEoMPLB0/bUu1CKq
	y6otZaAbpDXVYuzK12Vw1ICiOzRNh8s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qeVMHno8;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b29b714f8cso320001cf.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755791658; x=1756396458; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fN8fFqbbfxw/oj3xUy2dOVhcytSJepW36qzZ5F62/r0=;
        b=qeVMHno8XqSzMV57VlJpPp4PL3gSIR6lYiTXM+aVg+yTsNG+oEHnKmn6LFEQ4Ueoqo
         RoQmw21Xs4WYZbXXB7sG5DuMNEWk4/jfg2yh5VJWwz7IIYvgh96d93okiFf5dgrkbG8B
         tqprOsGvOxsCJvAZqpl0iO14RGs6h1CYTGeaxyZnGVqg2zpokdZjc3fsxEAgCTrPO10a
         beCiey+txKBkO4wkRogpVG13YIPQdHKob84UTfe3tH1yC/LX/2L1EC1ft5Gyx9hOeTt+
         78Cs+DGSiIwpLMy7POfaGeTfViNI6oIcRNmta2BZUFXJpu8JZE9q+Kz/WycdR9gtr/Nh
         FSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755791658; x=1756396458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fN8fFqbbfxw/oj3xUy2dOVhcytSJepW36qzZ5F62/r0=;
        b=FNolHCRkEbQNu5JKznCVKOndAIgj9rzUgD4Kv0uTClW4ajbUBmUliX3G+haxEEXs0A
         Suj9zAOgV7Ew+j5utnl3WH5kG2WS2TdSVQOunuPtmStIbEBhgEcl5IWMqcZfV/GSTUNG
         UbVUjkU7JHdIqBjQqSwPXY5JsQTOURtGFhChR6r/dOS4d6Ow37f/wmEOZ4bN+Ppi+eg7
         qAUQ+PJJSyPTA7bKUi5bzBKz5jWK1anco4EIJIjEs1gq6/N67c8ILPNfQcyMFPrlXXce
         XOHbTeablQ3QdqB4bhfkaOB/TlIvMOgOXZkktfDnEarv1t4EThJtTCMIYa8Cm1eKpPma
         HolA==
X-Forwarded-Encrypted: i=1; AJvYcCXFEj6jb3qCyF+AMggYtqrr/dOnt46EKDQSvQi4dyuAtsxJ7R7+i9fBtn/ckqW0H9RwKUG8sGC/Bw==@kvack.org
X-Gm-Message-State: AOJu0Yxx8/2SYqQXXg59EysVIr4Lzav2RBi9wrfiJKsrNiulPzBSYdBN
	AEOv8Y1AJTIflGFW47sU50h5wC10t1ipZw+8z0d60GHVTXCZaLA5mwnYPJ2yomISiKLXRz/A+kw
	qGGhaLQoEVOwiPVPUJNtXc2sC48HM+fVgtpeHMqI3
X-Gm-Gg: ASbGncsz1uAXv9wHIbVpsuwMwN27lz0XWbtK5gEzGUQUsF/Kk8GyaJKqu+WkQOuGm5s
	rE2QN7TxaGodUO7BkQfJq1JEHQil4WrkkfpV2/NtaF6JzozK6Rc5TAnU+iaXGqg5PcBKSiCosIB
	nM+G6oBdcwKBblVwrY3FGWkg9VhTUCSxxelADQ8TVrke2tqrBOrFHdbCvv6kdsSsqFMGuJMy+zi
	PyfbFWE0RxYr2TPdQ0ABsn8vuld5kLuFRB+imchzWda2asGL3TjWeo=
X-Google-Smtp-Source: AGHT+IF7ftkzBG+sErHG0PyIKhN56o5QPEdRNCi+vPkHmyiE5ovuaHVbNMUd5SO4AajLAnQHLFuy1cPHbgz3xOWbu6o=
X-Received: by 2002:a05:622a:1aa0:b0:4a5:a83d:f50d with SMTP id
 d75a77b69052e-4b29fa06aadmr5250511cf.11.1755791657570; Thu, 21 Aug 2025
 08:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev> <CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
 <87ms7tldwo.fsf@linux.dev> <CAP01T76xFkhsQKCtCynnHR4t6KyciQ4=VW2jhF8mcZEVBjsF1w@mail.gmail.com>
 <875xehh0rc.fsf@linux.dev>
In-Reply-To: <875xehh0rc.fsf@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 21 Aug 2025 08:54:06 -0700
X-Gm-Features: Ac12FXwQnszAXbgUOsvMFTdZCWPF5sLUrZJo15MDmJrYfWcN3MOe0juq7mH91Ms
Message-ID: <CAJuCfpGTBvwv9vZ1T60ejk+uDVrTLbCDvhP0hMiT-Cr7to6yEw@mail.gmail.com>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16265140004
X-Stat-Signature: wqcc4purhbkdpggnommg5t6pinhmz6cq
X-Rspam-User: 
X-HE-Tag: 1755791658-521163
X-HE-Meta: U2FsdGVkX1+WmHZJohpl8C/6pjeH7ycQt0qQjdNmcnp1AZRmVAdJAlBlso0+A3sBK9sxU0P81F6LTsZEzeXqAA1fpgrLHr3eSGrk13Q46FwUKOwIU8h1w2QtFxswfSDe0LvHkllnN6LL/RbTSoAjQMxbuZcljvCmBuId6lA/mk8VFB3VHV3Ugfu1rGswTlLSv/QodR/jSLCgAlOCTn8knX5uAsGeI/i4ZllVUZqfliJb8T6TNytF253U5vXOiIhvkO+g8kHB1h1OaTX0Z2zd4qYX1CnKkU5WOtgV9zdcB3Bx+EJD6k3UTZB1eMG2BUJtTM0NFyPW0q1DI6uTcjijZzLS4QtUzxHH7YyGm4I0KuHPXID83Q0+uj8tBgLd44jrwGrTrq6IYxNltXsTPREztoMa45UOpUHO3PKb4xO2pqcxwSqLB56V55E9ApPKdTFaSdWYSu6nZJl3yYlzmsZbfovJkFk1K2b7h+29cfsRYvWnPPVQ5oveGD6y0jzV+wZfDm290B17Vnr0Ct6Oi6/97jt7jSODNuJMp3Am8ncbue80uSp11IAliIEmbfzxOZN5SfKF926LH+tzX5h/wnr5Ik3vhF5m5mrYL5GgtLU4eK7Bpq1s3gw02whCP2MXWd3T4LbZ/Ef3a4lP3nh+9vmVy25VenNKYhPyodrXjkRfEW8agTpLvK467WfrNppBwQzcEXTH2LxlLylOizTqLBKgC+RiXsDsuFQpFYcrEsLGsPENpfo4cJ1ZZs8RYva7fiPYSR+F4R6aHgG88PYjsvcnSY7w/DSyUmbVx8sjiRZBXz93chYZFsc8Z7NrKOB/VwujNzBy+h14xsHhGw4nnp1qHDLnYu+ja7tCgBNfTccZ73CjlyYSSLY5LNtqDCGsA3TxTplaMkqTwgemR4B6VO90fV7UIOTsC2Je
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 7:22=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > On Thu, 21 Aug 2025 at 02:25, Roman Gushchin <roman.gushchin@linux.dev>=
 wrote:
> >>
> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> >>
> >> > On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.d=
ev> wrote:
> >> >>
> >> >> Introduce a bpf struct ops for implementing custom OOM handling pol=
icies.
> >> >>
> >> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> >> which expected to return 1 if it was able to free some memory and 0
> >> >> otherwise.
> >> >>
> >> >> In the latter case it's guaranteed that the in-kernel OOM killer wi=
ll
> >> >> be invoked. Otherwise the kernel also checks the bpf_memory_freed
> >> >> field of the oom_control structure, which is expected to be set by
> >> >> kfuncs suitable for releasing memory. It's a safety mechanism which
> >> >> prevents a bpf program to claim forward progress without actually
> >> >> releasing memory. The callback program is sleepable to enable using
> >> >> iterators, e.g. cgroup iterators.
> >> >>
> >> >> The callback receives struct oom_control as an argument, so it can
> >> >> easily filter out OOM's it doesn't want to handle, e.g. global vs
> >> >> memcg OOM's.
> >> >>
> >> >> The callback is executed just before the kernel victim task selecti=
on
> >> >> algorithm, so all heuristics and sysctls like panic on oom,
> >> >> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
> >> >> are respected.
> >> >>
> >> >> The struct ops also has the name field, which allows to define a
> >> >> custom name for the implemented policy. It's printed in the OOM rep=
ort
> >> >> in the oom_policy=3D<policy> format. "default" is printed if bpf is=
 not
> >> >> used or policy name is not specified.
> >> >>
> >> >> [  112.696676] test_progs invoked oom-killer: gfp_mask=3D0xcc0(GFP_=
KERNEL), order=3D0, oom_score_adj=3D0
> >> >>                oom_policy=3Dbpf_test_policy
> >> >> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted =
6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> >> >> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996=
), BIOS 1.17.0-5.fc42 04/01/2014
> >> >> [  112.698167] Call Trace:
> >> >> [  112.698177]  <TASK>
> >> >> [  112.698182]  dump_stack_lvl+0x4d/0x70
> >> >> [  112.698192]  dump_header+0x59/0x1c6
> >> >> [  112.698199]  oom_kill_process.cold+0x8/0xef
> >> >> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
> >> >> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/=
0x313
> >> >> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
> >> >> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> >> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
> >> >> [  112.698250]  out_of_memory+0xab/0x5c0
> >> >> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
> >> >> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
> >> >> [  112.698288]  charge_memcg+0x2f/0xc0
> >> >> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
> >> >> [  112.698299]  do_anonymous_page+0x40f/0xa50
> >> >> [  112.698311]  __handle_mm_fault+0xbba/0x1140
> >> >> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
> >> >> [  112.698335]  handle_mm_fault+0xe6/0x370
> >> >> [  112.698343]  do_user_addr_fault+0x211/0x6a0
> >> >> [  112.698354]  exc_page_fault+0x75/0x1d0
> >> >> [  112.698363]  asm_exc_page_fault+0x26/0x30
> >> >> [  112.698366] RIP: 0033:0x7fa97236db00
> >> >>
> >> >> It's possible to load multiple bpf struct programs. In the case of
> >> >> oom, they will be executed one by one in the same order they been
> >> >> loaded until one of them returns 1 and bpf_memory_freed is set to 1
> >> >> - an indication that the memory was freed. This allows to have
> >> >> multiple bpf programs to focus on different types of OOM's - e.g.
> >> >> one program can only handle memcg OOM's in one memory cgroup.
> >> >> But the filtering is done in bpf - so it's fully flexible.
> >> >
> >> > I think a natural question here is ordering. Is this ability to have
> >> > multiple OOM programs critical right now?
> >>
> >> Good question. Initially I had only supported a single bpf policy.
> >> But then I realized that likely people would want to have different
> >> policies handling different parts of the cgroup tree.
> >> E.g. a global policy and several policies handling OOMs only
> >> in some memory cgroups.
> >> So having just a single policy is likely a no go.
> >
> > If the ordering is more to facilitate scoping, would it then be better
> > to support attaching the policy to specific memcg/cgroup?
>
> Well, it has some advantages and disadvantages. First, it will require
> way more infrastructure on the memcg side. Second, the interface is not
> super clear: we don't want to have a struct ops per cgroup, I guess.
> And in many case a single policy for all memcgs is just fine, so asking
> the user to attach it to all memcgs is just adding a toil and creating
> all kinds of races.
> So I see your point, but I'm not yet convinced, to be honest.

I would suggest keeping it simple until we know there is a need to
prioritize between multiple oom-killers.

>
> Thanks!
>

