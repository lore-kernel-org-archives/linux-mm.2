Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C20B7FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 13:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61086B008C; Sun, 26 Apr 2026 09:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11F56B0092; Sun, 26 Apr 2026 09:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28646B0095; Sun, 26 Apr 2026 09:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF9BA6B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:11:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42F494053A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:11:52 +0000 (UTC)
X-FDA: 84700744464.14.13377F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 842571C0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:11:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HMRHcIvm;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777209110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fr68chTCSuJkNkls8FievUzLwjmEBB8VtjJ6H6PvY7s=;
	b=ZKHxLxy2LiJfyQ0IAzU8R9lAk3krpUowULpHNaAvGJK7xPE1CYLysFqy3X50NNW92fL36m
	6XFXjpFkpn/718Wa/9uLUPRBSAwoQ/E4wn3J+U8NHAk9Z8suMthm/bvUNZTVfDqa9RbeJm
	rjKa1jDxi8HZ6KHVAruFBnclDczsqH8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HMRHcIvm;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777209110; a=rsa-sha256;
	cv=none;
	b=fLImBNaOiLjA9VV5VWDjlSAFBOSW4zupZ//nShkCsxCRAg4kqucAGEAeJIuIWof3oHjHKd
	Lee538l6tt+/KTvpmqwp5IwU2zB4SZPjnDuizYxiQwl92gYkyyBudEWcEeq56EFDd/6LYU
	EPiHbpN+/XduACM0QQk3MEP6AcIHYLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 41F10403D4;
	Sun, 26 Apr 2026 13:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C477BC2BCAF;
	Sun, 26 Apr 2026 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777209109;
	bh=YEVvM6FpRRuRP61hJhb/+89MDOvpl5IwcVQvrSMPJic=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HMRHcIvmn5sefLGmSo50e8YvsVBMv5Yz5OKElcyIRunFMO8wy1QiSqIVyLyS5lc+c
	 rfDYSA4v1E10retZlXJn0OEQ8FymF+HTVXaxRoGkaEb3YwYut3pVP+g5RVzvrQbB84
	 tgV9Qj5srq4SlWqHPC28bJ2cZtbT0Hfs5YgwXZjA=
Date: Sun, 26 Apr 2026 06:11:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH v2 0/7] Implement a new generic pagewalk API
Message-Id: <20260426061148.944a69c2cb020b0d51f13f6a@linux-foundation.org>
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 842571C0002
X-Stat-Signature: rrsht7abkbba1khmc53n3wsu5z636c78
X-HE-Tag: 1777209110-297867
X-HE-Meta: U2FsdGVkX1+i4Gxrtbgi7M7OyOBeXrI+13DaJ6F7dXUy+o2oUtxK2CtaRAoqN0fnRnb6UmB6nf4rfApBlyGUsRcdkFW1YUj0kXMcM7tT/f3aE6aEIUoDhvZTA5lxMBo+5e4DeGZGvExJgKgWm4UcmvlOWM/XKgBlXtIaBKKQjXjSeTrLLujGgNz6gvDmC6ls8if86PFEJhbV9Ur5zaqw/ctYi4qo/Akr6kLtSvXEIUxUqdrkXwtL7VcybFlDBtfZpSs4U5okmty65KZZxOwtb5zBmf7i/ZDrr0i316f7BQ15Aiomwga1fSkgkLxPWPfq/bTfJTnpIf5NSpXlNm3d1kZRDkWiZig1egjiuia8inT5AGPdnezx9dWhpaRpHHp5RLjGdsQuDf0wKQOjlZCKYyqySG6QQET/DdvWjjd+jcGZ3rpVTonOvolyWT5XCj0yzIA7NEqlOiGlDxPKJAYTpHGtGnKELDApD50Zvv3ls53seeZ/OKhUbh2wAOikV7li8rH16+ChhZ8u4rI4DNLEPvTK5XsdXTUryYNOnxKUIm/AvvBFEPO3EiTOxX3XX1KbTqkd5VVPlHvUiduUdwFot34aN0S6ef0mq+8jawTHAlbPZXuDCaS3w+iP2m1xo1taGQsSi4p7qcMsO4gh873qBQUuhM+kTuNWCL3DhM1mNf5alnKt3oX3V6dvRT1xiLfqdwnOpIzp4RfUgw31FTKPV94oqWhatjtKvFTusd0P56PdjEar3Aa96Ra9TWlxaVUyJFM0A+snGhYlppMAGQZCBqKry3QApvqhMYjiI7JR2G/NxCUvD9HLtUZI/0UeYIDhCaPzYEcxclDhN3F0UC0gYmB+38zjoMF3qI4Luxom/FWtuChzOWB7VVv1p4Bmy980WgO9XkbgJFfLmxaUd28h6a5TEzyTsdLTrAs1Em9N+RHehFP85DxiqYU/ATTX10ttOyb+bjXV6/s5raRFSzT
 u3rm/1/R
 iDDbFuMmOK8FR0aOsL3/li0SBudI6UAWkq+294rtxcMyNpFwZn2i1o44nSttPQ4R4OVA6ZeaSzB55r86Y4BEQY641FdxVYCmnf0c9C1YyZEseyOhVfksC4cXBKUlWpw+HabgED4ywZeBquntZxQKUdUKnFWjd32eHhSRtXKelH5tg6OtApqYDjFX3V/EEedLLQMNiMhuLXqRMnbKggmf+qKAzEBKAso+dykoX603plMjPa1jlXoJbuVd2UvK4AvDAl4TGQjOFhSGE4sF9HeAS+//2h8FL6w+mB8666+uv9s+kOg6WV9yIhEV5pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 14:57:12 +0200 Oscar Salvador <osalvador@suse.de> wrote:

> Also, I would like to thank Vlastimil, who helped me running this
> patchset quite a few times through Claude, to catch some fixes.

Well dang, I wanted to do a Claude-vs-Sashiko cage match, but "Failed
to apply".  Again :(
(https://sashiko.dev/#/patchset/20260426125719.24698-1-osalvador@suse.de).

And indeed, there are a couple of little rejects against current -linus.

Giving patch(1) the "-l" flag fixes those up, no probs.  Roman, perhaps
teach Sashiko to try that as a fallback?

