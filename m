Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9561CF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AED06B00B1; Tue, 24 Mar 2026 01:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086716B00B2; Tue, 24 Mar 2026 01:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05526B00B3; Tue, 24 Mar 2026 01:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA0B06B00B2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:48:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EB17BEF24
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:48:53 +0000 (UTC)
X-FDA: 84579877746.12.4ED44DF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 45E1680008;
	Tue, 24 Mar 2026 05:48:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LgGstViS;
	spf=none (imf02.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Auqlgx2eITfKaRaaVP7pgsV/gFYGsYaCHVrjvCcEK/XM7BOyX0itW/pWsLIUw8RSKLlmJl
	P/DTvAoRaDdmCMHKizG4GkLu+dTiQ1u1/GzRK+JUniWzDS8Ja/WVb3B1nO6IYQ6TFeoRnK
	WPtuKigTlIJL5yPRHEEF/kQr9/T7rjs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LgGstViS;
	spf=none (imf02.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331332; a=rsa-sha256;
	cv=none;
	b=WksjKTv64OsLCAeqq3JCxZhosh2K1cEwbf6y1F2PP1sbekeEkboPpxCleWfeS1yi0p5aVw
	64hS2oP9921OCs4jFLw+B/LHxraUpjq0JIN2FwyAahqTIlzxq4ufvOXzcsnmvbQ2FyKcmm
	Lk1VT3+Yuk3KdXnS515WHqQNOPXA84w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LgGstViSzEAutneHviSV2EOKmH
	OIdT1z5rAGAjNp+2aMbFDun0oi/J2vEi5XeEZ+Z+3z5l1LsCacOcwtzKUhWl9k7WB2OZrKdbVAs9G
	4T+h3w+YmWBO2jusglJEvobEuBsKeTszsiqrq6pNLitj42DkQGjCjnw4uOZypujRrliSIiJ0fAgTi
	F743/2vWUBvYEkvDL717WL6Uj4a1yVqVjituRIz0JPqKaeE8P7VEqpnnZTYEvTsmLrLWHYXUdHOCd
	JlihRTyc6SMxXV5thw5arbSAqCVrY4MRo6eg277PdhMpHVvqIt4vjwrRi1kdNBqAfA4Fvnytw6t6+
	GMxwwtvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4udD-00000000cRx-1X61;
	Tue, 24 Mar 2026 05:48:47 +0000
Date: Mon, 23 Mar 2026 22:48:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 30/41] fs: Switch inode_has_buffers() to take
 mapping_metadata_bhs
Message-ID: <acIlvx7GcZO8LdM5@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-71-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-71-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45E1680008
X-Stat-Signature: 48q3qho9tjxu9abuy6bfmgq416cnuewa
X-Rspam-User: 
X-HE-Tag: 1774331331-396588
X-HE-Meta: U2FsdGVkX1/i331vDWHt+mV8vaF9JBGvjXFAAAnkIOVZkAf5/FhPGqaIlk0kpM046AwKi7EPWkwnlQ1Qdgd9UyWzg5fWHFc/9Jp02wDRMWaBGAvrKiJQtNQOxZ1I9N68+ZuO3uGuxKdNSHKKla4kZIXeX+uyQFBDQHyqtfYa3QOcxVKhI5m398Ac0UgdbSogkhXqDaBJlj/vUbsjQHifp6pgc+SAG/NDR2iobUdT9YYE83jZuwZlYaocb39P/5uF5cxjqtKx/9byZ3jYPkZdXXa1RHokzqj6jOsYsVyYSKLCSflEUZUK8yD72GqXmIumTtgknf7wgFzMugDRbZORHZ8E3BQ0liUIQMoOm7LvKydRkYdd297vFjjo1jiqtO+WUNE1LTNzqul59RauecKBC6h2ymaVaiXAiwTNGfw0JNFaHrAetbkvDr/ghLUtZ6YzDEzPuijFyd82x4Lyoh3AJQizcHuUtYOJOR+9+BXPht/z0FwNNoten4XGurkxaTpOqWNhESFokXx1CuGiBIRE2GHeCQXfDOk35OpFakKZ8zYJlam+ErXQ9j/6gRpOktFkW3pauWzeipgPtHGyHjw0yitI1nfJWI5zXqlR5H3UhSt++tja7352W+FEjYn8Xtg8rxOA0ho+QOqDB05jSM4U3LJt1OoVRJ00bSZ/fNgfqpe68GO1cPpE1BeBh0zHGxIIjoJeBXGfvoJ4QRStnvMclrtKzjp6Fr93usjuR7gF8Kh/u6d0UuqC5J5cApSHaK2OA+ksActlh/BIjk8yS7Yy+R3E95dZ3gWAhU4mSAmftIQ0kV3ksTb0uXl4yZTYf23lQindtqaCsc35115hmDzy7UQSQByIdI9LEBwdScdYLQnJWA2wtnsHR89vScYS6x3F6R5Oamuo3MDsGTSmHYMjpK2A8IXX8uQmWwcfqFv2VRmVbWWlJwMOf116YHmLfGQ4TUbzyiHo6Zq/18Ym55y
 sR7kFKj3
 rP1TMfzgcKVKaaDavukfKKTzMeJZAtKFLpb4OwcPcJdoRORD0MMs+PSjlTAXNVE25VrfKQ81c5jyyB1DzuklIyPgToQCzbcObtUd7TtMSCk1Ib2hLyZSIJX+dMbORThyKTSuw9Lgb4VsOwK68TnP5P9JwaFxcot2mtyZ9vy+7a5wSFnar1XHcLp1CkluzXw3gZFUV6+9QlwJIOtZgZaBb6Pgl2dUsbtGp8ljS9bj4wcleEeeyds4fFV+ywupfCU5K5A0mLKYpLy0i0tI3w6x96fhKbJlv4uvdd6j9f1iUG9d1MwQDwBQGAQdVp/6K8nicNp3WZcWrpWw4OOFj6m8Th/rKibLMkhIMaQzQsNn59KKWlxtDfv13WwOeP7evEOzsLquYG9bZHmQ+y6EFGOrnKKETjgqFWsQ+Gpiyg+Hnt0M0q96eg6qMnf9Yj9CEqLk7jvCMKl+n51xbkdmsfz1iA+KZuKKLPmaO+AJE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


