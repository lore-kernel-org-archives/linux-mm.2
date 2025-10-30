Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E46ACCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 16:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723CB280010; Thu, 30 Oct 2025 12:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB8D280003; Thu, 30 Oct 2025 12:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638AD280010; Thu, 30 Oct 2025 12:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51C72280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:14:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F14701A01F1
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:14:03 +0000 (UTC)
X-FDA: 84055277166.12.B729880
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5358B20003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 16:14:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLSYhk4d;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761840842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWXxehmiaTt0KzTZFEegz3mxDUQrK/hB3iUN5U1q7Mk=;
	b=0z5GwXYkj5qHNN0ufz0ww7Kn21L37JeA3xL4KuZKQChTs9nmjRl4NKr2wxEW/rj4BHJrrv
	cZNOfacPAlJNionp7SQJFZQg9nyscf7pU6IZX+JhPKdH1A30Ee/fjn4K1gr7CKS0eGjyex
	ZIidR8lBZEtB9DqrDj72hAmXgLtPWoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761840842; a=rsa-sha256;
	cv=none;
	b=7lpTjnRJAOXVTTiEk6QfdBmQARyxS8MffF+qXJIULWRv4m402FudTxfZ0yMYSIdM2RoSBC
	Pf5WJ9KFl5oM5A/OSdfO7++lSgBz5Z3skOoXJ83/65+yN8+Z4XSomp8T2tWsgje1r6XleK
	+PBmQd0esBshME3w3+1ucymP4jR3d34=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lLSYhk4d;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A2E260403;
	Thu, 30 Oct 2025 16:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031D3C4CEF1;
	Thu, 30 Oct 2025 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761840841;
	bh=81xY3et/CDlan4zato2VKfVrhsKD6Dy0acKVQafxgnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lLSYhk4dHqZ1dor08LN5ap2JBv3bG3N0GXsdH6f913EZk4xaZBcnfMvFv1C4K5mgf
	 0xLQloW0iTP/7YCZg/JeYH9gJeTa7h7N4w0pxp0nJ+GhSachiJYzWK4iiimAYxP6Bk
	 y/5NdkYtfklb0hB429t42B+VfjiM8DznMQgWZhOoV60Vg7n+M0HmFiEvSxkHmou7lG
	 GAh3ytHVmPZ97ggPjChUxRXzgaNDIkxXuWhyBxVtYuVJwKTYtWhp1s8xW5PLBi62o+
	 77g5MFoT4CJGhnN6RMNEmD68K1DSQbWOcltqcre4r+Bu5s8cIdfHphXYTbz1qZ9+8Q
	 B9DMm9tFQd4Aw==
Date: Thu, 30 Oct 2025 06:13:59 -1000
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
Message-ID: <aQOOxybyymnUk8fr@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
 <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <aQKGrqAf2iKZQD_q@slm.duckdns.org>
 <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
 <aQKLCuX5v5aO3fDa@slm.duckdns.org>
 <CAHzjS_uqFLEzvU0PTQiXajdFDsjC4gfk0Z4qMoiRQJ2uVPw6BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHzjS_uqFLEzvU0PTQiXajdFDsjC4gfk0Z4qMoiRQJ2uVPw6BA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 15xprmr9rpcqongzpfgox78nfibw8yrw
X-Rspam-User: 
X-Rspamd-Queue-Id: 5358B20003
X-HE-Tag: 1761840842-445364
X-HE-Meta: U2FsdGVkX1/wd1TlTlthnSX4Cq2DUKg3ilseCFeT8lqG4VtXBsgfcu+ohqB8Rko3AopFyFpVnqez1D7Z0DhIpEwBm9croCyxaYihvbBhk45RiyNZGAC/7l5nyvkeiT2R95QCRjZJgmMz8KDs/o00zCO7TdfHtrDXr2QVDjpX8wRiJwrLQeSoJsjqx8LC0wsBTp3LSQ4XhYbE1MFpKRSrgxo8vyI5KesNHL4PPCH2ayacFIkN4it/bmd+7/ZHwIkvxx+ZCNsKX1AzfnsP3EMbygqBf5kj5ycZ7TzvpARKRXhhUfVZpSZYNrlbedMr2/CBWV19amwTQF9E7KZIbxwxFkK04L/OE+h68FUtsof9yScvwLgpgPRkTk6UWglI+wo5ghIcXMIiHofMw5qetjForlEsAGybUlxMm/Ojw+/KhAVD4ADpo859aNkcg60EasG9QRQNd+0mhYv28mpQH+sQeGqkRg5s/GhSuXVYRPUziyuEuXVEY8U6rQWPzHd9srEhkW1umuWuLBgVRkQV4d131tu517JnFRkYI5sDGb0abV31IrzujSxWrMlVH0dEML43V3OOKe2M8oFu8jmuTbuA06uIvenrGHMYrTQTATOJszniugHRTFCEiff6A7Q4oYVmCI5m0dNA7qtVAvp4Xs2OzKKzg3Br7D9+Fn/xzeO60SRcyWcY8HzkC6+CMnqXwU+T83HdUi491VSxb9Ob10mooIUBTVgaftdU4bpG7KBLE8Ig7E6paoTg1Wg+h1zcLrprVRKg7AZfkvITjU+LNU7SOH5URp5akodhRMwc76CmbRGKVt5oWmRSVQcvyjetoBlG2z/xylRYU8/tc+NUr//kpH+rpIl+DusB53jZoHK2pm29/jq3xrq+e4f+mp+aWensfdphITJv9xS9zeGfy14YGVfFmtx4XlPE/EzJQ2Y9/Xp7HdhxjJ2c1qxXO1HsIkl4WieNvON3e7J2kCqih3c
 6ZvM9RnK
 v4kOTsJ6i/Hdx7ZyAyOgAympfOyvrRVxa/dcetRlR5LkiB+qbpJjw4pQ5mibJpMzM86A+XoW4ShFBuUh7dfE6FLReBm+ly52ywcohqCWdlYlk+X2A/XMGlLYHefoN74nX/tMm76UXgXVlTtKnoDl5w19tOp0TD0cUpZaALtQnGRiiR4rIBkxhdsMiNbTTkLJQDCVoW8/YpWmgkla3UoZnDkumBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Oct 29, 2025 at 09:32:44PM -0700, Song Liu wrote:
> If the use case is to attach a single struct_ops to a single cgroup, the author
> of that BPF program can always ignore the memcg parameter and use
> global variables, etc. We waste a register in BPF ISA to save the pointer to
> memcg,  but JiT may recover that in native instructions.
> 
> OTOH, starting without a memcg parameter, it will be impossible to allow
> attaching the same struct_ops to different cgroups. I still think it is a valid
> use case that the sysadmin loads a set of OOM handlers for users in the
> containers to choose from is a valid use case.

I find something like that being implemented through struct_ops attaching
rather unlikely. Wouldn't it look more like the following?

- Attach a handler at the parent level which implements different policies.

- Child cgroups pick the desired policy using e.g. cgroup xattrs and when
  OOM event happens, the OOM handler attached at the parent implements the
  requested policy.

- If further customization is desired and supported, it's implemented
  through child loading its own OOM handler which operates under the
  parent's OOM handler.

> Also, a per cgroup oom handler may need to access the memcg information
> anyway. Without a dedicated memcg argument, the user need to fetch it
> somewhere else.

An OOM handler attached to a cgroup doesn't just need to handle OOM events
in the cgroup itself. It's responsible for the whole sub-hierarchy. ie. It
will need accessors to reach all those memcgs anyway.

Another thing to consider is that the memcg for a given cgroup can change by
the controller being enabled and disabled. There isn't the one permanent
memcg that a given cgroup is associated with.

Thanks.

-- 
tejun

