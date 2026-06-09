Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C4ACD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAC56B0095; Tue,  9 Jun 2026 08:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2926B0098; Tue,  9 Jun 2026 08:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B624D6B0099; Tue,  9 Jun 2026 08:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3CB86B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:07:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 539D3A0540
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:07:26 +0000 (UTC)
X-FDA: 84860249292.17.47FCAA0
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F6AD20004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:07:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WZrwDR1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQV1qTMhPd4s+f85QfPCGgKH/8NH/n1/pSa26JOffws=;
	b=8KrMtJh9cLq2J/rEyMyDYK5zOuftDkEPSJzdiREuLfIJjcXDmPUx3QpDSIIwdAYXPW4g/6
	f2kJIU0RRiHVrK586QVBxcv8a2EAYO2PBp0cZ3ciXApofuiWylEDeJjZCXLAJcnJe2RREn
	GbSQ3Nf0RWuag6I8DqTziZTewyE2vxQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WZrwDR1d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781006844;
	b=acHQq6QgMFn3Mo00DPAOlqlWl0WrvnYOKS2Bcjf6WlgXV7hOfsS/bqQwXb8MDpStnaEKMS
	fV9eP3K3pjcACydlPVVubV3HaIKGlTCO8IwZIIgoB3x5y7HQ8fYy6ZPrzcOOTpTQKax9tY
	7QlQDY1PI+NvvAgnGupwZJjNJ5NbqPs=
Message-ID: <cff57120-f2b6-44ec-b4cf-b7d5d8637723@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781006843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQV1qTMhPd4s+f85QfPCGgKH/8NH/n1/pSa26JOffws=;
	b=WZrwDR1dbDAxxV3rcVSBtMHFC0p79DyleGzg3tzrI3PDp9bc98p5olVHu4Gyo+iSI3YUPy
	QhfFwYhx7YBdF6WxhgJs3ZHexNJuNQlDKm2JHuILHC+ERL2XwPCmO0Kvcpl5hORriOJx0b
	37tyfmeCWOwMbGalha94x4Wcsde3Gs0=
Date: Tue, 9 Jun 2026 20:06:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] Remove __folio_index again
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260601192626.150804-1-willy@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <20260601192626.150804-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8F6AD20004
X-Rspam-User: 
X-Stat-Signature: j16roewcpuqaaru15zsqs5cczkwpgyqm
X-Rspamd-Server: rspam09
X-HE-Tag: 1781006844-44754
X-HE-Meta: U2FsdGVkX1/9pCHwjzQ4PQvLmNGbasmRZ0TReSjN3JeT3ddUpLmzh4fCW9Z4mrM4qOEMsY34/ayV0H3hRKGZGSWMvOLN/KckiilWi64vZUXnlCM3qOUT3+g59eJQX+/Uj7fIKZmLUbnt806F8P1kQVCT5/oHyjZhaKAUsXh7utXfl8N0wyEkguxvU6AshbxIJdHTDAtcYByfii9gkj/nUP4Ggp4PC7YStTPNeFa923Gqkn8OKEeIZnvKL3ca/31SrdKdv7urfMyRMxxlr88E6tBl3Y2Q4kvAw1OGGb5hiikODeu+CA/39k7v2JpbJZEPSVOc20ftsWtFZh/OPXV9ah4yFqgnBF3lsF83zEmxq1cc61UW6dD+5AqZ0Cri3W6OWcfbssbCA91bVNbzJoXsbeL74ki8ieqGyceaU0W9dMBpfqsDoPhVNe+htNZzKihOz9N4USRHU89PySezR835acD92w9HRs2EnLju96SaUF5egqO6jiVIVubHXTDhcL1O9V3l6xAWNGLMh9nG9rD+EkNr9jP9kosGOeiFPdjlFtr+oIVuScx1ZvSIsFjRBtqKx6exm1Gi7XbvJknLxm6ckVD5AqnMDf0xQgZTKgxJfq2ePpRZQnUEjEIepg9iItZptc8daBPicso5cw+0KGvfgIU15UYowZbm06EAfpFo6mA46+gYP/TUDPXG14ZILcZSngrFqJ0KXqJwoHqsqb21D1QiszqLtVrEIGPhuEh1LjKsB3SkbX2v5lo64UXU8n9UW3Xprm4AJz/xUflO3omn8O2O7AymChGbGOANrycW5t/kqWu5NSIP751p80HYACuPfig1onae6MpgNwPx16FJqpHmZpRCJ4ykra9Y23pr8E0a2mMRyLhptQSpQt6SjH+44UaVwylpUWafC/JUIzJFXViDrcU1LDgpaBBYvEOvwBQz37/GwEDema/YTjazTA+ApishdsoxsB1BywRWtqx
 kGwbOBKo
 irrXK1imfQpKxS6vvQRXe8MjYGzTzNTyASpUssjDEqzvtZSHSwZaRRTxnZ3V3gLeALYo+IBXQ6jNhtVCIxGe2TtHqlcvjQ6Z1GYHg8DLenS1/9mOyydnw69CtZ4LqtMjYZv0xJ1Mt6op3JAQkh3umANXkRiHYKK8WSlp7pdlKXH4D65YBGIOvQ5uR4zlz8MEJzkniyu/uqAulUr6wkGOOS/Lj9f8wJy/D+7ZZQKF2XCkCdu6+6KpW+Zd99ik7p0+1PjyHGCHyI7zrYl6kUQTTt4U+vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/2 03:26, Matthew Wilcox (Oracle) 写道:
> I renamed page->index to page->__folio_index a year ago.  That proved to
> be insufficient to prevent people from using it, so take more extreme
> measures.  This breaks tools/mm/show_page_info.py (I expect) but since I
> don't know python and have no interest in running this script myself,
> I invite the author to fix it.
I am the maintainer of the show_page_info.py tool.
I've been quite busy lately, so I apologize for not replying in time.
I noticed that you have already fixed it in the v2 version,
and I have reviewed the change.
> Matthew Wilcox (Oracle) (3):
>   ntfs: Correct use of folios in handle_bounds_compressed_page()
>   ntfs: Remove references to page->__folio_index
>   mm: Remove __folio_index
>
>  fs/ntfs/compress.c       | 54 +++++++++++++++++-----------------------
>  include/linux/mm_types.h |  9 +++----
>  mm/zpdesc.h              |  2 --
>  3 files changed, 26 insertions(+), 39 deletions(-)
>
-- 
Thanks,
Ye Liu


