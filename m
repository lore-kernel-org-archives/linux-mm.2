Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF840CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 03:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14A488E0003; Tue,  7 Oct 2025 23:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122718E0002; Tue,  7 Oct 2025 23:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037DC8E0003; Tue,  7 Oct 2025 23:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2B738E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:51:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7102F1A034D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:51:02 +0000 (UTC)
X-FDA: 83973571164.25.CA05B5E
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B01E80008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:51:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNsWE6gy;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759895460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+jx7n3Xx/N7Z5ReLNJDr8EPoJ485g4LVFHysMmcuts=;
	b=Vm1dS/SIEJhAR9Gs7fUrXvSGyZzzxwgk+BVskL1VVQcbbXOuMXLXvOLZHg7kLB1ZbiLVdI
	3Uce8Inab4rQ7oVhVoq968NRQWMIraSE4f5vKmbj3YyVkU2WaFAEgYZTgBA0UB6OqinE+e
	h5X004HlQ1o5zEXseFAPx3sXMhb/3bA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNsWE6gy;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759895460; a=rsa-sha256;
	cv=none;
	b=S114fNDRUQpKimJQj8wUCfDTu7gEtR2Sk0H6b8u9lNsGLutUafDNCoQJeP3v9xw/dUpI8M
	TmC4cy3lBIQNKMnQotc/CkLBtEBi7+iGzqy8QWRWhYE3W42HO2PbeJzdg0mFkgM/t2wfsP
	1fA8btgifDO+D7rcKJ7PU+szxrV/PMI=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-78e4056623fso58133356d6.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 20:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759895460; x=1760500260; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+jx7n3Xx/N7Z5ReLNJDr8EPoJ485g4LVFHysMmcuts=;
        b=NNsWE6gyVJnoljPEzZrIrMBaSdJ+uC/4nJ3ieZOQi73jO0adIUxFuXFwXt2D5IhaUt
         SO0FixPpBuAsPsK3Bmw1KtpPGBinNNAmIxBoc/mwQh65wIbD/EmVw3kKFPkC6hs5bcjU
         hGjyjeoGweH8Y4lvi7ymNwL+VX0lMylHmCahJn3/XztdT/62xNkmCMHh7tBrabttZBRe
         gykLrEc3TvO1RXY83J4ZO/OTz3+ixnPmO4GyUf1f280MSdq/vTwgsOHtDE3cBal8PwGL
         +t3uOStppZobCL+peAzacUuRt+cck4NNRD5c0mpQskRYGIA6xoaunzeRdmn3JraZjHr4
         GRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759895460; x=1760500260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+jx7n3Xx/N7Z5ReLNJDr8EPoJ485g4LVFHysMmcuts=;
        b=qcjSTELqMLFoVvuQJ420dFMOLiZVyQ5/a2EoW2XmLbird9AILKbls6QFY0Zuvemx3Y
         VGZkmSA4hIbaZbOid3LhnM1DTsofIpO9c8ijObTL9JchxrrM0sqr2CPvAkAmWW0pRjQC
         D6q5AX6Mq52MiD23cxvbdPmbnRE1c945cSFUqdibpjuGO5bnWO1BfA5qYCb31J8Mr4ng
         Hctr7yakoPQxRqYA94fcSi7tw6+W4eo40V24Os4O59OooHLdJ5wvUMJhKsVNhbsjkdcr
         7HWfjvjBaIe9cL0qyHemQ1m5Qzb8MtPwjrzivHhlsLvlkxDu+y9OlMlGTtqzD3m4SUL6
         wtQg==
X-Forwarded-Encrypted: i=1; AJvYcCVyOU6dJYJ7d8PGQo7iCjnC1M61qRFL8qKQxfa/HcFVHc0iS9nIvIqA1H2TB3ffc+d6RgwDKYckjg==@kvack.org
X-Gm-Message-State: AOJu0YyvxwyjG8E+RoHgqmr6n0uWdhvrQxmVZ4er/mNzWviWxy/reoSU
	agXEmESUBpui/bVJOqEvfNoEQdfDFoKysuEVJfNd8+s/6ngpWMSAkhDGYbQ6PKUU8PDuibKf1Cv
	3HAR5eI4zTzcfoxsHmWn+TNN4qyj7L7U=
X-Gm-Gg: ASbGnctEMRTC9FFHZ9Wu1uWNYa2ex1MdLkBlL2gZgDXMrV3I66J1nY3UST56Szrx4mm
	4RL03IyXS64lZZ5c180Cjua3tfvo8ENRMOnJrFkT2UeiRpMDkIIZs3+LSo8IHk53Ddel/0bHRod
	RydYwdsjzZ3r/bvPxFTy4r5YtRFg8zyTUa4uujdsSEcxgSNJq0Wn6tlsLx+iDkzoH42AmSP9oJV
	ajOheEbsGfQgeqy9ziGZUmN1Bu6JCu0CBn/FtcOOnG5n9kN82pIYDTOmGNlvSB6
X-Google-Smtp-Source: AGHT+IHII1V1w94JvtgMvnbeLHT8eBxHxQJa6TROlR1NDzQLk2GySyA7HWBaodCNt5MXTv85m0/XMhRKG6JZ8VcoTLM=
X-Received: by 2002:a05:6214:1301:b0:7e7:a043:59d1 with SMTP id
 6a1803df08f44-87b2ef36f58mr22758916d6.44.1759895459595; Tue, 07 Oct 2025
 20:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com> <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
In-Reply-To: <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 11:50:22 +0800
X-Gm-Features: AS18NWDo6G0yUgBTxh8Ver-mea44VVIk72GGjRNlFLV7d6fNMUbUH3UgINnuRYw
Message-ID: <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B01E80008
X-Stat-Signature: tpi3fy5fux67dgntetj1tbqhhm318ccj
X-Rspam-User: 
X-HE-Tag: 1759895460-561936
X-HE-Meta: U2FsdGVkX1+QiyE2jehV7vMDov/ZgI5TRkenNUVHZRVsPEpkDMRjvUWmPIPito5lAeMykznkYNgIQC1b0iTOWRf6TXgyKXoCUXdpk8snraOW0svI0jh+ty8cWxMIk1ysZXQEb3zQmy3gLg0wqTXKnZPFiaJTuwMoi5hmtVfo6W41d8NTndRrLzR4aPCKQ0WBbuD20QCyS6qGUG8yBgPqfu/my2PB3F8KHvEYIsawWzDHuebEwPhsUq9VLuG2wkH/clt/b8HN9jM7UU1TYSzpXOMPB+kjZs8r+/o+8KXkmh7KGwl4UhaiHlI6xYKLY5uwX6hC51ogzU+2i3qWq+C/lpQInBlNKIHtMSUqhG8Jkq+/R46j/AOhOPPR1ySG+U5yXQHrfsSJNpw5wGUxTCg4XX57WN2efGdbHjUYqBjl5kCRNQU8xVt2yRv4Nt5bTz86d89Xxhwv+fYxIjJdFbi3TRyt0dc3ivg6EVJ92hCw/DtItbBOeR/JYAeH7bYP91f/Hky/wNM8+rppsWAjfjHbG08KUbNjPPmNRj74C00IirrjdrkdbN4RjbuiS8oiyFG5ntC8ul4frN7jh6JmWMC0aaCHN5WFdkxrPPM9PemAbAd1wP2XFExErZunP7tcmGuqofRR0a2HLFqF6s6bDJAz5bBSNQfOFxSHVF43YkrEAaJV6BzMDaNL7oImr9BXGcTXeZSgb+TtkX93hJaRd0JPpfIwn+3Fz2c3zHfvcIGYmoE+047U413xRz7kNZuYrMv0ybIB9S4vYB85pabOaaQoJyUYwtE904h3IMsqmLPoi5nk1pud60Idgo4hPUHvKUeuQQ1ZDXAkkgDHVmPy5mLwFl825iep1oN77QMvT+gVY5mgT7O/gjdDzuinzfODRvWUrcZlculjy1Irm6lNbdyWJ5A8sm2rqQ1Fj4+Vkt1zI/SE6URntBhbdfbUGeFV6rmObulDISiSnQ6DdAPqAr/
 6Rpl0dIn
 CMctpqY/Remwct7KuGWvjYmsonBsgHfmewIE7D97YlsKOQe9+8sEdBaVGTyuHNJ4IX6VkR90hV/gnTjKk9WD2cRzWV3CagTqXTIP1nDpD1nH4c0GJvVAFjohXaxD6pu0+qSw2NJIx7zIo8HgWh/0vATlGKsbgn5cCkK76i9FF4+rD+hjCyuavQR30AuIu0X+LigiB5Mjuvxn7DUzufaDpNXrVu5nHZv/y8mHASZh6ljyhLKWhkcZtOc+3JMXgzVcf94TP/fUbwSOReel2xpao0TCLvDdUggw/EzJNSvxDk4erdpp2g9b77hsIRPOxfMDWftNORlXkiNX+0JYhJW4fKPZ2xeiE+4ATMKdQ3Rtu9JEbsn2rf6raeG0YkRTmh5sK7jLB60ANOJX1L5PKA6pn7lUusmCRDVaDWxl5nc+l8f7gV3Ejc62PUHc777tnrxJlxglFTGU6Dfo3uVVk0ig69eco/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 11:25=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> > has shown that multiple attachments often introduce conflicts. This is
> > precisely why system administrators prefer to manage BPF programs with
> > a single manager=E2=80=94to avoid undefined behaviors from competing pr=
ograms.
>
> I don't believe this a single bit.

You should spend some time seeing how users are actually applying BPF
in practice. Some information for you :

https://github.com/bpfman/bpfman
https://github.com/DataDog/ebpf-manager
https://github.com/ccfos/huatuo

> bpf-thp didn't have any
> production exposure.
>  Everything that you said above is wishful thinking.

The statement above applies to other multi-attachable programs, not to bpf-=
thp.

> In actual production every programmable component needs to be
> scoped in some way. One can argue that scheduling is a global
> property too, yet sched-ext only works on a specific scheduling class.

I can also argue that bpf-thp only works on a specific thp mode
(madvise and always) ;-)

> All bpf program types are scoped except tracing, since kprobe/fentry
> are global by definition, and even than multiple tracing programs
> can be attached to the same kprobe.
>
> > execution. In other words, it is functionally a variant of fmod_ret.
>
> hid-bpf initially went with fmod_ret approach, deleted the whole thing
> and redesigned it with _scoped_ struct-ops.

I see little value in embedding a bpf_thp_struct_ops into the
task_struct. The benefits don't appear to justify the added
complexity.

>
> > If we allow multiple attachments and they return different values, how
> > do we resolve the conflict?
> >
> > If one program returns order-9 and another returns order-1, which
> > value should be chosen? Neither 1, 9, nor a combination (1 & 9) is
> > appropriate.
>
> No. If you cannot figure out how to stack multiple programs
> it means that the api you picked is broken.
>
> > A single global program is a natural and logical extension of the
> > existing global /sys/kernel/mm/transparent_hugepage/ interface. It is
> > a good fit for BPF-THP and avoids unnecessary complexity.
>
> The Nack to single global prog is not negotiable.

We still lack a compelling technical reason for embedding
bpf_thp_struct_ops into task_struct. Can you clearly articulate the
problem that this specific design is solving?

--=20
Regards
Yafang

