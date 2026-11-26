Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07A5606A686
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 22:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fQso9WKs
Received: by kanga.kvack.org (Postfix)
	id 9DAB86B05B0; Thu, 26 Nov 2026 17:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964846B05B1; Thu, 26 Nov 2026 17:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C406B05B2; Thu, 26 Nov 2026 17:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1104F6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:39:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 924A1120126
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:39:29 +0000 (UTC)
X-FDA: 85478738058.19.3F16386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1052100002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:39:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQso9WKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795732768;
	b=Q3WWLgC2mgOC+8cxmAgjkkKHEGgTn2PReJuoT/HbERKhAWIe9hFrqGDfrndONweVWw26rT
	TNuxo77WodIZgYNgdHHb+fvY1rxs7XfI9IXlDoR1WLZjBaXSVRIwXTsSQuu7YlesGm0VOB
	ZHcNEx/4n0DA/7NqnF0GlJZ+ODumZv4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795732768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLVLk6tx9szQj4RRuuOODEHNywl+w3WIa0JhuMX+CyM=;
	b=qcZ0M/KlWmCwv08HwkmRp4syXnz8EMv4Up2HlCbp/+0R0kSdsr1r6tXRE0BKlaY4hgSYJ7
	eM11EIhHX+CKYUfUQPXyKOiXwZ0gwUZDQoxDf9RBbF3eG2i48D/N+8bFde8RoVj0kTdMId
	0MhN573xn6EVp1OD/QHox2BaJ++GwQo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fQso9WKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 307A460A4D;
	Thu, 26 Nov 2026 22:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C581F00919;
	Thu, 26 Nov 2026 22:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795732766;
	bh=XLVLk6tx9szQj4RRuuOODEHNywl+w3WIa0JhuMX+CyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQso9WKsFUOitjfiBczWc7E2vu7kya1POvG2vyenxG+FvBJQhqOz117aHPsMaSU1s
	 ETZ4lxC/KRqGHDJtjqO5xaCT6s5WdFu9eIfb3klcwiMGDYmu82ul4OpmVoLDy1W5Tw
	 camdKe6A6fggExcu0lM232x9+wYszRuT1To1kY6pqSNhwEr8+PkHCFViD/g1N0hnHg
	 F25tPkIzyZgH5jbemwJViHqMwpcM9qLEhvZDQ0gVh7npgHnBMRiOEODhuVr0d9zJ6k
	 Xz7o40Hb7S8of/8Yp7irOBxWSnno2CBc6HIzNhzexqEwvp0nNpezDrj3Af09JsgkGz
	 HC0cZkuGpi6fw==
From: Sasha Levin <sashal@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	stable@vger.kernel.org,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y v2 0/2] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Thu, 26 Nov 2026 17:39:17 -0500
Message-ID: <20261126223918.1165617-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5b47ee1e-0b0c-4b0c-9db9-43c9fbaaec96@kernel.org>
References: <20261113110259.2901456-1-dipiets@amazon.it> <20261116111734.3798483-1-dipiets@amazon.it> <5b47ee1e-0b0c-4b0c-9db9-43c9fbaaec96@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r71kxqyj78yaf14rke6pkypnixdtzdtx
X-Rspamd-Queue-Id: F1052100002
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795732767-467581
X-HE-Meta: U2FsdGVkX186xCU+tKWIcspbL/WzQ/qXNZChDN/tXVkRl1LLnsZj0lly1onRSX5p52hvw3fKhA+tDo0LZ9jYtGflcbfvsuhdWuXxaRE1vL+8eVwtrpJiSMACtnfdtnNWL9ibbFXxP8K52oBA+WQa3u1/QdKL+TmvTqBs27xWZXNjK5KdVKslF8uXRhc/Vm722McJNq2WTkDLJGStersOxXECWr4t46nL0bqCQW5lNoGY3kKW5kj2R9IleW1kJBLzftse+0cNQs6Nzi1fxSGoMckRf7jL8wojhwE73NYlU6m0fVbzhtshUeD/BoYJ/ZyKdcrarLO1nRK/iOp/rL4kEUkvbAL/PANnD01adlQkAADWlVyTv/wE678mQClGD/4X4ltY1yEdh9wiTO34mEAWgr4CP4uH+iIi0BVj4DF5PdlWE7DZQW48BuV8f4jLkxd8MbXKn0uGZ4HcJQFuUrpOLqPuErIF/FtLq+SVfnhlKSigHVLliWjzRX1ACO+6ex7EPye+oTxBX1KJQQ1kdfz+ndmQfqb7BKKkj5AyBNGJhCwneTadl7uVr5h61Bu8jUWQN4tk457rQv9oaA379MzLky9CG+iHt+BxJxUC11b0RqGz0/X5a4AsGh5NMA1jr0qx40AqGCbwAmHb3OlulxVfgWskKh6zKcj76M9Py0iajieyFjF0GsFRz63gbwCtDfRjUd0LM/z9fXuwOtrZQNVhTDyTPLNMq2YkC202YeAcG+AXDLaV/J4oT9E3/teEnqxbWxQxs8117GP8Wu/mY+PR+JNayZwfCcVBNxHD50AxxvnEos4RNHe5ukZa4tJNJka5lyIvrADFF0X7njwSFB1iYPK8rrM563LhffOCyYWEzNG9+PyI9wltAEl4AF6/9TGKGGzfwdNZnRhOnCJj8xSJERP/cGmIWjPdZVlxJAriN/4lem/sv6Sz3cQhzzyw54CocSU8YMAxk8m1gkXPjVx
 +7PvlQn2
 FhJGyb0Nt0Nfm8CqNusVTux4a+xTzW7JNYBS2q5nJy3R48Cj6U+TAUFO3P5/1kM+OGHwrOsAkEgkV726v15NJoyUguEEWDWX7Mzoe5fFe144k1ljUaLY5vvGLoO5R0WEdscVVpaIzD/hFrUHFRbVuur9IOaI21vvEuW702nIk91vZByvv27lqa7CFPPaUnhStTrWc4XYNuSXkhdwFl8VD4PObNJftjdw+GmlU4YavMINGkfZLIsJtloLpsHoRq/8XDB/eZ1F+u9ejpd+wrlla8doGJoPmQJ4svMZR+eIK9x9FjUhe2kOdsd0r9Ua7bdthiboWOq+e03SVSIQd6qYlKyS+6eTqhGA2KqTn8eSQIXe2tYQLf0zB7ewUKz8aTw44Q+/3AplUQbdbSlNpy4IGGt1TcMl/e3M+Z9GXppQkmR/A751eyI7ZtQrVSyaXAQZ7Dhz1Cz68nQtH60a3RW1c67ScmEvOfjNulP1PzhJNyN6uz55t9yQKqMmMpjKWbUd6DfdwgQwH1TLmC44GsTLeSnCdzImKVQ4VSNF1lP0WS29xusQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 10:51:16AM +0100, Vlastimil Babka (SUSE) wrote:
> without also b480cbb071020bd590a0dc0166635b448e9fc46b and especially
> 9f2fd03c9bde366c928c9242fc9b2e2c5111a134. We didn't initially thought those
> worth backporting, but now they should, otherwise we have a weird
> combination of behavior for highatomic pageblocks in the stable kernels.
> Sasha can you see if those apply easily wherever 6ee3d87b9408 went, or need
> help? Thanks.

7.3 already has both b480cbb07102 ("mm/page_alloc: don't increase
highatomic reserve after pcp alloc") and 9f2fd03c9bde ("mm/page_alloc:
use existing highatomic reserves on the buddy fastpath") from mainline.

6.18 and 6.12: both apply with context changes only (on 6.18 the
gfp_to_alloc_flags() context differs for 9f2fd03c9bde, on 6.12
cond_accept_memory() still takes two arguments next to the
b480cbb07102 hunk). I'll queue them for those two trees.

6.6 and 6.1: b480cbb07102 doesn't apply. __rmqueue_pcplist() has no
nr_pcp_alloc() there, and reserve_highatomic_pageblock() takes
(page, zone) on 6.6 and (page, zone, order) on 6.1. These need real
backports.

5.15: rmqueue() does "page = rmqueue_pcplist(...); goto out;" with no
fallback to the buddy allocator, so b480cbb07102's "return NULL" for
ALLOC_HIGHATOMIC would fail the allocation instead of sending it to
the reserve. That one needs a rework.

5.10 doesn't have 6ee3d87b9408 and needs nothing.

fe21f930d1e6 and 0e05a469c294 stay queued as they are. Backports for
6.6, 6.1 and 5.15 would be welcome.

-- 
Thanks,
Sasha

