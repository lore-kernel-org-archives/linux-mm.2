Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D297C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28CE16B00AF; Tue, 22 Jul 2025 11:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263A86B00B0; Tue, 22 Jul 2025 11:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1466B00B1; Tue, 22 Jul 2025 11:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF2A6B00AF
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:34:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCC2BB9895
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:34:16 +0000 (UTC)
X-FDA: 83692296912.24.A6497DC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id F3F1E16000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:34:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hIzETRvM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of edumazet@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753198455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6huNDu8PBiF4Td2REk21Di2p4ZXL2OnE0DDZsCTZnFE=;
	b=DThCEOH8mSvXpQLBe1opoTwkDtOKJxBuV7lBJlNlq+0c0hj2GC6fU642Ty4+MRCst3VyZw
	lQZPI+Wbk0dpdVuicMACY9jgEZNm+Tp9vK3wOY8a/EHEN12Jg6TeHxOgETGE1bnfUZPgo4
	qTT00Qw9VIf0M9oswqlsocFA3HrAkeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753198455; a=rsa-sha256;
	cv=none;
	b=P6w99hXXkfIIBIGImesTt3z0xvWwHCe8M8K18Y3nAa6wg/u2GIpQ4s9rNAMV7epEHxppWo
	WjaErTi0N0853L6jeZHprn/bMAgMmKKYHH+8u+h7sctaV9ybfguuvtUO1MfPXNnt0js4tg
	naIjlk4dkAn54Wi4mnpIyHufn+Tbd/s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hIzETRvM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of edumazet@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab554fd8fbso53135871cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753198454; x=1753803254; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6huNDu8PBiF4Td2REk21Di2p4ZXL2OnE0DDZsCTZnFE=;
        b=hIzETRvMjEniDghZgU9zslf/t8wJu3t1EkJpegMZfF3Zb92w6clykUen+/VL8KDyRu
         LBUIdz2WP5X+JDUOR+HFY8WRbDtifZytlsv+nTku1m9U7jiYRI2VGrrOabVZKojeGMr2
         5dIhb1CkRPaml4co4UqoY84XRkGUF31loAz8+rc0efDhn+9DqRYmk4VBFjLPt+YkwLKh
         hoeT6hjMdsPSnGj19cuH3CLFm0qk/QCJNK9oVXSo5kYbLIt1p9+gl2S+NakTCYNNcyEZ
         ieXggtPkD8oTpLT/bVOzB3XjZ8PnA+ckCKnf4MqnurCBfxOg5TghbVaSpMOdGxWc2zqD
         SoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753198454; x=1753803254;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6huNDu8PBiF4Td2REk21Di2p4ZXL2OnE0DDZsCTZnFE=;
        b=kenkq0NPeS+6b7qpIg+vmBnFcTuVzu/aStjQruxY5mrEvOfXXF8wZDCdZ+w8ZTdc4x
         XzOhzCq2SDtO2M+qzp2B3pHfuWWWYbM/+7jQs4Ve/UltPdWKkJDdxADvwTChNZddYz8l
         P+92jd0R+04lsGtpzSk5MJZ/1v2npurmhMXen2GZ22FZvoJOcB31tTy8nvBeSkx3MImZ
         vetel1BjbCan4aR04pM3AWykRI2jNvGji76bwTyXIbMvzmWi9VrabOgfklsR+bUTPfma
         ASJZ9QhOARniGCCnfBmRmdIlflpm2IvO5YuGnS6XzRd4hIOl5Wu8TizgpnmaT/vvOMxn
         D4Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXEJUEPcMqXCTzKLTfLhXhHI1b4Fp3jx0E+c7iJkZ/5n0qwTgpi90HonINaezQ7WnDaddiJzW07rA==@kvack.org
X-Gm-Message-State: AOJu0YwXiLrFs5KiJpt1i0hWuPnoZKCJRnFRS4ZYM//6cUKPDdYJ3OqU
	9huqOPdLNvlla2RTpV70WBd07BH7MtrW+q8uv8nhGW2+Vh5Bnjofh3RUXl5MNv3F5uhOXndes6d
	f6sGjN10ycR1axr3IjuziDcpSO8BaXC6ZBPw9p91G
X-Gm-Gg: ASbGncusq1v8y2LVsAtmIU7ne7Wmw9SPzDQM6ts6KqI0VOgPv/lW3Sug0tGjIUCAHro
	03Tw8IPDIU4sbQXtdMgE+KrG18CpSmow9xLOKQ3+esYd+2YdEtaazpfE0dtXSpBlMkuXO8ubTNn
	QV2S7IB8MoBpfZl4beIMQhzyLKYa4vu4rxUXnN1pgWU99aPCx4KpyyFuQQ34rgmKFfPdoldlcfB
	1RLiw==
X-Google-Smtp-Source: AGHT+IHT/XoMTVLR/CLnQtYrPx5F5saubWGu+acQeXgnXHryN0gYdGmeEzUDX46mVUnYlwqL4F5dGGyi/ToV0NINlD4=
X-Received: by 2002:a05:622a:549a:b0:4ab:c0d5:6f63 with SMTP id
 d75a77b69052e-4ae5b68cda6mr48360891cf.4.1753198453672; Tue, 22 Jul 2025
 08:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <vokpyz3p5pbv7ja4ltipxapq4xjemqmv26gayezeekcyq7llyq@6kahz7tldhfz>
In-Reply-To: <vokpyz3p5pbv7ja4ltipxapq4xjemqmv26gayezeekcyq7llyq@6kahz7tldhfz>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 08:34:02 -0700
X-Gm-Features: Ac12FXzA4jvGkBqd2_ryawomXPZvKp3tJLaT4sW3pMPuwr_h2pU1RQnRsS7pTbc
Message-ID: <CANn89iK0zqP0OYa4S=5-X4seUG6wAsK+-qGEpbpXQgSzNJQaog@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/13] net-memcg: Allow decoupling memcg from sk->sk_prot->memory_allocated.
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
X-Rspamd-Queue-Id: F3F1E16000F
X-Stat-Signature: 7ffixbyeeekghdrhgapg6fycqk6ioxog
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753198454-87357
X-HE-Meta: U2FsdGVkX1/2p9YubFgPFvO280O9vVACRr8KjvBaic6grlIflrErqOir7iHGSUZY1Wz45Os9Snb+CFB0OUxC5cw9sCOAoHkg/aFzTJQv0BKwWqjXSzJx5eIrty85eYp82CGrFIbWsLGvvSMBATYbrnyPtEwnuxK4PXmag4AJC/COzPxq3xqbpVlQ7AD6NoDztt+fLp3Mfyb3DhRK9Kf3YlnFY2dZQmeTWbnXSDM9pfmDQdpak3fFX/nINnSXg/7qLIfz4TbA2S/mvKit9OtyGk/f1TGKvOsgUYSYVb9ufV5qj4kDMyJRpaKtBjSTgHN08i36rY/tSdlsWWb5OK34htgVLTLjgqyR3X7QOBOUDcVOR0RjfSm3hU2z3FGNjgqtB7ezzrmDZ9uLf7XfjWWmsjvVMcietfWMBwbY6qzUHZo82k9tO1sRabG9J0kkAP3Q+so5rY6wINBsI0gTx2K8ZHpLMeYlJq+xVFkWr8Q6PP7uLgZLuWhjla8aDQZhWI4cPiMHOK1UenQxAzzt9Np7mS69F+Jwot2+1rLHiOdskUsMPSbOSmuYR1vT5PUUHTlMCces9tHu+S4UzNcnxeWHRTeq4pFEMGqSTG4eHKbCsjX5VaCEbp/GmprI0P/MWSURzbhvYHxZZDwuBH94/RkfF6h8gpUE7xT20CXDY+Y8sOrPBQmRSJJzUI79v2x6ddJkczSEsX2J+JPCoEXBkF2xqMVaLXPB+Quy1ePsJ80qsUN2tXgM4HyZ+Njtf5FBJiTy8E8KgSGWclDDSbsYu9c+nBrEZhyBvulea8L64SvH1feEXzt8LxiemSbkp4CwYOrmtdvY1jeMq5wCqQkzNcVWERK0qSJLN7UCg9CVsgGUgBA4sdQA/3CgkLA2d/f/7nPs+OZ15XQw+pwxsP4ToPEfRYXybHJYLgq8adxcpEvjUub8u8UpxjF2HmnSN2n4F4/NFM9Y/SV5rtd6/I8YGQT
 v8E4lnSe
 0E6VlO81kBaekRFHK0E0l2lHnwwzqfBkzFwxIWY8o+Bchnw+b+XO3Ab5dBX5ReIZP5ylidDzsN0foWebIrQzTtwpNxspmA4HJ5rc5IxxIWiN3gcTwQHrFLwoKBMSHDsWcK/R/+gV4ZqNtzjafcxH0HPq97Fmwo1IuQFR2oWc1ZXjJ9RAr3oU4ZDqXaaaZ7GQRHC+/M7F5Yjf/F0Gi8oeh1ShowvGANUs2TrK5+pmTpzs5YgPjXA49GwlXAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 8:04=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Jul 21, 2025 at 08:35:19PM +0000, Kuniyuki Iwashima wrote:
> > Some protocols (e.g., TCP, UDP) has their own memory accounting for
> > socket buffers and charge memory to global per-protocol counters such
> > as /proc/net/ipv4/tcp_mem.
> >
> > When running under a non-root cgroup, this memory is also charged to
> > the memcg as sock in memory.stat.
> >
> > Sockets using such protocols are still subject to the global limits,
> > thus affected by a noisy neighbour outside cgroup.
> >
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > can be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > However, this assumption does not always hold, and a single workload th=
at
> > opts out of memcg can consume memory up to the global limit, which is
> > problematic.
> >
> > This series introduces a new per-memcg know to allow decoupling memcg
> > from the global memory accounting, which simplifies the memcg
> > configuration while keeping the global limits within a reasonable range=
.
>
> Sorry, the above para is confusing. What is per-memcg know? Or maybe it
> is knob. Also please go a bit in more detail how decoupling helps the
> global limits within a reasonable range?

The intent is to no longer have to increase tcp_mem[0..2] just to
allow a big job to use 90 % of physical memory all for TCP sockets and
buffers.

Leave the linux default values. They have been considered reasonable
for decades.

They will only be used by applications not using memcg to limit TCP
memory usage.

