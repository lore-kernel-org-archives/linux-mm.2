Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B0FF33A66
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 14:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A356B0005; Thu,  5 Mar 2026 09:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500CF6B008C; Thu,  5 Mar 2026 09:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4033C6B0092; Thu,  5 Mar 2026 09:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC0E6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:00:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE6E813902C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:00:35 +0000 (UTC)
X-FDA: 84512169630.19.5A8F170
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB170C0012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:00:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLiPPMTz;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772719233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLB7WOQa5oxTbNxwDfrrKUZKnAd4KHZV7UcRN3JkrTo=;
	b=6mDM9Q+jLL6R64JTk9WQZSnP36SyuyRBUJ2AcVw2a6QmnvjYDrqZqC98uhViDiFR/LOmfQ
	/p1UyT90eJ2GzuZYMM5WtTeCVGnyltJwKyQeVgWhoMU4EQJXOFtHDb4iOy5DOwebJ9aOGt
	ciCoJ32hIxhZnxlpE3eklQ1CbSY0QFM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LLiPPMTz;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772719233; a=rsa-sha256;
	cv=none;
	b=O1cnQbXo3xe+hkFo87eOtbWPwqx8yV8QSfy5OkyxXqp3GRosUT7vDsViw90z+2atbvevW9
	OL3OY+1VMwXYXoopbOl4kzWql2jSsDvcZoRW8sI7u2TZlJltonRPAkSaaSI+F9ghYF2RkO
	tTHQMs7Mmwaqy4Sda8se63t7zUDXZs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE18A43A5E;
	Thu,  5 Mar 2026 14:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E58FC116C6;
	Thu,  5 Mar 2026 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772719232;
	bh=393qDIgoHBbCQNpTIGP+WBiCqebYKIGYINOpS7EZdyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LLiPPMTzZg9/f80zQO9P/fDIaf7xVcapS/MbzaPpFA+pXw3fDPXDsl5FaO+E3F0+K
	 e/AwWKAZC2U0+K3fQVhE48wi9M0L1hOg+hzT5GLlBoJvKlwPwy0nB/XNxCSlkA3oVi
	 Zq5Tqg6m+9A8Um7hHXF9eEg/jNtA5iqOkWM15gP1eIg+7eezFv6GgM7tYhSpTb8EOR
	 M+VIQjM3qFn1f+gBYvrACm1H5odHiuYaipKFvPxrAPdkk8xpNQan2YpBRq8AuPNm7l
	 ARrox0w0CBjHRwemaDknNiPDqzDvILVTPu9EJd+tmQZOFlXsYnVgY6LfwgwCp+eVnE
	 yuMhyx9j8yaQQ==
Message-ID: <1efba81b-d4e9-405b-8ad5-0a170237902f@kernel.org>
Date: Thu, 5 Mar 2026 15:00:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Simona Vetter <simona.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
 Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
 <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260305093909.43623-2-thomas.hellstrom@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB170C0012
X-Stat-Signature: rht8p5o6gj853u5piwodtwzomqf9nsta
X-Rspam-User: 
X-HE-Tag: 1772719233-703874
X-HE-Meta: U2FsdGVkX19dBXtUNclMaZ4lrlF5mTcSCObEgrcxcA4JdX2NOpUmJi7xsNY8rU5Ma5CMKHSdf83vLG/fcq4IMmoHziSkjooLcGT0KwbJpXVaLpB25Z8wYEpwp29eQ5lq/b0tZ2+ofTk8q0DO5SxcEEa1gG6rebLgeUeb2VKkVHqkpd+7cp75J2Hk9gssETz+zSgte1qxUJqzfKbX6CJooFx5ZltjmuCb59it1BPFTcyPxIw+51W+8S+YEOxrU2UW8wy3/8DIXogf4TslUlt7IrMmcg4MvJw2I3GKsoYL/2br+6wp2rEOqot7a+CaHjAXF/UblCzOE/FB7GLzjyaAG0eX21HKbxWaG64dfHBywsZad2NgfvghkXsJamtPpyMPwD2NIGyycf8tqFjUdixMVQAD8npSdPirA700NwrWqk96QvVJydYb6EbjYoEs8Xfm+UqdHBW+Zp/wcJM7qBu7BlCD98obzioXtvcjMSi+HaGFfVAm9DKnO5JiIGkYn8auxBV1rizMKSF55yp5+pEq/y2EEYiaNXq1WJHeug+utDQ2feNfRddM7KHnTWVJYZE9m41JjNXG9KB8L7pJUmMtIUOHGiE0ZmB3aJqXe7V+Vvm7sryvpaoEU9UnGh55VnzhYPnktjXw/BuMiJDC1N50p1nfCq8PDbYBnwdIoUUUO5rHuVr1d63WgiiSCE0FHy80G+ZiySOddOOUugnTa9w/qKg5Ok0Q+LRENtEYKqPhxAiFbXhpJdqW4yem7+kfXORvptU2ym1/lHZgayOnoVmvQ2qCegWf8r1tkBtRmppbPAAwl9rfOVrUiSzex5aO11YH5r9lDh+eb+0wfTlzZtgxgxfPGlzJ6LLr74B+bZO5/hyR1HHxPEFy3HQAgsuiPD5qeKJiGwdpYbOPfqAelA2/Dv/yVasns5VhgGc3Pf+Ivj3DdR8fnuH3Jh2TS2ROzbpDmv00YpNyo2UdWVae0rj
 jtSgARVv
 iSigSH5qihIFQuDS6dDFZnmaFl9jn43P0/8IVQtF3S6AF47rysSZdiSTgx8/aSWGDsTNDV5xxZkHfKlin5hXms/lshXIMED1mDQXd7BGz5JNXh31ZbArTrx6AooscMQbl4VSEO6qKFh/x3L17V5acAr+qt2h3ONBwTISTP5DM4kHhFgk9a4UOvcMDTyvFBYa7Z0z+oC9wXQink1koa8OJWJ5yxpoK+iy6iKdOu7f0+8fcekgRjwH5x6ENdswL68wA+8zO0PTlxUXyKNdSpHeG7X6s39Tjx3mOrQnx7uQP0VK7CYJlaOK19iqGnE9RY5GjrlvdL8w8grzcRp6d3udnyLnkoBRZfVQztSDImxHT2NoYiPMC1JV9kx23jJ2QdcqU9khI2b3C0tX6Bzbd7EO9c2hXc0hC5e069aEakHfc8N2ic67gLUVqOBA55CD7Wa3ssIlnSD2r45uEpXy/XLF8WI4Wq8+XYGq209+V8Nz+6aMjAz+V4ZR5Bg72PrHIlLXHAeluNKjv6RFX5kIA76HfbTqAT/0gg2LOtdAXItw1GGj74dNAeSDOVWkIz1XurbjQhXnlisc4+8iRn+VV/sK9wjgJpmRcGKO/LxaC+nX1SARo9fWWQxrBfyThDxTiU4kr2lOPx7WJpv/Os8XeS3pxTrBKX0ur7MpB1fu3zS0kwFErY+gH8aMxw9xm5YM9Nm6zmOHlLv+qywpvKhQIu+mdxQqLJ8iPexNl/+mqVOppTTtbc3HTHbZBZAHBgASmF73pn+6Db+H8/HZsdwjn7DWooiN7gN/Yg6x5GKHO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 10:39, Thomas Hellström wrote:
> GPU use-cases for mmu_interval_notifiers with hmm often involve
> starting a gpu operation and then waiting for it to complete.
> These operations are typically context preemption or TLB flushing.
> 
> With single-pass notifiers per GPU this doesn't scale in
> multi-gpu scenarios. In those scenarios we'd want to first start
> preemption- or TLB flushing on all GPUs and as a second pass wait
> for them to complete.
> 
> One can do this on per-driver basis multiplexing per-driver
> notifiers but that would mean sharing the notifier "user" lock
> across all GPUs and that doesn't scale well either, so adding support
> for multi-pass in the core appears to be the right choice.
> 
> Implement two-pass capability in the mmu_interval_notifier. Use a
> linked list for the final passes to minimize the impact for
> use-cases that don't need the multi-pass functionality by avoiding
> a second interval tree walk, and to be able to easily pass data
> between the two passes.
> 
> v1:
> - Restrict to two passes (Jason Gunthorpe)
> - Improve on documentation (Jason Gunthorpe)
> - Improve on function naming (Alistair Popple)
> v2:
> - Include the invalidate_finish() callback in the
>   struct mmu_interval_notifier_ops.
> - Update documentation (GitHub Copilot:claude-sonnet-4.6)
> - Use lockless list for list management.
> v3:
> - Update kerneldoc for the struct mmu_interval_notifier_finish::list member
>   (Matthew Brost)
> - Add a WARN_ON_ONCE() checking for NULL invalidate_finish() op if
>   if invalidate_start() is non-NULL. (Matthew Brost)
> v4:
> - Addressed documentation review comments by David Hildenbrand.
> 
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Christian König <christian.koenig@amd.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Simona Vetter <simona.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: <dri-devel@lists.freedesktop.org>
> Cc: <linux-mm@kvack.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> Assisted-by: GitHub Copilot:claude-sonnet-4.6 # Documentation only.
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> ---

LGTM, thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

