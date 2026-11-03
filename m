Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4431606A33C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPTCykYL
Received: by kanga.kvack.org (Postfix)
	id AF67B6B00EF; Tue,  3 Nov 2026 09:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98126B05B1; Tue,  3 Nov 2026 09:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996A16B05B2; Tue,  3 Nov 2026 09:34:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 799F86B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:34:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89BB640472
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:34:20 +0000 (UTC)
X-FDA: 85394053080.07.DE022B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFC184000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:34:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPTCykYL;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793716458;
	b=dpk6BUmAK1XqR5bHGWSns25thAwPwPw/srr2KSdhnw5cqrf+97uwjpMkcSSHdRbUbtEDgU
	Hk+UATn52YwbbKum/wMXsUpY0mgNovy+KyDuHQrd94+kCosOgEnRNsJFcHOS0KxbPt9RIN
	KXqVw3u75GoSacTDRigqS/wN1x85Wvs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPTCykYL;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793716458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ajyy7n+0qSH1YTBPHJg2ZBD7XeUrxHy6Kcj1EJImYg=;
	b=F2yLrMflRYf6yTQwTTouUFilVE41TuSfndXqH5Zzcxsbgw4xD/ONwYaNorN3s8FxPZ5kd4
	/5Aik8fsf0lxKsFpuUNCV23Zx3j8XxPNqU16IqPYz7V9/wQ1Kt4bIxlbVYjSPk66NelIr9
	oK8HSjZTl4LHHSWw3liYhd9RTrdE/es=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD8DA43883;
	Tue,  3 Nov 2026 14:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC6E1F0093A;
	Tue,  3 Nov 2026 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716457;
	bh=0ajyy7n+0qSH1YTBPHJg2ZBD7XeUrxHy6Kcj1EJImYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPTCykYLb7YyiJfftqIjfbRil9UPgYWqaphUQv4SNzGMIybk7zut1L7O8CycL0PEv
	 Smo0NgFZGhnE+mBm7d9Btecxf57Ahxs29iz8mkXeRHCPAETLHr85sZIyWoN6caU4eI
	 Ol7GIqDjsQJNf1roys0/r/YwrfJP37d3aGtuBGDBHiKYgYoKHl7VVo5s8XPI5BOU3q
	 Jlv+0oj6r42VtAZvavVTNp0T2saIeiOJ1iLja14RovmpDMdwqr8eAnzS0XW8QkM8Lw
	 887397wb8fvNkInSWSXM7qeWGxayhLmWhlLO+BDB2X2DhcHaVwnIi73BFArxarkNqm
	 vJrNG4eH9MRIg==
From: SJ Park <sj@kernel.org>
To: Wang Guangke <gkwang@linx-info.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Tue,  3 Nov 2026 06:34:09 -0800
Message-ID: <20261103143410.87235-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103034034.7978-1-gkwang@linx-info.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1hxg31zjaz6n6bq3ycjni9zn8rkatdxp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFC184000C
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793716458-982811
X-HE-Meta: U2FsdGVkX18ZbqqV8gLkwZYSUp2zWnG4tcJjLptu/u3tNUZvMLie+w0x9h/9L+gNKs0T+LOC6Du1eVXcu0l2+YBoxwRqtopElEyjvcj3+SbA8LHaotvKCaPJhO7my7CURyC4NkKTn9J3lW4ARQ6rw8ZaG1ZEcwA6F7njB1aDWkHfTot1ZAJ2e7ywQHrjAAFoJg0kXbn4EbTkFdyYyiFfNnm3rQTyIhGxrgg2BVCJLTOHhH954G37JMWaSlVK9A+jidJnlG7tTonCBviKuGuoQUxgNpOr6dLyoN98UXrR04KUgmKHu2iH7BRn60Cskr4h8F/CuN6q7Kfi9UBKsUI+r+8uycIJ/C7CW/FRp+oxAXSAb/PcsjmKwRNpcAbb+MKme24fmmjnH9UjP9WBb4bGyti5/CT2bXIGEE7MkyG01AlFroumtYSf1NPM66IF5ovexKQW/CdrIB2/35rOxAClOQYPIQvDf8UtiKLAPww+hMQ0V/KcoBHzBY1PLUN3e+kcN+fDCSxNS8ZZyns/LbaV/geetIe53gNEQFcOa7CEMmlIc3osiIsd75+X4IQqrh0mQoK3nD0xtVTq27NckeCf7fxa3NZ3jeMr6eiMV4J0bCVVc5bqMo4thzzcg4TANSLVvL9vDVxp3skoSGwuEQ/RAXF+Ccsl73oD3RwQjCJ85iJ47BiQvA9kN2/xhsU/c3OdfcTa7gmhUaHvGXubnr6CgEVg5EmECCPTfUIZ/01YMGG/uB0E+0fZNbZ0bQOREFQuG8/SnOAyUS6xxWHFHvfov9J8SQRQMG789PWhSO/114FfqyVNN22e+jeSYec9sUI9yVkvTHAahXEdrCHk2rc6s8kyNJO9kNY/j2kwePdXdE3KRUI2PDxs453jKeSHfTn1gf0fMvGY/SqqS3e5sBIcki5QpZ5m90HryDY/PLYBKDp4+LPrfx9HGCwGAFoYh6eQUnl0noVpo/90KawZK/n
 ujdZH978
 dtJG8ZihEG1YAa2fvLz6B4iPs8lEck3ozhkU4z2nC3D6QccKTYJtX0bqPwaY/84IXYkmh9adVWcf+eflKNOBjTLw3xdOaXagEsLR6IxaYKBQ/tk6TGzzHRiXQBW6ORMTd1neMzodGGF6tmj9QT+rjv4q6rwnXIVgXdNJl1eMEg5ZYieme1/YDU3I3OvoW0N3R8FZsaUCms4Vj0En7BUU4lCWsyFJyG6OYTVmn+pI1G3pnQkaCFbZkuxAzrrkOhSY8K1lOzCMXnx4QsuK9IYHLvtEt+hUzzSLXyd1atVf9FqbD0DDbzfqh+9p9SnCu0vk/bE8U/pxexv3CJEG0QNdIZ2CcpmrQ87YAcvqx9RgqS4+hEx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Wang,

On Tue,  3 Nov 2026 11:40:34 +0800 Wang Guangke <gkwang@linx-info.com> wrote:

> estimated_memory_bandwidth is calculated by access_bytes *
> USEC_PER_MSEC * MSEC_PER_SEC (= USEC_PER_SEC) / aggr_interval,
> and users read it via
> /sys/module/damon_stat/parameters/estimated_memory_bandwidth.
> 
> On 32-bit systems, access_bytes * USEC_PER_SEC overflows unsigned
> long once access_bytes exceeds about 4294 (U32_MAX / USEC_PER_SEC),
> so users get a wrong value.
> 
> Fix it by doing the calculation in 64-bit and splitting the division
> into quotient and remainder.
> 
> The issue was reproduced on a 32-bit system (qemu-system-i386): the
> parameter estimated_memory_bandwidth reported 362 instead of the
> expected 1926150; with the fix, the value matches the expectation.

Looks good to me.

> 
> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Wang Guangke <gkwang@linx-info.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

