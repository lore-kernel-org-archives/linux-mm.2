Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B0DC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 19:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC82C6B0088; Wed, 26 Aug 2026 15:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0386B008A; Wed, 26 Aug 2026 15:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7AA6B008C; Wed, 26 Aug 2026 15:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9016B6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:57:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14240160210
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:57:23 +0000 (UTC)
X-FDA: 85144479966.22.BCE3BE6
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id E0E6212000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:57:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Abj4LMHA;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787774241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTsdPkFymOOtxTga6YWdOuMEYYIp5A5+bSL54jG3QCQ=;
	b=wYKUzwmura7q+EhSy2WQUdbmOISibTxc/ZkAoKum+EPKL2V8RjISjOlDokmVMVZF1ytQMz
	g5d2m3wADny0GbTovmkU/WiCKBnRA/0Hqk6264XmcZdKc810IQoApCVGUAwEtzFtRRn6xw
	ZjcXabh94PokGPbhYQFHLSLFJafpF50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787774241;
	b=R+TChOBlEBLlUJ+W7JSBDK18WDU37F+fAWURCr059D4WhFqhyKYBpY5PbDBbb2DROZVKqH
	59VWWILY+ktrebLl51384bphL0p7OciyQD4M8Y7L+iUZa4QXTlLzh4o8Th/gv8zPAzg2FG
	Bmi3IiFbtP9g3+cfB5rB+AhN4F4zlt8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Abj4LMHA;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso964155e9.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787774239; x=1788379039; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hTsdPkFymOOtxTga6YWdOuMEYYIp5A5+bSL54jG3QCQ=;
        b=Abj4LMHAO/6q5d8ZACKVPqyCQsR+kyB7nQJad0GxRMxxT6lrGtFfY4G/pXY35AttvZ
         rEHwnOzE8TXrqSFNJ/md4Vl6w3MATGYZ0nshJSTgpShhoqN8EbGgWVhSHq3QGKhbAFL9
         G6IhAx8jAfNLHiBlfXly3BKC8SToTlPKmjZco2MjeDVCckRjH5gyOQgmTgU17icdK1yy
         /ff3gG4AZ8Vxm5GY6gEYyrvNt+W7V+TKMENteoU6Dv/h8tP8WYjfSf4Da9JUhv1BGSsG
         Ha4JDOc+Off87yMbjlW20H3M1ZehUwHY6V2EyiTdniLM/N44oTdMg3ksIKzC1IjFxmT0
         3KEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787774239; x=1788379039;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hTsdPkFymOOtxTga6YWdOuMEYYIp5A5+bSL54jG3QCQ=;
        b=Z38oiA7IKgYiTB7ww4BuoLXIGtUqfMnK79ZzAtY4uNez/qr9esqOks5UV6vQrPy+Yk
         zGYFR9xiCzgIkzCI89kgYHon5FGh9xc3E8s6Vud7krB50b6rdO1bQVdp4oywiHW/3uw/
         c7FX6j71OEXVBNKu0dlxyzoSEGK/Afycbr4LDDKgSTzx4ovjMt7feXh8EGo0nLKtHivc
         ybActI807R/++vDWirqn/8R7L8NjWQWAO1QXNp3ytStiKC67XVVYJVPbr7IAm3ASBemK
         f06YHuKVPyhcSCMxDDba6ohTqkBJ0PMg36clMDLTLzVcghdCAAXCZpt9rEbifUxDd4F4
         Dr2g==
X-Forwarded-Encrypted: i=1; AHgh+Rrz4rozMl60iUhHZiRx2y32ZAY5rkhRZzl4jEAahaui6EX6rW3fgUWDSvK42zZyMQnNy1TlA1+wzg==@kvack.org
X-Gm-Message-State: AFuF++mmME3S/3lB+9SQlt08cWR+hYlnyLBX5u1IKIhK1fmCar43fdys
	N8t+GE7bZ2/mVAwgWTuKRojKKft9vD78Z2s31/bQ8tML7CW8NfPg7a0LzZR9NoMvd04=
X-Gm-Gg: AR+sD12nhcb3bPXEkWl++N0P7cIhjfQ1v4pHRW+0W/UlM1FeLuPO3g/TT8EV7l1b6pq
	MUQLiuMZkNhzwD3fr/yIlaLH8o55dUzpGhMEBu1DSUuhnIGyrDe9WJ9WyYZSR8dekQ+C2uF++1Q
	wVnUQxciC+HCpvCbo+UQWnK1FqXX+HSu0wW9tZKpv7s6cd8JTMIEVO9gP6C6XqQ5BNutGOLvf7Y
	4UmpuxHmKjQkLJJrLVY0obzzb9d1pzvX4CaJd/YgsgKneZYXh3Re/8inqWaTnncn8WXNFA8d+Ig
	D1KmyAE2d5TyxiEbQ86pUNMDEcfcPXxpsgZX3RM+ixjmZjXRcbI3XAhq9Sm6d6ZShXAZdvUiGnm
	ah1xadRc2wWaw2qY0EDxOdp3gsl39mNH8Zk+eFkttbazwM8hDLf0Zc0WFpr40SThQYEAvr0qdVb
	fuUdMgmNV9Br4TQlx2kTOjjNWdzjtvzZjHSnmMkveQ/hQ5goRsNlvzO+Ce55zE7mddpC0qIRs=
X-Received: by 2002:a05:600c:800f:b0:499:59fd:dbfc with SMTP id 5b1f17b1804b1-49b0dea9491mr13362775e9.1.1787774239286;
        Wed, 26 Aug 2026 12:57:19 -0700 (PDT)
Received: from localhost (109-81-80-32.rct.o2.cz. [109.81.80.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dcad9e38sm38430745e9.14.2026.08.26.12.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 12:57:18 -0700 (PDT)
Date: Wed, 26 Aug 2026 21:57:17 +0200
From: Michal Hocko <mhocko@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, akpm@linux-foundation.org, shakeel.butt@linux.dev,
	mkoutny@suse.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] docs: cgroup: document empty-write behavior of memory
 limit knobs
Message-ID: <ao9FHZEaSbNMlU4b@tiehlicka>
References: <20260826021753.197871-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826021753.197871-1-cui.tao@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0E6212000D
X-Stat-Signature: u9s1m61b3dgjno1hxsp7sxcg4z1gzkqz
X-HE-Tag: 1787774240-724373
X-HE-Meta: U2FsdGVkX1+IsoRCpbfFQ1g9mJvCusCPEsGWxacIxBdkKYg2KnUR+IAvUvBq9mICzLFMwJW+rDA29dMt/b0/+CZF1mZOuNPyZjMpt9iy1FWkCO7rv3f1nLEe8D4w0rzekxTlrNHuJpsjeAdni3aS4SflHFxjBqBIlGasbtBE4aXkasRaTo5/Y+CkOpn9RSf+Gy6+7C8CRC7YyNLIWtZLTQMBzLHneLqpuoCk0qS+WBOTvO54D45SzOgLoYrr61S+rWqMSnOClm8L/4eRY1s9MOOCkPvrAFJtHLy++yc7bRzWzEeX0drASQPPzfmq4P+OkvJkfDyugguZHee3DIRtmlHQ8aX36zkLl+L4a0RWBP1xB7FZJyRiGcEwG7ww2JHkuE5Hwi/aLF4y3Wqygcl7rkpHaDLJWMaRTwYyPmHUSNa+fYaA0c2Nvj0OYRDBCa8BEhFQE3Hq7Rt0Er0wu4wdaLl6XBhW0mkLpLe6tdIK8kPyKy5mEvzh9g9ff6NQE1fqTdPAAqgKuaW4Ff55pIIECu8RDYksDqvooQB5nBWb7SIG2mrfhsS2Iv91bdyRBJQG5OBxP68mSsGGuZQzqB7vWFi0X3poORzd/YAKRISW0ffZNqGuQcnIi6guv3BqCx3/tFeo+Rqn895jP/hxWz1QUXa7ls8Ufh3qYeMtcPIAMu8Foe7uwfuQAJdRXLp/ceympSNdmN6W8CU3ZdtBeEh4O/0/AI5GX0oi+rE+kRzTc90Kjx7H69kj4ksdTVNxnbqy9jlR96WGU3qjL8SWZJOmUPy0kHCqJu7JSGNWAAyXIET7t+9Eugr8cYDrqfUqdLo+2J8CuzltjsXg60DSvWTIbLZBeIuJhvxJtpMAUsEL5k3sDuitVgvfHUt5bfMX1kAZ+7Yi7P30mtcqfVh7eqJehzI/gBzTAOQ6DVdCwcjBBx20BAr96EOn9sPHg5Xx4liG3qq0mJFJDObEZCfYs5L
 SK6C24DW
 +y1UOFOXPoetFptbuLD87MJaf7LUts+iIR/uWy8Ox18rLZPl5LT6+vADlqgf6LaLfAxgkvxoGazZnTCVd89JzK+5eZFvPUMBacAE+lB6qh6Uv4bxubADK3MWQZHre9TxfnvdA1EAbGn5NMxZ+B5yPOSy8VKQTLNkx5V28B3pm1+8RHKWT1k4ykaHjWYGFSPYkRo4LuA14wzrDS+dOTxAwJP8HPKWedOzqPKwbIGtd0eu0vN4N1sjoVuJnyg7RWk5lS2yUmWt3KjKwIdgkRj0jhh+ZZxghNUGBV7P6Xi4lJr48zpJrx6fOurzRtMrSHeCigd3Z64b21yMgRcqTvj+/3PTiXjH99yPSg1UdkrIc7E3if0Bj8mBaHgrRefITVtDH4mZRk3yn5b2D/htbvUdrak4vTm466AGAsVfLZ4+x7VDGYVU0cswPk2wF0XIYhmos5z3d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 26-08-26 10:17:53, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> A maintenance script on a cluster wrote an unset variable into
> memory.max of a workload cgroup; the variable expanded to an empty
> string, the write succeeded, and the workload in the cgroup was
> OOM-killed.  Nothing pointed back at the write, so it took quite
> some time to trace the OOM kills to that script.
> 
> The memory controller documentation does not say what an empty
> write does; the cpuset controller documents its empty-value
> semantics.  The actual behavior is that the empty string is
> accepted as 0.  Reproduced on a k8s cluster (v1.29, cgroup v2,
> two-container pod, 384M limit):
> 
>   # LIMIT=
>   # echo "$LIMIT" > $CG/memory.max
>   # echo $?
>   0
> 
>   m6demo   0/2     OOMKilled   0
> 
>   Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB
> 
> State it where the interface files are introduced, alongside the
> existing notes on units and page rounding.
> 
> Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> 
> ---
> 
> Changes since v1: document the empty-write behavior instead of
> rejecting it, the outcome of the review discussion at the Link:
> below.
> 
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 86a2a0099178..8d2603751c51 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1321,6 +1321,10 @@ All memory amounts are in bytes.  If a value which is not aligned to
>  PAGE_SIZE is written, the value may be rounded up to the closest
>  PAGE_SIZE multiple when read back.
>  
> +For the limit files described below, an empty or all-whitespace
> +write is accepted and sets the limit to 0.  To disable a limit,
> +write "max"; to set it to zero explicitly, write "0".
> +
>    memory.current
>  	A read-only single value file which exists on non-root
>  	cgroups.
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

