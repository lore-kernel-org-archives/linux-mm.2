Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6026A606EEAF
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fIsZeZWQ
Received: by kanga.kvack.org (Postfix)
	id 6D1B46B05B2; Fri,  6 Nov 2026 04:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6820C6B05B5; Fri,  6 Nov 2026 04:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598526B05B6; Fri,  6 Nov 2026 04:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31F7D6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:21:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C375C1C47E3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:21:52 +0000 (UTC)
X-FDA: 85404152064.15.994E08A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0EEC20002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:21:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fIsZeZWQ;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793956911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OLeRDcRsIxPNSomaAo6s+K7OCLuQDG+64RQlcsvtls=;
	b=bcXSxPkMR2Pb4+FgTin9nKuhogWXgfceDci0bMlMnNaej8OYNewgy4rFacy9C6PeETl54j
	jo4rn/WQaGl3fJrEz5jLF9XJEFzF3PUFKA8HFCamtpSCHm8I2xoqj6AQkdjdkiwQkjdRvC
	xZU5WkS33MnJjcG3s0bY5o0bGICD8hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793956911;
	b=b/a0RrTdX7ZczThhF2ZzHaOgZBjrZS3TJzXom7pRA2VOoPfQa5CzG/wRx1wfPcAXB338JU
	w7QXlyoDHCeVngT3xvRXtFF09Aqp3OQgT7z88PMtsZIVpljtxIte1fFQEMaJ2KbbDYUUAQ
	A6FHQs0K8Wlzp/s7mJ1OPBv1IhDdlj0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fIsZeZWQ;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADAEC2F;
	Fri,  6 Nov 2026 01:21:46 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76E6C3F628;
	Fri,  6 Nov 2026 01:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793956909; bh=V9pEHYYt+1fb+K2GHWQyEStcJTnSm3pBD7VgR3s1gr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fIsZeZWQpPOXbXYjkoR9EujxqwRASO0z2OUFf9dmTklUqNfi1aKtM5IYz4h5E/DZY
	 JsbhWtfg+GQVv6QxQur1YmIIhuEhI0vtNKFR0w2P2iPc+zjm8NJl0YvUvkiD8yRHgK
	 xnW0Xx3u+GPrgI77rJFTJvOhKrkyOrYZ68UUX6fM=
Date: Fri, 6 Nov 2026 09:21:44 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
Message-ID: <au2cKP0SWaaHQPrg@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
 <auiI8jzumVHmmSV9@e129823.arm.com>
 <9a67e7f6-0ec6-414d-8689-c70eeed6100c@kernel.org>
 <auiZFJ7Bb6cQnqtX@e129823.arm.com>
 <d70b6ac2-a8b2-4c34-acc4-ee421eb70aac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d70b6ac2-a8b2-4c34-acc4-ee421eb70aac@kernel.org>
X-Stat-Signature: su5s1jhaugyyn3udgwrdg493ozfd5fk6
X-Rspamd-Queue-Id: E0EEC20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793956910-571304
X-HE-Meta: U2FsdGVkX1+HNeQ1j/7TAI04xRCV6q/mm6bUSGIrl3a5f5yp2B0Pu2FqsL+BxOLuDYQ35f0RMN8fEAYsd5no80IVSgnoS1K72b+9qMGkWI+dwxD+GeUR8rXQ5mHJWK8vSy/gmhQAyn7MzqGk905EvSzQ6I3tOo6Ppj86oWCWBLAs3s32SsODCS7Qh2zkgufkW+SYSDYGqr/L1n7ONIUu5IzejrfYqeMtsKfGmyu4vRlk/qeTomGetFDrU/wflJPWNmrEKL/NngHzvKeE3+0wE7QK+7E1Ew0V3JnRIGjDV3RCCKnJR+dyN0L+/NkveRbI2hnoPF2XiKGKHKoY9DuBXL7IrxfJGHuasoYomd37dGsjSz7mcHwwWB+F6inNpStklZsdOeKJouYI05JSesAwNea8urHjPbOHInCuI25Uun+dU2Bzjh2LpNZveHT+jFO4U785XFS2Wx2CquzTaO35klBmad10y+SPP+jL0uoMKlhCoP2cDwOPDZP6B2gEni+vVX1yqE2tdvLIT9/QAXBGZcQipwk+QcUt3aAIFPh1AqemhgXXO0N7rrKecIXHGa1OVF+e8+iHywKYyHT9bwR43efRnn8JC5f7WW1LjDxBE2MlsvQUPkReEoAlnVqTcgrLeIOqezUaouFLdL7zKvDxJSHbSe8eTt3mwAZtTpLvMMy3jBNwnisiynhYZk1MpozoM0KwYrztHi+auM0/WoXyban0HaT+GJ9w2CanDFiq0PiGEa8LW4e4kxHzwN1LDf+oWlsHzPrOvykCbmdCxvhFUc3B+PGIs2rf2Py2LPT2aZcMoukjSx4vEW+9cGp0XcRp4qoaaZaozX9LGVmNFiV1RH9zdZ1uGgYtywCCBhZnbFARGUrOnsCfRjzMEP41gtjWAXeV5ccHPTwyYva4BzcJfYhQP3yBhJvNqpaS0qeUzJktEywLac/0OGuLu7HtgafQTsF01uk3LlS4Lht8yer
 5tP2+qdn
 srA1bRkOrVRj0w2aGXQ1AWDnIR0EjC8Gg1MqVX87pAD64pZS8DbV3XEMo2lkCk062VMLuXIAgZlGgxeVsBX+/7dp6EVA9iZDw6zlMFI42te8R42M3CSyvaxeIbezvEUJBkFsrT/d2kkfrOBB99vLZKcCcXuwE1tE7xVqWCk4Xti/PTJn5tytGe423PFGp/KL3ZctHWgYug/87uBS42HDVOX6wTmV6BpEFaGEQkyLDv/I0c2gKltRGoPLVORAh+BTC4tP8Kd7dfIhlM2YZ5Nx1DUsAC1JHvXdWqaLG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On 11/2/26 15:07, Yeoreum Yun wrote:
> >>>
> >>> Sorry. But I couldn't follow. If we accumalate with any_unwritable
> >>> and check it out of loop once only, we couldn't properly nr value or
> >>> Am I missing something?
> >>
> >> Ah. The idea was to simply reject the batch entirely if that happens. It would
> >> only matter if some folio PTEs are writable while others are not ... well, ok,
> >> there are some cases where that can happen, but it's not really the common case.
> >>
> >> I think we should simply disallow ever getting large folios into shadow stack
> >> VMAs for now. So I'd prefer the fix below.
> >>
> >> Thoughts?
> > 
> > That's my preference too and we've discussed :)
> > I'll repost with below unless anyone has any strong comment.
> 
> Yes, best to wait a couple of days for people to catch up.

If there is no comments for prohibiting to set VM_HUGEPAGE for
shadow stack as David's suggestion, I'll post with this on early next
week.

Thanks!

-- 
Sincerely,
Yeoreum Yun

