Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EDDCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06026B0088; Mon, 28 Sep 2026 07:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FD16B008A; Mon, 28 Sep 2026 07:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57826B0092; Mon, 28 Sep 2026 07:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A07CE6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:08:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35909A015F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:08:43 +0000 (UTC)
X-FDA: 85262898126.23.C7F6900
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 30AD0140004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:08:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jS6qZvYu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M9IUB5D0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H3MMkU2+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=11HPE9PE;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xr/xZeQ5cyTZWsRIm6/m0DTTQKyIaa+hduhVvGYFDMQ=;
	b=LKUn/6ky6/YARY/x3+yxf3ifs3CdQUGZkbvYpHrXL3BpO0nsi2/NNMuX/nxWVnl8UqRqiC
	Xx8FPQ60vF3fPMTuWX1ubODMz6+vcpEGbcQi9t9OWCPhEix1UeqHFKW4AFRmCn0ldJJKKF
	YKB7DYIMtQTXYRi5zhBYX/lxawZix8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593721;
	b=Qbb0wfB4va1Us53b09iEJ7QYkRWp+WLCnrqK17XLaftugpgK2KXQLRScG0RnUg/4oUj1xv
	SgjeJRWTT933tHoUHaXRyR9kpM94jG7bGcJDXOdLsP7aESFlmgqcVszTaaBJUAngCYBXDO
	6idxO7cmno+cd7ttnVNeIZJdNm8+fTE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jS6qZvYu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M9IUB5D0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=H3MMkU2+;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=11HPE9PE;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1AE5226EE;
	Mon, 28 Sep 2026 11:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790593715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xr/xZeQ5cyTZWsRIm6/m0DTTQKyIaa+hduhVvGYFDMQ=;
	b=jS6qZvYuUdVoFCHgSQD3wfwWuVjA9pM7IBFXDniP5kK2hL2ZV7cZU7wjQ5jq7H80h+U5nz
	KVf8ICPoBUiTz3lS3dVAWNc0wFZCuQnoHwc5IWi9srDY99HUbUFcoZda6ebNexAutFL7Mz
	p0eeJsH4UTA0o7Ged9CmW14t8mUY3Z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790593715;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xr/xZeQ5cyTZWsRIm6/m0DTTQKyIaa+hduhVvGYFDMQ=;
	b=M9IUB5D0aR/HJvrf+SIjJJ1gwywQ/SEbpmuDNmR8r8JMAnlN3CussjXHb1nsd7+UNSB4ab
	UIE9Xwrl3azubIBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790593711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xr/xZeQ5cyTZWsRIm6/m0DTTQKyIaa+hduhVvGYFDMQ=;
	b=H3MMkU2+A3/+lLbBXPjkbi5Cn+IhbY1t86KvifnhoRJoLnfAyNvuZdUWQ2M1nCyeQqx7JY
	5zRyTWchzbHh957YCU/Z9VOksrh7v2aaMwOtznZ8xTt1MdyNSS+dTkYa+gBfycZ+qGBUCg
	ddQsVoZtJ+KATSQ8m6xYQI9PEdg95L0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790593711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xr/xZeQ5cyTZWsRIm6/m0DTTQKyIaa+hduhVvGYFDMQ=;
	b=11HPE9PE8eprCrSLd3OCEMcP7Fx7Kjvy8inGLHzBoK/bavI0aVo0H8OTN08XspznyT74cN
	CKAcc4GqhTWoZsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9B39133F1;
	Mon, 28 Sep 2026 11:08:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zG3UIa5KumqhKAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 28 Sep 2026 11:08:30 +0000
Date: Mon, 28 Sep 2026 12:08:28 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mremap: fix locked_vm leak by splitting VMA for
 MREMAP_DONTUNMAP
Message-ID: <arpJfa2ssGZYduRJ@pedro-suse.tail5790ac.ts.net>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
X-Rspam-User: 
X-Stat-Signature: wmogfqwdtgxrzn5neyysjniu8sb196hb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 30AD0140004
X-HE-Tag: 1790593721-258118
X-HE-Meta: U2FsdGVkX18Ib2fdRkkFy+hgWFLFaL8J2iNwszdFg1/B2IlvbY68RnNLbXdriTZ0PIQlL7RkcJj3SUCXoUBtat2u5D+WlMlzJZBB43dH3IxBjQ8FHs0aIo5/q6pRI9tUwuyxGQ+/NjxUkuwz7k0qhKYev7z/+cYXcxWGW1y4SDAnU3FKCHnJRULegrxbLYj6lUCJgFWjsXxeH29xN+M4z+EFHtXpj+boGNlbhMM7QE93PvUIuuHMGxYG9HJ0QWjOnmP5WUMY7mLeWV2RjcvBiFYjkTW3WUf8jF+mmzOf5nexyCXNXglNOYZOuFvJ+NvpFbygzB+RCQUcr3jqMAJq9PaWdsexmkRtF7bXDasFK5A2IYo2d0k3fVT9Pma6h+ClJ6geJfvwapid9cfJYzmFs9TLNHbQBubBRBOklDkOPjfH4/umfC8RHgcp8NwEC88QGkOqMhPx6XcH4gwh+aaRxWvhYCwheruhp+6dZXf6m3CdrAarhvPDQWGVlRejlgburBi7KvCbljKDdghCVzCASBzyGy4N6wd0uI9DZqTkHNJsyN4BmqqsDkUM6x6K0DAm/ASQRn9CMoPmNVnxg3KVJ8+pgbSNlMci3IIeYhJ9S+BlI7PNnm0JU+j1BI4xPfBDk11PdN8f0fs8C9NpdNzb8wgVrUHbpTgal1m2ksm7GYS4GaJglvulD9b7+AvDr8LLt+HdmwxakUv2uDIV9WQXbcLdsdGufbZ6bi+wwjeR1xsVJbiQvdVMG5nFjXhrlTM/a1y8zKYcWRcfHvxU2MiAYlGQDvtaFkfURlGebGlfrb0TEStxj8DDvNtbgjIdNHIuPOucuqG9cqYY9Y+6U9CG0SshaVvPaLPLgPmaaC+1cKVFwgHJoQ3+945RE32R0Z3s27eQa1J8A5Sq6f+Bt488yTF2A751bEbUAmqhau1HnDcWxURm3sFFjNgzSVIVZQ1w7yGQgUhpsR97Q/RCEiK
 FzZNJ5Ws
 Va1zjb8Su41cbf2vBguPTvnn7d7FfE/HujYVhhmW4cVwZ9y8KMgA4zghUguPz9pzDFb0/Kou8bIm8asM+LNF8ZzuxHdainOXRPOkBxzQpcO2trMuEKUwwUaM5Wn2b0qcZ1cFW2k2gJ7+TpzqJbmQ5AX3QcOVfT5ukCLVmlikWFQsM5AC+Eo31T77liyWJdwG0Xyt6ib02WGrqEzZEw8POeVCfPeiSqmt9I5a/DRRUyN8PfiTlb3I+sGanDIcwQ8J+KGEy9j5NHsojdCoSs1nz+Yv7xNERsW4XobEVHs6XBdm9ZfA0fXbZ6fQNki7pvs5uppwzY3rQXBFUPYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> Fix another of these - partial copies.
> 
> The long-standing mremap() partial VMA logic has the baked-in assumption
> that the originating VMA is unmapped and thus moved.
> 
> However MREMAP_DONTUNMAP defeats this by performing a partial copy
> instead since it keeps the source VMA around.
> 
> An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
> but the operation can be performed partially:
> 
>                            |-----------------|
>                            |                 |
>                            |                 v
>                         <------>          <------>
>                         .new_sz.           new_sz
>                      |--.------.--|       |------|
>                      |  .source.  |       | dest |
>                      |--.------.--|       |------|
>                      <------------>
>                          old_sz
> 
> The page tables in the specified range are moved, but the original VMA is
> kept intact.
> 
> This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
> cleared for the entire source VMA and set for the entire destination VMA.
> 
> This results in an mm->locked_vm leak as the change is therefore not
> accounted correctly.
> 
> The clear solution here is to make the portion of the source VMA which is
> mremap()'d distinct from the rest of it, a.k.a. split it.
> 
> Therefore resolve this issue by splitting it ahead of the rest of the
> mremap() operation.
> 
> In order to make this change re-expose split_vma() in vma.h for
> CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
> instead).
> 
> A quick search of how MREMAP_DONTUNMAP is used in the wild suggests that
> the partial case is either unused or rarely used, so this should not result
> in unreasonable VMA proliferation.
> 
> Since this makes every mremap() MREMAP_DONTUNMAP operation operate across
> an entire, distinct, VMA, also eliminate now-redundant code checking for
> this in dontunmap_complete().
> 
> Finally, update the sys_map_count check to account for this case.
> 
> Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

