Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387F9CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 16:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09496B00E2; Wed, 20 May 2026 12:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1AC6B00E5; Wed, 20 May 2026 12:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7006B00E7; Wed, 20 May 2026 12:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD3B6B00E2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:27:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 235A2C18CE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:27:53 +0000 (UTC)
X-FDA: 84788329626.19.C2A57EE
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E97740008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:27:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FEPFUg2K;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779294471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQ42gdFkjplvsdaBjA/NZ7vNSlLmQv5q5YgVwJhuB1s=;
	b=NLwI16bzEfIkjKl0RYnGQyW15D/awckEcyw69H3BdQlfMB7+hSE+MKQwSgjrGoFeERC5Ir
	T1RqYrnZ3dE/gaCvDJBZ0Y8XHJljUz7kXCyXON9SdfkSAlsVgq7K9GGZnV+Ngo83Xw+eF4
	YwKf+YvfoWnz6B3qS1VUrXgJMpqiY0s=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FEPFUg2K;
	spf=pass (imf11.hostedemail.com: domain of jannh@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779294471; a=rsa-sha256;
	cv=pass;
	b=3Ybt73eChdec+S8PCpiMzB4/f7dwmByYgFXZoOrl4Fu/4z8Z1cR0uUbNC5c40ARoSIj9HY
	GKlBeVIEeNmevQqDVL4fclbsjgAbbpu8BFNX0n4/N1mSDycFeooIgjOheidjIHo/LZRWAs
	WP/pBUbeJXRXfZ/JT/UmpBOpd0sSuuA=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67bf769704eso141a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 09:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779294470; cv=none;
        d=google.com; s=arc-20240605;
        b=f9ynCFwFKb/nZvF5dXqn6xL7T5FtfoBAeQ2xttyF/F6YBnoklLOyacwbU5yt1XpTFA
         MRFLrDAbdpicrrdSF5micKOyAm0pErlU/lVCpwmH/zN6Sa3qvKVxSHFazrbDOppSmvUB
         CimYNQZQkqjsQBwYSqU61UQoG5a3Og61W/VgJM0ON6X1VbA+3JDyl9QjI9ab7AurT61i
         5Dn8rgN+bAL3yvho1lXuBwn7aCtK2r0X1+jkn7ovsYgnnF++P3FtPXMz8pb3Pyb+4h48
         WPIsJu3RtcgC+30w5znnR/jy/1924cQooaxnA3RBOi+M+ZsqnMm6sxnULb89mq+Dsjsh
         2Ksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQ42gdFkjplvsdaBjA/NZ7vNSlLmQv5q5YgVwJhuB1s=;
        fh=KpuW35Ct5MwQBW6A5cwwUwfIt6GOzrSzML3c7zKvbsU=;
        b=coemzUkh2Ua5uUgtaQHIgnF2EQRRWUfM68kYZGO4KGPvG0kbWnbzaCN03wURq15x46
         /C9fAyFeKeUBSy9eMBO50nXL3Gh8lgD4U2m4xMo4DT0Wx9iusSThmoOWyeMi8Eo83+lw
         DjAB/d/44S3B0UGCOXHK+YPSTAdtb186ySzE13XD8Wa4vXze2ATqBAZqAkmpkx86X3aU
         PPdG24a5OSpCtKTAQAfl2ai9/OxIyVMvkITKQ88e8u3uMmftiYqQZBN9iBioVpZ1cywK
         uy6jdHgERUYRb9baVt6GNKbYzbZ/6+ihtOVV/5LtsQutu1EDwaCTJwjM2PIWj0/rGEJR
         Y6Zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779294470; x=1779899270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQ42gdFkjplvsdaBjA/NZ7vNSlLmQv5q5YgVwJhuB1s=;
        b=FEPFUg2K8GvwPE/VoPVWQC+/9kfQO09pQp+CZGOQTJ3383yl96Sv9vBrxUzU1oaelt
         2fkkdXrAjy+101Gduq8H+lZtlFfpqHc+/SIUbvz4kQNvIokWkLDa1159F2xsNKF7I9Id
         2F5A7CmK5AmjousnMr8xj22KQxU8h0PKmaKkkInvUfKGpfsxn6sDNGFUaOHfpk8TuXRI
         oIM7TU6qPSbZt5BEgVGyifVvhIWXq7P1l1fp/z589EYcMrXRQRD+KBPEv+33dEsw+qZu
         3orTH7y3pXMb1k8dC02jefEOn/G7vv/AzsR9C0ncNoAfP3XIe0TK+apjIUxLPq5byh5y
         QH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779294470; x=1779899270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQ42gdFkjplvsdaBjA/NZ7vNSlLmQv5q5YgVwJhuB1s=;
        b=fTIBAxno9o+w/f6wyuhzYYJ4STBwfnnt51kMnxioFhjCLJmJE8OWI9FTo7n0Wg0BNp
         JKbVtrQXAldyFIXiDP0qAoJ7LV5Fa4M8DzR/o1eNkoEFVacx+dgwRIwUA5NK/k9Q9gBa
         +uVVPenuLRYNZbnRhvxG6IQo+PFQYxqPazc6hrsajxer901/970fJbMKc4GivmPbUml+
         /Z/6RC8ydXUXbwCtHne1rsEMMlAJTJDsADCHx2yxYLDi7hFIAgZsiyGs6P6GcQA/lXNl
         7TrTApPOt1H4S8qcucWMRvt4KRpXpYLkCj+Byxb+v/PaEdbGWOxY1afxNeNWdqXME4h7
         3ouQ==
X-Forwarded-Encrypted: i=1; AFNElJ/d0aRn99tfnrbVyEyjjAgKtZptPln2Jvbe0tdEdSdrL5s+g1j98PHvp4FmJdYRMuuFZ04SCfxetg==@kvack.org
X-Gm-Message-State: AOJu0YzQUmqp0jNT7uEag+/7wr/yVC+zp9Fn0xp+/wb+Xut4Qiwf4FYU
	cYSK+5toy/n3XYB5SVIXTchiHCw4JEZLd34mCu8TlvUmSOSIAhsG+X58lVBO3jRgEv0U+oHkJNS
	mEPc/0H1q4rnzH1hizrR/ixdne4z3uEUNPbHgMpp5neLPWZvbSD/Eafmp
X-Gm-Gg: Acq92OEYJP9YNkid0E2o4c1FaoiJirUAn5ZeTWEeogtH2u8Xu2fHO7ZRsVUDQeqB/xI
	Vx4vmsynhrMJAftjhf7PTY4jJOJi/F2xUSNYWd3WexrtdXjHig/T3KB9CPtUfOQp+wv+GxSvbmq
	t74iCc/veff1px4ZdXEVAZmPxPy9Pw18bAVEPab820WpP/QgQAvSPKNGXKOBqB3C9yZvxp/B3XS
	FLJJQxTOJi/+vAEXVw6vEugfjjtJcLLhNp6rJNkM29X5at78QWH2x/xp2Fs0wDF/7CZvp+LbCb7
	T3j4IwxoGlLcHANEGYlAoRU5iB0hX+wlZGLboKXTKfoG2zcL
X-Received: by 2002:a05:6402:1806:b0:687:adc:840e with SMTP id
 4fb4d7f45d1cf-6870adc8633mr74826a12.11.1779294469084; Wed, 20 May 2026
 09:27:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-1-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-1-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 18:27:12 +0200
X-Gm-Features: AVHnY4JEq3U0fhFIhqc2VV095Cn3h4nqXd0Hly4IUWd4hdK01E2neLqGO05UxMc
Message-ID: <CAG48ez2ugPCx+7id5Tw6PAGk-0EJW0aw_RkoVpz-jbLLQPAm5Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/5] sched/coredump: introduce enum task_dumpable
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rug4xuhithrxtgoajikm3ir5j7y58ufb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E97740008
X-Rspam-User: 
X-HE-Tag: 1779294470-650376
X-HE-Meta: U2FsdGVkX188/u0A/eXd+awaTVmiH0m+bPEEb+rQmiWptBcGKOKleJzMq79Ly5wXwUbTXj3LcCY1md9zMCkg0XnRCeYHTxQNZn/1GCbbqO3sC16Yl/nXPktgLaGGl+elU5w3kyyO7dtvVn2VXETQAH4hq13SOebi5QXP1u5x0HVGkpmOHDNb9khrOAEavU/1DJdv9Fz2/Jtdk0WsdU4tQSPfI/16z0dAnGmi7vxrmBexqocpiy7LAvv4NBT0pI5OFfZwIMt8OkpkLCRs34d4+TX78T5s1GITuV++jdr9UBUoWIydWKo+oJ0OkJrazaQ22uXotfmdaSrWilLdzzGqNGh/t/+K45OepskJaGgtopGIzOwoJTOF9qwA2tiDadPh3/8WlaRDWFRSRQhgPdQxUG7kFB4zklPny815p5cQeoZMdgcqDe1Z//STkNtAkZaAleMqEH4Y+T+jFAbHlnb7JME0AXTFyVbzBu3AevgwyuR2/pcD7DLLgOYE+5lPzsWJ5zncCe+Aa2nNwKTPYX5YYwBwPgEB0RrsmeDxvON/E0VuhSH7AmE0wyTqJomq7MxL5NuLfp96obKQzy8yW7k2PzJxySGWRnDhqJLIdTmQY1UqbWAxpAySALmx5IVUDvaSYLXBfZfpNn3vf5QKx7KzgARy1jIiqL1uPgzGHNPwpJm6OXTHxHs9M/xTJiOXrv0X3a4omriSM7w1kmu+HFnEvRUFYLDIa+x7CBW7/ngRkugHTFS+U+yvFym5pGoNJQDyjTt98o2CeT6s+jhlbiQFlXoiixkrByLHwbpPZaIkvh53KHL07cL8Cxh4Tjz6GGGfKkCMX6AXkcxg7KGnLcIQ2Z4T7VURQP/LpsZbvdKGfJHKkUCjbUfmEcIk5xoPVguWVUK+WSVzVUM555PwxpMN+NIEffgWJaYAmqqB904lz1NL9HcY+5aZb8tF8dTFytwdpAfKOOuxpxWFTPeEd80
 H8goPXpb
 Tuc7dB2TznbvoOrc1+rqgwApMyEOQ46lzr0qOBWsgVNWJD33CexNAxdNa5vc0ZNySfvD4gP++BzZH+vQOzS4p6H3wjaJg9Yu2gnaBokCarj92AvWp9dnfe2NMQAHU/OF/M7ngothrZDKOalNgUuyiPpCvSq1oyXZk9D+n+oKUue1RnbgFMFVIKsWSosxg5LMFDoIT2D8jNuZbWEZkqb1cRiivU4oxtZKUOFyIgIxVEuM75jKX1qG0U2eqYqzFw2YerTPxv6P4XzPoWSZQ3r9IF1+5bGanLuDIa9NkP0V5+/RJGST89zswDo/4xtLni8bv40BNe22Ab2MmxZy31KbTxQ9OVYglHJnuHO/KhgO9PaM3R7tovhr7NvrXzK0jePFjnJQK0N4efnOb41sqekwEH3+jB4rKFyAMVmkkYsCALQITQb+HMzT+WnJKaKatVO2co+je
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> Replace the SUID_DUMP_DISABLE/USER/ROOT preprocessor constants with
> enum task_dumpable.  Numeric values are preserved (kernel.suid_dumpable
> sysctl and prctl(PR_SET_DUMPABLE) ABI), so this is a pure rename with
> no behavioral change.
>
> Subsequent commits relocate dumpability onto a per-task structure
> where the enum type will allow stronger type-checking on the new API.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Reviewed-by: Jann Horn <jannh@google.com>

