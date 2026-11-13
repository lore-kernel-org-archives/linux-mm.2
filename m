Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06DE9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=duCzVb79
Received: by kanga.kvack.org (Postfix)
	id 021F86B05E1; Thu, 12 Nov 2026 22:17:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14F86B0654; Thu, 12 Nov 2026 22:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05DE6B0662; Thu, 12 Nov 2026 22:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A98C96B05E1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:17:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 896DEA8DE0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:17:43 +0000 (UTC)
X-FDA: 85428636006.17.69B207E
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B37C40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:17:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=duCzVb79;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794539861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5967ZDHxZDdRDcuY4ilKzGF/DOGAuv3g8MurJqoARQ=;
	b=ru/c+N2NTUCn21NChl6oCZsW0J/3CHldMBLLBhrFbyuTsRJT+nlqJlQaUqu+uwA1MA6ep1
	0KRI8gHfxHKyse/ozTUpgQ5IE/1ACCNJl+yyNmmOf4Ieh4ot9nG3xyccsjSeuQyuKXpqmP
	XGQJ08pyCGaccCfl/7Z3qu5H0p3RnEM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=duCzVb79;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794539861;
	b=wLsY6Aje72sktDP/deug1Rpt7kmUrSep/sR8VnxrSzRoBDEl21U7D3t+JcKceTsb3L0AbQ
	ONKXDqpmPnOqJ9dQv9YIHR5vZtjkEduzNlHQfHNV4H0lvZvpa177AYEI1xGStqJi4n0OTq
	6bwUQaf5i9U+k/ySM8DJgh2zBxt3ffo=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-54492d8a988so109611cf.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:17:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794539861; cv=none;
        d=google.com; s=arc-20260327;
        b=ejpz0ovXuZ+0EJE2b7CCijt30loY/aJ+kU9AZQ0y7ypHa/Ecxv8urFFoS6/9Z3KwOr
         mlBYsJA3oUwFgeQiV8a26ybSVjYCbP4XTEppsof+KNNhPLI8l3EiQCKxgdbQTVHlqckM
         mEDP9vtQ+2sFvL7ps6jCX2nIh0pvwVHnstm0kZHr8YjIYFerDcxdrdyzX/WIYyY6UaDL
         cZmQLUIjavUoUbnaGVhgq/I9TyUroDGKIyPlYBoaICtUlWGrZ1w+p/rKBP4dIrJ7LuCw
         bNF0Kg2kV3y9FIbkK2GaHzr6Pep6tcBert3yuxy9k3oVOKK7yEb8zjycbsBBL24Aix5s
         S3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n5967ZDHxZDdRDcuY4ilKzGF/DOGAuv3g8MurJqoARQ=;
        fh=dVbye+YdRiCkDcsavP6OXrDyvTUnfCzxFaJDmbD9HLg=;
        b=kRVyvY2TtQwidoXt0mmq7SIwtW5/PTdlez++dWODSlHaU8LCtNHgPHYPhUiU0l0NVE
         mNxr0BuyieyDtuuQPlPXVIozxPv0sTFYThmT3LTLhffYO2dLrubFhv6zy0jN0jDn1ZHu
         s8iIqx2PW7kDVqY8+dyRYYZ0SiNd+qPuJn/xWOJqAHD+uQrv5ISqUl30S6EhICTLHI1M
         0YATpKq3Cgk2tGqwDQDJEtyybS1Cwko8QUVbEwKFoNAfVKoNLvNK0Yr9cilkp5b03kPV
         ky8val7xRl5zrLX0t1bwP76341j2COUrF6QTtWGXa/J+MVWHMKe3W76KbkHbmEkbAkkU
         CpGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794539861; x=1795144661; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n5967ZDHxZDdRDcuY4ilKzGF/DOGAuv3g8MurJqoARQ=;
        b=duCzVb79s8QKpak0yHOzDOEdyEzhXpkIruxiKiplB4kxd5DRo4KndJaSz7DTlhCVlk
         svtcapKvRGHBONvgH6nmP2vIZE1rY0tgq+LoUDWkpR31s9gifEd9Ce2RMQpGFArupqrz
         y3o3dVHMWNlfFSUBZpCwKxUhV/0buDz/b+DnAWyPzZSr0glmArgJMNwUJz6f5BapniJp
         FP6m07YeoByWiDUK8CGwOFEgREnm3Kjn4g1qbRc8TJm8/GhsjhnX5Wss2Y/44XcUNKn7
         Z6IPyxv9a5j1y0Ip+nLYwd8oXa8WPvh/IFmXL8qvrS3fXx/gdhQUSu2ukAKgYJgg0w5U
         ifIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794539861; x=1795144661;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n5967ZDHxZDdRDcuY4ilKzGF/DOGAuv3g8MurJqoARQ=;
        b=dqHfLMLEac00jNHAQnhG6vmTMMTgWzHuMLKvnVsukj9m4dyhaoieKSfR1KCXiWpVzC
         o+nHPDMHaiQqcWNSE4/stY1NXqlZdeO5EfnQ1LDZ7Cxfi/tn+U/rWso2dpjiIMDWYFN1
         bAS9hId+5OGmDOFEX7cKs1VoZhe14m9A++pPbb5oAm0lEWNfmYVvX9a2g1nQkMpLLUgQ
         MndR8Ne0zQy/jDAeh6/9HftV8d/WfseZFqKfUErcgjypwG5LtnnDZU8ZBLVEdhbqBoj8
         ltyWRO6Rf1f1clia3XePVVOjwfoZelDnTPA6DEYqrCke+5H8VDmMgtQyTPxQSDEJLiBG
         OUxQ==
X-Forwarded-Encrypted: i=1; AL+hErHMjcI01DwB+wTvQOtsRByWycL2l8zwG67JL/2jpGMJ7JyT3ARJiFyp6T38C4WgoU1lnV4Y8Ym+og==@kvack.org
X-Gm-Message-State: APuU4Z+lTEQzqyHvWZ2OnzMNqKcoB41J0qnX/R11jvSkcYjrQIQpc5/p
	P+n7BDSJc64Q+F5d0YeIzjFvDZh6hf16fD202h0dxSpAWBMgLxTclfaF9s1aunoFlFYUdaozfZW
	CxzLcza5SQdw05kIKh2fMKhn5t00hnFgPOrYsrtCy
X-Gm-Gg: AYBFou0dcnVDdChc3RBQDCJQIFVNNFeyWbnqflLq7qj+1dw/Egziqvqvidiqyb8ujUR
	5w7ZXYHyTxtRi3yg0cLzf1g7eo+t3KSHV2TRaH6j7qBMaPZNJp34A87LnSoxyEa9uCEMXSHVdU0
	R9cPahlAyCVEARBpyjgcoTySj0oKltRxWW0uJj2cewFXZx79HQaYbDkawtKDDGgqs6CGvCfRph+
	MTPL61EswjcQbvFeBZfxP3BTxkFuIBbhNYmkrgGL3p8sc10BYt/qXk4QZbFj5erpXje5hr59Kru
	ViNvJRcZzZ8l7/+K1NLmSooA20mcYtOGOLCUApx6PsJxQ3+6ioK5lkL/zzz/IE04BXuvM16y4Xq
	TrwtLaYK+x2km7IFblDH5HtP4Wq6ALtLotuvywiZ3lbV9UpVlW5CLrTKC0giJZkWl4+U+1XGZy0
	ObeWf1/UZeTMPJ6Hdb
X-Received: by 2002:a05:622a:408d:b0:530:e335:4ef with SMTP id
 d75a77b69052e-55ad7e74d7dmr3502411cf.2.1794539860114; Thu, 12 Nov 2026
 19:17:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112140101.647-1-adrianhuang0701@gmail.com>
 <20261112183727.68afda9533aff699eea12cdd@linux-foundation.org> <CAJuCfpEqQQb1_UkWH50tgbdVz9KZ2anfCGWsvvoYFsnC_KHcjg@mail.gmail.com>
In-Reply-To: <CAJuCfpEqQQb1_UkWH50tgbdVz9KZ2anfCGWsvvoYFsnC_KHcjg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 19:17:26 -0800
X-Gm-Features: AclHuK_2-9zUyKpx_ep8Hdpnolqj806Xeb68SWZdKXrDA-5ZStmcnD2-HIkJzN0
Message-ID: <CAJuCfpH57DNEb5ckB_c4QTWiiHVGSHNhB=S6HFdjvJ6GgGNSnw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B37C40004
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tjyp9h69m3f56ji5w8513nefh5wzm9br
X-HE-Tag: 1794539861-447203
X-HE-Meta: U2FsdGVkX18YhOYbMMJZsLTFO323fBmZDtUS6ZlZj4fQ9caWlGptDU+zzT5r+0Jm8M68yhLSQ+ftFcvZypJivATggCgQPzm7tnya7gTYABHlUtVJlijkGBTBzgeQlGf1NiQA5Nq6zvBEc2079OeOpN96ZZ9CYfjJGwRRJqBoOPd7dA1lSzYymZdEIOek4mHxcL+MSEPLr8Hib9IP3uqsbIcTyUQda8+8ZRPmUiM9xLQ9ekSVTyV6m+L+l+j/DdbrIK57SAE8UxDIqLU4/Shw1R2lutWM1tZ+WrRAApfzs+MCXbgGK5UDzD7Kuu0DGqxersuSTwe3pFk7mvENWdW3ORGQVMcUjQKHIconntB5lbz2uAcDoMORbPtlNxUD5p0kRB+kDIVG8XGel8SjUlZ1zc8WpBlaeijQ3yOqV5+GtZZPBGW3PrtU52BsViUTXixAweEVrN+ANXa4VV0b4a9H7oRWwrlEyD01zWRUThVWmf3V+dOJe7kJHYlg7ZfEaqTK2KqXfgJqVQMU9sQ37j8eMTbhr4OU/8m1Ct3M1UCCZVlib5P2+GSRCam8KQghryS3hQYctztrMHOmJ10q0KM0DbR7osar695QAR+Dv8KjuyDQezWq0gjwLbGD7RmeLY+atNmHU90keDb+q9EqeSi2+gpmty7uDNZO9Yjo/ZCiVTYWkCRD6ttyYY0sgbt1iMd0oEaOr7tnf0bsQrIpg6kfirEMiUR/Hi9heOBRJicLHd7KZfMb7J9WEhK07odNIqgOKSUnjm5SwGVRUjijw/1md8DEGX+g5qZkX80tGKkOp0wuhEMphlMw7je3CLQ7JkG14360jk32LB3QoMLaJWCL0c2hVjrw/hT2xk8MOsyyssPqivLQwnBdSAMyJWbaFcemAOFwSLVKCh4qQYYJ3mzFjXyZ/y7eGWZWoA5wEY9VNGJlpylCawImG6+AHRrKIGaWwhXhoRt89RigAqwQren
 2utT4w7P
 VpeOfUlLilLs8kShmlC8xa7CWdZC7cqxWnpAqCX5xN5zZszHLCjEJzPgDVqF22qDTKMYUJBEz+423xP1cuDHqXl8JCX0Ze7L82oh3FPMnHhl6ND7FOt28XNTIOH9bUhTYpsHDD6CGp5w4trGhlnUDR5kltqv2lsq/mXu43iqP2/XcU3K8O1EXV1n+I5O7YThMgyIyZ8jkhk+v4Un1IrU56IHqF33s7CAkjgRaNM8AOav/GaIIGfO8i6Cp+POy3vi1HvmmnKAFpEKCcF5pPRd6piDEjgDjYNsQLhIb+QyEsgqLyax6ejFy1rs/z42M70BxNVhFE9cetx0pZtrZoye9vrUr6v0AnUVdpz7N95/4PvM2HAujezin3KkZXrJ8aI5RcDQyBQ8OuXKkoYkx+U0MF80qtnIRFzCTEZ4G3LuRx6vLLZgQhfaN5aR6Jqs4adGZjOD3+u3aq2778Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 7:13=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Nov 12, 2026 at 6:37=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Thu, 12 Nov 2026 22:01:01 +0800 "Adrian Huang (Lenovo)" <adrianhuang=
0701@gmail.com> wrote:
> >
> > > Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> > > per-vma lock") introduced the possibility of returning -EINTR
> > > from proc_get_vma() when the VMA lookup is interrupted.
> >
> > OK, but what's causing the interruption?
> >
> > > When this happens in m_next(), proc_get_vma() returns an error
> > > pointer without updating the position index. Consequently,
> > > seq_read_iter() reports:
> > >
> > >   seq_file: buggy .next function m_next did not update position index
> > >
> > > The above buggy message is reproduced by the following command:
> > >
> > >   # stress-ng --vma 0 -t 60
> >
> > afaict "stress-ng -t" can send SIGALRM, but mmap_read_lock_killable()
> > only responds to fatal signals.
> >
> > So please clarify: exactly what is causing this to happen?
>
> Also I don't think stress-ng --vma 0 -t 60 command reads maps, smaps
> or smaps_rollup files by itself but I might be mistaken. It would be
> nice to get more details on how this gets reproduced.

Just after sending this I found
https://github.com/ColinIanKing/stress-ng/blob/master/stress-vma.c#L536,
so I stand corrected. Still, it would be nice to know how exactly this
issue is reproduced.

>
> >
> >

