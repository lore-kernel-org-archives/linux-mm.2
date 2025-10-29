Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D949CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE718E0109; Wed, 29 Oct 2025 17:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF078E0106; Wed, 29 Oct 2025 17:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E038E0109; Wed, 29 Oct 2025 17:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4965D8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:37:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E150BC022A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:37:53 +0000 (UTC)
X-FDA: 84052464426.02.8ECA3C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DB702A000E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:37:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fjMn/gm/";
	spf=pass (imf25.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761773872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2m6E3KOecuxoequ8DNsV+fUpEVK37fOzsOWy6portyM=;
	b=5y/HOWuyG4R7lWoRHv9/2GC1XwDC99ycMvHwqNXheXP7NjHQdP/WPbCE1OQoPZgBfGGhTL
	4TAioYJcRzdmZaw9aqUoRDnsWhCbGaPyVa+yhAmVPSKP71lVEWUcJUudVZsC3QsPlUhhZY
	rbIcLofXy3hf2PuU+9x3M3KRie42Bw0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fjMn/gm/";
	spf=pass (imf25.hostedemail.com: domain of song@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=song@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761773872; a=rsa-sha256;
	cv=none;
	b=luWghYaXvR/U7FNXfiEzlK/+Yd+FUv5Tc27v0AeEZxLfY/wi7vFTInJUJmGAA7EV+kZdFm
	UdEwQaAbhcXok+slh7mtuoMLTC8iYEYPNkTrEWk6Edh/zTVfsuimGfyqHr3NKf9zW49ial
	l11GIxFcCQfRWrVRHBCKBfsfBnNwL3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB16444810
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D32C4CEFB
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761773870;
	bh=2m6E3KOecuxoequ8DNsV+fUpEVK37fOzsOWy6portyM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fjMn/gm/CDewlocIko0JwpcUbQNTVXJfqhcLmVmlIxZ6TEhg012hI0UEbsfewfbTt
	 NEyzf/ciIDB8DT5NwyBP5NPO8ILWXAt1x7lpFo9imF6bbuGnHyJ/mm9OCM9/UqxEPe
	 plTDtO4nfJPJ8wxcKHUSEtnGNQ7iq5GlRWi3es698U/Sc1WL9UsfXczphrDyg8BanY
	 DVLK+k+n74VW2UgrrsiUeRKXL1OSpeGiQ61wxlR43E3jshlTrZft9QUKvMIBWF7s3j
	 c9MKG+ZSAKw7+Spt9tjivzpDHxKdgWQp2aBUkFEh3LOxq9paAqCf3V2B3kLGCpbR3f
	 kb7GKkZj7Y+XA==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ecf9c2c9acso2689191cf.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:37:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXvCcbLx83BUKceYYJOrS7fwKC1io9NPK7LlbIDwJh1aoAsLRwV1k9gXxTe24ISVtHeSAd8wIlBPA==@kvack.org
X-Gm-Message-State: AOJu0Yym3rkt2oM2nokEi5ShInoHTJ5iBywM31rNJnSgCn0hErYa4Jzh
	vUh60cJly0EqNvKqrWDljOqubYcClvMzcZmMi/XaTLmsqCyFTg21wqof2OCQVU+HqPcnnJbVxiO
	iG4zG+i5As4i/LQepvxtf246fRBKq2g8=
X-Google-Smtp-Source: AGHT+IHf7xJb92TiwVJcd4HpaDmN2Evk7yYp3/gpWQvWWAHb0Jqi2EVJBlDw942F/nUwWhx1w32vHDcnFFGm0iLiRgo=
X-Received: by 2002:ac8:7dc2:0:b0:4e8:acc0:1e86 with SMTP id
 d75a77b69052e-4ed15c1cd6emr57252001cf.45.1761773869510; Wed, 29 Oct 2025
 14:37:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com> <aQKGrqAf2iKZQD_q@slm.duckdns.org>
In-Reply-To: <aQKGrqAf2iKZQD_q@slm.duckdns.org>
From: Song Liu <song@kernel.org>
Date: Wed, 29 Oct 2025 14:37:38 -0700
X-Gmail-Original-Message-ID: <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
X-Gm-Features: AWmQ_bnEP6btBVaHkNJVps6IoG-AZx4A3wkxixrfqUMH1dY2e5xFkESMzpATyCo
Message-ID: <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Tejun Heo <tj@kernel.org>
Cc: Song Liu <song@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB702A000E
X-Stat-Signature: hrrzd6atemxs5ukh69myewkawp14wuja
X-Rspam-User: 
X-HE-Tag: 1761773871-432900
X-HE-Meta: U2FsdGVkX19lB6rjs0xSaCaIiE1mhPod8xqbTxKrn1gq5UR4VpLPBUT/xy/0+F1B8dEKRbVOiaPwrb9agAKr1/y8+e1rzdx7mWHIIXR/hfeEXDmLAhuFkU8alLyBsSxo94tHM8MOO5jD3/DawKiCvYCGdvRjKU07GR/b0cf/DCJavrh11djgQOLzB4hZumnBmH9AopHpWMnhFbvv9QO24mSs4zFslgJdBB3OrLm4s10FDh+AWgdF8yWVgZ7pi6TWhnrHs5svYRt9PcSm+0ojs7aLn5TNIS9Y6GjuAq6jBEb0OkaKNu/5/xfLj/wG2MNR5v5ghwsaypbjshE41UF+jj6jT1cC1QalMBHpNSeyoGovmiUEeGewWyWP3PWzg9770pFtyg1GVjvt1fBHXQAKJ4f16J8PPh7A69x2aLfdUqr84MAPQvffdPgT0pQnJmyv/BdSZXUCtxCJMqCiWoNsgi9b2iuYPG/a8XLBojFSaUhhF8n1vxH73gtxERqEFNi7XrOuFpHnLqZB4lYcQv7Aeo70G4/RuWjMm7LN4AX1pbOfWQ3UVvdFVmBouEIc+dT1XT3M1MWE5dkQvfpTU/zyzzoDlwv9VjaDEXd7MvybWB0en34KaWwGwlcvHZEnRaSQHRitz3Nkx40yCtLQGxDnWwuWXkoY/szsFTLNTBTk6sN5TZuwULqsQ/IDgTQse8VQjJMIzPnNa7scd8W/DH8yJrVY5W99slTLbSGdl0qkyhlx8NUdOgQ1BBYBML5qybz1m+0iQ2JOq22ZMKW3XRcF8+wVFM0bb8ioX+ibDOMS2VpqMb5Qxv/tRK8uBvkT/+JfMKtxnQXQqyt8ebdX/D2uq4kR0mf3tLl05rRAGd9j3gZH3nx6sfgs94W3XR04HpvwrYZ4SgIUffW5unUoyOFqdNMX3nTQIn2I+tmdJRIccAUbM2GrNUOs6tuLZOjH0lXJQqlbEfCUL7aI6rEHdZ0
 KNk++5v+
 iUeAbJpPjf3gkGLQW8+7hk/FaDTIjbYqCZ5dkDv8T+0MdxC/zXhJ8G5RfUMhPRJydsC2aHKConH0FMDL7DZZsQllGQnunqLFEFFR1/vLTbV2jp/1QH33gttpQ6HUlCm2BWQoSYD04hW/n8dhePjZwjU9bUX6CHVVzEky0jkAsaxBnZQMLtvdlXun16+FlRRHvh3d7hJfNGOEEhYcIH7jg+FI6R1+tyYAfRynXudflJCD5/65lRwo+ZFf9TUjAKi8V5ubujpSyVUN+FoCo2aV/xOROXJlK3dItbaCq9yIvWJ+DkGCfvb3THxDAjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 2:27=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Wed, Oct 29, 2025 at 02:18:00PM -0700, Song Liu wrote:
> ...
> > How about we pass a pointer to mem_cgroup (and/or related pointers)
> > to all the callbacks in the struct_ops? AFAICT, in-kernel _ops structur=
es like
> > struct file_operations and struct tcp_congestion_ops use this method. A=
nd
> > we can actually implement struct tcp_congestion_ops in BPF. With the
> > struct tcp_congestion_ops model, the struct_ops map and the struct_ops
> > link are both shared among multiple instances (sockets).
> >
> > With this model, the system admin with root access can load a bunch of
> > available oom handlers, and users in their container can pick a preferr=
ed
> > oom handler for the sub cgroup. AFAICT, the users in the container can
> > pick the proper OOM handler without CAP_BPF. Does this sound useful
> > for some cases?
>
> Doesn't that assume that the programs are more or less stateless? Wouldn'=
t
> oom handlers want to track historical information, running averages, whic=
h
> process expanded the most and so on?

Yes, this does mean the program needs to store data in some BPF maps.
Do we have concern with the performance of BPF maps?

Thanks,
Song

