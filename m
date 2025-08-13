Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B43C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558D89000C5; Wed, 13 Aug 2025 14:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509F2900088; Wed, 13 Aug 2025 14:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F309000C5; Wed, 13 Aug 2025 14:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25209900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:43:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94FFEB983D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:43:30 +0000 (UTC)
X-FDA: 83772607380.04.8F7A4CF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF9481C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:43:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DiBiiN0D;
	spf=pass (imf18.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755110608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9BzIik8ItZsQbt/3YanXJu26q0lEOJnE+a73ddJFdE=;
	b=SRYdxaNW+xDIfZLfhKBF+tGRfXfJdG1XarobLHSa6p/IxbWLO0OBYzuQgO23y20HZKG2qc
	D0X/iRVLHutT7jijJnv46v3xR44RK2sKHqeQPNoQieMi8VvSFVHkm6wUcE8DW2i4Ku1H+v
	vlsvPrZ6/30qqHvKZi/z+xnzYNAZXBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755110608; a=rsa-sha256;
	cv=none;
	b=zaHqumJtLay4IcarAJvRvjijMc0aTuZnhrziX+fH2as4v3l2abXG4u6vMAVsmSBMw4bDES
	fXCRFzxaJyKGndP8DAFJgjXiNjw0UYwxoa+IaHNd7zFfkcEgR5W8R+JOd1MA/KP7yvjnIK
	JTZPvLt5qNuOvJP9yFFoqzlLWO34t3E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DiBiiN0D;
	spf=pass (imf18.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24457f581aeso792935ad.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755110607; x=1755715407; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9BzIik8ItZsQbt/3YanXJu26q0lEOJnE+a73ddJFdE=;
        b=DiBiiN0Dv27ZOveRDyxzTMsbO1nVewTpYqWRyv531HhwZl0JgbJjYW2SgLQTuiu2hG
         ZF92aB0SD41dYEToaKvYaM86Pmc6xQdeYaUFh/82u5PGWp/cR1mxX8UMDvJwspr9SSR3
         rVaNZbhIRkhgujrvIYLBilNln6sK38UHkvjWYa5A5QMt6oLDulQO4x/RD32Ji1zDJR/s
         Zes4N9GrC8BM/ib2hYM9FhGsxTlSXDWguMtqP5JcGzGzsNg1Kq+ML6OSXPpF1BfEsCIS
         o17x5S8Y4WFUd8GycCkIG9XB6Zi+LZ8w8EHWpnMAW97QWZl/tWmp65D2QDtZakQKFQMG
         Mfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755110607; x=1755715407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9BzIik8ItZsQbt/3YanXJu26q0lEOJnE+a73ddJFdE=;
        b=GRQyUNzE43lDQYNrAwnhdrcCwmKI5p+cTYT/9dzCUieVG2nEOAME9m93FugLOj6iTe
         g2UL39R019LuQ3FauEATve1ccU5wUjjNUAcZG8qd1GZw01ucn8S5QoNeWwraS2oltF5N
         DNerqOFovYXucgUuIIOIms7paKYLbrnd+eVigzermZctwW2rhJiImAZaouvFY8DOSEX8
         LywOGr84NqMFdC/mxYxmdo0nSGVYj4VUNodiKPCtnD2kFSzUXf8EormPPgwdylmEJ5n5
         pHGS3/R1a4KEuWcDhW8f5W4I4mZERtroTFTX5H/Fw7YRii2uch8el9+IB7gy169iVFWC
         Mpfg==
X-Forwarded-Encrypted: i=1; AJvYcCUrRlilxuskll4kilUmhJgkoZPq+V8Kq/xc3cWNkv9cIXjUcil+ZltQc/S8kAsTrWSRzUsEfWzG4Q==@kvack.org
X-Gm-Message-State: AOJu0YzrBFAqe+KjlqRh3hla/9RZ7oEiexEf9vuUsHv7ZZUTTMc57MyA
	xLNtvNGdFd+y32qQJjMyED9yOmjQexQBmmv0QSkWNAvjC4forIfShJGDrl4Rnj3Mi1JU2Mw5cIs
	t4dZZ9r1UY4b9/EdhzrjTY++oD7btgdYQSr86tLeM
X-Gm-Gg: ASbGncvK0gmVV03n8NBvVEC1EPjmP0JEW8j93CkY44RhFB5K6oB1bFqrzm9958MfnRs
	UeM37fQb6BS8VBok04U3VuDT3X2aseAWtJcQr/B9P6Bqilq6ibK3brN7qRGi+8anqYziaOxegWr
	dORC1oggPECyni3jfss3pNGiZ9EIfuZw/1y59cT7j0wkWgpDbO85NAj67mBGyuzX3CfV3ytWt7K
	NPE/ef3q3VWowRh+C4fxukWVx+AGggfCeNHOdgG
X-Google-Smtp-Source: AGHT+IE+OAJLh0cA0JpKkD0/B+CsZDY5rBp0+LgetnTu3qP/aHmx8+dnnAhaX3xyY/0hlQtXLDaeU8b5ZnPRaXFlw7U=
X-Received: by 2002:a17:903:22d2:b0:240:3915:99ba with SMTP id
 d9443c01a7336-244584af6a2mr1990405ad.5.1755110607235; Wed, 13 Aug 2025
 11:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com> <20250812175848.512446-13-kuniyu@google.com>
 <20250813130009.GA114408@cmpxchg.org>
In-Reply-To: <20250813130009.GA114408@cmpxchg.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 13 Aug 2025 11:43:15 -0700
X-Gm-Features: Ac12FXzkQNJfJzM_zFO5RI8--6tu5_zAqIX6wf49jOuR7WukQGz1HzzF1Da6JMs
Message-ID: <CAAVpQUB-xnx_29Hw-_Z4EbtJKkJT1_BCfXcQM7OpCO09goF+ew@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF9481C0002
X-Stat-Signature: d4kia51sdn9uz5em8ajppbojkdawa6k1
X-Rspam-User: 
X-HE-Tag: 1755110608-711996
X-HE-Meta: U2FsdGVkX1+2AscQZTeHg8pb+zEH4e/uLTvZLGKTgum8rdvtq0oo4REfH587C3dbdlw+IURctKrOraDbvk+h3Fil6k6MHCTz0UHzBfY5bfMtc0yMliXS3kSL+3BBH/YVkp3x1kP/0RsqS2Z/72VyuQ+pB9Iccxc8KlTVNwO7HpL7+axHar9mOD2qz+pA77ZusiRK7a9+E3ktY2XQZHqr/dp9T9wdTCFmnUhddDEDQAAevj3ldUzDUM4LFrtEYcf1YK91nh1LerWmkRucCQ3dQymccs3IYsBryrZ6jyAEAViXAPwY1bjyEsB5Ktj8IKxFMlHohv5MFxoCCNiqSiJrAlfKS11GTpJMYZoZvVt/ou7ePDRXqrUnSwEnwz9/jn+HWmUR7z5DSUN0z5JiuhPRh1aN10ylmmrX5Plhc7zdwMPV0rCPIDF+lkeUFYrwhuL8jpgDKHeq7yuEIyeLo7hh7jfTWsR+GDUUwT1Ml3H666yebM4kojGMz+DGAOz5D/Xt1oExDdWa4TDosbXsVgHQy6f5Xgy2jhzn9Fkg7Byu96/Ru5g4dd46nvnb2nFZX59n7Or8G0B5/J6yf1N10SUpRm0POrgv34gaYATnjrFiVuXl2AMJnrTEoC1UajOOrQ9g4y1Ce1XttL9xFIMzgNBJa/gR91fjDQYG4C6CKNETaKPbJGRwbnP1deGVXUG8DKX7lB7ZyTO4Ur/IBMQGWh3JCaxn+XdCSxjvz+lm4gvxXVVKaR6SKXYgT5D46/nkw7ELicNjPoceh8RO/mrUmaZ3eVdmDLEHycet2zZonLTnccN6TQCfHmlCNKMWZZB/4KIRvlVwATBk0ffNBCBkoxa3QspAe8zF16MiOJHLUJAFEE4aT8y2x9+IC1EDeVZS5jAK0FZG6VhtbpgEDJaku++jj9QBXaUhJ1cvo89n4k+GyGaskYGx2oRIBTBJdeerUeZvZkz++IXoSUPVyPBdFSo
 qvMXK03e
 AjvXsJLuwM4nBndXnIO8+4HZ9J9coSxthsBC/FuNxVQn4DxCMBilHTKVpcHdxvNiLiiyzUFJY3kN35zIvMx0DkGpm2VRm24MhEqtsqVJZDu/hDN5sup8lDRVg1KIX5WeW0FzdZb7X+pY3FtCCuixpfCJ3JlNaZjaW2fz67YQbQ5Qu6PpLN6gSeOAI2LRL8Cyhaju5xpLdRGgGAy9vcH7ivGUKQYDuqfjsIFLVJ+C3BCqw2icX40YDM6SaZ0tHWE70t7tF5fyZO3l+ONryMD2W9k5pLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 6:00=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Aug 12, 2025 at 05:58:30PM +0000, Kuniyuki Iwashima wrote:
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and processes that
> > belong to the root cgroup or opt out of memcg can consume memory up to
> > the global limit, becoming a noisy neighbour.
>
> As per the last thread, this is not a supported usecase. Opting out of
> memcg coverage for individual cgroups is a self-inflicted problem and
> misconfiguration. There is *no* memory isolation *at all* on such
> containers.

I think the commit message needs to be improved, but could
you read throughout the patch again ?  I think you have the
same misunderstanding that Shakeel had and corrected here.
https://lore.kernel.org/netdev/jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zco=
ehrkpj@lwso5soc4dh3/

---8<---
Initially, I thought the series introduced multiple modes, including an
option to exclude network memory from memcg accounting. However, if I
understand correctly, that is not the case=E2=80=94the opt-out applies only=
 to
the global TCP/UDP accounting. That=E2=80=99s a relief, and I apologize for=
 the
misunderstanding.
---8<---

This patch does NOT change how memcg is applied to sockets
but changes how _another_ memory accounting in the networking
layer is applied to sockets.

Currently, memcg AND the other mem accounting are applied
to socket buffers.

With/without this patch, memcg is _always_ applied to socket
buffers.

Also, there is _no_ behavioural change for _uncontrolled
containers_ that have been subject to the two memory
accounting.  This behaviour hasn't been changed since
you added memcg support for the networking stack in
e805605c72102, and we want to _preserve_ this behaviour.

This change stop double-charging by opting out of _the
networking layer one_ because it interferes with memcg
and complicates configuration of memory.max and the
global networking limit.


> Maybe their socket buffers is the only thing that happens
> to matter to *you*, but this is in no way a generic, universal,
> upstreamable solution. Knob or auto-detection is not the issue.
>
> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

Please let me know if this nack still applies with the
explanation above.

