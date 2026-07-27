Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C51C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 20:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8564A6B008C; Mon, 27 Jul 2026 16:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D5D6B0093; Mon, 27 Jul 2026 16:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76B206B0095; Mon, 27 Jul 2026 16:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE8A6B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:28:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C53951C013F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:28:04 +0000 (UTC)
X-FDA: 85035693288.19.6AE61DA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86F221C000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 20:28:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iuw6Pkpt;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785184082;
	b=c3XoDZ3eC8OC27BGWNkgzYzmhpIYewjj3ccJL+2tsJnEMRRUarfnseAygEd6mZAQg+j7jK
	EbvceU/Pc2NB925H17Lpn3mmmQXLdnPiuX3qgkQs68FedAbbF4p3svztdnUF5blMfuY01W
	fPmVwLBJWhol7eSnJg1U6OdPN6VeVH8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iuw6Pkpt;
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785184082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C798dAa8fw/QYuryBKFnwSYvO0o2tExwKWEloLNlk4k=;
	b=j71Cp+lmBqtzE0bLNnZeQttsU4DWg1PoBEeFVRNbIE/eQ5e1TiUjS1F8l4KamGnL5YZ94a
	ebSgAJNFeNvuGrwutI/EKaz22B5lPrn2QUtR1dlKF8ep3zwT0nC0tteXQhuAEd+za0Yjx5
	FhJqGUGYISUYkHiGdVJwxJn3Jzcnmew=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C798dAa8fw/QYuryBKFnwSYvO0o2tExwKWEloLNlk4k=; b=iuw6Pkpt/Riscm6bIYyF1Pg/fA
	20IED5i22Z4fUJhPAxkUChEfggKUFosybNALvSvNa3iFaYo1CD0P/7hlQoUdCV5XKCFw/2Mp7iTy8
	311VJxGtq5jQpOd+L4qJ+XffqjEWZoDN8TgWbyfmoO0YzNJ5T34sjxYBQV2sr5c/87D9Md3stPV+4
	ZC8nl8VbTfQ5rn+uu3g1k0q6mszgqzHAo18ivmSm3322kYCTDj5m0aBhZJz2F1TUlw3LoVaUuxOmz
	p2nfmP5vfuEPFC4HBX8I2OyHVpuOD4+LAclEE8Zv/BEhZiGD4L2p8PRP2ECSTdcgFeqs2hnTnzWAh
	EQi3jJRA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woRva-0000000BOw3-348l;
	Mon, 27 Jul 2026 20:27:59 +0000
Date: Mon, 27 Jul 2026 21:27:58 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v6 00/12] Use generic_file_read_iter() in hugetlbfs
Message-ID: <ame_ToR5rr3m9x6V@casper.infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
X-Stat-Signature: y11xa19kf3gnxh559k6qh5833ww1citr
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 86F221C000E
X-Rspam-User: 
X-HE-Tag: 1785184082-687752
X-HE-Meta: U2FsdGVkX19u3OWrmOFQXKkScEH5Mrjr1yJ+buZP0vQkLHS+atzkfzhfT6Wt42xInqjXUlpeZBDMYmmi5ZbXc8o6iLKupyCh3plhRDxZ6axKyiWuSUzslgwtqQxu393dhrGK904ynC+P4WrzX5XueiH7FO1ALeNfP4xT1BKltSF/QPFaI+cTwpyYLfQuo7VbMfgG/C1fXp5loq8bE5FsHhgsLD9GvOkUoAL3pkPEEiuwWUsrcoQrsvbkMg0gpZbO0adEWeYZd8OIjHsq15cn8QLgdqAANaYzYG7fTegLT6Lyug7xbPTYWUQSPCHVz+8wwd94CUARHia7PfPKwfbVv9j8ECrixYRMkBey/GG/CXuJm8wGzeUWJWst2xNhRlNjdI3G+l5w+IvVqolQdn798KkICb+5Dc2YBpxxnbeRjXEsRLTWcquK9vKS+ySfGnjaD2G0tCKMVApYJdEBbVV3wzJUPn+fivm59/HLLDrSufa7lHX4DIwTLbzhr8WehU18yFU/k38Ii13LdkepVddz/g5ZWUBvWgb+uPpsV04c53vJ4KNKs09L+mvkXAQf8fQTNQuuqo3yfu5NML6pfLRi2lboSvb4vUrpbGUh4FNhnlMTtiEDmin2YGMNNUs+9+jXu9Q2fbILSDO8P3ywCSEAb22DKZ949pXDTK3UxYAjIcn8a2EBV27y4pBlNGBbuThooQqQQAy2SRMNbWaLMgt3YW3DiPr7mcnVrrrPoIoOLQr8wWgvyDViwaqzvadUtQhm/mYHoaaFPik8L7TLxwXI4M0hMhT6N2BBR8rglEzIVOB9oFtFS9YcEa5frqUsW6taV0bRHiqY9ZEClAH36QvH+kFXmkxPn06bvpo0/VBwLj2BmKVhcUMUuTeu7zUXg+aMZP5nMqpUdKX8NOBvT7zPliIJPx/cd6hw3IJ9Z4dq/7Uy2+42I/4oC28nXT0tDwrBxY5OWwj2V7PDFHEVYmc
 LYrw+6og
 oxZsuTROrCbIZVa9Ew9oISrkixr0lHaRvLHKcTlg3tq5QoPWQPs7MtNCO8FESOc0aF/+r1i2tsrgDmI92BNTYG5AbU4Ge4DiZuFDwz2twstJMs5aVMtEatpwKbs6PGolZgcN/Ax3vSjFXXyC/nqHBqgEvvc+vkRlbjXT223uyB8M1nLGa9X9E0825lf1Bv9jIRxMjpc2HUBUeOJWI1CXb3h9pjbdUFG1cSo755DP8AFFYpNs1G28Dhhvv/ntaKoZT6NLF14hCtR3qUN6undr9Jc91+Sj0g7RgReU3Ax+HFhiZFj+lhrFjHGNTNgR54IFHtIDKBMuG8l7K7G9r7TIYHJQ5aTr3QxiIiQq7kK+b0YvhOPFP43H3GaB4xThF5txbtIHFWFzfFxGu/btNBJd/9SsB89WgvI+YuQ6o0jG+iz9RVvr3ft0j/VPMpJ8aRqpaCbVM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:12:56PM +0100, Matthew Wilcox (Oracle) wrote:
> This set of patches are separated out from Jane's earlier series.
> https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
> 
> We need three things to use filemap_read_iter() instead of a hugetlbfs
> specific read_iter: hwpoison handling, treating gaps in the pagecache as
> holes, and having hugetlb set the folio size in the mapping.  hwopison
> handling turned out to need a lot of prep work; the other two things
> are fairly straightforward.
> 
> Sashiko complains that the implementation of AS_AUTHORITATIVE is
> incomplete, but hugetlbfs doesn't use any of that functionality.
> We'll add it when we need it, either when hugetlbfs uses it, or when we
> convert shmem to use filemap.

OK, down to two Sashiko reports that I think are real.  I sent diffs
in replies to this thread.  I'll give the meatbags 24 hours to look
before I post a v7.

