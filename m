Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62DBDC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3146B008C; Mon, 21 Sep 2026 11:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67ADF6B00E2; Mon, 21 Sep 2026 11:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590D66B00E3; Mon, 21 Sep 2026 11:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F73B6B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:24:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CCC791201E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:51 +0000 (UTC)
X-FDA: 85238141982.18.8EEC816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5336CC0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uit04d0B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rUSSPwGcAFQsl4uxClmz1BHLPOEerDOJfABfBbj2O6Q=;
	b=rRFEUzfeVPwpRbeTSZ96NGsMQ3raoc+GpqD7el6s3c9tBdW5JP0UrQp7lzRTFr4bkEEWiP
	twKrdhSnw3SadSWtFOr6HjkRrUIGVhaTE1nq9EE1isU3pwriMC09KGQGHmvHb/+x9wJ4km
	oieh3PzmfgLh13AHDxQHlpmISt+9tLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004290;
	b=00+IZrac76CZZRQH8r0scTwwEUAM//enY2KGheP6yesVkvGXTcruGzdk9BdyQm1ZL8+b4C
	G5R2hVq/oFdtY7r6/ZXjuUnzVtzIZfIqK7pHOnM2CUI3k1pLHPhlkznPtMWETgMwHoGGvv
	NNAwjoP24ihL/knNHocSpvyoJu2v2SM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uit04d0B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 81D3F4243C;
	Mon, 21 Sep 2026 15:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD31F000FF;
	Mon, 21 Sep 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004289;
	bh=rUSSPwGcAFQsl4uxClmz1BHLPOEerDOJfABfBbj2O6Q=;
	h=From:To:Cc:Subject:Date;
	b=Uit04d0BaHB0QLpCm5HJdlTak0t1YoY4/xH3Lzgvgynh6BUyis4NjWl5WTohjBs4P
	 dCjww5Eqw4wnwWNvwkcXrJu7u3FBH5S028rYTy0+86Wmgg0PUE5bj2s1P2Ulo9jhRB
	 NkWJjUa5sREFmplUXaboN9o5MnbxKueMAr20VKKttkRCgH91hPk8iYRI9ghyBoftSh
	 kw8kxTB31IwKGUVQ9SkPBYmceZBNkkQjjRFyIwgXrshwmprapOuUaLfUnS/Q084lDG
	 7OvVZkyhgXbrOPMAhJV9L5fo2XtJkqcQ+Mkt2XS5xFHOKtxIBsvS5RAuQQ+yOTDGyy
	 CP+Po3RC75LBA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/2] mm/damon/core: fix the size charged for a filter-trimmed region
Date: Mon, 21 Sep 2026 08:24:40 -0700
Message-ID: <20260921152443.80132-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5336CC0003
X-Stat-Signature: aq8efxjmccg43ct6enytp8xw69sn53su
X-HE-Tag: 1790004290-142512
X-HE-Meta: U2FsdGVkX1+Y7PfxZT3lF+ONDD24UNiegVh9I1i+wRV1v+MEHF4u+yXSPAPE3QCUWdsPzInl0g88LWAW2F8kOXR+FrFhvBHPIToIt5EjbLcTRdxEmXYZNewV8a5HxOyQvZqctjkwgpuORSpiXHOs0a5i0/11XU8LaVwP42eMoCh9Nt17qRnrPErsJ2BF7ar9e8zbWE/JT+DUaqRvHe8xSkwPjSNWvTvLPNq3SNmMiP9OZrMh950dBlRrw8Jze1GquyafUgKGfDbY8+xsTH7rEkFPwr2YHeU26SDWSLEUgsIR+umFQHP5kAbgZteCcQR24cW7vxivni5j4RY15H/tgJAr7weh+H0agYg6qT33IS+YDchSg+Wnh3BjsVH8iSFl8Mn0bv4s/U2ZgZdEHDFOlwr3WIqMQ0Tyq0fsU4CLCUv35nsZdbJZloqY+EPR+2s9yR5u5ARGkTAit9RNc7+IQif9Ufp/9mK9QZ1hNzRxT29WxVMg0X88AHk0uGCDXDd1QKQbQGb6amel87A+0YTfWK0heGkN7r9NzQyuGK2bf/TYemF4D2+un7HjlWFQR+3d/YL9qdH3ICcGMoRyFV2baRfXVf815SiITOKkVANQScoyxBkE144/3W7bpE1+fbe4zv1N96vHI5EtEUdE2ZzEZ74ezRS/I1vXKE55uvg70h1f6+Nt1EOFQKKAvzONT0YCUlEmOVKjcKSU5YFjkSLahIBJC+fqvZsxbkA7oMXjswQwrHbj8C+UehzHU078pWrecSeuui3N5Ifuddt5brJ6OD6zS215w2O2PmaOPajydUWblqDYkc27LumP4a9tQ5m1NvK8o+cj5EggvcNHwAd1o1kDl4/bPGYSj4I5YQ+CrycpSMn5QdXzozu6PBOpd89WyXXyg/UI0mgYE4EHF3nkgWUPT3DocSuUeuU17NzjnDNIeA2lKRyzJhAWjEAYmRnug9vh+wIFf33Hd8rfllx
 6fDJm493
 nkMhZeip4DQ7wzaqKek1H0nuTfaZVDIhSPdWHby7/aAtRXu4PBi65gXE6dCpRM0FosN+r6Gw3vYibN6VBP36Sp0i2xxEQ1Jo4Yvq2/5GULKZ/AjVtGe0K76LeVt4cbJc0l9XErqKfg6G3Bkvq+UeVWqWKP9YidfJus/vpB0FoT3B7ptha6hx2lck0LdM6mLFxsaUXtSfXIRYWGPX9Pd/mIzACYPrinObB8KhkUNP3zc40HzZCe8zZUTymTAXt3IxPCmx7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

An address range DAMOS filter that partially overlaps a monitoring region
splits it, so the scheme action reaches only one side of the boundary.
damos_apply_scheme() reads the region size before that split and never
re-reads it, so the quota charge and schemes/<S>/stats/sz_tried account for
the whole original region.

Patch 1 re-reads the size after the core filters have run.  Patch 2 adds
KUnit coverage for what the function charges and reports, for the trimmed
cases and for the cases that must not change.

Changes from v1
- v1: https://lore.kernel.org/20260917003553.2465523-1-donggeunyoo.kernel@gmail.com
- Add user impact clarification to patch 1.
- Collec R-b: from SJ.
- Rebase to the latest mm-new.

Donggeun Yoo (2):
  mm/damon/core: charge only the part of a region the filter left
  mm/damon/tests/core-kunit: test the size charged for a filter-trimmed
    region

 mm/damon/core.c             |   1 +
 mm/damon/tests/core-kunit.h | 316 ++++++++++++++++++++++++++++++++++++
 2 files changed, 317 insertions(+)


base-commit: 99528f68cc4066167e5e7135c1172be1e6315102
-- 
2.47.3

