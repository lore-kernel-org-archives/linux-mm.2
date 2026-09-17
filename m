Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2620C982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 01:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A346B0093; Wed, 16 Sep 2026 21:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBE26B0095; Wed, 16 Sep 2026 21:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2326B0096; Wed, 16 Sep 2026 21:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 420E86B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:27:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8117CA01EE
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:27:01 +0000 (UTC)
X-FDA: 85221515442.15.A79C8DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBAE240004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:26:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRDo5fsT;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789608419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OMNz3CzLTryMajvI16kLuSSdViwFTIviZ5J9O+nTJk=;
	b=w+QDw0gd7IBKhx5b1DJVSKYf0SImkog7yoVHbIxZP2rmW5il2VjPUOrNAtshxBtdULDlxr
	BIdpMwYJJVJmbpqU3+ZIxeSZOTUeU9Af5FtZhZf7VH5W2HZYW0yRsCVcViOSAilrce9VYL
	xoWfV2VypjYejAQ0VfWUx0MZQjnh9ws=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NRDo5fsT;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789608420;
	b=Og4u73HM1w/l+ghS8YitTyBNbF04X73qlHtPh0hFapvaSEdfdueDqyHAOIlwpaKgsOF5LM
	3knN6ByQVHIFZLVmslbAvMOK/epiGLpOFUgeNhoOhPtCQ/MMYf5x1lCXhpR7C4YxTpzHzz
	a2YBwkcpONpkHZTzCDV5UzVtPu9saj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C07E42E4C;
	Thu, 17 Sep 2026 01:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B981D1F000FF;
	Thu, 17 Sep 2026 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789608418;
	bh=6OMNz3CzLTryMajvI16kLuSSdViwFTIviZ5J9O+nTJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRDo5fsTaWRBzlfqECIeSUYrTQGoI8rKKgDF7QPrWg4KSFgezopRMNebgitb/ys4Y
	 lB2PcCpQXn+qRrwjlqQ8e5xUsGils15XgZC3/RholiTa6vC8JlM6mz5HVNG+AK0vVT
	 wAm3KSMkrtQS9obmQfH45lt6NgT40qF8kMlwaT9xo0f+UFRWkVxk3qX9udWoSZEnEu
	 y2eicZ+QVDTYWkt/m6lgjEhzroBnwJDB4r/cFgjswaOdm2H/Tv/AuICCK7lScOEpNJ
	 vbwIDUimWyEsRyGBpP32cTpMiRi5Sp4UqrFTmQDwutvIeoAW7dMzhcQENfN+IG2/k8
	 JHqqP7nUm0HiQ==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon/tests/core-kunit: test the size charged for a filter-trimmed region
Date: Wed, 16 Sep 2026 18:26:51 -0700
Message-ID: <20260917012651.101228-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917003553.2465523-3-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBAE240004
X-Stat-Signature: xfo6yfhwgb8trtshg7i5h9m5j1ier9sp
X-Rspam-User: 
X-HE-Tag: 1789608419-522874
X-HE-Meta: U2FsdGVkX1/XKWrJlXFrU5T6WNJ4z/frSnQSqOyaRKiodwNEY4akWmtgVbdDn9quVDbEjyFSo1FpUswDNVnhkG1mmZD8JA+k7NIsnoVisI+erHTOhUjfIqUTIJgCOO8zwxTtZrTv7SonO72r4bTXALXIdlenhrb332Nu+6xT9+9+UCD+e/fp3cnsPi5AhdRR+/31V4J0c2ApMYhi2nbXPlEBEjms5ZKbibl6/2sbEa/xF6k7w+J7SbS8wLcwITDEM6nAi0ZCHykpfSI8KVABl0qcvQPxfgY96F8fL2Yz4IQqY7MNWGY2QeX5uLToUYE6f6R0yvrmw5h0VBTKtWH1zih3tkYMmV+ZIZUpugprHhvFJhvYuVSqhasL0XRpIPUzHY49KO+p+GH6zWrUJ+xBQv/Fcqs9Mfr5OF6lPhzd9Eig4G2qD4gs+rYuk4FLXw6qicDrIS2ZzFfZsGmimEA/6oPw3pV0Ubl4XtAcKSjdnC3LH2xnsK9ntVnu1qFdWexmR+LAS6yHY1L4P8pViRu7pCmjO4j5cSIt05VfmgIE32rVFb+KC+UgK20rGtjtS6c8ZGCegkYuHDFbIITHHcFMEYPFfa5+2m1bNxAzdbKTHmSm1Abff42Fkzb+mdvn9fZmJ+cBLaUBkeoyBnyD/9Lry0OkgdODENv1yEHpddYCSl6Dd8GyRHQYkaLRONOqW9Eh7Pf2hxskMuR1sX1iaQtWROZ7t+ZxVKYKcW2dPYWK5nMujZmH0uii4qN9mt/n11V8WA4yYwLWW0TWbqkIpHCI3gMKgq17jKWsQpzWx3QNDsYzDy2OsmwCrHoRVNPy8Nav++QNC9TWhLg3yGeMmFph33mahi2n4o+McYmcCxwvZdBJFJV5ObcGzftwiEQaM2mKIeyvy+s9QtMEN+Mk3L/kdqlfCbOYZxhTDvLUCCTDSmRq4JPpFHseZnGkn6YHYT2uA/FA5EUn5YSZA0ug3At
 sGv4akhG
 WAxebyuyd9s95saMv9hofRmHx5SPMTI2mfibFAjD1t57DkzPvr3Xso1DQUgX0vkGVEZVckpJaUlVJ1Dr6WmyLgZ7z8eYv982iXpODPrDNl6K+UWaYoE6eWGJrf+sTr5QKpsIDuWj13jdHCewDnhGU0f4TVa1UD3pxylyBq7ReExsn91+Ix+lY0kWJyk3kF07GURfpTxL3aflHaZbg4fpWY57loTzAV1xKP5fNQUY7PpfpfN0tlj1SBxX6bSo4XvbbdYDg9yPMM1APlmwgG/dLClZzQ09MQsWJleQgrIGYZt0uXTsmR3sv2w55K/svxmozOZVr/TEFpAGLTF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 09:35:53 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> damos_test_filter_out() checks that an address range filter splits a
> region at the filter boundary, and stops there.  Nothing checks what
> damos_apply_scheme() then charges to the quota and reports as tried.
> 
> damos_test_apply_scheme_filtered_sz() covers the two ways such a filter
> trims a region: one that starts before the filter's range, and one that
> starts inside it.
> 
> damos_test_apply_scheme_filter_sz_unchanged() and
> damos_test_apply_scheme_quota_sz() cover the cases whose accounting must
> not change: a region wholly inside a reject range, one wholly inside an
> allow range, two filters trimming in a single call, a filter type that
> never splits, no filter at all, a region the quota trims, and a quota
> remainder too small for one region.

Thank you for adding these tests!  I to be honestly would prefer making the
code shorter, but I wouldn't block this.  We could cleanup later if it turns
out causing real readability issues.

> 
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

