Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0693FFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 05:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4886B0088; Tue, 28 Apr 2026 01:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9D56B008A; Tue, 28 Apr 2026 01:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF5B6B008C; Tue, 28 Apr 2026 01:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC8B6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:40:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1C381C07C1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:40:32 +0000 (UTC)
X-FDA: 84706864704.08.57BE659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D143640003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:40:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s7wNHyF1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777354831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fS0zxAHdlDELmGXk903zvG9jRUodb1AElMUZcYvUB4=;
	b=NhShM4i8qPMNDZus4SSYu1P2KYHm7pAwVNFQhp8736uhnarqwqP1pARPChNpAK0LY6TEKx
	sLvRy3pJOSQd0QspCi16XVJTZe3a8vtMEjD0TbECO0/YxZ9cjv6fbkuBAYaJlkDaqVhmIi
	ZRdR849P7icv1XuDxBXdPsTuoo2jQKo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s7wNHyF1;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777354831; a=rsa-sha256;
	cv=none;
	b=L4LeXoncJOfp+F/jYDrNEbEY7XNCOEwNDnYcDwvprGIoMz4PfL6Df/Lux1qW4LyrMhDf6Z
	tYI4eVcVfY9H2zDxiyEsHXJFDdpNlaeFzACYRB40hAt61JdTbT266JVYfDivZJq2a6e5oj
	iN9rTB60rlTk1UjGhxrg9tIfewsQM+s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A637940292
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AB5C2BCB3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777354829;
	bh=ACDTs+nzKnqc5cb5UacIuhCf4JsteW4a1h8Qd9UWrmo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s7wNHyF1mmeg8BMRTiy1fge0uR38oPB9AO7yb/JHrL0fmCj9rjKyN4R1pYmij6P49
	 NpSt/+nzelOPGQ85n3zNIzKAVZs9zINWgiQETB65Rt3R9B8MOYmAlJiDodzhKJBUey
	 mjouxP196IsgpgyiZ8efcgH96XdEou6ty9Y0Sm8oPxKXFuHRme05IGQIDVUBoaBaCJ
	 65xkTY52HUygugPpMaxpFXIpn+w8oZ3xswj8ICpYjhAH+kjPBeMPn8AVh5bhCoC5M6
	 QS4OwzExxr0VUjpc5mDQlG8AAQGiZyHarRSHy89rrLWd8zFOzksqbWi2CgcmBw7d72
	 2pQKrhlkqU5+g==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8eab809593cso951177685a.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:40:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YyV6KBxvkwNtlliy2GmBZiCUlr5eWNtyPtBsxMqhdiMK2tnUInN
	rBYwGzGEuYrPRGpMDNo1P3w8avziFDz3wG9K8wUnuRwQ2OLYF+4Z9l5A9KA2pD6uXgbgg6Ik3Oy
	iiY6AvxQk1m27WbOIhyqod4ii5DccIPM=
X-Received: by 2002:a05:6214:449f:b0:8a5:fced:6af2 with SMTP id
 6a1803df08f44-8b3e30a71e6mr29479776d6.38.1777354828735; Mon, 27 Apr 2026
 22:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260418120233.7162-1-baohua@kernel.org> <20260424045334.ce9801ecd7a077bf3d5e4ff1@linux-foundation.org>
In-Reply-To: <20260424045334.ce9801ecd7a077bf3d5e4ff1@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Apr 2026 13:40:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xMuBnQs3My21nvSCwLMGDb+StjmdhmbbfrO_EwOdEjRg@mail.gmail.com>
X-Gm-Features: AVHnY4JJ_k2LizkUk9OcUzg4WVIgapayHXHbEYmFC1zBPjUul_qnqvXDc_yu0QM
Message-ID: <CAGsJ_4xMuBnQs3My21nvSCwLMGDb+StjmdhmbbfrO_EwOdEjRg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, wangzicheng <wangzicheng@honor.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lei Liu <liulei.rjpt@vivo.com>, 
	Matthew Wilcox <willy@infradead.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	qiaozhe@iscas.ac.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D143640003
X-Stat-Signature: 8hpyryhneepfr7o4x18ab4rwappc6cnq
X-HE-Tag: 1777354830-741249
X-HE-Meta: U2FsdGVkX1/ED6NI3hNm3XGGD7mAQ+LelohnPynjgSqIhgKn7haCBqeH8qhJ/t/D/RgrmvnUsqdWIZT1S6bEJzR8+CH00agegYv9vw758OHqe0C4/g98ypfIoUa86J+3cQyBtENTDGEKzdbyzRjMBTiVYvJnWfVggy3cHtIh1t7xTm5nSAwwbI/Q9T3fDpx3ILJ8OC+g5YXlqyAJt8d457GpLIWvK1f64u4iMG/t2iOoOUrzZLaViVesr4TiLDaoYCcnho0cK9lWYddrwdc1ctfWy/S6R5R70DnvbOwuJWU+o+Zmfgb/mya9uRmGarecnjiC94qgyXQuNeLiVFSi8km5fA3rKvvGA0EuqV+GaYzp9hD0Q88pTDrq7rR7zqrQ3O9QKaJzrQ7yhj3OZlfA3h+N8xsw+fSZTuW1Ub05z55Rh8WEDZ1nPnTNmylGi5GVC6lOeMcQnh9fkaXknIsYhl8eDRKvGMhXrA4gUku5L2rrJV+wcweIO8xQGJdAoNzkcLIImPFTQcdJQ2tNbA++VgiNeZ2+Xup4FvEggO7V1r7bIsIOI8xt0Layb9xkqJUE50sAYmxvcDC0f4S0HVdNlPrLo57HGymWogafqnx8wBTTIFHXFF72wNXZWr1/yS1H9JYzu5vuPrDzazhEO95EkK8sV/v5chj+BUosvieIC5TbjWlAX3xSGCVVCPj2qTzXgcJtnFDCMhZ46EmKYViBKsoC6ZqWlUfUzGPTnTMZxc96sGLAGpi2bXOjF+pYO39/rIcNQtB5HaVUhv4I5XCsbPasqS3yo2wH7w7Zli/2oOekQOr83IombaprPHlnnI3my7w737jeVqVFZ1TtQzutYVAsxhDn2T/yuVaB9KtSdydXo0KNXSJoQV51aMIUedakP+WbwGSqKDzNr1GZ5j4jAi0oslErT7qSMCSko6giU0Zvug8FT2O5TTgDD24nAlyz/ZER0YOIw/iI/vVyy2x
 4cr8NrI/
 n20QAOINN1rLnIMWMr8TZJ5TuCHKVnusIskaWvadmSfzU/ZzjiyTueuo7BEtURPg1GVi7RdU3ce4SQJi+ckv8d8AsJ4QAFHPAxVM1WxkMZwXiNWraBAR69WSWEmQkVc57DCEyY9dGR14jCW/Kae3k/llV12wGGx6bg5rSZeoneG9WqEPBSsrs2XSOtPWHQxDUWJ9Feap2SMZJCRTbaj+GajozGS/37kLtdbkhal+PXYg4wOes3rOkgTrhevlwe4UFVkM9GglHv0auVS7OUkUNjnn2+0OioYCPNXDatVOURWGr7Zs2W0kDIpD7hPkoPG/iy/CWDJ5+gr9V94bN9b4rvna2zCf7i+ez3AZlyGKxXYbrcZCXJez/r4EBOUv3rLPgskzQl1Kmmdp2OIDNJVqQBQcpvcIKiMreWyvAWMEPD1sbg+96akxhFXA3rFOaS/sy3P/T31G5qao+IDpj4xhv43Ys/k5p21uhx8k0QnlO/NG1QbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 7:53=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 18 Apr 2026 20:02:33 +0800 "Barry Song (Xiaomi)" <baohua@kernel.o=
rg> wrote:
>
> > MGLRU gives high priority to folios mapped in page tables.
> > As a result, folio_set_active() is invoked for all folios
> > read during page faults. In practice, however, readahead
> > can bring in many folios that are never accessed via page
> > tables.
> >
> > A previous attempt by Lei Liu proposed introducing a separate
> > LRU for readahead[1] to make readahead pages easier to reclaim,
> > but that approach is likely over-engineered.
> >
> > Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> > protection"), folios with PG_active were always placed in
> > the youngest generation, leading to over-protection and
> > increased refaults. After that commit, PG_active folios
> > are placed in the second youngest generation, which is
> > still too optimistic given the presence of readahead. In
> > contrast, the classic active/inactive scheme is more
> > conservative.
> >
> > This patch switches to folio_mark_accessed(). If
> > folio_check_references() later detects referenced PTEs,
> > the folio will be promoted based on the reference flag
> > set by folio_mark_accessed().
> >
> > The following uses a simple model to demonstrate why the current
> > code is not ideal. It runs fio-3.42 in a memcg, reading a file in a
> > strided pattern=E2=80=944KB every 64KB=E2=80=94to simulate prefaulted p=
ages that may
> > not be accessed.
>
> Are you able to suggest any workloads which might regress?  And test
> for those?

I don=E2=80=99t have a specific workload, but I can imagine one. For exampl=
e,
a workload with readahead, where all readahead pages are mapped and
all folios also happen to be hot. In this case, placing them into
active generations at the readahead stage might be beneficial. However,
this patch would not lose them either; it may just require a more
folio_check_references()- PTE scan to confirm they are truly
accessed before activating them.

>
> > Without the patch, we observed 12883855 file refaults and a very low
> > bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy
> > hot positions, continuously pushing out the real working set and
> > causing incorrect reclaim. With the patch, we observed 0 refaults
> > and bandwidth increased to 5078 MiB/s.
>
> Wow.  And that isn't a crazy workload.

Right.
Readahead is mainly for I/O performance, but it does not necessarily
mean those pages will be accessed or become hot. On a memory-limited
system, promoting readahead folios can be very harmful.

>
> > For those who want to try the model on x86, you will need the
> > following in arch/x86/include/asm/pgtable.h.
> >
> >  #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
> >  static inline bool arch_wants_old_prefaulted_pte(void)
> >  {
> >       return true;
> >  }
>
> Can you propose a patch?  We can at least toss it in there for testing
> while we think about it.

I can include this RFC after this patch in v2. Right now only arm64
supports fault_around of old PTEs; it seems all architectures were
disabled due to an x86 issue in commit 315d09bf30c2
("Revert 'mm: make faultaround produce old ptes'"). It was later
revived only for arm64 by Will.

I may reach out to and engage the x86 and RISC-V communities for a
revisit. I actually have Zhe Qiao testing it on newer AMD and Intel
platforms. With sufficient memory and no reclaim pressure, mapping
fault_around PTEs as old still shows a small UnixBench regression, as
below. However, I doubt this is significant, because under memory
pressure, reclaiming the correct folios is likely more important than
the hardware access flag cost, offsetting the HW AF overhead.

Alternatively, we may need some self-tuning logic to detect memory
pressure and decide whether to map fault_around PTEs as old on
platforms where HW AF handling is costly?

Thanks to Zhe Qiao for the data below. Cc=E2=80=99ing Zhe Qiao as well.

AMD Ryzen 9 9950X 16-Core Processor:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Kernel A: 7.0.0-14-generic =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Kernel: 7.0.0-14-generic
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                        Index (avg)     n  Iters
----------------------------------------------------------------
dhry2reg                      111703.38     4  [0,1,2,3]
whetstone-double               34170.80     4  [0,1,2,3]
execl                          15312.25     4  [0,1,2,3]
fstime                         59662.58     4  [0,1,2,3]
fsbuffer                       72696.42     4  [0,1,2,3]
fsdisk                         31885.47     4  [0,1,2,3]
pipe                           61432.48     4  [0,1,2,3]
context1                       15438.23     4  [0,1,2,3]
spawn                          16349.47     4  [0,1,2,3]
syscall                        38748.50     4  [0,1,2,3]
shell1                         24710.05     4  [0,1,2,3]
shell8                         20207.05     4  [0,1,2,3]
----------------------------------------------------------------

  Valid tests: 12 / 12
  =E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=97
  =E2=95=91  System Benchmarks Index Score: 34045.39         =E2=95=91
  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=9D


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Kernel B: 7.0.0-custom-test+ =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Kernel: 7.0.0-custom-test+
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                        Index (avg)     n  Iters
----------------------------------------------------------------
dhry2reg                      105061.82     5  [0,1,2,3,4]
whetstone-double               33945.03     4  [0,1,2,3]
execl                          13992.70     5  [0,1,2,3,4]
fstime                         59037.77     4  [0,1,2,3]
fsbuffer                       72465.12     4  [0,1,2,3]
fsdisk                         28388.05     4  [0,1,2,3]
pipe                           64047.38     4  [0,1,2,3]
context1                       15322.56     5  [0,1,2,3,4]
spawn                          16020.58     4  [0,1,2,3]
syscall                        40669.70     4  [0,1,2,3]
shell1                         23514.32     4  [0,1,2,3]
shell8                         19393.55     4  [0,1,2,3]
----------------------------------------------------------------

  Valid tests: 12 / 12
  =E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=97
  =E2=95=91  System Benchmarks Index Score: 33159.46         =E2=95=91
  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=9D


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Per-Test Index Comparison
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                         Kernel A       Kernel B       Diff %
----------------------------------------------------------------
dhry2reg                    111703.38      105061.82       -5.95%  =E2=AC=
=87
whetstone-double             34170.80       33945.03       -0.66%
execl                        15312.25       13992.70       -8.62%  =E2=AC=
=87
fstime                       59662.58       59037.77       -1.05%
fsbuffer                     72696.42       72465.12       -0.32%
fsdisk                       31885.47       28388.05      -10.97%  =E2=AC=
=87
pipe                         61432.48       64047.38       +4.26%  =E2=AC=
=86
context1                     15438.23       15322.56       -0.75%
spawn                        16349.47       16020.58       -2.01%  =E2=AC=
=87
syscall                      38748.50       40669.70       +4.96%  =E2=AC=
=86
shell1                       24710.05       23514.32       -4.84%  =E2=AC=
=87
shell8                       20207.05       19393.55       -4.03%  =E2=AC=
=87

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Final System Benchmarks Index Score
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  7.0.0-14-generic                       34045.39
  7.0.0-custom-test+                     33159.46
  --------------------------------------------
  B vs A                                   -2.60%



INTEL(R) XEON(R) PLATINUM 8575C:


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Kernel A: 7.0.0-14-generic =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Kernel: 7.0.0-14-generic
  Prefix: 24-300s- (24 threads)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                       AvgScore     Baseline      Index     n
----------------------------------------------------------------
dhry2reg                   87226.50     116700.0       7.47     4
whetstone-double           29323.70         55.0    5331.58     4
execl                      12638.17         43.0    2939.11     4
fstime                     84223.20       3960.0     212.68     4
fsbuffer                   56491.22       1655.0     341.34     4
fsdisk                     34570.90       5800.0      59.61     4
pipe                       45941.97      12440.0      36.93     4
context1                   20177.08       4000.0      50.44     4
spawn                       9498.88        126.0     753.88     4
syscall                    29181.70      15000.0      19.45     4
shell1                     21060.58         42.4    4967.12     4
shell8                     17669.08          6.0   29448.47     4
----------------------------------------------------------------

  Valid tests: 12 / 12
  =E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=97
  =E2=95=91  System Benchmarks Index Score: 335.36         =E2=95=91
  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=9D


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Kernel B: 7.0.0-custom-test+ =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Kernel: 7.0.0-custom-test+
  Prefix: 24-300s- (24 threads)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                       AvgScore     Baseline      Index     n
----------------------------------------------------------------
dhry2reg                   87607.90     116700.0       7.51     4
whetstone-double           29092.33         55.0    5289.51     4
execl                      12318.00         43.0    2864.65     4
fstime                     85738.35       3960.0     216.51     4
fsbuffer                   57621.05       1655.0     348.16     4
fsdisk                     33608.60       5800.0      57.95     4
pipe                       46320.38      12440.0      37.24     4
context1                   20450.12       4000.0      51.13     4
spawn                       9579.15        126.0     760.25     4
syscall                    29563.43      15000.0      19.71     4
shell1                     20073.10         42.4    4734.22     4
shell8                     16946.05          6.0   28243.42     4
----------------------------------------------------------------

  Valid tests: 12 / 12
  =E2=95=94=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=97
  =E2=95=91  System Benchmarks Index Score: 333.55         =E2=95=91
  =E2=95=9A=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=
=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=
=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=90=E2=95=
=9D


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Per-Test Index Comparison
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Test                         Kernel A       Kernel B       Diff %
----------------------------------------------------------------
dhry2reg                     87226.50       87607.90       +0.44%
whetstone-double             29323.70       29092.33       -0.79%
execl                        12638.17       12318.00       -2.53%  =E2=AC=
=87
fstime                       84223.20       85738.35       +1.80%
fsbuffer                     56491.22       57621.05       +2.00%  =E2=AC=
=86
fsdisk                       34570.90       33608.60       -2.78%  =E2=AC=
=87
pipe                         45941.97       46320.38       +0.82%
context1                     20177.08       20450.12       +1.35%
spawn                         9498.88        9579.15       +0.85%
syscall                      29181.70       29563.43       +1.31%
shell1                       21060.58       20073.10       -4.69%  =E2=AC=
=87
shell8                       17669.08       16946.05       -4.09%  =E2=AC=
=87

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  Final System Benchmarks Index Score
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
  7.0.0-14-generic                         335.36
  7.0.0-custom-test+                       333.55
  --------------------------------------------
  B vs A                                   -0.54%

>
> > --- a/mm/swap.c
> > +++ b/mm/swap.c
> > @@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
> >       /* see the comment in lru_gen_folio_seq() */
> >       if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> >           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> > -             folio_set_active(folio);
> > +             folio_mark_accessed(folio);
> >
> >       folio_batch_add_and_move(folio, lru_add);
> >  }
>
> lol, I was expecting something larger ;)

Yep. I usually prefer small patches if they can resolve the problem,
which would make our lives easier :-)

But we will likely need a 2/2 patch for refault activation, as
discussed with Shakeel and Axel.

Thanks
Barry

