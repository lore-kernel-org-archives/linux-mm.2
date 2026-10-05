Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF71ACA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 11:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1016B0088; Mon,  5 Oct 2026 07:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A566B008C; Mon,  5 Oct 2026 07:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9120F6B0092; Mon,  5 Oct 2026 07:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 592236B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 07:22:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB638C021E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:22:56 +0000 (UTC)
X-FDA: 85288335552.08.AACD7C2
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB3D8120009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 11:22:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WomTtJZg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of neganhat@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=neganhat@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791199374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxZI1soPxTmfDPPU+JgwdQfVtmxFB63dai3uLQf2Sjw=;
	b=BwdN+1NmBZe8Dpo7r4dL1+vWwYsk1cF52pQRjRcsZ4YsvUGX1NcatNH30px0DrHqdE+S00
	N3vYHPR4xJXHcCToI5Tm7+A32K9l0xCuOMd8p1YSOwfoNQejrubgWOWj/dcoNWpZFpJbR0
	Yw80FSEA9WZeCg09so34JIpjCPHiVSE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WomTtJZg;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of neganhat@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=neganhat@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791199374;
	b=MSOk17NPr8zEe1AcGuLRr7rWvp2nhQ9JBFLjm7RUEi1W7iRZgjwur9AlpuxrbpkD/Ob1Bc
	TivG8bRyxdaNLY+cPaxrDGNyce0iD0s+8NQ8qGFcCkylJrFXFPzz/kvCecEC6KUqsdJj2T
	PNVFy8Zx6a0ePkBcpDBE02HuVfFQdIE=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b05fdb2f9so1324286f8f.0
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 04:22:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791199373; cv=none;
        d=google.com; s=arc-20260327;
        b=Xm4bsoJ7m6GFkuDDAN0rZRR56D1aHhYp2TdG/BYAJ/jKDXZl7Ao0Zcx9Fx7oG8fv7b
         n3C845M8uCyWiVZRHvIpCvFZ4LBUkQ7yuxPJyUBDnklnObPA/ASam49tpWI2HhfPZCpZ
         +tNrlBt0KXVwjPgRtW7CIBhdRfFjCysbM06tpCipGPflEttEBd+CT4hk7p26zEvqU8lR
         e3aTr0P06kUNdJwo/+bxrB+/PrcM82ZLRZeoVUyzCWIksUqUjAO3Fp47Yu4hl2pzEUvM
         GqB9LNgJk+uncBD4Pe/G7n5ALSapuxXLGviEtgNRrE/f9q5NRF5Uc3n2W0z/VOMacGXr
         fwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yxZI1soPxTmfDPPU+JgwdQfVtmxFB63dai3uLQf2Sjw=;
        fh=BZCqozHIP6QvLUIkip3ZAjdTOrRgd9KaF9CGAvPhSG8=;
        b=CRQUcF4zehUUSaz+pBOA2uXqrTBmT+/KLZYCV6WNS9SS7nmTe4+45zDOcBLld/BFgv
         Bvm5PcvBZRfh4W+5jk4+Bz6maOKg5ZG5EBnGNRDWMQlxUQtVlhPXpQKRf7AZzUDdN3bX
         c5qvBoOqiunYi4GfsYoSaexD5ifHcAzKssgyZVTW6DY7vRBgh9DkxS1N8hiyUWMRrRXM
         YWHAsPmsmymQeBYulxCqt12othsslIx8lnwwiQt3U3s1TMFARLn+1B8rUN1fH13ztV9C
         ALF2n552VSwycUtz/DfPjIJiH6IADH6kY5HED+WHl+tE13aX0lRlzdFNX7KdGuMXVGFl
         8erw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791199373; x=1791804173; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yxZI1soPxTmfDPPU+JgwdQfVtmxFB63dai3uLQf2Sjw=;
        b=WomTtJZgcPWN/EvpOI5vp1jzOJ3PyaJ8FtKC6unUl1yoMoNvaWqGLoJydoHkVFcjOn
         1sLqdGSxvCLd8P0WP8Z9B1iEtjrCHR2mmWrJgtoZ1iJIxAZ2eEEwCpKK3Zsr0gONfC66
         FBQIvUiq+UuYO4F3TwF+LzRfdJqKiWPVzMlyq1WR9tHVjSp+7ziWtt1XcQVTYyjUDjh4
         f3WAUncFIdvIHcwgJLR7GcKsx/BFZIUvxlkthOzmHDrpUX/d/NWUBn3t064e1JHIy6bs
         ht8oFFwl96hoRTbkWa1jZ1IF4wjNaPUBFVZZRYsiLmr/uaNK/IaUUiFciUKFG3YiJtKM
         uz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791199373; x=1791804173;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yxZI1soPxTmfDPPU+JgwdQfVtmxFB63dai3uLQf2Sjw=;
        b=EhBesk1Xm9i7nCKRQ0gAo7JR9lI8T259aXAENCrmZ6JqajeW1tgt6rYuy52qfvf1jI
         px22T7Yfx+nBzgWZAqAgpgjzSVdU7IwQ98Ng8aFKboYFqCOjK5jPNbA815ZPxOGGPE5a
         BmDaAUwbVTBWTPyGtTXF+Ho03IIpksjiOu/ba9MbWRBVx8ZfsPTZSs3vKaEg2yRcCBRR
         TiqDLu6/KzVtnQ/VSXEnsCFFS2bZH4OtVuJ+JLdYlcs+yn+txfpARRBQ0wAT9Pw8odVx
         EgBOOR3V75YoM/yEnxXC7a4Lmj8QHQuVIP3/tcmguFivRyckGAwT0IktRAjFKWui0ClP
         3rSQ==
X-Forwarded-Encrypted: i=1; AKwUvByaLK7c+nntgjc8fcsdJxT/x8EN40pt0FbyAGcuwPfs1eeUiS3aftrH4okensHGJ43OlwR2qxyMSA==@kvack.org
X-Gm-Message-State: AFq9FYKT4I7OnLcOAVsVyCuZOODerlStZSmbH9XE5xZq0jT8irFUTAHj
	4PJIlOxE6YUiTxSOzoTxjFEWFqWM6hjZ0oX5aPTtZte6/5NwK7EiMhRL93s8BwfryWpcO8yxlCg
	FZwTc7o/kmT4yFBfDo2tvdudIV6jrzis=
X-Gm-Gg: AYBFou0LSzsCSHeuskT8SMnc9lKqY+3MbeRoCjG0wj+fAxts37RTrb6JtRhVqYnFiBF
	xWeyVRxNi1oicUVXT5eLB3JgEVicvRsK6CTkuSSHyqMr6CrLttdR1EQLXIpiBKmc8j9tRtkWC45
	5rFnYGn9DjtBNdj8LP4bH3UBaVU7u6RzR/9DxqtD6QjgEbzhYSeg5ncNZbk6qDQTMtaQ1ILR5v/
	DAYD7GnlGWLPk//Yz7Bsoo9Go1Cap191W5+gywuMSFH5SFkqelMjISlO2GVcUFxaEfFnCXFYZof
	hllmR5HuohUVxf8Yc4tF+a1apd1PfBW9rEYl73iWmp1kbjDyIXIHdm4ixX6UfaMzSyTY2UD1zZc
	ugIKT6mQb34ImyIWPuaBcrtDh/O+GlBUn4mXykbpCmUfqt8FlLgbSzSrxbFjW6TOOWfFAqvraIe
	FIaL7ITxI=
X-Received: by 2002:a05:6000:4210:b0:48c:571a:a1aa with SMTP id
 ffacd0b85a97d-48c571aa959mr7447673f8f.19.1791199373177; Mon, 05 Oct 2026
 04:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
 <20261005093756.22709-1-neganhat@gmail.com> <645204ff-6c50-4ef3-9070-78ac602560b1@kernel.org>
In-Reply-To: <645204ff-6c50-4ef3-9070-78ac602560b1@kernel.org>
From: =?UTF-8?B?Tmjhuq10IEFuaCBOZ3V54buFbiBEdXk=?= <neganhat@gmail.com>
Date: Mon, 5 Oct 2026 18:22:41 +0700
X-Gm-Features: AclHuK_C8DWb7keJEldBGEQQGJ_SM_ZaF6oftPzgImWFpm52x1_XSGgSqgP23-E
Message-ID: <CAFJkwZx9zmz2sxMyByFbYgfCi9zMN+iLxKrypKBCZY9NsLQz1g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/gup: document unlocked invariant in fixup_user_fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB3D8120009
X-Rspam-User: 
X-Stat-Signature: un4her48prp5nyaiaj6i4pjhwbbacp4m
X-HE-Tag: 1791199374-51715
X-HE-Meta: U2FsdGVkX18GZC+/eE8vfkj0IjKGK7ZYgcQRH7UqBUzujKdXgScMSN6D5XwmpC2mB1y0uqcPZ+3OUrc9atelFoO9vn2HCm3Y38KOzGHoNMzzR1RbotsBlRq0w6bU8XMQ+Ovl2KfqZJra0tEZMF72BxccdX48exCOJP/kE+twDSa11gFtQprwSWgTuH3Ue/nU8zYjamaR8shROcSmTWd4C58UfEtBtrTtRFQVp/kqndezuR6lVOS1vgXI5KmqtZw6mT4bXn1kwHRM8P7R2SFmR+9ShMymugYANbqfxh71KLKmkywqcME6mAYVSN6cU8oRfjn/+9sjWBdqzd5p4UbiWJqB7K6HhO6czUKlZolO43uC5Z5mMFy+V+lLRJ7/OuS2uvaSGIBTRJZGk192NWtQPbUGuNYUtz2BphVrXtw4VG6Sj8jo1xwa6PpnWdxOF27iFsZcAoPmr3tm/N9ndDejyiuNKPRRAc8xpQHqzV7JrVUolWK7OVtVJZgNPWGuh5TRAD3uJz+8zuwDzKenRP2VGl3PHfXK0BqXQVczcXDQTpIyuJp+Z3+vw5UsnS+IWdiLPnuZTK6wrTz9wdZwo2v9/g/9LaDVDyZOnYSK0ePA4u9RWcqVrUPiYxeWpzEZKSKtBdFnpVxhX+2YjYLmnTI3KU2pj8GYGSo1aW9qHy6RcbnH7rBapQrFCOvK7DUfNvZCU7m7YKLcIjRBnVlghu947QHWfqgaxb1KpabPOj7ERzve95i31DfFkn9Luf8fLPz5jgC0KrWeJCit9JoxDlThQ8nsuZwuGKFn+1VQDbPlV2eOndqeclETQXoYcvAgY6iBsm5U/R5EkqyBUBJDQsxNFRqTeJKNp3M/GiP/Xj6Eqk4OyuB+5da/Vpm4bRvTnFIVidZCwin03OR/46uOIkiUk5bpvRETLjAKUjO6n5eDMD8rDgPbepBRTi6dQptXvsWo7/+Zs2dFsUCclKEa6tn
 mNDPPVJX
 Ln0L+bkx/D/cS5Qbn5POzyGQxR/mEnKjh/mwv4FqptiRml2hRSg1tB8FLX3xwiMh0WK84W6AAK3omRCmXLvVZJYt5pCKbyGNWvGwEcy10IzTyjLqwDDz5rHDob8nLXO5oV/KgPrcwx/Xd0iWgNLhQlSHc2GQyyqMbX/tTxXWBLtGgNpmtukl1MVZn7mMxtwVpxh3jJf64CSh3wexIk4ycfmBa1higgfLdcEHcwuMAo2r3Tj0NgJ3iepLy0dSJgLe+cCacGELwNfsoaFjksYweBc3DW7wADRbmqTlXpFjwJH/U1juNu0IN8HxcEHxyHkIzhDulsOG02q1/ty4tUmJwjcMvU2o4q8OUm5W8n7ryMGbhtBnhz6SacMqXZ9i71EX9/Lqmk4e4Tns/yr/lNVy2qiuQUK9hU0ycxf8odHIBGr4dbJn1cCgeWDwPa1LlORh0zR7U8kizcnnMx4VprmxcLQw4u9IMkpcIPfVCQ/nY5H+k8lSwJcNMFKdAem1Gc5fCTRqw065MLwkiL6bvkoE0hh9tZacWI+O3wB4WSWd3M6bloYVn6ebeWPVVys+NtIZCeHlO2ThWgS4qi+fMB5vPcB7yqs1ocdq6lB5VwaGosd47Lbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Thanks for taking the time to review.

My motivation came from running Smatch over fixup_user_fault(), which flagg=
ed
the dereference as a potential NULL pointer issue. Because the relationship
between FAULT_FLAG_ALLOW_RETRY and the unlocked pointer is subtle when
first reading through the path, I initially misread it as an unguarded
dereference in v1.

When Andrew pointed out the invariant, I thought documenting it might help
future readers or newer contributors who hit the same static analysis warni=
ng.

If adding a comment isn't the right approach here, would you prefer leaving
the implicit contract as-is, or is an explicit runtime check (such as
VM_WARN_ON_ONCE) something more fitting?

Thanks,
Anh

On Mon, Oct 5, 2026 at 5:29=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 10/5/26 11:37, Nguyen Duy Nhat Anh wrote:
> > Static analysis tools flag potential NULL pointer
> > dereferences of 'unlocked' in fixup_user_fault() when handling
> > VM_FAULT_COMPLETED or VM_FAULT_RETRY.
> >
> > These warnings are false positives. 'unlocked' is only dereferenced whe=
n
> > handle_mm_fault() returns VM_FAULT_COMPLETED or VM_FAULT_RETRY. Both of
> > these return codes require FAULT_FLAG_ALLOW_RETRY to be set in
> > fault_flags, which fixup_user_fault() only sets if 'unlocked' is non-NU=
LL
> > upon entry. Therefore, if 'unlocked' is NULL, the control flow branches
> > that dereference 'unlocked' are unreachable.
> >
> > However, this part of the code is subtle and can trip up
> > contributors or automated tools. Document this invariant with a comment
> > above 'if (unlocked)' where fault_flags is constructed, explaining why
> > omitting FAULT_FLAG_ALLOW_RETRY guarantees 'unlocked' will not be
> > dereferenced later in the fault recovery loop.
> >
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Nguyen Duy Nhat Anh <neganhat@gmail.com>
> > ---
> > v1: https://lore.kernel.org/linux-mm/20261003194846.205918-1-neganhat@g=
mail.com/
> >
> > v2 changes:
> > - Instead of adding runtime NULL checks at dereference sites,
> >   document the FAULT_FLAG_ALLOW_RETRY invariant above if (unlocked).
> > ---
> >  mm/gup.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/gup.c b/mm/gup.c
> > index eb898ea1ee22..58fa75441da1 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1570,6 +1570,12 @@ int fixup_user_fault(struct mm_struct *mm,
> >
> >       address =3D untagged_addr_remote(mm, address);
> >
> > +     /*
> > +      * If the caller passes 'unlocked' as NULL, FAULT_FLAG_ALLOW_RETR=
Y is omitted.
> > +      * This guarantees handle_mm_fault() will never drop the lock or
> > +      * return VM_FAULT_COMPLETED / VM_FAULT_RETRY, making subsequent
> > +      * dereferences of 'unlocked' unreachable when NULL.
> > +      */
> >       if (unlocked)
> >               fault_flags |=3D FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILL=
ABLE;
> >
>
> For which audience is the comment targeted? For people that know what the=
y are
> doing? No.
>
> For tools that report such problems? No.
>
> So I don't think this (4 lines of comment) is the right way to improve th=
is.
>
> --
> Cheers,
>
> David

