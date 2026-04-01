Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E016AD2ED08
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1256B008A; Wed,  1 Apr 2026 09:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3883C6B008C; Wed,  1 Apr 2026 09:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29ED46B0092; Wed,  1 Apr 2026 09:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18DAE6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:47:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE81A1A089B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:47:01 +0000 (UTC)
X-FDA: 84610113042.24.A5DDB0D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92EEBC000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:46:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8BlmBtp;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775051219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EB1KQ617Kr5VhuoNKPvDM4wGdT34Y57wo3PzW9IfKw=;
	b=a/GXMZ+09LsQMkAvJ7xKgwRT0fPvna/pddmgqktoIpwh1o1oCg790wSdZGnylOF91qhzJA
	otB3CW9ElKS9ZsJPHq1K80IyOOIBDUMVh0GbF4ukEfBzi+3Enb3b9pKIgF0jRNm2ca4hMx
	IT97ek0/fdOigqXdspc9eQn3eC/nNYo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i8BlmBtp;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775051219; a=rsa-sha256;
	cv=none;
	b=7LFZCOOlyutZrCVvr2iZL2va87we24smNZ8g6DX0YSgsRY3QXwCrMVK9KanI0HYvGmBp4x
	JRcvVUp0bJUeY8Ae6Fr7/7eEHU+HQTz3ftJ/Pn/dPj2i2xDFBZTyiffrz+rXVghcMS1O7l
	uLoD7OBz48R5ikbqJPtBRK28ZLi7hbs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775051218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+EB1KQ617Kr5VhuoNKPvDM4wGdT34Y57wo3PzW9IfKw=;
	b=i8BlmBtpBwz+asNG1mj5bOJuBzFioMLUvD+GLuESW3Z6eEkSrh34zHJA9gyYEgym1Fhhrg
	0DKoL32lTm6yXzjKK6zmrEx8iLcNUgtNJ9+cfpHT9QlLve7zcARlz/2SHvzPfOV+NtDhRa
	VfQhOBbkXAPlL/RnR+FQieAGV2mvtA4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-H8Yb78HpM766BeEiqGoEjw-1; Wed,
 01 Apr 2026 09:46:54 -0400
X-MC-Unique: H8Yb78HpM766BeEiqGoEjw-1
X-Mimecast-MFC-AGG-ID: H8Yb78HpM766BeEiqGoEjw_1775051211
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C64DF19560A2;
	Wed,  1 Apr 2026 13:46:50 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.80])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B9421800767;
	Wed,  1 Apr 2026 13:46:39 +0000 (UTC)
Date: Wed, 1 Apr 2026 21:46:32 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Mark Brown <broonie@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <ac0huDc_GH2uSgsZ@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
 <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
MIME-Version: 1.0
In-Reply-To: <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: YThS0FZEKwBVF8Dy15_jOkEUxDHbzIX9_nXTAVat9ng_1775051211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92EEBC000D
X-Stat-Signature: smwu54s13wop6w1sz5e8jizzzyd1hif6
X-Rspam-User: 
X-HE-Tag: 1775051219-23335
X-HE-Meta: U2FsdGVkX18dftTaMwhEHEgWdfWGJKEDW4tn5XqQECU6ZbVmjJhRhHsQVAYHxWI6tCfeZDhip9GdZHppvC/I/iYKl/f6QXhXBWw1do+GJPG28Ou1HVOTxANK8PDLf7DqfjqlVXIbZPhq8RUmP6nQBEEi80RkAYpbuE/pndlXUL43qQqp727S6YbrqqbWXXbXmRZutWf4tUskU61PsFYboiukCQQej96gXsfM7MyeeedlFhDE0z2ary6rzgv4lcvdTJodSUlA6oUxIzb/pRUTPwg4TStx2kCG/ebydQnHEnrhtMaVl3nOQmWEL0xhXqrs7cdoGcwNNWUGWiDF7c80XJ+gZFRrtXiWWDk6y+09e3zBbKMWeyoBNBkldjO2TWnyv2CN/w3ezcBWIGUdKfkn7bL72+7bVpz/JMTDbMtK8aOk/ZmRiMaWSJoHpFQQfPENIgaRmLL8itSqldqwD+J1gNOHxB4SYZJ6vBe5avijKAY+CuDUMSj/IaR+JvwjFc3wCF8f0Q9/BhiysG9vM6fPfoZ9RJBIdq9msI/Tc1pGAjqUFHiVQjV9ZnHlka9UiUiVuTtOjDqQHyTAfraGaZKzAHVQ4bX0O8dGM+gRITTR9Vu0VmFcLar9+IB7MZZPdqyaICyJsw/RnteUKvS3PskkuF9ytyvmwA/cds8mgVQG7205nRVhAXFBsFZQct0Na7VO7HA8CE/OBjVMxEMbmrA01QiHzHjAg+z7o6SVKUawnIthKbH8AdpiKsy2+30B/nPElMZrDzRbsSpQ8aijGU1wzLTXPsivjQj2xLtTbS+2tRqvi3mHDTkQpX1cq1+E7ehHAXPKtBENPX/RDW8/Nfg14N0EoYg1P5VLqroGiOlhHMllHYzpIGU8dmCkzQ1ELIEKFb3olim/xKEfTYLxPlvuoqkotD705JFol77XZkVfySIoGHrES8sn1He5g5OZoNQcjS+O/Jx4cnoExzAMLKg
 29Nr8r6i
 Z2Zg963+wMsFOVQYFdjjkTO7hRQVsjHZpywCA9CafwbZuLbBBuKNDczVCZOkiRu4v/xarOpBvzsnV9U/PrRKii4+5Sv2SFTDPrNNp1s7MGCRSCXPgsvd4/cqqREw15pnPZRwST57EVFP39xDgqkx/t+wiy/iZjFgF4Z3TJq270G7cAvSwCMadjLDHbTu8TSx+XXAzaFQOryxm5+I6EJpKQ7rbiQZ3NSU2LaiQXQrEXeLkqddt5lZzy10jZjLhT4nVsdD06sAs+FdhG3hur02o8PQi5k/XzT9Wzd8/ALIbLva1WckyYhmngxh6pyvUpoqgY22+Wq43e3qDjOuVrOji/4PUVlBIYNKaNYTu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 12:03:09PM +0100, Mark Brown wrote:
> On Mon, Mar 30, 2026 at 11:15:00PM +0800, Chunyu Hu wrote:
> 
> > The ksft_exit_fail_perror function previously only accepted a single string
> > argument, which limited its flexibility for providing specific context to
> > failure messages.
> 
> > This change updates ksft_exit_fail_perror to support variable arguments,
> > similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enables
> > compile-time checking for format string correctness.
> 
> This is causing build regressions on the arm64 selftests:
> 
> /arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> In file included from za-fork.c:12:
> ../../kselftest.h: In function ‘ksft_exit_fail_perror’:
> ../../kselftest.h:427:13: error: implicit declaration of function ‘vasprintf’; d
> id you mean ‘vsprintf’? [-Wimplicit-function-declaration]
>   427 |         if (vasprintf(&buf, msg, args) == -1) {
>       |             ^~~~~~~~~
>       |             vsprintf
> 
> This is because za-fork uses nolibc which does not implement
> vasprintf().
> 
> I need to look at why this managed to pass the build testing I do in
> -next...

I can reproduce this issue with nolibc compile. Thanks for the
debugging. It's great if we have that definition in nolibc lib.

For thsi series, because according to man page, vasprintf()
requires _GNU_SOURCE, and implemeted it in kselftest.h will
add the burden to all c files, or fore a _GNU_SOURCE to
all c files included, I tend to go back to ksft_exit_fail_msg.
;)


