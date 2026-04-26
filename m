Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A048FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 23:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5086B008A; Sun, 26 Apr 2026 19:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65B86B008C; Sun, 26 Apr 2026 19:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54A26B0095; Sun, 26 Apr 2026 19:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0E2D6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:03:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 040B416066C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:03:34 +0000 (UTC)
X-FDA: 84702235590.16.29553ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 60E7940007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:03:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YlJWjHgt;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777244613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouFMhW/YXpilBJI1TeEuS8aBZ85Tr5dLhIM52hnn2ZI=;
	b=cXQn2uRazV5VhXQjxGd85SNkz5dU+SeSSsZFUFJTnTMS8wr6PmjpPwFRqVJFy3LMpf9jFC
	YAs+dHWWGSKYv0LWXcVKaRAttX7pLNVurIuAplXvutWvJo/8sIhSLP6NqsojyE4wB5v5bm
	/N/TXiQr3J8mWnuYx3AhNr/WXu430j0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777244613; a=rsa-sha256;
	cv=none;
	b=inrz2AzXq6NHyPBtKoLParMEG42YF+myOq/TpNk/YsQM+UH0laZEfLWO7doAQr/QMLZ+0+
	+hhSNGe8q1+b7xEHFYv+z1JIpXEx/vPwXrR9Afq1GIKCQEYfPdKdcH6TaxXkp/o+8VJjzx
	2856V9KZJrWbH5x5038o9rkz25Bt4Lg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YlJWjHgt;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 854516013B;
	Sun, 26 Apr 2026 23:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CB1C2BCAF;
	Sun, 26 Apr 2026 23:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777244612;
	bh=Pssmh29rua0G3vOV364oBo0PTZnVdOappMtfzOGeM9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlJWjHgty3V7f+TFjCTTSoMO9eVq3QxibsfL3USNcWt+m+mQAw0V8oHOQzF0NPdmx
	 E2JVEskMw3+0fcgpc/QzkABNkw7Oc7NFMr9C3iSy25Mb2/V1YLUIvv3NlhnEJlNQWA
	 zDfMnJxeNCWoPFUfrmoF6v/dyU7TuuXs4Abuq6u+GH8gtF1qivbcte7fnARGBTkAQd
	 Y5YxBmUkfsRFqdtGX3hLjg5ED4NV8p0RinkPlujKnO3XOJf7G6kmudkV9GuvdR20Va
	 1XlX14eFJWaUwyp4+9Ib6VuwoXDZPyevcvENziMot7yITaYyKgpl34QUguPdS3oqvI
	 HWV0rdIX11X3w==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH v9] mm/damon: add node_eligible_mem_bp goal metric
Date: Sun, 26 Apr 2026 16:03:21 -0700
Message-ID: <20260426230322.106206-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426213859.1835-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60E7940007
X-Stat-Signature: ew18ydcscfaw7c18bnjuz9pb3x5u3xcb
X-Rspam-User: 
X-HE-Tag: 1777244613-884831
X-HE-Meta: U2FsdGVkX19Heu0z9q17RiPxa0XnjMdBYuDeIfKLqQVbcS90d6QB5W2Z0dmcEBDM1qZquGe3z8CSZHrjWUpZXGMDGWtfZAWh6+puNlJORW/tqkfJIwf//YWNYL+DhJl3wv1/T6TzZPs7jVKGkP/cEBWQWQYt4RQz+NLtQDSF9z6pIlgD65ehO0V6ZQD8IS5yLrCF8tPzlRmIFV2P7mCdqNA4XW2AT7rnT1cQ8YBNEWijj8su2u1zBlP6EtdjH9SoE3k0RJOgmuBHuYKsyRiTB0eLvTHfFHkQOV1iap2vHsCv84uQXFf1TltX8qMQ3SwikKzwgm2qLBKauabd1N4q+Rz6p2BqWnO3vj1TsPIFqGRnTiLYrSFCfS0+sLIsNlWtkf2N83XZls2uk+oPfKJqcs/yLcacTX4YTUGaXAgdNvVxbYCNpTX/K9BtvhwhKr4tTlO9c1WCaNDSUPhLV3NvIC2UnELz7rR4kcZcfMR8aJ9rPUcPHkgkQh2Ba1c71/kJPxZErU7eIu0xVxTeMekmHI3TW2Ll/XnyKA72en8GbnBKd4z4MAZgHBJQNDPEwcGgtAHlgsi5Z74E7EwazAISdRsMnScwvRrY7TBjjtENN9lEMLMvHcVnQgIc/lAfWKosaWNR4o74ZbizdMQyt4NvyPn0YkZyjn/mCTU59Ncf+GxPKWysyiAzPr2uzSnaimiHbpEJvJiUDBx5GxKvl0iYSFUZPqs2SYkWBennu7VdBUCl+BKfDbhlhwXZX9DrjRBasvIY13VsUav6it0BknzmohIRe6QiGnhewyUm0bzXabPWWMNtqMpzjv+112ah4Mta2DWPI8TIrQLGbB/qNNFnh5s+aWDoXrLDwb+79RhJD/nyKZnjfdR2eMPCDBWefpzBmGH0xfTUHYwNE8XsSOXovd5sN3OdV7cwQU21zyJZOuZ0smajkWvbX1LHXNVGDYiuBkhVk3mQV3qQKdpIquQ
 00YiS7GE
 Nxl+ihwDnfF7afETKqoUJGEgB2lsPuQTVpcvloTXeuWPnHPwIy5VBeOxK1rSricLrEYtnEgyWXYqJq9nCxx5HglZKMong2rPBhDq5MU9dnZuNXEyuJY14OcwbIjevmMaSENDRwP6ezcMDqz6ySlr55iDZIzJ4OrLIDca12EIhJEwdb7fhNO/Jtkm8dYeKsrEqLITIIPE3pHPUsRmGzjiuY3TSFItFC3249POpf0ixdXDBX5A3kviyq8BXlWs/5UrHrIxjd5cCv5ZjEKYGfB8N0hMl63VijmhlLuIItlOic/hqUwzXpSWKW3UUoLcTSIQ6KwFeWLNycUIEkQEafDnSsKRCWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> Changes since v8:
> =================
> https://lore.kernel.org/linux-mm/20260426003245.2687-1-ravis.opensrc@gmail.com/
> 
> - Removed unnecessary casts in mult_frac() call to fix potential
>   divide-by-zero on 32-bit PAE systems (Sashiko/SJ review)
> - Kept original parameter name 'ctx' in damos_set_effective_quota()
>   to avoid unnecessary diff (SJ review)
[...]
> +static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
> +		struct damos *s, int nid)
> +{
> +	phys_addr_t total_eligible = 0;
> +	phys_addr_t node_eligible;
> +
> +	if (c->ops.id != DAMON_OPS_PADDR)
> +		return 0;
> +
> +	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
> +		return 0;
> +
> +	node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);
> +
> +	if (!total_eligible)
> +		return 0;
> +
> +	return mult_frac(node_eligible, 10000, total_eligible);
> +}

Sashiko found [1] this can cause __udivdi3 linking issue on 32bit machine with
CONFIG_PHYS_ADDR_T_64BIT.  Seems that is correct to me.  I believe below
attaching fixup can fix it?

Ravi, if my fixup looks good to you, could you please post another version
(say, v9.1) for another Sashiko review round?

[1] https://lore.kernel.org/20260426220409.95B26C2BCAF@smtp.kernel.org


Thanks,
SJ

[...]

=== >8 ===
From 828ddfdfa3a996efc4620919a3cc77d55088c466 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sun, 26 Apr 2026 15:54:48 -0700
Subject: [PATCH] mm/damon/core: avoid __udivdi3 linking issue

On 32bit machines having PHYS_ADDR_T_64BIT, mult_frac() with phys_addr_t
will cause __udivdi3 linking issue.  Cast values to 'unsigned long'
before calling mult_frac().  This could cause divide-by-zero if the
denominator becomes zero by casting.  Avoid it by checking the zero case
with the casted value.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0ea747d487465..aec43314fc4a9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2921,10 +2921,11 @@ static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,

        node_eligible = damos_calc_eligible_bytes(c, s, nid, &total_eligible);

-       if (!total_eligible)
+       if (!(unsigned long)total_eligible)
                return 0;

-       return mult_frac(node_eligible, 10000, total_eligible);
+       return mult_frac((unsigned long)node_eligible, 10000,
+                       (unsigned long)total_eligible);
 }
 #else /* CONFIG_DAMON_PADDR */
 static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
--
2.47.3


