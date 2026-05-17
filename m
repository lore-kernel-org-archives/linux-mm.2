Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3272DCD4F25
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 07:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55CEE6B0005; Sun, 17 May 2026 03:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DDF6B0088; Sun, 17 May 2026 03:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCC86B008C; Sun, 17 May 2026 03:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3376B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 03:05:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B8DC11C1100
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:05:37 +0000 (UTC)
X-FDA: 84776026314.09.B11D659
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id A18FC80003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:05:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQeqrtok;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779001535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ltctjc7r1394XUJm5pCSTCzl1LWQxcKmwThNMn0v7fg=;
	b=eY2l+uYQkidd/5jtDoRWdrW6A5qWK7Z4NEV/kt65ivGkuKYJD3VsVkm0PfMRmCM2VRLUCz
	UhCEg2AjPX1WDdTSv2SwTd8sM5D0z7959SdZ2j/PWFWmh6cu/61k9k1rZZCGi1s4c53kz7
	eWLpJuQkTrAduzpGoSdyGsCZVmbjptk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TQeqrtok;
	spf=pass (imf02.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779001535; a=rsa-sha256;
	cv=none;
	b=SZiKhNCUbBcydIg8E0l4Fhh3nJypKmGwFisanZRwDc333TlkBz99AUxC+6BASx1nepg6cY
	56X5SCD/mmgS1wryShk4RmjBSvsLU6pVe6fQr0DoiGc2tODLchCyVm4xJwEiCTQYgVq19D
	etcwXYIyHZ1ZA7V43vwKoEAj+hkOhEE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779001534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ltctjc7r1394XUJm5pCSTCzl1LWQxcKmwThNMn0v7fg=;
	b=TQeqrtokp5Cu6eR8V/pxXbLNQa8lyUVErX0cpgG95pabKxCbXKtHp96xKOSikM/Hyg75OZ
	YPOSXNiB5F1eEJ9bR0ShNXYhrTPrYkWFMUlURgtHMZTuaajhhcyRWTx1oOgA9OTiRu+wsc
	5UCucQb8HE93MStrJ24qlGs3zH/3W0Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-PArAzHE2NUKdsnNN-yOTDQ-1; Sun,
 17 May 2026 03:05:31 -0400
X-MC-Unique: PArAzHE2NUKdsnNN-yOTDQ-1
X-Mimecast-MFC-AGG-ID: PArAzHE2NUKdsnNN-yOTDQ_1779001530
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACA8519560AA;
	Sun, 17 May 2026 07:05:29 +0000 (UTC)
Received: from fedora (unknown [10.44.48.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B6AE81800762;
	Sun, 17 May 2026 07:05:27 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 17 May 2026 09:05:29 +0200 (CEST)
Date: Sun, 17 May 2026 09:05:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal()
 checks
Message-ID: <aglotu9HOXmwMM35@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
 <abld-ilvMEZ7VgMw@redhat.com>
 <20260317113452.cede9a514dfed36a1cb0e5a9@linux-foundation.org>
 <abmmnjgxrrGLKn2D@redhat.com>
 <5acfea15-f2f7-4498-86e1-a383e17adad0@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
In-Reply-To: <5acfea15-f2f7-4498-86e1-a383e17adad0@I-love.SAKURA.ne.jp>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: vQ91D8U1V0-QxxH31L8Uxq5xCWNlWMjvpuejAWvqc7U_1779001530
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: x8qw9zqg6omoemscin9xpf6hokyjud1n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A18FC80003
X-Rspam-User: 
X-HE-Tag: 1779001535-953308
X-HE-Meta: U2FsdGVkX19torosyqOsaVCGWQZO2d2GlunuZtFToef5XaxCvbVqc5UdlAd9A+YP58Za85gzwI/3NQgumfvcoEm/AoFndJ3onel8HLnpRXPGkLM/XvoRoZEUqCJ4K4+RKvyQB3izpv2JFmLU8HOYbm2xpND7fWXerrpeoASO0IdXTtUc4i2IsapipyXoQj/iiZ4a71LhWIdGzWV6eu8U+FdQtKar1bUTURmXC9rN7P29g5R+MA83nj3t/irEDqg98BLtROXkbD5WXxHcgpXhQDRsw4ABS+YRLFmfCyug7tbYIRWSW7gOsUkfGRbjuNMwUi8KKUYOGrqBQ8PjXHRwQCkTgKVJtHin9c7aPIGM0XkRMDtw6+Um3IGHGaHDcSU7xKGhs0HjDZIDKwYUin/ipc+8naU3hdWOzv0B/J67HwJKe+osOk+Rj6qCD4TgIPY4nxh0P2epi5PqicSQeXoP9azm8Phe9UATsW4pUcUAfPekcpk1Q5jrZpRwcXvASSeXhtorUoqfsPQ9bfuF3NZJKlflGSsSvJQ5vmBrAfuQPlNqFgpgcGcm+pIlAcNMWGDQx8m2vMCp4iWdy2c0f0yE1AksaQZM+XXOyri++hndATWCss7IWVXpxQEB5PLw1vy74irsIg+QnD3TcqxgShh+dWI2yxODw6b8m1ch4CI5GbED/Azfldww7gup1wT87AVMa8+Jhi4dgsSvXxLobbOjwwhNF71F4x80Uvw7C9ZDP8gE8fSrP8AblXLC2S27XEbhV0Y7er/3PfnZA82ybYMFEp1pQpNyYi5kalBGnPUa3qZ+t4w/Zo0sWNIEs5Dcf4X1AE309pjQOqpRwbM/zoI1WrDx0wHBZopNdUNtUGr4XzQ/bLI6mL4Rlz8qFNWjzf2fmlxgmUlYqrEgweFMpI7O9mQyUo3P+I2HnryX134oGPYiKJO/Dvo8DmPiiolU+2M1PJy0hB/eehy22JF6X/x
 bMcIwkYV
 7jFrAa4tiFyQ4ZzyNJ1IZp+ThzgQoBZ5weJhmc/SEJ6g2sVWoUYULh6DbAD7Tc7wy558urrs8PVuzioqfJ0/oi4qoEJkG+gQZOVDN1Xeh9PgBfTV6lb/Pq+g0kSZYA67u7SeKgR75JsKXzgYEOfuZNZaJF6olRFy669bcO4tPJ/rS2sE/fFJVGSvjrdVmkzm2LRfEwgkGKaOghbpD5Hp6qpnAVLONZcFqppCE3IxeWJV7UYv6xqpO7f0l9K1ceJRiGWUNqufjfIW0Blwg6ScK4U+yiyJrthFYUvmfIwld06ikRpODb9pUzS6V+63UHEGUi+XGfSKmvzIQ6S52TOzqaqwVtmPsQvIuDeXztLMuUFTsSWZJSUuHo6XsPk1OOPDvdansOGj6JfBdEI0a+pSBScXbafK59i916CoOfvBtd//mIFTPC6JuVca5xc4TuQ7TV7Gx1tcF1w6hcnQ28GnsGSQvaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/17, Tetsuo Handa wrote:
>
> On 2026/03/18 4:08, Oleg Nesterov wrote:
> > On 03/17, Andrew Morton wrote:
> >>
> >> On Tue, 17 Mar 2026 14:58:18 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> >>> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> >>> argument of do_notify_parent() must always be valid or we have a bug.
>
> No activity for two months. When is the fix expected to land to upstream?
> This bug allows a local unprivileged user to crash panic_on_warn=1 systems
> by running below program, and therefore should be fixed before Linux 7.1 is
> released.

This patch depends on

	[PATCH v3] kernel/fork: validate exit_signal in kernel_clone()
	https://lore.kernel.org/all/20260316151956.563558-1-kartikey406@gmail.com/

but it was merged without the patch above.

Andrew, that patch is still in mm tree,

	kernel-fork-validate-exit_signal-in-kernel_clone.patch

could you merge it as well?

Oleg.

> ----------
> #define _GNU_SOURCE
> #include <sched.h>
> 
> static int proc(void* arg) { return 0; }
> 
> int main(void) {
>         static char stack[8192];
>         return clone(proc, &stack[sizeof(stack) - 64], 127, 0) == -1;
> }
> ----------
> 


