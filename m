Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D170EC55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF606B007B; Sat,  1 Aug 2026 08:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9896E6B0088; Sat,  1 Aug 2026 08:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8533E6B008A; Sat,  1 Aug 2026 08:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B65C6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:46:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4EA280289
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:46:54 +0000 (UTC)
X-FDA: 85052675148.03.3CB0D0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FA8020006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:46:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqdQ0gEj;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785588413;
	b=ZJf+CvRwvvNm+JeBB3jxmdi57zFv2KbO1aQKB//ziykimChmguS6/nnnWsmFK5ku6OoYTW
	PpueJUq8RRj6gr1inKkPoXVQW4+HeEW2kKnR2mUan7bvMrHIJ0cvHr3JVeaB2AZvjPtric
	pBQ7L5nMHFiGY8olLgpO+Lnsl4/hkxM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqdQ0gEj;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785588413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkxXSTG3H//V9ns14rG4qN59j0AblwsWEwAmJcsn5lo=;
	b=nTyMUu5p7Iw3vta0WbXu9n2p+NfkrTxzOSTrW+E047KZ5kFyRrt66LHNSFTxlfmoQkdiX5
	dHFfSQFwUINu1iybpL0lgA6ge5kf+lmfRxwFTc7gCL4SCbQnzXhlV6vB7jFhumEZjb0gug
	pXbXIc4cGjDEpYOZCC+L9V+hu3R18tI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 44F3D4350E;
	Sat,  1 Aug 2026 12:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99A21F00AC4;
	Sat,  1 Aug 2026 12:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785588412;
	bh=FkxXSTG3H//V9ns14rG4qN59j0AblwsWEwAmJcsn5lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NqdQ0gEjqB7HERKuKpQmnPZaDGNbkB1jDYLk2t4C951COmRrMXdjq4R1JHuxfOyQZ
	 NSiT4zUzTR8xDpP4TrmxxbOP+3UI6gz37JXEaodgU9p44im+5xtwKhAO4ROLZEt6Fy
	 ZEFk5huLhtE2BPrmSvheETTa1q29dYvHKqhTXZ02VMXNEVnKHmKYRru7TIubaV/zpQ
	 rIdxK72V80+Ik7Z9Y83dqTpqNNOo5J+tUixSTOYDxX7617eZcYGMvX0axVRbyHUcp3
	 v7OvKtcPMLboYglTn+6iRpwbWegIE7gOkaLy11VZhMormeDdU/UGB7Ti6BFxzVKvy/
	 Os5/l3k+5yhtA==
Date: Sat, 1 Aug 2026 21:46:44 +0900
From: Harry Yoo <harry@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Hao Ge <hao.ge@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: [7.1.y 0/3] mm/slab: fix unbounded recursion in free path with
 memalloc profiling
Message-ID: <am3qEKonkiyEG_nE@thinkpad>
References: <20260801122533.319272-1-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801122533.319272-1-harry@kernel.org>
X-Stat-Signature: qgm1btqhom7sepqaxc45jpo1fzzmrt4r
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3FA8020006
X-Rspam-User: 
X-HE-Tag: 1785588413-343356
X-HE-Meta: U2FsdGVkX18eAJmkSFLtDfunHbFL3h2EcnmSL8yPZBCs3KGMVKQcnHlrLf7V6n63RygZkOf0F656gw2VDj0MiNTpJ1WYkFviWwGtJaPEThuQmf3xTqL97djVPLE5YXq0gC21jI5Ft0WosvXdYFoJAWXn2f5d4SAZgqg/eaH6wnKDkrUcuVFixOTsyyyIhWVsoeWnWluDMJJ544PkceLdPFPRk2RYQYyXV+86C5bSOBUUh7FXaowjhQY050r+ClNxp8B4mOvtoBZ8IBynfQVMdc3vQtjDmTzpkPbR13GAMgF6b1cXQkFLVWJ3sqxbcGp3wKm7DV+vzJwCf9wbM6YGb1nCBDWzjLdWlAh0mZVn1h80bHidfVWxlSJlpN67E7bt4jL/UsU7nPj0hc61Zy39zbIoitawEGjYucYe240vn+YqsUkymE2L7hCPDqAKOlVfEKKZXdQYWuPZPTExUOyAU+qlG9MzxY4F0HlGlBgfPyBxuIgY6z5cZBR7VEz3N/Vj0O6wCyiHCL/vfGIgScr0w5xP5ilvUS0VE2dMhhmOfcQjQ/GEoR/tkbBKEzvs3Eh7C23HLB3FyltkI4MfnjTwvEwoc7Tss6U28BjKAEzObMKpx2lb/uupC3CZLGsNc0iXpmt3TmPB2SPnlCIfohCqR275evTWyx7mTP2JlqmiF4pPc9bnH0nM9Hm4szds1fP7F+nfAN6G3oPFthWLEMvWJbrAJdWfl/fBZty0AO/wwFc5ISCp+CFkySTYxiY3BlOtLWclEJWGfmUn3LZ9ODZFctqJbWEcx4BNFZ+Av4kIXaqO6EmVIw1zmsAbq4vQLUpUqvcrkLI6FtafIOcIaWQHYi6hwLW/SHRm+sU8yxTQKdKTsRAvndBOlHo981EKvmZsYOtsueelvmv1pHFx9cyxt1sBg6s9BfdsIquRUIG80HBLqOfAamaYYdjtA1/Wz4eTuh/tDYL1k1X800AHN0u
 9e94naAA
 qsbwnzSCyx97LmAIKoXVoKUTLwDOSdgzX9d5NQCbMblRPi3aK1ZY4nSsECfSaNSDcOFToYbQwnQoeir81HZxJwXcx///yForyeACWHwhNek70DYs5DiKaufKge0WZoLcLjtfeWhSWSboulDFho/LZ+v8TgDC2xYw6sxaxpyk5Uz6CnJjMUAIsSObvcjC5hPvWM2ieelAUAwWbGUYO/AoMP51a5VudzBkBoUUnHTdy9CmVgVlS4QcLaKSAvtl0Ea2BxNadG27rmpc4pT+31i7iP1DI3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ouch, I did not add "PATCH" prefix by mistake.
Not sure if it makes stable maintainers life harder.

Fixes for 6.18 and 6.12 will be submitted over few days as I review
and test them.

On Sat, Aug 01, 2026 at 12:25:30PM +0000, Harry Yoo wrote:
> From: "Harry Yoo" <harry@kernel.org>
> 
> This is backport of "mm/slab: fix unbounded recursion in free path with
> memalloc profiling" series [1] for 7.1.
> 
> The last patch has a slight functional difference compared to mainline
> due to lack of SLAB_ALLOC_* flags. I described those subtlties in the
> backporting notes in detail.
> 
> [1] https://lore.kernel.org/all/20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org

Also, I did not include the first patch from [1]
(mm/slab: fix unbounded recursion in free path with memalloc profiling)
as it's already queued for 7.1.

> Harry Yoo (Oracle) (3):
>   mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
>   lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
>   mm/slab: prevent unbounded recursion in free path with new kmalloc
>     type
> 
>  include/linux/alloc_tag.h |  3 ++
>  include/linux/slab.h      | 19 +++++++-
>  lib/alloc_tag.c           |  9 ++++
>  mm/slab.h                 | 28 ++++++++++-
>  mm/slab_common.c          | 13 ++++++
>  mm/slub.c                 | 97 +++++++++++++++------------------------
>  6 files changed, 104 insertions(+), 65 deletions(-)
> 
> -- 
> 2.53.0

-- 
Cheers,
Harry / Hyeonggon

