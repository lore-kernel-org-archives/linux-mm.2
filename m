Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CFBC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2F190004E; Wed, 13 Aug 2025 04:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AA2900044; Wed, 13 Aug 2025 04:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB08590004E; Wed, 13 Aug 2025 04:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA02900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:54:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13087583E2
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:54:43 +0000 (UTC)
X-FDA: 83771123646.13.8DFF88C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68A391C0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:54:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkB0DENA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755075281; a=rsa-sha256;
	cv=none;
	b=TfZdJ0t6JPbjphUisDb2Raw6q+1S57cbSux1xGslXmnNSEsofDtT33jCB58WQiTeCBaEJo
	iyv9acJi4SE6arLFreAa2Ur22XjwTiWKzg8qkFAnfJHUR4VWFUd3lME4b/s9hgO9+Az6ZH
	I9OQWQVExqKGSZNUYtKiJXH3gpWvOqs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkB0DENA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755075281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxSxs1bcucuULoGHrK8+9HS8dRUECZeQBRbiSylRYnU=;
	b=wdcqcgdnZtXqbx+kvybD1BmnU57PeTz4Sk3gl8Rdub9YjCr3WF6oIY8mfzFV8YvlD528R1
	zKHZ2yqtTEhZzu4mQF+r06fcr6gOkZb+e41WESlhp9IoIA4BqFW9H7dG6doJHNZaOGLtgN
	pg2/UKU15U6HufG3XkzhTcalBi/MMRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id CDA54A57B59;
	Wed, 13 Aug 2025 08:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C3DC4CEEB;
	Wed, 13 Aug 2025 08:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755075280;
	bh=SBXBWsF/p9NKoJCWyngak/HD9GTkihC0XAEtH+NHPaU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gkB0DENAHiMv1bTV0uLkAOQtPelp8vcSXECcmJM1R8fLXEb+A/yNSIS0Lw5g/aNLq
	 TScjivlOvmkh7LBv6vZuPf17tX/AEY+NwOf53y4mJZTF7N82ecPlFHRIFCkJoVpIqW
	 Pd0PYJbXGIzPSwqVgib7ILcfUzFxfqcaEMmGH6qI1ymzYckc2KQbiebdU2wxUaOJIa
	 r8EXvG/9cNxgcghFbKP5v8lD3OgY4KcRtXtg8dCIdQsUj/AJVQspscW02B6BvnvM1j
	 GSsw2Gso6j90PUTrIAdD6q0ujq/FxP0XsJWpG/myCkLTddEzOzPRj8HST0bDnyoiNe
	 KRZA8hDbrL9ZA==
Message-ID: <3f267fa4-4266-40fa-a485-bd14012f4b61@kernel.org>
Date: Wed, 13 Aug 2025 10:54:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v3 net-next 02/12] mptcp: Use tcp_under_memory_pressure()
 in mptcp_epollin_ready().
Content-Language: en-GB, fr-BE
To: Kuniyuki Iwashima <kuniyu@google.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-3-kuniyu@google.com>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20250812175848.512446-3-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x3whz15mxiissxe5rwen5xqdsty8tch4
X-Rspam-User: 
X-Rspamd-Queue-Id: 68A391C0006
X-Rspamd-Server: rspam02
X-HE-Tag: 1755075281-584922
X-HE-Meta: U2FsdGVkX19kmMIspxSWk/pgpCBf6AL2X8vmxMvWRKD7cJIeZjoQCROtC7hM4ZnO/5UmXug+HmV3542wIFS4Iw/jhdnMPj7TPzV/Ws0JTpypJRc23QHW6n2sSbaJOxEhaZbafjMuQz/UsRldaoxD5e5ugJcLanXMxaVSiGnjKRDHB79GaBzgAjHa1SHKHlLRgpvTonCMeLyaa1JDri7f5yhN7wKxmevgiA9uP2NTgN1wTcAJkWglVNuFcrzr2kkglI+fiiIszPa5VNgttIZLDa6V9DE633iKi2kp2RCv3foqLRLcR+dYEnjHtdxyYKVwyKHmxLWo3shpwDDGT4qY945jougrjbIFA1O+gvghMBNBArzTmVOd5Bm32RoCWrr/ZKhUPnqziBbW6znLIpbNYHIB+8IhIvtR0at59qQmrWW4r4qOTiyh620ymULVEfrLGqIGkCijgknwY3e/3PgzfAlRBIEUddgAWlxhkXkhHjGKET0tZxIeOP71DkRuAHMd1HT4dG+E+vOrO1lWLFkCWuriM/lemukOKBIMxeBa1FpCbrJd1kGVMXrYtaGHoPilGOoHYhQzrB2/VerLTALMzZDLNRAyUTo3aWwDHJVq3iG8QJf88cEJ5gViR9ByLkwPZK+uNovbzJ3EjBXDxbjU+IHINl6TXK67wELx3uh5NwtOMq9HDeRHjBE7kbYeJnaWjMFsyUhwwh2Ml3Pu0JsV/tpfEFl+Smi3mdc/1SC3WnNfpYNxhgBZgMnFnR3O5CmPkLhm7U1Q+5vQZSAcAwfn3Dv2idhBNMGh/VSkX6ba9wDcGFP2BiIi38wlodKmKmKwpUsYMayRX5kaxPmzsiuvqYL4fKPQmRwhokA1B75wMSNWei8KCtn+KsmRf3JQqtvg0fK548vQHFUKPo3QUArtlB1ap1vkq+Xu8CdfsNpn4ywl8bi2Nrdd7vJv5XuxaKCR/JjgXznvAfBP98YiGXj
 OMZlyrmk
 BtpDr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kuniyuki,

On 12/08/2025 19:58, Kuniyuki Iwashima wrote:
> Some conditions used in mptcp_epollin_ready() are the same as
> tcp_under_memory_pressure().
> 
> We will modify tcp_under_memory_pressure() in the later patch.
> 
> Let's use tcp_under_memory_pressure() instead.

Good idea, thanks!

Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


