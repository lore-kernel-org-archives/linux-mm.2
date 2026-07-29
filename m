Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377CBC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143FA6B008A; Tue, 28 Jul 2026 23:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5AF6B008C; Tue, 28 Jul 2026 23:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B4C6B0092; Tue, 28 Jul 2026 23:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CBF0E6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:58:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55E191C0C21
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:58:00 +0000 (UTC)
X-FDA: 85040455920.19.E429283
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 639B6C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:57:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpUFKb++;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785297478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBvGb5qenRrsnlW7ZV/vGRFaGIHQgeYKe9QqCseZxGk=;
	b=lndx9qEjEBo+OJJEFu5r6bGUzDwYKoi9oUBRUMyAIuQr/dRUT106g4g+lVjfOvOxQLX+Dx
	Zij951LaQkblOU1sOJeH7jpP7O39ueW2rLiqGFvjiC70y85N1OsE3Bvyq2w52wvzWtDrwU
	TI5E5CgE/IpicU7ZpZZ1Sbe6cnFgRV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785297478;
	b=QdoEuLjj+MXOuY51mZAsgv6uMvaufK3AaR3srKm456NLgYLPmBwu4Wru+uDvrnEyqD2P54
	FesLtcmOm9BP4VNYFKm3O0bcXh4yHnQDb80543ohipzqGLy++AhES07m422+NG5tQ05Wlp
	08AX0pfAyQFvo/2CQjPm5C4D0Uovz28=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RpUFKb++;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FD0D44FC9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F071F00ACA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785297477;
	bh=WBvGb5qenRrsnlW7ZV/vGRFaGIHQgeYKe9QqCseZxGk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RpUFKb++/Cu1R9QdgIAMmG4bMtpgEjj7oopRFu0mJQ7mWzEX1KVb2XBnrpffzpf5Q
	 epwwZya6sFKpBI+/bdhekqpsqTw3erbHOD1wMabVRwdytc80V929PrpZKU4TgV8V91
	 iE0TeY2AWFF47hbsv3Yhh5Z1ofwSlf/liGFjCGlsN1H4vY0+I9IUKxKbl8CVeTGIhq
	 ZPZxHPf0wa1gRUbOPZODyCeuHAC+hQRPcmc6Fcmot9yk6EvNBuFAUQ42DzU9y9sgb7
	 x5w/0FiEuB7YSCR1ywTRxSjPm9Ojx/3esTtijMlDNBgRc5+KB+lz0nxtL27fqm/yHm
	 bOk1shrU+tHrQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e54f8c051so30188485a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:57:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrwBWpsy1o86QNlEJGWXRUavmSSygOjbQpMe8EWrTFGkrlKGc+q/c35uxSWkRVMIxzA5fqEvhKWDw==@kvack.org
X-Gm-Message-State: AOJu0YwVMG+t3AQ1aip9pRzArnZaUHzWI8l5EKbANF5JbN2xcBwTREaa
	O3b0lnPsEVBzSD0grrnYG064jlW++w4Y2EWDdBO7TBpp5T7UDYCa7ArZNo8sf1Qz2q1La46OJ0Y
	WbUXAUnrhkpg0li2UTKdFmGPs6Dmqlnk=
X-Received: by 2002:a05:620a:4725:b0:932:de54:130f with SMTP id
 af79cd13be357-93302644959mr540835685a.57.1785297476778; Tue, 28 Jul 2026
 20:57:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-3-jiangwen6@xiaomi.com>
 <20260721181729.305137-1-devnexen@gmail.com> <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
In-Reply-To: <CAGsJ_4wWhvKA=BmPwCrGv06kq07QMP6CKES1mGUnx=HmiDPGLw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Jul 2026 11:57:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wUveHA4mvkhrkdtyOeZzsNOmY-TxVN-dHpb=sN-Gr6YA@mail.gmail.com>
X-Gm-Features: AUfX_myvKscN0E2hsqpXT_KCvHtoTt4qoIZaeHJpupKzp4Iofdn6Pn4vkmIM3xQ
Message-ID: <CAGsJ_4wUveHA4mvkhrkdtyOeZzsNOmY-TxVN-dHpb=sN-Gr6YA@mail.gmail.com>
Subject: Re: [PATCH v7 2/7] arm64/vmalloc: Allow arch_vmap_pte_range_map_size
 to batch multiple CONT_PTE
To: David Carlier <devnexen@gmail.com>
Cc: jiangwenxiaomi@gmail.com, dev.jain@arm.com, david@kernel.org, 
	urezki@gmail.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 639B6C0002
X-Stat-Signature: frag7torgrkbpr9uucan4azutc1nwn4p
X-HE-Tag: 1785297478-918289
X-HE-Meta: U2FsdGVkX1/D5CyDIx0iu5HJv6dUaXthUaRoLJ2wqbnwj1jsqfEZlmSIJDJRCcsR16Vinj/r+lUKxG/kRQohxN2sBT3U2Y8/xHu41QbLKUB85TzeMOox7WlS9ZNX2xZUM6u0Yg+QR0jnD1Ew0I+HdM+wGxIhH4RRjMCwJBt0lNcPHs7CmBxk5t5RBok39Qyo3HLAJRF9yIQxVLtxfBu4TMXNj20OLfmnWTh14f8ojk60Ty+DBG7R8sUbTCYpxJNUvKx0niptGX/QfO6xysbYyFsUY5PC3Ro4FckQzRr10C+e8zJOfvYjwhNJiaPRsqK78tX0tclZrMECUbOvpcOrGYHWKnA0xMcC1GNEbAFzmpvfS+9EODX4rimrsDyxpSQ1XsZ0risliXVhcOQvqYPHykWC9+A9SH4Y/EpmHFhQp1rTgACLNPCC8LEDtzEZV1QUS4zdNcXMwC12zm4JKNRv6MQeznw439on+/bA7Ql6LQZ02EohLd+HPlKCE9Mu7t4gu9UxBdPDvCQ2AFj1h3qFizXOwsTLFssCgCXkauod3g61cuoCFdSSs8lOp3ncMIB6/UM3TmlguvQJxOMN/NAcyq/iCfRxvt82mwDPZWvZQ8xP6hTt9VGjQrf0+eJv/kTgBNutEGVIcmHvosENzk/19elyQslVweyfy7zgFulWgyeeccHsPEfF1LiSGrNMhAq+mybhck5agg9AetJWCyKG5QQPy+65Awl1GzNk0b2mtiyFI2Bjm7bftzMUukAGkYIE3060YDf/SN7GnFMjlFok3Kj5NO2lpH4D184fZJy5qP0cVJGyUsZdK2h9LULD8FwdYJhkMMQXosq6J2aj8tMIs2VjLhT/kKqKdWZ2uaCEeaMTwDDUiD1mwuWWX8MJ+Klbry3Tsi26H94YvrSO85h+TXAtyP/C0FnRdHc/e+ZAhTKA1eqC5gFxDexGVBxIa4yhPneGrhomTVLlbcUJ5I0
 CkvSF7bg
 bv+1JowOdGHXiEJlj45OysyUPq9Qsb9LMnFvKP1im38Ywz6Z/vUGInqvbv2cwub7aIBpUFe0Jv07ejeO/nD+OShWdUI7fu3aXqYHKSlvJrt7z0yoHNUkXhiC/aQzni6Sv8SLUlRBhybiXGKfck4ksdX8u6RSFLVaXbIPxn46K5yELoWMal4E/loUzlhKWyyWDYpdHxRxFO2cGYqWjJoN056iCcNsBIcTnD4yk0lvJBmQMSWGeO1fGNLKdayj/N1znmeEVcZmvDTssTeaUn+6YpU6LxU8MIwgkOBNVDkewqTwnDFWfSIP0KAq3iIVYJLAnqklmBqTum0u2U2nBOi6JXqizpeNEfeoaTBA8wjwuN0+G4d0P1laj/uZHJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 11:45=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
>
> On Wed, Jul 22, 2026 at 2:17=E2=80=AFAM David Carlier <devnexen@gmail.com=
> wrote:
> >
> > Barry, Wen - the returned span is capped at PMD_SIZE >> 1 but only
> > checked for CONT_PTE_SIZE alignment. In the batched vmap() path pages
> > are only contiguous within a naturally aligned block, so when a PMD
> > boundary splits a batch the next region starts mid block and the span
> > runs past the contiguous run - set_huge_pte_at() maps the wrong pages,
> > tail of the array left unmapped, no warning.
> >
> > What do you think of clamping the span to the pfn physical alignment,
> > like 8xx does:
> >
> >         while (!IS_ALIGNED(PFN_PHYS(pfn), size))
> >                 size >>=3D 1;
>
> Thanks, David.
>
> I noticed that 8xx has simplified this to a simple
>
>     if (!IS_ALIGNED(PFN_PHYS(pfn), size))
>
> Could we do the same here?
>
> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vm=
alloc.h
> index d665f9d68742..a27101e24f76 100644
> --- a/arch/arm64/include/asm/vmalloc.h
> +++ b/arch/arm64/include/asm/vmalloc.h
> @@ -46,6 +46,8 @@ static inline unsigned long
> arch_vmap_pte_range_map_size(unsigned long addr,
>
>         size =3D min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
>         size =3D rounddown_pow_of_two(size);
> +       if (!IS_ALIGNED(PFN_PHYS(pfn), size) || size < CONT_PTE_SIZE)
> +               return PAGE_SIZE;
>         return size;
>  }

On second thought, the caller is walking the PUD, PMD, and PTE
page tables, so it won't pass anything that crosses a PMD
boundary here.
otherwise, the caller has been wrong. for example:

static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end=
,
                        phys_addr_t phys_addr, pgprot_t prot,
                        unsigned int max_page_shift, pgtbl_mod_mask *mask)
{
        pmd_t *pmd;
        unsigned long next;
        int err =3D 0;

        ...
        do {
                next =3D pmd_addr_end(addr, end);

                if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
                                        max_page_shift)) {
                        *mask |=3D PGTBL_PMD_MODIFIED;
                        continue;
                }

                err =3D vmap_pte_range(pmd, addr, next, phys_addr, prot,
max_page_shift, mask);
                if (err)
                        break;
        } while (pmd++, phys_addr +=3D (next - addr), addr =3D next, addr !=
=3D end);
        return err;
}

I guess we don't need to do anything here, David?

Barry

