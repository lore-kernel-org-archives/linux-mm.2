Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80819CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25D26B0005; Tue, 19 May 2026 16:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7FA6B0088; Tue, 19 May 2026 16:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5CF6B008A; Tue, 19 May 2026 16:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4C36B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:53:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B43F161883
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:53:18 +0000 (UTC)
X-FDA: 84785369676.13.73D9173
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 387531C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:53:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i/Ij+1aT";
	spf=pass (imf20.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779223996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae+dijTOTo/8e3HvGN3FEZCQc/7H0q/1pnPZoGZAADo=;
	b=iQQvAo75QWjYmUPI//Mkde6lwRXf8yDEFxO4jIVAJ10TrSyS2VYU09X/Cwac/SDLGRRqG4
	5KDEjTUVxUWDCRlclhgCjZcNprxidBQD9wJ9Phro0jLOAw3Gqf+i4k0VqLHureP7EjTxUp
	vvAHjSa3Pgbvq7XXfS163v251UmSjwg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="i/Ij+1aT";
	spf=pass (imf20.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779223996; a=rsa-sha256;
	cv=pass;
	b=bGGhI4oOP/hZh+fjZHuJ+vrLXtjJ7ItVukFEKGYEzWFQudk8tP43yudGXTvi0gQLv30gx7
	7dXHan2dIuuYAXDOBLnLYsNtRipZ8C5ew5oH7PZuTZFr3pqWAKx6JBc9U4dyvYediiYkUV
	n1Z5eUgFKNcql/sv5Qv8TZllUAofScM=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67f7caa33easo8771585a12.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 13:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779223995; cv=none;
        d=google.com; s=arc-20240605;
        b=UQTKxdMgPaZOVNtS9jcLs5QEKehvoE0TIqwFTftAeIKNa6srXjz7nhb95+LYkjENKz
         XKQmnLcY08NnIntjGFxiUD1CnKjNe/sknBZ/YQpQ17acvkn8N9GkEUolqZbUrLMQK+6z
         Q7Q6Sylxd8DPilB87JvueLAxEVpfcz+MmPwAiYK0sZl5CKT67hyZKDjdBllUuanQnMTc
         7liYTWWOUc/1EmMQMT+qsb5j6bIcg5fRikoUboCt6IKWoaC3EOdBzQehLpvnpEIEjvAC
         AIBFoC6EEl25nDbom457zsYAtyjJdwsqxwkSo61CJs2JRpakP3w3PjUVID18KDL6aDKP
         w5tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ae+dijTOTo/8e3HvGN3FEZCQc/7H0q/1pnPZoGZAADo=;
        fh=wmB6rgB6nl77udpBBaqikmgnjmtLKDsDcSEBuTsN7TA=;
        b=N0iIldb13nDw6QGvBCpStKs94tNRyprU+pF92pzvE+LzAVlU92zX/tsHDKprO8rfBd
         Igp7xq/dw5WvHaa7Bg4RRcQuMsKGRkJAd+ErorHujhLbeWH7EVffDlyffeQxN+MHfjGS
         EYM1ZevqZFLsmFRx/L3qsluqHWRPQa+y/NjjCjKiPK2MPzMs6Oj+geW/boj2UBHTbiWY
         l6CFNP/2mLRNeDx1ER5PWRB49ozYoM4b2MbqezqwR9dy3AW9SrDIwVBrFFfdv9SQyWVm
         cDk8Bw3r9zB1LEBgx9L9DyVAUSjMq+uLfIPt0KLBR/iDbDb+B6wmPpltNepL8IbVWFLb
         Z2bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223995; x=1779828795; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ae+dijTOTo/8e3HvGN3FEZCQc/7H0q/1pnPZoGZAADo=;
        b=i/Ij+1aTvzh+8Dhgob41QOZ7MwOHavUqhBZAlbdf/MGDqEqip3/K2p354nf2/HWS4k
         MUq05x7pXmGsQ3USnJanvQvfG3de05VqZrMBASglEL6MoFSgz/db6di4OcFDAtu+LlyS
         8u1/AibMBTDfA36Nfs9Wfp5pyIy44EJIsgyKHp/+X5nGkkQo7HnPzgbcUCb/0L1oj95j
         zRpPpJCXiRo0ZiUxgc2R/IT+nDMRctTmJ9WlNssFHrHycpHy0VQaoimmzRJLOrIlJrvZ
         lleab1nEkgAOIUPG/PDXsalr1QHS+5DPF8UoABkBGmv8KsRCffjYVMEZDXeZ4TC6ITgx
         JjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223995; x=1779828795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ae+dijTOTo/8e3HvGN3FEZCQc/7H0q/1pnPZoGZAADo=;
        b=Ip09TXljSfK21KfiWGv3PXcswXnfDk/ktKVRSLEnNyFuOpckH860jaeeUJhk3VmdVt
         s746ccQpVAIaMMiGD0zObpf3FqZ2llhH6gHKnncjMH2X0PHH6rhx3WmG7xEu8DkFJTOG
         RYrn3BS4wGvxzomLm0dv2TdJqKc2XSGPnnWhL3GRM1RY9Z9cp+UYmFaMuS+Lca3AVkc2
         VxG1hGmaoefEyknjPpvpLtiTaBUQ5zMvo8TLHgqkA/eLuX45kXlCfZe/qcAimls+pZEM
         Yk28eSpWYXcc6Wxsx9m4s+mOU2aEktzO8TVPpswYEi1oV3X9ZbHIXGU9hQbl4AgkJvFf
         ywvg==
X-Forwarded-Encrypted: i=1; AFNElJ/GoDqkq4DwiOdrgpiyl01AYRGEZiA18nWk7tg8UZE1SVDTmQmJ4v5XSBo1nJF+7AjDEUoWBZ6JCg==@kvack.org
X-Gm-Message-State: AOJu0YyQPQH5NTdsFUkbD2JfUw4JfViVyu57dBeeoZjlmPoxiqK63MKW
	nEIN6MnsuBf9TkihP2p3H/GiW3XUr1cyf9Kx5e0DZbaFA1qfsvkaaxoCTEg7q0menxJnsq2Vz9/
	StuRvTytyrIGNW9sPUtrcoIpd2Xq+2ak=
X-Gm-Gg: Acq92OFXe+p8RJZkDgnDAkAWHrBWq0g9OvmEMzDWO0ABSyOsosaRSMXDvJo6g+J7470
	QYWSDKhjvJbvRKzyA6Kdi2sbEKF86Hna+xo93t6PcpXa7p8dYujXxr2rlI4UTrxCx1m1ja53JIT
	W3nJkrrlM708AJcpRUreurdEkQpM6uKXl2R/DOqACwnfurHEjaXNiKF5ywBBJ+i1fkr+e4W3tdO
	WNawTkQvP7KFFv9a/TwkaRaUNNKD7WDEBK5ClLkXK5+2xce+k11mn3NXFaezBtbx0wg5Esv6x/u
	1mZCFJY5sQ==
X-Received: by 2002:a05:6402:24ce:b0:683:1cc8:84b5 with SMTP id
 4fb4d7f45d1cf-683bc1b7472mr10554792a12.4.1779223994390; Tue, 19 May 2026
 13:53:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <CAGsJ_4w_-Y8qNLDeLX9OWpLpK01YG2bF-N6_mGypgsauvfCvkA@mail.gmail.com> <CAHbLzkpbQ4Ca0xC74BJ6iJUVKdpH90qE+E=g7HkDXvcNH1+8+w@mail.gmail.com>
In-Reply-To: <CAHbLzkpbQ4Ca0xC74BJ6iJUVKdpH90qE+E=g7HkDXvcNH1+8+w@mail.gmail.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 19 May 2026 13:53:03 -0700
X-Gm-Features: AVHnY4IimOZqeIRblNaSy2KsMS8vB_GzCmlGYie_zXnP_ZtHrsCb1dPTmYJGNBE
Message-ID: <CAHbLzkp7WcXA6Zey2QjBDrcs1w2hP4dhBoda2G3XF+Q0h_hwsQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, surenb@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, 
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o4bb73dtkungax588ene9jzf6ptwpcp9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 387531C000B
X-Rspam-User: 
X-HE-Tag: 1779223995-573104
X-HE-Meta: U2FsdGVkX19uTMor0pSSyx2FSJ7+wlGB7hkaOF16VfbK3OYKpNAZuRQ7Ol5JBvwcs9XvJv13MHABaFfXiGmI2AaD6e9rF67N4jIhytw0elHih9zuJ8CBqHlwCMu2Om73Wqhn0cASH7aJ0Bz+cqaz699CIEq5MnRV0154z1hi+Cj7kKDdMCl/JWmaccA6b+wUu7pwC9Q6sbjWrT4F6MYywwXPcKHdMMNxDORLk6N065son6jk04DjtFV5N1M3Py3AboMBsCEfdG7/rOXHvPLQ1YH3TJFk1+/lACga06r4aRCIEmOX4wv7i6kqNk74wFKh0AgJVZYWW7FRPuOOIyv+FEBnG3zSXjgjPKeROlys+vTsWDFr76VIxgObRBppOkgcoSqxx50y3/Rz+4K7vZvFok6vDrlIFbv0LWB1AQwsN7f5Lvj2AoGsYJXHa0fEo2gxUYjBJ11colJfo+TOq8cnjbiEsO4NqGQZrjLUmmo1YHTuJOFRVmzDJ2sfMxmEIjz5ChRr6fmvpCbER8d21heeVdi/UTTTOgnRfHiJA4x4RFKkK4FkRC8NPXIt7IcRfCTuFFGs4HVYKccfZKUcyJQo18GRpHpNNcbmhWhshJd9ence5bQJy61UUORnJFwXh8hm82RYvQ0l0QRODYXjyL7NI4RrOu/MXnBx9bkWkiSj3S3Y6I0+8ov2VA8p3HL5ijg4pEc58yNVo0yqM9Y+iXpR/tiyaBibqKuPgeQpR12u6/C+p+9YCA7MbZpP4kj5kn/cYMetUbJYEbnitN2Wkt/yMTAVzj44wKHyogQo4WD8L+SnJMHLNsr/lSgptupBfJJK9MVMb2HaetB934mbJBuH5KCLjqckyBd1MLPiCWRhSw2s7C9AUUjzF1Kt/Up1kxOjHTDYI9tnbVhc1s1ny996VHLgPBq3DVJKXBtH3dc+PfGYPf+/oXPnKQsawoyhw22+rFU+pMc1kbzBAQiRu2+
 JoKzkR0e
 xzN5xVH5dLyzsykMgPbkyafWWd7eqd/301M+qpnUmJQnZ26YW9r+9PtkkZT185up2ahUluNDC8DhgQ7YelPGRYRf9OyiS/GZMowVORYQhp+I6L5/RDEgJoHmm38PnMCxOBl+gDjszLS4W7sCHZ9zOu8uzDy9/H7luYAIHkFv1zRbhCOZCjJn5xpi7rVbAuawKFTvSyE2MtXkymAz+xwMewU6sTAMhfvhZOnUjaj12iiNmqYRXAGFdTp9G15U4NNY2uKtq2ZQVuJbE8S2pwsQY+Xk1KoSRAvq4S/o7VwygJ4m8Iyqr73YCjhWgvaP9GCKNnTqvIKwgm6Jz8PiVXUAScKq5mcMKr06D21jl8jtJ0qy8l3dnwyPKbAGmnug+xX8lmLw0QioIABuHMjH9chkgaoPILAdvbviQ75ZtU7GAnsiK1h5VJPBjkCIK2CGH5tHWB1qGq3dQHqZP5AwYbKCYV8e6waz3QPf28efcsj68cnHafgoUmLvErcqWQpSJzB6EBZVZFFnNjbH/fkWMqB18oosjTxrRlUt0UyanpBAHUpl7J2A1RvSA8bi9pXAL7XSBHtUHvqdCNLby8bMkDDKrt1Jgf+PKmQa+57XTnvDlYVo9N9dt/8mW3d//1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:50=E2=80=AFAM Yang Shi <shy828301@gmail.com> wro=
te:
>
> On Tue, May 19, 2026 at 4:07=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Tue, May 19, 2026 at 5:21=E2=80=AFAM Yang Shi <shy828301@gmail.com> =
wrote:
> > >
> > > On Sun, May 17, 2026 at 1:45=E2=80=AFAM Barry Song <baohua@kernel.org=
> wrote:
> > > >
> > > > On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infrad=
ead.org> wrote:
> > > > >
> > > > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@i=
nfradead.org> wrote:
> > > > > > >
> > > > > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > > > > 1. There is no deterministic latency for I/O completion. It=
 depends on
> > > > > > > > both the hardware and the software stack (bio/request queue=
s and the
> > > > > > > > block scheduler). Sometimes the latency is short; at other =
times it can
> > > > > > > > be quite long. In such cases, a high-priority thread perfor=
ming operations
> > > > > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be f=
orced to wait
> > > > > > > > for an unpredictable amount of time.
> > > > > > >
> > > > > > > But does that actually happen?  I find it hard to believe tha=
t thread A
> > > > > > > unmaps a VMA while thread B is in the middle of taking a page=
 fault in
> > > > > > > that same VMA.  mprotect() and madvise() are more likely to h=
appen, but
> > > > > > > it still seems really unlikely to me.
> > > > > >
> > > > > > It doesn=E2=80=99t have to involve unmapping or applying mprote=
ct to
> > > > > > the entire VMA=E2=80=94just a portion of it is sufficient.
> > > > >
> > > > > Yes, but that still fails to answer "does this actually happen". =
 How much
> > > > > performance is all this complexity in the page fault handler buyi=
ng us?
> > > > > If you don't answer this question, I'm just going to go in and ri=
p it
> > > > > all out.
> > > > >
> > > >
> > > > Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> > > > waiting for answers),
> > > >
> > > > As promised during LSF/MM/BPF, we conducted thorough
> > > > testing on Android phones to determine whether performing
> > > > I/O in `filemap_fault()` can block `vma_start_write()`.
> > > > I wanted to give a quick update on this question.
> > > >
> > > > Nanzhe at Xiaomi created tracing scripts and ran various
> > > > applications on Android devices with I/O performed under
> > > > the VMA lock in `filemap_fault()`. We found that:
> > > >
> > > > 1. There are very few cases where unmap() is blocked by
> > > >    page faults. I assume this is due to buggy user code
> > > >    or poor synchronization between reads and unmap().
> > > > So I assume it is not a problem.
> > > >
> > > > 2. We observed many cases where `vma_start_write()`
> > > >    is blocked by page-fault I/O in some applications.
> > > >    The blocking occurs in the `dup_mmap()` path during
> > > >    fork().
> > > >
> > > > With Suren's commit fb49c455323ff ("fork: lock VMAs of
> > > > the parent process when forking"), we now always hold
> > > > `vma_write_lock()` for each VMA. Note that the
> > > > `mmap_lock` write lock is also held, which could lead to
> > > > chained waiting if page-fault I/O is performed without
> > > > releasing the VMA lock.
> > > >
> > > > My gut feeling is that Suren's commit may be overshooting,
> > > > so my rough idea is that we might want to do something like
> > > > the following (we haven't tested it yet and it might be
> > > > wrong):
> > > >
> > > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > > index 2311ae7c2ff4..5ddaf297f31a 100644
> > > > --- a/mm/mmap.c
> > > > +++ b/mm/mmap.c
> > > > @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_stru=
ct
> > > > *mm, struct mm_struct *oldmm)
> > > >         for_each_vma(vmi, mpnt) {
> > > >                 struct file *file;
> > > >
> > > > -               retval =3D vma_start_write_killable(mpnt);
> > > > +               /*
> > > > +                * For anonymous or writable private VMAs, prevent
> > > > +                * concurrent CoW faults.
> > > > +                */
> > > > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED=
) &&
> > > > +                                       (mpnt->vm_flags & VM_WRITE)=
))
> > > > +                       retval =3D vma_start_write_killable(mpnt);
> > > >                 if (retval < 0)
> > > >                         goto loop_out;
> > > >                 if (mpnt->vm_flags & VM_DONTCOPY) {
> > >
> > > Maybe a little bit off topic. This is an interesting idea. It seems
> > > possible we don't have to take vma write lock unconditionally. IIUC
> > > the write lock is mainly used to serialize against page fault and
> > > madvise, right? I got a crazy idea off the top of my head. We may be
> > > able to just take vma write lock iff vma->anon_vma is not NULL.
> > >
> > > First of all, write mmap_lock is held, so the vma can't go or be
> > > changed under us.
> > >
> > > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > > fault happened or no cow happened, so there is no page table to copy,
> > > this is also what copy_page_range() does currently. So we can shrink
> > > the critical section to:
> > >
> > > if (vma->anon_vma) {
> > >     vma_start_write_killable(src_vma);
> > >     anon_vma_fork(dst_vma, src_vma);
> > >     copy_page_range(dst_vma, src_vma);
> > > }
> > >
> > > But page fault can happen before write mmap_lock is taken, when we
> > > check vma->anon_vma, it is possible it has not been set up yet. But i=
t
> > > seems to be equivalent to page fault after fork and won't break the
> > > semantic.
> >
> > Re-reading Suren's commit log for fb49c455323ff8
> > ("fork: lock VMAs of the parent process when forking"),
> > it seems that vm_start_write() is used to protect
> > against a race where anon_vma changes from NULL to
> > non-NULL during fork. In that scenario, we hold the
> > mmap_lock write lock, but not vma_start_write(), so a
> > concurrent anon_vma_prepare() could still install an
> > anon_vma.
> >
> > "    A concurrent page fault on a page newly marked read-only by the pa=
ge
> >     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on th=
e
> >     source vma, defeating the anon_vma_clone() that wasn't done because=
 the
> >     parent vma originally didn't have an anon_vma, but we now might end=
 up
> >     copying a pte entry for a page that has one.
> > "
> >
> > If that is the case, then your change does not work.
> >
> > Nowadays, nobody calls anon_vma_prepare(vma) directly.
> > Instead, vmf_anon_prepare() is used, and we always
> > require the mmap_lock read lock before calling
> > __anon_vma_prepare(). As a result, anon_vma cannot
> > transition from NULL to non-NULL during fork.
> >
> > So the original race condition has effectively
> > disappeared.
>
> anon_vma_prepare() has some usecases too, but it seems like it
> requires taking read mmap_lock too if I read the code correctly.
>
> >
> > You also mentioned the madvise() case. If I understand
> > correctly, madvise() should take mmap_lock before
> > modifying anon_vma. Only some parts of madvise() can
> > support per-VMA locking. Therefore, we probably do not
> > need:
> >
> > if (vma->anon_vma) {
> > vma_start_write_killable(src_vma);
> > ...
> > }
>
> I think we still need write vma lock to serialize anon_vma fork
> otherwise we may see:
>
>         CPU 0                                                 CPU 1
> fork                                                       page fault
>    src vma has no anon_vma
>        skip vma fork
>
> allocate anon_vma for src vma
> vma_needs_copy() sees anon_vma
> copy page
>
> Then we may end up being no anon_vma for dst vma, but with pages mapped i=
n it.

Sorry, this should not happen because creating anon_vma in page fault
needs to take mmap_lock.

Thanks,
Yang

>
> Thanks,
> Yang
>
> >
> > >
> > > Anyway, just a crazy idea, I may miss some corner cases.
> >
> > To me, it seems that we could remove vma_start_write()
> > entirely now. Or is that an even crazier idea?
>
>
> >
> > Thanks
> > Barry

