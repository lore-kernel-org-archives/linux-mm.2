Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61940C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 22:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D819C6B009B; Tue, 22 Jul 2025 18:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58E76B009E; Tue, 22 Jul 2025 18:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6EB26B009F; Tue, 22 Jul 2025 18:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B84CC6B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:10:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75E9816011F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:10:41 +0000 (UTC)
X-FDA: 83693295882.03.7BBD017
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 92AF540004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:10:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=21zOg4eN;
	spf=pass (imf17.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753222239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMu39Qawe4doNbq7gca8Aps/3YUEzEFiqgdkwW68ctc=;
	b=wzMrQvHZF2K2jHSh21J8wK9XVHOxwmNt1pUT3QHjW1GHg1IpW4FvV8UVinBSEsvkuIGWk9
	7xU68+NeMXI7wEURBECmK0Eb6J6mZIfR0r1Z/fKc/ODSGKPyyHmdPrp2CY/rR0N5VkWofu
	pqJyG4f46PI8iy2HZAIJIzoZa03FREA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753222239; a=rsa-sha256;
	cv=none;
	b=WI0iKwCmTucd4VN4ombKdMcg8TCH/uhMveeXI72SeF9LKNKHMG6mIU6biBkD7raATrFnU4
	93gX7ymASgHqzBj1dn6cNVxKJeIkUPHJ62y8LXmf5kAnADO1ZQBU01QsycBLE+Z5v4opO1
	6p0y14rfIeXdvFZCJEdEWD6K5CFNQjE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=21zOg4eN;
	spf=pass (imf17.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b34a71d9208so4204991a12.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753222238; x=1753827038; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMu39Qawe4doNbq7gca8Aps/3YUEzEFiqgdkwW68ctc=;
        b=21zOg4eN0kyDPCIBxIm3PypYGOs79NLL1tc2CEPyDo5oszurH1JeSC3dAbL4wwqeu6
         gxIzTbz3l4dIKEHKRwl5sq/o4mNakHpjgmpaZN0oAKNtMQdrIrjaY3uqfkuwrga2eBhm
         8Dv5n51RXfKMtezmptYcqhA5piQHDduD4B8zdvqVIjfejsE9SPIaqvulU16VmDJvIDtm
         ibafcewVIBcwkQiGiEU4xHN9BXObMZX7vNAh5pye2W2x6xPSFqYvonx/epnPxClk80fD
         UpMCOKcJajcwVeobONvMvqUE9Pmz48NAus7Ru8zRdEpwLuJwomo+/PRJnyK5WI21aZZZ
         CrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753222238; x=1753827038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dMu39Qawe4doNbq7gca8Aps/3YUEzEFiqgdkwW68ctc=;
        b=TYQTy9wqGCnv5785h0HPWEXEq3QjtDd8Do21zX3ZsmjMyvQ8UTuIx6ld535b32JPOq
         KEeoUKEWJqPfsRK7vk243nDE4C4ZEMRbx+g7FBA5RwlNuvIR5Ypnt5IoCdTl90VzKews
         MaJbYTCSYk0PG02WZyChcKp+8HOYLCEOhuuapY9eSwAv6GYrQ6Pd8kE7FuBMXl57PaTa
         Owygk2gmsjgXaGJ+ytqULDkg9j9qYr/0MS27Y8evcRlmLJm3vFrYIMCHn8+vVSKz75WQ
         Wccpwt78sAH9iDj2ZJUuYLpFbh8E5oruKti8QNqRqvS5v/WVbJl6gzxquEqScb3QyUZ5
         dCWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCnVgVZH+p5ywOISncX/doVSWYbXH025cQX2DhQFYV0AtBEgB/u1Dn1fw8+GMzpc7ZJ3bFTsgBjg==@kvack.org
X-Gm-Message-State: AOJu0Yx2gSuNwrG/9belGP5Z9vnZgS+m3Q8tSufoUsdoN26hfYIoeO22
	MOMO1E4iIOHu5toq4oluTlZDqaf6r5JdHKm17+5Xv7P5tluq7w8Ci8VzWM4lW7aiqmO3v/zWQvY
	CK9t59EbB8Dl3ji9OAQj+9AITL7xbtHqjrvQMzk19
X-Gm-Gg: ASbGncuwNhW6mv6jWdRbpNhEWH5/WcQqwuz6hfNYltt/jXpnDRfYIjYzUbu6bhY5D5B
	uTkP9e3ed+SEQ9wOAwbEd/tDq2I5rRQl01my+zWJqItwNCi1ErGeeYD0ji+gncaqqEw/A6onCOP
	pepzEpcRib1wdfH/5YEQq7XDS3XRF7uNNsHKomc9o6slx5Rln8AxPNlEuOV+48NAhVPB+ghuTMq
	J8VTXPCY7x+O+P1u3SSLjZkMtYqjeNNdk4g9A==
X-Google-Smtp-Source: AGHT+IEXpajWjFbFbIokxEFjTJObVRys/LIQ9BsDVyGOdn0Bwr9QNYm/RJoa2DfSiuRm6/HUlN8Vmr3WAOUBQQKDqI8=
X-Received: by 2002:a17:90b:4b4c:b0:311:b3e7:fb31 with SMTP id
 98e67ed59e1d1-31e506890efmr1392388a91.0.1753222238076; Tue, 22 Jul 2025
 15:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com> <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
In-Reply-To: <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 15:10:26 -0700
X-Gm-Features: Ac12FXzy1MKKZWG2l2iWJgUbEgy1nu_oczRIhl7Ym95gxwm3W6lz1uXCfPsEMTU
Message-ID: <CAAVpQUBcovfWW7K2P_6kZoQn-ZrdAJDN_yCm5unHkH6FLpS_VA@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 92AF540004
X-Stat-Signature: k7i1ykb4ni9chs7c9ozi6kakzmaeztsd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753222239-497362
X-HE-Meta: U2FsdGVkX18X1j6+/0B+1RiCJgpWSEp4qEZf/J+JNUkEq3hKg6b+806Hm7L/1LFg8NRyeVr7iLr2zStaMovkhsMpgVrzUmKIukeIAwj79AdTKYDgGQH758zHTUrliB3K1oEsVVFKETK2ZRHItH2D+FlwYNY4KnjfbapXURnjjnQ1SMs4FKECcOQ/unJ9WEDtZnhdsXBvuR2OI5HVSQR8DBPc1leuhx5j4jwCOr3uJKsOQ9IgBn5jMUcdTwlJEcAnjrtipiBD+5PAsOqsXc3gfLAcyJdCmfui85Va9uw9aqwsPo3KPQcbL/HEqHblehrTjwwctOunMp7pVgpJzY8X06b+Z1goYf8yy0e2pbL8hLomHHFF47zPjd+eaaXGF/XWq7VPKBYns9PlwQCyF9N+e/j2xicupQmLdKBJ6lVGbTJCIQON9QlLD6Qn9YitKWc6eYhRxrqPpIT/5K2M8353251dHmQfSwKvEyiA+x9A3u6gWdi8CrIt0LqJffWBcFd2iiGJ8lawyHxfn7T3xjdet0ajgV2H6tvb84E3zg2zQjc9p4dAK+dk8SFarApR7QQjCbMTVODewisoGNQD5TR9GWBUaJT/JCjpEn+VEQ6PkJXkefsTQefIX5M1TFNJSrpZdMew7aHImtDemHUKewWji5FYTMOQ/pdmtMUbEmwc369HH46aV25uYd8pfycQzHAcEQciEnocBfOMq4DrSEBGsYSA8vFPIykTvC+Wj9701auLDYRQ+4UWlu+2B+l927yWmMM0BqY5qld1G9vGxhL5elE3fnxxYvdq+HrvZD63AkVcA6yfbYGhFQNZqQrldfPvMZ7VjO+JOwgE7VcMct+SpYXSlsgXN+gjsXx5kGoBc3DGurTuux+aFb9EU2WMa+Dl6ZroOyxZYK9dzvEwbmIgv9xRGADnSOhVK8Ncl+5ZWo5VBLT+SxLtzFEM+YZ2MpAmyo4chWxvWE+jab4YGho
 S513M1By
 TWehkPFu94Dc1cWEdrqiN5FXxMHOPMFdN8wVb/xxMmki5xfaf94S4Iq5NNLIp9DK4sAeZ6ews1tyHqdC/Lfn82MRudxlU5G+VxQCGWnUnjmgF7FdS2OCcBuL1ng+2lqtyU+PFcsOeVVUt6NkB/XVVSaUq6B65eqnoZ0Vzrn+nYI5Zei+O/PGnk/5DYI+Th5NxGNjsZLvfr+VZfkzDm8mNYY+dbGg74ZV4xQGXx90fe7c2QE8EET3Ly0Xk7l03w6wBx5aTaBH1+35PYZ67LSjco1PuuyZKCKVG1ofHnEmR8GxRiPoKsVR95s9QZVCECWrS6PHa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 1:11=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 22, 2025 at 12:58:17PM -0700, Kuniyuki Iwashima wrote:
> > On Tue, Jul 22, 2025 at 12:05=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > On Tue, Jul 22, 2025 at 11:27:39AM -0700, Kuniyuki Iwashima wrote:
> > > > On Tue, Jul 22, 2025 at 10:50=E2=80=AFAM Shakeel Butt <shakeel.butt=
@linux.dev> wrote:
> > > > >
> > > > > On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutn=C3=BD wrot=
e:
> > > > > > Hello Daniel.
> > > > > >
> > > > > > On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel=
.sedlak@cdn77.com> wrote:
> > > > > > >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > > > > > >
> > > > > > > The output value is an integer matching the internal semantic=
s of the
> > > > > > > struct mem_cgroup for socket_pressure. It is a periodic re-ar=
m clock,
> > > > > > > representing the end of the said socket memory pressure, and =
once the
> > > > > > > clock is re-armed it is set to jiffies + HZ.
> > > > > >
> > > > > > I don't find it ideal to expose this value in its raw form that=
 is
> > > > > > rather an implementation detail.
> > > > > >
> > > > > > IIUC, the information is possibly valid only during one jiffy i=
nterval.
> > > > > > How would be the userspace consuming this?
> > > > > >
> > > > > > I'd consider exposing this as a cummulative counter in memory.s=
tat for
> > > > > > simplicity (or possibly cummulative time spent in the pressure
> > > > > > condition).
> > > > > >
> > > > > > Shakeel, how useful is this vmpressure per-cgroup tracking nowa=
days? I
> > > > > > thought it's kind of legacy.
> > > > >
> > > > >
> > > > > Yes vmpressure is legacy and we should not expose raw underlying =
number
> > > > > to the userspace. How about just 0 or 1 and use
> > > > > mem_cgroup_under_socket_pressure() underlying? In future if we ch=
ange
> > > > > the underlying implementation, the output of this interface shoul=
d be
> > > > > consistent.
> > > >
> > > > But this is available only for 1 second, and it will not be useful
> > > > except for live debugging ?
> > >
> > > 1 second is the current implementation and it can be more if the memc=
g
> > > remains in memory pressure. Regarding usefullness I think the periodi=
c
> > > stat collectors (like cadvisor or Google's internal borglet+rumbo) wo=
uld
> > > be interested in scraping this interface.
> >
> > I think the cumulative counter suggested above is better at least.
>
> It is tied to the underlying implementation. If we decide to use, for
> example, PSI in future, what should this interface show?

Sorry, I'm not yet familiar with PSI so can't say what would be
especially useful.

