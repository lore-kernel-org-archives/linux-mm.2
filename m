Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3637C606A323
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 11:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GZaU9S3g
Received: by kanga.kvack.org (Postfix)
	id 504286B0A8C; Sat, 24 Oct 2026 07:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5816B0A8E; Sat, 24 Oct 2026 07:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CBA86B0A8F; Sat, 24 Oct 2026 07:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14C126B0A8C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 07:01:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6660AC0302
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:01:13 +0000 (UTC)
X-FDA: 85357228026.05.5AE0AAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7060080008
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:01:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZaU9S3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792839671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk/nez9nenBsnQjciCAGiDdqXpw8qDo2kH67Oa3IArQ=;
	b=tzzWBAlpA02HmLhH++XHofBFkVruqmpfK3gCw2wBztRpl8sEc7yRoyxeUxtnoFXzH8VnJV
	4fJP3NLU+fvc5tqUEO/GwJBVa94M+sGcJfZMcBwb2NbxqyKyyqlpJ6Et8yTlKwfr7d1J4J
	er75xKjnvGi6cmpsEgaAyw8LjGYD4HE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GZaU9S3g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792839671;
	b=ksDvThfYRLLMIF8OpCGLN95FdzvpjnlNUv/O3zMunCEhWwdi474zjVvpvIGYVY4l6qdwUz
	P0ISfpIT+AdYfdksb6Mx9Pzwo/6hKW5FdU1nd31pjjEkIIvQIEB7A1dcufRldCGo8d9PVh
	J/OkfSF1t4SZ4qkWp7PqjdvowFTmwQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D35EF60A8C
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5A61F031E3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 11:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792839670;
	bh=Mk/nez9nenBsnQjciCAGiDdqXpw8qDo2kH67Oa3IArQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GZaU9S3gSwPmSPqYPyU7A/QGTA46xOv0Jf6Z1AlwqU6cIs62wd+vrITEKX6siJTKM
	 kA8BDJozMYIOnfwk4NC62QHqpfodaTDvonpP+w/EyEhM6mit1r6P508M0/yYaZRKpR
	 ihXe87mHtg1uV1w1gCmTLBeoZfgWTrxWD4H1D/untTyY+x4z+chu4hIebbijAGtSKB
	 KVKPlKnWRP3HhMTFYeeBSvr9ugZxVQYclVPfUK4c9il4qxmbfb1yyoeI7HmPz+SIX2
	 nk2fUpeIfgPtOVDk0MS1SxX0sUd96nsaPJeGjF2+3Oo3n+zHW3A9n33OfCAoQW3Gkd
	 96Ch3x4lLhRSQ==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f30660e69so119927985a.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 04:01:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwqshaOOV0G00boVSDQg6dpeSU7jpOcQz1cQfLG19kKDebF5NFNu3i0mQ3QQgSSkJLguPIzsigjJg==@kvack.org
X-Gm-Message-State: AFq9FYJK+RG0JGkHKxqOZCQHvIUA5vm1SX9hykXLt8YAQIchh3D7gusV
	q9JpWeaZUcvtGl7P+xspNdepfuDdvSuPiTdYUDKMyJeIZeADIlNP/XvU4XAPu143VLyMZ/8q9HE
	AVSfoslNf19QtfhAm/8ZDtiLEo+8OTKw=
X-Received: by 2002:a05:620a:262a:b0:93f:3863:268a with SMTP id
 af79cd13be357-940ef92bffbmr223374585a.37.1792839669908; Sat, 24 Oct 2026
 04:01:09 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260802074018.73887-1-baohua@kernel.org> <20260802074018.73887-2-baohua@kernel.org>
 <anCu3DOrXDeMrwi5@lucifer> <CAGsJ_4xM7mmv_Xa3g2mB_0gW0_VtYhMtwz0idgYLyoAYiHFmfg@mail.gmail.com>
 <anH3jVrBlUMLd-28@lucifer>
In-Reply-To: <anH3jVrBlUMLd-28@lucifer>
From: Barry Song <baohua@kernel.org>
Date: Sat, 24 Oct 2026 19:00:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w9eTngW4TbqhmgDgCW6ugd=3Thq+u8ufqJ1WX-c_4p=A@mail.gmail.com>
X-Gm-Features: AclHuK91tBy5WqlUSNbGFKdzZTc1OWL-WRH6V00N6zby1epMlwqFq2F3wTNVRPE
Message-ID: <CAGsJ_4w9eTngW4TbqhmgDgCW6ugd=3Thq+u8ufqJ1WX-c_4p=A@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on user addresses
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, surenb@google.com, liam@infradead.org, 
	vbabka@kernel.org, shakeel.butt@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, zhanghongru@xiaomi.com, willy@infradead.org, 
	zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7060080008
X-Stat-Signature: bzzu75z5j8ysea5khocp3infima39siz
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792839671-138501
X-HE-Meta: U2FsdGVkX185PzarkVXbKE+oIpUKSr2d6ZapZSvJ/zhCCpM+MtBLdJOJnfJ0/iN2nKu7ZuVOjYPRiy06CovID6UJmj97NcLZLZfkCa7OltAd0f9jNP/paj9bdw+y8qslrDHAKTdfZU4FN2eYnYFT1OXzsR/q6f5y85j654AQaNvmKMOz7cyYuq6eVzdS/EkI6MKRWaYpwM6Yca3I0e/WC/I83/bPp4E0re/EdUvU6K/W0ZzeBO8mmSguvUUfKmNS+Y50QjMomxwHr4YfuaT4rkLriADogeMdZI/M8OC+sEVM0qb9Eaq5ksdc/tqkO6QjC10jaGwL7i7ETVWRSGZ4DivnAttDcgHjRTJ/qrODkarYZ3LgAZY7fxPMusnkJU7blmPQmptaV1dILvjMCMXg8NT0s3b/gPJdWjVutKA7YZN/PVXW++uWGUs0S+9ixaOjpgB4iqZXMpbnMU0ToT5cBibdy4mS5B6lUn1fQbuueGUpxPp3jiAbSLI/n6MC7b6HEYjaByi+rx86nyUBRRa3IdVbyw2SjfFsiZuf4cSHGFNU5cIlY0OSO2iJetutGctqNL24dO0ZupIO7205xEMEmiEF+Tcg17/tfepTX8FV+mGp/GhrZJadcfbfZJtpaOUo922jC/WEllAj9BJ/q3WcDepiyqO14mPpB11lgTVOV8OA/TYNfXKYvXdOZRtSel6BOXZymDtck8+9XqGTkXS3mcP/OoZkWqOypWhCKi5IIfIJ2LajLbXuhqp7Vg4jPmbp1CJmK4NG4GxzucTF0hlXMtbsqXoDCWn71+dnBB7wu74XBlDFtBdJ0ZqvitjKUSiobanvRORtospWCqtrOYZ/eArAABx+1mDVazcyzfUKDbXZzUk03NRbH3JlhD+FHM0g0LR8ztGsbRMEwA6IJ2vc75vZaVuoQM44ORhtCCVZdwctBZfgNOBnGDdESos/hpkcJqhMoMPoF42u9rpSkZV
 pLSiwzds
 stYYCk964HChrxJY5bRgIaL6LVR994NjGMEDk2iOjWmko0Xzj4kUp97gDdrqCN8aGnJtO0RbwJBqcg6eJF2KfvqhDTQquBvNd9YI3rxEIEdQstM0VkDyd4zVvi00uTt459zMwiqiv8CvOzwwOZl7ehZL6I32a3MOFfGgzM1PJjEiQ9zeAyQhG2rbaX3jczpgExNbgWPCdTG6jHWBN77V/9lXXsfDO9nFHsba5dAVIJqno9IYBoupu5/raNsM+YeQSfFEB4y3RYRPbT2uV8tIqdwmy+mk93pd+Vv8vnj1P2WkKiAugciyoOyKFVNWkDnE8rZ6jZe+y5ajaKgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Aug 4, 2026 at 10:46=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
[...]
> > >
> > > And finally - Willy is working on a grand clean up of this stuff _I t=
hink_ so
> > > you probably should coordinate with him also?
> >
> > I have no problem waiting for Matthew's work. It is the right
> > thing to refactor the duplicated code across architectures for
> > the VMA lock page fault path.
>
> Seems sensible thanks!
>

I'm not quite sure when Matthew's cleanup series will be sent.
Matthew, what's your plan for this?

Maybe we should send RFC v2 of this series on using per-VMA
locks for kernel faults on user-space addresses to collect
feedback across different architectures? RFC v1 only included
demos for two architectures.

We may need feedback from architecture maintainers to confirm
that we're correctly checking for page faults triggered by
kernel-space accesses to user-space addresses.

I also think the cleanup series might need to take this
requirement into account. So, even if the cleanup series hasn't
been sent yet, it might make sense to discuss these changes in
parallel=EF=BC=9F

Another suggestion I made earlier [1] was to wait for the writer
to finish and then retry acquiring the VMA lock, rather than
falling back to mmap_lock when lock_vma_under_rcu() fails on
the first attempt. I guess this is also something to take into
account when working on the cleanup series?

[1] https://lore.kernel.org/linux-mm/CAGsJ_4wXGf90BMoJp3_z8G4fMTAgED88RXvbp=
6C4Gf+iy_2nvg@mail.gmail.com/

Best Regards
Barry

