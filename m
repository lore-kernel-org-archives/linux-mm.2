Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA35ACD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 23:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2133D6B0088; Fri, 15 May 2026 19:58:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4606B008A; Fri, 15 May 2026 19:58:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DADA6B008C; Fri, 15 May 2026 19:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F20E36B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:58:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F812401B8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 23:58:27 +0000 (UTC)
X-FDA: 84771321054.11.2286C60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFEAC180006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 23:58:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jLmOJFuA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778889505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIk3aAnNz2vJKKytiB8vXCOHo3nAndV8JGEBWZmFgq0=;
	b=r/zUQ4Xt8k1+EdzERiObJsk+4fB3uVmmnp4oO/dbc8LGLNZQ1YbTaJzLeHjo/LP+jKrZaZ
	a5EWEpEbIBrkKCx+MwkU58237q+QQj5vLZgFimGg1uT4+7G3exvG4UjdnEWD291ZFKClm5
	2MwylFPMzpz0+tIASd/yDuXCzpdBgeg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jLmOJFuA;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778889505; a=rsa-sha256;
	cv=none;
	b=3LEcUuald8RXWgtdGUUXGGoQmzneqfsv+IMNKo7DUw7A4bs5+wollRtMA2NM4fSDlf/82e
	ddyAKCCi+O/9q2IG4mh7nXWxuZfy/Dw/J0LU5F7kYdpew2jJgherUWeU3d3K09lYgUbuJ2
	6aYQPkX4v1YLUFEtUH/HS9UfUJrQ06k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2626C60142;
	Fri, 15 May 2026 23:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9626DC2BCB0;
	Fri, 15 May 2026 23:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778889504;
	bh=DRFwCkj8ZqTEpiURsa6RjCEdEirSkU7fwSbrQ9CFLAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLmOJFuA7sO8r9fR6IIs8EvD91wurBFs1jjDPLVKjPAnfKAe5Xyac7zOckX5NWUWc
	 hchltuFSGhCN07K01l3Ikq/YS7Bdu56/DORv6NHC3pEAiS7fuv6ccaoI1b6iQvy9oj
	 27xHNYXCAXJBquzJMmXiUBx4Qyko/9bN8m/CEpnV8kEn6Mwldoiml0wbvmae1QTpzH
	 yrdyD0xHbYaPWVQrkwwi+U+5phf1NzZK5QqiKxIp48WMoHMZe5+c3MA1/u3ziIzxdQ
	 eRdR2VY8jbx0etdzOfrR5UyrkDfo0hO+2RTfhBbmbmDfOVSToXVENWmpAjMp0091cB
	 TAHqxUFosFxZA==
From: SeongJae Park <sj@kernel.org>
To: wangxuewen <18810879172@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v1 1/3] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Fri, 15 May 2026 16:58:16 -0700
Message-ID: <20260515235817.136362-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515065325.4009527-2-18810879172@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFEAC180006
X-Rspam-User: 
X-Stat-Signature: zshc65eap8ysyddrjbhx8sih4nngzsos
X-HE-Tag: 1778889505-697923
X-HE-Meta: U2FsdGVkX19O0Sp/+JDx/cOpmjvWM+3BuyCinQWEpFEfahQDs61AYA0eMgBU2vK8W+zEXeBNtm0WkLg70XIj42St16LfSiEHBOBHlz7ygSAGfQDFZuIImnt/RMyIqErYzPWhIomZN80BW3wSNIn4tFg27Llr/H897lULL0Nemhgxe10TroSF5hBkEkmufq9Xk4IpcpULA0LGJtiYhVByNSkw0CC/CV5+f0yCQSrHyktY58+W6ckP1A83ueXI8EWNnI9cdfagGtrfY4CnJvUAvf4qALFzl7VK1Bt3t8LAvSnC/aT7R/rv3iDxq+mjnI1kC0nt+x/GR6I8UlKdaIzLsuC/cDwOQlF+8QvDcfF1JkydFcZwcj/lAvwTSkjygGGNiESZCvI5PfiihZywM+hIunhDkA4Ikq1RpX7tQ6NPSdJlfgfp5/mONZFdmmbb1JKhYnq3rqSiy0F3fpimr1Woyom2OH0iIB8XIPllpRIxp3K+pbycgjXxKTBPNk17izc3ibEM+2H6xe9lnxO/D+9ZD85Zs/bER+ggw34TFnJPro/1vo38xif+vOi/960yue4VWXqLY3lVZc1ZDkzJsBg2UPFYjh2AYcU19hLdAFYmB6opE3cto2GDpskAdyp0gcAumvryEhIDauH3rOOkewJAPWU+1Tgp3+VNb9Ic5bqqS8gviNuLo0iZSV1r+8DTlZckFnlx8ynPjOsxdyEFqEXiEi5PfH9YQbrwu1reuUur0P2iV7jHgiQ/S9LhSzgc1IG4ktdEg5+CEu+QF7u07YNteZ7Jer4p/0I0UP6RUKcgRO6aP9HH3vTwtRmfmQJuisHfYOIkkaBw4HIOdsxQ97A7CkMz4nJasRfpkMEZFOvu4DAIcE1Ow0XxSreW4+IoaOKfuceIiPkJY3c9a4yscWJUI1JySTeRkfujDbDpQYHwmqPF1NUJ/X4vGTjd4o9KfL8jsjcN6O3Hmsgy0/ZvV7w
 6D3gkWRz
 2oA07a4djiFA7DaM/ZU0/BVkHLBKdjjg+Km2hbS5GOWgaznSBVy9BoE5z1+KFx5L9oBv0qed8JWALgocBvz2hT4ladLL42EdxomaBQuMzLKT4mDapLbZfRIDqrwykK23icXjfgNF380No9GBeoX5C5YyI20yW/Ss/xjWh7bHkoiYDEd01WvUa4TRGOdQa25vc8Um/EZnkVV6K5RkQaWLpZecZGEehWReF6GSIWK79WXrQI6i6Vcpzb194lKuNg4R0GMKG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello wangxuewen,

On Fri, 15 May 2026 14:53:23 +0800 wangxuewen <18810879172@163.com> wrote:

> The disable trace path in slab_debug() had a logic error where it would
> set trace=1 instead of trace=0. This made trace functionality permanently
> enabled once turned on for any slab cache.

Nice catch.

> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>

checkpatch.pl gives below warning.  I think that should be fixed:

    WARNING: From:/Signed-off-by: email address mismatch: 'From: wangxuewen <18810879172@163.com>' != 'Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>'

Also, should we add Fixes: and Cc: stable@ to this patch?

Assuming the email address mismatch will be fixed (my second question is not a
blocking question),

Reviewed-by: SeongJae Park <sj@kernel.org>


> ---
>  tools/mm/slabinfo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 54c7265ab52d..39f7eae7eecd 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *s)
>  			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
>  	}
>  	if (!tracing && s->trace)
> -		set_obj(s, "trace", 1);
> +		set_obj(s, "trace", 0);
>  }

I think it might make sense to use 'tracing' as the third argument.  Just a
loud thought of my personal taste.  I don't think that's what this patch should
do.


Thanks,
SJ

[...]

