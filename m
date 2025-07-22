Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EFA0C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977D36B0089; Tue, 22 Jul 2025 10:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B25A6B008A; Tue, 22 Jul 2025 10:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1866B0093; Tue, 22 Jul 2025 10:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 669786B0089
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:59:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36DA512A753
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:59:01 +0000 (UTC)
X-FDA: 83692208082.27.F34CA3D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 676471C000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:58:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="A/0muN7f";
	spf=pass (imf20.hostedemail.com: domain of edumazet@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiqwsXqS9XffgcdUNt4OEyIxE8kyMoj+z790mtcu3ik=;
	b=JIKg7T2CENlxx1r7rGtmtCuo0gVfT8NEfUhezgTmE1vm0Z9uc3uCX68fj9MKo5ytmuly2t
	zIa9/u9RCfVpO9h1FK6S8tUMNm5Ki+A8CT1R9g39NLnj65p+FaM9Flm1EP2wfSMewtVIbp
	H5Ur1VAWuuDbXmjNH3xJIPeLTJePLxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196339; a=rsa-sha256;
	cv=none;
	b=3FPegHbi6ksuQMKLaMSCmA21mmgoL+N0dsA/Ur02C0wOExGk1iTQw/IfSzs61eNA76gFSQ
	iBPKZEHKhtlswjoLKH+2BP1775autktAahHdyBnFHx5seYAqskTUgLNz/qJnE/4mUQDfsz
	scczId5ZokCbK4GDcbiBKZeRiDyHD4M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="A/0muN7f";
	spf=pass (imf20.hostedemail.com: domain of edumazet@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3802455eso72731671cf.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753196338; x=1753801138; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CiqwsXqS9XffgcdUNt4OEyIxE8kyMoj+z790mtcu3ik=;
        b=A/0muN7fLw5Fza0Kv4ajiFDPpa9ncJfdGIZiiRGjlZ3R8J2wvsX7dAJ+XdtceO3YQS
         GlrvWVDQAYRMl250P1CrJWyx82Ns2Q0zFLCtBb4Q8RU5+hdpVH1EZp+W2+L2d3Y1saQr
         ZJojmtoqhqEvoei/6/+FuheXxsxSKOHDCvu82JwXD5/OMlKcpg/3OHdOqT1fHCIpfTBI
         1zhCD00s28TE0iZ+BhH8aUx1fW4mBt8V4wjHYOU11QYt/eIQgXxkihnrXGK/pwYU0Ha7
         ALgUdfgxh0sphkK0LM9hXtny4R1RmDHX32Rt9E4uue0/407qrTZWVl03tk/jhvRZtYvs
         vnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196338; x=1753801138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CiqwsXqS9XffgcdUNt4OEyIxE8kyMoj+z790mtcu3ik=;
        b=n4v7297cxWqt2gYlJA3CufK56ojkqI2Zpgq+9+MoL0S2dXk0NtzuFtV4aKu83dfavf
         cJsZNlBMAEczdL1o/lx/4hzwNWz9xrn8eEKKwHjev67GEwqBRl5efiuYSnQp5lQ/yztA
         +7dgpKbvU9KcU43tb6uVCQlZ6imTMvEgexvNrx38YDI+uCQQKdRg5AVKU9IkfkGpLxpl
         lLBB+MYKvbO+Cv0l0oKqJqnJ2gvLaZjU2gUos94KZyrA4zb4IYybrhiob0Gj9Xfi/kS+
         dX7B8YB4cL/yd1Aq91QWtJFnbxG6S1DAod6jdt4gGNLY4FWXdDccqjkG68G5IFjzg+iY
         9RCw==
X-Forwarded-Encrypted: i=1; AJvYcCWk/CbTjBIhQgL9RPkEyt76ibwK805KAKsd5vPjjdk89ru7TzdC15YRMUT6cWygVCRcsOXOaVEQEw==@kvack.org
X-Gm-Message-State: AOJu0Yy85FBM3HRquGIuEywMdSBWzmCKdkTgBrlneA2x5NWH/jNZKZLS
	hT+cuKbzGlbusnzTEJPwH+iwOhcPwmt4Azbq5TsKMtV8rLlcmgHhOR4sKgLzh4oE8Q57Q9cClg+
	qhpmcAtU0Mnz/HCGc6XjoeIyRBGCKPHF2dC3bm1eI
X-Gm-Gg: ASbGncsQ9YIT7zTNw0shcvDOlhzT0Pe90+VmFo9XWUNDnPwZlD0bxLklEvY4Q5A8GbK
	tJqO9y459p9p+DCD10BQhSutdvZlQMdGdWz9mvqe+fWPZChYHIg2t4iCZtWfxvg94+tym2VMxB6
	5QMPesUnFMhGK0cx4Lyi/sab/zeQ4EIk9NI6AskP5QkCSQ4+AFGIUmR72cUS0ieG7NfO4FdKyGO
	pE4Pw==
X-Google-Smtp-Source: AGHT+IG2yg147JK4Oinx02ez69SdDMukiZsmWmT/iPx1WpvOc0p35m3lKJjL6O102z1pXoYruFzug+iTBIemqmhssxc=
X-Received: by 2002:ac8:7d12:0:b0:4ab:7125:99aa with SMTP id
 d75a77b69052e-4aba3e33f4bmr306580691cf.49.1753196338060; Tue, 22 Jul 2025
 07:58:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-11-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-11-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:58:46 -0700
X-Gm-Features: Ac12FXxT4R5nqDZoq6He5N2XHgjugFXTSeJd14lK7mmXsqA2ix7EK8BukOpBfNg
Message-ID: <CANn89iKo45xre19BCkTRQSym7WCWxAbXOD77+F35OJ0eubmdew@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 10/13] net: Define sk_memcg under CONFIG_MEMCG.
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 676471C000A
X-Stat-Signature: yjnpg74ah18hu8k7917mauaruyq8s41j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753196339-944794
X-HE-Meta: U2FsdGVkX18i7gc1Xb1E9a1HM3lYwqkVEpU8F51PVJWnP1JyMr/CgNlArieb60tKZ2sgfceRoimSMOAsVLZO6JavTH9S/ilQ0A1uDIz7vPNv4Z5DUR+aYrC+1Sc4rAE05edM2fFTun9l5Dz+pMWTYwCVIPVKgnGLvn3MyBr2bEd5OVJ8UOBJEo/aoo9gek09uf8ufFAg4mMDQiOeWpDRje0gyaU1yiyC79MzdpJm6oFAcODYYGpSgeV65lX/eV2DZ9HW1DV8wDRv7H0sOv5P5gR7LtNCKV8etcznlGbtZ41gjyKIyaqdFR3CddUT7+flHSdNscu69W3ED+kqqC74JUysm8AGn5hEKsGSzx+jxZch9MImZNHTiEZDGr+oJJtDEFzwx+3yrCla7sYJZ7BzDXSicshXROMPHVnvQ1s90oi0v5015B6YG1P6bx7pbvflLdeaLEtaqBuUpZYcW2TZg2+hTF74TtjKSq1PKzfkvRkr3yCj/Hos5MJJU9YLW8E4nXxeSpd8lUqU3nCnwpzBpufZp0PdZ+7aVCNMHUC2FuSoQJA5Y43lpV0aL4gKbVg4D3pBbkGvadTWOEc9f6no94dF2scTavH4e95/TIMrbP4ZjhoOos/qSx8pxr9grNzo0jb36WxbwfzWVMbmrOcZZMkUgFofbuUp3fWdMB0F3xkGpkNbg5W/M+LSANnxpRmMh7Q9ywA3WhovF2utZaRDuoDOq7TmlqGGsBWXp96zYktnawmLBSHCe9i5FlTxSkyXXDA6QZS9yHY1BG7LIHKBR4Hu3tANR0dWdmScbxids+gigu5k5L2y3nM0CqR6fTaddfsnSK/c8fUQdLWKoLD73XIQ8eE1jNv9fuuOZulP27LUt2Oz3a5YzLV9pdru1yGArOYoRK8F2Ul/XoIksMhwCz+XQnuYgtlhCX/8sEMxNbUXU7wGqpiNA2RQblbvtsfpMQuiOI494zC2L3TCguY
 3H456j48
 bbWm6j2JSWPopM7CDkx2GvTyCfyFvHxWArdcXz6xSgUc3ZihUSx3gxM8mRjtz9tUkwNgedV8d0EE1WN9CQeUTc3SlyVfhkgaKdi2bv2wY1xhSXKzP/IGFdqlI4SYHrjFRGdSGqCbG3FtWbK+AA+BN8bAjXkWeF3H+Bx9xBAW3j4vRs5GUA0XDID9E+FGaOtsh7GqMf1kiLOWN4Gwn9pEEpmTWUnG7rhV0XlOyjNGcxlySZk6HnFb6gHwLWVNpXyQ9Czbyz5bxEPUFd3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 1:36=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> Except for sk_clone_lock(), all accesses to sk->sk_memcg
> is done under CONFIG_MEMCG.
>
> As a bonus, let's define sk->sk_memcg under CONFIG_MEMCG.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

