Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9B0FD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C486B026F; Thu, 26 Feb 2026 19:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA2B6B0280; Thu, 26 Feb 2026 19:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B266B0283; Thu, 26 Feb 2026 19:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9F2A6B026F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:24:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CCEC1BCAA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:24:12 +0000 (UTC)
X-FDA: 84488339544.15.42FE2C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF2B32000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:24:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhpl98Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772151851; a=rsa-sha256;
	cv=none;
	b=EF/CXPlKEq+e8CyHCuNHF6BMg4nY7SF9GmpPjWe9jfxYMDQOULz/pyK4BtzIHpsAVM1PtN
	uPPSFHDzPqQIOo8P+8iutAh59BT3wRlfc7CIJvBgF0AsRcJ6TESww0RZBTNaQuFQocgmM8
	ffYT7RlOrYn9fe+n1oN/eWkW7yZFr4I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhpl98Fu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772151850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Efz9q0poatbA8hHPKY8SNXfcnpnV3XZ9wxlVeadKTtw=;
	b=E7DAmIWlWWFvTYeVAfZ6YwQNpNWswjnjv7RkidFymXeVnm8pmMnkyO6xbGUpLQxb/pli1c
	RyiNIZy1C8N+ALCrk9UxKQez2RgjEBhMFz/uMH0uPAmEIt8H0ueh/ixCub8aSJSIbMgMIH
	ttXxBrNYseDgi8phmzQOUzHF7dPFgDM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 911404093C;
	Fri, 27 Feb 2026 00:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880B5C116C6;
	Fri, 27 Feb 2026 00:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772151849;
	bh=fYwp4H6MZZvXqT9nHx4ALyOysK8KQnhb3bxCGINCOsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhpl98FuaQh0duTTyS/EnSNt8MlCHzX41pBZJpwol1vQ97QQM0uCzFB2kB6p6+0+U
	 XaDuUYdqPbHIV5i2gJIh4Z8lmjK62h/i1h6qLtSpFCNLGF2ZPwAHyEz15dV/gn23oS
	 /QA1Xy1SYBL6PnwjeWoy3jyVKeneg9oiZzkqh3CxgBxd18qPvhtxRe8eM/VBtTklA0
	 lJyR7pL/Rsl2agMYVphHfUHsewgZv+cZ2j+RG2SLwyysL+ZftIATDnUiZb5H2EJeUT
	 uFgrQC3ilKn7iZVGI4fE2ztLXoYi6AVlFlRJfYRI5Kjy4D6L8RNZ1GcK5AZCLrR2Wi
	 YMG79qMk8rCQg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 00/32] Eliminate Dying Memory Cgroup
Date: Thu, 26 Feb 2026 16:24:05 -0800
Message-ID: <20260227002406.82611-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225135706.28a93fd5817e0939387275b6@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF2B32000D
X-Stat-Signature: kfrrkbcjohqjh65ks4m9cx151f9ub8b8
X-Rspam-User: 
X-HE-Tag: 1772151850-104981
X-HE-Meta: U2FsdGVkX1+E5wATW81gqxvhqjFwUP9Sw1gW3HiBaT9QM4vBXmn63K6f4ftrB0e329asMrEY3DNu69X7x54kBjtNcndYmWIHRAk+5o8mxBaITvp21ryg6dwKV0JEOEbJME1M5KusGVxmNwF0CbknQ35bQSd5Qu3ChTdJ7M6Uhx4KPNs8RBHeRCJJXNXONRFY0ahxedbJ8XORBK/tU34SKds3KEMVVaM6xBKSWnkWEnSLxODOB7+alk3YWOvHCumIev3wjUUXvWKQykjQEoI9bJjsLinMz5AhAaiHZxPn6pQZkXLWf7FVQSquXRVGo7gtZZN3U+fbwNu7/j53Acm4oK/NQ1IIBbpZQ5Z9/2CQMJCWcFsm7ZCngXFU7vj1f3ljJcEFR9oVgGtDZEZzHC0O29Ecxgu4VfTePdKy2eHmfgMw89gNENoGz5kZfo7T0DlWpngLNSLbRscrsHR9Mx2eMx440hljNszL4nI+EiqUasEuD3gKNWZoqphChqYG1WDKvYEHYSKTlW7AglvI/bJ/px747/65T11QspJatAucWn5zv1xwTDvr2anmSce6oElE4DrXh0rC88N1g3Oi1zixiZ3Xcv8w6gyUr5pY75Z1yog8AXPhVuvq0/W6Iqmk+9buYZzqhdAPnkUFL/SYdVEBOJnCjm3W92rAeOuR4iF1WH5A2JGihgEqX2sL+UPFhEXos9sP3RorjtMGw4J55Mz7wrYtgR+E9p44VFZw7O1093m4ktCSzrZmbve37aZ/03dzPizpa1+t2Sc0lQX339o7AwCkeDZLZpUyL5VaWWiGc9Jqps7viymXsDd3zgf0MsW7rZN3juwsSrXg8zLtZIO2PZXevDr/uyolk/fyTvJji/IMpvwuurYA9EJ3+LYzgefzOW8/4D1PpfBYMHSWDdLzLHNWfaezMHMs9xQllSLwCs4d8/wENkPil1Xfe+GUjS+c0nJZBNrWXyIBrnAeFtz
 brhghSV0
 2szdYG9C3Y1lSZaGudIyyAdS6PA4pL5KKaPcRNOCavHTxAo2sTgUpz3nzlh62FRRNYP//Aq1l/Pdqvh7HzPgVoRU3NcLobdQ+6TdIromgIL+0LAq6UUJT02uRlj99Zi1Hq3iSEkLxSBLKxECu6iltwVvOv61lDs/OUDh+R9vNImxYJqHTHslbmb5ofpwnMh4FzvzPE8v55+O9eqZeZbHH00lCTZZPnZyaq3l1qq6q7p4dF0qiMUGST6q5eu9qsPl6uunozQN6+qMxii8ak2y94Ht1hOVlwMhBdbRVNRpgapJJkgU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 13:57:06 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 25 Feb 2026 15:48:33 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> > This patchset is intended to transfer the LRU pages to the object cgroup
> > without holding a reference to the original memory cgroup in order to
> > address the issue of the dying memory cgroup. A consensus has already been
> > reached regarding this approach recently [1].
> 
> Thanks, I've added this to mm.git's mm-new branch.

Great.  I found the commit message on mm-new lacks the conventional "This patch
(of X):" line, though.  Andrew, could you please add that line?


Thanks,
SJ

[...]

