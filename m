Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493A6107761C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A858A6B0330; Wed, 18 Mar 2026 16:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D4F6B0332; Wed, 18 Mar 2026 16:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A6A6B0333; Wed, 18 Mar 2026 16:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DE9F6B0330
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:52:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B24DD56B75
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:52:29 +0000 (UTC)
X-FDA: 84560382018.20.77E9488
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05822120003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:52:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xk4BVuw5;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gPDPE3uP04XSuNdZbsheC2vtbIrc4cqcngmTQFNGy0=;
	b=JUK9cvIvG8vz1OxNFP1J+BdcKO9xmvjd2WbJHrDM9Rx+dx5QrFfLv/xW2NbO3Gt0RpcbVq
	HNN7vpH9Xk+0qRgG5rocO0tryVWjmloPuH/Q/4L9O/WEUZPMLKqPNGlSHfdbVIrQYSudl9
	9hxMQo5CwrZXGrWLSjlTqZxTCxZLK2A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xk4BVuw5;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867148; a=rsa-sha256;
	cv=none;
	b=FMN3ghxK8ZDWHrC6FHAyfWHFsspx8Yd7ijMNyu+orC0RnkN5Oi2xLgG7d+0cM/CaLGtIxq
	4q5UKbq6EFHiere8TFNX/uMpsQ2goVPC+wMdKzxi5w7UJyf5fNwfy/xMuA1777WqzE01GT
	xWPAzPl+LfQITq9r9mMGlnVl9xcqe58=
Date: Wed, 18 Mar 2026 13:52:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773867145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+gPDPE3uP04XSuNdZbsheC2vtbIrc4cqcngmTQFNGy0=;
	b=Xk4BVuw5VIILLUcfGzi5lYXa16hNfK+fwd+kKGACgtY5nNJBPU/NiOpJFamI0qLlmbFX4f
	hAxYY9XURLXXeCg3UYG6U39iMNfGVI2LB146cmmbfgeOZSrLouhxmIW5rPOnrcY7mYaCdP
	DtyVcTzJNqHCMQV8ailmf6tk2REKI7A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/7] mm: list_lru: introduce
 folio_memcg_list_lru_alloc()
Message-ID: <absQV9JTD1mj9wWb@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-7-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-7-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ynnjmtuydnpx8brpmug13ujkox58fb8c
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 05822120003
X-HE-Tag: 1773867147-393943
X-HE-Meta: U2FsdGVkX19X5R2zAewH7cUI3L532U0MnsTQS1dT7jy3480TTQE5gNRFuprrHFbTD0IbNLygaISfY//QtnqotTGenlS35g65o+tTPNti5z5gzMJ1vfOPaNKI0ujyd6AkHx94zbK1GnOfToaZhk01mYDV6AYkls+Pjg1763ploEgl9MlYoqupmdUFOkwe/F+eCKLXwnrsoXVzEnMVjz1cSuMFJPq+mnJ1Ja1WFH2uW2WtIiSMdh/abZbjxgfZ+gRhORyG8zL8DVaF3c1zYSzfVjiaZf763ht8kmLP7kmnpLpqA/I4SxepUPRDeeyrd1Z6peTk1OvvkS9ofSHqtalTiyZne5UPUVIoJcuV2c8pWbDvAIs3Q6RehU7F6PA8AkljxIJX0xLzjp/YIqWyIgaNFqa3vVtk3sYcPQh4zJh00ESv7vgSGI30enBEMWrf9Gp+g0GoP/BjDPI6msdRO4NTsszTkdcbhLsx9V0dDVWVlC3m2gFEHHggJ8xPPD3vv1tFu2G9Nf+t4bZuRW1fp5fngKatDHv6KvSv+pT3qbCNn9i4DuCCpcivnXzvmm5DCQXPl5uy7Nr1yBQOv/lSe+loBU4oj314v+4a7EKwB5FcEJiY+yJUsUWfIRPpLiggKX07vZOqJrM+H7HClUPtiN1gJPqwFcJZb1Bbiq5IkTcf6/kdoqV0Nga9PifjHoKuD3Uf8cVAITcwWN1hjTHFCDn7KYxGfKgz5lAdABKfEyQyOf3qSzn8jrJPegi4U4lkPoz8cP6wn5t0M+KFz2V1xFxflmJ3J5HKaha6nbheNhESC96HDAA75bhHN8VuDjzM2rzqsws8rpi1pM38VcYDlRfxTV9bggmpEMYYzxcAHHWAWitWWscXMU97XyxJjOmocfgHPXjXUixWwBp7kvLFYBjwNzvEQzanxXpp57h1pWLoTQbNLy6VCvmKclJGZSYGwubxtX/EGkQK8vqotXqli2l
 HUfDbSu9
 7hlHt/Ukv2oVUFdOXGTG8zjb9umAJGUAxwgk1SRLUP94I9nKb0dsR1FlShEuh6VJmRQIzChLtTFmrdWD0HjxGxrUxrZxwXve8F1UYj+htwnqla3U1rg30WejEnYvpAUeTDBHqSO2o2rw2q2yuUjq7TbTWeB1kl4JRxoqwXfGJaEkLi5lEm8tDZfIBfLnt4VQtAahhAvMcqNqmw+k7hABjERfbpTLTVb0BQLMN/0vk24hmxJOi01KSSmf8j+AEXBswlXOAVM2/oKbV4jk4Jl2edxR9ISpVTX2n+hYWCnegkcUKgue9BVbRwXmNR2AHQvIzyv6Y3kl2XGRvgmF4+dxQPWus9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:24PM -0400, Johannes Weiner wrote:
> memcg_list_lru_alloc() is called every time an object that may end up
> on the list_lru is created. It needs to quickly check if the list_lru
> heads for the memcg already exist, and allocate them when they don't.
> 
> Doing this with folio objects is tricky: folio_memcg() is not stable
> and requires either RCU protection or pinning the cgroup. But it's
> desirable to make the existence check lightweight under RCU, and only
> pin the memcg when we need to allocate list_lru heads and may block.
> 
> In preparation for switching the THP shrinker to list_lru, add a
> helper function for allocating list_lru heads coming from a folio.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

