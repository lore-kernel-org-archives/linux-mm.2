Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BD6FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7395D6B0098; Mon, 27 Apr 2026 10:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710706B0099; Mon, 27 Apr 2026 10:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EE26B009B; Mon, 27 Apr 2026 10:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55A896B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:52:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81E304051D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:49:28 +0000 (UTC)
X-FDA: 84704619216.29.5E67DFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF60118000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:49:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYMuM5TF;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvnieFavbwcEPaK8KPFd5GIKpqcEfe297TY6AAATeLY=;
	b=UADmNyGuvzdcamtl1iC/Fzmcky/v4Jg51V7bGxv1LCheocn38E2nNssR3CALSahWaZmtE7
	NkTlyyVYiucJYAuBF+Sh0VkaC2ASyjkFPbQwdQQc7Dz+A9Y163cABAoNXNTWSVpM6POmnK
	y8XLRcLIx4jWFAYuCECi45jWODCyG0M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SYMuM5TF;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301366; a=rsa-sha256;
	cv=none;
	b=PFoEYT4Cj8rfSuB0ddnMQIY6ASNSryFtcHX4MhKvrp91bVEWjix7tfxTD037n/9J0aC2Fu
	PF257nEaWNjrSOH6zL8yXO7LO2/pdrHClVb9kQX2dpaxyZ5eJWoB11Ms+NwtyisDNOG2wz
	2aKo++dd0xN5rsBBuj3O3xhPsut7rLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AE40160138;
	Mon, 27 Apr 2026 14:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F271AC19425;
	Mon, 27 Apr 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777301365;
	bh=Pie6H9kqpjFwLcPtbrm+7WML7Q1A98k1SS00JCWV22g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYMuM5TFKXTJ6aCxcFBt93wMfV9JuHwsLvhTYblz2FPcqf2pCbAtc6mF0vovH3sRO
	 d97a2kliIigXgAOmBV1dSVNdDki1NFxWsNx+br6CEN+P0r+v05nmfz2D1jm/qwqN/g
	 Bka0Kb68aOjHfApRXOEcOhdBIJihZW1JaIew4Lt438T6le8Qz1kfzUcvtCaTxYwAU0
	 i6PZdY9fgU9hnZZkI2JA4uFJ+ubmpwm87J26kiNfT6gqVD9x6RetS80mVUpbgZPr5I
	 2fPEig6U/gMRQ0xU/ImslkSjgwwSG0pjh+EhuI0QsemcInFfMjxs4kSHuJvBwFqozo
	 g22bxt4NjwXeg==
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
Subject: Re: [PATCH v9.1] mm/damon: add node_eligible_mem_bp goal metric
Date: Mon, 27 Apr 2026 07:49:13 -0700
Message-ID: <20260427144914.112106-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427010209.843-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF60118000E
X-Rspamd-Server: rspam06
X-Stat-Signature: 1fpnz64y9qu1x96dnuq1djnkix4s1cxu
X-HE-Tag: 1777301366-544645
X-HE-Meta: U2FsdGVkX1+l+ZLqDZOQiA8GrMqQDWdqNBtx0jZ7pdTJBgqc37Pr40DKWTyoYhf7uEUj/GPjl68mNLkz/XfNiFsriDzdVmbIBrpc3j/d+EBq2WGS6pUHSOLW366Cole/qeYsRFRGE2R7ngUcThS8PuikoEKiI2e2w0d38lKuJwB81suMiwmFsOlz0w/kJrUU6Bpd85aUtTS7aHjqS+C8gMkfTEsDqlhRGdnLbNBF9ZX6WVy9MDNGj6OUYwGD1CNTw8RrThG/MfAe8YcENPwSoYTzYBLMVtsj4TKhHGfKacOq2/3kinoM6UWTh9Yvr8nbikHsk4JMkY4nyJWRpTyrCU+Wv+eqci+RvxwePYbL/duJoYR4Ei2V8QWxm3kSTvn6XaETzoupb6yTNRDxVdJfmmMcZ/exvkj58WQ39EFuz+aGsQXccniHRS4qscLEW5HlL4ntXsd7uUob0/JEW/S05/jQceqaBW0mjdVc+vG37tjgAIi8co8tcf+LeG6odtdhql2cGy6Y0NmuKpPgOlj24MOWYg/nxXIQAus6vti3tQHzqgprsmoJW/AZ+DkQ4eyFHQnRqJYWzTN2ngd26GBwpYrfGlAYM0yU8LunBFUMH1AjII6isHaNtSM55ezwCorK6XcCKIsGZbzyeKNZ3zp9wQUiYYn15kQVosT3/saIZ+LsuB14khQNkfpP59BHcR4HqewTv2WD7ylONYehySdiTdQwLH12nPGW2Jd5+L29KrWs3X7PgpB/OCFrpIqpCMkeZn4HRfFIooPkTHNVNpiSGGKD4ObD1500va2wGc7AH/RBo5WBhMsNhUenMF3I5xI9sRu89rWcMiJ98jwcGpNh9/am2ypF55DdCn0G1y7P6YP5GCUlny8ylFMKwK4fY+FJKkPuOxCbYK8JlkmIOlpTBRfAMpL1IGD6Szvm2OG5YfpJxnn9xH6vzzKPAnlxbv3fzAIDVS1wsEAVbJ0Liz7
 IsSEbkDS
 P63vyprc5POBtUct4Yz867eRWP7QZAoxA6/4vVUv9su54QKD0QSVn+/1aXJgPBPBaz2zLUKPFUlLNERvtaHDCVISIORnLTabQAdLlcHIyd/viaIoE53813JPSa8Nn+qK7VZ87bAaM1b3RYSwPm5f2wZkAZ068ldnZQ7Qu2xeZnNcNPeAFJPytbcCjs61eNsCTf74hwt8EYsR04q5nzCfHfxIauB6rkVaHLBzmhMJr736n2TH7FbjjYOptzvgj5Tw/jik67WuX8nfyHsCdS0aUcV06e1x2McPYRrNXtuPmERnLxA3dVdhyqfUNrIxS3UvW6Cu+hrKuJ8RN93JelR4NBn6b0S1PVFDej0fRQ2nKT6MVSpoF2SMtSWgkX8DdyIrBVQeEJrUhG7IrMYNAdx57oij25O1al6TUD1DI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 18:02:09 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
[...]
> +static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
> +		struct damos *s, int nid, phys_addr_t *total)
> +{
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	phys_addr_t total_eligible = 0;
> +	phys_addr_t node_eligible = 0;
> +
> +	damon_for_each_target(t, c) {
> +		damon_for_each_region(r, t) {
> +			phys_addr_t addr, end_addr;
> +
> +			if (!__damos_valid_target(r, s))
> +				continue;
> +
> +			/* Convert from core address units to physical bytes */
> +			addr = (phys_addr_t)r->ar.start * c->addr_unit;
> +			end_addr = (phys_addr_t)r->ar.end * c->addr_unit;
> +			while (addr < end_addr) {
> +				struct folio *folio;
> +				phys_addr_t folio_start, folio_end;
> +				phys_addr_t overlap_start, overlap_end;
> +				phys_addr_t counted;
> +
> +				folio = damon_get_folio(PHYS_PFN(addr));
> +				if (!folio) {
> +					addr = PAGE_ALIGN_DOWN(addr + PAGE_SIZE);
> +					continue;
> +				}

Sashiko found this could result in an infinite loop if 'addr + PAGE_SIZE'
overflows.  The probability is quite low, but could we fix this?  Maybe like
below?

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2349,7 +2349,10 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,

                                folio = damon_get_folio(PHYS_PFN(addr));
                                if (!folio) {
-                                       addr = PAGE_ALIGN_DOWN(addr + PAGE_SIZE);
+                                       addr = PAGE_ALIGN_DOWN(addr +
+                                                       PAGE_SIZE);
+                                       if (!addr)
+                                               break;
                                        continue;
                                }
'''

Ravi, could you please post one more version (maybe v9.2) with the abive fix if
it looks good to you?

[1] https://lore.kernel.org/20260427012429.D25C2C2BCAF@smtp.kernel.org


Thanks,
SJ

[...]

