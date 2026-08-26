Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3534DC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2779D6B009B; Wed, 26 Aug 2026 03:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228296B009D; Wed, 26 Aug 2026 03:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E3F6B009E; Wed, 26 Aug 2026 03:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E410E6B009B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:55:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 787681602B5
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:55:05 +0000 (UTC)
X-FDA: 85142659770.28.22190EE
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA5DE140008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:55:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730904;
	b=8Y9OaceHO98l0KR+nPbEyEIvJpTv9rZzYH52bsWnhbE9SyhSjrkw11q2gsxAzgFE/AdRIz
	CAtQ0eaVs4wJK4uyq4zhuHRyj7B8ueRh9NvJAvprWxaourPU8VcIbksh9eXODWxiZmD2Ad
	20yS73iQCbZR37wzR0PBM01Mn+3Zaug=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S5/Vfum3OeRJaVcQFexVH+N19vtGM+JpTCnIUKvBNRA=;
	b=YYbUmgoxfeKxzEn0j5dstFokN3wJEAJ4R86zT5bysSz/k6/QB/FJ6V+BwqPXsCu5eIx9D6
	mJzS9uyUbAmtTFArtfDZCVIso0tw9dutILLbhBZd4WhXonfmGUk2AHlxZcrJXOb98QvO7+
	M5W8Q3dgnxSS3iZqQsz5tJ7p5OTvetY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D3D268B05; Wed, 26 Aug 2026 09:54:59 +0200 (CEST)
Date: Wed, 26 Aug 2026 09:54:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260826075458.GB19050@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org> <ao1Lo6TKhPcqV42B@pedro-suse> <ao3gZRa7HOEg209P@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao3gZRa7HOEg209P@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AA5DE140008
X-Stat-Signature: sazeyfop6fbxhpr6pgfetmdf9seb1ef6
X-HE-Tag: 1787730903-426158
X-HE-Meta: U2FsdGVkX19A6mX2q6lMTk59a+A0fmelJcS9eTp0cZuqNTVd9quMbyrmzgLxsgIr5CkFVaV4mYVGO7ZrHWGuO+4u2gzEoaakA8VSx5HU0AXUOyW06+iGRRKiNOR1km0JMSAZ99wIdU/NblQ8wBCWBRiCRIq7hHVbqm2lJGZV2p3qP4L3SSuKy2da/8GeXfbnD0W/d32hZH3GOl7uYXQ6EOyR53m3QzGlt/NMCuezibU4egjGMMAKrWTfqo8AreQsQk4caeK8F+YQ7i6+zfsH3+s+rL7UfumzKhU9NrizI90qQE3PPcgWZJm0WX1kq85k+WLQ5Y1jWM9s1mA75PlpAJ0jrRQC0dZEwocQ+QOqwxTB/Izg7KIqYQvlbc5W0S0aLq8tkTWGoRhbsncVW+dq6G1KBHmcrG/hBZqnNSna6Go9gJGKe2hWjUzyBA4WZ7ElFe+aJZoBxRbMiWQEy16drQxYgmB7DPyoJwQl+45LVYQUoCFZxbmTk07eh+71GXvyy0/rv6bd1iWStiOC2E+7N2tLoJthtuXNIH5CKvhyRsBmWtP1rIxO9XTj9iR4WCeJ9dxYtRlLtoKzfzbYichs1HzMDLvflSkHndriythzn1FSnLQh4UiEb/JwXexPEkmluj1RzbSSUIgW8rOtOVwOwDtOKeNTr2zVqjJ95JmnxxClzoVPe0hftRxs7utgCKh1ZClDii9ldZNfcoTsrYqyx6l38OTBzwCpvXz5U0rEltIdWXcpHovgwWwqaNl8c2jcmSckOoE2i05XimiCVpd2hrZUhVd6joXDOATdZO30ZwLtJS9qh8e2BfzQuuu+vCaVG11h1caliNYyzHWfQfRmPOQPBer2+UQnNQ7NizCo/HQG8oKDaQP23uVNPGKt2AiBAmHRUt4HZn6+zx1M2WNPoGZbhio2ed5AxA10ExLoTxCsXgf1beKWpAhfIKJyHENKU4DuvurlgFqUd/GFmli
 mMVrUCnw
 O8rotzmBGKHgKGC2O8RwqxJtfyV66kmGXzQ75F6PjzctIYhIoTUwkumyf4yNcwDisHG1t5hM985v7NW+g5/acrgWXskv6jNOvDe0xZA+hDW0GNEj7q7u2c23JKe/1TIx4PXdYEngcnTozTqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 07:35:17PM +0100, Matthew Wilcox wrote:
> > I don't think you can do this for stable writes. It's probably ok for
> > !stable writes filesystem stacks, as long as the filesystem & writeback
> > can handle making no progress at all. But since stable writes' writeback
> > can't race with "writes", I don't think you can Just Do It as long as the
> > folio is DMA pinned.
> 
> Ah, yes, I forgot to specify that.  For mappings which need stable pages,
> we have to bounce buffer them.  I wonder if that's something we should
> do inside the VFS or if each filesystem should try to do it itself?

If you implement the writeback without clearing dirty by going through
the direct I/O path (with whatever customization is needed like not
invalidating overlapping page cache), you get to use whatever bounce
buffering the file system already implemented to deal with unstable
data for free.  Assuming it already had that, but if not there's not
point in adding it just for this corner case.


