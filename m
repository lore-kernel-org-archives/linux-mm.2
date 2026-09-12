Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 516D0C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D5F6B0088; Sat, 12 Sep 2026 04:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE696B008C; Sat, 12 Sep 2026 04:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105616B0092; Sat, 12 Sep 2026 04:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8D726B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:46:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA82E16041A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:46:44 +0000 (UTC)
X-FDA: 85204479528.01.98D3E6C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8812640007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:46:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KG3bTJy2;
	spf=pass (imf17.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789202803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=muj/HRuq64yD8eyxGvhrEp19RdiCrjzHDAVXUMs7IHw=;
	b=YjLVtKIhJ7647ufF0jjE3iCaDYfUU6TuXXNEAo9keJRCwXZv2znaERiCrBc6xidwzrMkfS
	ZtEnKRBa6sHpUidRn/HobTO66uiwiCw8pstRVJKt6sTW+flt2wyl08JQmBPo+3MSBBYGBe
	J0Ie5STRwCr8CwAcfEAhVI71BcyoF1s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=KG3bTJy2;
	spf=pass (imf17.hostedemail.com: domain of sh_def@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789202803;
	b=UclcEV1rkJkM1ciJcnFvJvBdyM1bc9w9KgTe1rRagk7cwVJ3XcsnWPEdSgO8/GZBQAX7ih
	uUxUcM1wSbAgSZ+YHzqDwXdJJJY3VltpbVGkk76EDTpMiCIb+kQVtDtYke+eTBqvsp4+WP
	ZR0XiARcmW+LT/vvCjdvZ7LLVbWfogs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:Message-ID:From:To:Subject; bh=muj/HRuq64yD8ey
	xGvhrEp19RdiCrjzHDAVXUMs7IHw=; b=KG3bTJy25PW28Y/vRG1otgkYywi53jg
	Re5lHhiOV48Qww8ToHTOnJt4HWQ8UElDPLgxr2qYeTfd3jYcoal5vtzya6KcopTV
	gJNXRfXoiI0Z/anZV5/PBdIJwp6cClgtv3CRWE+sh//rrOsGbd6VtR6bW5/IH57n
	Ct4sS4YApVtE=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD332xZEaVqwa_uAA--.63502S2;
	Sat, 12 Sep 2026 16:46:18 +0800 (CST)
Date: Sat, 12 Sep 2026 17:46:17 +0900
Message-ID: <173eadcb2d7b18b3f8c57a7c57bd7652.sh_def@163.com>
From: Hui Su <sh_def@163.com>
To: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: consolidate compound folio handling
In-Reply-To: <1ca189d6-5b36-4d70-9dfc-34316591447a@nvidia.com>
References: <20260912034414.1943342-1-sh_def@163.com> <1ca189d6-5b36-4d70-9dfc-34316591447a@nvidia.com>
X-CM-TRANSID:_____wD332xZEaVqwa_uAA--.63502S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF43ZFW8uFykKFyfXr1DKFg_yoWfGrg_ur
	yktr1UAa1rGr13t3Wayw4rXFZIka10ka4UCw4jqrnxAw1rArW7Gr18XF9Yv3Wkta18tr1a
	kFnYvF4UAw1fAjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUaiiDUUUUU==
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6hpevWqlEVpBPQAA3r
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8812640007
X-Stat-Signature: y4ozzq7jysq4raohcbz8hek93eas5tdi
X-Rspam-User: 
X-HE-Tag: 1789202800-599309
X-HE-Meta: U2FsdGVkX1+wg+itSzEf6Xts3u1oRiIT1iergfmb7N67llmsAb8UcfZ6wzd1+ii3uHQos+bxYsNtR9uirybic+Kjsa0PiJTcuGmb6sqlSqFwdXAkQ5HVb/eAO5y9jES6NODxrAxpHrVyDuDdqPpca/ZDRIyJiSGPi24Ks6Bh3uY9HPKRsvlLLOJQn3RVr5vHL8J4WmVPiVxYIQDtVah+qne1vcWVAYBWnhsBUYqntGDrF5sHCWnFNziPA4BbgnRL1YLRXIrX4p+DbTqYpcSbhqbaXu8rkFyg//QrROa3ud5Z9J5IfOOBwUzMmw7UCDSYmCLLcCHtmHvryxK5IGjZ3svyBPtM0kejlgErPGT1vRPyB0YqYDWB+XNcGJkyQcu+W9uH8DJDPL2iXHbtgI6btN2dQlW8tmJ7YTFlW96AHplyhKfcBzWuq7yqiOP49UA+Omgvr2yt3hM7LnC40T8tDKyIHtOrNCbrrQULZ6yM3FrNBUxX1qtfKLTWGhN9CARZlvCvmxXAd01jhyMIn9IyO+LFUtqZuvoIZWRVAuFIny+JElVfT9d8JIjrcf7Sgu0glb8KcwH9BNd6o+66rTvsytqfdDNpRLBiQeupa8yLmqGTPFTanujpbfH37aEItSQJ9lAvFiT0Ac7sQjMltJe+n6rsKYmUj+1vVwWbuCUgvkxJrhet8KfOtYT5DyMhkOfeLwGvIXcD1UlYx9rLWNghakyVNKtzQum/Vrp5Wz+0zYe8KuoM1Q5MOk28uLwY9IfRRbOlP8z55qmradJyj+QE+0LWn4WtUIFUQdTlBkBfdAE+CGSwMrCo75vmE5NTgc84WxfaclouGDSp5saj+1WNdYvk/Y/OxJbrEgNgGsJNTfZ+87L1YUypRPhGoZ3+mUMOc1MX1XHLzgSJHhVKWOIckPqeiJG1rDKEYHUmOvlQx45XmE/8YbrBk4MHkAOQiGzdmL6Tfks2FVQTVXvVqDf
 k79B9Jg9
 LL69DUN7XLAABvqI/+FXZn+Z2u//CXRYCYkyhne4Q1zSD9nDHy50n03wHVltQ2t29t1ZDZSCIZFuzPLRNwxdxN2UZsRv22K5ZFIuBm2PPCTcs/AdzewFletySUqRyvQUzJF54cfPdxyqEWeEB65Jkw0rEOEE5VDbTocukcLV/8Sv2SPFHjgXNUoqUgdMwKYMCepQtE2JFpe6GiZlBTicw3XAto2Rg2Z92R9LIMQrWnNAZpsVJyFajyR6OsWEe7yNu/zun+lQQ5aJ2D830rhiqSw5tswzRKJpJP0Yn75hU/lZAKlSPL4lbXnCsaYen5J/g9TElW6eyDbcDakv8QDgb0o8kmP8pK2cUAotX0HsyVWIH9h/YzTCaoC9rRCirClPXZDgnRGvykZBPdinGUy51HyHjGDKH0cxkSBRhxoUx5hmaYgJU0+ictThV28+Blmvumr1dmp4h3GpHCZ7oqPug4OzVnA0dVNAxPutM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

Thanks for the review and the Ack.

> Don't we want to check for *src_pfn == 0?

Yes. I'll avoid setting MIGRATE_PFN_COMPOUND when
migrate_device_pfn_lock() fails.

I don't think we should return 1 immediately when *src_pfn is zero,
though. We should still consume and clear the slots corresponding to the
whole compound folio. Otherwise, the outer loop would advance by only one
entry and the next iteration could treat a tail page of the same folio as
a new source PFN.

So the plan is to keep the folio-sized slot accounting, but only encode
MIGRATE_PFN_COMPOUND when *src_pfn is non-zero, and only do the
unlock/put when the lock succeeded.

> Can we please change this to VM_WARN_ON_ONCE?

Yes, agreed. I'll switch it to VM_WARN_ON_ONCE() and keep the existing
defensive clear-and-stop behavior.

I'll send a v3 with both changes.

Thanks,
Hui


