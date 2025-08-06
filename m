Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F311C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D486B0095; Wed,  6 Aug 2025 18:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E536B0096; Wed,  6 Aug 2025 18:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54206B0098; Wed,  6 Aug 2025 18:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B50316B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:01:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E809C073B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:01:59 +0000 (UTC)
X-FDA: 83747705958.20.02F3D4D
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D2C1140004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:01:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h1bXuVmD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517717; a=rsa-sha256;
	cv=none;
	b=tVrwJYKZk805zpgVa19kU6h40k15FzyPz93+hrHBakesykdtbc3NtQhSZq5C7mI4YVk9wf
	zZLIFFHGnAAM30fHaWviShyP16g0TKvCkWtY13i+9dSdBBqF4L0HWAjFXXcuPfDccdV4I3
	LwkG8sK/LPSoQ8lRmF7tVaQ/br024+E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h1bXuVmD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tS5sWoIyqI1LV97Jb4CN01ckOCIdChBVFk4TORl7K0c=;
	b=K8lyT7roxqmE19OWYkzGrXYEJjjTBp7VZX616OaGfguyrFDF3SAeq0s1Y6slIBjuuA32g0
	Aj/wQntJc/pZNgYPTaWgUBnx/+LgVKrRQgvG4Cv8Rr+Newvc0Zy8S5RoG8ffFm46LuY+m1
	TMBEFLe40RtRX4qtb2sN4OVt4BEnjnw=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b3be5c0eb99so257637a12.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754517716; x=1755122516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tS5sWoIyqI1LV97Jb4CN01ckOCIdChBVFk4TORl7K0c=;
        b=h1bXuVmD9qlJsRzLgqvVghwtGYYDo83s7l0ip4IOBVVbUb6wPLuwcHazYTTpe/PNG9
         RcHED7qljwe9zNMQKdOI7xfG5kgTI0SXaRDcLmlJBk+boAOyw24YVJfZi7aeeBcl2QVN
         omecBtJu4td1Lw3aqNjvSaG1/g6gZfalLmgNew/qaPyuBjIjuHGvViB/tArgbtV4iGny
         IwQoUFurK8tJ1NuYFOwxL+4eIopYxwluXULIxc/gu3hMQr0/CFl/fmIPDQgUihpMmSmc
         v1hC491gBhz/zWw2vAnon6aHEuTzG/InunSt4HAD+x5CabIsRq0JH5YxvXH2lJkEA7Cz
         RnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517716; x=1755122516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tS5sWoIyqI1LV97Jb4CN01ckOCIdChBVFk4TORl7K0c=;
        b=L4GGQ9tIbEEfNb4QvgFrarOZTp+lQE/yi2GVqzfiTDLczKTvqAIeqMcMGtyyRVX/G0
         NmQNojvpTRIrYVM6dPuuTc8WUeIR5W9Vq/WZH+EZ9pQJofsaaz07IbvosUUG/ZgGkfT7
         eJIpVa3fzvRmomLpXZEVt3KL3CEkGVjTDGLRcanCxBIeyIlcnIhCfJ4LetvSyss+TrO/
         JGepYJZj2vjnZj2dmORt8uDRJxlssfesS6RrwTdZSclLmJd/GeYTHmIGqfyV/+6uvoi2
         XNxaP00TppaecIHYk5kaOF8rQqQAFguyHoACLQjc8VlKUHyVxNp3kPfc7AkoMvBRKMP2
         Lygw==
X-Forwarded-Encrypted: i=1; AJvYcCWzEmusQ/LAFy/ew10ZjyfwvD0OExmou6ghi47VjRC4+bWDnfJAJiZGqkJCL7qVzkyKpmIctZkS5Q==@kvack.org
X-Gm-Message-State: AOJu0Yy4Yu7lvS2B7APdRm2aqXepRJCcau150mnCTRqa5g7VOufl1ahf
	RdLRBx+nz5YA8em6rwUVlSFDEU/83qYAuSBKSLBCACI9bv26K7ez8FD+i1IwZudkeirvi5EQOpW
	B1K3N1mUeeDSISt0YlAw4sWSIYo/jslR9D0Qv69SDOlOjzZk9IKBhGZUblEU=
X-Gm-Gg: ASbGncuEE5neyljsUYWGTNp0ELPP30wn7F8hnZVkV3D1/i/RP1C+r6w316GrfKlfNeV
	OmDmwxS9OqAGFha/R4o8LHWmN/TOQcJWk4q+NQibTeVzSgWATSXHCmfxuVrklz0BI0elVKRnMhj
	vio14ulIq8XDC81FfKfWJ9zrtqJI7HeehnLgKN/o6C2bcUjvCWwVoIuquHmyylXHjXg89/mYHJe
	bFUKU0/j2MjVBsAjcfR3t2XeL9Tk2zwJjYBmA==
X-Google-Smtp-Source: AGHT+IHSk7dzFSFXcu4X48id9sXvSiAxg4OZ+/L9B0Yq3eL15/6jfV7hChGejTL37W1MR4sOHnmzKtJZuAb4DsrqR74=
X-Received: by 2002:a17:903:2f89:b0:23f:d861:bd4b with SMTP id
 d9443c01a7336-2429f2d99a8mr55381415ad.5.1754517715836; Wed, 06 Aug 2025
 15:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com> <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
In-Reply-To: <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 6 Aug 2025 15:01:44 -0700
X-Gm-Features: Ac12FXyFJKmVEi3oHI4ogHBbfqPpbXF9V_pMaOAaUcyE_TX_Or4bugRENLRs7x8
Message-ID: <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7D2C1140004
X-Stat-Signature: bd1ms765e5qy8bec5yffg7pschwmxeo5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754517717-645824
X-HE-Meta: U2FsdGVkX18Y8Ox9ln8oyB52bsyvZasiklR7lMcoBY/ZoLjAZKMK3YKbqy0cuj560iibmarNgAA+IKZVhDLYPXh3XS7UAflScJzg+M1p/mTfiUuQLLd+GPJ5zMx/ur9N81KRAX+43ab109pw84PDW/vSrS1GcNA9Foi1Sim+pcRUu8cfm+k6vY9AieYd2kMOqKva/WNdgoyOSDjOP3wg2altGoqBjF8xLne5oda34NeOzGs+ygWiFqU77bZD2jd/ummgstJcuZPmPuzGq+qy/UlXHO0BMCtcOEgkwQuXHYG6oe8ecAdyJ+NC0st9raDuyB8GwyudKbj+xA4ZLHH7kCF++zGZa6LI5y1Wx45XnQyYx9G6X/X7KIB7JJsKgX2IUKL1nQBa7P/Bdvb9HBaRYXEETFuweFkgkYy/XpzkI7knmm4oRvB2uSyYpo37/icYXYibtxGoqaUhAcoAwHmAZB6voixTGx13yl/NS4gd9XlFd0dF7FZp8v1As1piWVgoM4veYydu8cKTTl5cQBKwLLSJ9V+BfFhUUb81bAEUVYl5HwHs/oiT9PAvPQMkl/v/N1dgDVHWVqGFypq5XDF+vTJu+0K8I8h8uWFGUYdz+Mg6t5ehhMAxZ4+t46qZ6J9hpD1CZvl83gIs6jJi7zv6v04zeuDNov+eyp/hB+lwIvAVOGMJbUCOsXhzHkdbHCMXp+yZY6EC2N8qRs/clDzZ9sQgRrix1oxejG8JLQPkvMuJJAkNSf4U8FsdKU+6hFDDpqG2GPSFr1WkQj9cDlcYWqIXT8EiueWU75HcEJBM5Q9UNOh7gQU670cptocJqImMZjekO9ujvmYMH5p5N3h1jWpQd3UHWGD8S53lo2uZmwE4urN8S4Hue0uUUCaY5TEfrjpyWSjvuZKSq1PjxMrZB9OJwUM/coGQ7h2hSkoz6tiK9AiP7yMThHyWQulsR2aAGi0GbWGPjU65D12MtHZ
 8PBog59W
 9lKAQArctxftMuCnnRr3tYwEjnEcsMtFVqV9mFEMQBnhhRyp7zP8zX2vBZiDX80fP2TC3DTS0qTpNpnHJQOJIN9b+8wMOYGVxXbZzN05zUjYefPyyT6Pm/unwMQ8QWo4Um6MU5f6FL1FnV5zMhaHP1VUZcZyytIHn9qhDW/58/4CXS6PMqSfNg/DnUrPcc1w1iZib
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 2:54=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
> > > > -                     WRITE_ONCE(memcg->socket_pressure, jiffies + =
HZ);
> > > > +                     socket_pressure =3D jiffies + HZ;
> > > > +
> > > > +                     jiffies_diff =3D min(socket_pressure - READ_O=
NCE(memcg->socket_pressure), HZ);
> > > > +                     memcg->socket_pressure_duration +=3D jiffies_=
to_usecs(jiffies_diff);
> > >
> > > KCSAN will complain about this. I think we can use atomic_long_add() =
and
> > > don't need the one with strict ordering.
> >
> > Assuming from atomic_ that vmpressure() could be called concurrently
> > for the same memcg, should we protect socket_pressure and duration
> > within the same lock instead of mixing WRITE/READ_ONCE() and
> > atomic?  Otherwise jiffies_diff could be incorrect (the error is smalle=
r
> > than HZ though).
> >
>
> Yeah good point. Also this field needs to be hierarchical. So, with lock
> something like following is needed:
>
>         if (!spin_trylock(memcg->net_pressure_lock))
>                 return;
>
>         socket_pressure =3D jiffies + HZ;
>         diff =3D min(socket_pressure - READ_ONCE(memcg->socket_pressure),=
 HZ);

READ_ONCE() should be unnecessary here.

>
>         if (diff) {
>                 WRITE_ONCE(memcg->socket_pressure, socket_pressure);
>                 // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
>                 // OR
>                 // while (memcg) {
>                 //      memcg->sk_pressure_duration +=3D diff;
>                 //      memcg =3D parent_mem_cgroup(memcg);

The parents' sk_pressure_duration is not protected by the lock
taken by trylock.  Maybe we need another global mutex if we want
the hierarchy ?


>                 // }
>         }
>
>         spin_unlock(memcg->net_pressure_lock);
>
> Regarding the hierarchical, we can avoid rstat infra as this code path
> is not really performance critical.

