Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC99606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UvQ0g2fy
Received: by kanga.kvack.org (Postfix)
	id 763306B0639; Thu, 12 Nov 2026 21:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B2B6B063D; Thu, 12 Nov 2026 21:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677746B063E; Thu, 12 Nov 2026 21:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 497D06B0639
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:06:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D828580160
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:33 +0000 (UTC)
X-FDA: 85428456666.14.A204CD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EACF1180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvQ0g2fy;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794535592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNZDrVcq+boAL+pOGbd+KtTtVDRMXO3ms/PyKJ+Acm0=;
	b=pAHe1QaauQ4Xx1MdSr96m6gEyhURUfqsfqDXMr2yXhbpmNC6KBkwZyB9QKekBkdkTm4Xc9
	Dz78yd5pBJK+1I2Sq3hHrQx86f7r9TnYyVgyBvo7UUkjdPxNb2kWegzzo8ScRjsBh9pFmN
	5H4R3XG5a4HnRC5AozlJK2qeni2Axx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794535592;
	b=yRcAGtqyBVRxQMybeFSy3JIUtm4oP6d6s4aFtapt3bVoR+QZ5YUoJfFy3gQUdhEuCUzIJB
	i7I/n3BBpTrWoMssz5ksC7cvf/ZeyWypeQZDpp4o9pmFi2O6k/PO7eyF1VkFhf7X90kcim
	J5WZaKhsh0sVLi9BiGiGfjKmY8D3lPM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UvQ0g2fy;
	spf=pass (imf06.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4981D6186B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED391F000CA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794535591;
	bh=XNZDrVcq+boAL+pOGbd+KtTtVDRMXO3ms/PyKJ+Acm0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UvQ0g2fyOtnKkzpD32DDtLAtYh7n3uX34whzYXUtynStniu/ZUr6P2swEhdKImhXk
	 VXt9CkbAaSQONdXE18vQIqxHYby7NrNUzKbvSsxbhBbbmiC9LjGhLMhONKX0doE6st
	 1SyTvd1gmPqg8Al9VUM/xTAJ0dgtwz4xvk1qxWA6BRIn6KkqeJaFZhbQo19qSGpWg7
	 49CVUQTGAY74eyv9LGp8nWY8G/am6vZSzFE241EuISc2ieHfoRd+0A991Kh5oO6g0H
	 dpEhGiuOGFIUy9NOZSFSrx4LbPrXXkD0Le3aRL0PzQslBrBXrxfJMU+Pm97ZqHbGFc
	 e+1ZD7kRj3/Bw==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b56bbf8330so524894a12.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:06:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFAWtzpls3xHZ2iW942N9HbtW/5+0+Bk/CaZ/cwPCLQQYMxZS9mAu7PtSBabBU+2zSwxfkCIugPog==@kvack.org
X-Gm-Message-State: APuU4Z/76JKxcq0HHSbqlqaICXvckMyzuxmktbCqQR2igws5qqXTuDMc
	RZ2Iv5yUuynX6uTzwF8f2jobeb/HHURTS87w1bjRYbTvjGFENSlgFnovmKkLiax3Pe9OOjWaJ/C
	331cfhxmT94DZhr+48QXrzXRMdkyV4YQ=
X-Received: by 2002:a05:6402:c50b:20b0:6b1:a647:981e with SMTP id
 4fb4d7f45d1cf-6b7c0c52570mr790505a12.24.1794535589658; Thu, 12 Nov 2026
 18:06:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
 <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
 <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com> <20261112081348.GB2668804@noisy.programming.kicks-ass.net>
In-Reply-To: <20261112081348.GB2668804@noisy.programming.kicks-ass.net>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 13 Nov 2026 10:06:17 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7U5=VYEnb9sv4VF7p6Wc77sy1NW0ZCPH23LzPr7wYkRg@mail.gmail.com>
X-Gm-Features: AclHuK_JVN4dasIdBgm1TIXgmrLvT8GsJW8f9xBjTyZqO8uWl502owJkHbxQpwE
Message-ID: <CAAhV-H7U5=VYEnb9sv4VF7p6Wc77sy1NW0ZCPH23LzPr7wYkRg@mail.gmail.com>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gye8m9mtmc5wa3cq9dgyywyaajuqfeiy
X-Rspamd-Queue-Id: EACF1180007
X-Rspam-User: 
X-HE-Tag: 1794535591-914827
X-HE-Meta: U2FsdGVkX1/c6xtrgXGLmQ92D6WMdM2dR0nFhjxY7xudnZ31j//MsEst5+uJAFR8StljVJyCmK7D4d7HGWMEcwvtHM+uozbdIfdSDac4fvKR74AKEV72ifOvj96j7ZvqsEnts2tfGtRhCKPtXnXoKzK1cO1uIYC33yEFyjd1eox/Dp/+KLcBWqinStaMhs7n420H9d92QU5SpqVipODoCITLufuWkWvrrRifLM6hemqk2JTWRZo+Cu/AqVe5SgEhFTQXX+tUYSvHsy0czztQF5yMQHyEsHqEP5iO+EpWgh5S9ky3XhrxWL6Cy4jTatyZ42RwlAFl2qoS+v2m9Bw+iInoluJMYth4xrpaOCUHFJAFUVXAL+bSqt4DUK7ITN0RpjzRJxOn0m6XrjQS1ebfOZrKJd0PyN8qOKS371lpxoJKJyU3h6Vx0uStqzUpk7xmkY3X1nQJ5u2+MR3/KHTPMVeweU0xxJd7tguuUmsRY/9XeRfy1nWJ6n28/Y4Nk6BzQNQU1N2+21/0JTCSY77obe56bRa6tGNfWHfPMFYY6kfpwBh4ErgETBBNzuRicCGGPwKzMiWweM+Ix1ZEdE+MU4+TmuzhUzrcsa3QEWwLOqe6MARWwlv426zK7a7odONoKRVx372lj/WZrQAPrgvTkTWKWmkY9IXJlgVGraicUFjiyBBgvyfDikpVy/L0HYfFUYtealgMNM1k7+ezHq0C8IuAA1//F/qbwOs0DpFTmd35QOfBQTmzz7TkvfQFNynwNqCGh00pcs1ZvdSm9jMNfZSnElyYhnbInTOXgaEYcdk7SC1UMHPwh+y3RYe7ItZ12IS945EocxZ8HQKtgUM+o54EArrWeP4abBQptVVEdZmBHnG9I0NdeyAn4xl6Z2fQwJnlWatKS0aDRdZ63qcYo1SP62+etjs1EgCDxGLA6dHX7/Rt1HXwHvCzZZdPnLEwAaYyvQjZ3sC/SMYBKIH
 pFYGjd9F
 Hlue+TxBigKjhCcm32ETep0XRjGjZQa9NZw98mS0uXbAKReB8u4i2eHBAmLK9NRL27xrz09Kc4tjwbHVSKVbosgyewxbiH2qrhVMaTGSIsCcWc7awE8w2wfN1uWxGDK1M1sM2PE4DMSLOgZZ6Pyc+vQ96pywLi6Em8mvnlbRq2o94IJrAvwvf/wyWBztVX4lc8XmnUD84tcUdQ8K0ZcHd5PCn9UTn7+U0LLMx5jVr3CQtneTJcOWjzRpSQuBjiX4TeiTLt9/bh3jdeBnbSx92dRzsHWz+OvUipwv427E3RktZBaRIjuiKANAxqcAUEnCvtW1zcp3cQBG/KihXFwhh9nxkhXGELZxtHGl7NfqA0p5NSl5AoLuJefDaDZhS4fuEzVz97uKGvrg7Pv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:13=E2=80=AFPM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Thu, Nov 12, 2026 at 11:14:57AM +0800, Huacai Chen wrote:
> > Hi, Peter,
> >
> > On Thu, Nov 12, 2026 at 1:06=E2=80=AFAM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >
> > > On Wed, Nov 11, 2026 at 05:24:21PM +0800, Huacai Chen wrote:
> > > > When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) ker=
nel,
> > > > calls to smp_processor_id() in preemptible contexts trigger some fa=
lse
> > > > positive "BUG: using smp_processor_id() in preemptible" warnings, w=
hich
> > > > are harmless noise because the process always executes on CPU 0 and=
 CPU
> > > > migration is impossible.
> > >
> > > The check is still valid, you don't want to have any code that uses
> > > smp_processor_id() outside of preempt_disable(). Such code would be
> > > invalid on SMP, even when ran on UP.
> > Thank you for your reply.
> >
> > At first I also think that smp_processor_id() should always be called
> > in preempt disabled context, but after investigation, I found:
> >
> > There are 5 existing skip conditions.
> >
> > 1. if (likely(preempt_count()))
> > 2. if (irqs_disabled())
> > 3. if (is_percpu_thread())
> > 4. if (current->migration_disabled)
> > 5. if (system_state < SYSTEM_SCHEDULING)
> >
> > Condition 1 and 2 is to make sure smp_processor_id() is called in
> > preempt disabled context, but Condition 3, 4 and 5 is not.
> >
> > Condition 5 can make sure no context switching since the scheduler
> > hasn't begun to work, but Condition 3 and 4 can not.
> >
> > In other words, Condition 3 and 4 can only make sure the current
> > execution will not be migrated to another CPU, and I think my new
> > condition is exactly the same.
>
> It is not; your patch would suppress any and all checks when ran with
> just a single CPU. Even when the code is clearly buggered.
OK, now I know my skip condition bypasses too many cases, then is it
acceptable to use "if (!IS_ENABLED(CONFIG_SMP))"? In this way the SMP
behaviours are the same as before.

Huacai

>
> > > All code must be SMP ready.
> > This is why I use "if (nr_cpu_ids =3D=3D 1)" rather than "if
> > (!IS_ENABLED(CONFIG_SMP))".
> >
> > >
> > > Aside from that, nr_cpu_ids is the wrong number to check.
> > Correct me if I'm wrong, do you mean checking num_online_cpus()?
>
> num_possible_cpus() is what I was thinking of. Notably, there is no
> requirement that the CPU bitmap is dense. You can have nr_cpu_ids at 256
> and use 255 for your boot CPU. It would be completely daft to do so, but
> it is still valid.

