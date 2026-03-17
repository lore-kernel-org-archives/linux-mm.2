Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AA3FB5EA8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 03:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91CE6B0005; Mon, 16 Mar 2026 23:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A427B6B0088; Mon, 16 Mar 2026 23:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958AE6B0089; Mon, 16 Mar 2026 23:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F31A6B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:36:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 345FF1C0DD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:36:52 +0000 (UTC)
X-FDA: 84554143464.05.AAEA2EA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72DA2140004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:36:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TcC9BFK0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773718610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zB79a/FOENLHI8FCWiGrvfZkVLmqf3PzewX8k2/xZr0=;
	b=vRX9VA1e4tT2PJmQLgDJSkepY59Y9kFjuzH/9YaaVQesUbcKlQACrPmXVQpZu/flGGCyw5
	F+ZDRYQi7Vd9lKH1LARZ02LlB3741rmwFGDtsjte8IyYN8p4nN+OITqvnxDXAixw8Z8VnA
	IF/fNlBdne8ehUB7eUFr7YgZbgmTOM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773718610; a=rsa-sha256;
	cv=none;
	b=ILK9Sk3QSge0JhMU31TSPdSIDrdDTHarMaV3wBUOKBJ+gLk8vAfo3aHTqKN+cHGOI/2qvo
	BBxEYF/ZYvScuSv/ucjdHHbADEsfE1xJVK3YZ2EISv0I4A2ZbRCqR+xtyIKULq6E6REPOp
	qOJ0prnEvop3Ui+OylDGRaKpT6hpDC0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TcC9BFK0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773718609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zB79a/FOENLHI8FCWiGrvfZkVLmqf3PzewX8k2/xZr0=;
	b=TcC9BFK0I6D9tCsikKVFGgvMK0rgEJVXrZhzwmjcTu/dZUaeCFuNTZjpMq5rIV/xJgSNGq
	HxxogFElamGFhBLpN+cuZV96YfLWY320m93kGagPRkeGpQxwxcEPX7fSKrNE/zNjrOHGKu
	f1HHh6RK9rheOKR9hlYKrsDBY/3kIa0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-568-ivqPJgBFMnCWlq80myHG4g-1; Mon,
 16 Mar 2026 23:36:42 -0400
X-MC-Unique: ivqPJgBFMnCWlq80myHG4g-1
X-Mimecast-MFC-AGG-ID: ivqPJgBFMnCWlq80myHG4g_1773718600
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AF9A195608B;
	Tue, 17 Mar 2026 03:36:39 +0000 (UTC)
Received: from localhost (unknown [10.72.112.155])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 414B31800361;
	Tue, 17 Mar 2026 03:36:35 +0000 (UTC)
Date: Tue, 17 Mar 2026 11:36:31 +0800
From: Baoquan He <bhe@redhat.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
	x86@kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org, hca@linux.ibm.com
Subject: Re: [PATCH v5 14/15] mm/kasan: add document into
 kernel-parameters.txt
Message-ID: <abjMP58VdUu_eElh@fedora>
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-15-bhe@redhat.com>
 <f7054184-dca2-4c7c-9e2e-4a5e3e1c81da@sifive.com>
MIME-Version: 1.0
In-Reply-To: <f7054184-dca2-4c7c-9e2e-4a5e3e1c81da@sifive.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: cN8EuR-pW2-QulAS9vke2bjgQPqoJO4xvl1WFwY5IBc_1773718600
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72DA2140004
X-Stat-Signature: g84np1ab6zg7n39twhjopcwzzpq8g8xf
X-Rspam-User: 
X-HE-Tag: 1773718610-573184
X-HE-Meta: U2FsdGVkX1+clVDqN1D9Dn9io+bsYYABMeOK20uduQ7mZQMfydeG02Hi3cKT0SkqpYjVnGhhI+ZF/f8mJY5nKv/mRV+7kPz7VfTTAUVbFPoyRDcgtO183A4zAHPYeyWoflyUxEctfKEShp0vhD9aQRK3TNSmCINMGltC8g6TLCMIcKtY6qC8SzO6h2LFJSR/YlKj/CeTa6enR9oodLKk0Ub3EwhZnJJo+fvtrYPo5lHgiOqsEwjz2bUH46M5VqKJm1Jblnk74HTiOLY7O5Cz9TwLmxI30noBD9AaKJKKsgXG3PdFOK6rkIkvCOvrIBzlAdQCTYS1Gv+wgieavJN+Lc1iMhtqfL9GjEpuVf7bGeLxjCK8iz6gdUb5YVMs++wz34tgHS7abYCGKbz29pGs6+3oEtei0mOlh1AxytC57kCS29lvWlAQpjPzrDEk2fovY4QI7R+T96oZompOIwicqxXaoAtLH1OioGqsB0/aBLAEYsKZXVOS/j09/g4nxAFSDd+p6OktXOJ0XjVareVLIf7Cd3eJXa3UI3Nlu46OOIJ3pk4uoUMPmJ1P3nJerfit0CIAGMiIePJNOBW1YiUd9dIezzXDZuojF626IwCW8/ParUYzGZYeAvQRtqGH19lyuNHZuLm7JH1xHutqoMVlQqfsKO+6c/b75Mb7iWKY4rERdrnsBO3CCs3XqTFhTzxmkCoxez+kuPBG2Gg7YfqVD8KK1D73R4p7A26thqbRD5tMVDQQDqTVp1og6M6LsZB5evUfU0GeUa7oqY4OH47BVauHb/sdKuRgPoQh6F8OLooBhPKV1ALliN0sj7TrTJAQ8dtAIVt+POZAnQHDi+gHb7KrHlkv6hZdffEEpHX0c8XJNUZUoeZrUyPFpn+EyPBVhOOti8AsmPxTJrdFhb7ngMcswOZbXh3CGCexY72v5iZ1PPagHJUcoReP3YOEdFj1dNb2DknmzFTWl4OKhZx
 YJfbKD+h
 yJEtJh6ocq5vFDNxfG4gMuW1SjOS9dmmaDIFsBgao3Lfy9AqRPQnqLgTlwOrL6i+SGnHO04lomBCcUClFXjvWxfvAlIenna0pozWl2C++sgprsrCMWJ4hpLdf1QQpzC6pnAlDqe5piaorhV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/12/26 at 07:53am, Samuel Holland wrote:
> Hi Baoquan,
> 
> On 2026-02-25 2:14 AM, Baoquan He wrote:
> > And also remove the relevant description in dev-tools/kasan.rst
> > which is hw_tags specificially.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
> >  Documentation/dev-tools/kasan.rst               | 2 --
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index cb850e5290c2..e0115fad9e60 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2899,6 +2899,10 @@ Kernel parameters
> >  	js=		[HW,JOY] Analog joystick
> >  			See Documentation/input/joydev/joystick.rst.
> >  
> > +	kasan=		[KNL] controls whether KASAN is enabled.
> > +			Format: off | on
> > +			default: on
> > +
> >  	kasan_multi_shot
> >  			[KNL] Enforce KASAN (Kernel Address Sanitizer) to print
> >  			report on every invalid memory access. Without this
> > diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
> > index a034700da7c4..eaae83fcb5e4 100644
> > --- a/Documentation/dev-tools/kasan.rst
> > +++ b/Documentation/dev-tools/kasan.rst
> > @@ -129,8 +129,6 @@ Hardware Tag-Based KASAN mode is intended for use in production as a security
> >  mitigation. Therefore, it supports additional boot parameters that allow
> >  disabling KASAN altogether or controlling its features:
> 
> The sentence above is now incorrect as well. I would recommend documenting the
> parameter earlier in the "Boot parameters" section instead of removing it from
> this document entirely.

Good catch and the suggestion is good to me. Thanks.

Is below change OK to you?


From 317be48b9c1bf9d33b8d8fff5e401e3155531d81 Mon Sep 17 00:00:00 2001
From: Baoquan He <bhe@redhat.com>
Date: Tue, 17 Mar 2026 11:28:39 +0800
Subject: [PATCH] mm/kasan: adjust documentation
Content-type: text/plain

To reflect the change of kasan=on|off.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 Documentation/dev-tools/kasan.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/kasan.rst b/Documentation/dev-tools/kasan.rst
index a034700da7c4..8e65bc04dbcd 100644
--- a/Documentation/dev-tools/kasan.rst
+++ b/Documentation/dev-tools/kasan.rst
@@ -103,6 +103,9 @@ Boot parameters
 KASAN is affected by the generic ``panic_on_warn`` command line parameter.
 When it is enabled, KASAN panics the kernel after printing a bug report.
 
+The generic ``kasan=off`` or ``=on`` command line parameter controls
+whether KASAN is enabled (default: ``on``).
+
 By default, KASAN prints a bug report only for the first invalid memory access.
 With ``kasan_multi_shot``, KASAN prints a report on every invalid access. This
 effectively disables ``panic_on_warn`` for KASAN reports.
@@ -127,9 +130,7 @@ modes below) support altering stack trace collection behavior:
 
 Hardware Tag-Based KASAN mode is intended for use in production as a security
 mitigation. Therefore, it supports additional boot parameters that allow
-disabling KASAN altogether or controlling its features:
-
-- ``kasan=off`` or ``=on`` controls whether KASAN is enabled (default: ``on``).
+controlling its features:
 
 - ``kasan.mode=sync``, ``=async`` or ``=asymm`` controls whether KASAN
   is configured in synchronous, asynchronous or asymmetric mode of
-- 
2.52.0


