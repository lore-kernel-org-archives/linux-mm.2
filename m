Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13604CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CA49001EF; Thu, 14 Aug 2025 19:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444699001D5; Thu, 14 Aug 2025 19:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3894C9001EF; Thu, 14 Aug 2025 19:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 299939001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:22:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67349138984
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:22:45 +0000 (UTC)
X-FDA: 83776939890.04.BD88E6E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 98E95180003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:22:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KX+pqEbO;
	spf=pass (imf24.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755213763; a=rsa-sha256;
	cv=none;
	b=df8/NxMERHN728fryl3RewTNKcgCgfnws0v3lzsOgmCXBVM2ejs7a4V3Q8+Sge0oBdsfcG
	X3jnB+OAuFcVW4flhfRDccs+E7kuaQR3nRqXLmPGWgG319JxuJBcRiTvmy/ai2h5PTudTT
	YB5YJO4zoRO8BafojlHdy9r2n6YBXzA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KX+pqEbO;
	spf=pass (imf24.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755213763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQ7YCZjjUdesfp/4AmnBBp2EwgfrYAy7oWynoXY99mk=;
	b=J1ILFSHF02UsPL99/7vMIeSb6vH8erjbUMgB0Q+q6Wzf2Uu5Cu51lSDGSgkKJFRmdjUT8v
	IFdSMOjM59ub3kd2gUG5kjhqi/qZKDtbdkRfKZKYlH5bceBSGpOvGlTfbLJM+PHr5Ca1j9
	WByPBxUEFBS0IzS5gl/R7lDWZMFaDek=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24457f47000so13636655ad.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755213762; x=1755818562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQ7YCZjjUdesfp/4AmnBBp2EwgfrYAy7oWynoXY99mk=;
        b=KX+pqEbOxo8Th+lbKoPfWpaaNHrAotJ0ceyrIbDMdxclme7aNQTXDR8mMrUs+QIvpz
         dhumZbUW4VV00KC6MN85IwceuVC9vjxXKxo5uOJWMj88ACga+5L0ShMFir/JamWdu7AY
         BNhiutEcyAQMoVNGXkmN/WOELKyVTypRAGDKggMbAfhh7yYAhtqfFu4JowBq5mbc2rYk
         QdAwQ0gx/rVUquQ7/9GWxFiK9+ta+nj3xBF9wJ3/9rUvHADLVMpwlRLoRjy5qe+ofHeb
         FNG5JJGhzf+f9A8Uin6B8GBETJzMAOjLDmpQbWynmp7G/RSl0HBbq9lD1jcBakNCoUac
         OkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755213762; x=1755818562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQ7YCZjjUdesfp/4AmnBBp2EwgfrYAy7oWynoXY99mk=;
        b=SIVJVnoEHzxZgtQrbJMUa4qxWjY3rLIWN2S9iNTf8KxbpZJbI6SBQqZv0Bbpg/WuaG
         Qr6HrVTm4Non+6/+DRgRiGaHqDo48zYFRW/k1D0pU5uc1Le0Qmo4J8LkR9zw671P2QVD
         sxKLoHxfCpvlWfwniKmyJuOdYLr3vaX/+jElZJmUM+8sn+DTTPkblF4sEptnpMQfCKbw
         p+GCZvXt4G49oEmAqvk92qBU1jOq5cuLunfGwdNeoXkngjROASZIuoqLtkPiI+h6yzrf
         eThzYaQXyiUMWeQzvkVnhnNDqyFW12qhcRCqpg189rae+MjpCC34Fovvv5HoqAFt9VOA
         g3Qw==
X-Forwarded-Encrypted: i=1; AJvYcCX2ACXlFXhqgORFyVarSQ0p1yQGiYtDItUaM1I9l1/zxLuAn0QqumcwFOwr+Bm4nw0cn9nM+1CTZg==@kvack.org
X-Gm-Message-State: AOJu0Yz8o+hUGZIoQELosuPRM54/HDIVPVLvezk1qnxErqVIA1fXECRW
	ykDsut1yR9a+KBu38IAeCTZi8GXbxacKT2ZERoSObd4KFnBDUj2yrGKlCn71YHvcCy+Nv5UOVNR
	ouMk81oM1r34WAcyevFCM2N3UpbH7gxeRQpklMjIL
X-Gm-Gg: ASbGncvevfMMpgQFB03hYEkULDCq84Ueh8rRoK4Gydal9n0QsDnLNvJadTRxw+hzRqe
	rztPAei+J5J0MCm/RdlJQJRLCgzurgj0gJK26aZGp1bK9Gv3rq4MTaw9gQTXwwpE4qaM86qHfP8
	1Vdt+4T2I8MzCzGOpHUgPuTjR4H38fOzJxqPNs4Mr6Tmbwo5rma1/lZxoZEu/5xAgcJQubqmQph
	6E+tjsiGDKcsY9ab184GIjS2rlAOuFu7YotciZYPkNJcroO9yuZ8Xxx
X-Google-Smtp-Source: AGHT+IG+GzkTFoWSxjI/UBpeB+AhhE8U81bSEVut4K3CLnycOTHj2PFasfm2kLor4XHXf2jf8tiH2o7md6AgbgQhI+o=
X-Received: by 2002:a17:903:2444:b0:23f:c945:6067 with SMTP id
 d9443c01a7336-244586c3d33mr71675685ad.41.1755213762138; Thu, 14 Aug 2025
 16:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com> <20250814200912.1040628-10-kuniyu@google.com>
 <pl47mmcmxu53ptfa5ubd7dhzsmpxhsz2qxpscquih4773iykjf@3uhfasbornxc> <7pbqwjm4yl3oxebibihbdqkdusamnnui5ypzhfh32pxfkcordq@o3hottcdlavs>
In-Reply-To: <7pbqwjm4yl3oxebibihbdqkdusamnnui5ypzhfh32pxfkcordq@o3hottcdlavs>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 14 Aug 2025 16:22:31 -0700
X-Gm-Features: Ac12FXwLp2y7n2f70IACCfZi6vRBARC4QHPOIBg0j8Z8siCHACfmll_htqDpnyQ
Message-ID: <CAAVpQUDxXZaYz98hen3ariCek4s9TQ9JxWqS_zRoDK=ON-asbQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 09/10] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98E95180003
X-Stat-Signature: dwdka975ey7x17b61cwqi4oia46pf9en
X-Rspam-User: 
X-HE-Tag: 1755213763-105886
X-HE-Meta: U2FsdGVkX1+hpoXh2bbEtiS5ap07DenpBKdJHHQQYIv4eErpY9oSlBggQOZz99bbgtoGFwyJAKPbJY0TNZiYKk7FpFRkFY1Ir5F/gdnPqGmhGKK5Bp3dQvWpORNpWHPc3R0ijjNvdj0ftRJVNmu4UjjTpgkciByEXyAOTV8+3qGvGv1JaVvlnAm+nz7zrPiH4JetGGmC3wLhdHTW5Z2IOnw1RzYjMTo5hRAZ/BFBl5yDwWEqf5B94i4aoPf7pVlOkt4PtqfFUjweG8G24bKE6nuLqAIAZbwTJWhaipsXVGtd4R9jETdx4NWuo+gC+8rzY8hhyPQO4wbqoWIYuohocKDm0Ko2ZH7LR0QNW2lENNSi5sdKgoC8hYNazYHU1+2Z8By5uD9bpOYwUcFKCkpMIzNfTZ5HGKAYqKem8JNcZ9GrIW2wA9tfH3jT+kY1qXMH3K4616+JLQtuRiwZB2Qz76oC56lP4MGyXl4hulu9ERn+Ms8Fs9W1CojVwBhQivMXBc+cbD+BqaaG567JE4LScnHD3QUQACS9CLlbhwEx8/4UpE52V5hR/t08ub3AQbakscprJvrFHr2Yv0xcQgXC8pRW3TCiAs1jLT/R3WAkqVw7v6CiPaVpMPNR64ZioUcz8btdJGcYw70aMNzQjKskDq+aii90Ln2C53Dl7zb6mTNtFYhjyvHD5DgFJz7twAZAkvZTKrW+DZMFLJhIklpeBp2t5q0W2u0TNNb51rNsGNYn1QAINBZg75PO1otIz7zHklu+RfLi0PP32YWBd6H6D8EASkABfzDHtWQylh6+90oasJhLLOZJLUQn3NgzcZUvrCSbzbJXQe7Y6bpIF8IR8QVHJ0W4QrTSdD7ScEc0I+EvNwCO0hvHmW3ek7QggAfqfssQV86DSG0teLsLpGpyT9CEuwJ0RD5C2psJeGH1hEOrLkyVtV5E2Q81zLL7t2KPIwfPIjfqAUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 3:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Aug 14, 2025 at 03:00:05PM -0700, Shakeel Butt wrote:
> > On Thu, Aug 14, 2025 at 08:08:41PM +0000, Kuniyuki Iwashima wrote:
> > > We will store a flag in the lowest bit of sk->sk_memcg.
> > >
> > > Then, we cannot pass the raw pointer to mem_cgroup_under_socket_press=
ure().
> > >
> > > Let's pass struct sock to it and rename the function to match other
> > > functions starting with mem_cgroup_sk_.
> > >
> > > Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
> >
> > Please keep it in the memcontrol.h.
> >
>
> Oh is this due to struct sock is not yet defined and thus sk->sk_memcg
> will build fail?

Right, we can't touch any field of struct sock in memcontrol.h as
noted in patch 6.

