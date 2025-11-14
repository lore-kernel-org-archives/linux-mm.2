Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 667BCCE8D7F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35348E0034; Fri, 14 Nov 2025 14:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE55A8E0021; Fri, 14 Nov 2025 14:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22BD8E0034; Fri, 14 Nov 2025 14:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A36EA8E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:35:34 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68E6E16047C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:35:34 +0000 (UTC)
X-FDA: 84110216988.29.4FB47BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1FD5120005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:35:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kz1ExJB9;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763148932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVOsGGNev+kFc4fmmK/Sez25eFhPMXojX9JX+N57FXU=;
	b=MXG0KDOHKz/d8rxY0HAkGjtQOF/6zOWxIMFdaskhZ7mGpG7zhWop1L2SK6fwl4QcNMrUM7
	rD7zplMlDSTMsH1QjoQ4R+9SZqceWyp1vsJA0EyghLF8AaoJ0TqThKpByysru4goSEkWFR
	ryCGIpmcue9AGew8nY6RwLgvxRtKWrM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kz1ExJB9;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763148932; a=rsa-sha256;
	cv=none;
	b=CJ8NvZqZtYpWzqtlua3Xf6JU58072Z/AkzKtJMkCulOOvql6auJl2RFrPAKhqjnan67MnQ
	Rt+TmMd5tWHvBrJ0TGOeF9pkxWSvofoB8VKS4fi/VkneWifH5PU2IZqQQudy5OzVdUqShA
	sq8mHHTfUxBe0lFuXlyMs3AjtYSGdWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4077260188;
	Fri, 14 Nov 2025 19:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8BFC4CEF5;
	Fri, 14 Nov 2025 19:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148932;
	bh=Zc97r0exmktwpRs9kQQA4bpGO3Sc8oaRn9s7KddLdwQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kz1ExJB9ShhwyZCJrTmzMuqpRjtWv4hW2F7jZNB3rfQUowOAAacUIA9PnkDXUXXGy
	 xLhcc2rw7hSxiEIqfhbBUcVT9CvKryIbYxKgx8gSDhH6DPxm8qm1u6p2h4NU4y+eCh
	 jElngR6kvZ1B+ABXKxNxhL3hIGll1aJDF2ueT+YF5Q4Bkr8Q9r9knlbR1fBdFyTVCq
	 R2ND68jqTTUj1ZeLbaAN4/1I/L/AHp8N6psr/aDGPJdB4iWsFfp4u6FjJE+EFxuFiy
	 r945l83UMnqUx71Xg0fjH+ULU/gdV0SC6l9m//rhtkFv5zEouCT8tb8KzHp71NJNGW
	 JstnL8QGZWi/g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] kho: Allow memory preservation state updates
 after finalization
In-Reply-To: <20251114190002.3311679-13-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 14:00:01 -0500")
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
	<20251114190002.3311679-13-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 20:35:28 +0100
Message-ID: <mafs0a50o5rwf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D1FD5120005
X-Stat-Signature: za7gy1waa68nc7ken9877grunx359xuq
X-Rspam-User: 
X-HE-Tag: 1763148932-472958
X-HE-Meta: U2FsdGVkX1/DlCbvHmv5w9pHHxQfANiXfezi+3SEyXcs3vyR/VSsQrDcC/HgzUDek4GBIrXYQEzfIJwHMYktZn0HjqDK9M+zJ5MfQxtEzu7VSh7mqohsOAF3TxudtmgLBpvivIREgiob24XR19lv+AISQ+KIFN0aGv2P8BXTSOtqKjbVdRbnzDLS5HsUjCmJbkYCaS/VU3hNRiXc/Uy+nMRkhu8OWuKd1GP8eGfwEBPejyZlWbsjHZKi1HlML6dHAg5QekkeIvzJ41SBJNagxqBqCuJS7AoXXEU1lqEE8QmV1BP0IRWVH/Ua+dCRSAWeiN4xuD73tYd+5H3NnBG8/qDI+PkvC4lNy+eFRuarBC8RHnD9obDHxeaFN4ohlimQaOutAHVSwmkoIA7amw25IWl3BXlIAOWubwtXw7XaX1QoXNUOEUTD5gG4oAGqFcEXT21Brt8/rr+MjfbI0sHC852W4DpyXbyQOGsc3C4jTy6p7iMHVVO3frFA81U0PNW53kPV1eW5h8ADgsONrRsdo2EKLa3HI1r8dGbvHCtAdo8Aa23WXsxYkk+JGf8M1fGe2Pwa3HJvrRTDg3jlNmWP6rOJqezgSOrIjpk1KIk/TJZH95h3xecUBpH3t1WF1UCfk0EN/z+cMOc9PQQ7wjXK0lCR10fqOleO8Rbot/3EbNp8ZFhbxJom8zlc+RLwpagRFULyH2BMqtQut36M3LB8O0TlpV31wN1Kh8/oh8M6NiXGaq2PJXZmzqyVrJKVNXNzAaTcTTUkEXTCqkgvBHLWQKPk5gz2bc/ZDgxKbt7FlHWFbfgb/IwRwD3ZcPirfwJYZRuPZ/HLcp9DbkjHydNANjlAQkHnzlz6KRKEdA8NPptlECxm1MRQaGz/koOqBJ0B86vlAj/hQAqoc0ToInAPCxFStXumZDnNb62CccikSDhY3k1JNCmz1muo9SyBuIhtKAxLapVM0mBrsRsRSvg
 AWXpNxeL
 mhjElak3HQUF1rhPThN8IiWuV6yr9NOc3yrUTI7R4tGFsSVFziMOWHOGY3pZbH7bFv9bZbwup0Mj9fyPywR0bd6Wo1CvrQayNo0Ss3i4spL6VLqoyIHAjVqntDCpoA+NFOQGD92bxJfBHO3MVf0tGP2CUZriFIUPsTHuATRjDOmfeUqQ/Gg6/BS30w795uwT9onveOqtVmBkhfeRsVhFiJ4fCjioSkiyTdf8E9KYwkNHk1BK4DmZu7J6mRKLsJNvrrmOO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if
> KHO is finalized. This enforces a rigid "freeze" on the KHO memory
> state.
>
> With the introduction of re-entrant finalization, this restriction is
> no longer necessary. Users should be allowed to modify the preservation
> set (e.g., adding new pages or freeing old ones) even after an initial
> finalization.
>
> The intended workflow for updates is now:
> 1. Modify state (preserve/unpreserve).
> 2. Call kho_finalize() again to refresh the serialized metadata.
>
> Remove the kho_out.finalized checks to enable this dynamic behavior.
>
> This also allows to convert kho_unpreserve_* functions to void, as they
> do not return any error anymore.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

