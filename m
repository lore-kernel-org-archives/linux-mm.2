Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2ECF34C58
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95636B0092; Mon, 13 Apr 2026 10:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46776B0093; Mon, 13 Apr 2026 10:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984006B0095; Mon, 13 Apr 2026 10:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC076B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:31:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 411271401EE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:31:52 +0000 (UTC)
X-FDA: 84653771664.28.AA62701
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id A887540015
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:31:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gRsqUZF2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=txhMkBUn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gRsqUZF2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=txhMkBUn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776090710; a=rsa-sha256;
	cv=none;
	b=8YUi4vQYWguvTfeAPps31KWXkLDT2sHxhgdFIMjZGjV7T4Sao5FeCO8cJQT3pkBixz3+E6
	F7SnmpmnRC+xCN0M9L1OTUOf2QUxCp988hTWMpoCdp4HsfwqZJ8CoulkLqa3mXYHcU/B4M
	PQFCxsTe1zkEOlZP/elNVyYm6I+3jvE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gRsqUZF2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=txhMkBUn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gRsqUZF2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=txhMkBUn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776090710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFbE6qgRyi3Tx/DuCsdhUHkiE4vb+Obr7lf3ABpgj0s=;
	b=HFHSkH9yvBupn5jy7XpoBN3CWZj2AiLbfVkJFrSHGpkShJuctz66WZ44cKHGNV3okfRs/D
	dK2rn455CbavAqLTnDl7ofL2aQ5b16dCMSKI4d2cx8uBvHW9Py1Sjfs3M54tRNRGpZ8LWp
	O7H10z0eHwlhiTSXpoiuie3oxuKK7rQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7BC36A8A9;
	Mon, 13 Apr 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776090708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFbE6qgRyi3Tx/DuCsdhUHkiE4vb+Obr7lf3ABpgj0s=;
	b=gRsqUZF2IJ8u/97AMVKL87wEa/JJ8cUvu4Soh44pE2wdx1IFOF6Sa4WsHBGoyEmPVO7BSC
	il61Th2+jyG4R6XD2DuRLdnVONQ9JZXCDbzaD90tKUghbN7AVMQxK0mn+qWWa4nOU6mTRM
	SYs1DOmqvMMpvV84KdBAX4TVRbKofd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776090708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFbE6qgRyi3Tx/DuCsdhUHkiE4vb+Obr7lf3ABpgj0s=;
	b=txhMkBUnJckYbNjRfjogV4sfoTnHQLesPlqKuImNzhqPCZGYy2AceXxP8HH8nE55TlXYTQ
	7Jj3znT9gRwhVICw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776090708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFbE6qgRyi3Tx/DuCsdhUHkiE4vb+Obr7lf3ABpgj0s=;
	b=gRsqUZF2IJ8u/97AMVKL87wEa/JJ8cUvu4Soh44pE2wdx1IFOF6Sa4WsHBGoyEmPVO7BSC
	il61Th2+jyG4R6XD2DuRLdnVONQ9JZXCDbzaD90tKUghbN7AVMQxK0mn+qWWa4nOU6mTRM
	SYs1DOmqvMMpvV84KdBAX4TVRbKofd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776090708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oFbE6qgRyi3Tx/DuCsdhUHkiE4vb+Obr7lf3ABpgj0s=;
	b=txhMkBUnJckYbNjRfjogV4sfoTnHQLesPlqKuImNzhqPCZGYy2AceXxP8HH8nE55TlXYTQ
	7Jj3znT9gRwhVICw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 798024AF25;
	Mon, 13 Apr 2026 14:31:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9tGRG1P+3Gl3BAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Apr 2026 14:31:47 +0000
Date: Mon, 13 Apr 2026 16:31:37 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 5/7] mm: Make /proc/pid/smaps use the new generic
 pagewalk API
Message-ID: <adz-SRhS7H50fWXY@localhost.localdomain>
References: <20260412174244.133715-6-osalvador@suse.de>
 <20260413141801.1465873-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413141801.1465873-1-usama.arif@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A887540015
X-Stat-Signature: kznup3g5ynhu8k7kohcm18zmhs5xqqxf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776090709-126120
X-HE-Meta: U2FsdGVkX1+TsAEix8NguIOSzjNyqFjJgd9lXTyBt/H1yNbPzgIJGLCa7axX+4DJGG5REdiJH3jtx/VN1LIpIudxLiRea+vbpZUeoWwpxRgsNUENH7NrQwh6PynR0PtMFKOChf/r6Y4WG8Cyelg4wsLbchc41biehbOEwUEZpPqTIWqBvlMf3FgTuLBoMl22ihk5ICikEuQAIsF2OZWqJdL0fnmesc7hzfM6ZdueOhHcPcCxP5NNVuk+y0lH9E80GzaKDdxF52LetRccWFSDieoU+HWWf7Qn50wQ4AlStAxXjo5Te1+BKAPaQmcgYrvJwJjqRbyZJ9eCHyQy7Aocc5TQa6TrEe0Yu/5/e9zwvHGsoe8mc0V/jTAS/c5sn7EoDs37B1JPwB5ZD4lQfEitBwPy/I8GRDZF+oh1iNveUWLfhW+Ufy2vFiInAYRml1SwJ93fadThNITQjOhbfgMJcO2GhocyYeUlb2jV11Tdpvp+caeHmX4mEjVxLFcy/ZdleeyS2Y0soC+GAZRo81V8oZmp1x4BUtE1QzXnRtmHyfaGmF1ubh/F69H8MnAByIqzp9PzR3QyF10F3sWnPuaen7LIhc0En3BxKi9I+Vn9SHYPrP5x+xaQdO7vnLwZVo2xw9CJ+y3YO7yYZYNjcmUQBgos0IUnUM36IwW+Eok3WMLFjZ5qPNYabdTe1pGF2Ke5E3WhauUfQ0vVhrsu28p1rgtrKnAnG32THBePBgDxbmdIOKF9ZB6mfRgY2s+hB1mpX58Y7duzG0IeE39n2Wl3+hQ4+O/cMOpdgFa5YkBq7rgrQ27ruwlDJ0TYcdLb61T7TeeksXOrU7mJKqg3IUQcce5qT0qLIGmH7xw2q6ZQWCp3yAx2wsueJug+5VXgRzBs2IgZJQZfJPcBxhsUX52Tr5aM4fFRYLZCh0VVfe5HKx1VH/kYH0qJ+vrgXgf30P/V9E8a6xoy7rppA7w/AWY
 12caqKUe
 SH1A69Ry5yQYHdyfloeoCyNV5avosN1Ik8KdiXF1OjgqfVtW0lXgcSG3kIdvhfe59v+ZXPeCcKYdZRyb76RH8oBWYx98qkZ+k+XhkcBzW/1lwj/Jxda4/C6MtyZT+EZcUl2GlENWMng+nrKcAxhhJkebaDbEfjxD7fvPn3nboMsdaeEtO16FZHTcuqadEesX49LwGIVCEayMTFNPeqcUWTFGNJsea0INjVWgfSFcgWXGSUOQG3SmKjNwsIb746Kh6H0GGtwK04j7G4OX851bSjvazOuKAxeVVF7J0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 07:18:00AM -0700, Usama Arif wrote:
 
> The old smap_gather_stats had special handling for shmem swap
> accounting.  For shared or readonly shmem mappings it used
> shmem_swap_usage() to efficiently account swapped-out shmem pages.
> For private writable shmem mappings it used smaps_pte_hole() via
> smaps_shmem_walk_ops to call shmem_partial_swap_usage() for each
> PTE hole.
> 
> The new code removes all of this.  The pt_range_walk API does not
> have pte_hole callbacks, so shmem pages that are swapped out (and
> thus have no PTE) would not be counted in the Swap field of smaps?

Yes, sorry, that is one of those parts which is incomplete.
I am already working on that offline, but did not have the time to
prepare it for this one.


-- 
Oscar Salvador
SUSE Labs

