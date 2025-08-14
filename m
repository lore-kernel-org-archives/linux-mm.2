Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58184CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AB7900119; Thu, 14 Aug 2025 04:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC43A900088; Thu, 14 Aug 2025 04:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BBD900119; Thu, 14 Aug 2025 04:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE96E900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:56:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F95EC05DD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:56:20 +0000 (UTC)
X-FDA: 83774756520.18.4013360
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E32940008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:56:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fjENT/1a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755161778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e46B2FI/PagtxjUFemCdMQXhTSnu4yC2Ildyjyftxdo=;
	b=SjF6Jjwohen+C5apmgOE6zPmUPLY18uoKlG08nXzVhQ6R4IQ07+7PpEND3fHS9ZT6+5K/s
	QMmS8kj50Rf0WCb49O0lyQV67yUVCVTU8LE4hhfLrxZquslTWRI8yn/8gOMf2DkRBNsXDH
	JEt4snTL0yXc11xsExffaGTpF2O6cIM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fjENT/1a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755161778; a=rsa-sha256;
	cv=none;
	b=3Wot7KiB9efkGTZGR82MBlZQ/Vd6jsUbAsrALThUouqAr3DfNtNuZe+RJB0V/nWgeM02P+
	XvC8iZmqVD3b/F51bf7wHep+tN4VjgKiKZAO05LQfVEsA9gq8611x5l+dnI7SctfFL7xpE
	axb4U+OjU6CMyDxYy/pvoXsC/I4GVtA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755161777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e46B2FI/PagtxjUFemCdMQXhTSnu4yC2Ildyjyftxdo=;
	b=fjENT/1aTBRHuYoJHgVu+ygI9lGAS1rL92sAS+gxJFxk9b3KHumv00tNOqnB10J1E7YwER
	ZfrWzJIJrbg10Ea95cpNz26VEcbD1aZ6CvlEAw9u2lbRoOXj9vSNtKQ0I64ap+fbsXJjRQ
	r1ezQJaBaCLwg3+svjQ6I9m2Jn/qVhQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-422-3SOjFLgDMcqA9Xa_jao8Yg-1; Thu,
 14 Aug 2025 04:56:13 -0400
X-MC-Unique: 3SOjFLgDMcqA9Xa_jao8Yg-1
X-Mimecast-MFC-AGG-ID: 3SOjFLgDMcqA9Xa_jao8Yg_1755161771
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEB141956060;
	Thu, 14 Aug 2025 08:56:10 +0000 (UTC)
Received: from localhost (unknown [10.72.112.89])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B73811800446;
	Thu, 14 Aug 2025 08:56:08 +0000 (UTC)
Date: Thu, 14 Aug 2025 16:56:04 +0800
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
Message-ID: <aJ2kpEVB4Anyyo/K@MiWiFi-R3L-srv>
References: <20250812124941.69508-1-bhe@redhat.com>
 <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
 <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com>
 <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv>
 <CA+fCnZfv9sbHuRVy8G9QdbKaaeO-Vguf7b2Atc5WXEs+uJx0YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZfv9sbHuRVy8G9QdbKaaeO-Vguf7b2Atc5WXEs+uJx0YQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6E32940008
X-Stat-Signature: 3pb1899ns6opspnhnc9kys1w18wzijdb
X-Rspam-User: 
X-HE-Tag: 1755161778-646928
X-HE-Meta: U2FsdGVkX19vrHBEk8GSxb1mz2o+odCl5st+LH8lQtBWi2TTkn8miJ4c4UUpCZRTxrU6Nx3TONyYJpH7MWOmc43h7DkZokqOhL8xzS+QkvOcamR8NrMqC4RJQaKq8UUL81zsf+YKnxm2p+yrRREL+ahau1NJn+N3yQqGMiYn5muvdBb+fNbVJDTDNrekRdFZl1khRizdMdRxgmrqMOElF6WyFFbu1nfSBrxRAXs3Ly/jMwuXdlKpvFl0pSK+x7j65iIwfskBn3xrnUCGazTBo7JEgiLfTUKENuXDiNV/1dBkUI7Z4vBJR0clbxer441YPHHXSzab+AqVjly9/amWpkqdJREeRQXX90QGH05IqdIO8T5De7FFXoKOEN5gi72Q9Ya22xnyWoWY6vp6hjw6EDEFnEnakz71Z9V+Cn5Xl4eGSM+EeBb4C9IT8rvIRYoBMp0JGVGkcxvlzbZxQ7vAjbLsw/e/oZX4ii6DIpUPXT92RYYtpHNzSSaSGLeIZmu7csa7xHDEwvUvNRpuaXcwoJ5eOlBGCJMhDT1Bx10Nrs0/OwMjlQe7EQVe++uIQqwHMPnItPhhB+o44hZraMnJWVZ/ZDQmDU5f60mzTpmeZ655yaJtjW35x0+K88PgA52RShkHixGlirvweFbGI+tq3L1Or76vXnHMkH92ZmqjQFdQBExE/jAl+oL3WbjZI/foPQkoRtL+tsCwB0fGbPkHjFwJE24Xi9Or3cbvCA16fDan2UhFjLmkfihoGH2W42pqacCJbnhklARBoN9YtzJrdh5iws/kmCRyNhOa6iGxpq3a225o2EB5jIKDJQao4gsVA1eD9gD01qTHWWCzOe4IfuJ000mwH9I9gCO+qs49O8kPCvpdiGSAs1WspsggR3UNiX0eZSGqLs1w9NBH+SkcfIKztBPmlJPA3uEr5J+9n+bVvhk7Q+Oe+dwJ8FjWQqxg+ISBe3dK7V6WxNbUzwM
 0DNGWFNg
 lc/ilABvJfLa/JXGXq6FXwMllfk5FSQuDuljQIP4b83/D+Dci+icFMulkVxoSueCSTCi62VieNINODuUO+yfzg83CFsQF97EEoLG1L3qL1kjSNWn/cLHiAUoqw0nJcogZxvU5KezQFOvclGV7H6ZtnGV490RdGb2hWfS73P9A0a24QTh+7iIa+BM0z5R2d/eh+gV2d4F7FETGVlJwAzLMnS34dYg2VwErZMsyGL6WMteD98F1naOERLn4qBhb7fMhOwP26kuHl/JB1j2wI/rbXn+7DmT90iNgiEgnHAZ+JD8EHbo6yPqR4EsRu0WAxhXlTzzM2IfMmdxdJG7xfJX2VDnbJCpHkx7CyzU3x4pcxd7DEm/m56htCYkB7FhRskJ5ffeNVA9OXuaJ1y6y60t+wjtvnwYJYBw8ZXaGp4gA9/Wj2BZikMpKBxMKyKVJ3i/noII0udwvWB944rqy4QdvFtjabMiv2mWm2L6nQvF2eHTNaFf+7CRh/YkACuZT1Ubbd15+0oUpTeR1wrgix4TW5cfnOm3zqD/j9TLB5Z3Lglq/gZwjayga+aHQYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/14/25 at 07:23am, Andrey Konovalov wrote:
> On Wed, Aug 13, 2025 at 1:14 PM 'Baoquan He' via kasan-dev
> <kasan-dev@googlegroups.com> wrote:
> >
> > > I'm not familiar with the internals of kdump, but would it be
> > > possible/reasonable to teach kdump to ignore the KASAN shadow region?
> >
> > Yes, we can teach kdump to do that. Then people may hate those conditional
> > check "if (is_kdump_kernel())" being added in kasan code. E.g even
> > though we skip kasan_init(), we still need to check is_kdump_kernel()
> > in kasan_populate_vmalloc(), right?
> >
> > Combined with the existing kasan_arch_is_ready(), it will make kasan code
> > ugly. I planned to add kasan_enabled() via static key
> > kasan_flag_enabled, then it can also easily remove kasan_arch_is_ready()
> > cleanly.
> 
> What I had in mind was something different: into the kdump code, we
> add a check whether the region of memory it's trying to dump is the
> KASAN shadow, and make kdump not to dump this region.

Ah, I got what you mean. We probably are saying different things.

In order to record memory content of a corrupted kernel, we need reserve
a memory region during bootup of a normal kernel (usually called 1st
kernel) via kernel parameter crashkernel=nMB in advance. Then load
kernel into the crashkernel memory region, that means the region is not
usable for 1st kernel. When 1st kernel collapsed, we stop the 1st kernel
cpu/irq and warmly switch to the loaded kernel in the crashkernel memory
region (usually called kdump kernel). In kdump kernel, it boots up and
enable necessary features to read out the 1st kernel's memory content,
we usually use user space tool like makeudmpfile to filter out unwanted
memory content.

So this patchset intends to disable KASAN to decrease the crashkernel
meomry value because crashkernel is not usable for 1st kernel. As for
shadow memory of 1st kernel, we need recognize it and filter it away
in makedumpfile. 

> 
> Would this work? Would this help with the issue you have?
> 
> (I assume the problem is with the virtual region that is the shadow
> memory, as kdump would dump all RAM either way? If not, please clarify
> what how does the "heavy burden" that the shadow memory causes
> manifests.)
> 
> Thank you!
> 


