Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E60FF60D8
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 07:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EF8A6B008C; Tue, 31 Mar 2026 03:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6886B0095; Tue, 31 Mar 2026 03:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208DE6B0096; Tue, 31 Mar 2026 03:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 119756B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 03:26:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C24B91A0B46
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:26:41 +0000 (UTC)
X-FDA: 84605525802.24.2CFA9AD
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5A9A140006
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:26:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774942000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jVlDza/uNPI7Evug/rL6BZvLjtTL6ttAHlqcx6LfBKU=;
	b=fZ2z554faTGKNbEZETvfaBs1I9Fje668G6WUXAJ1X1vs6UyG5swqVTwHFfwef0FjlqWoUB
	5/GXJrymqALwOefiWCg8glzKiXqkUAPiFbpOwg6MFxyvjUQoP5jSeHdYV5UfrzlmqCzC9O
	eGECeMsJaB22H/AHEpfczGgUpbRLsrs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774942000; a=rsa-sha256;
	cv=none;
	b=kuVNINM/b3cY07Ruiz8iKOW2RLWYe5amAi64XuLvm+WwPyoNs9flzZ3uTY5Ilr0DdiQ03H
	UG7bkPJ/6wxd6vepQxViP7+g+xAip/Lv/7WQWkQKg1GzAPqoCYG7hSbxv7wpW50Bk+5GRc
	KBYha1ckpdkXsZKHqrG06PrbSjgW9i4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf26.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DFAC76732A; Tue, 31 Mar 2026 09:26:33 +0200 (CEST)
Date: Tue, 31 Mar 2026 09:26:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Qu Wenruo <wqu@suse.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] zram: do not forget to endio for partial discard
 requests
Message-ID: <20260331072633.GA5494@lst.de>
References: <20260331071537.706139-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331071537.706139-1-senozhatsky@chromium.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: A5A9A140006
X-Stat-Signature: xbhxyjaq869sg9fnwekpwkpqonbu4j3d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774941999-291413
X-HE-Meta: U2FsdGVkX1+COVr1at8Y+5grzo5okVSXczYLNQqbfsOxg5okk6h+UBzyzPJxGI7N9i8M7EHKHNK8bcvMP/bMq7YnVE9yMeyjcd4wVhbs7Wn+nUKitts9afjbn7jw1wYvBVZtW2QGI8OUTuJvlSKmYuFZm4DMSwzGYRznlAhhbVFvughGQiHkUt86zcoBD6QvQRAiHP8zqjtzPLOh1oIY5M+mYysoWJXlesc217iRzCdHzE59UPZa6RGRv1Q9dO1kIeatk4j5UCxB5a50RyzN9TJmC9U0cu9yXte1squnlYuORMd+1n9HUzWkjLeKH5wYrf6pSmGdl64JWhnChEBJF+ZnuZ7iKu4SorIJiAoeQfUn6E04Dm+XeQK/rc1xWEp/U+bKfuAl/QPbpQK/61fn0UZ2C1gj9tC8VdBM1cLjEk3HkoBeCLKcfoXN5x3Lwb2bLTjYia9ve9hO1vOlkl8NzLUC3c9q4fZlivr86ywHIkafDJnAGJACv4mEb/kc7GyTUB6HT9F4fi/Sb5IS9yoP46u4a5r56YPHW8xehuCUf5xMnJ+juSwgQkYo4+IcstPugGUkTo0QZOn9KrsRsR7+e1w5yLqAFKsBj3FkOCAwxmx43A6DAuetE+W1CS6pX1YPlpwXr2d8Qxgd1+ZYYdnl8a0rJ5AGsILyM3RNshBA40NyY7YNFxoSt7CjGnmixREWJl0JUWS4efKVlyKhfNYajCHT4aI3am0AqyeXjo6zIUUHWuzOlyOgx6hKEBFjgUBytdtHoMeM82zdGA11W4q5edU6M7uCYMlp+xCn255cjd5FF5Hnyj9dHdFgtgePVK4okvHNRi93AeWT0NIvXvVty/72s0e7/wsvJAC2+0YQtTRukdA0HdNjXb5vBbqNsoO3XwD47qs8Oc6VJgZ4LtmsSnjEvdlaqVx7OhUn3J73uJ0ukdAQ513ZvaPy7HW3rrXAWhDtsRUdoT248KjlkGw
 g3Wk7GbX
 wjUJlKgPMCdx4c130Oi8VfbIGRolnbZKaQ0DhzDVMDJ/hGKyHxJYzWcbUZC+1txRXSmwNjOqnEKEm9mEGMYZt1y9uOReFpObaDP6MARiAAITxnfsIyIeEOuIF3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 04:15:06PM +0900, Sergey Senozhatsky wrote:
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2683,8 +2683,10 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
>  	 * skipping this logical block is appropriate here.
>  	 */
>  	if (offset) {
> -		if (n <= (PAGE_SIZE - offset))
> +		if (n <= (PAGE_SIZE - offset)) {
> +			bio_endio(bio);
>  			return;
> +		}

Use goto end_bio and share the code with the final completion at the
end of the function?

