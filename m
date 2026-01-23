Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DA2D6CFD5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDD76B03C6; Fri, 23 Jan 2026 01:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B56F6B03C8; Fri, 23 Jan 2026 01:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF286B03C9; Fri, 23 Jan 2026 01:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEE36B03C6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:16:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3F0214031A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:16:03 +0000 (UTC)
X-FDA: 84362218206.12.5D5F720
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf04.hostedemail.com (Postfix) with ESMTP id DBE3A40003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:16:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daeNHtx7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769148961; a=rsa-sha256;
	cv=pass;
	b=hhJ0mCn4Yz8LeotX8osMD8fYuzhut2aQhPbQCMX1LHmJg68sSkgbPOIhxq0uiTIdR2knVg
	lhRZh8TAbzBn0uWv8wwUqsPAVDdxwt7isPfAvJbuhEN4V/rOlFlQxkMj4S06PpoPw/dcb4
	qAd6G1YMV1oPQU1OMV6OD9huKtMso4w=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=daeNHtx7;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of tianwentong2000@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=tianwentong2000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769148961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
	b=GCJ9SElZvFBMr6Rq9Nt1sS+vhIIxo9F1wMW+k0vpDGzo7IEltS8i1w01/IeV2bE4vLK1MA
	+FsuWtZYA6ywe+lat4yG8S6tyV4sbS3NGpk/BgfheTdOXuX8ZqeJmGP4kUy6esBc8r8q7C
	uPD774zpJh8UjVjRACZsfIu/AApoYXc=
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2b70abe3417so4701561eec.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:16:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769148961; cv=none;
        d=google.com; s=arc-20240605;
        b=cdnc/mIptFVZLaCFw6aG+FruMx9N61XJRNyoa39rBk6ms82580fDb9BYXtiCoIVisk
         ahDQ1akhXqrPWsnh/aWXOObGK9Ydfp/18R1EEOj6Gq11xIPeeIjL9BdhDkNKFnUmb+qu
         xsZ7EOw//quq+qqqHmivBa9tFuhyYj8LvIiaY0mDhbo7sHHrxTbDW6tI+JhRQMvHupm7
         EaU4NVuwN9zXmqAXMMUTRJwbnr9BfhGoDi7i24GP19Fv2FKtxLe0KoMFRji2rbNsYwDp
         abql86THBKeC83FSHwwtkQPLTiCV7rrFXJBXb9y+MlQbQt86rFi/2Grwys2UBxrIYMPh
         XBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        fh=eyIW6pBG8Snznu9HuRwTqjMsNlaE9OP0+7gD//Togyw=;
        b=I2afiFmkmHfMZP+wrm/ZlBiBvemfDHXaWAbY2cMC+8bo5rTOnD5wqwv4gdpmtLufB3
         1coYo3MRm4k0az9pwOO0LVWnoZdNxtE+LGl+swE81g9eD7oolwGsQyUExLvdya1ph5b4
         DYvpqKwSqrOueA6sp61Gn2GHGcHApXVRhTUuE7ReTxrcXgwe8mkCjEKGMJEBKphFKrzr
         d7Vpxx9EHVvhBUrMWE37L4739hnkhcseAkQ1Ns1KoClU6c4NWF8f34r8LoiGlotLvaFl
         8m3qQjrSWMgb2UUBowgYHtuqw+BJLHtrUr5y/HkC3JmUDk5Dv7Mduu26AzOPrCkLuGM8
         pKFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769148961; x=1769753761; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        b=daeNHtx7INSdX5DXv6X46kuksWuxmlGNG2qTCsE/L3Gefr6FyU9KPDq3PMjUEwEk/j
         LN25wKVixwe8OQozEFKtnEZpIDKWgJIeN7VAzEGjcsLExYkwLw10beykbn2lmRVK948a
         bJhp2v5rdqUE/zUg+shzz/TNTFPpK/6zG0cHO3SPlm+EeZ0/0lw2HiEwiK5U81uh+x+E
         nQ1Bo9QD6am8GQN5+tHsW6laKcq5bA4Gjk3Lty1KljZtb99OPFBKVwnnoiVZwLKxUliW
         prh5ebG6fbFJ8qqehI2McV5BYx5IJCfAnl0TzFWQKYBYVUQcL12joTfUjwZhm0eU4lSW
         vSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769148961; x=1769753761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        b=uizHRoUrBV1kqpVCSpcVXmS4dNVwlX2oj7aDFidiWBaQ2f28pK0B5Hma4N0rwhAMq0
         o0JSvokDg8h4OuBiujDO/kArMilhBBPj0IhA68b7NyNK/uS65zH6m9KAeOEIf3YgZzOW
         yPxXKR8yze/vMklSnSsRDn24lQSks+XZYh5NUJ8RllIN/9b1sdseaoMHLc/hKq3Yseuh
         P697SNOshqAm9hDOjp10prb+tEPoQSz5ECJRLuczTd98g8q3G4+bSV7TvXVgBpXG+310
         e/hD8csQloorItHvVZzd85rC7KpoBES3TPI6PHvh20+D6xYo25tbzIC45tjOQfvvwiuw
         WrNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSGzMHNm3PzHk6waMiSOOuItSwWVoqE3BNhyZAE6S6t/SSOG67mQiRr1VFs6J9nl57fZJZXYeSXg==@kvack.org
X-Gm-Message-State: AOJu0Yy8QXH11RGgxs2GkA+u9cd9BzqjojJdAF4HoiiIha+EXZ8Bl4aA
	e/pGh1Hauk8WL1h8vnmYel2g+Mk+XhDcA0kgAmYDGXrSLQJUjezt/wZ9v0xcub2+oe+cxUuPLeJ
	gh5Rq4qRzRnTMk/QyMcIQ0v03cY5N28g=
X-Gm-Gg: AZuq6aILkS3KDGk0n79s+BwxWEIkvtOmrKoW/bqFlL9JFkTtcFCVk8dg/k4zauZDHso
	D1bBUTqltuGq6a4c9+QdCFcWcXiO1qyKYPxsFaUAfRJRnRToOJzXpZJtCMajDPLMFv/ynGqppk9
	FyS5NE8KyjcByzMVhi9HGktpvy00Qp0UfVA93gUosxMu0kTmUQwehIXbT72e2/GNyBjaDGN0mfA
	wqrUqP8lqJb+Apf7YqXJpn4fzZRHKePuzfzmdyIhJABYg+382eJ9LknNJ+A/TNAdFvoNJ8neeeN
	pqGkwtLd
X-Received: by 2002:a05:7301:2f86:b0:2b0:5c2f:6bf8 with SMTP id
 5a478bee46e88-2b74285218amr94165eec.23.1769148960619; Thu, 22 Jan 2026
 22:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20260122055435.95911-1-tianwentong2000@gmail.com> <bfaa49c58626932e65096b433c7f37a2c35ca382.camel@intel.com>
In-Reply-To: <bfaa49c58626932e65096b433c7f37a2c35ca382.camel@intel.com>
From: TwT pupupu <tianwentong2000@gmail.com>
Date: Fri, 23 Jan 2026 14:15:49 +0800
X-Gm-Features: AZwV_Qh772i394vRC9QB89k62wNoreVJOAo8TWYwMOfwq0n_HtLm7G8PGn9a4qg
Message-ID: <CAGPELS5G42Esir0LHz6gAHKsO5gas48XiMtfOeQ+Kn62rDuicg@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DBE3A40003
X-Stat-Signature: ury49hxh9tm1b4qeuw8u1cibnq1m55by
X-HE-Tag: 1769148961-654007
X-HE-Meta: U2FsdGVkX1/KqZzOSmsRg4flXbbfJgG1PuaoIavoqirBiLNrFzjkNmzRSbe0BE+wk+NAHggh3GuQNRWoE2clVJKCKmVV125ucPu5sH8ZCNDs3t1o6U1yJKRlmWK0A2VbfQuAPakhT/siEhG3Pn8o988c1QfuvK6nzfzdF3Ky43hgWxOuJCv2tdXuT1zEsn8evEiS8ljKcSzGB7l4aZtLUXy6fnEt5a3jrySggURRnRiqe9xNbwE+fLpk3JTJjjjCOQJNOxE9TnxAucQ93XZWl3GHFMVe6HB2lmWLi6pDQGnxyknQV+EkFpWnuvufkKKdftynkm8JZvyequQk0SbuV/TMbIgewaTbrlBaWdLCmoz502umjtAe8G0yeAzmYM9EJuCbV++qMd9Dne2BndEJ61dNTzdpgu4qDH/aL0tixp63UNXV5rTysm6U6w1ynOeKmLm99Dl5lRWZ3Zag5DbLtynbRNUWH6luK3R/W/osZoTOt/EyCdh83O2xEzoMClwUgr1aoy+DiWUvJpFkhBB5sTX1eIX7MKUQc3z18O3woyDNASzyAxEv//pxnoAF3C22BYG56nCz7wjnyxYMT3dB07tk87TD0DMk84oaZITYJ863tXRLduhoI6T68NG2PM3SpkYv93HlW2UfNZ7hMZUA9n0TBiRfBTO36pjP/Q/mO3ESBn95aPz96Atb2UDFWOSk6wMBcxUVEMazbJdXIbXVHfB1/zvdp++sc2utys366qguYa7qcKDDNAqNtRH09YFd124PgW75aZXwT40JYbEEYuenITVxE2fjtbgJPNBD9XtwtyLsZPq75KaXUxwQhp+hP0ijXZ7lOO1NXQIlsTRFZ7FvSIeECF91Ijdzb3U1Nx6sXOeFX/7EvQKfT+KErTwEpXWFWJ53SBpbWSxYrNIh6Tie665G/7GTcwSRoHyOGkIJ8EiyIk4UQRtIw4Wy4Y+iRktqfnd8sLTM/CCnJ4w
 izWaQWq1
 0kSqmqkISVCYLhB0BojlMzQUa9ftpSUulxlpTlFHOY7p9H3D5f6F+o3XlU+kaNrmLQEZFnxRPjprgs3cVkOXR1dzLFEgD9D3VQ3XcD4ZiVgmVjGB31tJrDhIXAiRcXbpIj/oCpZZzwh9/MU6p6dDjxmkg0C+u13cGRys+AAyq1Zoy0q7gUiVA6Jm2NGbetosxrJoUWTuufG/KKYJku2xCfGKJOPE0Ndcz+/QfFmPnB3XxkqIKimzOk0Um3PzkJd9F5/JWUDyIubrM7rszL9jgeOgqJibHlRylKpNJQa0xg+7RkyhTTzzWVPbbLDA9Dk6+tQ0hW/sv4stXQZ2hiqfGzIeg/g6RNYLpTvb03C+z+jdiqURn49ZLakRe9p/w+2MCzNBkTIcwORmTi8m1MCMs1hkmBvgAlV7OsYExt8M3g7HldJmhScqGdXYb9tPoy8e8ZkYEMBZn+mT78l8451RrWa7Ti0UKaJtBTX/LHznpABx8V2x45VmtcNGsX33N35uhPjqpautPVH0BFpsJBCN4XEePCdqZ1KnW4YvLmgu4FM5cGntNoQyl9wlgDhR5BpjHeR3e6bpbaDTuy/cDQqni9rJbFhdMoUmk0np2hjd3QtfXMrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 22, 2026 at 7:42 PM Huang, Kai <kai.huang@intel.com> wrote:
> Not sure we should change that too:
>
> struct sgx_encl_page {
> unsigned long desc;
> vm_flags_t vm_max_prot_bits:8;
> ...
> };
>
> ?
Hi, I'll include this in v2 for consistency. The :8
width is unchanged, so no functional or storage difference.

Huang, Kai <kai.huang@intel.com> =E6=96=BC 2026=E5=B9=B41=E6=9C=8822=E6=97=
=A5=E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=887:42=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Thu, 2026-01-22 at 13:54 +0800, Wentong Tian wrote:
> > The vm_flags_t type is the dedicated type for virtual memory flags.
> > Architecture and driver code should use this type instead of assuming
> > vm_flags is an unsigned long, as the underlying type may change in the
> > future.
> >
> > This follows the cleanup in commit d75fa3c94750 ("mm: update
> > architecture and driver code to use vm_flags_t") by converting the
> > remaining vm_prot_bits usage in SGX code.
> >
> > No functional change intended.
> >
> > Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/e=
ncl.c
> > index cf149b9f4916..814edcde225d 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_=
vma(struct sgx_encl *encl,
> >                                                      unsigned long addr=
,
> >                                                      vm_flags_t vm_flag=
s)
> >  {
> > -     unsigned long vm_prot_bits =3D vm_flags & VM_ACCESS_FLAGS;
> > +     vm_flags_t vm_prot_bits =3D vm_flags & VM_ACCESS_FLAGS;
> >       struct sgx_encl_page *entry;
> >
> >       entry =3D xa_load(&encl->page_array, PFN_DOWN(addr));
>
> Since commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") already converted one
> 'vm_prot_bits' to vm_flags_t in sgx_encl_may_map(), this looks good to me
> too.
>
> One thing though:
>
> 'vm_prot_bits' is later bit-ANDed with entry->vm_max_prot_bits:
>
>         if ((entry->vm_max_prot_bits & vm_prot_bits) !=3D vm_prot_bits)
>                 return ERR_PTR(-EFAULT);
>
> But 'vm_max_prot_bits' a 8-bit field of 'unsigned long' in 'struct
> sgx_encl_page':
>
>         struct sgx_encl_page {
>                 unsigned long desc;
>                 unsigned long vm_max_prot_bits:8;
>                 ...
>         };
>
> Not sure we should change that too:
>
>         struct sgx_encl_page {
>                 unsigned long desc;
>                 vm_flags_t vm_max_prot_bits:8;
>                 ...
>         };
>
> ?

