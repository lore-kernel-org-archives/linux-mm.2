Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D9F560A261D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SWTYQg0C
Received: by kanga.kvack.org (Postfix)
	id 9DEAB6B05C4; Fri, 13 Nov 2026 14:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E2C6B05C5; Fri, 13 Nov 2026 14:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E1C6B05C7; Fri, 13 Nov 2026 14:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8436B05C4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:10:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA3AC8014D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:15 +0000 (UTC)
X-FDA: 85431036390.29.AF03256
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 611DFC0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWTYQg0C;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597014;
	b=d29Kh9WbLCANhVmwkRJa2+awaNBe0FjQwRU0S4ADsfNWPCSaYwxRS4wEI7ISsqGq2IdC97
	MB7tlK7XHrqn1bN5vPhZsaJX6W4zHqA6NqK5bUKWyInupAkTJO7bRd2D36mB6RqrJK1fAk
	O9e6hi/0/FJlxBQbwak3JK1exEQuZp0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWTYQg0C;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	b=mSlDpoApxRPyu1uD+DZkUTdtMEAAZUaehhMPNp4Fb5m9XXzZDvbaIfK+KbAKE5WtYf7Ih+
	ZXS18XlhFdXwZtKvncERpyO1bZLtgc6mSASEPh1UZ3yI4UiPaKb5vkkfbmBWq/Je2eKRW1
	JIq/lXeRXSuFCmGa89fmiywacP+x/qU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A31A14646C;
	Fri, 13 Nov 2026 19:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB43B1F000C7;
	Fri, 13 Nov 2026 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597013;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWTYQg0CgR/xis3k3QzKwIhMJEwlNq0p3qBtiA8bOEVMxTYMo+tzuklGFY+7drVAi
	 HfI5oWBuKY1tqR7EPRtqiVf8A+TdLMExZ6rbKIhg4EMBylI0fl0HplfyLPFWS3JRhD
	 EsgFqbMQioG5krlMtyZjak7X0+SMrM6+tCKGeKhf8U5my6BhLc1LtwtAmyJw4YTpGE
	 RVK/8K5E8VGr3VkICY8Q6d/sZxdxrTRyWqcdzP0KTW8fB/i/kay4R6KZlOViJj2CmP
	 9q9nUu+gRpmM7U9RiDj/XDasZXz5/lMi33X4lJRcB0A2xSsdhG25kaCeZKCgAOJsLp
	 0Imh7sydD26RA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [PATCH 6.18.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 14:09:57 -0500
Message-ID: <draft-0007-redipietropagealloc6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113110259.2901456-1-dipiets@amazon.it>
References: <20261113110259.2901456-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 611DFC0006
X-Stat-Signature: 7x6qjf7whpqcmh7i756bb4jo8ny6rbfo
X-Rspam-User: 
X-HE-Tag: 1794597014-444678
X-HE-Meta: U2FsdGVkX1+xFIkO1NvqjwrqPv2EIue87e19nT5FUTeQC8wMCB/K23T3IlKfwBaynJXISIEGjntNAEu1JTfk0lNjSD7mbxgVVigRG/Ryx28HAX4PsET1Su0FsXL0F4ncfHVoCroYE7wh14cK7rK1NUUQZtFMCaTu7Q0hS/BjjeAsi06OzxQkkDcjN3ZH2Ltg+iAqUqHiKB2jBvo+Pklr6hvmQqch2rV2zly17vI2nJD9mbZIunZrWvIuYNxaSqOYXUu1Lnc/WxF7KNOloRlFNXlQZvT977V4++NVbblp7f/qVQ+FbZriqYuo4x+sinOsJ8wJtycAenAsQ4cDumWosUVWoFaSINLWOExbfYbtqrjCABLN72NchNZ9SUrsKi+tGEffgoZgi/lXCyEyi+9vZkJEyibIPNJebj5lUQbMWSJIUFMJtjKoMfqk4peaSlHZvq79UnZ47sxSJWOxQ6Did6O0t5dj17QfkRxP9J34IN+RWGLEL61PtxrziuAAv+4yU2f+bbhlyUZrQfTQVmvBCfX7rGpU+k04Ay95f2g52t8TnRIAeIMJQjuS5okTCBHKpghQmi5DhM40sHVMUVgT+vRgIGUEM8ooP4vvYXDh7DN0N/6UMq0iAs6J1UHt2Sye94RABN8jDtJmaT3F47sfLzQtu5rSzs/QoUf4i92RqlRohRIzASsCy6m7ZoqRYQt4LapmnNEbEYEEaMvlyoE5IQNeA6nLwynOKx8oSitHzE3GmULTSvDgXrtY4xcj/5e7Z8Tf5U0UTi5tKks/1mug4xa9BJme0Ca2OIC719py6uzPKhFMLhXNFPX99sDkqjkNv3nbKOTy537KP3aYRNQeV0FIcoFD7ZPEwVVqycj2VWmwJaJbcpbs/0IvSDoE0lgrTeIVPt4kvXVc9/5oLEQ9TvnyNS4H8UkmCyirNOHsxFmwIviEHK6KTVmreWldI1bdfPFF1jXJfLgzA2znDoO
 q9zxSvtU
 cupVVJEfObvt//PAyRVLwBBAqgiT6rnTGJIWi1FyFj2OrNavvhnz/cL6wan8d23CVBUxWujij8IW58l/AfJ2c068RyYisJSakPycDuNI0F2rETinc9OY2vbBGY+H4s6+qIftwsIpyFEfrMryUvcebBhKvKbc1Kgn2arXoGe1Iu0fZc2fUoZSFPUT4/OHk+GEwxZt8n8+6FVgU5U+hJi8ptIngmFYnWCJJtWjFfJdrL2cff2N6ghKg5299VSYUAretJjpm9U/bCuKOuSjKyLccBHt4lKjHBvZxVoltA1EAjWEwofVlHhJD0Tu8ZOqpsfvdDedSuahjVfbLEa0fQWDS8uFLNqI9Gqhe4W9/2riaDhtXTgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, Salvatore Dipietro wrote:
> Patches 1-2 are its prerequisites from the same mainline merge (Cc:
> stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
> adjusted for this tree, see its changelog.

Patches 1/3 (6ee3d87b9408 ("mm: page_alloc: do not give all non-blocking
requests reserve access")) and 2/3 (fe21f930d1e6 ("mm: page_alloc: remove
ALLOC_NON_BLOCK from ALLOC_RESERVES")) only carry Johannes' and Andrew's
Signed-off-by. Since you are the one sending them, they need your Signed-off-by
as well; only 3/3 has it.

Could you resend the series with your Signed-off-by added to patches 1/3 and
2/3?

-- 
Thanks,
Sasha

