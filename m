Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A80C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4433C8E0006; Tue, 22 Jul 2025 10:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AD88E0001; Tue, 22 Jul 2025 10:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357DE8E0006; Tue, 22 Jul 2025 10:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 270558E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:57:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE6CF1603E1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:57:10 +0000 (UTC)
X-FDA: 83692203420.28.39D68EC
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id F326D40017
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:57:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FkhoxPKQ;
	spf=pass (imf04.hostedemail.com: domain of edumazet@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196229; a=rsa-sha256;
	cv=none;
	b=jOsJlIDn1gZqqgE9wu/hPUpx0vZfXBfAv7Bw9ZVLh8bNJzK+wa4tVWuE2Muk+HOhx7CHcc
	HSktZ8arNRGwwMnziVMQr6OOoQ77SzKH4vOFbky1HOd+0YsIQB3GFAgaL2yN4wOG8C/gkE
	H5cTLZCfoazyUFwsutgPxQ+nr6wTIBA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FkhoxPKQ;
	spf=pass (imf04.hostedemail.com: domain of edumazet@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0AktCLJK+ZUuWGfQ+iSpRiQx815PM7rgLaWcjzgcEA=;
	b=womB/raj8zCayydR+nc1OhM8FiUXad8eNwWVoZE07IWm3oZwL166OZ8/9mxWyGU8sHshKb
	N3uoLBrlzRuDvWi3yI0F/cbmKAAwMLbf8MmHZq2QCV3sK8iJoFp2KhhO8nPHr+qImKWO1b
	T/1QHRVgqXjPy6MLgKd5Gc7LduFcGnk=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4a9bff7fc6dso52722441cf.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753196228; x=1753801028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0AktCLJK+ZUuWGfQ+iSpRiQx815PM7rgLaWcjzgcEA=;
        b=FkhoxPKQiTQDGWESf0IbtLRzU2zw1wjqdhE9xFgSj67kJQt0V1yev25OajnH9kLyeC
         F7/PrHsZ8WxK96iqjeNhCMieX8q1ORCCw1Ei6JC1oxJ9Kq71OxfNC4m8oG0wsDxgxGJY
         S0lC1FBIkqrDcqIp1sCD2YjGpJLaywt6T4co2RnsRH+j1Nzm/Jo5Fl4shFiGX+Hfvhdk
         MfAxQEMpSPMqgog1V/szELGf8bBg6HVIqKYcXpMpZ9lVWRxZ3rZ9mRDcnEM2rHkbMRhb
         FEx1X7kbYhI+1L9uemrFvwVCkH9+USDS6sMSzKDlFLT/MnCNZRbFBSTWh44YMAi0o4cJ
         xUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753196228; x=1753801028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0AktCLJK+ZUuWGfQ+iSpRiQx815PM7rgLaWcjzgcEA=;
        b=ZXDewig9FaEwkgs58xXTZEb90bJcoDDLEFubVpufOeAl/ryYm3OVMGTjnvXpaXDATs
         q7BrAWD8BaEu+ULB7hnDZkkf9/Z1ZPO2sOiQOPm1icB90lCniXH8zyqILdNj59dsIIRi
         7hBTHFqE/wSTzUEfLTmHE4vA6aO98kGkiMnaIDZfFeH51aoJAAbVgo+5X+R7v0VOKRBU
         0suuUUjaMBogBitp5cM16qLsuy5HM5J+rrTAn688cPcf1QELUbF9LSHaNBmYlNLLAbm2
         fmBZthi3Sxmza7uYbCyLVyJtlsdEZg78gH3cva43CoTGNnDaPtcunB2aIZN/LNH1kufy
         14ZA==
X-Forwarded-Encrypted: i=1; AJvYcCXff8NnoxmUocW9OeFo95nmaAJrZEdMNlVkbLtw5H+YtNEcrXkuqJP4kYcFQEbYBDK7cUjcgqqqPw==@kvack.org
X-Gm-Message-State: AOJu0YygGer4kJapxsOopYfigtlJIkcrzu0MbxZOufDaDqnLTInzVBAy
	YZP0H1QdUBFHWUFG1sSQOFhhHmE9VDhyo33kZBbtP5zabRJAXJP9B1x8cceuVQG0VSkVZGkfQv8
	VmhGSLJb5WeCR439FvMvMkeV5qrttidFe8lrpyf7j
X-Gm-Gg: ASbGnct9mcAbLiTiHnAjrn/zdENL5ZpBTEKXqVNL+fg0YR3BBKN7QBcQ/zo8AsOsJJ0
	e2qji2i0RrUBaxoJLq5oAV1G840Ma8zlBcDYP0QNtDxqhi1luxr2HlTa9dEw1FmVLEMrmaj3nSu
	EisdE0ykiSqPuKrgAT2tn6PZnxQ2x8VIftTJuwHeyE0AQrrK/E2k5vmc4Pfr0wmZEk5FFwmSSLg
	lBvLA==
X-Google-Smtp-Source: AGHT+IEsEV3GGTDTdmiKaik3AqH1VA1TZx7fA6+/n168ze76wf/ZMKc7syZqUWj6LZzqN2/qXmVi5AZltoQwXWaeFfU=
X-Received: by 2002:a05:622a:5514:b0:4ab:6e3d:49b4 with SMTP id
 d75a77b69052e-4ae5b776852mr47163651cf.7.1753196227557; Tue, 22 Jul 2025
 07:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-9-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-9-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:56:56 -0700
X-Gm-Features: Ac12FXzomuVijK6Zq5KT2dKkSJnghXUcZpgHafRcifrYJKvhd0CQdjVZBQvvh-E
Message-ID: <CANn89iKC-RJg8Xi1o6Ks4iCgrrwhvYFxDGwtXN0q0KM6HqAs6w@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 08/13] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F326D40017
X-Stat-Signature: 1rqhzdgfte1mqux55tddb6s5pmngw976
X-HE-Tag: 1753196228-596038
X-HE-Meta: U2FsdGVkX194wiL3HNh6HAydzEd4qoDWf55zkWzhMlBXcwS0oU7usYEfC+ezNx4Po5cczBcH0YL445ojZeyWqynMHcrbYHS5b9/zofeXQipm1MqqprUhUXCpLDJBkp/J2zVPbZS095b/cwXDGNB0cO2hEsRqIsYDbN+BNoC+ZypCFxEqqBVyPkdWntUz7HBJYB99ClEtmiae1/3ZC0fljnyrN8HQspqsH7REG+sznYEI2aqsIGiAItGRw2nUbjfw5gA2lRr8JiVA+C3de5ubAobVy92TCKZN46SCK5voHUbGMkSH2h8sh3Y65hc2w6Z9LlET+BeXPqiwtvJBPStkwdt3tOQ+LYJoHSzNUUCJoZ603ZYm1DaOwfviuYJYRZSY1meZTqYBkpjKKACM8JfQYXDAlTNzkZjO7R7klLCFlFyrRsQn2mE86Q6ZFjwhw9zEjPla88S/YWsfC2ZQStyboWkY1chhcZoqRxXWNPVp98MbSlV2iRTKXR9qXRtpifM9CfQO8gS9pBCQ+H+Fv0c9IRXw2f3fPWdMUG1JSnBD+T7te/9qRbJ3m1bNMZZuLjgLTcKriO0qCd6lc25fiqvDvRQhlOOLT85uw7+00ZWQVE18eGCEA2pWmij8Su3ZqmZQMQSwb+VVgA2V0XeSyX/ozeT9IprfZOphpCDa495+QXEC9O47rrMHuzecIZL8pAKb4dTYNcajs6YzGiKWBiyiE8rIf6J5zak52kUGSnwe4V00gLgWe0wYm4Uo42fNduAc57TXR8qrJTH0RLV/EQzN3hdpf1ILMPHChNiZJDaEF/2QcqNidpb0kMFy+lhSMfiFG+fkIHslM3OI6t5NGX49Xj1wNfN/FqyTO2yrFgVcqJy/Imlif2/Q3sYra3xb1VWLZp8r7PvVHsvNfPcK78OJrLgGEm4piJ/WXpfM84hPByRFFTtaXtR1yh2/dLDyBP6g/gWhbUD604xsy48gXfI
 R5fSLKrr
 h6OVlFad907neHyVQrdOvxudZsy1oBevUKZJ2b06Qsbv52jN0ubE2PLEuLGh6ULrYbvY4Iuwdd2IcY26crgo1zyYtLPoV1vMMeESkjMvO4IGe1bdI3HAYJkWOow2Zkw5PtGB5rykuXfGTp6TyN+GOKUdBnqAN7i+naBTMd8wgQTxe8Dk8MgvaCeQ91IsA0X3VzkvtKCGBQFbQaWCLXsouuM7O0Kh2msDpkzpvaRfZlA9assWi55hXCMOwB4lKWSNWVU/1gLRH05uGTDgH5uUrsBNBBxwm/h7pBcPmEZ28USlSmePw4aiHOM0/yQ==
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
> Then, we cannot pass the raw pointer to mem_cgroup_charge_skmem()
> and mem_cgroup_uncharge_skmem().
>
> Let's pass struct sock to the functions.
>
> While at it, they are renamed to match other functions starting
> with mem_cgroup_sk_.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

