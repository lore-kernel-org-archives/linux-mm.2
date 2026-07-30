Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CB4C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 23:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15B76B007B; Thu, 30 Jul 2026 19:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7136B008A; Thu, 30 Jul 2026 19:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4476B008C; Thu, 30 Jul 2026 19:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C81B6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:11:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C7AE1602D8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:11:02 +0000 (UTC)
X-FDA: 85046990364.12.36F89CA
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id F123640005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:10:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGgABXRo;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785453060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd5vLDkGU0plOZGMPAuXeFegEAIEtVEvtYGsMIDTS+0=;
	b=kFrCEnY8JEU2g3C9OycWYaEqPGT/1PNHHYgzf6VBa+JANHZjlzO01jmncZUFbHy6jaX8qO
	aP1geJQ53ZIADbgMv7ztw4YKC2bY2GyRmJ90PrLzGte4FYVaEN3swN2lp+IWFewK1sXxTB
	P6SlW0DniYp40g0Hom2vP2PDESIRrG4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785453060;
	b=Oq/kdFAUgN6yaTNutLbW3p/zZuNweTNsjJDglG4UlKIP71EcDNYlYcGXDS1FYvZ651hO75
	fiC8oA6MN+JCMsfbthiHmxkEZejJRRJJee3guX6+xsHp56X+wyHfwDeoRJCR85tRR/T/eK
	QV17dUH3Sg/zOjgH3zgWojug8liiE+s=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XGgABXRo;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-495635a85d2so2421985e9.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785453058; cv=none;
        d=google.com; s=arc-20260327;
        b=cWMkXT+c2RDKFjcVha6Ge0dHJdqKsCFZxDsha+4TKOIK59awrHj7lfi4lWZfQamT0R
         QkJ41ZNQnu7wWqVSX/taEs6SRfik/9UTXF2+wOhV0+LccFXfS9hhoRrDXi9EcYPpTvyV
         BiFMYMyBXKIDzJ0DPFFOrcmbH449/p2cTyjGBjdxHlnsGmJEpXvPRbNIKjLrqUvy/6Gi
         vjz10VDGlFj6trsX4yB6a9St4Ho32KyjLSN5NdM7KyWrxXbB7WwK86RxbXzLRopYVwca
         HYdq3fjHAXsumPMYo20zvJsMdBJs67hAV/TpMxWsa7AK5C4JdB5xAOrj2KJ322Rqoi88
         QPHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xd5vLDkGU0plOZGMPAuXeFegEAIEtVEvtYGsMIDTS+0=;
        fh=1CrxQ8z4CPPqDR3solT2KG0Eas9xlQuC1AKFxOGSAPw=;
        b=rvJFwy0N44ZmJHUAv/XPReM+Q+6mPLsK6PeJptqYQomqO5Vfg7g+hAMc6icM/3Kaoc
         Huq7TYUbuSanVSEM+3udroxnV0os2CpNCqdZzb6UIE3TpArvmh26xqVu8wH33k1jCUOE
         LGxvtV8Zi5/jgNJaqLEPZeTqNBbvYPMH0PGCtJMSmsU65AJZDwR/U/YpBwEFiqrTArMB
         QBOqZnHQzff8R1Ue2LVlRGsuqOidyUadSiARScaTQYz8MQipGmNBgLopCHhCYOgmqXcL
         xs1BjIuc/qESlPt1L6LN1KEvdKc/F2qYSCcAvGS7vD8ztNAPzAWuM+dOQ7C6Se5Cv4h2
         B3XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785453058; x=1786057858; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xd5vLDkGU0plOZGMPAuXeFegEAIEtVEvtYGsMIDTS+0=;
        b=XGgABXRoU6fMp1w8y+valz6ce+PFfb88dpbfrWns1paa9/cRMHjsTRdcPKn8Cl+mUa
         rP9bBuGvzyxCVM6DZO7UwKn0KYQdCJbGJQzTkepfNIj0WZMlGgYbr9G3R35TKT6v76KN
         Cw6T6cDC4nAETKyhLLmo+KtdEu9K9GfKw36h7P9PVQ0RVu4+CZ3fji5NodUZirU4m17w
         23CsY6t9Yj6TZCK8Zv6DCb+M7BL55inWgZial+Kl8r18NTmByjsllodhNnEjAzPxxZH/
         lI3YUEaGAKs9wkyVT++VAQBVeDUc8svKPukKey63IiWWfsBiyX+7grLpXygHHRctUdZS
         0qUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785453058; x=1786057858;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xd5vLDkGU0plOZGMPAuXeFegEAIEtVEvtYGsMIDTS+0=;
        b=d25uTYbyewuzOIrwNxYrRw9ul4D6ZsgdcWe/5shyE7x90J/DOdLST9PLpScD4dAI1t
         hsPqgBpUWGHQmLmDx5tP9JfGAMwXkHSe0TvI/y63m8thtiyiG+cUhc3Des+TgUz/SiEz
         XBgJCddD17bxEP3ocpF2VjpFut0AzUPikCTRw0ZJsVdpK1QyolmFqT3klwZH2QCXhYh9
         JxdosdVvzhJ5625/xZR17hMt4k9YAb/tSMCrsQkHUHOUFhfvNUlWatniweqilqOHusRk
         vEQ1yh3FORzs860AzaBSsVwOpoK5aBDcc2yJPviamvmUXA3abfe0xPwV1KqlEoscptsO
         m+vA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+aVI0V1QuBTz4zDxHaEcJwfM24fTpMe+4uAAphiAewt2DsD8i4VZzS+oX8kV7K/8wttW005a0fw==@kvack.org
X-Gm-Message-State: AOJu0Yy4yGEDoZdXPjNYGZKQNnqaMHipLWOPYt59inOoBLIf4kEOq3px
	Y66yZ4jyB0pNR8g+ybLydu2UGIGGZENnxhCVdOPEr+dLr3xof4LanO2jL0Cs+S9ak3hQgMVP40e
	7jEKu9rnGe3w9zhOeDpPFAAwCVDWxY7I=
X-Gm-Gg: AR+sD10xrjIN+t7mpiy4a+6laig+6cdKBJQO3B23MDpdAOjbG+JQ3ikcgJHipBw0oZW
	Mmwm7N97q6Eq8HcKjj9C/BFS9VQTMjx6Z5uXiadU2qPgpBofiQeYcTVAUCPF/li4QM6mG2HF62E
	R1ERFvTQyOBidq8Y2ksVkGAxzpT9I4B9bjUgtL2lmR+AJIIlbwJH2m5l0EpuRCS5FzVlTW3c15x
	f8Ois5Jhof4DNAdCOBuzy/5Ch7qyUk/Z4rPwKx9KCM8IKfhjEEGoPtYwgKhgv0L4i0Z5dKotFSV
	POCZKNp+4UC+0HKmCrxuLL6igNizHwCOoarXDNHh1vtol+rDAgHv1OUQ8okuMAvXuOsr6i4Ap2f
	R4YD5WqDcTqrZbCRw2bnbT7eX
X-Received: by 2002:a05:600c:c05c:b0:495:6060:d6de with SMTP id
 5b1f17b1804b1-49800ece23fmr43508145e9.31.1785453058373; Thu, 30 Jul 2026
 16:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <ad31d36d-ac84-4053-a5d9-e18c346f3908@kernel.org> <CAJnrk1Y-4-_0udtGKeva=f5=xYRCWcyCnBA_1aVQ8oUZRKGkAg@mail.gmail.com>
 <411318eb-3156-4e5d-9e11-4c319bb9e755@kernel.org>
In-Reply-To: <411318eb-3156-4e5d-9e11-4c319bb9e755@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Jul 2026 16:10:46 -0700
X-Gm-Features: AUfX_myk2dUrnprBBbtBc7KG5m1PqaZut-_Y_pgsqKv13103U2O0vsO7thvG7ik
Message-ID: <CAJnrk1YBG7bT6M=oeEPJDo7A_bXakpN-Vu_Cm3awhXQv_6JmwA@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F123640005
X-Stat-Signature: 79kj6ujdzpssnjn55ft5jxk4eegsho71
X-Rspam-User: 
X-HE-Tag: 1785453059-674756
X-HE-Meta: U2FsdGVkX19C6slTmaVFxQyid5xFUtGgzTeXilAoIv8d2r9oTraw2+NrbOeIuXzE9m8p6zx6uStkaJjSi+eJEjPYVHSf8b8k4XhfM9QSAD8XJHZqHLruid6UyKrcoO50+j8GdxhHXbHqgk0XYSaQGRkUUBT+RB0V1XgXuHmfjDea60ZO9q7OfURZfEfr0JYhpBzGF5zTTaF0Ci1jkWk/wy7tlcJgzD/6FG+LZEKAV1cqgRgGhW9M6Ak9OryMxkeqgCuYY0kO6Qmdi/FKfcp6EzK1g0VHg2MXh0f173WWMa24ZtfFClVUMGqfjIbHoTOyCm2OjyQTVACZaDPRYpy/D1M8UnzatEY1HsJ90hvqMbCF1EZZcW8aMEqBslhXY5LyfWD9rtjbMtWZ3mY4b0ftoAK6Di+by5gGqaZORJjc6azJVkUrgaGzdX0RVL8nCv+/kVenc2ijnFwdQQALXmE0kSuup8zfrz6URU4QbR8WTyujL+WcBQ8OoLyh+UJNWuWIMadU9BwR0Ri5bAyPDU/fiwPUu4/jK9BdDcSGd2O5TwUwYl5kpi59yOfFLhNVPW9J5z4Ykvpe1wP3jJ6DOrPWNK5wBLqYr5WBhfHaP7/aqAG/xFi93jktnSzJhY6fq0FmTrrzsLxtBKFt94Of0AmHcFueuEyknOrRQtPgekwH+PIVgJjDmnuDy+FuKW2gfLXGtr5O2mdnDtcQfUvBXa6GbW7smaetuWHVwMsjTgP0u0kBo/uHPQn8viVzFbINQHXbxNmbjbbfhOUCasCBrMY3C2pgnwNx7cUXNhKIfi5xXkZPOTHnYu4fLA1wecZWJt4l+F39v0fDQCAumIA+IMy5eouwbnaAl3gmTAgXfrMjdmbxmr7MCOVapAcBN9+p9PO3fXBsH6W3J+/278/bLOTSoF8l6ZAWg6b+P3YRJLi4Ex7wTuaJbTFRIaLhiyUTL3if5fauXAqtF3irafk+XuB
 JGqZtpFf
 3ADiPxEHyi+WyFcyJGDPuHeaBGT6aSJiRfa604n+l08mq+EwCBInABkELvjKpuuiqldiB8MU/hlXz0/5mDbk99XV4f67Fw0i+RVVMuBbLMGV7/MZGmp7hgT4N4bF3Pe7Y1nQtrmirPGkNhtTRM5DDdXUGYwOr1OxabVWt4h6ENI2Amcwly2iRsA63jTO+5+DPlgGtwwHhmdTa94dcsM9HTmybAe3xg82ZM+ngRGPuQmziyLVaNztK/sFdkfsuFA683I96MvZAR6dgrCc6JkTVo0LtygWzQM8+Exw8Sx6IOdDpAiPoqFFinZuzt6NSzUADHMOU6PYLkAjjkgVljgxTgwE2C1pTfUx4hcYV2xeGydfbkBwOd3TUNngxkXWE99jx94MxVz+wz1w9PC04TtoUMzKidToFUzP6zyaEXSzQEQPtX+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 6:53=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/8/26 20:19, Joanne Koong wrote:
> > On Wed, Jul 8, 2026 at 12:47=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 7/7/26 22:17, Joanne Koong wrote:
> >>> PMD-sized THPs that are mostly zero-filled are reclaimed under memory=
 pressure
> >>> by the deferred split shrinker, but this is not done for mTHP folios.=
 At Meta,
> >>> we would like to deploy 2M THP=3Dalways on ARM (with 64k base pages),=
 as 2M
> >>> provides contpte benefits and 512M is too big. However, 2M THP=3Dalwa=
ys will
> >>> result in a memory regression unless the extra unused portions of THP=
s can be
> >>> broken down and reclaimed.
> >>>
> >>> This series has two patches:
> >>> Patch 1 - makes thp_underused() work for non-PMD-sized folios by scal=
ing
> >>> khugepaged_max_ptes_none proportionally to the folio size and using t=
hat
> >>> as the threshold for how many zero-filled pages a folio can contain b=
efore
> >>> it's considered underused.
> >> Did you look at the khugepaged side, and how we handle it there?
> >
> > I'm not sure if I'm interpreting your suggestion correctly - is your
> > suggestion about using the khugepaged mTHP collapse threshold in
> > collapse_max_ptes_none()? I had looked at Nico's patchset in [1] and
> > my understanding of it was that the mTHP collapse threshold currently
> > only supports values of 0 and HPAGE_PMD_NR - 1. The patch 1 changes
> > use khugepaged_max_ptes_none's value as a proportional per-order
> > threshold for mTHP because 0 and HPAGE_PMD_NR - 1 are too extreme for
> > our use case where we're trying to find a middle ground that keeps
> > mostly-populated 2M folios whole but splits mostly zero-filled ones.
> >
> > Is that what you had in mind or were you pointing at something else on
> > the khugepaged side?
>
> Yes, essentially that khugepaged does not apply the scaling because we di=
scussed
> it back and forth and it either results slowly consuming more memory than
> intended (creep), or ends up being completely confusing for users.
>
> So khugepaged will currently only collapse mTHP if it can either not wast=
e any
> memory, or is told to waste as much memory as it wants.
>
> Adding scaling here when we explicitly rejected it in the collapse path l=
ooked
> odd at first.
>
> I assume your point would be that just mTHP over-allocation (not due to
> khugepaged) could make scaling here a good choice, correct?
>

Yes, that's exactly the motivation. I'll make this more explicit in
the cover letter in future versions.

Thanks,
Joanne

