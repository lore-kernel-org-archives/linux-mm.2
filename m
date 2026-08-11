Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 373D8C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7876B0095; Tue, 11 Aug 2026 12:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF326B0096; Tue, 11 Aug 2026 12:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E536B0099; Tue, 11 Aug 2026 12:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE6966B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:23:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C88A404FC
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:23:11 +0000 (UTC)
X-FDA: 85089508182.12.462517B
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6709140012
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:23:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FrLF6ObM;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786465388;
	b=ti64YzuiYdN1Cn1Xs2a2B9OQSSrNu3Oq6n0NunpJASJdLSRuqQ9RomG1Up3zVxN3v274cA
	aQybz+0xF8yTkU8IcwI6idiU4MRBd4Il3reL76WxOtsQTZNkcpXpqjf3B00ScXBsWFgGaE
	5omfkcW+I01xfkCVIC+qWTlLczHb23M=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FrLF6ObM;
	spf=pass (imf09.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzsxg0SY/U6IfS55mTTNvzZ0Cp4+HE5FIJRTaudsYBg=;
	b=AnUQq5U6izBhjk1okdrBIwMc/McjGgB48AB7kvV1E+CSOfwVi2Nh7CVpBtj64+IzydazKM
	6ruVO3diwNlkqRaii1n1pvYyGnNtbfSe+B6+rhEmE8Iivun2bxHAq5NZMewu133nobJ7Uy
	TLynAOrOGIhxfDVB11GjDwov6ChSTa4=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a17f91so34043a12.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786465387; cv=none;
        d=google.com; s=arc-20260327;
        b=UuGJwXavLnjbq+C6639DEY7cYyvkGKlk/aHcvcJFOKC0PKRq3bq3OSiomVXzBv46Qm
         3LYMasmN/xvO6iVZdOs6Z/fFUOamaVufXwn+I8Sj1Fr04NsQ+0sNkbbsky/1h3xudKJ2
         PaI+9eGAKoeK80L7O2nc5H6Lx5dTgHNHNz5ULL/7wdViyV43FSTmlevxKnYtp3FOIwQM
         9uSldl/8qcnnKtQyFwDmzV1A/KAR4aw4bXwOfts+pXFepHxtHd6jFs/+S9JJ5YVIOUkt
         Y18ZX31z549Rd9L5V5/57w9lG0BlARAfiLzbW7DXOmrY8F/vefVUWRwlUeQN82oY4R4x
         EI2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qzsxg0SY/U6IfS55mTTNvzZ0Cp4+HE5FIJRTaudsYBg=;
        fh=yrhDVrAjbgBx6RNm5WVWInc6NHrq39FulNLGAQP4mVY=;
        b=JzBodlaInvELudXj6TA7tvfljPZk1QtyU/v/M3A9M9uWCKkao+h6RG/L+SUz0s8HXT
         GcwLY43AFUm+dADvxdjn6dWupZBoIkZaf3URT+LIcNgzULuW2FmoAZSsFngbMRSAGqda
         NB10C5DoG3oHiXHickB3WdKOKX5fNedOvRcjSKkKPLZgZ+jYT56p2PmRLZL4LG+h6h3w
         5ONRtQvOnTdX9GYQ1LDaC39y4OBnvQVJekTTrYekeGQmRewoTZuigq5efvSdP6mrSfGx
         cDZgA9yiYhd0d99S5xl431vVsaybz+qz9u8O3qKFQZ5X3loVQDKcFzNCRTYMtS1GD0p7
         Ty+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465387; x=1787070187; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qzsxg0SY/U6IfS55mTTNvzZ0Cp4+HE5FIJRTaudsYBg=;
        b=FrLF6ObMWJsmcR3aBKAfvEUwSe/Ux6WML5rDCq47Cv1uKuW4zveY5DyHpnRFEULCHM
         xi/JwkIQd99/nvLC1Mu+FS68w2L36YVu7CppXlSKRgVgBSVElPEZJtgY4/frMCCi4tp2
         TJYAsnKMiLPInh5Pvfxzucss7WpHz/mzgLDiu/ahTc2bXkJHhSPJQfpMUxGcQpsUJ36N
         2QI6fkyT7+Gl9k/1Mf5ab5tySs09N5MBHIwYWtUtHtrC8mklglg8Iz7D9avOgwqvFZ/K
         ZgfcAxAvOEQ6U8gagivr06hl8iGBdU0THj8NUmUYlzaSieH+DwGluDRQqFeFg1kL1qcP
         K/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465387; x=1787070187;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qzsxg0SY/U6IfS55mTTNvzZ0Cp4+HE5FIJRTaudsYBg=;
        b=APLTDCNpqQ3vUbjCa4l382O46bI8Q55hVZW5B7OrgZ+0Ua8iSUuc7/uDGxc337WRup
         tg0bLxH79sjVTDOdRjrK2ryGAfUggXwyyDrLF6Uji8+QMrsE+Rrk6bO8QYJXddZnvvcp
         UFtf9ytdPc/SvqYRzwYnFGm0Q7kkxp6aLod8WM2h4jqbLPF4/5YxcUAD2Ov9Xd0BKVBp
         8myH/aHZlP+bdQ0zyTTilNUyr3gfPsGlyVZUL6Y+sxo0a1PYpxD9ePqQfE9YjblzW8T5
         o/haZdFLULi6j/SPYwEgLNR901ok/fY+9z3mqwFl4uADRTLT+NyDELMY4GOCO0Wvm0CM
         mqaQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqb8L8iuaNxcsd5MczkthKLRGsV7GSo0LmQaRj1bnsPM0uoblr66RIR9qQZ9MUW+DcTZ/PRONBB9w==@kvack.org
X-Gm-Message-State: AOJu0YxbCnRY7aBmRglQfZlQ3SSwSFBDJjqXjpXkQssUIYo+RNMZdykU
	mm6xX42REa9krKKEOENowiR72lsdcEct0Oj6HL/WosgruvmQLX8ELDHk6oNeEqF8wlC8NEz0CRX
	QnDs8BzwCR61nGTRLJ0y2pU1oYlm07zY=
X-Gm-Gg: AR+sD10NlMrtFGpqwn1bmvJZl/XVEpMKgoDe/3rz/ZrmPGFBS+vwroPEfmm00nH8MhZ
	K1FnvkNf+Q+5jGJ1aoBZBrsw38NLlnTv3/YkSECwnJ3yV9aHDSb/N6TKjSntmyv8uGKKPY9PptY
	xMB5vQPN0IvAuX68JfaQNf/AFPyiff/hGP2inZB9BfQ2gxVYurdyenrsS7UF1GN7IPWWJy2W0fY
	JgTg/WQiYHwIjSyn/xLLb6f7a1rTNddGK63f4lSiEPDR2zOMalNhMMX+JgIOgqzM52MXBFqPgAj
	pVbkSaPKzrqsssaiUE2Mz3ymqVKQH52+FDsTGJBglm1zgncfpEKcuY0eFnP+PdjH78e/tH+O50G
	q
X-Received: by 2002:a17:907:6d04:b0:c1f:c03a:960b with SMTP id
 a640c23a62f3a-c20e6317b05mr238926866b.32.1786465386997; Tue, 11 Aug 2026
 09:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260808052732.2589657-1-jackzxcui1989@163.com> <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
In-Reply-To: <20260811-zerfallen-boiler-bissfest-cdb998278337@brauner>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 11 Aug 2026 18:22:54 +0200
X-Gm-Features: AUfX_my7RrpW5x2bkYwMaUE0UjYUyZu6pwxULeOHYxOTAhMA3cZycO0hfNh3N9Q
Message-ID: <CAGudoHG8ff=8RA+8e6JUtESDxBHFjZ65UiCaM4X_6qSU6-Q9Nw@mail.gmail.com>
Subject: Re: [PATCH v8] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
To: Christian Brauner <brauner@kernel.org>
Cc: Xin Zhao <jackzxcui1989@163.com>, david@kernel.org, ljs@kernel.org, 
	rppt@kernel.org, pfalcato@suse.de, viro@zeniv.linux.org.uk, corbet@lwn.net, 
	skhan@linuxfoundation.org, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	ebiederm@xmission.com, jack@suse.cz, jlayton@kernel.org, 
	chuck.lever@oracle.com, alex.aring@gmail.com, arnd@arndb.de, 
	keescook@chromium.org, mcgrof@kernel.org, j.granados@samsung.com, 
	allen.lkml@gmail.com, rdunlap@infradead.org, kuba@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D6709140012
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: snroxtmm3ezdchhetnmfiztn9cqrhx6f
X-HE-Tag: 1786465388-431514
X-HE-Meta: U2FsdGVkX1/dxvwpJob/AydwnA1qlRmtQcfQZRzAjjcIIzHZbuZDpV7741XFWPLspR9+/vuQvAxsa4MX3KzKL90Wb1ACZzEi/QiMv7gCmx0fgUnWH/B1fxagbkYMWIkd6OJ/6OdKX81/b5AbJy+WVOVIHdK67STQx5QprFm+Ff5q0iqadygXggFZEvI8hRBWRXAzhJgPQytQISZuUGruIak/JYGwL9qjC08iOti1srfSdCQnkIFxpEEAn/bDlLTy7YCjFu49Vw8/0OTcykJQU3TqY1BKeGKP5WeXSGQw1Ce5mpHyM/KWZcvaHFe031rFdctwBPuw/aNYXcoCB3gddbf+VafYKdbdzvD7jABj4bwtaz/Hbt2VDOfo22wZ/ToAfQbkWIQp6riY+RcgZzZALqmJ8kNuiVAEsV0uJjZjeFVrQJRhPOFpSFbqqXbkiYJtrOp/r1yp4UUfiVArl1O8DF4gz3dlJhLfu+fwyP6rUtCknBHIWky1r0eL/TceSDm8jSu9UbKqRn87OX+HZyuZHgVa8yDJxj265oEdzQIuT21VrBtmW/642F9WnRf+8Eena3OAk41jc1kYcb4q2fRMY8AJUilMUkEkm8mLBD0u8nq4yplZgcUEw40h0/PnjYF29fECL89eV9xArGptZ9KWr3cyj2lVYVzueRTDCDTvnIObbyUh7yF00v8CUdeJHFroH+guLoteLtvnopSmdb/pxOlfACJ894Wwc3ggeARs+xOog5FgYC+wPxC1y9QaLxVdIISbALe1TBQDmBP7zxsuhqPUreJoMdF5xTq+/6QMeeYEyldo6p7aNtRft/EqDcbidP7aoX45t1M0JbvImz6ux2tL8MYrffR7tAuzq5sBoFgI93NEwAD6cESqbbNeAHnr+jdmxvCxCI+sPjAbojxh7j4ts8Z5Myo+VtnPzZ7ZdHc1kmr7OklQ1Vhz3DySNegKxNMnd4WlnJouATMyx5X
 kBd+VV48
 UZUYYyKW9lCS96o+lH/nvHwtkoziZ9caFbLIGPtyApyJAkL/+ZrDxzaEzhnfFuxOIMIL66oCnHBh49YLPrwxlsnYfW4qifB0fOQ1hu5EVlePcXB2Ugax3xKbht5BreoObvqDSuN9FRbg2BUW9IvFnknGbQBXa+e/D4XXTddErHPoVEwtChUUHJjV6ASGFfNftkuSZmtf4g5dXtCYn8K3amoZnRgR94Bm8HkScpBiJoCqI00jS/rFNNLp0O4E9yuVxLrS6aLU0+Nzd74EPk4aQFRhv4VkXTEKyYNZ4tXxipD1EVFHynhDLarwgYuqHfvyBv4lxaBipjKPqdc8Gbzle3PN12RMxTnqfDJJUekuWa7tySbBEnBnoH/R8E93PBlz0DmG+J9e7BoPyc5wLZHCI+d1bXmmSrNshtIqYKYfMn1WJzNAcfuuV94efwQf9c1X8tDGyLcm8LXepLrZ+c9j/cApYg0/GPtijZ2nbRvCTyPkiPSK3cwoQL5ssgIkBhM7bkGA8Y9s2MHpqjKlMVDvrHGQxT4sSpKgLnXYm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 11:09=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Sat, Aug 08, 2026 at 01:27:32PM +0800, Xin Zhao wrote:
> > A coredump typically takes seconds or even longer to complete. If we
> > happen to hold a write lock with flock just before triggering the
> > coredump, that write lock will not be released during the entire coredu=
mp
> > process. As a result, other processes attempting to acquire the same wr=
ite
> > lock may experience significant delays. Another typical scenario is tha=
t
> > some custom management modules for shared memory also need to release t=
he
> > reference counts of the related buffers as soon as possible, rather tha=
n
> > waiting until the coredump is complete.
> >
> > Add a new bit(9) of coredump_filter to tag whether need to dump fd list=
.
> > We set it by default because tools like systemd-coredump go through the
> > fds. Some other coredump pipe programs like minicoredump do not use fds=
 by
> > default. If you are sure that your coredump backend does not use the fd=
s,
> > you can clear bit 9, which will allow some file resources without VMA
> > references to be released earlier.
> >
> > In fput(), check FP_DUMPCORE task flags to NOT release file by task wor=
k,
> > otherwise file put operation will NOT execute util coredump finish.
> >
> > Test Case One - flock
> > Test program send signal SIGABRT to the program which owns the flock,
> > output the wait time(unit ms) to successfully attach the flock.
> > Test program malloc 500MB heap and memset it.
> > If NOT set bit9 of coredump_filter, waitms is 11280.
> > If set bit9 of coredump_filter, waitms is 0.
> >
> > Test Case Two - ion buffer
> > Test programs include ion buffer publisher and ion buffer subscriber.
> > Ion buffer publisher output the ion buffer hold_time if the subscriber
> > NOT send ack to publisher and NOT release it. The subscriber will trig
> > coredump by itself in some time.
> > If NOT set bit9 of subscriber coredump_filter, max hold_time is 19591ms=
.
> > If set bit9 of subscriber coredump_filter, max hold_time is 320ms.
> >
> > Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
> > ---
> >
> > Change in v8:
> > - Delete the duplicate description of default value of coredump_filter =
in
> >   proc.rst, as suggested by Randy Dunlap.
> >
> > Change in v7:
> > - Fix description error in proc.rst. Since bit9 has been added, the
> >   supported memory types should now be 10,
> >   as suggested by David Hildenbrand (Arm).
> > - Link to v7: https://lore.kernel.org/all/20260807040124.1706927-1-jack=
zxcui1989@163.com/
> >
> > Change in v6:
> > - Fix operator precedence in PF_KTHREAD/PF_DUMPCORE check.
> > - Link to v6: https://lore.kernel.org/all/20260804001703.1340667-1-jack=
zxcui1989@163.com/
> >
> > Change in v5:
> > - Not add another bootargs for the feature,
> >   as suggested by Christian Brauner and Lorenzo Stoakes.
> >   Add bit9 of coredump_filter to tag whether need to dump fd list.
> >   Set bit9 to 1 as default.
> > - Al Viro, Christian Brauner and Lorenzo Stoakes point out so many
> >   problems of the code related to umap that was added in v4, delete all=
 of
> >   it which is unnecessary. The management of reference counting for sha=
red
> >   memory generally does not need to be released through the release
> >   operation of files that have VMA references. Traversing all the threa=
ds
> >   within the process and executing exit_files() is sufficient.
> > - Fulfill comments and commit log,
> >   as suggested by Pedro Falcato and Lorenzo Stoakes.
> > - Link to v5: https://lore.kernel.org/all/20260630075604.52533-1-jackzx=
cui1989@163.com/
> >
> > Change in v4:
> > - Christian pointed out that the coredump process will traverse file
> >   descriptors (fd), so certain fds should not be closed by default.
> >   Rework the whole feature, add /proc/<pid>/coredump_pre_exit for user
> >   pre-exit resources selection, default is NOT pre-exit anything.
> > - Mateusz suggested that walking the fd table and release the file-lock=
 is
> >   reasonable. No longer release all the fd(s). Based on user config, on=
ly
> >   the flock fd(s) and the fd(s) correspondent to file-backed shared mem=
ory
> >   will be released at most.
> > - Link to v4: https://lore.kernel.org/all/20260624145552.70143-1-jackzx=
cui1989@163.com/
> >
> > Change in v3:
> > - Add comment and commit-log to explain why do the MMF_DUMP_MAPPED_SHAR=
ED
> >   mm_flags_test() check, note that memory mapped files keep their own
> >   separate references to the files. The case to work around is that ear=
ly
> >   unlocking a flock on a file allows other processes to lock and modify
> >   the mapped data protected by the flock,
> >   as suggested by Pedro Falcato.
> > - Link to v3: https://lore.kernel.org/all/20260619122419.3954581-1-jack=
zxcui1989@163.com/
> >
> > Change in v2:
> > - Get rid of the implement of adding new fcntl API, the issue does not
> >   worth inflicting the cost on everyone,
> >   as suggested by Al Viro.
> > - Call exit_files() in coredump_wait(),
> >   as suggested by Eric W. Biederman.
> >   Add MMF_DUMP_MAPPED_SHARED mm_flags_test() check to filter cases that
> >   need to dump file-backed shared memory.
> > - Link to v2: https://lore.kernel.org/lkml/20260618150301.3226517-1-jac=
kzxcui1989@163.com/
> >
> > v1:
> > - Link to v1: https://lore.kernel.org/all/20260618030700.2511668-1-jack=
zxcui1989@163.com/
> > ---
> >  Documentation/filesystems/proc.rst | 17 ++++++++++++-----
> >  fs/coredump.c                      | 21 +++++++++++++++++++++
> >  fs/file_table.c                    |  7 ++++++-
> >  include/linux/mm_types.h           |  6 ++++--
> >  4 files changed, 43 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesys=
tems/proc.rst
> > index db6167bef..aee03858b 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1927,7 +1927,7 @@ will be dumped when the <pid> process is dumped. =
coredump_filter is a bitmask
> >  of memory types. If a bit of the bitmask is set, memory segments of th=
e
> >  corresponding memory type are dumped, otherwise they are not dumped.
> >
> > -The following 9 memory types are supported:
> > +The following 10 memory types are supported:
> >
> >    - (bit 0) anonymous private memory
> >    - (bit 1) anonymous shared memory
> > @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
> >    - (bit 6) hugetlb shared memory
> >    - (bit 7) DAX private memory
> >    - (bit 8) DAX shared memory
> > +  - (bit 9) fd list
> >
> >    Note that MMIO pages such as frame buffer are never dumped and vDSO =
pages
> >    are always dumped regardless of the bitmask status.
> > @@ -1946,13 +1947,19 @@ The following 9 memory types are supported:
> >    Note that bits 0-4 don't affect hugetlb or DAX memory. hugetlb memor=
y is
> >    only affected by bit 5-6, and DAX is only affected by bits 7-8.
> >
> > -The default value of coredump_filter is 0x33; this means all anonymous=
 memory
> > -segments, ELF header pages and hugetlb private memory are dumped.
> > +  Note that bit 9 is set by default because tools like systemd-coredum=
p go
> > +  through the fds. If you do not set bit 9, files that are not referen=
ced by
> > +  any VMA are released before dumping core. Some file release logic, s=
uch as
> > +  exiting flock or releasing references to shared buffers is executed =
much
> > +  earlier.
> > +
> > +The default value of coredump_filter is 0x233; this means all anonymou=
s memory
> > +segments, ELF header pages, hugetlb private memory and fd list are dum=
ped.
> >
> >  If you don't want to dump all shared memory segments attached to pid 1=
234,
> > -write 0x31 to the process's proc file::
> > +write 0x231 to the process's proc file::
> >
> > -  $ echo 0x31 > /proc/1234/coredump_filter
> > +  $ echo 0x231 > /proc/1234/coredump_filter
> >
> >  When a new process is created, the process inherits the bitmask status=
 from its
> >  parent. It is useful to set up coredump_filter before the program runs=
.
> > diff --git a/fs/coredump.c b/fs/coredump.c
> > index bb6fdb1f4..ed4d30916 100644
> > --- a/fs/coredump.c
> > +++ b/fs/coredump.c
> > @@ -521,6 +521,25 @@ static int zap_threads(struct task_struct *tsk,
> >       return nr;
> >  }
> >
> > +/*
> > + * If do not dump fd list, files that are not referenced by any VMA
> > + * can be released before dumping core. Therefore, some file release
> > + * logic, such as exiting flock or releasing references to shared
> > + * buffers is executed much earlier. Note that do_coredump() often
> > + * takes several seconds or even longer to execute.
> > + */
> > +static void coredump_pre_exit(void)
> > +{
> > +     struct task_struct *tsk =3D current, *t;
> > +
> > +     if (mm_flags_test(MMF_DUMP_FD_LIST, tsk->mm))
> > +             return;
> > +
> > +     for_each_thread(tsk, t) {
> > +             exit_files(t);
> > +     }
> > +}
> > +
> >  static int coredump_wait(int exit_code, struct core_state *core_state)
> >  {
> >       struct task_struct *tsk =3D current;
> > @@ -1124,6 +1143,8 @@ static void do_coredump(struct core_name *cn, str=
uct coredump_params *cprm,
> >       if (cn->mask & COREDUMP_REJECT)
> >               return;
> >
> > +     coredump_pre_exit();
> > +
> >       /* get us an unshared descriptor table; almost always a no-op */
> >       /* The cell spufs coredump code reads the file descriptor tables =
*/
> >       if (unshare_files())
> > diff --git a/fs/file_table.c b/fs/file_table.c
> > index 16e52e7fc..6ed8ace8c 100644
> > --- a/fs/file_table.c
> > +++ b/fs/file_table.c
> > @@ -566,7 +566,12 @@ static void __fput_deferred(struct file *file)
> >               return;
> >       }
> >
> > -     if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> > +     /*
> > +      * coredump_pre_exit() may release files before dumping core.
> > +      * Cannot use task_work in the case, needs to release files
> > +      * earlier.
> > +      */
> > +     if (likely(!in_interrupt() && !(task->flags & (PF_KTHREAD | PF_DU=
MPCORE)))) {
>
> Still NAK to this whole appraoch.

Would you be ok with a variant which merely unlocks prior to dumping?
File descriptors remain in place like they always did, but that bit
about them is changed.

