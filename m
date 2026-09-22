Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31017C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193756B00AC; Tue, 22 Sep 2026 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143956B00AD; Tue, 22 Sep 2026 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0808D6B00AE; Tue, 22 Sep 2026 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC2FD6B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:14:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CB331403F4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:14:36 +0000 (UTC)
X-FDA: 85240686552.04.9CD6E48
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3C847140010
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:14:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BdpNALhd;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790064874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05lGqeR+0ZF0CP4Fq9knoYUiG/+6t0CLA1xk1HKeOK4=;
	b=lkrxGRRqqQt8WuE/2Np8VhTi3CRCFssCdJgfu2Y8y/mS8tTpbAoNb7Ow4bU0jzU7kQmQhv
	Htw346RCAr58JZZUenxUZHe4+l3Q7QIXEssyT+6uJC47ea0c8swLDpj5mNlbuUSByjSwa0
	a529EgykV7XknGJeEsMafSGh70DzL54=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BdpNALhd;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790064874;
	b=wcRYCXIA0QVQhUpnSaGdIwvNgPdGf/6jddYVNBt8SBLakQ3k5U+Mv8cCb2SF8HThPi2LWA
	tJ2dluC8eeD9pwtnrSTgDMDiwafL5EdGg6Tmn8WsinBAtb+LKOZvD11URmM4rilcnPl/Q/
	Ow4bAiT91iTLDTO2cu1bP/EJ+DGv/mo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J2i5GvjJ+wUOBpbMeil8dkAVf6eHV4FfangEdsKlF5o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790064873; v=1; x=1790669673;
 b=BdpNALhd4Xq72H0U13xGDLE2o4tCZFTlNFxRZ0RV+Y3w6reTkOcOxBJcuW8xV5K/M7OfmtDj
 359+6dseT0n9OgrcsJtw3C7MUkz2TmJCJFIcWBdFPwSkadiw/q8BirBltj+HGJWDS3/usPc9RvN
 d+jh8sl+IQiz9S/FbFA0o+ow=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ac6469190cc15d1a;
	Tue, 22 Sep 2026 08:14:32 +0000
X-Mizu-Trace-ID: ac6469190cc15d1a
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f419e8d-de07-48be-a69c-7b7b9d4a1cb7@linux.dev>
Date: Tue, 22 Sep 2026 16:14:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] powerpc/mm: make vmemmap_populate_compound_pages()
 static
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-6-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C847140010
X-Stat-Signature: ojq1g3kazooccprte418gpt4fxfcnh5a
X-Rspam-User: 
X-HE-Tag: 1790064874-939024
X-HE-Meta: U2FsdGVkX1+nlmYTS7wICQfGCKHKTs1j6sDazxUnkPTKUk2AcXqibWvTXQFHOnNzhTjmV3KqDJbmQcuyiV734A1OFgAh1rrSMqmq3SNEyECwZc6dt4ebb/E/0d54zAdAKDkXNzCP4DKqDVxkz4FxNN4likmiZy51O/Ed9fFZxKK0O22Wym+SqP9tAxHZm9beVEbatJ3UBs3TtxUb6Ra/wPBAjiDJVGe8380b3FslfQSV7ATGqX/3ic62j0tbfcech6LKBmCVkh73p9vEMilqxPXXzPtaFuZdNf27/E8vvOx7PWgwQZEIyw21qSMx5NpTxqVKa+MdxQnGDOE6VnlaRm/iQxxjG29mznBC+G7P9yPgYips03e7TWgOxel2JrT2Hm/tnrnGhHnb4Py2g+38KNngDjdDzyhVidTR0mw+Q8kx6F/yOhLBM4H0GRAYZSuk0kHo0WKFstDVXLOIp1GIgxk6Oka1HtJX23FHB++1UkXwRsvmZbzOYdKPFWz2j/OjSzoZtkC04nX6oRFx0AcRJFx2ciTx2gffpkzwHZ8PtAR9Pm6puUG7ceHUa2tuGV2oi7wdoRTJzRicEduNQ/EOCTZc9+0ekzTx1WwBHwF8GfFagNrTjzUfeGf5TP5nWQy9nHdej8Hu/NFATPIs17TMFL1mK0z3xhQdy/2eXG52s5PTGy25gM0xAMvxPZY9m7OWimtGyYTang+JP66IDGarkCXAzSLUZzsH7JpmukaIJCMstTbSAYCJ1sqoOrB7lOp5ms8FRIQAGy0TEc6H30Qg+QAnCM4CbPwPpDAIWLD5kb6kpPHuzzWIQtboVAWgpc5gywO9wSsHy7p2bm+ss09cUFZuoA0bFJLpbEiFXkQhH2Z7hYB6U1TU5dC0Ty83uJoDArS6Vg2l15BD00ISdQQ0CJpNlBEjIgDWxuTAw7PR+Vvf2IyCnkMxq1uIXlYiZpNbErpCgFy5HjbJGJXztll
 dgVAJYp4
 kS/oUKGTuNNCAdjqZSwRJCwuztLfZ6a7tfrhbe9Po7179xhaB15tjXcfP6WyEznMM5r22lO2Kf+typRsoCbUubFtbUa9I5BvUtwa8oj79TpZxp4zjIYXzvJFSaL+1wTRv83YbilX535O+1JHgITnsmZpm7B+o41vPMU9E6SJR4fmmh+AM+YKtoAg13ywU2Jxy/mWN9R/K+d0QDROTTeEL5ff/MXSUmdqBz/NCwxtzlDkMC9hkU2XtmJiUCubIAZLwrGANAMAOkJCJTOk2BNdW/Z8fWcukLl2hFRpKhtKN0Xhk5GVULkTafZ5tAnHTD+Sb2pP1y2d5Beabi4nX6EbSAjRVmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> vmemmap_populate_compound_pages() is no longer used outside
> radix_pgtable.c.
> 
> Make it static and drop the unused dev_pagemap argument from
> its only remaining caller to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
>   arch/powerpc/mm/book3s64/radix_pgtable.c   | 13 +++++++------
>   2 files changed, 7 insertions(+), 12 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


