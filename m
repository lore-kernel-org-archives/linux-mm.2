Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2948D39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253B56B008A; Wed, 14 Jan 2026 12:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C0F6B008C; Wed, 14 Jan 2026 12:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E506B0092; Wed, 14 Jan 2026 12:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 015476B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:59:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2FBA1605AA
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:59:25 +0000 (UTC)
X-FDA: 84331331490.03.D6B2B43
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id D2AFBC000F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:59:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZcNdhXS;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l16mAKGChN2PX3pOsEUpJwNSJXDy5Uc5IHVR3AfNsDg=;
	b=vVVp2qn2azxEG1k5Eyz9AE1UHV105gIEbE3wcLWwJwDOkTyH61q/MuvcOA5F9pSvq2z53F
	YBQ2qFNiAvuRgx4IFrPrNvosYKCFKocGyWS6+4vVibMhTFNwAXrTes5+kJc/hw7beL2Lcb
	0jb+N1xnfWOrW936hcwf0cTA+nyU6mI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CZcNdhXS;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768413563; a=rsa-sha256;
	cv=pass;
	b=NoBdqWUXeuZkVnTDFZZTIffoZ3YCW/JhFiYmio9xWg/t/UCw9CgRKOVndtWsCHMmOTlOpK
	X/SOsRUFBGTKSO0akSDkSkxK/Zx+f97KRrOzcckynmFsDGyvUnqPHJaMITNz5oqvVRh1Z2
	+kHh3tqbbhsseSDRxAuKwBP3njqf8T4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014b5d8551so14481cf.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:59:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768413563; cv=none;
        d=google.com; s=arc-20240605;
        b=h87zCMU0Awoqx4Wx1KDgcou/JH5OIU2v2z+8ueI/lxZEV4zN8G4LW+n3TLEZVIbcdC
         TM397RonSSkzeryU/8EbWq4FBycxTAwnT0hzZzVQAf0EzGTf7ZAMDDR5GaP6JyNu8NYf
         q/LojV/F1awlUS3aPehNCPpIQVOtZrzcabvn/0HpNmPQex+RIw+H744zRQ6N7TCesUKh
         sEkxmd7dGFuU2kj7VtQ//2e71vVxq92gfGVzjMdwb6+ccteN8WgHQi+S1CQKjMjM5On0
         UhM54W1q4b/j99GwZa55bB9JYv5ldmLgJZFwtJjaeM3BoUS9D3as/3gbO6vklasNJ789
         uUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l16mAKGChN2PX3pOsEUpJwNSJXDy5Uc5IHVR3AfNsDg=;
        fh=jGx9Vs9P9+R2YT7BHCKprcWGhwTxTS4RqxPXFwubkjI=;
        b=b3sOX9EW4qktvMUivFdlVRApHHcW1M4IyGcM+VHl0Unit7/nLsIza87VRg3bcmlGvH
         26a+vQnyuqPAXB8fAtNpkL3okc+ZMJtf61L06I5AojwrUKXO22DcExYeSEBca1z1mIUe
         ME+4QMBJjhVwosMmxmcj6oCdtjpc6Umitkh5sJIdNfVrv59+gxHyhsO74gLDVPDDmGfn
         G7FDlI/ALjZES3GsoNwzUj7wn+hgKTvTHNwgpBC1rW3SH89qwEppRo3I79RO6fpFTxHK
         yW0c0FZgfA5mprVtMifj8ekuF66MuMbUoLAG9vQBkKB0pI3wnxJjWMQ8qO8D5u+63MLs
         WocA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768413563; x=1769018363; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l16mAKGChN2PX3pOsEUpJwNSJXDy5Uc5IHVR3AfNsDg=;
        b=CZcNdhXSNjXL84npkS4S7VXuZ+dgUkkW4x60FVDDK8mt+lHVkqM4GQT57EtDj/0Xnu
         FIVaQ+CnztutV60SxI8aR1yr6RUwdkIVCBHvNJkf2o1lSoGyx7SCDsoy5AAJGkg5FBvh
         FTtoeGmQrHXyLBxAg7fBbM00Ixu+K0/GURoJX4jsI4M6Wqw1fp/q+LZN7Ao9WxZXKcBu
         GYu69CuaKNVn1pcpz1BHadEepY6sVy2rgMbpSeEwjmSOL7zMhk29mT9Mf0Ciw/8wodhW
         MgI+YQduudaqtIiRJypVuE137bCBLvxLti8mBfsdxOOYtrzHQzPA02tTl83f6X+08icL
         KtqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413563; x=1769018363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l16mAKGChN2PX3pOsEUpJwNSJXDy5Uc5IHVR3AfNsDg=;
        b=PT8PTtyapwG6ZRP+g243Aqve5aC23+kwmd8qyvDFZBBJJoyXmvkJ9Y4+iGGbuewTri
         Cy/GqF+Nr58cX4SE6z7lxfsxUY25ni1daBxLyKAk+BBh6I/Jfe7mqeLFR6lN+F32uB54
         TNUfu/1DjIb/DTXM3hWE+oRDB7ye431wtfuX5gIz/WeSMrpHR1YCAzy3NRkOEWsEjHSl
         I/ItFsyIRLx/nPg9UabB7YaldX0rraTv3+QhPWylszcTz/g7RMOgGqvtPRnN+SjbJeas
         X4fdf+i7DHbPIWbn45OiLD7mxZ92oWPr8xqEJsfpMwxRFq01D2ATV/19ESjwr14+nAV0
         zrtw==
X-Forwarded-Encrypted: i=1; AJvYcCVxQDfGH/IV8txpiyLu3W68CQOS7ElR8gyTvencoIESbeyys3r/przAa0FZKvsr29TW3RqCY9UWLw==@kvack.org
X-Gm-Message-State: AOJu0YzoQS7Tw3yhXyN3xNwpOtR1pVLRj84Jl0gwFs4RKvxSyDSZrku9
	M9RgZnFZuOILU1cV0h9PWBJS4rhoaG3l0tNBZYdUcZZnisRIfwpniRPSximqKP7UIZOSebeibwo
	K1Pzrn6QgBGtl6Cob0rx51WkbHwXcREniJ+Y+YMZ/
X-Gm-Gg: AY/fxX70bqkEb+b5jxdcztd7oHs/+p57twxD0NiBfZrnlX0Ut8/L9xna54UpT8IOZxh
	lb+UNQ/ofwMAgHomaQnS9S+Vs7ntmxEyvk6TA9/sVGFW/uIDp/sIqyFQpowxIobiwRFNNeQYIEC
	Gc6fFmi5URODcgSi2AKiu7FOG3sV0zaQz5SsnOSHkuorGtqURF1xet3epYel2twGnTBOVvHDLM8
	a6JrL4LyrGhkw2wltHvt+BzpjB5rv83a7nvzqGYwzrsZtm4Tqzd0DUt7aYSgC/VLIycZruQOup6
	18p6EGgIHGg3yTi5xeIMU77B4Q==
X-Received: by 2002:a05:622a:1187:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-5014821f599mr13933411cf.12.1768413562436; Wed, 14 Jan 2026
 09:59:22 -0800 (PST)
MIME-Version: 1.0
References: <20260113033403.161869-1-ranxiaokai627@163.com> <2vxztswoi16k.fsf@kernel.org>
In-Reply-To: <2vxztswoi16k.fsf@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 14 Jan 2026 09:59:10 -0800
X-Gm-Features: AZwV_Qghg4-9vnb6fryrTxvM74mMBwrbkqD9jDrCoYrfZdn-SMnNF6tTLNYP5B4
Message-ID: <CAJuCfpEwa=_fubhf5wBnFKrKpOgjyXRy94f2BDx38x_NALE_OQ@mail.gmail.com>
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
To: Pratyush Yadav <pratyush@kernel.org>
Cc: ranxiaokai627@163.com, graf@amazon.com, rppt@kernel.org, 
	pasha.tatashin@soleen.com, akpm@linux-foundation.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ie7hcf64789m5x7aiipmjho6nrm4meny
X-Rspamd-Queue-Id: D2AFBC000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768413563-885906
X-HE-Meta: U2FsdGVkX18MTkJnsNqjMQfQv4ab4EF0yZ3oFlMHmC84BKpr8H68aBXgvO9QFkqVRNu3AHCZkGxHF+kmqChv63Qz0cBBR1KYxW2ri2LJaSS1+HUCsedqzIm6B5ta6KkmhoM70uxPBPY8TfAGekdom0sKD3iH32I4fDE5ugsvgU+zoQIUnb1SvxL1Y7mFQYh7Urmxmf0nbShdTO1ZAGf++uK06Ya9eEWxiwZHOhHqV5nzLpM2dEfK//6TnIJ4AeYj2fP3b8KT4gbxXavY43/Of6Km3OjXC2EnBnEc7mqqh2m17xArfvB+i2d06TMKRhVeMi8CQFKUn0fW1jbL6GCEiumiq6o/ymCOCelRUfBv+2/qJ6D40u063GGQjZoi/qebn1RlQisW3DdmJsBFogCgBhtDFM8ZOHFAjfjNquIrTxU0rjr+0iNGSGPvdIRJ9eSSgCmxyMnpuBIv4k+8azPlv6eKa9tQ0eXUP6IIDPhEi5JyFcsxxamtRtOP2YFAR72EFW5MA9SjXjYz1izOXf6ABXj+u5F1J2jdm878fEdQ5BXJmg+PySAtE8kT3KxPwY6U4abKXoL5bWEkTztpnGi9FEsP9vyBs2pGwRVF5aG2Tyf9qb8Nm1WrBCJDyJFm6fW5ijyyGxeECNyTJMRv6LgNz0xhG21cUi+HActX6E36/J+gW/SILmGblTSQ+rWGgbZ+gqoXGPQal2S1WyVbq7ZMK+HWiSWSqDGMIuvlI6vG6LZR3pgBKlm7FVoh6rY1VIbhcN3ZfbBgXqBcBQZqZ5SobeN0SN1YW6X1pGNuONWVygNV3YoH45GFh75BnMthF//rzU5sJpW7vwDASvxzwHJyQWaH+4khF2WnBjPNZ5yQe9lUaHkd2PCFw2c2N2mltUfk3E7SGfnch3n2fqr4c8Mo4YIvc3pWIGL01wAaf+GvxlBqd+IXgegqNPhuytB/c8y6KgkuV1rqKvPmu0n9rST
 KVuhkyBH
 bEcpIppuYonR36COMpe04L6+JhfsdhDdm81Af1S5xtVJVOfG3wPxc4KDCxL9gtfPw6TWlEtO4xQ+KJK1BOe0rBvCcHCZB3pEjkQ5ljZWuSIlYDxCLiaChnqBtBk/sguoCMSADdghgIRsFYog5dWI1kR2figlf6I8/7b1jP0YwFhDsanHTKrKvNQK5ot8LdA5/3xZ0OAEGbEYBdb4HeC+j1rn9XVgzSaMsDzXrffIx+ptH+kkr16KtMs6L+PZg1cbw/oVKFu+WND5lOukoJb/fn98YBtg5kUIVmUBxs/aEArb6F9HACadDHEpPZP2xuTpUn2do4oCHpMUgzN8IoRuPvhlaRTsk78Nagizyv8t8jhpgUvrPRl0DrruavA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 8:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Ran,
>
> On Tue, Jan 13 2026, ranxiaokai627@163.com wrote:
>
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Memblock pages (including reserved memory) should have their allocation
> > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> > released to the page allocator. When kho restores pages through
> > kho_restore_page(), missing this call causes mismatched
> > allocation/deallocation tracking and below warning message:
> > alloc_tag was not set
> > WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU=
#1: swapper/0/1
> > RIP: 0010:___free_pages+0xb8/0x260
> >  kho_restore_vmalloc+0x187/0x2e0
> >  kho_test_init+0x3c4/0xa30
> >  do_one_initcall+0x62/0x2b0
> >  kernel_init_freeable+0x25b/0x480
> >  kernel_init+0x1a/0x1c0
> >  ret_from_fork+0x2d1/0x360
> >
> > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> > fix this.
> >
> > Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation=
")
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index cd6b3fb9dcae..2d47f2c50bd8 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t ph=
ys, bool is_folio)
> >       else
> >               kho_init_pages(page, nr_pages);
> >
> > +     clear_page_tag_ref(page);
>
> You are only clearing the tag for the head page. The tail pages are
> still un-initialized. Is that intentional?

In the case of a compound page we set the tag only on the head page,
so this is correct.

>
> What about non-compound pages (the ones you get from
> kho_restore_pages(), aka when is_folio is false)? Do we need to clear
> the tag on all pages in that case?

In the case of kho_restore_pages() we call split_page() which calls
pgalloc_tag_split() and that propagates the tag from the head page to
all the tail pages being split from it. However now that I'm looking
at it, I'm not sure pgalloc_tag_split() works correctly if the tag
reference of the head page is CODETAG_EMPTY. In summary, this patch is
fine but there might be a bug inside pgalloc_tag_split() if the tag
reference is CODETAG_EMPTY.

I'll analyze and reproduce that case. If it indeed has the issue I
think it's easy to fix it by creating a specialized alloc_tag object
with alloc_tag->ct=3DCODETAG_EMPTY and  make __pgalloc_tag_get() return
it if the page's tag reference is CODETAG_EMPTY.

>
> >       adjust_managed_page_count(page, nr_pages);
> >       return page;
> >  }

