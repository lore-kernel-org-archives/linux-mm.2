Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E5BE776FC
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 01:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113EB6B0088; Wed, 24 Dec 2025 20:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB4F6B0089; Wed, 24 Dec 2025 20:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B216B008A; Wed, 24 Dec 2025 20:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5DAB6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:09:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E3831404F9
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:09:21 +0000 (UTC)
X-FDA: 84256210122.22.71188FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E89914000E
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:09:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvHowpI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766624960; a=rsa-sha256;
	cv=none;
	b=2ZZfgMYKT99TpBYAGSWJ+0yhhgIGKeerP+uNhiCn1bvj273VF6Xf7fuj28gkjCMSrSoqOg
	ShX/TEbqPr8R586Ps2TXr3i57VVAEQtR3roGMyDvk0OmHnfZlDp6SROP49gnLgJOlPAJ5l
	EAiMonr51GhWPlv3kgHs7RP0GNlSUcc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvHowpI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766624960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5ncGSLwpq59MIqQN+r8QVQr0H2YoeTIj78fpjVJy2E=;
	b=F/wgQS9DwupYKw4IUnFKOdmEIs8bWnZGv7JHC9764hKzsiDFT2hZm6c7je7pKM5Wic6BLt
	JKq/T8jPzE0kNyxdPTsyV6EWh9Nbp3v6WihPfUo9rx4zqUJBMVyczT0xs94WOnn0L+vdkj
	Z3bjqWK1/K0bK9LBlQ3V34OJQ9n4EBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6941960054;
	Thu, 25 Dec 2025 01:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCBBC4CEF7;
	Thu, 25 Dec 2025 01:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766624959;
	bh=atWqVlWPztPoWYujNROViEXfGrgp/U62OsSEy8tkX3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvHowpI159bC3FUzbJxJyAsjQqUBJVErhgJe73iBenOlg30DvBSdeH4J/pPUKaKqG
	 7SQTcEvF+ja8qWAxLYL3SJCHpYs5wC/buIYAqrabvzJkeHvWAIAAiDYVVuNdD+nTvq
	 pI1UblYcF4DBJLR3qNQXsFBJkBY53EvzpZO4lo3EzSQCfa98cDDTbrl/uN+1X8bFpg
	 IS/wMs+P+l1nMvj1U65XcTrD+iJtu3xKU2nzF/s7bpettmU9wJvvzS+OoV1mV3kYby
	 Whtfp3LuI+3LKPkcvuGIHBbcLl025E0qcUEVFd2HX+YMlx8M1aok1Pgiv/KMU3dj5n
	 3LywKB2PguV0w==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] mm/damon/core: get memcg reference before access
Date: Wed, 24 Dec 2025 17:09:14 -0800
Message-ID: <20251225010915.14866-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225002904.139543-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E89914000E
X-Rspamd-Server: rspam10
X-Stat-Signature: casspjhcg8a4wpkudnpgsqryxfjphp81
X-HE-Tag: 1766624959-243753
X-HE-Meta: U2FsdGVkX1+owdSqpXkNzQAcF9LhcSlgnvTJ4h43GC28B2qwySsP4hTqaC8kjAoi0kgLALJj88TzrcBJOhEYtQf0NPqe3GAF8GKnMnLt/eLQhp0Ksr5uwJ9bjYT4YPxNDwi4hT2/lHNVjxe3qTXlFbqw2Z67T5zS/NasRuETZ/0AaR4alucaZ83PldK+oBdjubs2o7sI/cPqOGYRhc7vS4AWAl5O6Lu2S03G0b21hF5MjDlr8zm6juUEzVnQfpjtEg8wgf9Sm5gt24dsGIuIF4UCEqz6HV3BD3y/5GctJzJjiQmIXjdMaWGcamnxKPQ8Fkqnth3SOQ4Gy8YKxgnpIyQYZPfHCHNWGPeL5QvKnlE2EYBgsjEZQPT/QKR/xJUP/ylDotlLwaDwSUf35WOLyvoD0IYPnHZlPS1pJa+0kbqraUwcGgwEob//fI4J+FpOZwE3G+kDxVNah5g4iBPb97UIpMctu/ve4IbT9VNtpjbs7dPlI4NDs5lYOg+7soDyEqRjcieAvN/AZTzYy4b/4JJF/AlKnqR2q8JnR694sva1FDn1smQ0F1+aONEHYtLAXKm2NQZ+urNeAcxcjn98h+Zbp5RAmYQ+x11iUo4b8JBlyn2MTOu89PM/obx0+MiAKR2Yp3g8j75ALnRqqvFnncDHOW/z54+H7xNty5bHxzEDYCvdYW56WqJhTHp/0SI1bW6mVN5DBCTMHCzLTlF+sOBonfv+mY98OwS8EigBHjeCusg4NfMCCqRvTsHge3bzM9VNPYxE4Gjnc2H3Ze0Osop8IiIWOYWZH5xQcP+zp1aHV18WvOt4hWSE1viAsNYEODPfxKayE6z0xeokN/FOKRIu+0RH7wNPVEpabKqNGx1MBXTUDWWpRXR8QzyCdo9N7+gFuy9iW10YdYwSgcCEOL2jJkFr0MepIIiYhRwnltxb38JWQ/zMJ7J1ct4mE8ODfIc2F9uQlDqIRbxAe+4
 xThriRW2
 5VbkjNdbfxEnW2IZ/jNt4gIIJ1BSi004dljFrQedWyErP6xdoQfFSGBGetMhj410Ih2+PhXBChevguYMo/pyLOo1EDO8OHR5ZZ3mIy0R3/d4BmOlHqZj4OfjpAROsfm3motQKJsa1HmNIDvGkEblKJ8R8k0o+PgRj0hNNzGY9xJB72mkMNdrpXCqzAfrb0nfucVxd6yttw6dHRZgy5FL4JTXk2QfOPBPjkv0VsNiYKRo1ospUjLyzGr+R1Gtn2CHl8N0y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 16:29:04 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The commit b74a120bcf507 ("mm/damon/core: implement
> DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure
> without getting reference to it. This is unsafe. Let's get the reference
> before accessing the memcg.
> 
> Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> ---
> Changes since v1:
> - Changed the subject as requested by SJ.

Thank you, Shakeel!


Thanks,
SJ

[...]

