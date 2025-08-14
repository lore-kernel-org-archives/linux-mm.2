Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3EDCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EFF9001F1; Thu, 14 Aug 2025 19:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8099001D5; Thu, 14 Aug 2025 19:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6529001F1; Thu, 14 Aug 2025 19:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 438089001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:27:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4F9EC05C5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:27:46 +0000 (UTC)
X-FDA: 83776952532.11.582894F
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06D29A0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:27:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sAYobKEL;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755214065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJte4ardeN85Du6oFLbjV2pOyfXJ8yitINHiZm+Srao=;
	b=RFzQ+ohFGA8xaRMZqb+aRUFXMJ4eOnMM1gb0zcQlpHMm1w5ISDnecPpLD3Fow6HCgumawy
	L7BjuOq3b9B98dd5ELpS1caLdZ8aXgZz4e9utR2Xk1YFXK7S1CSm1Aau3U8jpmMy/ZkXHb
	rmTE/Nq1pt8u2hIsNaGqJkpr2D1ZaJo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sAYobKEL;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755214065; a=rsa-sha256;
	cv=none;
	b=IA6XqpUx2hwOrcS4l+nPiRRDG+x3OG9qakqsJ8+/Q9TiJeLpG7BRtwaLn0TqLOQeP/qZF8
	fdfrTKiqn9s8mlFM+iafyyof0N7nEOK/TLM2P9cija9wHTLsOSFMP64ps1PiT+qIkrkE5C
	F1pby62MruUQ9nXg3NR6EZ4Z5y9B2yo=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b471738daabso1250331a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755214064; x=1755818864; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJte4ardeN85Du6oFLbjV2pOyfXJ8yitINHiZm+Srao=;
        b=sAYobKELDAC3b2ufUL/DE8StPfDJcayeZPyQnOSayKJRT5py73DR2UG2wvXwUV7vUy
         Vsk91On+m67P9rxtBHFz5L9KRzf+RWuWNrMxTUwsGS42DeFbCK5ED6lU2v2owQQUSTE7
         ye4gHvLgySScDN1mEwqn6ZSU7Q4P/ASSI2PQGlWs0uHfQMB1u8L/bIjbrdYT3NkaBvFw
         jZLnX7jwH1KMSxnFzsKzvlExUsjIAnPSP65iPCyQ8cnPjBtp/W9V7uX4M6LwGGDm6YV6
         uB8o9FbOLWE9wHlkMYzvN3AXkTX+3sRmxMibPmx7h04f1pFzstb8WgNUqPo3rXshqRX3
         gbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755214064; x=1755818864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zJte4ardeN85Du6oFLbjV2pOyfXJ8yitINHiZm+Srao=;
        b=iiutg532XoTafbzR/OjLzCRM7sUTgug25ixV8HsCS5QXh+jc7NMKc1Juw/NH6Uh36E
         TR15y7mBAc+0qaneKOS7ra4XsTu+/n5pq2Ck88pBzqL8FWEPjigrwIWP8xv6ZxFl46Lw
         Zapoho53P1QjYSYSWshxDlbf7HMYgzTRY9wj0fcs1RoSoMH03Kg50jmr+KX9eZVdNSvV
         Y9FRXMH0fKnnRz78Ee242Ndd4f0d42wFwSr5S/tEIt4nVX1WaJUqwh6WeDDoG+faUkw1
         oLChjzZtVAWDccZQTZmMuLlmtXtJfSElIjr5rM1v8Vp4N+0qhOI3eNMTvOrDv+UA/2j6
         bFeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmRAqfALaF4hsnHqigo54ImQEzYxmK3yZJG2C0/DERwSTyzGGwYpJ+AxYhqYEFWc1OiQaYtD6FCQ==@kvack.org
X-Gm-Message-State: AOJu0YyaeCjSSI0mB9J2rIE8O7ZARzXHoW+7OVpEyP8ll1pC+IB9xdk3
	Rxhf83xJH1F2D7nqlKCqoLDGt7DBpmjmu40yjmYOzyeEx0gELh0VvMwdr3PwerFG2xS4TfmbDFU
	0fh+DSsA7nykJFDMHRUAKLB+4h/WVD8WvgX5rGm7S
X-Gm-Gg: ASbGncur+ZGMFvVWS7XPA9vt7TfSUMbrQWtBxMhLVuIctB0kc+uh9gbA7R1j7nFhS7l
	Zoa9owdjQIgcguOkpUlW7KLhVnGSfrRigu7sDmaKlMoS+8xTfZYrqUM1WVNiHzlwnTHwY5JRcnZ
	heSehfBfM7zfxCXhbfJH89h9lk/Uq2k4nOl3sMpiBuFCTj8s+cAPbkcvRWOXcoeCX7kCFYmpd1z
	uRxIZyqt/LhiYWu2Sh584BweyQbKO3gMg1RyfIi5o7sgQ==
X-Google-Smtp-Source: AGHT+IEHit+6v/zQOrDIYEMP+S59QKYaphBAhA88+cWD0rCmrcxwlIgGARBzu1jGkGqvO/cZmUpqkxnAjxS8w/4Lc8g=
X-Received: by 2002:a17:902:e78e:b0:235:f078:4746 with SMTP id
 d9443c01a7336-244586dbef9mr70544725ad.42.1755214063557; Thu, 14 Aug 2025
 16:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com> <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
In-Reply-To: <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 14 Aug 2025 16:27:31 -0700
X-Gm-Features: Ac12FXwI-hCJioucwxG326FRr7yD4nkwLO0ruxEaSqR9_-vI1XwEMNZdtXGsZVw
Message-ID: <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Rspamd-Queue-Id: 06D29A0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yui5fsf9cwiyzcderfd7o73xbiztte4f
X-HE-Tag: 1755214064-883298
X-HE-Meta: U2FsdGVkX19SYlBjhTEEJZ+Txb9k0Dy/0ygq3Nz2qtXN5Aba/uC20uN23GZyFqpQsWhGu1HMqInEaS8YCG6b9zfNffusmRHEsgK7mluxJIcUpjLfNVv8zbRsQ1d6+XYIT1WRq0vbCuvHj4oPAZUZNGRjrC1P36HhqJRYvl53a/BtLsKNmmmlBef9k0pL69FCCLzaB9ktYNwVv+4qpmGD8HVLkyh26ASg36HgcReWTQe7jnWWUHInmGT8Fcul2gBYSp6zsPdO/wFSyofMPS7JEJMcfps0MWkP/zcU/JdyXro0IvVNdtkv9kzk9TXeKZuAPrI0m+myvSXmVpB5+PDejthlnJbDH+5KV3s3yr195VRBQYUopLUZhALLp5gQzYZxcPdSS2zoR4j+THoT2WxjJFEfhboOoAbdsH4DAH1R1LxwdgJ29NCmm6JEXIMUAt+5q+JeFMxPJKVyioTIoPlqUyhVSMGY/mHPQ69FZbYHMOWifLMPUqSwkHn/OA1jazyaBe0K4/C5DE2OXQXiazkgCAODn58NX6GECyYljbhPQpSgMVy+XGe2kTs3JOnNHjb8QR/OzE8vXouEeRVFvGFlYoUv+hfSgntFkKxoaZHIGG2+wf5IazmQDT5mUkuMboINtIhaTkaBj9+0gxazHZlZpw/H3uMATpWiDt+2PokeFZvHxcPylCzb89lX6S7BriZc7eJth4wWdSstL8S6Su/4I50IubuuITi3+AnwYIrUUpJkceYvF1g1vsd2mdBbmLv+Kl6QgHizrAkso7oogLUie7pZdP2FCY+gRq2yCWR4irxuzFu1qx9eno7HoUU6nfPxi1qdDuHJibXYcgbP5o2Rfc035XrPs9WqHZbKE8Dew4OYiiUcXIfiY2IZiz+lC7uT3wEQbc3Kr4ljFbZyVlsaqpUpk0plJUk99fqEJVRChmRI2pxweI+eOxSvzh0s2QyMSIL3k4bQVzsz1z9oWRl
 0OkCv73r
 b0Bv0ggVI9PlyB8obqXZTcM6/hxW0avwwRE1WlNOLU5qTrdvoeD9hJiFjorrgvywdvVXDXv5eppcE1A5kc2NbTR9XQBTciClOQMZV2NgWFWztlIZXCROHvvVuF2ixgSM6jw8klqRqo/qbY6ooamt18Fxz5rIQIm9yP1ZxROwL5KvR5BMK1N1zUmvLbEpKLv+A4z6l5hHPbRwjcqQy2BIgZ+dzQcYOBLHBrw3GnkGdSb+Jpzuf0TPMrv9PLtDRhFOnYH0V2TJ4jQY+lGcS44c7mciaRXvF1QnjF/2CZCFzfaWB9XOUgj1f07ADTl/KQXY9dfKdnlA2LNdu3gY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
> > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > sk->sk_memcg based on the current task.
> >
> > MPTCP subflow socket creation is triggered from userspace or
> > an in-kernel worker.
> >
> > In the latter case, sk->sk_memcg is not what we want.  So, we fix
> > it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
> >
> > Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> >
> > The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> > correctly.
> >
> > Let's wrap sock_create_kern() for subflow with set_active_memcg()
> > using the parent sk->sk_memcg.
> >
> > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> > Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > ---
> >  mm/memcontrol.c     |  5 ++++-
> >  net/mptcp/subflow.c | 11 +++--------
> >  2 files changed, 7 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 8dd7fbed5a94..450862e7fd7a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
> >       if (!in_task())
> >               return;
> >
> > +     memcg =3D current->active_memcg;
> > +
>
> Use active_memcg() instead of current->active_memcg and do before the
> !in_task() check.

Why not reuse the !in_task() check here ?
We never use int_active_memcg for socket and also
know int_active_memcg is always NULL here.


>
> Basically something like following:
>
>         memcg =3D active_memcg();
>         /* Do not associate the sock with unrelated interrupted task's me=
mcg. */
>         if (!in_task() && !memcg)
>                 return;

