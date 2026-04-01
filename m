Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA14810F9314
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 00:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36CB16B0092; Tue, 31 Mar 2026 20:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DC06B0095; Tue, 31 Mar 2026 20:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2331D6B0096; Tue, 31 Mar 2026 20:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11B8F6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:54:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7B5116049A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:54:07 +0000 (UTC)
X-FDA: 84608165334.28.9DF283D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 201CF14000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:54:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ul8G+PLu;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ul8G+PLu;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775004846; a=rsa-sha256;
	cv=none;
	b=wCYdZC2r1Iqz9TurT28/1BmPrRPwrE69dQngyh/pNsImGGpl5HuyfXnjsB05/sM4faH9eC
	aXCvmskHb61odm9ERBMmlTv7h13ywq7W7qhgGamxyjQJ6nK6dtb/MeHwAJxNefdLv5qvn+
	DrH/zh7w0P7wkt9lyFg/EVvlOyIVM+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775004846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LOkTtYkaGiHEatuSTeLGPRtjm9N7CywEE2YDL+ihvk=;
	b=qj5eEca8DH4mAaKKIre0diUHs35lD1qfKRH3TsLha8ovPZ7CfOFMtSb7DUJrLjv1Xm709+
	56u4ASghCYDdkxvyK7LvPhra5Lwl+eGHx9Bfu8MsnZUnXZX/qNFxe2q/nQ0wtds9SkWTUL
	LBpE7GqzXAof2sON9NxhqVcAgqnGLyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92FAF600AD;
	Wed,  1 Apr 2026 00:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7D4C19423;
	Wed,  1 Apr 2026 00:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775004845;
	bh=+f4CmOUNnvSl0uArFt9iOybOcimttiG3VaErO1gsD8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul8G+PLuHQzMqCcaTBmaiVFddbBPa6py0orboYcGagVbnzKGnPy11HZwDVoGQQ8p7
	 IgYkupOTJvpTkm/deSnZBZVDLf3+Hk3Ob5G9n4lvtPGzGvbQRGCPr9cyFC/vE5eDdH
	 lrtsAVzHiOaq5+OmZo7JUmBlLNQZtnkHw8sQ+V3ae4Tr3bXUJSDJYcRDNVv6S7N8yw
	 JK+J8nldKfrWDzdcZvz2bZBYOH1J4YLdiY85RItTeOpR1eMSTlmJBnp6YP3Msq5srF
	 AM4378+2ZEdWxI7uVq/pvIy1+kZ46OauU5HpVwilRewwR0BxN5NtxUPL9AFVKpT1ZN
	 Wb80PuYgS9kYw==
From: SeongJae Park <sj@kernel.org>
To: Stepanov Anatoly <stepanov.anatoly@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Tue, 31 Mar 2026 17:54:01 -0700
Message-ID: <20260401005402.85833-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <716989f5-78d3-4e78-98ae-2bf3caa447a9@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 201CF14000F
X-Stat-Signature: xhgq7a5fs1yuc4cegkc6547f48xnro91
X-Rspam-User: 
X-HE-Tag: 1775004845-804902
X-HE-Meta: U2FsdGVkX1+OzGgFxOBS0u31DSQg+GX66Ul8W3mwlWXXfYf0qh2/cbc/lPaUVjOcUcpkSriQUrmCivHQu9s7MjE7mxSh8IYYcigsKmQ9iAoNXf68Vt1VpBoLmjKtxUjk0hHvY+gbUWrWVjx7Z4fAOvLl1TZmn98BWlYGNA2EQWdittNqrKxnECRRPs5Up8X2CRbmeHVU9Nu45BkIelJBzvMVY0EPETfRvUgr4w7KF96ttlGv3+GJCQ3gt4HN+fP1Qyj+dbuBugRaLxdp/Z+PTwavGUHoFB1k9D5xQF35X/2zM6FNC2bBh9rqetjm3PhAjUaUrcO47zLEaSOIvLVFYmy98SfDj8FGK5DQdzKiSE7cg/bGvlsoJ/weGwIC9LIk9KGtFYR5ZNAyopwq52+FxyD+/7pGYdHVlwusiUfagVsRnbIbFuwA1UUCfHpZJ2oVTnQ/n/lEr2G9XqHO4Fpy997FTaHqaxpKsqRTmEw7EZlGPRxZuMi6Klc9Y3fO+cGAjEfBzLdtpLhjqB+YIt/v8FN59Qc7j01AMKFs0SRkEhA2faiNBzwjFsvWUJAZTSuXz4t3t5OnjJkFMikP0wnbUE46dPF5h4KMHIOr1G+yiq2WaAV1KD68Ce5q1MjUnKlsKcTdtMRrdc/UaVfTP/cBQ2T86n3/hBFICY7ZdqQ0QHOfDILWPaTqxaLcpe7CG87Xbrx0oHMiV2v97ih8lHGNM+QrhbUNoR9E4/Vu2YsFkECssZE9TaBt29jpfCO6sbeAS63EHRUeznpDnrQDrg1enz7/ag6RN7RUKHNX8Iz070LxCUkNZjz+3xX3xENiDfMxlNAwbu4I26UuSerDHYmmaXwQhxCmtqEIpyOIhcu3bGlD81RjFlD1q00JKW3ohhBDBgrMbxo8Lcufb+rJlF02OUAZGo1YobdBVn8bgm/B3pZ6nHCZnbGT8D7OHmVSZ+G1O+yD92y59LDscGi1L75
 XEzqJqcU
 NvpAh6etGz6WGH4/bd4MSt/ZGViDV/RHl6102IgmJ+ypLvQcPKqnvpD9HpPTRN/O59hIOLx3DZDYeCb3fVL/VoO1nK3X8K4lHoluefqHw0/NZSkzH5jjGPzkuK7Sz6dQv/aDruGB+x1dBpPPH3G3VkKnovXo5IbE0zIlNoC7ClsHFibFGL/+29f4bLp2FeHKIhR01l8bYGnK1FJJVivVhe4J/AIoD3CzltS2wUbkgScQWCoZ0Jt7/3b4nWSQWVD/3YTDVJVqVDxLZQRirUjE0CN+XUgHnUiAIlL+tyVCZsuVf/ZFt0tDE//fOMkIuhAnCZaQoUODJwuigFShKq4GOk7jBCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 13:50:21 +0300 Stepanov Anatoly <stepanov.anatoly@huawei.com> wrote:

> On 3/31/2026 1:46 PM, Stepanov Anatoly wrote:
> > On 3/31/2026 4:31 AM, SeongJae Park wrote:
> >> Hello Asier,
> >>
> >> On Mon, 30 Mar 2026 14:57:58 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>
> >>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>
> >>> This patch set introces a new action:  DAMOS_COLLAPSE.
> >>>
> >>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> >>> working, since it relies on hugepage_madvise to add a new slot. This
> >>> slot should be picked up by khugepaged and eventually collapse (or
> >>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> >>> enabled, khugepaged will not be working, and therefore no collapse
> >>> will happen.
> >>
> >> I should raised this in a previous version, sorry.  But, that is only a half of
> >> the picture.  That is, khugepaged is not the single THP allocator for
> >> MADV_HUGEPAGE.  IIUC, MADV_HUGEPAGE-applied region also allocates huge pages in
> >> page fault time.  According to the man page,
> >>
> >>     The kernel will regularly scan the areas marked as huge page  candidates
> >>     to replace  them with huge pages.  The kernel will also allocate huge pages
> >>     directly when the region is naturally aligned to the huge page size (see
> >>     posix_memalign(2)).
> >>
> > I think key difference between DAMOS_HUGEPAGE and DAMOS_COLLAPSE is the granularity.
> > 
> > In DAMOS_HUGEPAGE case, the granularity is always VMA, even if the hot region is narrow.
> > It's true for both page-fault based collapse and khugepaged collapse.
> *page-fault THP allocation, not collapse of course.

Good point.  I think this difference can also help answering why DAMOS_COLLAPSE
was making less huge pages in the test.

> 
> > 
> > With DAMOS_COLLAPSE we can cover cases, when there's large VMA, for example,
> > which contains some hot VA region inside, so we can collapse just that region, not the whole VMA.

This also makes sense to me.  Also I think this aligns to what we discussed for
MADV_COLLAPSE intro.


Thanks,
SJ

[...]

