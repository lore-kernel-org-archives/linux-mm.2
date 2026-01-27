Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6D3DD2FED5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 18:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4AA66B0088; Tue, 27 Jan 2026 13:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8606B0089; Tue, 27 Jan 2026 13:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04936B008A; Tue, 27 Jan 2026 13:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DD636B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:21:17 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 419A0C182E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:21:17 +0000 (UTC)
X-FDA: 84378560994.26.83779B6
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2B93E4000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:21:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tSyAeuuc;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769538075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRKi3EtRrwoq8B+JttyIY07IcL3E2jj6n+oY1r/9jo8=;
	b=PdX6V2r6xxLTiY05ox3PcQOc1X0tgoD34StV2sm4aM83ugv6dofbkUjQylyvwj/wbbtxKa
	5tmQZEy8EDftjysKZU4gOGdWf9dlmrUZDGiMd+6Kc6OJGCxfBWbN2/42m+cts5sxx63aSG
	OBtySNGhEeNE26Rs0yixSwONUDhXP38=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tSyAeuuc;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769538075; a=rsa-sha256;
	cv=none;
	b=Q661r+fxsZTK7Sv8FOJrgQyWIfQRWDgsLqz6yhg7kyKjBo+O4x3S5LBm+C9zWs3thZxUg1
	Lk/+wE6Mo7LNAPHPPaVG9mQrNKd/B6egYMgUTcj/UXlNZuaU3lcylspH3qghVH5TCsYR2u
	5adZhzOxBzKvxB1yxjetxFGHGOwMPZY=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c52c67f64cso590888185a.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769538074; x=1770142874; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KRKi3EtRrwoq8B+JttyIY07IcL3E2jj6n+oY1r/9jo8=;
        b=tSyAeuucLhaFVwRRcng0bnA1mzrLFAYtdXhRyn7m8CULaRCCpsgJc3s2FwOmc//1Mz
         CGt68cZ/0fA0CFGn3JF2cJCbWbBIKHBAuuSrm5Hu7tR4ffLeu1fmEyVX+AzJixWxTcM/
         MucLnuO5SABSek+tXpn5gU4a/YUDxd7jKrVOmmU9l5HZ7DMDmlpVs6i2t8ByVGoH47AX
         Ox9aH+KaoC50p/+h9stnZ1ReWEw0PimP2J/Nh+g+LSKUN7jiDTRzyntZq++Ba5ob8gKA
         eTMjeB5bW0BOVATnnXLk8gAwGV9krtVSgqH5jWisS66W8Q8F3Pou+nBX+wTtjaz37Idz
         Zy5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769538074; x=1770142874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KRKi3EtRrwoq8B+JttyIY07IcL3E2jj6n+oY1r/9jo8=;
        b=Wqlv0KPLWBK+/f0a3zSAda7/c5e3MPwm3C/VPcEcoQH8bvvedXi8K/pZkMwtQfZSNi
         LnwTyZRUQVAXD8uM3litu8DIxx4TLM3/m0JTdu2Iufg9FGGlnartFUIGxcoIBemfNbcm
         +AmMPzmGFEEjW42fL72N+RioJJhtcQzO4sSKmPMLLPyegUEQRUEXZHxAjG26NE65vx0B
         8zOy8mkYqNnLokEgpRLoYnmeWlYmwqq6OUMteNsHEu4H6CqHnJOuitZkkKVhjxbwjz0s
         2qXD+g3ZtDfytjUpDCdmAhPBh0/ykMsCGAUl4i2zj7JE2YGVngnLfUyujI0SBOQkpxH+
         N2Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXmE5WaAzbvhEDoWE3X3xbCuPrHy48Y7UbnO9IlhSX1iJSh3L/YfVXUbzF9RK8BpieZoXv5Yoah8A==@kvack.org
X-Gm-Message-State: AOJu0YxrHrRkXBztzaFdp9uauaxG5AufXZ2BHutgxj266dJJA8f2KnMq
	Dj4gQBI3mKfOWl+rxiMfMftmMsvR38KvzUZ0s7JC6C2BQzJlfNuoXByWdxY/5J8BmN8=
X-Gm-Gg: AZuq6aK+ZLdu8H7HGK0xu1p2snzNEyLcxueJG+zwde1mWukQBg128b2DO5LVM8V1pBU
	PWhZxgtOieu8ALoTaiHCdn7PMdUZf4T5yyEF2fhbh4vXBfwf4RyAZS0fFQM93TH9R2EbSwsxEYK
	v3gbNd7FuKvE/7JrpqtRdhoJgZAfHq0lF9ChSWyP0YAlkTUMfhJ+Wz9AP6H2pgh4k5cv1nDBt76
	gz+/uUiSqgzBZsGVFCzdKplMpVc8qJEjbdP4OzWQr0fj6Bgw9oU4EwynsRNrq7SZuST7u7QiaaZ
	7Nd0NWzG3Fjll6a1VhHKv9h8vgQeC2F2iUyj+DOXJjdPkPbdX70jpVWOtDjmOV8xgjV+NQ9mndz
	c1Fe/4zhCE0f5pXi9u/niNvarY2S/Kw4ACHRP2xqclq+Bc8o6SXE2XV30UvynSZSXss35J8blB7
	VIEhzcWwhb3g==
X-Received: by 2002:a05:620a:f0d:b0:8c5:2b63:2d21 with SMTP id af79cd13be357-8c70b930124mr339909485a.88.1769538074072;
        Tue, 27 Jan 2026 10:21:14 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d49c2bsm21564685a.46.2026.01.27.10.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 10:21:13 -0800 (PST)
Date: Tue, 27 Jan 2026 13:21:09 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Hai Li <hao.li@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH V1 0/2] Only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable
 caches
Message-ID: <aXkCFYWvbpZB_5oZ@cmpxchg.org>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127103151.21883-1-harry.yoo@oracle.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: tdojd7uc1z3sc94o5u5aq6u8z3s4xhmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B93E4000C
X-HE-Tag: 1769538075-21894
X-HE-Meta: U2FsdGVkX19HCZIFcKpSc8dsdWQRoe86XKUIgOTej33TnDQRbQ0eXkwtmeit9ddJVeUFL6J6McENAt8tZHmYgwrSVi42SVxRcvzcAZJ5CRx2epqkk1oonVVYksIB93gOW6XVq+PRbjbHz4il09dr4SywsS/Ga3Bb5sNnpYpp/AdCQELZshb09uoF4dQigbCK0ad2+3QNeBRHBiaPw4mEm1eiGBQPrRBl9S+ceDqdcH7P3JahxX9WEx0ePgJ63q9xwpko4/w/Rx3YBdoHcrrZ7K+OGELQPsG/1VtjCu8CbEg5grJny5W3YCSrOdPxd/ZETNamHJRgOIucsMCQu8SYMoDMzczwclE1hxx/l6srlruSQ/o8BmKLUN+hhSaDn2vkN8PzjY4q4nq+2EpD86aixZC29+9eQwyhAFd6dzrR5+VA3p1U/GO7xR6zyLGFM19p8zYLp4MYljufyY8dQCxHLIYWDHlWRITV4/L7ygJR0tTdL0vH9J8RC5agYrrClevTiZbWclC2jcJTj7j0sYSCC/O3nx5/uZWtdE2Bb3fKj0rQCBMIJUVQfmdJtZzXwa22kKmM7SQsvkVjVzY9yYlLa8VMV1LK6gp6NiRQdi/akK0ssOP7ETzEsIL+vF+xIHityD8z4HWiwoBDNgyWrrBqfdkrUzZU7o8+HaDSYF85ELHr/96IvE+RiXzA1XaYou5fxMNs8sr/p+1p3RZ4XFNjzHCLKjp6J4fSymSFrWgznZMwOg6z1GhByj72jufS3GAaZHEqRixv0cTgipyKpHIbEYnrSlSBN6PYheRL6aFuM2E3rOKOMtNeVv6xXg38JAFSTAUodrQdTcj+Dh1ALcRwqdolhQ0PJpGQ7Xys5Ayt++0V1UBqQtl9yP6lQm2Ezhy/P6N2it4+2noH0pX9+JRXBISaEtfRSXtQpLWHO0Yc6zfvebiR5R+DR7mRc7xLD1vhiCHO4w0l+3MzBp/V1eq
 3U9VaL5M
 vusZUgyoiNbU57EDuzJhOIh+DbiZrWv4cBLQaumrlV0XKDsdv3n4lC3gQC4EmBQJQs04p9FHXDro0oFy30JO+FWcQ6gnmm1Rb2VUb8eWfbDlEkfxOYux9XpOyMzSY3yfXMeSFPSdBOu/Sc5n0eFPKRcQyla/0OK/Ka/dqWyDu/O1bSU0TfhFVwTeDTF0du/FH5us0uzhiddiNRP6TCuyIe9Oi8bDRSl7VD+A4xZNCqbRZrjqFpJ2NP22/Czgf+FU9n4yt2sdCQN7EMGpL/23m733bghyRlP/6vnfCuT2k11hoNs/KvJ6iPbK/jixuY6d91XkFybALUXIQ+hgw1ApqsmqxzJThTsmDeUbhV26mf/5tJno2bpWko8vyzmLE5aCpDtzVbiIm+tVeAAdpxL6myIG5VH1xEypBCz0GkruP393Ztn16VSJWRRMsQWZ8yX5wuJuD+3c3tqUXK5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 07:31:49PM +0900, Harry Yoo wrote:
> While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
> slab objects, it prevents slab merging because merging can change
> the metadata layout.
>
> As pointed out Vlastimil Babka, disabling merging solely for this memory
> optimization may not be a net win, because disabling slab merging tends
> to increase overall memory usage.

Is this motivated by a production issue or a more a correctness thing?

It's somewhat tangential, but we've had practical problems with slab
merging and ended up disabling it in the Meta fleet. It makes it
difficult to identify culprits when there is a footprint regression in
merged caches. IIRC there was at least one instance where it merged
wildly different lifetimes, which raises fragmentation concerns. In
the end we turned it off and noted no meaningful usage difference.

So I'm curious if there are cases where it tangibly helps. And I
wonder whether default y makes sense given its observability and
predictability implications.

