Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A67CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:24:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC93D6B000E; Tue, 19 Aug 2025 21:24:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0E86B0012; Tue, 19 Aug 2025 21:24:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6D26B0022; Tue, 19 Aug 2025 21:24:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80656B000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:24:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 797461A02E2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:24:00 +0000 (UTC)
X-FDA: 83795389440.01.F723070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 02ED91C0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:23:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZaPJdoc;
	spf=pass (imf21.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653039; a=rsa-sha256;
	cv=none;
	b=t0WOFpPIYAoJpS/K4PdUVbN+v4R9PqlAdJuY6GnXNkFbhA10Hrf2VLqZTX4smmo+a+Z0nu
	/a7dJb1INF2UGw3eAZ2oIO4O3Giaez9dmSauS+XhwKBl80tV/JYcrQ/BlckytshXVtj0h2
	UiwfnnwnlUjT+jk+yv9q3Z38qSqsYys=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WZaPJdoc;
	spf=pass (imf21.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yGSbP5Zb472QC8qsZ0DjUb92uQAZgaivzP+otV/ahQ=;
	b=wnpsYhwZ1bXyWV3ph/z38C7anRva4uKW10FW1vm2zHTT0QS9AgFjkafwbEix4YC9/9K3Hu
	yi375R7X1FkizHlCYjm75FRqYj7My1roSNFjnqK91R5R4OE2SG8j0IPH0xnI2hgfe+tmDI
	ndLs67XzTIK4nCRYZXBjjpN6jlfxAyg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4A9643F32;
	Wed, 20 Aug 2025 01:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDAC4CEF1;
	Wed, 20 Aug 2025 01:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755653037;
	bh=C+2GTR0YI18RQg7u25sMTQABBcMAstNJVqtMhULRkOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WZaPJdocCn479Xgj8B3WHfL6XEbteMRp4spYbJHrKRBsvPTNdt82w7J0ckf1sbZ3K
	 v9NLjjrNm03pfouKO9pYrOz5WmbXxn0zgnY7eQhSHLKFALzAzd7gGxDXbAXO7ggY6S
	 ZP6KuZGPuipzXROF92MMdH1DF++mTr9xnzIbQoqfGyqa/LtMo511gtA0Z8HjzXSyf8
	 pykXVleVygK3hxM9bwoYGzDKOB33L3M0EUgvmgNfV3iFTsKEryFnjpp7f+S77kWBbj
	 1i7g6Qf9xMxQ2SjhotyTIT4+ebodrg5TiFSBQ/AiC1u7MxNG8D99SIZ6KKZSBUxKmP
	 009BVg9fIAqzg==
Date: Tue, 19 Aug 2025 18:23:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Neal Cardwell
 <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn
 <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, Mat Martineau
 <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Andrew
 Morton <akpm@linux-foundation.org>, "Michal =?UTF-8?B?S291dG7DvQ==?="
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, Simon Horman
 <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, Kuniyuki
 Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 net-next 09/10] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
Message-ID: <20250819182356.75aa4996@kernel.org>
In-Reply-To: <20250815201712.1745332-10-kuniyu@google.com>
References: <20250815201712.1745332-1-kuniyu@google.com>
	<20250815201712.1745332-10-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02ED91C0002
X-Stat-Signature: zt7kcoad8k7y7cqg8x18ru5gnp7xhb7b
X-Rspam-User: 
X-HE-Tag: 1755653038-886739
X-HE-Meta: U2FsdGVkX1+cWSSpmWd22dlSrmDE+NYL1iJhzE5irl2ZHtFEqraYO4gXsgTn7zCKChOTba+4OFVXHJg5jUwAGE++bAAyZVBEwgb6KAyvlsdk6l2BRJesPBlF7y0irH6ENWD8lsi3CeoT3bZQbF7oRk31p5eHYXFhOhlC8hTmDmhbyUGSbI1ggW08LZoi1Fka24QyJh8vat3TI298Mamml3M7V0eIODBtXOFsavr0KWdobPvCH5YzAy4fUwyZTiPQD+GVRBPu3Xs318gKEVsmkQ9CtpqkQxa7eHNPLSLn0Hw6OU8UwsFx8nMozUE6IWp1zon/E2efyUt/qec9KtTzUMMaY0n7SdezXy9AhUrL5nGalr4viAN5bBw/g/wIZQ6MLYcZdDo84PpdmO/djJgkfDlkkpXsPd/rI/NFUC+sK5XLaQmWrTgQ3qnzrdQ/MwRdfaOG42ZuJz5XpG9i2J+Hdhnk4Wwwbd8W+WwrCC3BB1/JPLP6Tul3oGXkhy2if2qxLTppNt4IqJNiIPQ6pPUzbemnsK2jTh9YS3V6Za67VPK1mtJjRUUYy0IYt1iHz8Oyw3y9MeP1A1LXm72FeZ1pPQz9B7bSJPUtfoLsLwQsdGlEo7UxxVI0TnchTsAsCduLIbA+WE9rL6V5CGTk/I92aK4RGlq70IkI83pnuh7zASfEodTqxloRrDEpccrDBIh2O9qmKBSDfF7nSU2qlMNQr6Kx0QWAM7V8c7UQD/W7k+FNVFVVqBYr7oMILq9GowNAHzBlMlHG9HiHhJ6Tyr7TQEeC+GwY0ZQeoRkvMp3yQiEJq2iFDonu/jDi5P1O2kkdg0t8jeLTYZC4hZQUBzVTKRiVW6KpzKLn+bzpECuEElaav81Z/1L+o+SNjmGYp2HqSQfBsNZbQHtto+yTyOBwQ+tJe2Z7KWCnSu/oGwSSyaAjb3lkiiAsLM92NILz1WI06hlG4Ozmqxmn5761nAW
 ymco4o0S
 9sO8L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 20:16:17 +0000 Kuniyuki Iwashima wrote:
> We will store a flag in the lowest bit of sk->sk_memcg.
> 
> Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
> 
> Let's pass struct sock to it and rename the function to match other
> functions starting with mem_cgroup_sk_.
> 
> Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Hi Shakeel, looks like you acked every single patch here but this one.
Is this intentional? :)

