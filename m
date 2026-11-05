Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE61606EE9C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVLSEKAh
Received: by kanga.kvack.org (Postfix)
	id 314F66B05B0; Wed,  4 Nov 2026 20:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C65B6B05B1; Wed,  4 Nov 2026 20:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DCF86B05B2; Wed,  4 Nov 2026 20:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F36046B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:02:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C4E1A0905
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:02:07 +0000 (UTC)
X-FDA: 85399263936.21.99DB9F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6062F14000F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:02:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVLSEKAh;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793840526;
	b=0Q6mCac95PnAe3g/FQt980WHhKMyZV9lR3rKL6yVeWuat4cBje1Y4BqPkV/GZkF+EbrBHi
	6h4Z+01OnP8Lvp0QEz72NuIZxYGU8dLjG38f3AVy6+PzmD1khD7Hfb97iT8vmpvC34R5Cy
	vHFmNqJYNOxr8niaS+iAkWA2AbYM9gw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVLSEKAh;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793840526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AdTomW99VvfVgE5W24KzmRdqP4Moe13ZETF0Fbj5rS4=;
	b=5xU87vNhN1KOBsx3G+xMTDAb4s0oj3pqxU4OmEQJdr8XXuHgtRmV5P+MUgErdYTHHO6qd/
	gHu/XgngJVxz7rwzYEDgvLVwc15PBAi0+NTt8swvCuw+qwnIGSeGFnbJkYvqNFNZ10EfKH
	mokwvCe1ujY4+W217T6fF59CCF2iUrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D90CF411CE;
	Thu,  5 Nov 2026 01:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639F21F00919;
	Thu,  5 Nov 2026 01:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793840524;
	bh=AdTomW99VvfVgE5W24KzmRdqP4Moe13ZETF0Fbj5rS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVLSEKAhvrku33NQwqvpc1uvzIv9Ozs8WWw826VC/BFa80lLIcCQ+clssqoDbgDHF
	 YOVjVYcUcsWQsx+1v4R9hQVs268jZbcB+dOu6yvVMfGqaFUloURsGYbgXtFNa5RkEr
	 z32FsIuuUgthsX/hKkTTlpXakgqZPESIyl1XYKlaspyzQQ7Yw1LO/Zoz/Eq4+ne6wY
	 wZZaA46fjXPR/GuEGq+8xNhaInoyIYsZz0pzx2r3C1SBe4X7ckzHYntZnNxkouoYrB
	 JQJlNnAnqRFjtBKhlZT5zLLzcC7S3YxTYDlhmxz2U9wXaybF3lopHXk+OprHFmIC1R
	 An49kSjhTDREQ==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Pereira <danielmaraboo@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] Docs/admin-guide/mm/damon/lru_sort: fix grammar and style
Date: Wed,  4 Nov 2026 17:01:57 -0800
Message-ID: <20261105010157.87652-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104202959.128646-2-manuelebnerli@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3tc59y57zxtiowwq63ozdpxho3zynj5s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6062F14000F
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793840526-599243
X-HE-Meta: U2FsdGVkX1/5SDfsynzx6+FZMpo9LHEFm74UT/rppWwTWDBdn6HcemqegIY5uQJ8/PS7YwB0phBMJ3bdz7R+SV9T1dbkRHmowBE+vJtUywCYL3z7gM7iD9leZ9/BM0x1J4/Ws50pra6jkgzsU5KQAF6HA7rwyWL0K/AKMrLPS/olLLXYB26gkvLBAwNopauIcqrVJRvZxKvP43gptYG2Zmd6d8AvUJtSiSyNq5Kr40AVfaMwR/hZRg2Tb4yhpP4MJQkEOb04Aja+ahCTZ4RqFsfb0OF3QBBTLR9g3CqwIjepnIqEPlafoHgROKsu/FbkAshsk1I20Oj3aHMgRPERmfe4qpCD1h6xBGgiAkxyr0vcW9eL9QTdlBAu7WmZFEQCarFu3EW0SSx/CRAdfBNGEPk96yQHWPPQwUOAcjVP8jolCoornQWVv+pscxXq1VKXTOA9hlw3sHnKprmlO9CCzblZ4mvw4PKE9vtjNIn3pbndEixgGuz18j9xBG4y+fCN8992vVQn+NIbx139gdYV7MSNQM0dOE3nKzhMd7DZjEIlt/7pxEfQqQ8JG66w9te5LOaJrhZisdW2m8EvRL0QJ5s8TxbPt7UlL55xkHw6Kw3X7xE9iA/R7C0jQZz6x+NaLV8N0Vha2H1EhR9fiFWT/BXTgIWIzTPspmPcMo/LL7LKaYMhGqOqJUn9wUotflsUVI7OSCEYymGItQtMZQwURSISIzPTUfCZHwM+nO3B2evzyWV19ZrVu7AkhecQF80U2yYPNf3D2IpgoMWkN5gtWsagvMW9XKrG4Ia4/8F8oXvDz5yKxfxSB5eDgvHplFeFbbDPsHN1ND779X5jcHPS57f6unysF50MaVeubW7D4E0ClJviqUgO82XPptc8jcxXOY9q8CGnDV1bwURV+IxIBC2tzqpSUe+wRjjSO6/UcdgyHLtqkC/koXXruPN9cO09i7DZ/haoESe9+YVZD0S
 vsyEcDDX
 fk9Yn9oRJntSXr2/ev/71SoyX0LJXvEdSEpAQDnqz3X7Qj0b2Bh5B1udi7ptTxuHXLRYIma/LxLMTSJgcYqpBikTNUUSA7HdHUkKFTE07GwgihBQTkeZwnSDajeB7qdqV3SepnRTDTh1QVkP8wdLjTjFEiCGGhsudIEuK14cZXUPt7hCNQOwGqBTs+ia66aRmHpyhCin0UWEy/CgWCC3ayy1QGrpHuiwruGf1+0I72Ih3xjgrsWynnnrKdSBYZY46o6odY+N+v5HweFlfUh/Zmt3NZXFf8C7CrMyQ3zW5d7o47VQrJ/EqsRouv4JPyI9P7QPG4O8QBXfVFOOHWJH/e5YoLmMH9NiLZrXS99ioSIo8K/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed,  4 Nov 2026 21:29:58 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix tenses. Split long sentences thereby improve readability.  Replace
> 'set as' with 'set to'. Replace [] with () to make the file uniform.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> CC: Daniel Pereira <danielmaraboo@gmail.com>
> ---
> Daniel thanks for the Feedback.

FWIW, it was a feedback to the reposting [1] for mm.git merge quest.  Sharing
the link for a case someone wonders where the feedback is.

> SJ, could you please reapply this patch, if you think it's worth it.

From the next time, please discuss on the feedback by replying to it and ensure
the discussion is completed, before posting a new version of the patch.

This patch is already in mm.git as commit e576f9950ada
("Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye").  Andrew, could
you please replace it with this version?

[1] https://lore.kernel.org/CAMAsx6epLXuUjaV3J0=SWAuLvajr4h58DTM9gL+LMmaCyjcxUg@mail.gmail.com


Thanks,
SJ

[...]

