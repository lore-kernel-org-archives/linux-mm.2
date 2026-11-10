Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7700606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SkODUEqk
Received: by kanga.kvack.org (Postfix)
	id 031556B00EF; Tue, 10 Nov 2026 11:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008066B05BA; Tue, 10 Nov 2026 11:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E617B6B05BB; Tue, 10 Nov 2026 11:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9B706B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:44:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 665FDA8689
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:44:42 +0000 (UTC)
X-FDA: 85419783204.11.AE6C354
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id BBD18140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:44:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkODUEqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/qfX2R+fE5TFU8gL1lYbWbnT1+3dpcnTBXBU/PkfAg=;
	b=12KbsrghUqa7w5oEiopNtlR/VvJ6NWWa/uJQSZJ6DrriehJnNm2JIf/CiVQZ4OS8Qpp+u2
	FSvi6ZjohjjRZwqZ+/LCPSry6YC47z9rOiDQSAXhdztqnzgdgGy4ILo/QV3ysm7Qr9U97v
	u3z7b+nWzc7ftTynH63Jo7WoAUbxgWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329080;
	b=OXWTsJYr19MP9vC2jT4/CdOSW05tTdJRhPhz6sMCnB0eRLWyIerLu480zznl0/d7A6bpIC
	fN6xI2XSRauSSlBv9gGa1XXI/kiMXBirHMutpKRyTIMpsb8f52O8YCQWhEBCvmhDnTUCb7
	JgrRs5Z0cgMhcwXT2Dz1Cm3ZJVOHrrU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SkODUEqk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFD8B41FD8;
	Tue, 10 Nov 2026 16:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2931F0089F;
	Tue, 10 Nov 2026 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329079;
	bh=8/qfX2R+fE5TFU8gL1lYbWbnT1+3dpcnTBXBU/PkfAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SkODUEqkvlyRvjcJwC5tU5BtqWCLFI5gGvgOPIh2pyDmhkOdp/P/T5DOaOp25rRUJ
	 vO+TIZGOcCm/WHRu9EEVtaII891yWB5GQ0VQmiX+taYdFzXLQtYBUdKSqBqOuktSmh
	 GvKIdZFVmH5iBQAWt5dQC3Qmmx8Wb345AfHpR/Y+0c+iNKca/ey6QlAnjxQ0QVMMcT
	 y8Cddppsk6vxAy0cJZL0TZ9AdCD/mNiWC1VHwhPdksGr56t4kprZxbf9TC/0oPZ2cc
	 HfoScmF1jA13vzAW+bzN5kbXosGepqZt+NnybIWXuZwyXGD9z6qweyIGN22iUGdgfs
	 S7Kxs08xIWFPg==
Date: Tue, 10 Nov 2026 16:44:37 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj
 is never 0
Message-ID: <avNJ0p1v6FZ-wnQE@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-9-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-9-senozhatsky@chromium.org>
X-Stat-Signature: y35nyjmbazm8wyfetjkshkh9cx1uenhp
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BBD18140005
X-HE-Tag: 1794329080-572384
X-HE-Meta: U2FsdGVkX1/Q2PjCf9Z3SzUcn7ehh1TkF8jwnVFT2zdcABgO8McmAxCaE0AvcYuddVVcBeE+b7P3Y9qrVPx1EAT/Im4Wp9K3GSJ/Li1abOgoMq4LiYYYx4aIPNcCpp8mIn/Hzm32cGjtJ/2AZ0cdUd3WsntHr8vUJg9HgQA3I0VecR+3KX+lXhlUdvlyoDMiEBugqGZXjMXeTU+fANe1amzMmxktuLVsGDzRU83GKxCL2Ny1Vmd4ozLJj2dmQ7GZuPHIM3HUoULVrr2Dx0iZWLH57pZfRDC9GoLnkkM7QWPoPIfa5nWYUFU3z22t7KlL7TVt2pk+b7g2hYvcnYh0w2xBWHn9RTK96xMJmBGTzvLAOH6iAGS4pfrjIOyo9OZo3bgMcKOFvpSz892CnJF6PaBGS0CZZyhK2L/6OmkXCAu19kphYj97Yx2nIp36AxPlGZj3AAKZSRk7mX0G7gqGhNG7kbUXFMGhUImWCD3/HCML6Aso4Tv8ueKzjqQ5w66J8KH9tjUBBjZjND+/jbhfAi49q5eSLPHg/cVh3u2gEq/bXnAkOrbHwvshGdQ7qA1znyNtJD524CUkyTlwt6XwIWTEa2/6qwjOPS65Sub4n73Vi7RrsnlER+alOOnZnjKjxnAMp+fkV4okmsiXYdKYpG2MOFSrBbB3IayfQp6LAycMBrSnG3zPt8Ch8bg6bGZeYGc3QR7oe0q0xgjx/g+yjrKdQy2ukgZIse/Ro1/oI2/9LNxtfJfWJCY3PbHAsyg7eHzZWOYK+ALPBL2DOtHBmNPfvHCKByhHtR5PKhzvSlxQ6C6Oi7YEA4/wB9wBZ6UNUyDSsTdocQiRWSPz9vnxBVmVdHxi9HNWFbfX9+ZU/QDwKTgQrcUm5ZnmbrIQO71MDs5DbYfkgNUCc7CgaQxy1HDs7HMYKLeBd1dmliKfU3rxsVBtMAQNu8AM/CEh+2HqUHhW2d06p8vDxiMOlbu
 W9m4I+Q4
 LwUg6FsVEDSbSapchIE2XKjOQjeWbrXh/Pa2ReLLPNDfULHLnz8QBkYFzLBmJ1LRdilxPqHMwIkvUsgYT0TUm46hl8i6CktKsEN1MvVIqVfS7pjK4KvwIcn6CiUYnIjuu8qCwQyChn2Jr1bJfAgbCw6gFoE3MbLo7pQgP8f6PdpVLF5tEAGJDE/hK29Pcbbuolk/IEm1PBpOpcJP9nO07BsT7keL76z1jW5Vks3l3uWs88wqsFlFfLB82uWTN4CZsVFPq+xRiLdFpq6txeRt/q93hzSlvL5bnZUx3IPPQnTgTwAtZV5K8wUe5ybv3m/hdrLzS5AKjrqUS2OnQx90ZIzg4NeWAO9vCcLDvVlE9R3ppFZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:13PM +0900, Sergey Senozhatsky wrote:
> The next patch embeds struct zs_handle into zram and zswap entries,
> and a handle is considered allocated when its obj is not 0.  But obj
> can be 0: object 0 of a zspage whose first page is PFN 0 encodes to
> 0, and some platforms do give PFN 0 to the page allocator.
> 
> Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
> ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
> separate tag bit, this doesn't take any bits from obj.  zsmalloc did
> the same before handles moved to handle_cachep, see
> commit 67296874eb1c ("staging: zsmalloc: Ensure handle is never 0 on
> success").
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  mm/zsmalloc.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 3a6a7253fd01..aa436df0cc4d 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -61,7 +61,8 @@
>   * Object location (<PFN>, <obj_idx>) is encoded as
>   * a single (unsigned long) handle value.
>   *
> - * Note that object index <obj_idx> starts from 0.
> + * Note that object index <obj_idx> starts from 0, and is encoded as
> + * <obj_idx> + 1 so that a valid encoded obj value is never 0.

Well, this may be a stupid question, but why not make obj_idx start at
1?

