Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28D0C624DB
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 00:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC966B00AA; Sat,  5 Sep 2026 20:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D6C6B00B5; Sat,  5 Sep 2026 20:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3749E6B00B7; Sat,  5 Sep 2026 20:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 102B66B00AA
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:42:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 969BCC02FA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:42:43 +0000 (UTC)
X-FDA: 85181487006.01.B03379B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EFE64C0007
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 00:42:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DH+YNIWa;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788655362;
	b=hFD12TJYNOEwgqnyRf6aMDmZ68lgZIbvbYuG1JLDkX7mbUbBw0fRP0q3fVK4t33qTNdkP2
	8zN6uvsYe2LBBHY60MfuhXy5cgPnWdzl2OrRP9fn5Th9J/cpcbUvPX24/kelWvx8K457Kc
	eJN3kuN0MtBg7907qraYOET7ue13fPo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DH+YNIWa;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788655362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GM2SyBAgRCQZD95qhR+WEi9oXrPFIDHlTqyVd3dGmVE=;
	b=LGwZmdBXa3mhSmb1cDuqj4jYk53yO1sCApavUAP4dabe+JWw2WS5vFr8QoZBTOLSqCH8Cr
	v9XaHTDW5viR9pVo+mpAWTnKqfZ+RVNz4mG6jME6dGkNu9ZHjNg86Rzg946VHK/7buqZiG
	kuBdGkd5sa8WXx9U6WjX30xieHjr42A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F85A60D78;
	Sun,  6 Sep 2026 00:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6881F00A3A;
	Sun,  6 Sep 2026 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788655360;
	bh=GM2SyBAgRCQZD95qhR+WEi9oXrPFIDHlTqyVd3dGmVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DH+YNIWar6wt1hdxQ72+7q6esIgjvBDieMtYb75WVM9L5FOTr3Ca3mSeY5LpHYALu
	 SrooTcOzf/OGvsFOC7HuJGILmvO8Epx7K459+4ZeWUlKIdeHNcjeY8SafIc1lx/13r
	 R/+GTdeReqy0Af0lnKAmyMndnjwjcW8qNm/zpDZQ=
Date: Sat, 5 Sep 2026 17:42:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
 <abuehaze@amazon.com>, <alisaidi@amazon.com>, <blakgeof@amazon.com>,
 <brauner@kernel.org>, <dgc@kernel.org>, <dipietro.salvatore@gmail.com>,
 <djwong@kernel.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-xfs@vger.kernel.org>, <mhocko@suse.com>, <ritesh.list@gmail.com>,
 <rvvandan@amazon.com>, <stable@vger.kernel.org>, <surenb@google.com>,
 <vbabka@kernel.org>, <willy@infradead.org>, <ziy@nvidia.com>, Vlastimil
 Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Christoph
 Hellwig <hch@lst.de>, Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
In-Reply-To: <20260904115629.3993331-1-dipiets@amazon.it>
References: <20260904115629.3993331-1-dipiets@amazon.it>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFE64C0007
X-Stat-Signature: hxbpwho158jnzn7emw1bnt6x7pqcoxeg
X-Rspam-User: 
X-HE-Tag: 1788655361-939832
X-HE-Meta: U2FsdGVkX1+NflOW0eXIabvPRR5PUDYWfDcXh8PLGe67CIxNsakN0MyraXAPo2SJ+RePft+T+eQaXGwJkCsKK2SWDGEW3L4Cx7+Ce2dP3kDEculoXXfLno15lDrKqpm3R1zrR3iutUys69mVNLa4iH8JrVeph8//l/QDrO5FC5/PHnksDFrU5S/Sz37JG2h68cT0AlFDg/eJsIv0JPHJyg34ToW9G3sttiZQ51L8NmUaRQbnBqJy42HJVawZG6K9ydGxnVNgW5nves9xPXdihx1bSGfkAtPLwzU2apHOsOm4c9692i1h7cjupd7JXkfzL/HN8vRSLhzr8eJ3lr2LALVdB6hrcfCEHkaHpXCZQ+xDg9CDPwDQUz3a1IhyMC3sj806HzDA9mgAqbVmAaHNJgpDRpDjqOiy2/kckWE1KtqfTCQqism9fKX9zHp8LfNNLe4XerV44DNfmBfQNipn1Kt6ZauzJVCB4pgwp+I7ksDqTEzvkWmONmbUsiAKxBEYaBnXSBgC7jsi45IKvgRTL4PUIBKJcoyhnCDwg2wTG2VIzBnSDLgYpllS//MgwBLlbFiZvl/bHwSHFBRJgFoJ9MvbO3TlrGnockElSsjR/wimbVlzgmHRKf8lV59IEEDtuG/tgP6r6mScsGFHCIJmEtanjKzxtfjbikcYk0unzLjaUYMzvUGir45WExlKZwqe568eds0AW5OD3FlUT1ZJSEp3zHw5ZdTNv8Tt1u5e+VrS3lSMU543FkB91VbUVfvdM3EXVgD9EehOnTDIKLXUpqamSqI/BeZTLBuAoJqFxNFBeSODsQYpKQ9FFZWfYiNo9O78V8RajqXCJOneiFBk4PgbM/MnxFFZJBEQjL7tgStM8ea9ZQ8ky6Aq/svyxHhTMvTIG/PE04Qi/40ILbo44NSm4tWK7YOSKz3lKieh/V7bWMsfkq+fc+gWJWaQCRGbkc+2GrvlTixtULm9BE4
 P65s9DxO
 IjkHNRzMoy0iwxB6ADFM+8nW5Yyg8RBDap+pLA5ZxE5/rlBVuCGleQY5Jixxn3YMb+dHI+AbT/E7t7JPgzc8eaidgpDH9KJ60W1Ov/bAqzuxQ8gTEhh4xnJZiVAMceUVPtzkn9naU2zRiazFmwrzUt3oiE9+ijjqb82YpYqNZDqNVbcGLCXJ6lwPZESK/dsshQtWGvFdc+e/kBfit7Mkpj/KddZmTfXgkm8O+e1UMVVi71pjAodgDo4S8+AopwUaIB9NbydYb271na1dWKLHeVXY3PHgAxOAWfLTIhVRuTo/qy12nridKJw77PDWPF5Cb1dqi137W1YBps0ne0c2Sy/gB5gH2yhDMI44rGRQ7VkNBj7ipXChLOgpPkSAshKoOZg0kQxvm5CmVe5jsBhXcpUuJRbqwq7B+edCLvBBGX8LimvhEWCJtVlTBiNW3DF/Jhs7T0Ylb2mDqVu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 11:56:28 +0000 Salvatore Dipietro <dipiets@amazon.it> wrote:

> Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
> introduced high-order folio allocations in the iomap buffered write
> path.  When memory is fragmented, each failed costly-order allocation
> enters __alloc_pages_slowpath() which runs direct compaction and
> drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL
> pgbench (simple-update) with 1024 clients on a 96-vCPU arm64 system.

Is there anything particularly unusual about this test case?

> Results (average of 3 runs, TPS):
> 
>   Config                   Avg TPS      % vs Baseline
>   baseline (no patch)       59,408       -
>   With this patch          155,409      +161.6%

Is this back to pre-5d8edfb900d5 performance?

> Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
> Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
> Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
> Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")

That's three years old.  v6.10.  

This is not good.  Can you think of an exceptional reason why this took
so long to surface, or is it simply that our testing isn't good?

And thanks for fixing it.

AI review asked a few serious-looking questions:
	https://sashiko.dev/#/patchset/20260904115629.3993331-1-dipiets@amazon.it

