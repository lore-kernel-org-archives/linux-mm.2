Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F363AC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8A26B009E; Fri, 17 Jul 2026 12:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B00E6B00A1; Fri, 17 Jul 2026 12:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2EEE6B00B8; Fri, 17 Jul 2026 12:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1D686B009E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:38:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B0B612011E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:38:41 +0000 (UTC)
X-FDA: 84998827242.08.3321803
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id A11194000C
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:38:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWn4IokM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784306319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2bUPeN9u+ttge/nHvtSSgPHXdHk+Xta8t/IGxUaYIc=;
	b=NN0WBglltBV6u3WF6XwBo9jRvJKYUDdZr2KDfyNXufF4n1F3zaU4A4KQty/A2aE6t5JJK/
	B3FgFnlHbGwH6/K4Xxkkuqpk35/b0R/bAWx/73IyRAYcKOVGF+fRaQahxUhf5oaYrc6yTu
	eoDS0+9+a84jJ2zv+7oDE7a97rhAEKA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWn4IokM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784306319;
	b=DV/i7IyTwylVOjUlRGm6ecqqErsxKKlVP8tU3aY9ReWb6R8RCsxM9WrPKyuhJiTQebDylj
	rnA6oI/tHPzz9PU3YmM+ZSuF49sYcBnA76lxWf9FUYjEMQqLgnZJa53IONKP2Bf3uAWJRS
	Nh/tugtL96J476Ml3XF9bb3zOUZSkXo=
Date: Fri, 17 Jul 2026 09:38:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784306317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l2bUPeN9u+ttge/nHvtSSgPHXdHk+Xta8t/IGxUaYIc=;
	b=EWn4IokMQWON7TfL2bBkP/KEvJpjG+Tc4pP6bSaD5OdwPQZoETIVDc8OFi8JjWgImqcro0
	Hv/DNoXvaXve9+3uXGZlwvQktlvLzsFStqQFnIPCcKthAmk0+YY4XD7Yh/fwZZYpdLFXwh
	N4I5y+5tOYM+abPDTKz/kNpdZ6/k+cw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zhongkun He <hezhongkun.hzk@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 2/3] mm: vmscan: propagate real error code from per-node
 proactive reclaim
Message-ID: <alpaZo0Jf6EIifFX@linux.dev>
References: <20260717113300.214717-1-ridong.chen@linux.dev>
 <20260717113300.214717-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717113300.214717-3-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A11194000C
X-Stat-Signature: ip1j365sep1oujye6paidau3hzcwwu37
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784306319-95208
X-HE-Meta: U2FsdGVkX1+A0u9NpikYmcfbg2dRAVLiQbgRCSqtpw7XDm0wi8p94Msgmas74vgatNGtZ55mM4uqWFPqcmYCIGK/Pc+pT9b4jZV06x31pisAdFpvmqKQSXE2u7f+1TNW9dyRgExvZVI9tARHi7vGLmdpmRQxVVUEqWsl7TxGPeMZjJKWHRAEeiOXA09heaVwKlIU3ypEE9ZtU36y+sRhH/OH5cAus1VkLo6Sku8ZIcj8u4WzzZz3Y7Q8sPrstarEXirr2q1YkFBoOTsnr4A5EAIDRfj3Uw1rgxCWDmUKI7DjT1a4R/u5HlA9ZtbEHiuioC7yirkaHi4+Anplad2hIKkUYP3KjRKLKTRcU5lKpFDE7epNoGm1y8KMi05A+mbZTdnEzoAF6D1EfyzjJUGu1OOnVw8KTLwAta6jBfGmdDJknG/jRbX0KqTWg2qHNOgXnAF3WnxFUS+nVWqHl92+euLKy4WcGuFYsHd1A/9TkNMegXETKuRoXIrRKUeYpX//ht4Owe+jm0LZ6F7fSfn068MgoitvEfgPVakeS1LcJzJpU6fbaoU9OgXzlnMNaPF3NHJAAbf+mMonzPjNBXIVs1ynFM2MFDU9KRPpbborN+9chlnVJr7VTnToE9hGi3LcUR3vZcDE03061wiOxNogtL2T2kMT3G/SWlTESPN6oSjo28tMQFkXBFMuk+Ew6XQ1qOw0LOpjDVPaMTNt1ga00CY5hNY8RNNNqd3j13dcJZc3rBKxlQZEeIhZmpqWcrqJN5airjaN7fPHHE768JPO6WoiHs+cg3t92OFc4Oynqg5E+ObakGwWAY2CoyBB1BXa1pJln+oN48+szlhNQHW9UvvBiHpAhK/qXLw00nNpYNTInt6R3qA5//mfz7iaRbms6eaeAGJ1uHFv39GkAaQBFhtvlVFqY9uodibkQiGp47E7HUdb8+W4DAghSixqrIWKJyp2B2qZso633noO07p
 DHwKCCyW
 SBfHqZ/L3odJYKcOZnK9vgPFMhinmXHC+iIztx4NLLzEQKMvj+6gh5yzPdFiK6bxDaHQPViGWOX9X89uiHSvv4zHrnpwkj1RMwd9gRW04dnEDCXaDnfdw7HQCFF/jkTt3DJhadHTmiwes1V1xFYQanu/OlotSYUcH7HwUSOgeD2R3QYeciP65mwsE5V1Og9+y8HpU21JCMqZGGMaygroDVyc9J7BLPAPrkrDMaQB8ilGUfCiQgsTxY7cjx4TjP0hhzPa8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:32:59PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> It has been observed that per-node proactive reclaim always returns
> -EAGAIN when any error occurs. As discussed in the mailing list [1],
> the interface should distinguish between cases where no reclaimable
> memory is left and where another entity is concurrently using the
> same interface. Propagate the real error code, consistent with how
> memcg proactive reclaim handles errors.
> 
> [1] https://lore.kernel.org/all/20250717235604.2atyx2aobwowpge3@offworld/T/#m3514718be82a31b05726a49da9b61fbfc69a589e
> 
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

