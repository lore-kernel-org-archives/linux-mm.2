Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37340606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dMalAwg4
Received: by kanga.kvack.org (Postfix)
	id E67616B05DC; Thu, 12 Nov 2026 14:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43106B05DD; Thu, 12 Nov 2026 14:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55296B05DE; Thu, 12 Nov 2026 14:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B76E86B05DC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:52:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 542B61C416C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:52:12 +0000 (UTC)
X-FDA: 85427513304.17.2396901
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29C95A0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:52:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dMalAwg4;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794513130;
	b=X83/FD9j/BrS1jdJgUhivm/aYP6lCOL0pfG/yrWdFg5Ih6M1ABbiXA6TDxUynCKrLa4LYz
	xeaYdN9QSkucuwYWaMBH8Vy0RyGSpecaRoSCpwluH4koyDuNkRVBUA8VWvLVBwA9LxFG2b
	CjLoNBHvK41YbTkWmPAqlyzFroHQW5k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dMalAwg4;
	spf=pass (imf15.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794513130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MlVYwKClSr6axkVUrsf5Q0/gbt/MU2NgZlbXv3TdhJo=;
	b=WgaFvkHs5Ni0qwpp28AWeg2/HGl49z8Ja8I4eajtlNQByCZocCGRbb6tu/HkdO5X/TLnQQ
	NJhl/9mAKxM1luM30dcjS65m/Tya7r/wofPnLkZJpfHI9P9cZo3zyzSUm348spSH8dNhLA
	moBfLKHPlMmI4a9Ae4ntKVZJhPLG4mE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEA9E143D;
	Thu, 12 Nov 2026 11:52:05 -0800 (PST)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 314893F632;
	Thu, 12 Nov 2026 11:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794513128; bh=Qn1sSaGxO+vJ/OI4LVM3KSf/PAWaWZcvH2r7l0WtDFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dMalAwg4D4V11GtglDiciAsH1CIOvW0wiKBRJMTJRqkwqvppyFadYrD9i9e1KOQ6d
	 XaZJTrTpq7zdX01yAvHL7Q/+H7ypEJCScq9umkQj/XaFrI1xDhKuikjesnO25SEGOq
	 SkVbBI3G8Ex2o+VhAnoyh30a19eFbGVFB2cTCik0=
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>,
	Chris Down <chris@chrisdown.name>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Mark Rutland <mark.rutland@arm.com>,
	Huang Ying <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale TLB entries
Date: Thu, 12 Nov 2026 19:52:00 +0000
Message-ID: <179451296802.3304937.10304187215137449416.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <avPxZjjdBIlM_8_g@chrisdown.name>
References: <avPxZjjdBIlM_8_g@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uzjfoggf1swhuwy43ct9kw3okagyqzr5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 29C95A0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794513130-804168
X-HE-Meta: U2FsdGVkX1/d1FC5zHEtRIOy73q5LpR5v6qf8BT5KbO0/ThcBylTZGVoEZNsvbf943YPm3bJlWqRtOVGAP8zvv6aYxNzZQGUCofSecEwqj2UYxs/m/8j4bNrpGdB4/1TBYLUnVEJGkRp6KFQWZjMy1OoDspBN4lWlv5U46QK3Ssq8RSpEtJKPbrN//UfDqxGhLokBsuZTiDRc1iJ3y+zJJWtwEb/jnulPE9k3a2PKttRfcVT+pDFA+AC8P8jCft14hahKrbTeV7F+xGpaxVLm/BzBOoPuwdsMTU0p/KzZgTJDykZIPwnM16++j1P0JuRNPbfJckI6eNqHqj9tdscMvF4PJBG/vDwekMU+9otVvz2OJ5MBT4P37N/VlfvgtxPv+ZIhM3ZJqxQ33k3CA9BsrEMiT/+asYS6MYJ2MSmbKVzkvuGuBZR3nPIp9sMLri3k8Nbe362OaXY/WP5g22r3Hrsjy3ElZMGlz4Iul92ekjQowaNR+t77q2CFYKpfrR3m0nmSp3lPKIza+QCcssvlTvUJvYpu3QB5bliPniz375QlvC8/u9o3ZsROWZwArWPBcvxby33JOxRx619rjWMpf/6tcGbGUDPKohijgJSLaV4EWwFgbWop+TFmSg+C4f0uqlXT6itDQ3OlmqH976netNv8IEQMXYjVLsc4aBZjL75V2QbiIXx11R5bEWHvsDqR90vNtNU9Ud3bCfFjrXPwV1dv1lvcS93Tq8T+tHkXRp74ldpoY3523bNphVQCoGvN7dY2IXKxglKnAiB+ldaRb5ozS9WP8zkVKCl8GFNjp1ljeYAAyf4t9j8QyiircGOBhxdeSeJO9dQ66sF/6Qw2qE5ywk0Pb1pugDxhwVgppOK3vsPg2muvyayKOpKHIr79iXq/rNf3uCjHzFiyEcJiqHoQnvnvZgiiaVlxF8przH4QU7q2QIDZKgRrSKUYBM64/igAu2gWV2GnwnyJ15
 5lwlD3bB
 +Zg+3CcE3DtrBEi7bpAyp2KChV8xbNvMKyPzljqWOAoVtGht96umHv6wkC5Dqg831TA3opgJLvoMtzkZPHHuMTZTQlhU1nPw7KDiyPAS5lfWhkvsIW4y1Gh85wEkBsb8nGU7ynzifBQCLxgDyDq19sHO4KKof86cJQlruhmU/8GwKJupxzIz4dlZBYvCxM04SpjKX10fW2s8lrRvvv0ZrIzx2ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 20:39:02 -0800, Chris Down wrote:
> In Meta production, we have had tasks get stuck in a fault loop while
> using hugetlb on arm64. During my investigations I found that affected
> tasks share a private hugetlb page.
> 
> Looking at the stuck task states, I found the following ordering:
> 
>   CPU0                                 CPU1
>   ----                                 ----
>   read page
>   [read only entry cached in TLB]
>                                        write page
>                                        hugetlb_fault()
>                                          hugetlb_wp()
>                                          [reuse folio]
>                                          set_huge_ptep_maybe_writable()
>                                            set_huge_ptep_writable()
>                                          [flush local TLB only]
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: hugetlb: Prevent write fault livelocks on stale TLB entries
      https://git.kernel.org/arm64/c/3c47ec82540c

