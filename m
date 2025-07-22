Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B81BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FEA8E0006; Tue, 22 Jul 2025 11:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0698E0001; Tue, 22 Jul 2025 11:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F220D8E0006; Tue, 22 Jul 2025 11:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEEF48E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:02:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93B4080473
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:02:23 +0000 (UTC)
X-FDA: 83692216566.19.287D981
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf17.hostedemail.com (Postfix) with ESMTP id C4ABA40020
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:02:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rY6Tm+Th;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of edumazet@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umAjpYj5j2Nm68r3Iyqwfyn5wdRoOmNs41221wlvsuw=;
	b=qFM7gQ5ddgeU0APpLU6SWP2x5JiP0d4mMe+6wGW9nLhKnrJkjOn2WacZAvB7QjKW+b3sy1
	XDpJFCPj1LmOJKq78ZOe/esIQXAaUCABPSANcsWjXUEazCAnqnGbGwIWi0EPXCZ/NpnOZr
	aa9FL4S/bQnW7UmmDEOt9iHQt33dlG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196541; a=rsa-sha256;
	cv=none;
	b=xi/gj9gOcmSoEcpEgYE0/+ZebuooCMWq3j6yv7tn1luHsDm7gUU0mlqEoXzktMIM3W9kCy
	XuQehLpaFp0euFuf8NY4kw6sALNgp37jdj0gek+6kE2WclAfYgsaQfg2QwhdpZnRhGH966
	gHX8qBuRuLnvoAv7yFlDO1m07QxRZX4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rY6Tm+Th;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of edumazet@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so42019631cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753196541; x=1753801341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umAjpYj5j2Nm68r3Iyqwfyn5wdRoOmNs41221wlvsuw=;
        b=rY6Tm+ThcpvanpgAzwcfb19lYd9GsTWAEK1BhmLewmL8PZgNuUBhp8xL8TZtzQqHPe
         RG3rIvyaIqfHv1fqFpuSqrKDDfnju7pmf/MovUM+tgXNF2iEUC2Kk2uMDz+AZCtKo6fk
         Qm/dM/8idzNVUb2uqZHEExSpk4ER1nbOAOc16he5D8DwPIEcx9KREIh4xhaYsHR9ZZu8
         6q3fowmf3n7U08nMe14syyoUhdxZspDwowJZ68FPAmp4SNVylqNzYuI6rZRaFOoBSEGM
         VvwyToYAtC6YHYJtqfo0Li0j97BAkAn86TrZ2SjwuVuqZ3QTOdvssdT4c1gGw+KnK8qK
         m0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196541; x=1753801341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umAjpYj5j2Nm68r3Iyqwfyn5wdRoOmNs41221wlvsuw=;
        b=qkP+3hdqXmBWasyYSxVfm1WwJ8iMNo0JA7F019EvmadiejStEr99KmTd76TlKDtYPz
         lH8hXwIh1U9K1ugY0Z/Sy1MyXtwAwOZEP3o/mMIrCBip+TutP7L2WJ9V34MLYWxvaBdh
         9Akeme9j54ULSuThzS/7ioDCtzt+q8Qzz5ClfEkuoplPOZFZe2kxVV/ZpznKCEuLo1+U
         VoTYW7vYuEZ3oZdFwbD6yfiNzv0cTS+EX2M2qy55SMqEFO5VJsZpbwZ95l/e87EkeAZl
         kTx0KU0CSzr2XGGTBuEe4WS2FoVYU7dK37f+B+0BI/+latzrlkzCBf/iAKi1xwoNC151
         GR2w==
X-Forwarded-Encrypted: i=1; AJvYcCVfqyzKFBXf+QpwKW9QZ+HYwXF6kRiKYooLBf248SJocY51HfDUZB5Ya+CfSYO6K6/Ls6LNvSHHgQ==@kvack.org
X-Gm-Message-State: AOJu0YwR0C61rz7JrIFK35y8HLqc6UJDzwlkZmuJllMCjsc6WkvW4clQ
	dYqBVHGDLih0yOxHsh29AC18UJHOOSlXETLTr5MWXEGZRzzDp/F+y+sjNxqK2HXshc9gcAcPiWK
	FEMPrIGghimB8Z636ELT2qqeAfYjY4QyuLgnPUgE/
X-Gm-Gg: ASbGncsluAnFzYBWSUlAfzyo9rZZ3tJ3yNzaN09J2Sb99pirec1VkdY9DY3MRP1bxBA
	9xUXIt5MUVCKkhGFebgEg3f7G/ll54pjn/MCfM7OfLHGrVwl+LUo8N2f2fZVQF7NqK3p/CTx8EU
	nbS4smtSurhdE7XkgOqst9Z8Vo1EILX5rA3pWK8pJFRfeGVta/kNEWqGky6L787EKSYtU48kPXh
	1qaUA==
X-Google-Smtp-Source: AGHT+IHatyO88FKjpHrkC5ZRrOvMvJcUcR//80j43PsSX5i96Xgq4GOLULMpeJdluQDo1lBmfvGH9r94q7sH87FUvUI=
X-Received: by 2002:ac8:7f13:0:b0:4ab:b02e:8c24 with SMTP id
 d75a77b69052e-4abb02e8cffmr222175891cf.9.1753196540172; Tue, 22 Jul 2025
 08:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-13-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-13-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 08:02:08 -0700
X-Gm-Features: Ac12FXwnxSRbbL9Frp0VNEdNEKZjMoYAXFHNjGRRYDkATQpDHC00xX2ThpLs5IY
Message-ID: <CANn89iJk3B57ytDOEL8YpQj5K-LacKS0v1ANgLi5+cZr5gqTyQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 12/13] net-memcg: Store memcg->socket_isolated
 in sk->sk_memcg.
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
X-Stat-Signature: qwhwqbmupcwpyhdqqr71udxuixhxjax7
X-Rspamd-Queue-Id: C4ABA40020
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753196541-405893
X-HE-Meta: U2FsdGVkX1+MO7fhwTG4ubSq2DqNqymGP9TuSad43u4FxYb+p6qxBRi5bTYdY/haImkaxS5kz46g4mqtzKftBZAYVHyNlKvdemD00xI45HFAdOteHIXYQbwbcP3PsW8nDFvqj31T5ZBCgKNCuY25GNT1ztNgr+w9cGYS1pfzbKZ0FmqoUq2uDEzd5BWLY8eumrERQBf1mydVnd/h8rTA89tc7UjNMxxPUwr8LT4T6azxdoiC4wWLAw2i/gPM3abkFDuDmSSwYI3gqFqXp2vzsEBuCHh3iDX5GDyqpaf+dk9cX1bojuoEhFY0HU6R7bBySUsbagacllKbuZvkClX0CDYYQALUjo+/GaaERs9s0VN8Ns51rnvPbAVr4krcqTjcWo5vEyJB9xYphYtZWpuPaiOtZSx3TWHXTV+V5vlfaeUkHJwkjIGHs4kn2LAKrNF87ZdP7ZjfyAA8aQV+0BNR/iS8cnf6a6A+SToy9Hy/uh2mFxo0XC+55Xa81LdbhTP9v6HQP9qiQOKY0rqKZpwIWDyre6ZiwOv0X7dJWMxpTgVOT0g/nZS6McKn7OWjFkX51iX5PmGnSi6H7fTDgVUBHyXBhx7JicM2bINMnH2yH/LxIGyg7L7EjdByxrH1ao5bCC6xI4tT1/RPB8HvC2dtXmrB4HX94TVDfpXInKd23hZ3zK99NQCRXGoFGkOgZYTVfu+2X6CDCoK6Pnl7vO5pA/cb43SMgz/wHaW1GYYm9Rqq5XcaT1mcWP1tc9qMJjPwF4a41id7/6FHUuOumxCIlQkdyg7VO1pqlvJbSDItLeFe+yFxg5wWDdby68ht5hxBWRIzZFy+8OMVhYmiIr/HMvQmEwnU2EnCr/limpMczKlUDw/aBylbDgkb8v16oFRkRXFRCWdyBQ0BHn32cQ0iBWXo6i8LZmQQAfUs7CGRMnFCvBg7DkW4kw+bktg9yhlx2M4kaWUFqck=
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
> memcg->socket_isolated can change at any time, so we must
> snapshot the value for each socket to ensure consistency.
>
> Given sk->sk_memcg can be accessed in the fast path, it would
> be preferable to place the flag field in the same cache line
> as sk->sk_memcg.
>
> However, struct sock does not have such a 1-byte hole.
>
> Let's store the flag in the lowest bit of sk->sk_memcg and
> add a helper to check the bit.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

