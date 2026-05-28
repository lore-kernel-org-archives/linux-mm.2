Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24AD0CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8810A6B0005; Thu, 28 May 2026 08:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858D46B0088; Thu, 28 May 2026 08:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795C46B008A; Thu, 28 May 2026 08:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 686CB6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:49:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2744A91C34
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:49:46 +0000 (UTC)
X-FDA: 84816810372.06.ED0DF7C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 90DBA1C000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:49:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AcBo2kFB;
	spf=none (imf21.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7G6U2FOW7FeLuMO+G3YOi7XP6zPp5DB5XZz1vAGJDdM=;
	b=1r6tYPC37GKo3KH3Du18qYtgCmgLIYiKbqDf9PqchDQT5h94eTDmYR/uoz7aez/JbDeEOm
	cjCyQnvdUYmn396cbdV0KmqXBz7d3nFugVmmB3EioxmuiljQXj/Awg001pmdGr+Jp6Qi63
	B10aNZP7pHFiQJjnL5DsTfHeqhxVQ54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972584; a=rsa-sha256;
	cv=none;
	b=wgiMHfvZin3NEEwMpWq/CCwQMMZi+bpnZgNqcI85jlwYWQGvWKoo8cDFVFHnL4rIXAZ/pM
	nA168ZRaX7R5DlDAVt5wcTz+bZGDcxF17Rv+8zNTKU3DAu9fsL74o0A57yygqbesIPtJ2x
	IWS8M2Y88NI9xNTTYiFIG2BPC+LVYek=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AcBo2kFB;
	spf=none (imf21.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7G6U2FOW7FeLuMO+G3YOi7XP6zPp5DB5XZz1vAGJDdM=; b=AcBo2kFBlUmREj6D6f0eKT4T4y
	46dZcGN/eLbRRLwv26lUr6d8nBZ0DIrSduOoMatNxpjeLqIgYQaXCdrqIivgiBHMSBojOcil+KSF5
	b9U1sMiwffkblDJ+zhJF+unRt5BfW8oj4Q1CAq3TbVB3RigiyZdEiDvgx/xQ0vk2zurn7JXidKboT
	RBGLE8aMptY21RjCVD6XyVH4pqPz7u1ZJn3tCoMfj6+v09920aPPwS6PuceYOOt5MbT303mbhXVuz
	h09jXnUKm+dAQEanZ5//GDHo0yMbBZcjnqu8FYS+kxM7k/NJZzzevOeDt5CThnMzUsLBxTSj5/s7K
	AiDiENhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSaBA-00000005jvl-2bcT;
	Thu, 28 May 2026 12:49:40 +0000
Date: Thu, 28 May 2026 05:49:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
Message-ID: <ahg55Ei8Fc3iRsnA@infradead.org>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Stat-Signature: ctytxwbi3zebh96gyf8ca999dtffy3da
X-Rspamd-Queue-Id: 90DBA1C000A
X-Rspam-User: 
X-HE-Tag: 1779972584-841580
X-HE-Meta: U2FsdGVkX1/owiC1oY/bcs6Ig+5SDpqlB2PfCP5EZYgRbObVzvkETIveM6vHKopWIrmfFi2J3CQUBO6dX+qaThGs7Pjk1gzJO12ixr5CVI1HpC/HXz7XwI4eRwTmhuLH7U5yQu/KBrXsq/mPJ/iKbP8hNoSePnRg/g0pFHBzZj6sDcG6JPcVvjrJiQ7I+89TSyQMATLpyDGf56J7AFZs2WXV5v5q4K1APQQtuyU0E7sgYxjSspre5Ecb1G/4u/u4e+jB93MbkQZtgasQ0T3xIOR1l6FyHH/ZAghVEAj7198+gzBk3vv5i91ESgxonIfcrIPL04ZO1b7m/TgA6vccUMhiDZ8CHyXC8+Rs+wjX9lfW3zEvtahsH051IKvagMbKPj0/D396atbd0nM5/iCxFeSpdxOCE/Dt2C0e7TzItT0eMSypynDTIqFjc7TVKllsrfy6PewdsC4llCLUgqVrR5JGCfuYMzeEOI5aXHm4uUtZuYFJUQyIOGVdswc0QrxknGZ2py8ypHjtIjaVhnkyq/axpXap9YErzae594z/P49wMHXJMPhMUeVUfTve+0H5JEUcKWuyseHjepYZKFJPT+Lx+v5mR8yF/YZW6QCSaDOTIiONSLvYQ11pS0hXbSasjW1prNq+txpTlyfKh1JCFTO2LtiBRjtVn/uVk/Mr1lBG4WaYBjAk0DaHCPh3A28aDvLpiJDWaK58zw0ioZvo9a7E2KMh0D8SYZ679tWVN0O8ZKKCGvFSFV1bxYsdZbrtkkCvOn+M5l38RSJg+uCmgolLYCinKrr9Woi3ij4rpmJ7/q69250pqD+DtxgH5RB1aGmEll3ml9BzT0gCwgNkEnayEkVRp+RLKhD66ZF2sB9H2zx6bEDcw3TBOQWTJydG+n4JfCBfzlCqk+/mPWVSa8cjkqcCaLl7Y59RWLmIzEGI+iJAhf57euo3A1fek4J+odgGV4A0tzI4ASH9qRp
 r6eSxhGF
 W7gTE9CFUaUKw/JnOKcDSmWSA8KnZj+9DKdAkceVfm9ZMui9sim9lDmcGxkVDxocwp3n1KIl7e+n1iScwukzYzqyU39lnUMfcp4veHWGnKEy83wZMbdKRmaCdAXEJwAAV/jrc+hcoEAV+QxfVJ4/do3t2EX742uQ1tfHHdXHTmMnpILnCeDph9mHxTJg+8XOfeJIXnms1j47pyeKnqboWHQNxnyvfr7INvCYxjYhEV57luzMIYXb1ePuFEvjnqFktgTP9AQALQpMYgaf/tQ0nj+eF55c5LrKYGdVud2ZJBcJSC8eRLX8E14SenbK8Fp6SltgkLbZ9eEy+oA5XRGha2Q4szF23Amnon0LrE9OqMFNe5iPngh5LAJLRM6ta1ji7/zLlHKv6eqzc78CYlF5C1Pl6NSt3GZ3yBifBxDS30vsaPmZk8DqC0LOahJFdfZler28ramNGpQjdY03PPXWQHWY+lFN0op0Uft5rDDpk7GwxklHqQ519IY8sVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 11:22:37AM +0200, Jan Kara wrote:
> Overall this makes sense to me. In particular I agree it makes sense to
> move the file read/write helpers into fs.

I disagree very strongly.  Mixing default implementations with the
higher level APIs is a really bad idea and leads to people taking
stupid shortcuts and other layering violations.

Splitting up filemap.c makes sense, but I'd rather keep the generic copy
into and out of the pagecache code with the MM infrastructure for it,
as it is not VFS code, and making that clear to anyone touching the code
is important.


