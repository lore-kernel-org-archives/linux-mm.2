Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB469D2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24BC56B039C; Tue, 20 Jan 2026 04:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CEF6B039E; Tue, 20 Jan 2026 04:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164466B039F; Tue, 20 Jan 2026 04:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05C496B039C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:35:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33E691AF1D1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:35:57 +0000 (UTC)
X-FDA: 84351835554.30.8917644
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 58AD9C0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:35:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9jQrUkG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768901755; a=rsa-sha256;
	cv=none;
	b=G1L1v+AKTZxMVDJ9KwVEZ+mXDggap7s73tjdVwNiqL/X2q7XEELBvB13EU7IJB7FpGFPty
	yn4scv9MvOTiYQRsGSuyzB4vL1kY9A8vvcUwONnYIy5HO5kUQIBo/Zj8gckgkYhgasij1S
	Z6GBAl7UH4Eb+yGPpmn70AJd/0uJxds=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9jQrUkG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768901755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/B47m2KmCAoDa1sKTOG2K86RewOM8wCFrwCd3QEgHw=;
	b=0ebImXKYWk3Fu6J+swNiovvC8rFK7EgvkTsPilH0AoOUY2eebslKk7/0dCrgCL6gh3S+Pe
	z9wkmDPK5MAw216P8Yv+rzUc6UV8aE70bkFKchMf5gdLnmfc3udXXBC60c/QDxzFeY/Tkk
	9/7NZtzI3Bsi4jwTz08roytqQiEQVDg=
Date: Tue, 20 Jan 2026 17:35:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768901753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w/B47m2KmCAoDa1sKTOG2K86RewOM8wCFrwCd3QEgHw=;
	b=h9jQrUkGxc6uglTG0TBiZgPbgunulGxvcaH9cRELJTTMt90s3Xg5BRMUdKb0YWsNEP/DmH
	Qe6wm7j+OskKe0rHD45NWr8HR57ZIwVzdSjoyxPmr2EQsJjFsD7F8Pszkyu4xktyxxp+Lb
	i/Qhi4Fb9oFjRqzJx9GLArJyI1oYfMM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 13/21] slab: remove defer_deactivate_slab()
Message-ID: <veqtpod2liqsi4mgcxndgaiyqlhupnymmj4pquueqziqyakmnk@fzympoan5pds>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-13-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-13-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 58AD9C0003
X-Stat-Signature: di1pney1ocsnszaw7w6adp4e513tt795
X-Rspam-User: 
X-HE-Tag: 1768901755-403668
X-HE-Meta: U2FsdGVkX18gzFM0xVD26LTEqzb3FvuFJB/Mt6NwGgANKYFayvfAnXZNNPQJQwE6t2xZWB60eF+9117v2EWnRigUdW2ojwZjTJ3ycnxA/n3vwjvGJbvNEia+4EolisFB7tlFl1Iyqd8ohK0nvTYMIlicCkqtZ1G9QQxJK6EbXVpl2/OiognfnhEsRHT72DCWui4K/rTssJxeAYG+xVbZMjq6jrVaqVpqOi6GFqBR1V/DBXrseq4DXB3NJviTAOl+Pf3Bl6s5m2HhYXsVubkpTIeXDTvFKqjirLG92JiUHzVozB3h0p/ibWAKTqfQGFj+B9wVD8TbZzryrp30oCYwMGrmAsShnlSllcMZv1tpDI0e17HE1fuiHZ3u66GCn6PbTLaJqW9+UY+rE8f84ZC60BSdrOWjsem7H0n1dvN0ZJtijI4EGGY3X1CAntgaLBgYdzbG7AxTGP10t/ppri6K3NZNSV1IWedVy1T90SN2RB0/1KcemhMS+Z+ad2egdsWuplKDW2VUOi77qertjw4htUMI1ys3YMTbH3/pP9ewJxip0Wjt+59xkDBQboNv+Bm6o86PJNemRHdzPaT92pCeyIQJtOTMtVVCMXYnFqo4U7oy90VAr9d1ypfCPszj31NlD529IxxNewDEXF0REBchNtOyQcnmqe3HLI+YgC4DAXONyuDI6CVItIkgvmyLgLCm9h92cOKZ2ehkTh4H0nguem3yU1Gju/1MvLvfHc+nWcMlM4mFU3ApwacTfLj+uudMUG3B2exM62416o+/eFUfJa1s59nPTeaZpvqLMkFvUlNlaHE1+p4BnBWzDrBeiE0NfdhdB17dh/k1wX3DQ3vp8Y+z/s/Fot5T4QSvV1GDwmyr+jqbDfrU6pJRDkqdI63rarZs8fxl8tzV9vWhK2pQijnkZIr5HMY7/Sx88vPMH0sd/tsLMw1AX+Ql9JpZbANgA3wlZuzmsBasUMXXkBQ
 UC18sCt1
 Mz4wKZIyLDlr2NZcyc935I5l+SIkijZsOY7EdfHAbiYYhLN/D3dQg4jxA/eQyG3/EzNdkP/PGPbmv2a19Nz4xAIVNcjvLz5UPxzsBUsiWUbvdd4RbQxi4cdmJuKQ/owcZ0rC7ImRphK6lyHUA1oOwb5BXFXalltYgrvdlqAB/6949sc2aeLLEblM0MSeIkV2FIzo3cbt7cJZECiztTHHSJRbIf2g3wrx80+GDzMqtxaIZ+Q7vP/fnGK81VN9US8+bX9YI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:33PM +0100, Vlastimil Babka wrote:
> There are no more cpu slabs so we don't need their deferred
> deactivation. The function is now only used from places where we
> allocate a new slab but then can't spin on node list_lock to put it on
> the partial list. Instead of the deferred action we can free it directly
> via __free_slab(), we just need to tell it to use _nolock() freeing of
> the underlying pages and take care of the accounting.
> 
> Since free_frozen_pages_nolock() variant does not yet exist for code
> outside of the page allocator, create it as a trivial wrapper for
> __free_frozen_pages(..., FPI_TRYLOCK).
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/internal.h   |  1 +
>  mm/page_alloc.c |  5 +++++
>  mm/slab.h       |  8 +-------
>  mm/slub.c       | 56 ++++++++++++++++++++------------------------------------
>  4 files changed, 27 insertions(+), 43 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

