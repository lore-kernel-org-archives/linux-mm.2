Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D602D606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=NoOZtZ42
Received: by kanga.kvack.org (Postfix)
	id 00A676B05B8; Thu, 12 Nov 2026 10:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDEF6B05BA; Thu, 12 Nov 2026 10:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC7F6B05BC; Thu, 12 Nov 2026 10:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC5D76B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:16:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 262588054B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:16:54 +0000 (UTC)
X-FDA: 85426819548.25.34AC9B6
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id F32841C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:16:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NoOZtZ42;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794496612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gvq7UynjcI04qxrVBFRcfaa2pXFRPHXVoB6KooUQP78=;
	b=doyXEST5+AOA8MWe/JCBT/nBUJokkbGdBKIwEc4BqA3OOUhrn9PVUotxgEE0Xodp7K99z/
	Owg47IdjOIEyrltb2ihlQVF+jf+GfEaf3OjQTzAaE/HfczY8MaAHaGBsvDSBb+Kf+Ia8QJ
	Mhg5XnvR34eDZ5BZJZ6BEVA9GIxWVk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794496612;
	b=flkjWMsjPihtmzfFVIVCFGL8QGGd68vVxqD80HFgYR3RP3SXIejmua/5PppbjGHz2nZhGZ
	1O7gf1+4JyQLcU/LQy1FKduE5trnCRdiHXSW9hPnSW3Bd2njj5Ehd4ff1BkZlWEWMQRzef
	L4kZcY/LnPareU/dBhmdZFhbkBO1DR8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NoOZtZ42;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8b3b31a6290so13023627b3.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794496611; x=1795101411; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gvq7UynjcI04qxrVBFRcfaa2pXFRPHXVoB6KooUQP78=;
        b=NoOZtZ42wXq8hOihD+5CptlJupu+TadJ5o6pjLPgo7+5Vp/VixetSlLX2Co3mmGDgZ
         aplVx3Hfu4wiTPfg9Vk4POP0yHyTWkFhcc+A2Sc3cHjsE+dfwC92p4e11ppGNEeTTUUX
         zPPDsP82fJOHgHuUb0eRvoToCp+13bf91PecgNo2HY73FGvsBU4ZWSR+ZSyk0POmmNSf
         8rkqCyz2RHSBFbX99sR0Gwjrvgc7JOPZuOgVFeCEiB8YKzMVsfgoHsa3+TG2UMW4ZfsX
         YWsC3dEDIS8aLtVIy+KV1eMmFutQYffwQ17FwXPDAOjetNTaN99GApNJZvUObhokzXJy
         WhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794496611; x=1795101411;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gvq7UynjcI04qxrVBFRcfaa2pXFRPHXVoB6KooUQP78=;
        b=VFy0XKRi11kXK4s2lRGAATj9VLEJu0gywaT3+EqRIJ7JY0H6NQOEozvhVQvF2uZ7bM
         NlpfSu8zRhwRWUvF879B/VH9KNHc9vHzuP+/VKOynDiEPqhzXwQOF6UpEdbm5BAcUaci
         JZSkXJdZuPX/mBt1VvAPAutzwaJwBhHckLyCx/N4qhWZzNTN+tIYgdFe4g180m7ms8Yo
         SuSLTSopTEVDHWdNDdsfgQ/zoExo31PmXuyom2hJv83GusvIri3gBYJFg0pN1rOt080m
         ls2+K/5raj+c/Gv7Jdq9btJT+u+8Un32P/xdrs9q9p/5DYRB+UMWnbvlzGeTIrBMuHeJ
         0krA==
X-Forwarded-Encrypted: i=1; AL+hErE8ZFvGvbrbKl4DvBPmkbNBofvnfOCxRuih/aBGgpFUFpRhV7Xq0u8kzvofCsX69uUEPOlIX2DSOw==@kvack.org
X-Gm-Message-State: APuU4Z9t4RRW/S/VZ5qdVAXpFPaTdFFmccJEVzt5/vpR6dIG4KzRv/x7
	Si6wQz++HrA9l8/96DYzlDjrJWw+2y+dkAhw/TG97rk0t28faCXcsFWK2dHWMeuxYP5oz1eh1kb
	KhN2X
X-Gm-Gg: AYBFou2EcGliBqfVt9BegLQ8HuZK2+9I0r/UJGgerma2KRx85JLxaFKp24waWQkTCvv
	lSIMZAUJHd/CaHMqjN/Dbc3uuO95/jN/2zH6Fqqo5B/4GwEzrPPp237flS/fX9wMQ8zwmV5JL3X
	hoaVWQzavCEKRAtwBFklyJDgK6uIkfz/jnXEK+OOKDTPPMJbPSjVAdc7dj9tR4oOgOAh9kXFotA
	64Evxi/nDrGBk/iMEUFcCCUIwrAKpXwHbLt8GWEkcjNHvd5K2FW+ONlMfm1fJtkhlh2cplte6rY
	M3RMdULYudMGidbTQSSAV6mTLbi39T6cIdcX+2AgxTmYuQgHl5W0AuZpyMeeGWj2cLLj/qt3vjw
	LnQKZYkh4yhc+7hTO/+gBVZ1PLEyeMqpRtM+DSN/bVyuQ6XqgOhO437ccCXuGL18KlIv3+LoQL/
	fi0rVg/EPsqI1Co1v/ldzYJTI/jB+cMJA7dtiJ2K58pBwX1ghL645BfU7gSM2xxx47Ej4JMlnDS
	j70CuMLXKkGIaSEF7r7zudFmcAcA9ncCM6PPCDDCW0Y/xI1w2mUsYEVMhyn0/Fi6rSAm49z8rTO
	rZar29ksV7hsYfhsUa5AjD7e57LG
X-Received: by 2002:a05:690c:4d0a:b0:8b3:37e3:7515 with SMTP id 00721157ae682-8b3a81a539amr35260977b3.67.1794496610737;
        Thu, 12 Nov 2026 07:16:50 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933c5a00sm72450787b3.16.2026.11.12.07.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 07:16:47 -0800 (PST)
Date: Thu, 12 Nov 2026 10:16:46 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2] mm: list_lru: fix NULL deref when a folio moves to
 the root memcg
Message-ID: <avXYXjSJNOFa5K88@cmpxchg.org>
References: <20261112061231.2469026-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112061231.2469026-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F32841C0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d5z86bc151pni9oa9kct9wu9ka9rxqpy
X-Rspam-User: 
X-HE-Tag: 1794496611-342605
X-HE-Meta: U2FsdGVkX18TwpmPm/w9DNqJPjjsKi790/YuNE+4ipcsgPYLyu7PgAXEkajojLTHcBLjQjzm+bikgnV3OEhtpijxK9E6mJQ4Z/evIfB2AS48A+XWWn60LX/xKp10cf/msOc6puh+z2KJqsxL2pMhldSqlz2DjIhxLD/0LDbTHFrlDTyKABnMi8sDYbZ6uwOWBMdKikKuk5ksQ2Sx6Lxgb39ULQGZYJ1Skkg2zI7tLluhhvUFMoaJy0Crwf3fgX7lK0EvE/ocQPpf4l+HFR6X+2eY+39Zq3sEj7KfQJTXmmw0qIWN3noG7QZMSiDJnM5xnzsHqsmCmXVHPoIPh6ZlXyLHUmdUCxR5WVJniEfqZPAE5U/wj5P9L8Cn0LXiQ+5ibwsWrdStlal8ooFDK/080anpr1xlmktdDh/3ZOOJG/x7QQuv7vxIh6RBH9Wi20kKxPCkPUdK85ZfHZwpjvRadp+ZC+5ek1cQlBuugZ+/K9CosOSqj7DRvWQwrjyeb2ICZqu6BeBeFxoDzA1Dd9NE14uMq4R+N7X+AMngXLLdF6oizpqhciBnzGoWUaOnKuW2T/L+q04/0EDNOribLQ/viANNmTOu8fLPKDssUSliEmpXk9tjXg5MOH3+OKBZqNqYsibdWe2QMhMQEc9c5jYFDuwony24BwIjwO4F1nctHrjl+14a3LUVs/YOVDYLMaNnL09FRwkPEW9jsmnmcDcL57AAIIZZ5mD5OiU/I56XjMGcY//OvrfIvrScb6ReNq2Kw5VykzCpX1B129fBB41HXJpzKuLBRIhgsqi1VOYyNfhlfjI+qjDUMrNGF+lUe+BUXuFjI1vtT0vu+wfiect1pheJCw30U+bpoIvlwVaKNAsn/HKZRKEOg+D8uPYaC8B+qn2TlmINphvA6O7OEGXfLL3zFvFHKeQHv1tpZpYn+dNLyq6aVwoLi1PWf6sGurFs70hLvFtDGjl5/3KwrxD
 sRaeWWji
 bRWdS9i1G+KErw2eWNNXpueMaz+ftliyw+SYnJY/UfgF/DwcVtdGS/VsOQMGbyPcTSFU/hodrBnY98t7Fr4NkXul1WuHWwrRGbJU3uqLJNvYCoDPjXPF+G8Lr2q44qIyLe5pNMPHsvVXxlub9vbS0s/GT7Ds2ne8TQ4CeogzXtrBNBVF5ppPgJsusVxKJhTR/PPWIObMda0+8h1yZnAojzN5OEKqa2wO8y4YQhozHF6gtSIcq2QtKnc+9xN4C/aiHuTR7F5J740fvSJeLyuowae/wvMXN31PrL8EfRduaFGwgm0WUxs48mf4ocRNxuWFn/Q13QyVo9NA6PVkio/lYixYhqDTXJFtp86IsHxpch4Xi9IPa0cbpHTEQUj0iGW3WmC0besr//8ep6rxrP3v77plm66l+Cx8fSijZpWfX5ooij+FD93/0TUWZkfG7/0BXp+zaMte1svwHESau9THbxciTNpkKeQV/XLQW3rGUJV8eZ0AiWJwpt2McBb4QOiG8wf6Rt2euv2ZK1fYG78c4y3PPkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 10:12:31PM -0800, Shakeel Butt wrote:
> folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
> own lists in a list_lru, such as the THP deferred split queue. It looks
> up the folio's memcg twice: a fast path under RCU checks if the lists
> exist, and a slow path takes a reference and allocates them. The fast
> path returns early for the root memcg, which uses the global lists.
> The slow path does not check for the root.
> 
> The memcg can change between the two lookups: when a cgroup is
> removed, its folios are moved to the parent memcg. If the folio is
> moved up to the root in between, the slow path gets the root, and
> __memcg_list_lru_alloc() dereferences the root's parent, which is NULL.
> 
> Users see a NULL pointer dereference oops while a THP is allocated,
> such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
> are affected too, and for them the oops can also happen in reclaim,
> for example in kswapd. The task that hits the oops is killed, or the
> machine panics if panic_on_oops is set.
> 
> The race is narrow: the folio has to be moved up to the root right
> between the two lookups. For example, its cgroup is directly below the
> root and is removed, or has its memory controller disabled, at that
> moment.
> 
> Fix it by checking memcg_list_lru_allocated() again in the slow path,
> like the fast path does. It returns true for the root, which needs no
> lists of its own.
> 
> Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

