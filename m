Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07237C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3A96B00AB; Sat, 25 Jul 2026 13:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB396B00AE; Sat, 25 Jul 2026 13:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1126B00AF; Sat, 25 Jul 2026 13:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9575E6B00AB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:52:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1220A12036E
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:52:52 +0000 (UTC)
X-FDA: 85028044584.01.43A963D
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15F7B40006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:52:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DnBpm/nm";
	spf=pass (imf27.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785001970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OybZgWcsNWEzM/uMdiPZJWitpUyM09bc/f1wOkJKK/c=;
	b=RBPa9fqQCOpc++BRS8j2MKZa8AxwDvNpIdrVERLR4E+89trh3NvR4RZZ1YFx6o847LuisF
	lCdcMRuHvwoC8Cn34o9WXJswePfmkUCFK4mLqWNA1p8SUOBKbHqhUXYs/qPI8mQAEUR5mR
	2+TAqx1qxPn+CuWIPnoNyIArRs+UeLk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785001970;
	b=RcqJHcvZyArydZZH1/5vU4ElpAwOOg7gnhzBIvm8NdVDPewumGAL7QIxsGix4ZD/lOId5q
	ogN08hcFuQVQCtN/xAUSWaazgdwIiM4540qYxlk5kb/NXLjl4+qj9negew0RMhkDT5I81E
	jvRQ/w4JddoHsgOLf0s3ZuILdBMpFh8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DnBpm/nm";
	spf=pass (imf27.hostedemail.com: domain of pratmal@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c01c79467so175891cf.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 10:52:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785001969; cv=none;
        d=google.com; s=arc-20260327;
        b=jxFRNofym+sBLqCErcVjQWCmkLhCs3aV1icprBaDnFouYZEV441mL1D0+voaqoGs51
         lyP+2FbaqCckYH6xChPElV4ZIj+L7/wZpwG7VCRIO9+DoWkBiAsgjIBuLwxKhXsf0YsX
         dTXN6v5mwalUfMG1DciHG72HSsq/kGxUDFBgDBq8BTbx9+mDOo2VboukMe+270LCLWWb
         2wUHSc7OVf/nEHkn7uh4MnIZwukxN48bHho4KjSWdppozro4hOaBuM/1gtzK4bG+jSx1
         Fkcj8C9KmmaBeaSO3WUtT7cwHZEu4RMKhvson1pAU6RwqIGh3rkwT6Tv8dhXqM9jsAdr
         DvBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OybZgWcsNWEzM/uMdiPZJWitpUyM09bc/f1wOkJKK/c=;
        fh=jaPkgzfxbt7ee97qwhXrz7UvOhU0qapREY+v/7wjd4U=;
        b=AK9bdJYhY/0a3dOg8cSiHDjtN/YPMT4o+tZT+fzIngc2AtNrc+St3F/WAoIIJqjtLU
         B5OWUfM8QyogrXw+i8QDnc3/m7DnzOKrSdbGfp+S3ic+t5zNongZwL4IRBkUtFsMyQf2
         UWU5BOTY4BIgGTIAbHoJMhagVMyVnPD5QXAmuCFXvtm/tzPIue4egDMPUZQDU+RKlI+M
         npcSlLq8Y8yQizoilZx9u4qt0yOXgsicqYkBGoh+O9QOxRkvsUu48dSlpdKt1JRdLb4R
         UTEyK1o9xYUrNg+0dKJrCjf/+RhuUjGeEcHBtf4nwt7kuU2+T8z8CtwdSPEda2/o08TT
         qD4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785001969; x=1785606769; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OybZgWcsNWEzM/uMdiPZJWitpUyM09bc/f1wOkJKK/c=;
        b=DnBpm/nmFPI2MhZdkUBakrsM+Od3g77zEbx12qD1x6dfHQioE3qssl2FxjiAR2ej+0
         0lSu2E4k2IE129G4e8xCEv0uT5/0xp9crPgrhBf4c2SAwfvJLaRtxWOBpPhKo1wayH5K
         I5QZMgU7vFVVIUOz9bJUTYKGYT5ZvJstuuKxzjOIh+qMe2bDaddtSXA16XtcHm4S6qXI
         3reJ04NHhIid08BazGRF3zDk2DgJy8e/mtW+9eJK/y4vklVJqJtAZNb5w+4CV3BG1R0E
         GxDZKKnO1xA9nL71U/6yRjpwuh47wJUK1D7VLyMKnvVvivM04AzoxVqA1y3h+O/33H5V
         i6HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785001969; x=1785606769;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OybZgWcsNWEzM/uMdiPZJWitpUyM09bc/f1wOkJKK/c=;
        b=k2Zam7rIzjDWyumOhlYgYbhqGUvSNDi8pcw+0xcFxB3kgLlhLA5nPYASmdkTPhxzjW
         umFR/GFBM7HgVIF5jAwD0PPBuYPPfIRDtj1kidWA7FovHvFyts/XP4/Xr38Yd7mw3Me+
         v/nEGcwfb0H/I+Y2J045Us0NXA4SK3XBN7UbqQug5egcJRCmUKWkGB8rJUKB+ArpR8wY
         L5PAdU3ozv6R+ikLs7GBuMm2ud+6pHIgTuFvkhPbkd+jbGODPvHzsWlfBhxSxf+D+tE7
         PYYM2wkFk/5kiap6qDIOumNPvI7N3wYnV01vYaHj2D5yV4FIJxqn/K5iAlbQ1gXFQn3a
         /C0A==
X-Forwarded-Encrypted: i=1; AHgh+RoxZj0ECkO90p0WAgFfxGs9Tz8gkAIOPjVHxcP4FOWDUiBqniwnpa6kxl1e5FgSQwLI7yz1zaB9qg==@kvack.org
X-Gm-Message-State: AOJu0YwyIJWXB0O2haq+lY8SxStBDKXNQ1Ci9WBJtx+SLAs9GSz2pyJh
	SAQPc6iyoLzGHelDre/A6uXiS1+rsCjUNhkHflQgcXSZLLY4EOfkqp25YgnhpSUgyEKQFyZVEtB
	6QYDZqymlZm+N5N0gDc87AHGTzi5+4CYkYHfZsaQj
X-Gm-Gg: AR+sD10TYAh6spAoSeAqZwboRtfshZ5H/YIg7ddenujrkELr3OxUVJBKJEQghfzKQBv
	RMV8oC9nHC0+muVMqjcjm3qvTC95YjvlTF6DZ+d2ZgPHeAGZWUhh+Gv4vyFbKQngoc/s8xx/+1+
	Eq3XvKlVehExNy07x0wXZu+hqsOkPxoW0PzGImTKjFL4cbfS9xPrWln3+LtEETVTtYqjFd0cGti
	51OmdAkyQ805yfyqMuawNWvnt1QHRBDy3r12Q/o79GgVVfe4SzZZuRzww3AiOFr36NtWVqvYzrG
	JOyueaDgUedBHX5MC403q9AlBZxibIRqa1M6sCyEI/6t5fUv7tmkzQUeb986nSiBnp/3WCcbOsD
	34hHEkmNn63Ca
X-Received: by 2002:a05:622a:14ce:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-529a77746bdmr10498301cf.13.1785001968752; Sat, 25 Jul 2026
 10:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260722211517.1898228-1-pratmal@google.com> <20260722155402.f313e8a98615bd3b513221eb@linux-foundation.org>
In-Reply-To: <20260722155402.f313e8a98615bd3b513221eb@linux-foundation.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Sat, 25 Jul 2026 10:52:37 -0700
X-Gm-Features: AUfX_mwoIRmgKJqfOzEx16Fz5xzkuI2L_6OdjyNhPoEo9DYD--9pTFLQ9F587Xc
Message-ID: <CALHaPKca4VDiG35eGRONg-to-19vWHY4a1NP_q2P3+z11R1c+g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_reporting: Add page_reporting_delay_ms sysctl
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Greg Thelen <gthelen@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, sj@kernel.org, 
	ljs@kernel.org, skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 15F7B40006
X-Stat-Signature: ny6p7whwt7j7cxkwi6dwkw8yzk9kwdh4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785001969-504257
X-HE-Meta: U2FsdGVkX186SpC6Mvo74Yiaar9Lnr1vZnYka9flW43bRBmh3UR95VW6XD6gKoAz3Em1qJ4KcoK9scw4cMeRtt6TIBuNdGWM22R4a7zPwfBRoASXGzRuCglHAv4ZMuXpWk9WzrrNEEWcRLxD/D2K5wJGIDW3wDEHkmse6WjRe4HEvIofE687LAMDHJhbydqlOTXbX8jNBDB+pQQ4zxEJrVF8CBJkUiU6+krdp3aBRardMpvfk4ngPN+D2lGAHIBOo7NnwhxCDg/bZoKfc7RV84GNR4iNON+nrJ32fg1/QVx+MLwZaOBHSDw39/auLkGvaaN7AFnAAMtEmnqw0ZKn+eM5+HG3mEnmd4ezPSRYeUVW6sAYjzDRp6mqi6h0EsJb8hODVfXCpSSl/nqQ5DObIK+Zl4B5bu0LhCj6CirCiRjGrvmJBw49ZrT6BjFyknog0BR1UTxLQwJawnKASUSeBW/of3uiOdSflWHrZBfI/YAjUC+JhCWGkPWT09yAecKseo/ByGOtbHiQPC5u924AQo6d52hF4GtyKFB8GZnmaxiaDzkw4stzbQXinWNQJWKiOQPAf2V7MBXL3HSAIu3U4iqWIOvaQm81GqAjbP1g4HAxnx4gOE33+Lsy73ZxIyCyQoQDCRVW/rvF1ouZ3ZIoYP7ss/maDGC7C6qb2fbKyPTFq8CEbVz/VBKuAczd4EOpP+ipPI1bF0vuTZFs3Usp8imcl6mPmVeHxqK+ng9WoBZ8tGevTlo62+M8cKu5HJmP/wUf3EZLVLS2RUjU6zNT94P8jrqpvkGwgOmADj0FHAW4L0y0sxKHGgdkCkVRFn7J3yjRzVYq1aWQ9KAaFOYJdbU4DBymOy8pstS+xcopa2rbUR/+LqoKaXSuFM+lHgJ4p3T1ECxGP/FgK2UHgYxmkrNs8NduvcmqpQU9oFBmjaM7sC6sxLq4/0J1SGE3jrP/wnyOdQndaf2VkZS4cBs
 e4RX9g2N
 n0+uPPgbyQgffK44fEBRajMiXUlKfpt6JeJICqyn0q5O9OqWD6Bk50b2WPJoPa296lgTjObmdMZKtvUer9JMfakZplnQmukWA9o8sZXCBIjc+B2o+cHyUi02U8R8b6XcKPFXlfKSNJhoaw4338pJRdgU3qXEQKh9Qs+Lp7Tpin5DNuWr095WBei5pov5DZBHt7viFDM/yvLZXOuusvGCQ9EOiiIy7eY4vGiVQVhX+CNXSnLGsFH+b4BqBYFhsdYZhRsO2ynmEShffc//wI6W6fhUrY898WkPyCMH2LP9C3CoYJzf2EvOTVIOCkrOtmnojElP5Zsc0mvWeezqDpPZi3Qtxtd0yu+o0NukpGJZdBQOMLWdwhpuQgTbk7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +The default value is 2000 (2 seconds). The minimum allowed value is
> > +0 (immediate reporting) and the maximum allowed value is 10000 (10 sec=
onds).
>
> Why implement a max?  If setting it to something enormous causes bad
> behavior then Don't Do That?

I don't have a strong justification for where the max should sit.
I'll drop in v3. The value is unsigned int, so it's bounded at UINT_MAX ms
which is around ~49.7 days. So none of the free pages on the guest
would be reported back to the host during that period.

Thanks,
Pratyush


On Wed, Jul 22, 2026 at 3:54=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 22 Jul 2026 21:15:17 +0000 pratmal@google.com wrote:
>
> > From: Pratyush Mallick <pratmal@google.com>
> >
> > Currently, the free page reporting daemon uses a hardcoded delay of
> > (2 HZ) between reporting intervals. While this is a reasonable
> > default, it lacks the flexibility to adapt to varying guest workloads.
> >
> > A low delay allows aggressive memory reclamation, returning unused
> > pages to the host as quickly as possible. However, during spiky
> > allocation/free churn, this immediate reporting can lead to a severe
> > performance penalty (nested page faults) as the guest re-allocates memo=
ry
> > that the host has just unmapped. In these scenarios, there is benefit
> > from increasing the delay to batch free pages over a longer window,
> > absorbing the churn without hypercall and re-fault overhead.
> >
> > This patch refactors the delay into a dynamically tunable sysctl,
> > /proc/sys/vm/page_reporting_delay_ms, measured in milliseconds. The val=
ue
> > defaults to 2000ms to precisely match the original (2 HZ) behavior.
> >
>
> Seems reasonable.
>
> > +The default value is 2000 (2 seconds). The minimum allowed value is
> > +0 (immediate reporting) and the maximum allowed value is 10000 (10 sec=
onds).
>
> Why implement a max?  If setting it to something enormous causes bad
> behavior then Don't Do That?
>

