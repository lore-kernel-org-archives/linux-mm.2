Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD34606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=idgeTM+1
Received: by kanga.kvack.org (Postfix)
	id 54A036B0B11; Fri, 23 Oct 2026 03:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FCA16B0B12; Fri, 23 Oct 2026 03:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410A26B0B13; Fri, 23 Oct 2026 03:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 27D536B0B11
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:33:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4891120198
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:33:14 +0000 (UTC)
X-FDA: 85353075108.09.78FBBC3
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf11.hostedemail.com (Postfix) with ESMTP id A31DF40006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:33:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=idgeTM+1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792740792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCPeXdVtsAIGZmNIgcd/gdVcV03xEPsGBvi1mGdnz00=;
	b=v0JaL374hJ7LultDUzMLcn788QCjQte6vBmvOKKWfpNbCmDFCqWsltmwlTkXN2w/XEmIVX
	XsvNw8Uivuvky/mRMfH0WHH62LnIgjAaUhl5IHptiW2k6Kn7xJGRw72jvpqJRCj0VxsREz
	7wmLklrrQtUEGgp2YmoScE5Y5J5dLUk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=idgeTM+1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792740792;
	b=zSE2FdFDI3xmtrN8Uk0RMOZkvXZTTcB9TmTTXsuT3kK5M5kEVvFeo6utVywm6JbVxaVgU0
	VxTCVTeSHuCcSMasHo7tewIEKZ8X08s98IimO+0a56Re7peYrDoY++gbRWtv6DhqRG2qel
	rJtgib98JWqZzgOnZNBS4w/M8cZMv6Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0k5lukGRbTSNqdymG8Q7jy3MBEvP6PLNPDsNCvsgCNU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792740791; v=1; x=1793345591;
 b=idgeTM+1LCkjAbPmUEPvzrzw/moA6TayFIoBDO7hqGVN2Nhzi0H4kg/JReqrOzFs2OgGrddu
 0AZl1bx1HXEL+DsXJFXxEXbjS4EA22cWV7GAkLu49SElOXezmuTcThQB2kcyB92wxeba85DG+fJ
 yHGYXcILWEdbzuBQeT4UgwOs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0fec9d0276b536b5;
	Fri, 23 Oct 2026 07:33:10 +0000
X-Mizu-Trace-ID: 0fec9d0276b536b5
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Fri, 23 Oct 2026 15:33:03 +0800
Message-ID: <20261023073303.66682-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-11-songmuchun@bytedance.com>
References: <20261020115824.823278-11-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A31DF40006
X-Stat-Signature: rbcoxkci6kn45rn7yfc1iau5ug4gcpkk
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792740792-156365
X-HE-Meta: U2FsdGVkX18CEKV0bMVnboe5qDVm4lqE9B3546dnSL1d2BS+AK8tt6+6Oe7J4HaWt9WpXEaSoUl7u5O+1MQZlOyaDYPrKDIvzU2Kw9vRIEShnAZQ+8elqUJH3ko+FqqyYNVz48z+9HBW59uJigBH+3OdVpAIFRRvaUk5U9VeyKWmYH4H8uXN76n+topM5ckAuJZe/ThgN0JKcoZ1etRJIsAiOnP/r0uTb3P3aACvOV36Bra3O/IbV4cujm6ZZFtzsJneTSg1pKgeYUbHUHv0zUuiC0XbEiPRW5IeUKQTaw4xFs26UDdvy3LEcrt9VIr9962RCklPF8QxGB49pxWwSIsM7QkPB+bhyCF2rexdhSQhKnL4yIiRb96JW44lBMVmBAAqEI9jEk7JyZVq3CYV92pi+PhIdilTfv/6sXHGyGbWloK1n2iCVSMnDZZvHYqUfA4fY4LZzq6YXa6EhrGAlt0D5AmLjq0LjiFIv/RdxNzpjrWjI9Vm9/OlM2bLljRdZnEpV7OUKjHxqkljXPuWCnETq3il3Gx0ITbU9bgbv0UACPngSkG3SujQf6KBdVJjjFQFTC0Pyu1wlQF7gl7jy6VtcZjbJwcoIN8sR+ioCdcanyxjHAD8GBJMkhGF3vMs0iH9H8mTkonBt9wdvM30cpkgah+FQ7Qg6qPIai13ilt/muBPdunPh1Uu6QjK/YSj61FUGigaQbGnKqDk0nmmBCBJAiSAuAKFvFb7hQ7BJx4/QYQeViEzZmc3Ws9p8DsJZI9kTYzH8O5KTLP4ylKOTb29L3rybmQC0rZdxkzKPpu6/5fAMwtiEjRuTlB5pIE9nJ/GqprlC/ZNw5nmtOcK6RjBdwjalgE9HPN27EHeYQhUR4vw7YYtzZeZIcqz/1+EPSCTEbgNkcwEeq8LES2i/XPN4BYJrxkuvNkpk5zIKIgxujc9PEWEhtQ+jwmyjtiBu269osbXadlt2uLZwyH
 j8Rfo9On
 S7/dXu19T/UIIRC29X+hCbDiTIN9ggH3BHIZSYOoYfSDBGyxUFJHa10Pvv1heff/vyBwEEPPFWCkFuVCF7kF8xnnfwV2Dc8PFK0I3qgpwFBvj95MuLYjO0ZkImfy5vPEGGrDeY/IlbU1y0/QFC2q+V2vTlUcqoMyYSlVW18k8XpV4kDDlVtwSQS7ZbZbRiTU2SygcrK8M0TQbOL8+Kn+QUyjEYa+3j7XEAyHG4rVL3FL+xo+Q7g5GadGjoHozcY6LxaEEjCBiCSFjlGNHJsZWXdUyiWlI9JngMz0xfcrCVAuV8MUsCpnv2LoQ4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:24PM +0800, Muchun Song wrote:
>Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
>operation, but the current interface exposes a raw address range and
>hardcodes deferred TLB flushing.  This splits the common mechanism
>across layers and couples it to the HugeTLB batching policy.
>
>Make the folio the unit of PTE conversion and let callers select the TLB
>flush policy through the folio-oriented interface.  This keeps
>HugeTLB-specific eligibility and batching outside the common operation.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

