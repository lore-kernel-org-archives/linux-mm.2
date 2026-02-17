Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99DCE9A047
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 20:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5E36B0089; Tue, 17 Feb 2026 15:31:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD196B008A; Tue, 17 Feb 2026 15:31:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18746B008C; Tue, 17 Feb 2026 15:31:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DACC86B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:31:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73C9516023F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:31:48 +0000 (UTC)
X-FDA: 84455094696.18.A1FB895
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66F3080008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:31:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eCoDDoXv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771360306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
	b=se5TGJbrOAML8wyd5RpBJ3yBmJKB0/WkDTnrPnOlBwvWG0IUjiLruVyNYSFUvmXieL6TJa
	eTJf6pzvKM7NAXBYDnaUJ82gF/5Qyt5mYJn96J2rz30keYD9OMGn1O2fOt+vzUKauAaE9i
	n4YOmMzUVk+8tg8eozzJRFHu8SOlFyM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771360306; a=rsa-sha256;
	cv=pass;
	b=UI6+LoPx0cc3HAWp4WDAZwaAPPFMdpFme+liZfCrATcg959KWfJTYhReQcCqvwhXh9AnEe
	B7Ym0pxZIAp196JW8A+t+1bp6DKMJTjkrp4JLHOJtWGucVm+B89Dboy2UVxSGAx2dYmX/Q
	yxERxCht15VTgqwXxpCfgB9GcGFfW8s=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eCoDDoXv;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5033b64256dso128461cf.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:31:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771360305; cv=none;
        d=google.com; s=arc-20240605;
        b=jfF6+AektKuO9Q9saYr8h9sP3D8BG3vWJFS63v/qqaM014KzoPmN5UejPChgukC6/f
         2LK0q1V8mdcxfeDvPgZj2yF8UE9ZXX3DvWqTgpzuUVJ4twHDQEAk7awOgY09VPlT2jyp
         k6ZVrLqWNpv2D0LVjD3q/tbZJvnrdBi7epaCzBmuwcZ/RC/74FO0eipYjlMCqka99APu
         B5lN+g+vKS+xQusppot45zg36sP3/Y7hJpwkj1uv19WqJTj8qrzMmIRqecC2e+yFTEeQ
         56mNUosMJR/QcssC38iTMGF8vjYLAP4uYuIA7x+LwL8twC77YJYvxIZ9J+tYkc/F716Z
         y5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        fh=5RFyMmPaO8i9s8kOopDSmx7A2oBT0tEwwO1+vzzmlsc=;
        b=kKpStos9yT5yNtZ4r+vExeSo7QcJrut7+YGHSGad7sv7RYnS0/Z+hsIoc/vvcp39dD
         IPgAWKSlBwiFZSrENh06ESgUkV0V1xUtjMwa8DuYH/SHwyJIO9KbQFu/Oly+XhYyFoFr
         glthflglm2LVnoUBu8LEQ79BZzSG5Jav35lJniuKddvC3rRbW+6sLChlR8I6S99Z3Qel
         Y1XQE/KJoLz5pldHUSMdD0d5U6HQS7CO+tlkGlIM+2NNhfFmrnuKNW5wBfxilpkFW/DW
         QwBviBWQHvqrn/lqV3n3lvPj1Q4qJmigO4Kcc4ARwUMNc883ak8O96IZ6M0VCVvwoCYK
         ajig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771360305; x=1771965105; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        b=eCoDDoXvVtpK3XK+2oQ8Utwkj9C3zTzBlHDEYVrJR5v0e09QIGoVRwg5hWha/OTlK1
         jCd9ovm3HqhaKY/BKnuAbWFjwKJOBMGlVuHg3cMmGN0W/EgHNuiDUb9kw94absztOdnE
         f++O6cjfLJEnqa63Ij6wQk0Kzv9yi51X6qwY/x6fsCfntb1kWNIMlbM/Kcy/0sLBgZdW
         CDVatnRyxoIT0jtC/feBbXkRbpjg2YGQki5I7+iLhsELOZo1iRlV0XgKQIobxfhLEhPv
         COPqo9Nzk9AZNWXLnGdLNIyeYvWIjyAtO9a3gD5Ngc7DiEI2iYkyC4JEp8mfjlqvOHbf
         Le1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771360305; x=1771965105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBuR5hoi+JIoThnLErWVLc3d8raQLXMxIFo7dRHtl7Q=;
        b=Tgm3nD/zSqEuSUCPnV2+mv9ZhDfYuMi2hxnyw1sUiNJj2Dxfw8r+o+pXzag4FOHaPc
         HwrjFXLdlIj55tge938+Nr875Me02CqmMX/OdZWgcsNGt9ZGP8jnemsVvy2QDZiQiVs1
         65bJ4rIXgIPqZf6Lc9vtODSKG3XG7uKz0xTS71zZ72up3C6D/8Sz78oyUds6CbhQVOJm
         dg+IXq0pYKXSgzLHVJBfRefMiOCcUlrO+LgNW3M8cwDrBKDUuLdW3KyEVpdSw+mj9rof
         fEC3BeAWHbU+PEhpIYxu97q+HD//DthQJwbidnFmzZWGyPTbKLo441Pf+PGN2iL3N3bC
         1hLA==
X-Forwarded-Encrypted: i=1; AJvYcCUeHTKIbXmCNEqQ22JPG8z4HIdAVNl6vfs6cPI3YJw5IkAhuQZ14TrWe2RiIC2KzzqMOoQFolfWXA==@kvack.org
X-Gm-Message-State: AOJu0Yw3YoSQx/+jiLgK5E9RmDgeOeBwFnjchX/TVCtxAFX5xGtfWGo1
	bYCv/nNbQacLylD14m1jMTidvb2Hi5UvV50R1Qux+29s2fQphEoBkyy+Mo6RsyiHstuEbxAsDSh
	6zxAh1MNIzGid7QuAxiYM4+GMmBxcwwQZXxcTqZB6
X-Gm-Gg: AZuq6aI6xrhiGL7Fk5QYerqGfVK+7gt0sFeQOCCgWSbksfpj2j7uOTAPSsl1duvZDEt
	7nJIMdcUiKru7DEOVMMEbPF1nkuGYzmLmHfI/kig2sQR5btDJSwuKP7ZtPrd44M9tugLi4yv6my
	z+mlEm2CwN8eFFavJ5UhHqaanzJt/u6lZWYT7aK4gcUywngqiaq22GtjHJ1aPr166D32Vl/Uruy
	lL82qSW3QJIQyMEnxWd0EshMz80XbZDS/qFdCLtrf4pTW3F3bOsf4m3tWw0YPOifzb/F+62mAxX
	CqpUbogEEPgNJaz4qVrlsDQ6k3KNFD+QBCxsTg==
X-Received: by 2002:ac8:5746:0:b0:506:9852:75ec with SMTP id
 d75a77b69052e-506cdb4c09cmr21741071cf.9.1771360303253; Tue, 17 Feb 2026
 12:31:43 -0800 (PST)
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
In-Reply-To: <20260217191530.13857Aae-hca@linux.ibm.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Feb 2026 12:31:32 -0800
X-Gm-Features: AaiRm503YYR0kTgCvbJHDicLagxX0QqBNRpofu84bYZnAbv1-xnaYHyLZPIeE6k
Message-ID: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: rd3xruc1xjhu4cgw9kju9u49b43mjw4d
X-Rspamd-Queue-Id: 66F3080008
X-Rspam-User: 
X-HE-Tag: 1771360306-893814
X-HE-Meta: U2FsdGVkX1/ENxV1SPke5PrnCYRwtwJjhhlMovwNTSt0f3U02I9jNbESJj7n3cDEOOURwsl2Y1bapd0mYKqIxp6WgzcUCm2I/vIq+H80glBVOeCKjkgmTVEAhR1qV269HtwboGftS5wwtsj443UpkPQ3Tn1x37+T8+skdKtMcmDJpCwQHwPIS3UpI+d6PxOoXhWzLkQBPi8WRuMe6mZrRAhpRHgQWJdpMFu6i5V15I74Ux6MwJ3HxPQsuJLWx6Jf5v4fURlp03RZblYzADSFRUZhj3TAsXFYuNjdWa00mR90C8wj0K5X5lJw4C63jXFXK6MgrfN5wvKHxANRsnRq1P9tiys2cTPZAnydoL6cXDiZYvyRrnjbXMZqCSxnGS81OJzIlh9fzjGEppyqpy+YmirHnnqeYVaR3Kv0ahtJOoKqQcMzgW2w2bHtDWkZGH+TXR1JQYaumKLRY+cSNjSVXVvijZ+ZMlN1Pnj4cxZPPp+S3kY3t9zIKtN7pRtvUt9J5PDmly7BYK0KBs1IIr9C3ya43+Z72V4XaWxuuj+CccbrBcKbOne/XekVBd+pZS+7BnTusqWLJayzZap07fgzPYSuG1xngg0nnXbSYy+fLqW36/4lbcJT1fj25c0/MLbDKGjXM4brDFqmec+3o+NaqUJD/U1cVmNtXAfMJ9558fqhyx7OHdkTpuDm2mj6YRt9JMvyNjRdLnrANOeaLdebW6Ws7E7Su3DUPqkRwSX/S8Aw//qYOt/8xJthlAGqn+xlsmGEEQNkxlpDUa2Z56kfikIKIKJhVIXDkuNcTDzybaEhGlSehqj+CYZFnHRcvRJD4Y6lWabhHM8bl0HjrQ6XloIWoIbTymqdQX1DSj0hiFnbUB4MhzlzMBbf4bCkt7fNMSWSbq367r7dzqThGpLlDs1EyD+E5mQgh1nN5LPB/i9znIyBCYlu5/EIUg69rEPNfEM7oM2UR0yarpIsvzT
 +GjkCN5v
 Y3hkq1ijW1zV/BiqjPSZloN8pfGx5DwO6RPQQKqbBxVy3k9DPgYqesn1jPLZ0qWuhBVOukuoa7Fo1zQoEgRdm/3R6ED+t3EkoBeveACKVRO/qtezfWLsTwHSz+HmPk+WCAuzqC1hcHikgeY3vtnuMyHsPH+Hmi5fRuIEVI70QpMpAWP5NQQzRautmtI+3ewFruTMMKZ+VIReF2vRtaVWr8ojQ2b0SGuNvBRtdG/CdovvKaS+kHTFL5RuntXYLf0omVl2mFnPLUfCdq0ExY5LZU/RlNdzdTY7F8uZtq0J4bM2cKBicZctv8Sqsyz3m0OiVNKOAa0pI6t8F9kVmCa258reMieCtguilcJkQcf1p5zF98XvlLMzOPQ7sjO54sUVY8692k0if6yguG65VzwRin0UX7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:15=E2=80=AFAM Heiko Carstens <hca@linux.ibm.com>=
 wrote:
>
> On Tue, Feb 17, 2026 at 08:32:50AM -0800, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  5 +++--
> >  arch/s390/mm/gmap.c      | 13 ++++++++++---
> >  fs/proc/task_mmu.c       |  7 ++++++-
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  4 files changed, 33 insertions(+), 12 deletions(-)
>
> The s390 code modified with this patch does not exist upstream
> anymore. It has been replaced with Claudio's huge gmap rewrite.

Hmm. My patchset is based on mm-new. I guess the code was modified in
some other tree. Could you please provide a link to that patchset so I
can track it? I'll probably remove this patch from my set until that
one is merged.

