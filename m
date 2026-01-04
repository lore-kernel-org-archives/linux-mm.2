Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275C7C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 09:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763D16B008A; Sun,  4 Jan 2026 04:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FBE6B0093; Sun,  4 Jan 2026 04:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B066B0095; Sun,  4 Jan 2026 04:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 557D06B008A
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 04:04:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1ACD21A9B7D
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 09:04:26 +0000 (UTC)
X-FDA: 84293695332.01.570202F
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3E41E40009
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 09:04:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tFJ4Sc9u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767517464; a=rsa-sha256;
	cv=none;
	b=sZLbJjZ6+efIU1rj5IQNsdC0vzKxUQWA8JymgZGZJzmnXDd0fEi8HAxmgc6GGWzs60FmAt
	6pfHP7ZM9uX7yxx1htIdkrUNRP25p8AbenCw8uPVdS6vWe46B4dBcL400Eg8CgKpING4Sr
	Nv5BDUiV4PG2dxR5pwVRedu0b0b8l80=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tFJ4Sc9u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bingjiao@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767517464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSOiATV59Jt7zF0mcNusY/T1zTDz582l3BXZAoUYnUk=;
	b=AjQBxEBHUJxfK8M/vB1i760YPIS9ZqnP2J+ZQQDQLD7E8k7DzZewuB8SWLdTF+/0gkBxYL
	jPXeilD1tnKVLwhcVksXpK5mw1PD8IJN8JkWdKHCej5zFRljLYJLMqIGGG/uNb9PeDlxdZ
	iUj0p80ZVslJ/zy3GGe6EP8wv8Rrxy4=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a35ae38bdfso91215ad.1
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 01:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767517463; x=1768122263; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QSOiATV59Jt7zF0mcNusY/T1zTDz582l3BXZAoUYnUk=;
        b=tFJ4Sc9ur8UvkqEb2bhXpcRa9xYdIaTPqkW3qQm3MT64dXeqmaCbcfX+mx6t1gjvJH
         02hx6FKJPbFizyJSwbAyLfltkoIdsNV5DkQjrLylcu5DaJzFfNRVX82zuDl8rgVH3+Da
         US12UrpQ+KYEi9lVDNbyAJU49l7Y76OarY3XoeURyo1cJ28MJXWC5i2xs7uS1hgNU+5i
         6VVc0UX4RH6FXyVoo0ckwwR1VtbAkZ956EwKHRL9GU46fV7mfrwhv11KwsO9iTtHu++B
         +XW6HpPPTMrCyxoRF1+FbfbP7IjpQf+iMatWkR3/z0OBy29yuCiQad8pZdHhLO8HHeyR
         fdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767517463; x=1768122263;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSOiATV59Jt7zF0mcNusY/T1zTDz582l3BXZAoUYnUk=;
        b=Fvf+PXUpnCayW5ZNwwMK8EK7KT9Z6WBhXAPkIvCUKD35W8HANDwwNdb2k/+nHMaaAL
         Q8OnNK9dm7URb5sSs8ZObFFqbUer4JQ7wZcwIxqN8mHB+xxyL6QgstCGkwFJFDQ/xb3u
         G4TwPtEQ8EVKbd+FVnCX4C6EqvBL7JUNpL5yz6+qvKdHDvixNp5D6FrHzEFmy6lY9GGc
         ootwtQi6oknT5ef12QaRY0iTQsAYdGKERhWswELDRJjbfKC51/Z7D9Bcbn7sPeNIWiXb
         GsWSXDHzp0aNt8+d4MBg1rIWUmFQ9eGQ0Ld8CL6W4PZbfRC6ut32wwPMveLA5hMLT1PB
         pD2g==
X-Gm-Message-State: AOJu0Yz7rw7Ey6DPl8lV852m5yWFBa6aWvLUMhHj3NK9RpfWbIKKbSE5
	tuPl16eOTwMfYot6G8SdNIpjchLu8hzLw5x8BHf9SOIRZ+t8q5vWB20M5GQvaIckokYvgBc8eR4
	2mr8BBA==
X-Gm-Gg: AY/fxX4VQVdFfXmiVXMaqyLFUbZetIy4+6LnLQSarMA7wpCGcDkeQEzBQktxfwbkhIj
	s0Zh315y0xoZuuWsuMHfekh0WdTn646f4ygDZo1CVK6+nWcax0KroOWJNLgqb1vKnTrZLfDKy7G
	0U+rtLLQqCmiqVGi83VmOMse0XGxbSCQWRoCIGzsF1XYqB82PmsCYi5/aVrySgYSJNs5yEDDWRc
	9kMaYGsJcLI3HN4DHY2/jRxuy80urU75LdgUvzOhzQGt2QmNeajQlyC8gWlGw20vKxcdOuMKVYH
	+Qu1lj4nxPHiCwxXY1Pk2JxzSsno84o5dH8bNCtlOd/wTcP1LLKksok6/3oE59KBG+6welnz+xZ
	dntwKggpOV5wufrEAXgIrxSFGpWOniq6u55Nr7HOEBrNsfJEDmItrTUyEksZNXwXxBSOw0aIdHK
	xILlzhu3m0T0XCYzcdfP/iOFkaJGfKYoibtaiHrAg5QH3hOfs69V729Q2EGhSdb0o=
X-Google-Smtp-Source: AGHT+IF2f+qqRGbSWLY+axONWjGzW67AvjyMri7/vyDsrV41RpaLChtAfH7ihOiJuNWMSfi+MREU5Q==
X-Received: by 2002:a17:902:ebc4:b0:295:1351:f63e with SMTP id d9443c01a7336-2a3c1c1615dmr1696435ad.10.1767517462607;
        Sun, 04 Jan 2026 01:04:22 -0800 (PST)
Received: from google.com (248.132.125.34.bc.googleusercontent.com. [34.125.132.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5dea1sm411421835ad.81.2026.01.04.01.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jan 2026 01:04:22 -0800 (PST)
Date: Sun, 4 Jan 2026 09:04:16 +0000
From: Bing Jiao <bingjiao@google.com>
To: Waiman Long <llong@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, gourry@gourry.net, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVotEFFHwTPF_K1h@google.com>
References: <20251221233635.3761887-1-bingjiao@google.com>
 <20251223212032.665731-1-bingjiao@google.com>
 <84ed9b5d-41d5-44a1-a1ad-2b3de8b50a50@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84ed9b5d-41d5-44a1-a1ad-2b3de8b50a50@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E41E40009
X-Stat-Signature: 9b34womk41hent5bsumzd7bq36gcctsw
X-Rspam-User: 
X-HE-Tag: 1767517464-961342
X-HE-Meta: U2FsdGVkX18mIjVhEheZNsJl9kuPAMCwAMlblvk5+gyM9lSa6O1MVO7p6yWqLuYwZylJ3fMSTeS7tdmkMMbouIvrPmcLZcXoKLPIXTy9h29P7aJus7hWW9OkqjkaONguscU33XZmHbYqYul+HQYG9smQdbrYmqk7hX3MV9nWo91y4bRuJR2Z9FNMwp+KRhGZKzcjMMMKI8F6gyDZAllP30L3sUrPwBw6cKS1g2eLELurHeyLMKhmlLFRDeeDa9JUpBl7dLPebp5NcsZfyQRbmITJG7kLt5+yM67TJDFD98LZUuvqvqZ9MoUAbEH0SIQfraB8eJpgNQ7kofbzA6EsD92aQlWlYewwCAjVC0UzIqHUE8tiRRpseXZBFEKYtWNs217Czrx5lByoaqwD0TMLXNq2QkXKFehTLQRT/fZ3GcXXovo3/DmcM380xcV0MKqZT6H1FcBrhBub2gsXcvw2BvrboxOtctxB7jynYzQLi0SJISCIGc0PGL+gl2qSDkOCHPoKrUcDjvAy/2QW2fYClRSa40RVDF3/2pJBE7vgZDLStYA2WuXP7b1NhKI4akBfmXMOcqS6GfVVgmekqvq4GShnFH8eVFORm3ARw3GqOZLFcX+im4Gcb5XXZNrE2Y022ZAU5BR7J2/FkGHkPedWvxU7kW28eRlR6uC7KAfL4NzrOzfmMje3Q0zPMKC4DqmTGvdw/XajPLX7Cv9sBNS8snkx7fb9pbobZatzjV0c3G12OlpmCmiCyMqejml7vjh9vmfVL+Agnrdc1KJwzEocdVVnUihbK6Dv61n60K3UX+aYekSyB/zS6Vw93xe+hAc9yOv63R7PFokl/Qf+ifzJXdLuNAzmBLT0+89Dv2f0N8QY5QE4/gsk6Fd31PtqcjOHIdfO2ZkRXIT55m3wZAeA36qiEF6ELxvZOqMYScJv3t7NYTBWjpCUO+2CCiPo722arHXXB74U+JugHAOCWeg
 4HiJIXP2
 ssPMyXcjbzX+msyleIJ93g9i2zGrYi0V7mqNP3YTC7wTruIFAXf2othsBor1xoYEc5qyBRb+mBu9JWGTXFzr/TlmEYmimPIHRKMGExVkUjXdI2pi+xtWZShqsmT1Ze5X2SXVegEsu9W2jVW+KBxDaTzV1wlz2czQxfely8yO+PgysXijUUa3HBJc5qBPplkWXStjXT+B/3nOWfxwSle85uaF9/LjVfuBCz8t88ln8qHgJa8wdimwZAdL1gvHj/i1MAjJ8HMi1jJpBlk2FNHboRupTgrMyHYV3TWqKH6w7ULUhVJjD9AUEpkRW/1ZY0r2jxamFWuu6bc+u6k2Yym8IBrEERZR0/0cT8H78an88iqGZ9Ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 03:24:29PM -0500, Waiman Long wrote:
> The nodemask_t type can be large depending on the setting of
> CONFIG_NODES_SHIFT. Passing a large data structure on stack may not be a
> good idea. You can return a pointer to nodemask_t instead. In that case, you
> will have a add a "const" qualifier to the return type to make sure that the
> node mask won't get accidentally modified. Alternatively, you can pass a
> nodemask_t pointer as an output parameter and copy out the nodemask_t data.
>
> The name "cpuset_node_get_allowed" doesn't fit the cpuset naming convention.
> There is a "cpuset_mems_allowed(struct task_struct *)" to return
> "mems_allowed" of a task. This new helper is for returning the mems_allowed
> defined in the cpuset. Perhaps we could just use
> "cpuset_nodes_allowed(struct cgroup *)".
>
> Cheers,
> Longman

Thank you for the explanation and suggestion.

I have updated v4, which updates the functions to filter out nodes
rather than returning mems_allowed. In v3, the caller need to declare
a temp nodemask_t to store mems_allowed and then intersect with
lower-tier nodemask, which is unnecessarily increase the stack size.

The function name is updated as "cpuset_nodes_filter_allowed".
Do you think it is still better to use "cpuset_nodes_allowed"
when doing the filtering thing?

Thanks,
Bing


