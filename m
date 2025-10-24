Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A75CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFA18E00D2; Fri, 24 Oct 2025 12:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260258E00C9; Fri, 24 Oct 2025 12:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175948E00D2; Fri, 24 Oct 2025 12:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 037328E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:16:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A70B813C47D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:16:14 +0000 (UTC)
X-FDA: 84033509868.11.085EF03
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5043140012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:16:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PsDVoCqk;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hoXtHHA5k7qKtUM3YbUnyrHBlYIGcj0sn2V7B2w8uw=;
	b=yTAj1lEWyxMjwv2UbettC391enoC+a4x/E02qsq5fd1oD0L971+y12t8GwuWS8ViGp6jw+
	S+bakXuJlyE/bs5d9gUS4f+3hTT+ltpdX+bXA7u1NQmwHwpMcSCGqwvpZBMyTJc4XuM0Mo
	0WLjQST+C0q5gL1udh2P+6hZdq5jCrk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PsDVoCqk;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322572; a=rsa-sha256;
	cv=none;
	b=IJwSqhtcPJ6Cc96x2e/UvRcqIjIcmgeNn9u747Z4wFXBEexsvKP4tNCFDR625c0mg4nP6c
	j0wUX3Z2p+TOanVMWdEBpXvRnI+SYpFFEmx1Pe93NLYMUKZmhMqzrMsSvpMOUG1jbynyvA
	HKuU04dkzg5d4jDrqGnNcsGqJjUesWw=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-378e603f7e4so9965001fa.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322571; x=1761927371; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8hoXtHHA5k7qKtUM3YbUnyrHBlYIGcj0sn2V7B2w8uw=;
        b=PsDVoCqk7hXRKatzxzECUNnzvd+7Q4DXxXd1Q3qMiP/DarhSeIvr0lRkdYx0zfHdt7
         oETEx+0PqdnqFUqerBQ/O4vaY0KrhqnYXhG3CPqoEMfIw3y6fKQ8uH1ifWi46MmMGbzW
         bPZ8/D/HENlnb0wwQ/i9OXdnNXl1T6cgsKRfWgXitf7/PoP3ux6HJPmhYOHyueBv23oG
         Y8nFT1sORP+SSGkIWJg9WPqOJJ8zzQ3cKfrBTOJul9ihx6cSy0MkxK+dLM4kf9dlU0s9
         kY2YNrCh0m/7eSS3dgJyAxbW2ScusQU+A88cma7XGYobB+Jb0AJTvJ/AN4Au3c+FgHSL
         JpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322571; x=1761927371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8hoXtHHA5k7qKtUM3YbUnyrHBlYIGcj0sn2V7B2w8uw=;
        b=ZLKyp+mDWIh3HdV1WhjSfISPOkBsObMUfjcmn5YMklHAfrutSlIYOm2mZexZA5HQ2j
         RtmnlZyFIM3KJOm6vNr1S9QBSZRXaNhNoBI9248YQdI4y/VpuJ1uLACEoP7kkw/V2XHa
         ZT2AcqVuUgEpvXpi0DYN2n6YpDPHgASAkWeolkDUq7f/JC0thkx5zzlTKER48tW6QWCX
         k+MsUeD8liOnKNeDog/IRH7Ej8AEBrx0sp+rrjz9amK/bqHXZetOmTOIYD5zZoriGNM3
         G2KQC/qaR/pH2E4tgBAY0xJV7eSZSCM12V8G2Wgf8P2mTyEbwdL8IxdvfwYH+WDC/sUI
         nUaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmgAc4hY6V3iClKfAzO1bunJra9fXLlYGJ/cONIbdW/WSvqOxbgVl55lpRZcQNnQ/2UCua+u5dWQ==@kvack.org
X-Gm-Message-State: AOJu0Yxx9cB1oLhqHovP48le7H0J6qDl8Q+3I62SB9ffE0IAgHEvSbGA
	53hqkxYk1DJ46cQgff+ioiAHSLx7YePqTQjNuesLxV1KwaCY4tDc6AHnS5nx5IpUeJ9i1j5RpBE
	63lIzpLp6ptotJpSmXnUrVYtz+o/N5VFZ5M31NHLK5w==
X-Gm-Gg: ASbGnctao5nRnWlSGx5NHaZjx21dKZS8ZUir+ayZhtvXIZ0C85BDMhM4xAoXpL7VDJg
	h69aqdMoACZINu3LdoWJHnErsaJQP/30ZsL42ZQOGfnnogpwvy2ufbcemxA807PqKvEVo9+hk2o
	vmaemiLB9PjlhpKKOCkjajDXvATyM7LPW61gelWcmGbuHchCW38hZSKh3PQwSiMFYky+sSdYXD6
	78sEvaIN289pO/Ze11QP0R83oghPcJwtOs8sr/A8IRNJcR4LhEAmJbpv2BU1wZWDRL/
X-Google-Smtp-Source: AGHT+IH8WOU0xbwl7Y+ksyd5jD9X6PhDLczYsD+A6K0t8J7OJdygB2+hIh+k9oSvOmjM4CFOKsep5og5GveG+1uLBEs=
X-Received: by 2002:a05:651c:12c7:b0:372:93dd:681a with SMTP id
 38308e7fff4ca-37797a744bfmr92216601fa.35.1761322570537; Fri, 24 Oct 2025
 09:16:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-4-pasha.tatashin@soleen.com> <mafs0ikg7fbez.fsf@kernel.org>
 <CA+CK2bDrrg0UoJXpeN+Au2-sreYrZ+DHVcEUidzPw2Qk60orgg@mail.gmail.com>
 <mafs0o6pwe1sy.fsf@kernel.org> <mafs0jz0ke1qd.fsf@kernel.org>
In-Reply-To: <mafs0jz0ke1qd.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 12:15:32 -0400
X-Gm-Features: AS18NWDS5bf4nRNM2qxXHaSonlVu1EPNEq3HBS0RPvYO5kiX8yMEO_3tWdOfdcs
Message-ID: <CA+CK2bB_xPAsHXU62Hd5iBt-+Jf2BiXQM4M-QEL=AA_Xu-APhg@mail.gmail.com>
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5043140012
X-Stat-Signature: 5f3wyyg3znys3t3fqhm9cdwpkks95bdt
X-Rspam-User: 
X-HE-Tag: 1761322572-574449
X-HE-Meta: U2FsdGVkX1/IrmLadpszNtWJPf7SvG53b/kfqtH21BM3Pou6tdF4+iOy0bGFbXVN+/Ti3Ex+MTMDAPu13zMeZhlb68GRcYKCJp+x+tpfAVgY3l3hKPnu5Qsx/hQupenMB2Squ7N6G3/bXFO3cmQXrE2Q4x3jYRY9eWdmaSaJ34JFVa5J4L138C2xnmkBUeeiSS0MyqFhc1uZjZFQaT4LzY0j8BBBPzR786dAJy3qz0+1bkZf5k7z6uiKYtKjeMCLKTGo4PxOlvVTWXi+6LljvAenWwgk+L6nIi4dhDe40G9X/M02LO28MkumxJPloReTO5lYeSlypexQcllqkI7OSyiXWuT4ALQxI5Ejr983C4almbyX3rzZ1lqdByU2CaaxjtYbA+rEIiS51YTIUFvhhdxryVFE5tYKcTKcGryI3T1zALLfj9rBJ3k5IClYBaeVQCNaPygOsSECbwIcfI/RYQ+T3slbq7EEwaW6QSPmj4FvpAiAbo1LuLvKVi7DOXhBER94TcCs5nHRb/olspcyGxff6+ImREffGGaXXhT46mwQC5vYMGHY6OcEDRnTZ3xZh0J7aXqBmYyJfN8/2JBHUUdYfZzRLilCLCpZnS1AgOBD3CTpWLDFOzOy5ZhdCTrXAVv6hSHZ05sir1nLm7KUPxT3NhV1YBVHF6Cw1AmdRLHaQMZ+KC1fqnCSTtQvEx6qMQbx8KaqBy5dTQ+sOerSGjkR3NbOz4H2CmpkNrS3lHE0RGCPMn7TJ5MhhzKAKkHWkw/IawN3QBmDTQbO+59IQ1PyrEcspUKvE8BhPsMW8Rx4ukLF9DTquzlst27yumFaxCteokAlHlXCv7AyTJxPBZdvACh0uQ/0syYltxfQ41Bswn8/o6etB3w4T9R2W1UnFWbX3t67eWexyWshb6oXPUsRW4YmaTxVd+5BUpSCJrYgOIpgcxBPYM4IIDWm9YEY4mfm/8TcXIFbXAOYwvQ
 GwuSxIPl
 Erh/J/KoF2Oyb8ELubDHzQtJaMlh1NQy2g5qFeBPgW4Or0BGgJFTvat8Nvuk65JcQWGnikdCXc4NOXHJ0e3npiNvJVwi/pwDRu073f7xtFrL0VAsTOxP1LjQrqzeWdIODlvnFG5EbKfumCuzMkGhL1GRtv6t/Z3qKDWmFs4PiGjYjaq5KTdYkY+pxc2KJqn7JHNaQZZ0sgSsSz4qzumgfqtyW6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 11:52=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Oct 24 2025, Pratyush Yadav wrote:
>
> > On Fri, Oct 24 2025, Pasha Tatashin wrote:
> >
> >>> > -int kho_add_subtree(struct kho_serialization *ser, const char *nam=
e, void *fdt)
> >>> > +int kho_add_subtree(const char *name, void *fdt)
> >>> >  {
> >>> > -     int err =3D 0;
> >>> > -     u64 phys =3D (u64)virt_to_phys(fdt);
> >>> > -     void *root =3D page_to_virt(ser->fdt);
> >>> > +     struct kho_sub_fdt *sub_fdt;
> >>> > +     int err;
> >>> >
> >>> > -     err |=3D fdt_begin_node(root, name);
> >>> > -     err |=3D fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys)=
);
> >>> > -     err |=3D fdt_end_node(root);
> >>> > +     sub_fdt =3D kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> >>> > +     if (!sub_fdt)
> >>> > +             return -ENOMEM;
> >>> >
> >>> > -     if (err)
> >>> > -             return err;
> >>> > +     INIT_LIST_HEAD(&sub_fdt->l);
> >>> > +     sub_fdt->name =3D name;
> >>> > +     sub_fdt->fdt =3D fdt;
> >>> >
> >>> > -     return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
> >>> > +     mutex_lock(&kho_out.fdts_lock);
> >>> > +     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
> >>> > +     err =3D kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
> >>>
> >>> I think you should remove sub_fdt from the list and kfree() it on err=
or
> >>> here. Otherwise we signal an error to the caller and they might free
> >>> sub_fdt->fdt, which will later result in a use-after-free at
> >>> __kho_finalize().
> >>
> >> I think, it is better to simply do:
> >> WARN_ON_ONCE(kho_debugfs_fdt_add(...));
> >> Now debugfs is optional, and there is no reason to return an error to
> >> a caller if kho_debugfs_fdt_add() fails
> >
> > Yeah, that works too.
>
> On a second thought, maybe pr_warn() instead of WARN_ON()? This isn't an
> assertion since the debugfs creation can fail for many reasons. It isn't
> expected to always succeed. So a full WARN_ON() splat seems overkill.

I sent it with WARN_ON_ONCE(), I can change it to pr_warn_once() if
there is another revision, otherwise we can just send a separate patch
to make the change it is not that important.

Pasha

>
> [...]
>
> --
> Regards,
> Pratyush Yadav

