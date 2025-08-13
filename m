Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE24C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAE590005C; Wed, 13 Aug 2025 07:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2C6900044; Wed, 13 Aug 2025 07:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF8690005C; Wed, 13 Aug 2025 07:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2619900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:14:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68AA21602F9
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:14:18 +0000 (UTC)
X-FDA: 83771475396.18.92204F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8B34C1C0005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:14:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UmPGhcVK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755083656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNVE6wsMC8x7hacYqMkArJqlP3u73DUjInfZebo80YI=;
	b=Saxj0H5ix5O/9WNBvWAexQWHWXhL+FjYGjczqJt729YWxbCXxsIqFTG3jwPRx2AJgxBoEJ
	/KLwVwmBgWpkV5PZipM1TWnniF2VHXjpRzfA9BvEg1p1KxYnK2+BvRBtTbKWqDPXpBZWSV
	7tZdhLdv+ccz9YARKzUemxEMNXHYsU4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UmPGhcVK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755083656; a=rsa-sha256;
	cv=none;
	b=OQIm82dBfSqiOQAufHgIMPjccMGr16uIixSJ2K9SpZyRCctR2cEUVAkXLfDepc2ZRKU9OZ
	r+rWFnUz8Z/ZVlY1b1imVi+s6pV8edKSwkS3FvePnm/Wek62JMkJd1rKGPrSskxbPwg6qu
	TKGaw006tgnCzeCCTpi1tBKBE4l66YY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755083655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yNVE6wsMC8x7hacYqMkArJqlP3u73DUjInfZebo80YI=;
	b=UmPGhcVKvgK1DAw5pNYVgjxGAhMbn+e0jSLcNeU1lmJOgrOUWDFJ4eoP7/Fss9IRNawgd6
	EgkEVGAdKKJw5Zuzhf4QEynxK4cQfRAtJhXZRrer3GjOqUPUfhAkGgIMxd8aXCw3QJi8xr
	JChK2DS4bHNNLo2RAFoH7vbseQ9eftc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-4Pp8IIsdO9WiKTWHKKqYIA-1; Wed,
 13 Aug 2025 07:14:12 -0400
X-MC-Unique: 4Pp8IIsdO9WiKTWHKKqYIA-1
X-Mimecast-MFC-AGG-ID: 4Pp8IIsdO9WiKTWHKKqYIA_1755083650
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F1FC61800291;
	Wed, 13 Aug 2025 11:14:09 +0000 (UTC)
Received: from localhost (unknown [10.72.112.177])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0043630001A1;
	Wed, 13 Aug 2025 11:14:07 +0000 (UTC)
Date: Wed, 13 Aug 2025 19:14:02 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	sj@kernel.org, lorenzo.stoakes@oracle.com, elver@google.com,
	snovitoll@gmail.com
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv>
References: <20250812124941.69508-1-bhe@redhat.com>
 <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
 <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B34C1C0005
X-Stat-Signature: 13unzpreoqprmmo5rh1kwwjau4kxa5yu
X-Rspam-User: 
X-HE-Tag: 1755083656-857926
X-HE-Meta: U2FsdGVkX1+EqnZc2FpdMKbwAXgvQdMXyGIqt9L8ebZjd3PNyn7NIqdxlAeIo5GCdJ2HXwvKvuJKVuWoKc3j/qTyX57Rwmk367ifsw/+ssCWv78MK9j1531adbIbaHGFaJgUf8p76NWaa51lCsxAXQugMTfgVmt+8jzcfsu/mRmtk2UZ6yEVEZ9FF3pLdsv3RY3ZGKu9244ROixa10RC0kTsxpSFDhVBlim9i7brVrRCWqr0hvFxhYRc+IdcAWWGstsvFjgsH4xxSXUheID41JUyhAm9pIt9+gzxuY19BcHF5b6672Z9YRqQyJR/YmI1K6RuNi5QiJdOnUjk0OCkoeuhHZ88T0+Ge2+AOF33OaFJdiYHVqwPAxi2jkL+FahL4L3JnCBnn3s2bsM9Crw6LYkmfDbRfFwREpY+XDq/SGSAWBHEocQ4HopsXpxdvMNuShPogb/ZwhmDN/AvStSjcEpKKDHVFNyuCJRzjNi+spbUiC6fNvH7VpnXMx/g025uYEb4d229ZaeWibPcO00RgVTYhCPVT1whXFVgHB09rDiMFYjG0wxRV/a1B58lKzIuuAFErlow3FBmunBoQ/9K3Ghl4xbVkpVaRgIrUIpSWM4/9omz0PP8bxCOJyCjdOQlqJ+E+uVILm+DqrHgxkqy+A9bXEYROFbLZkb3wgvZY21dbfKFq3qu4AAUXP45NuOn7Eqj5BAWm3vvDUR5l2xer7Rucrd/xaX2RIs4HW2j3GbtImb9aeAjcnKchyOSkphkYow1o6gLESidQWGYKtpMblolUIIdu1BvVbbKqGDx2TXbKFym4hrbH95PMHoOMeZ7bJw+8m+yP1I38tG4Q3KrsL6F2v0Cl7SPSEF4h4Gp2EU2WNtpYY5K4GEo29U9huZiOI/GQW0wZNyj9NNPxrZ/D1q5pPAiBGoGJxQTHaj8voNHjnGkF+XmJj03Uf+wx3FcVtvrQeRmcCkHDcYZ6YV
 jg/OxRnO
 FFck1+hOierssVUleSSltoIH3tPPZ4n3eRJPTPhTKTxNAWbHg0f9KEZMeKHQfQi9bXzYMHyweCGZ21iHFBeNV4A/dn0KzKhEdSfk+gXVIX4hS00MbL4JtRUrQ1CVEV6IHLdtKHCF7+GegRswrct0UixhUX6pbRBz8SP9hnu9kzXjZsItAShVl4Fzx85GeuQF7WWftBxm2lFG2GIdwwqZ4RHtJvuifNxl8q4L0e8sD50+RywpWyD/tM0EV+OmlTPWb+lVgL/a8NyGr/5v2MOh8znnZR4Zx/pnIS+D6Wck77ENSBOX/HndUAnLe/4prS71rmGs6Y1xHVHGDQakQqm24/O0TRg4xOXuyg7iGyDqBx8LSiRIhy/y83q0iuvQcS/7ecpTUr+nfr4kLeQm1GeS+HFh3OZVV7ai92hbtKyJSQVCCLDXa8rdOX6dTc7uIhrNIpfLhVAFHiqwMjW1T6d8/wK2tNBY4RlWQLwmu2SYCoIKw3+jS8CWMErtcCKDfwZdUuaxVLFo2cWXvTJmqUf6UrnhyfhMMPguIc13m2AIk7LoT+gQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/12/25 at 07:14pm, Andrey Konovalov wrote:
> On Tue, Aug 12, 2025 at 6:57 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> >
> > On Tue, Aug 12, 2025 at 2:49 PM Baoquan He <bhe@redhat.com> wrote:
> > >
> > > Currently only hw_tags mode of kasan can be enabled or disabled with
> > > kernel parameter kasan=on|off for built kernel. For kasan generic and
> > > sw_tags mode, there's no way to disable them once kernel is built.
> > > This is not convenient sometime, e.g in system kdump is configured.
> > > When the 1st kernel has KASAN enabled and crash triggered to switch to
> > > kdump kernel, the generic or sw_tags mode will cost much extra memory
> > > for kasan shadow while in fact it's meaningless to have kasan in kdump
> > > kernel.
> > >
> > > So this patchset moves the kasan=on|off out of hw_tags scope and into
> > > common code to make it visible in generic and sw_tags mode too. Then we
> > > can add kasan=off in kdump kernel to reduce the unneeded meomry cost for
> > > kasan.
> >
> > Hi Baoquan,
> >
> > Could you clarify what are you trying to achieve by disabling
> > Generic/SW_TAGS KASAN via command-line? Do you want not to see any
> > KASAN reports produced? Or gain back the performance?
> >
> > Because for the no reports goal, it would be much easier to add a
> > command-line parameter to silent the reports.
> >
> > And the performance goal can only be partially achieved, as you cannot
> > remove the compiler instrumentation without rebuilding the kernel.
> > (What are the boot times for KASAN_GENERIC=n vs KASAN_GENERIC=y +
> > kasan=off vs KASAN_GENERIC=y btw?)
> >

Thanks a lot for checking this.

> 
> Ah, you don't want the shadow memory for kdump, sorry, I somehow missed that.

Yeah, for kdump kernel, the shadow is a heavy burden, and most
importantly kasan is useless for kdump. We don't want to capture a
kernel memory bug through kdump kernel running becuase kdump is a
debugging mechanism.

> 
> I'm not familiar with the internals of kdump, but would it be
> possible/reasonable to teach kdump to ignore the KASAN shadow region?

Yes, we can teach kdump to do that. Then people may hate those conditional
check "if (is_kdump_kernel())" being added in kasan code. E.g even
though we skip kasan_init(), we still need to check is_kdump_kernel()
in kasan_populate_vmalloc(), right? 

Combined with the existing kasan_arch_is_ready(), it will make kasan code
ugly. I planned to add kasan_enabled() via static key
kasan_flag_enabled, then it can also easily remove kasan_arch_is_ready()
cleanly.


