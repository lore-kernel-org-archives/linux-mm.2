Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087A7C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C39B6B009B; Tue, 22 Jul 2025 10:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DD36B00B6; Tue, 22 Jul 2025 10:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C9A6B00B7; Tue, 22 Jul 2025 10:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D77D6B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:38:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41DEE11069B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:38:17 +0000 (UTC)
X-FDA: 83692155834.30.11CBA4F
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 670064000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:38:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uR1Jhyw1;
	spf=pass (imf27.hostedemail.com: domain of edumazet@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn4gJyDMnXhPbLwCQpWenpbaZRFD72gmw0empnN1AaA=;
	b=CdSRRsaSf6XUbGaqxGPdSGYqGF+wpk6xzVdp6VWI+T6ZrJnUJC3JF5dfSabvcU4MSKtrpn
	kqHt8XzvDv+6YXJaOsLfrVcvTlPpL42cLwTwAndXAtYdVct3op84JyD29tZXo7TgHBQy9s
	mpT5r/wAOIZjXr5liY7WVwMcdUfCBaE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uR1Jhyw1;
	spf=pass (imf27.hostedemail.com: domain of edumazet@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195095; a=rsa-sha256;
	cv=none;
	b=QwfOtiL6H3GTO76omeUgiVhR8t5cFzkv3z1JdT2Ro46HPE8fRTGd+Q+N2BnNW5Msv7dnmU
	CwCdGpkR5FDSl2/iEzaZ42/ARL6iWxWaYqJdsvVrAwkT17atr3f4SLFVxeG1AnOCiu54D6
	xkouAxX7x6GTiQAgQLfSxhQJLqlmfKM=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6fabe9446a0so48128746d6.2
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195094; x=1753799894; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vn4gJyDMnXhPbLwCQpWenpbaZRFD72gmw0empnN1AaA=;
        b=uR1Jhyw1mQsc92wNgGZlbbCnTPQ5YH5qmW6BLBLcQMp4yZsgpvv93kRYvdd6JO3dkQ
         1M1bvTevGskLkUVaIt+LWsnj51X02HuTok53sue4PjO2FtJA3udSm2KERQEQ9OMrV83E
         Ams3WUOmDw5FjlBqbQu4h4XNJlvxCreYMarAk0/JD4uYA1FZ5SbAeWscFSghg2b/V5Zy
         C4cl7LpkmaSxncgbw1GKvKdLjEKOncZD15J+gxpD1nkFNV/Arvwj3V1Wjs/WCJPz+Uc3
         YCgDaqkBfg4FCuJ0RFSuxrBX5ft+uB0+lDtwFeuvbgZid22B9Kh20tzqVvCfjeGbieEI
         9edA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195094; x=1753799894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vn4gJyDMnXhPbLwCQpWenpbaZRFD72gmw0empnN1AaA=;
        b=ZUdlgUXYylGo/IM5t+P7ZycQOAihZGu/VUmyG8br/l2+evhOSqh4/0JBoZbHp9T8Li
         LY6WmS3yVRqIu3un6TRYVcW5GPBl6i6FlU41likVmsvTftsMSRgsp8XgaaWl8sOzGfTa
         8iNsXC+r8fY6DSfR43jU5r+j6duXERy4igKj//XSvXDtpfiwkQEiqrup9z/70Wa21qwY
         nUVzk/bIohVRr9GWBHsOLH2O98kcPRpBRW1ZizMNXzMC0YfKNHPG/VR9s+aIAoTW3IXx
         wgbErzIq6Ieh06Nt1MrPr1f7BnzqOl5biTVfPgruvCBRUMfkrOOHDDSwKh3bVwrYr7JU
         U+ug==
X-Forwarded-Encrypted: i=1; AJvYcCVBkbauqX//mufhE15bjGc0A/A+Sx96Jz+oLTZvmbdyEGGDbustVl+O96E1Q5S0leCfCLpzAvr+PQ==@kvack.org
X-Gm-Message-State: AOJu0YwdcRy5VOjs6+6/eEY+ex8yAnTRL8vc+9R1xCu3ncUA8EIVnNHs
	Y/j0ns+pDN6u7YeVc1avzPsNMfcOwQ1kdr9y6d4KHZY30O/V7Lz/5Zk7LTtM1hHGV3GZcMr6+IF
	58Zt5y6YGPd1tyDf7EzETvdC6NiWtLDnEO//ImnNW
X-Gm-Gg: ASbGncsXw5S/kseZkqdsjSm118RhnR5cvhTy3mZ3bJRzmnFXHNOipqCAm1Zui+0kDap
	3zdIpJnuw+38T3LD91hNeRUSV/DrLIw13z3/Uvklbr02vqiAiyueU7C5Cef43DvAE9VlB29UCxU
	lOrNP7cBuSq6KQ7HgetuAg4qkS/k1ruvvXpx6j/ZLpwRSikf4AbjRpTfqyCDzZT+TrIc0vT1zPX
	/7xSQ==
X-Google-Smtp-Source: AGHT+IH7wiXrlu0TBmC9UV2qMcDz1px3wXYN9maWZ0wBhcAItzqiY44+P1BWoDs4fyTq/fL+do1VMmfi2vruAWutpv4=
X-Received: by 2002:a05:6214:6207:b0:704:f736:7353 with SMTP id
 6a1803df08f44-704f736739emr250100436d6.25.1753195093977; Tue, 22 Jul 2025
 07:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-6-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-6-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:38:03 -0700
X-Gm-Features: Ac12FXxlsXsI3zGI0AVZPAQnuIlcT_-ASbHpDgM34ehNdBuFJw1M1IUr8BHKjK0
Message-ID: <CANn89iLBoSc+x2n0w44HQp8CKumWBkqgYQEOi-enLahFTY02wQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 05/13] net: Clean up __sk_mem_raise_allocated().
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 670064000C
X-Rspamd-Server: rspam06
X-Stat-Signature: ygifqi6r1b5hgd1hgigtj3zamforirq5
X-HE-Tag: 1753195095-934733
X-HE-Meta: U2FsdGVkX19n1OVnI0HqseorhFld8QyGi7qqgFSf+S8m//a5fm65Bi45QXKMS3ArzTM8ttOMMoXfB2IOzCt5z40vAiEPRu6T9wkyb/TcYwa86SLFt4ABjwy0JFfOnPODlX7FdGvA1Jhv35kbrc8e+NGV+k2cNdCxoHiurKU6++KGS/5QexFH/3CXk7F0DHwCYgvELe2tvS0A9dUzdbpMZOh3pMz934lz27fIp5Ksof5CWUjGHZSDbr5chTOTiHqeYF8Zs0fXrSo1ZeZs/Rfd5G2r143d4Vhm5MHcmjt9BHyD6fZ71uR9f6CRK6MOAhSXFY1vrDE2xjt2JlO27CzdFxUm5YmdwHjvjpTXCN/ncggE02+8Wzcj9IJ8kIqzBDQhq6dfk3QsEwY7YAfbSDt3KC3x6c69NdDhQ0szRH2Ws9SFA5is1TCS1Cd9nV872nA+sMiAMoFdSlSrNYAo3r5pPpg/A0umKL+i59tSsa33zLUV8d5Us0Vcq7Yv7OEMy/rNmu7ox7ocSyOROg51jaTy0Tz5neilwV6mJhs6UkaZAjyPbjJJ/rGvpjosEjFQJ9KxKMnBRmXKxHjWydcZUiQSJq6/OyTihoDgog8yBq30zuJg+9ZzE6LOPnWqmRDptun+psz2Vqph6HeyIic+edNv19CJCnRe8V9U1Q4LqdaAe0/dMHI8O0lgmNnnYwtKCz25rPu9/UrXXjCdm8zlI7L3HbGmeAVIW0Z7togO/g1rg1LTjQJww8vqm0SAeUK0dViFp5OGtIVRSm6N1PoRcE0oFavVFeVXRK3+RyBgu4V4uhdCTJi0rZcbIn5hFP80wM9nONtd8U4emk3Jj59SCk278gZfinTnw7aEw9fGTngZbV/Fu9/jv2lf45mBYLsBQj5dVME/GsW6Mi7d7qZh2ZTcUHsLU023TR3L7SrkecOC8DNzlcyIxd/7ufxARrjg3yv9jbBnlWSD9np2AWJghvh
 0e0KcTpQ
 oh5ZdzgJcF9///8pg7IN/TtxevYMDwv7MQyUCaEs0eoXzpC1OL+Nn9L1abs5C9nT/RjXaAcDydcdb4vMVPJuD4+rgVuul+etHj+0+ANNwy+T4ujs8BWKm7e27l125QS8ZmXmBGaCGEKdIvFLKfMSLoIQ9vglBU2A/raT9JhEoLyaE4XmkHdLCTCGuTyPk2gvfvaz1STrDc0s3OIu81mKuIG2c/bxCwp1lncXj89wY1tivzcviUIkxEylP0GyQ9MVNFDBNUMH8hqvQIgo=
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
> In __sk_mem_raise_allocated(), charged is initialised as true due
> to the weird condition removed in the previous patch.
>
> It makes the variable unreliable by itself, so we have to check
> another variable, memcg, in advance.
>
> Also, we will factorise the common check below for memcg later.
>
>     if (mem_cgroup_sockets_enabled && sk->sk_memcg)
>
> As a prep, let's initialise charged as false and memcg as NULL.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

