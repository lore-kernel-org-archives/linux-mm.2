Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E88C79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 18:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903F26B008C; Wed,  9 Sep 2026 14:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBD26B0092; Wed,  9 Sep 2026 14:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0A96B0093; Wed,  9 Sep 2026 14:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7B06B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:28:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3D8CA030A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:28:44 +0000 (UTC)
X-FDA: 85195059768.05.A1F5E26
Received: from mail-qv2-f7.google.com (mail-qv2-f7.google.com [74.125.230.135])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD28414000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:28:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VQzL/O+V";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.135 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788978523;
	b=PSD7pjq0MJ1nuFjn4Bcwq5FI3BbTH/4Sv7m/SP80m1tY4tUgV5yWXjiqcMwUPsKGVkLNq2
	V4IArxQeRsro4fMABh4VAv8UnNnuS7bwBonCu18hPKcxRH3y+fffxkgXKYftxZJj8O08UM
	b7oXc4YWtSMJtop+93Mrz1ZUvp01hq4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="VQzL/O+V";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.135 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788978523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC8+CYBpTjyEX77+0CoRP0GmnJOZZWZXdKNBjQTGBi8=;
	b=yeCfQ2Ycaa+wB/HyS6cqQqyQS1ttDCUb630SgW8PrQoXZLmwQ2z07GdybvDCB/Euwq2f62
	TdVOvbCqGbT4F9tY2lrD8RDCUefHlsIroStrFZzgM81QXsmCDpWXHM+OFj8ylzEhikS3mQ
	9aZsbfSSsRsDFAgsZd0k8OnVDQIL19A=
Received: by mail-qv2-f7.google.com with SMTP id 6a1803df08f44-90ccffc2654so36646606d6.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 11:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788978522; x=1789583322; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IC8+CYBpTjyEX77+0CoRP0GmnJOZZWZXdKNBjQTGBi8=;
        b=VQzL/O+V35RYebkycMotlEExzuKVUy1ZzHlRE9ux9lh9AZmHqZuOMLQR5F9s8zbMgz
         aFHvCZ058MAJ9eYT1KOp34qWyieGxr5baxt6YInDt5iXXuKUXEgX5NCCM7J/IYKBRw39
         B4lR9+Wev6wAyNaIxVcXm2EiaHjO8BigH8aXUGxI7cL8ZOZ9aajHdSXgx+ougn/l4asT
         gqekF2qCPVIGDn8ZykngG2Fz/vNjfaPNGHy/cJEyNVl/Y861lWbdpL6/oOtSrR8LPdRK
         tYX/AlI6Qy38RX1ZgoscvGu5MGFC66bSWsI+XJ/gVKZZBy02WWIs99xCystUyZ+Tdg70
         n5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788978522; x=1789583322;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IC8+CYBpTjyEX77+0CoRP0GmnJOZZWZXdKNBjQTGBi8=;
        b=JyOR6xjSUzRucgF6wwV0n/RWKn9Z/03QKN+CVrgfs07GfWOEW2r7top0Fn3zkGEKE4
         AUPQWG6Gy2LWLsPsn77c4lXU5Y6Uve6Y0zKDZ41dEXPzu4NGtMgUu+xrZS0wDb+lC+NI
         wC+sEwS8XbYLhlfW9eJisyWDjVXFk8ppF4pZgmRTF+/gKNQlLxlV7D9qFkKhWsxQ5Yox
         bo+dNu/ksBj1lEGF2Q8IlFkPdjfAFZx3wdIjitqoldFuOfXPCZ5ashv01o2SczRWu0QP
         FQO2ZNPCd/RDYpKn4fnb29YKlnv+R51JsKyKQ4/qpHGX5X8qhRocL9YD4k4qOC3VSziD
         2Vow==
X-Forwarded-Encrypted: i=1; AKwUvBzDkuJxJs7vNe9kl7BBG93wv4by1jC16xVgyTLOlYqAg9MVLLeBofcrJW7GFFcFsmMx4to1KZkJgg==@kvack.org
X-Gm-Message-State: AFuF++mF5/rFKnpfHO0+iQSvtXUGS2QI+ryks5WT2DNDd//CvVaAdP9J
	XRP/tnSX/E+i4uQWjlyitZG1afcQh9fOCbdX/X/KgwnPHjvFvzB99Pet4ppKrfSBtpw=
X-Gm-Gg: AYBFou3kNCqPC85iHce0n9bS+YxCwPZPrD4o9HatytYCcCq+LjlAuZp8n0DLeCypuha
	9CcvhJ/eMNgqF1+OtgGDU2uKP7wpab5S581OsqFx7rKUEgVqlbyRsHtdG9aCeVQs76VYKt1OpFn
	lruc1tPImKEfFeJjHUEIXe5YoQtVm/iVho99i+zMNEyBSUObqccANa5z8eyvBY72kR+rUc32YkB
	q7FXVktvXHk2fv3D42amw2ob0JyXmK2rWFRUJVepAGHx4AHhhs8ic9RsaRu7h9ewm6RKr1E9e+/
	/ITfEDxBPenqCtXl0MqAI4JFB4QsdAStKu6gJ+DlejVcwPl19hzpu1NbKmeEn4vQGwHh3WrG3EX
	b1JfghSJow5C2B1YlqwKKtM4D8sfxRSRzQaoLiEfTB0WXzmM6Rz/01KdKsupuUwKLiaAe75GOZK
	/jPr8R5HcG/b0f6XuV1auI3cjBAhRuyi4+MCubbrsFPEV3rvYDqCH1D/YAMo72aac1p3fMMQ==
X-Received: by 2002:ad4:5c65:0:b0:910:74ec:8892 with SMTP id 6a1803df08f44-91074ec88f2mr36395556d6.6.1788978521419;
        Wed, 09 Sep 2026 11:28:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406bf8c3sm150409236d6.48.2026.09.09.11.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:28:40 -0700 (PDT)
Date: Wed, 9 Sep 2026 14:28:39 -0400
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
Subject: Re: [PATCH v2 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
Message-ID: <aqGlV7NjxrFPYtRH@cmpxchg.org>
References: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
 <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260907110111.2286932-4-qinyuntan@linux.alibaba.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD28414000F
X-Stat-Signature: g3ju8tfos1uzeiy54rzsrxfqczmri35j
X-Rspam-User: 
X-HE-Tag: 1788978522-414647
X-HE-Meta: U2FsdGVkX1/NcRUQohiOHN22paoPiXuqqXc23JLCB2+vpuzae2FEOTAjjVKHX6O4VJiqQJYCQT0WqWvDkCZ6w1k470h+4naXD4fs9tvxUgaS3sGKCZotWMaV48T/2alvMQ1O6CRfGpEraVfvSaX5e7jDkZoT9SJTFVgyBmf29U3xxWtRTD7hX7NjDbXqkZ1KOamcDQmDB/KyzRaRmux18CavRmYyURkZC0x81lscFS2g6gWzfZ+ZTwaxnscm0PDNVZ7vJAOSKNL9kCuAi6/pR1D0AKTzfXniTJu+Fgh/FU9NfFW/uLP4vax9Nx1D5GyM7Drntzi5PfdknzWNCm82TQ5cOANIb6RBSblWjs0FiCaBrS9ZXpKtlZ0W5PCGOdHfAU5+xSDzx5iftwsR7kjnEGmQi0CD6+8mL8k5SgEBA5cm7rNgCh4tSkAtyig1aSOyG5Yf4RA05i32vYTX9+3RGfNY6NhL6yAf2bdaKFxVFwcPvn/G9Z+0rq9GBYgAKLMXVVoagJLnipCNaEIfHDZt9AKqbint5W8wmz7buG+AVEuC9lCaE/MXbDojAzvFINvrNfAGxk5ZZbJVo2u+PT0hunz1bQZbZuofGHru/04SpwaozJWnU1NpVz3g6iWS10mZjpt/5lpuzOMkGkfHcVCm3xSmfrDEqlFA510OwJqWggtDC6RZRE8dKmoRfwizxPBJDb26LVwwAdBHz+XzGLA4WR+OEmDAzKYNkuq2DJqCVtZ2i93S4DEXhGaCj8MYTkPw7t2xsagyU4LuxDkMrndecbtDBQUEj2UR5aec9wX73JmZq+GLxurlrIAxzhITNDBZuyZdoQKZ4JvlOWR2yEDUYFM7jyNlP5pLWFWV/67tN3WvYG3KMROVNLLdX9Z7cf9EIyToHBCpMzQHSfNtrQm/SUpACEj4qeILm51KeDJvnjJW2TSP8qEd1OYr/RhZLywFsvDzQAPVbjpItct4dPp
 G2K0/BoN
 SohZ/OiTv2RtAtfTq44Up4LOMfUqK0KWZi4VVTUC/0+bBzL7eGPKiU/pcUnhpn6D//varzyy8/B+1mdZQIUq7dFghEN2gTYdEi6imkfmqC7Abl1cl5/rmgTf9QPnEPZj1R366d/EVo+nHOJySTtw9GlOYOM0JWmNOTwnZOZPOfnzxKX7Brh6NXH+kJnG2uiXhX52art5/C1wh0SNIxFoCUBxZ2PA3gCZb3Bj0E8Vc7dkuAE8011vOZC5EIV/QALAcihEcWIRv/l5vu+T4WqOzEYJaS3Km4Z2IhT6Ty0Q6vKNJ+gatgJ+UXvgUFSeFGfhYIbe8nVi2c/gxSnw9EXmfoh4Af/X6nlKl4hLe8hgEHZobD3NR+aB4ClwAvFfPIEqtt1zG8Uc9PwTtDuq8L24iKkj95hxU4PHZs+rzKxj2azET2PIdoUpvjsrisjFSJu9W9zKDiwqKucNBvi+7rw6ftglv7iSs8stHiFycJheVw7sECFK+i8jV0kOCoccEj317aTbcSgZdFle+SnTBmpZ3UxbuwWIaVEFz/vyz59FaWCXFcsKEGFxITEE+1H1QD9MKsafHvCGjuDTeMlHEL57JC2UIAbrmYnIy76IVpQrU2chpQrACaIhamqSXBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 07:01:10PM +0800, Qinyun Tan wrote:
> On a system booted with cgroup.memory=nokmem, the deferred split
> shrinker is quietly demoted to a non-memcg-aware one.  As a result,
> partially unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
> 
> This is a regression from commit fafaeceb89a5 ("mm: switch deferred
> split shrinker to list_lru"), which re-registered the shrinker without
> SHRINKER_NONSLAB.  The shrinker had carried this flag since commit
> 0a432dcbeb32 ("mm: shrinker: make shrinker not depend on memcg kmem")
> precisely so it would keep working with kmem accounting disabled.
> Without the flag, shrinker_memcg_alloc() fails with -ENOSYS under
> nokmem and the shrinker loses its memcg awareness.

Here is the reason why it was dropped:
https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/

After your patch to make list_lru expand for NONSLAB shrinkers, it can
be restored.

> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
> 
> Restore the flag.
> 
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

