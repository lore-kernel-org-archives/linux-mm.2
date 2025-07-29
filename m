Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB775C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 15:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4436B0092; Tue, 29 Jul 2025 11:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3EA6B0095; Tue, 29 Jul 2025 11:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0F16B0099; Tue, 29 Jul 2025 11:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6D76B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:58:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C641DC0174
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:58:34 +0000 (UTC)
X-FDA: 83717759748.18.EC0BEFE
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27414180007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:58:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g361NQMA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753804713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUws7AGIxuDaiAmJ5QmrWCWvtwZTbddWS9skeAxsvDQ=;
	b=2Uczb2msMeVvQzXxNegx1mqkdKtFWehhdmBH0NCgjiHl/NbLIJ6kkWntjrEY640CeGdwDh
	+O3yH1YAOfP3PGXFa6cYpySH8QyZil/NMfapguMIJTIqc8Ek/2hyM/ntl6tx/snh8Pwrpf
	nj/rmCGtOWcrV9SJ7H4NrVGCd0UnVDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753804713; a=rsa-sha256;
	cv=none;
	b=c+tqLqV3A9EgBAY1t+sZNteI6wfy4tkw4JW7jx6BPNnNMbGFABMA7U5H7e5zcx+J+y3qcT
	yeQmfo2T99ogrSCXQmYH+jaxvOMQtQii2tS2aEeQ0rayNb5oaCtNBQVxohBldNoVODyVv3
	eQUG8haUSxWFw6BJHmK5UHepoMYttbk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g361NQMA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 17DAB5C033C;
	Tue, 29 Jul 2025 15:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94145C4CEF4;
	Tue, 29 Jul 2025 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804711;
	bh=no5i8N4XqF2VNil69mGrq36vOP+MLLW27XGJe3Jnfxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g361NQMAs4PZrWjcf8MDRe94dm2xTN7NbdF7thEN/KXBr+PGlMUQkd8gz9FrEQqka
	 j1T+cmiSzC0qVT39PGoYSQvDF0kbh0QFbtLvnzZnso4Xy34bAIn4138wh7gid1OEAS
	 5LxCygZN34m5GkXvVeVE3ikqF8NmsNyp2C0ZysbpcUrJMkpgCo/1MQXDM3WFKyILdv
	 2yxYjaFGIyBQ1D69frMH0LB/uvkoS5D9AltLNySbXZi6y9bDszWhkbRiRqOcj+dR+b
	 tvUwwfF42/mMZEtQ2vrPMZNFDDrQZtbjpA17/HQXFgRnrCSCCruJ0tbQMQG10fmCxz
	 OisebVlldkzOA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] docs/mm/damon/design: fix typo
Date: Tue, 29 Jul 2025 08:58:29 -0700
Message-Id: <20250729155829.53913-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250729144414.31958-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jm478a8euiaq9brrsdg3wodh4s4oab85
X-Rspamd-Queue-Id: 27414180007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753804712-795899
X-HE-Meta: U2FsdGVkX19S+4JxpYvwfKqT9KrW5XXUrh2yblTRfK83B9Lvc2xkNRRhK1f5iEnAKdKuhYirbxm5hBWj6oF0uE61IDXlo4Hgcn85FDZpb5Ziu3xxCV8YxNIIelU3/cm5Uw2cZ692/REiGYSYRQsbg8q4z1F/nZ2dhjuRObTYZhHZMp4W0QlABG+U5NfFFEp8z1OqozOwwyJ5y3Yg/HhD5neI9WAMRKXD0d7ztw4bHQhh9G27zod08I81Y3OlzF3WL8OeC9Aw07w6Nw8jo0mdIpxIVRfWYazWH6fncs6UO2mOJUaWMyCuXXH17UjZAB9C/vaEdJUuOHHqjkZAXrIqNJEbliFwIr8zZ/0qIHnWSGmoMJwV95luB1tzYhI4YToHM60D6xWXkxI7lDkmDlYFTJIbZzwiE7tfFUV0FL66gk/1vEXtNGu4ZZ3vj4l/FVzwcCNWSF7v2RgoY+14zQOosqD2QoXQewjQWJ4dh+/9ryKDzvCPRlmeR3abqo6BdTcWdWS9XB5ZwnmIASbe3LuDjH//+y4WnAcbbkGKtKI8OvnY9Eppw2coNe6ZLdWVElEg1DqDgStCW6OeEpYxBUWX1VmPtKjlFG3pTGKuvXg8KuFyqVcAzXrOWaS9fim82nEL5asR2Z4SSYzjsl6ji3N4Dy+ea7RvgfFYu2BZpLWXmerg+UMvzq8+zoB1zuLQWREcE1QMFxkJtemnTOokxoCnWsEdiaJDkfWgW/cUwf5ro/eUrQIA2cDOa5mHpYi2hqe4tRSLmuS8qUWuszaaFL3sgDJlxlbnnCd2XCzcsMJ9SV3prtWARBcjObf9WkRG4g8/z7pW9c8mhwA25h0onOx/xYDJQyONR5fPi9tvip3DFC/dDXmWxg1AkE5Lw0k0RwdcRFUmpagBKK3CpXwiGD6Z4gUrVJKivIAnCRTlChfXHiqnq1RRiM6uQN7WXYFkWaIl999qM2u9t/1lmXI6xwr
 jofAzvEF
 You+j2u5et07SzpMA1lDbLd3ZAs2jvk2ys0Sw43KoZtAA2tjrf7VDEZs7MVhBhcpjiKKI1P8JVtpDK/E3DaXjjSukRyD135rNF3a4KZGYYPdaz0e+IX/efCEPLmfo9aFJ8cMOIIVPT1lwSt6GiyjlX7A1rLIzaVqJVLf1RqMwycmcsx+jPLQENnPjJFPgFn+f06/FYnXK/PmuXid7C/Wa10plBCUoDXTxs5qmZsRMDt3Ef9Hwvaaqe88K+E53Gp1HA5v+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 23:44:14 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> There are some typo in statistics section of DAMON design docs
> - sz_trtied -> sz_tried

Thank you for finding and fixing this!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> While studying about DAMON subsystem, I found some typos in docs.
> This is my first kernel patch. So if there are any mistakes, please let
> me know. I'll try to fix as soon as possible. Thanks for reviewing.

It's my honor to review your first kernel patch.  All look good to me.


Thanks,
SJ

[...]

