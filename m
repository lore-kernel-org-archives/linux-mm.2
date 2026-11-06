Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61384606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XutjVlaN
Received: by kanga.kvack.org (Postfix)
	id 562556B05BA; Thu,  5 Nov 2026 22:06:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53ABD6B05BB; Thu,  5 Nov 2026 22:06:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4777D6B05BC; Thu,  5 Nov 2026 22:06:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 221346B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:06:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A40D0120C39
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:06:02 +0000 (UTC)
X-FDA: 85403204964.13.4CC99FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D99A040006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:06:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XutjVlaN;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793934361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZkGjQt427pHZpQ9JbotH8VEMJC0LS31LlX+t4WlA5c=;
	b=KsJV+hmBhGZ/zn9R/5sfr9NfxXMohH8Dddpme+uv/kW4vdXCjYKCctSXqE72Q4Jdx3nMiv
	8Jr4Xy2C36O7vz8PulTsX0W6863KTD5xlrX0qEXc0nh4BZ6ixM2WGFm+LFaEzcEktq+0+L
	PB15T8HFQm2Mq2cxEY33nHRiOTQJs/c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XutjVlaN;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793934361;
	b=bCCkRuk8CCWibVPWB0ge9qX9zpf7fVnEXgPd1AI+j48tdTps0nS5iE3+XGf0lmoFH2zLpL
	FJ2luoGjps2YCVK23KD5zcLSv9YN9fHRyW90xeno30YrR9DRycMIV/FhO6dEuV2SYFu28Q
	iEhHdGvsezXcSEp0iL+KoEfsZAysZXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F3BD40411;
	Fri,  6 Nov 2026 03:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90C11F008A6;
	Fri,  6 Nov 2026 03:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793934359;
	bh=YZkGjQt427pHZpQ9JbotH8VEMJC0LS31LlX+t4WlA5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XutjVlaNn6zbWPzBchJpHcdLyBIU7b+pScmD/VStJs/l4IyHUOVhjba3sEjIBlBBa
	 X2AJiEabXK9IiqnTWe2eY3fb5VODELRZJUkiXoib+ImUeveYD/aTJV6ewlxlnPA2Fx
	 lYV0U6JcejL3hsRq5X0M7wGbFlzKp5AKFcIU1XWI=
Date: Thu, 5 Nov 2026 19:05:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
Message-Id: <20261105190559.5656444f0cb52cbf888427a6@linux-foundation.org>
In-Reply-To: <20261106095340.lgMcCHGK-lkp@intel.com>
References: <20261106095340.lgMcCHGK-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D99A040006
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: anf3j3x9zuokdqcgeehs1hzqi7rrtebt
X-HE-Tag: 1793934360-669862
X-HE-Meta: U2FsdGVkX1/cpoaO+Pe+15R9XLCHPhVB1U5v8yCEDc4SU49z0NSlsCCndbGyrZ3/Xg3zQIprAZpebikoY1vraZANHIYAmFc9KGjVbJUpFCvhRpWQ3mVg/YnbwKp/R6LnXImMTov3g2swCzW/r6luto/H35504W081/7ZQJ3xFTnRyfeZhkstilIUH/K/eimqRR835j9ftbWim4A4ZcEpSB2+eJvdiUTWPRYAudELRDx2eecwmoPh1fdsxmeeT1waTCYeGccxtZQzRnWXAekH2Ho61WJMDXsM9/AvNx3ztwoHSolz76JBYAZd1b/wIcqxBOP0gfqUHDUjWpsKt1khycEA4VDQNbRR7WzBlMu0V4AWAByHZyjoF1EhcvGiiAWviq4RBSaMDmc+vYP0UaVJZ61DyKDbjFMrF73re0d3gtneccnRkyAKGOt6Qki+zFUI3nPYXyZONskSW/j680qHKAtAbmptQR3h6VRptS/CHGT3E4iBLHm7E5CwyG5pvte4xymfv60IGDK7DQi4EcrvoVH/wz2ZxkbIKm74bFyBS+OPeyHJ8axaIzdpvJR1YiYBF4CtukkWP+0FRKl3z2CrsN26tEw0qcEjjK2k9gCjns2YbPtC/i879zEW6lQYzpV6nDyZw4G/mkmSrcLjxcRffMY+32xPnEaG/tIzQnfgEShcRs34ASPTjLlKYG98HVaD0cx8R1wcRsVkTzn2IB1kBXzBb9dthA9qu/SVu+IvDRIAjCyuZmW7Bx4lsZ3Fqmly41JWgvx4H8O9P5mmnt7jqlmJ/9ytOgmwuwqT4JRbntSH+3pnS8tw13JWbRb4Z4BBqbYrU7gAYtNSACEU0ldh1kUvxsnPq2mNzWKb7Qlf9sdIXBz4Qh5EuwzOkSj8JvHr7biQE66VIHtIPtBJYPTL/qy1ul5qKf8m3NP9D3bjL/5gBNGxXY2xtddButVHN/Yu7s0g815CaERyYKpcEVb
 pNsw7Asd
 fAzCCHMWULOfQK6zOHOcclxY5+NOM3jvkiIu0H3BI+vGmmuDfVn4MILyUKhov1rd1bj8MPXIeIL+Od0eu5A3xoB9m+qdMHNvBsXlD7UqFxJISHCtW1ztrazumlOFP1YLc6AV1n7BXAU3+SYPjIt86fUd1KQrpXZzf7gV1gDexT4KPVSGB5ulhn4seJdj69qfrxb6u0IMDc+3Bfnp4Q+vUp38Zcaf8aVok743dfrwqSCCR5E745y1XGOFYfEcl+i5gPRkU2a5rL2EyyBGn3+xd6DkIvTZJ3b3MnY6ed6FYcLm1Urc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 06 Nov 2026 09:53:40 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263  riscv: mm: fix concurrency in mark_new_valid_map()
> 
> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- csky-allmodconfig
>     `-- drivers-net-wireless-ath-ath11k-dbring.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
> 

Thanks.

Am I being dumb here.  I can't find any error report other than this.

And I'm not going to lose much sleep about a CSKY gcc ICE in ath11k ;)

