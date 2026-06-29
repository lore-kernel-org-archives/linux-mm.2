Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F29C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490206B011B; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2766B011E; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293976B0120; Mon, 29 Jun 2026 10:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBF3A6B011B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56817A015F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:48 +0000 (UTC)
X-FDA: 84933249576.01.513DF31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B467A40004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDXoE4r+;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744946;
	b=pycZM5Ou0mHv6wuV2N1RI/aSmgwxZlx8B/YvQFBFdOsn07ZHFyRZUOjCADyShu4SefHnM9
	C3dtcXy2o4vpZF88kqnnA+PDBtu4GdH6ILVkdAxP7XXbqtMMcQNiQh3LmGMNGxT8m/WApe
	zpQ1kQP8SvhDB84U38zsywtwUAWLL6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmG2gg8tRrgzpTnWK4727CnmxNa5ZlUXqEpxl0pzTvM=;
	b=7UoaWD3N+CZC4jM+EdR9+/Syb/thPMOr5y8M/vIRmH2zPDeflTDnDsZq5BoH35zAWfZUV8
	c7w1f0bI6C9YeYDXY2IIjBsOAytqeS9Fzgk09s2djNLd3V+xo0Gfhmd4k1u32dpKuUzhk3
	YZXAiVEEEIagP8fqJuR1GkBNyUxCGdc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VDXoE4r+;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E29943EF6;
	Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72971F000E9;
	Mon, 29 Jun 2026 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744945;
	bh=PmG2gg8tRrgzpTnWK4727CnmxNa5ZlUXqEpxl0pzTvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDXoE4r+74Y296coPt1frx1kzyLDNql3DFMMOIzlslvyJFTNPeKJqSeOd1BDGHscn
	 7JxWBT1rCvA81uHJy/isaEosOp2DZGHkNoGD4HLn7ogayUzWJ5zwg2x+07rkEtpRaw
	 8blA/qmadJwueO/Rdnjs8v3bGmYMlO82Dn90EOYVDAnWNUqA7/YKH+U7s7tGYpzed7
	 rK9ch9+t8IbKto8G+dMJ5sXLTueItloeyuqj7aP5RcAJ2Vuymeig0gwzKEAAuMmUhe
	 qAqTSwke8+1IpOiHyxeO9XEfWO97aI6ag7574rgyB0OFWqfTHWItsgEeJuobPoeZ/w
	 pKCprFZAKr7IA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] samples/damon: Fix typos in Kconfig help text
Date: Mon, 29 Jun 2026 07:55:35 -0700
Message-ID: <20260629145538.134832-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-1-sj@kernel.org>
References: <20260629145538.134832-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ow61tiazq15i3tmyzw4q5j1xiyd64cr5
X-Rspamd-Queue-Id: B467A40004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782744946-867441
X-HE-Meta: U2FsdGVkX19b2BsHPUcw1/dKpDYyLcLVpK4rk2whvjpzFUie+zbfcIHp9j30sroqONIh6Pf/H8DMNOGLuKX0a/J0cVJW/XTYynJgRA0SCJnA6LkFX6OKPxyEiozSPgYUVdjHtH2XBY1xv6C+4TrzrMI8Xbt40fMkjxXQTO//TLX7YFRbOiLjoA7jLOcx4JExVO/wlffTyU0JQTwbWUefQeaM4NAPZaHuzHd1eWWoAbJIwzgfEh3Ag9ujIJnw6N3JCDW1mBfxjz/7vc4gg/dCezFjwfKH10FV+ICayFhfiGk3XdI5lTyP9uMu3jF1m6I/jrbkyZpPIbLNroBHdIEjLHEV8wvbXj7aag8JCkGka/YEQsX8alrr0jBJgO+Tr46RwfH6BZ71aOtmBJWv64++ZbnSqSlIOuZoiaCUzkenD6WONSFd/SGj3VuSFzWtSbmHEmoC7YKXIzj5dbcgyz4A7ArpRQOGax3LI3zz8s0EMrDoJNTyJvj2UwwQYRgWNNKXdkyN6q5qJ/x5H+YxqUsUHHdKA6dHTdUQcrUHSqBcKIqYRR/ln2H0eSLhymE+jsFZt3NgZ4gP4bXm7k3H+ze/y+fVoLywnMWOs+N6WH9CSQxAPjcQDJdOipDv2z+bfZDv1ZPuKJEdLx7Bwl02kBaPYzoUnvhsg49ARqhP2EBfg/5+uebZllVrna3J+2zgW4wdHjAYnfEZJDQ6q5BdCopEWUkW+ADP8x/oQWaYY82Ay0PwoNcHCr+oYDtO4z0CU5tPBeuYYj/q1pCAYbHMA0WEuixcZDi9ELiJnp5Uz3+/aA0OaY1wem1iftpgaWEFACri61HmIqkgd3NbSYbX8wVDrRn0g12FnbdagSfMCHSwtZbly+Yn3lRlCXkcBVGaKvvXyC+LKcVcI4CWF4zP6ed2BFXd3vGXI2YetpE+56lEEf4RX114suqPRuvFxlH3gmJpdJ/mCPTlrV1JLBNNaZm
 XH01mtoW
 uFa46SgGEYf3dq2Dl1Hch7pdxa9jwptFVLhlidJ81cikhxQAA42T66RqklSwgljaEoitapHwcdcM5WY+lAwvARi5T950hRzLGGlZBXQ2PXkSo3CeSapGZ2Ybf7f6YR1mGMZXCXzWYEcbN9kC4Sxpat86VPaXKVl4Z2AvKyZ4EJdFILEdCVIYljwZMVt6AaQa77jtMGeAwRqnIW4URjOJKOrRhnOZdoA0GPOmkR/1F1cv0dNAfo5w0d6+rtxcYIiNRH1Blb8l4VAkP1zUXyfe7AgmoUDCGBUcFHamV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Fix a couple  of typos in samples/damon/Kconfig help text. Change "Thps"
to "This", and "tierign" to "tiering".

Changes from v1
- v1: https://lore.kernel.org/20260617065716.750179-1-gutierrez.asier@huawei-partners.com
- Fix one more type: s/tierign/tiering/
- Add R-b: from SJ.
- Rebase to latest mm-new.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/damon/Kconfig b/samples/damon/Kconfig
index cbf96fd8a8bf9..00be3e6bdd659 100644
--- a/samples/damon/Kconfig
+++ b/samples/damon/Kconfig
@@ -31,7 +31,7 @@ config SAMPLE_DAMON_MTIER
 	bool "DAMON sample module for memory tiering"
 	depends on DAMON && DAMON_PADDR
 	help
-	  Thps builds DAMON sample module for memory tierign.
+	  This builds DAMON sample module for memory tiering.
 
 	  The module assumes the system is constructed with two NUMA nodes,
 	  which seems as local and remote nodes to all CPUs.  For example,
-- 
2.47.3

