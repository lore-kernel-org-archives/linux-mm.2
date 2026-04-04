Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D842E63FEA
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E736B0088; Sat,  4 Apr 2026 16:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F4B6B0089; Sat,  4 Apr 2026 16:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DDE6B008A; Sat,  4 Apr 2026 16:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE3856B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:02:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C51DE039F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:02:08 +0000 (UTC)
X-FDA: 84621944736.17.E4927A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1E94180007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:02:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrA5QUGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775332926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Tli4XlqxojwH4ywuXK0tkk9B9+2jjd5GDQh9MG3Zf4=;
	b=of37pHeNpnLUpdDgxAGn6E3lK/egrFU6LVsSdDdRnFMkQiw9eim3zbDgOchpaBv5XhgwE7
	wc2ABfg2EE7TmpVvwiK6ga34VWThGdQC7hgQ5bO9EIrwdI0nH4dwAnDxddLy35CaGRhju/
	AVoy72w86nLtc6XtXHJwd6tCuKGwuHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775332926; a=rsa-sha256;
	cv=none;
	b=YbvoxyWwQC93EEgrEiKzvpQfAfDxBiRYip9PE9hjjWTSgLdj6+EFzb77g+Yn8UPHOVZmka
	N0jcIdZ21nzmpldUE5Q8O7keSvMo5zjhNYQwVP96CHMkgNyVNDGjcpmRtBLMj2SfXGxARb
	UpYP9wcgNbH0JK441ri1IYapIuWLmDE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrA5QUGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B89860008;
	Sat,  4 Apr 2026 20:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C5C19421;
	Sat,  4 Apr 2026 20:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775332925;
	bh=/JiyVizUMe9wSdqRZWW6fVbbnNxTVMDWZytcmkzNmcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrA5QUGyJQ8bVQcBRmkgwJI7ZwBM9sJNU5eBGGV8qZnyWKaSUSqyBzu6LpN9GvD2U
	 6PWqlaeorIT4jytNB3eRyedgLHY4vnZ6k6bamJalIPDMDVKAkMXdqMHg8VkCPk0dEQ
	 qwq2SnCL0oc8kudZeUxGXqaFCTXar2+nndGXZcRnaxRguhK5GF4JD8E9XaMQvYQqZC
	 EC3Tb2Z2do5VI+617ig9E5WWJc7V2bUnhUoVMAxoyrAwK/SW3I+5+Du2twxoMyWjf9
	 cXG8+wX5CFQV5LXDpLImwNq0Qy+fCoBrWJbb4+EMp0GEby3i0RtmKpBUCX1He7oBSi
	 jW3NCs6DwbfUA==
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
	yunjeong.mun@sk.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v5 1/1] mm/damon: add node_eligible_mem_bp and node_ineligible_mem_bp goal metrics
Date: Sat,  4 Apr 2026 13:01:57 -0700
Message-ID: <20260404200158.86020-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404012215.1539-2-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1E94180007
X-Stat-Signature: zdn5yo6dpfa47rumoqeb1srprfs3c5em
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775332926-672196
X-HE-Meta: U2FsdGVkX18XDrKA0lRXsip8O5az12OeoyzXja1bAiQAzYPOxyuwhiHGDs0vf+UdsklcxN9LPdZvHXGAsOjkYKZ8OXnpEo+qh59WT9Oul0h3CxFytCyXKPICbRRSTSg7WlRw3fV600up1yws0pAdV714tUqQzVkzlsWqkBzBcgLvE1ZTb8moFwBTtEpiHIGB7iwbCFbl/2qlaQDbz98MXBS3eyJINA6uoT0sZBWB/9ow7DOHwY1prH4YfZp00iMdZJFhZNi3+iYHKm8EzCJhf2FyM8eKoCn/sIOUlFN4MsyC8Cx+Ukg/67W3VbrWvL2Y6G6HX5ao3lFT00cIAYOfvz7vNAyWQNnygiZTNRxLbvRqEYxf0exU+MY5Whmb2gZfLNcGjlpwKl99FOKJCgBrrEcei5LLkDpZHxekMY5c9GI8EcFdqF0NtQUI0/J2JT2axBr3LxcZ88b063Un1dFz371UscF9WB7B9gq7aCPTC6XIeNWVdRrh3eDmOlKTaNmHj94kWwnqHiChLs1EGYV9N9QG2wX/WtlryflvgBfLfFm6AOR9CYo7OZvbXbXPeBwahxF4lNnllgCtaRtJpkEEABtocX/LdchOxlKyW0y7ameuhL+E1C0AcKBI7EsiCUnH31nkssDa93VyQSGVOFC/dPrErzRlX71Mi+3o5zSLSvVrvWmNaOPmnUUw8hxILHI1kMcbBzhIC/WV/AKKod79c9JkA9ryRFyRNmG25KIcVr92UAskK5Yd55EY+gSF2QPVbDS/ESODunxiLkscM6Lft1F2vU738cfY/yBUyQmusq6PMyOp+TiagEb06fk/bEfibl3xMqG5Us/I3pHW159ButQth1arvG/5kJAnNFMVifa3f6XmfzigR5wQRAwV4G9UFvIkZbQ5ntBj+d3y9GMmFweagC1/2Xe+cblX9DDL6KB/isvu8ncYzk3+qXsC91oEPDSEed3BjmNcXAENvw3
 p67wHuH/
 FJNJAjPNDiaSzcXIqH9tqEKGBrJl2zQfp4eB2uKv34lzr9QILQsu/orNC8SkypCvDPuSCC6qIW24wFAQMqPHBzuiXFk8y4xLJLF1LDaff/QCSx12XQpT6YUp/2lfoQDeM3R+0Q0IvqVPloI4m72gks0ch9Hid8BlwRh/cMpYUoeZ5hdigh50sPPxepPzI5ieE6NqiN3a81Os/bd3VlXbCnIoBFvAVvUS2TumxqeSTomqFwlKKCH/liB+1psTJmKzp3y1Dd1YwLyCc2RhtSLbdeaHZvZX/WFy08lEfEpQKvvr+nrXHgyfC8TKBopPcUiCw0ipy0lPyL6HyQQPOcV2WO4AI44Mp85IFmXpTTAEc8CgpaXs2MNkR1tmci5ZhMd1UwXwYQLR61W3zMyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 18:22:15 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Add new quota goal metrics for memory tiering that track scheme-eligible
> memory distribution across NUMA nodes:
> 
> - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of eligible memory on a node
> - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of ineligible memory on a
>   node
> 
> These complementary metrics enable push-pull migration schemes that
> maintain a target memory distribution across different NUMA nodes
> representing different memory tiers, based on access patterns defined
> by each scheme.
> 
> The metrics iterate scheme-eligible regions and use damon_get_folio()
> to determine NUMA node placement of each folio, calculating the ratio
> of eligible memory on the specified node versus total eligible memory.
> 
> The implementation is guarded by CONFIG_DAMON_PADDR since damon_get_folio()
> is only available when physical address space monitoring is enabled.
> 
> Suggested-by: SeongJae Park <sj@kernel.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202603251034.978zcsQ2-lkp@intel.com/

I think you don't need to add the Reported-by: and Closes: for bug that found
before this patch is merged.  Could you please drop those?

> Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> ---
>  include/linux/damon.h    |   6 ++
>  mm/damon/core.c          | 186 ++++++++++++++++++++++++++++++++++++---
>  mm/damon/sysfs-schemes.c |  12 +++
>  3 files changed, 190 insertions(+), 14 deletions(-)
[...]

The code changes look good to me.  But, as I replied to the cover letter, I'd
like to get sashiko review before giving my Reviewed-by:.  Could you please
rebase this to the latest mm-new and repost for getting the sashiko review?


Thanks,
SJ

