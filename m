Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A776BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D05A6B009C; Tue, 22 Jul 2025 10:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381686B00A0; Tue, 22 Jul 2025 10:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2700F6B00A3; Tue, 22 Jul 2025 10:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 124A16B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:58:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4A981122FC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:58:14 +0000 (UTC)
X-FDA: 83692206108.24.BCECCBA
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id E32B0180009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:58:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3cZB+29K;
	spf=pass (imf24.hostedemail.com: domain of edumazet@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NB1BVYhS+7MybxuCFsZv3QiZHTdAuScy85Aimnn5Du0=;
	b=eUz+zxWPI9GOzLE2O0A5sT59Ex92jUs0eXm9xZmNvaG87W1prruuulUuZGbNgwBdObCt0Z
	QsHla3UogzY+mSmQoEsZndkh7L8/VrKZa+8aMabZ5Fym0wP3Rwja5aPtJdBmUM6pDm0+DQ
	S/9KX+VXWDKq+0Ps1XE3zVSJHqKm2Ys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196292; a=rsa-sha256;
	cv=none;
	b=dKZRXy5stIDj6aFBxadFRMqQsb3H/c1TXJwiOeRXqe74eUNu6Dv28EfjbXLFqqiFKwL5D1
	TZ0vEJrDfiYPLyoZ6YSIr7q9KVjAf7urdeZpfUvImQeJOHmvPzGp6+XRZm2mJUv2kLbVzT
	OSYMfx8xUbFFm6I9kciAGLcccvPst7U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3cZB+29K;
	spf=pass (imf24.hostedemail.com: domain of edumazet@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab81d016c8so77546041cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753196292; x=1753801092; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NB1BVYhS+7MybxuCFsZv3QiZHTdAuScy85Aimnn5Du0=;
        b=3cZB+29KONkXsYpYVu/nJM8qg82xG8Ty3PNqm1TeAnpK3Aik4VWkbovbsCW8weXRgt
         OpIaUzH52mMII9ilY5DfRm6TumTThk/4EKenP4WLr1sQ1IS8HP0KPscpiTIVRgkHthCo
         taWn6vVHVXI5CgpQTYzOX1u1K5UkiqJfs4ZgdmAqA5Hu3BEbL+qzsMSvmfMIQGjP5DKM
         ucKen93iijQqLIRQy1kAqT812DUX/kxc33euqPVgh/9XVXvlIrvM6BV8HDSjD7qe5mex
         vBdwEwDefVuOC1qNzLQ2QtW4aaQOQBhFv5YzuMshFjCdk9M7bfo6QVRofnI9rvbOvNEX
         sa7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196292; x=1753801092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NB1BVYhS+7MybxuCFsZv3QiZHTdAuScy85Aimnn5Du0=;
        b=GI2NaVpTRGPox/0qNw6YAam4Jqs5sKD5ZPrWvbfwlccsWwLNmVwdnkTh4cX+QtbSGq
         ccmKw5unyfTPSFaMBMIo4+yNoT4cOewv2zl3Rok6I7gL9RXirRwm7NUaZ5AjUaVusIAd
         x0fjjaE4js+EiOv3+TlW1ZQtxMJCcMn01Qe5jlZlwd3XqG+WOfQlB7U/E1dl+FRrbVdY
         2TGFEn/4u4QuJuo8UL1Jluq6Xay5qe60ySWblnggea/RaLSz0jx1KeOUS5UjekxU4XIA
         vHrfQg5YH9qcjJRFFdZFopsvtdaZepgeSCGAmDTKPSEezhpHia3pwgom3my/g8FxDipv
         oBHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUngXOa/tqL2KZtPz8XDO7O26oVuu5FRsd391NcIdKeTTrEqJ20MrJV5F5r389GKNrQNzn5J31F2w==@kvack.org
X-Gm-Message-State: AOJu0YxmzMAMJaU67dxRdZS6A0PLD80gQD/TAMo/ZBJAOS9S3vThSxKY
	s/95SKi8vz/KJXCiInY2Q9fyZih+77Qn+BfkUagDkeFXJSz3uOHyAWGEGDuvwdssuPNx4FEvy6e
	ASyxAriluJNP7dOkh8goaBi1LHrIpz8n/fot1soNm
X-Gm-Gg: ASbGnctLaIZyOBAlNeg0spnHeFRzyU78h5UjKYWXMR0k2no9DDFkSu1GING+Jrblsrp
	5cwIrJaJwWcsdrEDZwLC8GygzZukBTr2dxnPTM55Wir3Js0pWVd2p4P8qH2o9VZ++IwNVKsbK3e
	o7bFU1fD7oHdbnxM8ykBLVZiR69jwCPdz58R1V12k9lUhe7Ar12hj6ZwGK2FjP9QUye3ZoYghYC
	gKwaQ==
X-Google-Smtp-Source: AGHT+IHbvsTmXoMJ90OlEJkh3KhkwboNSzW3FyySqD4AsNrmtWHLtCL62ueTgeIousB3XPBSsSCTtP6ho6CBB51apSk=
X-Received: by 2002:a05:622a:1999:b0:4ab:4d30:564f with SMTP id
 d75a77b69052e-4ab93df21dcmr375890231cf.47.1753196291532; Tue, 22 Jul 2025
 07:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-10-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-10-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:58:00 -0700
X-Gm-Features: Ac12FXyjA2hCizSwjNeIJfXQ3m0aOkPNJ6whPVh_v503OAB4UKe5n9M4BBBTIQU
Message-ID: <CANn89iJckRO1b6_pdgq1dY+wE_6M1SBgzenR4wtggiykv9B3FQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 09/13] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
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
X-Rspamd-Queue-Id: E32B0180009
X-Stat-Signature: 4a5i7p65go6hd1gd88d3akrnahkiqaea
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753196292-886271
X-HE-Meta: U2FsdGVkX18uKc2FZ5I3jYG3MYd092wwW0Eh8Ld/5ciH1k2Bhcl4MOQ4vJOp55Z8vQ8MgrrbF6RWPVym3HJ4xVvA7q6Ws7KRY/5eiWb6ynSGZk/gBTFTdOwWEudA9yX55mfb26ilwN+xgSL/DfiAZlWRDJ8gHn/3zFbgcz58+9LxaokcIHjr8qiUDkRg/mL4sSx00IjZRjmeIYAw90M+ZrEtRdUubWFcThFkGCJoz5zWFLXjN9tPwuO03pa+2fbiW3fPN+dHpvSkVge7YSWqdLi82n0Vnpmvh3Hku+uw4lhuzANsM4ZoodvHx8OjA02DTYZ0fFNny9EvR2oX7UhG+TSkOkmttH7/VViNfGtZnBpcr2d+TrK8zUa/7aXZAy0vWpaWIsFDx6hDliuKCeqDXlYuPTaQfQ80+lsUFlpSXwMHFrh2DyCipghjoiI62Uy5jSndrXPD1jox9fYacjWr2l0l4PK3LefCurzea35RZcEdpndPlz1dhOUnhI27Bojb3X17+HgWXMTa1QljqapKvpvsjacoCWEcN2CBnu/rLGakakcXpG0XrW5r9C1rgIGT4xhRAiLqt2RKowOic/PndPllVzWoeCSdCjgCs/9ZhG/xVSINQQE7FJVrziWjKev/2su2ZpjfBU2kdiqUxtlHVGfQGPxkH1+Y4KjAooPMmuR13Vnt1W5/AXE9zBgrMPaXPEajfb1Fx2IiD4S+72JHos/SdCpJcTQDqPPB2jeijxyZzeRkZJpUPwL8XyMKncOWj0XZiAhK9/vEPMJVN0aZb4G+zxFL5PdhPWbOExqPw35XwuHzgFGAUkkwrjZ7gEqLB5YMwWOrKpgeW0bHVaphtEwJuD9D5f+W/zAM8Tb8PDy7paPs/LFyI63uFFnpi5usGs2sTnfqNwKN4ZmtRgslxA2G7k18e+Q9BzpcOkie6v+9taARH9N4FGX8rAnCN8E6/dfGhFkunT2a3ioXRP2
 3/4yU0Nc
 xjkccZSRxHTRjWEP38PDLz6i06MQb853IPonOx5BXNZwjy9LJV96GOUZd/pWGIuxULCh2CMgB7MUvqNkA512qt4zXYOxrpV8AdwN9l0Zzfb3yUYUQvIXYDA50Z/I6wpORyg0fnwm+zduvcSPOanPiMunGsWDKAmzNTvCJEjW9JBTcvxxoBknp3frrP0YfSN+PvNiQnOxGH9Io0TukvEneyOqpCuhXlaHaY4Uqb2kLe8sTvFgGiRX6t+09+wvL5vaR0549W9vl6/d6CNQ=
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
> We will store a flag in the lowest bit of sk->sk_memcg.
>
> Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure(=
).
>
> Let's pass struct sock to it and rename the function to match other
> functions starting with mem_cgroup_sk_.
>
> Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

