Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B8CC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 19:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168EE6B007B; Tue, 29 Jul 2025 15:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2496B0089; Tue, 29 Jul 2025 15:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22CC6B008A; Tue, 29 Jul 2025 15:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD5F56B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:41:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 874A6133648
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:41:16 +0000 (UTC)
X-FDA: 83718320952.13.6D87946
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 997CA20002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:41:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="fFEj/AyV";
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753818074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m37FqMDYXmj2Dv7ygO9Vcvff4CeQGMY//ilXkgwqiPk=;
	b=DJxrNDFC6yTszjqP8dSc1OdzelgN5TmzBmaC52WzJHcaIkhn6gVCwDBaPaTmPoWKLO3eih
	7JCLnkXin71CyHefFPZBfA12EGWjrp61fYgfN5a1vTjARBj/7cYLQsK1rQF/08MWQMz+86
	l8N6pkBIyrvdoQemsTKSS0ld13/QzOM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753818074; a=rsa-sha256;
	cv=none;
	b=TIir7KTaYsVMZyhHvc4nsyjDpXmT1ROt9kmTJn34TmYXO9MIVxvRXHE3wpUp+sASsRSkQ+
	Wc0+Ab53+Vf+7EUycMaNLOuXsxVWjrVx2Eyet/ec2Z8LSdjZfYGXySMCsJGUL5yETUrPU1
	gpYjk896xYmjRTE7lARdUC0kGlJnMIE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="fFEj/AyV";
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-31ee880f7d2so2707346a91.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753818073; x=1754422873; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m37FqMDYXmj2Dv7ygO9Vcvff4CeQGMY//ilXkgwqiPk=;
        b=fFEj/AyVfirVJq2ZGBtP0gUyWnJJUOUXrvZJykEiL61yH6fbXlQaT7xITp1uYKy2N5
         +8YSTpWrXFOLmy5NBUza095vFzuySjX6yQioZHfWXbSrOgr9/07xxWtI9i8xdPfS9lV7
         +R0DcpsP4Kp1CbZ8/A+Pe1C6YlZ+uceUuQGY/0PVzwUnrv7H+w93Tvgk76J942k3RPPD
         iYuvbCO/JX11e7C54oa/FiQCc385S3xC2AQMC8t5PbuO4Dyte8T0RMw/A3vOGmb6YvTg
         Kc5jOPi4L7q6D2sBxnJ5wcbU5ywI8Fpb4anTnFSmKdn3/AsEYmrPJ3GQ9XLC0VceCFSr
         8CxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753818073; x=1754422873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m37FqMDYXmj2Dv7ygO9Vcvff4CeQGMY//ilXkgwqiPk=;
        b=jG+C68SwoKHAMRdh8kOZqSwXkaLJGAbsV6+8q4EO/0VVmjMl2wobL1cYEU6xNN1UuM
         r2odhfLWyCr+j9zctzUUZA6bw64tc6jbqcGGT7OyN/8VCsoBsxLgYvnE+K2x7DDX+HRu
         VJ4DRy1FtyelNlZrM8nTgdgPbQQfxMFs2C1PNaJYebj6fZZCu/mHerv9rhQP35tejDxv
         ovoSXs+wUhQ72RRFVBBuuy9mCZBR2fs9I+ozW2mIVrRj+qAb7o0Z3lEPskPwxnWjpVXw
         8PGc70AmGoOI+MNFTaQ4FnTAG11PysOI0VhqctoDMS8oamk7/GkUd54dn3wP9WGfNpp9
         Yvkw==
X-Forwarded-Encrypted: i=1; AJvYcCXxRMoSjKNU1p2tokGynYNfegwVwBCTl/U96hqziCoNV7NuFrX58NYIVmBVfBfvG2Pb5HvsiRgAQA==@kvack.org
X-Gm-Message-State: AOJu0YwvOVzM8eUFH/PjtWtV89WH2MPDx9QqYv3VJgxKsCvJRPqCgvOF
	MS4yOh4vM5syzBcx214WFbWAIR4cW4mwNAiCDReWI8VrFtq7F8quH9X+sSYeYH8AdPSkszUrw6a
	2L4iO65O6+DtEnrwy8k+zGaJr/nOs7pH4I7YFOaPE
X-Gm-Gg: ASbGnctKExlFkd5iJujlPcLggzXc2AV6C5EONmoUtpQ1MGnDZx59gW7MhFMvQMDRjgJ
	WznBZ9QXnwYV3nBocBwSYN/wzFeyZU05xcESiu9FqeUtmgSvkhLX1cLxUXvSh6RFUgWDOcYmxYH
	wBIWOD8IDUyoZ/L/Tk3EnhkYjNF/v3ywis5wB3FB9Yqey3/yx/uXafH6meyUIH094NTwqftiNue
	VoaTG1aK7kEdBa3P8AlbzMLvFgt4lxYotY7Cw==
X-Google-Smtp-Source: AGHT+IFHi+K2rngfQJNaDXh6Q/65dPesMfdw/U4rG+5b3JOuqTwCXpXEA1k+tUMK8fVxHUmx8u+LcYENLMSlBCx6eI4=
X-Received: by 2002:a17:90b:3c8c:b0:313:db0b:75db with SMTP id
 98e67ed59e1d1-31f5de7ba65mr947421a91.33.1753818073104; Tue, 29 Jul 2025
 12:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <20250728160737.GE54289@cmpxchg.org> <CAAVpQUBYsRGkYsvf2JMTD+0t8OH41oZxmw46WTfPhEprTaS+Pw@mail.gmail.com>
 <20250729142246.GF54289@cmpxchg.org>
In-Reply-To: <20250729142246.GF54289@cmpxchg.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 29 Jul 2025 12:41:01 -0700
X-Gm-Features: Ac12FXzISgl-tZJ7iKnC87dk4hDowx1goc7Bk3yppQBdjG6RkAfnE8zuKgCifMo
Message-ID: <CAAVpQUDRccLyZyaz1iKABHNaw5rHfTBHtrOypmHheOJSaVORLQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 997CA20002
X-Stat-Signature: 7ak89rm58a1x5aab8m94wfeok5j33cit
X-Rspam-User: 
X-HE-Tag: 1753818074-555894
X-HE-Meta: U2FsdGVkX19WErFHjO9SahVQAdOlfyN/vOGK9WY7XfJx7kEBH34LxiDzBHDObpxLYkLkpUHYIYiiYsNNGL2nWwJ9V81nOt2v+id8K6iGSyqFYP3tL2n2x6TnsbxbfnBylbPe4k/f20Bv/apWRFuRvo6mKdn5rdLlvYo9qw7k1agkPFmKBNXgAVD/T2EHe02PCbBy+7wpIfp2B4c7BRGFuxqE97ngqBlsYRvGv1FPDjJVCxAA+mStEGaG3qC9O/3B1jOsDjaP7JHXSBF7W8uMeR0nedngYYub/CtrZB4SOCvP9FY/XIO50Xet7SUvfl7tSgqfChmafRXiVbzeLP61vgLbi0j1VwdBRX5zsexkhqQLkNh6nykL2m8RQVyv3ftQD1GS2Bn4O5IRTkUBbkmbJym45Z84HgfLoD/mY9GEqX8WoA+Q0VL8TwhPFINO5iML5+bfkaYhPZADFy+Dpm4PSAn5a3tkPH9B8HfD+H8NAdSDX2kKjgkuVToLWP62T/LGSEBRKX7RN0sux6JRsCdZksRDLdE3/iXPUgUfNGNtdzjIpmkbA/XK4TlpZpIRZ16paQrmEnm1IqlqkNqJVBIgEwFCvka1PnBMY/mu3q+UHMirpcYrEcVJgh3onfMkHiCUruLdnuwh98mv4Zyt4xtgthgOZOJogd1f13I9lky4u21bCCQBzlPOJl5j5D6CWeYl/RDDTrymytL/kQsuYHaN82LutaeOVW17Vl6YvxLN/ThJZndmc+rGzEkL2ZoWRL+6LLA63g3153Q3VXq+9iV0XnRHFknzAMBQcQ8jC69xsypgBp5+BNklRJqciTOPKnyvRjSi5cmmrZX4iXrdLuWWDHNEucALk4hUtAJ5eNFFp8S/qxVH1UmsHcDdtds4FI8EKsA7UD818lZgHbo/qyUnXXevgejp2HcKwNhnAVgXkeS0NlwhkXbIi7yvNg9inZYoHzSrOezjQtjULZXvn9b
 QCi+Yqc8
 1q3mILMvWm5LgPNq6/72wzz8cbYs3SDyY/vpfPE0lojRwuszyqsPaJfpdgXTQGrfaVIvany5zzD5QtXletKoSDT97760yYxmyUd8uxLY4uCRpVNc4/AOflYNYcXstk4JCcmLgjd7tvE77tNjeiXPqE2C5Wt4jDC1RFWTFrjq2gwM/+gBvrxolSIyKEd1yBbsdcizBZ6Cb3Ki/Vv8j2KBP9VU6SyO3IgpEGVmkCsKFLnIEQa4kec8LuX0z7Tb+CyUYCpZs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 7:22=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Mon, Jul 28, 2025 at 02:41:38PM -0700, Kuniyuki Iwashima wrote:
> > On Mon, Jul 28, 2025 at 9:07=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > > > Some protocols (e.g., TCP, UDP) implement memory accounting for soc=
ket
> > > > buffers and charge memory to per-protocol global counters pointed t=
o by
> > > > sk->sk_proto->memory_allocated.
> > > >
> > > > When running under a non-root cgroup, this memory is also charged t=
o the
> > > > memcg as sock in memory.stat.
> > > >
> > > > Even when memory usage is controlled by memcg, sockets using such p=
rotocols
> > > > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_me=
m).
> > > >
> > > > This makes it difficult to accurately estimate and configure approp=
riate
> > > > global limits, especially in multi-tenant environments.
> > > >
> > > > If all workloads were guaranteed to be controlled under memcg, the =
issue
> > > > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> > > >
> > > > In reality, this assumption does not always hold, and a single work=
load
> > > > that opts out of memcg can consume memory up to the global limit,
> > > > becoming a noisy neighbour.
> > >
> > > Yes, an uncontrolled cgroup can consume all of a shared resource and
> > > thereby become a noisy neighbor. Why is network memory special?
> > >
> > > I assume you have some other mechanisms for curbing things like
> > > filesystem caches, anon memory, swap etc. of such otherwise
> > > uncontrolled groups, and this just happens to be your missing piece.
> >
> > I think that's the tcp_mem[] knob, limiting tcp mem globally for
> > the "uncontrolled" cgroup.  But we can't use it because the
> > "controlled" cgroup is also limited by this knob.
>
> No, I was really asking what you do about other types of memory
> consumed by such uncontrolled cgroups.
>
> You can't have uncontrolled groups and complain about their resource
> consumption.

Only 10% of physical memory is allowed to be used globally for TCP.
How is it supposed to work if we don't enforce limits on uncontrolled
cgroups ?

