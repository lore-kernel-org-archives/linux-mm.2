Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A61AACCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3858E002A; Wed, 15 Oct 2025 13:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB568E0005; Wed, 15 Oct 2025 13:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7F38E002A; Wed, 15 Oct 2025 13:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2608E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:41:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21B7085A90
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:41:08 +0000 (UTC)
X-FDA: 84001064616.01.2F87087
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6DE248001A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:41:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHzfevzY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760550066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSMG89Up68NYQoqwU5zmfZ9Fdp5+8Obj2RWgs6WsWME=;
	b=6R9q3CbSIawSImriwLW6lBDqqqHMWpnjtHWLjEgfLvMKOpr1jHffRT/7sI0M0UuRdKsJGP
	ecO2X6AoNRiq5y6UomHMYlJ9S+P0T9ztRgbpcN/ZA/+wRXPMm/s+Syd7LxQORx7ykeoP/y
	kzkhQiYLnjfQUOWrFV2ygLJ+yhaYKdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760550066; a=rsa-sha256;
	cv=none;
	b=J96lsmZFmksVKpUe/llou5Akk4p0DLrd3D/YkOmXfzkl8hclrCkEV+booCFDKGA6AJtNIw
	yBIcTXdrMa3320URheroTk73GihsGTWYDPYyY2fBvXGWSjI3/KWCCqZW3EKicGNZR/7JYV
	nSn2nVXtIw5AOkD3Fi+QyKYvBy307mQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHzfevzY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E63BC45359;
	Wed, 15 Oct 2025 17:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7ABC4CEF8;
	Wed, 15 Oct 2025 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760550064;
	bh=NZCrGB9nHrm21Ve7bIne00nCHgmzUU9E7iFs0ZquwJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHzfevzYzGfsGBPvLd4z4XdUC4PLoK3g/GVMdhXLOBq8o4Zi+tUsdJIMc07hl9w6W
	 NqyRdZye2N68SjeHS0zcPlmfoCnTDjsBF2jB/Tdao2jRpEZv7IQbrAiNmXOg9BxriO
	 IIaVeZdCy/YS4zw98StQ6b9SL6pv8xll0I5jHuRgj13hfsbvf1JKyddl7zxvv3YeU+
	 VGv8IypkhNJmOEFgnlHH8QImVayM9XjtcDfAve9Vo64+2eLJczWtEXZyDZ4uoOGtBW
	 OasDjpcr7moN799RUmRNXVQAtBMLDLHnDVmQGHCZd7OBhzD4t6uC21gcacq0TPBamt
	 Nv7sXoK6NVyGQ==
From: SeongJae Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm/khugepaged: fix comment for default scan sleep duration
Date: Wed, 15 Oct 2025 10:40:55 -0700
Message-ID: <20251015174055.70060-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015092957.37432-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ckai8q61ubfhx8iz1aqgpn9aje9n5iyt
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DE248001A
X-HE-Tag: 1760550066-337885
X-HE-Meta: U2FsdGVkX18DL6Kv5fQVeK2tJoO+ekhcjPgDLAB3D7hGdp6F/dNKMLNRe15Cz4MjggYImrkRh4mdUULHWgV0JLjhL2WZXNF1oP3aY6TT9DZ2pDezECvqS0If8Z6PoNKCYVO8w+/qgOTvK74yQS0+877nsODXLy4ySjGKvx7qDIGN4Y5WxfkQ/gsJ3yFXHAxZ54cb+dVEozfCbvfbVo2uucD1OgPVPExzd0rlNQUB2DQSeyFNlvmJYQA+fWyDER6Rma57AzeUW4rc2TrTiPNWNYiZGpXnXjRtIKBC+1x/WUGgBXlOPZGPdfTjzI8f7GO8cZ7lT7E/whmBqkGgi/c1MWfHSZPFP2xRIXgYjqEmivlPgUTsVojizGsQ+rWUGQ7tYzPX1lfqRU0OUmFVYGXfXP5bnmXw/iljMANjWGKADEd7Jgvq5FgJ6SJQ+3gzuD9tYmP3FEn/hSzuabkAkYqqaq3TkrGeCzjN3nKnM/Lgdt2dQ91DuAVUr2OicEuTbF3NX1vZF4UNriZWiQ5ywVNWhU+Fk/kUAS0SNjvOwIRUBHptftdPF66YXgnm/9vAQt7MsJby+9MsEeQQdE11h9BngaFqGirSR7TgVFAvDyJ70ZcT72jSMswcyJVLE7cE3KXY0kXP6OgjVibLwyR5puyV33CLuiJYHGk6smYmLyHEe90mCgLiTIC7lHTMME6Hcy6WqMIM2zmozzBw8nWnmYCiIKnWbc26mv7oga7TpoZV8Fzn7fPxGXLZVNrix/CWJhEMo3caCFEmJV6RTmSJmSQjOehP6kyyVn2H73Dn5juMT7f5Ihx+H9Rcd9I5W1YL7FCobiV0nn/LKn2QD4nO/P80yIzIkRp7B6Apse6YSI+dKJWnl6cS5CH8A14bm5vrJ9Td6JY19xH6KQt4T5aY80MUh56wjTNcrop4Z4EKlzO95CIX9Bkx5HODSwVpl6wMr7t+4YWW0ub7HY2E9wWB9g1
 f38ZOZJx
 UJWmRd80UUFVNx2+t1A8soUNo9wmOtrDL+/k7DbKWjfDIfq2TqGwU1VAUGiqpc2JFl4LIuUNoDifyJAJrXndGkLuMRbSnDejEYipM8hrzuOQGw2rA1YBR5Ycjqkn/scb4i+j9XyRAo7e0MpXHUVo8ea6iVvBYToxbiQEBu7Qi6ohwQTbXajrww/9I7vTdvR72PJkhD0xYq0TvJXT4YSiqaeOTCAfA8GSCd3jNLMBQ/ZIC4yoxZanag4rf+5D1ZsUBCTEs/rjZyxZ63jo0xin6HqQQnFLvLPGAeyWdGKse/kTvldjScQmz26tFAY41fWGP39HxF3an7LG+vY3X1upfFai4/7bM+VPg+yB9aeuDcYJMOZi7ragX3wL7U+FrZEZK44pXkqgP4OAau7zgZ0FCcB9WsFxzl7HTmtDl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Oct 2025 17:29:57 +0800 wang lian <lianux.mm@gmail.com> wrote:

> The comment for khugepaged_scan_sleep_millisecs incorrectly states
> the default scan period is 30 seconds. The actual default value in the
> code is 10000ms (10 seconds).
> 
> This patch corrects the comment to match the code, preventing potential
> confusion. The incorrect comment has existed since the feature was
> first introduced.
> 
> Fixes: ba76149f47d8 ("thp: khugepaged")
> 
> Signed-off-by: wang lian <lianux.mm@gmail.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

