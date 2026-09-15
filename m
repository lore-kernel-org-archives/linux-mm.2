Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2830CC982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFBF6B0092; Tue, 15 Sep 2026 08:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458BA6B0095; Tue, 15 Sep 2026 08:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347786B0096; Tue, 15 Sep 2026 08:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 164A36B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:05:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F3EDC03B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:05:29 +0000 (UTC)
X-FDA: 85215866778.26.CFEBA18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C2FA540002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:05:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ciTyjsYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473927;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fBEtIbr3AFyAksoQqS3Fbydy5vpB4nMaKZT39mGc48=;
	b=hPk6wecHwfM/+crKnL1NryPhbhmmv6dM1D2/DPLjDjluZT2zB4rylA1BAe06PKcy0yvGEa
	znbBc+th7QBfULBQntAP6RLqLpPeCPykWWhgR1rBnJB0pZGkxZRetNfCUA357R+0mS37lc
	ut4cN/zWA0dx33oeWQve3mO1JXsBqCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473927;
	b=b8GA74/nbWGdN1bgvoRS8YpK2votJnpGlC3pliblXx5NzwffJk+59Wrb4FbjjfXRPWsIx5
	raKycO0NRwgYhW+EMQL8gte6xz6nnrIQlWpjmfkeamBVKl+sCfrDTbQr23E4Rg0sHb03bI
	B7gEdOprVHdLs3fYIqFzejSoYw+5VfQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ciTyjsYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 618BA60261;
	Tue, 15 Sep 2026 12:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4910B1F000FF;
	Tue, 15 Sep 2026 12:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473927;
	bh=9fBEtIbr3AFyAksoQqS3Fbydy5vpB4nMaKZT39mGc48=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ciTyjsYio6YcUd6U+CzkUXMFWJVI5JN8YpF3LWAF35D4RcZO6WNyNNLXWTcTNKx/k
	 phMotj0kCSRJiLRwEB6PukDAqeOWTf+ZkB0jp+D5F2leVdFoUNkcjEaKJx1upIioCP
	 CUcHsmrqrKX9GAlkCPX6E26buGa/rDYMQLBRn2YZpYiLqv6kE2OPMZp+B2G/43JgPY
	 VQ3gvXiSdHMDyE74NA/AxGmidg9o/oGBR74v2qXcAt1S74qyth1DbIflVP8V9zvpQm
	 0rcjVCp5RxoIduGdCiF4608I/waS+6ME56RhQGnLGMkkRdYNrNVYyQVY30p5DEkuKy
	 JPaEc4INykdeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 25/50] file: reimplement FD_PREPARE() on the
 deferred fd_prepare() path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linus Torvalds" <torvalds@linux-foundation.org>, "Christian Brauner" <brauner@kernel.org>
Cc: "Jens Axboe" <axboe@kernel.dk>, "Peter Zijlstra" <peterz@infradead.org>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, linux-mm@kvack.org, linux-hyperv@vger.kernel.org, linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org, linux-gpio@vger.kernel.org, virtualization@lists.linux.dev, "Ingo
 Molnar" <mingo@redhat.com>, linux-um@lists.infradead.org, dri-devel@lists.freedesktop.org, linux-csky@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, bpf@vger.kernel.org, linux-snps-arc@lists.infradead.org, io-uring@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org, linux-arm-msm@vger.kernel.org, "Jann
 Horn" <jannh@google.com>, "David Airlie" <airlied@redhat.com>, linux-sh@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-25-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-25-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:05:24 +0000
Message-Id: <20260915120525.4910B1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C2FA540002
X-Stat-Signature: sghau7my8ktrgw5qo9coajrdets7egot
X-HE-Tag: 1789473927-735885
X-HE-Meta: U2FsdGVkX1+0UKs/agCqD7UQEGdG0rhu2jjX+Dml5XJwq+7nNSNV5YlXPP1FEQFU2bxtfhWdVdKfErXUHdfMLQ5b0nkagNuJDESqQJ3v1qCTfNENnt9mZk+MlTUrQFiPkdzrnVKZIDMnC065wY8ch/7vpg5jbsmDPjTL2Cc1ghw9tOYZ840nm6Ku1chWMNLyVlAv5y+6ndQoRM6JPxT+cWpXmPK10fmli80fNZZHIZKFKYVOROL1awY52ORzPeJ4t3tkPc/DViNOSEI3PlA65tMCSiVaiOQsVOGD6br7xjS9oPl3KvwGkpL2ew8nRsde0FkAQhuwOLy+c3PMIbGbCY7AGxmcWIVQ70Hrye0nTpaZrHNvE1y9SbhkwT/6R+jcT4EzqH9bJUmr98WOvm62gLluARZWfMpauI7yhNtgmChOBxK3MwdD2GMJFRed9Q6NCQQ+gAwjA6Jv8yCyUijEQzbmsRjpgCt3wHqbv1YhohRVl2qATQ4UX+1jpF/HOQiFvUaipkQxJVCG0uJ5jyTamPVSMQ3uul5vyTlzW7XT5HcER3KzClp80vhDiao6LtSK5eiOCFTybAUxepY8Km2ELADHQV8V/TFhAZf90BF4j2z2DC5oUjqJqGzrHiRobNOtzZ5tDnQumVZ02X1CdpclbLNb1BWqyt2PqX2kh2huNQfEhPD8CQoy0GiW551TrSvDhG8bR6BP6AW32veEPXJ83diVsJW8iT481B/yxMcvQEpNYxiwkzsy/0ZBJdogndzGbr4P/n8BtPmlXStm1GdCvEd4qnEKH8zUtQGeAQ+NsIsHJW31+vcGZsLGP6tlh0aqzt1DJnmc8YqPDPJHrLtYn4uVDmRaS31hKunGyaVvOYmGZTFfcThY19pWSoRyhNoZ3hsy4gLtpdGkoEun5peer02UXfaH8BrS26MgMLN/Bel75NlI2FtUFE5c5V+n6ALiN3NZLu4fpngUvyCaOhN
 768Yy33A
 tk5ENKLQNrb3RW7PDpPLqT//eJ5/uaWRuRYGbjK+6KNESceiAz5ogdFHYUpjxVKevEVr4PHFkp/+RXT+NRcTdRdi2mnX+kSQ5Tp5B0D7TwlxDcOiO9TK1Q2AAfJ+Q9jZnAVGwwUXGB2ZiYqQjKON2kh6TViVlWcUx7O7eCKl3iDMHi8deX4MRQSdtOzAHpKZ9giy2a8eQRbP5hXkzhn8Nn9rJRc5tEPwtLgh+2wcXXhk6y8CF7/YbSywE65SdrcUvAuRs9JY/Y6KQrhzZA0BhQA/v0YtSxMI+pAD0pa0CnikON3mpkS7FjN5JAREsS2zzIIxi7jakc0uCqOHh4acOugBwnp+vQK0uT0oImOM+vRnx75q2MaNRfMPgFu0j+EvoHzT/YIXf98jgtLeK2iYJbiTiR2sunFuXr8B8vhCGirHogXGYjUyNcxSBVOxOu5KK6lQ7XipBBtShFAbBqGCakvdmztKOmlngIfKeEsIzvfMtWUatx9m/sFRA4Rs/y8QrhvsBV4ONECX2gTZmNrdXi0Qp4d5kqS5kApg49wvmyxB3W/pPn2k6jcUYv7pYH9ARA9Cm2G9nK9MNk28WRh7YWg9cw4kHXQrnbtvCstiAX+jpFXrKwASao3/jqsQ+hidiKkl1l7Yr2ZhDQoWhpwWOrCajxxj0Ip71wuFY1da6LFJmUmatJRQyVvm8katObP2GfsQnlFR3CZvIKlnqTNmU3BoWfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The FD_PREPARE() cleanup class allocated and installed immediately and
> required fd_publish() to be the last thing that could fail. Reimplement
> it on the deferred path. FD_PREPARE() reserves a slot with fd_prepare()
> and stages the file on it. The syscall exit installs on success and
> drops on error. fd_prepare_fd() and fd_prepare_file() now read the slot.
> fd_publish() is gone.
>=20
> Convert every FD_PREPARE() user since fdf.err can now become a simple
> IS_ERR(fdf).
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D25


