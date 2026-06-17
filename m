Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2404ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B866B0088; Wed, 17 Jun 2026 02:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE29E6B008C; Wed, 17 Jun 2026 02:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F656B0092; Wed, 17 Jun 2026 02:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD21E6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:24:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 451DE1C413C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:24:43 +0000 (UTC)
X-FDA: 84888416046.09.48EC82C
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id C58E6180006
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:24:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781677481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=busgHP+z6JkzV9ZUJIF4qN+1v5HWMSreQkBoN89NFSA=;
	b=O0JrHexOHTz8wli9OQ88VrQvP/i0EGp9DT3eA0uTR4vX4bN8SoPb2iFdZui9EqWfE4eUfw
	K+70n4pP8WDFSc8ODE2tFotgMjE2xR7+hbGEbXUyzvJ5J4QlXjkNwfSQtt69xyQL38m7Fe
	p/cI3zJsllNtiHUiN16mOBERaOH0k1A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781677481;
	b=NI7K7ud4ATqRAeD4MwZXczcuYn+MUQqO64b3/mxdGy/fa3UZ3iMoTBUxw4NGfiuzK0g1S7
	drMKjjEoiamntC8cWlvC/9pgu3ZTRA61muj4P6WwlCPbmtPv6shZ08zhVBDhHBan0vch8u
	8V+tyIfolQUCo74mNiXCaQhBpCMp9Lw=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 17 Jun 2026 15:24:38 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 17 Jun 2026 15:24:38 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, yosry@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v8 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ajI9pmwrSXQarXBW@yjaykim-PowerEdge-T330>
References: <20260617053447.2831896-1-youngjun.park@lge.com>
 <20260617053447.2831896-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617053447.2831896-5-youngjun.park@lge.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: haw6pi56m5iy449zn5c5wqaxywrouwxy
X-Rspamd-Queue-Id: C58E6180006
X-HE-Tag: 1781677480-949123
X-HE-Meta: U2FsdGVkX19o+F6UHkeCdAoZRNhmFRpt68KAbDEZp9OtXkmFZs+iRJ0EfOo9WMiXpScVAKMS/IFfre2J7DqyXYXPsu5wVk6mir0G+OJpVLrIgSRlT/OsRSixUvdrBEcGCeIkKWQ6zmQMaj2yAd01NA2uk0cH8uiqdjsEWPMT+2WBtpaAI697713ps7crHCeyJjJsYp4HUyT4Qlognfi2D/85LmN57mTEoRQHnZRSvpHMCxP4ihnG3hOhjryKBIJbPcSNKJhr29a6n+5N/g9iUdbJ8Nr6OJBSEVM+dl1asOed1qXGKRoeSIZHvLtMnWAqJVGyCJSzC6kIwnJVCbHeatUf0d58e6B2glzvAxe6fZPZmtSALITOA/R43g2ogm1w6xIgN06mnCgFZZENl8g2bQx7wz+t6PLXrPzMJlLEMsybJY7Z6VXMVxQIhKkDalJB2ynLZuDbAv6PloZXm7eutdBOE6TC4iBFTYE5Oanw1uEECYaTpqzLQz1i5n75jiZ0hnM9BXiIjI3lFKWFHNjO4qCGFWPZzZ4Mroozsc2rUVBv9ATxsw9zLQ414fSdMmYteE2EXatj2CsAGzBsIaQEBcHoEvtwOcwHPZZKxdH+GPczR/LF7qHtep4S9zO47amGubzFp0FCBXudqbhQeBLH5RwcRQmUIypyF6MbmfOA3cPLEJGE+SZXbXsZYrhs0MHdX72CTgkhOm9iwJ0ZY9OTj3alxtHYENzvG0MOeaIrq4y7lkTp6/GPVLHdGwR8BwtOBEvjB8qh2XzblmbHKqkbkbBs6/1A6WmdpToCD1aBGIHLdWL0v2jQy064XysTGoybqkN7tjyi0kBC4BFaKatOPmguJFG2dwu2CSpmdnk69V59qlyAtllGzJEBl5yEvhBJT9vN5PMMwo+tjCps+l6fjgVh3f55P8KZ2w902kb3O9mmK+4ryFL0QSN6MTuyDvpz8ofiLvajkO0aPPJuYdx
 Zn6e6HOE
 /J7I4ML2tYE5fpV2wNi3ighCDKud2dIqQCnXGNVbVCWYaVebq/+BGjP+0jEhWux9r4a1JHhB4akXnons7FdvKwLj00ret7JZc00MH0SnC/Al2treF/k/Oo904uvrsmrmZ9EsXSIrmB8b8465cvib+GQhytXroOzNN0BpiUuWU6fVOP4s9yOSRCHDIaNFemRozMiwi81SGdvrNW7I3GlAFS9hMGmk496pWzyNtymHb+X24vn3CmcPFN2K7jAu8Byv7pDm/3F+iQlUbLrjOuEsTwaUc/ehaqa4ACluJ/F2KhRjMgQVH3oTHYEJ8P/0Zl3RgcVIl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

https://sashiko.dev/#/patchset/20260617053447.2831896-1-youngjun.park@lge.com?part=4

Regarding the review from Sachiko.

The AI review pointed out two things. a pre-existing issue and a valid
issue regarding swap_sync_discard().

For the pre-existing issue, I believe it is out of scope to address it
together in this patchset.

However, the second point is a valid issue. For the case where
swap_sync_discard() discards a non-selected tier, succeeds, and then
retries swap allocation. I will fix this in the next version by
checking the memcg mask within swap_sync_discard().

