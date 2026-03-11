Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7381049528
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035146B0005; Wed, 11 Mar 2026 05:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F215A6B0089; Wed, 11 Mar 2026 05:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E282F6B008A; Wed, 11 Mar 2026 05:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0B5C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:59:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C8CD1B88BA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:59:17 +0000 (UTC)
X-FDA: 84533334354.12.AAA34D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D480C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:59:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GE3fBRAr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773223155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vs99GcGFdxVlcNduLaezfOqApYTIq9q/y0UMK90fge8=;
	b=sWUNT4ixQos4GI+WcNqS0RsfAaelxx3DiZAxXFzi+hjLP3QdusJP8x+53zaT8MhIhyV3nV
	OK7ISJ+6IkyIWMRR8YhUIy24wcPf3tUzf+zsvb2S5N9lWboYqMiGPJIRwe0wwnwmaDf0aP
	cb/Z5XDAX/yLXfU3SWl2DIS0qCcKO1U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GE3fBRAr;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773223155; a=rsa-sha256;
	cv=none;
	b=udWPxbXY8RbNFghV9w24yWHe3qp0ugU46DrDPODrofF5sIqoY0SpTrH3HYnf2ANOZz+kAR
	7r9QgBESJZxL0H3t6KKocwDxl7QWRWFpYdIOgR1NvXdQ2QTKt0keUw5Pk1UBjOpgDirnXx
	cyCk08EHsNTIiOGHzh+N42GErcI5pP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3F57600B0;
	Wed, 11 Mar 2026 09:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B46EC4CEF7;
	Wed, 11 Mar 2026 09:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773223154;
	bh=Z5NUwYdO4gon+w2RD6G1dYtfGgOROmoRXV9koOGJKd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GE3fBRArehqOWxNpJmM5YDSEj3wW4xPPQuT2vIxwWBjmryEYuo25dK7VFxbSzNXBd
	 K1uD3p9/Fy0LVnjhXFG4TjesehsCaQhTq5YDbpdYVVjvSFQWQlooopyk5rFupsurrk
	 0xagwO6SlrdldzpCv6BBu68ChDRPlwWFjyj/DTcxEVmxyB9dJUU+FxS+jmxgzDSIPy
	 cAnj6e6BNviJY+cxnCSBHq/QqhYbjJ+E/yWrTUe8twO75oiGbh2YVl3MHcuWuciO4B
	 QN17cJrMkLTvAwiaY64G0iBd7Rg9DAPQeMmVUE/LwRlNWDph5wG4Be15NzTYKL4hOk
	 5XTtfdhikQDvw==
Message-ID: <5fb9beef-b6fe-401a-aa24-aade48b795d4@kernel.org>
Date: Wed, 11 Mar 2026 10:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
To: "Boone, Max" <mboone@akamai.com>, Alex Williamson <alex@shazbot.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Tottenham, Max" <mtottenh@akamai.com>, "Hunt, Joshua" <johunt@akamai.com>,
 "Pelland, Matt" <mpelland@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
 <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
 <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D480C0009
X-Stat-Signature: 6f8u6t4kfcyjhp7y1awwuwetcrx1i5qr
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773223155-234641
X-HE-Meta: U2FsdGVkX18LF6oRoPJxAwLq7P/xOFLmD8K8cg6xSAa7niAhCQdQPg2fh3FjxyI8djjDMKXzrCB61+K5LuB/ibbvRLPU8Ew/p4vKfsgVKkDSfihA6MtPy4ghd9/eDtkru2hhAuNjwfh8MCLYYpS15ITYc6Am2uvQiBRKtdeHnGF1qngcBgajqMN0EkN0vrkR9iyJG2y80ru8UJpFKLoSgeNTWkv424MJxDvFTqgziHUvCk3ntWkGfELQZZODMJIFo9knJItmPyeyZCHUcK3O6nHTySl3OcIQWLtQply0Gx62F6sBy2pF2l/M6bpFx7Iz651SKsGgQyedCp6nU+UenZbw0ALqtfaUqgxGjYw9kN5boluVVZ4eTbT6WNHN26qZs4upryjzBDG9A24OByM6SNf8xowaoYWN4eSNHOCq2beA5rRgBwnH+69ibDRDk+F/GnD94O8PbXkSyL7oSxOx2+U3AcgC3fNh+dHj2HbDCHHbTccD/aPLMGjeQdg9nKd8LRkSWSfYJmtuH+624L0x3XZm4dWwX975uhA+kYRzWdAEkhuPI+wrvV/bAJohjQmyIgEleIt7W3EgKc1fF7E9VFQWqbVlRQWl0g4hp5k90IXWTlt9eYt6BxuLFkFulm9QnX1F+anKJT3upPifab73nbyBX9X3RgPqXPR463X2XDidloR3b9VbwRF9T7UIeXqHTNF4Kat3VmTcXlMQ8FZ2nAqL//sItW0vVnklLt1IHeUqunBaAC5++gdRaAjfXc3zL5X5+0vPMJ+CtP+eQ7jBUY/hxmDkrwfYoSGmRNykhJTVn1xG9WTR+KYXDR6VvwjQdZW9MjHxsqJ9gGTmse0zdun/pxwfR4f/DZLletzld4fgKTgiwrqWh+DOp57qX/Yqfjnd+rqLRPxkrBCuwDNGMco4B9iMiKmOz/Odex4slBIxWiuSAF/1er5qroDbRkmRQg8LfmlZOaNzZWoDAAH
 ogjvj2iP
 VygY4DZd/4RC4EkVwOiVyeZHAkxRuAiCX8wyJ39HSdMkgcObmkiDbPuSwQqyWudDiZlGbLYlgvHONidpHiWSd2cWsKzRQVzTswTjhpG9fVV5B8q7GX5m0Mm3EblKl5a7dn6OeJ/OaKCxSE2vMjDN5tJsbBZzsJqBitsg7XbzGV3LlZHhuMxJI294cvSKurIpG967lEYkYHcMyvRq0LViIzlS6ujrs/+AfnI9QVUZZCsS3/jZZ0y3V/DjPGB87QSH5tkXB/1fw1WrLqt5btWMBf+Ijpk3e6N14/rUEzdvGGclfJh8tMmDhLSkNDvqFuAI8NELl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The -EINVAL originates from:
> 
> vfio_dma_do_map -> vfio_pin_map_dma -> vfio_pin_pages_remote
> -> vaddr_get_pfns -> pin_user_pages_remote (mm/gup.c)
> 
> Possibly that’s also the origin of the concurrent PUD modification that requires
> the retry in the walker in this patch.

We'd have to find out why we manage to trigger a -EINVAL here. I don't
see how anything that this patch does could trigger that. So maybe a
problem in user space? (calling it on unsupported VMAs?).

-- 
Cheers,

David

