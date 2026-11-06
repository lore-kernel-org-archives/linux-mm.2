Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F42606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=nwQSXUa2
Received: by kanga.kvack.org (Postfix)
	id 67DF16B05B3; Fri,  6 Nov 2026 10:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607476B05B4; Fri,  6 Nov 2026 10:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481496B05B6; Fri,  6 Nov 2026 10:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 203366B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:34:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 908A0160508
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:22 +0000 (UTC)
X-FDA: 85405090764.06.8C8C86F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8D60140005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:34:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nwQSXUa2;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793979261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YxG2ZmZM2e9qBTSySrFx7lsy/MjifUIQN5iXXAUf9Y=;
	b=h9bgqTPqrqdgJi2J13odNQ/DueNXroxhy0orRjI6NmrqGBRI1+hdxtlA3MaQSD6hg9FU9Q
	UMVwovr20odqBc98GRERNBqo59Tsv6ES6hWGA3Z43IBmR/7BouY1XlU0fHx3DKCMi5v7wr
	NDTvT1QipaZcOhin1p5cayyJG+fidLc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=nwQSXUa2;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf09.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793979261;
	b=okrTkV0ZADci9H6+ujv/AWwYkc4SlWrrpkimaytk45yrujDRgs70av/pYDbKHgb4Bj/PBv
	z3LkjFC8mY5kdCDNHswu52IcLXbliaQWBPXJc+u1qZCrjr6Qy9A9jZGMJvQy+Ho9Ge8Gpn
	X2/dHAQ6l8Gl10AiG0k7W7HjXb5YYK8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/YxG2ZmZM2e9qBTSySrFx7lsy/MjifUIQN5iXXAUf9Y=; b=nwQSXUa2bxKpHSEVGdWaum6xXR
	37cQdyep4RT0SyJtpDSFXQKFwmgnl/SHD3v1bS9x8dz+WfGChe4RZlQo6CMksMfLOQjOvd5WIf1Fv
	FUY32LP0p9GqyFw4JkD6W6/tQouC6mOeunPW5U9N46Yj6ufJNgCch6IxSKxHVu8MbprY3loJygtuf
	GNNwLKM9kOvePIQeF56CSSltpiSkeNjMUtU48twJPZEnvS4SBrpf84DwTK6sVYY9kCgaWiGoXJliK
	hyW81dnLOPLA1/gIsMLFSc01fkOvYQ0v519R87UiwMiSJIHcPMnZLxLio1SfVs5EM0FId6L9Gyrqz
	wdqi8GMA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPLxA-009NnJ-1J;
	Fri, 06 Nov 2026 15:34:08 +0000
Date: Fri, 6 Nov 2026 07:34:02 -0800
From: Breno Leitao <leitao@debian.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, baoquan.he@linux.dev, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ruirui.yang@linux.dev, jbohac@suse.cz, david@kernel.org, hbathini@linux.ibm.com, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] crash: keep crashkernel CMA pages reserved if activation
 fails
Message-ID: <au3zYIPmX8bvwjet@gmail.com>
References: <20261104145600.3708886-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104145600.3708886-1-usama.arif@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8D60140005
X-Stat-Signature: q4rf8dddgg1ghywkujcneo5q63g6xmxn
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793979260-783625
X-HE-Meta: U2FsdGVkX19XH9RtMQdmmqPtzjcz8fCX1rZ0alGMbuBsh9HTgyO1ny295LtCA7SWa9QMJFzbijRJL+IlpsmX37CI893+dZrLuwyFEjuJ4wwN1neYLEfyhdav3E/IIO7mf0OChnCQLAWnyZyxQ1rypnhQ2L7av9p8SKxXfU5sG0NrgOL600sKuV+XbzE+DmGcwZnhy5Y1t2i3+nZIg9Nqro5QlVYAbGIDt1klj82GRG6sL4ZGu8XYrdGX/mYMJeW1SjrlEMRAzEHRvcITZ8eq+S7yM3Bdaz9oe+6DvzLwiKt4uack5skLZcvymwCX6gQ7xEMqs09diAqdF5p+2nB3zWyKGyl3LwQ80Ud6UV8TpFKGxYtwqsO0NJL8744cOP4Ffi2qe+BgWCN5zOIDwjraRruaUhyuwACCUIzHTe6e+jHSNN+6UEsxGAMVSAMN8Ek5QgE8kAxSk+Op989N7KYwjN099QtI/1eNvyeovgnznc7HXDr93QjMqCINcylkpf/N9IIQ8PyoO/wCcMaifsjp+2LlzjLSeIJAXSQWcdDwf7LlbtsCOfGYLik4GaSkW/7f/Dwx6YRNNQmEYqabk/cfAuIHIQCCP/jZKjW+WQyJWIWjxXwvk6wkr2eTbUr66DexJnvXEViMa5FTnG+lzHOBzU6V1guAifMk74h0SVu/sNLQ5j9u/e7UC1V50MmbDA0ju3vhVIsV6fnrtxHYFIx3GtubvidctmzwI03ckTyr7rUZ4OPOwfA5qXrNgoFQrCc2+pjQgPV2WZJtdIWY7Rmmu4+/Qt8y503IgLrawiR+zFvlRkdmwOvGwfJqicRsT3rHdwCg5W4zLHMaRiHj131RULg8LxOob0gHyec48G+LDkVQZKI4YsCrlEJp0WfNo19hRHjfPmgyRs5+mAnEPaxIy2IXqIlLrF2jSYe7KXlrFk5LFS2csJDXGUyzkvZVIsXsAEN0dmNVuB8igLw6zIB
 4K3HzaxV
 BZpb9S5Uw5YMd+4Xzpm4N7rwtm7lD4kq5B5M7u7gUumr5bAjvakk3lP5sgxh0yx1W+P49y1nlEw0gx5ngvHxHl6f2OHOvM2EUVTc0mmtQjm+t4J8/5WpRKiCgMf8Ta6Y5zNRphXYzJuz2UaEtOzsnJt6lho87/1M3yXMpXr5dYT1MZCCwHCdBCJTTd/nXkHot0MNO3y2xm3kJvPtB4QzXzLsnB6+v6VTLJ9CZoR9iMZEUZTFUep1g4k1SM6M5K5EncfvYvSfXlsZthiV2Imxzma2R/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 06:56:00AM -0800, Usama Arif wrote:
> reserve_crashkernel_cma() adds each crashkernel CMA area to
> crashk_cma_ranges[] as soon as it is declared. If the area later fails
> activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
> inside it, cma_activate_area() releases the pages to the buddy allocator
> as ordinary memory. The range is still handed to the crash kernel and
> excluded from the vmcore, so kernel data that lands there is overwritten
> by the crash kernel and missing from the dump.
> 
> Mark the areas with cma_reserve_pages_on_error(), so that a failed
> activation leaves the pages reserved: lost to the first kernel, but safe
> for the crash kernel to use.
> 
> Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Tested-by: Breno Leitao <leitao@debian.org>

