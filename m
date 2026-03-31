Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61DC7FF60C2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 05:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A9D6B008C; Tue, 31 Mar 2026 01:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9022A6B0095; Tue, 31 Mar 2026 01:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F396B0096; Tue, 31 Mar 2026 01:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0946B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:15:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE4F414097A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:15:03 +0000 (UTC)
X-FDA: 84605194086.17.2B4B628
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0901412000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:15:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ho556UJ4;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774934102; a=rsa-sha256;
	cv=none;
	b=bd2NhLUEXpn/82Zzty6tIFXVCMZFpEW0qTKpWH+PLBj2MyPMpZSnjoICANtCl+XHyIHoor
	JV6fUpJl5SYTKsClUbFFpsGAfOPAdyezmZgMnW7IGnn9XpP0ZWxuQwXKi0KCNF4tSgtkEM
	7aHLN0IedRiRrTaQ9A9CsXM0e2vEzo0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774934102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPPQl0XwsBjm2lswGHXiGfs8Ssv8jDUCGkFDWefUheE=;
	b=r8UyF6ljD5t3jeJa6juD/6eY5hZzk54tCFSc/67PryXT0FAgi8AxfJehPYZYtJ5y4rGaiV
	64Hxtbt1UsXB9XvdrmypGASK8ggTG8d1q9PSTrrG5iXn8Osj72/Mkx6S/VvIlf0ralxHae
	bDfmSymVFnMULTJgcDycFe6Ri1SYpmU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ho556UJ4;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48762600CB;
	Tue, 31 Mar 2026 05:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D99C19423;
	Tue, 31 Mar 2026 05:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774934101;
	bh=m6vXHv+hxo99iG5dI3XPQgsu3KBW43Y/f16iDN2u+fU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ho556UJ4SsEPhuIGcdF7Uct6O2topnSDWm7A5jrm9fHUUZoLjR4jyti61bEgPG0Q1
	 4OXEw4DFFOnbRmMUHfw4qrOBpiJa+mCGf1eZPan+LaF0Y015vaIUfTauGzYOkJa0Qy
	 tK2NmGm5BwepW8Okt66rBmkMvBhSNiqBXkMwKYy0=
Date: Mon, 30 Mar 2026 22:15:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Li <hao.li@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, david@kernel.org,
 osalvador@suse.de, vbabka@suse.cz, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-Id: <20260330221500.01d5466b26c969f460225bea@linux-foundation.org>
In-Reply-To: <ceqmspe2x2p5uv5bk3jyiw67qkyweaviclcjdp6kgwpg6v4kdq@f7yd6rr2lpkl>
References: <20260330035941.518186-1-hao.li@linux.dev>
	<aco0MtqpysMXMZdy@hyeyoo>
	<23feu42lqvc7iymgaxmnywea7c3qie5vmjm4aijbgdiazwvrcb@mmlxjowgtotv>
	<20260330144640.161ca53e94b37b3252de2e95@linux-foundation.org>
	<ceqmspe2x2p5uv5bk3jyiw67qkyweaviclcjdp6kgwpg6v4kdq@f7yd6rr2lpkl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0901412000D
X-Stat-Signature: nxqar7pd4fghxz5jt6d3g4ek91fj495o
X-HE-Tag: 1774934101-602582
X-HE-Meta: U2FsdGVkX18rD6n1mvtijaAaDaNByBb5xhlk0DBiVmy0FrqMpehUpTlYwDNY8Z1jTy8SiNEwo1ZriI3Y8YF3piPj3xMDO1mJ7Y9vDMspSWYXOP5UsTFBH5iR7PUn0ej9isEsv+E1JpX5T+poP+lIfvC1KpjC0Geilkj2n79DT9pBCF21akoKLGlnL+0mdnpa9etHTpmd4uSGPJrLgB5oz7ZNJop0VCy1a1YpzIlBIbLyt1UUK3d0grztkAywocxQaZ3EEWGDeFUx0NFUff9uGYVmT11mU0aVlgd9AABq54HBu6Ir1b3l2lW1NJZVvYRlWqPKj+Aox4tgn11+DyHvVqBP9XkfiqZEeGJzKk4gf5cbCJhnW/967OD1lZZqSYO8dMMwVxObXr91lyodBnsP96XeaezGTjU3EMv8b5uPe6d8AgFXCEdGmHDxCYdVCq+VsTAoBoze9shFk0ykms1dmfSbtQAEGfyG0jQ2whggxMl3dp30wR9HHQy9wTv0xFew1cVwa2nXtTuR704GHJICIoaXcnRiwRwneuO1ZERVjTAtoNAYYmcllaM5Bi8Mo0FqkIwfvasjBOAtWfhCgBvRXNRyi63v7PNh56IwyodVLWpcbHJhs/2AQBKcPCePn7noTyWmH2/M+oA4BBTAwZ+/1iIAeXOAXSvG2EVC//plllJ/e2ETxrqTBaKXIisCeZdFPJGokpyapfkAj7O9cr0tHqy3vHYkX1eLUYrAPD303IsxN/QFMT1+orE6Ma0suCLzRb3v5vglmsw2u08g+Nj+I4gIwLwfOTY/c9/ERPUZLp2/TJ1eajWHjuiMulXwsw/BWjxM6NdTciGoPbLDxo2M3m/XkdnkcsHnvjngucMBO25KQ/Kr8U4sE0zsuXd1ZSTwwbNvbflg9nO+Yj8qQSNBZk1wRPU737mnz66tEw0uhSzQVR68W7vq7L7GHq5cWENSb7/de6NGWJzZLC4xWRV
 ZDkCsXV8
 HjfU0eYrtggi9UJDOu7IUX3locdeb+Td3zXPfuwLILwUyumItJnIWR0jY7EjhxhFX6c6sNP0QkMhvv1xnZjRQUB6M5VBoZDvjES0wabWbG5IDIW1wsh54z18Ltr30II2zIyVSL/LinLXZsHghqin0B8mZSrX7wxd7/41sg8TIiW5XYSOVx9ggRiwnl6xF8GIUATY9FLJeucviQUq6VVTdFLuH3EPbgmKdufmoDTSINy2YGJvC1SgPxVjUsvtDZWQS+eC1eBW3mCod1vvOb8MlGa8Ipq+FuPgRgWkOhs4/7+tDRg2+oFrxOcqT0An+ihz5a00pAMhk81eFUrC/FKeXeak73l4raAYHU0W8XRRqKVLMgVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:24:46 +0800 Hao Li <hao.li@linux.dev> wrote:

> The most visible effect is that
> /sys/devices/system/node/has_normal_memory does not report a node even
> after that node has gained normal memory via hotplug.
> 
> Also, list_lru-based shrinkers can undercount objects on such a node and
> may skip reclaim on that node entirely, which can lead to a higher memory
> footprint than expected.
> 
> Feel free to fold the above into the changelog if useful :)

Very useful.  Added, thanks!

