Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05DECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 19:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D738E000C; Wed, 17 Sep 2025 15:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4098E000A; Wed, 17 Sep 2025 15:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4FC8E000C; Wed, 17 Sep 2025 15:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C951F8E000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:33:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77B381A066D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:33:02 +0000 (UTC)
X-FDA: 83899740204.14.A13AE65
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A92F18000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:33:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h0GiTCyp;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758137580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RmLnlfE5wdqHFkwFJDCHGu9ac/98s+fF8hA4wv+ATE=;
	b=YGFeDQZXX1nAjTppTrSLcAAURtL6MNK6eJ6aC4MvtvmBbJnJGau2ahj0Xv8ZVFonJSYuYX
	1YhGLM9PNwg41c7SrmX5TBdm0RgVrRx1va4i7QSDmYiI8L7sQG1Sm8M2D+oXLqLFmHS18c
	UBp+JtCoOLMiPF1/sCRM4lI7F4LxPGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758137580; a=rsa-sha256;
	cv=none;
	b=3VY6FW0I9n8EOh9V+RwBkkOZ/eUCP49FAqoo7CdDYTle5shrDkv/T/d77iKNHsIcAnNxZ0
	NHtUS5igbaOAXOPlT5ZbpVRsGeyPpqYZqXKc/rRJ5Bsd5RtA7JPAAxn6XufAKxI5/hnwNV
	iaRRvE+TlbYarga9Y8no7xYzDsFWOaw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h0GiTCyp;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45f28aba94cso16375e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758137579; x=1758742379; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RmLnlfE5wdqHFkwFJDCHGu9ac/98s+fF8hA4wv+ATE=;
        b=h0GiTCyp2jqXQP0qpSQlfvRPO6EJRoyiVuRRTg6iMHBcks6lnzEYSFU5ie16vpd0N2
         q/LDQmweepmCmClrYSI9Br9dPLzcXDy6v5GdlRGcT8ibeUXTyONEpcSTc+J+TW905YQV
         o0x+eHat2bUmyYy9ouE+6jBpS+yFMF0F021nE9MDTqfCFTIQsPAKtJrovGrYlDc8ScCC
         wHL2SwPltPSSMpNumVDb4pVDqpmyGjUvmkJGuJtN/yaw3hqOV3NcuAVDF2pX0tPgH7ip
         IavUTf2FA5lLneTYeVxDLC33KC99WGB7+z+aFM2sCI3hlweKLSaPY/9rt4C7emEaKCIB
         W+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758137579; x=1758742379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6RmLnlfE5wdqHFkwFJDCHGu9ac/98s+fF8hA4wv+ATE=;
        b=F7cWUFUBQkGcIWTWqdPKnVhsH+DHkVRJyBJnIBXnJKuRl28EBg8Q2g0huWYydHd/LS
         nVcfJfx0NWy8mqV5Fy52Sbfx4RkQ/nVGfjbXq1M2hzbvA5AVtQ9adQuPBI06ZNdi3Ih5
         Nr2W1tDUN4vEiWQU0RHf1gEP8zhgwq23BIKr0c4rhUr/PX7u/tvS/Aeog2xbNySpQNM0
         Fl30dEGOPBcP26MlAOebdxdctyDXKXvwUDA+rxjHfn3fWW5jH7Ab/3Uhenuc+jE/3Tat
         bGiq6a7B2tBA01gLIoCADWhFf9foBQjDadgOboXHW7q+rfjk/HW04jrXEMS+dkO0Yu6o
         mkoA==
X-Forwarded-Encrypted: i=1; AJvYcCVMhYL5koXln4IaVvKHrl7PoAVFQY1iOq3TzFne0VDv7ywia1yS7OThwyFr8ZwcT1tH5w0SDAkoGg==@kvack.org
X-Gm-Message-State: AOJu0Ywr2rhB46dwRp94WEyiqjtVPQj8IpiAMR5s3surTTu1cTV9TR0x
	teeu7zM8u+ggs9Q54OHIaAiiUrmbTCd76Deo/Q5mGvH0Zn9RI8nOa4rVHe19ZiN02AjLlFi+US+
	TwJQY3gNEow0gfmr4QWc2I7OgK+HAXNa7chL6U60U
X-Gm-Gg: ASbGncsjdCpLaj3L1eRW/wxpYSQyn9DUIoni0fuowdjgRAKXSIHBD0iLW+mwkkPrA8w
	zbufAoeDUl1WX6XJjfDcyNDC1OOQJWrKSoyGWwGgqJBfLnb2qRJ7DIVNzmlMvn+4HPOW7KkYEV3
	mIqx0NQ8HqY9ezaRGmfVx/MYZbDlH145T/Y5kpAGnobvR6+2KvlSy85SitdVMkrMWfRiSRYL+hY
	x4i6vRZPCEUpfEAROSuxf/jkm4+z5quj/2N59GCfcYq
X-Google-Smtp-Source: AGHT+IGEb9fQVFGlEJXvdZv7glWzKfh9yb2g3ypJs/1z3YlFmIJ1fCW1zhKyPJig4x9nGqaEce6mvh0neogmq1REEMo=
X-Received: by 2002:a05:600c:4927:b0:45f:5b02:b0cb with SMTP id
 5b1f17b1804b1-46149490f52mr1528735e9.0.1758137578779; Wed, 17 Sep 2025
 12:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <aMiu_Uku6Y5ZbuhM@hpe.com> <a99eb11f-a7ac-48a3-a671-c5f0f6b5b491@arm.com>
 <8c3188da-7078-4099-973a-1d0d74db2720@redhat.com> <aMsDJ3EU1zVJ00cX@hpe.com> <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
In-Reply-To: <cd71fac2-bb9d-4e84-a074-2b695654e655@redhat.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 17 Sep 2025 12:32:47 -0700
X-Gm-Features: AS18NWA8ltNJ-1yAPEykUi8kpppNk1zprgJjx3ovrdKhQKA72C47t087_EGFCP8
Message-ID: <CACw3F52p45t3iSZPjx_Lq9kBn1ZGTDZsxk+iQ-xFA1zdvdqqrw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
To: David Hildenbrand <david@redhat.com>, Kyle Meyer <kyle.meyer@hpe.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, akpm@linux-foundation.org, corbet@lwn.net, 
	linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com, 
	jane.chu@oracle.com, Liam.Howlett@oracle.com, bp@alien8.de, 
	hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org, 
	laoar.shao@gmail.com, lorenzo.stoakes@oracle.com, mclapinski@google.com, 
	mhocko@suse.com, nao.horiguchi@gmail.com, osalvador@suse.de, 
	rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com, 
	shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz, 
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1cgwdsxyitqabgym7jyt69qom7cyi67b
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A92F18000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758137580-645260
X-HE-Meta: U2FsdGVkX18vOtMtwfRQbr0ytfiJ34BMRVqY4oC84q5h5LTXpLTQTDl7J3SBUC43PNx8QDChA9a/ROq4l617LiPxVTHDOIozxIYKyqUhwLShti+k3XOGXsYnxaQek9fRvEBhrfujgo6ITdnO0mco7kGdlSqnFH3HwO+AuZyE4kaPwSyTrGQeZsuIrs2mX9lJenmzQdR8s8CidoE4ikv7Ew9Tkem6dKFcYkFfqSoCwB0dLN9HIqSDaPLewsR2uvKbmJajNN5r8FEUmwgyixtubpPsZmrge05bSJHbT0iVdzrJ0TrgVGT6OoTOCEgAR++1y7NWAKEz76TwG7Q1qWBt5T4Pa2mc9vm+jK7g61jE+nVNLFo+vn+URFEEqbsWk/jv2FEncFJRc5x/xULUQqSh2I1zPjQaKPltNmtUe9Lo04WZ+0H9LtHSTiWvPsByrTgK2s5z+MsxQ4Gp20ZrxihqOT/23vm9yP457XgBKYVsu1hPeKBjaDna7EUdtaf5P0PNw0jP5DAex9dj+eUpvsUoCI/AmVR1OutmC5Nf58l7GAwtLr1YH+Yc10wXeOoKnSKcw2VPeOeoe4kPf2+1u7c44WBbml8reIGJ9xmNUCxPPg6WjPClvh1N36VLJjAv67ppeG9A6K7LoxDq3UsQpWEyCqnYh7ybkF4zrnVfAu1sTNxSCMDG/8ZXIXLMu7W1c43zmfLQofwqKgmN3le6FomA/XOnTk+lcbnWyCGvg4K8xXz8ODpAiLKnmHG097QYnl1H3d27bMWDUQaQbONbkOqeqcH/J/mcIXh28R4jnmQLaW29CoikNKg1vmQJek7852V1pmh+QeUeEQHtHfMQyQ+aiwGMEl5XlLJJ3piBIaHR+2cSGqHAwoi/kUJt0wSRP+h1jQjVfX67Y3/o1KY9xJXFSDFVCLIhkmSYvJQwsV2qzksfKbjaPOcS0jJRAJNm/DM3dekh8FfZ/vQP6dubKvs
 2klQKjmg
 93wwxg3ycgMuocoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:05=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 17.09.25 20:51, Kyle Meyer wrote:
> > On Wed, Sep 17, 2025 at 09:02:55AM +0200, David Hildenbrand wrote:
> >>
> >>>> +
> >>>> +  0 - Enable soft offline
> >>>> +  1 - Disable soft offline for HugeTLB pages
> >>>> +
> >>>> +Supported values::
> >>>> +
> >>>> +  0 - Soft offline is disabled
> >>>> +  1 - Soft offline is enabled
> >>>> +  3 - Soft offline is enabled (disabled for HugeTLB pages)
> >>>
> >>> This looks very adhoc even though existing behavior is preserved.
> >>>
> >>> - Are HugeTLB pages the only page types to be considered ?
> >>> - How the remaining bits here are going to be used later ?
> >>>
> >>
> >> What I proposed (that could be better documented here) is that all oth=
er
> >> bits except the first one will be a disable mask when bit 0 is set.
> >>
> >> 2 - ... but yet disabled for hugetlb
> >> 4 - ... but yet disabled for $WHATEVER
> >> 8 - ... but yet disabled for $WHATEVERELSE
> >>
> >>> Also without a bit-wise usage roadmap, is not changing a procfs
> >>> interface (ABI) bit problematic ?
> >>
> >> For now we failed setting it to values that are neither 0 or 1, IIUC
> >> set_enable_soft_offline() correctly?
> >
> > Yes, -EINVAL will be returned.
> >
> >> So there should not be any problem, or which scenario do you have in m=
ind?
> >
> > Here's an alternative approach.
> >
> > Do not modify the existing sysctl parameter:
> >
> > /proc/sys/vm/enable_soft_offline
> >
> > 0 - Soft offline is disabled
> > 1 - Soft offline is enabled
> >
> > Instead, introduce a new sysctl parameter:
> >
> > /proc/sys/vm/enable_soft_offline_hugetlb
> >
> > 0 - Soft offline is disabled for HugeTLB pages
> > 1 - Soft offline is enabled for HugeTLB pages
> >
> > and note in documentation that this setting only takes effect if
> > enable_soft_offline is enabled.
> >
> > Anshuman (and David), would you prefer this?
>
> Hmm, at least I don't particularly like that. For each new exception we

+1. Given /proc/sys/vm/enable_soft_offline is extensible, I would
prefer a compact userspace API.

> would create a new file, and the file has weird semantics such that it
> has no meaning when enable_soft_offline=3D0.
>
> --
> Cheers
>
> David / dhildenb
>

