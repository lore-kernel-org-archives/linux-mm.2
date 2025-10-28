Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEB7CCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 23:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9298E0018; Tue, 28 Oct 2025 19:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790F08E0015; Tue, 28 Oct 2025 19:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6F58E0018; Tue, 28 Oct 2025 19:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 509738E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:51:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7231C050B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:51:18 +0000 (UTC)
X-FDA: 84049171836.02.3755670
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id C679AA0003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:51:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PLndH9ar;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761695476; a=rsa-sha256;
	cv=none;
	b=B7eB5NA8+q7FgOuHiz+rc24fqP6QKCDj5mvq7YLuPmKpXKkYDp5takK/q7wtAGB7rDTRLn
	p9FRTxJWTU59El83saQ7a85BS06vI+/m2liOVlA8rAou2iov5rCSj7jm8DmM8J9vdsGM3t
	yNCSP53hA9JHSiXdFZAXCGDkhiZvO7M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PLndH9ar;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761695476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ss0xsZDTL1rwOqKY2yzsfuodL2zhm4Ktw8Z3rrAQsGY=;
	b=cO2CxZioponwakHv76huZuNnvvaO31bvmrqXxOO3EXGbCgAZD5yF3f4/VsNVwfBbkTfJuJ
	zv0j6pmvjM9A/DqC9HGdpFdsxwARd0jGWx4nVjuE3j44vvRTvQVHBfxKQGB+ILP3D2HSDQ
	jtlaWES4QRwWtQ7txZu1GOmCzczVAA4=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6cf1a95273so4816234a12.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761695475; x=1762300275; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ss0xsZDTL1rwOqKY2yzsfuodL2zhm4Ktw8Z3rrAQsGY=;
        b=PLndH9arutRVM3WS2tQKfCJGumMrB3dXnEPazGseQWYmTamp1l21gFfcJHdTkx2LAW
         MIhqTZJYjI61C/YBrvvPNGEQ6fVnEPQvGglrF8HCDbew9X59Ab7szA5K5+JYgg6g7YS5
         6Scf5mwnyVOYiqbSKlkR3tNFk6l2Z8RJ6ofmsk6lrKOWjiIrTavEn2A8rQnyXp0DC8Mo
         MyMaPjqczdP3JN29VgD/qtj5zeTKwQ48PIQ85h1Cmckj33oGFKvG5DzN6Ny0pEVZabjd
         DECyIiD7GNWbdKds9aiQ4qlphzLV6mW2L7pSqKttOAk3IBIOD5KyuTc9Wd3/L8YseC2K
         sQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695475; x=1762300275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ss0xsZDTL1rwOqKY2yzsfuodL2zhm4Ktw8Z3rrAQsGY=;
        b=nQlPe7M5v5zRSwPGq2yLooO6BRdXdWiLYWf8ogFRzN9jhbK2r2B9mBT7kfVoI5eNSW
         vGBJjDIvQazQf9hdjJUel8M067kZeSPCHGFUlZ8Pfrtjik5COGvDC1hpUHAe9KMgGxVe
         OCKN/QUwhrCCMgoIGKw0AZwqJMPjdasGezgEcBHZBfEqMKF+tVmTFVDgJ0IzQmCn8+88
         uICN4aZO18JTzs4dfe+3lXRGL7bh9BN5E9e9gQXBwgYo/TsLI81Br9Eu6W30lsBGwsiZ
         GV1g4HpPgAzg+krNEVPhvGpFpSmgvrl3xMiOnM5y0DWynynZt6LI0JDJsb8FMuBy+g+p
         ivJg==
X-Forwarded-Encrypted: i=1; AJvYcCU7yXVMJO8QtvxTNA6RmwY0ocRNl9Ir8OOtHIicbdnqQe1RpRUMUPY88vh9hA7dpMTs8hz/GtfKfA==@kvack.org
X-Gm-Message-State: AOJu0YznPwaMm/G1D+pjHIUE4yFSgq3CFoJ1BX9gFNnmChzF2VR0Q/0C
	2iEEC/sb30qM9yvtUbMNZdTqg1/xrIOa6btR4/D9PMaBRjMULDaRKfuxRGLyECuA7Owu54uond+
	IS7omjCn8X5AEz5XUmDE3DpCH7tdOQq+5P0fWkLMh
X-Gm-Gg: ASbGnct35IH2E8AIZ7uzmnQajLK9OFhnIZAtIqf6ae6I5vqFg2wBuhmkwjCHMbESnTn
	AEhE70jMc8UBZOTM3ZBZSzlwZ3Bji73JsXXXI2rgQJdCdaopXJVCVjslnNXCpZF9pDH2ZM5ZgYE
	J7oROIBd9glVOsA3R63vK2UbVVWpH8eb3roNDiwDvaA+oiMBXM+L2zoLBFaYngp7iW/d76XnIG8
	UrE1SHPzrYrM8ON1XMtwLhitlZQYoRQ/2PrGfg58qLyj5puXZk+lNn7CK7p
X-Google-Smtp-Source: AGHT+IEQNyH4/UIhryBKstXm8OFaWiuLlbUq8UQcH5+4F6rsLQi06Pj91sWwNLFBJTsNKL1LL+PFGKuePdALOMKBWdA=
X-Received: by 2002:a17:903:32c1:b0:267:99bf:6724 with SMTP id
 d9443c01a7336-294deebc1a4mr13124835ad.31.1761695475463; Tue, 28 Oct 2025
 16:51:15 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-35-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-35-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 19:51:04 -0400
X-Gm-Features: AWmQ_bn3uluZWrDfxLWehWBukesK9g25bn5Thq9tyHBU2hJYs5NTI3fvunVput8
Message-ID: <CAHC9VhRa011jL86779TBk8FK-pcWinLkSkQ1MoxGyyfJg5SMgA@mail.gmail.com>
Subject: Re: [PATCH v2 34/50] selinuxfs: new helper for attaching files to tree
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
X-Rspam-User: 
X-Stat-Signature: bthd5bkudn7koojaepqifdn54tenhq6z
X-Rspamd-Queue-Id: C679AA0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761695476-62217
X-HE-Meta: U2FsdGVkX18hI6L4f1MBi0/P136PIQNkgZSgFLhtq0Vuv1/m3PW+iyTstAQRcu5/8QnSakA+IsMgzRS7Vi2sJNbOmv6KwVUWuOl/YVYyyF9REmcH++13Jh+XVqU2nbKNz8wbaPZLmJf8sruCvdvI1JMjf1UdgbbMEAqbLQanc9Sr01DTIEzenN5E9+gWpFLAfTLoSprswt4SeJP0x11O+wadn4R0K8LDEr0PEJeE8clOshhLQ58WbvFUd3+bI6u0eiI5PnNNUCEWFCO5Lchrf328nbvr+mqpHPgR1VJEUzaKWpkhtubDyOvzSeQvVgThO2lWjRJnI/J2xGeuCmkFaFUwD2sPU4FoUUDQk1r0oUcPTy7DVbxJGNWVBD5svbc10t62PrTdZTe+1aKH5JOG2a7EB3pYWbvbeCAN6D43qkbih5oYchyVPhvlBwjKfqyOsIepK3husteY2Q4ICqHnQvz+ZTqzSdxwA7uKkERNMCY7HWsf0UxXaNqcMNnA01ZDJM/fXP3F54iNEm6fFgNi5cizq2tSQq04RTzuNej/oCUQ6N/b7UYq+llIyj3hJco123yODFVy+f96KwCS9oFt5le1rvvSHOjH5KacCX+Z8o1kWJo7yb5Zkn42WwLn8Pv0bkKjz3jDYD060GhzfG0hMuK//o0Fv4HNl35dSlM2K0X51ekVgY2MPlgoC5qBjGuBgmgcdPuAdRkraU9QL9esO5gLuHty8/If34GVMEJisBvcpVz1okIVzlDyPaC28NF6FBY7QgeG5DQnX1lAzIfmGRyryaJTXkaUybVdgr2QxE1m8LHKcCNeJF5wfhhgCbez1IxO9xJdEG/fx4oz2c1tgu6i00ZKBzM9LdIXVHzs418X9KIP4EO5fGcDPHYXM+fHW4uCP5cRBGyyMWey96diiVTGBlHr4UE+yBsWUvPHDpb0Q8bImxVYRTfNE9pwFtrUnB0Vslhymy7pfe+rzQU
 EfP610w9
 KGZoqK9iuabVQYCNIuVFaKJ9UMVnCYSipIP1j7rSeAG/XByNrs1ws6P4r+cdC7UG9Z8+1LnGXAGfX4dhadTEwWWm1yAps3N5WUAOOaxOKZ0AzGZU5xHyxIGqHnSAYwzjzmgtZEotLjRJ4TCBRyotYM4sJ/RX3qWsxhV9sVl1LGWmJYMvi1GZxbpm3cz0EtD0Ta71ZJtIe/BqXdeZMAuKoCtWknQyFHP1cIHk0N7MXkP2P2gHaFHyhjRrf3543Ij4RrCy9snHDm3wXJTW1//L2/I/MEZV1cWEk3Yp0hIS1EBew/Iu7a2S0Hurx6JC6mvoBl59JJzq0A6OnD2ByFGwRWDlNMDDXZiEawS5X
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
> allocating dentry after the inode has been set up reduces the amount
> of boilerplate - "attach this inode under that name and this parent
> or drop inode in case of failure" simplifies quite a few places.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  security/selinux/selinuxfs.c | 160 +++++++++++++++--------------------
>  1 file changed, 66 insertions(+), 94 deletions(-)

Looks fine to me, thanks Al.  If for some reason the rest of the
patchset doesn't go anywhere, let me know and I can take this patch;
it seems like a nice improvement independent of the rest.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

