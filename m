Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBA4ACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 07:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222D18E000C; Fri, 12 Sep 2025 03:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC538E0001; Fri, 12 Sep 2025 03:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B738E000C; Fri, 12 Sep 2025 03:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7F0B8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:21:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A75D41A06E6
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:21:17 +0000 (UTC)
X-FDA: 83879752194.19.99145A6
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC8D314000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 07:21:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L1lZQ/gX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757661675; a=rsa-sha256;
	cv=none;
	b=AnEutWJeZzkk/djWxqXt9Xsos58KuqSbUMfFB/RSYv66fzk7iQfm13Z1LlYYrpW/uKGQ/b
	01iVxgAi8FxSQnM4pJp9tG6+T2GSbgwAcvYOgAhrQESr24wf6PdPp5OnumcEq9absvMNba
	RpewEWNrNCOhB3WYsLuQRbP9hrCdJQI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L1lZQ/gX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757661675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ev88jTA6HEsYj4nljikru/jXK/dK5yGz72SO2ZtSDEk=;
	b=duXFjlmHMcMUFqvpcyGSX2bvhM6ThFTBujNqZvUexKikcPJFlokL6OoVy0ovDE9hxmRPJg
	dHZQlwRjuVJaTI+9gjFtydJAfR+0Aa+dRylbNXK06IY0rdQqGABf263H6p7xjVuGbNZQDg
	u9TpRjwaKDGsapa5keFZ3gxqQZYFtyk=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-72631c2c2fbso16953656d6.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757661675; x=1758266475; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ev88jTA6HEsYj4nljikru/jXK/dK5yGz72SO2ZtSDEk=;
        b=L1lZQ/gXMTJolRsXVccG8jt0T/TjYQnF/BddiVa+YFDtUsjo3rjqvrXgtmvjjk1ipj
         S5qsKyMWm53rhB0EZ+TP+W3RlZgoccpccQBbBBcmvo4nc9DeV8oZQMjJOolix8FBWOYa
         +QQR9sTf8SGeQ3El0biZp9qThX4CF4iPU9CpsPgeroBoycf6ZtGmwpldzZ7tUxTLTrec
         FPUfoVo+/Y2CwPQvMmlLVK+5/Shh+2m4NfXmZbFww8UceejhUjD67qzOKf37bIE/e9A+
         3RA+Rm/Md+5a23mNGoQpubdi3ze+ZLdy0xcFq8qwo/in1W29avUOesONjfBFPXPfzn86
         anJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757661675; x=1758266475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ev88jTA6HEsYj4nljikru/jXK/dK5yGz72SO2ZtSDEk=;
        b=ZLolppl3OfrqcOAzX/ezqQByeKF9rVhj1UlotJSROLQH41L9XFL9biXjatKswULAC5
         W/U+7HjMbPNHJSVn7zliH505OxAS15dZpJF2PLAHr7b6heFxrsenAYuwK0+gTk5mBgxl
         Qs4j88qp3OuH7vHhXRHJA78fw4DX88RbnfpPCgUhlZZI4vZ6SRGn4serhFadqrcHzLZI
         EGunBdhHhbitfpSdxGDPyY2SwaUfuUyZu8Ipvex52Qp4Dg0WJW5uaGNhJ7GJPAZ81u2Y
         H/o5othDMNDKKPHOIaB4Q6Vmj63Rk2BJ2Gdnt/m12PhVsiRD3OJ3c580KO+cxSYHrYrR
         YIjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX83kaova7+Sl/heVZxJPaopmrFThVEd3FJ+QHhq/DBK5uFHEMgPzf6sbczCasoA9EISjvkYoD0yQ==@kvack.org
X-Gm-Message-State: AOJu0YxlrHNGVK5ED3/cWF//QaA5BgC2a9RMSFJd+mEQcdICZsDjZOo5
	8uL+xaLqyxVHtUj6/Eb757xpShAYXoNByNINTThSEskznPbP7aeeEO4wcLVWMlqNMBfKoyT0VBB
	08y4nj2KaqaTIXfSWl/EZMRPPmU7mKUY=
X-Gm-Gg: ASbGncvrGqY/ybB3d7bK0XEWyeTCyDJ9kCX5DKp1nt8Ov+nXL+EQS5c0SRHzMOxf7jI
	NjPzhU8SqA14no7sulx6J3KopScbFq4+qDdY2WDurXKf6fTDvAaFuFTfG+6DglpYYtkn/IVWvmO
	nSQurGHxZpwD8uD+h8XBJ6T0u088M837Dqvd6yRWmOY71yQuJpqiZs/AGpRPwK1KN3/UOJfdFNs
	03NzlC+07jDyhXwBav0qDP30lih+PJuGXdq8x5k
X-Google-Smtp-Source: AGHT+IFmxWKlg9lTecPzrdzZLK0pJmBN7ltgoRVqWwQIeIm/S78B3/KreguC5TVAusVGlC2xM1N4WcQu5sVexX82BM8=
X-Received: by 2002:a05:6214:262d:b0:753:c7a0:8dbd with SMTP id
 6a1803df08f44-767c50647c1mr23734096d6.65.1757661674807; Fri, 12 Sep 2025
 00:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-4-laoar.shao@gmail.com>
 <0aad915f-80b1-4c2f-adcd-4b4afe5b17dc@lucifer.local>
In-Reply-To: <0aad915f-80b1-4c2f-adcd-4b4afe5b17dc@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 15:20:38 +0800
X-Gm-Features: AS18NWAEu23WLC4-YzUUQ5p8sE8322qhir0Y_VCH3XGQPacrY3qmhSJ5JIg6_ao
Message-ID: <CALOAHbC1QDeqoS5Onkccsf+rMWEUbb1OEdeuLOaC9sLWhk-Amg@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 03/10] mm: thp: decouple THP allocation between
 swap and page fault paths
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC8D314000D
X-Stat-Signature: phsuc9u8si9p6qkqyf74gdbdeubd5had
X-Rspam-User: 
X-HE-Tag: 1757661675-25881
X-HE-Meta: U2FsdGVkX1/xkv1RCxcwhuWJMWhxZ+RKqXqu7H/+S8p4CH/eE2U0WAd/P0t2f4aOJsYPk0TjCNNIRdvMHRjPwJhSqaSKmTyB5qFaW9saMxjOTbZ4l5e8d82h1A/UBPq53IdWlukJN4G3mXNxW/p1bjKWCA+Di4KQE1NRz/oaFdukKLR73KuLAnh5Bbo22youoMvRzZY49W4c6AqaH/dSn8263wlUpE5yqvaiuPwEt74xYsB3fZbw6NkzQNyGK5onk8cnIL8T+TrqfhWgV+RyLDM1Ik+0JfAozWrysk6H/XreG9p9lvDB7FiIYFXX91vqKlnMYeOFna+VcFMrdY62YJIiw8bOpcIdCEoQPoI4ObdYIwcemyw0LPrhUnj4gH+1sopAbHFPDQbufzeuJ4ScCzxqiWzyFU9yqK25+kTyRUB4mh46Hthlz92O+L/0V3l+w3ktJ9WxmfmCdeG+eJ3jEFnacpnmpUv22cWnMy56h6JEbrH51ltzonmbnG0oGd409uExzHHxXFACMwzKrK8qT+XoK1oSW9qpfUTEUHMCYMtpoIf2ay9cQGZOWYZ/uwyVG06veEjXJrdmUM7VY4lmT4Kj5Ihf5f8BshxocDd1JHGsdM+x2pBhVFDzI9mo7HlkTXEr5nz7WPllrsnQYf6VV15h9ew8qV3pHqC1TOPNsxWN+11lkrO8xe59NfOFyL6m3DC1/3jyJ4kgU89lLJuBD7Go/7BOfu5LOE4e3NDpJTZjXr7e+UuA6k+fHXba73JAype8ZKlrayKS6EC6eRUJSuKZCKeJBYIB9kPlYqQahNA35vqZK2l0oadKeTQbn09UwbA1u3AbIja29N+gg5w7YiHgryuTuPo0YLarT/N63dN49VwW9TRgL/FB+6+ptu5y7Xmq0Mwdpii3p8Pi3PWjZB64DeB1HQ9Eu5luUzSuf1mcbjzyUVlpa+Xu5hRgwmmeJmuP+USom5dEmLiiFaW
 UqfAcExu
 Lulli/lXorH8OIAl+ZLnUQaQ9Ncg4gRqny9KyC+XYgOKynjn+TXldo6bZS/HGNSQG25GR+jWvRIiqso35I+xgu1Y23kvL31wHEeY+bSzdf8rVru0ERDpc1bhwOiizlNSnavDyEs+Le7GC4RUN0bYnl45nFVOj+PPSCS2wcmdvceKtv6MTonopb3XFSJVGDAdTeZhblQGT1VkYj0zF/GnbvluPf8JPaZ6EeZJLR5oov3AoO4LUAe1Ir31c3RLtBKl46QCWgSNz/Vvyv1zC0GMWdTSm7gZ9ueTG+JDI0zYRCn3nA+WhP0ZJDYnEIx5BSAwa2lUX4OBGNikVxu7POdr4Hm3ljVj+JnSfT511Rh0lnsEh/lUO915Cbrh9FfDg5+ubSrE6EZ4bLcF/y3jY5zSrTwNHW9RMPwFh0VENxKEBI5GYCZPFV0zjVZjkrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:56=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:44:40AM +0800, Yafang Shao wrote:
> > The new BPF capability enables finer-grained THP policy decisions by
> > introducing separate handling for swap faults versus normal page faults=
.
> >
> > As highlighted by Barry:
> >
> >   We=E2=80=99ve observed that swapping in large folios can lead to more
> >   swap thrashing for some workloads- e.g. kernel build. Consequently,
> >   some workloads might prefer swapping in smaller folios than those
> >   allocated by alloc_anon_folio().
> >
> > While prtcl() could potentially be extended to leverage this new policy=
,
> > doing so would require modifications to the uAPI.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>
> Other than nits, these seems fine, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> > Cc: Barry Song <21cnbao@gmail.com>
> > ---
> >  include/linux/huge_mm.h | 3 ++-
> >  mm/huge_memory.c        | 2 +-
> >  mm/memory.c             | 2 +-
> >  3 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index f72a5fd04e4f..b9742453806f 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -97,9 +97,10 @@ extern struct kobj_attribute thpsize_shmem_enabled_a=
ttr;
> >
> >  enum tva_type {
> >       TVA_SMAPS,              /* Exposing "THPeligible:" in smaps. */
> > -     TVA_PAGEFAULT,          /* Serving a page fault. */
> > +     TVA_PAGEFAULT,          /* Serving a non-swap page fault. */
> >       TVA_KHUGEPAGED,         /* Khugepaged collapse. */
> >       TVA_FORCED_COLLAPSE,    /* Forced collapse (e.g. MADV_COLLAPSE). =
*/
> > +     TVA_SWAP,               /* Serving a swap */
>
> Serving a swap what? :) I think TVA_SWAP_PAGEFAULT would be better here r=
ight?
> And 'serving a swap page fault'.

will change it. Thanks for your suggestion.

--=20
Regards
Yafang

