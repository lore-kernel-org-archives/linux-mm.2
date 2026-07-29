Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B879C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F26F6B009B; Wed, 29 Jul 2026 10:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C88A6B00B9; Wed, 29 Jul 2026 10:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605786B00BA; Wed, 29 Jul 2026 10:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 407CC6B009B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:02:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26CE4406BB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:46:25 +0000 (UTC)
X-FDA: 85041787530.12.34C11FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 959D71A0007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:46:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObB1HZI2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785329183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5EyZaIGNJh9pQIiNFuF+YnjsVzpTmxcyoyvY24Qa/U=;
	b=yDDRjH4/GAM9wLafjutaIdZxLuOj0lOusuF0cbeDhkG7h1/Ej8sQN3ILITNBkgzKwhCQS6
	T388s2zyJJlV6XJj02bjsAzF3ktCKeG5zkUjmXU60a1hVMXNaRdCilmQRL3JZd0x8deUrd
	DiGTlCpPEqXViZyn7QMf5lW+HP6zSic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ObB1HZI2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785329183;
	b=KNv4fLCUpRvOqfhwgLSUD1SGkF8zhB9IE1+bfbNbMdlRTVdqo8pFiu+xy/qEQmQk4H518s
	0jGTO9znRNtYEj8P1zqh4Ga6eCT5dSueDTxvxttHp8JVEXIPduUsmSDGyS40by3JY8Lb9O
	EJvVIKRWe5ZMeXMP28d2QzuChjOow10=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ABFD600BB;
	Wed, 29 Jul 2026 12:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A261F000E9;
	Wed, 29 Jul 2026 12:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785329182;
	bh=E5EyZaIGNJh9pQIiNFuF+YnjsVzpTmxcyoyvY24Qa/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ObB1HZI2xUReSJDP2xfClsEKHhqyIa8spfc7Y37Q5iZ+RK2x1JTvs1SHFsLJgOoH/
	 6cN8lbX2SrGbWwrvXDUk+iLhq2XBWTJ2ePH2u7RxNQXHJSfcVaQPhduWy9QD7Gc3X/
	 TKF8TAwIQoLrC6ac/QqWSVoSpHttRfP354lmrOEkE7vqsugiVeeP6sClKSoDXOZsVl
	 CRJOVqLAuFguFbehrxgosKmu1z646x5qBPw4v6PQYkNE/BjLxYbDQ8qw+I926z7r3r
	 tFzuvaL0aiSFXpQhBS7LqGWdJ9Yxu0Na7bbBqKEN0EOWCfdz54SnmmccTKhOsnofaj
	 WoJP5rWipU+Ig==
Date: Wed, 29 Jul 2026 13:46:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update address for Brendan Jackman
Message-ID: <amn17f8tb0od0Voa@lucifer>
References: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-email-change-v1-1-666ae7c2b7fc@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 959D71A0007
X-Rspam-User: 
X-Stat-Signature: x117sburq1s9yjc8zwar548m43rch7w7
X-HE-Tag: 1785329183-925641
X-HE-Meta: U2FsdGVkX1/dNhYDE8IDqGUJeBu4GqJ3fRYdEoKrJn3ZC4yhcEOz3XFm8GAA5Sl4oopu/dDxCCnbpu0J0KSXPLz+VQW1CJIVsgivDMpEVzO26+XqIxf7r4P2gVgoNWcgPbWg504tb71vmybqygLMroZ0NgFWnqoe8ulhPOICy3kE1ShoBc6Zrlp1sW3k2+A5zrphUS0hedkHlEA+q6IRaizW9/4hAD4gl/EmwI46aN7MFS6lL2Lo6VAcfH6t9lUJ824CFQ7u7+5yzC0o07iKb9nOrhbwsvH51+nCngUpqqNbVJ1RjwiJB5BwgGeEBl3vIJfzk/rvFbCpJ4CVZK4orPcmL9rhtaY6iSWCgEWu/yeQBo20Kyp9KGdGyVayc/igNj5SiwwdP/H+TeCsGglRLo/aSdyrVmBxj15uR/W6wwKmu53mO+J4neBAIh/CA111w8StevxaKHyZpQTAhVxQFbkqvjLAiHqaVMf14z08ThRMdAMsX/TF2NyACm3kY5jjKvUXdfLOIPqvDKC9INWBavWZlmrwKK9dJKPUKcRi3MWjKKMbbM4c5uoDqJ50EEJa6xknMLNNOv94yjFBrUhEXHNq6Vn6PpSbfAYye6fmr2hEMyl9G2oTDuXD80r5VXk6eh1xp0Pouj1I+ST5hw4Mxzu2fbufuaivnqGF7eYEeG7dRwkLhgUiCOs1uGO7WWkTfF/rh2eX1QlmfP7xlLg1TdTyb5X91G4XP5o5Mrizqk4N8YNOGgLcNYaE5GGiZJ3IlcVp+9ITIp3sqjgHfk/l/sqMx8D/fvpE9jtQJ81CTZj2OgLQ8VlNw2LvkxucSuqC2g6YYyYs1ttALwZ+e3Hki3FofrqnsJlc33QM/ENPIhYx/GX+Ra4ePuSS4Xzc7cd0EZZXWx0o7TKJUtQMg2I1+0olTHVryG5LOqnBwOm03yfz9bn6EOv2WuAVRXbbNeFTg4QlgcARJMDLIvW87Qx
 CZniSEIt
 F7MFeTlRUBTEDDKehS3qWilFLSswmmEbjrxrSMaUhBbQpBBM/hTv6M6HyFs+fQyNg8PCuFPEtdaUayanVuPyRRx7DFsBtNgkkvipRmsS+gN2wu0lGhx1SwWpSEvNMfJrpC3XriHB7PsjYEQpXq4B2y4E5Aw1SuXSBMrk4HMxe+y5/wzS4QzFNygsHuZKiA+bQwmQv8y94+9Ulg3ECOpoOiv3Ia8IZQ7mcnKf6ysON92Ti3F8rnQfVTc2ybnyfmNSqq8IdZfvOdTfrKX094YWu2SSVVNeVqC5/d9bryUZe9j7HtACrnzxIuDTvpp7BaU46W/C5d+3LO/z7MHMz2z2Y7SlPLNt02JyxRnDAG8NWxY+rDDUeQpR5LyhA4eCfOVy2LKxZDqeIE84NSJpNbrbMyCskQOScKLCMsYpFSCr4tZT97UAoDndS0RfQJkT9o469F2MNXLP0GclYtp1Y+tdzmuC6IiGL8KJHxb12jG4OF5kyN+Uq3wWEL0mx5k3HVu9LY9E7cADl+xY58s52R14vnRJctC3pCw97StlJwA4rUQFEMdWEMMcZ7TMQWmhqqEBAgTQ+L4j1Id2Egu3w5DL/FP2hZOq44ScAEbIEcmza6UCsGjIEPOME9V5FPh7jynkvhTuOEFa3XVPGlzFtKjAFH3mezxapTN5n4Gy0qb4T04QKf9GIgcNQh8tMAxThCmpt/2NFyjbN/ESufu9cAkhO0gldpu7OrLxsrvNY+Pod8hjz6TKF+/jhdq/o09RlKwWGz9D2nww1xW+M4FhDhxcUUf1+eGOUZCKfAwYqyR/8ICGBGyHmXiyqVddXUiV601u55GGIgdGYUN5WO2qORzoJ1spYrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 12:01:48PM +0000, Brendan Jackman wrote:
> From: Brendan Jackman <brendan.jackman@linux.dev>
>
> Switch my entry in MAINTAINERS and .mailmap to my @linux.dev email address
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> Signed-off-by: Brendan Jackman <brendan.jackman@linux.dev>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I am leaving Google. Luckily I've mostly de-Googled most of my Linux
> workflow already, thank you Migadu <3

Wish you well for your future endeavours hope to continue to see you on the
mailing lists and at conferences! :)

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index ca6dc25758026..7324e1af59c2f 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -170,6 +170,7 @@ Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
>  Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
>  Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
>  Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
> +Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
>  Brian Avery <b.avery@hp.com>
>  Brian Cain <bcain@kernel.org> <brian.cain@oss.qualcomm.com>
>  Brian Cain <bcain@kernel.org> <bcain@quicinc.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a22b942616cb8..2657cbf6df903 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17162,7 +17162,7 @@ M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
> -R:	Brendan Jackman <jackmanb@google.com>
> +R:	Brendan Jackman <brendan.jackman@linux.dev>
>  R:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Zi Yan <ziy@nvidia.com>
>  L:	linux-mm@kvack.org
>
> ---
> base-commit: c73b725a57f276a3702ca213bde78fca029bc619
> change-id: 20260729-email-change-8924aa90b1f4
>
> Best regards,
> --
> Brendan Jackman <jackmanb@google.com>
>

Cheers, Lorenzo

