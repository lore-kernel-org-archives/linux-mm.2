Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95001FEEF44
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC1A6B0088; Tue,  7 Apr 2026 09:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CD96B0089; Tue,  7 Apr 2026 09:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72866B008A; Tue,  7 Apr 2026 09:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B124B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:40:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E12BBB412
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:40:34 +0000 (UTC)
X-FDA: 84631869588.04.92D372B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EDB2C0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:40:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u0Sno2dd;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775569233; a=rsa-sha256;
	cv=none;
	b=GT3JtOSQP5xAgaWS1CDpa4+7zWDQ/88f5KTRPujd0okUF2Wjje0TMWjWr+BB/LhIkXyI37
	2F82CgCn2j7OiY51U7cElB8nWdRWyMb+FNujcYD6rPnwMgIQw2rvW3uzFMARiIPa2mXwWF
	BQSyaRSLDWUOXkSF/yOZB9ZJG4F+Dbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775569233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuxSZ5DXz8fu1kIf9zg6mcgh1utxKsYfdHwjn+bP9QU=;
	b=BRoZhk6mjtqDEmA//Y+tG36MkX0TWgaeoEc6pSsrt7zY6KKhC4j6V0ZnnvTqhX79oShtB0
	lmO1Xqfs4H7LaKnObQ/LkI1XFrK8O0VbkJ+2XPTWclomj/6nRCFWh2NCt5/NvzuDfJB/YG
	b+WOPlw0XOQQ/PWHUCp3zsovH0kF8P0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u0Sno2dd;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XuxSZ5DXz8fu1kIf9zg6mcgh1utxKsYfdHwjn+bP9QU=; b=u0Sno2dd2/vBjVdkCrCSFH2n8p
	r4kzR11O6GbCYhkuSOEL36COn9L+PV8e0cvcLsaxJrI2EV4QvEcwpp59JAPn9JJA831IkeUWaovWO
	OSbxM3aOpPR1M+CdepxPY50sleE61PT+vNcqPiF3ky2POo/4XB5YqTJkF/7Y7THjCE+X/+Q+5umQD
	PJzH34pU6W6RdzgruKgEKd7c6kxvu2pkmbrUS7CxJ7AnoyCFJIwt9CaAtXS54+BFRgxzQICzMFQkB
	bGjTVPrwBL7coG9MZ2WrjmEsRml/lIv8WIuKu3Cb2PDSWrW10sbGgkOuG0/rDaCnflxKgTiagUFvH
	2AgKlhiQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA6f9-00000003gNx-0OOJ;
	Tue, 07 Apr 2026 13:40:15 +0000
Date: Tue, 7 Apr 2026 14:40:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@suse.com, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, baohua@kernel.org, bhe@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
Message-ID: <adUJPnyKp5xDgJBa@casper.infradead.org>
References: <20260407110002.204755-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407110002.204755-1-wujianyue000@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0EDB2C0009
X-Stat-Signature: un6xzw54u65f43ba4dj3dne9qzngmsjc
X-HE-Tag: 1775569231-369678
X-HE-Meta: U2FsdGVkX1+TpG001Ib797K02eewYCUskN1TOICQKkdRp75RDB6qwuiF9owMogCDRGUqeTq9IYOOHZhGI8X+KV2z6FvYusBbOzh0bNaP2S+N87mZC4pt7xZDByBwvaElH/eOtuOhs5zRZr43nm0YgOjtVFmR6m0ZUd8r3Qi4JcvWv248AuPEdKShJOHO+5npTljN8MZMYlSvD4UhzcjPHqhDDhZXUDfZ57r8Dgr6qQBvCJWEhuPEhbmcslinC12kAvneF3B50lMN/ZzAbzGRNc2saskQ6swa8bVv+Js3XyscDIJJ1ujUKNdvAV2WbaNU9nEy2qwjJd4mSfJAkEDCcnB6n/nTxSs8VxbFjM4qg19n9wRHvH+J3kBgineKOTqdHPnfJiODjAGoEFhVdeA9TFNaA5AlQm1NoRQmMYPswmal5mK8IRkCreFdrY/zGh2I9Qn4aOjXUq3oA1fFg6cN3eTVk+6GKZ6YTUAerE1P36x1TRln4xAFCXgG4fP9o6FJZTBsaPTz30BUSNTxQiyBBpRISwQk5nt1z0Kb9qn7fbPWN4QDeZS9Sq/QmXrlVW+0krh/Q7Cnga0sqxZgpRP5Edmr+XCERi9kJzW1LPPDasWY8fFmfTfOMDk2H+SIo5JzgAF+1/N1RW4ubbPjSs2uMgwKt3e0yQ4hrRRo1CP2w6Nd76zX4175+yX8wsyGr8gXiRBe7T6g6aL/ZKEMHvDg1HRU6iUfUh9JSDIs69rkIjBH5PwXYsOE235Y8offSK42yi0OEkJVqFNnAGpHEtcw3K7EJhRQlU0o+E6NZeNajhZn0FW8dURZX5kTMdkKh8udSJ/F+kOSBgFFus6hy2hjX9Yzh+H0LUpvYgB3/e//WrVU2pYg3Hk2/2Of0ZP4ApMdp97BHQNodX9BVnugc/A5KsduTNocnUC78vWcZS5w5hQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> +++ b/include/linux/mm.h
> @@ -39,6 +39,8 @@
>  #include <linux/bitops.h>
>  #include <linux/iommu-debug-pagealloc.h>
> 
> +#include "../../mm/folio_lru.h"

This is enough to reject this patch.

I don't think the patch is a good idea either.  Yes, the current
situation is messy, but you're not improving things by moving it to its
own file.

