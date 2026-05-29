Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852BDCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC106B0088; Fri, 29 May 2026 09:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D0F6B008C; Fri, 29 May 2026 09:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73976B0092; Fri, 29 May 2026 09:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91B2B6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:50:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 360FE140153
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:50:53 +0000 (UTC)
X-FDA: 84820593186.30.B65AA92
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id 58D414001A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:50:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780062651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QxObCDqwdzsXfGv0yovWRpi2Fn0wu98spK1+/Ye9D0o=;
	b=nVFjn+yd2BuzrR7t/Zvk04b2jqAal7z8RhzBBQPPbDGruykSgtJjQdjOniES7JLqUCKW6T
	Romt7FbrylnXVlGeh+U/6EZWN1xDtviHVrq7hQBnrybaeLHkEAVbey828en/N1uQfV0EXr
	PN5NKhLMJ9Vwl8QCQukwQHlaaCsOZ8c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780062651; a=rsa-sha256;
	cv=none;
	b=EiH8oh3yKBSFUHyEqzasQBRuvGSL/RqwzyTQx2FhLRBsIqKFMbTXEEP9T+mEclkMKwHdSU
	ru+oT4Vh0DrqRz/AyNH3uSLzzbN+tFVU2ijNowASIUXXnz/6nHpr31uYEh5LbTuQhJfzgm
	EhttGDB2MK/BD3jotGDmilVpw82mHkk=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 08F5568B05; Fri, 29 May 2026 15:50:46 +0200 (CEST)
Date: Fri, 29 May 2026 15:50:45 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <20260529135045.GA10647@lst.de>
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de> <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58D414001A
X-Stat-Signature: wyhumw4xe4shwyqx11wbqxwidfsep6mb
X-HE-Tag: 1780062651-598649
X-HE-Meta: U2FsdGVkX19MTQNJYqB7/WqQAw3cmwCk+9wLGR1RwMNvS8/L2i++dxctX2FXL4EF4s4rpxp+FGCq1SVRnF+5Qo1K2CrFu0tpMqEJUKObYvLqXMM6TT0hXs7NlUnt5dz4Q77Bn7TQN3DH1pDc/3bqas8kXByhLJ9AEYLsGQg4s/Nfu/F8XXvIdyK5rmyS0jguI8/FCo4XYBir/po8YIlR7N3IvtWJBZWJSwILNI++jgYVuzHRqxMJ34cIHhqFYcRuPY2Z0oicXasDdWt1sBkQ2qus0gG9BMzvNCEJTqTBPA6ULhe/1w7f2iKxnSq3tXas1jLUNnYZaWCswzHjkZO5ButZtVWMjStg2DCLAFH3eIdqx79njYHw4d0gVoQWdYIEcghTZNfjIv04J5x66aHihPDeQJlsXJPnleKHRJiqBkjngV56sQ/gq/SG+ZbhCjGuJG8XuCTAA4O6fsaJkqZ19v0rpBTupzfjyDcG9xYp2zi7u5+jAHPZBjFDSlApFfcJi95tRQxSZbzd4CmaqP7ZOTCxq0w6LnfP5X9grbfaDnbgz0V2HMK33NLvugUlzWj9MKloL9XMEU6RdwoHWD0Lnage3lA+ylkT+B+fJy6J5ez2YfEfAEEuXVVPdc2E1PLvF3jSfJXc2KDp9VOECOdNDa28opTOKiNHOgtV9E+nrzXFJbw89/+p9LeID2YKp8/8WtdiGCDsdAWg/+jdZ+B/wvpEAJcNNIGafNEDdCKDLJq5Ok4ebN/WHJbven41wMaQ1Joia/xVxXKMmRRZfz2mu341izQCVhGPRD73uUwqq959B8ZQoy0bDkLhtkwakwrqBGccf+GZnakO9ZTUd/w/RfJ4bCep/xV+ou5D39rGGo/0iYfLCtOCwlIDOpa9wK8jH2YZCElMupSw1N6vVYBxDglYf3LazoggyGJbxDAo/Azy7m0q1nkkRZG5lKRUUmFYdELCgtI7bN0dQxoRa9J
 cnHoKWGk
 CIck/BGGaN9WnQHAXYV8nO1VWZNsBxM4BQnPhqOCr6C3eWn+qfyke4NKksnAompfd3PVTkSktK1SRSyA2NZ++QRLXyiGlD4w+nF0A1OJbkhOQYAsHqnfvReIG4cngZvdy/9hCj0eFhECN8LA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrote:
> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for-next
> (it's still yankable in case of issues)
> 
> Did some fixups below (the comment was stale prior to the patch; restored
> unlikely(), simplified one line).
> 
> A test merge into yesterday's -next found a conflict in drivers/gpu/drm/
> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the changed
> codeto a new function panthor_vm_op_ctx_prealloc_pts().
> But it's solvable so no need for a complicated coordination I think.

Ok, thanks.  The two Sashiko complains also look like they had merrits,
but I won't get to looking into them until Monday.

Your fixups look good to me.

