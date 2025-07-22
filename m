Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E117C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ADCC6B00B3; Tue, 22 Jul 2025 10:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184016B00B4; Tue, 22 Jul 2025 10:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1276B00B5; Tue, 22 Jul 2025 10:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F080B6B00B3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:37:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6C4E11262B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:37:28 +0000 (UTC)
X-FDA: 83692153776.12.D8A5360
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7699180013
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:37:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i24UUF1N;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogGcW5syfHAy99iS0KaNWz31X1S4P+kdHYMMRHVaghw=;
	b=Uih2q0KdvlqIpHebFVbuh53iFR6gEx3Fh0qdPXmjkXNto5DgURaqN+ivThkdABOT9pgEIz
	PdYVyDji9VxTyaB+7CS27dyPS79HlHWJ+KHR/JVD6eIPDYMOcYIpwlqz2Rnea6CQlBZ0Rh
	qAfMVuhuGMZrQVhtb4ugNm9Em1dsdZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195046; a=rsa-sha256;
	cv=none;
	b=WiZTjJhfSrGCe8UW+wbkSdG5QNTYuSWBzeE7elg/cHPzkrC8q5Ej9u6B4jwvylioK1xGi4
	o255CiHn3tGL8cKqxwO+hZNN3AjFEdBHTm7ENqItVxA3mDbeJhC/vzkrxNf9u06RiKzQBh
	WW/Ctl4syGm3kQyOk6aJBvO8SO3e7dU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=i24UUF1N;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ab81d016c8so77171931cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195046; x=1753799846; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogGcW5syfHAy99iS0KaNWz31X1S4P+kdHYMMRHVaghw=;
        b=i24UUF1NN753/M/1jYNRVW/VA58tT0zkv2oHhMUeKHefEalAdUU/9dGE0W52qqn2Kx
         9ruTlNh5KH/Wd//8Ns4UlLU8C+IbdCiRd1PoEoFZvXcBEhTrpdpp23aHvnyz8SylEpoA
         O4QD6z6tDL9mEda7v3Q5XAtM/NsBViLjc4GA7/sZt8iYjj2fVRehUa8ZDGKdYzsYhuc+
         /hnPXe1IceKfwGEvBmqZW8LmcPvlswlW5AFbjMVogVHN5hxWelRfjJvmdSoxq2qtamgf
         MMDf7WKXUJGcx4sOwP46geHqDnO/pQjs4fZhM/tBHfsLSMBixKNvSKYMds4XGiLuzf7x
         TKsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195046; x=1753799846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogGcW5syfHAy99iS0KaNWz31X1S4P+kdHYMMRHVaghw=;
        b=CUGmP+1dSYT9bWDTL1e6FlHSck2Gg+Pdw0MMUolAwbmUBPiW9EQAnid7ihe/dvflem
         w+i0d4DaJ9dA22OV6VrvwEDGhywraWmmH8s+t3+R1RdE9Of2szhY+04boQ4Otwn+hXCB
         DNxSOZhUjO+gbcVpm8o8UKDoW8KZQ6HtjO053VpyHPpuU9fhEBfMyXOL8ilEQC8j+6K/
         y2OW6qgTDFLJhBShuhIkenSvJ9pYaO95IWpz43PQ8upHiZmUGg6Dr4GdX6HvwxB2mkm3
         HcEf11gdrp+fnMAW86m8X3QL8r01y1QNv4dCOyWr+FVkj1vODQfbzdx700C6IAPWoa4T
         QMrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXM4ExfD+paUkJJqVP7WGd/tSbOpmfYRY+lWnsSc8NByCl6eISO9XOVNlTlS0yPZqEl2Aaf1XGilg==@kvack.org
X-Gm-Message-State: AOJu0YzwcZWrWzrEiHMfQDUSVokqA8mAKnsSGLI65+1Zk8et/IlojTJe
	AGcyCLPd1m892OfOwlyprgGTnS9G8MlVVwgZeVKvhRWpMdafOfFzqZ6jQ6iGR2O3eUd0N9G4Njy
	0tm31GDIlEZawdLDH34+1V8EewpNV64khHgkVUqiZ
X-Gm-Gg: ASbGncsU/HoWZDyNVkAbeUV8xeNfoZf2BRzYUoDNhz0f0b8AwAoE149DY3BG7gMqZoo
	oBTpcVPly22lhzCCnYGO+IS002bIWrSrl+bjaWzEXFP4mFiQlXwleFmU3neCSejrCu06UhXd2fk
	UPOe+9/m6AtRM5u9UYAnvxEVlZjJRwynLamGRriNsbOeFGEKwPLtUdhYt6JrAN2vgkrW9RX6KQA
	Z4j3Q==
X-Google-Smtp-Source: AGHT+IHh/lY3G2VVyGGsILbI95GYxwwe31jY4DMEtEPuVbiqIy2WoiqiCRLo4vbR/BymSRXtvDDARRkbJMlep7SRIZY=
X-Received: by 2002:a05:622a:5815:b0:4a7:6ddf:f7d6 with SMTP id
 d75a77b69052e-4ab93c7d56amr387332941cf.10.1753195045666; Tue, 22 Jul 2025
 07:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-5-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-5-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:37:14 -0700
X-Gm-Features: Ac12FXw_PVmGWG71LBM_RvH4ODSBv72aWxnT33PfI7UhVcDC69sZUBCPONqRMjA
Message-ID: <CANn89i+p45mE7MTEmf+_fYA_fKXnzMRXiDXNDdkrHVimcYMFRA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 04/13] net: Call trace_sock_exceed_buf_limit()
 for memcg failure with SK_MEM_RECV.
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7699180013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: xpnb7rc8pj8zz1ddz7sbi64wfcb5nmzy
X-HE-Tag: 1753195046-76526
X-HE-Meta: U2FsdGVkX18AXBoR3hiTHpY1SNiQFmrNcYUOkedcyxV73S5Kx+rxdPOqIq/c1ofMfuUNlMMLffwKj/F8PJtkwoEvM96ZUN2dQNKyvcBnxwABc3qDKvUvdmkL1nNMIJnncsMdsp3T+AmQbHptR3T8JoUmkRWzLZ4TXceojRG86TfIQ1PBaLJQKy2D+SnRdWh956AqvXUcDClkAhsEChs523FQ96GZlTBJGlGi5rtm/ZzFrhiqzwdbA2LT1dgz/KpVXH+S3GjlArgO4ZqXqv/3tpxGv9+cu9084wF4MNd/qjeFwg/cH2u7/5VQa9bHeLBuEOFbttqEqCJ9GAFL6NCXfG+1fgUMwghM7JtUbIHzIijTa0TmvaKDFEw5BbXMiNreCzsbAQlO5XhQ1VRDAVadgr6zYPDLfDlqElKyG/N3zhytfEEoxFJdu7WRZKmU+5DHgSD/o1L0h1AGIbdWZF7ye9oRx2lOBVg49QJ0wH4x1N3sPJQuoA2FmKjGWDfT4cnpgb8c0H6Jxn9fmSF/F9vUWDTet4on1hwtLPfJJ9vIYrpz9r1EDmBQ42gTPAK+tHpLQHfa2mY9PzapFPcq3Q3LJ8V2ScQA3z1gQK+ijSL2IXp2wlEgNLZ1Rg0b/ldt8aGutXwdSWAfnXPxirDZOTiWP9n5Hh9I4HNlPh+3GSiFy6rNxRQAWMVhDr/Bz15qSzhOdgCyi8dh5Mgqp0uu6p95VBVEuUYna/CSMDXogwunTVqAQVQ9tw1RxWAAQ+5xOP1w66LSU+V+uKydS0Ll79Tr8TlfMBCVAoU6q/7ysSeEIpK862pf9aE5gYzVLoMshY4SDWQEEzvIpctksQYzCCUwE8WMBtfqBQOF0NheSlBPS/9p5wvSfuOb7Ghlx7p6b2KVL9BYx5x5NWda+37vkEiNUAfOQxtcaFyZAx9CSCinejNhOWNCWRXYqPhixkdusDNnlwEfw4byPqnRIQAhD8J
 AbjfxPW4
 DBDl/tbkdhGXB2teBt1otuoIh9NgrvfBJNqzcamTzIiXs3Il0u8buPlFGK3Ptv5mvahGOMREIbB+b0T7byyj2UHVyJVNfaX13afKoH7LDD+wT7dV27HUNiOqkqvVvfh709aKteen4LbCDQLjLpbeFe65iVX4wJ1S6srIV0q60lC5H4+/aPVGN0wYlOpqAltADywz1db3ZhHy40NnSsnXsr5/EXgUNJX/+pRsGMikF4hq7VO2p1vhgrrQcE57d0pJfUDIZZOj/TKKLCYU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 1:36=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> Initially, trace_sock_exceed_buf_limit() was invoked when
> __sk_mem_raise_allocated() failed due to the memcg limit or the
> global limit.
>
> However, commit d6f19938eb031 ("net: expose sk wmem in
> sock_exceed_buf_limit tracepoint") somehow suppressed the event
> only when memcg failed to charge for SK_MEM_RECV, although the
> memcg failure for SK_MEM_SEND still triggers the event.
>
> Let's restore the event for SK_MEM_RECV.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

