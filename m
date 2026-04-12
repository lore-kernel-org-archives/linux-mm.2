Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF88E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 18:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5444E6B009E; Sun, 12 Apr 2026 14:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F58D6B009F; Sun, 12 Apr 2026 14:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BDD6B00A2; Sun, 12 Apr 2026 14:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F18F6B009E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 14:14:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4FB01B6F18
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:14:20 +0000 (UTC)
X-FDA: 84650703480.20.C0F085C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14F60A0006
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:14:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAskbK8U;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776017659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odCuR4OPY1DGDGwGb1d1EW4B0dOpY7i9azhYVMlCJEo=;
	b=fK6xRtB+QQlkoT4zGsr4srw2cURbzgM7eekpHxvkuCjuYUHt3cromZ0eii9DewIF21dfJx
	ljFkScG8cHLbWSdqzSY178A0zTrYpzMqHkde+tsvrfn00TK90SQ2wlKfF3G/tG6iiHtW+1
	U7zxioz7uZAqFMHOJoER0gPVLnYBL9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776017659; a=rsa-sha256;
	cv=none;
	b=OaNN5xixBzFr/fhi+FNxT1KGQy92aci8X3IVfwCVvaaw0Y7+5D70lzouyFWRgRLMDAvP3v
	6wnWDPQnlWC2obp09EKviJAQzJB4J3/HT8IpBcuwgkycrN5LYB+sGFKcO8dXyXNf5KmyVH
	DvLtYAWJd3B/f2vNOoQ/78LFy6Fnr4Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PAskbK8U;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 078354175F;
	Sun, 12 Apr 2026 18:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A148EC19424;
	Sun, 12 Apr 2026 18:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776017657;
	bh=ScWjFfjjpM9jn/WjFwtS9xJ95budLw+WQgu9N2i0yr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAskbK8U63j7K2gYgh7JPEvRyPtpkqPh3JB5rKqMB8MZPYFL8RinP/tRLYZXW16uN
	 V0FbIjCqRcoPGj1KzTUTYV7UlWk1+t2ckM/jWKfsB9G42Ch6zxcC+qvQ/9ezf2Tj8e
	 1/Dp559TCBynLYestO13T/2x+IK3xuYguT2bPuMz6/a/HkSczEiGEhDaKoXT6H2OGl
	 YrOphXq6Zx2vdI9p+YUAin65/pPDdhCz45nLhMfJnzEP44rmn3GhQ++uM9UFAO/UH4
	 5mhfq0oLiGQht+RUCnwUr/E07RMhlJ1zHeu5ZTwusynQVITzDXcmloyHDzqlWxbbOR
	 1B/4ZhI6mKw5Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH v5.2 00/11] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Sun, 12 Apr 2026 11:14:14 -0700
Message-ID: <20260412181414.84422-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: y7kgdzhwzekayqntp1pwe3tjbax8ifcw
X-Rspamd-Queue-Id: 14F60A0006
X-Rspam-User: 
X-HE-Tag: 1776017658-23895
X-HE-Meta: U2FsdGVkX19pkhz3e1bi0m1OqLSb7v5dGYpc+pdmWHgVD1A9cl/MnODD1E+yubrvhapapNv42ubicAFqVkqfQmFevzMI/aESGfKWhEsOn96y446lGAHcwU6Ui/4A9eDly2Xfytc0OhqnQxdvcJsVjzA0snRtiluT6QhQLzQzWD0C18oOaHHeqmwL/r3/ktNMhvGRR+Rl9MqHOO9n0oI0vBMzA3Zrd0jf1QDNwrd3vdzoMuDSLYekAux8t7eceHSx41S5kc1Ykqt1Y3TBiNaJDp/+9VR/xPIChb0MdfIzuCTyETqExVHa/VujL0ZbM8dBWzJupwniIU7zuOtnFrQVxXa9SAo00SWNi7tm4wEKtBo1usEQwX426ydBzOvDQlesFI1/W56uSiKWPmZUfhqpflmkMkroSgq3fP975basdoyy5EmuvTreX7/BoUKodgnO6hXYyi4yH9/tNPg0q1k5R1lpGNC5Ap910i+/EWmdacen0jKz8SGvoQqGxnlPmkCw5nfdR+I4iRYuVUFtQvcBdKtHBgTGXN8ax/PBIBDOLFXv9BtGMRn5PaZ3qfQXXagjuvSV/+HnmzgYVu4WXi44zBKGJ4GJIypRNvWDlD3OMsnQNM+zzww0DMTEuwtjPLXG8aCOoWFUWxAwrPMJwR+cpKY1QtMNTIZ/EnXzDzsnLtcAnOpDYxKp9uNlxYxVSA//d8WddT0krJZ/boZUADTWgY8lKCyXoCmgU+6lIHOQEz0EyNRuqWxxIODEqbdcO85aad9yq+jXGYFgcFTmbbaFFBLyiPHdZER0R1kaotSGr0T1PsBK5lHeogoz0Tz//pVmFfeIcz27Yq27WU02nOeqdEatplOFJEyt4CItctcjmSOMWvUalaJRiS5YE9/hzQAHlcbIteGIBdzCAsxc8l9XR3RkzCxmuOLmlPN5Ph68mVPPg/986J8R6QrSBotdlkgQ9zOH+4Sp7Pyt89Z7Gxu
 NoF4iKBo
 Gw8iNbItyNKmntDuo84vcx3e4zsDjXIFTcbK1ZO7LnfUE4Ww6X9BcpftPM01SQk8OtvR7pvoL2oaVhlroo1OTnFB83EvlE1soTHtW9dUP3YJCVa0cKDDFMv6iSGPU6guH8fAc73AdvSwgDN7hpFmVfH3nNFjR4uamwjEU8C4g6ymqsbNcsQBKVSQQMCumcI7kOC12PGS7mE3CQbHwyeY5MUIYihg91nHXFhHRVnVOPQh/nXfbccSnGr1KtUn7M8YlLds5d+C61LXpzr7Eke0fDBeUqE0epvHKVLKM2IabXWiBaRiohJrbrWIAxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL; DR: Seems Sashiko is finally convinced.  I will drop RFC tag from the next
spin.

Forwarding sashiko.dev review status for this thread, with my short comments
for issues-may-found reviews.

# review url: https://sashiko.dev/#/patchset/20260412161957.82835-1-sj@kernel.org

- [RFC PATCH v5.2 01/11] mm/damon/core: handle <min_region_sz remaining quota as empty
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 02/11] mm/damon/core: merge regions after applying DAMOS schemes
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 03/11] mm/damon/core: introduce failed region quota charge ratio
  - status: Reviewed
  - review: ISSUES MAY FOUND

Sashiko is asking a same question that I already decided to ignore.

- [RFC PATCH v5.2 04/11] mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
  - status: Reviewed
  - review: ISSUES MAY FOUND

For this review, Sashiko seems just hallucinated.

- [RFC PATCH v5.2 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 10/11] selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v5.2 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
  - status: Reviewed
  - review: No issues found.


Thanks,
SJ

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260412161957.82835-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

