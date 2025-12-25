Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8BEE784BB
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D876B0088; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B096B0089; Wed, 24 Dec 2025 21:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F096B008A; Wed, 24 Dec 2025 21:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D628B6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:30:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66DCD16050E
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:51 +0000 (UTC)
X-FDA: 84256415502.22.1CD2A5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E52BF80007
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUXab2yI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oePK6Q5m6jfqvj6+kUD2Wpqbs8RXyDc/KmGQltc3jpg=;
	b=VRq6rTEhNHSXAAemIf5xfpyIlRWqrX6VzHhw1L3FMJRq/NL4rbiZ0U9Rvudp7Vp1kDOLV5
	Q7NLrh/hKfZPVNtjk2E+O6ksAHz8sSywZ+hz7EZRgpyoL/6KXTv/aANk6FNrZ/LwNppNha
	LOtbU1VAzyroxiMP7eGfrVb4Jdhm090=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RUXab2yI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629850; a=rsa-sha256;
	cv=none;
	b=BvXKrETxIy0bOcVOTXj1aDLH/dY5kGf8XDCL9PqnBdGx7CRFD1hxro7UVd8u9DQpDFk1SU
	wvES2saBbdHGWpe/u9O4SLEUthfQTWWEvtnEU1XB+ZnzlvcBMHic/NlA1rVHePByqCXbf+
	gMK11yyQyzAPhOQUbRodh5Yh8XgJSZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFAFE60018;
	Thu, 25 Dec 2025 02:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E81C4CEF7;
	Thu, 25 Dec 2025 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766629848;
	bh=LLOqG5vJD2kR91TBM/mg3jWQ7kJeBAaIMsgcTlsWvik=;
	h=From:To:Cc:Subject:Date:From;
	b=RUXab2yIuBOMci7cc9iezVq72mrNsBVZb7cEhAbu1Qf9jSt0ZNxESa93MDIVT7htp
	 UCXXjO1UCr7Vz+4EaYLSb68bFBwONozQyyZkrEgvUtIPvYn5lzqAPFr2kZkLRSfX6b
	 MKXtdBremFdJtkl4zPGiaaGUFh0Az01m+hCNwsXrVu7vrwJB04wQMrQm9YQXPkopwq
	 xxPl24wcX3bTsuu47IKz5mFLQaZdu1paz4Khm90Qe9Uz/KuIAJeLno04ag35dUvaNy
	 +3mQZAxzoozySxXbgVkI/yHAuQyD41p3+tAndprYVLImmIgRaJq8nZMqsBUnj+Zcb5
	 Eo4AH32/22J3g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] mm/damon/sysfs: free setup failures generated zombie sub-sub dirs
Date: Wed, 24 Dec 2025 18:30:33 -0800
Message-ID: <20251225023043.18579-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i9e6fy6oj9mbmdip9cb86p665hwfqnad
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E52BF80007
X-HE-Tag: 1766629849-273104
X-HE-Meta: U2FsdGVkX18fjMll1F1smQBCFgHzx4x+nMhDdkxjhKIjiesIaYb5D6dOPyZHNCzT42Heu882ibfyoyX4kXLLGB0JzFQ6gExAxr2BYpnlH0ARGO5geBxw4vcSiz2wpoJD15PvGPHWmxeTfROQPryK+HR6Z1NTzzXDqx5lZfn8vFpRmXPS2SSqb9SK+OpG+wthhrfMenLinX8C2rbEdxiCNaDb9AYQ6f8kp+iaXhgK9MyZ8uHJXJS/pFXHSUnGM3E0rAMPIwK+9WEim5a6BmyLTe7Nhmt9bBqsb7cep2WDeK1uNFGBXQzNipm43eYwah9Eih7+S5EiPGILEjRARme7aTz3j390krzJ0aU+lhD7H7c4Wmx1CUUeKdBae5eB6WfYXyBPZA/K8ygnUfkgc7tILDWAkrH4GyfO1jQF6GlWti697JH0cks9I8eLanQ+jbjqtL0H1+iod8uzzk+sbz4BF0VwrV9HribgDNp3dH+RBsQGp7xG3Q1zwwNy/V7pDRaicWPXgW/yzxud7vrXpXX5VIIdwLbBn2d48DUt9jjCqHJ0GhpSkT5fOYxsF218LJt086LvnpouNpmP+pB3ntAkrkZJyUqBX9jf/UjZoV9HEkfsm/vJKVst6+TnU3FGqYAhS+ymY/qZuvZxZUdtNQKQdMyJostQ0BIvkNYTFbhoSDWayyWYBdEqX8ISXukShIqXNvX5xHpXnqMjwAxmrmtx4cHDWHrjTLWvpyO65zaLwhCinsG/4weG2ro4Eh+e4HgcQPcp2wS8+eOyfKCkVbaQhrBteyjV0KUClttRLQ/dQMG3Bp6OPJJ8d1cWwOm06lW1UL1uRARqnYpMgzSHoiwD9JwTFMuRc5tDUC49ILluaCi4ajpXUAuNThDor/wmdNlCNhdDsuBNQl9W6NKAqpMEgCLiqS3zREfPcePoO9CKrC0W6y4H3QPhkWFpr9IVCmhMVYPmO/ppm7bBqgfetcr
 otdwbuxT
 Jf6EiKXXDAWUuz67v/O+sF0ZtYpj0BiHfVjktvqW97Bg0C8181pcp+PJ0QM41Qsa/x23/nHsKT5ZgeRmo+qMVmj7Sslefc3Nac/JO174jG+TXpsnu3zI8yIPDJf5tIKQdI+AAFNU72KvcWxo6sGx5TY5Jc0afNVQYQ03I0jymeLINQC6oYBq6A9nUDJKnKXv3PzfQkMYiHWMrdz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some DAMON sysfs directory setup functions generates its sub and sub-sub
directories.  For example, 'monitoring_attrs/' directory setup creates
'intervals/' and 'intervals/intervals_goal/' directories under
'monitoring_attrs/' directory.  When such sub-sub directories are
successfully made but followup setup is failed, the setup function
should recursively clean up the subdirectories.

However, such setup functions are only dereferencing sub directory
reference counters.  As a result, under certain setup failures, the
sub-sub directories keep having non-zero reference counters.   It means
the directories cannot be removed like zombies, and the memory for the
directories cannot be freed.

The user impact of this issue is limited due to the following reasons.

When the issue happens, the zombie directories are still taking the
path.  Hence attempts to generate the directories again will fail,
without additional memory leak.  This means the upper bound memory leak
is limited.  Nonetheless this also implies controlling DAMON with a
feature that requires the setup-failed sysfs files will be impossible
until the system reboots.

Also, the setup operations are quite simple.  The certain failures would
hence only rarely happen, and are difficult to artificially trigger.

SeongJae Park (4):
  mm/damon/sysfs: cleanup intervals subdirs on attrs dir setup failure
  mm/damon/sysfs: cleanup attrs subdirs on context dir setup failure
  mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup
    failure
  mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir
    setup failure

 mm/damon/sysfs-schemes.c | 10 ++++++----
 mm/damon/sysfs.c         |  9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)


base-commit: 6d039da6a260dd7919bebc70ebb65d250bb9c24e
-- 
2.47.3

