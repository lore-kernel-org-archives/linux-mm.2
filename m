Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962D8E9A77D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10E36B0088; Tue, 24 Mar 2026 08:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72786B0095; Tue, 24 Mar 2026 08:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B141E6B008C; Tue, 24 Mar 2026 08:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 998FF6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:24:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4560D13B0D2
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:24:45 +0000 (UTC)
X-FDA: 84580875330.24.014C11E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id E688A40015
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:24:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DpuXonCA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6SYWk5aM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DpuXonCA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6SYWk5aM;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774355083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=K3CfrLfglzF4wIhlZ3j1RUIWzJJ1kUYCZdUBidFC//yl4fD6m0DwdQjnXgpOnqsfuF3Jhe
	JjtDBiqw688qEUj090q87GDkyqopmLme2YdSEB0j8hX0hWgn1e/vyAEtiBwprpGhgT+nJt
	pQ+0YNpoEJvvjxtcTqlURBG2qfhobiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774355083; a=rsa-sha256;
	cv=none;
	b=Lbg6HaLbN88STO4zI9Fv4H05+9LHuMMNhxaqyHfFWsxG82tMdgwUO/4JEh4av1U6lUhU3r
	YPTBvrDrrgyMwB/LhWLLlN2fD+Fl5mweiGx+406u4ehB2xYilWPZX/XLavsaO6VbUwmLVc
	K+jAhkbBmwclgsvncQ4OpALun0I9VIY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DpuXonCA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6SYWk5aM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DpuXonCA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6SYWk5aM;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2013C4D1EF;
	Tue, 24 Mar 2026 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=DpuXonCAJTnmzxmj7MYbY7fs9pYY7omNJcSCIeYO8vB/nirZ6rHkpsPPK6KxHnhDmUaNcx
	L9NYifeiZINqnAQPnQP4yF8eVcWsd9IH2qPE4MRdxtElllkN57VVCmTz6ZDKe5PhJ3CAE6
	YbFFFBfBGzgnBvfVWXaGaxBpD7hbiMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=6SYWk5aMcCZU0dZjkafUYdIcw0wAXHlJNIYRYpyQzUAft1K5VtU3yc6xBmNukWXDq58f2m
	I4A9UHrmX26DjBDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=DpuXonCAJTnmzxmj7MYbY7fs9pYY7omNJcSCIeYO8vB/nirZ6rHkpsPPK6KxHnhDmUaNcx
	L9NYifeiZINqnAQPnQP4yF8eVcWsd9IH2qPE4MRdxtElllkN57VVCmTz6ZDKe5PhJ3CAE6
	YbFFFBfBGzgnBvfVWXaGaxBpD7hbiMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=6SYWk5aMcCZU0dZjkafUYdIcw0wAXHlJNIYRYpyQzUAft1K5VtU3yc6xBmNukWXDq58f2m
	I4A9UHrmX26DjBDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1451A43E2D;
	Tue, 24 Mar 2026 12:24:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JhfqBImCwmlEZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:24:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B81D6A0B32; Tue, 24 Mar 2026 13:24:36 +0100 (CET)
Date: Tue, 24 Mar 2026 13:24:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Message-ID: <lrkdrgbiyaxn4lkpsxcrb4pbuoxcxzz6k3wvafp3ffg5xtenbr@edag7ovfmzi2>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-49-jack@suse.cz>
 <acIjQVRICiVBndVr@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIjQVRICiVBndVr@infradead.org>
X-Rspamd-Queue-Id: E688A40015
X-Stat-Signature: 4i7m9uay1jmyyco66ndaz5g9m6hdux87
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774355082-959159
X-HE-Meta: U2FsdGVkX18hG3d09EF+4ycDZgAxDkMYpdMJDaHCdPuwPZlRv1tzbdq6Xjc2JpyT/PdfrrCnEruab8aLHu6Cv8/rs0KaYkZFkQDzMG12mtVusDqit+yOPnacHVbeGIHO52BC884VtLYxjR2oK59TTWYWfiTJTPiESap5sZq84HyDRZN55NmYUb3foZusTohUoH+JfDTcM6W9vZgztAiR1EWh27CLAqk2dz/aaMRBiKNLkzVmKNfaS/5o7PFQWkUh3mppUlJPy7IT50IclaeWJsbCgVfz1hjaUmYxxDfcWGNA1qWUcys196PcPzwPkgHe0rD69TsawdV+Z0YDkML7D7nal/990gVeGcvVbAMJgtZ9zBq2B4DCqOs5FbzNiMSQH1ly2HnZU0YGk0/pJuQmXhp/JnkxrkpcefnBDHttnTyDLmM/NBm3vRRhTfPf6vjYsZnuDtNtuztkIM160G9bC7tl/WHww6NBMJKRaNhLQlo6u8f4HUTPYd+E3Ljc7PZf4/ZbBtPUX1IQ4n6iA4qGQibl+9HSGrEzOUM55KebKtgNGkt4otPZEjlv0XlTH8ZNLMRDjq87OvLxsalgebdzohyMV5mUMcfLSnuhIgbarl7i9UDUwfhVhmt4ES9xkCjeU7Qqao3aSM63pRh7D41NAdj0QfshexG6FnqSYyjrgTEymgwGt+Or/1cmM+pDyBB4ojUNfIGN/7o9tczk8LGougMEiSzKUn6DxYus6OdVr4ara66H+8RBfgk4uv9IlEB61CQqzrVhIDEBFk+JSBe0UtRVQQJ1J/gVJDlujGGmYLeBtxXLL8FT6yUnpR12NZ+bhS/4abjMUiy1E9m1l7xOtty1dj9H/KVxWy9w24KwbCJclC9OiWp8ndXFQDfJbxZNQLIqZn1KCk5qU3kCKUAYKMWWDosAxntZZBhJdf4nanQxL9vN2au1z+VXOEH5Y9XaSwVLqsHwVAumPB+gVq2
 JVUDBGtg
 iP1l/cwtaZDS1RWAmSSFfn5YGGl871n9bvHUsWbciRbmUaeLPgq3UO8Nli9GYbsUsr7u4NPZl2Zb2hFxD2paquP+0f4ySnUBspSBZtcy993wXGwOBS3WfddDzRZ+DGjaQjtdTNrJIhcAxY8vuGELCXgFd2/5rdlLtrXTRt0m4bbteeDDaM6fs7VfPHNp6aH/OZF8NU/WgrS6gia7d3hFvbEW9cZ5bxLcbwwRNbO5moOZxKDRhk7eTllATduRO9dfaZu6zTaWcXqUNI4lEWiQklDsmg0JGYCLZMs+ELeLMY07lPdZNTKt84dkBzPkPFrHt7HcC7GNv1skRvyylipXZzI5+77TE7nsu5tuS4yudmoyertpKwAqM1Y2fGNsMewvY4wID1o5nIQsTxb1ffZM7VA9nXGwrF1b6WFOhW2ZMvZep+EUsZFAEQB8HQ3PvSXo68bCuJLV0sQtV9i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 22:38:09, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:03PM +0100, Jan Kara wrote:
> > UDF uses metadata bh list attached to inode. Switch it to
> > generic_buffers_fsync() instead of generic_file_fsync().
> 
> Can you explain this a bit more?  Right now the only difference between
> generic_file_fsync and generic_buffers_fsync is that the former takes
> i_rwsem and the other does not.  I'd expect the commit log to explain
> why dropping the lock is safe and desirable.
> 
> Same for the other similar patches.

Yeah, I was a bit sloppy with the explanation here and put it only into the
last patch 41. If we move that patch early in the series, explanations
won't be needed which is a good thing I guess.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

