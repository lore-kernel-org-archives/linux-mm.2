Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482EF606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tzaQbQ2T
Received: by kanga.kvack.org (Postfix)
	id 61DF56B05B0; Wed, 11 Nov 2026 01:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5F56B05B1; Wed, 11 Nov 2026 01:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B856B05B2; Wed, 11 Nov 2026 01:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22C3C6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:16:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAA97A0218
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:16 +0000 (UTC)
X-FDA: 85421828352.15.5414CE7
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE06B180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tzaQbQ2T;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794377774;
	b=svdcWwjngrrQXqLr+DyYiwilb91hjsL2ENfSAehhJohEUwQh6Z/GjalvLziR2rz8p1D9f5
	CSiCNEgqxt28sUv/vVe/jj3OxfT8inZAYfZVTnGeNkhNHdplG2gzVreW8S2VmYYzOlFaYO
	lE0v1x7Ac7HfpqgiCeonNTvgzC3Nxf8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tzaQbQ2T;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p71/DW116beDMpJe07R6eFNT4MapU9JGcbN3csjU8TM=;
	b=19rzBnR0izihtXDTMbw5bE+zwpc3GO1LYbJIKLjARYdO80KclI5WdII69WrNY5mdo8oNs2
	jiGqez/0YTa2hBLyrAMcQd37jQxcwf4/43N09CfS1XadsNSg8xfqKh+zCUTfozvsaJPsvm
	nLRLihMhzffdab6U0xfibCuSpUvazZk=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so4455608a12.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:16:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794377773; cv=none;
        d=google.com; s=arc-20260327;
        b=Sy2268vptboPmBZ2ER3B0cHrgtsMItl8hlOgJf6WhmYnii+NAmGhBMVFxZh+JgV84F
         6d7aw43+LaO6m0CEbwFyPhNvq6Fu0wz8Q4VZ2dKNNXRLwgeqouKR0QPzq5FKA99Nh4/i
         b6PUHbXcHI0zOaR1HJGbGZFv+xF7UrsKcUaoSamVV/g1G/JqKum2aNVBPqYx0CZEODnh
         25tcc04W07rokhQXx9jxf7TJFxKPr36cZ2FSu4FH1N5CXbh5MuqrL4z7FQpbzUurZkT4
         ml7Hopq/A7QudRwZNfkHYwY5AHE52T7COEftSpsrMJD7xhsILKJY2wrW+z/y8SQhS/jC
         arMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p71/DW116beDMpJe07R6eFNT4MapU9JGcbN3csjU8TM=;
        fh=1Sk3wso9qSbxqzCMuqPnVUX7GJbrBiqL+b1AFnoLlnM=;
        b=eccnpYKK47oyn6mbUoL5U2MkDgpA8Ngb3XtD6bS6DOTE/GVm7JolzfvIdXN++rosuy
         dmfm3VSLVwE2h8VOnug/W5RIRZaU94V3713vmiKYnnAi0S8ylT7/997TjVWa59fqvzye
         CoqGUmaAFRWbFie4RfpsqtovR/p1aSoq/AmP40A7abxQHXJDEyXc0WUQwrfeLtbAn7Nx
         zg8ykTgxH62nzOwgQg6kAoqWxaoMhKuCjj/fe9O841InVfIQ/fjqR8sIXGZGx9YCa5+n
         s3ekRC8dKlj1tFsKqT5S56Jc2WnXG4MIBKFyBsPEMlFDGrrnBzKlrgaxzuZZ7s6/52ed
         zCRA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794377773; x=1794982573; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p71/DW116beDMpJe07R6eFNT4MapU9JGcbN3csjU8TM=;
        b=tzaQbQ2T2s+DqkjrJ3kPv2MY8MVlKIfvenrKu98IgwF7xvu8mHZrOZMUun2lHTvKUo
         34F+WiHLcBbtiKpQPpG5x2ExgjbWuMETBEheeCE4sr+TPV2A4wqSDOgizyIF3LGuRuZ7
         M6OkbQYw/hYziwG9n3g/XNkgN9YR5RriYrBtZSDjKDH2CSGo4ArUVaj6VeVxIe4V6YNG
         nUSeBeVxDwI44Vjb/oMDG789Zz8BkL/jQz6MAZUUdy3e1SUiSZBCnysR1Zh31Ac59U2x
         sA9V2hWEC4lYyaMt6/y5fCOoYtQE/AAYtn0uuw0PVno4aCtM7rX9iFsOejIlnYSILKY9
         dmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794377773; x=1794982573;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p71/DW116beDMpJe07R6eFNT4MapU9JGcbN3csjU8TM=;
        b=o/QJ1urLY2xbLmWgbgATY0NH+LiaOn5mWNOORwcrI360SaKbneBFlfhs1euLtrJ9PI
         zxw3Ova6YWC2HB+msGNzeBsctiLWEfTA0c8MzaXogNqm/qOlHylNVzlw366o1SOfOPjR
         VEWZmchsvuEF/bHVLobRgQsKM6cH83yZyB2PC6Y6/nqAwMcaOi3OGyURKvaR+Sk2TBIf
         /QeAF05a8v7B6EAGAFMjp6oIa/cdYzzEwNdfXvqb8QqKucpZ0VC4Cf7pTapVZB7o5lX2
         mP/R8+67IAR/gOWDF+4iJDA8emjAY/MGPsBEWjQbtdPbSLkFa3Hl1xZ8tVhXUYNrORkz
         64sA==
X-Forwarded-Encrypted: i=1; AL+hErF6k4VE7Qnfwr/APmaCcTaGpanmIpELJPhmCWlvOjyrkFFUh/qFoYimK5uVAnx6OIKW47yjoMMadA==@kvack.org
X-Gm-Message-State: APuU4Z8SUx6Jp2DuuLTnS6HT7wTGLs6ih/9TN8gsF7ZENI08xqecOuxg
	PEFb+vuJmUbKwWEHxEY7zlsEwPLNblbehP3js/owJm89rLJplRm3Lwt8pfPjtAfm/9GnpH63c0A
	ABql/F4JobhbM2m7RJioZ4vgR4rRgjX8=
X-Gm-Gg: AYBFou1T5spAqb36QIOUufD8JM3VCYH0Z0vqltKC95PrkqXGJS6OpJzMcuoKQgAwSHX
	s8nZMzzsZ/+k40Ob5pq3tBu3HnvyLaZ9FtPfxc+6GwNAlJK+ZB+Vvj5STgP1pUSMZEVzm69P5iF
	bxNg5d8wlF2mJpaYNai1MDXUpv0rA+N4+mhT72dRv/9T/sxdrZigARVq5eDtQeQDZ239+5ERGZv
	sAH3qkCJMegryXu0fIXuVSx2ixEF6HsR9OnWqhdcNNHA4Tzb9QBN99PvkPkj4YI8AxGfkY8j4v9
	n2vRvtmJyLbOw2mHMczffZfu9mGKzMM9lfxw85RWF448eQQSz/HIS33GVv6qJssSHw9qvI4H9V7
	AwGkQfEluydFXvSQH7/vNt3UMPZs1Ae8B3PjmHSmqERxQownRKrzbS0YVUDngdBLNYVAD+Q==
X-Received: by 2002:aa7:d357:0:b0:6b5:9725:ff0f with SMTP id
 4fb4d7f45d1cf-6b7773e2f90mr673414a12.11.1794377772963; Tue, 10 Nov 2026
 22:16:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org> <20261109104142.c4e01c2e29ee9ead4056f354@linux-foundation.org>
In-Reply-To: <20261109104142.c4e01c2e29ee9ead4056f354@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Nov 2026 14:15:35 +0800
X-Gm-Features: AclHuK-fhrTrvILE4a2W2jzvXP48Kzwh2MpWzSARmUPbICPhrCm-RaiJ5eBx5hA
Message-ID: <CAMgjq7Dd6UQWfBwex4vTLdxAhHKMfpmgTG9DB3MG+4+qig0Eig@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
	Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x9hjrt8fbrrm5ip9bygca7t1ek15yqr6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE06B180004
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794377774-888018
X-HE-Meta: U2FsdGVkX1+43HeqShumqIG84i6EJMUSLMV/ubUW7oZoHwsLDrz/CpvSnB5KATEKJhs9F02NKCJC9uf8Y4YqkW15ztTcho0hDSVnPDK0QKg72Lw8ywzJln0+SVgkwjBJ82GbOh2Os2jI+sZBbh3QaTV+7E1Ul3oJlT0q/HO0+89+wRe3qw9XFVzvFpXlBBm2kdDqzTV4l6mOW60tiVNHfT5wEewJet/hkFXr/1XfUqwqsy9yaah7Upie8qVZ5K/ofU2gPkcY+YogWpop1S2zuPyuG4OPqhKYAdim25qdlIYGNdKrzET25iBXvi4O0LvWUPqy7R8hjTEjZBqHL2BcwwBQH2rWlCWL3ZjUcm4o6Mkmzxod+JQMexmZodVmOo9cCeuLh5AE0mUzSx6F0VaPfa72I4qQ6pRdh/2m/qo+zJHp3KtjX8Jyb+++gJZTPNFmktpEBSHI3gaIP7P41eSYrZsaZGFLlD48l/m9tjsbG8icT4D6Ed+2/Fg4zDPoL9rZj8bufrxaIDpqhqfX0EfLPpzl5ZJ+P9rGnCw6F6UtwdlO9TqaNMpmIVhKBm1xs+hwkIgR1J/Ge1YbXRa3+cAwReTd7Cw4+8Rjc/hK1zAIan1IoUC9emvUt21mP3Q68QJNYSVVDFCrjFDzb4wFTlqw+/+VWgCdSc/zYy+GZ3mMx96m7L0fwRuqiHDAHkW7cxU6XhOj3NDFS30h3/m8AKCZFoc3F5Ox5ocBll14fej7WCyhIVMrAvf4wRdlECYI+wr2IIv1Lg+euodyBonFsdMZOqBa04QOjubMqeigexkYPyaMR2eG4PSg8WPnY4peuaFNjrvDh/xxfiaEBwMRj2pP2f6tAIW3gw1OMb6CGLjTBMoXg5ZB3ltS6c4m28Zii+gnIQs0zVUO4JvqkZjm0pWLCTrVUh0O548nz3tbGvmgpb6ikzTx/DCn3vcdlk8W2Sfxv3BtjmkT0+80GQ81U3i
 PHUyUwRj
 aT3v+QvLB3XkLuPS0LkkHNTdEVcePpfnIDiiKlQwU03/oVohyxBXdvoVaXTln2PqK95DvTJ5o+wZ72dktbfSFIdQqS+GWN+Jn3ulX6sTRf4Kkb7PLCKxO4OZGmDkYoKc6FwkAY6tmf5HNXJmvTSqNPqSn7zs7YsufmMHK4Y/FapVeQfH4s8FuPdcwc6Y/HETzv4WN9B5uBRpcXY2VjeRBiX58yY6kA79LokbKWy3SeKIVHh4SFVSB0cr3n2uw+Yn3+hqwWgoX5voE+0cMnOTbnkAZmFO/6elDXbMsZjmAXnGVmw/lFNgP0Gs9zin9zJPGU+rF0+ZQ0a+20vD0cycwfcS0QVEYwuBeZyBmROkbM0ZtudWOj69BdeEy+rDgbprUXR3aHNgFOulHLYWt/kHiqxFioT/aTuTB/pkx8u9p9kKe0kcPoFEiql8NyvAP6VO37clvbrxjj/GPk0t/t2RrCTAGfFReHfivTIvRpseV9uhXgPWVqL4ZvAXpaNEtiBwRvT+w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 2:55=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 09 Nov 2026 19:31:53 +0100 "David Hildenbrand (Arm)" <david@kerne=
l.org> wrote:
>
> > MGLRU is currently the only MM component without a dedicated component
> > maintainer. Fortunately, Kairui and Barry have been actively
> > contributing to MGLRU and have volunteered to take on more responsibili=
ty
> > by officially taking care of it.
> >
> > Given that Kairui is already an established MM component maintainer in
> > a related MM component (SWAP), add him as an MGLRU maintainer right awa=
y.
> >
> > For Barry, the idea is to transition him towards a component maintainer
> > role over the coming months, starting by moving him to the top of the
> > reviewer list.
> >
>
> Yay, thanks guys.  It's been wonderful to see the rebirth of MGLRU over
> the past ~year.
>
> When do we get to remove the legacy LRU???

That's on my radar :), though it will take some time and it's always
hard to give an exact timeline...

Items I'm aware of to sort out besides the FG series, maybe we can try
to make MGLRU the default at some point during this process:
- Refault distance, otherwise we still have a major regression in
heavily overcommitted cases, also protects cross-memcg workingset
thrashing. I also have an idea to remove memcg id and node id field
from the shadow so it will have enough space to hold both the gen
number and distance, will post that in a few weeks hopefully.
- Memcg LRU vs. iterator (Ridong once tried to unify that, and it's
good to see there have been optimizations for memcg LRU itself
recently from Max).
  I also noticed recently that the Memcg's LRU reclaim balance is
somehow a bit broken, I'm not exactly sure why, nor a very major
problem, I will look into it later.
- Isolation protection (from Hui, not a very high priority, but still
on the list, we don't want premature OOM).
- IO cost & swappiness (Barry and I are still looking into this, with
an series posted).
- Page flags usage issue (FG cuts it down by 1, though it's still tight).

We also have aging optimizations and async aging planned. I'm not sure
if we are missing anything else, but we are getting close and with a
sane todo list.

> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -17635,10 +17635,10 @@ K:  (?i:vmemmap)
> >
> >  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> >  M:   Andrew Morton <akpm@linux-foundation.org>
> > -R:   Kairui Song <kasong@tencent.com>
> > +M:   Kairui Song <kasong@tencent.com>
> > +R:   Barry Song <baohua@kernel.org>
>
> Totally-Acked-by:me.

Thanks!

