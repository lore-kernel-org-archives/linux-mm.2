Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DA76C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4995D6B0099; Wed,  9 Sep 2026 14:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4710F6B009B; Wed,  9 Sep 2026 14:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386E96B009D; Wed,  9 Sep 2026 14:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1198E6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:29:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88658802E6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:53 +0000 (UTC)
X-FDA: 85195062666.26.F578F39
Received: from mail-qk2-f5.google.com (mail-qk2-f5.google.com [74.125.230.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87CC1140007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:29:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="T/Y6KCxR";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.197 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIvedYIS2AeKXYBcXZE100tskW8WcxbKQFbzxJ/h4TY=;
	b=j/VS70FeYBo6RlXbKL2iFbNQE1bwSPKtY3T/WbZyDDB9kZiFjhx1Ma++Vvef/okFOJGf34
	WSgZexr43zUR6611jE8L6TYIlOzgHn6CA4JRkJnJtLvDXARmUN4DbFPu4qxeLDjhyXR5GE
	Thh/rVEoKB6bco1yu88+oq3Sqst5k7I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788978591;
	b=Ostc7m4HHYaDDwWofeulIe2SyJZBEGXc1S8AvxLBIKxxfEbqBlY5c4fRD5Fv/TAX3H5ZFI
	Gp+3QIT9fmXneHYnRzODHx7iPQPACfxWOD6v7P1dAg2WT8KE4KatYgxFQDiLMo0VpqHB0k
	xIIPKnpuHws389YwKsVj7FjhlpPOH4w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="T/Y6KCxR";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.197 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk2-f5.google.com with SMTP id af79cd13be357-939042cc742so316355285a.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978590; x=1789583390; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pIvedYIS2AeKXYBcXZE100tskW8WcxbKQFbzxJ/h4TY=;
        b=T/Y6KCxRWHf5u9dNk/u7KJJ18k5u4cvp+JzMui+owvyvJ4B8cRoi8UwQ+52i4smoMA
         PEGF3InVEHsZiYwGPXA0NrTUtgnNuD07t/078xLeWle1IKepnJO9MWtBKzLq2Ci3iHQH
         +sffOmTlh1k9xfJicL/joZ9o/KKGKltvr3l1ppxd2reg6o6XQ4g0UdLMYGAnMnPfUKb7
         1QaxShFaWuarR8MFa00mcUHEfpeTzG/jBbudttaytipTAf0c5begdZxFXTh+q4DzpaIv
         hIj15+ueRtdX81IA0SselMNcNJkUKAoUt3UY8EN7Q8CuJzWX/LEcqbPJe0zEmmIwBICg
         Tx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978590; x=1789583390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pIvedYIS2AeKXYBcXZE100tskW8WcxbKQFbzxJ/h4TY=;
        b=gctD4V7SP3jWUnJhVTH/rk4YnX9CMlSJrfTPaI+sGC/QfAqstOjglQ4iL6hJ92TbGK
         QTMb+dcZ0x0lfPzTWYOL8Kp39JXJ7mwIHG70gzIup8dDemYb/lePdlhWdInDWYAEU3D2
         5pcpc+AAAs/XSRmfJK2vU11yKa3PGuUEAmUoAmCSePpFp+2MEBUjQQRYuZIY6BYh5Kx5
         m7SJAsEfgZEKEWf9550CWTsp3e+huqosi0cLhsiPuN9MJS5mtdEL3vjpvfPYXf67wucR
         6OGpHE3RkwBPhlxp+mt4ZEtygtxr+WsU1DjLCihaUhf7RNQE8Dl5fGMXiYdwS/f+74l6
         XbgQ==
X-Forwarded-Encrypted: i=1; AKwUvBx1PtyZy8iycsNP2TXGGn/5NcsFmd/r6QgyHprzT/ySkk4JSgj9w4ufyoAjgY9Sh2ntsOYiRRz2KQ==@kvack.org
X-Gm-Message-State: AFuF++n+t7kNJnzZuj7WKRUJ6y6iyRTME5PT5Skn6DU5OEXZT9eDQkto
	z24nZ+AJstt0MZLRES+PZ6m721R9qBvE3F7G/NWdY2cVCfQ7ubEuLNBYJeyZE/Nn5j8=
X-Gm-Gg: AYBFou2p+13vFKQgHFe9LVUoGmz69bY9u5FGmOXKpcFvgasCq4rJ1zSuSyNPNwb5ybl
	j0/e2t8T0y6LuFyBwA7O4VKsVN0iU7eV8Hm6BucP/oxlt0U2dyqwjP35/MARqWFbLNU41fdj3qn
	vxO4arAWRUVYbwTwwgY73Iu0PXTavhu28wSL+qOXLAdSeEpWrvdN0XhVDtT/5TH/s2eDJTwA54o
	fhIXF3FOcOBqu3MWKGagODfJuMV58DRAfjw00nmBFhm2GKXuCxMN4yZnp53+7IY1+YsL/JB5Sh3
	RfpwA4FcMJZKziLTyzLM5WgaL4aaZE4oVn6cEB40niaD1AEgStgf0oHX6yc+yHx0iWCiTnqIM8T
	b02GQsDdg+rCfydOYNaS3jTXugCkVJQR9ZXq2zJZK70eih7P8ga0GEoJgm+0pyHUa+Uw8xULHml
	QmLX+yMudKG6J6sprdvILZFrdFYtL7F6ay0v8DjPwzgtDnoGoBB21Ul257mIXWvUC3wonIQg==
X-Received: by 2002:a05:6214:2f8c:b0:910:3451:341 with SMTP id 6a1803df08f44-9103efb48afmr505437276d6.32.1788978590647;
        Wed, 09 Sep 2026 11:29:50 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910490a3a58sm119183276d6.44.2026.09.09.11.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:29:49 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:29:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: zswap: mark the zswap shrinker
 SHRINKER_NONSLAB
Message-ID: <aqGlnALaf-Cvq4kj@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907110111.2286932-5-qinyuntan@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 87CC1140007
X-Stat-Signature: ox17pwjrzboftuisdfw59nqid9gfa489
X-HE-Tag: 1788978591-669303
X-HE-Meta: U2FsdGVkX19LYVY3XaHBmzd+u+L9t7FxKJXN2997JkWNixfLPC0MJ4YN6XJn2D8VNfh2wG1feVwJqoZnnrF0TnZKtj7yHlVOocNZ9yuLz8MpfA70uRnrTw0TkPzbBZKNWkEfo2RggZhzmvDS71tYQMeuDRHjarrUXSljWVvkAGCsqIxJ8F218fKP5Tav3/4m/GrLz1W0lMHjM7iULOYeh+Cn+Y5psVVUp4PymLpiqExBcsrYYnU7ofHJyQ8alPM1YeiOzZdoV8Q5R0oEhN9IA7U9Ujy2hxxSYaTunFERhJYQfmph9/YCcZ/FcPvfesQJXhTEbAbeBd3aPIFsxmLTA7teXgh0HgkeYVyOEet11uNCnXQ4qP/lM2pb6GmWbOPeFzTJdmJLf7XkSJi4+pJZfjHR8qu8sEsW8T+ubBmblgrRQiNKj4qpLnhVTBuMOR21dFS3hCOWDK0Ehd8Ttz9Ak8p6XFpmD4Jd+Kl+t1mXKhBAxc51O+28kgowSfxT1C4/ldXaPm5134R25XGvgArDA+c6GIkitzXYzMlNecqQErXFI+nXzSx4kXwW8TPziiwai2g4WQx72Ya9c9q8/lfNp7kpHuSVaaq84voeUm9Hs7zpmg9RLpz043XqttY8NOy/r4QRyd6/4w/KYkGyfnLE9ccp9x0KHTq4QGAWKexlGx915DZBtt9vawMkLou/NrjL5MHNhFZ21gMKAYglRLEzSUQjK7Esdw8jvGt8RZn0WR0PLnJzh3yVhYx5UiifC7y1TMaKPyAFR5mVWUdJjBYBKFP4YYMZsRRYEXjnJAoixjMDj/a2TkOWEEcZfQaIaKQ0QXvXvZETdQATP/mo4efNomVkaOMiJcDHtCHxBr3R3CL6klScqxRXTczKdYC0zsakA5J0p+rSfPGrT7vX5RqaNJWEFz2WzhK1nVaA+pCi1DalQEapWbAPdDhNoQIxWGfRWiQ1UUxrXjVX4X0fnmt
 GDK9nk/o
 Vo8aukOtTx7HRB/nb1Vd3Ge8FTzjfYzPE5Ys+rK4nlvydHn4qLDKc6hoQbP4QlSxGJLqPSnr03EdyKZwAPO7u6J5TrpW5dd0371K8P6UnsEVJbD3XVOfju9Yu71pPIxorGR4DDJb0+VhVmStOPMMqCD7YT+PvnagcOz5dclGs2GQdaZ5yt9tpPuno1XUEpIe0PKFMFTBGGIQENykhbFy7MHhD7keTT46EQrL9m8zmSFuUVDN3is79c+UILzFL1RRQTymCAWZh3csUL0ITlamrJzfdOKmn9ywxvVgDZdOZ4MoMS4FwY2N1AFYpCX+RbZFnchcMyjtPhdPs6f+MbFslo3pM23+P5HICCgkFjNFmaVUFJSg+QTGK2hoB6YTNrBwh7PuLl9ak6r0fP9jXKua4LoQc2v/MR9z5MgQuiVAkP0woX9VVxnzJL9KDjRQJrjrxh3EDjcUjo4o4QCPkhV8Pxu77V/g+qPW/ZNFSTSbDekJVm+EYBdXScn4oKxz8C6TacJixqbKuXHUV6hDpieTtzp1Hcz4yVYdBuszmyAHjmM6gXHEyLn8fBn1+4jgQe++7d1J5u7ORyZWKkMvN44tz1Eab1fgLniVfECtK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:01:11PM +0800, Qinyun Tan wrote:
> With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
> 
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
> 
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

