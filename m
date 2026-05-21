Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04584CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63AE16B00A5; Thu, 21 May 2026 13:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EBB66B00A7; Thu, 21 May 2026 13:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529006B00A8; Thu, 21 May 2026 13:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4222D6B00A5
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:42:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAA7FC0146
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:42:11 +0000 (UTC)
X-FDA: 84792145662.03.7381FC3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5C17A16000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:42:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ejOrg5mg;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779385330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mocVZk7k0i4LfDz16F/hYo5gMZPJrjHL7ge9GFVHtqI=;
	b=sRwSB79IkrIa85PBh1uGf1AJL9vDXRP3Fe5tXJUg6Y1L/A1H1QJ7+tKn4bNpT0UWkKAqnP
	eSUnOwY9cqnlxYEQQgxpg0tvj7nCSOzgiGv1VnlWKCgrGiXP858CQSG82MKDSCZVYgypQW
	TROxFtn2TFd/5koyzqrDAOaW4g2FR3k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ejOrg5mg;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779385330; a=rsa-sha256;
	cv=none;
	b=xWmQDs6hJdML0txh6qtUMcQVtdQaJAFQCxouGyczTDxKFqCcYa1JzVK/r+p9Q0PavLOe3F
	qsnlBHyAyDuY0Q3U49qxVHf+iiQBHvJ+OQU0DGWnJmrl2olrPTQUahXvEUzMFhekG68BAf
	JL+if3GQBF5hxLQWyV+2Zu48slwh1to=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mocVZk7k0i4LfDz16F/hYo5gMZPJrjHL7ge9GFVHtqI=; b=ejOrg5mgxSsn7RT/IqWLJYzFmy
	NjacPOHPPk39x+u3OOyZlw/ZOZDCW0fQ5+j7kEh4ns0cWOZDIgh2/xgyxFhO42LNiJuYqfWu14Qyq
	INqflfS2Q5C56RXca4CONSNgXzpsQvC40q9brHTV6cOwrRANsEllx6AZK4PQKsjB7PlcIhsF5CpqN
	QhpXfxqg147N4BeXy5Bv0k94qY/07fYp+a8FjqSGRQh7dVRzAyyXuO3zAztmvK6mhXUPh9EOTJgTP
	fnUKz1TMjfkyI6WIwVEHZ5v3AqVavAwv4Eq7ga7uPWwJfxGJoWW6Y1JZanIeGHyZdizhe1S6ukMYn
	C1VY/WxA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ7PH-00000008pYv-3GzO;
	Thu, 21 May 2026 17:42:04 +0000
Date: Thu, 21 May 2026 18:42:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ag9D6_7dttbDGHZ6@casper.infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521155748.GA79343@macsyma-wired.lan>
X-Stat-Signature: eog13f9ex7p3du7xp9x3t81i16rgb7zz
X-Rspamd-Queue-Id: 5C17A16000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779385329-116239
X-HE-Meta: U2FsdGVkX1/okNiPdXrXvQ5chCrvLGaFQjHLcDgnF6MiUZEIM90LM2U1Yd3ozxDJicxHwYOR9Zpi0maI6LNIbLLODqxnfx+ZonAUhPcc7bnldVoGbvpfncWlBCbfjH4B2s3mpDsFd27r8M+XjTcMUmScJ4vDIOteHkKCl6rS8o13LOSPkWuEIuPV6odIdnJOVzCHaewe5alnjSbyjC+DVQiSgv6W4aj2w3uKE8qwMLOZidqsbqapH14cZUveXs+gJUC8aFauIKfhOPDNNA+Awah9rs+UkfnHEyYDMORvUz6f9CmFlV4ICYki+n1cRimsLLuRNcg4NKaWAlcW8F+lyV4ovvsXhY/gfy+rWAH3rTj1/ZHEvExvPkLxNdTVMjIY6rEp/a5P+hZ6pHZ0+IsUJJD4DJSGnc6pwctgl7qIDEHgLylVUL+oUcp0GkJ7DDooERFW6pR8nQ4PhmUeWbq736d8ZCdofqjoSStlkN/LgUNKJfoF5GwkF7KB/7KethYruSJ/Hy8vlQ7sxXy97vGd+/CMH7FXr70zk1Z8lctz4HdJNDCLWq618a2rVCFRxQ1dtUMkmOL9qveTA3ixa1zvDxVP1PzFBlenB5S9GjOhUycvN/+rx4un//XALQ2A496tMrL86Rut6qwOgOxcQ+ZaTKcX0Gp/3+PKCLhF5Mpe2nGB1JeMftUFlMs1io6WEkgBXKmQzDKSlOFp9gZmAKUoQ8Pu/XxkFUADPN8TCqTUFaQkcKHMWZpOcG8sAYtIeC7yXUoQcZPESqb7tmGZGWhBuLIFPNhInJ22mYTrUxpFltptXzuRtJ4BfrWIh2m6oLvwTLXrN4d026+u0ww6FUQnyaNiuILR2S5MUL3oUtSs0qDzZkIyR/UjoRK4/hHcI4lC+Zn9sytEHMBNQYdGHOTVMwzVB0hh76Pzsje+YJDAbcVq9nH95Fi7Rr3ssa5EgQyY2Bt8BkTxDmE+x2f/aWz
 DsghDvma
 YwD4g6Dbitie3hO7Pc3lkZH5+Vf6Z9UWEJ1AqLQ9qEzkbEVM8FsH3Vgi2qh8ubAWBG5zaLtpudv3s9agsivUguhO0BVFjbiOlQbLqFwUP7x6t6BQGnOTOlvw/v+wHX3UzKW6QBDh+Zqi4wUPwS7qJiyo5fDWWPePUSoUF+acPOm5VMoVYdZg3lveqXR3jUC7qk4JePgdPkgacvtm2EN4ofE2ZLO8VDPLPi5ptzMAtLhmxVbNu7P0COas5mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
> So let me get this straight.  This is a magic xattr interface which is
> not even persisted in the file system, but instead sets a 32-bit
> bitmask in the struct inode which disappears once the inode gets
> flushed from the inode stack.  And it uses a generic xattr name,
> "user.fadvise".
> 
> There's no way in *hell* any other file system is likely to adopt such
> a broken interface, so why didn't you just use an ioctl to set this
> magic f2fs-specific flag?

I mean, yes, this API is horrendous.  But it's just another example of
f2fs thinking it's somehow special and not just enabling large folios
like other filesystems do.  This hurts everyone, not just people who use
f2fs.

