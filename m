Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C60CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1276B008A; Thu, 18 Jun 2026 10:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AD66B008C; Thu, 18 Jun 2026 10:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12316B0092; Thu, 18 Jun 2026 10:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A04326B008A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:10:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C8A41A00C5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:10:52 +0000 (UTC)
X-FDA: 84893219544.29.BD4BB98
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4CC8D4001A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:10:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IfYIYKU2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781791850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yEL3vTDX3RN/4Op4vWPybqIcJPUjup3Ov++9PioHs+A=;
	b=pQl5zrwjz4E7goINN+6rXjYkSnEiQsI8Qy3Cz695CM7BReaV9aatQxuAVBGCGtgW/u3yot
	QavDx8ifiTSaeIelC7KMgkl9klvKrKJe8b6ppPaAbw182xdNr32LRD8dlkokEjxYuGTcRt
	cQLedQPL23zm8n48cyijDg3dFWz4TgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781791850;
	b=xZ5zQGx2hDLWtO9uU6FlXzyVkL9268hlVMBZYVZyl7wbE9F+l4Zw2S7XoMXgw6Sm7SsUD7
	bT34k1v5+ant0tHEeyTQ+LqKfahT22mVhfv1OwCb9U0H+WiFKpvssG5aKRFNpwwK+C0uJ5
	bdkKt39pPFB+iUBN67WyT9LGCdF5kZ8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=IfYIYKU2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf04.hostedemail.com: domain of BATV+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d0115506b4e64763d629+8334+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yEL3vTDX3RN/4Op4vWPybqIcJPUjup3Ov++9PioHs+A=; b=IfYIYKU2ALGIFRhPuheYA7hAId
	aJEqQ76FJ/aKk2bhvAJ6Q1jmT0wFhi8rZKpfUT9sQlVZT0JQ837VKnmpIJQOHYfLO4aPxXk8MQ/Pt
	v9LOcM9No1/NQkLT6bt71v9Pj3HA5DYr/HoG7u4wBjGDjdmFUEqs+TtZZ59fDqDDae5pWigUIoCl1
	n3/pfBXWpxmW0Bh+sfzJhP8osf4ec8D3APKmfAA/g/OiCPGuPqmNIl6jkr+qL/APKC+ODnhZq3ggI
	kWLYMqW0WKv4+eEtRx8Ln2HU9Nvd0AyRzFN/Nb4CJwHy4C/bZ60UmSk5py88LvCkvM0Rz504q2XWt
	0/U0Tcaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waDS9-00000001Plj-2kRI;
	Thu, 18 Jun 2026 14:10:45 +0000
Date: Thu, 18 Jun 2026 07:10:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Trond Myklebust <trondmy@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Anna Schumaker <anna@kernel.org>,
	Shivaji Kant <shivajikant@google.com>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] nfs: Optimize direct I/O to use folios for
 requests
Message-ID: <ajP8ZTTLYkICFTO_@infradead.org>
References: <20260616134000.2733403-1-praan@google.com>
 <20260616134000.2733403-7-praan@google.com>
 <7ee3bcfdd6126c93cbb1c219bf601182b95c10d9.camel@kernel.org>
 <ajGGpDvzZdkGtSbN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGGpDvzZdkGtSbN@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 4CC8D4001A
X-Stat-Signature: gf5kxa5cat1iu5e9i4hhsxqx6fybukkd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781791849-483711
X-HE-Meta: U2FsdGVkX181Fu/5KeHImeiQtne1yaNhmjedpb/v+wdZfGgMI66bZVgg9KTCkA+8+sV3BWiD7h4n5ZehjZkNzZWVbQF6YqpbjMzzdQ/fbUG6Ro29h1wGHBesY//kyENilprKmyol4EKN/jZyLtNO+woay/u71Ca5TjIUPizxFgobyr+qSDEmHhYBgDKbnYNO/ThJrlIVmuuQOBw3I5+kH5heRFGJHTnZqvrrWoCuj1SpT2zo5nRy3vDibbPBU/LcgV++Jh6RcHsNcKIeL1EFpasf0PuS68yUPzqKmrhluPSn3Hga1ToJzi9fJnuNqbTS3p3fFgeDguGCcCI7Bjv6z7WyY6mdL0kYXYvTU0UXgSztfXiPNxRB+J3mubU5NUv3gCtvDWArZvvkB3ZAAA1P7OcsGSGhM0tKQfLV9SPyzlE0/vllU0TXxC3T5XlVhK5ljeONdaMdX5z+x1guEKDgcB4twiyXWimw/6UnySUDwKAp8zCcRv+ErGnciH4DoQofhcpfKSbIMWZu6VLSZQKhai8Mh/XIKnPfFn7AQffIxZY5flzWn16qWE8v2EyC3Iz3IjmkZJf3Cb7pISFJqsoE2lC7UHu8V9AQ2dmNY0Yrep4rI1STI9jLm7ioPcjrbdnxg/0gKMV6VWBTocSYxDJIBdo5gW4cQWftpJEXNCOcCRFuJD7+fCO1TBza4p5MjisQVad7VmEZl4jBnRWvVIPFlTdWcOKY0/ngaUth1SKbo5mVPAl6VY+gNR6gyEd3pg0bIvVhTI97aR2/myUBrchwMHZctoP2hL6+Di+REk9qXJsF3plu57qGguIskSDJ4imND0X8p6ZCMFQTD4ozmvD92zhx0Q7S8oiTvTT619NQwiXhVW/XLPI/SgqEIoGhdpyBDY1OJJwy8RfH+fa94xN8SHtZ1A4Zije+4ugmmYwuSnNdhKaMFKYfLvw6muIupyVKl0j3KKL6dQqxrpn5Nk6
 T+7WuJul
 kTfgy3Z5Ao2To/NfJL5hbUXQAv/Q39/KFvcrC7fexNQI44M4I/V7ueOK7u0xmIbIaLPmNM2etJBYhYQSDgRl77sTWUWeqB1+a6kyIlh0xtMfKuh/oBt9BEo6wZrNgEcOL+yoCr3Tvmkx0M2sRjxkVEnpKfB7powITcUD9ck97KHvvrse8FBq07BoiIBfZ+UYm1DvUvOKA4adm0pItK502jq+dCqzHjESu2M65FbCMH/ZlTeAPmdI2XPKsZ24edUrip6KUvlFuWOEe6MU5GoP6H4NLyub/JIyW69OhlDpJcY4b/rRy5XmyAwYMn/3K/WqE6QOF8+aj7tbPY5p+a/tYz2Yxt4tGokyCM5TJf1CaBCKVF1hlVof2f2kox+/ucXId3DUL6WfrdrpaJ/7AsdVmfdjtWp8VjboEBQihB1eJ7XEUzzbA41r1zeBa37GEh3ODHteozg/PK/0uAP+r+BCfuIm4PBvgJlpJ5lQRZwf0eWXfudqcpoWpH3dNQVCNIzcrc1xfwxq4zzuFo5IuHG63KG/aASJxFMFBTbea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 05:23:48PM +0000, Pranjal Shrivastava wrote:
> AFAIU, the MM subsystem explicitly ensures that every valid struct page
> is part of a folio.

It is definitively not what the vision for the folio is, although if
I'm not mistaken it actually is still true right now.  This whole
area is a minefield unfortunately, and we also ran into it with
iov_iter_extract_bvecs and the earlier block code it was extracted
from.  Adding the relevant people and lists, but for now your best
bet is to stick to what the block code does or even better reuse
as much as possible of that code.


