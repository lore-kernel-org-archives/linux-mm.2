Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC06CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFADF6B0088; Wed, 14 Oct 2026 14:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1F56B008C; Wed, 14 Oct 2026 14:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11056B0092; Wed, 14 Oct 2026 14:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 757A16B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:08:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0724C0791
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:08:30 +0000 (UTC)
X-FDA: 85322016780.20.58B1336
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 363D9100010
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:08:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cfx0G1dR;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792001309;
	b=QqSOpHMzBRbCLnddp9hQke5hk8SYy8F9ahBx6PTb7VGhVuoINu2PZqpT+pOKFISkSHQcFL
	0XaAm6x+XrM5x2DDKCvZuWUQbNwICXnNrHLm1BumhDtXtkzyktXpqyGy7AYFJIFOCO8vEe
	r5Hn5NNIx/dZA1iXq8ConQElxfnL79I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cfx0G1dR;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792001309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Au3LNpF2hUg5xkBv3JpQ9J5GcYVRPUaLDT906GDhkkQ=;
	b=lb/xHAma2SvB12b6N8EswBUbehgDjC+eJ3681rVbgGp6sjOxmZVKXaVh4RCkSogYPZ+pLv
	povrzE0MRXAEIIaVcrsBgPrnoTfMv1JMDIcuWI/lCz/G06fjiPHWQVENWrI2xHjuev45iX
	zHzYQxpTB1TcTZAOgRwUzR/kFXFEaOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A005660098;
	Wed, 14 Oct 2026 18:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14711F000C4;
	Wed, 14 Oct 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792001308;
	bh=Au3LNpF2hUg5xkBv3JpQ9J5GcYVRPUaLDT906GDhkkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Cfx0G1dRgMNLo0iM3NmZK8XJOB2BFB9HB4XAZm0dcHDa39O3+PHvzqLD+bFFbZ5XU
	 CO7Cvf+BUhrG9mV7cn9u+hrPuXP5VGFZgB+JW4lSyJ/79un/CNw2OoS3rS9NeAXBdY
	 KBiK6ueSPHbeqs7Ulq9QKAVs7zlOofpLMMe8zDevqAWKGpUBjXcdog+fNRpb4Ew8xR
	 ndbdaLOj7y9/miUYnBDNf2jauFsA0g5hqHF6Nc4K7yyExEwdubwQ49mXtQsOr+vPD3
	 QLbXVnyS1B7I1U/nFfIEo0ItJU+PXB21lkkZo+ZzkoxQaD8ksQtoMow96sgO0IeWLI
	 StkcXiA5nGoAQ==
Date: Wed, 14 Oct 2026 19:08:26 +0100
From: Harry Yoo <harry@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <as_FB6P5YAhc7B1A@thinkstation>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 363D9100010
X-Rspam-User: 
X-Stat-Signature: fhg3obqxy7urhc579aoh53ptacncq18i
X-HE-Tag: 1792001309-639111
X-HE-Meta: U2FsdGVkX1/Lc/dpwVbIDxwhmkxFOaV5WHFQee24ssrGPUjHSl8JY8Leag8hsse6XphbG9khTkGRi/yHZN1Cdp5P+J7itt96OU/yHBYEKXFcnlp5UXwUjQLs9wy4XmarmRXeUySU07Bq7zzTznLlRF7fYp35i9JkiYyiZKAYITJAsTBbtuHfMCWTh8h263KNRstFb27ALq7wXlH8bClE73jsR2NFjCfSwib0E8KmB5IIgvbCYX3WCGvkgjztzvVQUV8ocragTvBMbupFwjDHuZPbPmLsNd6q9QjGuuGcpg+Mt13+KCkJFquoNgUueQUBPZK9y+U9Gfaf68HsY/Nfa/ylWvwVpgLGjsHlYbm2WomTLLAReTOJ0ryqCh1icUtwLMCNtw+gGeTdP2GO9JPWNz4BqUxXCwOpS79rKHPIwcKkPyoAM//2Uvsuaah5UuGvzGLAZqc/v4lVjAwbRkBW0uxqvBZpYkiyaS3i6ojn0Ge2W32x115Rb3aNsn/gxLNDwbOSRMlMxM6A84Rh1VNdOFFoXw3C2wxd+ZBAPCxs4aiKx/MMQkG0ljmpoTCGwY4JXE7LxUUrCMLNQIWpb518cQCvVQ8YrBVriiwJIHGI9mvFpWDuu3kBvfsETpzL/D7NMrYFsfRx6wvPaLORLADRvgs0ui8aS0qb/OUPSm9Qf8Esp64hH2rJ+xLoCJ5P6oLB6ZyDxok1qN02dBjP0j8QkSmR8uv5ycOAkrdKE787u44vtitgDFhW37kMr+W61uvKzCBX+uDY95MnkSaTFaosA9Hcii8fUymJPUHEew4Fwb6Y9P5OKuHCDWJkXyPLyIdwFRTF3ztz5QDYV10ipsTrrzR72NBfO367j7Iyh2EDuJplsF2u+cGiweHHgBBf2AssqlexIk2Npn2e7VkLKZusco5/eOvRUTdkhy2sL+PsurzKixAggaIwIOJ4vFo1HfL65/F9PPJ70NCABWju2+l
 zec9xAzx
 AHoOWWiKsTJTt263IMcha02NaXjX8ic7ROcNxziXX8nomX6vOa9mWdmn9Zk0CpOyujk0s+p8CMyWRu42O325fUReQTibvEuV/mX2Yr034js+bdf+YRZvqktuWJmsw/FqseJw6mAeYFKEZvdPmUePGmvOAtqbOT9ygu0klvxk1SAVgSZCiwrxq4J8ahoiAF9WZu+UoRcl7LW8DwGgtfNitUv2IDwSjW9UvpWYj/fIXRRrXKDSwtm3Dzh8pqjkqIrImNSlXqWtR16jEkR79gvd64fs+Bfa/JYwYa2Lo8+/2hYAxwUeBGXerUVw+yt3W/6taJ8CW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

