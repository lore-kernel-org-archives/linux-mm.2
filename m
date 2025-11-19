Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B408CF394B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADF16B00A2; Wed, 19 Nov 2025 11:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F016B00C8; Wed, 19 Nov 2025 11:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D966B00CC; Wed, 19 Nov 2025 11:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7052E6B00A2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:07:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47AD312F5F3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:07:17 +0000 (UTC)
X-FDA: 84127836114.09.8B53BF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A22A1C000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:07:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b7KQxCxa;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763568435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPCulklciNjwxnZgUY167lvfpPIQgMiIPs/coJNoJ+o=;
	b=DqNcO1g1jw5shbv+Hp0vXS7sQRUyGFavfM9CxKVD3vDAT8gFqf9RK1LOPGdCEv7jnLjPEB
	lNwO63R15VGkLRDEriMYhiDKqgj2pRPZJYr2fozQwxjseP2A2rC1FZjASDg+AId9S+QfDN
	sMvVoMOMy1/0oFxzEQGZ6hpstUrh3b0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b7KQxCxa;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763568435; a=rsa-sha256;
	cv=none;
	b=XVzuIrRRU+4k+W5zbcmnwKFXkJ6s3pdLs5ZeTg9wz/UgiodmgVyPZbQTAIbfwH/CK7se/c
	3tYLM8ObhLV6K4jssmt3tVg/Pg09a//EsCNpYW3BgVTfGwubNqMfQRa9QSOkjv95OZ0ecd
	J6nZqFWDuuiSklyS8n2GGV8WRw5DrXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E95E433FB;
	Wed, 19 Nov 2025 16:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581A2C4CEF5;
	Wed, 19 Nov 2025 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763568434;
	bh=qRmXNqvNBQDh97190xHWs7o5wzuF2E7C7rnGx3N7xAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7KQxCxafz4qEtGxChHspekYVsdbRsj9qiAz3vFLObGmqzZL1lrFzsBm8ciNbo6bq
	 6BGzn/8DBsreJedaX+njzYw+E6jL4GPtRfRmybU9J+KrygcbHjUiE0fs+uh/QE0hHP
	 JPY4vDH00zQ7d98qcxtDlDEuoR0pfukrqJyDU+rNCe9lhxeqcGCciOmDsRIRbLDTuN
	 FKn8BquQeP2swUUvrzc0OrDxuxM5jAUXtAsRKDWgQX7VTQ3Zw2+2W9bhY+dJf+Uryl
	 i+UbaOQQNdPcqbzi+7QtAn/c0/dF25lZ0w5/bf1XZ3TSyj50NsbNJNzj6X6G7jCNd3
	 KMf70HOU7D2Tg==
Date: Wed, 19 Nov 2025 06:07:13 -1000
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: Re: [RFC PATCH 1/3] memcg: add eBPF struct ops support for memory
 charging
Message-ID: <aR3rMWgTWHryaZ6n@slm.duckdns.org>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <15f95166c6c516f303f3092e74c88ace5164bdf0.1763457705.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15f95166c6c516f303f3092e74c88ace5164bdf0.1763457705.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A22A1C000B
X-Stat-Signature: rqsngyier1kfccpdejbnwge9bdnuyw4k
X-Rspam-User: 
X-HE-Tag: 1763568435-949142
X-HE-Meta: U2FsdGVkX19c2UQJiCC1HCCq9KT8sd0WRivr4E1pLgQgeakZ5hEoopZGEYbU+MLx2Vj5xdP0CDcwa7HHqQDx7Hm5MBlnY28BNW9IpO3bFszjan9qC/qPCuzY/jjmLNXm6Ppt4bwH9vOqOl+caf2hEGDd1oCvC5q220gl/c696FvfXPUwyolNRc5KRIGI2gF2mMWF4XaPeVdueYGqyfpTVyaO55C7Rofgp050PvIJIqRq3E2X7Ojh/Mhcal+7q69wuZgPRQkZQrtaq6XHF4JEQ/PsW/JHVjHtj98+TO/Wc6i3YHVQGeFdNuPgBRu0S0DKs0LwVFAJQTTm+NHxY1g89aeg4ixzYgxpqGl4UNe/CAdjCald2gX3d7wW3AZlPU5zfDBg4DddUKWrg9xt528PCRk3qrc2kvr+ZuaBmdU+q+RsefwrEeu4t3qDZkwSj6gsu2aMs42wBqfuspc2gvahuu7M8gc73dRK6GmpHAQgjM2ZQf6xJLxRareboQpmS7VVv8jsJVaMnsPLXU4DvrcPhl4BDPfgsPKqjp7hB7+XLxnZ7ZQJnuUfuuYEBRNI9StfU/Q7a/FRO39pu2XBCPW2dYYSqyJZnN3M+kPximHzhgVn8t0km+JiMn+W888pxCkaq/beJtNR9idKXLwuMeaUyzYeZvJlygKXdB39PP2uZRjcaCf9pvx73R7iJOVpMiLf9FVOCq2Tycwttyk4c7YE/giJru3riXTYw+bCC4mosaAwJLtFK6u3voB/F1M5jTZ+E0AoWJbJcQR7mOokr3ikwCfnweENSGSh7PjO3Xh48teC74ofo4icPfwakrb5GR1pwdZP0Jhaoa/0t1q95FJKIrvH31YlDdcjje8+HLPbftX+DkgSVXOKLCqtxowQo2eHNx/nPRZfxijpsomUv5A6u0t8pRHkferlDq5MuzOe1Ycbwx70AhfWQ/oeTYVbu7Iiwa9mLYT2mEK07GPLNI+
 hjJPNlgT
 ayk0Pm58ZPz+1THODtyaU41lF+f5EQZwfKZUOK0rCV1jdi9hxIDqPZ31zC64/zAYZQDbcBnYChWQkszS8q5PtdeumcvRsgwUCmU1/FSLwpKk+j9FJn8htDwDA5f6h9eB2f0NquVhNlqhYLAegRFI+EJ0pgcdAeHn4fkNTofrGgFR2c6nrax9KDseZGseGD1t43F1wB2H5Km3gn7i8Felt/j5L/dqN6ffcxMUm7stfc59A9DY99lRNOf21NqvbVUj9xO2CZ2/WoVExNbJRnx5qANwabklOoqaiPR5GEq5N+w5nk1e4x6RwfEwJzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Hui.

On Wed, Nov 19, 2025 at 09:34:06AM +0800, Hui Zhu wrote:
> Handlers can inspect this context and modify certain fields
> (e.g., nr_pages) to adjust reclamation behavior. The design
> enforces single active handler to avoid conflicts.

Other folks would know a lot better how this should hook into memcg, but
given that this is a cgroup feature, this should allow hierarchical
delegation. It probably would be a good idea to aling it with the bpf OOM
handler support that Roman is working on.

Thanks.

-- 
tejun

