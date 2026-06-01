Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF72CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222DF6B0194; Sun, 31 May 2026 20:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3406B0195; Sun, 31 May 2026 20:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B5A6B0196; Sun, 31 May 2026 20:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4F1E6B0194
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:16:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7905E1C085F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:16:34 +0000 (UTC)
X-FDA: 84829427508.26.891AD31
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B36E14000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:16:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Zg9zN/E6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780272992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQdZFdRPMl5NqctlRONekKw7Ci+pCu3VSk8zafduNPg=;
	b=eEsC7GWwcS2O/Sso4fRcNoBvuhTV98yNfyKkxPJAKLddPS/bASrWlUoc9E4NfEgQ1xvGQV
	obMZe4HgDgBjggqiPsWL0qaHi+nvqf7qAqoF0BcFpukHO/AxA3pRpvo6/cGiNCDuKkmvkl
	Lxp8hVdjsZ+Q4KLE62HvZ+RY/WA3HYA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Zg9zN/E6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780272992; a=rsa-sha256;
	cv=none;
	b=ikbjNQA7H+mJ10/xtQ3JL+rDNg4rlbhWIDrk0lrJqnpXH6NhBw7A4SAofvmtNZsnXGajnr
	3ERndlOZzgKORF3TyVQfuc1i8jfrjV4MuxLdCjBF081W5ReguJWsUvrjjQ4GwcRp4dINCr
	OF1DLnbrBvz7xWoI9IC42VuelJNo4r4=
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-485fc256028so1214071b6e.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 17:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780272992; x=1780877792; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQdZFdRPMl5NqctlRONekKw7Ci+pCu3VSk8zafduNPg=;
        b=Zg9zN/E6YFelvChQa6WOP9xDOUhCG4TsQKEv+mAac9xzYnbLJ1R5Vqes6sJUrOt+F6
         FnnGPPuQIViXM7TkAQmK8V16YXAzmh8+HwhtLbA3QyNb4k2MDvFL+bAP2L98hMWajjNC
         qTv46cxebN3L5YrtYB0eOr4nfJI1RBPVTIfrw9/9sQQubJvB6uU6EOzGr1WBmM4dfkqE
         br3fAFKw5aoQ8cM5q5arapmelL9FyRClqFfj9NkRiYmvpYNegpGMJOuJgkshyVafaC/D
         KrpuGKNuFqi1Ph/mxGJuPDbXoLHKWwl+Wcu3TlL+3r0aPM3JgGQQH+zW+9P+duHZuzFy
         heEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780272992; x=1780877792;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZQdZFdRPMl5NqctlRONekKw7Ci+pCu3VSk8zafduNPg=;
        b=VYfJVCQhhZCjPld6TjlDEd1q//AKzW5r7sFsauCHTks/SJGMb+/NX2fsEUoBFtF6cT
         7NMO6cKW6+65ZLsPAapG6OEKLXipUpnIsVKTeAfE8zR3Q/Gir3gJU8Lws9B6N4TYgcZV
         6m/Nr9GPrxTjSurEfeB/sGbgXPQl2fKu4l94QaDyVrNvLdJDXoMOJNlWRo9lDoeIHZN8
         zcNH2u7hGIZfQgjDgj+j/kZEFBMXlCFFyqWDjqkBOxxnZBGnf21QXfGmGMsxddoZeB3O
         Ts0O7pR9FDQXy/nWL0IEKxbSNWKacf3mjDMPA9LvTKAAM+xHpbp3YvqBrIU9H7NE4O5f
         ITtw==
X-Forwarded-Encrypted: i=1; AFNElJ+33FBEfaSl4zJGWofzGD9n+VsF6cKeU4339pe1RhDIWzdf9Icjls4EXQPu5ug0Rwk+4YkAzy0i3A==@kvack.org
X-Gm-Message-State: AOJu0YxuyIX0yD4JD3l6ta67hTUYbfLBCkkowbI0bUyiwrjwNkF13BzL
	rz43iZ0la0u0/8Wj5zBMdokvkc20MUIk8in5ek4Jhfsv/vdDSwItAKJm
X-Gm-Gg: Acq92OHQxriTh6UDxdkGk96EH1MWUvFhiUYgNb9oRaZaGXO8ou5kDbfhTRDCNcGPLGA
	jSPqaHFvwCw4gWCmLUGvn1i9LIsOsr/0Tth4+Talh6wnzTOhalXYoU8pgZRRHVKyZqEbVZFWSfy
	W8evyG3x1DOBKgEyfIZW0qwvRYsV3BZel0Nr8auZdrEe3k3+1uXeNsbZRjmsaGc/Qqtqs1h/gtz
	TpV0IR5+G40ukuP5GJ8oIRrJzplABJt4cjZWD3kCCFyU2cILN9P/Bnn6yVnVhcnFFz/pgFNin9x
	rsaxdoNjaP4dpwCu9qwiGdv5oqpjBQOsBvAe9TU06/+JbJ0bUT84TZDGBJrs9Gt5HuYtqnb7bjT
	S6GGbBLI7td5k0pZuZ+RVxI6mY9/TOIaaRS9R9R11YauVirl3Og6OUMQYBXR4v/a0MSjw7WfEWR
	w0QjoSZ6u6XgYZtHdQqRpUy5cSNLjesQEimcS9vxKNbhQgywgovdJag+LOglg7f0ULvugSk9XGt
	029injnhV7dbtDib8zrDDjd
X-Received: by 2002:a05:6808:80c8:b0:47a:499:b616 with SMTP id 5614622812f47-485fb2aa4c8mr3766450b6e.16.1780272991503;
        Sun, 31 May 2026 17:16:31 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48605f6a576sm3396395b6e.4.2026.05.31.17.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 17:16:30 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 31 May 2026 17:16:27 -0700
Message-Id: <DIXA3RWL6XLD.1WZMXZRHBH1SD@gmail.com>
Cc: "David Vernet" <void@manifault.com>, "Andrea Righi" <arighi@nvidia.com>,
 "Changwoo Min" <changwoo@igalia.com>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Martin
 KaFai Lau" <martin.lau@linux.dev>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Peter Zijlstra" <peterz@infradead.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, <sched-ext@lists.linux.dev>, <bpf@vger.kernel.org>,
 <x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Tejun Heo" <tj@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "David Hildenbrand" <david@kernel.org>
X-Mailer: aerc
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
 <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
 <3901fe0537edee9d7acdfd91695ead28@kernel.org>
 <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com>
 <ahnedQ33ZH8ogjbC@slm.duckdns.org>
 <8cc56c7a4aa29628b7d17d85be7eadb9@kernel.org>
In-Reply-To: <8cc56c7a4aa29628b7d17d85be7eadb9@kernel.org>
X-Stat-Signature: ooekmy11et3c5xbuioy6uxmj89j5g9xo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B36E14000A
X-Rspam-User: 
X-HE-Tag: 1780272992-119522
X-HE-Meta: U2FsdGVkX1+PBRJZuPw+DQrqINE6jn7Sy7+g8QZ5PyjkftJZ0Zg4lQOgYjGptmL0+JmkgUcJuiOW5VtfEma1UXxHOb8zJzCy9ii8Azt0Hdxwbap27c/nCsxVNuBQv5iYWjSmQx9IrsIk3EXkg2r5FVa9qQbfASrzxvk6TAPqK7MiswUsmmPNSyjjPtOGoOsosTZz5buKt3wc+smRsCEXMjKQqw6UpGGP5TqlFVHsNYt9WRvQawb4pYswgYt801R/S0r4Tzoft3R6T6BPdj6WNRrTftX4Yrm0w55IeElTDWQ4GBnC3BeGvNsDQWxJauuZma7ww7wErvknJk9QM0IrMPPQtqOaNZHAcni8So4pO+IK3NBQDBYi3Rv57iUpotMef4pn0FiVLKmrjDFAeJIYeKVwFvLrGWdVILqPbT7YQN5tF0juXODYhUUHSQ8jcOJod+vjtSEWTCUcbedqfl/nnjJnzU6/tuyPCBNB1H/Fv5yyh27pc2Eimmn+yKp78/yE0ZPYKnG1VgxAgrN15KIAt89WuXMgXe108Q8aQAQEkKOlSk4/gBOxW4ElllF3KaGGel09paPDbQjujCQwiZd2SRThPwpycLPtyKU1lomk38fSx+UoweRh8uF1Xg/k5G1qyTcIykF/Xiis9DuWtJNPG0opmQikSwHMWLfjK1sWjzArnhi9vmMJvOTsciNcEXEJE5RdcIkkaxbCwMD4VIUy7zCzld4IWdiLXy7tTP2XhlLPTm57k9HmJWKcN/eRKoO3DSBIF+wor4vB3WTj6g64YNhar0NnMHWHTenTg+rmpPj+/sQZhOua+HdlXj/fSrbTumQeaZ9kUikDG0S2cKNAPcQJz9HJD3rsbBbvZQlhoxQuywdKz04kTVcSvU9o+qwol0DKyHfKuOwonZmGd+aRpBSSm6DjQL32XZd7J+i/JzZPp26xLm2ie4FtHti33ZDAQATKAUXuo3BY8GUT+vO
 j/T0TlMH
 BolkfHlj5tphDgXUkAETNNTmrO4JT8vZf75D+uU+5pPy3gwX7OrQ2mXFV6qZsUbo1+/pqN+QW5QlBiecwgpe5Q3U3G0yI9JUSkRBYj1Spl1KimJJw6lTgsUkn//Hj1atNlrwLY8Rnm4T2GL3caWX6ISUBttsobbcQEOujrocdkXAsw7ijSMJFkHnKWfFFhEXFPw1yWl/mX1YaxxyVXiGxbWS8Akz7lo4lr2rDfTQoyM1LbI7zKjpahIbYRswx9yMi0zQWW32I6h4DSyG4Mbyq7ogUu51wfRo+NdlZ0MFFjhrtdIPV0fbqtmjTlMc1Oa71r3RIlW1G+mQhkdXS+M7aAkkoNWtXYIJwC2lswhnBO/CdcABqyWAKI88GEiaY7tG2EnkhHnaKgLHU+HpcmCgCUKH7wCcicS1yUri1GnA/0hICI4DNHoRxUBDCoZhOH+/QLYU84ouE9cUT21wjM9K0QSxqkUQ6grFiSOs7U1/YhDj5CtugX4UdweQRwsMvNiob9XPloG4yshwv7JOb7YrE4WWTkzwGgZJaPc324w4BTVRfOlhISnUAbxcdUGGTaXRm+bbrwMirpgNJk7leCn//qmg5Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun May 31, 2026 at 10:47 AM PDT, Tejun Heo wrote:
> Hello,
>
> I posted the check removal [1], and Sashiko's review flagged a
> break-before-make problem with it [2] that I think is real.

ohh. interesting.

> So instead of just dropping the check, the install should route through a=
n
> invalid entry rather than overwrite in place:
>
> 	while (!ptep_try_set(pte, mk_pte(page, PAGE_KERNEL))) {
> 		old =3D ptep_get(pte);
> 		if (pte_none(old))
> 			continue;
> 		if (WARN_ON_ONCE(pte_page(old) !=3D arena->scratch_page))
> 			return -EBUSY;
> 		ptep_get_and_clear(&init_mm, addr, pte);
> 		broke_scratch =3D true;
> 	}
>
> ptep_try_set() only fills a none slot, so the slot goes scratch->none->pa=
ge
> and never valid->valid, and the loop copes with a concurrent fault
> re-scratching it. This also closes the set_pte_at()-vs-ptep_try_set() rac=
e
> I raised earlier, since both sides are now cmpxchg. A broken scratch entr=
y
> was live, so the caller flush_tlb_kernel_range()s those pages when
> broke_scratch is set, like arena_free_pages() already does after clearing=
.

Makes sense to me.

