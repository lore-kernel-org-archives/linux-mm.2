Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77378C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C426B0098; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927A76B0099; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812B16B009B; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 580FB6B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:22:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E053F80937
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:22:22 +0000 (UTC)
X-FDA: 85045204524.14.E7F54DF
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 005EB100009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:22:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UXqn0DWR;
	spf=pass (imf05.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785410541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGIW1MvIRwAt3M9iZcnxogiulmE4EbWDPVgZcfiXGJU=;
	b=anFdyTgbqBQZacv/PI9rCsG/VbLiZHCOmXlg8+Q+t4OOPKYJlxxNCEP0oinMqQLk7dcCKn
	KZqvx2nbSX+hUtZd/FPg9iIquyZA7RUqQ6MvfsZwNNnzvLnyJzA8zC7if+AnQcyJC0h94F
	owoyE+v3IBOkUNNFNSY2ovYZLVE1mVE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785410541;
	b=TA1BJy4P0ZSMBHdpUfAt4mMkknveHXiO/GAJk4aW5YiX+qJepXWRWzYSZlosFbqi0Gttdn
	ifF+v2PFeULIfwyODnw8Chz3b/62cxrMfpzJgb0VXdYtzFHsggDW0TAou0DZ2jUxquXMV6
	9oVcNmCwN5DrQ1JOb+lJ2uSgl2Vkah0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UXqn0DWR;
	spf=pass (imf05.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39c6b6c54b3so1538531fa.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:22:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785410539; cv=none;
        d=google.com; s=arc-20260327;
        b=aPI8fiP2n5x+7DGkcIsKCh/ApzsewKgxxHRzE7D2+x6zyKgiWzbplnQsPePdPhtH+v
         ZySajRGVUmmk3ZgZ12pP3HKLDiLO9M1Os6WEqCqMAsCUmXabG2eSHlLs1eGPcIeApJ7u
         N+VQ8suu7mEvCwwlnPAmABy8wNsVVhJW9PI8aDLw2p2Ab1y5WtsT04LMRvuqUSR7EAj9
         HBYBJWVG3cRNfZkZREQc0MSl6yHWf87ot4/BH4YW8zj38C9JkXWeDjUGs+ExOtfXfiv6
         d3tvUZblEupL5zNnrH9ZAhfQxXY8ltp0QBkTWnp86GIXgVRy34kA9pAxgZ85PC9XAaDg
         rXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tGIW1MvIRwAt3M9iZcnxogiulmE4EbWDPVgZcfiXGJU=;
        fh=EnGL+GpP9hOb4YgjToTgjvKiO93OMKlWhskT2kahFkw=;
        b=TsbdR6AuJZzXkdNSZUXeQmMZb2nK1pYbhE29WqyYUg7jHqX4IBjOikupmUQ+3mqxDm
         Qe49a/r+AZdaDdVpFNqNyCw2n37NaUK/nwiqrSWtbIreguakeYKOtiOrobJH4SrUqPLV
         vJwz2+bcNJ8AvU9MfGv/RseJzLZCpmIUCqZJkLkceQxRveSdDh8Oc8B1JVTuGWy4wvLp
         AWlrPmOGUgMHqf7lJcx1NP7QFUh4tjw0TvyyE2JhuKBHVyV1kvyZA/TG5uV915LnEo80
         QNnPBaPV73DuKjpOiV6iAFkva3VdQ7FFA+tBUTOEQML/fPmBH3MYGj+LZSiuIp5Kcg0f
         vX6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785410539; x=1786015339; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tGIW1MvIRwAt3M9iZcnxogiulmE4EbWDPVgZcfiXGJU=;
        b=UXqn0DWRxGLPGmTWTQLRc7/p6geMt+TNbKkHsEFylf8vpCUzzl3WttyYlx29TVDhr8
         js6QtQN1BwPyBrZCF6X2nyQ0UZ/80GXVFxJafiUth0B/DBJULILR3oMtn6sxHX6g2D6s
         3HRYCeFLo0PLkogzAq77C7atYnLMaQvfAMJtbChQ0Zi9BV7QSj7HgiVXkHa+PigCrE0M
         A34qumFUrzqlOWHnBEs5InynMbyd/Q9gzWHVqdx2fmp43ayfywKJqHZZm+gtCw363439
         uWB02fEH/43CXOoEG31vE77ux8fLVQ+1vTTHvXi4tcHxJJ98SS8YbdqsB7SyCkIOef3m
         jkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785410539; x=1786015339;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tGIW1MvIRwAt3M9iZcnxogiulmE4EbWDPVgZcfiXGJU=;
        b=dG+tU8oUKiAGJpzmvdOn2el4uUkd15iQFaspSit+zZRXRqdBN6ZJhmU8p9ObZYNDQ9
         4cCH9Gn1a3nCQQ7gONt31qIzeNN2e7KsYjTl10jDp3wDfXULSlFH7spYMrGGwXZ81/Nh
         ygKFIfOVxKohET2A/9KfJmx5LtcwBSmx2t6ZyNbJmWW2nWqN5vFYZ/LgukrtM6IHaYvP
         o2+2WCQbqsIy/vAdDOW3feiYcCxHNJE3JKZdbQVQjGPkesmwWPpdduZJHtlWqaHvhdaN
         uUFnvlkVSdY53SMYZsWykxYsTrM1587EMgWaddH5xw/9/YF0wjwPZcHs1JazFcBygRUF
         32uw==
X-Forwarded-Encrypted: i=1; AHgh+RpMZEAvpiJAt9Niw7K6kUvo3O/Z0rRYRJy8V1UwZ0Xal7Uav7YfWAapFyo1x3mA2tNp+OIOHaeXRQ==@kvack.org
X-Gm-Message-State: AOJu0YwESN+h9mSpze1v72o9RWw6OYbYmJlVE6cKwrJ0/+dz/S0s1xVA
	h9/NBnOEYtg6CXR4rJY70RsEQtQWXKDzxpJpWU6SI/VJ7T+eNvAU6FMULc7Dxzf4MMmOpxRXhcY
	RlfJ8ScxHWhOuCxLfcM93r9iy29Dwasw=
X-Gm-Gg: AR+sD117mQ5ibtfEHMB9+yVad8pGmfCFe6QPUuWSfaqndLUTuZPntmxX8DJhHIxtqIf
	Ne4s5Ny1yWBQ2pX6aaga+i62v9uTB4pXmK9k0Tw/9S9RtH4imzaSou8HYPCVoOFL+SOXDYVeblX
	8QEcuHd6BCOVZdj3tfH8cqo5pyQlFW72LatgZRy7lUswsIVGvSreRvAbPUZv8oVPGdpEyE7746e
	XmacfZCej7R8alKpoY031VzCE7SbXgw5HUANhG7Eow6zm99AUXpO5GGfF4idkNuX5A+W3krEt0a
	B1LkEh80STTg3Wsk+y/x+5KjZQQ4+eYkDNjvvYcofTJo8syxSO4+em1E
X-Received: by 2002:a05:651c:1546:b0:39b:3019:2267 with SMTP id
 38308e7fff4ca-39f6b658766mr4120441fa.0.1785410538919; Thu, 30 Jul 2026
 04:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
 <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
 <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com>
 <CAGWkznFCzz=ow2eDyzQR6UsAkLvuamEYpyc4PXJXXd6rF4HHcg@mail.gmail.com> <CAGsJ_4znO0fPzNBH-CMakf5hcTFyh6exBTEhMZ1TRmn6283rOA@mail.gmail.com>
In-Reply-To: <CAGsJ_4znO0fPzNBH-CMakf5hcTFyh6exBTEhMZ1TRmn6283rOA@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Thu, 30 Jul 2026 19:22:06 +0800
X-Gm-Features: AUfX_my6BuvxqDrtg-LlYxVlQHZ5lI-OYk2dtElPXoVBqceuVE8_3CygcNjIOM8
Message-ID: <CAGWkznHS+j=NQkTjMbEcU-8oS94r2JOgxjGm269+YCj0ye6o8A@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Barry Song <baohua@kernel.org>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 005EB100009
X-Stat-Signature: a581eztaegifeior6cwo3qauh1iuuwoh
X-Rspam-User: 
X-HE-Tag: 1785410540-213692
X-HE-Meta: U2FsdGVkX1/JML57o0VbHPwQ4+iYreOpF+gmj+Zg4Rs7mORW6J5bbRpArhvguKIut8vnwSK9A1OpbXQZ/nNLGLR4cQGQHmVv4XA83UAMdrNWbMg+lONNNo0Kg7tTi3OIRWpxot2eXoCa8pBFN96Xc9vBXQ6deWSbinZDiuJLgFCPBhq+OjEhpSgDHQrmVSBZLIdE+79Ym9Wo65J/cYDZMAzRtPqvqi7oh2/mkuJFfhqchgA2eAUIXzFztwoH7LVNfYYhCZIZcmpZm8FZRuta82Lol0LZya0neVnssePM3w3xUp5TBeAFHUmHuvuvIcZM7lmBJ4wNjD0J7t545b/9jLlCGAe9gpjd96yNSkNEC+B6H4EPpkAm2irLdMl++t1hB4maCgz/rs9ICHZ9hL9KWYmM4dXLLQOhvh+HcJwklQxLrpM0CZ9CrwmADHrmH2EZ6ZjSguWypAk/WydPqsLpzXHWoXrun464Aa3mSpeHdtzER1OlA7zMY5cGU5gkasHJmsI2Qpqk1IqKgnxYnLpQozjDxVCimC1nupudmD258MrvcQwMGODXk7PhegFyMSif82YmAQkCibY94TwQ0xPNoObTsvmmAjvtfpsq/cXi+Qf/JJRK4vr42Dsx6Tq4Q75YcnX29Bg9YwWo4M/PaT2Om4kWNPOYsNABvOybQSPqNfuXJDC4TIAa3KPyrhaJ/AslbjRfHgRp1uR8oo/+6p4mp925codRz9vtCLGnv/HhAFfT7pcLqjULs/u+Gloawa1rYEJ6Uj8aPL0tRQsEbQDnDqViZMSAHcW1U6u3BQV7GUIWw/asHKgyHo7WpLRKEbQE3ydRS3vKVmS7QX4LPhX/bHj9jAZpqv0ozGtFEVHacb1C+S+sB+Gn+bFPmcQsRu7yYurvlKz94XDT3aEiA4T+KpAAc6ReWmOEEM3a9Eoi+81sTlla5Xm+4WYhfVTMAhCIMW1awAz3jc14rkLiIDu
 5O18aBFc
 HvNsKR+qhX4Y/+YJkol1HQG0DSrmFrY6NktQPUOl9iw+ryPXtDjWzs1XNM+5+b0Vk4vXDfNHHhbpovFsp/ThiOLTTXZ4+w6u2xUj+SATxU/Wj4JqdexcnDKuYrmYMl+3sMJ0TkpK9p+vwb6EczKHV0Le/RyvuOgKyB7+MgVuJ631Gov7JN3+yjSbngJcDGbaxMr0V+AfwWbC/4RZikDpaUx4LX+zgNdWZHX2NbPmZE13bEozboiMVzfCpPNVfim1rWPgudJE+FxYwLFY98NU5XeeZo/1hN6wdaujQhIuea8tSoCJlMuWdrcYzZPBqxNvHFDC1hocFSilpDtJJ8rCPbpPylKtxLZurf94tUcHwVu1sBN1Oodt5Zcq6ks7KBruAAEP1PTohJbMMpwezGWctKCJxoMmN1tVybog8TvR9DAHtzutufq7Jmp2gdpm8iI2v55WWrOvTr9oOjFkPsslxn2OObLI7j5QsTDac/sP53V/NfLOClIWD8jjfjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:41=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Jul 30, 2026 at 5:35=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gma=
il.com> wrote:
> >
> > On Thu, Jul 30, 2026 at 5:31=E2=80=AFPM Barry Song <baohua@kernel.org> =
wrote:
> > >
> > > On Thu, Jul 30, 2026 at 5:20=E2=80=AFPM Zhaoyang Huang <huangzhaoyang=
@gmail.com> wrote:
> > > [...]
> > > > >
> > > > > This is very weird. This seems like using a sledgehammer to kill =
a fly :-)
> > > > >
> > > > > Do you mean that isolate_folio() fails, the folio is put back
> > > > > into the oldest generation, and the next time it is scanned, it
> > > > > still fails to be isolated? As a result, scan_folios() makes
> > > > > no progress at all?
> > > > > And is it because the oldest generation contains only this
> > > > > folio, leaving no other folios for scan_folios() to scan?
> > > > >
> > > > > Why can't you simply promote the folio?
> > > > > Do you know why isolate_folio() keeps failing? I suspect it's
> > > > > because folio_try_get(folio) fails repeatedly?
> > > > Yes. As described in commit message, the orphan folio is an abnorma=
l
> > > > one as it is on page cache but has folio->refcount=3D0 which makes =
it
> > > > isolated and putback to lru forever and finally be the only one in
> > > > min_seq. IMO, MGLRU should keep make progress with bringing this
> > > > orphan folio together with.
> > > > >
> > >
> > > Why is a folio with folio->refcount =3D=3D 0 still in the page
> > > cache? Can this be fixed at the source instead?
> > Yes, it is a bug and should be fixed. But I think it should not affect
> > LRU in this way while the legacy LRU could move forward in the same
> > scenario.
>
> Yes. But, if there is a real problem, a folio could always fail in
> isolate_folio(), or keep failing for a long time before it can
> finally be isolated successfully.
>
> I agree that we could apply a similar approach, for example,
> promoting the folio to the second-oldest generation instead.
>
> However, if this problem doesn't actually exist, it seems we're
> trying to fix something that isn't a real issue.
It is a real issue that some android vendors run across recently in
v6.18 under truncate and fs's gc test case. Some vendors even switch
back to legacy LRU partly because of this issue.

