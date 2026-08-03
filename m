Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A820C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203C96B008A; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DAD66B0093; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C206B009B; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40D26B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:46:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 548531406B3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:57 +0000 (UTC)
X-FDA: 85060084074.14.C445869
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D81BD80004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3gHHJ5k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=co/3NtBMT+/PSQBj9iUTUY4KxUG/Ig2umyiYC8Q4zFc=;
	b=rhtr5ynyIE1fudN/xzZLa57d4NrK34ZQ5PbP4C88wjxtbW2PCP6fVaDwF7dzJqZcFTyX2X
	3WLbn9Eo72CISMdIp356c3DkN0JjR772w1qYl7epkloUXvk+5kM769S5R45HU/IIW2zHKb
	IX6+U3XHtVXoqNpPgMD/Z1bmlLDFiqw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l3gHHJ5k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764815;
	b=ZbUbmcuWdECb1GpnWBMjPif6Fu7wckzh5jkMf6muSfm+TpCwoTnur5XMjVxdb5uCvcT68L
	FvEiQ+kdKvwkvsJEnmycIzdrSB+f+1GmiZ+qodIJvZqbiLlbhoWGZs1aYFSuYBIJj+VGpj
	944R02F5L/ATjvF0IJP0+ejpyGu2Vtg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7C4E60A78;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263691F00A3A;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764814;
	bh=co/3NtBMT+/PSQBj9iUTUY4KxUG/Ig2umyiYC8Q4zFc=;
	h=From:To:Cc:Subject:Date;
	b=l3gHHJ5klugoL+0hNmdK4DzQSOkan+yAC9Nal74GzYW31jeLXXi4X1kxjUsloEG8l
	 SQV/uUVas9PpeKXumZD+LIH8wsmrQ+w5m7bVeWjx6s1ZIUrC166lTy6+UNENIpIqFs
	 CdhRw0s+yt1QdDIGmy9R9BvUHFiKKwEPuGUljJIjA/GCmS87UnIHCnwiaP5TLNNyEC
	 XYO3FKA5eanu4mwiXUm9/DynpZX/mmu1Djg2ytvh+FQSwAp2J+/Wp8C9z6s3ndKf8x
	 Te4TJH+fF4NIPaqVg3iNBncEIs3c+CxbDWEqRWPAn3ovLMA2lNnnJGXkLSOt1CnnyY
	 2+ENQnbqP/o2A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/{reclaim,lru_sort}: fix commit_inputs infinite hang
Date: Mon,  3 Aug 2026 06:46:43 -0700
Message-ID: <20260803134646.16640-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D81BD80004
X-Stat-Signature: fjeeruwues7iy4dimegpenabensxgd5n
X-HE-Tag: 1785764815-522923
X-HE-Meta: U2FsdGVkX1+VKUvmsSzo9nPp2S/hshKEZYZN+14j+iqHgoyGHWc6vneHnX2g/QCE3PNnZ7AjtMH+8M5BsC8f45tRbpQY8wUQhzy9kXbEqJKKpSEgbiF3Y1Wfwziq9gyIt4Tjnabrz+wWFdkiU2rPPcqzXeTYOHtlh2/WK0VLQoGfUPtn2Qf165sft3MXSdlG53RaweGqFPbEiA0apEeg/tgTS/pOZL+X2QGiL/c0NgIS6DIkCfa9r8TM5vED/iY9fxAI+JyaZDOGTrs2Qc+JlbXPxeEwzauQffef896kLePD59GsEyGakyC/DPRjh/Ci1IwH29+73UjeT6Bzty81JiOYP07FeBV5/VAPvvT6kdMG3RVzxhBi9fOLRihuB6Si7SV5ceDRBTsDfAbtgLGNrChu04Gu5+xSvlHOcvvgEd7SHZiPIoQsQBXlrdCSQ8uZqkt3Y/lZtJuEOwlCcFCZ8FS9E+DNRqEX9/6vsrgVL31MxnKa8FMcsXrZS7kQ7aL+ouegQTuiAQQWwAUEP4uQ8xP2qvyeldyz9wbLxOw7gApfpJlwIOFar0iMdldItvdUq+8wY+KId/aGG2xK5hBIgXLu94/avlZXk6zJ6dgpMZcpGX1uhyKCQ5l3XcEzHSgCENO/e8Gi+IIGZeOK2wjowm6YcpVUdnhYRYpZ6mIsUaH+bp0jnl0rnjnVux8M4umG2pg6STnxsvZ7rNZjLXcx8N1/xJmzqs/2+R3T6vN0mbi3Ie0/6e+YqN+FXz02QYjhTkDdzEcJ2B4L82yIPND+NJ3aMcAvrzQv5mqTtkipP/BeZypYLz8pmXqcAnwg7dQXo4ewSALiE9jsRXTgcvt1ZgFLd4nC9hpUznOYUDLC56TlEmdq42l852TXduL1Shkl2LegkXlm366FklEsDu8LP/6yOy1IEf2QcSt6J2ww+eIicSPgv+FGhm/M1VExybbqwDC0YEMQVVe6NMOz1+P
 IUINdGRY
 LYuNp+KjuNeRa6Q/gTYwkvG/Rmq7D7lPhdk5qkL124eLordlnwGURlHSR42jdGlcSV635HLltOer3Z1DeIgCzBXaDKQr7nchXvA7hQUwXHZws4f9KJhbJ64WrrU8m4/iCH2gmYKxD3WWPfPadxhQ+AtidPGIZf/afmyGuJTh7wZlkkNIpbeNbvYkWFUaJbc8Av1ppqmFjDzTxdanODfjY5BanqBjU8Muv/SL7iiqkFIRBp5a7Df+a+UGJApIJOllDu8pUS8jpun2SFZrIlzyp9qUXyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Writing 'Y' to commit_inputs parameters of DAMON_RECLAIM and
DAMON_LRU_SORT before the modules were ever turned on causes infinite
hang.  Fix those.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260802173021.762-1-sj@kernel.org

Changes from RFC
- RFC: https://lore.kernel.org/20260802185430.9940-1-sj@kernel.org
- Drop RFC tag.

SJ Park (2):
  mm/damon/reclaim: skip damon_call() if ctx has not started
  mm/damon/lru_sort: skip damon_call() if ctx has not started

 mm/damon/lru_sort.c | 11 ++++++-----
 mm/damon/reclaim.c  | 11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)


base-commit: a96a4f995fbc65238bcbe94e05bcdbec29a54571
-- 
2.47.3

