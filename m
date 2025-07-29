Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23596C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 15:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7DF16B0096; Tue, 29 Jul 2025 11:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55AC6B0098; Tue, 29 Jul 2025 11:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A92F76B0099; Tue, 29 Jul 2025 11:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 995DB6B0096
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 11:53:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47D4BC0168
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:53:31 +0000 (UTC)
X-FDA: 83717747022.10.1148BE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7994340008
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 15:53:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLOCuTCo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753804409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsXTspb2TojAYirRTQj0V5sqSl3VctJ8/PnTjGcaPgo=;
	b=qdpl/Yeb/LtInMfJZr82wASODzKGLZKdjGZNU3FH/c2hXavinOBzSjPVSjebp+l6likiRB
	nyJDkeZn6wUB08X3sE1AYuVfN92Kbstk0k4fpHzOn2GF9ctGZJ7RPqS3QVbAYkZ8HLAyND
	xkS1akjdcTvQQF4wk0eGs81XE5vnWRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753804409; a=rsa-sha256;
	cv=none;
	b=P79Tq71aBUzQ1Chzmf0q+v1+a5CUK7ZpfK1vM/40xRAM7cHv1H625r2EvdcTjdGCOi4icH
	EX3ao6/ykKTMu8HG3X+0q1ll3K2wmPcAVliDOnrJEavHk0uUi3sCbWr2DxYVeaL0x+veh3
	3uzyEzuOz5P7plSLLUCR9esLvfFd/sk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bLOCuTCo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45C964480A;
	Tue, 29 Jul 2025 15:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004F1C4CEEF;
	Tue, 29 Jul 2025 15:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804408;
	bh=qCaSWpcCNxthcnOr8otvX0oM7+4N3H0wfT8jaHma2EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLOCuTCo0W2RHZPICvStNngLqFazt1jjiCudVke/Onxj7NiDJ2dt5JY/FqitId6y1
	 MwpnXx4KIHCEj192zsEl0UkZldtmxT1htBfRjvr+u+0s8xudcIebCKZg6z2SGqTDaP
	 1a6DQvLy3vR/aG/mgMyHPKm+5JLK1RJZ4cfcY0agKFt0h2Z8VXTQxcj3fxJ8buDQ+1
	 7TlKjuEJRk5d9fEm3M4WzdNCRUuod4qmtzpZAe9wyK7YRKBvIE2J2Ux8D6DJ8SRJ/0
	 FClFgiNrQjI5jY824pcrMw3kD6ngBb63xi4KVer2FAgQeM1P/cSz1YU/bVEoswbWxO
	 BrSXRnPLL2gkA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	zuoze <zuoze1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring above 4GB
Date: Tue, 29 Jul 2025 08:53:25 -0700
Message-Id: <20250729155325.53726-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <ab6b06d6-d2e8-4695-9eda-5bfaf507c2f1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3n447f3mesd69mi6h83giii8q8p8qcry
X-Rspamd-Queue-Id: 7994340008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753804409-244610
X-HE-Meta: U2FsdGVkX19947ETIl9jBkLzLcYcRZYp80vnvTVYw5ypuS2aQrehQWLbxjdTMAhLY9Zr4lOeJKkP2dyBcmsO4vQqs9SsV7o6WBDnfQtJhBWCqPjgJgx7HNELDpornicUP9vp9ot9r6r7LNOqtu9TaD1LY2/kgEPVUCYjabCh+T9ts/DjUoeG3so+vVmGCEVjFAQWhNdJ4ZC4u7G5yKMxFPA5OCy3oCUYUJOsv6uFFn9Af6+r+WWEHTOIkviyFk9UnCGRyH2ABrYj0XMLosLad3X8Or1e50+j3XliaPvmGZ6L3fgCBPIGKXKSF+gOoZC03zlQR9ZCLCi3CMyb2sKH/mPyVIwYMP0yIx4WvmxjAXJGGLQV09efzZdKUHghjWTidlw32g6vmL67j8PjnjJbXN2RtBxYWUZlfH12l1kGBlyZ95MdC9C4k7+MxIzRwAnoN/SL4f+Bghv0AdXq8I0fJBBOULC8g3NLvInBYmFM8kgLZqcNZyDIbxb/tKmh9VhtnN57BvghtIVNedPrldd0hRnmnreF+PYg3seklU09RaQ8XlvvQopTksF6njvTd86R35kxPFSaX6HUxoEgh0miOmErQnFKsUfvQS4mDv9CcMG5YlzOjJKq1Bm+hT6y35TFLxKbVH5RuH+05EJzJ1NlearHWz8L4NLRtozHhYt+o/K6h++Z0omxMsUWoU6Vyhcu2xY/SQ1fy65caZlCMFFHaay39YpKj0My0cv9ZUQTD9A8ERxsXxAYCflxcKk7U3w2nhipRhu/ov0h7YbUz+dHckXLhI74Qs0rUHg1wjvKv8MZqTJpjXkPyayL6BEb5UlBOFXxSqE4AqaLrg1pbSumXV40rr9mS0C9VEnQ+0CY40FW1gMS2XuHqk+GboNiqT65Qn0M9eMIeFqLkMX5Jxc0GbdCtkddmZVlmW7J0ny8OwhauzwbR4xpJixoeECoNoV9f/7/PpUL+9cG6CvGXBU
 XZWHuFt9
 iV95Djc9q2TLIKsI+NaeO6OkB+8Hf1BmlNHiJ95b3Svu2Td0ix7BKXU6Y2IgRmWJ2ubtJGLS2iN7swBvM2Mxwruyg/pKaPJLJu9XG9NhLpS0w1dmC3vLOUrxl6GTOP+nmIKQlpsWsoDSOcbwI9YLephjenAhdTau3Mm/Oq/+ieDCcwwdMdVrFK6x2oWATW3buaMn8dyoiZeSSrs0c1C2Po4X67FkFSy/2+C+i4n7Rsjy0IJKcfYGzWbCS3DrR+tYywvAuZ9jrzN5eBC5lmsSsdtdk8PvLPcehbDo6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 21:52:18 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

[...]
> Hi SJ,
> 
> Apologies for the delayed response to this email.

No worry, take your time :)

> Following your suggested method,
> I added implementation damon_ctx->min_region, and also uncovered additional
> issues specific to 32-bit platforms.

I'm so glad to hear this, thank you for confirming!

> I've prepared a patch series, which is
> currently under testing. I'll get back to you as soon as the verification is complete.


Looking forward!


Thanks,
SJ

[...]

