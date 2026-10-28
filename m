Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B28606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=uHAG3HqB
Received: by kanga.kvack.org (Postfix)
	id 56DC76B05B6; Wed, 28 Oct 2026 05:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E3D6B05B7; Wed, 28 Oct 2026 05:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4339F6B05B9; Wed, 28 Oct 2026 05:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4136B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:20:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12074160AC4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:20:14 +0000 (UTC)
X-FDA: 85371488748.15.6C2B74E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE9CEA0009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:20:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uHAG3HqB;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793179212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZFHM4+DLjyn47zDsovu4y4A00dH/kf24XvJgX5dD+w=;
	b=EYxQLncPWx0I9LD3+AsqIAV3BUVgMIXw878dqwngnMN3PnuAyO6ziQrkpBeW+ktJlkg2hG
	NMksXlt2aKb3b7OxMscSMAAWDZoOietpYNJonKPD0IdMeFh13Jn53dcYWG4YlPECBaRaFD
	emwCBQZRzrHcTQV0i2SjvraGY4IhGlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793179212;
	b=ROwSDHHeY7VaFGGW6NEuD0uWQkrVuk+8xL/PDXOt3gl6cxicNO998OxkIVN+tYgPwCiHTN
	9kx3kgZlcw5uHZDDJ4VcUv66hZKHsTKIzWMO0tVTGTet0jVpYmZEZOoMyDa228Ti/1dRgw
	btXs9P3jxLyd6UEDpIsAZ2Ip19xuwxI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uHAG3HqB;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4ZFHM4+DLjyn47zDsovu4y4A00dH/kf24XvJgX5dD+w=; b=uHAG3HqBdy5czMRd0B0gFKODf7
	xEiO9EmxmA8jDbYlz6b9/g8ePrlc4NeMgIo0P7k07/aHHx5/5hcJFVfbJRREuWZXG28yVn7eBFeNx
	1DN/Egp1H12OBO+Otyc/u2RrO9OSF1v2pjl1fluCLs885s0+Ua8hhOjyexusDFeiPPyskzUdnWPiK
	gSOs/YtbHExKIHNwb7OfIUwnEYeaZKeHB4H/ViBtKLcR1/LX0VL92nagvmTRTmQXZHjHY+kDdZKpW
	luQUeshAZcwlNW5Kc/VZ4xOqFtScOOXV7yXKj8uS+PAwN+b+wjUjHIT2VsH8gXk4BppopbuxL+a1u
	G0h+TG5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLzpF-00000002RUY-45tI;
	Wed, 28 Oct 2026 09:20:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D1BE830120E; Wed, 28 Oct 2026 10:20:04 +0100 (CET)
Date: Wed, 28 Oct 2026 10:20:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zhe <lizhe.67@bytedance.com>, bharata@amd.com
Cc: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org,
	dietmar.eggemann@arm.com, gourry@gourry.net,
	joshua.hahnjy@gmail.com, juri.lelli@redhat.com,
	kprateek.nayak@amd.com, ljs@kernel.org, mgorman@suse.de,
	mingo@redhat.com, riel@redhat.com, rostedt@goodmis.org,
	vincent.guittot@linaro.org, vschneid@redhat.com, ziy@nvidia.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] sched/numa: refine memory tiering promotion
 heuristics
Message-ID: <20261028092004.GG2668804@noisy.programming.kicks-ass.net>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028041253.74839-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE9CEA0009
X-Stat-Signature: 8ew6cx7d6rio9uyocz16kjq6ujjkpqyq
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793179211-280780
X-HE-Meta: U2FsdGVkX1+Nhn3W5TQlFg9v3IeH5RCRbdX8m5Gz4rE8DyUMRjANpvq9Mz6ypS0V62146hTlepl/M05OqQonQHmkLP8RvTrSIcHmN16FGikRC/7JwdC0aNc1kyeDCfsMHmnTsWKhthGSdANtJTRkvttdFbWC6NEOAr2+Mk9GfrdDv8xkdLb6U/d5WppsNSOBlYtKagTUrsX4IjXMp4l/EpCfxqeOEzmIWwqptawtpRvzkTxiH9CqD6BlYhM9MHwO8AOfeV5gQUUQ6AiKr+XLSLaZXIwMIbdy4aNW0d4n9o2Dtu4k9hNMMuVvaChAd/200rk1rtGp2TL0uLCWn5Ow3XQ1fg2ktaoxDxmQ/Awuxdx68oXLWy7yXx4iRKh5pOcXQeMUD/nMuZtkSxUAHZZhqIHIbpMR1Tdif1vqxU0HWRdA10bpnkR0RLRXptMHObB5gZjj2wJv7SVTYl/2d0DJN4j/PUZuQtkptHYtQiA0FttIeeTjfFcv/t4HP16ympwGEKOtSs2TREOIbdyRlgkWoHRpmu+c8cPHEs5dRQDtX+PkBrdu6BAytLhD1j2qayRRFi2e1RCP5XUQtikqVDtd2+5YYQuZVVWVwvOWE/bCFIGao4CrURpMgYViOO/IFpEdgsJBxYtOfXiqySGQo3DM7jWbHWGpbkEzvW+4gI085ncPjIo3DTZ1ZmiesDSYALapcueWvgHCYcD1Mp6isZYZICeDmTUM6kgLzku0Rm79RVdNez3H1gYVYBJRPaX3lV9GLj+b2Cb3FtTNtOfYDJis1HCZeVlD6PqdxmKOAnb/1HIpOTe4WAyF0okS6PIh1axdv4MU8d3VD+T4MzuRtoh4ylaXgfQ0su98l3pzUV1P6LkbFdmUP/wxgvy++LFOasZGZ6gMjG3Ej5xVEyt2jpYG4eR37UYKUug2kwDx17I1ctfnhylleDVZr8QwaJmLAsLRdi+5hVFK47EwMR7SjY4
 SbIjO+aH
 iLYU4lTx73B/0CSkAPLMhps5+Pk5ZDVfTx7eBnoO0wCn7kxIiH2L8ARChTNkq+98TvsI14/CgixuJ0WXxkS682P7n0W4CDCtpTU1O9zMgnb98y9gDqUzgwnAuiaPkZbK/uRAdkVCDLQiZbGxHMtMtMVe1SBvvE3mSylGL2+MYu486AR9SJA84wUT4RykJNAmEmD8NnOM1vEVEfE0IZd3cMJvCXDxxKvoqZYUbOijPUEH46bhRf1+TzFqz0Wzi3gOdf8B8GmC+4cBA//oYsfK5QoPNsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:12:50PM +0800, Li Zhe wrote:
> This version narrows the series to memory tiering.  The generic normal
> NUMA balancing cleanups and heuristic changes from v1 are not included.

Should we not look at Bharata's pghot stuff first and untangle this numa
balancing vs tiering nonsense, before making an even bigger mess of
things?


