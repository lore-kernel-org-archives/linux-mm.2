Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED48C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9A68E0006; Tue, 22 Jul 2025 10:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69A78E0001; Tue, 22 Jul 2025 10:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59298E0006; Tue, 22 Jul 2025 10:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 929188E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:34:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24E668040F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:34:46 +0000 (UTC)
X-FDA: 83692146972.14.F887A7A
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A43CC0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:34:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NGiPGIoV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of edumazet@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1yUYuQxhxPejZAVd5Osy9ksEslSrueRAJCbWso5h7U=;
	b=4JtcfCZSbwPG7KqRPSgkccJZfh6C15b4zFChr2p7DTn6gUKOWGmAnzMWfhHeeUtova3uO+
	GhSKVTjK/Vgv7gJSwuFdNWrzzDBbNfACZnihLQjFWCg17SiSFTKNLGD5yBJ9DTAJFM5CBc
	91MYkFaK+NFikKfAauacb+edecTztzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194884; a=rsa-sha256;
	cv=none;
	b=I40NsjR25AmAXcHWtNtnF9Ih5LW2CFvYquaMZYd8Ttvx2u3GZ/UsfpcGfPbjNrpsfGNzX7
	fbZUS7O9o1dwax8E4c/td1t+D+tzEIzAKmtIWHryetrImup95H5hoRcVUHhSt+YCa2WpAP
	Rex1iuQUto8k+Xnae7ggRi6hGdlmxuo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NGiPGIoV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of edumazet@google.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e050bd078cso510233485a.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194883; x=1753799683; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1yUYuQxhxPejZAVd5Osy9ksEslSrueRAJCbWso5h7U=;
        b=NGiPGIoV57MIVu9ZK3sPrd18wtx+QOX5VaOTSYnZF2txaySMZq9blduGoZSrFRos0x
         yoCLejsthIg1i+dIdo+YFHB1PytXiwmGnnKtkdwhKJTQqJpGNTxaul32xcYXFoLwlgv1
         k+hzuR1SXSxgkWams2m+czadE/ZOcxLo8/ZiU39Ro8OroHsN0pLJ5ZItyxfvdrxwkNB3
         tdbNE7gPTE6tRs2a0v5ka0TQNXHkVGhpF+WkPtr1QAeznunC10t63JVYUI9n8wnySb10
         /wLBuyPCFvatv/+6lxoukE4svxRdgD6pcICmz2FmySwb9JX2ux0DLs9cGNQWHxPtUbdR
         1Ivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194883; x=1753799683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1yUYuQxhxPejZAVd5Osy9ksEslSrueRAJCbWso5h7U=;
        b=GLxR5mtwZRUeaF29czAj6R/pkXkfog6RSzL+ljI8CPdmiEgr4JEu9c+96jkLjh5Pyz
         VCPHi5I+MivxZzfWm5zHFImI51PzJbXiqw7Fj/m5sgkk8hUNGI8ICrhxFw58rTxwDsYX
         KWaZBlOmquoHwv9g+FFr/LyazCsSK5bSkSkqWvtdfLblfQK7oD2UVrn8i9a1r/s1+adN
         XBPfNEGjPVNmivlQQtqT/VZPuKKeguSfSIc/yoKxxmBjocXkJ589JRMzi7M3SrHkKhcT
         YjeT673OYeAy2CRO9JYS68lE/8LXD40ES4toXmDnwJel72XbISZGSIHHBQ02VajW08Jb
         J0BA==
X-Forwarded-Encrypted: i=1; AJvYcCV7BXbnvU4pJGBqrcKEt0+/JmV8UGPWFxMOmCd0GNFckKzbCcJDCPQ4h29oL7uaF+0dVlIINLsxSA==@kvack.org
X-Gm-Message-State: AOJu0Yye0vWfW//qU/RxKeT8jhbP31QxE5p/JGfpZvpFRk80y3LeU70J
	hjqSuM9EAlbP6JhoNbt8YboAZxbDyqxJbPoMYtzwWA3h4HsPI6OK07E3XKTYq0QIciHEBmWUG31
	ZdAdOkeW7jM06rZMmRQQ2r73//uBaWtEuI97KTIjR
X-Gm-Gg: ASbGncvbvTXQZNGas/drUWuVduoe+TL3h//RfjED8wRk9wNzA47lIepJ7j1nAR9/Il+
	Xhzch4kcR7DO8PEop0W8kj0bsOFRi8DzUd2Mltk2JZoEaWmyKNdsTK021rCIqh7ZmUAZpMCFfVt
	OIwbj7Gzp29ITgnfJTlgjzyBMv8FrerXkhjJChxtsou14KOPUTd2p0NUkiUS6LuzBdk6KovRij1
	pCQvQ==
X-Google-Smtp-Source: AGHT+IFiji1w7r7AjCXlHaxfMjOrdW8jkVVGDDlvc9QhWhAg0vDKfADaHSk4qJ9skd7E3tmPFXgzgJZBnGJrSQTiafg=
X-Received: by 2002:a05:620a:28c4:b0:7e3:3ba7:f072 with SMTP id
 af79cd13be357-7e34356b85bmr3408946185a.13.1753194882975; Tue, 22 Jul 2025
 07:34:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-4-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-4-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:34:32 -0700
X-Gm-Features: Ac12FXzGLru6M1-g50J2KyQVjtZB32-ZEYTqBFpNaueaVx_KJKwNZF50EJpN3Ps
Message-ID: <CANn89iJkNYHLGqXCTFgG2rEp3S05VVkWi9=2HedGqqfw6YF+uQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 03/13] tcp: Simplify error path in inet_csk_accept().
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
X-Stat-Signature: cs3torh8cz4yjycxou1uacpq9nnzncok
X-Rspamd-Queue-Id: 4A43CC0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753194884-984890
X-HE-Meta: U2FsdGVkX19ygsW1j6Ghwo9Sk81b8MdwbFKYUiAniPdRarNDE2zYDRmblZh7fZ6VaHy047WbJqY05H0ws/PjLarRIz0go525BtdjFGUbPC8gbz6E5WFZzC5DGJPjpeCAxqgy8vKgkDJyikmOPk18oC/8rqQH8bq47ty6Bqd7Ma0snVj/SeBuYsvR8QCYOLwBdM53L4qRoojW6pADNcoIb8kvVUXpaSFrCJsu7AJsF/0Hz9tglJrXRQgsNQ0UTziQOFxA0atCOcujgh4egVR8+LUTwIcMmjH7xcnji+3/nLuE0R/limK6H9sEjCZlzzV+zTcnJS4AZauxQPSM9EL3ffSeWIX2HorTFZZNEsKaNWa9sSouwP9/6hhIcF+uPgyhg8Szg1tbC7s++DbTMYNFHZUXKtrFvzsodTjoZsL5Wd/WeKzCwyeHNfmc2nOFJMwyX1g5NYSKkRfLpJweHEAXb9fnTeAdtpymWd5TRS3LVDIr8lS0uZJKlUi21J7Vbn0YC9HOhTR9kpRAuS40z0B9pTIQMjhbpVgO4gQEuBybCkNEIEtsrDMC4cIm8fhFx3Xo6/Wqf4ZqmQ19cfvEiBmrxk1aMtj+Y92jIHMdnegBB0keVZakclbD3zIaScdrlnQIko3cW4OoA03Gbhk9+PnroLo/wmARnfHlmV7TnIe2pTGFQdOVxafrJ4dxn9jxmDJqJpZTA+uwtzv5TC+mbXUCLMgfrvL/Cs+5nmxLuFshi6fYw0ZyCDiu4u8jnuIY1rz4210jIkPIGJecRElSO53pzk3c45fCD+ud2B9NBoXs9JvcNZxbpYY0xSxPG5vTlrE52Jgy8M/s73WFvH+vdZnT8HMl5UCAqyOQTcMz+k4WT1sNKMtBRbsXu0zzmzHU0kzSOjKHWojlfSQSpSp/ge5iJfDiMg40hcCWMFB1S5lxmzj2jBQmZJdS10K7Jp6K01HgmwM4z13AThM23vJZLN6
 eyaUWaB5
 NJvBmsW7YS4QhZf5nb+wJz5DgIgVsT82AFTkb8NTSXfrpMR5EFBtIVT4XX3ThNNSfWz2tWFmr1reGXJ1rnGms8lIDXxev0vz/bMd+CCKyibwkfEfhbGvIR0xcHzSybuFYnRY8dqZnncurgrhN7BbSC1oIYNFzm4OXqHgyHsf3EU/5VP91XgZgYzxtKQtpzZSMhjU3/TOfET2M+KtSxURR1XI9Y+huuuFUmOVyqPEfUSI8KPzAobSGEdrB2VRCokjd9OzMRe6x3B45u+k=
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
> When an error occurs in inet_csk_accept(), what we should do is
> only call release_sock() and set the errno to arg->err.
>
> But the path jumps to another label, which introduces unnecessary
> initialisation and tests for newsk.
>
> Let's simplify the error path and remove the redundant NULL
> checks for newsk.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

