Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAD0CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09FF6B0088; Mon, 12 Oct 2026 08:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB8B6B008A; Mon, 12 Oct 2026 08:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0856B008C; Mon, 12 Oct 2026 08:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71FE46B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:45:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6B06160D57
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:45:13 +0000 (UTC)
X-FDA: 85313944506.01.DE40D63
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id DF87A10000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:45:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EqhTn7xP;
	spf=pass (imf05.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791809112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxDcCA7hpgDYYxgdhqPc+1ZwblatM2CFgvbhhZn3Nj4=;
	b=qGzFS1oeTn4zXg23C32eW3xEYqaiGe6BE9kCaSHitE+cPtdZAg+n3wviYwjkeRaVmTnHTu
	iC4zT0T/kXvGPvTzyXgas/1AkTp1ejxOJI1D4U2CEBHhB+jWZKtwwsTkOM/6HMem/l2dsJ
	uUTpskyRaWCg9qAMi/N+9D8bCubHYw8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EqhTn7xP;
	spf=pass (imf05.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791809112;
	b=PmBcfGsEEWGpA8pRPnUQSbaV4MO2bqedkHGN/SSrQzbhQyPs8R+F+zmHuh7+Otyzq3jhUc
	G3y7G+Th89dMepr7anCI+sCIL2xOW6r3FPL3asYSNA/bK3ugCOtxJqYObMNBJsiQYphLEo
	dnq7TDu/JjWRup8vN/soEfCDFUkXd2I=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48af27fe287so1584972f8f.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791809110; x=1792413910; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pxDcCA7hpgDYYxgdhqPc+1ZwblatM2CFgvbhhZn3Nj4=;
        b=EqhTn7xPB+wD+h8Bypi89r8jsR3bDTRyKoUwGqyHA/6z5nEPRc9Czoq6Uqk3vjBHl5
         w4BsgKrp5Vm9r0HmSjPmtag9xCUStR390CCH1wC9WuUUxErTPzzp15iE0rV19fyiD+Rj
         aSWmYLJ2XIpcsLLFb3Uw0I5dP2eUq5gWdBguV3BQnsOM0px/xFvn+U76FtT/Gu+0PqnW
         DivIj4C6xXRvP7cWtxf85E7duzUESX8JPLLDGpbD6PHghgiWGqSK5Y5WbJaC5MbudBcw
         Y23gtJu14YZCFyMFItsXs4fKa6LjLYP5IMy1YWMeZM9if8wAzhPGa8eTW6F6dDZBzoTr
         2aOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791809110; x=1792413910;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pxDcCA7hpgDYYxgdhqPc+1ZwblatM2CFgvbhhZn3Nj4=;
        b=yYleOf+d3QNlrjqk0Y6pqCS9Mvz9Xjy6R78ryifZ0diu9QJdFW7MAIQySRSwrOYO+T
         7hIYKN3T3WH5TqAHXXtlOvWFigVHOR+sUYhV+pjXcAvvfobKy004JxUp2ss32dytgovo
         1eggJ8oJQuLdi9Cdpc/1CtSoerDbV0XoTl1cv5Vw3vK8ghuubmAtUyxpadIyx0RDinHU
         uIJNGNEwMpFnrGcli9/IdulgansZHtJzhIff5NjWDF/CL62qnRkMAylFeQkinddJBbWg
         PtHC8+tqkhy/dzIOyAYlrRuqNWlST7jjQL5Oxxgrl3JR7DzvGRB7p+ZNBZFKUunESy1W
         H/4g==
X-Forwarded-Encrypted: i=1; AKwUvBwZcVzkVfpG7rtq65RFVxFbcgf2PbxTJzvpUWrAIz5/LGYF58+1EW+j64eQsOQe15Sb8J1O3JYFvQ==@kvack.org
X-Gm-Message-State: AFq9FYJNLN93NHF+eX4ITlrUXoaaujunveLr8Qbnbcm+yAnv6NptbRdh
	9shQyUepnYsmPZ67i+udqTvCTc1MR8ylYa5iIzJfTv/NNOMw9DPJsoDPPDUdTT959J8=
X-Gm-Gg: AYBFou19db+DwLVbvwJ5MZdqPYfeDow/azkxK2UoolQ877jtd3puwWPF/VMuPnrvNNv
	bqdV35jK3y2kvf/Y17b4YPcLatW1YJlYpCyccj7ijTllBc+VrZ7jenLjayOCFee6wl2g7yjJtXN
	Vpji5BTly/vmuB+cc+ddBUcM9ool7o4AI+b1eL15AfttiSVm9K6VdqeqxERxsuITzUYTPa/3wRq
	kY1f5BlMhzj+0PhweNC7JxQuALh1wHlSng7c5eeshrX6qF0r5IP5WkBMyEAdrTAlaLj2C3+HWQf
	aUm2O9qN6o5lK4jrxq+MpnJ/uSZp4mjvgfhj8OHi+mz8rV+P2b1cBnqoFfwLubw1LE2VOBOmX4X
	GinWm9WaseFw9kROzaTn82un6z1tbLBgYLxJTATkPiK3UnD71B6ew8h3L2WYHA2gYz3BwWyMjv5
	MjO0yTiksu6MeazkJ620lEsagjRIM4SgUzMKW+Ch83RWFfzmMl6sN+ptc4LtGYsQtzNBi5GhPMp
	A==
X-Received: by 2002:a05:6000:160e:b0:487:27f9:842 with SMTP id ffacd0b85a97d-48dbace9d4fmr11992821f8f.55.1791809110413;
        Mon, 12 Oct 2026 05:45:10 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9ac02cfsm18344889f8f.39.2026.10.12.05.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:45:09 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:45:07 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Amir Goldstein <amir73il@gmail.com>, "T.J. Mercier" <tjmercier@google.com>, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
Message-ID: <20261012-grumbling-spearman-3a313ae31198@there>
References: <20261011223358.2327625-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lgnee3ewncxbl2us"
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-10-sashal@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF87A10000C
X-Rspam-User: 
X-Stat-Signature: ob9d6xh9ow1x8jxgi3jb65srphjotr1c
X-HE-Tag: 1791809111-721188
X-HE-Meta: U2FsdGVkX19+8O7HcRaBIE5sUCma365gQ9xiCVY0f3pTBJZmzZc+UAc9lQg+l8//5zPRnEpH/gFeMjmsox9R6oVmHmpGG/J6xWnknWN12T22ZgafkdaBdJKlz/Tr9cf/O8JZqmgROHrCC4qV4dqla7hszkIao8VAtYOtgAB4NQ407/gHNIO7syLyDQOLicdAB4/Er1XKRPV9t0rcaMnv6tTabdMbTczg9y+dpV2DQh4+IW6aNekRQsEdf/+3vSQet56FLxoNXL32G3qLd4p5U5WMoYjUcbb5aCUXSDYpxKhQq1sXEHHqhbJrYwXXf33JbxS5CAQzvx2Y8DUTmJPIjBmkcOu2G+HnK4ZoARNgaj4HFDKchNUXf4zfkIAA28O5DFSVpSri/Kg4/zZnwSb9VOSKmuBeY9I6SAq4Kl28a3QCbJsgMsMzyKRckOYdjkKfwzk9K/dnWtm71uLv+qzgQ57TCgFuvFc60O7HkE77zAf48UfO/Sv1+yPswq8syFsQcLR0du4ZPZMpYclID90k7mmNfD4fZumayrPJcHQjZ39ShQw3OuBA+Q2mK1kbUQYSU56GR2buSN1CNWkPQ0am0Nm62L3GYMP/kn3CaNXf9VcIH9gvxbBmI04mhmE0BNQsaTjJ3MSQaIWDb1wPFql62rNFW3vER4SyiV70MiRtFBNQNjI8AIi+7XUvHzAWJ22yP4CTj993/jodI95FHbu4VgOQGAPE0Do9WKqOiJrcwyD9IfNMFvgNXnd9eUTq6eEgRnJb/ZFX7q06V9M8h+6bW2jCpfZe9oztk6csKkW+cgRY9fv+cfjlut/WCVfdlWeSmaTyLK15pV1cyz+o8YEnvDVnYDxNqsZeyJGj9w6K4y2bYnj72WUy67fAypEA9+VCcLUQMHr0a3dg1nFfG0ppVKBjkGDPsc8xFdjKQA6kfKwfvc7NIbC3oJPdPD7tRsqYzmwfRFOGhmzwNXt4+Yw
 gaou81k3
 7oUMZvyWUqYe96zyAz7jHcLSEWHZKZrie7OlmkhcDJTi0f4EV2VPU9nMjrVXQ9VjJ9nY85nhs1Wt6A6IF4AdtxfDW2IGXtLomhcWOv7qasRIdYk+QrMb8elASuccg6FvxSFM1EqzvcX+Lj4Zl/gCQXbLY7U+O3EPs8LAQ62j+yFnUCtVPyC6sp2xui1JQB2JHNdTBbhoh1fF7s8CrvFZGZRA+DWs2WJwtsQwwVr2h8WDRYCwO5pGc8V8z8xBdLKpKVd+EMfwEJPAC7g9Uy233d1kj+5Hy+H4yYYDgULd0H05vq1GMb9KuGSEMlqcyXt+lOOPy9pJOOfqf6vo+LKGyv3iNG0cqm8+kF9ejLKIYfcszkEGPxk3Y99+J2KH/uxtb3Nfudj6K0v5EaF0gT4v1JOvOPtSOoHob2WvFwqL0tkHA8wPGz0sDA39wCjiOGHXa/fHa5oy86/J0J1+WwbNorq7PK8/lAmaBHFvpECppMqqvPEINxC4rDGEJ0765P5MYmIwF1QWl42UhRg3IKv3pTtodk0Z7TtmzdReNZvVRkQOQTxCKFiFZJpMKL42cGi9kARwi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--lgnee3ewncxbl2us
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: free the paths returned by cg_control()
MIME-Version: 1.0

On Sun, Oct 11, 2026 at 06:33:38PM -0400, Sasha Levin <sashal@kernel.org> w=
rote:
> cg_control() returns a path allocated with malloc(). The two callers
> that pass it straight to inotify_add_watch() never free it, and pass
> NULL to it if the allocation fails.
>=20
> Keep the path in a local variable, check it, and free it when done.
>=20
> Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-te=
sts")
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/cgroup/lib/cgroup_util.c | 13 ++++++++++---
>  tools/testing/selftests/cgroup/test_memcontrol.c |  9 +++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)

Thanks,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--lgnee3ewncxbl2us
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaszWTxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjYAgD8C3rg4DsOngu0tGcoEsvc
5NuTbUsIxMtIYR1QnuiqLKoA/2ZVZusoTfiU4S96kRaXYt4cG9+dSPS3Il16Cshr
GREF
=nNP1
-----END PGP SIGNATURE-----

--lgnee3ewncxbl2us--

