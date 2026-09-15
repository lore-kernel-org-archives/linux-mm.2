Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F51EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7156B00A1; Tue, 15 Sep 2026 08:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADD06B00A2; Tue, 15 Sep 2026 08:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5F76B00A3; Tue, 15 Sep 2026 08:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4899E6B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:00:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A7B81603BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:00:58 +0000 (UTC)
X-FDA: 85215855396.01.2F3FAC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D63DEA0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:00:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYtZVg6I;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MldQSLt+lfDM6akgn8f71Sps4Op9V02KPlLk0XcZRhc=;
	b=49KxchO1TGbe826f3jVpJSxstRnvRqyvnBXaXZlwSqeRrwUqA9shU98HobdaANhJ8/09mn
	AxhI/fhdBTHdtvIT4iYPJNulF/6lLWN7a8zdTTjDz1ZnJsyNTqRfbp7RorHsu/HCBkR7p+
	Tm987gU47N12AszXOjkQW/GX8tpmpFY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473656;
	b=k0Pe3G3tcgl+4v4AdCG1deOdmHExhtVyJiHUGhUdYwiSggcukRxCj4TlzlMzc3+woxrJpU
	D74W9utER0H4a/ns1It6DG5BuBZSyZxLxsQ07sM9JVICkBP96QFEzmOYRiYqfe9SgpaZMc
	5O9iuHx15MfXElYbcC1oLvohJTVRZg8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TYtZVg6I;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 389B141B2F;
	Tue, 15 Sep 2026 12:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE4C1F000FF;
	Tue, 15 Sep 2026 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473656;
	bh=MldQSLt+lfDM6akgn8f71Sps4Op9V02KPlLk0XcZRhc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TYtZVg6I4Bh2MSIVyOp4GLsBjyldHMWNSOFvEULmB/p14azRXWqSnww77YB7+TPqN
	 ScvufVzu/TJTXHoXtbu6nkMmHWq4H4dMpP1MqQSi0Nmrto4rdEsiZifxC0Gp3ctWOs
	 gVm0pQG3DVlsqt2P+zJAnwEEyISNTbCWqNK7nqDQbAM5w/PqbddR2Jr7q9aHUm+QFp
	 3CM71ghQDVb22etuVzHNdfC2YmQHMxeMwBg3BFoQVgyoGYCR1SeIZz2CuWCHLj4qhZ
	 TcgsJSPylBVRit7lOZeS75JIgRGNA5o89jEC9Doqt4/emxXQvDifGb95FahnRJnIlz
	 1NumvA/sq5Uew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 23/50] file: open-code receive_fd()'s immediate
 install
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-sh@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-openrisc@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linux-hyperv@vger.kernel.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jens Axboe" <axboe@kernel.dk>, linuxppc-dev@lists.ozlabs.org, linux-hexagon@vger.kernel.org, sparclinux@vger.kernel.org, kexec@lists.infradead.org, linux-gpio@vger.kernel.org, kvm@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFtdXRhYmxlKQ==?= <brauner@kernel.org>, "Eugenio
 Perez" <eperezma@redhat.com>, virtualization@lists.linux.dev, "Jann Horn" <jannh@google.com>, linux-mm@kvack.org, "Oleg
 Nesterov" <oleg@redhat.com>, linux-um@lists.infradead.org, linux-m68k@lists.linux-m68k.org, io-uring@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-alpha@vger.kernel.org, bpf@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-23-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-23-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:00:53 +0000
Message-Id: <20260915120054.5AE4C1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D63DEA0006
X-Stat-Signature: mzb1apn1i6oxoa5seo5k5jbpiurzayfz
X-Rspam-User: 
X-HE-Tag: 1789473656-23644
X-HE-Meta: U2FsdGVkX19y8cSLDdMsgulyFxtDLnbMdifU2VIX5cXij9SXXhi/cnzs9LRPa72VE/mhrgEqZ3dxPPyc1N3r01ygSRGWSHvR3RubsqqTbOjH+QFgPqo4dYtrP6n9V9dE4VvfQ9uCI7DsIbb0gcCnJoolGVCS2ed+gIe+886sDP2PNvWmpHuGKjaxjnTacAW7NgMkotNT4MJnxKtwphzmj29Vn69uROy3zzzskj2TL9K1tryXrHNOxkhDE2TsSH4OW0/IQ9lVJepTllqf1f4zDzyO007tffn11csrtOQ7c45CkW/Ubeo/5gLO1leKCY/SI8fPU9UgA4T27y3U20HjWhZLOfSD9Sbks/8MHhr/kjh8yX4V4+uEtGtbYq4y0uQ8hWUkIZ94g3CjSrGQkFx4kZRq4h8eWH6g3Zqd2i1M0FZGhzPToFOKcvAqx749U/1onqC2RmTBIG5vxqIQ53TKQXWzpNBLx8GuFw1Y7umVu01tV1N74xpTUl2QNuUqwiJnYuAXeT44Jz9yCVAFa2zdF9SH0vwLr6NQvItWmh/xfURlATN7UZbKI493EkIGhkCmquoyVzPsy3MXl6As7cqmc72ZlPeJFrUosmr0C9MIh2TwJDqswr7k2pIHWkbx1M51diGWdPw4N1k69p8d2az8AxfUf0S8bo4UEYS0L7xHf1eleuC3HtJ7ecvCDPwrUrvrBYldkAYdIDpSeLenHdqMPsdfURXZRy0LTM2wPsyRvni1IB+DWnHZSsxL8+XGBuIOu56FBu+HVjEPK+0pBdYoN/vLZ7hhVZfzgKfUri4LZMMlaabG47/1J7aAQ3vz7/+uEOIbSijJNCYt8csl8gE3rb4LrMJyFuAUZg6PiX/KWnMeJ1gIr/IkqPpFL2eFaXD25I2ehgP/kPYTmFpZ3eRiNXBm/smBehWAhOETiWOr607S6LKM06QBRrjOFv+rkByBJ7SO5o0rQsJ1dIWRa8t
 leLyXZAz
 na5UdEmD5zByD3U4OxbE0V8N+w/ITmlxduZG1DS2DWt0sbEMAz+589H68kOA8MM5tIztl8LTVtkGdzAmdTQ7+bp7RT14O7R9+ybys5/Aq7nT+sZjvFG7TAUyTEo/y67qYK+p6VB9QF3owmYeNHk9J761LIEjtX+R7ezjFBY3u2lSy1Gq5wv7Kek/sFzJ5BawR7eROJIVzB7fi7Mzihyde6uMvGxMKwRokjVz/4YsvAEyequslW+Q0O3xiehhYkx8dqZHsh0WUyjefRGBb8HfRu6HO+7OQUUFpLzUifLsrXI28eJLwIIrwaHPcAE/GY2Orjxu/yBuouxSBXozdHCjB6eoucH+icYP1OvYVsu8YMhpUBZ3hlam1UGK2d1Vj5NyXk59LRJHLl8+ZcjzKYPEGuNmtWsmnnwYi7M+kKJg3XBJrFWMX/SPGC8+2AYqOmRW111rgHNmp3YOcM0p519astQe7pALFuBUrKkBZaXvJ98H61xgvHSggAR0RO97ip5+VKoXMbn5cCrFggEjO+UuVL8qEXXvs2YjCfqGvbSQBbEwJAJkvzskZ3ec++Mlg/Mog7G+Svbz2u3bjSh7KnW0p6gHPBi3JbIx70XPkcsQWG4hOcawuo5EVUVnsmD4Ma7e44i9Nax+0Cog2XG3G7IQA0iQ2ORqG5m/3sziaV8PKhTN+L8gBNW5VCb6rMyJ2VVsoAQYrHGCP+zMPNboyPfGvIDEg2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> receive_fd() cannot defer to syscall exit as SECCOMP_IOCTL_NOTIF_ADDFD
> installs into the target task and hands the number to the supervisor
> and IORING_OP_FIXED_FD_INSTALL runs from an io_uring op. Open-code the
> get_unused_fd_flags() + fd_install() it did through FD_PREPARE().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D23


