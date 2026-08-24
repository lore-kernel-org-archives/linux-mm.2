Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258C5C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151CD6B00A0; Mon, 24 Aug 2026 09:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBEC6B009D; Mon, 24 Aug 2026 09:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE58D6B009F; Mon, 24 Aug 2026 09:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C71836B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:49:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F40880122
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:49:55 +0000 (UTC)
X-FDA: 85136296350.05.F8FC3A4
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E9D9140008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:49:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=lJo3rjeJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
	b=bPbp6GF8utjNliYU0zcPnslWqq6FBFzXze6ZiN//bKhBuSepukL48nMzYpgKN/YUF7q2YW
	JGdQbhXZbmw63g6mrSva60Z/ol2XFodNTy/V0CjNLAw2W73NIXP4W81mnlFdoeDEedas4R
	742gT1U1N137ad5ZEjJIN1pckxFtQsc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=lJo3rjeJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.178 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787579393;
	b=o46U+dyhibzpgEhBFOAAYJh2Tprm2xgsWqSOZvO1VSCW6JSnK/7hbHmNJ1ZIcrUh50//cp
	q3Srj/Xumtb8yWm3Ge83QnTEwjsxplY/ImJYQXtq0arc4jqhr+8tmIx7v9kXa9M+XmnAbT
	530trWlPVvB8J/zEgGDLNrv2ciyuEK0=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c2a76536bso38075651cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:49:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787579392; cv=none;
        d=google.com; s=arc-20260327;
        b=K195JVH6dTgyCrjdzjoLkX+qRLifZfZUoZIJPh5y1g237tk9GmxhtUCRkmmowIpNPP
         6Ty4RJz60jY8hp+rARAp8wAHCOxpF6sLbyO4Gqambs3Q8sxKpuJWcoOq3w3v8nm/eDMr
         +5N5cpBU55Yxwc5zvGkUDXNZu6Pt/JXMsYktLRDgzcjGDB4PVh7lAuyPXkdGAKbGEt6g
         ahSBvLFdzlh6gda+iZ9C7cGWzKh5Ahb/HIJkswEnG01bNixI9RZ8P8bU4FMsEgtdOLAs
         GdzfLjYq6yQSsoUR5w57vL4KR+AB9svV1NR8ITvSjGiTTns9+BqQ0ZziW93JJ0c/Qo6g
         T+vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        fh=0C/Ugs0+HOH3eyf/L4HM50oqCjOq1+JX6dyj9n0Q7sM=;
        b=jgsFiRSi++FSWGwj6WH/IJsPw4FcJsWKtHmb5ELZQTQnrgjskG4wdwgztzRV3s5hUk
         eDoAMfPCyxqbG0ZZ20X9pSBVWtHe5eUt6ZMU5GYZQfMR78SqOMsuFd3DKjL6q0pdsnnt
         wDn3t023xgIsWH06nxVa3v/Us27tQcNcDCEsE6OMYQTWPoxZh7feeQEkvhUOxBrBZs9j
         v7EJc8I8n7VVqh3yxVmnD3HOfzSizYWp+IVr2LACEiT+iRxbW4KqHPiEweuloZ7mie8t
         Z5nEtbbTzgdbgukX9cStpzfJdR8mH6KGs0xXrAVSElHTix+15qUG8K+qAd4xXBV7riNI
         KilQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787579392; x=1788184192; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        b=lJo3rjeJABgtQsDbcuz8Z5Xqw5SG2Kg1QRHXhFU7y26XyrMJvbwbDkVC0GkKaagtE8
         WwBsQ/4QIRB0DQLmGaabPtsmaq97m5YjrNIlyZYdHWoPBhiEwKDSkUADOUeaf3ruq2Ml
         5kmj+g2aOAk4ROSzCxnuSfKjcs6J9mjPoOvBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579392; x=1788184192;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UWqjXIcqtIZGoXJHhXghNNIDKwEBlEpB/YPKWMii0qs=;
        b=W8cjsFIIkjveCoUZHPP3sOWX8UuaJmVSOIwEURhJLuUBteedDMfLL2Ado6AJ/ZCdzq
         D4HzpWxXqJLkLHlgmwLCYJlM817ppJ3HfmWvyFp3A14uL2GdB4dwZEYqOikI7UeAD8ii
         ZaKqZIj6dABJLhZrZYpvWxjSFgNqPRL6kroYyr0rWzPCzhQGfVx17tXDbctCCjlyraN8
         zMADneHoNKXfTZHHyaf1cVOplohvQyfdoeJ+bxGGz+0f9rmQcN9hM/0geK7p/UJdVf8Z
         vg+k2+X1Z131/6Xs/ZblXaLhU6tqjIcEtnDA5iNIz2ZCUm82RFuWNHUEpeMFSO6daq4W
         pVFg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9UtuSJFwEX2/Lwm71tUvzfrbmozncAEzd4DWjt9Z4Iggocw7xECY62EHutuCKpL6DIU0gaIu9bA==@kvack.org
X-Gm-Message-State: AFuF++lp3TxYTIIcyswb69wGOX5Zn0FctXJj3p+mjpemeGBb/okLxPm5
	lI1/H9aj4/hxwWHO96CC/K5g3vH7gE6Zs/k51xvI+Y6IvX1iA4fkj2BP48tktqOBetI2Rct+EvY
	SQYF95De8qllZUDO573a3zbfbOhLF/69SjyLC6rQQGQ==
X-Gm-Gg: AR+sD10c+n3Gjrr+SmsOWY9PY0TGYlwCuEQ6iIKGTvXbCvv94/TvEnglrhbaHnqnI3z
	H3M0wt4oqX69Z0EQPTOVIzlFJwJGymy+vpqe05jjE197T3Im03NStcUTWa0lXuD8JwE5XEvYfHB
	K/HixchCuDi7aIGKNx7826SlQ61o2fLFXXfZhXDY2bRyxDyOa1MgaLimvd3bxrHY6Nn2HdtYK9j
	w5zv993D5x5mW3xchKQAhi5pHVjAm5lP2Ogo+ifM0Mc5uHYsqweRkLLQ4eU6PR5IpiNdo5ZLLgL
	YiMzkBVD71b9pJVb+n4uj/PlGG9//WZfRWtcycZi9XK1uY59Mhnyi9yWt06i9on0AYeXkZZH9SS
	HKv8=
X-Received: by 2002:a05:622a:8416:10b0:52e:1109:8f6d with SMTP id
 d75a77b69052e-52e1109944cmr94356391cf.42.1787579392384; Mon, 24 Aug 2026
 06:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com> <aoxHOSC9kTPbKeNq@casper.infradead.org>
In-Reply-To: <aoxHOSC9kTPbKeNq@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 15:49:37 +0200
X-Gm-Features: AcwNN1WXkLYVG2Rn2OXRtnBdlHWAinn8Fn4WcEVqUKiB1DB-194nq79209afcM4
Message-ID: <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E9D9140008
X-Stat-Signature: swph8itcaekbfkkdtbosbsap1i71ddiw
X-Rspam-User: 
X-HE-Tag: 1787579393-459313
X-HE-Meta: U2FsdGVkX18Z/1KeNWyL9qbd5/N6pCByMqpS/9G1+/Zeopn4sN8RUB/9lPIEUU4f7z3BIVL+/vYKlbHRpa4Rt8tjp6I4Ufl/Oha2DdQoxW0X1DLiybXwW2xPtrhMyz2cCWbDLxq4bCJWPjqP/Fh5h1rWCrVu56v2LzF/uDD6BeJIcdHk2Vt5uOnn9GeQOvMrEUKq6nIZHFyTOGev+6/OCCWSzK+0OJ3/kmAITP1zpEWtuIIQbi2zsi7wtk+8UiwVChfXVWhn2Ix40dWNRLZRJKbxWIrgDeIQBciwdiHMt9r065kWLtF2IrWW+yjiROGuBr6a9xNo3JDVAIHaQILH4KQ7tuSwSLUzKzeTt60F+hXKzMUF6BTfkk7EWdeOy4bF0jmnYn0hcbpXu1+4L4g56rYaEyNMO/WC/iKzwSX0r9GmOjyyIcbzSocFRGnaeisjji03R8jEw2tk5GQ5nI/IFB0tWHTrUL27AyxdCzmUPIYnJvJKzKifUzfFdjajBoLPNS6uBRRm1zmW3DnXJfffIweX4z5PuN5J1wCRlFm7vwOhyVY4oqp/3m6qwOFkVFfV2ZkiQUQRvW3mrZ/2tuVMEgEqXwJME/gkBFqg6T3HZ3O0nSPN274635A5uy/szKTqt5afXpM02eEfC8Li00QgM6OHc39RUydRZWt7tjBlIE683YEtoaZdW37UYIjH/9yOk7I75SWFq0F7t62RL4Jo9SqpuzgbalalCw3Z1gnoNJ6miIzAvqfqTByTk4Y9V14jorbnZ9HDBYdgIZ0pbciiQylggiJk0+HBjUfISyY/hMIdI+sEu9Le9GK5fqHPiwJ8QaLNR2zN5Le+P6yeS1YTOsNhgSYNRfXA42xld0CLFZXpWShW+jHWSU9ozpy0uWx7KNxTogjDA0igAIfnGqe35TNcsT11H2neuds8LzYhgD3E9EocmBvRFAfnPodZA2Cg9KOcYvVM6IGhInF7akX
 K6lI7rhl
 KmZ/X1waPHbzEh7s1nBkxOF9X6F9DCOmQFjEnmE4J5CvFc4Ldz/r9jECAh8xWeAgYB5yIfM7lGz/n0xp+nO4ubSFbtGlcXQ474+EAbbuikCHbUItOP6p6X50EUERuxQVmb93AdzgvQ74Jw2fnMYe7kln0YPhNioVPI05U7lDZjML8rjsgz3RDP4pp6NTHLhA01LSR9E35/ljEHc4q1x/5ZilBLRo5QAHYmt0BX8eEVEuDGWeR1tFzUXqdA/GG+u9AZQjTV3s6exDcAv2OS59T78wfBF5xw4Fu0FdYQ9ME6AlQ/p+l05Kr4CG1a+gE5eA8ZsJjOtz0TamGFcecp5OX7AsFWUdwnBgRAVdjm0rtHLY4XXuT8kB7ZH/el7VmSW5SpC48jA4k7CjLBteRdNwvezrrxbMY7QUMNONAJn6K9omnblY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 at 15:29, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Aug 24, 2026 at 11:05:46AM +0200, Miklos Szeredi wrote:

> > Maybe add a variant that takes that lock?
>
> I don't understand what use that would be.  As soon as that function
> drops the lock, the pages could be reinstated.  If the caller needs the
> pages to not come back, it must need to hold the invalidate_lock across
> the whole operation.

invalidate_inode_pages2_range() together with launder_page guaranteed
that no dirty data remained in the cache after that call.   Yes, the
pages can be reinstated after that but those need faults and the
server can then serialize those against the invalidation.

I don't see that guarantee with the filemap_write_and_wait_range()
(with or without invalidate_lock actually) since the mapping can be
dirtied again without the filesystem's knowledge.

Am I missing something?

Thanks,
Miklos


>
> Before any filesystem people get funny ideas about closing the O_DIRECT
> race, you can't do that because you'll deadlock on doing I/O to the same
> file that you've mmaped.

