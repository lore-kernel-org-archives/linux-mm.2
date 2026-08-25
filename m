Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A41C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB7D6B00A3; Mon, 24 Aug 2026 20:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABFC6B00A4; Mon, 24 Aug 2026 20:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976BF6B00A5; Mon, 24 Aug 2026 20:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78C836B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:22:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1616A1202EA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:22:36 +0000 (UTC)
X-FDA: 85137890712.26.E8D3145
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EFD420007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:22:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WdURWD0z;
	spf=pass (imf03.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOyFPtHP7h9UHgRrm67PAH0DWzbHzUFre5ZWiI2n6oo=;
	b=WYCJ2LK/Ek0a0grul13Vz8BfIHnapO56rVDVrei5Y7iXDz2cVh8BrIqPXrU9UdiBol+DLv
	NcHGVm5qJCM0M2jrEC6xXnatKSzQZ062+9BnPoc07UaIX3MZ/UOAfvqtmxX0KVH6ZBeFCO
	IVJlVnZvOtJLpEX6QFHJy4p7McjDOF4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617354;
	b=OiiCbl2558vCs2dh7639xjxjhC2jjHhtFdk3AVNTt53j0eLxorBmHWjXLrixiRyS9wRUfP
	W3rnZVpw7RuzmwSpahLjGpDHKTA2CCj8+sFfXUf0njy84Pik4hp2A0iHyTrA8dvYzNT2rD
	bopYKM20aWMCGCeo0S3MHzmcAwf1rZc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WdURWD0z;
	spf=pass (imf03.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c167aa9500dso626662766b.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617353; cv=none;
        d=google.com; s=arc-20260327;
        b=LoH9TDn2jMmvORiQ9TtsYjenLROtAjEu4Oza6d9GObcESWTwI5ICkKng9kkT3nhYyK
         dpiTE5HORC1UqqGCJvsv7jHGHN73LBOxQNssY1F1conInwt10079BjATzfbi2eAHeZ/T
         y72+dMu4Lqv0DWh3OQSztgq4cvq19/EbKyoo1G6VymaciMRbMsYr+ZlT/VAmC4V3ULog
         zuqBb3zG+B5mdBGUOIZuWHHBhJXqVLpbmxTT8RRPGLgR3zaIO47ieaSiJZnM8FHHUhnD
         G1nkBciGNfCq0dKKR7ZlvIZGTzndTONfEzlumJrbqknMcD/erbJekjSrrDk77rRNXe91
         bUMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kOyFPtHP7h9UHgRrm67PAH0DWzbHzUFre5ZWiI2n6oo=;
        fh=jGf3kiacuu+J4tt1o3lJ8tb6PY1qeupOYjJSCWukxdQ=;
        b=iD5mSEvyIgJql1Bipmrb4OtmNU/dzXlK14N1ByUoCu9IL4WqfIhFwB3xyFFWB66Tl/
         XogkC8UmBhxd06+f45A6nPSXMJOu7hPGCchqsqhO2lxfBokKC7wUGvKrT8PYbbWNpgxa
         4WslL1ucIwtG2axa/ZTc7igaznEDJvUWWHM5AAA0oecXdaAmhqSFDp0/X0bRHl8lZBda
         pwF8gQZ8n4RqE0TCmYObFoTkoIiZasyx6n82lozMi1AJfZO/hc6JVt0u/COYdDvgHK0H
         vys0LcZVbVTy4/HmupernXO2eqtS057T20YI2ZBCvq8xHrEFjobRcxH4mFIC5EkcKfiq
         EK5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617353; x=1788222153; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kOyFPtHP7h9UHgRrm67PAH0DWzbHzUFre5ZWiI2n6oo=;
        b=WdURWD0zYnQRFXp23u4q4NAlgojKzzlF6QU9zsj+9/FGfse2nQmbdiKOAisfhyIf8A
         6N2br8su0vFEL0Ow6Xrve/mgK+OcEqDtPq1HAWDuI0rPPTu0T1hkh0dtp4LEJ0fOYavK
         fHMfTHkqRHrnL53sEzAsIehVCKt93Frw4utRpz8WVauQdI3I1Y9NlVjA9I6VeC7BsdrP
         jwHhpMOM0v8E7idFeW8vla3HVdyG6pFyU5RNXJaAxrSlBhN3kmgJaGSjHorJ1OuwdSvc
         N4IkNFx0q1lCMrHiVSa/FJkb/5er/uecMmeG8ee32CyWCchIWxiAkGOIchw0P8XBxIDX
         83XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617353; x=1788222153;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kOyFPtHP7h9UHgRrm67PAH0DWzbHzUFre5ZWiI2n6oo=;
        b=bVxfWPHgPpbjU+i76Gmi6Zn/+8T4PH1h5OuYOVucUkbyNlNi6C05ouaX8CN75UHi4l
         dbsSfEPPScQ//05RS9a5mcDIW3V53UNH8OmSuCHWgG/K6j8dfrUapiSTIl9sJpZVCuYA
         BhDQOA1rAMtr+eiqID5R6tHEKfwECuHTKhVA6oE1Bbw2aGxnVSIOG/4aCzz6iln0Wqh0
         blO14ERdIe1qWf+eD1Sdlruzc4YDQyH/DxF1+0VPtmbfApVvFeWxBUGwYFqZByaEIW6z
         dPWkqeOgGZZN0fTZYD8sgT2HGE/gqV1cZ6WeZvH5ynv5ORYnA3912GolFdRcPfsJ7KM6
         xj2g==
X-Forwarded-Encrypted: i=1; AHgh+RqPD/i88pImWbNRp9G0YgDyw+wEmj/Yk9tD6hDcrl2bzWgP69x8VqyA50YUJ71Q4Gm2sEu2aTYm9g==@kvack.org
X-Gm-Message-State: AFuF++nYNGk7yYamiWUyM+XbdT9MJepGAoJklsSnRqa6ussetz4/5ZR+
	hch5hMOOVjw4gPM8BxrO7zRk6dq+2Te1kpqJAmWm1C7oUFvvA5NHcHGEjL/8oWLANHAiyArdzHb
	K3iD3gV2+h9ZQo+C891QfnMGja/LFb8BFaNvbKRNn
X-Gm-Gg: AR+sD13UzaTdYYKsJWbuRP4/KnQWINq42QIQ1LkGq1R/aPUNVTmju5P6P9BTrXJUJm1
	VV0PGS0W5ZnZzjas99dkFuUhEDGOUJw+l+r+rfICkvJL7r02hLOs0RZp6TygdeIqN5R7WBZ7qC/
	8x3XyQMNX78fOSwvrxKhbQvZ7OX/rNWfJvGB17IuyC1qH59Fuu9R9D7QnFGfKGb89ZPBCvnBtUB
	qnLMLnXVJL7BICUV6QBJuWb7audNqcxNksG6wRQQ2wqG3KkU1sbvYjkNXaqucA1nvomorJQ2MmB
	Zi8MSAe3uwokmYXm0/wrCYnpiZUD36bA9BQIIxFwmFmOwkMTLJTW3Jcq7qoaUDV9Iu1RgsW32Gk
	C+Bjm6DEVu4nDAfVW+0+bx3NoNOCykOrGmEqTV3k6IASCd5IpXxn46Z4Gb0KMLfR5aAwi/n7+/8
	37WnNWvSDjIl6UGTRA8g==
X-Received: by 2002:a17:907:f509:b0:c19:49ee:19b9 with SMTP id
 a640c23a62f3a-c246a654f4emr3673287166b.15.1787617352275; Mon, 24 Aug 2026
 17:22:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-13-jthoughton@google.com> <aoSJcAFMNJ1nPl2H@arm.com>
In-Reply-To: <aoSJcAFMNJ1nPl2H@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:21:54 -0700
X-Gm-Features: AcwNN1X7B0NHnRVh6P3ybt_oiJ38AaVOx7MEwM5ijGiH_DdKQLX63EhW2oZ28oc
Message-ID: <CADrL8HXZy3HgQeHA6b8TzJX7oWc9goe30sPfP1F5OMUtWLbyBA@mail.gmail.com>
Subject: Re: [PATCH 12/18] arm64: Implement try_populate_vmemmap_pmd using AF trick
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: pdg93hgwaghdhuaxq5d3hparwj8euy3h
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EFD420007
X-HE-Tag: 1787617353-331561
X-HE-Meta: U2FsdGVkX1/hgRumX0BelajP/Giwz01Jm5M1yK0lOykUnOQjLxcDcYw5RLGQykqUfj/Y9xKnRncrmPtzoWF2CvrQMseEOfRKZykSDmdQcWvS9COeHAYdCCTkAKAza2NnsJ6Yi0DtVMwcINIDbGe9MAD/Ixjev9ebyIeBwrSFq2gPMQZnw0HiQy7a2n+eQANk8wz/wxXqRAKZ6nds3TeqsnTiK8UqXDbxGlEvg7onPqxDtO4nuSiRsixy0nx6q2DjGMGjI+1/MmKXUuzT/+ynuf3NDLPdUNvKyfv+GI7SeLXCGGr6G0DlzBzWgO2MoQt5IZDK+n8SQpF9T6CTQHmFQO9uOvvjlZNVuLyR5pZUx2ZO2ak9XSyenOJ2fQOr+FhvVrdOmHlhpwJpWdwhl/8c3iat3H4/S7qZ1gwWgXpaCJmegQpBgLfOg4pHGJZFu6MM0T8soIxCYYZj09vrhzW8GCmUfxLcro9aj46EbYyFLSKuII+HH+GXDljLQ5CeB9Uw6IVpPkq91+S4hnOteqAZ6zIcW8Lb2Nm8rY+89BO9WFPeDxbrqEa/bDbAcdrqKGxYJ5+iYksUIJwTk6BotRtumgjz7StA1RA/bRkbsdk7mOHxfqxlMT0z9bs6nDkn2VrrHRW3pmGh0TqQ2YEvhsVzey5yd5R44FXYkdJf7T95WvXV991hvpJGpYdS2Xr+pySBPV8kSR3GVZN+CS7Du3vfsVl9A8UCT1bBXAhtuG5WL0FCXS+FDN7ILZpWtKA5Mx3HjnYRp5wsRXZbxe9ObhULVNOb6EBYIprt1b7bUvhQpTTKIAp8lETGGUyqBTEcJH1WiHXB70oji88yjHbunMDA+tU/TtE6Pp00Y8+NtCOeR6Pl5H6fGFdArOeNbH6Q96oaaIQQC6ewp0hD86IpsBFm1pipZukb8Jx5ygIdZxzY5KQmnGsIYheCoV3m3vKvEWacvL4Vk0RRwtABcJTDgcG
 oCInq/Qm
 1oJpDyACK7dMMAfceUboGQxTZJJaKvAZljQe2DbVYxVrkUlaEgt362/dsTFnqeRL7NKFzYW/4Db6xQqsNJPO3nsFlqlLU87eyiFn9O0zJW44atTmiCZtERRqqzxlHRNmTIGVkYk8uVZgzLle5OHVSfI+sSCIexOHFk0tJwgbCHUUxBrWPJbe7eYYEdT7Gy4Dt/vRcpkkN8NnKl+ZuffKEvZMYhPZJ5DaYJdc+cKom55cJDkv/YzPvBSGFVXWTIkc4I7ZU4h5GoLn9jXWPvtwjO5l3OS5PL9XbDicKNCuiOFCMwT6p5jhp7qACD+fNUB2oNHuZnRoI/svqq3cE8j82faOEXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 9:34=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:22AM +0000, James Houghton wrote:
> > This routine is to be used for updating in-use, leaf-level PMDs in the
> > vmemmap without introducing a window where vmemmap accesses might fault=
.
> >
> > Implementing this on arm64 requires some care: use the same access flag
> > trick that is used for vmemmap PTE updates. HAFT is not needed and the
> > TLB flushing routine remains identical, as we are not overwriting a
> > non-leaf PMD.
> >
> > For systems that support BBML2_NOABORT, there is no need to use the AF
> > trick.
>
> This part needs even more text in the Arm ARM. With dropping of the
> BBML2_NOABORT requirement in patch 13, we are left with the D8.17.2
> rules in the Arm ARM (M.c) requiring BBM. I'm not sure we can infer much
> from the AF=3D0 caching rules as here we talk about the walk caches. For
> example, a walk cache memorises the VA to block descriptor translation
> and that's irrespective of the leaf entry AF bit. If AF=3D0 and you skip
> the TLBI, nothing flushes the walk cache which may confuse the CPU when
> it suddenly sees a table entry where it expected a block one.

The CPU must still respect block descriptors that become invalid, so
it wouldn't be able to just assume "this is a valid Block descriptor",
right? But I really don't know how implementations actually work here,
so it could be possible that the walk cache could get confused during
Block -> Table transitions without a BBM sequence.

I agree that this should be clarified. I'll try to prepare an HVO-less
description of the required behavior and work with Will to properly
ask about it.

> If it's not critical to the series, I suggest we leave this patch and
> the next one out for now.

I originally included it because I didn't have any machines with
BBML3, but I think I have a Neoverse N3 system which supports BBML3.
:)

I think I'll still include these patches anyway (it's at least useful
to continue to drive the discussion of whether or not the Block ->
Table transition is legal); I'll structure the series such that they
can be easily left off. And I'll note in the cover letter that they
probably ought to be merged separately after more scrutiny.

