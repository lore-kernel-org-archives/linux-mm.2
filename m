Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF3AC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 22:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2086B0092; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA586B0095; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D87D6B0098; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 687D76B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C41B16023D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:22 +0000 (UTC)
X-FDA: 85213817724.01.E38564B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A5ABD40008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJIMboED;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789425140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KOcA2tcYSGnDhJMYp2xxbrOyIjGECs9CmcVH5IitgEo=;
	b=Sbdpro6yRAuDnuSnfyVx2aXJpC9+gTQkKXTxPmJ7+IO9FMdBKi2eYcc+Q6/xQxt62fbJUQ
	xFp/D4JA68l5wCIT81Q++bL4cKOy6c9iX3Try12EsiStql5DgdOG0IAABHOJbPfDAgaKVe
	VEWoxw7kbe8jp6Co1xOt+2EHKH4GNMQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789425140;
	b=Rw814fOH/BEXCJFqr/4pj0WL39SDcn9vUGU61K8qOfqqJU/oCODuvFDM5n4JX/8BYXGYBl
	u35NFx1V1WeweAA82AN4Y9u8YiVRgbAmwiScUlkVYCLojQg4D1dwCmnvjoxJxCaEG8vA08
	Yoz/DwC5E6lKgvFnOQhiY7oCjDANUcg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OJIMboED;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88F634198B;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E431F000FF;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789425139;
	bh=KOcA2tcYSGnDhJMYp2xxbrOyIjGECs9CmcVH5IitgEo=;
	h=From:To:Cc:Subject:Date;
	b=OJIMboEDjb8wnTlLoFItfkx9VEnB0HBrVsFvYs3nT8IACR02rgiIdWIveIDXmegG4
	 Chqh8XXbMdMvL5eCfPkx+BCq5z4D2IBAMaTdlpPonu9LpZXccjQr+We+OiqngkUpcI
	 XqB0kE9fOtGzNYf6bQzn8T+89DxYlyVFop5M7VnXsfLlFVLe3qrg2eYIxt3Xqyr58c
	 giZrQj9iv681jMvXA7+dIo37n8iMdZ6Ecsbrc2iKHeM239kd6n986RjPQrHQZdwfnx
	 a51gDM6jAo8CJHlgm77ZSr5CEzN8jyD25hif1eZNNNogp77S6KKNpAI5YBRGxOfH7a
	 r8kEGVEHlxHew==
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH 0/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
Date: Mon, 14 Sep 2026 15:32:15 -0700
Message-Id: <20260914223212.i.829-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045; i=kees@kernel.org; h=from:subject:message-id; bh=qijXd2QkQ3HWA4BpjJ7QTWYCf8fopTwhtZmjFOO2pcA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkrSj9wCz48ajQtkP/S1t6wJyfZ/gcdS+kXu7WqOFh74 hR+s56/HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABPZ95aRYeML871r0hIWhL+v dNUwyWdVdtrvwhIRv67h6JYo7qfntjP80z1+w8/u4f9kCftJy48Z/ft5KX2u8vLk96eSeeaI/gh L5QcA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: pzfq1fr4uuw5m3gmy5tdokpuw89femin
X-Rspamd-Queue-Id: A5ABD40008
X-HE-Tag: 1789425140-441594
X-HE-Meta: U2FsdGVkX18Y6WTA5B22vxgjS7WS5h870ef8T/tHSunkHsb7W2+NQC5FI5idM78yXZiBjfflI2jLNT8t3N9Vlj0BZEgkuVMd7MreFYAFbj/2HmshqcF8Sw2QJ2zQir1CwiVfPNopIHA8Xc4XBGC/oGG9YlkXEXDAl3wRWraZRB4inCuh8iDgP3z8TW/R7zAs3ekPrgH4drsrrDtAkp9PwtCT7WzBhjdDXaEJIAurJnsrBdn0ZBQvSwpE4bpi73Hi2BeHsnA7EGRUJkQaSWGotDrlZuCPTnmBmcL2eVl3bC8FoSKhZSyOjiUp1vtTdjGXnK0tqlhe4Quh5P/lcoIWCtfpxCHAvwxUB69nygs8sVbF3Kfyl1kBb0hcR8gzLO89pF1rucnbPrc80qQwCAjIQL2AJ5lQfQdOkTGzkFt0CE83CAemJS0NbnZlG4oAcnCzdB9keJTkU33cy0Hs8BoK4j2pRNsRzKRK9tS8OoHd1Q4Px/wSWut/sttKaleMQadj+BtiOUNGcLwLsXgd8PiGFcaguxG0gUUFwzgMwH07E4F3ePvXKiC27ZpSkacrg1Fpbvl0lgk/C2Or6wVp+bvH9ieKWKLWtBHY1TlCZ1Kkrb1lXrFf/C2W0E3AOMJd6+DeG8rQaCwDDO3tIDy8nhhHXlvbHCSIfCDpWudqSNMuI82nfoNj25im3diqNEQXW1qO0BQglpj/2MSnS5LRGeEeWkL36rx1wNoTTlLiM7S6sN2JEnR9UqnMw/RQqDL+4Mx8iTyksb+7Hb4oOQsH1adgMojfPKLheyFEcowp5EOCBp59KQMTKLfwJs2EHEby8sc5loWlBOiTwOmocO9+q2SdD6ZW/ffR9/eghDo9mww26fzmRJm49VJgw+tlYIvc+gA+vhP0CM4th1xNsQy1nmyV3SjJDqv6utuzxucBacrz8V3wFWALe+IUEarT15ayBluB/Tl4ymCafjCBUiWngJj
 IGuNcwUa
 +BclHm4kDEM3rzVsL/7nZ2SXiaNOLRriH6Rg32MxvMWvZcBDyYfdwPW1H9HrmleGKRd9EvL/KJrgT2J+4aT7LH+CwWWN6wADj2z6q3Bg2nMX6lDsQJEcvQPEfhWy20X2eTLfwRF+SCjv/oE9ils0+9NlLh/d8Zfcy69QrNNiZECA2Jil55DcHN2WWJMK5FnfwzpQdBdV/0tFwHX5U9qDCiTCqGL0r0fBQdMbZyC8DRkUum1ID3lnow/FfPygvTBq7z5Cf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

As a continuation of the type-based allocator work, this introduces the
wrappers for devm_kmalloc()-family to use the _obj/_objs/_flex API that
the kmalloc()-family has moved to. Along with the coming changes to
scripts/coccinelle/api/kmalloc_objs.cocci to support devm_kmalloc()
conversions, this will result in the following uses:

            6644    devm_kzalloc_obj()
            1714    devm_kzalloc_objs()
             296    devm_kzalloc_flex()
              89    devm_kmalloc_objs()
              83    devm_kmalloc_obj()
               2    devm_kmalloc_flex()

which totals out in diffstat to:

 5908 files changed, 10013 insertions(+), 12082 deletions(-)

-Kees

Kees Cook (2):
  mm: Move default_gfp() into gfp_types.h
  devres: Provide kmalloc_obj*-style API for devm_kmalloc

 include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
 include/linux/gfp.h           |   4 --
 include/linux/gfp_types.h     |   4 ++
 3 files changed, 106 insertions(+), 4 deletions(-)

-- 
2.34.1


