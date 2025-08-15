Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DEFCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFDB8E021F; Fri, 15 Aug 2025 19:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439DF8E020B; Fri, 15 Aug 2025 19:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA598E021F; Fri, 15 Aug 2025 19:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2318E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:36:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FD3482938
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:36:00 +0000 (UTC)
X-FDA: 83780602080.05.503731F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id C90E180008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:35:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1KSa3iP;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755300959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcqbcpR+PPLolCotgvnuTTzNHDIi6DR9EnEVb+T8qy0=;
	b=ipIx5MqTqmRCc8L/fopkhKwAX+srCxz3iitYeZ/kaJWZylhF1nZjfrqQqGQxNRBuwiUloP
	WYCUyRCShWKbmbd6qN8637+NiEspK226gCtQVypYhYMhe4Ix7KzxIwUd6Z+HVSWy2f6WcX
	QuP2iR4v2thY97K+E6v9uUxmgkDavxg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1KSa3iP;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755300959; a=rsa-sha256;
	cv=none;
	b=E4bkHCugDLPC2gQ1O+4jyuMYDoCye5IY/SYa16QP8mYSTFs35bbDYzTl51Y6tvW9t1N0U1
	ibKBJvXFsUx935cjPvm+ilUYEpRVHVQdxi0cwY7OnqQEhb4P40SeJHMpqzAESsC6TsjhPC
	3BWmSw61WVBx1MZAhPDquka9yjITK/c=
Date: Fri, 15 Aug 2025 16:35:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755300957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lcqbcpR+PPLolCotgvnuTTzNHDIi6DR9EnEVb+T8qy0=;
	b=I1KSa3iPECj/Wsi8SDf6g94yBfaB/ykJX7hBJxYk/MeurOgwRt3Sk68DV1gE7JOrcJSbcY
	sS3o3rH35F/X4THaHv0DGoc/9gWC8z4FmjfuNHO+JP535625SiUr+N62DFZU/dW5FX3q2H
	0O9H5Qfvt9jxbHkzIs+OHmZyUXbeSCM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 net-next 03/10] tcp: Simplify error path in
 inet_csk_accept().
Message-ID: <a53fhshvazugtmvszdak5j3arzpf2dkiqy227bredme6drt7cj@5vlq2zyeyv3u>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-4-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815201712.1745332-4-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C90E180008
X-Stat-Signature: 6wj6fisj4ikosot5x4oqrtgcd8endmoq
X-Rspam-User: 
X-HE-Tag: 1755300958-630190
X-HE-Meta: U2FsdGVkX1+DV9sW4aJSJsvtPerQz/CoVWgm8Y01JorRHZU9ezIu5mtFmZPQWjGa6HsK31nGfS567MIbA44nKsJBop8e2ozUgkht7VmQpcEcr0CJhzk8s4mlkiXxOaEDV92VB14QSkYer3ihpSTBGWbJ1K1eq6nfmaKHvPdiGvHYX165Vpd30mtkdmnwsQ3DGFuK1CWNBZGVTGu0LFWk5JGAgmOitzpnfFHoGSSfl9JeJO9zfDxQos5fBmq8DENtmqWkLsxir58+ZZyMKi7qZPSewsqxGbIMg/8Oc4hxcQq4th9wYG5CErRixlIquYApQH4sX3boNGEFRoVkXHs60OwNyLWNy6QIll1SiqxglcpBk527UMUWGKg5bMeOdSzvtTWNg4gMz2zloLQbi9MkFa6UVIB1w6bxfaGwOJHBO0Iv99weYBB9v+7CxfGIo4fD0D05cJCF+kFCOpDZhriNvWvCiCRgXFeQsDzkJKyFqNMrO1d1xmLHjAQCRUOMQssQWfTMOWq8vjK9Lp5zCcd4hUJ6RU+6ns/Al4T+UegW4mHz+xQalorc59i+6cbXKmb7snVG8qQ2c5QfXWOREOR1+9fKr4bwaICidu5LsIRjIw34WDiUd3CIy5CdoHukwT4XRLKvTraqXPmHjDJzxsxtBy1/WXwQKr7y77XUK6OP+An1/lkC0U9kYPzboky4uf4qz5GVG4rGb15kgjcHBYZASr5ZpYM+hDH12d9oppGUB/8f2+bpNfwa9s3VAwhHGts/HKQVedoWvsL0vRuOtDOz0LesXXgTHuD+ypgmkrX4aP0rXXPajW0DO58TbzdiGs3wnPY/ltzRyD2nnPcKevPW+uK8xPSCVRdO31FYV+tLTA2X0Yp0+9ivKYwAuTwkvTRTmeLyDaRa3YvOKsYxpfoJHd/Eht6xAbVEIup+oHO7Ac7NYro35gpdq0/lblBL2Ncgknm4Kby9HOIntzI1gJJ
 GvWTOTjU
 DpuuVEGX759qNcnP81A3sLuqje5T4NMS7YFqw+WymuN7AtKdSnqScS41OZFZrmNiQLSCLFXTQvl2jNFa/CmCt7wEcBI1J2bE6QYgECY+7CFdOcCcf3OWwNjAjq0/i2o6+E+U7vqfBwvJdL08NK9TYK14m6OZRSwjh93jBbSmgTJ1ElAQen9VWgNOPLPXvf6zwmzuocCkzs4XqiZ4BXds0malnK+MaOOSZRqXNfm8OUPNcotcuadBpY7PiFqKW1VnpnF4hydmenWEz/238LR7/0yEpYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:16:11PM +0000, Kuniyuki Iwashima wrote:
> When an error occurs in inet_csk_accept(), what we should do is
> only call release_sock() and set the errno to arg->err.
> 
> But the path jumps to another label, which introduces unnecessary
> initialisation and tests for newsk.
> 
> Let's simplify the error path and remove the redundant NULL
> checks for newsk.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

