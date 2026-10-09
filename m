Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D82CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 01:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF1B6B008A; Thu,  8 Oct 2026 21:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA79F6B008C; Thu,  8 Oct 2026 21:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4516B0092; Thu,  8 Oct 2026 21:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBFC26B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:40:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33612160190
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:40:25 +0000 (UTC)
X-FDA: 85301382810.30.23F58EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91778C0004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:40:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPcvwB8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791510023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sonlmmEbsMw8bb8h1L4x7UUPh61JSBta553UffDZL6Y=;
	b=Kl5AS4JrDuhYXLxKPeziYmeCHhx72f5TSt7FjOrxtpKBJeAWSiXJpaS23gOGKA+gNndkcW
	IU2nyUAq34xnHxh2T+4zcY70nhrWCyma723RJOpVC5FtbgEwHoE/m2bXFvAe+lI7svWWkW
	cCKYyw+2BAGFAqNLQXFMmAhbYXC0jXM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPcvwB8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791510023;
	b=YVzQssEVc59580/RBXko/gWfb/pTrrsvbBZEHz78dlxhM4SSLZkc7TSqsMfsbyvF5Us+jG
	kLZ7Zws8CdH2EVqn0XpoinMOsNaIm0R7hrrmGtSKmCeliYrjC1qzgkueVnryGM/g6O3wAj
	KmH7PLkBHN3GKQFVjK5eBtq30etyW8I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2930360DB0;
	Fri,  9 Oct 2026 01:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E2A1F000FF;
	Fri,  9 Oct 2026 01:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791510021;
	bh=sonlmmEbsMw8bb8h1L4x7UUPh61JSBta553UffDZL6Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LPcvwB8tyoWplYkcjrGGKzxhYDkOKYV10BGcdZc1JNR4XGatGtc+PxpptAUACHsE1
	 12q+HFsPMpBbaqKNpWOYNqkxc0UFZuQGRVjG0ZDJyTXAKJ5OnFua2738PtmeS//+Zx
	 sIT1dLHzFBwk+4VHLOtNQ+dahzCV7l0GIyVyamud21wc3ekSnGaOymUTKTMn+xErYP
	 3Dwk93r2VlVMnvprK+/dw9oW+l/YDAGn7CQOjiJ+j+7KOgeCbuYNKe3m0V1rmmeggA
	 IyZu8QpVke7nIkRJf4R2CGVjt/KkXtLT9+r2bt9kaV44tf/aMbGyER4VYEMkPwKqR7
	 ie09JdWQh/s6A==
Date: Thu, 8 Oct 2026 18:40:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 "Harry Yoo (Meta)" <harry@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Hao Li
 <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes
 <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Willem de
 Bruijn <willemb@google.com>, Mina Almasry <almasrymina@google.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, Jiayuan Chen
 <jiayuan.chen@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/7] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <20261008184020.666ef78c@kernel.org>
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91778C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: j1jeyehhzcxhtfwmmr6g3kjx5g6ef7xg
X-HE-Tag: 1791510023-572061
X-HE-Meta: U2FsdGVkX1/+/UZZ0yp4biZGsaki3ZuSEY7QPmZndmEt+tdZsG6VEjd3Z7gXt+lt9GzRAPBmA+xIZ5qeK2o2eWwdFVWzRpv7raAVNYPX50DbSqNpnQT97EGf961j9lEQpuUCZ253YSGdxF8PlWSQsjHtgEUxEU9OUMj0pBZMKqfXWmrf3nrOySPJ2IXANQTo/Ds31xYlvpq8U4MQ+QhyfgxhzJhR/Q4gU15uTeT5EHABK3abm9Q3Ebsi5DKN0+9x0qzcwCnxYa0egbEdoXEEQH3Ot75qSCCvfzG8mHb2YEXxW9ZTvU0GA3uTP7cFlV12uljLcopJjtJKMsACpNmxSUN/Zl48IDN6+gyhrhDPQMdIRxLW/ervBXvWbjuSkL8KZ5BwhTrxsXB1per0FKUrYeRzWRDCgpbXEAtAK5l0nHVYYHyVZMvNkEOj/srYnXOg8drgqfN+Nrk1PJfl1BOSxijIfmcilkrDxR0CuVJFyosWyDO41ZKbDs5YXZ4U7qHUuP9sOAZ5fcpmdOxtaVaS8iLyRoU++yPsbqwdm9ZGsiCxdftot8FZvs9feLuHOUa6/ns0i4lGpOqyeQ2OOXmIkcQIPJXNoWGXeXnNWe04RaR4Qgj1H07ZsSCh+RVltm+GPsYyQXEbIIkm9m4vbeSElQXwmmGwjlCKGTdq30zqnBJUP6fZwxX+XUjzsnFBfNqwLjQqxXIxoXkhFC39LUCeLXIb4pA9QE8oCGEG81+i69TCZx2yuHRXZsiPkrsiGoBUWsmtiX4G1obQ2vqIAkcda7J/X9ICtQO87wjDscCagDE2g805b1Exbv+ooda0RoteTIu7eEGlWgUbu/2L4XFEyI10XfrqKQGKT+Gb3OcVR0qtQwKksxSYDY3+k+eZWVSm06rceePUP+rI/l2nSLo4Iqe+EXFnuxsLgDVmXRiOa7qBNtUNnRKHglLfHwc4rHu2S14IQLQfOwILXhJ+PCY
 xEVeFrEM
 Lavy3I3HADj6hAhWJNkffmEguYAYrylmYTjOp4+vUzkwL07C0pmI3XyLg3j2/n7cBcb3ek8b2AQ1LNy7lH6HGyu8nOUbk2JoT/YafBE/04yN50EJu3KNniIDK0ocOYFZSfI1HdBSORg2xUYuG+8+IU+tocFgNdenOyuBu9IRFoChLLH1257zMRAwkZhoFQCB7xxQEnr5/ZpfsY5XhoEUXK3eh5tXJkWerP441QzMQMhHKquMm2DtowOwM8UfELxOI8AdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  2 Oct 2026 16:11:20 -0700 Kees Cook wrote:
> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> acked in v4, so I'm hoping this whole series can go via slab?

SGTM, I wonder, tho, why you marked it as net-next in the subject.
-- 
pw-bot: nap

