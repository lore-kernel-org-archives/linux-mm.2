Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3F1A606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=N1rhLlRq
Received: by kanga.kvack.org (Postfix)
	id 736E86B00EF; Tue, 17 Nov 2026 22:38:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8516B05B1; Tue, 17 Nov 2026 22:38:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D71F6B05B4; Tue, 17 Nov 2026 22:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4006B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:38:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AD36A066B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:38:50 +0000 (UTC)
X-FDA: 85446833220.05.7AC6767
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5763920004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:38:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=N1rhLlRq;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794973128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
	b=7juvThalgNXSxoqXCZF6h5OR+clIkXaP9UMHIUWKgPxGe0FJlUNJdC0lb7OlJU6qmaCzPZ
	51H+FLa/gDA3rODbNJGv/hTSUvUINgOfJvHul3igctyBZqtLqBr3ezJPqbDW1kmD2ppFfM
	tLvZQ7vBx22P89Q5zShSTNiDYT40Hbg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=N1rhLlRq;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794973128;
	b=tU48aZ3I5xotkC0Wr3n+xwgUvqetVTUv5K64QRHGTK4SpCGwf8SF6clVZN0BDzfKG/Wbmz
	MTJO63Vf/yOMj1tlowwBtygdEv9Nk6rDc4z5IaTtK0SOqmBH2h+nwMXBugPoBtom4no9td
	Ei7OfSySlhLTKMkvqIYv42iEHQgyK44=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36dbde64409so1078340eec.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794973127; x=1795577927; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=N1rhLlRqhYOEoIgzRjsqow6HgmzRHy7z3T7BkoFjX2EF5W0X0VNnysG1XR4NxC8psB
         MjJrvA5Zvs/mcwqU5DfP8tsFHrtZyDNYH1hjuWWWmtNINmXtIvFW2Nba7M2u+Ox8g7pO
         45yR66XOH3jcnd1kFO9kcO9CUsouQq6pHUohs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794973127; x=1795577927;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kvmn+xw8fMzfurQj4tJUer/fYr30jKP4x1tcbpp4Ht4=;
        b=xvpEQcI7pyDz2d9NldXncHs1ilpWe+Df4DGFlDvFUNNNT7OggH2uTrfGkjTD1hu+nk
         3H7QEG9+EohxuGjKSpu0Ug1GmjoA1W+5pmqPsGHLNLrgEP0/GsAULT+y/KLj5Ub4C7JR
         r6IJzVYcgroDI/KuFCh+xrl3lnumTrUy84/3D5ODGZ/OHzwamSM4WVV41v2ffUJzwZw1
         QIBaxrv3gjc8KIUNhnWYl2NcANHDEOVov22x2CxdDAql3x9AWbhigWz6236qp8MRapkU
         Z8mYwQ5bQRKnSKfegGP1cx3d9p19HBCLetE5nSeMqELQz1pyM9ua4LbZNCLECek++6Bq
         FK/w==
X-Forwarded-Encrypted: i=1; AL+hErGIMCZWplrFV/UzGTFKdI7/C3WcNead9277yUafJHzPYvaGF4i2koqpc0l2xW0rvVmN6rO54Iz6pA==@kvack.org
X-Gm-Message-State: APuU4Z/kyycqjlUx4T9zhSedqxlSWxFRcggNI7I4TBAX3JHN2MDeUN13
	iQ5SLSPPwvCvmWktGD0Mo8MoSXVEjxDgTExxN+nm+Wga5OAI2svzcLSVykdPPC65o+U=
X-Gm-Gg: AYBFou2hrgWoJ3MUMP0lqSGdDAWPDU6B3H4IclDe+DFq4/u3dU/ZTPZk1hRVhD3LyKQ
	XwI9gZsgiVHExPKcKwoFgWzNeJLXALQwsJWIzG8bcaoJFc1YAoqeQhR3IicL8Umdh6KuHrCMZnZ
	5xvO4AhqfW3mgJZboZhGpMyeJTIiS0z5VXBot6tYTjM3rVk4a/mOnzZ3L+DJuc5oXa18QdkJ4H9
	ODN2fwxYKHY07mciZrG7QYkhv4aP4g/Qam9gkvJ23E+SvBcH1bHQzPMV4zczMbOchvG28f246ev
	+8K5ybVTd+6WuDs+bejKTvurywinVlRjH8Ugq75It1H+/bPbPR4SG/5guF4hloelB574FhuPI/k
	/AFt1Cq8wY4SpIoFIOjmU6rIkwUGm2xI81pq6pxplSEiOyl44PoDTnuaeMy61crEVFzopAo4npy
	bEECZhps/hLPwKPNoAC/OlsQAsieyYBMBCJtmZnYId9SR/R/IO6uffOGAy+MCtrhdW6uFsa7Vq5
	vJJrFhyHpFRQSuCu026MPgsYowswLRduWIHAlxo6roke1mut/0s0+G8gBv5Nw15mDuGi48+iHgp
	9ZD6g92PN0afy4wBUkx+cOk1EyTk167e/qDU3QxyQ7ipWg0Y9lX+jHsfgqRTceyLPlMBd/+xg84
	FEsnfUhTtRi1re4T7KexECIgBAMlf9JiV0RDidqTcF2ek82t3ZIl0rv/Dm+/Ugv1MmWQeFuXZz2
	9ih+GOSTc7ZG9o6wfQnxKgjNyAmp7YJVZqUqecPEcs+GSHxrdo2eSiy1ODRXUe0B9d
X-Received: by 2002:a05:7022:fc01:b0:1b5:1a6c:af64 with SMTP id a92af1059eb24-1b543bcd4b2mr1258863c88.17.1794973126774;
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63059f8sm4907822eec.9.2026.11.17.19.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 19:38:46 -0800 (PST)
Date: Tue, 17 Nov 2026 19:38:43 -0800
From: Chris Down <chris@chrisdown.name>
To: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Cc: netfilter-devel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>,
	cgroups@vger.kernel.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
Subject: Re: [PATCH RFC nf-next 0/9] netfilter: nfqueue: account queued memory
	and reserve capacity
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <av0dwzvTBXXLqWCa@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: 5763920004
X-Rspam-User: 
X-Stat-Signature: mg1k7cyzfry9omy3gomw9o6cwsgiht6d
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794973128-848319
X-HE-Meta: U2FsdGVkX1/B60NkuEtplo++qWZ5qE2Jm9ZlDeqFcqwc9aU0zw2wxnMBSeCJR+w2y+vQ2b30A4IF3i94CCtMtx3AQdwZzbFJibH8PMcUCMwKhttpLq8T1MVJbaHtO2yi62SPy5IgY8EQk4Tt0/yCIp1askW6Ho7v7uKNt6oFyvL9r6+wNDJIlnVVNAb/xCMfwoWK25+Qt0OVbHVVNdL9Q+cKcevSwWcHc1i68pUdakGwck+JAzD3c3ioEZvZJlxWnuply6waEeOkDcvVl35OihA5tiIGaZ7cQ4hJBtDd61uGx1QE+9wY6gxiGI4204gBV2jPxWntI6gM7YdXy30Bc/yGsvGSwoQDZpaBxIEl1Z3030VoTDLL1gWRi8I1ffRcQDt7UWg9P8VBpbCBVuSYeLHaUA71Jfj8g2vecmFspJMHQnr4YKjTGbmLHUHpf0Abu4kySiDfx8m9qJH0MFjxEurSmwjvjmCNYGmEMly3x1jgrDw/iEYv5RsHqRoJ829wvFOkyPJwhraChIoo/NuywlmXMdT6/Gx3UbvEJM+4JIeWFIyh1+Cw2UMnLgrHg0GUq7vPBQoOvhbdg4mHI41qYIWrd9pKmic8pDTjxepZepJYzkNpWxjLXVlnI31687ot7FPw4vTTJsG6U0paWc4Gr2I+S0OFoQA33os+UFL10E+V7bGyRGTPnhWeBOVoGo5EJsD/onpB4iT81T9WyyrMWbjjoBjHw2txzKD0q2X3yxFVIA1brmjJAo6F32sEKCOM7iSPC3KYFgRALL0ASY6XiwsoCptGby7EueGKFZ1HRRFITSaZvLV8Isxf/nNBoBv8mWIvJ2muCpuuhkngwPsSlVkcidk8WNAGhvB29d6u8CChWpZQMuFzlmO2c6R4KlKt7tNHzFFU6og3hx/76JoReC6sdDZtc6djUZBfXmm1L2+KfwZJt0uJ89RkAAs5WxjbalbxyHmEhRwBcBTZLDI
 nOL5XnQx
 3cguQJJI9UbbO7P/TKasKqwNWifqC340pDFwkxl2ATl4dmkP8s8eOpnwPf3VTnropelkrPqpSxgXmyhYxyPXExAQzLe2QN2u2sTLJWpnUgdQCR8xUT+jrqLaeUHVz8mWvTMns5+ymxwA/ozoZ7wJtOpNUtkIbivAFasZIyT5R47jXZzbr+uY1JoF62CqAlDhtoiJR5ehiIb3rYaAbek2BlYnACX0EgPmFGnaizDGA2dEdeMRjwySQKsi59f7fI1W5sXZ8IYZJMMF5yX8SQ/9K7diTDNXzRnpttgDN2NRyYb7eYzIgio5BDmf8XDVK5QeHIj0+p0y+ORTH0y/LRqYYua/+RIS/72Ic3EtX7tNWxdXujT8YAK/p7lCZi1i9B8VjAuwcbZA871IBT4oI3vzUHtLreALKuQ5kGyoreJiZXbSSFnAsrSSZ4/4UsLy5Q/JnJsxQThynWWa44PR3GAUjkK0GG67n1TPFZ3VTrHQjP5/8B2op/5g6rpsm7PoRGCvC0yOyu6yVDX25CC6ehLaKWceghSM8DSXk7ClZEZeIuiD/VSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alireza,

Alireza Asgari via B4 Relay writes:
>3. Whether the proposed bulk reservation interface is an appropriate MM
>   interface for this use, including the explicit restriction of charged
>   growth to 64-bit kernels. Is this compatibility tradeoff acceptable for
>   the initial interface?

Hmm, I don't think this needs a new interface. obj_cgroup_charge() and
obj_cgroup_uncharge() on the objcg you take at BIND already deal with root
ownership, reparenting and the kmem statistics, which is most of what patch
4 reimplements. They would just need exporting.

>4. Whether non-reclaiming reservation growth is the desired failure policy.

I don't think so. A long-running cgroup usually sits at memory.max, mostly
with page cache, so resizing the queue would fail with ENOMEM even though
most of that memory could be reclaimed.

>Increasing capacity obtains the additional reservation before publishing
>the new limit. Failure leaves the existing configuration intact. Shrinking
>preserves queued packets and retains page-rounded backing for the greater
>of the configured allowance and outstanding saved charges. Excess capacity
>is refunded as entries drain, with refund work serialized against resizing
>and coordinated with queue destruction. Refunds settle the actual memory

Keeping the charge at the larger of the limit and the bytes still queued
makes sense. Otherwise one could shrink a full queue, charge the refund to
another queue, and leave the old packets uncharged. But, unless I'm
mistaken, the excess doesn't have to come back as the queue drains.
Configuration already runs under the nfnl subsystem mutex, so if the excess
is released at the next configuration change or when the queue is
destroyed, it looks like mem_work, mem_mutex and mem_stopping can all go.

Thanks!

Chris

