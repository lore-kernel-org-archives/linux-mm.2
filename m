Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3DCE9A022
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3218D6B0088; Tue, 17 Feb 2026 12:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CF0E6B0089; Tue, 17 Feb 2026 12:28:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB666B008A; Tue, 17 Feb 2026 12:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07CFD6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:28:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90B1113A5E8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:28:37 +0000 (UTC)
X-FDA: 84454633074.12.0FAF05B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf08.hostedemail.com (Postfix) with ESMTP id E694F160004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:28:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ebapM7It;
	spf=pass (imf08.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771349316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g375hDwMmgHWl0MW8cBSMpNwUd7rHzHBiYYhO4JLtDo=;
	b=a0YCGOMhOzlZ7olc+x5zDq8ScaOcEv6ievhv1D5yW9zqmTKAoNCBET8DFbiqcTzpDVgxGF
	LjRe4QGyehs1iXM3mcgteh9kjy3FEIjT0Ihh1uyZQtDXwxm00Q1s2DYwdEOVWarllak8es
	viNEy1JeEmIH8vF8t73l4yEQTJ4gvGU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=ebapM7It;
	spf=pass (imf08.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771349316; a=rsa-sha256;
	cv=none;
	b=Q62YUjD64TZn7ZwIv1XYbVmm1+6dB6A1dIeTI2uLt38ru8onmyQcUDBTBpy18Msb1kSl3y
	5wj7K3R5ey0tRdIAiSffkgnPYVciywRM8+eFMLP9xRIEoj6dn7qryzrzmMTzezpHfT/tPj
	n2zrjcihT/sEgxJAW+jJ2Sv+ydc3H3A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1771349314;
	bh=g375hDwMmgHWl0MW8cBSMpNwUd7rHzHBiYYhO4JLtDo=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=ebapM7Itx1/C/zh3NAPwQBYkiMEQgY5hOkhfPXAiQn+qWO2aum2IwKu1eTrpGJnE0
	 Kj3jPLxwdMKyx6Uy+UjQjB06rKOR8QIyuReyqSaFJxpxpFa+sMruBk+Zh0GXSaz4Gw
	 LzWQLi1rOBwUePT9HIM5dUO/H39dmfj56HxTJ5ds=
Received: by gentwo.org (Postfix, from userid 1003)
	id C9299401B2; Tue, 17 Feb 2026 09:28:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id C6B2E400C8;
	Tue, 17 Feb 2026 09:28:34 -0800 (PST)
Date: Tue, 17 Feb 2026 09:28:34 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Yang Shi <shy828301@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>, 
    dennis@kernel.org, Tejun Heo <tj@kernel.org>, urezki@gmail.com, 
    Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
In-Reply-To: <aZMCAWiA7XHYLIE1@arm.com>
Message-ID: <c095a354-5b71-76f5-d7be-536216bf7321@gentwo.org>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com> <5a648f49-97b1-4195-a825-47f3261225eb@arm.com> <CAHbLzkqRjuWg7ybdkuv5xdoPz7z_q2n+0Eh0pRNoVxq-WskRvA@mail.gmail.com> <aZMCAWiA7XHYLIE1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E694F160004
X-Stat-Signature: 9q7tauwcqwucx959fr7w4xjuu7jjtcfb
X-HE-Tag: 1771349315-490798
X-HE-Meta: U2FsdGVkX187lV410OYjKuxyGpBW06YkJF3ailaNzW3fXdUrBUBNBR2QBwA1gqclUIVUnS4y8Z9lOilRWZvMha3N3nl3LIWKY8voG1c21VQwuxWxNDNyuvq+mNQWce6lPE+ff+E6mJwcGgsxVpyq1e+WUhVoIQ4OTEdJjNgP8QnoBKzcxJYdfn5IeyfQgT4PI9vIo2xElZt80aSOGLI5xNP8DKf5XhLbzVnwl/Bf/0A5fIVd+SSE1ak0PbkzBgAawrta7BAZFTYuXYQnIOkIrO8U4lSrfmKPRzEzDabRYcHUFbRRZBSsDe2PVykdJin/FRAY+7Jw/EvwfxfqZxCICYhs9OtTwye+L5v2MZYIO1LaaMYFSN9qfRS4eJAbbvX3X2DI7v8EyP0DntDyYbz+VgPZBujfafqpeVUW4lXHzR+ajLZaoyI1p43GzP/VKJ1PlxA+wvtAGh251idq2OwqY/oVsO3JacKHqAkn+c9i3na77sWd6giRoxt+OIvObnwqXbkjraeTWO4mSXJ5cnfvIywqIGqbbi/g7+qy/j5L8xPIIfKbmrdpNYXLInAd13th4F6E6kwAScm+4/8ewd1ESqegPJE1oqhYneg/PmG6L6vU8f02HNK+X2STpd8AjVJ/0XgxsHAKMEuvj9scse4GumzmZDZmCJjvDfn95GSw/1F0qwBa4u5uWJ0yMcoubWsrA6+nXMdTU5lP8vAk88miolL2UA7xQiO35yqhn9WsPsec11WjJfZiDq7sjTuKsqFNaJ1jl6qxcFrX0PII4m1uwACTVQ7CmTVqQCuB2DupMQJTAsVPpNM5hVUSsl2vRXW8ZODWAc3yZgrQNCSK8HtFaBxblujCE0Cwd395SFbQEp0LlkL22yWtU1ekguvoYSFb1H7WN+PG7rlrdQ54/J42/3ghg1KRNuq7+VroYhm8M69gM323OaGoryaa5OTHedlsqM3u5WSQvDsBGBv3EZZ
 d24HhU4P
 W/L2++xnGQGAqmgQdmHrZhnany4wUyvqbTcqLnWFK8lEh/wXcHg5JYwB4GtzWqcYCjxMDvWtSRc277fvyJCYSwGELD5yks46Y/huW+XiqfT85nv3WwCLI0dvwCy8cXuLFMHZRNQkH3EtIUImwkE6J/xcS152FCy9/QOoA9MVY8qqPCvR+KLqBqhJMxk8p+DfkAS16lxgJc3jTlMb+/P25h3T6i9qGBTYgC3wOamxe3t0VhEDAoQpHM44PJOFJuh/yEPiD/wqozGfnIBvC3mbyOL2gi1G7Q1iAGh0NAJcETxzqLxFxkVz6a5UqDOl2WBOVD39hwYTPcFZWZ6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026, Catalin Marinas wrote:

> It's not about TLB conflicts but rather using the wrong translation for
> a per-CPU variable with CnP.

These conflicts could only come about if each PE would not be able to have
its own page table but share page tables between processors.

That is not the case from what I can tell. The ARM64 code does not
support a shared page table and if I remember right Windows actually requires a per
processor page table.


