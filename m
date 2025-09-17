Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2CACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1758E0026; Wed, 17 Sep 2025 09:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A3E8E0003; Wed, 17 Sep 2025 09:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0894E8E0026; Wed, 17 Sep 2025 09:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E47318E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:56:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A90AC14019B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:56:45 +0000 (UTC)
X-FDA: 83898892770.03.B47D527
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1DC28000E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:56:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oTCftJ0i;
	spf=pass (imf02.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758117403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AEMbm9j4CeshvjtGmvTaFxMhMVyW+S0748f965m42aA=;
	b=EoBhlUeRfFuej996v3spDLTxx4W/muFkRaAiLpkaCJo2PWa1mt856qJm1QdukXR4x/1s7l
	aR0wNHQmjeopQx8XcTlEFn0OLVYwkk5el+9BXVtTCYdbiA6j7KLMXTSitIsz70daHmLfgs
	9E4kpDPQ3GsRf2uDXeipFsEBNjYx1yA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oTCftJ0i;
	spf=pass (imf02.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758117403; a=rsa-sha256;
	cv=none;
	b=SZbI8MKSfrLLjYxYHery+f1E3iKRM3MIsgsz1I1Y/z47p0XtRk6lmGVFy7vCJUS1yDsuW3
	0MrA2UFWhmDnoARWQ6ZVCBZWhfgxe7x8sduXdOGxZbD0grmObTgoIzu7RdqpsAHBBdr8tO
	fW3rpO5XRHDQotl0cCV6AIeJYVHdN4I=
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-424122baf43so250405ab.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758117403; x=1758722203; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AEMbm9j4CeshvjtGmvTaFxMhMVyW+S0748f965m42aA=;
        b=oTCftJ0iyXCH1avuQRz3MnkXdcAT29fF015OImKpn1/3IkAIqyfcArkB4rKkZ/GEIx
         PuHkF38cmnB0DpiP/m/a+KqOhUKfxrG4b5ok9KeOAFK1ESOy/ASzbr3mMELnE8al022V
         cKYftWIZS15fLyz95htLlRhuR84plocGVZZfijIOiJ4ZLqKDM18aEvY4hD3IGKz2Zl6q
         pUwvhbCd9j6z8aiTfwffqKnAtndrRMDGeqRaQwDZOYwShgWJf+UZqUNaUEuZwt4WP7nz
         u3jNu4diHJ3TVxIr3+w4AHm7aMNOnP+vZeCGXZQBMcsR0g5WPS406jV9Kgh6w9gPSdgm
         dUVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758117403; x=1758722203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AEMbm9j4CeshvjtGmvTaFxMhMVyW+S0748f965m42aA=;
        b=g/pW6IOZntGTODQ+dIjFYcUktMSpznHRlobwQ1ctAJEZGdNsSDrMHLUjXzLnWotldc
         eC9xPrFgoIS1DeG4lRf/By7AiI774cDaP0M9J71Kpchl+5Dqnlcz918tOWSlg/bIGaST
         SbdffycGqe/czvm1/7Z0QL4GT8XlU3nSmMowkBxk/0tUOicUuoRY1tFaz+R60JC3y1Sz
         BPNVJNDZ9m9zLKL2e/vVlSqPsMtxCfuL1kGh8MHgb+4hTdHRSIJk1GyQ2iVZXyQ21ZqT
         5TjxChDzws+a8Cxr+pRgjHUtIT0xhneMOLofAd9wGk94pL5U0FxQyEKOvR6s+fAl+I53
         a9zw==
X-Forwarded-Encrypted: i=1; AJvYcCVY+0OrcoY70WPIyirAHPL4vnoH0VkrVVWpTriYeTmlf559TYvzEDaF1eC8vuQPAZTrrtCU+XNbog==@kvack.org
X-Gm-Message-State: AOJu0YwaeBAAFj0PVYUCF1gwxYX7kwpQ90+8kO6pyigKXo/+uLb+sYAb
	0rbFWgxjpnFd/CGkPOQL+UPWL4Opl/GL+IVaE9gbmhYOpzI68NrHZvf6gUgj+7syDCEg3f5R5TD
	OvLwCsh1wkaxNaYTPkdEX8/EKPrSuScr19pInXUF0
X-Gm-Gg: ASbGncvPL3lTDdCw0LYFDAhFKE0N8cXSvLnB32ZXUQggd6Jx9VxlfqCyL0SReGEWZab
	CKwpD75+FQRkMWrg4LRixBRwv20REikMaWymMXJP3Q8lDK7TWiSqq/ScGK2fnuXoI17XjUdJmwL
	bQZkDcIR1dJJWch+dRCazUssjpIUAt1IzJ2iopIBKL3sZFR9XdrpB2uKaSE6LXSaG4eSK2A19G+
	309XMISWHAUEsI=
X-Google-Smtp-Source: AGHT+IH54lOo5tAxFPzTKicKk8Nsp5PjK919P2Qv1+RMdVTWh/6suOqv/WwtVlocAeLMNNVnJWcFQzgwmq8811VHRig=
X-Received: by 2002:a05:6e02:12e8:b0:408:1624:b2fe with SMTP id
 e9e14a558f8ab-4241972e618mr4622285ab.19.1758117402484; Wed, 17 Sep 2025
 06:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <v5ivpub6z2n2uyemlnxgbilzs52ep4lrary7lm7o6axxoneb75@yfacfl5rkzeh>
 <ecac1e7f-1709-4348-b8ff-fa1c0f087548@lucifer.local> <CAAa6QmRaiKB2OOpZYjRx3EAQ+d8_G=MsVmV=9cc_MmHOYsikow@mail.gmail.com>
 <j5pf6l745hp4r56fndlshzcjpyi3nttgywouowhmfiewx6p56j@b64l6tmupykt>
In-Reply-To: <j5pf6l745hp4r56fndlshzcjpyi3nttgywouowhmfiewx6p56j@b64l6tmupykt>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Wed, 17 Sep 2025 06:56:06 -0700
X-Gm-Features: AS18NWD6_SfLOiTUQ_UY5m4VYnC4sMHbvOvNHRcK4iL_zjl8AWSf_Ml8a3TyFUU
Message-ID: <CAAa6QmQY=0J=L2=NaYfwHeqV=JtknA2wwPvNJBvWreq5GXXv-g@mail.gmail.com>
Subject: Re: [PATCHv2] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on SCAN_PMD_NULL
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1DC28000E
X-Stat-Signature: rmjx8suq4qp5sfqggr53npxke3z6xhnz
X-HE-Tag: 1758117403-477251
X-HE-Meta: U2FsdGVkX1+Xazd8tMdIuISm11gc6h1RQWMMI+Jp74IQYCv2cxx3mWRpVPXtyWeKul92LV6VP6gkwEUXRCpxWAQIEn5sCaBA9ZaTXyiUI6DvjQ06yu4s+VIEUCSIq8vpIUtqQKoCoqZhHqITdi9XyQN5DAZMkLOn5hgt9AGMV9EVmQc0v4jXutU+JtJwjH+mc8ZiO6I3bIdDsh5ZTZjN5spZZ281WYtgJ2ef+lKuniHQ2qHFLODFM+/7UNfXZevfZT7xMfqxKQO2nEFaw2AkQUhCSwSsuE2OCRUTAy0u3dYcmjAVAfoFmeNj5AX5mnskSDvYfQRwDpZVzhAGU2Z6GFvCv3JnUFUx7bRxE2l75slvCs5FO/3qZ1FHL4zj/oMpnGtiaQj0c4IKgu2Jd+2W6oECfZFS3rkZtC5YrCpi2zr2Ui0m+K2AgwyxkXV0GHF/ap4aIEsxeDSCChBRxC9+UJarM/D/L5/wJMsrrHFRBaaESSfabNEq3D1uzsdUhmRsdkfCaD9blWe333tAwhLUmsF3zoBbb76yIvLHBMEdPcFMzDo+v5FD/Am/Ih6yjIU97zdA946fh3x4pL7vcxQ1yp0O8wSA4fehprTcrCgauiV5LIhAmfErL/rkHnFKUc+tFCTDb9agOmg6tjXy4VMtF2ZTLnQp5r860w9zzOCpxJY966R7v4uZoGJZN/djRjdUKc1cmNFvqOyqlFOF/GLg4/0MmWjq6RIiV9iqjBpCZVBJnMAwQI6d0EQkU02NHgLnROk5Dldso74EzcLvTz1EAeTFg55XdL/7MkLtj8PQcnod6rAjUWVXXscLsmGNacATXYHACndbzQTbT3W39QDWx8nplPHQBZ7eCREDW717J3vmjfwpXXj3O9h2X3nPONXQbS873NsD167PvF7SVW352DZWXH+xQVUN1OXz4+DQsMTBQR/GOi0VBgV1q/IRFmbgkdJFs7Yuw9XQXQ+7Qm8
 W1fTS7Ks
 Nhu4Onw/mIxIYN/yJ8QG2jKXFqRgeOsMeQs1AT0vAh53+QhTxoSu/pR4nnW++FGcYqaUZNxdDrGkO+G8r3EBCA/zM5mW1CF62MeLS5Ptl3rb8fqXKWc5dpyqJY8q8v90m+tXzlOAHOp3cu3mDXRn+PRNHeN7e7Ix9Fe8d+Qx/YL6aB6xH0mpublttfaXFWAUJluFas2tkOltngjbRUlyFyaUbXnIyKay6qR4v81mMXNeIOYw7l5O8bqDgW0brizcBgSOZw+yPYDA/7mk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 3:52=E2=80=AFAM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Tue, Sep 16, 2025 at 11:06:30AM -0700, Zach O'Keefe wrote:
> > So, since we are trying to aim for consistency here, I think we ought
> > to also support the anonymous case.
> >
> > I don't have a patch, but can spot at least two things we'd need to adj=
ust:
> >
> > First, we are defeated by the check in __thp_vma_allowable_orders();
> >
> >         /*
> >          * THPeligible bit of smaps should show 1 for proper VMAs even
> >          * though anon_vma is not initialized yet.
> >          *
> >          * Allow page fault since anon_vma may be not initialized until
> >          * the first page fault.
> >          */
> >         if (!vma->anon_vma)
> >                 return (smaps || in_pf) ? orders : 0;
> >
> > I think we can probably just delete that check, but would need to confi=
rm.
>
> Do you want MADV_COLLAPSE to work on VMAs that never got a page fault?
>
> I think it should be fine as long as we agree that MADV_COLLAPSE implies
> memory population. I think it should, but I want to be sure we are on
> the same page.

Exactly. I'm always a little embarrassed when telling people about how
to successfully use MADV_COLLAPSE, "oh, but makes sure you fault at
least one page beforehand because of ~reasons~"

> I also brings a question on holes in the files on MADV_COLLAPSE. We
> might want to populate them too. But it means the logic between
> MADV_COLLAPSE and khugepaged will diverge. It requires larger
> refactoring.

Yeah, and taking a look more thorough am perhaps reminded why I didn't
pursue this yet.

> > And second, madvise_collapse() doesn't route SCAN_PMD_NULL to
> > collapse_pte_mapped_thp(). I think we just need to audit places where
> > we return this code, to make sure it's faithfully describing a
> > situation where we can go ahead and install a new pmd. As a hasty
> > check, the return codes in check_pmd_state() don't look to follow
> > that, with !present and pmd_bad() returning SCAN_PMD_NULL. Likewise,
> > there are many underlying failure reasons for
> > pte_offset_map_ro_nolock()=3D>___pte_offset_map() that aren't "no PMD
> > entry".
>
> Sounds like a plan :)

:) Frankly, I don't have cycles to tackle this at the moment, and
unfair to push the work on you, given it's non-trivial, so can have my

Reviewed-by: Zach O'Keefe <zokeefe@google.com>

For this patch ; though Andrew has already taken it

Hopefully I can look and sneak improvements into 6.18 -- but wouldn't
hold my breath.

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

