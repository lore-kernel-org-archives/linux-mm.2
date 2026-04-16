Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3E4DF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8BFE6B0095; Thu, 16 Apr 2026 11:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E631D6B0099; Thu, 16 Apr 2026 11:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78CD6B009B; Thu, 16 Apr 2026 11:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C855C6B0095
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:26:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C6908C6E8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:26:09 +0000 (UTC)
X-FDA: 84664794858.23.07FF543
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 83C69A001A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:26:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r5IkDHJr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776353167; a=rsa-sha256;
	cv=pass;
	b=ASmOlSAyDv6wXBq3NrM02kHT6Y7qsI9a9iBkmmlhZUWNs2psecm0S7jgRetrW67nMO02wn
	qVcEBBvJTzUqTmmXnw81A3TAd/g8THzGaKi9PhgxKikRIG6SWzCsxOo1xRf4u0T0JXmYcR
	+eRT6CXcBQ7E449PLIHqb6O5PTm5FIs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r5IkDHJr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776353167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8jgbZta5Vs8aqqguyp3QSwPgyf64+i6mRTRJLQLhj8=;
	b=FQYcFjQ1SdjUOoudQx/EEGDX5U8ku6WDrc+QLEJ0afNKsdZ+Oewr9W+h5RGseUhZqeVV5s
	o4vauhovp/4AqPoVuo/jtYP+JhtmXbtdMdb58pgYj57JVBgPQTIypuaUB6pDCp2Irqsxko
	RxOR/VbWw10wNlzLnbDDHmkJW2h9VMk=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7b248750279so47119637b3.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:26:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776353166; cv=none;
        d=google.com; s=arc-20240605;
        b=BzrULYkd1y0KDaPejq0eWBNna2iFpiX6kJSdXtQapjhicuu0bhA5RIkpEAeN0o0q+/
         5oM/fu6SYzNFdumGkfSZHtb8aAo20zU8fX8MKZvcb3f7zaxCRzyetu8EXwR12+sRr1FU
         Mapyz7eWxoNY6+N0xv9qn/pBhPhFU3PHzXOxu1ePldvK11JeFzceW00io6s8iSnu1nT6
         GOjmC/Rg/zXSBMooblxR6aL9AXlaFDTgxev6Mxif04E//cnplBkqf0GOtUeyNuqOq8mF
         6lZOaqwy36yqpceIADFIbESrhu5o7+FmMBt6JLxY9kXiLBWfvmbg4HyNtgWWGd+7xYMY
         UWUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B8jgbZta5Vs8aqqguyp3QSwPgyf64+i6mRTRJLQLhj8=;
        fh=nYeRfHlTEzL1J2vj/x3vJU7KPoCpTYarQf/8DMUaZD0=;
        b=lZq6MhvK1PKhbNEKL9Yxsgf6Av1i/no4zXiYA4INEZdSBNQQHMCfkK7bZ3LlCVu0+d
         ypMxs74bCio4EiT4i1+M4eJOVNymVD2czhmrJ99Af+IZaW9m+N7+7u+p/+zuUVAcJ4N8
         7CHDcUW5zYMrbq0TLT2AeWCI4eyg7T7Wb8QGGhi2Vn5thssCvKjxqNCAYojwUloWEL3m
         3JMqcnf0d+ZDaSWuyvN//78O9huMQxigSwImzNqj9+JTKv+oQCMUrMFSOCSzGJTNety4
         AuIqG4JeU8e1xCcvhr5qBJvTDlpR5P2zuUHR0FDS+KeQKCYME8hMeDJOwxYdbPFSqtME
         1aqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776353166; x=1776957966; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8jgbZta5Vs8aqqguyp3QSwPgyf64+i6mRTRJLQLhj8=;
        b=r5IkDHJrG1AajOUQSdW73c7if/FDZQBHZ6wF7inAc4DtJ/RNM5DV381PODShiILwPO
         i21ggO6V2a+e0TwB6izHWyfNJ8a28H7C4uaztEC+V94mem0ZSOfbQiwS9/nmRSqDBKrY
         /5Ufb62gpVAOIc1uwZxOYrHCreBU+jWzR6Muh14xLwovcAeyboe/SeOvOyiQa/GpeA7i
         BXlg2e2QB7G2J1B+ml7FFd377rkntjLb3UPGe9pdrWGH6BguN1w9vlf0OVgZKvXyHoL7
         2lmVQ3nCcd4FxqcsFBHKprNIZnat1TmW2nqrdU+3OsCH78ywYWpkcx2YqqJ9uWNoOddx
         xXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776353166; x=1776957966;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B8jgbZta5Vs8aqqguyp3QSwPgyf64+i6mRTRJLQLhj8=;
        b=ULS9F/ly5MTDp36IXzolMxiQ8cQbDqvC1+nD403q0jovWjqtR93HrfH8dBVhJVdJkO
         UT/offgBYnvDTPkTczsP8Ekj6kznoUT6ecZaKDpkmzR9PYI6O0Gk4sDcQl7pFI1W/Tr3
         FmSeiEHUaci9OjnC8RaCRIgDc94mCvkLcpmu7BPDxdFcacaMLSdAA2MvtFgSbhuGsD/q
         QRBX779XkW84Em8UtBsrHu58dafAqUbI/r/eiqD02n3Q3XG+UJWp2WHr0mX1tEK36ldw
         JfKbQJqVlEnn5rSC9O5Y+ieAME8v5CAoUe5lXupggRbgtdgXII7BIrhmjoA6hekw2YOJ
         O6kQ==
X-Forwarded-Encrypted: i=1; AFNElJ/0rLSUwVtipuMLtXfruy6tl0mgodhW7fNBvCQ+IftpgKcScmmbofkNoOp8m6g3ljkNOtyynmhgfw==@kvack.org
X-Gm-Message-State: AOJu0Yy/D7AG5D9cBTEIcLo6rhPb2CgQPYcTbIcOh/Vo/DlUo6TezcWd
	bdo3D2bIuYbUtuSFwGNDwdJWHPNzLpUk+qaj13ugQPLEd4bzylULeSjwpKkxQybHOssBURRYOYW
	LvmpEwYBxl43sAKv6JLJagcWCgw/+ki0=
X-Gm-Gg: AeBDiet7cuWVXv/gC/JS7asUARTUM5AaEP2e63q5iZYYNvQfYcg8fdxnc1JT9dhOeM2
	WsvHisfFNG5bcVWBAhSeK4Y/l/gkL7jWj3jms4je7aqSJ/PMmnLAmKxUjBGBXGgOO9UTiCvA3g3
	ouExlGEmVNBdrWpP4DdKgfULnZvBFeEwaCadbC5zlexta2ONyurPkJJ/tAHphc4ecXqasiav8rq
	U0/ecukAMOkJICF9lm/8DXXfWlh2ck/Xnr6ea20Ia89fyjRh5gEKUbFhsjudG/HSE5/lW49+ciP
	5of2v6+MKGTRKww=
X-Received: by 2002:a05:690c:6601:b0:798:730e:effb with SMTP id
 00721157ae682-7af6ee47a66mr300246947b3.10.1776353166389; Thu, 16 Apr 2026
 08:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260416102558.575210-1-ekffu200098@gmail.com> <aeDz3UAB54v2K8Hz@kernel.org>
In-Reply-To: <aeDz3UAB54v2K8Hz@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 17 Apr 2026 00:25:54 +0900
X-Gm-Features: AQROBzAw6wGw48suIcLijqaYowDfuLwEMheMKL7CrZeq15DG_kNeON8FTyQGn-g
Message-ID: <CABFDxMGYBkZpAeH8zbZsQA3giN9v8dyHPq=TCZf2EZbppMT24w@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: 5qr1ed16ew6ryssp69hkbj6pgt1kdqci
X-Rspam-User: 
X-Rspamd-Queue-Id: 83C69A001A
X-HE-Tag: 1776353167-317617
X-HE-Meta: U2FsdGVkX18I8TnQudR6rsBo4gYzuE5FQEeFrJLT0SUMty0jgsAIKyrdMx1gWfr6etyoh6FLxgxgTsn7uutqtbmFNiiz6F5AVp7zFIiIDBjwtuLVO4ZT1now8gD9Jc9+dCkS1nGtdfLsGg1cXMrwyM3JcvPJS90/JsvIzHFWq2dIni2p8HMI+6N+iiF7WwtG/PsC8YYwSXiZ3FQcn6p+Z7EvUDaW+vZymqoByn7ytC6bU7lKPlSX0lFq7VSLOOyVMWtxmT7nM4yoHPmiMEgjFUZ9oLud2CEjBMhGJmhZBGY0J51xN222OOkcfkweLp81nz9ICG4HfTc08UKsv/1R7cWD7p53iiXnvoLUD2KKdkVi3Mlbzt3xz/NDzWA1uVOp/eUcVhfNZJZE9JT+CtjQdZv0OfgTkVWbM02xtVNNc1rptxMSjtLSj8mSYWXiNf00b4oUXHy5yXvdqfRxLxWoLDbpD/FQBA5HZuXwXGSIt5tuhUwc+yz/VPGdwYXlso7bebDQ59MkhlHDg5G8InuC9ZSsUrdTOzfhcnFfT1usZ2ZcpuxOQ20KNwOnvVjmNHc4bgpFjv3UqkHsGE6oMQFlLlPVV6ZsS5Xa6EdjPgRJkrjHI1nL5HiZ5L30h+++inr3W0KY0NDN1XOhi7ueFoop37Ld8JB+dyNYk59qZT96/SX+RsKkzEH+ZfcLH+EB8IFNuisFGBggny4ALcsqdM8DIxygTOzKKFA1K4VsY1q7/D/wA3eqNPh595GI4TeeiaFBeilPqttPxB9EfsHNGwwtSkrAFKhn5YBiUTTlKVfY9CA/DAthGh/RHoj8Nx1b0dahKL7WXyV2f0iFKxlpPnXaUmhfnv0+r/e3xVpUs5jyalmEBaOBg2R8//KfxiEpR2gJin/la0+yEM0FonSvePgECqin0/zz3BrjV0uV+kUjaXaN13ip1g3jvH3zeu9oRM9phGy3PRyKjYvN4ocUFiv
 c/7TBMiX
 v9kgTyavZrBfa1/4lp4e+eUky8gyQFKqvwquRQPRopqAENXCVV9FmWuQOsw/Wq1oishuDUmJHyaaFd7/9BWS6IZQ5Bjd37FBxqCm6TggWENwjMfRwLsxMeRnXpf6FMmhbr9hF2iWm2lW03VQxbud0eOLrC7ZnJ/hUHEsC2TEele2U+JhQas9X9D/2Mvw2QYc7wcUwCZBkIOlctz7GRnkSb0RMt8adlmmxRX83NBI2PtvLRYleH1lijNZzhBmAqj0eJExf1ueN5NTFZQeHyDZ6Pnf086CmH39JEXNdjdH4THphiIaSL7WY1tYJB7XEZb9ftqwBrmHJqd8KNGyWZC+8BchlWKp7H7o3Y0qMRQ0b5Dw5u1TiZyeQTgaDJuZW67HbuePJFOoft5qHLbOa+pgcDLTrg/eyz8n5qTZdy0xg6Mlekxb9eq3jNChwYOJoRjznGHBf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 11:36=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > returns the next absolute node ID, not the number of nodes created.
> >
> > The existing under-allocation detection logic compares next absolute no=
de
> > ID (ret) and request count (n), which only works when nid starts at 0.
> >
> > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created f=
rom
> > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > fake node nid starts at 8, but only 4 fake nodes are created due to
> > current FAKE_NODE_MIN_SIZE being 32MB, and
> > split_nodes_size_interleave_uniform() returns 12. By existing
> > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > under-allocation will not be detected.
> >
> > Fix under-allocation detection logic to compare the number of actually
> > created nodes (ret - nid) against the request count (n).
> >
> > Also, fix the outdated comment to match the actual return value.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capab=
ility") # 4.19
> > ---
> >  mm/numa_emulation.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index 703c8fa05048..c1d0a76aef64 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64=
 hole, int nr_nodes)
> >   * Sets up fake nodes of `size' interleaved over physical nodes rangin=
g from
> >   * `addr' to `max_addr'.
> >   *
> > - * Returns zero on success or negative on error.
> > + * Returns absolute node ID on success or negative on error.
> >   */
> >  static int __init split_nodes_size_interleave_uniform(struct numa_memi=
nfo *ei,
> >                                             struct numa_meminfo *pi,
> > @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *num=
a_meminfo, int numa_dist_cnt)
> >                                       n, &pi.blk[0], nid);
> >                       if (ret < 0)
> >                               break;
> > -                     if (ret < n) {
> > +                     if (ret - nid < n) {
> >                               pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> >                                               __func__, i, ret, n);
>
> The error message also should be updated, now it prints the last node ID
> rather than number of created nodes. I think it's worse creating a
> temporary variable for ret - nid to make the code clearer.

Is "worse" a typo of "worth"?

And thanks for catching. I totally agree that the error message needs
to be updated.

> I'd also recommend running qemu without and with your patch and verifying
> it works as intended.

In the next version, I'll try to include qemu based test results.

> >                               ret =3D -1;
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

