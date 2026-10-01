Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F91CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646746B0088; Thu,  1 Oct 2026 10:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E3C6B008A; Thu,  1 Oct 2026 10:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534006B008C; Thu,  1 Oct 2026 10:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 393426B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:52:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC387120470
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:52:27 +0000 (UTC)
X-FDA: 85274348334.22.04E2F54
Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	by imf09.hostedemail.com (Postfix) with ESMTP id 937BB14000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:52:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=acz08jLC;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790866346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxNjso9KjpjP2pDGx7oGaiU+zaJJp4PBvs5wT3NhcQQ=;
	b=awkR5Ymlbe/2v9ozZNdJdxOKblHLv5S9a+ODhL8PQZH7SNvUlSgxVU4y8ZMRuXo4uodgHS
	XUewbmDzcCinEBp/PEkmaJRg8hCH5tqUmoyEmIwOu7RQLFD/f4V+QqgiKEQQRiHmtG+Ivx
	6O3OGABRSKxqvAUeJ5r5ienk/0O44QA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=acz08jLC;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790866346;
	b=fzRfsA05IWfe1KO830AMCz6Z7NdayEXhwDA+VJrLNhWwC14lM/gTFhJ/4u72w3G/5gIsuQ
	7DQV3ZEp0j6f6uxvoLgvw3MK24QmZsJf5SEZzWy+GIkYPAguFvIu166KvaOw7sVYivYTbQ
	1Z1soZIw1Ay09bUofU2UxeDPlyPtW9M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YxNjso9KjpjP2pDGx7oGaiU+zaJJp4PBvs5wT3NhcQQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790866344; v=1; x=1791471144;
 b=acz08jLCHokKKFFoktu7aVdnwKze8YfmCpzWps0Qfs6x7Iz04dgN2si88PqT+WHvE7diE2qF
 lhQiu9vG1t3YQgRzPX/RXUAmicoMsNLdvj/Jy5A3eM//nUT+E8t2xd9WIGnAjdDUyluNIX6LLvy
 fhKT/MmqGbdnTsDGkfTlcjVM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 476754a991a89109;
	Thu, 01 Oct 2026 14:52:23 +0000
X-Mizu-Trace-ID: 476754a991a89109
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 4/6] mm/sparse-vmemmap: remove the unused ptpfn argument
Date: Thu,  1 Oct 2026 22:52:17 +0800
Message-ID: <20261001145217.19370-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-5-songmuchun@bytedance.com>
References: <20260929053231.66085-5-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 937BB14000B
X-Rspam-User: 
X-Stat-Signature: 713og55ubd56cr7opoxhuxajxxgo5yy4
X-HE-Tag: 1790866345-177651
X-HE-Meta: U2FsdGVkX18QvCEi6HVLr9KuVOl1KyglqQFXDqJJN8AYzGoAy4CPks5VWWjjyaf8e3w6xaqMURB3DKv8srPUXpSoFjZlMKvfU26kfMXeHZdVgrQ9a543tdVb5MTXzNw1rfJOWhJ2vDHdetwdR5YsHY9GcjyrJjK8HOLit7uj5PKUz6AlXAAtDbVVGKfJLt8Bv9jtRrMjgPj0RqwGDMs/tmQoEOABmyK1hMxt4OpMK911IizW2Q9+K+1DeKBtArT6iktciipnIVVps5r+HjSnleOcqE9Ds5RiBGWqoCN88yQxvwLsurf7n5fkzAiWAfuEBqETXwCEtbkbPcFLi103oi08k0iohOpfMskRhsSIs89cHny0EfA2QWb20TquRhdiZo9OCPwyuBWrLdLKJB4LF3YqoRDHHhdXR6WXqra2ZB740Bf0ZPzV4fiD81ujFyMId8h9RvaQftR1JM5snwzKB0tm8QVxPKiYCvb8z1+y/2bHSNQkFsybslI/cgFB+sqHTEz7ie5hnoU4d+sjgDsmgj1EX0PqfVQvoMRHSU1UknfXtlcLZkHUdH72kIY6kuw0EglhjA8LU4+IxvTgRJy4eDFEOQcoRRlabiUBeLVF/T8YCk8EMmV90JTCeyfgtT6SZHnsqlzbpZsogXYxRuCqM6Po20TJjqGamc1DFHyme5H93T5kqubkz3d+mYh8lGCtBrOyreMM3kFo4yy3wANIWwNuAgvtkSnezn51OFGA1llywRKZ7TrY4JOaVdumdIONlwZleVV1afu8pbAVZB0ttfX7jWN+RWMzfWXMJLbH9gOkuKfMU4O9BE8UQhFTJw3CBKyQXFiQufM0fafD0brFgiaGh64peUIU37j9etiKxvzLnMxPBlx/J4q8quEjOqeyXEIZCOgsZyphPhhJqUSVX3GkVKD7R8y5/YAv3/EFTl9Zgpq8sw4PFaMkptrd3DZVYhhTCcUk/RIlmq66Ifq
 SaNFBIYS
 uwqIv84hNJzZse08PRTxb3gXRmXXE+/Yt7Qqq0HXnQbOwUt2mPs2+/Mp4T5Mr4KE68XPSOxcn/72W8jDg26YP7u1Sfr+E5iYfwLtzvwFSSr+u9tIXga3XkG1ytxqeNGT66Rpjlyi2utcGDktLpBSYuDubn9Z8EtQ+yJArQ6OeL/LfjTx2YrZV6SL5hnrKviV8nsxfGzdmKUC2rMdbJrqT+2P3WPmTYln6kjdmiHEhetSDIl4sQJTcDFkNQwdZ6XLjtk3z35BrkSmErFivWOvHq4VqQ/34N8y3UrUWmiEzz0R7VfArnnYSckr9QzUxVsYnk3AhemOjHEb1OZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:29PM +0800, Muchun Song wrote:
>vmemmap_pte_populate() no longer uses ptpfn as an input. Drop the
>argument to simplify the code.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

Nice cleaup! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

