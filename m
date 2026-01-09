Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416E6D1A63B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6E56B0089; Fri,  9 Jan 2026 09:31:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4F56B008A; Fri,  9 Jan 2026 09:31:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B79B6B008C; Fri,  9 Jan 2026 09:31:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B25E6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4867C8C987
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:31:02 +0000 (UTC)
X-FDA: 84312662364.25.C3F785D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 41E0118000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:31:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pHpVFRiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767969060; a=rsa-sha256;
	cv=none;
	b=eTR8iftoY9o5FFR6ZkZYd05EJQ6fgPD97ymD4oSbtdC/aaidSJngoJReeqBU+mM+RQ60k5
	rVfCuyUZSyz9CmxW57/MnMCrWR/efC3F2hOhFcyBzSd3Jv4ffYsCQsbH26gCOe2CTvNB63
	Eg8d/gZkPfxki/e+KqvrjoKDqRQ3GjY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pHpVFRiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767969060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ns7GR+T0FdqBhFNROZBBOYkDI1KxhuL4JmLMezTZKk0=;
	b=6jyRIZlbtfAvnozV46FylId8tTuvg5PrPKqmNjXUGDf9+Cl2Pia8BEPorTsR6IpCGt95Yi
	eEa4rjhVV/qbrUc9K8uBlf0jARdDRI7Nq4Y/1fC9NhBigNTA6eBpYZm387rJem2ei5H8yo
	CnQWpGsFZuF9XARSyQciO+LRn+RqxGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1640040555;
	Fri,  9 Jan 2026 14:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D51C19423;
	Fri,  9 Jan 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969058;
	bh=TdYom7rghZTv2IjRrgaPhoikmFPVyU2pZd9l2O2CK08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pHpVFRiuF2RNMPccr+IGEoh1Jo2s9MQpBcm9BwUYU8te+7Lmh9YQ/EsCo2j6sPGnZ
	 u2Zey9DF/RFRyqxY+PZ4v4Uu81hpeoylndOlNwEFDHbgFoWmwkDiKDDPV99yz3Oyqk
	 YTEzyp3LPLsxIy+h2002Ry2V+r+Fid6DmsRgiT+PwTJAPYHEJePm68NqkwTE0JSptu
	 PB0S2tfJ9vxaHEX3C0s+DXY2d18O5h/AET3ETtWm4US76cceD4ruHV/xeh0cff6Uh6
	 UpHM+DKSEaiY5jmdfM4Z1EhQhSw9rdvIYgAkNNtrIuh6nvoEOtl8K/SpWfdWkSPVMq
	 NLBwe6vxhHYqQ==
Message-ID: <510ab90f-e753-4891-b52e-04b3ed889f15@kernel.org>
Date: Fri, 9 Jan 2026 15:30:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] mm/khugepaged: map dirty/writeback pages failures
 to EAGAIN
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>, wang lian <lianux.mm@gmail.com>
References: <20251215084615.5283-3-shivankg@amd.com>
 <20251215084615.5283-5-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251215084615.5283-5-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 41E0118000D
X-Stat-Signature: q9ocb9xso59zbt4ogwdufhtw5qgpoow4
X-Rspam-User: 
X-HE-Tag: 1767969060-566463
X-HE-Meta: U2FsdGVkX1+n60LumnbCheXKtnLw46+731dTXMHFZJL5m4tjX/wxCQ3euqLb54p66m4FX502M+qfWTaOKrFLeNXzTU9Ikd2b6qav5K6u5aM3l2VTnv7b3+WbVsPu4MyH3L1OL8F/Qjb2R2JpDBWsYFBeCDkJLNWHk0RE5F1hF0PDBfGrOGxbfYFr7beiDQ24f9QI8i2MN6ehLUavtNeAHolCyT5a1ISmtH110letoBJREEF4vfzMCAddgfSH3OjGDOZjmNCGC0TcrZ6Gf00thkLFVXbt/GwtkLjjqmddBWtBa9qiMFm+65YfL/BqS27y1a9Rvh2AqHoe5RMnvpQwnwbGk/qt9E5/2EkcLYtqxIt95jyT15l1GT+GdH3sSz4Y3PzmT9B0Vj6TOArlJLOkY5zP7Njni6TxWc0tt0DDWJGcXaEd+f+ycloLjCY/WbAo1V6itoz6RXMV5UQLB6DM+w0Eys1b/KCz8BODyiKs1LsTzLCm/7L0Zh8p5g/dc6ezYiGYogAY9Z8z5AVqPUc42dh7PX+n1gn0x+A3eindJjQfnVVRhae6uoe+MFAsGLOnWSEzv1M+WF/5ufw/+tE5qMdquDizDPpWUyID8+h2yZqygpduODh0F0dZEK45QHg99Xw+3UiTh7bCQeHPt+a167mPLysv4J6zcZg/ydYNiL7SdhiUuTabbdfvwDrP768sdUrGESBTXQwVYqMpEU6W9gXClx4xAEAxvbjGo4KxV1DURid5P/ozhpzraRIsjJgA+lSebB2x8M4LF7HtSflSyEQtET4NbwjyAHnxhn2dHdivSPWccEj78ftnLnL3GIOQy6qfrvlcsh7OqBOlMUSA8kSs4F4R32iiYpLC9amZ4TokeX8vuCfmMVcTKhD5GTvW5Xyfl8xJ2lS5/Q7LN3KcyjE/0XJ/Egh0ft/NuKqYO3qBB5d+Mdix6+cUMbfzh8biqzN1GK4xNaVsKpA9qZg
 ci9posF5
 8lqDMqP455i3oIvHcPJqL4z+1PeZjCf8ISWKg9NNKWBPNqwwc++9u833v+rXFvllQ2pqTSwjiwuavLFcHDwqwuOf014dORBdAexBY0cTd9UBSDrMJGTOKfvxG8yFka+NJUVLfsatuFbOrdMQO1r85m0EIADv/HtA0Acdh8Q6lOMp53DNBMd/7+npG4sAC29+RcCU1NFLaVpFy9UM+ZLze0kJIgnXfN7RAfc8lQDgEkgzjhKRlyrsbkOIVEwIaKfSzIvvmJcsVWsni6qIWiHtnH4s39uGn63e+rRpTCRn26q/RrHWnaSnz18diI2aLdJ8/dEtzGxI713Q631qQ2KV50QymlrzRHxgYPcqxpK+HqIipO1p8tvH/thuphpT4+NYqyFCUnqowxeJwq0V2kay4Le8v+cZgZu4STut15sxbsZKkJjJbqDIsvwkdZd8r4/68GWuzb286BGbeiaMQpX++VkhBJCPK1v3lVVns
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 09:46, Shivank Garg wrote:
> When collapse_file encounters dirty or writeback pages in file-backed
> mappings, it currently returns SCAN_FAIL which maps to -EINVAL. This is
> misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
> pages represent transient conditions that may resolve on retry.
> 
> Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
> states, mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace
> with a clear signal that retry may succeed after writeback completes.
> For khugepaged, this is harmless as it will naturally revisit the range
> during periodic scans after async writeback completes.
> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: wang lian <lianux.mm@gmail.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

