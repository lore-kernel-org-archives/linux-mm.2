Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DD6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6EA80192; Tue, 28 Oct 2025 13:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6A98013F; Tue, 28 Oct 2025 13:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795ED80192; Tue, 28 Oct 2025 13:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65DC58013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:31:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0817F12AAB7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:31:08 +0000 (UTC)
X-FDA: 84048213816.28.F2D45F0
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1A051140011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:31:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G+eG65Pp;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSwI/dovbxHZsefyXJPKSjPbHaJhS6KhhKTTIMoQyd8=;
	b=udbJIhh2KXApppfQKjQ2tdpfRnAOympSjLcBU5iCDfzypqh2gAZYeiMiRHRIm8sL+QU9Tt
	8SpgPfG1+jCnJ8GRKHzelweMfuBYiR/p3T+O2cC9o489vr18r610l9GY0YS+2Ba6C+Vw6v
	/urXM5M/oOJAyROmR8HOzjJwEjLLsj0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G+eG65Pp;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761672666; a=rsa-sha256;
	cv=none;
	b=VO0TtZUUFUxp8mHMko7K85n65KCkRVYlcCwnX3qYSgmYQn5xIC6eN5niR6VbKN42jH2jeB
	t4rrA3w3TPyNQmn3D2dYuJwBw3ENv8DgaYE23vsGsKlxuC/ZrhtldKxP+r9XV2CTyReZiF
	kSbXo/f27cjv7PX9zrWxqsbMxPF4/f4=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4298a028de6so76369f8f.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761672664; x=1762277464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nSwI/dovbxHZsefyXJPKSjPbHaJhS6KhhKTTIMoQyd8=;
        b=G+eG65PpX3DHjBpO0HiKar+gzQ19vGvl6gWYQdJd/b/iJyAgIMwOB9zyl8Y7XvCCF4
         MXl8SrEIWauQfVM7IJ4rMrzWfTHTSGSeATd0mQZEDZ1HtHX8aBr45kOB/VpD56Sa9ZGn
         TY8VaCEsk4rA9PrAtwAGX/0+Gmo7UX5wn+96PAehVw8t5ZyZ3dEcC5XesaBzDbeTUBL7
         zJTejPn/ylVLBSdHk2BM849rTy/3KUdy/0UAxNqKSdgcfgxG6P7k4ZD0cLv/yNE5moaR
         X44h6eACEi9ejUO9x7B7BzQBp2nrqQthJsXkwurghKKF1zsnmpvG/bQgpA2UMxa8ZYjx
         H6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761672664; x=1762277464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nSwI/dovbxHZsefyXJPKSjPbHaJhS6KhhKTTIMoQyd8=;
        b=WdOuvcDlHXD6N8PFyM/iOdRmdO8uEfnH8yS8qehrycdkVTXxbCzAXYiMWw2siGxp4s
         13bVlzt+3aLScu0xXaleYmSr9nWeA7MuP4WurwELmUc16qu1xS0au01i647FZvJu6D3R
         g7nEBSHOhTMCVCde021Rp/K7EUnU9TNOVHjq3c/1PzZqVzFu9v0Et7UDmaP8T+rDYoiI
         bPe3pw9M4DRwIDI8Fogftk5vqcLKwVSjj54KpZCGRdd0+1/NytLF0X/8CYhoTxQHxwVv
         tJfsAK/8tCuWd2Pdx5UmcbKLg6H/vI6Y12GDyXNmbc4/ObVdpT0BSZl2i7poI6Gnxs+b
         LhdA==
X-Forwarded-Encrypted: i=1; AJvYcCVIKQcD+RBup+3EaDVBWjjvZYfVcLbt8HVyaK94gA/mkQ5yHq+Hy+00EqxigKqNPZjofRNFLIMgrw==@kvack.org
X-Gm-Message-State: AOJu0YzIjRCipdrpfJUGjMN7g/7dDUiHCofCpls6h0VPywRirYf78cwz
	m2hdcuaHPA4aRW54peAXnUl/+wmaNY6QCKG9WndekXNs8lVbTBMe8ncfzv8f7FjGI5B3BNpX3dt
	HdQNfjDK14qgVaf+ivew/iUpyK+DAhVU=
X-Gm-Gg: ASbGncuWNr3jgEEh/4gI7revimgjD6AZta2O4gEKo8mbt4vJIhcFfX1xarZOK62Z8D1
	DKqv13ouFFIa4p/PwHfnFDoRQBlKVBfOYecy7x5UCZrz/R3YW8ngksvez0it0FHRL1Xb5bXdtz9
	wlpK7MvxNgZ/xoM3a5LnQSSbVGASiYKHqw0OsjxYWQx2AwRh2ZfThGHA1c1l/kqnT9zDl3apIwP
	c5RC2nMZOXdoBadX9BrhWgPm1UzQ6OkNkDPxhD/5qgmXWP/pk2L/fbrWI/j3/qyeE+5XV/hy21a
X-Google-Smtp-Source: AGHT+IHTdDJ7W91+X0Lit2Jf9Ol9397LLqUf9gynWpswTVO1GNQdk1TYiUTC6R125faMYDU49nZxa0ZLkOYh93L+Thc=
X-Received: by 2002:a5d:5888:0:b0:426:dbed:28c1 with SMTP id
 ffacd0b85a97d-429aeb04dbfmr49732f8f.14.1761672664362; Tue, 28 Oct 2025
 10:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20251027232206.473085-13-roman.gushchin@linux.dev>
 <ab8c7bf2f312e150c22d83e5ebe91e17f3c4be42b3ff0825623caf3aac4086af@mail.kernel.org>
 <87ikfzuezd.fsf@linux.dev>
In-Reply-To: <87ikfzuezd.fsf@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 28 Oct 2025 10:30:50 -0700
X-Gm-Features: AWmQ_bmmzQlUp9ca5HlQPxn2I7vrph6AvsljwavTyuNEOnR6T4XT912-2Ipx8hs
Message-ID: <CAADnVQLcmJ3X7X6oW_v0KgQCPtgjmYNtgfqXqH5tFrQ+Q+5v+A@mail.gmail.com>
Subject: Re: [PATCH v2 23/23] bpf: selftests: PSI struct ops test
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bot+bpf-ci@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, inwardvessel <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Eduard <eddyz87@gmail.com>, Yonghong Song <yonghong.song@linux.dev>, Chris Mason <clm@meta.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A051140011
X-Stat-Signature: cbd5kum48qehidg4hb6zqzsqiuikxnwd
X-Rspam-User: 
X-HE-Tag: 1761672665-94147
X-HE-Meta: U2FsdGVkX19ZsC8f8Qblem2hQywfiz64J1iedeRa9PHtxptAuAYirp2cYzsX6SXSY9rNHYAN1Bm+sm42M70pM/OJfwqnShqkK6UTrB1K3wgGDUS39r34diYrSqNL74ntqMTzu3Q28ZKOGs5nklGRlSWP94PB/BIqEGiQl4KACkS1046GfSZIM1H1rTpGtFXhoFNtmMJQU4ZxhoJVHjh9P57HFFjEVoTAkmVklLjXU6m/SnpbQ0hjTb+0BS+fjBI0cyuFzzTaI6Ex87wDzTc3LQw54SwALizi5zlAp2XLyt+8+ioG1GUtFPWDXD4aM8yIxIobt/v+K+fmDAq+dJJz7XsiKSOrpHgaJlmJs0xuPxHgK15fkogFXTM/EvhCFzje4fA6idu4eAkznvV2tyISFE+f7cvXb5SjqOCWOwy4qKSGsQNyDvsD/tmZiYqTfcXfcvd2IW/D7bI++azCx1NLZOOQT2kgd9IHpPpTOel1OnVDqa1c3vvppQEAkCVskkBvYd1lydf+r+E3t1HuXUsvVOv2JOU+gUC8MHFvlVS2bu629q7k7JkKH5aUjApXWfyxlzwArc3SPR1dQfu39tSU0ZtA2cs0MTd7j+cFhM07aBfzyb54Rf/ukm8xyHQu77cjxsCsR8Ohb+9nmC0A4xNZjzrsBHJIOVTkgFNfFZJbdYaAPCxk8+SBo1bRaRxmk4jFKcG+tjfEV/gQAnEfyrqDMXtWDpdSXOvgIPO8/AR782zO9fPiYV8TPDGdNabmkY2H7V4M20bYEyeJZeB/nIx6A6wGvlfU42DfH5fTfWJXbCJU3zDkWVleJcPrbNpv6VjtjgsHg/pkQEa9BUVqfxka44YJovvwLvype8FEfQNHJXJKlugDLlwSeZtyWA1Mfx6D8WWoMMipaoR7x40CkIsxlwl/FVGPxR0jVItQaSecKjoKk79jHiRvemaobV3TJ368zRck46lqY8xFh7otrc4
 wYpWhQGz
 1tm4SeR7HPHNCIn601oXj+G3hCtvNI7Kecs5LXyoRFOKHK5nnGCTC/nGoQV56tg7tdybKucii7ZrqqepjYlIIR5BwF8XDENByaL1Zhe+8q+LsPc/iS0XRu/yUcVhgWixLo/LeV5EAv1EMm6OMUTGNtctaRofnTsenP299neZJexrxvebc1GPToaxUpypWUuhTS0jbzD9xK3YvJHO7e9emJhmi5x2OwcV0dGFWtEkwxLqK5DaB7xtqWSrYOrS36psjABqHfI6I8aWW3YZyf1b4UZlhY2nFXnmGApWcihmZmP39YcNSDQGsjs+Nf4AuKs9zUg/3sV8HVxE0sBhpbeQY5gv4DI+8zPdnAtvEo+nNeSb2maznT5IPKqQjGpUl3qq87klBuEKOqS5qjbbRpsX8avmLpPD3Dt5HP4G4I0r685lLMUlrKWHZveRr/IMloIBv8DvlXgJ8MZoytnMc75ttNMNVuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 10:13=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
> >> +
> >> +/* cgroup which will be deleted */
> >> +u64 deleted_cgroup_id;
> >> +
> >> +/* cgroup which will be created */
> >> +u64 new_cgroup_id;
> >> +
> >> +/* cgroup which was deleted */
> >> +u64 deleted_cgroup_id;
> >>    ^^^^^^^^^^^^^^^^^^
> >
> > Is deleted_cgroup_id intentionally declared twice here? This appears
> > to be a duplicate global variable declaration - the same variable is
> > declared at line 13 with comment "cgroup which will be deleted" and
> > again at line 19 with comment "cgroup which was deleted".
>
> Correct, fixed.

wow. TIL.

I didn't know that C allows such double variable definition
outside of function bodies.
Even with -Wall gcc/clang don't warn about it.

