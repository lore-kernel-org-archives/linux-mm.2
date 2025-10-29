Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D9BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537D28E0107; Wed, 29 Oct 2025 17:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A178E0106; Wed, 29 Oct 2025 17:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388D08E0107; Wed, 29 Oct 2025 17:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26AB48E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:27:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0096988DFE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:27:13 +0000 (UTC)
X-FDA: 84052437588.01.2A1C3F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 575D6C0006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:27:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZNlulKx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761773232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IwcHKBqbtEcQt/kZv+hWvbJcmkCvkHCe1waK33OkGQ=;
	b=2lSFZCDy308ZOCiUPCmoy9Eli4wvVFROgo8rdhObM1sp+AT3XTYu4IUynbg0Wk+Z95lbBF
	aEETEo9uPmoK085Hb0MjtZFkgGCU/Amqy1b2joMJHW34JVmKPSoGSRZul8BAvL29jb/pkp
	F99GCWt3MuJAULdBZp+Xzz6tBhI/55Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761773232; a=rsa-sha256;
	cv=none;
	b=ERMHqUAWgNiZOrpUEd1G0mBd8WrFGApHmhMADqLZs67G0S3SBhmmZ0MfrR4QPp9YAhsDCg
	lz1RJcwrzXVM5GBGRoTV5iJefoOAytC5iSlqI5NGQ8d68aAJjAQd0sI5aHTaCr3zMA95Gh
	Iy56jYnZaCi80hcSerUJDzv7CtXjxwY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eZNlulKx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C36D44703;
	Wed, 29 Oct 2025 21:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F36C4CEF8;
	Wed, 29 Oct 2025 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761773231;
	bh=HUtp628QjLPxNtYlW6oWnca/Nvl543Rpcqb9fbnFXSo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eZNlulKxj9Ol8N/shr8+sMau99BQNL9iublLIN5KxFadpOi4pfDDtShOiNFmSgTYu
	 zQyz6X+f/w3w1aXroA275pzp+exbTd+E3LMhJH3Ya1RUi7gFxYMHEoho54bXtNKHMG
	 tlAg/gBxtFAtVsw2exc5ISynGzdNNuekCQqa90G9r2YBWqLPZGquiDONgA4XmAXML0
	 hsVnDLmw5GOrA2JRKrPybUYshcUFq6Wcb8jEm7Xq3zeigf38bdmLxXxTmfIfDn5qUx
	 gwKzISPh7Pm2a9kv+AAYWsH1oarD5XJNSH8f7G13mKUo0w9kWg0oMaa9rmmP6SFb6R
	 7DXVDVm0yDP3A==
Date: Wed, 29 Oct 2025 11:27:10 -1000
From: Tejun Heo <tj@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
Message-ID: <aQKGrqAf2iKZQD_q@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
 <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: f9cx36wy6qnmtniee7yr6wjg6a5h91ar
X-Rspam-User: 
X-Rspamd-Queue-Id: 575D6C0006
X-HE-Tag: 1761773232-136253
X-HE-Meta: U2FsdGVkX19BomgTuzRIyfsEaqvgcu6DPg5UHyeadouh2fY3PD4gdfhcYCebELO0p8JgjwfK+OG6HfxIKRlEseV/XpaOwbJCcLVj2V4aQLch6m3OIkFm7duhBvKMDkxeFAWwVrLKiKc6q3cz1QrXjQZqq4tvkrz4UEh20+39Kkfj3mC62x1/AvZ8mwLG9fLraKFzaP0aGjhmfEo+P2m+W2gppegJStAtgQ3WaSEBiSzz97eicz0GfnUoJjurw4YKKXTEjK9tmYFmsI/3X4IORbXjWOGaofRo+8YK5fSnUhZWDVVEa6bGE94VhSGpoZ2OSlaVt5Rqs337/ofoGobY9H7MLPKslRkdLgk3VQE3wP9Ncrw4uU8heXMd4iQ6PtxTicoNlP60x3ON2VwpTEMrHmB90dYh9ZSt7484qr8WGMidGZpHL67xhJ+kqdGAfU9vXTP+w7gvQPrI0BArIil6/J6jO3/Qoi0oex4ZCs34P89QVoR4S7mXugAdqaEhgzO++pFaec0I9pLq5u2Is/EF92hn3IvpsLwLLIojiejcaR//8dBmgRWD806vhI0PRXz2cYY+78HV1RDPQgU4BJ9JZUNiUHheo4an0B4S6OWGo92w13GaRO0lKeKlsGbHmygUD30Xpu+vxkZslKZYWK1H48w/ESNnWv9ciMos11W2vntYknRu/UyxF6pwU0ddfktYe0/acyIBQEspL+6JUc9v+uL9SGVZkJwbDcXU3fONZzwipEM+bSb2teZrzEIAVP4JjUvvVUA2MM/3YKlEZYs6u0zDprS1rc48qeNYqLVwa1d2YhJPPodJv+vuBJo1ahUndYjuOANnL7V2Fq/6A6EKogkPUUJB7oph1KN2UJ3qBH5Fljhx1nfFzBRLXQMOlKwnYlU3IW7I2R1Twh3ziXOI98D1FT8ujjvXxfvE8QqLPmGY/PClbqRqibMSVTxGMXLNPwu2lmIqVTXkRVaJniu
 PaIQySj6
 rNyv/WZtAjld1mECmg/ZFh1PQJmy0zSgH2I4X2UqIf3FJePvChMyDK3SeE/c9eCJkhIq4hCf+/kRIlg/z3KbCkkG09Aab0KOxyaClIGL0F9KacPNBONA2tEmvZZVjA2tDo5qxYXOF/zs4dCcJe+idTHtxfR6MvrhpvyNqFaaJXlk2Cq7f9MlrOO650FhBSX3I3iv4swHVui4xefVdoRe0RINqvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Oct 29, 2025 at 02:18:00PM -0700, Song Liu wrote:
...
> How about we pass a pointer to mem_cgroup (and/or related pointers)
> to all the callbacks in the struct_ops? AFAICT, in-kernel _ops structures like
> struct file_operations and struct tcp_congestion_ops use this method. And
> we can actually implement struct tcp_congestion_ops in BPF. With the
> struct tcp_congestion_ops model, the struct_ops map and the struct_ops
> link are both shared among multiple instances (sockets).
> 
> With this model, the system admin with root access can load a bunch of
> available oom handlers, and users in their container can pick a preferred
> oom handler for the sub cgroup. AFAICT, the users in the container can
> pick the proper OOM handler without CAP_BPF. Does this sound useful
> for some cases?

Doesn't that assume that the programs are more or less stateless? Wouldn't
oom handlers want to track historical information, running averages, which
process expanded the most and so on?

Thanks.

-- 
tejun

