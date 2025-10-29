Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22225CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 00:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E44F8E001C; Tue, 28 Oct 2025 20:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBF68E0015; Tue, 28 Oct 2025 20:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9648E001C; Tue, 28 Oct 2025 20:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 421078E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:08:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D40EAC05E1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:08:21 +0000 (UTC)
X-FDA: 84049214802.06.2B027A0
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BB1CC000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:08:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=FtrGRdHK;
	spf=pass (imf22.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761696500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZjzJP5BDJixdHcjsD4MEtXcdIeCfYM/75TifkWeDww=;
	b=C0c1sRegqOSyhII/hiJI8/7PNKMThp6kzkHMINNb65l+Q2mS7YcJo5lVEkOWQbR6Lc5z+Z
	GTIeUij0hITW+RxYcR5ewWIEg6ez3mWHYYl88xwzRP9F+o5Mczf/44Hysj4qU1plEaWWBC
	TsRE9A/Y5ep2IUwT+SM2d0rOecnn1l0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=FtrGRdHK;
	spf=pass (imf22.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761696500; a=rsa-sha256;
	cv=none;
	b=0pNae2K3gQwdAunk2Z/pOw2wouniMvLSH+2C2P1OjxCj4IHkcJRs5TkVaf+W7WlIRZiJ/W
	JoX2Ap/hGuEvgko+9bj6SFEO1vEhY+qRBioRcIs7pzAi9KcT+BWrQqhoNZlHafBqcbuIc2
	U+mVSeUdPTSE4zavHWFEbnH6+TPuom8=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34029c5beabso1686977a91.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696499; x=1762301299; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZjzJP5BDJixdHcjsD4MEtXcdIeCfYM/75TifkWeDww=;
        b=FtrGRdHKxTm0AhfxMzV/TdhSMhQFTYNPI9cbFITfkmq+qbXJ1vMGXxd8p9hEbtd7j6
         bXc2yEGM9PNNhtp5ethzfyE4BQBort9HyX1MWAJtGJPrwCVKBNiCNr0jl9/ihmV8tLbs
         uJpQ6pCLToHT9pu0kgHngGceRVZkqIG14e9tbws9AyQknoNvTwziVyL81t9u6iiOsvE3
         2yEZQzTWipcSU82uAPV462B6T9TsIV6rDxhX1kmu40Aej4gUa8rlbZJNQ+hrThEnuYv4
         NLHTt4MPdVzpk7DSjV7qDPwpvwwZi3XKwujASBNgmUBlZqlB82gfTnf8uhASPpo9wSwG
         ub6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696499; x=1762301299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZjzJP5BDJixdHcjsD4MEtXcdIeCfYM/75TifkWeDww=;
        b=h3RuFyrYDaSTe0fwC4B/QMWiOIQOzsW0XYm5MY+LHl2D+HSlNXXTgf0CmV9gw9mGaG
         AsEJCT8yqGDy3tyQaNpHzYjUyA0eSESaZE4X2zxmQEMvAi1lnxG+HZQ6/5iTRBv/gMES
         QbLmTTSA1O0xD0mVYga0wXSmj48DsfTsgHUWuMDGXmRPinzdUweLdjXFIQrSDUzckH5J
         2uE2Si55zpUR/7r6URUI0YbLqABeL4/NOfxietts74SswRgLFxkR2v9kVV6fYqkltwR0
         becU6/4F5h6RGk9M9eB79P7pU5LA+myKm7u4Z2mLLTftK6eqXfY46WG/UkmdHXcFC/BY
         +esQ==
X-Forwarded-Encrypted: i=1; AJvYcCV36XPvDlVn8P9Vtc1FwG6NoLY+VOeNPb1CBuZZTtYCIMoj4CCjkDLWLLU3ZMIWZuwkKG2RlmHwOQ==@kvack.org
X-Gm-Message-State: AOJu0YymNONaBXX96MhqguN/8Y9VQF4dgKqWSQAHf7FzwTXG8h8TzuTT
	i6li9JsIh+Qeecg9CnA6fTpUbLBKUPeSzJMiZmTokkXhNHVM0Dv771khqAVP5mNNdlQr6AXWLIN
	+XzrdFt49rAB/CwlGGB37jKti32SAPteY3MV1Cx/I
X-Gm-Gg: ASbGncvhaNpMlAR9uWkUS2TP7qjDKPb1j7aPnChKrQCBF9EOGR1fquRWDQk2RJc8ldz
	2dnbgpCF+wlprUEgAWe/KF91BV24i5FcyijbD9U7rgep+FlkmL6fQOK1JrAHQqBUjkclboHGPfY
	L7cF67/b5qbvWehAV7ePkUCPvC0BDWm2sTqcVfwSqhNvottnG4YEZ7+s8X6MFyj+1s+SoZPL+0S
	YJGRJYjNX17YZDbsHCeikjxMAQMJmy6YXDPShzWS4c0juPLhvrbL//LP8hM
X-Google-Smtp-Source: AGHT+IGEKRPFq5L2rd6w/ubcuTn//BXhetf/wOj9xAOGHPjYYno+UXGan0WlvoJBaoZ1JF4tIK0SCxZjeiDlUqLjb6g=
X-Received: by 2002:a17:90b:4a05:b0:339:ef05:3575 with SMTP id
 98e67ed59e1d1-3403a294f2fmr971614a91.26.1761696498871; Tue, 28 Oct 2025
 17:08:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-34-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-34-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:08:07 -0400
X-Gm-Features: AWmQ_blBn2fdqYcxKi_H91_QLngZD09fAUzDyH5oMtRPekpRq9pqWMOuQKzGUHw
Message-ID: <CAHC9VhSeiK=qqLMUDAKRTgS5EEHdVvLD7-afuDqJWYFindvfUA@mail.gmail.com>
Subject: Re: [PATCH v2 33/50] selinuxfs: don't stash the dentry of /policy_capabilities
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BB1CC000C
X-Stat-Signature: 1xgzpuyhwjxrp9uscde13zgpfczwkitk
X-Rspam-User: 
X-HE-Tag: 1761696499-69609
X-HE-Meta: U2FsdGVkX18JwUVdSffQhdvv1BhTqNWyaNQ9FMjguUPxb2boxZE0fXmJFdKJayu3EKJy0ir0rokbtNupPq+8zTimgazdCd1cNCzZXfepTd+lMOdhU+KYC+tWowlXuR+Hi+hUmfowmHCp3omR8lu+yAb5Eh1pPYFuCZZDDeV7r0TmBhr48xq4+pg5BPcGEo/hK0f6y3SC5GBl2930Ctt0L8Tflw7UnyW0vmmsyP4fgGdxg58pbRU7hw6n1pwxb17jqCbJ9xExKGT8KmIG5us64R6JXdinGEqBkXcpFJ6amEWJoJWzMtIMEWx0FFSAxn6c7vC+EEvCuB5XSazsU6FHWhT+T2GbrolOpPEkYS5bR/cRK/ghU8UWKf1cQnfl7FsAbvLEVlpKN+ziXoYQG1TZzuUIXMdHuQTvzq9tHSDQoD1z0IHcC+Iv3Y8tpOZ841cPekJ8doc/Pyfag2LHhivp8ke2v4aqnSpjc1LUWZR1RO+sUMX8GTEHFqv4Rl9MpU75GYsP0jpEMjEFcjUB8tU5mD9twCkUPJ2PUqfQHzQDeGhJQKEnqw2MMZj8/1vzl+IqbbfjK7p9YOozS5zuxq4T4YJzxneoMfnBnsyhmX3nV0RDsM0QCsF88BYNetIapUhxV8veUA6v/3/i/hXDLgF0pMCKLYCXEHrIV+pICMNyR0pM7AhsrzbcEoda+5iKJFI2dSEfTx03wz061nZY6hbeDM/T26JLGX+YZrVeAihjBSKBX/0v0c7HwhAV/hReVJFrTfg9ZBa8V82yEdfeOPWoV/USmCWuY7W57Xo5pGu0kOVefNity//L5L3BS3Lqit9ZDYOLD3BHw6nIuUb05Uhxh/5pXZRfwFT31aKBmlR8nuTka66rNXlWFYMzXRRMhO4TSlKBP0QMdBlHpU5Ycu3Bu59eyHLVcck9laFkkwZN7gAhHEDpSQMhr1qIhuJ/LekSt07S2HlQuNkFtqThrLS
 QRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Don't bother to store the dentry of /policy_capabilities - it belongs
> to invariant part of tree and we only use it to populate that directory,
> so there's no reason to keep it around afterwards.
>
> Same situation as with /avc, /ss, etc.  There are two directories that
> get replaced on policy load - /class and /booleans.  These we need to
> stash (and update the pointers on policy reload); /policy_capabilities
> is not in the same boat.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

