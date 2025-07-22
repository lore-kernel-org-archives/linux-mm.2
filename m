Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F532C83F34
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24FA6B008C; Tue, 22 Jul 2025 10:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCE26B0092; Tue, 22 Jul 2025 10:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39B96B00AE; Tue, 22 Jul 2025 10:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3D236B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:30:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 567D71DA6CE
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:30:24 +0000 (UTC)
X-FDA: 83692135968.01.289229A
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61E3B8000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:30:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3mZJ8nDu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of edumazet@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194622; a=rsa-sha256;
	cv=none;
	b=Xwc2upZTsnDeeYmawwzDr4ZqpoKNpzdZIhCO0XxFMHku17w6mScVEBb8qXYK9VuNFlupSj
	tfbsFbVDJA9nO3wpmRI2/o/K/Wl/ksTLk81Frr20/8oVdWkwADCeqGrqhZBIwy8YI0Esai
	VstvjIbbcnwlSBaGp497HA3lQiQfagM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3mZJ8nDu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of edumazet@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zs6B7ByVFqNhd4M7cO2OVqmSjId/nOtkp1oMTcQiG7s=;
	b=7ZwCXnfhlOYZe4/X+odhToO9IRoZrnktSpTbdOEC1ZjXpC1TftZ6p4veneakbWo7PVSofm
	IqXxaPsgRmvCkJsIBg2rHkddY622PG2PTzT4gjXDB9+aDGlnmEAV4SQtcrhvPZ3b8MhGjG
	I0kjDcg+d0hamaiVd495bFpE33TsAf8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab81d016c8so77044111cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194621; x=1753799421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zs6B7ByVFqNhd4M7cO2OVqmSjId/nOtkp1oMTcQiG7s=;
        b=3mZJ8nDudyIhDS2C0HRb/2dqw7fxT0XO4aFBfLaCWZlsUA17KWr+D+iGuOVNiF+nOe
         B4Mk2zogkWR/0cxGYcQgNbmB+atR5HXgJBKI79OSRkhqRXcPG4Cy7INR55RS5Mgn/5dr
         zNvT5VNaWrKUzrQfGoZ3nY31lIolm9+k2Br4xodlWVgFX9hYqywiyYlhXPZLnw51OpGz
         99Z0UQfFS8jyHU1oJ5KV9GGVyVmRhPPyKe/Dg/R5vmnHB9Q9vOB2/H989nkANiOKKJUY
         uqtp5fCZaOLYtF/7cz02cNeorbp44UiWw1tSpv/oEDex0JLpXt1/mfUnAecBGjPF/IHF
         +1zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194621; x=1753799421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zs6B7ByVFqNhd4M7cO2OVqmSjId/nOtkp1oMTcQiG7s=;
        b=IaHwAi6qbvaSfo/WwHLZAdEfuXyYRpuOmBXO8IwDPRd7IeUdbmizTGzOrplgVbvsRb
         lxy7o8vRKBg80My0+K6UZ+UVB/f+0lDBBgorNatHGbnYQT5X150Qe1laem+pTfX+m0Ec
         1eFNiT5HNw97V5gJFrMgI+zLhd8LNkQmJdmU2uhCRSSDJniBroBdFURbC0+qqlE5JQUy
         bSTZJS9ioCmoYQtMzrc00iEnZVrdtXpgLbJD3LAzwEESOufkOP8X2YImuXgLWcAn9Cyz
         YsdNqgoUlVTIyXtjtfTd/TKqIJAsGM/H/65FOTPp2Fg2XaykSy128kLsXYtQ9rUOjsUv
         l9Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWRRHN7i/vsCnhGtWluP4wxXwcQG9XVtCnL6eRYUvJFIjJDxaR+NTn46k33id9lSheO2SnmX07BzA==@kvack.org
X-Gm-Message-State: AOJu0YxIaElANG5Du31ydYVeq+SK75z04P+YaaaO2G1Bh+vfGxHFFrnL
	DABSBOxCmURRPjMY9V+yxE6nwgrQb2cq1Lr3pHrFn48glde/YAfy+jX8Qxz5V8bpz5iz9D9MkWQ
	inZTUC3Zo1f9No/zC6cAsB1wN0rxyuoTT/S8/aPkd
X-Gm-Gg: ASbGnct4y9B4bJm85jzba4hhR8pOqy6607c49nA+cs1Fey/9e3RT4rlB24hlpvFiXbW
	2TGu04HprDTR0rsjdbKfT2Z57T5j76kk9P726J6XK33Zk1XeLFg2QL6eDkglfcgBCy0Axnhv/DY
	5FChoWHQpl6ReF4NOZ6FkZmY6HmexkdFsdQdLUcuTkaVsGJ5AqPkwe/uONBz62KgSpxKEIkTJry
	Sct+5qvJXmKQyLL
X-Google-Smtp-Source: AGHT+IHQ1F/XNS6EEtYUtpk/olOEZA/Va6cGJiS4hiBQzXMnDQFWPRfhrIeUbeCE+v3wAGiJbMRJO1Xiv4/aKrsvrGs=
X-Received: by 2002:ac8:5d4c:0:b0:49b:eb1d:18ad with SMTP id
 d75a77b69052e-4ab93dbed7cmr383658691cf.41.1753194620995; Tue, 22 Jul 2025
 07:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-2-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-2-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:30:09 -0700
X-Gm-Features: Ac12FXzou9QrF6H0tl3cLlJlr49JVeNU-g_6k8oOer2kAmc56xaiC2vvAezaFAw
Message-ID: <CANn89iJQ_CDgAsDQ_cZC=fJJ9Vk5+Yk=RmmS=r3ds9abOqr-nw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 01/13] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61E3B8000F
X-Stat-Signature: yt4rcno11qgctttwuoebjh759hz8edxs
X-HE-Tag: 1753194622-789934
X-HE-Meta: U2FsdGVkX1/NJEpzhitBTUq3Me927PzQG2DHdiuCRHpy9Ak+Wxln01/NyUSwCa589sBGwjpe4GBZ/e1LPSxGcyi/VgVugWqO8lCdRIfgHCqaDzK6jw05uGdTQkQDsU68vcU3kr5IforkAS6bqhmU0dNwNv9YF/B87v2RWQpagw+KtiEYQnEJBqDbG0rjDOyIiQgCO32dynSfCy2FSbvNxIc15STW3UGYkTOvwYphCVnJRGcUC7ylW4BuvR/7G/BvWdIfZT3B0hlDxLHbm7XNuAIARyV4uM+84hiqQbdXHocWDS+TM8NG6n+S3msKzMLL7aW28MxaqFVj0o2nc2Xp7II4eQ4ChTi1FsokwNtEdtiAoLjjDvBqfgo/OgLnDb5MAhTOw7T4tX4nThtPbAW7U7KjyzEd3Par2JJ7R5H625WOdjwBEYiFirf67VUDLv0+fGpLYrWJnN7LcVoQGvqECDL4tgWcBfp7bM74xnL20H7FypaKyiRiWiJwpFxNwPx63OLBULoc2kTGqJ6JKBDr4NBrYj2dDHzzIhlrKPmQ2Mr8ZmJQexrGtIKl+rVTl61FfjEW0w5pZSbvP+V4+BIx5b1typx2FXgNdeHxfxE9mMGHZKNfV5WRT2Q8BahEYqs+K0DximSgoedtzsJQwlpRGMA+qyBUBjK8Pp2UVXaMCaQSTm8ucee/xz+6lgnI4tI4OeQ+IQ6nMqGLSldR9EDVIbvI2b5FQ3aDLgX7f5MNbPI1gowGSF+LBGPm0F9011a3rVqOVEl78wp0LUFH6j8Sjuiw2grlT44vPvPujbhvDAEYJ/bWAmIv4nB/NWkma+xAjoEjF4WRvrHnv8j2/gFcioBPi7v0zr4Zbqb23t5FZRkiE5gGPIiC9RhA7J6fnnLO48eJGYDaQEN7hRqH5vEPWqbWFIbnf+tpLptjX/ABWIgPhhlxb6ln5QtogA8SocaCgAkB8cU1G4DgvwGy3zM
 c6aik6IB
 w6XXcZ/6+EK75plTMDewLmDjQHAUxGDgjo1IPgpPnXEK/grSLcCXF02KQ4WQjTfw0aZHWsujiYU/37tz78TGIbIj98LN5gkd0xeDQyr7w8vQ3OMGFTIcYaaYEzPzxGMOp5raX0SlSFkB/LBGHuQzybDG0Blm10Z1Atrw969MK+e2FjHCNs2Rzzuo+jNa0x7FTC6kGAqKBfgKgzCQNyOkya1ojtIcYpTvlu1ujJt7YZOPcElVIUk5a+qkfbD8uqPWXh7d3aUstdXAFvhE=
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
> When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> sk->sk_memcg based on the current task.
>
> MPTCP subflow socket creation is triggered from userspace or
> an in-kernel worker.
>
> In the latter case, sk->sk_memcg is not what we want.  So, we fix
> it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
>
> Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> under #ifdef CONFIG_SOCK_CGROUP_DATA.
>
> The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> correctly.
>
> Let's move the code out of the wrong ifdef guard.
>
> Note that sk->sk_memcg is freed in sk_prot_free() and the parent
> sk holds the refcnt of memcg->css here, so we don't need to use
> css_tryget().
>
> Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

