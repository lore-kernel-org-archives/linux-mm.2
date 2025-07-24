Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E754C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D1F8E00B1; Thu, 24 Jul 2025 14:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313338E007C; Thu, 24 Jul 2025 14:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250248E00B1; Thu, 24 Jul 2025 14:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 159218E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4BB1133AAB
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:53:04 +0000 (UTC)
X-FDA: 83700055488.24.E39BD6F
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf22.hostedemail.com (Postfix) with ESMTP id EBAC0C0003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:53:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=G4npzWaC;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753383183; a=rsa-sha256;
	cv=none;
	b=NBdA0wMJUJdq+Tg3b252fhwz6benrXR//Y1O1H+b0jHfcj9gwK8TFLLs55/VXuFgUGZKCr
	y4xVcrGRqKz/LiL081hQcKhAkL6rHoJLJ/kglRrqSXDDuDQcZkCjOjvlG7V2OsN9aK6UPB
	+YZsWomBiapGB5OjzCc168PRF7Lpbi8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=G4npzWaC;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf22.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753383183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0Xf0b8DinK01imbKK6i64vZs39pYDGJTQ5VYvwvFoc=;
	b=5yPFE32YPkcZnfu9Al3U2gV+ikatHvb3pJhx7IZKoPzqmBsyj5SL06GzTiiA6n5lTJqfJR
	/cQS8ClSzN4h9mSs1lSNIhu3ZMvoMLId9BobACMWhKwPYxKkvRdOYWcdBQyVgZQ4rQlwj7
	iHnl95uY3sY5cXrtQKmEuM3im65yJUE=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3EF3440AA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1753383181; bh=u0Xf0b8DinK01imbKK6i64vZs39pYDGJTQ5VYvwvFoc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=G4npzWaCRHx/kHnsrMIeGN5Ihq3TLvct0YEtFNcm0vllmisIQvSuDqpIJsBg9Snxs
	 DwkzjBwBhwcoHED4WgxCJab3d/+3Q0N7M/ZSIQ7Q0DCBtPYlGiicJYpEekhU9v8N7T
	 1kIbJDCapnNj6g61YNDaqn1bE4cpIiAbCpZ651+ZseHG/gpNhobMHxbWWKopdM2oVI
	 TrCzMFN0VAQmWCL6Qjpm1xJr7AcWtwokqkggYQhuTa8aOIPKctK/qNr0EJquNO9fbp
	 z22+COmDXDHFilHiBn/1MosmHguYzXr/9mQlf2+z8//depVNZIOn8CaYdQThHNkeL/
	 q4n2bsrri1Jow==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3EF3440AA9;
	Thu, 24 Jul 2025 18:53:01 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Hildenbrand
 <david@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove io-mapping
In-Reply-To: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
Date: Thu, 24 Jul 2025 12:53:00 -0600
Message-ID: <87y0sd8lpv.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: syncjcfxiqbjpquintj1mbs3gkn39ujt
X-Rspam-User: 
X-Rspamd-Queue-Id: EBAC0C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753383182-375672
X-HE-Meta: U2FsdGVkX19OWYF5SBj064zwUoK8TER/EpxJcPrketofh7JUvg0OqIfEfC13dUPAMOh3TqNa5+CetoZQLS1JemJMytTVGnGFKy9jBYMs0c3So9ddd4UTUVDSfpnUyBmcnzZCcM4zDTFIten0GvJTgSeElkr4Mm3glSjU7uR18ZRKllVZ2wub7wpFDjGfK7lnCzZeH1d/6gyqmVFffmIUSSJ9aaHpTl/vx37PJ+53JfN/nhyrY+coKzPfzpKMg+K33GZ4nz0Hqcrjb1jAKxxbc/FyqJ7cIZZAzcqeVSEH02JpADrMz+Hz3zS6OP9kA80HMB3/aeyqJyGceeEX+LW21S356KljLZgIOrFBBs3tqL16YL8dmVZd8cfniNwUh1A2qjlF9MPuCiDPZj6AM0FRCAK/kDPIj8mJ5RuDMljpQlsxzYBhzlBzx/2+iZOCshOJ5AwUKdE4VJds0QV8j3CWbGnB7mw90p1tASHbGGgn1lnf3xSogG+lqSy8fJvcKrRtjysWkATBekWYp2Zs8R+3cmJi0s5hVNTUMNEJHlSVELC98qS6ZU491LTa7MsRnuzy2P1/HOiiwUYM6wMXkYN94Ngq0u34ZuyK851nNCJGIeaFSrPK94+qxVTKZ/MSJUUX2RHuJeMn3iz/3lW0CkeCAD0OPD+pFQAOngbr+KMn/KgQRCOfhTNuQV3dXZNlnc+XD2WfupUhgsft/PQnIduqcCDeyFdinEjEcyIM79rnbVmBBEGz8zSruzabxFAKKStZJ3NLltuXX9N/hsZpCqrEQ9GheGDyFu+jNaUTTEb25r8n2bI/V8gVh+vR+U6t3dpicBhMmt0HmF+3zz6uALTmn6tNB5or/3jg3gp00x3PrqAn7qwq7nBMXmf/gE19hiV7HXaCuzxu108pbHht2vAZZ3oAce6IVnTWVTyR7NVM4Q9wiTGLFZrXJt2N8JlhpHGJUAdJN2sHP2JsIGAKgvh
 bNyQY1De
 hqv+z1GegWxIJ0WlQzqUJsuClj4ZX83SeWFRVRYN2UpC/zmW53mx5wv+GsnVAelt2LQs/8tjmMJ91z8OP7/e2b1tcOR0AGNdBlVC5+5WscwAFqa2JOOeS8dcwL5BxTwFNKcv8tJvG9GsQWXrEq8aTs/KJxznk8HLU7tRIcCdEd3P1LAkm1DW3ENn1AjdPfdGgxr63XV0XnScKGlO67L4eb8CHKSyZIk766Wk/og5vqBoASntwwnZ6x1alINGvzKqHj3f7YFLTKIvpnXxSb2G3JbXM5XWbgTmozLTHoSXtDvPLOVsHuheuiq/jsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:

> This is dead code, which was used from commit b739f125e4eb ("i915: use
> io_mapping_map_user") but reverted a month later by commit
> 0e4fe0c9f2f9 ("Revert "i915: use io_mapping_map_user"") back in 2021.
>
> Since then nobody has used it, so remove it.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/io-mapping.h | 231 -------------------------------------
>  mm/Kconfig                 |   4 -
>  mm/Makefile                |   1 -
>  mm/io-mapping.c            |  30 -----
>  4 files changed, 266 deletions(-)
>  delete mode 100644 include/linux/io-mapping.h
>  delete mode 100644 mm/io-mapping.c

[...]

> -/*
> - * The io_mapping mechanism provides an abstraction for mapping
> - * individual pages from an io device to the CPU in an efficient fashion.
> - *
> - * See Documentation/driver-api/io-mapping.rst
> - */
				      ^
				      |
You'll want to get rid of that file --+ too

jon

