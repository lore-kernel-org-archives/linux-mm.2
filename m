Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7C4ECD9B5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D195C6B0088; Thu,  5 Feb 2026 21:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C9E6B0089; Thu,  5 Feb 2026 21:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8D36B008A; Thu,  5 Feb 2026 21:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B2D6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:18:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E3C6160753
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:18:00 +0000 (UTC)
X-FDA: 84412421520.27.4D5BD53
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 68E95180005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:17:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xDiFXAEf;
	spf=pass (imf06.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770344278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwKKBAWfianGkgf2dOSPW7sjKHIffak4EwdTz+f+A0M=;
	b=JMVy9EdIxPPn3EdnSu272HpGl7qoOgZ7oE6xtCP3FzZqx0S58Gbg6SzUDCoqIGkO7k3Q5T
	LTgsQNYW3vUTcKTB16paM96zx/omGAlANPi9yyHkmSAVycQY1eyvzQnEusyiULdVV9C18B
	QkXn3MaAPlXQGPTdrO8uzmYbcruT7yY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xDiFXAEf;
	spf=pass (imf06.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770344278; a=rsa-sha256;
	cv=pass;
	b=KOwoKZ88dlHchB+sgd8VgHwUpWddMw9rPDTfG/o8TGRWBhWuyX+ffgp0GhscQmiTq86904
	LpsTlzxZYfjEH9cMFHsTEsJ9ucTCjPXAN6IdSN83YsGMGXArhgg9miQGs/cwuPtaFjmNFE
	R5mCyawZtm5PM+biE7weASeheZjMKUE=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so85254f8f.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 18:17:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770344277; cv=none;
        d=google.com; s=arc-20240605;
        b=NRoPilCabtjbQwnS41zK+YIGo0BfGg46svd32R6qg+S7Rq6Fczz9SQTyCuIaYmXMO7
         7kyfT5uMHWKzBuhEoyRiz9x3e6AuFQ/7TG2lcKQa5nTjDe0zKTHB2Qnn6Nl0bL2+R6K6
         Mh4rUpDG3bv2GgvbB+6JkeLSnos2dlzI2XhIX2L6Gqh4ewfB75u98p8TxWIT9qQwWLCq
         T+JR7Aav3xC0U3nOuv8Moyqtjf4EPmOdVD46H7OJMVdx4+qYtHUj5S5yzK97TRP8JVFL
         cX3rD5HedfyDJ8e3hEQ584ytXs8FavyUqyKLfJyglEN/NcYW8cFlfHGICEYef3a/RElg
         kaIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uwKKBAWfianGkgf2dOSPW7sjKHIffak4EwdTz+f+A0M=;
        fh=ZTbQDVDOBzuxrk11beGehEopnXYtalQhnSbGoZ4LBuw=;
        b=Ps/0MyR/HZoOKnX6AfJcnBmgNCVPowPnXg25hMHuiqKCcCtVMFSS1Pdg5xrgfCwc1c
         tTMPgZLtVJzpDhcPY3G4KZ8bNV6CvHeFgNOnj7kE1T/Uija+t7RsmMEz5rsDMsMwCy6p
         EGJPgXzGI6T+/F8biOHYsYnEy/dGbo9duLjCO2E/AbJLTTT8b4eanZWtwKLh6M7Y3+UD
         0Bd5SP4+mNoxlKZ3qOeV8hjy52Psx/8/HRupPKRzU2+hLAudT690iMjRvKAdoOb2g++H
         scZsuNRv7XAXuh3zAbBBPso7tzd68TmwO2fJahKEBjOcvyfVR47OEEVAVa4md+jJ0Z8/
         ZObA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770344277; x=1770949077; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwKKBAWfianGkgf2dOSPW7sjKHIffak4EwdTz+f+A0M=;
        b=xDiFXAEfqgI4Y3i+gmrERiY5oXhTlnI/zn4YBnL3OXeFdRlRObh0Jrkj8YCGVjC21R
         bmrhCdFZlIdyuqxuRbKunnEGhi1JfzjvtKUV6mcg4nBT1koVV7IxBEbO62EOI4B2Sb+f
         Q8DPfG4ONs2n/oXzXVX2B1q/WOMJnnE32aRBYeg3Gcr+vHoOvSM6OjBuhaQVs+pfKtfu
         9JHMd56FWgsh49ZsPmkCeXDcei8zcvGmF6MiPexDhTAbo/m/lfj312i9uBqy8utQyvTX
         X4WWSZ0DgR02zfJMUPV5IrPp7frcA1x5o/c2rqt9Yg4HWsm0yzFR2U7KVswOS8OdZOPF
         r3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770344277; x=1770949077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uwKKBAWfianGkgf2dOSPW7sjKHIffak4EwdTz+f+A0M=;
        b=p+nv+5UiZjSoAWUbKzqSoFCryj72tpfE8bvsu2NcS7UAOJ3Olfty54ktZyhB6Ez8zD
         1/mwwUVh5G6se/Fx/PtzUSSzmDCEYLRKO2nO9Wbu+su9tT7UhVj84Zk8vXhx5i3ljiy+
         YM12THxSyT8jDadCCrkqcgyhxM5P7GILnehHteH1OPiZyC7/fIvKuPmuyMzoBGqkFO73
         ZYWZPr7lZoIMetr6F9tKdLBhKn588Xw5p2/plFuIhTjHbYu1SrKCL8Jq7sRFogEJUAhP
         6093EmgcsXTgiFqBP10cNSTIrPcM0HadUk/kFnstjjRqAwJD1pAUk+eOplBlht873hJJ
         mELA==
X-Forwarded-Encrypted: i=1; AJvYcCUlUV6hjf17W0XczM9zb3KtyePsD+ZolPM2N2G3S3pXideLOMQQbgdDddQtXIfrMsfCJOvvjGjOaQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5gVVuSgaQmNUDmXnF0kk6GFIZL4QTaT35yJ1LdJeIufDG9am3
	7V8g+2N7B6YILswH09HJyfIuLCEA1vdAJTTOh9WftsHlwtRjYUMxG9hzXMM6/yr2/XZJrHifi5q
	ftJFGN0Pgx1A8m93H6wtUvYKVclFavZbkkq8KazDT
X-Gm-Gg: AZuq6aJfw8xNR2W3LgerD/e5o0rjKiT07qilwRkrvve7udRG9d4oxnYPNhbwL1LNSvv
	Wr02P9GeFUElDWWQlVKSMPUJvRjXt2Y/xHXm6mzaYMrCaMCv+Fz/V+YTJDjgKPg43vWMkeEm0PW
	1OAhaTi+OO/hht4MNkECzjDy+eHJmpT/HgPzmyN+Fb6kfXQ3UM1ZivLzXOdRMcBP79isgDW6IIk
	wMufuGV/vRW99a9LvjeU/L+Y7W6qPQJGLUVkRTk3z9TptBc4Dvlui+9JuaFHHZeaJv7ayxz867+
	5XhhWVfHqJqRDE6IyczKcrky2A==
X-Received: by 2002:a05:6000:430c:b0:430:fdc8:8bbd with SMTP id
 ffacd0b85a97d-43629380f51mr1671102f8f.41.1770344276502; Thu, 05 Feb 2026
 18:17:56 -0800 (PST)
MIME-Version: 1.0
References: <20260130005739.3163049-1-jasonmiu@google.com> <20260130005739.3163049-2-jasonmiu@google.com>
 <aYIfRa5fDBaLVR5y@kernel.org>
In-Reply-To: <aYIfRa5fDBaLVR5y@kernel.org>
From: Jason Miu <jasonmiu@google.com>
Date: Thu, 5 Feb 2026 18:17:43 -0800
X-Gm-Features: AZwV_Qh5kY2CdVbBsORvOJOaIaI4NUYwjHlys7b0_-TweShTI-HzzR29KaFBDN0
Message-ID: <CAHN2nP+xPRYgMyhUEoBoqfwOQ4GZtvDjZf+B6JwoGe4xOSgf1A@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] kho: Adopt radix tree for preserved memory tracking
To: Mike Rapoport <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68E95180005
X-Stat-Signature: gkn8133zar1dkksuyfgkxy9dp89tcgfx
X-Rspam-User: 
X-HE-Tag: 1770344278-554961
X-HE-Meta: U2FsdGVkX19LuBV+l/ajOPiZvcoKxdxrfLNlCSsF3DZVvVBHM3C6MJY5Z3M+xfcRNpF/acM//qsCq+QWIhRWVcOfZctr7FmTmFzSubP+FRb40H/c4G13uyKExVvHwxdatkNhZdzgSM9zr7zGu3Q6C3J55DZAZzrZt8wUuaExnxJvjKF8A1V0IeWK8pbPUD5fcREUr2DQMgFqc4/Nl6BjCrnd6eWm1nMH5tdHQXAVGZHcrm4IodFqkE8RZGQ6esWPYJ5vkSKZ4J13RiI/ZK/efrzLxDzbydsFFoQggY8psTNXwjx0dKGQCRVVzJMdpJHSa+bWu9KYVsz64CVhKOTkUBbKPyUvIFOIsCr0Bo+O8Rd1R2iTCbin0CYtrru/Ch9A0gUzxxQA7xZpsaYcJOcvP/aXGrY29HhHeJ4rPCVh6g2tGFqRNIq4jsjgwm1/6Ww7mh2zaATCdWhToupca8fVQxm9Qj1pHmSpS5yoD39ZDVjG0zmaYd7rSxYOnzmUMUCU4wijTPkqqpCWQVCmMTi/WMs0adz8XQonFhR+O7ioi1c7OnpyCQANgooW1xkltV5pcKylxEat10F50GbT+J7H95aViMb5NoCV4zeeGas6Y5Tz/61ikwMyJ7wH/ceW1z9KJuRAstSr/7ZYD2mGdyx6jIR+B9fSAL1finBaCfmXVAJFZgP3NCoQxHSYMxSItHe7vtB/xdS73qAUzmS/rGxyUM6HfYiAPQvotiqAN9g+69nDTks7Ff6UZtst2PXqbHJQ/Nh29m8TaawQIQlXA6w5K0HmXTN0gkQhlQy8MP1Ga2ovCiOsk4AWloyTli/oAvPBhVd4w1T3rp3yBS9M0njCiR2Rijx7q1zMmmnKQVSUAjg52IAnApp8Fk3I+MvMjsOfLugSkaajYbf5lMzFpgwSFY4ZstZdXH9svQx5eWaVhzV/o6Qf0dQNWPvwAEIDetruka1muKfC0eUyAkqKCgF
 JGH61wUS
 PycjfcbCsXqUP+wO7ZuBc6N6Wy7wG+DcoK8U4q4eQWqA/AKNayyBF2SjBCT+cgZkZ+PRQU5HubvP3sSZqaqqZ3+P/CgNQCrOrCATVSCtcTamucVVIsstMZBGPZFV7N3wFGQ6rultB9DJzEbD/gLWHYRAw4OwrRwbNm0yMkL4y7/UuRgBERUn0uAtv84EVYGh8Nl5AawRzMbPQM7vsH66RhoACuxNI5DIhOkkIT00xB5CpRjkA+idnXmkr8vXc9ZJoU/ThShi/8Up2kdW92/k0V1RjMO+Hvpnc1MVyIB4hEI+HU6NzEojecxelNcivc1D5KeSOywUhITdwNHxLstX+9AQd0lRe+5dK3tVqIrg0s3Zq+W6Uy1B3mLeF7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you so much, Mike, I've sent out the latest version.

On Tue, Feb 3, 2026 at 8:16=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Thu, Jan 29, 2026 at 04:57:38PM -0800, Jason Miu wrote:
> > The ABI `compatible` version is bumped to "kho-v2" to reflect the
> > structural changes in the preserved memory map and sub-FDT property
> > names. This includes renaming "fdt" to "preserved-data" to better
> > reflect that preserved state may use formats other than FDT.
> >
> > Signed-off-by: Jason Miu <jasonmiu@google.com>
>
> With minor comments below
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> > ---
> ...
>
> > +static int __kho_radix_walk_tree(struct kho_radix_node *root,
> > +                              unsigned int level, unsigned long start,
> > +                              kho_radix_tree_walk_callback_t cb)
> > +{
> > +     struct kho_radix_node *node;
> > +     struct kho_radix_leaf *leaf;
> > +     unsigned long key, i;
> > +     unsigned int shift;
> > +     int err;
> > +
> > +     for (i =3D 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
> > +             if (!root->table[i])
> > +                     continue;
> > +
> > +             shift =3D ((level - 1) * KHO_TABLE_SIZE_LOG2) +
> > +                     KHO_BITMAP_SIZE_LOG2;
> > +             key =3D start | (i << shift);
> > +
> > +             node =3D phys_to_virt(root->table[i]);
> > +
> > +             if (level =3D=3D 1) {
> > +                     /*
> > +                      * we are at level 1,
> > +                      * node is pointing to the level 0 bitmap.
> > +                      */
> > +                     leaf =3D (struct kho_radix_leaf *)node;
> > +                     err =3D kho_radix_walk_leaf(leaf, key, cb);
> > +                     if (err)
> > +                             return err;
> > +             } else {
> > +                     err  =3D __kho_radix_walk_tree(node, level - 1,
> > +                                                  key, cb);
> > +                     if (err)
> > +                             return err;
>
> Nit: if (err) can be moved outside if (level =3D=3D 1)
>

Updated.

> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +/**
> > + * kho_radix_walk_tree - Traverses the radix tree and calls a callback=
 for each preserved page.
> > + * @tree: A pointer to the KHO radix tree to walk.
> > + * @cb: A callback function of type kho_radix_tree_walk_callback_t tha=
t will be
> > + *      invoked for each preserved page found in the tree. The callbac=
k receives
> > + *      the physical address and order of the preserved page.
> > + *
> > + * This function walks the radix tree, searching from the specified to=
p level
> > + * (@level) down to the lowest level (level 0). For each preserved pag=
e found,
>
> Hmm, why do we need @level here?
> Or it rather remained from the older versions?
>
I forgot to remove this when we changed the function signature, I've
updated it as well.

Thanks again for the guidance.

>
> --
> Sincerely yours,
> Mike.

