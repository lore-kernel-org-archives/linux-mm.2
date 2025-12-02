Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA53D116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 01:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97E06B002D; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25A66B0031; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECB86B002F; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2326B002E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:32:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C4D413ACE6
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:18 +0000 (UTC)
X-FDA: 84172805556.09.85B164E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 04DBBC0009
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 01:32:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fm4uEjS2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764639137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kz+PDRrOLbvncsu2HtZG2sODnHbczkORDvE4BiuxYgY=;
	b=HV/rwz0K9tyTZVNWgZ8oKqQ7thOkKNfPfPR1Yj62IvIQSSMKBk0aA5SBBH4x+Oo3wAR6Rp
	BfoaLW32l59uQilvXGTx1foYBsN9K3UNPORmJAT6Pv8EEERvW+UHDJTjCu7VBXds+u1oSz
	/tnpTDkAixHlQD+hluRhMS7Wcx7WpJY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fm4uEjS2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764639137; a=rsa-sha256;
	cv=none;
	b=Ywi2E25+iOmBq5yMyZWA3/78Mr2dxOieNQrKnFFFkG6bUHMVrDF6Sa/RLRwo3oM1Z4AwZg
	55fmzmoSH8LNK0O+8AzPqRjepWdcZXcpoyeLLrJ+0KAMh2wGEoi04r1nqBkBEwvyL+pn68
	N6w4+I72FbO+riLmLcA9SnG9eP3wvKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2544060140;
	Tue,  2 Dec 2025 01:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD3FC4CEF1;
	Tue,  2 Dec 2025 01:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764639135;
	bh=Mc2opyTryZLDKEEpjyKDvLiL+kNz0NWn/iSTPRRI+m0=;
	h=From:To:Cc:Subject:Date:From;
	b=Fm4uEjS2CKU4OvJc9S5bTn9rCfeW04ZJuO3UO1Es3IXjfyqpNR8u7Bk6Xe/wJBNIM
	 26pMFuiOjRefGf/s7MZd4z817Rmhf3OImKaXSZQjLBS70Tlw9qZSd9NqexdAQw1jLF
	 YWv5hzsGY0t0BABlofjahcsJL7AUcG5W1ik9ic+ksgvuZBE0CIuEqvvRVZfJS5e3rF
	 cPWGKPXdYAVicr6bX8DOzEFgmAd+KxlMO6OFJYoT5mpBQzxP8yH10zZ+sfCSBbTGHX
	 5tWTti7fdFq5DPSOWnpQ8VYaaQNS8PbXDmnDMqzGU7v2RyK2amEbeSLZSyvDTv3wpb
	 OCY4V9hl09NUw==
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 0/3 v2] improve fadvise(POSIX_FADV_WILLNEED) with large folio
Date: Tue,  2 Dec 2025 01:30:10 +0000
Message-ID: <20251202013212.964298-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 04DBBC0009
X-Rspamd-Server: rspam11
X-Stat-Signature: if1crk7aiqcu968n9gw8eofp8enmik4h
X-HE-Tag: 1764639136-583428
X-HE-Meta: U2FsdGVkX19BKOWL3rYE009jotL6OkotZYLC5eOVaJQaVkas1TZqOJTbwOPbfmjcTPkCNAAuN1GRjqspVWF/LZZHgkY/t8kvoB0cpvWS9x3MF98z7pWaFu5+tQMBd409SW5f7lcx2ETxRhaCstj1LYGBgtv9O+WbLZJs4oxGpGTyXfGJxRja9/m5KNBaRIXSzmpxRZV0QFfY6Xa7cVMzX/a1Xc7JH0wQPpZDNXjv74Vpx4bymM9yuXssc+XAFM+xTE4mQfiku76yod9liY92PAHwvZ8/y9A6aL21A61H6yJUxlaBWhWThHlLxS4lLU0udxSVP2ELIS1AR2+WVLjwMBGQT29jgyHCuxJsZKj9wAWgFlSiSLJOZAyq7W/p3fNGvFDWpLh4ZsOaSvgIKNalrCxJzq4xD5pbh+ItGxulSqjc/0IBg9LO4jpy/T+39VDfLOTtRcB86oFRJYRcbLVY1ILhu2Q5MNOeSA9D2ZsCzK2hgENHu94RUUcGm6NXrY7QP0QlW3/7YrhbB6hk3eclL8VnPTYs5UzGyucAoqE9Yvw85mxLcaJRIQSyTHjB+JiQqVpnvQ6yKk4kE3lsj89sQscUPpsqV842iXOMm4rS9+ubO0BCScPDQ0vqmJEL7UmMAfjvGFO+vurJjuvZJKZxqSI/zhxHGoi3jxBxoZwptKaPpuuHPqdovM7nXU7hXqNAccoHLQesyYQBCzcepSWOpXhmu1zSprl6n6Bx+kCDdP8E7Um2ZdbeBwbzuxsKZ/Eq/zIYzbDEP01DxeTObtVz6gwLpv/+1jgvDGsB3BH7thoof0qo4nEZNbWup8YerJJeMUSeV1Y6V5fmjBWjtkDuTa5JTksx8sCdF9tUZLw+m7woByIXoqB/v0rKzet1FVGzEQ3dRPOlwRsZ3DPqO8INSKVHGGo1eb4b0WcaMZ29QtRnA+XHdc3JjViZ3CB1RKwvpRyz7JASI2uNrSiV2h4
 eIOHgFGX
 aSqlTGf2E7LqGV7fZF5fJ5aijQsd/2UjzuS1tfhdDB8b8qsawo4OpWONfp549Rllub3f/NIQGXBekmLqJ9VayAaysO79Cd3wVHzyky1shCRWshOJ74fcbeILRj8qZ43HUFc990by75ZL80tao3YJHGDjAehOFOHBu+BCbRFvcNv6w+YMgs9xpJtoyccd3xmNG/BeWvLTZ/sS0+VUgQqVYd1kbocmDqeEVqELJZBMt+S+ylxrcwUOFapgKZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series aims to improve fadvise(POSIX_FADV_WILLNEED). The first patch
fixes the broken logic which was not reading the entire range ahead, and second
patch converts the readahead function to adopt large folio, and the thrid one
bumps up the folio order for high-order page allocation accordingly.

Jaegeuk Kim (3):
  mm/readahead: fix the broken readahead for POSIX_FADV_WILLNEED
  mm/readahead: use page_cache_sync_ra for FADVISE_FAV_WILLNEED
  mm/readahead: try to allocate high order pages for
    FADVISE_FAV_WILLNEED

 mm/readahead.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

-- 
2.52.0.107.ga0afd4fd5b-goog


