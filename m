Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5269FCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA5C6B0005; Mon, 18 May 2026 15:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABB06B0088; Mon, 18 May 2026 15:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772926B008C; Mon, 18 May 2026 15:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BABF6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:57:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C524693745
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:57:14 +0000 (UTC)
X-FDA: 84781599588.28.853CEAE
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id D7FF14000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:57:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i0UNdQ53;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779134232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/+TIJ7IgUqjV0Bv46HdaV7jQIvLaf/1u3zzskYDkTs=;
	b=61+8G0Kaw6FqyXpl/84xLw+cdbIRkldevKROCuviHy7QR/prtTeVU4vqDWciN9G/NkkAm4
	K7I7zUToeMQpNGIVAMFkWIwmzMvA8tf+AAXdlNF1//ISdI/zD+GSUCKrlUYG7S+tOBF1cK
	TUx45EgJC/9MjsZIBYTO28hvgn5Toac=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779134232; a=rsa-sha256;
	cv=pass;
	b=DbSOfe+MCbO0dnUEEsJLLs+JxizmeS/ZHXDy2Hox0eDXZwJjKsxsWrxP/lAMFsj5RdSBkG
	tcf+6E3MaT/l0Ro1Fpvre0+45XVXvciRsNQqE4hjrhmhGRo1C93c1vPo9kp33vNm21u6D/
	02PK/m4tiXitggu4AlXk1MSyscw2g58=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i0UNdQ53;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50e61648f10so5821cf.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779134232; cv=none;
        d=google.com; s=arc-20240605;
        b=iZxdJVWcZQkDREaBn1pPs7y7RVQVNAJWkNS34wirB1L+iqcUZdJ2sknAgnTz3mWJpp
         8L0uZ+WMfrgqLrPuoOA21vcGwY9BojWNEzpRr1svz8kBJ/oOSaFjOrUIps+VpZMyq14E
         wAh+v6TGDDMWuP4lgGEO1AUUFAYYcHBtTKkpTNypvFf7I+UdLJsLAHiYZUuzuhgPvn2k
         lYXI7xvY0X7j8M1LkXa27hnDfeJNYKt1zIc1J9iOqx1mBbV0EpQQqNXEL4qwMraI4KNx
         dqKQdlkW5bWmFRHNUTGyHHPK95R859/EAqLcxOZMNSLD3e+ddLpLhSFWkhwn5+6FI2bX
         qywg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u/+TIJ7IgUqjV0Bv46HdaV7jQIvLaf/1u3zzskYDkTs=;
        fh=6PQ4loVIMuzN/Ydv8GHKM31H9EnzltT+dDbaBneK7qU=;
        b=SohwCaCRMPLIW34gY119wmk26Oqq+e7by7bpb0pVsqES9mBCYq/t0Qv3CffQ6rbtVg
         jRklpsjxh1ar4yb/hnY1SGCcm6ujLE/6qzIU3dfHJEaWj0vWlbJHXEFlbV0yGRMgz6CL
         uz8uDoshDskOPlU7V8XA728vvxDVOW9mBP7FjgRWBMsRI3gmGy8ZOrJI1XxSzZqUXrU9
         rIL9egRFV6Sq2t6TgY9VT/ETvuoBnwwuwfX8o+q9WWbDmAYiqW3LsNlzJ3hj6NZhsILE
         rTh628ohGwkgZa3YQHV38JJcfnubvLbDsE43jZlJSXZd/fgJyug9nqZt6oRDQk3XyVtS
         rtaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779134232; x=1779739032; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u/+TIJ7IgUqjV0Bv46HdaV7jQIvLaf/1u3zzskYDkTs=;
        b=i0UNdQ53kqcmQ5XLbO0n2LTG8E2AW2mgdSomAa60y22rN64/DTfqHMw0pEmyR3H09r
         7Ah9KShT+Q9/HVexeFe69L3NWW/OoU63KhE3ZMpfyzjDc7ANX1cl/oHb1V1EJ0X76KU5
         sbDTSPp41NbnUE5uUTYsEN8lFzVGxO1OlsDSSEMeeOx0wqXorthCPSHAeC9S9htgASyi
         mhvITJvv6IyycBhTbogbMR/nKaGFnYw8czByZku1oYiYxkbrk3Egte6nifV9mlFP/FQb
         xEbf3/lap7t/9+z4PEfg3C9DcbVREui2Q7bXmCs+zYCXVj68SM2srEQibl9tJSmp4GrZ
         jTYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779134232; x=1779739032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/+TIJ7IgUqjV0Bv46HdaV7jQIvLaf/1u3zzskYDkTs=;
        b=P84Im7VD+UAOv/SNoSLwydS+7c32+NF6NsBqpUC+4NnJWQ+lGaK0kAT1fcg/5/cnmb
         fqJC44+i5NpLm0BgTEWTpUWCAJSpfLRunt+gBPJwukf9XBm5IuGvGoEzn8/80/cbM+Yn
         c69qZ77gZk7ndILKbyOk0dkZtdd6gbr68BmSf4/nLzclPmRsx4G9amWJa1WebtcqHuoP
         a/Yr0oZ0jLCE3kvlwgQpFfIhTiGSmy+6ZzyhqTUxmXR74Oj1WfYI7mPmhrWtAV+CcMHm
         YLwq5TWiZxsZsQh/R4bG162AhMnGGhZkH8Eo+lkvzK3EVDBDMJoMz2oQQ2Q9uVtLBHD8
         DAyg==
X-Forwarded-Encrypted: i=1; AFNElJ//zOl/mOpCzpXLa54cq2SGApqC7wF7plZKT3XKgA8ff1Ve0KgKeONqif4KB5FZdI//RhMz8Pe13Q==@kvack.org
X-Gm-Message-State: AOJu0Yy+oEoqQv2n87QltMNpIbK17qoGSaSvTKmAkIVbe94WCFVK/2+k
	g2o2r2+jW7/HJkXlFBmkEntFvC0cTAQwdJzh0WBeECQDRMVTTXq0BdhY6bsA9X2gclP9BNpACh7
	k6JeVogWRHlSZTL+E4HuHiKd8VAMch68rX1PFB8bz
X-Gm-Gg: Acq92OEaPGUHTRJ5/THeEM1WYQZg5uPBfWXxisgyor8CNejYNAqJEv47mJnT6goYLFY
	hCS1Ar1NJpCLaNCKi+TK0vEkmdLpcv8NOHohwriMJgGuiqO8LSLLSDs7XT4OlXe9RJ/8520cAje
	ukl/HyhPi146Xn5ZnwNSrXNPYgAuISK+UriFvWBCw/WSmQgclFQnKwdfGk/EsItCcmEvbnks/oq
	a/Byjq/dkK64xzLCw3xg7ohnhYspLxYjlmIDwG9kiHmsMhnhsys+0agQ7ujglV1EHF7MF7OeplN
	2b/oJI8qNGNub9f3
X-Received: by 2002:ac8:5907:0:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51679440a95mr20949301cf.16.1779134231137; Mon, 18 May 2026
 12:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 May 2026 12:56:59 -0700
X-Gm-Features: AVHnY4LKURvCbX_IJPUmfCTmwYP6SL9RXK1r_86Qf4VKBQdD4r83VbCvOh5ZGPk
Message-ID: <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7FF14000A
X-Rspam-User: 
X-Stat-Signature: 9jjqpzemjef4w75iecayejz97wxqe9yh
X-HE-Tag: 1779134232-631633
X-HE-Meta: U2FsdGVkX19uWQk3EHZT/qn4axSxnmKVpQqRTfn+9BVbsqDtf4Q+iu0zL6KcyweAGbGIGr3+dObSGfELzwNjFdy6kn8mWmPtpratiku4Lqx5NU79ote1QfrKrIpAd78mF2vFU2oPVhmd6mu+gvlJ7UiCbAmU92KRdF2IjbviSfvZoyGH/Ua0jtDmAlt4zIyzsKzwTfR2KQM3h6t7xQNM6e+khjofJM3pQuGtHFCLBeONGprMihtzu4D0H2tsSQyeqI1z7cw33PnvOZH3japl8+4juJeViIVUIPob3wlN7LVqaRybcEyiltFI4/Mn+flBtYid9W8xV/2epHbD21KE5H/oX0uPj33Ww6Y0PUiVO6uEMH2XGEOu6D+Gl8uubfQ5KXLL/pKRkxf/h57LUW/LDelhPwzQluIDfgAWds0Cxk7qGQIv8zGtBFXwxYv+7HzNYSSWdXn++mEnv/K/ZpulwIsnHCECjy62jjm5vSvhGswkU6G1zegjOAKqTvgPo/Qbb4gjKmwrR4b5mqmZU/sIKuVl/gqOZ3VitJSD3IYkjQtI6bh1pID46pP02QubWcY6ZxBw9DQJkmEUj3G80S00vDS0+s+7uhb+Sk5KO/+J9av46QKDy2hehSRT4t8JoXAvmOqc2LTbktkjeuo2UEu6y9BbAfVgYNtzsA74gJK7PpxTcCWTDhezchDQNnt1GIcJcjhWQH4tmgXF6qZdm5a91jFeHGv2g/KFD91Jpo1Bc4SES8e3In8HMJi3H0pSwCCa+UAbnfeqzdJb8hUbpituPiTuXebKp3SWhxyk9BP9z94CZXos180gmN9fOcQ4RySiueKXh8TCr9YXjelhgPaBNEbFeLFEmAgop9hlluxMkpNg0gEk9PgV7q5LTFuAwSynABBu3tbwxr5nwH6Vp9vlvKj24u0jrVdecdPTVR++V20fPj4AxuzAcV1Av3kiswDWSgEoJmhHT+sAzWxlJWk
 7yh57TdL
 DuMcCDl7lHAEfdkGwFpVqpHonI41MRG0a/eFb7+r3i1486Wx3eJFD4skUnd+tIX0tm9pWSAApE4/It1/wyquz4o7kFEkZ1m1UvdpZB03+uI0BqtU1cwMPweyimFTd+Ih0ShwbrivhIpmGDos9hD9Kd2hUATvRUZJDCikt5otHKOMZfavl5gLf42N3XCy1txXbPehKsATYLPPu8kMvvIHumaT50URIy2cvVqzJ/sjX+wBhH1FP8fsgFRsLgIvcx2bw9AycB+lnBq5vOOq0fVybkotIDokCKbUmHZCpmbOUOmWUJgret87g47T0XZwANTICKJlbXT6xMrUHSJNU4JRmaXXAUzhhLWeIoooMPfIUDs+13Wd9qmlc7tTrVoqQP/aE7yr9KMANLELmHyC4L6+9TlxqcYueUsrrGPCVTrEGkVjFcjTgR/HSOdEw9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 4:26=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Mon, May 18, 2026 at 5:47=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> =
wrote:
> >
> > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
> > > On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > > >
> > > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@inf=
radead.org> wrote:
> > > > > >
> > > > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > > > 1. There is no deterministic latency for I/O completion. It d=
epends on
> > > > > > > both the hardware and the software stack (bio/request queues =
and the
> > > > > > > block scheduler). Sometimes the latency is short; at other ti=
mes it can
> > > > > > > be quite long. In such cases, a high-priority thread performi=
ng operations
> > > > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be for=
ced to wait
> > > > > > > for an unpredictable amount of time.
> > > > > >
> > > > > > But does that actually happen?  I find it hard to believe that =
thread A
> > > > > > unmaps a VMA while thread B is in the middle of taking a page f=
ault in
> > > > > > that same VMA.  mprotect() and madvise() are more likely to hap=
pen, but
> > > > > > it still seems really unlikely to me.
> > > > >
> > > > > It doesn=E2=80=99t have to involve unmapping or applying mprotect=
 to
> > > > > the entire VMA=E2=80=94just a portion of it is sufficient.
> > > >
> > > > Yes, but that still fails to answer "does this actually happen".  H=
ow much
> > > > performance is all this complexity in the page fault handler buying=
 us?
> > > > If you don't answer this question, I'm just going to go in and rip =
it
> > > > all out.
> > > >
> > >
> > > Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> > > waiting for answers),
> > >
> > > As promised during LSF/MM/BPF, we conducted thorough
> > > testing on Android phones to determine whether performing
> > > I/O in `filemap_fault()` can block `vma_start_write()`.
> > > I wanted to give a quick update on this question.
> > >
> > > Nanzhe at Xiaomi created tracing scripts and ran various
> > > applications on Android devices with I/O performed under
> > > the VMA lock in `filemap_fault()`. We found that:
> > >
> > > 1. There are very few cases where unmap() is blocked by
> > >    page faults. I assume this is due to buggy user code
> > >    or poor synchronization between reads and unmap().
> > > So I assume it is not a problem.
> > >
> > > 2. We observed many cases where `vma_start_write()`
> > >    is blocked by page-fault I/O in some applications.
> > >    The blocking occurs in the `dup_mmap()` path during
> > >    fork().
> > >
> > > With Suren's commit fb49c455323ff ("fork: lock VMAs of
> > > the parent process when forking"), we now always hold
> > > `vma_write_lock()` for each VMA. Note that the
> > > `mmap_lock` write lock is also held, which could lead to
> > > chained waiting if page-fault I/O is performed without
> > > releasing the VMA lock.
> >
> > Hm but did you observe this 'chained waiting'? And what were the latenc=
ies?
>
> We have clearly observed that the `fork()` operations of many
> popular Android apps, such as iQiyi, Baidu Tieba, and 10086,
> end up waiting on page-fault (PF) I/O when the VMA lock is
> held during I/O operations. This has already become a
> practical issue. I also believe this can lead to chained
> waiting, since the global `mmap_lock` blocks all threads that
> need to acquire it.
>
>
> >
> > >
> > > My gut feeling is that Suren's commit may be overshooting,
> > > so my rough idea is that we might want to do something like
> > > the following (we haven't tested it yet and it might be
> > > wrong):
> >
> > Yeah I'm really not sure about that.
> >
> > Prior to the VMA locks, the mmap write lock would have guaranteed no co=
ncurrent
> > page faults, which is really what fb49c455323ff is about.
> >
> > So Suren's patch was essentially restoring the _existing_ forking behav=
iour, and
> > now you're saying 'let's change the forking behaviour that's been like =
that for
> > forever'.
>
>
> I am afraid not. Before we introduced the per-VMA lock, we
> were not performing I/O while holding `mmap_lock`. A page fault
> that needed I/O would drop the `mmap_lock` read lock and allow
> `fork()` to proceed.
>
> Now, you are suggesting performing I/O while holding the VMA
> lock, which changes the requirements and introduces this
> problem.
>
> >
> > I think you would _really_ have to be sure that's safe. And forking is =
a very
> > dangerous time in terms of complexity and sensitivity and 'weird stuff'
> > happening so I'd tread _very_ carefully here.
>
> Yep. I think my original proposal did not require any changes
> to `fork()`, since it simply preserved the current behavior of
> dropping the VMA lock before performing I/O. In that model,
> `fork()` would not end up waiting on I/O at all.
>
> What you are suggesting now appears to be performing I/O while
> holding the VMA lock, which in turn introduces the need to
> change `fork()`.
>
> >
> > >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 2311ae7c2ff4..5ddaf297f31a 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> > > *mm, struct mm_struct *oldmm)
> > >         for_each_vma(vmi, mpnt) {
> > >                 struct file *file;
> > >
> > > -               retval =3D vma_start_write_killable(mpnt);
> > > +               /*
> > > +                * For anonymous or writable private VMAs, prevent
> > > +                * concurrent CoW faults.
> > > +                */
> >
> > To nit pick I think the comment's confusing but also tells you you don'=
t need to
> > specific anon check - writable private is sufficient. And it's not real=
ly just
> > CoW that's the issue, it's anon_vma population _at all_ as well as CoW.
> >
> > > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) =
&&
> > > +                                       (mpnt->vm_flags & VM_WRITE)))
> > > +                       retval =3D vma_start_write_killable(mpnt);
> >
> > I think this has to be VM_MAYWRITE, because somebody could otherwise mp=
rotect()
> > it R/W.
> >
> > I also don't understand why !mpnt->vm_file for a read-only anon mapping=
 (more
> > likely PROT_NONE) is here, just do the second check?
> >
> > (Also please use the new interface, so !vma_test(mpnt, VMA_SHARED_BIT) =
&&
> > vma_test(mpnt, VMA_MAYWRITE_BIT))
>
> Yep, I can definitely refine the check further. But before
> doing that, I'd first like to confirm that we are aligned on
> the direction.
>
> If you still intend to hold the VMA lock while performing I/O,
> then I think we should fix `fork()` to avoid taking
> `vma_start_write()`.
>
> >
> > >                 if (retval < 0)
> > >                         goto loop_out;
> > >                 if (mpnt->vm_flags & VM_DONTCOPY) {
> > >
> > > Based on the above, we may want to re-check whether fork()
> > > can be blocked by page faults. At the same time, if Suren,
> > > you, or anyone else has any comments, please feel free to
> > > share them.
> > >
> > > Best Regards
> > > Barry
> >
> > Technical commentary above is sort of 'just cos' :) because I really qu=
estion
> > doing this honestly.
>
> I think we either need to fix `fork()`, or keep the current
> behavior of dropping the VMA lock before performing I/O.

I see. So, this problem arises from the fact that we are changing the
pagefaults requiring I/O operation to hold VMA lock...
And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
anonymous and COW VMAs only while holding mmap_write_lock, preventing
any VMA modification. On the surface, that looks ok to me but I might
be missing some corner cases. If nobody sees any obvious issues, I
think it's worth a try.




>
> >
> > I'd also like to get Suren's input, however.
>
> Yes. of course.
>
> >
> > Thanks, Lorenzo
>
> Best Regards
> Barry

