Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BD9CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 00:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089389001F5; Thu, 14 Aug 2025 20:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050F29001D5; Thu, 14 Aug 2025 20:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5229001F5; Thu, 14 Aug 2025 20:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD24F9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:06:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EE15160791
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 00:06:11 +0000 (UTC)
X-FDA: 83777049342.30.4E17206
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70234A0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 00:06:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pAP+bCMp;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755216369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3g7azcGA34tDaaYjObSrLKH+WoZLGsOWxePbsNLSk8=;
	b=7Xysi8d522HxHPrGCjj/6m6wxiUeR/+NN9IJ/2qKkcs6V6P9WlymQUlTh4OOaX6aNbwDcf
	tKDxoFIXnAcPL0kHUu13xWDwQwgJp6BPvJT+6bqcC6v1wFx1O5GPufjExCn9ItkxFuAXBW
	ZeSInG6nAZpJhHagP18us+cwmKK7MPw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pAP+bCMp;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755216369; a=rsa-sha256;
	cv=none;
	b=fGHc9bn04f8v3NzIva+GEM4QBXmFnRDTK7lnSNGXa5ufODOEZIsv2kD+CBtnRrSKrrw9a/
	lTKxo7Ai3oiBb25Lv0JVuegbmiBH+px9e0GFbYDQKgF12ahr008o7J3toNQj96ojTf6FCe
	MhO5rOs3l7khaz6bKlzvy/2tmSbtzNs=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b47173a7e50so1203528a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216368; x=1755821168; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3g7azcGA34tDaaYjObSrLKH+WoZLGsOWxePbsNLSk8=;
        b=pAP+bCMpCgkDAmkGopGNw/q8bjsglaPbBgdAi2D+/VPaG7q2fIMLOQP6J/6piJD3SS
         thLSGblPNgKB8uV0rFxNRvhmdEPdduhWFBmdUDtvB+YeUIK4j3tfhqtpDdIaFMYKA2U0
         Qwn/dj30cf+qkYqcl7JJAtCr+JHfCg/JeO41/p4kQJXpjbKfHd3KwUrt3vdJMjNowXeB
         oHYqzJAMAbVgOL3iY0z4QifNWDQork5pZFkc8jOBenceW4pwU4ixD5ExQ3mE4dwk1f9e
         xpGrejWuy2UNUvUz2y4/diszCy9yZJJ6ZqhoXCnq9gIfTbRMogy+c8IzQCDPJ9+1gPkf
         ZRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216368; x=1755821168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3g7azcGA34tDaaYjObSrLKH+WoZLGsOWxePbsNLSk8=;
        b=C0tmCunr/9pbGalRv8zCmnX7wedWhH1aTE9JjIbvNd2cKGCm75fl+4mL+YLedz3Xiu
         Js5cUd+5M+r21q+jUXP8dkNf+SXo9Hilmvq6S0Pe8p8wEOsxpUuQTf8R4TpxVRZLCRtW
         C7oXkXicsIpb2SRIOGpzICM1duMHTj5zO8xZHs8ZSZyEzjZuciqiEk0mIKY5SuYcWhTt
         4mcdsh2bo/tNbj0w3twDwxcLdDefJhWu4MJjgnlwALJ2raNfRMuR9N5wxmKyfMd1apA5
         4aw/Ael+uBcC0ssdDlCPHfi+ypJWAKjBrnUxhoFCNOHtGAsEYzbRq6kDFpbVS0/dOu+F
         xbug==
X-Forwarded-Encrypted: i=1; AJvYcCVQEmj7rw0QO79Bnd2UlH0XpLTFR4tJM5POAl9ThXsOq5Q4hVLiaouSnYIF0MRu4GTQilKFk77bCg==@kvack.org
X-Gm-Message-State: AOJu0Ywm9XK3+YNfUofIvj7utmp9p0yqId/VsK1g4ugbo1WS1kj/OdDI
	KS+pqeeerF7sY9CfKnnYsMi7vKJWA86PLsWD5i6gfl1TV/iTryU+CnbzVn3S041k+xl+P65zHK+
	hkddsAaD9JSf7tDOxztCchBlNKkACBbZCyeX8HoQx
X-Gm-Gg: ASbGncugbG3q+/EVfXWwsE0YdPl8QGQLY13S2/xigz0Qz4hDtnR6k5ytfwe2Dfkyn7T
	SeWh8z08GS5GU00Mw78M+S7m8CSHg0Ju7xYoCLVFCyFhE29QD7ZlV0y5Bi3WWwqu3vYrDX3HCOX
	D3c7ZR7aiY/8Zx77nS/rmNQU+WWDycxJcD4fn0Dm9mnr5pIEkpUP6cvPD3waLpLNJhQMTzInziM
	r7BAVwwapfg4nIcaRwz/Iu0Qi6mqj3SoGpYoHzkWxomqpif21SE3gZh
X-Google-Smtp-Source: AGHT+IEFX5W+lUoDE7ZvmQhutvrW9vD5G/rFOFnR+zH+RlJzruuwGalQl9EbNrgSF6pYF7LAALbUj/uy+KXE1fNSEc8=
X-Received: by 2002:a17:902:dac1:b0:234:d778:13fa with SMTP id
 d9443c01a7336-2446d866269mr1258465ad.26.1755216368013; Thu, 14 Aug 2025
 17:06:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com> <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com> <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
In-Reply-To: <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 14 Aug 2025 17:05:56 -0700
X-Gm-Features: Ac12FXwONNleDf8vaBVKCNkrBAioUhawdr6ixCRQttfFCFdFsOrwwMIEvBAgFfE
Message-ID: <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70234A0002
X-Stat-Signature: j7w7kbp7xjsnq9kpieao5mdinxm1wr9u
X-Rspam-User: 
X-HE-Tag: 1755216369-552787
X-HE-Meta: U2FsdGVkX1/w8Sv99oSjVLOUteaYl0fDZ96AFf4ZH4L8v1kqmp4lwGSw9rdXHByODo4zz3EHxHNZeLmgeU9sdXHVWH41uAGJaC0gD3G6knRCQ8OreDf++CEoAXwfDALvWnExqPAJ45iQn5ddTQZcqJaC20iZ4G+goeb3Qp1ps9XnwJrKJTvi8enDD0ZTokMjswRu3e0fbDmmuHx9mMw0zZUv5IlNUmIz5+LR5WHLyqSdhfdr4qqqwQhUXYovScZ60bgTg0sCHfeIuJjCYfrqF6+6wjxx05kwcGiLoBppOR44jnrhYktiHnzZ00tpX9+T7hMLgHAvoJgh1bcMVr6W1pvhkDr2htqzXWs2M0uPjd00fw3WpEOf6MAiGFITT1GJSlT2WEJNGnhVFqZu2NMOXwojJit8NvnU1H3fTPSNtObuBlCAiq3ix61lYSy3zPEvmIahgBHIDYORrpNSN5kVGvLyLj6yRYXAFRhChXFhsUC+wHsjsW4PiUOTRL3tHhjWQQndwL+IGc7jsmj55wcGiv86Q+9k/e03qLyCYuf+PCTVTceJGgRVVxzynJgXPO7spIZ2NsxlFTSUV4xrNuUrT13I5hrewoTP3hFnvc+eIdvt0cFH/WQbNOXhyP3N1AczIqM4EGuQiYa0cg6VrNULUgEeb9lTfIq6dHRf4zDAQyhXZtI1gZtV3H4Owq3YBk4zufdiYUGWmMR5+EMikp4Wjs2tqhdxp+iELkuU5oa4R786+H4izrF2kPXevFugLS+ECVZ2GmOCAgyPfu1Y2/c91x8+5psUnk12YEtDX+Jke5gNOpFo/sqoRlwrs6y2vl7D0oFWT5MZ/gWRb1iaPO3suxPCzHRG97KlUeUs8gfG4lZVBYioew2F7CBBjrJHeWPimBFfTofQu4eae+G7HY6RjATUi3AX9yFGFuELEZAOvOuCOYToTlZAKXOg8UidT6/3ywwFqon2OaCsyQrOkwV
 uK6pPHVn
 Lkukv8Jxe1baqFJ7yKBnmPFE0xz771etJPoNYOmMMmwm6AIO5SOX6cKEo8Ha3jVMV9nQ7r5hF/GuYLr1b24bcfdVnwWpAOoJ8xlFLYgYr10zFZRVTtLAZYEYUkoZAB83tnyJKhyJ1K/COEIJ0zNbKo6XZs0RxBO+40XJQdZw4Mld90E97Lad8lWxXPEuxg4+jbh2AQgVxrZCzKWX7Q04hZS/WrNReJe2U5GTc12L9PYlr7Vcxb15iFRE0T7x1BGMw7z15mPa8n+QwBsV3UMsUG6KHYy8Umw2eOYCgOVdcrjWJg+4avNncbHFB0nikuhkF3kez
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 4:46=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
> > On Thu, Aug 14, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
> > > > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > > > sk->sk_memcg based on the current task.
> > > >
> > > > MPTCP subflow socket creation is triggered from userspace or
> > > > an in-kernel worker.
> > > >
> > > > In the latter case, sk->sk_memcg is not what we want.  So, we fix
> > > > it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup(=
).
> > > >
> > > > Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> > > > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> > > >
> > > > The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> > > > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> > > > correctly.
> > > >
> > > > Let's wrap sock_create_kern() for subflow with set_active_memcg()
> > > > using the parent sk->sk_memcg.
> > > >
> > > > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgrou=
p")
> > > > Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > > ---
> > > >  mm/memcontrol.c     |  5 ++++-
> > > >  net/mptcp/subflow.c | 11 +++--------
> > > >  2 files changed, 7 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index 8dd7fbed5a94..450862e7fd7a 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
> > > >       if (!in_task())
> > > >               return;
> > > >
> > > > +     memcg =3D current->active_memcg;
> > > > +
> > >
> > > Use active_memcg() instead of current->active_memcg and do before the
> > > !in_task() check.
> >
> > Why not reuse the !in_task() check here ?
> > We never use int_active_memcg for socket and also
> > know int_active_memcg is always NULL here.
> >
>
> If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
> infra then make it work for both in_task() and !in_task() contexts.

Considering e876ecc67db80, then I think we should add
set_active_memcg_in_task() and active_memcg_in_task().

or at least we need WARN_ON() if we want to place active_memcg()
before the in_task() check, but this looks ugly.

        memcg =3D active_memcg();
        if (!in_task() && !memcg)
                return;
        DEBUG_NET_WARN_ON_ONCE(!in_task() && memcg))

