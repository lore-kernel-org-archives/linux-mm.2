Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89ACCC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F666B0092; Fri, 18 Sep 2026 05:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235AE6B0095; Fri, 18 Sep 2026 05:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146616B0096; Fri, 18 Sep 2026 05:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51086B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:10:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B62C1C1080
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:10:59 +0000 (UTC)
X-FDA: 85226313438.24.F3627DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7DEDA40008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:10:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bz+TTwjs;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNJi6nGPH8ZTguXoPLoous8uAKQ3uRVi+YG0cOA6Fmw=;
	b=wVhB35NX1wTqf2DjqWKPHZFIXRuSuyQA0jXBpb4Dx8FdDUmX+xGPMg80ySSL/pgLprIF58
	nzaazisX35ihxeg6PNI2aRB3ni0D18Y46k4BBR/bxgX/frx4/0/vR09x6bAfTSK9F1UJvn
	cxcIiWaftIEvL+g7+JsGob991KD+pQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722657;
	b=jz3SnYXM11lS5GKWu2tCLu0xjf1beFgvKvx3PbST2KbE0RORCCdkMbR/Wg1EF5+pCTgWPY
	/kq4K1m286JeNtoCXw/z9YrJ1RTnqngps2ruNVodtxjkrGpBOFHkCLbjD3kTOcvH8TwJeE
	5NnU3wyZywxpSd1LwQi+5XknV8uyal0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bz+TTwjs;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 241591BF7;
	Fri, 18 Sep 2026 02:10:53 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 688683F882;
	Fri, 18 Sep 2026 02:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789722656; bh=0Gs4DhCYwB3KNPu9eHCxhSGFokYsZcGSeJbNemazHxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bz+TTwjspbB5CaBJQxhzIc+/C1YNfnXZLlT/T5yo6haK6KNwifGYUJynU0DrbRGwX
	 vf4N1YThDlrhFR4eQCgJt1MZJGlooz1TqPGxlRH2RyPPuc+n8XzbLDH3PMakjlMfTD
	 AV+DOvFw/Z5Mw10nwAD/y+QnzprCz/BN1XOr+fr0=
Date: Fri, 18 Sep 2026 10:10:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/3] Documentation: kmemleak: describe the metadata pool,
 not the early log
Message-ID: <aq0AHKSkUCSeQMV2@arm.com>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
 <20260917-b4-kmemleak-doc-v1-1-84fde6d1f749@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-kmemleak-doc-v1-1-84fde6d1f749@debian.org>
X-Stat-Signature: 4fb7sguwtaqhdfo74ymy8znus1ff3qd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DEDA40008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789722657-98807
X-HE-Meta: U2FsdGVkX18ZZUXbuoC5KisB8U8kS+PnatwkUtbETcbUa497xP3aMCmhuTcqVa+iWwOwaBjsPyo7RWNEooPzJnOKZGfv6ylJ/NbzYacAt9EK+uU3bq7P/AOfpsfdQon+kl/j9RCiLvXD3763Dm8iqOu31uXbcUQ3BHGAvK6N7JiyYP2+xUa5oUJdUgoWCMIl4NsV/NEzOIKxQIvqFTclYf90VLE3Qg0Ip25BBtgVN58HSpb0+V+7UrYrONiyze3gWHGRb5pDFHmHZ1aqrIAqRdWMCO12XXhJ+FnOm6xXL/Lwzokk9MQpYzbx6MVXES3G6BXgweoMKiXfpD+m0NlNL9itSpJ7pcLCoaqVuLM/b8bE6c3R9WSHsfeQ8YNJoa8JlZlb6aG9IuOpLvP9pjXCqVte9pnButMsE+rtW8iM3ham3s8s+8hpk5kbXWnUhMZ0Ncolckv0FCidudLZVutO8d7oZEbfATmDtorXD4mvMxDsvjOfAl+IHLtpgJznP/hFIuv5hfq0JIkv0LCwerUfeRf3zhQYYPHkQ1teapgXh8FgcA/aPZ1QotrRIeCUvd7CnEYqziQCt8eNSZOw7X8H9aSkyLwGdM9nkisWEgnPrKEyMrf0l0oVpcOLUtlvIPWl5xvE3Ro/3rFyauLy9Jt6FWc3Jfpl+CuWwFmlODTz7DlCJXiuA9rjNTmSRx86nWuBBquilYQao5qXKzt6eWH+NfUeaeH1Q1bBkRgFbHjEqkT3bVCokH2LszK70yGiP1rHxsO1HZipTKxm9WPJUdc37zoYfxXewxvR2DFdzpHn6ZlH5alV+Pms0axBkVv2r8XhJkA1X/tKYs6ciFf2bGGf7RC5g2G6Ok4oH6ZS5meqY42qz5VrnH7KGblAeG3f1vtc+5CVd8NRo6EUq+etl8YHXwuRyH9q/6LF4nbHv3W5j/JRfKXrd5wTlk1UjNqgJIisD+m1qTuQbBy2N+ggnIL
 zNa26xqv
 Jl4Z0YAeAPkTQFTlQE9hSfY5+Ij3ilY5syqFdziLljYGyNPdD9eq23Y36FP6zqixCQTb0UDMbc6FchGMLAT46LB3CxYliRBCNgbdpPiPeUmpvUlNx2wYEWm3CNc+lM2HuO0GHUsBhN+/EAo9lXMgtoM7meoIdLBUAKtp3xAhysYYb/16m2gxdKpRUZkKB4FhvYaT173Up2ybOMU5Ki7urEVTxLHB4Uz07uY9zjz4Ghw2E2/kZXUKRx8wvHDLV5tzFVz+AIKdBjXUtudYauieDZ65k9QLEKKKxTm+oKFzdJhlDW0pP2MwzAj23CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:47:35AM -0700, Breno Leitao wrote:
> commit c5665868183f ("mm: kmemleak: use the memory pool for early
> allocations") removed the early log buffer in favour of a static pool of
> kmemleak_object structures, but the documentation still describes the
> old mechanism.
> 
> Fix the documentation by describing what the pool actually is, matching
> the Kconfig help text.
> 
> Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

