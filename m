Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56011CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD528E0003; Mon,  8 Sep 2025 14:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85388E0001; Mon,  8 Sep 2025 14:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1A58E0003; Mon,  8 Sep 2025 14:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7598E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:12:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D7135797F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:12:35 +0000 (UTC)
X-FDA: 83866878270.01.FE14DF3
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53A8CC000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:12:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OTQ/fPJh";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757355153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uj4ReL0NH0lAk0pIHHnSUHGCYEXRjz9HW1ZVSj9cAuU=;
	b=gv6+0lp5xcvHy8KMTVGAi1+ocl7ojWXrDRdudXxrOcE9rdewC3LdfxspDzTcmB6Wayuv0H
	lHYMUOOZlprjDhBvzXeRRqZEy6njAca1sOaMkM3fqs6H56KB8n+TGqqSbWfvdC3/HK3pOf
	dpiQWBi5xC/7ZLTS9YkzxrnKZo8AXxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757355153; a=rsa-sha256;
	cv=none;
	b=OMtaRPzp1oW/m/qma2ssiPw8KjOw6BduvFSw+72UbvPwg2Si/ED4Ajt7jAIPVc6JY+Rzs7
	BZqRF+TGLLEh50WZK5y+B9QPWSF4A771VhyfHRi+r1X8Q5l6ZXqPDTIgbiBdVLqFKleHkj
	ZByks//CGIjPhft/Dw+illPbt9XcIuY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="OTQ/fPJh";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70fa947a7acso13224936d6.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1757355152; x=1757959952; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uj4ReL0NH0lAk0pIHHnSUHGCYEXRjz9HW1ZVSj9cAuU=;
        b=OTQ/fPJh2XMpyFmQbqm/sT2cfyI59CM3biNsJCZj63AJGvUrmjqDOq4mxU2LSHex5u
         +xsa/UhAR0ihTQSe1pUfWng1vtkoT4sw2dIYqJ4WFkyuHEzFa570yNbVMA1RihTvGGth
         xEEwOe3HbZBE+MjBsLRtWwdHERi/675HrNRbAHkJBzG8CvfLGaBAZXWeQxgI5Efne5rN
         b1X4lIvqu9/xTnBdMmz4yyWrenwvU10SIevYJdAyQKnal4C3M+pVn5tx2B+bgBTk5Kq7
         dmC41jz4lFs5lYrFaiDtKEw8BWtzIEFNtIwrBmpF/OXZPaBkpCAOBRWS7jv1liKmlzME
         b6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355152; x=1757959952;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uj4ReL0NH0lAk0pIHHnSUHGCYEXRjz9HW1ZVSj9cAuU=;
        b=sDS00VP9OvTlFqe+IUhb55s1imYz8CZwLkL8cwYiWj8uWw+yirz9A1uARX1ckjIHvd
         Z3xa05lAtMo5pL6h2qx20+Wizwq2HPe/Scq+uSaUzrMu0Bop42iIYaJOZjNNyNA5+pk8
         xF/Ab2pSnpHPpbcrzRQclIY5cHFCkRRP4DXiu7eK+oPVm7uZZZopx/xVVxVOV9wBo8tW
         tsmjhtjtEu2LyHPFMkN3MNqvE1ArqX4ZDgQAbQN7ojNsg735IS1gTKQlZIjtGQWoiwHG
         vTpgv5LxK1XoJTX/nrUh/twZalb1L9Kquq6LobpH38kuCktE7TtfO0r/JvydvLVhLs0w
         BByA==
X-Forwarded-Encrypted: i=1; AJvYcCUyOfZLU4eA5Y9TfRVFR9l6jEsoDHQn5eQj7+oMInSuVqM6HekelDo45nByRTfffS7coLOWRks1WQ==@kvack.org
X-Gm-Message-State: AOJu0YzpFHmATZHc6D1yJ0qz8k4lewz9zO/HDZFQtDavlZVc/7qtyDJg
	fTP4fnVDURJU24G9dNFF42pZqz/gckbFsSBuLhac4HQCOPOJE+/te5o2Bkle05s6yiCSg+XNkWd
	MToxz
X-Gm-Gg: ASbGncvlY/TkIpbhmQQwM+9vlQTFQ9O49I5wIsre+BHyx8+MjLiOCEmflbaZPtbzZEg
	8b8pq9uV+EbYbUgcLG2RtU/hbidXieixF1Sx+zz293rp/xMUz2BoGobUjJEyxfl5kaXmzngtfib
	vYiXChtd8+wtv9RKgRfqIRfFL7HXycAR0oSP5w/r2nUZYjIqSiEPj4S/Fszla2BG2GSZcO5Haj2
	rFLrOE4jxEUfU78r/pnRH2cZBdjmObilMX/pOOmxGeUx6t3XlpCdqj262ev391pIWs2Cindc4pb
	LgdaU5XSnVQ5TIPnKWtszqYXrY9UafdC0cxa5edMjEZxMNjUghTOcQkVigV5K09AS3TgW24/Mt9
	6uGcgjYEUm1JVT3gJPqPaptnJSje1syheemOItQRCAPmoiEhB6faWQde5uFrHxrIHN6KakJuRTp
	skMGGueK6Xqnqf
X-Google-Smtp-Source: AGHT+IHkQPfYoxKtWu7CMTYM+b3wnO+oGNkhruiQEKn/RX4SytWQAfGxekDvg/b0gwP5jynytPYZQg==
X-Received: by 2002:a05:6214:5281:b0:706:aae8:ad48 with SMTP id 6a1803df08f44-739403158a1mr78540096d6.35.1757355152367;
        Mon, 08 Sep 2025 11:12:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-42.washdc.ftas.verizon.net. [96.255.20.42])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7243de51ad4sm109175846d6.53.2025.09.08.11.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 11:12:31 -0700 (PDT)
Date: Mon, 8 Sep 2025 14:12:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, joshua.hahnjy@gmail.com,
	ziy@nvidia.com, ying.huang@linux.alibaba.com, rakie.kim@sk.com,
	byungchul@sk.com, apopple@nvidia.com, linux-mm@kvack.org
Subject: Re: [PATCH] mm/mempolicy: prevent the risk of division by 0
Message-ID: <aL8cjd1mIAamBzXo@gourry-fedora-PF4VCD3F>
References: <20250907160829.91628-1-chelsyratnawat2001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250907160829.91628-1-chelsyratnawat2001@gmail.com>
X-Stat-Signature: 9rt9iys5yxtip4z3qmjxys1ny3p7ud7y
X-Rspamd-Queue-Id: 53A8CC000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757355153-28753
X-HE-Meta: U2FsdGVkX19/p2UETM49lPGRSxROZ7/GJJ60VEngO8VPPtpqkBBpZ9FbfWlFcyajp66vMYnqnuCUNi9OVicLyfNE8i+rJa5MeFxfqlXZfpPhTVe6a8BCElqYiKd9O6oUOpaK7uo/E8MUYQGnp8H7FUplJaRt91Kk1pO8gYIusZhUea43agLmVEivwJMEJGvzpdG7dNbfBf690SOK9ciiEjjDig+7CDuaPs0qV+OPGViyTG8riBQ4lKTzNrNdCxOzAuw16esq7Q3Sve3ojAfLjbKozxJQn1noIic9iXh1Hvc/R4KY/0cEQdnEFT2ho3Eg+ZJFtsvrjle23vm4JuKRQ6dgybHDWQMpDXHqnTzwu+UGwjistB8zfDtl6IQnAJ/HDFOADwpZe4Ke30RzzAcorUMOmI5LfooSmJIkVTZ8KDi8t6Rz4rOELL2NTjx5kkf8khhyaj9f0GM4spv9wWhB25GR4atnAAOKD0asSiUG5HYtikOtGhO/03MMbcjo/fXZZn1CFGn5m1wgHVVXy5+ohWEL3d3XqeeCn7PG1j2bKlDOKlIiIfmfaNqfE1KQUPxlJJFFlU9xmWiC6aEspmyoxFa5z/jUAVwQI014srJVy1oRA81uGExAkwXcLlOuGzyB5YfVWD8EvqH5kqbHH9xUI8NFLpRTNWrpqr3qWs8F5mlD4T5DG3cOda8BoH9B0H2HMJIBJlkfrtWJjDxKXnJ/AmLKqwmNXcR6Yj1rdRQujisbRWrX32cDESy2v+nXhM/1k4BmuKpA+0V84pzIFY/zqZD7+i1mFzcQQfDb+oCFVoqvDtPnRMeWg9Ee79zVW7EO+yB/sv3nrOcH87CwmDzUVCIaseDOE7m9H2IrI3mn4zPm83b1J5RnpMb6zgpfPDMQ+ZaNsG2yRrLtDXfUFDdTqkLSoTUqAn8vGcx3Nmuhndwsz1MoVDh5GaVKdUxKf/TzkEiSMZYRStVitCGRUyN
 vnnhRJEs
 kvyD8MYDbiwH4jASCKEgupvLjeAdMeFk2iWX1Y6wwwvBc5VyJC5l5JDfQEIV8oTlp1k0+R8jIpqJuIkt1Gsgc0HIJ8lfqRs4Phza5BnTAgpglQPeJRcFuOmeJiNR5+DqfKan2V7H8/KfVUwj8ZPG9EP4rq1ohP4vmk0GyKck3FnbGsmoCSLOVH+qBOcOL9Vo8mrO8n21i4gPo15NNyuW+1HPbaxYyP9DnkbsTF1HYX68kbPozy0u7Trsc2w/N+MS85iqIr9nGRBNhg4V50oIlI6lDHHa27nvYz4lZSPO7eEOjHg7pKgul5VwnuNHNSLLFgGkxC2pIz0BWHDE98Z8U44VhV1EWfMCussCPQKcDPRcV13FaQUqxVngkyrHiZwzOh8PGcqP47fpn07+1ePmoGCdo102z1+Nzw3LiFVnCjBZcysY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 07, 2025 at 09:08:29AM -0700, Chelsy Ratnawat wrote:
> If no bits are set in the policy's node mask, then nodes will be 0.
> This patch adds a check if nodes == 0 before dividing.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index eb83cff7db8c..faacc604fc16 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2530,6 +2530,8 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
>  	unsigned long total_allocated = 0;
>  
>  	nodes = nodes_weight(pol->nodes);
> +	if (nodes == 0)
> +		return 0;

3 second look at this code would tell you the only way this can happen
is a mempolicy where MPOL_INTERLEAVE is set and the nodemask is empty

The only way this can occur is

1) someone setting that explicitly, which is invalid and protected by
   a line in mpol_new:

   else if (nodes_empty(*nodes))
	return ERR_PTR(-EINVAL);

2) or a rebind event occurring due to a cgroup task migration or
   cpuset change - which is protected by a check in the rebind:

   if (nodes_empty(tmp))
	tmp = *nodes;


I doubt this bug was observed in action.

>  	nr_pages_per_node = nr_pages / nodes;
>  	delta = nr_pages - nodes * nr_pages_per_node;
>  
> -- 
> 2.47.3
> 
> 

