Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D4DC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7ABB6B008A; Thu, 10 Sep 2026 06:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C646B0095; Thu, 10 Sep 2026 06:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69276B0099; Thu, 10 Sep 2026 06:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9138D6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:20:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 830001C224F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:20:30 +0000 (UTC)
X-FDA: 85197458220.22.9B7B12C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94D1B140008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:20:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmAzDaZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmAzDaZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789035628;
	b=d2M/ZYbCUufvGE+PFIXLkOCW1pg40iZI8DsIn5KvJ7hz0SJCUF1jY6dD4+cdkROs9W34gK
	niJJKAilnurCODIWt8tM5UTP1FLifjxFufT7S8SxHpwxtDhhfJFwCWROe18TDiw157ppeJ
	lwUUukpB+24PJrX5HU0aVPt7ua5AgOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789035628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdEmpVyv56kKc6AhGYdPAfYFd5B5dnDIFz6+xaDxQFc=;
	b=TsQE23U9nXbHxzmRtuCLzhiWkDQ0KU5c0n1EYUCZKskZZ289mwgpVEY/avSrqXOCm661NS
	H3pfSnWg2Q1Jtxln4v1f+94HDU7v6YNqScDJLP1RFPgISG5sx/y79KSnhFXKQE4blGlXZK
	8npIEeke1IqUHt9GUbcdxNcuHJGDEUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B38D043C87
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ECC1F0089A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789035627;
	bh=cdEmpVyv56kKc6AhGYdPAfYFd5B5dnDIFz6+xaDxQFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QmAzDaZWfvVQyqQLjmvIlHpG8GGTWEDOqslZrCFNLTT5V68oAMJhd39eA/by6J/vI
	 6oCe4xTj+QunMxFAot8H1u98Zt33iLMJjdEb0dk0Nrj8Zo326K1ej3Lk2YnH0iAivK
	 a6a2ZeVoK4F2kLUXlw3No5ZLwKcWeNJQSGrtHWA+p8EtDCYn3E4CUo7Yf1HfPRgE4M
	 smeoV//aMC/rFN6PEYZ6UBXV3nAdI2MqxYEpJXydcf2nVNr+HsD57NE7Z1f46UJP+m
	 9Km6bRlF7X25TvcdvO+ygAZJxb5QcvN/62Ma7Zthiu2kPb7+iMZA4ZpjB+VBh15d/6
	 wUsoNMWTCJBgQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c2055573c8cso963915766b.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:20:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByFRuRmYH2CFfE70yc8SY/x1m0Cwo0EA0jhzBZWf0iQacf1TlIkO+TIoYG/sYWXBisaOYek7Fprvw==@kvack.org
X-Gm-Message-State: AFuF++ku7uxYHYUmYzxo0hqPorDfQLCMbEsuGPT2u4RSbNSRFyu3xih7
	IAUhecWcmoSryLqMvIpw109BDIdPDmr2K2ZhxNWAOkimDvcV4UW3nICNKzPNnSrn1s3Thn+yofz
	6jqus5RzWELv1Z5sfjBz1L17AqPkrkho=
X-Received: by 2002:a17:907:9485:b0:c25:541:fd3a with SMTP id
 a640c23a62f3a-c260c7b5cfemr1652863966b.7.1789035626494; Thu, 10 Sep 2026
 03:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260907161938.1932355-1-usama.arif@linux.dev>
 <20260909194712.706fb2e87a6e59097424c31d@linux-foundation.org> <7975ef1f-8d2d-4be3-b206-7c6326bed2db@linux.dev>
In-Reply-To: <7975ef1f-8d2d-4be3-b206-7c6326bed2db@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 03:20:13 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPsK1i2wcDEOx0M3Qb_VaUS0-8aGrdyp_-E8i--Napbtw@mail.gmail.com>
X-Gm-Features: AcwNN1VENlP2SEMBSV-Te_X5pjM4wPgRb3x6c-WQl0KNc5q59hkAJHGQQmBlbmU
Message-ID: <CAO9r8zPsK1i2wcDEOx0M3Qb_VaUS0-8aGrdyp_-E8i--Napbtw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: don't fail a large-folio swapin whose range is
 not in zswap
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	kernel-team@meta.com, stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 94D1B140008
X-Stat-Signature: dhyagywp41t4738uob886po61ucjectm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789035628-624050
X-HE-Meta: U2FsdGVkX19YV4+/rV760fjPcCjApspx0B0St5kEgV59eB/xQw/4Pp6Pruhwz1hQy25GR5cfAE+//kJivvS+/cFBuJhN6OwaopiaO0Irq2SIRViYQIEBoQr6eQPZtaTt0KXUpDld/4UfWYmFJcyz9qFrQEqJKh2Dj2sKHP66aX2tFtHj51SEB7EU0zxaJzQVW94NJIv5CH40wKJvSm/tf88ESjo/wFWuR6qKVbkYvLXKmAd1RAnEXqz7PGedMCaj6BzjMPIaHGcQVtLJwKuBAOnPukDbYqwmXU3PAWEgRX05bU19VbTW7wBccAiwRYWRGcFurLn7NZxBVzFThMH1vc2Ciyp/RqKxlPd2TnIJWbNwzbtoTjfFqGdzCCuig268XgoxlvWWJ6CysluvHC1HV+HjdLuVnK/gnUuilMiP6tCrnbxGumLEEesKTHu+ix+NRPj1OVNlxuOIzAIBxdcAe4m3Q9hzbwL1FCeDPg8KmkqCk2BZDKOfKaH3kQu+YngNOIp6qxPlIQgc5On8Ktbnd7P7+PM+6nK+Ddwwi0POFro71EMAA6HRN6RWTDEpUcqYw/lgnDIkrxPtxTulTWmST/WSyQYNCGRHbjCTOOc5/2pVfF9BemQ10hjr7gLx9uNsnJDzgyuV7WCW4QqHDGXJkpq1ySqHqlcSFrMnACBa8TTS1ny2CDIdPH28v8NpRO5YP5+Qc/DUW0xuvHDo7sZP2bAwCq6v0t865G5n4NbgflKhsJdzRu0SXXEx70Ei45TZcAu6C88R+jmAdEzqozXJkowaC5jdCfcFnB4wOw/ONg0WX9cJ9a9zrD3wlaxjVqJR6TiKb6m8O9FPzk+pU2ou8cCu2ptCM60FC12zpiCoMz7p+S7zoV56GzIgpLAN23CEMQHWqBLcYS/jWuvmPXgtkHUOelajUNf5HmqP/6ArLG3pE+Lzqc9jActNUskPLxQcvAxbz+yurdTKML8QlnH
 BKQij46C
 eSE2MRShcjATd5qhQ8w+ggEt7pWWxK/7dSYRnH9NUJFDidqXSwwaT88+ilJ4OSwVaor6YV4VtowdvGyk1ZYnGKzuz2418FCOe8JEEXdr82VhezUGQMXxSctTbFk4aovs7QD4ANrr66r7oFS0Tw99zzNpB2cNPALFI00MzlOPZz+kC7aRdHQ+oTW8q28GpQmHrStLSgjoQGQjHaQLrnmn2Nrw/H1Ub5a6s3ASpY12nAEybODhQwyUCyYALEvgtndJrcBS83vYbgY8YHk1Y++fbeGvREKYEKwukrwj5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 3:11=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 10/09/2026 03:47, Andrew Morton wrote:
> > On Mon,  7 Sep 2026 09:19:38 -0700 Usama Arif <usama.arif@linux.dev> wr=
ote:
> >
> >> thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
> >> zswap_never_enabled() to decide whether a swapin may use a large folio=
.
> >> zswap_load() samples the same one-way static key again once the read
> >> reaches it.  Nothing serialises the two reads, and in between the task
> >> allocates and pins a high-order folio, which can sleep.
> >>
> >> If zswap is enabled for the first time in that window, a large folio t=
hat
> >> was correctly permitted reaches zswap_load(), which rejects every larg=
e
> >> folio with -EINVAL.  swap_read_folio() treats anything other than -ENO=
ENT
> >> as "zswap handled it" and skips the backing-device read, so the folio
> >> comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -=
EIO
> >> for shmem.  The data is intact on the swap device - it was written the=
re
> >> before zswap was ever enabled - and the not-uptodate folio stays in th=
e
> >> swap cache, so every retry of the fault fails the same way.  With
> >> panic_on_warn the WARN takes the machine down rather than the task.
> >>
> >> Scan the range instead of rejecting the folio.  The caller has pinned
> >> every slot before issuing the read, so zswap cannot start a store or a
> >> writeback into the range and the scan is stable.  If nothing in the ra=
nge
> >> is in zswap it is all on the backing device: return -ENOENT and let
> >> swap_read_folio() read it.
> >>
> >> A range that does have a slot in zswap is still refused, because zswap
> >> stores large folios as order-0 entries and cannot reconstruct one.  Th=
at
> >> stays reachable - a slot shared with another task can be stored inside
> >> the same window - and refusing is correct, since the alternative is
> >> returning the stale device copy.  Report it as -EIO rather than -EINVA=
L:
> >> the request is valid, zswap just cannot serve it.  The only caller
> >> distinguishes -ENOENT from everything else, so that part is a
> >> documentation fix.
> >
> > So to hit this bug the user needs to enable zswap system-wide during a
> > teeny race window in the swapin code?
> >
> > I suspect nobody has ever hit this and couldn't do so if they tried?
>
>
> Yes, I think it would be very very difficult to hit this.
>
> It was part of my PMD swap series, where its actually needed for the feat=
ure.
>
> I think we can drop cc:stable, unless you think its needed Yosry?

I am fine either way.

