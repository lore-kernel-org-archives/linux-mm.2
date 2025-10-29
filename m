Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55909CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 02:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A049A8E0029; Tue, 28 Oct 2025 22:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC2F8E0015; Tue, 28 Oct 2025 22:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F1E58E0029; Tue, 28 Oct 2025 22:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDA28E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 22:14:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FAED12AE75
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:14:16 +0000 (UTC)
X-FDA: 84049532112.09.817872E
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7540A80004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:14:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dxGU5LMB;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761704054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vPGYW3pX+7b1B0RO8MNUWDpnqr51YW+OGVAApLwa9M=;
	b=s3Po5Q78+QIVpYR6rzWd+9dOClxcbSrwfo8tF+G3qOQus9Ocwx1Br5vz/M+/caFWckBhYw
	7ivNY5sJ9Vt226IuN/0hZkTrdz4FI4hUkZKtNp37obtQ5Y6WGqtLjght8vPBL1crp1pqkh
	N+gRi3KHIRlo0ZRtbDuNiR3m2zo7+HM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761704054; a=rsa-sha256;
	cv=none;
	b=v17l14t+lAlkGBZ1xYiU3aZCGoz15rDtxvXhCQwUq6XHg75BrSPunyPEf0k4/6AWbKtkHR
	/qiYAlR4amlwQ2Q/NOOxYdQ3kDWdiN+gjvdPbfAgbHwgX4BtF2qdoEpKQrf1xEVJq0FvuF
	AiQu/npQ5bgoLraSivDYYFMrY34wJG8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dxGU5LMB;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7832691f86cso92677837b3.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761704053; x=1762308853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vPGYW3pX+7b1B0RO8MNUWDpnqr51YW+OGVAApLwa9M=;
        b=dxGU5LMBAqcSBKLnHaHN7xJq//d4pdVJLCR5XRMqM9jfVdBeCGfqkCgLecaToeILp0
         8soI5sk9ibABdJeeynbJVLmzMG8uBMJ2MXbhI13Mb28tiQNYCGZPzC//1Snp2z1+PqMR
         y28c4TL82Mxc9j1QtLETBXRYVxtrI5Aqc8MFE+jSu+70KT5g+EWU6CyDleG6kbtt5deF
         sKUjAA9pP7Z+GvKmZVlt/bjy3xYgceVQA5x7r+g/nbKpFIP1MPSWfd5woCL3EhI37lmm
         PCd1fmzoZYwisugYtOPna9bYbHeJYsJgJQ0TcV//mEaWJ5CAtx59+BiELQFUN47K4U8N
         KKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761704053; x=1762308853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1vPGYW3pX+7b1B0RO8MNUWDpnqr51YW+OGVAApLwa9M=;
        b=QGPQrsybIomF7SMNCfwbwl5//ZnnmMEFFsGxm9+Dt10sQ1CwYIkPEv6xGZYq5OUB17
         d7OSkPb/XSUYOXOUHHvSiQkX6I/48PpR+JlWN6dt5gSQoSVJpW4MEqFKcza7u7DrRRnD
         jFc2iAABqhpV9/3VYUHO0AcyyqaZoVO6b3efqUX0H2o4cU6lsLN4L4+rMTq3WelS9E31
         h2/pmoLWQRCcM65EJ4tFADy7PbIh1qDF619B3Tg/A39tpRB+Zc6w0gj/++mdcqUvEBZx
         gauHZ8EryiLHKlthvkTxB61Kl+6EXPP035AIxDuodNIqYt1a7CmjD8GJMKaKlHZ+okLU
         xmCA==
X-Forwarded-Encrypted: i=1; AJvYcCXWOm6glbMKO651nqfdS4LsVOyRiaVYX8l+7G4DsLlTbeUAD+sgtP9yI1gxJ04xQirdeadPjKDusg==@kvack.org
X-Gm-Message-State: AOJu0YztldmLzW7lmh1Wp0FNDjsP2izhkR230XR2E3DDm7wf7RI0XzI4
	OYUL4UCkkw5ov3yuaWrowYgJPg1unFW60izleqpqHaUpLa0VX3js8xrHRGM+b/Sjgkvt3lnKGMq
	Wx6YujqE4KUCol5vINC+WkYjfTXNlXbo=
X-Gm-Gg: ASbGnct+0EkG22BIN6dzbRdeRKwsn2F8+PvRI24r5NcCj0VlOKoJdq9mgbyj73FYq1d
	QtMHCNanLo7DcfngcEeKjDISJX3jn/V9Vz9hu6igxdubvgVkRMr4sOEvCKecAEwYIYT9BE2pwHG
	fA3NeFVtY7YsANkfbDcop3nGWeuj4y6uOFBy2+DMKHp/CH9NsCtKe+0M8wq8us2AyFZqgF4g7i6
	w31r9Ud132JtbunVuFFfreK3d4L1cxaDfOYm0QOkYQE1akZIEXewSsRW+efoJJak9yqnjFV
X-Google-Smtp-Source: AGHT+IGAN6hw0WwRvKtq3B1y0SiTrVIZoYnrx0iULGRASJtLgN5JvkICVwdenSNU90hNH8FkNZBvjoCAptWUticznOo=
X-Received: by 2002:a05:690c:6289:b0:76c:b76c:ddaf with SMTP id
 00721157ae682-78628e24788mr15670597b3.5.1761704053447; Tue, 28 Oct 2025
 19:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
In-Reply-To: <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 29 Oct 2025 10:13:37 +0800
X-Gm-Features: AWmQ_bl6ri9Brpc7kQ08rlFDC7Zg4B3FVd1R7XVe5An1qRSKX_V24AXUbVkKMWI
Message-ID: <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: qu5f7drrgp5mxqrcea5sbamwwwjoo816
X-Rspam-User: 
X-Rspamd-Queue-Id: 7540A80004
X-HE-Tag: 1761704054-230883
X-HE-Meta: U2FsdGVkX1/8TBButHcGMX4yq2HfLBLC00UuTvsZju0Sk3FuKx79vTZMxqni7uPY6MmcdzDov97CV+BirziHEv8QHJ9ZOC7mrYvAmOyKypzNCkAdwgIHyu2gMj5wN6xBxNbilasPQI459siB0MTyhfEL0Bu1Jdg2xQ2t75TKpOLBKAVakn/20367TVib0B3WTSaBtU6RhujJrwFThlanECrB+3XPbZOYgMWifvSMplJTU53BnsHdX0wdmr2znxBLH5qTSRWB6Te3Tc7okcs6tqGMktxWytj6WjN0kDM+XfQs5iAP8GVQTAZehMTe+NLG+sQesLTO+g+KHqq1+waT6AOQFqcMfUlYrLtvQ/eqnhF+fmlHpCd2G5/OOmmyQN110XIDpK8f8AJw1p3zVzpKEGlFW2ho3VzdMroRK/e/EaTWDUESt6Bsab6sJPHwDh2kPuWtuRkwhz/EAP6ZOMc4fAcWkkRxO8MLegJR44dquq6AUoV8rWNqDp59F6XyzuA9ALVapuvi7qI0h4RMHHVpDCyCVtqTR9oTjCyoZm2ZC/1XRXsMNJ0c7QxGzaUBbawACtldTxcn1rUAXu3VbfN/9PwT8dXu0hL8qwgMSeJXtDlkavx1dpjTU8Cnun4+UZzBIqThZN45K1bllcyKReAwT5dpEh/8CEby7OLynxsWP68eDdXFnzFTTC1T32xc/eQkwre7i3n2e0eFTyJToUl22UWsqlGIBUpjCE1XIUB3AeKn1b/JrFa/e3SEkkRIwM5Nf5IjIZqqix3Z8093QRDl1okWBFGUe5AHucXjp0/R8/tIcjYbaleO2GR7EvHx+zESVl6LJj7dM4IqMbUU1giqLXWTr6NpPNn84wqqHbp+VlRRVwvvHXGSsfNVPxHgGY2QCPvCpjXOrOrXnSD3fSBUnEaUMacB3Zyx+6flUSQYbcbzMZuN79xdsFwjY+NgNEyMrs2M/LR9t32gNiY967G
 V+qJDNOz
 I+hnfBJtXtvQCauNCPzW20Sae/4KZf101Yz3YhV1dyw+b1SfGEnZ2RrAiyjtJoS3TDdri/BYMxchB7Bwi4EbG/CkNFJxqGp0fTZv4vURti/ZaplsmGd8Elrl/cvcSe3Hy/kjq35MVPkOTZmZhw/youVaGyn4xFRdE8yE3g1y5NUCqyvH2ZodzhNS5kRia/2HiXfUuttLDjT0jO49qWJpHYtDNt4Y6D/O/Fggvlx0pc2iXNv3iQc4eZf09llfIgWAKA/lcEFl7Pi7OMKEZxt/UM8IKqwEulcTI32t5YNtUxySdQFT4DOVQ0qfabTvP5UKlprlGnVIsdMTVRb9gXelFV5M4UhsnvYfmj/kqtxycAnbMmRNE4c4J1xk4E505Qt7AYge3UUmqXHBhoPfBKiKs+PqqZqyOFW26GCj4QR5643SBXhAjxuOFjuJ80euwESMoyMsDnS+5/vNnrsdZiPQj0WFq6lNMno4tgGzIhvSsjINuREktHH4iKPDOhQyxi0mQ73Kc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:33=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> >
> > The per-process BPF-THP mode is unsuitable for managing shared resource=
s
> > such as shmem THP and file-backed THP. This aligns with known cgroup
> > limitations for similar scenarios [0].
> >
> > Introduce a global BPF-THP mode to address this gap. When registered:
> > - All existing per-process instances are disabled
> > - New per-process registrations are blocked
> > - Existing per-process instances remain registered (no forced unregistr=
ation)
> >
> > The global mode takes precedence over per-process instances. Updates ar=
e
> > type-isolated: global instances can only be updated by new global
> > instances, and per-process instances by new per-process instances.
>
> ...
>
> >         spin_lock(&thp_ops_lock);
> > -       /* Each process is exclusively managed by a single BPF-THP. */
> > -       if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
> > +       /* Each process is exclusively managed by a single BPF-THP.
> > +        * Global mode disables per-process instances.
> > +        */
> > +       if (rcu_access_pointer(mm->bpf_mm.bpf_thp) || rcu_access_pointe=
r(bpf_thp_global)) {
> >                 err =3D -EBUSY;
> >                 goto out;
> >         }
>
> You didn't address the issue and instead doubled down
> on this broken global approach.
>
> This bait-and-switch patchset is frankly disingenuous.
> 'lets code up some per-mm hack, since people will hate it anyway,
> and I'm not going to use it either, and add this global mode
> as a fake "fallback"...'
>
> The way the previous thread evolved and this followup hack
> I don't see a genuine desire to find a solution.
> Just relentless push for global mode.
>
> Nacked-by: Alexei Starovoitov <ast@kernel.org>
>
> Please carry it in all future patches.

To move forward, I'm happy to set the global mode aside for now and
potentially drop it in the next version. I'd really like to hear your
perspective on the per-process mode. Does this implementation meet
your needs?


--
Regards
Yafang

