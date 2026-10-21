Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B394606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FUTMIgoS
Received: by kanga.kvack.org (Postfix)
	id 4DD036B06C7; Wed, 21 Oct 2026 07:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E066B06CD; Wed, 21 Oct 2026 07:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A49E6B06CF; Wed, 21 Oct 2026 07:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19C3D6B06C7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:31:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1350716051C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:31:25 +0000 (UTC)
X-FDA: 85346417730.29.8DA652A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 65DD4C0007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:31:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUTMIgoS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792582283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzXLUvvYElCIwzO2oJqrs76hOODnjOjJTUE9c+S1f2s=;
	b=sf8L7bp8zjgFRaK1hoiZSHEfPH4+VERLWA9AQOtPbaJzYfym8iJSol6kJCgMTCR57IMsvF
	IZYTUIgQa4yNRGVSL//hhjNK0i2teRoRkizLYL2AB/YIIXXs4vAbI9bGA8YSV/599UMzzV
	aZKq09aksq0gWV0dDH0hRacSDGlsL/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FUTMIgoS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792582283;
	b=iilI008nqLfHsAgegw4A6e791RS09KjpY7S1ucmAuK6rrr6sKlUo4x/Z+jNvtnFOgd1tXu
	Oi5Ku/Fai5jMfJsAQ8eoXVwG5laVdrmg0C9EfO6QMiW0m6IT5hGdNdZXe1ZWS0WLjg7SwW
	1EW63NWqefb6EeiFllL6cSJcq7rD6Ag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1C6F41868;
	Wed, 21 Oct 2026 11:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5BA1F000C4;
	Wed, 21 Oct 2026 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792582281;
	bh=zzXLUvvYElCIwzO2oJqrs76hOODnjOjJTUE9c+S1f2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FUTMIgoS+aBlqZ30wPqkpHMjxDoOzCNQP8AcmN02c/Vui2ZVKWu2TV6G7w1MVgmzF
	 g2CbnmaghbylXozWCMrwomnqsEcQfOjjkjEbOja3V4oOgXmyifUY1QfMvMZvGkEo/B
	 ganuKIbPE/Y2IJjKKUs6SUbBwDo2UFk6E8M6FD4IGbBGc86Z8UXghsEowXbqHWAXqi
	 qefm14eZ+bogHps6bDrZRSEVYZ0OybF2UHjAoLGqO0ZR6oOS9kfsfmfQR6j6FW/E1I
	 a55BbfxniS4mY1gkuGZntZwf6dZSLF4xZOD7ZfNdxmpT4Hysdu7kze5yZe8TcJPQBo
	 z5xxQAMWyMRAQ==
Date: Wed, 21 Oct 2026 13:31:17 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Christoph Hellwig <hch@infradead.org>, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH 0/7 v3] fs: Deferred inode reclaim
Message-ID: <20261021-korallen-hochzeit-jargon-5142e8e15fa7@brauner>
References: <20261009133253.20102-1-jack@suse.cz>
 <tsjar7j52anyxrtfdqfhmp6enu4e32hsvtitk5gy3bpxvagsjx@5exi7yidgf66>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tsjar7j52anyxrtfdqfhmp6enu4e32hsvtitk5gy3bpxvagsjx@5exi7yidgf66>
X-Rspamd-Queue-Id: 65DD4C0007
X-Stat-Signature: c1aqkftsughyey1mkbkxhn9s8mqjk1oy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792582283-509735
X-HE-Meta: U2FsdGVkX1/Wlf5Yn6ZBMJBHK6fr4LTZHTbDqyBM1rhl3Z9OmoRoyfO9BPKeNOEzWTeVI10adYx8zKQgG8FbJI7j8yEkKxBHryDjDhn5KWDEn9okPaDp3SdodEw71yWCjmCQfESNvcZuLYvlUBD4HabeuPBR3+KgTkuLOmVyqFVNTtFlhxQiUZMnFXr8b5lxRdjvhCz9mMftFFBTZ4/UiYwIPtqsOXPpyMUDssNOjE648U+WNdu9ILR4FVURaSlzrzY2JowqkODgiDTRQmvgmuDHIPjBwqx654gl28NBllgmcRqZX/RMXijR4SJC+uVajCMyk4F/3nxU0kK+5caeDdiCyIWDd2CniqGq9ntdJe4Qs6fadTvd8i/LXP3QfUO4iwvzR5vGKgE/vux8xdvO8DVe8Kk29LucZXsy7PdIh6R+dkCTA172HSEGBwMjzUxqatg52eXVCHrIPUVvRfcMoqHOfqYTUthu6ImlqPDZmrllfcQkXaqiz9tHU2dV0h3kiJLPr323nERYOo8a90wq+eD6aCLPninthzOzzS4GfMLhAI3yYHmYQTaGsfGfZXQE6Ub/2nG79kklbkt1rtSUVAsr7ncSJMPdVd1cMSJMcxqcxhMT+hvpQzaoZGlJcrmQsvL3RIizVd71obuZuoW9P27bO0maPd7WkGYXYvf6HHvfIqBD50fCCbE7DhI6RuvlRuvEwnXHB2/qC0+993B9ec7f4vCoQIZOmkskAD3xVT/42fPcFitpx32/miDC/bjtkZ0QEChxqIPgM+5cV13aXqUN51lh4btg1kWCmnFCFFHk33PJxK/AvY7qFBDLr4146JXtyq5gpBoOIFjRgNbEd4VyywjWZFggvrErwjnVfoMdXAL4kvmMlEJaNM6JnjFJ4Y7rUdHp+ojAyqeFQYT3k+SMeXTrU93TkY0A+w8J9POdvXk3mIhgSnToIqH8Gid3m2B6FV5n1Xwzjq272Gj
 +eHUOJj7
 tMXCZ94UR+/V8GVhkqSS106g6HaUIsp0GzrstRlcn+qHS+Tub+UIcgTK5mVKuLsPms5au8fdJ3tssaL3db2N2mIfJXYGicZ36YRIk9LmbOXqBy3w7KjdLQrZT6oKF+IA5/0h6C+pnuYD+Riv43Xv3rRig3YSj0uzpo2dbQqe5k9q8hpdXXt8R9dLjULJZ9oHndhIlH9RaIuUncZphSBlhD9NeGWJmYkfLgytydJa3D9PWW8oom4OT0Iz1lXRPRDc/ocUl8oSopm7/opb4ZUTjlYM1IZMH2H0fDpps4WSYj4XrTrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 11:43:58AM +0200, Jan Kara wrote:
> Hi!
> 
> FWIW Sashiko still found some stupid mistakes I've made so I'll have to respin
> this. However none of the issues Sashiko found are fundamental (just some
> memory leaks, wrong memory ordering, ...) so the overall design should
> stay so if someone has any comment to that, they will be still valid.

I do like the direction of this design!

