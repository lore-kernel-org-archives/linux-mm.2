Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B7521091910
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8213B6B0588; Thu, 19 Mar 2026 15:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1966B058A; Thu, 19 Mar 2026 15:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7100C6B058B; Thu, 19 Mar 2026 15:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 60F856B0588
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:00:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13DFD1B8811
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:00:36 +0000 (UTC)
X-FDA: 84563728872.11.0025BDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1912520017
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:00:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDo+RO7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773946834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XiyVLUJAGce818g8kluLUhKj9rL8pI1k3+hY2MNTbYM=;
	b=YeVdclUmeD7FOC+nPnEpU4rqdNt0XXisEOGfj0dSTggJazy3bRoiU4vd6j/cwRT9UI44h4
	vMWY/tG5Gj6c1UpXpZze0fd/4ySk5ySK+ysRGM5aIg+xA84TvSBF10QVq0Zmia1HKLOXwE
	N2Vrod1N08Lma6ARA2VoH5jeTDTfScw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SDo+RO7s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773946834; a=rsa-sha256;
	cv=none;
	b=HLqYi5/IzWNgFvFdQ5YFHJrcWPYjjDyANuKWufc16h6IUokXIwpXtrRQWw/MmvLLcA8JwY
	TLjRJUnyy6yf8u99YDj9gl1QVjv3Vpz7NTy+b5aauk5nBPxIgP0bq2aYO5YBh0DUaSvw+r
	OOuvqCOjCJjRVm5aVhMxgzsYd2lfaUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00F33417CC;
	Thu, 19 Mar 2026 19:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD55C2BC87;
	Thu, 19 Mar 2026 19:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773946832;
	bh=XiyVLUJAGce818g8kluLUhKj9rL8pI1k3+hY2MNTbYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SDo+RO7sTB4Fws5YXMq0JNAygcvx5h5unVl5OBDx/Hvny56UEtubGKDO5Z7QNtQ4F
	 q0IFRvgOlt5nTEDrt7IjF2BJ/OZutpMAcZjcjqfFFS1fsJYlE7oWA9mW7SRvneD+/3
	 jfgtGYwiV7avtsPSe1h13PtuitlTP1nBGrV+LLDYwvAytTY6NwRcITV9Jip2KYKwh6
	 XLRr+beJcYBT1/bjuQBfEAjZGMd++1MW5g7yY5be4VycisLi/Ymj+gIesUyTTo36pw
	 ETcimGGmygYrp2uPxzClL9HolFyLZ+ahvRbit0WszQOWNv++EQirngnMEH3UpzHSb6
	 jP/4U+mV5HFvg==
Date: Thu, 19 Mar 2026 19:00:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/mprotect: encourage inlining with __always_inline
Message-ID: <1593c609-9926-4ef2-a5fb-057675792a53@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-2-pfalcato@suse.de>
 <cecfa4ac-1fab-49c9-be69-0071596f78ce@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cecfa4ac-1fab-49c9-be69-0071596f78ce@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1912520017
X-Stat-Signature: 3wzkej4omb5gg4gmwg3qiexqbpf3113t
X-Rspam-User: 
X-HE-Tag: 1773946833-3821
X-HE-Meta: U2FsdGVkX1+ioFIoTwCIMPFv7moXTvMpVfpiJNXDJvKI9bIXrknN5NTwWu1KMtdgXhMBuCZCCGdK4QZRvYzlnqRySp0Uq0wuoQvRyYKh5EEcepRvU9LcGauzL0BuxtHZzYhwu5S5uTLf9T9B3DfQAabG2Of9j7WcGYXbblmNGxDY/lcAvBYAhfQzwnA9gffTNVCY3+HtHNSG7Mq44vG5G64EMc09psNxT5XSYwCGbFlrzGYuwg5NG3jG3w+tsX2+I69P2lyTTeRsNXUCfiWj2HOv9c57K9vzIF8qDjgEmicoKAro/RWYQSKfErFi4wpiP3HvcVvdZwW4jtsY/Lct0fMfpcLYVa9oVamxtdlC0bG/dZ/7SvamuLX/g77z8VZLjA6IT++hFF0SW36fwsrhdIKEdhRLP5JfXUUm75JSbrNGWqYXuCeLFxatyPK/aJFNLy1Sc7syDtQA0vaJu0m2fytxhXB/kQS3do30xuB+xaG+5MdcoY8kqYesnUts+/cefMmdSxfFzcCebhJgQQi0QCmsseWRjz0EW2LiwuiAvIOIkT+K3TaDWUFsGfua0YBfLZs+rPHch9afaX+CwNOMaG0BLFAAbg4CbVoq2uEeoCDvjg3euoAq/PE89yJ/JXZeVjnz+rg8gUenfqsRZ6utmL4j3jHwv97aDF/9hB27RbaA5GDyVvvtx3tjhW62x6Tu6Ccwaf6YsoVDLUzkUhkDGnqhkQb7G2QZlFCnlPq/qROkYsYWnJ/qX5XDAuDPF2kBliSz6nNfsnPK44oz3LeuLD1C+f8M3ClPzDVjHwqS7nMwDaUjKQXTFKYxkooPBcMd/Ec9B1X87FHvqFTo4JKBBglG1aB7ODaCI1SxZi/G28uOb1dfyzacfLAXpg/AiTQbg+dKlbxZG8bimHaFwp5gkYGgFBzQqbE9x3aeZveY6yh3scpdELHl7LEev83ep/FH/fc0jcBS6ZkbSiCD5Oc
 G2L7mMcG
 kBUIiwyU8HSiczcK+GZmvJt0Ajss1Vls42grMwmyJDP8VKycfSgC5cyzacLRdiKGcIiOIT3gRCmhA2w+F1vFUUHv63eiZrKvBQkxx6Bjr8UBDA1WvwnDz+9eA6OUB0zELvYoDo9t2sKY1RvKI/I358zgbRxmkk2XjUeTlQJrNHyfzagMdhDCPrd9PGbQRaU9WjTrTnX2UQq5VDZE6QFkgQHVIFw6RSzXN5C/wM1r4JNz3uF+MIi0rDQ7sm9OA9qAcC8p2Gl1dsk+q/UA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:59:37PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 06:31:05PM +0000, Pedro Falcato wrote:
> > Encourage the compiler to inline batch PTE logic and resolve constant
> > branches by adding __always_inline strategically.
>
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>
> Does this vary by compiler/arch that much?
>
> I wonder about how much ends up on the stack here too given the HUGE number of
> arguments passed around but I guess you'd be pushing and popping some even if
> these weren't inlined.
>
> I wonder if we wouldn't want to carefully check different arches for this
> though!

BTW have previously seen how compilers can be suuuuper picky as to what inlines
or not based on hueristics so can see why doing this would move the needle if we
were sure it'd universally help/at least not cause issues.

Cheers, Lorenzo

