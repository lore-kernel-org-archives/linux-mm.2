Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D07CC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD316B0096; Fri,  8 Aug 2025 08:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27E556B009B; Fri,  8 Aug 2025 08:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB1F6B009D; Fri,  8 Aug 2025 08:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE656B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:55:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1062B6E29
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:55:08 +0000 (UTC)
X-FDA: 83753585496.20.75065D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D0B301C000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:55:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cmnGV/jm";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754657707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=735MKqTpVsLiwF08r9eYm/WhPdFnfobFmT9GhcsZRXQ=;
	b=M7HdmpSSW8OcS3c2sT2K6Bd/HJxdAZy9QmwypIXt5duwv0DLnBUu90CbtDJE9P/JXRjWoo
	L44VbRcQjMvycuo3g6VTfB9EmfHHYZHQHB9SvuHgeQoeGFF3t7lRNdS8Psvi8vcDCxS3+a
	9b6gBeeeodhsma+Chh47N8QeX3GCB4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754657707; a=rsa-sha256;
	cv=none;
	b=OTyGJj769xZHSJ0gstn6A2WnxcOtNXwFbhDYWlvB3RabqXfsVo0PbLyRHcNYm9zDm5rWch
	8bm81St6ZjR1+OdMWm5Aqvdt49WsgQpOX9KyTjXE/PeTElJEpW/EV93eE5d4BxxcMYRwm6
	lHW4ITnTuP7sXmK2gtuVtsxAC9j160A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cmnGV/jm";
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754657706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=735MKqTpVsLiwF08r9eYm/WhPdFnfobFmT9GhcsZRXQ=;
	b=cmnGV/jmk9UCFiG5+6S51y5D+5ad80oAOOpPxLo9QD0lo/8B3UaggaKxTTHZlimd2/+cae
	M3H5/pTff//5SRii6VwP0W73oQ7Wvvt6mLk1zs1YfJAss64Ko2EuJ0f7rQG4vILZj25pzV
	z21mKEtUi09XwM4Cm//wbbqmEAo2Wtc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-JSQNINiVOQuzqBr7vxM5Mg-1; Fri,
 08 Aug 2025 08:55:02 -0400
X-MC-Unique: JSQNINiVOQuzqBr7vxM5Mg-1
X-Mimecast-MFC-AGG-ID: JSQNINiVOQuzqBr7vxM5Mg_1754657700
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5804B180036E;
	Fri,  8 Aug 2025 12:55:00 +0000 (UTC)
Received: from localhost (unknown [10.72.112.126])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3F3B180047F;
	Fri,  8 Aug 2025 12:54:57 +0000 (UTC)
Date: Fri, 8 Aug 2025 20:54:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-mm@kvack.org, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] mm/kasan: make kasan=on|off work for all three modes
Message-ID: <aJXznYlO7dpY+p7D@MiWiFi-R3L-srv>
References: <20250805062333.121553-1-bhe@redhat.com>
 <69b4f07d-b83d-4ead-b3f1-1e42b2dca9c2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b4f07d-b83d-4ead-b3f1-1e42b2dca9c2@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: D0B301C000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: zxgqqtbza8m6rim91s18k5r4sgbgeq9s
X-HE-Tag: 1754657706-30584
X-HE-Meta: U2FsdGVkX18tvqUOxVtO5usgz3mAkyiQg9tBKPMs195TTwvzmnp3EvpeSrQPIEFd+isV8YytDsJ6XpuvqrjQ7aT8pIIWQtG3PICF8UG8hYPvn7vK8qdn7zAnoUmO7UYdBhiAOtd/xQeBT6z/6sfpEWmuFoVqNcXWDF7oxF207aYqFOVaI5nlb5Jm5WBJP+2SnA771/50EAFkqTtPK7tSAMKN26JSmW/qz60Mv0J1mPerXyA9BT6wvSoUX2grIF3elFfXoHyrlYRvBhPX0jO3KCr+bypdRy2iD286epiis5rlPbIKZSzgiDmF+yxvFoiow6z1U8vUrp2OC8Zhg97QhnKShMVCxBTWWxQ8kei/lZFBcd+hR/g7V5l95bvn9SADM/vhVNGC8Oz1KmMz7A95sFGW7xnYiZdZhXmaaiE5R9I11QfFjTwAbsuPFlK0feLiPEJZNy4iKj8l6TaLSrAXirbgEwg00bhOAd4yBGfFLPIrEVqZyT3v9xKPv48AcSRpj2PuvyNS7eQCno+HW+f83AoG4bv4T3phdk2wuP1t6KBgP9dF5wiEYgLsaDWYrv4pgsJjCXbKn/zKwbP+RISL45RPIwKBxtubmqdWkgFHAKYE3WZFE1efBWsdKxQtWOJlNC3+lykx0WHQ3eNRlLHXW2tqtYYCF6jDyzrI4fUrifkWFOCw0mhkiKHVy7AR7dLjh3b+SnQXh24GZWMK77GaM799tUMHow9SriUS1tJXrfayEH8GWkGZgX+gpveaCR/Bq96FwHl2KnCtxqleffWeuHmt5vwNfWErocopijevudrIx5qMYxte8O1kC1JxhycCY68KORUbLtTiQJb5iqnH73tuiBS1LwaPI3iZ1MLTWuLCAHWNY/jbUhT8d89o/NifKtVc3NQUIGAkB2Omirv5bCkOe6n0uz1WHzEpijRjrpD7jbAUhy3Hqj3VoEzTp+vbvN8gT/QVOU2n4ggPHVm
 QcpWForj
 dn4IB0ux8T71MF1dFCDJSozciRj+y8enQ5AyJmQ59PGNUX1CkNqC9qL9AgNsL144+k7kQ7JWEjuhzgrG02MhsNPn3QmgpvHrCFcLmhVeleZxA8cHuHVjdYl1X7sJnSuG7niVgl/t8J3ZMLWaLsFDgGWpDCpXd+q5zYU+3k/fhbqSfeaaeLz6jERT195xv3auEwH629EqBS8ilGCmFADH68FpA4iX3kgNfcgwxSpcX2nyWaHidonEM/X3ILP9YeQ0+xqdb68ads9gPqtEb+RVjmGsy70eXpmSluZwrS4B2qUp9d5gw6/lJL2pxuzMKVZ2b1aq+U+PuQX7INxjuIsohcrngo/Y0sNpe7DENc2UeNf3M9UhgtJECBekMHk12fVKFukXEc/NbJIMhHJjcLeI9S4yCBlAWdKW7xyCwCH8zaeMoCFI+06XWC/DBO/xpn7WwHG4rrtn0t8JddFC1fWZ1RnjjQXk0H5nu680a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/25 at 06:34pm, Andrey Ryabinin wrote:
> 
> 
> On 8/5/25 8:23 AM, Baoquan He wrote:
> > Currently only hw_tags mode of kasan can be enabled or disabled with
> > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > sw_tags mode, there's no way to disable them once kernel is built. 
> > This is not convenient sometime, e.g in system kdump is configured.
> > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > kernel.
> > 
> 
> Ideally this problem should be solved by having kdump kernel with different
> config. Because if we want only reliably collect crash dumps, than we probably
> don't want other debug features, e.g. like VM_BUG_ON() crashing our kdump kernel.

Yeah, we have done that in Redhat's internal CI testing. While we still
want to switch back to let kdump take the same kernel as the 1st kernel.
Like this, we have chance to test debug kernel for vmcore dumping. In
this case, KASAN is the main barrier. For other debug features,
VM_BUG_ON() should be captured in 1st kernel's running, we won't wait to
run kdump kernel to catch it. I am planning to check and adding feature
switch for kdump to disable if it's not needed in kdump kernel. E.g I
have done in ima=on|off, and the existing 'kfence.sample_interval=0' for
kfence.

And the public kasan=on|off kernel parameter can make kasan feature more
flexible. It can be used in production environment with kasan=off, and
can switch to the same kernel to catch issues easily by stripping the
cmdline setting. As adding a cmdline is much easier than setting kernel
config and rebuild kernel.

Besides, based on this patchset, we can easily remove
kasan_arch_is_ready() by detecting the arch's support and disable
kasan_flag_enabled. And when I testing generic/sw_tags/hw_tags on arm64,
I feel if adding a kernel parameter for choosing different KASAN mode is
much more convenient than changing kernel config and rebuild. If we
choose to KASAN_OUTLINE, this even doesn't impact much in production
environment. I would like to hear your suggestion.

Thanks
Baoquan
> 
> 
> > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > common code to make it visible in generic and sw_tags mode too. Then we
> > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > kasan.
> > 
> > Test:
> > =====
> > I only took test on x86_64 for generic mode, and on arm64 for
> > generic, sw_tags and hw_tags mode. All of them works well.
> > 
> > However when I tested sw_tags on a HPE apollo arm64 machine, it always
> > breaks kernel with a KASAN bug. Even w/o this patchset applied, the bug 
> > can always be seen too.
> > 
> > "BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8"
> > 
> > I haven't got root cause of the bug, will report the bug later in
> > another thread.
> > ====
> > 
> > Baoquan He (4):
> >   mm/kasan: add conditional checks in functions to return directly if
> >     kasan is disabled
> >   mm/kasan: move kasan= code to common place
> >   mm/kasan: don't initialize kasan if it's disabled
> >   mm/kasan: make kasan=on|off take effect for all three modes
> > 
> >  arch/arm/mm/kasan_init.c               |  6 +++++
> >  arch/arm64/mm/kasan_init.c             |  7 ++++++
> >  arch/loongarch/mm/kasan_init.c         |  5 ++++
> >  arch/powerpc/mm/kasan/init_32.c        |  8 +++++-
> >  arch/powerpc/mm/kasan/init_book3e_64.c |  6 +++++
> >  arch/powerpc/mm/kasan/init_book3s_64.c |  6 +++++
> >  arch/riscv/mm/kasan_init.c             |  6 +++++
> >  arch/um/kernel/mem.c                   |  6 +++++
> >  arch/x86/mm/kasan_init_64.c            |  6 +++++
> >  arch/xtensa/mm/kasan_init.c            |  6 +++++
> >  include/linux/kasan-enabled.h          | 11 ++------
> >  mm/kasan/common.c                      | 27 ++++++++++++++++++++
> >  mm/kasan/generic.c                     | 20 +++++++++++++--
> >  mm/kasan/hw_tags.c                     | 35 ++------------------------
> >  mm/kasan/init.c                        |  6 +++++
> >  mm/kasan/quarantine.c                  |  3 +++
> >  mm/kasan/shadow.c                      | 23 ++++++++++++++++-
> >  mm/kasan/sw_tags.c                     |  9 +++++++
> >  18 files changed, 150 insertions(+), 46 deletions(-)
> > 
> 


