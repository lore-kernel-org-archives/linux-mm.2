Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45C3BCD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85256B0093; Wed, 27 May 2026 02:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E706B0099; Wed, 27 May 2026 02:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDB76B009F; Wed, 27 May 2026 02:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A26D6B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:33:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C31714038A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:33:24 +0000 (UTC)
X-FDA: 84812233128.19.D0E37EE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id A681CC0008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:33:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L292o9Bd;
	spf=none (imf28.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEdEkrkWD4PUlydL5ruu4HP9SQ8xgA8dkqdrg8+Pz5w=;
	b=qO+lbktwW8Xpxxu4OSDn7f1VLyZxYU8cDDBqPzKzPnsW3YKLux23oLIs+qEyU8/bUfKxjV
	P9CjSmuLOAXZDYj5WFc0/8VR0jAmVtIagWD/Tr4h5Q0b4sIge2dWImgBQecdWf1VZg8Apm
	ThFqqpnELV4GSMNtG+McheJYpqd372M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863602; a=rsa-sha256;
	cv=none;
	b=qL+wPN4RD0upqKftFlY4OZ/29hOXp7IvXY+DuDTVo92KxmVr4oKv4LFc+0dNLfVjNEEG6V
	nupByUx7nLOaRw5edqrDRcAi9uOTdr7CSrYI1JLbGnx7vvJIlXi/8/xx3MCbtuA7Yl7S74
	9fFOccpn2TvAr12PRHV+nlDALyC8e8w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=L292o9Bd;
	spf=none (imf28.hostedemail.com: domain of BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+e9735a96feccf8b5d28d+8312+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eEdEkrkWD4PUlydL5ruu4HP9SQ8xgA8dkqdrg8+Pz5w=; b=L292o9BdhdzRX7dwCnyh8lXw/Q
	aInv3spzoL36ml6byXQJAIP6c9rHzdAI5XAEMaBYcWQ5td2NKk7V0VE8JKmrjzq8K62svpG9FXk+c
	TFZvUtfQPoTtDUuw2y7XIsGGA/r5AtmGWBqsmyTKCqbeS3wZjw+Ih11M0mxzTfHQRUa+vlwVSIcUc
	wbRyatrxwjWJ6C/55O3pN/OePsPXDeFlSRao18JdofJn3iJZRz7Rr3oLIEmwxK6SU/Fsbruyfp+YJ
	BUdSW/zV0p8QL1lTXQMNKb89ugT8wK+V4ePi1SkXf/I6ET/GgcXt4J5GTQ0YYHd1Igil+9vMYCg0t
	eLerb5vA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS7pQ-00000003PH6-0KFC;
	Wed, 27 May 2026 06:33:20 +0000
Date: Tue, 26 May 2026 23:33:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahaQMKe7qf63wqni@infradead.org>
References: <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
 <ahPffhaOi2CBtWof@infradead.org>
 <ahT1nT3xsMGkyJab@google.com>
 <ahUF7HqSKFJ422bU@casper.infradead.org>
 <ahUX4tBeLykdQNxY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahUX4tBeLykdQNxY@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: A681CC0008
X-Stat-Signature: m7eyj6qgt56o7uzpy4ou3nrhygjmd51g
X-Rspamd-Server: rspam06
X-HE-Tag: 1779863602-493903
X-HE-Meta: U2FsdGVkX183NuBt5gorXXB6opzWBEW4DbGwl6FOFbDatha3SVU1wZXIQh6IrNuzi3kjmDiv1UMuDY+7iNnR0EqHOWsauMkhk/gb8JSAn01M7lknfzMxyusae5X/y0pex4QyGThL/0nAvdLR2hGcpJ0HZy0zPhgc2R5twj9ituvIqKcxrsd+jXSSDWy5m4gAbjklvXJhbJQhqLEufc2veF6VglHotFI7qDKiSNr+ObMPzUDZCL5ZkLgoxTzEdkqsK9r/rkVUmTIEYSH57fknY6GfJDFGVG8KEhlQzvvI3OWZxaraN7Tv3+wama5kacUySjJhLS2B/ibrJZ4d0xea7I3aPt3Qe0jD3K75PX+luorhCkSIYPzw/tOESyLQN9k922LGYUdfT1j6dBu6MTA99RUAFtzrR/0Q+9/62W+G6/UQehJlDBN/CvJ6CYVPvASbnG/Vticeao+jIWqOPEGwMCVqXMUmxT3WrTNrkG+22kkRas30xNk0uZx4NV5lAIjIF/VmZQ/i8ZDCV8dUk5XE5n6AOabqHXSDsEcwKNES9w9p1Ozhv3owjRapKg333Ni3HLwWTKOkvCcb5OS4uS9zw9pibfNeHifRwdPPm01Bf+o+ge6nZMtNgKL8/Vy0jinVvj3yNMBeIWMQBNqeF2bQv+1jFyFZMNMfsnnQ9pr0blQOaVe1CRN1SE0mTAFtAEJAlRDcShsvP0F0PUEA9yEnkgXsoefIhKE9vIBO0yRVArLY95lAhWKlzktR8tUjoXlBPuofA3I0pRVm8mNZ5I/S++S5cmXQonWRp7CbF84gkmNfXchpgJbbkOpYBo8dogpKtz13pTZr6p+mWLynu9rooLMAc7+aXnepT1ylLMaBoU+xFd1DuKHA5CMucZZa5X9cplG2NJQjy93FJNorveaAzRp3c5HRiO+Si2UWE+XBRhWKHcOj5yISVOBUQUlzH0IHeNov/1CUY29UToEHxV0
 A1BnhgnG
 WWvCMYP5oRXhgpX2xzxVPWxGZi9BnEKrsSbnlWSjeC1a+487NDY3e05qnSOVRxc66VsFJ8GgswJN8jpIKku1IYOKoCry1VEAdVOja/NuOXpXBCI82PHatiLMhjJBDB4zr1GtBkAMkUUAlW4edyjDlWgkCFj3tuzCgQUDJltimem1HUzX8fbvsxL/3PW+qZ7e0RxubzTlCLjLvZXWUdaoyHjAXk8q4GRXcADGIFZ7Z7lLixJFCXZwclS1Vknlxbz09aNMlBvdmbKuVAAhqjjfT7UpL4r80oHoNvSqaeLVvcQ/G0oEFiJ9lBwZPaOS67OC0NUl6lCP25M8bbtSFHEUtao5U7H8VJNJKfS9N2AzfTzHTm1kHREdLPdmEre+TMZFuMPTBXfyF3Lba4pWpKDbIB15414Bh1Sb6oXgz20CX3J/AH6uOOfLtgILaQs9clyFJd823lZfetQJc5t1G9+0zf14Sb41WCaZ+hXpnUwGW/H0Z7V+e5p4qaUU6fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:47:46AM +0000, Jaegeuk Kim wrote:
> Thanks for the feedback. Actually, I tried to do compact_memory before doing
> read() for AI loading, but I got complaints where it took hundreds milliseconds
> to run that compact_memory. Is there a good way to secure high-order pages before
> that read()? It was quite hard to project when it will happen.

Make sure that all files use large folios as much as possible so that
you have a lot of clean pagecache to reclaim..   Same for any other
easily reclaimable memory through shrinkers.


