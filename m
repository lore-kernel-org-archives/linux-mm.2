Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A1FC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95006B0093; Fri, 25 Sep 2026 15:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B4D6B0095; Fri, 25 Sep 2026 15:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83036B0096; Fri, 25 Sep 2026 15:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 916AE6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:01:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8B1AC071E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:01:53 +0000 (UTC)
X-FDA: 85253204106.30.C1D3B82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1F8E5C000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:01:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=beJzbYhb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+Ar61tv78gbaAB5x2pqKfWYRtZb9fTQQOWby/HKljI=;
	b=OlcsecX5DfgovO2reZJiNc2/gbw4OgcpdmNAx4+Jko5PX2vQXa27e75ynGrnKQkZuIVCWW
	CGiMQNwXfz4uWpLUIZf4rDtw88yYPcip56Xy7fU1BwBp+KwUOYRkiD0+5k9ib5IpcRcM0r
	YrUyKaPKhmb0zm/MHwKSblGoXcFEhhg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=beJzbYhb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362912;
	b=J9xFtlFpnd2IN6bZ6ujaHn1Z6BGbB2cOIYQzd5tzpVnqep97KBNcrEC6h7e7D+8kOq1hE9
	0uKs1K0GmoWG/imKzg0Z/V8PXS43ute80TNw+ArU9cofWCBMmzZrUpd4wQROfRgId1mJ0R
	8S3JCTAogEr7YqmWlSUjq6Rxng9WKTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 333A54036F;
	Fri, 25 Sep 2026 19:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B411F000FF;
	Fri, 25 Sep 2026 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790362911;
	bh=K+Ar61tv78gbaAB5x2pqKfWYRtZb9fTQQOWby/HKljI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beJzbYhbsUaFJb+iBlNUq5lBMdl2PkZuSguZb8itkZ/vO+zcHB7u2Jg3vKgPyepG0
	 x0+NRQl6zljrn9j9YL4H6oMewiET+NhzPGYg2H9dYsBT0lQs5aAbD83LTVhOgFeHz3
	 U1lL/isFBX+L+wPGxhqX3NjLosS3mTD3+o+pR6L1FExVAi1oKQ+L09TP5DPsO/VJJR
	 qJEYbP26knXKRATUJfdKx2WeYnHOIVTeIJH47vpLRLjl0CSk1SYEuElBHic+2oJsYC
	 9uG0DcEXvmhgNNfsTOaeeYaM42VOe/xQwPKPxf9kMP5fdwzT5KoJiGA7BhmwKcevhm
	 ydrClkokl5rfQ==
From: SJ Park <sj@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] damon: reduce stack usage further
Date: Fri, 25 Sep 2026 12:01:43 -0700
Message-ID: <20260925190143.2553-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260925130254.4022227-1-arnd@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F8E5C000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ffq1oj9t483nxmx4beh4x17r9xo4cm95
X-HE-Tag: 1790362911-932848
X-HE-Meta: U2FsdGVkX1+lsRv3zcWPV7KaQqfofUshTsF9KN2v1HBGEXs9odMMLeYkrdSt99x7Yom33jc3dWNT87Dd49AR3oDAv6t3rskbLxfk4oA+LOKlMc2lDp8seDFVR/nbv/1rgCFwDGQkNz26b1+41qLcT2Qt7AFWvAj1QtT5qx/zhqqsVF9pBJgts7ehSwTcH4BJDWJvz032xetB1+OH+EWjG9+zCINR92XuPnjaC/TovT80bNelx0nohnJdLOsMOsP8hCecTpc0LjkaL2bPGN5uWn3nMz3iISwKCs+JAiMzi80l/YxN6rP8zHKltXCHZr3G1Ri8w15cDX8YbPcgY26V5xoNknkgT4GtgXewRDUu93nMDwhEXwKMVpQJyYRgrmNiG44VsaurNdUlhwoaQrY8kduZurM9Hp0TNH4Pfzpq+ZPCeJ0q1iUqWftAOj6lcNaK1B63xyBcWUe8f7VIS6mzRI1pqkgZloibRTDjmhPAtBDsKYwt97WcVSFVjVLv2QCoT7Ip5Ts4Zqx4NUAaov3yaoXK4UN4z6H6KXSCOMmFdtGmo3P0YNpVpRP8J1zABpi+jwY7eMXt8hR0cYWq1dl5pUJdb8C1M/agBQy4jbbndv5PlUvvkKMyREKGoJDOcVgh5r2hZirZwJv4N5OdDty7CQ5Gd1EpM3awQgO4PzLO1KxVMW3Puz6JOwLiyRIVyt65t/Pby9FhTqbDBXVhDju+qvyYesdBr6cgrnsEJtMhx3CaIAXs7mzC2wDaMD4HrVbpFXaNwx9ETwLGrVHz3XgtDbViHETUN/UMTMGxl8lG58iwXfPQFBPhwGQwAHIIcuXP5/V1nsuoRAbgHVV7Of4wTHbuUdpZm8jnDymBm4iYTCrKT29xe0/vMqGZ6MXCaJ2TeQSrf4NXdnv3FTL+tZqzoO4prF4ihVR2b+Eni+mdOx5t92nYTn/CQMx3AYAXnm3PiYqzXA5AfYYJLqXc5Gt
 YwYeLb6m
 pqDAtSktJzrPKhHfEqpFCc3liIhayuvXDxg1necDGH9brq2IHDDovu7wNx69oK339DJ+KgWf0L8qHCsIdRSnqrcgWNb9kRCuVlRlk3KiNaZFsAlNfzhya4IG9bpWAIg3VEJAdSn1cPUpmVl8u3gYknk4g7Q3JiW9l5WBZCXt5SCZLl6hakIqxQ6efkFj/qpenGolJFoQrT/7JNOzKISbTAa/t7Viw6XqISbWzwOIvKFTbSN0fjISxINAoD90DmyV+ufbXUetWqY9Qp6rB9yfWkR39TfgweRXqWslfx+LCCd8CGYybnbiPWzaA1RoWB8lL4ueqvo/ztPNVIAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 15:02:46 +0200 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> In a previous patch, I had annotated kdamond_tune_intervals() as
> noinline_for_stack in order to not exceed the stack frame warning
> limit. Unfortunately, my current linux-next randconfig builds show
> a similar problem again with clang-21:
> 
> mm/damon/core.c:3953:12: error: stack frame size (1288) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
>  3953 | static int kdamond_fn(void *data)
> 
> Do the same thing with kdamond_apply_schemes(), kdamond_merge_regions(),
> and kdamond_split_regions(), which also have individually large stacks.
> This should work to keep the deepest total stack depth down much more
> as well as avoid the warning.
> 
> I also tried to reduce the complexity of kdamond_fn() itself by splitting
> out the while() loop into a separate function. While this arguably led
> to slightly more readable code, it had no effect on the total stack
> usage and just made the new function the largest stack user and had
> a nonzero risk of me getting the conversion wrong.

Looks good to me.  Thank you Arnd!

> 
> Fixes: 5a00cae64de1 ("mm/damon/core: reduce kernel stack usage")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

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

