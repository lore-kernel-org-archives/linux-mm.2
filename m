Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E3BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978466B0088; Tue, 22 Jul 2025 10:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929166B00AC; Tue, 22 Jul 2025 10:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817896B00AE; Tue, 22 Jul 2025 10:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68A6D6B0088
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:39:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 231EA58E04
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:39:22 +0000 (UTC)
X-FDA: 83692158564.19.5C3ACA9
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 240CE40013
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:39:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJUdQPqo;
	spf=pass (imf17.hostedemail.com: domain of edumazet@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753195160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfOWjAAjxzaPD6O6dTqgvPQKFnlN87Rl+iS0j68i0zQ=;
	b=f2/GqitSzaPotQyJSBmH2n/U/2eg4b2DX2EfB+BassW9+XpyNBHvZ8e08elS/2u9HDHfqV
	N0HJvlwwGWVHApSArnC/CFEv2dkLlf7VBsxFzSTuqjRRlj0FDhViYkwjjf/gv2IMM+VE3n
	D+D+nX28RIIMKmfeghoNcsSVEOrKpqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753195160; a=rsa-sha256;
	cv=none;
	b=DH6kfoOjKx3S3tkNQXvjikCN5XaVB1UdbDkJdfALAjO9LmXqHqfhaDqPrjBMgguDuN4EdU
	A78x99N5KPfj45CYj7Oy0djyNcmH79+AsS1iKGRnNOmsahH8IiMsjv7pttWPzJ6grqF6fC
	isJDjq4M3hysr5Gez7ceMlXhY6Pz6gw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJUdQPqo;
	spf=pass (imf17.hostedemail.com: domain of edumazet@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4abc006bcadso40937121cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195159; x=1753799959; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfOWjAAjxzaPD6O6dTqgvPQKFnlN87Rl+iS0j68i0zQ=;
        b=LJUdQPqoXy1gQrchfk04pg84jsyDW9wdhq5avoMvAz2udWNkgTO5rw7tUxohIjEjCx
         lVnG3DLoj3fRGqM6iAqjXNpn1PNvL1Ckn7Z+IZEbhWTIUFIT1mrXs1AUiGi3Mlf7umQU
         50Gt/6GRtIuAkrk//hNejQTM25ZVmEdVPGK4BDwZzMWAo2sRlCYs0d55qh4hzUt0wfJv
         KBjETbFOjigBl1Z/IEXR/3afpFQQ9Rf/IKhpS7uJM7oWkVrmKnU/4dC31ajeLS4mLTBP
         8+9NOoGr5fVkssIG/y/xojAasirMxjyo5I/krERZYq0uNQSvqliipkIwGurSFxT2lRVr
         6pFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195159; x=1753799959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfOWjAAjxzaPD6O6dTqgvPQKFnlN87Rl+iS0j68i0zQ=;
        b=DHIgmsTJPPmSsglKV5AUKkgQCnsCoFDDQkswMJocBAxqHkBfbH4bLew0GQreo2Z/bM
         hYNumb0GE/0+I/0B80TQzchu99Q1RJ/MFp7lpPVdez2D6odvNF5g4O2xzL/jhqdln+ac
         F3dxr0NolRjcqcRqXCY4SQwopPSuLdOCk+0ix0QnGvb8LGtjzcQ3mpRQh1J+Ll/RalPN
         4VRXnKNJtKlcKPjWR6YEri4XQM+ivNoCmoj7crNjOLBc/d1jSgnuYFwwdikRDn/dv9tl
         Bl044riFMxlxWZFZPMxYwQovA9iBV5xm4cNMJdwyDYSCewtxx78MwNtFbh4VI0gFcZIb
         3P6A==
X-Forwarded-Encrypted: i=1; AJvYcCUnePzGJEoiPoU9vcGL9RJ+2S5kphyXkWQaEgfmK2Ep+2YSCbpzKPPTlUlUe8Q04wM2wGW97xA8BQ==@kvack.org
X-Gm-Message-State: AOJu0YytPC54fQQAhroIaeAk4i0Qp9ct6yT62v2Ah5C1jNxiYOXmD9hZ
	ukNoT+MfWZaGMRBU9YSPydVTCRG5h2WNtYzfQXOA2fohJdz+PKhw3zvrrnwIXVyidcqHLJA9yam
	dmj0xDLGDxJc00Q7QuXR+snDzboO3cWC274ClT8NM
X-Gm-Gg: ASbGncverqPLdg5r3myzurLA+B7bshrwaWIziGAuxp7FejlFGai78kpwJEp5gWJH+fO
	VkI5fHY9uE5KKkRSVnVtU1dLyK03K4fCB69RWny2Yo2lsnkCbS31P+RQe3f158sZNQVAroZC2JX
	h0v1aQHVPVvAM2UHSRJC4TWCHVEwXTRnrQCAc6Q2wAMSJDXJ9AAgXTdinZW/AXe0/01JEeYBbR/
	L+ZVQuVNqN3ec47
X-Google-Smtp-Source: AGHT+IF/6P41Pb82F2ptVRkEzRWcH/wqc08aOFULaIn2GgGXH6mVUvBywwrKZk8BZMD9A0/6nMaxFzoslrPlJkLFRIo=
X-Received: by 2002:a05:622a:2303:b0:494:b1f9:d683 with SMTP id
 d75a77b69052e-4ab90cb6a40mr389467931cf.49.1753195158828; Tue, 22 Jul 2025
 07:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-7-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-7-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:39:07 -0700
X-Gm-Features: Ac12FXzzmBrUziOnhdn3RLzTJezLALGw-_Gmb0DoUXsN9KTiXNdnxPTcE5y2_MU
Message-ID: <CANn89i+qss82KMGJHKf-uMgrwFHXap9fs67+2azrNeBVpsVodA@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 06/13] net-memcg: Introduce mem_cgroup_from_sk().
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
X-Rspamd-Queue-Id: 240CE40013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mkufaohikcfi7y5rgcb5a36rrys6ys9z
X-HE-Tag: 1753195159-396402
X-HE-Meta: U2FsdGVkX19fqDAdWXadQgnKzWbiItfETUXSmVpxhwQ8W3DYTVGpeaCGK3YcdAow42eGUfpleX4zG4Yq5Eg13FrziCjsGu9Danj3gR/lzfuHYOPL/2ephTDE9olPJoBQPGX9OBeQnpdPHSNSZFG6VwB2dBd25tM2SFpCSGT685UWcfOjAfANyunLtQWwgMLpY4SYEttBUExA31WVi4XLEpYtkzDmGwdI7Nc3vspY64YGaHNb//rkqqzJrSj5a0XYmQSkcDGDCesM/8dWjVrF852jlhV6JYNazXShlJo9U+p0WEvKATXxf1AodXxLwTNAaBk8956WmTABm2HrmucfzVbWsVNxTyNRFOH9HA9iwTUPhBvaHiwsz/rBFHvwmT4EXvdSiX+8xqmDv2uoXxFTDkk9LSjeQ/XkHAVpeRSrEmkKwG1SNAjNc9KH2r/IcAfskjW5zKlWi0Umdtx/X0oaripEJFZQIxJVQvKLoxBVyvexij+l1IVXX1LJVXVFx92H2B9J0fnJ1EI1IIvzHcoXYsTW16gPP2UZOnCvYXnhq3qe3yIuGJE5MMHiHXyanH0/WsQ2QCXqfPHKliL1murLXbk3keTJ722fWm6Fj30AzKZKxCoxGuLsrpkg7jdp2q8R06g9bJhJzjwyzERlPzuAcwDVELeG+FEqvZarUGTUm3dt+09KtLG820vy9cYDxUWaJiB9vg6MqylYf+qzd5fH13wAqqwphs/v81qEAhP/dmIosRhrcAmni07ZPPAxlKopKVauzsMrVxTiUJgMUBPhSdWDM8OPfR843uqOb86+VvjUI9yMNdMzU4QvP+LNtJ6RcGMOSdx/ElWf/kroJf7oU0B/Q41xJeY7qZxS7sWTbq81q+9VcbIfUf5x+hS8Ul+rZ+qSH+6n64/Nxv4XkNmWUZ5+4pDKn5IX8NvPT82tCkOW/+szuAhoiyS/Ci+c0QEUjxTnlWpa9/9oMeUxavr
 uAIX55eQ
 e/2p+Ur5X7oRofv93a8u8d0ZKy3MneReWih/q++UWz5XkXlU9IXlSjc2aOLYl4AQzdgbh9FZmZ9j3MIOrydmHx+ngtRFjSGBrF/QAw4l2z/kWjnMv6I5EadisiRoqINjKCEAN3Iy+8LLP7atsEtPpgWYGfwy8H1Bc9g1zFprdSDmcJ1tvhUctdQh5t+ct3UL5XZb+Bwq0u269mFZRNlGsoB9Dzq1mvPWmT7Mbv/gEawNuhxshy/6dOEJZduMsB8cOflQShf9oAPU91a5vI5euOrJqEEASqrzS3eV/
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
> Then, directly dereferencing sk->sk_memcg will be illegal, and we
> do not want to allow touching the raw sk->sk_memcg in many places.
>
> Let's introduce mem_cgroup_from_sk().
>
> Other places accessing the raw sk->sk_memcg will be converted later.
>
> Note that we cannot define the helper as an inline function in
> memcontrol.h as we cannot access any fields of struct sock there
> due to circular dependency, so it is placed in sock.h.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

