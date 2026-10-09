Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB72FCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AC66B0092; Fri,  9 Oct 2026 09:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894C96B0093; Fri,  9 Oct 2026 09:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A98E6B0095; Fri,  9 Oct 2026 09:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 582E26B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:50:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C85941403BE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:05 +0000 (UTC)
X-FDA: 85303221570.18.BFB56C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 30E2620005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jaOtYbWS;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791553804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H071Su+4anOlMSS+gUVM0N4jNV+NkmKss72WEdIivlQ=;
	b=Dhh4Vy9RKQMKqR7j/kW5eiTy+I8UQSYilRiXcPZ8uEL91I0NWGgYVFvH3chP45G0pHqY46
	C7dVyDQGBfuQ+6B44cvK+0iU32rBWj+45Ikto9c2vwmu8s50YU8gkNgN7TfM6wDELjlttu
	66i4Yo0Udu+iIp7Rh3bBReVBme8p/aY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791553804;
	b=Wz+P3W5NtFVHSgAd5qdgUcsNqB04SAwSTRW5PrrRJP1nmnErSMjymAU2qpFAD2sT8r2g3l
	y7D82RXhk+y0Fm85j3nMM3s0ziqXXbUxBY6gADnyhT1v7vpHDH6Ec8C110KS5FMs9w3fAm
	7KW7Hmb8JtwPxgVil1ZunAq/GDxQbTg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jaOtYbWS;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 117C240837;
	Fri,  9 Oct 2026 13:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F33C1F000FF;
	Fri,  9 Oct 2026 13:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791553803;
	bh=H071Su+4anOlMSS+gUVM0N4jNV+NkmKss72WEdIivlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaOtYbWSMeWlKVzUtj/mC5JhGw/eRRP8P9KPZ7ycsQyvrSjSKPXPjSB28iY/uOAUf
	 RYAAC5Ao9A2ivu5JD+w8dayx1zgxO3ZY8oaz7hD3DHp7MiR18Cu4k6WQNcpvsrnci1
	 kEpw7YRjqoD52RKePcVL5DnorfevK0IhATdk0sQhMWn1ixlgnvdBpguXKGP5OTtCTG
	 QWh0BrB2T5L/v3HtdgH9PGy4Rd78axftTQNIlk3QCSj3i88YE/NIgE3+U2zE3TOcso
	 TLOmT454SYB0b+9WxhiOOQW+NwyJoTGnv9zdum6CZFx8qdT5lh21Ti2gxPvTBg9CBX
	 HS0FZSbklCKtQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: damon@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y v3 0/2] mm/damon/core: fix last region handling of damos_skip_charged_regions()
Date: Fri,  9 Oct 2026 06:49:47 -0700
Message-ID: <20261009134949.11507-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026092948-moonrise-persecute-3597@gregkh>
References: <2026092948-moonrise-persecute-3597@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30E2620005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ggj94uuhkw14sirh4t6az3wwbjhk5bhe
X-HE-Tag: 1791553804-769135
X-HE-Meta: U2FsdGVkX1+x5/Jt/zywdrS3aDQTPuF1wCMb5rp2NCwGlQUOU/c2poI3gku4Eq1a0a0IRN7EG78+OziC2dLDqGDuMCv6zhy9YLHIvrtgR+BFZqJbw6TaJAIajQqNKexENhV+vV5WSZcvOqOZmPWD3oLhAyflbMqAEaNM1iTNzD5KiOi91sEmrWc21j4rBN8pgq5yzt6s3nMIIbvWlm0DNWOE3rFIRSLbTBqtmrSu8/3V6ftk3WyWiBhS5PXZYIkHrNYdfBuI+/Xu25gbd3TNn+RZ0B2pTjSw/Q7Gp108HxR/8SstHVbpDZ7yXsbGmeC3kOgBDyCI3w4B6BtDfWh7qMdezYMKDnTa6pjd+BaqDJji+e/NghybVwJrHUEvLz/mquVzcKcJW0b7nzEdDR+Ov/NVarmGL1NswCR1SuTUp5uG+GIm6CYipZf3+ZHnf5ylNX/+UthaaBjlTpW6TmbSp/bJFgwnpOVpnJ+dYurBCgXPyA4e+C9TqYCqAoVnQ2G+KVCHOWBoNSsvNYjvehRiQZwsUKZ9fUvox/GDW3frPpn/4L3CTeN02rIksx68hwGpmGnExUV9fHvBw1gsVKlHxLUmw4fb/n0cfxBk0jRcbTA67ZTw9o5KsMYxDjWkAEdJ1vgwBHhv0Cz5WbaWcYTA0l5cCHHWJpSxrkNmiSN1/FsfOrp83TTX9rP/St3wk0jMRV3WF4tC5AQRzn0mqpl9yRXydtxKYYLh9PUz2kuu3Quw9UsG/GOyUm3DhN6gLMxYq2dYtcg/oXwInZrQ2FgK4YziXuuHZFfIIafAEEr2fWEQoVHKnM7r0BLUf1nLhSkP/t21RW73gBUHwD2GpT5c5uYK2mhLlD/tfi9JBUmV2De3QznxS6TIWte6yn2WWNqRatmH3yoboRzFh91wsAr4XDGCXlDBcXSnsFv3Tx8UgNz9PQMwlHZy4+/+zsVegQ3CRemHwfnZS2xe54WVqX3
 nuZ6heBo
 7ApoQL0eWQrUKYDZ8fT3JIkyM0nuB6fG5z1wI66i6l/5XnyKCrNZ8qUrySTFZZOdiBqyKCrsFH56cUIXaeL0FeDTtE/dzk/9OWvgY2YG6J9lc7AZKqkKPOJIELOrI+JHUjZPMMYyACWPjd5XylChxITfm3AcX7p9akUI5yqD4+FHh5LpLUJgP6W07sftEKfryqS52O2/2u+uQ3Oi1HYeLrSfw78Smv4kfsBQ47H9KSPSOJZ0zeA90k8IZh+uMK1ufJ05/6+8AZMxrok6ZxhUYdH7vPdstVMnxSV1zyDEy1EZEy+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 is a dependency of patch 2.  Without it, patch 2 introduces
out-of-bounds memory access bug that was found by Sashiko.  Patch 2
fixes a bug that categorized to be backported to stable@.

Changes from v2
- v2: https://lore.kernel.org/20260930101853.58786-1-sj@kernel.org
- Fix out-of-bounds memory access bug by adding patch 1.
Changes from v1
- v1: https://lore.kernel.org/20260930093707.48739-1-sj@kernel.org
- Add missed damon_sz_region(r) <= min_region_sz case change.

Liew Rui Yan (1):
  mm/damon/core: fix unconditionally skip last region

SeongJae Park (1):
  mm/damon/core: do non-safe region walk on kdamond_apply_schemes()

 mm/damon/core.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)


base-commit: ae7bc7c9b4336d7a8fb4bcfe0a6d8c925bde3ce9
-- 
2.47.3

