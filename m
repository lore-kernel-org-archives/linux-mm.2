Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC2DCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 06:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C0C6B0005; Tue, 19 May 2026 02:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C466B0088; Tue, 19 May 2026 02:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2418A6B008C; Tue, 19 May 2026 02:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13BF06B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 02:39:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DFABA0195
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:39:22 +0000 (UTC)
X-FDA: 84783217764.01.FA798FF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0A2D914000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:39:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1nMUS+u2;
	spf=none (imf09.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779172761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekkueEbKjoJ5ZcmBfTn2kbworqdQev5OvGeeGiZpqXc=;
	b=48yexCesIh6N6fBcznVwagKdY+E3W41niFiGKxxKUZ78uk+0G5ChTY9oYbHlC9DF/2DA0+
	fFJEaWEyMEhOH4vi/jsTQl22ln8z+RT3HsGlRE/yjqDWycA4wC74nNq7jTmgXWfqmvIrRR
	5+XBDUIMZMhU4wtAmgEuRzEeVn5PUVI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=1nMUS+u2;
	spf=none (imf09.hostedemail.com: domain of BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+2732b787e2e1f0ad5c07+8304+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779172761; a=rsa-sha256;
	cv=none;
	b=3C7NaR41A9JK1yLG8lk73rAYYnBkqMOzEtypf5DKD9WUIcEqg0SSIfR1Vue3WDSHvLEetw
	RgVLD/TMyv0JO6XgFsb09utwfddHGhG9W61W/LHMsDpV9P9Zwvfa//nvWZ918/B42mdlh8
	8l7rKZinSQXJCsTBtWxO6Tw5rY1o5Qc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ekkueEbKjoJ5ZcmBfTn2kbworqdQev5OvGeeGiZpqXc=; b=1nMUS+u2ccmBib9tSNIYywxfu5
	xRDQK/03CAPPKghXgMhuu2ZeenqK63qusqx2i4Dodb1yqzFXYDdw3lplYIlv/LU97QRefQe6AiM26
	pgAENic7w8SIDcZYDa13uatQWoVJhaDovVrx950oVoDVibkJCQFD1IlwUKzrNnXYvl9Wu6jvBs9/L
	Kpe38PL56s/e1ONIVxfP84EU+gVmWV37QIy2JCtg8kZh4tP2Qhi3yCh8/AY63pjWjRLzdW28+9J2w
	geUqYQE4R8ip3C0kmm4kgNfZjBu7P/TbfnmsnqiD936ohg82DxXcJW2Li2TQazCo22+VNIWwQFfDB
	0in/EcPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wPE6m-00000000NAl-0lq7;
	Tue, 19 May 2026 06:39:16 +0000
Date: Mon, 18 May 2026 23:39:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <agwFlBKvKytjURDO@infradead.org>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A2D914000A
X-Rspam-User: 
X-Stat-Signature: pjwfu739g4teeiw1gtbaxq4esf3a34n8
X-HE-Tag: 1779172760-915129
X-HE-Meta: U2FsdGVkX1++dyZ9mEs1bbagAYs+XUfG94G83krR316xHWr7IlgTumQC15gIfDW3CahHUkCE843WMshgJd+inuF0aPB5OCgK8z84BmDEZxixlqGCHuXAouOfKQQ0OgFHBFk4K7rLNVvZSWsTEQzAHDgwmsMQPaohGbcLZBXGQaV7sQT2iC9oY9L2M/HKvNrSa1YXAQ+yEzGMb7W2pODkGZaiMRxrEh7wLpjmNJPeT6oXC0H8JbX7v/ePkrwJt3L+T69J8T8+opABFhbThptP1+mqcY4v2YiVlUWvJRZ0xqJrZZFehDkyOpqDgu9EbZAP/RIzPlred2xhGjPwVAhZgJixgtj/QI9EGBkraNMJo1qRSoSbGtIXUvjvoLzOz1OZg5754H73VJZh9i4Vr9pNZtEcJo8Cbc+ZGwj3In2DehgHTDz8K1uR95Cpe4/2vUBPvmvf4SqH6Az8Bu8DD3NJ3iR4rd6JEj7DMg271YKnOiPAYuFXWOIJpbf65A6xRAIN/oLQpgbbKh8fC7IOR+QZAjB5OenlSw/O9E/66sBI5AWBfcKUsdHUKwkBFOM73TaQR2ENDjLrX28PVO7SgZvax6GSWYcde4ppMLQFm8uNnOKcOyCe6MquJrTSfu65KeyiWhDQc86ivkcDOZAue4KLckgtfZJoviveSmP5fdVNxUft0nHmljeY/ja8xTTOjweYlr0wypeOyaB2x0e7C+bmgRNijA1EANbrqzsHVhkBj+ylSihFFFt8nKfHs4dwZ4RK+DgfMBlUfbLeuag8NBynXr3RmlScDT/jbavcxsxCO3UoALP8TuUtnt/cFjKmyit0A73By39X1h8pM7lI6flXF8xqH2BKumG913EiDkLu26F9TgleIPbn+YKVXkYxBtwy06Ot7MJleoCM+uPvInDDgTXh8EHbmUkD2U5Ey8iY5+A4y1+3Vay4ZxkHzq8Vu5bJ7sHSBzHftKX4qmqR8Z7
 6yVy1Toc
 9uXibLs7LYb7q+g1yGMSI/1rU9ckTBYT33INfP0cLk3VcE8CrhcnlaDyRLtA5UbwS+BnOPXcGEB5fvzGQ4YoYCv8zZvMEs+V4okwQl5nAmXIYeDVEVbxO4JQv+mghuLl/K5sKIr3jSC3Z6ytX+Fy8qTsPVswx6Sj2mR3QJ/5gUXHHufyriyGJQtgnockK/uUDdAgWlDWaPMmQtBewISeaWH3QHxR5k/+cRanwsje77dRSq3aVeT2WhBQRuGLYbIN1K3MkxbzV9oKej9VGskySSSt3TcDmGf4urLqhYAwvw3zlIJjqbByVr0m2bX6LN273JjWopLOpH50es7yuyTFMmORuBwzfyihZYf2WqPgcsdPpwQgQ+D2wzvvZcqK5aMIqhaRdUq9ofz1hgUFw/Ta9Ra+NXB59bY0DVSz3V83w8orqytVOM3sAgjSoBWLBf5sWhzoZeNyHU8gOfca7v/Y5vh4w8JMZZkzDO5LBzaK1w4XsvYUKA72wr4vUnUUgQo760yMHHPX1nJWiY5Qiw3K+zx8dgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 08:59:13PM +0200, Jann Horn wrote:
> I feel like a sysctl for "disable all the splice-like interfaces and
> zerocopy TX" would be reasonable to have? Either by blocking such
> operations, or better, silently downgrading all such operations to
> normal copies.

Yes.

> FWIW, vmsplice() and splice() are also weird in how much memory they
> can implicitly pin - if you call vmsplice() on a single byte in a 2M
> THP page, I believe you'll implicitly pin 2M of memory...

vmsplice is the worst, as it is one of the few remaining places that
can incorrectly dirty file backed pages without telling the file system
and cause the other problems fixed by a FOLL_PIN conversion, but it is
the only one where we do not have any idea yet how we could convert it
to FOLL_PIN due to the unbounded pin time.

Note that we sometimes use splice underneath other operations that do
not have these issue.  The most important one is sendfile, which has
very clearly defined semantics avoid all these pinning problems, but
there also are similar in-kernel users as in nfsd.


