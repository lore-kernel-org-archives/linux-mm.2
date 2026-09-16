Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F2BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4486B0092; Tue, 15 Sep 2026 23:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4826B0093; Tue, 15 Sep 2026 23:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB306B0095; Tue, 15 Sep 2026 23:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02A626B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:27:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2236140541
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:27:53 +0000 (UTC)
X-FDA: 85218191226.20.0E4023D
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0977380003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:27:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OT/+2sfP";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789529271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpcV4akiuPw6ooaHeQwzYvlzeYD38qF2Fr1gPzg9K6U=;
	b=YUGlSZhx2nFA8D2ApiGYoezBIAJ4dybp2FxF1DMuoS32nJhRHQgDjq//+UevMP94q1dTpR
	vd6t7a9G90aFOXeXhe3ui2wSR2c+M/1TdkDKFTlY6ob5ATYFX4bxwbNRUJCicBpBCWToDf
	4asPh4oW69sZ5NoF2bVeIZ5ju+qmYKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789529271;
	b=7RRe8FTJ4j3XmkUTVdU+2jZjGvto0TW9pmuA27AXmE3OmaH2bO4L6fQvIb/ta6Yk2RZ+0E
	h4XdD4X3OPxHr/1PNDiZKRe+1XEOSiRcvUB8Sy74/kWOjoQ15V5TLndISeCbSisdVmfXvy
	W5UgJMSjw6WiVNIZmFbkxMJEaxR6hSA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OT/+2sfP";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910a0cefaso40508585a.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789529270; x=1790134070; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LpcV4akiuPw6ooaHeQwzYvlzeYD38qF2Fr1gPzg9K6U=;
        b=OT/+2sfPNRW+bI2q92TS8FODPsHCFCUS7UnaqJji4s2QknfoO8/GBNPj57/TGIftSv
         SHJVZNPbuoO/pIPkxPOh8IulROLBQT5O01j57nPkDCgcFTV7om281B2dkGrrZ1/23cy+
         E8TvprLDyxbR/5+rB7sulqD4idIbNoEWDZWGmhf7p9wlbyOMbSBT9b/LqoPhy1KKcSHp
         82OY4J6FcVJiv7IbHnkDaYC1a7zF72kpUZPZuE2LyFjfqkbcmMI3Z0M5sJzp8MvLJTMD
         AdtaycsXWLIzcHdSGrr2Oj7J9S0InigAfsJ6mh1ul+EYTKakg3hxTj0kwupmXsVsquvb
         sAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789529270; x=1790134070;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LpcV4akiuPw6ooaHeQwzYvlzeYD38qF2Fr1gPzg9K6U=;
        b=V2wAFvXpPwWAalmMpstZKaaydLNM8baiFmx/KeqM+6IeW6mNs/YM0rMCNBtt9I9e1t
         lzHdNWxeHsfVCV53GTrqrKTYzORTqNmAxzuSxtbCcXXod+M89dbkQdRY4MDTZ4BjKJuD
         9H0xNrtUSHBbE4mWGLoM56ani5KP3O1y+oYQr59StWJkYyC7lWIYd24tAxTi0buom/MG
         rNp+RerjU5qryNXeDn40cf1EHyK9jzx8DoB6mOkVwu63IfAnm0r5vCemPAPmFkG4eLTT
         c5vYOXK7qok3s4m5B4qR0zLfak2f/3bkqhy1jC1i2gcaYid+g9B2gxFY51wGvI6eBScU
         33zA==
X-Gm-Message-State: AFuF++mKB7gONYaKzT5lEGJLiY2D/0Yr+VanlQriUpQ8IcD+hQ/5sioK
	vqD8TQc5bCkRTpwyXeOriuMQnOCA/0ofiQcy5zBNgKjFz5NQchNJwPQcOdhkMnOztF4=
X-Gm-Gg: AYBFou3N6TA12SPhwzVhdKHMvlSMrmlOgtyfiBse7yWj73QFLwilme0ZngNPOKqHQxo
	sU4Bz+YzI3qxc9CDEDDjCBnhEFQigZKxZFPVFW1pFzGwfadpkyWj9TPXXfAv5jM9lgtBWF2HyMm
	yZkD5fmY9bhLN53/SSKBDd0zmZrn4eYzwbtT0xweb4RHQGadRwAX5stxiGe9gMEkwmMJZUrOAkv
	EBjkcOILvBYSvL6OntZtT0sfqMwY69ouxOuE+XFI3n/DNP+3SWQQ3jcfKGG2XDWgeuXsWfqVi2X
	vg1ZD7VgMN3IZ03jf4Js+Rhe2N/OOIQECG9fk3g0M3Duowjf16scqZMMDjTHk8zcthOgKQ8fE1+
	5zV3hh/9puKRvVEVEg2TbNDX808oAU3linZsZ05qE4a0Ubvjb5m+MoUiIsN0N35/Fr+nturj24p
	rB9eillC2jBe6QYA1SZ4hpK5HsC1L/gOK2v5ZhkSZXyHDKgofCcAJ6HbgWIaijjr37PZcTWmB37
	cYI2zA5SeP0iTBGD+4xItj83o7afvCUhqFpvZ23XNz963gPP+WHuio=
X-Received: by 2002:a05:620a:4512:b0:939:13a7:70f0 with SMTP id af79cd13be357-93bb770c2a0mr153460185a.5.1789529270091;
        Tue, 15 Sep 2026 20:27:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81d19df1sm115328585a.45.2026.09.15.20.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 20:27:49 -0700 (PDT)
Date: Tue, 15 Sep 2026 23:27:47 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/madvise: use folio_trylock() in the
 cold/pageout PMD split
Message-ID: <aqoKLlzgsMc7VwJ3@gourry-fedora-PF4VCD3F>
References: <20260912110540.3203010-1-gourry@gourry.net>
 <20260915184633.e2d8cf719e5eed186d087a8a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915184633.e2d8cf719e5eed186d087a8a@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0977380003
X-Stat-Signature: 1cc5iitugqj493bfahufuj8k4sz1oght
X-Rspam-User: 
X-HE-Tag: 1789529270-624149
X-HE-Meta: U2FsdGVkX19Q0OXBoYXVcb1D9uMSNymjoRciqrtFMi0PZoyhTYOX6+i6KZY9kBRFa5Qq0Pw1c02hq2OEwh00/xHgOzsZP7AMnOZ5mOVbJJ5DUcRaEtIYDfAfL9CiLYmyykJrhKPaHauT5rti+6afWrPUMLG4RnP8EKa9Y24IMfliN1ec4U3m3ftkIFmk60PJqGTYult7wCcSesOuyaSrMIK7KNdU/XxXzS8Kg1YSUSMCD+/efhIdoLoLkqVkS/b2dH/0N8no2hR/O7sfd7/tZuzHSOQj3jfINlYiZJa0tZOeQcNmVYPuV/LAjn2jDTpyzcyLaRjHhccQSnDICsIFhaiIgo9ccIaqr5whsf2QaYMWlmPjZv8chcNmVKEdSbunhd/IRqNKxVRO0vUHyeTvOgCTch0qHIRNcwcGESDbOjYNMlJeckgJCFcvS1WPJoZRdcNHV3bFIVYwSAVV8G4q/Byqi/crfZvY+KDMN9/fcz97eahKBzFrPWZinO1a/SrLXYqDwXiG+ePBtAgw2Bnfvho78lRAh18SfrgR/+FwFECwEUgc/FDMySYO7dhU6/1FrRwXD7GgGzEFJIjHwmGBhVhWOSvduBz9ArQ4j5sf8SBw91t60bKH/XFtJRvfh3Pl070LqEcu0+VzpH9rTu/Fs+leyYaCai8Vdhlat231WC7jwAWxEVBrvzC9ojxUzpT3nl0h606BLsYB6C5kKLfaxXiMBTynefe/j9695ood6uaJtxGbEfnulBVpqlcgO4xsuId3WgSnvIUzPhXb9pfTXm1RPAY/DA+oyM6No4Gt9Pe+sLkcsgsTXf/kL8s6DKuSJgM7B+it18ZMdfPXqAxt22bBEAkvV3yxH1YbJiH42uHQ0Ib3E+eC39L1qb+v62W1lBgfK75968fWT5YUAZ2Lse7BJ+HD6Dxc29HyY3fuSLFm/QQWQtfI+70PTvk5wQR2vravLNzmgNCGnDA+Z+Y
 18un6jC7
 2gjO5N1s9gjQVUGPTulp9qqkp4TLuwe40sZIU2QtwdA33iouX1AnGDdrl8j2623nbDcZ3VvyEcvDSh9InAM3b2+nG7kl5xtH8qWgPiFPNoc6KSuRpDg1t+qiFaRJe1wuLR3sm87P9QZSkd2AMxiA1PAmRLmTlnkB7b10W09qDhMtmQRkNYO8tk6ELedLOROALq78yyUIC56IJ8fMGVhEBCLXO3WRsfVW1KZj+nHeSbVONZqzGkEMDC46LWhKiuZSpzfyc6ulU3OV1TYMQJQ4amFGAzjrv73JU6LsrCCzwxhEq/FYuANFyIGqfEtrkGoGaGPLSzb4ICGidhou76dA9ssKKAM2PXqRaTLLeZTc8eU7H59YInKzV6M2Ds0Ps7VwPf0aWpBYU1F+bSLQKTHRFqdvKl+Xssirt3bk5w/59peFVD3CpTCQnJBY46ZAl+E5G/CcGjpaVTckiceZ1WRx4ObKIscN/CV7uFv3kpx3PBX880Rc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 06:46:33PM -0700, Andrew Morton wrote:
> > 
> > On failure the walker returns 0 and nothing retries.  The PMD path becomes
> > best effort when the folio lock is held elsewhere - same as the PTE path.
> 
> Can this result in more EAGAINs being returned to userspace?
>

I don't see where this can result in more EAGAIN, at least from the
madvise side.  The race is the same, we're just giving up and saying
"I tried, doesn't matter if i succeeded".

> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -419,9 +419,10 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  		if (next - addr != HPAGE_PMD_SIZE) {
> >  			int err;
> >  
> > +			if (!folio_trylock(folio))
> > +				goto huge_unlock;
> >  			folio_get(folio);
> >  			spin_unlock(ptl);
> > -			folio_lock(folio);
> >  			err = split_folio(folio);
> >  			folio_unlock(folio);
> >  			folio_put(folio);
> 
> Sashiko shares my reaction, "dear god, why does that function exist".
>
> 	https://sashiko.dev/#/patchset/20260912110540.3203010-1-gourry@gourry.net
> 
> Like the entire function, that random mix of "goto foo" with "return
> whatever" needs to die.
> 
> Anyway, please check it out while you're on a roll.

I've been trying to shore up the sashiko garbage first in a backportable
manner before doing a full restructure.

I would hate to rewrite this just to carry bugs forward, and clearly the
code isn't even remotely correct as-is.

The remaining issue on that link is the memory leak patch you already
looked at.

It's taken a bit to generate positive tests for these bugs and go
through validation, but I think we are finally at the end of the
nasty part and can actually get to cleaning this up.

~Gregory

