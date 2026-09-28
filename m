Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19099C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1095E6B0088; Mon, 28 Sep 2026 03:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA2B6B008A; Mon, 28 Sep 2026 03:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11DD6B008C; Mon, 28 Sep 2026 03:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D25CC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:55:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61CD8120123
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:55:55 +0000 (UTC)
X-FDA: 85262412270.23.62B82A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C80DE4000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:55:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmPRuxMK;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790582153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vs807hViPAPmQ9mexVWo1Ffl9jfECuMvazzU5hbaGk=;
	b=hKUewttUYvM5BrLuAiKJs9QIn2HJVEEupPh9T5fxeQ21+sgE2jQ2Z4B7r52zcQTIBDEKaB
	npj2S83jJvDzGNxy2fP188a2nd1gmyat0GBX4RGC8b3vlE2VNiMJUKX06gpnCuQIJVQMFl
	cUQ/5XxDzt9DDS/GYblpj832XcoCtrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790582153;
	b=gt2Ex6SjjOYv4O2mu3zbE/wBHH6YYuo714789vnbY2n5rSUDAJq/fq7PQbX85Zn10xmp9p
	MCKHVsg4JCTbjoy77mAARFTp5fNNu3OSMMV2G6a7YGPuWz3fofOQYC1fwgxw5mW3Bm3YUh
	BBjXzmdu29+3jrpI1CJ0HQq1PqWWWIE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fmPRuxMK;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 570C860AB9;
	Mon, 28 Sep 2026 07:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285381F000FF;
	Mon, 28 Sep 2026 07:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790582153;
	bh=2vs807hViPAPmQ9mexVWo1Ffl9jfECuMvazzU5hbaGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmPRuxMK/a+e4TwACWc5HtJ6DJAB+gkltV1d0bapWhBEummTA8lzp2ErDw6jteGX5
	 EmbYrrWdyRTYwEUMvSTsMnaYCyIeUjV32Vat7b94B1UVc0/FbEIu2gpo0HdfyBy7jd
	 /U3L8gYEZLMtWf77VnhLCELnKVBIKVUCZFohnctaWiWR+/nX/UCoztn3YUpXdT/shm
	 aVqA4K9AhMboTxpn4PvOHIXkjIBT5M1HJis/TCw05RoXxW1oDJwn0SCf0pM5Q4Pfzo
	 stpUnnAwQ6VLjrEJLfou5ofdH57NqTsOngBkyLcyg82aH0XGQl5EfPDivxDw4cCP1X
	 NH54nED/cTZkg==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Mon, 28 Sep 2026 00:55:46 -0700
Message-ID: <20260928075546.3245-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927175159.60703-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zk886wuceknibwbbqmd7ez7m18duqjmz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C80DE4000B
X-HE-Tag: 1790582153-700838
X-HE-Meta: U2FsdGVkX1/e3Mu/MuSvoDX0p3BBK4Fol/7yZJf2RVj0Da0ONoYZdG8dr/5Vi1ULQZqE2Kui2at6ZDXMSDJ/+8BMelPBFeuI/G7NUX6VIzWd+E4LUXcdwoS3GKfU5KnwRC7cxVim25hQ3tgpQEtdeBJhV2FrgIy++qmoSCriWu+nfWFbEFD3kXSRp+p1OI0oQvXuCCaGcs9mPkkeOA9Bo1XhuxPDt6uCt8GccgJ8yXliVxP2FhS9Ypy78UmPOL1V40jFDW+jIPf2oqsZQ5M8ORs5cdG2pDUx0dyDdqtTEV0KuFBGR8fyGP/ynoQxeHpd+JXonULtrgdCJbqK0Mo/B6nPLjMQZL5srX/YoW3lCjgKEjMJCFveDaoQfK1IjEpKHhFY7/iokIQ/Pur21TuIgIpZIO1dhSOSirp/dPiSzARUmJ9HCAmO4sXTFkKs1alyDKPcIHS1JJFxYLeUP4HAu+XGxlvyFCXoyWD6hmDPfxtem/B5AO39dUfhSLxVRzG7sLEpkXNBbNz9+b1OkoaiUQHZ6Fsgaixssc+uafz8KVka4meGmMB+XJOsL+oDDzsszXZhgumLqb5+O/IoHzkBpwBmmv5ssnGY1mqCMYtpUi6jF/Y1hHFpVAJZUaNmcE6toMJV+0zUNMR5XiHOexYjG/3OtURIdEsQ1EmzMp8im8ywtR940FLrOYDHACnP6steoW9ydrR497CHfJAQld0R2pZwjcmtmgVDu0Ptu2x4Axw7wVlUDeUVNDMUDBWHuE2nwDYPbfIS3HJNQT4CVBaQ/r9/EbZFl2w3CriBN10opyKaYps50Fs0ou/LDIF48/ETcjaGeXXyKTr4vfdODb7Pi9OdqYzaswq/QbfZKMyabE2CsTpUUSHTjw5U/woMjaaDnufEaEZCCSXDQfs0m+xvnH737GGqUas0iR7iT/meJbAfgPT4VFkLmpShwde+OeUBFYsqwfztNJOLDaNyC0n
 o+Fe6Y0T
 kVeoANegk/iIw+Kw92QfM+ewkLgw4svUqozCv5SGGud3tRsjhxfnDVlRDzt/4c6Y7wiDwNz42p2OZOSRX3Td0yhBxGvk/EVAzMjO8sik5aGQA2Uo6vYgQ65CSfxUWda14GZj9YzhT/SllGW9V3hjn214t/Csbpm8IfkHaD5ErbJkdWCZh9WSjThb6Z54WLQw79PSluMW8guyIDWP0Gg5KPKEzPVWD5UwGztpbq+p2hcJW9OBak490rMWdvV+ipqxJdDYTPcLfu3E4ZO8RQCpLWpfL0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 01:51:43 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Commit b3723b596b54 ("mm/damon/core: fix unconditionally skip last
> region") fixed a minor bug.
> 
> Add a KUnit test case to cover this behavior and prevent regressions in
> the future.

Thank you for adding this test, Liew.  Looks good to me.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

