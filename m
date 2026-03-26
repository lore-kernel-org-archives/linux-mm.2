Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3DC10A62CF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0C96B0005; Thu, 26 Mar 2026 09:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 361596B0088; Thu, 26 Mar 2026 09:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277E16B0089; Thu, 26 Mar 2026 09:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17F656B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:42:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97AF713C1E2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:42:19 +0000 (UTC)
X-FDA: 84588328398.26.EFCD5DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1BDE120002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:42:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHgy518K;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0S6B5k2YpdqvxqAy6Gks2+9Hsgsav3pxdr7CTYj3d8=;
	b=U/5dqP4QNKZ2SFtCbeJRblhMSGvEdatMRJGSdtnUOkYSHhJqhefzHxAGy5P+0bG/6hPn7y
	ULHcuBAaUixK/958HEyLw2U5w4UNvGK09+vdfZ8sUjHpvuo5CaZmA5YB9rphf9/oOQAz4Y
	xnWe59+S1F8jWb2BLINnlpKbvqfC1VU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHgy518K;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774532538; a=rsa-sha256;
	cv=none;
	b=HKlJN3uP+aEloYvTZrqufte+lwALShxP/m6g7VW4a5/p8x4XbxNgMIp7AzwCZIvRVr+dpX
	lobv8lVT3Q41H7uqAo9uPv0lOGpPvbUZ2RmNVcxst3E6YJAr2BgWWm8l43QcxTKKyRrBYR
	e23P+4EauJRqJxSzGrRcp2hXrae3Jpw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5897860103;
	Thu, 26 Mar 2026 13:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11C6C116C6;
	Thu, 26 Mar 2026 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774532537;
	bh=/ibWzeKxjNFBvk8wY+4Gkqhtda2oN8qXvu9dlbPEKXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHgy518KsjFtwu8+Y9MEXkDzm78FGQR1H48i4sLEtgqPg7ntJb4eFGmGBsh03q0yL
	 sUI+oUxdApsJfW4l2Z7moz/Tt3aGu7McGtNPiPhYhiPxBEqcKIixXt8Xpe80VmS9Uu
	 3aSZUb0v2dlpxeDE5aIPOiix0OfaMs3KIk14CvBTumkBR0s0wRkZ3wLVzBxiPb6Bdz
	 O60p/Ldox2qQFxCZmtGmghEm0jxdyd2QJcyArIvIL7iolTnd8k3ITwuzqc9vI88CCX
	 eVRHYXzlqbpGw/yiUH/kdp8ovT3lih5fMNCgnS0GdJ0SbKOzTNb5/Qt3B5C2Z7avNM
	 4YvUhroD1mt8A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH 0/2] mm/damon: fix damon_call()-related leak and deadlock
Date: Thu, 26 Mar 2026 06:42:08 -0700
Message-ID: <20260326134209.90377-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326062347.88569-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1BDE120002
X-Stat-Signature: rz7mtbz463x6pr3zzeigyzdaa7e35mn9
X-Rspam-User: 
X-HE-Tag: 1774532537-278940
X-HE-Meta: U2FsdGVkX19EDcor0xVA+SITNoeBvbzHuQPknmjNusZ3AqeZv6nxMCltbKERP0AHIvzpaKZ355TubXmV8htV1EqZyH/wAOJN00S9GsKLTbTzCE5zl0JAjiZTY7BjE1ucwOlRG4Ycb5FaGZL7mzX05d6abL5kc7qmQrx6TpXmPyb2mkR2vqYHEW9JBsRHf9GHFepf+ZI4WxdKUBrh3u2kn52PL0Uj08zaMuNbupGBvKAym/wwKFFJ5DYjORoFnqIjS50BAXCI5J39GQKLcm8peyjGoeoYix+WiqCJo67U1Kzh0q4HCkvGICLemaSav+9818le/gMkJ4AO3x5L9WCKB8+g6801GFzoPhvFQk2ftmzNhvGL6jbR++qRzsS4cnQ1uRKW5Dc0d46pIlYCrBDT+L5T3/H2QsNzUUr27nQ6V/NtuCKtQccgt27xpHALt5C8Hj/Lx7vjhFhh9FDcfTVH1Kbp6TJAuM2YFIpcFoWuUAIklUxO3f7szFjhkCGxjHUyLIs5hd6Suu6NWuQj8YjfeMGiFxOBFNcbd9TgliK0gITe3Bdx7ZGq7QBY/aW2zfKaTVud3ibKMY+7Wr4jkTpubtfYx8pkHRtZKYbLZBC1xSkzm58Dwh54y9y42PQ76s24rGddiNV/bdx6kYWIIlfIZoPq+2T00liyJynESoLB70CYOZ5g7xfQHv23x9LmrII8oWWZLlRO4xSM4lZ5LxkbzEcYB0aOS5oIwr5AKnp1GpKOY2oD5bEiXNcKvLXppdLsK5szn22sZhtM0csRSCKndBCaY68UtRXJXsxjVnymtyvUTm+hTs1l1XpJ00MYUNrfN3pDFfw81myeo/iH6cszQmKdqt0ZcBxAkhbbctXblyNFmKnb2KBeg9O0wuHwgy5EA7khkj/RwtKEXNSYGaCW+Pgl/prkNy4g6VPrlU0i02PN72junncAF5WuSrMJq1bxpWrwkqUjYePAFGo1H6e
 bN0lU9BD
 uw4PN+y0hHDRY3wzDfgXt3KGV1dkVkHi2HUwmu3JuP/UpB3T/EGIfjSH4xZY38ILuvjt5B6NQeH6z/kKgAitqx96dbhhht1v0kvFHpjhuBFb9LxJwk0RghGPTOG1mzPlTUHQB1YzQ0zJleXs5e2gOql9TWmvfD4nENN5SaX9cg00z/73oblw6prgR+ylMnwX2Pzy6iB6FWiNWv9Cjd0DF3WoZ3bLB1ofD42OhdRziSMbmBGAwoiS3RCqf727dganohsxAKT6Oa0+vgkk/mwBAqE0fucRBLUhng9s3Jexnkm3m2ObiITregi+fudsfkrPip3baq6uKDahV1iP3f5WdwsmLLtTjMTN3MANk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260326062347.88569-1-sj@kernel.org

- [RFC PATCH 1/2] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH 2/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
  - status: Reviewed
  - review: ISSUES MAY FOUND

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260326062347.88569-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

