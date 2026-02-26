Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94452FD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 01:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36A76B0088; Wed, 25 Feb 2026 20:01:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18626B0089; Wed, 25 Feb 2026 20:01:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E456C6B008A; Wed, 25 Feb 2026 20:01:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2A796B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:01:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 978481C57E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:01:58 +0000 (UTC)
X-FDA: 84484805916.13.395659C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 03185C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:01:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjtN5EkC;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4905uXVX9GCze6TLxTjn2Ivk3XPKxE2EqOjwlga3Nbw=;
	b=GNqhtVsmDqmZJMUG8cO4WVWHzn0IYVvWwaA/Medzn6CDfZgoyXaN4kthwnFmnRbYO2wDOp
	YWGgcgiiaK+39gaY46dqWo8gzZAPAX89xQV43bs5Gs4w2NNWjAztNykk6Ot5Sf2OwaXCPq
	N4cynTvuD5Q6mDtNMcg84gDTHYjobd8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjtN5EkC;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067717; a=rsa-sha256;
	cv=none;
	b=mJWdawJSS2NYSO2hVCtzVL45I3Y6CXabsw18qrgGNz+UUsgp3ycp6+YTEA4WgvqFOyU0pl
	GuvVIV8iNdsPA41FkteOmJjP/uCManwnIpqOnYPkw806lOmh/lD3jvSFNmjD7SI3CKQddX
	Ve6sDXBquavKGxN22NadQOxfz0HQJ8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58E2360054;
	Thu, 26 Feb 2026 01:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869F2C116D0;
	Thu, 26 Feb 2026 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067716;
	bh=zFdmXpPt1AUJPzUzuIRQvkZc175RtEgIkrR7sqdAa9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pjtN5EkCmecTuHcBc6/oquE8k/dM1e2UU+e8llWJG5XO1U+OiVpEfy5e9K5EfRe9U
	 IK4oGG4GbOzfmNOWjKWcUjk9z9OGXOmRSuhhpFL7KBHW8IcproMlJhJHwg4xGvDnLg
	 1la0gio8NT4GNMtTWWXGTRNTmk8IM+NNJqe0yk+Rxm029ohOMN97k774WPZn6SnqkR
	 DssyX1dpsLfADn3hF3n1E+GjMh7tzpgOYMY6uMKaAH9cC7BOZ9uajU36BS0U5UA/OZ
	 iXb2TOo4XK3h0qzJMuBqUm7k+26DfZFhRet7reXgHbsi8DIo4x7Hp/7vsx3et9YNuT
	 fE7Jm1reJZzjg==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Wed, 25 Feb 2026 17:01:53 -0800
Message-ID: <20260226010154.8065-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wrb384bz1seg1udqmxq9mck7jngip5jb
X-Rspam-User: 
X-Rspamd-Queue-Id: 03185C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1772067716-247341
X-HE-Meta: U2FsdGVkX1/Jjaw4lH1yth++DWDKfrVmRcryV3KONQn9gctTVpDlQ6A/VowlMj5VVuLbhMtKgsTHQrzZ3jVeZvgy7cFNN4SFr5K7jGYS64Y9sVNsxhPxouY3KMshA2Q0RRMm4GeNu7HZkItd54ncAC8n3gRqjiwiTVPNoNRMbNU/rNZJ4WdVfi3pFboI1DgOxosPcWs4cPfnXRxbLA8V6VfMPMjdmmbDfDVxOhaerwNq2xyCEH3iWcwutfA/T2trxWcI0gjy1V70mjdpgHNHzzjzu30VV6trqJwauy70YV6SxL+cR/lQ277XVG2c8qmrRskR8y3sztqrnIaTkgw7d17E/2uSlDZagRLn83Leao9gHn+tTnrXCpJBtHx8coKGLs9uh+VILz3NmPtc/+tAEEKgu6KZhUioUb2MZni7jplhE5QuQ4NVB/luEL0FUpqDpK4Z05FlU8paLgFQSWO/CuVAQ5YO4KaGRfw7GKGUkfrKMbEE6P4UN7VOd3UiVcIH4yXJqgmqekESljNMBFXDVJ9A2xfchIMb2IEp6EDLH3zxvzAWs7TgG8v3GfbpTv4C3+ys0MAygN2xQTl0928dw0lcH90QHxuSySM2HZfbYzGGLcqRgYucyf32EisvrEu6eVBiItcYXUTym7gDW87yWALUmA/qf0+vtThxdyngtlNDADDrRlma2RUq+1wobF1xX20r0S1SlYGpnqwhGlBWGMmRwhaSB/8VnFkAU/44uqaFMubQBXABbemYSF1R1v3Z5xgly5RAOpWajIh+Lp99kO6UOFIv+dCyA/FYzp0of2rAa20bk/g+AJt1MRSmos02VZDXF6X/vsFSN8Jobfh3BY7jS5s+CR6SAOdDnzg9XadQKG02e4bGSgD/NoVGA0QZ0IKDNEKmV05/erc5k5QPK8EHHbnrFx9ASOOXp9oT6V7peRZ3e/pAZUAbbkj1mdN9ggshBBcohbEwsZ+lZHP
 694ry6j8
 /zUgITKdev+sfNKTb+b9zXs2LgZIvRmYk7yIksz5dPAcbZHYMtbPhHvLNK/r35pkhVUZK08vwiR5qLjg9vD5Ti8anmWqfzmxgmy1/tMiYyATBa3aqHY9MEy+16r8BSksuvEGWjIYQV75a0/WlZZ1k5ozKzpcFJrK33ubMiIrVwGcd05yh+vPYh6D8eWqHtwzTwKlQKgrq6trNDiLnmPLDnZxsuPLFOmEZYdllu9Rm2BpxNLhbBccTnqQJ4b6fJ5OyofFCa7CYZ2B2K7AcELJUE+dLce79KsQnOybZT9h5WZe1wH3/SQQ44LSJlApwPRQCr8B5rppkwnrq/wyuB5vIszxaXxvKJUyP7loi4TSLnJ82gubHtaJRUA/haDxjaGVTvoAq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 22:12:31 -0500 Zi Yan <ziy@nvidia.com> wrote:

> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

