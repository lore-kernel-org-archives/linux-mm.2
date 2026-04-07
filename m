Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B17FEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EDB6B0088; Tue,  7 Apr 2026 10:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF866B0089; Tue,  7 Apr 2026 10:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE7C6B008A; Tue,  7 Apr 2026 10:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F21036B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:19:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B6D6E23BD
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:19:07 +0000 (UTC)
X-FDA: 84631966734.13.750E496
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3ABF2A001B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:19:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JhSaNTNM;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775571545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH7dFq7f1INYm9K7IYaHG84sZj/ZwJzM9/9IHu+cmAg=;
	b=oQtcSBqK9hy38dI/AkMwXBXqHC6q5WCpJISTPQ3qTRJ1PVQVPNrF9CWr0lpOvkXx5MQd/V
	e0CCzNlbcAnSDnbOv9Y8UV8QPCCZheuijyaY/TZmjs/4j/bVW4mEAdSgz7BxXI0VtsheTR
	Gt1cm9ofjIYzDKR0yHhqA5Ak5J24+Zo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JhSaNTNM;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775571545; a=rsa-sha256;
	cv=pass;
	b=qVG6vYiLhuqUKB7spWk3mZcmnXAorwEF/ask00k3uaAUIJL2j7h4gIJBh7/t2n81EK8wTU
	KQCRsWJRm69j9dbtbwa8rR2H5EIYz3iZJX3tYLp5oPxrFWksR4kFt6VZXyfPtqMkNf5Mq3
	46X2T1ZpKwU42IKIgJgM1O4CpRYb7mk=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b7cf4a975d2so630257666b.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:19:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775571543; cv=none;
        d=google.com; s=arc-20240605;
        b=TzpSLgjHd99FY0GyDgQGl7JpfGHfcSOe6VlQ1qaUr8oCInsxYb+84/8KJzfPhS5qLo
         edAwdCcv+kcLyC+sToMCKPuwCGlgZYzq211HW6pkDbKoKncfa+8zZA52/FRz4yZee9AY
         GdPMhYolSZRBEvwuB4ZOYjyL/0ouPn5JAkctLmEGE0SrR/AZJIhFIL+MR5/bHTNDIYDH
         xKnUHcRRk8WPoDraUiB873ogdtbMUQVTXFBFmq+oufmm8WH0nUyDjLaLdg90F3/Z2LvN
         Ch/q2f3Ev2mHfxz8iIZhgqkYEHONzvQAz7OhKfVSDLWe6ldKZwtQJPoyizbjlhDax7ET
         542w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PH7dFq7f1INYm9K7IYaHG84sZj/ZwJzM9/9IHu+cmAg=;
        fh=cN3jLOng4c3iDfZneS72fCztfX6sbdJjl5FpyZxnHMg=;
        b=eITrxunae+NQ0ovRVL2XL6g1w88aP70Zrqf/cBrjG1NdfGtDihCmxGZPfR+/ICCa6q
         1dTi9FC+R/+tREaQbotzzyJjcpeWkmuyECz+DdEc+X6o/0D1xrTTfSTMAes3JSwIJ8c0
         3EG+CgeLV8CgpDXCsqjT12BCgi6dpQGybkFQ47x7IaiBRLo1+PfcSdam/brV3TxWbyBa
         lBb1MfTxt89ycyLEXJewW8ziz5Ic3elXHSsBAqFjVgPSwbaEUVbC9AgUp3lKoN1l7wo6
         ERgBVZeM3h2EAN8pI6WFXGJxbBoAX9pR38M/N1xS4ITJThIUJDNbcKmxeRDQzwb40rIM
         Sd2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775571543; x=1776176343; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PH7dFq7f1INYm9K7IYaHG84sZj/ZwJzM9/9IHu+cmAg=;
        b=JhSaNTNMfbQtCR4orc8QExgvvl8KmRADBAZu2Db8Hqj9OOEKGVszmmE2rNOP+kRg8A
         AQWHSaHNROR1128TpenuSH3Bh5RoAV32HI/7XyiJ9WHN04O5pFm5NIfBowB3Y3BdHwA0
         EahkqtRr+RfICNGxJH4QLTEejDLWqgeILt5wEb8c0WQA7K7tcDcMd2iBOeka1YoxfiJB
         nJoTQjUGC+7A3jrfdGe+N57IyhM+CIdApBmRo4MblP2+eV4zzE7yrkczbM3bE7fdrHFH
         X4By4QSpKNZnMxS+fkiQOFwRoLvtR2uTAcLEiNTAajsEXX1BaxcpvHza0ZQgogeIJ3b3
         lt0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571543; x=1776176343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PH7dFq7f1INYm9K7IYaHG84sZj/ZwJzM9/9IHu+cmAg=;
        b=j1dPD0/RMxdXUCeabjnoZjka2vvJSFFXi+KDCL7edEt97mH1M3iJL+kPvt6KmNErRO
         Ft+TCEm3VAHg+HWFUIMgsKzR3JOO7zDF6QDFsjoYjqqOx87yihtQ0kbLKCMqSR+5gKYY
         4KxrZDtDtO1kVkmF/B2TpFQddc/cAI06xxbTaO2KDcZQiVtuL5y1NI+nHJsIkgC7M9co
         aT36tGSGbLT78WI7HMM87Y54nU//Jf0654WFvgqGDeaFWXh3yYHkh+xngdnOUUHBh5t7
         eSCsA2gBVGVL2eYN+fLqv3dvwshZG8F7Mrin5QqcqLL3X7bIkurIze1yLHYkgNr+QSPX
         /a4A==
X-Forwarded-Encrypted: i=1; AJvYcCVLYFDUr21IFx7D6aACNo7VII9+2dBrvjfO+2Qu3oct9gvT5D6aGweYTDp52Qt6FPEW60PLwFL4hQ==@kvack.org
X-Gm-Message-State: AOJu0YyWs2dPDqgf0se64k2L3Xcdk4EPG8rYsd3ZXyvI+zy8/q8FuHuU
	pv0sIhABNHeN/59AV7HPMxpzaglkkX5WnyuBEOmSFs+fyr87bog6YTm/PKNkcnc+hJnV3zjI7DM
	9bW0x4d66Ulr6GHdAnE83y7Ncz7iFe/7GNwlBOeSktw==
X-Gm-Gg: AeBDievaLLEHbG4fFOZ2qLhMEc+tfVo50IBY2860sBFXSitet+HcBf2nACRGYa00Sye
	mI1Nggzk2bMCF9JmEpwS2rVzzNyO8GV+zeNz9g1PpKixsyfsAKeeoG6sTq6ANEStJ94VJQfMKIK
	76u+Ci33oWQgIRF+JSYWYWprFscs8oxeUBjGGMdXC3dr22dimm0Aqohytxz6rxEiXNwDmO2aHe8
	2/cNzr2ExXOJV/HXkaiBOCMzRJDYHMN3Fw6oCGfcVKX1HolNGKKGDhax0jRjroGmnwghWcMF04M
	BTUicXu7MG8w/AAPDkDB+fFAL42i2DEDq9Zy92k4IkeeUEFe
X-Received: by 2002:a17:907:e113:b0:b9c:1a5:acb7 with SMTP id
 a640c23a62f3a-b9c67b4d13bmr511967866b.29.1775571543087; Tue, 07 Apr 2026
 07:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-2-mclapinski@google.com> <abptg2AObfxkkxKf@kernel.org> <2vxz1pgravke.fsf@kernel.org>
In-Reply-To: <2vxz1pgravke.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 7 Apr 2026 10:18:24 -0400
X-Gm-Features: AQROBzDxG3uqA6xycK2LUwqsWH3qLlD9BRFGhHVc5AlW0BiYM_p2w8BL8PV1yAE
Message-ID: <CA+CK2bCSoKGxfV+0QL46p_GqC=rj0YhcvP__bLrM2rVTgTNr=A@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside debugging
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Michal Clapinski <mclapinski@google.com>, 
	Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3ABF2A001B
X-Stat-Signature: 587ywfsc99kp5tx33w5r9qt7z7y4zepd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775571544-527108
X-HE-Meta: U2FsdGVkX1+SMwz9fUHY8E7uFphhilWU8Tf2/6J3GVK6Ndw4A97u3GOquJsbZ/w2Dp3cJ6hU/+wHem8+6h82N4H9BAgvMYv/qLi/Mt49ZsBIxtVFjfzk4q0zklZWRm+VCY6AxElKvW3gVubHuqA+xQfEoi9ZWcWSUN+EeO8TlcpeaBgRS6i4zgAofUh/eZCG8YvEyWiclwcyBxRN8pEGmbrtipNSZKCzUppdS5v1E4pMdTpjls1euZitEE0bzfxYpe57brwyEnSOK2Yp/Ej4AdqvfRpQebJTHvua+bEiqd/DHpL2jyYatbqQMDKV9wL+hUz3NPQjMmmgfwouXuGIeMgw6aSxc90qRUa6tcakIJMvY10cklAzgyD51AZUqv7yWk6uSSKwwbPHIO1COxe+gPxZ7DpLzAsmIYvBD1wQBtQ4WBzAe7GfayN8G1ecoRi5AlKyy9dT63G3DWgwv2lfsw/ArQw0/KmTWQZunwDHDzxvIdl8wIHgdU0TT+H8lVFx4McQFZAk9nOZ31otcbjn9e1sgFOSm5iJ/fITXxUrzuatR/RQnHm46jWHeE/RV7sRoUqCGyOKwQJp+txXW5cwKHsu+jaIt/mUPNz7wjpyfSiVyrylbiJKfj1alrAkNC09U8KRBISdkYK+IH+QVkfcWjfX+xWXlAAxeBkU4xtJ99lPHfDHIT4C+iDAN5q3u2FC0W0Ys9pAF7om3pMuRuwtZJWSlS5WX3qUKXayTT4aS1Abqf10quVhej5m1Y7JWx4r5TVak3QS2OqmbrDwyZ4ZRM0wX8ZzDdO7t2eSBsMjKrWorGuoF1PrGtfMn4e7R9ZmUPEp4RM6L1wMvUSa00hBcu9gb4O8iflj69eQWH4MRIL9JxAjirPlkxc4ZMeeXESzpeMhamDjFcmsg12Tg6BO88gln29IQT5O+g9yIwrQAEbRjVkeaWRwpiWqks2gZp0DwAmtp0+itziEauM6snk
 Tokwcesp
 yUBSCxkfNGBv/aaNwJMHIaGmyw6WEiQxWcfuFNiyzUL3uAm+FyyVlXYSQQQM9un5pGMbGchwr68NhrJLiIPNWDraW1krT3NwWK21jvw/FDmVnD3mI7Bn96vKdz/Aa1GczDIwvVmrvF6T6gA7BpsaIXPy24HcjgK/tyPkBgva/uF2xuGVvhoOkWSTLGVlhBGfnST84e+K7A4Nw9IC7LakN8KAcDCG51p4oH18574ukFBXbCIVvq3BBjdHq27GjmVZSHVJyEgsSaNJHj0UWGN3cUe4HjuYepwfeTNYgf/ynSyQrJVZzXUd05V1Q9yxlixM1/HblBHkZA+tPNGAWFjl+rMSIkIq3cNRS/wXSCzXTvk23dqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 6:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Wed, Mar 18 2026, Mike Rapoport wrote:
>
> > Hi Michal,
> >
> > On Tue, Mar 17, 2026 at 03:15:32PM +0100, Michal Clapinski wrote:
> >> Also return false if kho_scratch is NULL.
> >>
> [...]
> >> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> >> index d2f779cbe279..dc352839ccf0 100644
> >> --- a/kernel/liveupdate/Makefile
> >> +++ b/kernel/liveupdate/Makefile
> >> @@ -7,7 +7,6 @@ luo-y :=3D                                            =
                 \
> >>              luo_session.o
> >>
> >>  obj-$(CONFIG_KEXEC_HANDOVER)                +=3D kexec_handover.o
> >> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)  +=3D kexec_handover_debug.o
> >>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)        +=3D kexec_handover_debug=
fs.o
> >>
> >>  obj-$(CONFIG_LIVEUPDATE)            +=3D luo.o
> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/ke=
xec_handover.c
> >> index 532f455c5d4f..c9b982372d6e 100644
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
> >>      const unsigned long pfn =3D folio_pfn(folio);
> >>      const unsigned int order =3D folio_order(folio);
> >>
> >> -    if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << o=
rder)))
> >> +    if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
> >> +                                          PAGE_SIZE << order)))
> >
> > Can't say I'm fond of kho_scratch_overlap_debug(). How about we make it
> >
> >       if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
> >           WARN_ON(kho_scratch_overlap(...))
>
> +1. And we can get rid of kexec_handover_debug.c, for now at least. We
> can add it back when we have something else to put in there.

Are you proposing moving kho_scratch_overlap() into kexec_handover.c?
That would make it uglier to have #ifdefs in the C file. If you mean
removing this function entirely, I think that is too dangerous because
we have already had a memory corruption issue [1] that was challenging
to root cause, and having this simple check prevents this from
occurring going forward. The problem is that changes to defences such
as kfence, kasan, and asi are happening outside of the core KHO code,
and it is very easy to miss when something unexpectedly causes a
preservation from the scratch area, as we have seen this with kfence.
Worst of all, some of those mitigations use randomized or sampling
approaches and might not be reproducible on every try, so having a
CONFIG that tests it every time in a debug build is the only solid
defense against that.

Pasha

[1] https://lore.kernel.org/all/20251021000852.2924827-1-pasha.tatashin@sol=
een.com

>
> >
> >>              return -EINVAL;
> >>
> >>      return kho_radix_add_page(tree, pfn, order);
> [...]
>
> --
> Regards,
> Pratyush Yadav

