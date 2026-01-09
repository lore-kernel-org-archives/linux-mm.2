Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3318DD1A63D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999F16B0089; Fri,  9 Jan 2026 09:48:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9444E6B008A; Fri,  9 Jan 2026 09:48:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AFE6B008C; Fri,  9 Jan 2026 09:48:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72CC06B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:48:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47FBC13BFB1
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:48:33 +0000 (UTC)
X-FDA: 84312706506.11.063D20A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 95762140011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:48:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dc0VPada;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767970111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkpDtcytXRJ5VF1P7QvMO/C4aZ69Q4KgwNYNFnygtPs=;
	b=UNTeuEOiXBZbr06xf9zbrvmY8x7dMlL6pC3K5au18/lrztfuZQqV7DYdXgHFz8G3KvTzLt
	28iwg7jf5gwBK6BZMZNf1bz8x0lv631kbCJVBYyggFZeIbMyT7w+7wQ9q7EVi18702gB/Q
	N3PJyCRvGrwfwv9w9yZ5n9I0yW70WS0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dc0VPada;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767970111; a=rsa-sha256;
	cv=none;
	b=zCdc5Q2J7nBcwPixKs5zv1HJ6ftkRAiRZqAZu5XbgzHEtfpukvztQ5LpjjCfLGDFSC0y5r
	9WHRd6iz+t1Re5XJ/tUYx6FsvtRszyLE+QdhwHlNJWhW/QLbzrvKQPwlHNhonFBIExfzoS
	bWrh5UgsDMJ3Li+18cUY3v6Atf0+ynI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IkpDtcytXRJ5VF1P7QvMO/C4aZ69Q4KgwNYNFnygtPs=; b=dc0VPadacoegrEAG1vLpoxR2w1
	X1uzPW0SB5Xdm1mOy8AFkX2b4SNN6ypiTQUD2VZUDj9uV1byeNNZ97k+POvqMM/UYpqHlbhpNbjZO
	yt75Mvrpp9uUiwpEQA8D58F36YzzMIbFsm/zoGi4wleLLUoWbGcmz0gMCLlcg8YsDZzmYpxH+eaUs
	UqM/sOzfdb0Z5Y1sHXLlxDgSOL6LS47szHApRwNLNN/cuTThlpURTs5XxabpAdmRGe/3N4UbPEUvQ
	bfCEfx8NdbD0ekLvP8n10azCKv9L0Q7rTWM7OnbDfiGUio/ihvmOB+bH6UdJq53StVK2m5Ht8MHKD
	lAGgXZRQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veDmr-0000000GuoK-1HpU;
	Fri, 09 Jan 2026 14:48:25 +0000
Date: Fri, 9 Jan 2026 14:48:25 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] migrate: Replace RMP_ flags with TTU_ flags
Message-ID: <aWEVOWPhucKqZ8Ay@casper.infradead.org>
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-3-willy@infradead.org>
 <4b5b29ec-0629-4141-8022-8304e990bc64@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b5b29ec-0629-4141-8022-8304e990bc64@lucifer.local>
X-Rspamd-Queue-Id: 95762140011
X-Stat-Signature: ushq1sdwyu3mfxzpmzdagw9ujs78kny8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767970111-231726
X-HE-Meta: U2FsdGVkX1//6fdbwH2YRxbxKtmzJWoPjcJh5ZS7r1MR1UNfI/bueA88ZyoHFKgM6zmdtz3LDnc71sDDCfYqNupnsWc4pKufzK4TdHOpQ1CDP0lTyf4+NJIy6/uTYNh5AkNEFl1h42lbyvbWcvbv2vpW3dmL9U0iZf+jOVxOUas3XMDpG6ydGCANAF1igfWfoD9sC1rW00c5eCC6OKaOP4K25NM6A2Ocr/GE3j2QFFZR7bluW2t1oXV/0tK9vNXw9gxYzg9Qtux42xA0hO2inJUfCEHhBCrmE/zoqK5bE6fS+JHGmEONsriOCFhywuySYZPpl2MPTjS7rTJAnPt7dgJmC0kpNRZ/QwWwKc7RsbbCTBUE9/RTxdk44BQ3OMMvF4xcRsaBAfzVfZxHx0CmKBGJv1AksFf7jct/bsm64CcmHBkJHvl9kGwOWhCPDX6fRS8JhsL1s5OMyfHHGOKJS+/W3tdqukGv1NIDIr+kmQcLzBmOIGoVuea5qK4OdUpC8jeZIPCYWy7RCtXsFYStR/YYRVDAPe6XAnX/ZA8xtfTcanwaBVOWK7zMiS5Nc3rhW/VjJxzd3RPhMUEIaeD+smypfDsaj6NshxYuh0w2g7eEvpMsA5uTTsWRjUeCzHdoLxihYYpIUsqRMhxRDA+VanMt6XdTPc/1Gk4W9F3A1mNK+gbXJfCNiWYm0h72zl/GqL6LHkfGwxl8WyoNMnLq+QiPTnDPKOAXSvE+2lhCAdalcjhQ4DvA2h6vKIaiSqssGRbQxmUYC/Xx3hYytuw16yLkvHD8xYwlkw6vzSZiEEhyE+FsWlzehAJPo/0NfmAwlb2nACwquePl/JWN9KezO8evEr/jvhjhHXVVSigN06KLpf7RdoNjvswaGZOKAVbYgV4Qo6AGTS+L4nzWeDT5/Yp4DISXEBIQFkFUDXhI769N1xgme1O4q6j5Ba9Su4NMci3yzBsGLw7R0TV7HHs
 2u9jxsb+
 0v4vcR7LMTrIB9URqDbnB17oA6oLzLBFGjBYcTt/f0pwhMhhNAMa6+3KoEzNAV3D1X95D+pb//87l/VPIROj13Q0QuG2OxFEs3qJ/wiXyPC/Hy2jdgQXk8QeMmOHGQqmmTJbwUrIs+2n3yLr/a3URtQWghYlJ8KEhAxWJgJSkU/+pY162S/YudxFtMHsknY6M7YdocZCUYeNJLAcmZLMPUx3KEWhPHMpuQsbl+5xecOoRHYbka8pIP2eyPQBjWHC1BO2FdZXO8Wke1Mn61ULQAeIaEvPUKKBUY6vu3rhospuYcEYTZiyXG9/eFKWd8vHbD2GjZ1AtCkIuaBaebT8noLGp2DiG6R3FIfsv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 02:44:20PM +0000, Lorenzo Stoakes wrote:
> >  enum ttu_flags {
> > +	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */
> 
> Kinda weird we had 0x2 free :) I wonder why? Did we have flags here we removed I
> guess?

a98a2f0c8ce1
-       TTU_MIGRATION           = 0x1,  /* migration mode */

cd62734ca60d
-       TTU_MUNLOCK             = 0x2,  /* munlock mode */

732ed55823fc
+       TTU_SYNC                = 0x10, /* avoid racy checks with PVMW_SYNC */

013339df116c
-       TTU_IGNORE_ACCESS       = 0x10, /* don't age */

a128ca71fb29 did many changes all at once and I shan't attempt to
summarise


