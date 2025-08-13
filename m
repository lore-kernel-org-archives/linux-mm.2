Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AE8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC107900094; Wed, 13 Aug 2025 10:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98AB900088; Wed, 13 Aug 2025 10:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5B2900094; Wed, 13 Aug 2025 10:15:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE332900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:15:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B95EB92E2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:15:15 +0000 (UTC)
X-FDA: 83771931390.13.99C0D14
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9CE131C000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:15:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AzFyJuyU;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755094513; a=rsa-sha256;
	cv=none;
	b=jglV10fTinlYGqEJMHvVqav+mWG7XDtbETco0fV+S9Zemhs+Tq4UsXjn2S36YinIla9L4A
	CqNZsLf2tpTalU1u7iAk969Xf1y9/+REKU4PMs5Ya0kpQy4GHGiqjprCMf9N8/4GLfg8Ij
	hd6m4NYwpoI9lupKLPgUN+9FAhLww8k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AzFyJuyU;
	spf=pass (imf18.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755094513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCdyA5C6sl+D7SKSeD+kNt6VztluFSoqXBmRZjXidnc=;
	b=jFBy6wqbHz21K7G3KymTOl8SKiIvESS7M1IjoUuF/L5R84rNE+v3kQSeCujoSWwmDqLRZm
	OcE3X+XQZYVrA1IEXvyAEzALrnC7jFfYV7/GFDWa8i83AK0HheNiALlPJWTItqRaDlT/YC
	/XrglHefj5s9ebIAQ0zfqULZunLr384=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso8967a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755094512; x=1755699312; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCdyA5C6sl+D7SKSeD+kNt6VztluFSoqXBmRZjXidnc=;
        b=AzFyJuyUcXJumNDvsib0lqarwQv84P4nVLJQV93wE4mGhJO1x8kknFAJVIX72a9xQY
         Ufrhf86cixIQtC7EkuMTvw8w3M0rQ+e35gBH0k8PQ+nu6wrxdP+Kq1fNeQwAhndhps/p
         yLyfnsnR2f+O+qdPjgfjYy7x6kSHcEVSsrbflEdKvIx3aIgYiYqWOqp6vMhG3WuSPHDP
         eLYPP0DTEce+n8Ab8xOQTaWT8pjT9hzao28WZje5EtKy7KEpkGKVwvp7zImZW991XfS/
         oKFZohsoQe4EmPBpl4IFhDcI+01tUS8BOGgjkJXiuo3SpXq9/nDYSRRTd3EXafXpcz+w
         dHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755094512; x=1755699312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCdyA5C6sl+D7SKSeD+kNt6VztluFSoqXBmRZjXidnc=;
        b=SgjE8KSqB3TybbGOcyVPghnIWboEsQTjVGHINlukCtuzg5O0QpKOVouaHx73Z+/vd3
         EuIReuUk3uHmwYKuLPnVOqbGv0ZiFXxVveQvVNHnXiOQ0hGALBxuQFPJ9pd2qDXzhYk0
         IIlkCI/og8EQYLWQdPa4K6ceBJ6RECtq9MxzFivjyTLUdD0k0GogaAWACvRxXWgO7IWX
         fkpRWgQSepkrj2nsbJp2QWImqmadw7LMUCk8TwJbWFTNxKOmwC5vIvD17fHmY3vscCUn
         yt+erBle1ca+Dz1HixzZLYivX+jnSpkAktLwPELHRJqkp0cgouQhiHWrnQfxlpHXzRSV
         5eeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn42qAcs8qeYnG5V3KUlXWDrSqiPCmEujDriqHAKZNoVKjZqkhKHxbeAvWrO5oH5pWnL3cOZIXpA==@kvack.org
X-Gm-Message-State: AOJu0Yxtrn/neKxalSfqa7cc4zXI5eqfXMWowDODDmBIxvFKfiG4BhFu
	S9AGiWfbfObUG9FRiiOug8oL0awinPsai28g1KiBw1LtPLhw8Kxk/Dbd/s7zNUimi4XHorwCm7j
	p9Vt4XpkQr5P8XiS817ukMVqv1BqI/ikALCWcMylE
X-Gm-Gg: ASbGncuHc/A9a2yW/0A/9Zzwh+hoh+TylfjldBkBKNUY8geF1lnXY5/CGH176URpPkB
	OjHStkazydZhQv6T1bR3lJ1CgjO85HumziDZsFFg24dFbojX3542VZ5RMWtMKLTeRNYI7OoVH5o
	hZmD3ZReDyUnaxQCdNvQhm7QH2FSfDP1eLg6YoryEXyq3oMNMp/Aa1jopNeIuuIDK95hJI7U9n2
	U/2VXKJ7n81fbHWpmaBWXhU6NpCP4Kf+nH52X2pAcDSM3PIeBM=
X-Google-Smtp-Source: AGHT+IGrHXsjBerb6H4iA2/G9f9W9aXY6fFEQY+IlMLrfnIuvzCCyHxV/OD1sC5gfrO8L1dGijqw2XDpP7IbxWdLy7g=
X-Received: by 2002:a05:6402:1f4f:b0:617:b4c9:4f90 with SMTP id
 4fb4d7f45d1cf-6186d54e613mr95378a12.5.1755094511897; Wed, 13 Aug 2025
 07:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
 <CA+EESO4JFCR5P9PFoY2zo+X1Y-qv+-yy8X887isoqXwfQBtn1Q@mail.gmail.com> <CAGsJ_4zK5iLtYaT2o6ctnZNUgRoxrxkDJ4gnGrTOD7CW5vuRHw@mail.gmail.com>
In-Reply-To: <CAGsJ_4zK5iLtYaT2o6ctnZNUgRoxrxkDJ4gnGrTOD7CW5vuRHw@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Wed, 13 Aug 2025 07:15:00 -0700
X-Gm-Features: Ac12FXwcVcIIOY2FQk5ryN01K33bglvd-HUWD6CVhaDAZn5gaMfb8TIOumWEKEI
Message-ID: <CA+EESO5ny0L8qiB6_b8t9guCVj6+ygjKf5+x6bR2aXjEcJE5Rg@mail.gmail.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CE131C000E
X-Stat-Signature: g5jp13bcm9ibh46g5y7fqeuy9f4b3cdn
X-Rspam-User: 
X-HE-Tag: 1755094513-750231
X-HE-Meta: U2FsdGVkX19hj0r+ewNCrdG3YVMvs39BAuO8K2DZWD4BWNOH/+bNlKFZUj7EERiPCnEEKKkOq9U/oJjW1+AlqYWJPMPcu+a3REtnTL/SMzmZfiCPfz/Vkpiv/M9ABAia9XiXjhTKrmfelO2E2haRrq8F6pyUeHYANZIVCfKWN7NslJqQQYYx28mJu9x1502cNaW+AhBon0AQta1tXEqnxhh2/tyycJMcCv+6/XW8rwlbt8oGtKAb/aiWMj8zcHR9QhAryAFwZzOxfcuglnxtoEoAaNL9YXoZpgHLxlRupdEdhMmZ4dw1ugKUGiXjsmXNolTe0oyU0JriptSygbbIaGk5jIrpW+LbduQ9v0T5Os4sf0+FFEPJdQv2m5pVo0In55x9yAPOYC4QpjgZ03Q0ne65gZfIS99Mto4U02VND6WThw8IUcJIH4PxwKsKP9N2+D3nSJ94TDT0mY631CipecWGYGX0vQ5u//KLBIM7zUxXDd6HLk50e0XdPmW646LXe8u3IMuo81y17HRA7jl7PcU3Ygr6JIvuyoz6poij15mKa5rd161G3tz0pHEsY08ML4+bEd881PyPK58TyM22ApHYkA6+bkw5UF17pg2s7wqEHAoc4jNdGTil4V1+OYiL1OjSq7LNhkmBVck9eNTxPPVIX9G0ziICezEOJ3PQe8U7xFlpJlkzQy7DGxuM4I3VtSl0P22k6m1Ski1oETqH6OqgsmkxAurcSfTy/Aab6LkH6xuE3KkqhMDcwFuor8X3CjYWyhdOMck0JPfTdcygcq456TQi8CBbrB2m9FjQOqwdqOWeSGg7RRUzU67SmZaba6dHrkzwnoNOt6POpSXZjvMfc4do2Mcct0EsI8Nr11ktfrQ/t6mF5GgEQ3EJoCLhTQSV3EDBzS9y/ggnB1FygYP5SGEZ6CmqWw4WJTOIFr304wXQYSgXwyCnmj8If2yE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 2:29=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Aug 12, 2025 at 11:50=E2=80=AFPM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
>
> > > [...]
> > >
> > > >         /*
> > > > @@ -1257,7 +1327,7 @@ static int move_pages_pte(struct mm_struct *m=
m, pmd_t *dst_pmd, pmd_t *src_pmd,
> > > >                 if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
> > > >                         err =3D -ENOENT;
> > > >                 else /* nothing to do to move a hole */
> > > > -                       err =3D 0;
> > > > +                       err =3D PAGE_SIZE;
> > >
> > > To be honest, I find `err =3D PAGE_SIZE` quite odd :-) Could we refin=
e the
> > > code to make it more readable?
> > >
> > Agreed! I'll replace 'err' with 'ret' as the function no longer only
> > returns error but also bytes-moved if there is no error.
> >
>
> Looks good. Should we also include the following?
>
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1246,6 +1246,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
>  /*
>   * The mmap_lock for reading is held by the caller. Just move the page(s=
)
>   * from src_pmd to dst_pmd if possible, and return number of bytes moved=
.
> + * On failure, an error code is returned instead
>   */
>  static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd,
> pmd_t *src_pmd,
>                             struct vm_area_struct *dst_vma,
>
>
Of course. I'll add this.
> > > [...]
> > >
> > > > @@ -1857,10 +1930,13 @@ ssize_t move_pages(struct userfaultfd_ctx *=
ctx, unsigned long dst_start,
> > > >                                 break;
> > > >                         }
> > > >
> > > > -                       err =3D move_pages_pte(mm, dst_pmd, src_pmd=
,
> > > > -                                            dst_vma, src_vma,
> > > > -                                            dst_addr, src_addr, mo=
de);
> > > > -                       step_size =3D PAGE_SIZE;
> > > > +                       ret =3D move_pages_ptes(mm, dst_pmd, src_pm=
d,
> > > > +                                             dst_vma, src_vma, dst=
_addr,
> > > > +                                             src_addr, src_end - s=
rc_addr, mode);
> > > > +                       if (ret < 0)
> > > > +                               err =3D ret;
> > > > +                       else
> > > > +                               step_size =3D ret;
> > >
> > > also looks a bit strange :-)
> >
> > Any suggestions on how to improve this? 'step_size' is expected to be
> > different in each iteration of the loop even without this patch.
>
> Usually, we have:
>
> if (ret < 0) {
>     goto or break things;
> }
> step_size =3D ret;
>
> Given the context, it does seem quite tricky to handle. I=E2=80=99m not s=
ure,
> so maybe your code is fine. :-)

Yeah, the special handling for -EAGAIN warrants the current
implementation. I'll keep it as is then.

Thanks
>
> > >
> > > >                 }
> > > >
> > > >                 cond_resched();
> > > >
> > > > base-commit: 561c80369df0733ba0574882a1635287b20f9de2
> > > > --
> > > > 2.50.1.703.g449372360f-goog
>
> Thanks
> Barry

