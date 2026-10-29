Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57993606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ofbH3Y62
Received: by kanga.kvack.org (Postfix)
	id 73D086B00EF; Thu, 29 Oct 2026 10:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDAC6B05B1; Thu, 29 Oct 2026 10:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC846B05B2; Thu, 29 Oct 2026 10:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37D8A6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:10:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2F771C3B6B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:10:50 +0000 (UTC)
X-FDA: 85375849860.02.EC31FBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05D9F20005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:10:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofbH3Y62;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793283049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6jBwgB0mzd2kWy+BfoLDGgcNGK1100O7enXCOOxA3k=;
	b=qbfoYxeFWMjT3Scv94IQuly4HMumpf3dN40GYD2d9wXl5X8L3EHHGkq1dkx29Tu2aBiGZI
	mx7GRf02TUdpQ/GCM9UxczSsDAduwBrSXY4iDMzhMGKl7+0+TzPuQ0+2CFMGyjXUl4GOzH
	Xgw858qN8ydDmBh9TkXb0prLqpt7egA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793283049;
	b=kgfJKZiQSy2pHppDEXpXFopzTVQwsNRZLU/XAkfKu81teCBUBDsGmURVsoHloGJJJKSQN9
	vCQTLdLhfGAxh0hqS0MUDaOIfkh0cHSMCgrVemH7hJmk9FKThY5K8pCDEUta7OyvCN+ssu
	+2S+dmBgrNCs0yTiM9XFgmutIkVwbMI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofbH3Y62;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6159F4165D;
	Thu, 29 Oct 2026 14:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C076E1F01825;
	Thu, 29 Oct 2026 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793283048;
	bh=T6jBwgB0mzd2kWy+BfoLDGgcNGK1100O7enXCOOxA3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofbH3Y62HqYpuqTQ/c4/VW+V2KrlrU26ac96H/imGeTXuJfi45MHa8Gn0m/qlcJxq
	 RZ6Md1fc3/YT2PjPoYLfD35mVwuRy+lkSAWBKG1zXteuYW3UuM3kqLcelqnGzuA5pv
	 sG4eYTJDftBSbgHNjpym1EU92+c4R0z8laWYPHWgnkcWG2B89L5RKZ/vXDTEf5sVR/
	 DSX687NvGSA3+Hk/hj5wkVCMv3iazPeJXjGGW4Z6WV6paQtY5zx4VC4K/gJtqVrRLI
	 x4RuXoIvR+N9dgtWWq+zWE9r/mqI4/Dl4WguTRko6rl3FPhuAKPqD+/BEgfszS9+4+
	 8lIosbATeLo7A==
From: SJ Park <sj@kernel.org>
To: Xiaolei Wang <xiaoleiwangxiaolei@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	error27@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test
Date: Thu, 29 Oct 2026 07:10:40 -0700
Message-ID: <20261029141040.148392-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261029075609.35661-1-xiaoleiwangxiaolei@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 05D9F20005
X-Stat-Signature: oyw3xfbusgfx9j1fab156ii6h6xp1oh1
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793283049-872202
X-HE-Meta: U2FsdGVkX1/Pa6XYsvu3C6DabIeIGK8R85HWs/aON2L6MhfzSFD7wI09a/WC9KeA8igt3mnJlYx9bUtU+D6vpawjhz/3Qvifp+qaALMG68bhIQqsWCNVD3TKmYuf8+EFL9GZZ/zKa0YgYCv04ekFFZOvVkgP4sfaPRd4WlzqJ9ZgDH+/K+Y+adXGmCRFioYYU85UyBKg506OojfId5VgF4poqBNWM9qYBf7ZiUA+w1mMjt5qFOFSj53Qbp47kTpm5xJQo1U9+0X7LvImwWaFYSwh6JWhVczCgKEu0eGmG4iqqWBVW01heTJw4LnD3AIdOcEHSwGCPZI5Q6SFHtbYL+pdmkikzbx0xoaxSYQPQ5nbcFk282jEI0yPaEnbprYnklaCUKQLYew9e3fLYvVHZ9LOGytZetObrxk9vzmUACaINEmS5S8JJ9gSflCtWUqjUQbnpesh61rCvONjYxWzA0sCQSljsavaMN39QFWo+880Q9DO8FP7NrE8eJx6QxE+eFf9smOVL6+oiLIcS2tJdi8qLXSqK0JmIPRkPorm7bm4FZBLgdKqcVFpRrQ+8v3woJdLE9hjVHwGWDBXxo3sbT5wg5uMkjvQGvpHrh7pWrd6312TQ/7z3UZiUfkf1YsOhmq9X7cea6M++1ntTDUHZBvmMl0s7+HAe9Ll8vTFjM1V4Fi3vO+v5ZT1NHx6ZdtrqRSlcJxFLwjPxwAqPMcLuihcsSqy9Do2m0LQ/hs5l5eluL/ACMsXMqvABRr2L/9VJKMuBXoPvOiiHVlu9hmdf9DvElz8E27TRQ3wr+RM/xK6pdJE6s9j1vri1DfHu7C6KbtWFaDr0em0gvTT1FtDYE5xu6YpTBUze69dC1IjFyMpfWo0MwCrlOX2W7rZNjaI4d9VXThK14fz9DAaaraRfc6no79KdbD07257RVeXDZ3ef4K9+39UMj3Uzfl3UfGB5svHd2FToMYeTO9S6/d
 5+mWlc1d
 B9R1UQE7bGzTYwtd6akhu8qchF7FWtdDvh118U+OfP1bDMmQZ9qziNB6cXTauJCRAwLg4S60YDPQxLFdbcmaI9m6UkvMZbHg7jnccrIBW3nLYv30HeLOPZ/Y/LMuUyrzpnNItaKZ3R4i3XOEyFbg1Edx0WrR7LJm1+13Y+t6LegsTxxUTpHDQQSsOqC1w4qzfPvl3P89izoT6IxvvhTySM4ICNmOvmMjYENX/j/D5GNpUgonczG2b6PGY2mAgFmv5mPL8q8d9TtCIfMrV5cxKR/rB8f6yL/EixnPNaZ5wggvqpSq1ujF5a1ZVD5V1H4Zfb1ieUVUZ//7Zelf8D5vdp4EZ+nlV9QFw/dBUqqd5hSjcB9TXFvs+hhXId7nEsM4AHwXDCOyMg6rAfwc9IRaPfUzkmRn0TPQ4lC5rehLeM9ojKTD0ZMbDLmrECDmEF3Yu1AbtAjkFIxpX09OZVtL7SAZeUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Xiaolei,

On Thu, 29 Oct 2026 15:56:09 +0800 Xiaolei Wang <xiaoleiwangxiaolei@gmail.com> wrote:

> From: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>
> 
> damon_sysfs_test_add_targets() creates its monitoring context with
> damon_new_ctx(), which leaves ctx->ops zero-initialized.  Since
> DAMON_OPS_VADDR is zero, damon_target_has_pid() returns true for the
> context, and damon_sysfs_add_targets() therefore calls
> damon_set_target_pid() for each target it adds.  That function grabs a
> reference to the target's struct pid via find_get_pid().
> 
> The test then tears the context down with damon_destroy_ctx(), which
> releases such a reference from ctx->ops.cleanup_target().  For the vaddr
> operations set that callback is damon_va_cleanup_target(), and it is the
> only place where the reference is put.  The test never selects an
> operations set, though, so cleanup_target is NULL and both references --
> one for each of the two damon_sysfs_add_targets() calls -- are leaked on
> every run of the test.  Running the test with CONFIG_DEBUG_KMEMLEAK
> enabled reports the leaked struct pid objects as unreferenced.
> 
> Fix this by selecting the vaddr operations set for the context before
> adding the targets, mirroring what the sysfs interface does.
> damon_select_ops() fails if the vaddr operations set is not registered,
> in which case the test cannot exercise the pid handling and skips
> itself.

Makes sense.  Thank you for finding and fixing this.

> 
> Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")

The impact is leak.  I think we should add Cc: stable@.

Cc: <stable@vger.kernel.org> # 6.7.x

> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>

Other than Cc: stable@,

Reviewed-by: SJ Park <sj@kernel.org>

Assuming you agree to Cc stable@, I applied this patch to damon/next [1] tree
after adding the Cc.  I will repost it next Monday, as an mm.git merge request.
So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

