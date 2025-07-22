Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CFFC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958F76B009B; Tue, 22 Jul 2025 11:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930CA6B009C; Tue, 22 Jul 2025 11:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846936B00A0; Tue, 22 Jul 2025 11:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 721396B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:24:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4255EC03F0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:24:38 +0000 (UTC)
X-FDA: 83692272636.09.AEF9E9A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 561E514000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:24:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YyokXEgo;
	spf=pass (imf23.hostedemail.com: domain of edumazet@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kV049ZvyH8bug7lCu3rLwoNDHgKCSKmx4BYFWbO1B34=;
	b=M1jhdf7cepoiTThpPPNrcSL6bvQNtcdgoHZDPHG4qrSi+toTx/s+wOGQcN/vmNiMHflZ9r
	rjv/gtf2j7fAQoOmCNgq4ZBELJNni7khobyAPrMBgKeEZldG6d8OLfvbikOkOtXBxky2dp
	sC/coE6JsNwzgnWMGXAYY6H13cXkBMc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YyokXEgo;
	spf=pass (imf23.hostedemail.com: domain of edumazet@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197876; a=rsa-sha256;
	cv=none;
	b=VKWtGo7YzLgRwWKiQ93y/DQgScV5y6X+HCj8pZfFXR1LRMYrWTBdRXzoMPu86MKTUTwSVp
	kQnND47RS2mbJjQf4wKnW10qF2ea5Ffcg8HGEOpde4bUBhESxmJGAL8rD3MwtGjurHWbAD
	FqkS3e3Nl74TncVYFE25tcgsmDMpG/s=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4abc0a296f5so49249461cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753197875; x=1753802675; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kV049ZvyH8bug7lCu3rLwoNDHgKCSKmx4BYFWbO1B34=;
        b=YyokXEgouRxltsSFVlJDAP9k4RgUITNHdrhCc9VuoduFzlimduPl6zw7h/ct6Pk2A7
         F2h+mwH5VCukrZ9+DpT233JK+daXnUj2llH4j8i0htnIT/Bo+b65Xw0DI0E+yrNePI8X
         LRfvP0YbKWteJXdiJMIurfGrTJ4PjvIil+B2TGPKBiAuuCQOuCzwvc16MH81tGRBzn6P
         neqziTlj8vNlUJJh8jy3phtJ5QyJzk+kBHHQ9wuMVKjCnNHkDHTwZtCX6F2G2r01TXp8
         JmCIQgyF7CMW4uVoIPzyilkxNCAz9uXKkSW9IUlNX0mGA3bVXH7pWXfm7A1pa7UW3Ccp
         VzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197875; x=1753802675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kV049ZvyH8bug7lCu3rLwoNDHgKCSKmx4BYFWbO1B34=;
        b=oIAym0RD41kBW0Psgn0ip+cmB5ndiHI4q+nxlDAruPGgj11ScIIcyNRwC/ZeBpDs4O
         dva3MY9aninVMdz0p4DR5t26XmC2c3DIVOOmNFzn6xeYvTeH2gpud9fvY+HIyUjTU/De
         yZf56hPIypVhBK9fkiz4Cx5fAeRUE6tBTfFvZFghfCEHvfNBBL6WfVzfQoRLpelWBLEi
         8yQGJ4Hw1GsOth6GTcfIgKx3HsL1VDjlCMeJX1X1DTco2ASNlp1byYiideHJar8mXGv/
         v84xJJt/bgiqePm/WqOHNE4PLoaRTB8DVdrJQD5Z7dYFpjktk+lKA11bt28kVbMP0wtL
         BTPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRdTKHQ6Amb+7inKJsogRw2HlPyBQT5on1zJpCI/Iu6I8S+aLDe2yccqGoN6CupHAbOe32e6Ihsg==@kvack.org
X-Gm-Message-State: AOJu0YwVj+PDiX3jqfkNxX7rT79iaVrOZVr0TutBfVHWvboD5rzCpini
	wZKFfk9c8k6plJRsaDjCXSqmkmc50bpuJ7tqF8f0NJFDy72XfnUsgCmG8Xct6ZDwgFKC+hvi6A+
	kAXtJILPiVFsr/hET1vr0CEZRaspnSV8yQHnte0Dw
X-Gm-Gg: ASbGncu9LgdNQqVGu1xCh3FC2u0QaEzHnM/8R5Ev9Ssv95OuCSWd5aOWC5cBU880VWm
	mCUunoY5P9myu2sSLJ1mM0TJ/w3xrrZGsA0EH+yeg2a8vFSIwvHYgr55R//MMG5haIOKkA532Oq
	akXcNvWSi71doypOEjeyfHzkxUO6ncryBSRsT3NpAAPyKVmFmT2hMYqh21wJwWa+DSllb8ycjUJ
	qvpXQ==
X-Google-Smtp-Source: AGHT+IGNqove+d9nqBnprWFval+F465BdR48MaFKPBz3i7+j2sNb0kdf1AFXSoxhiABjI4x2NGpy1yAogO5YUQ5F9ng=
X-Received: by 2002:ac8:5a0e:0:b0:4ae:6b72:2ae9 with SMTP id
 d75a77b69052e-4ae6b724070mr1666271cf.43.1753197874316; Tue, 22 Jul 2025
 08:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
In-Reply-To: <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 08:24:23 -0700
X-Gm-Features: Ac12FXwavIrX7g0teLwhtLsjBkoK2NrttJzG5Br2HWJz_qCsAQMuVk1ahKeyT1Q
Message-ID: <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tpa1x8s6b5osdwcyu4std3thx7p77qbh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 561E514000B
X-Rspam-User: 
X-HE-Tag: 1753197876-183214
X-HE-Meta: U2FsdGVkX182wCWAx4jgblHTp5AVcxDNKPSY/7pBR+p0hGFvQGnEcTYyv8hjm/Zr6CiGDvgw89rV6nz6M4Tbdg4WJCb6PbV/pNvN7gCxb9r7AKdxjsoLaGg3A+DhzAGHlFkH5ySjV08orOEidfXvRj+R1eSpeLF9irSjgxSSt7L0FR1gH5p/19cJuf3lk6FTIrWBD/NghI9ATB6g8Qsfti8Fcqx7qUrXQ4TlftXsdyd5m36prUg1rWezZIxsfUy4reSRR5cjdYAbYlsZWLx4egMlF0hUa7ylLI2LhQ+gP+D/1lt9j8Gjh0oBaCxnCA6v9SoFSCnBQND6kNTR/Bg1q+mR2e2RWKGgUVb609dQ6V02gbvP/E4rTOYiOEPfAjGxDblesdAYQFc9gVIEVS70ODHTfQe7M+VCjAK0JCTW+yBog50MW4cmtPtrckdq74C/1a8avLRVLPo5y7xMKD83C1iV0b9HFjQo9Jun9X7/BUe9Xh3FS5ITre41tcRlToeSV3T3xHPsE/AgPNYjt6YgRMN9Qvid4mb4lyE0M02uUe4ckaZrec7EOYD5L1tTtxy4PLG0arakGoXTov5A9qxXQOTzqaXoIa4dLaGJX1LdgCe5q1wnq7uB9us2McbvoijMkEwlYClXPtCE48hxNX0eJ7p9UPnKlJ+TpcvjCvZZhiwlXNkqUXDenpzp2UFG2Ee/DFKDlsfftKYNq4Tuj9gcUBgDJKoMFBhGMJlm5aZqTFqVe2L0uglZC9FOtdO9n1pRCDBTl4iMjzt3OqXa18uwMMWO7ik/SwXjH8gnC5hRCq2ME09ZgrTkgkaE8NpNf+eeAizWxmhhTKrCuU4SxVdfBaVVfo2L3couKdDddv0zBYHv4oWhPjsJ5NZ3mOZ74v4+4sIQhXBtN/5afEekqRSok0HQeuQQ/ZU1BIQaiO8N+XmDkHumHRbM5cSr0N11NIQtf9E9V3CWCbdoiUB8CAF
 ws4Ma1on
 6jXS6OatJfi/bH4j4vckzSkUCBax4H0g9ghZVAYfVM92e1+4hW5WsWUIidxjLGCvxWbydpfAcdLoPQW2DwQGWATpYAqzMHOFiES45ZUdvUh+RFfHqjjunqdcKdbKuM5sOlDBfFo+IZMcnqQB7njAI/u5WWeaUETY2bCsJpce6Dp3atHSnHTF7jTpGDpnAL9UcW1ry
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 8:14=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > buffers and charge memory to per-protocol global counters pointed to by
> > sk->sk_proto->memory_allocated.
> >
> > When running under a non-root cgroup, this memory is also charged to th=
e
> > memcg as sock in memory.stat.
> >
> > Even when memory usage is controlled by memcg, sockets using such proto=
cols
> > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> >
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits, especially in multi-tenant environments.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and a single workload
> > that opts out of memcg can consume memory up to the global limit,
> > becoming a noisy neighbour.
> >
>
> Sorry but the above is not reasonable. On a multi-tenant system no
> workload should be able to opt out of memcg accounting if isolation is
> needed. If a workload can opt out then there is no guarantee.

Deployment issue ?

In a multi-tenant system you can not suddenly force all workloads to
be TCP memcg charged. This has caused many OMG.

Also, the current situation of maintaining two limits (memcg one, plus
global tcp_memory_allocated) is very inefficient.

If we trust memcg, then why have an expensive safety belt ?

With this series, we can finally use one or the other limit. This
should have been done from day-0 really.

>
> In addition please avoid adding a per-memcg knob. Why not have system
> level setting for the decoupling. I would say start with a build time
> config setting or boot parameter then if really needed we can discuss if
> system level setting is needed which can be toggled at runtime though
> there might be challenges there.

Built time or boot parameter ? I fail to see how it can be more convenient.

