Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277C9C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C870A6B008A; Thu, 27 Aug 2026 10:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C385C6B0092; Thu, 27 Aug 2026 10:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF476B0095; Thu, 27 Aug 2026 10:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849346B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:52:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 405A314044C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:52:18 +0000 (UTC)
X-FDA: 85147339956.28.05678C1
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE547A0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:52:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i4E+24nJ;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787842336;
	b=Gk/85J2x9WhOH0/J/ptM9K+toYnPAYitJlM9ax5ulcSR/9JT2ns41mrtSR/bmxVFte35T+
	G0XfEoe3JdIkDjBeEXc/rOaDAS16Ro1aJUcCfceR6v4fgB4i2ajToypgqcZHCcUj3HIZF9
	KnofmS4TMwzEATwJ9X1/lBc539IzOc8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i4E+24nJ;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787842336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PhM8hHOikt+Le7MMX66XCq3uKxujYXBd3b3EMmxqtI=;
	b=jcchzuTVeXUc6jKN5NEdpijN4LRYIwzx2TPASJwvMtz0VIrzdipWCfQdb6x4V1ZY2NgccN
	fDnY7edOgkKk4A8SuSYQqoS3o6/q3PH3kLfPbPx4sLNtq7rK2EELnj8r9qX1uhY3eQSBdx
	te0MfUhWII5uhNOqbsX/cx+2eIF2Z3Q=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-836c91bd782so40058147b3.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787842335; x=1788447135; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2PhM8hHOikt+Le7MMX66XCq3uKxujYXBd3b3EMmxqtI=;
        b=i4E+24nJNpLvQQPAb7XjgyN3AK+xSrRRrWil8cKVtk/C8aIDMWInmgC/F94hGzu88K
         uKvgm1HtOCB5xcgVakDBi70g7F2wxs98lKRwPbhyh78uobs3a0amw4SfyM03oRW+ywe4
         wmnpkQfET4nUL4iR5fuipsvgkAYPniW2rFRzId+S14+9p7aa5T0pPoi2aqbDx5ooY6fL
         ojC9nGxCp4pLdW61MaMcYKMqhQEqD7LK+by7vTOikZY7gfaoUuc78wb6SlOKmUdJMfel
         L8lRBUoz7k8ADVj2pL0ikqKvQXJtE8M46lf9r/7GrXAEbp0wgYnPxiyiah1/UtMXPiEI
         ZDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842335; x=1788447135;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2PhM8hHOikt+Le7MMX66XCq3uKxujYXBd3b3EMmxqtI=;
        b=s1KhP4NaQkHZCF8bZ/MpZlsfVZK75h9Ylbp8MiifijvkqW7rpDjDfv6gceC+ZxS36K
         09cCrMNICnuh8k5a5YBHtDI+h81pseCwgTkJFy0G4N1KTU33x2MF4XPoHOJ2tr0cwaim
         c/0qB28MKVL5hY6YHlro/H2aZuSe+KGoVL/0j2bpwGeUVZ2l6SrB0BSJ7CJyBUPkhBVP
         ljVxW5C00Y1c2G2aD/+QQN8lIy/qEhlYSZSwX/KZYRyA+WmOr9LQPn4txZbfwxkw6Eqb
         043TPdsseTaMfKh8G19GVkRyNuyQYdMxAKYnbAPEZugdEj5tQ1jv3YHMUBFBlgjELb9U
         L/Zw==
X-Forwarded-Encrypted: i=1; AHgh+RqCVrojm579q430QoiXVdZxTFbQK+gYNP9xfykwuX4E76KiGTYzxy0ot76tWvj0eostIjVT/pDfdA==@kvack.org
X-Gm-Message-State: AFuF++mLLPPU2xdyhqHtHQV7jb1ZUG+t/x4BQSD8k4pBBF/cSkLkYU+A
	vQl5VtVM7p+Y/0ahKxr0NGf+3b97oh0iPVCEWXPrXk5vHzofzypCtfOwk//lfjxLN3EEpFuzjdv
	8DWYe
X-Gm-Gg: AR+sD10aW6qWurk9tZfmA2eOhtNyQsEAMtSSD/pUQlVxnqQUa2EqRHaWy1LDeFT6cDn
	7Fh2Qu4il0syVcdcaJqBKV1S39BBn87Yn8NksBahibleZ1Qdhuk1CXucfCZHE5rnWDCwgl98YWA
	MSaDjCc12yZg/uFp2zmdYT+QHuDvaDeucGdtSwwYw/tt6ld/cc82nC4BF3f60ToBs3DnKRjs8WE
	aDpu6uEq149Ev/IEWoW1KHHDQIUG9VSC4L0DXkAnQnvIYFH9kuFprnxt90fHTnGDUxnDv3i2AQX
	vMhu2YOx4zDIOSA5EARIbQthg51D8sWBFVV5xTOb11H7d4ZHsNT+ym58Q0G/GC8mSsD62FifSuc
	E3mArCydMwZgN5HYfElX900l3riitnu5VKFgpdOQEoJUNVz8WGECgzZ12y60P1wRmrm9UbM13HP
	qpmkeR8hwQuaJq/aQXJr19wkYOeb27g1cuAJfiJsxqUQXyEJxzah4+FZOp2KEN
X-Received: by 2002:a05:690e:150b:b0:66c:e3db:e14e with SMTP id 956f58d0204a3-66d256611f2mr5655360d50.8.1787842334856;
        Thu, 27 Aug 2026 07:52:14 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d2471d460sm3060976d50.12.2026.08.27.07.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:52:13 -0700 (PDT)
Date: Thu, 27 Aug 2026 10:52:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] memcg: sink mem_cgroup_uncharge_folios() into
 free_unref_folios()
Message-ID: <20260827145209.GA3004@cmpxchg.org>
References: <20260827030516.462926-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827030516.462926-1-ridong.chen@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE547A0004
X-Stat-Signature: wrysajds87b743ue9dnpmudmurjzbkat
X-Rspam-User: 
X-HE-Tag: 1787842335-143183
X-HE-Meta: U2FsdGVkX1+XFhNHhyUPBgliZR20O0nWe4oai0eh+brh1y4I41yb+nu0E0FbQU1ionUIprgrO+S0OmNvSk4z5zlR7/RJK4UyVGjDp9imdIpankEa+3NxJw+MKP+fbSB0TzHCbAzG1q6iO2CtMs5P4GB/e/9f1hcS2foxf95QOZk/69dmdUAlLKzXfB6prQS4ISt+GPix/ZuouVeQr3OYAyj4dLoLTZMjkwAUHHL8/iot3pIa6g3WHvy5sNHXv0T0lu2E9ARraYsC5Zx6k4vQnqvcCfNT3gDcElu0oT1bNJk9xsL8FliRDXRngIjN+2jncYiSvYC9zWNDC48bAlMS3p7+VYZXiKCakOfWKot3Ww94ZrwuSlYQu9tvE2WG4HCVGVLlRz7pADr0a684oCqOtrdJEQTZCly+ukjblH4ZU4+KNQLLoaZV13Bbhc8cDJ1WZ78MeiLnJ1b38QZcFjeC5Tt7oU2Oqpi4eQH5SaEjYB/FLHBH7kF2lGBDNy2W0yEvMsa0l7z519v+sWENVUB8tFYNY6aaeE0ePkgdMlblSalmbZHLqRZcJaFgTfUUUaEylxHW/ucUpQ94bBI40J/RTaQzjHWdH6HIdEJK7V9T1Qi3G0LqKpOU9ign2H3vNRna5Ja7Tyq/AFKwwsa+ylIHVCat5YFUOG9pxeFKds0RZAw2+n18Mk8AOEGCTh4wUiH+cnz+YlsPub32UOJelhCvfPonELSr/L4FEZGEnxIRKAPSZIiCA0zwzNh5XU9alRHJx1j9PXkrQBjhur1DxBhCi5bnqUtibATZ4dwkRI5HptQ0h3pQzC05+FPB/Kmda2LU680m4XLbxb3jB/yMeg7/I9CoqIpjSQ1U79EElw458UjD3GPmpXFO7HQ3NE1LGJitz4EWyf1ad/hYxwMrUJpPM7G4bIyme4Z0mGx0mvRb8YTZ9nvdG5HwH8W6l6ZL1aKd3KlBSezNmRXkF+hulD2
 cA5DTUe4
 /7dqH4P9gUOTvBM/7kCux8Xu1fZt80Vw+HqwOW+JPKHTIp1469T63EQJ0/gRwplBUF3oHlNw82E+8vTggrHdmqIGl+W9T5YtwxTlVkMMIpL8J+eCutej+fSXdkZQf+9lHsxpLYrm/VEEoOJks9Oz+w9KrEZdYE3RBzK0LzHW+jyf39PB1XUk7HhZaDa38idwdDkCq7pSxIc38FLLlOQSJTJn9sDYlcQRApTncYgZeHmWR9gY34q70fN3nM0B1eW+TDgF1mh6TSY1Rvy1cqdMQpvLYI377Afd178GYteIIEQAUQI4Cs4pS6xLC2qLlELJmCHwpnu3q4V4nZxJRkH6GgKNb0T+7h8Jk5zupSG1CqEhbAgDHEsN9qf/02JPiq8zY1d+MV1auVv3zecIJ6dKoApKoTMULp4tuEyoXahSy9UdFJRykjx5Lc5xVBryUKreFZTP3Qa+VxHkoi+uE0Is4/rKyuNPxeH7CoDN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 11:05:16AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Every caller of free_unref_folios() invokes mem_cgroup_uncharge_folios()
> on the same batch immediately beforehand.  This pattern is duplicated
> across shrink_folio_list(), move_folios_to_lru(), folio_batch_move_lru()
> and folios_put_refs().
> 
> Move the uncharge into free_unref_folios() itself so the batch is
> uncharged in one place before the folios are freed.  This removes the
> repeated boilerplate at every call site and makes it impossible to free
> a batch without uncharging it first.  No functional change intended.

Hm, IMO this is confusing. You're making uncharging an included
service in a subset of the page allocator freeing API. Batch freeing
uncharges, but single page freeing does not.

I don't think saving 7 lines is worth that API caveat.

