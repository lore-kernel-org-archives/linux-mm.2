Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD55D58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF406B0005; Sun, 22 Mar 2026 17:30:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049566B0088; Sun, 22 Mar 2026 17:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A666B0089; Sun, 22 Mar 2026 17:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3E226B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:30:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27C651E810
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:30:27 +0000 (UTC)
X-FDA: 84574992894.14.6258672
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 718F0A0008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:30:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9Hcaiwg;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0KyxOVEvJB3ODPXp1F6/sTISYbeR0TOBYguwJx0seo=;
	b=q8dUOi7my+pAUAJY7uoyH47qUGYHqrOwLITv4r/415R7CrUYIK9Cz1XYPgHHannUVghIAn
	HYKY2ljWbx9X9NL9qdXujOerIKUGinBxsWe5YKDmnmxC3A6G8Eqa7BDuy7HIrGFayExulb
	DX9bCkrJgeIMPKNaY+0C2h174nxK4qA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j9Hcaiwg;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774215025; a=rsa-sha256;
	cv=none;
	b=XQhxf/Uefb3wI0+4H+t+glSXmKkni/u35OMt5qXsv7t3uB9ag5lhtPABA3GYc4Ssee+CjN
	s6antMThxU3cTMzrpuZCMApDTZvV9xECMNtBmc/KvFJD2L28LpmdXeqpmHZlhurzzzFOj1
	MJsxP21mQnkYLzPRLikzuaBQDbW+2qQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FF5543A72;
	Sun, 22 Mar 2026 21:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34D8C19424;
	Sun, 22 Mar 2026 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774215024;
	bh=PTlhhQzw40J9uUqv3p0SdVsqS3y8OudgMfIgsbJNjG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9HcaiwgB8MPr5UR1dgiijiNs3I15Ty0podWkwwY8tMX1PP/G2F+OvXXl2BYTkMQA
	 uvlMZKIDFVNG720KfYXuL7Nn9D5Sgty879SIN4iHD/KW0e0zbzsTh1i/lzrpJXHIbc
	 3/wYW1NZ8a21M7k3Pc6J3rYNewBc7jDwmpAe3F4R/4TDBwQESWYMfOrpyA/QkRUoYy
	 /Aoj+836eszpmRXsTadmZEKKTFMQ7VPPfpK3/imVDZHq2rDNLWU/KBxIVywSKngI7a
	 YV8cKCgrZ8bfx7FZIaT7NF/zvvEb/zHkDHtpu2GPw+6/b22+aKeMeW7Id/KAlSt/XJ
	 qzw0byazU3WRQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Sun, 22 Mar 2026 14:30:15 -0700
Message-ID: <20260322213015.89161-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322184641.251966-3-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 718F0A0008
X-Stat-Signature: bohii8f1b6n5tboc6ad8ogcuesfc9ggk
X-Rspam-User: 
X-HE-Tag: 1774215025-890575
X-HE-Meta: U2FsdGVkX1/sPFcHFQiq/gp4gc0lrmyXDlPcqeyI418PG4USZIz+bs4LZ1NyjX9JRYZNJ5CKgTpPiCvsOhYEmiHxRK6gZxYG3125ZfrCkVNSQiUNXixwoHmrqNzmxPFfqs8YtEGG/2q0KJyiydYsQNgY+Gm3X0U+aqxUO8tMQtfM7kxdmJnvBNyMy6lDM8ch4Hrdayb7LD4jQX1Y2H59pmEnIbdFsJTQo/bt9AbifnicUwP74bLP8WvSGDsowi7MD3Aq33qvIHVGYetSsW06/D/39U9Rv6ld+CzgxyAjYLitgU4oFtVNr1ZM3j3U9OQyHKBXx3hp3LESyGoFe4vuub6aPMSEu7frw4JuzVT+3F7KXYvA98ZTXyRtxIjVUx3JvJdbKDmAYHXrmEO4w4dYOmiquplQC9BHLpL5Kvsh3eTGwkyNpnII8isUdVFCfDX7wYwd8/QEgr2xlHA420ZGU3mt8bjkJ0k3wuu6/6RxVQ8UdvbE8R6OOBRta/N0nda9abP1PpOpIqCbAB5Nto0GAzME8aLKd0cv2N3K9PTo276dZUilL9DTaj+VO2P3jSWl+BAy27JWbCzpk4m8cFrciNUYMnKJxIlnez8MDnJgqI3dDoB5FwqT6pK7wiaZrYgVHDzEVUQBDOQsigRlkYQAdrJIk3YUEVOslf9LMJ4wtch2nB5hNwtfFQNpBGde1LhGg1WXoRJVUq+LCKadWbBX1ZyFNu+4SjBjvTu/QkNm9b5dOkfiwhnPxgI6nWxMCuTvs3D3icHnDu2QZDmpomQfWgaiKwYQFG02Ob4MMEuCvUuHK6McwK7YSkmcyrZFIR6td4eNknqdv9UAg/ASDiMjRvCxcXf6zjLo+9vGkAvAFE1nW/Ev/IkltWTtYiamosWXExKOkKmkxtPPhVAeFQicrgyOsM1L+Px7JpFzhcBQ1Qb3oYt1GqcV6fd0BCT+y6Syo03FawseSUxoDTAGn9P
 6nPmic1t
 PEq8IyTx5hBAik0my1SIp1OiB4K5X0oVkeuhF71GmmrplTajvZw/yqkVcJxPgDwu6FnrxdM5l1Gtx+nvrnrIAPTpyeCdjxjh9kFnQ5IObU6ivs0WWjikgxRP9cMYo1Kb0SeNQiGa6vhmmihDEztmXJgBP90WQlNa/tczthPIzxPWy1sqARuVZwXberLED5WPb/s2g+Hbq+etSb3gv91thwbX1LH5swnQSi6igMJyHZb9uKpTyEbaR22b5l+FSXBjHe9VB1hyEMDQmNvEcDVXJC20HMoiNZQGdEI4r+F6CFJVGQeYxLLOKdv54Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 18:46:41 +0000 Josh Law <objecting@objecting.org> wrote:

> Hardware integer division is slow. The function damon_max_nr_accesses(),
> which is called very frequently (e.g., once per region per sample
> interval inside damon_update_region_access_rate), performs an integer
> division: attrs->aggr_interval / attrs->sample_interval.
> 
> However, the struct damon_attrs already caches this exact ratio in the
> internal field aggr_samples (since earlier commits). We can eliminate
> the hardware division in the hot path by simply returning aggr_samples.
> 
> This significantly reduces the CPU cycle overhead of updating the access
> rates for thousands of regions.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  include/linux/damon.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6bd71546f7b2..fffdb08326a2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -960,8 +960,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
>  static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
>  {
>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
> -	return min(attrs->aggr_interval / attrs->sample_interval,
> -			(unsigned long)UINT_MAX);
> +	return min(attrs->aggr_samples, (unsigned long)UINT_MAX);

checkpatch gives below warning:

WARNING: min() should probably be min_t(unsigned long, attrs->aggr_samples, UINT_MAX)
#39: FILE: include/linux/damon.h:963:
+       return min(attrs->aggr_samples, (unsigned long)UINT_MAX);

Can we use min_t() as suggested?

Otherwise, this patch looks good to me.


Thanks,
SJ

[...]

