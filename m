Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5218E606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hKQDCwWc
Received: by kanga.kvack.org (Postfix)
	id 53FFB6B05B2; Fri, 30 Oct 2026 00:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516E96B05B3; Fri, 30 Oct 2026 00:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4551D6B05B4; Fri, 30 Oct 2026 00:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22AB46B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:48:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83ECEA01B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:48:30 +0000 (UTC)
X-FDA: 85378061580.08.BCB76D1
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8CBFAC0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:48:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hKQDCwWc;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793335709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCO2gpCBQE2FwzGxXtXJnVmZ+zGlw7S7nKOHMvP3QG0=;
	b=G09NiepHDgBkkCEVD2FkOaeH+mGS1AC1OKQGyfxrZrImo291IrX1AWeY+WDTocPaMKqjVe
	nHLqG/TGZgivslDlecT5v5q4+I1Jf7CQK/ZF3zS91XS39Pi+w6wVGAIT2+Zaf+DC6vFetr
	Mtqy2UQhvigDtEOLwaLihx1FJPhIn8c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hKQDCwWc;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793335709;
	b=5VFy9ZDR3c/+a69b4vvtczzoaS8FLWNuIXkbyIPAJcm4QAhdW4exPcxDGeKLO1RsYcxEYJ
	4C4/xgmRpmVte8ctekJ+kosaJfM0/WAPWy8KJREttK23UIr6l3vkireBzQOk0g0pDPDS61
	2xaFtonoEPbLVoeecltvFiHaVQIMozY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xCO2gpCBQE2FwzGxXtXJnVmZ+zGlw7S7nKOHMvP3QG0=; 
	b=hKQDCwWchBDZrqV2HNumPX2hRrvnfsyuREe+gEk1+dUcp8Ix5tYjEtSit3Ix1F6SCsLMbtLB63R
	uZ4U+z5dDPcyVnSPDudr+gqN97h9YbEiQymk0YBvHWBreByFOtJgk2Xh6I+GPGa5r+A1nP7BPdYIP
	vum6ASLLzYK0W339d7mFON4zuKKHSr7CpSgWU+18qIVY7dxeaT9Uuc/rwp+mjogVUayQrhMjXz5zD
	n43lkbkGyO0OI0eY3jymvs6qA0TbpeZwPR2D2hn4qQklHAvB8BaoZQ3crAbmS47ueoqFaDPrt7W3m
	RmJKWZjND5ofD7F2w9P0CzgYKXeCgqSSvxJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMeXI-00000008yjK-3ZRY;
	Fri, 30 Oct 2026 12:48:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 12:48:16 +0800
Date: Fri, 30 Oct 2026 12:48:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auQhkHG6XlgNTdRr@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CBFAC0005
X-Stat-Signature: a6zcgj4rir6stifi388cnzr8tje1owx5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793335708-697067
X-HE-Meta: U2FsdGVkX18WLSSMLQFTBMntjrWVCPGe0fatl3vu/l7IHoL9IPK/kGERghpHqih73xyTG+BSgxvYLHkhIMfRSHduAHYvTs4AN+6BMwZDYd1iigd0DETz9nCrMaATXZyIOnGMOhreZS8KXxo6r8dgqoQwa3icn8T/LqQIB7GaRngdRJvRx+SYrj9FCRLhPHXlvPj7y5mvoA1fmTZZCkB5X/kZyOOElOZUZHk/RZ21Qut3ddfoK1MwNs/unKfhl9j0NxGmElKM54lrLyi24Qq5mx1X11kSEIJR4CVbsCST1uv8hXRsbwjBbjTAz24lFUCgz2Ade0I3EPdbInXN6kl7vnn61uGIL91uphwn3OWHcJOJ0XT3YLPAU6P6APegE/3fZB0/qcvyQP7unOqqFYTZA0CzM8U33xK1cRtpFgMJITrsLkRyDxZkTN9KwewkLfvNn0f4x1vftEAfEtvwCP0A6YWK85nLNlJsjk+HtwxiIeUiZ+WFeXRGZGawIN3LNIZRa/Dqsmd4KPQ0lAdDn7eBJxhw+3rSqBwpVtrrJIv2fEjbmpLEoI2wC7IDdBO/TxMDrXcGat2BE6zW5K/0q/8NX/Jst78ZTYQ5ex2lsO9oZKg5cWcyWc9N5bb+dobkup1iSak38wEjaEf/jqchNlG7ecTOAbEEHkVDC3Fo37n2Scg28MT+KXGKFxc7B9c+KiUO+qHUgFKb0uVPpjyGwMMdAC5DxnxxhyYRHqhDu+nJvuJtAnIEjOMtZoXIF8eyJxrfn/T/P2SB/vKFG4pnFZ5wA3zGIrE1MtkoeENyO2lvtpMFFh4SeoAT+iKXDW6y9ibDAJo5DGHg0vtdlElkNoeaIvH0Q99ScCjlHgAX4EqqbtSVVQj5XUoIZjGGJfpBVWjI0eqmVR3HHRMvAuS9ynCLFTOi/5OFBOCiAF0OTDKzlSFJYSyjNWOPnYGM4Zipo8vO/tgbmyRawPS01gslpU9
 8xoIuDEQ
 jrJ50x9UU2Wi5bitAW5mCBCFQQNAwjmr3LRNVT24GKFit2J08EKfItpJTezmHNO2GhS0NPtaP7R2hlq9Ex07uu/NhIpdtmz4F7oZqDgSjWhQKTdI4CEjKkO27cIH4yKIvfbOSZmmGb2C511bAzV5SE7cjdPV2xeEUI283OfRzQnYBvwwnP8vQQn1cOnCZNny5RpzxRsGFra8e+LpAlvopffs07Y9871ba/gNb9CPy18+zZHOuS9ymUmdtkjlgS+qv6Gi2DH4Z0sQ5F7ozv5rMdxJkm35Iwp5Magy61D0jigXRG8PvYB3EENGwBqghpHVIm0Hn+XEJ5fViv19vgyYS/YcO16oaOQ8fhKuNSWIzCU2nn3Mfl+dUF/1wPXPkpuSPUAohGhrS+/0Ei+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:53:56AM -0400, Liam R. Howlett (Google) wrote:
>
> Given where we are in the release, this fixes a real issue that can
> happen so maybe we take this now and settle the general handling later?

There is no rush at all since the bug that you found has existed
since 2025:

commit c6307674ed82c0c57d6e1e3408e84ac449ab8e94
Author: Uladzislau Rezki (Sony) <urezki@gmail.com>
Date:   Tue Oct 7 14:20:35 2025 +0200

    mm: kvmalloc: add non-blocking support for vmalloc

Let's take the time to fix this properly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

