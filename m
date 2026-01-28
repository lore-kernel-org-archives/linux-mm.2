Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B49D46BEB
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 18:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15646B0089; Wed, 28 Jan 2026 13:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2C96B008A; Wed, 28 Jan 2026 13:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5476B008C; Wed, 28 Jan 2026 13:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E80F6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:52:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD3635AEFB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:52:52 +0000 (UTC)
X-FDA: 84382269384.21.CF66246
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6DE2140009
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 18:52:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g9KszV/y";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769626370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHU3SBN4kSajXpdSc5kb9FPIvGlVuAgxov/ZwG2Suug=;
	b=zyGk5hHLaVVHI6qbP0Dq/cgylx2G94QOMHnR5O3E7wAS6UrYoMZAs82/O37AtBLWBeZHdb
	jNQNF8Kcb2KusjGXz3ZtWLR2B66sHNZpY9A8VIFb3cuJ3i8Zf5IVSwO8kmlal9thqbQKCx
	J40ZARLt5sO12o4NMv3TPCB6/LeErM4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="g9KszV/y";
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769626370; a=rsa-sha256;
	cv=pass;
	b=yKNmSJp87dr+S4pAL5SQexm7jYGiRG2F2NAAAmzkel3sXbRa8aYBwrFWqy6TyeZixVJyAb
	0IKPsZWSwpcrTuCJbAwr1kt+nBQO4kBhr+uhBb46deg6lLl3BX/AhPzl87yMtNyagHzhV4
	6bizfha25gjLfSkPbu1wvuISjDRUX6c=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5033b0b6eabso44831cf.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:52:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769626370; cv=none;
        d=google.com; s=arc-20240605;
        b=cwpUCjjoG+Sefsb+3kLQvT5NJd/lxZt1ehgc7icW89yz+V7JM5ya0vQ0+4O0kjROki
         fBkgy+jGzEIHjpjboNaTzg4WHKF1IDYehbiM9Aq6aJlrsCCD417jCtHXkLCVRL5uL9Ri
         bNeprooyK+t2IKlv/3LRgKbPLOtagR+kMBpqieNhRQjnMVkLqK72o0z8HBPDKlyHFCqe
         z5qd4frBJs+NcWBFo71gToj9LdKg/QtRnvMmlAVhISbfHRvo3bofekfo+R7YMo5WI6sL
         XEUvp5u7ixE8FLNySxUvyUgu72xNMIxZuOFVP4nUtyd2dJ17/4xFl3mlahrRugumgn6S
         /nhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WHU3SBN4kSajXpdSc5kb9FPIvGlVuAgxov/ZwG2Suug=;
        fh=yN2042eqF+vjcfgxSdBEw8WWgLHV3JwKsu71MJI56qQ=;
        b=Wl7VYG11YLOo5BsJbAJH8L//PoK9v684zHQPA546Q/JrQpIjkLd4OTjug9es+aD2KQ
         nySFR8nAo4Pg8fQhHjHjg2SYv87ibJHiT+Dw2PLdBNeUpb4egqj6QRAZYCLDbW1UkhID
         xfgnVp4Vgb88W6/lLuRjhWVhixvLizWzmMQlYFzbgE1ybHkcFK+kCU2uYcXhDEGRI6zE
         Wa54AzVlTQEwCvc8lho2cAztgVWU0yY45KFnIkG21SlACqCGARbm7yg9sQy4licvUBcK
         uTBH9b0K8cYeaN61q8TVULV3pMcffJBBfIQF8MG+ZJEs1YvLOLGZRuUJlKV7jF5N9+sv
         it6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769626370; x=1770231170; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHU3SBN4kSajXpdSc5kb9FPIvGlVuAgxov/ZwG2Suug=;
        b=g9KszV/yD1fdVtaZa4cX15BOUySqElmvC9UVHjh0ZdqXPLDjMC8wt4QsEBpKB9lEJX
         RDkrjeBzeY3jqp9lcTy6B1xDa2e9CH752y2WhzLuftvX3HgcRWoId/FPRlT9iWPRZqjy
         ezbB+2wjIDFZFosjY+1fDZXJN77809D3agYhZAE+qcOBorNnc53FTSuqVg/lj+gTORT5
         +FZxvctpgb+kKiJSIpkgztJcF4lZflpIYUGTr95nUpsKabgQLgT6srLX13hwUGUBOJ5Y
         I92tw/N3DIUJI3ck97XNWAsYUvTh40G39Ku8/+5WvG5FaKQHc9kazzOWYVO4NLkG6Gzy
         cV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769626370; x=1770231170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WHU3SBN4kSajXpdSc5kb9FPIvGlVuAgxov/ZwG2Suug=;
        b=q+Byie7Hq1vaKJe3Rud5RX7/PlPaik4pdWOAo8rOasKVA+2mmxlSmhrpxVhQ79sn8b
         BPZuwq4kf79yaQViNB0H1jsFSAdQ6MmyVOSIljkUszZHyn3gkEsb3TFCzLkOwRhNkP4E
         rpE7+FMUwSThXs826kJySwm6oO0RBVIz5WIzLrsik/sbnY2J8XfWeezCsCVmOon6jmD0
         YLOUBonsgJtp5OHyscu9rhVHNA5JgvIVTQiHTrKJBhcO4ywbHYgwdlh1s9/jBpQJI82/
         X37AjWVZ2lb2sIOdxVzpewWaQCJPoB86bmzBqJAWDu/PiAfhS9+Ydsnck0wguF+VQlzL
         0HQg==
X-Forwarded-Encrypted: i=1; AJvYcCUjQN+OgyCWGRSHdE12Yame+kGGK/VadEff0k442XYkzWHa7g2XlkOqtNSRGZSEB84tEToBBcqfiw==@kvack.org
X-Gm-Message-State: AOJu0YxkKSXHg8G1WLLRw4oM2nG8X+IQaXVx5O8EaPn2mQNM4l1JddV4
	rp0P+EW2aNmLNgwi46Da67Yo10L2Gyg9MY82Rr8357mcDijGsi4vJNlimsEs7qfzLvekYuYUFj8
	j9521miYghj7mSjnlh2IXRzGzj58Gcr1tOgbrKpKr
X-Gm-Gg: AZuq6aLc9sRCIXPatGKaLXZ8d8IIV3m32SwhMWZr3/BHmqdFh1wVft3gK9fOQ933oC/
	IywuWJY1wi1XeA8YXGATu+NJQf1vnc3F4hPE65MHUu1d7ra8W0MzZ0BMTFg7MLIV8WqTyjAsCG2
	1BXSoqfT4N0OLQPoQXGmQXXLXCpcCreGCNK1UXHquahfwT5tqzW+dOogaeDpA5FdB/GVlHotEnZ
	rgmXbPwJBu+jZyLAc6fzr9lbob45YUhMMKMWVLpSKit+ja8TmkT3Bj/sw/LQJN+LXUQquDkRS++
	dz/vXL/xCBq6zrXgIlfWK/rMnQ==
X-Received: by 2002:ac8:5ac2:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-503b68c5619mr437881cf.13.1769626369423; Wed, 28 Jan 2026
 10:52:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
 <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz> <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
 <CAJuCfpEBHsuGJFAGyXdASpaV_FY0_RBShKZM3QA_9z7ZvAtu6g@mail.gmail.com>
 <425e3040-0522-4af1-a7b9-c9ad04e017e8@lucifer.local> <bae98030-f359-49e7-b294-14aec5a5425e@suse.cz>
In-Reply-To: <bae98030-f359-49e7-b294-14aec5a5425e@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 28 Jan 2026 10:52:37 -0800
X-Gm-Features: AZwV_QgZBjbER74dI9m_uPvunquAKGJLY8LFOmekpfhxdXBjBkDVXkOvnrwg-7c
Message-ID: <CAJuCfpG4JLu88YKZuRzprMgL3ZvCS+wLaeGbG_O4pKboBXxaVg@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document __is_vma_write_locked()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: usjkcx4838d7f5x1zxaak3qpi3kkbne3
X-Rspam-User: 
X-Rspamd-Queue-Id: E6DE2140009
X-HE-Tag: 1769626370-701365
X-HE-Meta: U2FsdGVkX18//DraLWMTLWglRHD/t+uKH81ChOaRx8UcEQybHW06Q6+QdYf+CVYgQdXI/FfkTrCT6YvKTXf9yDhfNKSL+TjxffZgQcliwzd92rxM3GmdPydq9crkeC9vxRqAuuQ1ns9jKvtO5lzxC7yrN572ps7zXvvkbpg/d+JADoZ9vCxV1HHnU4spAADlw28Pa92FGvKJW03q6rqbZv2grp4MPWm59/61TEJbLGhN4QNufZkfjA9PXOelgwfJ2daS/ymD5Vy7esd0Eqct7zVYhGS39FtHI/3W1GXDrAXtcv/t0/suD9v4LE0+oLLNs7pVpmUISD/CXXRJEuBTk75y3A+FgYPU5qPfzoBBAYARz7OhR36sRtbBSpDeNiFM1V2OYTfi/zyjvtcsCbxIyo+cbEgjYfTc4+kJWAbs9bBMWiNJJRD2nWJQ1B6qQ3qwNw2ZiWsFmtN3k9WvECTw7zOFZUn+AKQr+FoGlViqwU+jY/rcKrb0d1HvFAsKIFwZXe/h5Ngi+34ocUbnFylISSpzeoZmE6kaop9BY9Y6y+nyvgOviiG2vXff43uVVq02Nl//isNzmWm95kuGQ0T9p2+P5/BjLI3ESFz52kCGt8FpkSscRk+rmedV4hnEWeHGszcXv06bTmFvxBcehaSmPhw/26qrAyR+jnI4f0T97h7msmEDs2zc477YhWExI4Sip7hF8kBWkPtWxktky6i6mkUf13pbpgnD1Ip5djnFGXltJytsN0Z3saC7V26pjqG5eRDHB7MnMYsVzI747AYeV7d+/oznVsOMwxLryVnNO4PukrCAZrMQilV4ggd4gbemTMMgNGTK/2maMZ1lqiTa/oFkMKpdh98jZ+BIxNxccAfDeffbiCYDlWrA8pEkY/zsouhrxb3nwN5er50D4dp21nmDFocyHrfw+cILnhMtoXK1FMxaBub4zg1ru+YCF9gk0iwttcmVUAtUx+GBQt/
 RwGS8Ek3
 E6x6LBG6IMCeGBKK3hu6hcIV8WE0/DP2Ih8t5RoiHDOnSJfFsFnC9YoPuPdG64H/C8erHReJrU/4Exl2/SC/NakqZ6HzBfwHf6P5KkATI45RQ0P6PYZ1/hjy+C5PRlj4OGkaNtZutZViMO64ZvJhGaj39lhaYHT/7TVAM1BFn0wabRaYanRbBPqnPVTYuVpC27VS2X99xB8vq/KG4rQn2YWy+ndsJxYpFxGWshXofwz2rsOuU9Xh0hrdZl2BccAVvDbw0z69jNyVMGKaZpUsfW4D1WvA5h071SKInaN1f1CnF/IMZbWUvmUoPjwu1xNBUIGzhOvYTAdlENCDLAxM1jLKuQWdGWCpU2WPC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 5:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/28/26 12:51, Lorenzo Stoakes wrote:
> >>
> >> >
> >> > Thanks!
> >> >
> >> > >
> >> > > Few nits:
> >> > >
> >> > > > ---
> >> > > >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++----------=
-------
> >> > > >  1 file changed, 25 insertions(+), 19 deletions(-)
> >> > > >
> >> > > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock=
.h
> >> > > > index 678f90080fa6..23bde4bd5a85 100644
> >> > > > --- a/include/linux/mmap_lock.h
> >> > > > +++ b/include/linux/mmap_lock.h
> >> > > > @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_=
area_struct *vma)
> >> > > >     vma_refcount_put(vma);
> >> > > >  }
> >> > > >
> >> > > > -/* WARNING! Can only be used if mmap_lock is expected to be wri=
te-locked */
> >> > > > -static inline bool __is_vma_write_locked(struct vm_area_struct =
*vma, unsigned int *mm_lock_seq)
> >> > > > +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_s=
truct *vma)
> >>
> >> This function returns the mm->mm_lock_seq.sequence attribute of mm, so
> >> no real commection to VMA. IMO it's better to rename it into
> >> __raw_mm_lock_seqnum(const struct mm_struct *mm) and have the callers
> >> pass vma->vm_mm.
> >
> > Sorry missed these comments.
> >
> > We are only ever referencing in terms of VMA's, so I think it makes sen=
se still
> > to pass a VMA ptr, even if it just references vma->vm_mm.
>
> FWIW I agree.
>
> > I think the name of the function also makes things pretty clear, given =
it's
> > called essentially 'VMA['s] raw mm seqnum'.
> >
> >>
> >> > > >  {
> >> > > > +   const struct mm_struct *mm =3D vma->vm_mm;
> >> > > > +
> >> > > > +   /* We must hold an exclusive write lock for this access to b=
e valid. */
> >> > > >     mmap_assert_write_locked(vma->vm_mm);
> >>
> >> If for some reason you need to keep this function VMA-centric, then in
> >> the above line please s/vma->vm_mm/mm
> >
> > Ah yeah, maybe if there's a respin? As kinda trivial thing, if that mak=
es sense
> > to you!

Ack.

> >
> > Cheers, Lorenzo
>

