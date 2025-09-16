Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D896CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 01:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969AF8E000F; Mon, 15 Sep 2025 21:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941808E0001; Mon, 15 Sep 2025 21:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856CF8E000F; Mon, 15 Sep 2025 21:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74EC98E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:00:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0571013BBEA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:00:18 +0000 (UTC)
X-FDA: 83893307316.02.5D00033
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0EEB0140012
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:00:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EoWIJJuy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757984416; a=rsa-sha256;
	cv=none;
	b=wtQUqEnVJP1WDAcOV1r8vEIte4Zlx8mSoRrVjEM38q/7aUhq3mPPkFGBkvgexR/HQ6Dtgp
	x7JfkgK9TTQ9My26qq0nIIJKuJK9PokGaODxqU1bfkIGJ8A6EqcJMzSGN6rbO1ieyd1MEc
	wkcCpr7WckDNtD2J7KM9sJ8PKwYLUAY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EoWIJJuy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757984416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40khU2eera/C0wIDlxivIo2NAj0/r96JDxR8+rLtfvE=;
	b=i41SyxWMZI1zuwf1At6NCEhXfNgL14NeJ7Qjiy39LAbtzXhzP1kV4MlUgqfhANG1AfcoIQ
	WjzmOQmu2Xvm2aA5xPbzR3tTuQ4nICfhNnFrg8NEm0f8cwS94AWpyI05EgWqY98QwMIJlc
	GiAL+489DjiYSgFSJwomsGz1hlThr28=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ea3e223ba2so1678819f8f.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757984415; x=1758589215; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40khU2eera/C0wIDlxivIo2NAj0/r96JDxR8+rLtfvE=;
        b=EoWIJJuyXofEK1Fc3fyaKmoJ4ATWsO/zKdPxU0QQvomcUER23YEbxnxsaF+U5BHg13
         CD6hKJmenk4TL3fvMqTQIcM6NbHnnDAu+axCkxxXFQhCWVHDP/FEv8CibbB7QLoWkg+k
         lA2DdfsiFncoyCrSV2RasnA67+Li7JBWDujDx8c6p3rGx9UzFNeaVn28m8W34fIwbFCY
         3P3dOq/Z/wFEHoDUdqjTCVwTQ/bqiHMgSpSylHcnSZV2XO2jm5qvubAMJLHpCYUlfGhA
         uu/lazJaup/a+thZqNiJzZ580uZYfLQN3K+GHidUVdZk4pIPqxKR2qN0iHKLS3MNf8ai
         gJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757984415; x=1758589215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40khU2eera/C0wIDlxivIo2NAj0/r96JDxR8+rLtfvE=;
        b=r04OCd1ZCUB4sUTHlXvKzNVBgo9y4zx9B2l6iSc4V/bH+Upe0fzhJYmcHfDnZ4I5Ck
         K19suWkjipvRGwu/K2PIYUZZ5f8Kbr+V79GIil/czLxE+a/ojtLGDEfapNjzTb4u5kcf
         iPc9RCdb4RyOU0V+jarJnOfIaKH9waaoJls67Cv9iokbmF7JbtSKGmU+YEVPaJ6hyWmx
         nfVm17ci6YCjQw0OiYqkOMSn8fdA7BztynSx6MX98GWwF31GHf3/OMECEtvH6B5hhERv
         fchWU2chO6uMRVUiIXE8ivY10SqGfC1k84N+EdFUtUnycTjR4CueTsOLeqSjrvjoW8eV
         eG6w==
X-Forwarded-Encrypted: i=1; AJvYcCXyJ3UUioFnlTnhtUp6D/qq46H/dAlF6zsX4gmxnPH72VWHaPcpnLks+1ASs8lT0On0bJJS4YL+Ww==@kvack.org
X-Gm-Message-State: AOJu0YxXN+3MySUlYareTnh2xTxMuOuRU8+DChTwERKOkNXZDGD/X4Mz
	LMcpprytlxEuuY5KWSF08UFi3gPcU/T5jYWhcMFQo0r5Qg+zaDpt1IvK5pon40Om1g/QY6DMDPJ
	nXm+CRx27YQyDaAqFusI0kzkjmhN/9+a/Ew==
X-Gm-Gg: ASbGncuIzrgCcanuvz5E+hq3G1wz4pd4la8jDsFsxIAVULmuk4hU4uFJsQDx9msIWXU
	ESwrw/MnRSjCYurfT+ixh0Z0zZlO2MkCv7nqA55xBYRCfqqXlcjkX17wcmB5gGRK+gCQthj0eHh
	5UaOSJ7BamU+TfBwYBFjc64ucb5ChlRfiHEG5YSz3gSL+vdW/OTHbXkRs2CHz/KC6v64y+m+Vfr
	+jQE7E9uQV89EB7InZLqStau7zA3CQ4oVJC
X-Google-Smtp-Source: AGHT+IFF/jNbJrg7JsqU1KXpSbCfkS4+VN2T8ZW+UmOw9rPbBXYFNDdRXsyuyZNFSfle/Y+OP+wYAkK7vfhDvIB9uf8=
X-Received: by 2002:a05:6000:240a:b0:3e3:f332:73f7 with SMTP id
 ffacd0b85a97d-3e7657adee4mr12627231f8f.28.1757984414528; Mon, 15 Sep 2025
 18:00:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-7-alexei.starovoitov@gmail.com> <aMgMIQVYnAq2weuE@hyeyoo>
In-Reply-To: <aMgMIQVYnAq2weuE@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 15 Sep 2025 18:00:03 -0700
X-Gm-Features: AS18NWAI9B_2wRiYhYkx2plpF2KQ-My4XIXEQBm9flGJedyurG-fw80e8XPUpbw
Message-ID: <CAADnVQJSS8+2Zw4kAypC7duWhyd2zQeiu1zbgy8WW-xqnBCgnw@mail.gmail.com>
Subject: Re: [PATCH slab v5 6/6] slab: Introduce kmalloc_nolock() and kfree_nolock().
To: Harry Yoo <harry.yoo@oracle.com>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0EEB0140012
X-Stat-Signature: mzsrgegcy6dy34bw51ocoyz85uzf9dsx
X-Rspam-User: 
X-HE-Tag: 1757984415-591956
X-HE-Meta: U2FsdGVkX1+sX+5K2VzwJTOYboTpy9DbE3+EyPJvhBshWo3uDVEogStnlEmFgAY72B6KVw0TsiUW2hHbmbFel/GAKlDVrcIvwX1Gc+cQDDLsiiLqnwLwG0oM24+ZPevMm/8rp7Dp6INWoVqpOHu6VSvk3vBi5WUv38oaP6y5s7HskbigVYxZhS70HNcv0jFQIC3J/G0QiPCxnBMMqBzMsya+vWVQC+8ImZEG3YV/nS616RTquEcN/rDJS2bxg3ruOZ563CwbewU2nUG2Ir40J5hEFrlernwfpIcd888v2rD8uLqchPh4kDIzbwovGDWIgAFZRdeXjVjlEvfGtOacw8wCp/hMMMm3f/jvvHPiV/D2IUnrWlGecYvGXwIbYthVVRr0iYxWuxXabuS23I5p0IlDeMRjWG8VD9MJNGnPEQZNF9GEoO4X40jOnLcqIiq6PhfOebGpjfcUsUNk90+HHCdQ1bCiMkH/H/DqYPrtPSD5fC1C3XojHxOZXq3J5sTZKbbE+deKIof6Dz23ymGSNs+U9rs5FLflfwPJ86d8Oulmd/dVy5NhJ2hqVV7tacp6L6uv2KL4vtCcsAiuBaj66rlKdLEHMP+6K7fuBrRnJV7bZQYjlhLuy1CXc0zHxeXH32qLEdA1NhW23xoVS6WGLh2AsZWSx/INFtgay0EkVqsRU100eyegMpwQFOCyiiFgwcC0FzsVxXdfZ2ZEGGiIv9FvVJBt1bAu+YFNEYNf8+3O3MqVy9O5V9plo2E45grOXhlvyqYluO8HB+pO+TyZD3yJMEexxNf3plsFxUrWvuOo/3nYw1nvONMZCbQhBAJEB13mkT1mEXYhgaYG4VaXm4qBUJa3encGzbPnbJr+XB1AGwwB35CRmDsFeoxviPpu0Z4Sbb2bjXriAZd+7ftfc0rPs1qKcHpWLBS0DDr6YvXKDOvamBi6+0ny3yKSKfbNzhFBtATR3z9eT0dwjU1
 SvqrJveB
 XCN848SW61YSDwrJHCjgzfO8x2CRQ+5hU0kcnf0YMHSRAMDo0mgVEEbuaJJhBomV1CMC97bFt7Dg3ptNOzPXyJiBOZY00VX9TlH9BFoEn6t9+9e3N5Qrl79XZWxIo2EFw26+ynmmgc+OV6omMd3wAdgUa6iabdZ2uDvASMTy5+i1jmPYEkKxukHYEdUuoHkcynbHUAMYt8KpccStIIzhLEGaKu2vIONX9MLCbQwykagw3bOLY2nGfsuIVgYlwDgdrqHC41R/Z2qYk9eUd1eeaBxrqAF4IfBzbK0GR7Wknmql9pN8A+9yYfGm97q1/b7pe97DdJodSMmY4Kunyg7pI28phWJLmrLe5vX0cLtXlrh9OpiScWhnVeQJfkRQivVfMPPLtWXUFnTHjEPbCTi39CPP66+SkgwHNBEEbZRIk8dhX3a/lWMSgfOKtThSe4NLsqk7uEhigYOphxQs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 5:53=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> >       if (unlikely(!node_match(slab, node))) {
> >               /*
> >                * same as above but node_match() being false already
> > -              * implies node !=3D NUMA_NO_NODE
> > +              * implies node !=3D NUMA_NO_NODE.
> > +              * Reentrant slub cannot take locks necessary to
> > +              * deactivate_slab, hence ignore node preference.
>
> nit: the comment is obsolte?

Ohh. Sorry. I clearly remember fixing this comment per
your feedback. Not sure how I lost this hunk.

> Per previous discussion there were two points.
> Maybe something like this?
>
> /*
>  * We don't strictly honor pfmemalloc and NUMA preferences when
>  * !allow_spin because:
>  *
>  * 1. Most kmalloc() users allocate objects on the local node,
>  *    so kmalloc_nolock() tries not to interfere with them by
>  *    deactivating the cpu slab.
>  *
>  * 2. Deactivating due to NUMA or pfmemalloc mismatch may cause
>  *    unnecessary slab allocations even when n->partial list is not empty=
.
>  */
>
> ...or if you don't feel like it's not worth documenting,
> just removing the misleading comment is fine.

The above reads great to me.
Will send a follow up patch in a minute to fold in or keep it separate.

