Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE81FF494D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951E06B0092; Mon, 30 Mar 2026 02:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902F36B0095; Mon, 30 Mar 2026 02:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818706B0096; Mon, 30 Mar 2026 02:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE656B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:37:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 210A71B88F9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:37:59 +0000 (UTC)
X-FDA: 84601774278.23.77188B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5249F4000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:37:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPqSl0HR;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774852677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r3puxPnJQp9ZrKjnT2mlOf6FJw2AgxwEcIbvAVBE3s=;
	b=zvyHPoPRFQnArk/tH98jVoSTJX5V0ITqXK7LosTaA1E/DLfHFAcabSGO7EVtYo9qCpvNz3
	dugCdP5wSA/q5XROuP8dIGMsQitvSN0pT+pZbOp4KRMe7rj+Fo/PVkFG8J1CtpFuAFogQc
	CkK4PUNSMUqJNHMh2kmVboPE/adYyqA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RPqSl0HR;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774852677; a=rsa-sha256;
	cv=none;
	b=hQgt7wSMNWwdTm16vSrCEb0Rn9enQMl7mSDuKhTFjz/CMJhjeDTG08xS3/suu3JIq9D8YU
	JHM1dThpaTntk2hSnxd5lg/7ezDn3bD4Np7mBFkwGSCPW88A9KERqxacunLTlW69ISrkqt
	C82s9KaxBVEp7Tsxk8cLYUVSOQA4mps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70292416CF;
	Mon, 30 Mar 2026 06:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1334AC19423;
	Mon, 30 Mar 2026 06:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774852676;
	bh=e/Y3J4AprcPKB1V1dIQE/QVRuxD7lAyNx86JF7IRYDQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RPqSl0HR1j1qIg4aRaQ27eVsec+1rebugLZlVlwS4UGPQ0DZkpca4EFFkO4FN+tep
	 xs+IX9EjZEIsqOoVl++bH/Cs9BdpyPfnrhFwl8Sr2r1R0GdgJC/g9LzJag63iIfSDL
	 pLTYoMVk01C9aOc4rGFW1zAcaVmVcBgTOstDYGkGRPjMTdA7xf+N0lzg5ILpCD7y4/
	 MweZjkX5PuHeliNF4vG1b8JOXCUo8cr30eFenKEhfZHSXitLdZ4EEF6m0AluvnxN5F
	 ba98Mi2ykbvJ9NtSqCqFO4etsOwbM0N/5MSbdAZNfEAz2T6RNG6zawgf4e78FepVv5
	 ocnCjOn8BHxDA==
Message-ID: <9c0ae600-d73b-4e7b-90ec-4f858c665d80@kernel.org>
Date: Mon, 30 Mar 2026 08:37:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_io: fix PSWPIN undercount for large folios in
 sio_read_complete()
To: David Carlier <devnexen@gmail.com>, Kairui Song <kasong@tencent.com>,
 Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>
Cc: linux-mm@kvack.org
References: <20260323170449.26333-1-devnexen@gmail.com>
 <20260323231315.240137-1-devnexen@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260323231315.240137-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5249F4000A
X-Stat-Signature: gtxocmwhumf4facyk8pgnw1h4bbbec3s
X-Rspamd-Server: rspam06
X-HE-Tag: 1774852677-387297
X-HE-Meta: U2FsdGVkX19a46q2kMSvIpJaLQqzgUbWYgOcue2RrreER2j8sDu6Lg4Nmw/c0HCTRP/8keZMrXMZ1EwD3lHBdgFb8qX9cRuh8OPqsg7DPVFHwzaWXqU0cHa0A2NBjwHaEGwJvsRp7DHkLZma/b9AnhjKPnvJQQDxgbOIiNaHSofLNdG3/UJjk0RZ95kKn3/p3ZzX0kteBEqXN77NAj3y2qBvv+Phg7dh8mm8I7/tPplbFcbYpeC+OsjYmttgs3qBAyMqaOHXw6zRS5HW2BpTm6sBM/hP6/5pzAwONdrbnMpf4CrjAdlyho8/9ju1N7fBRQAWdF6CcUweto5EoErKi2UdjDKFwqf4/bsBfiA7V664BwbPtWCq/sr2XzUZXVlJLMmgJ1QryAgxKpeKSykG+uonm+fqTsVJh48y56O+XQ+a0qWm7t+J/Q9a7cpRsqw5RJ32gl20jmnD9fOyHpODhMh4n1DzxuwV33h6lBDCW9DJdAu0qTKeFz7haHTQp9IiBtypeos+Tt6S8F+V3Oma0QsYjSHyfuD2FbFhSg962Uu1CsVbzB2jX+7Aifs4OcWYKi0vsJW6uYcrsVthzpvZaXttEno0Lmn7wqG7NekMFi/YAE/i2Flk3+HKKSghfh3AIuU4xIUdq7KxoWdZmnD8Nh+Ypuk5fxEKOXY6HOzCiEgBaOmmlgb9Xlu3Cif/jtcpCo3DIDWQTWNRqFoHp24vSPkZlcs4psPLBUzSdxrjJ0Yoq9PwMxABI+VIkmj4n5N2gJMSEQn6jMKVJ7xHNsY1gJcOXuDxqYJr13OdPr6lJw2rd8yU+EAaU71XuoLmHrk3M/4ROU1wslXNr7lQZirRDHeSQtK0ynPVZy9PjX59Sn65C839cfy4yTreZVWAZtv1SFFEiM7es9a0x/L1K13DcPtxhZJ5mMwtkvH4XdTaXa78J9errZurnimCQmKJ0HdJJkrv0WfxUAUfdAXpaZX
 fljwf8xy
 sVAIo+7U0isyak1ykIcfMsL4L+/z/Z5jVo450Q+Wx42GFkddzf3nfCfrnQb0O58VjIC0jbWe54wZ7VA2ZSHEXRF+bNZvJQQ9XrHDwDz9zx1he2n9q0VJt0T+jRI9WYAN9HvKJEpwYo7NOjQdMSO5IExNEdjNEKSUhePxJqNJzy4KezVEpJCPsKxgKxqXrGCH39uPUvDOx60pWtDILKxXvnx4PowJ1aI8g+fHsajSd11na98/Nq4q4H6ksbACOOt8ATwYNw1v05AUuRJJr5WSicX5EWDziC0SuJtMCtCTvh32BCb8KX0HfSUj0tzaFOGWZDcd2RyA947+9f3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

please don't send patches a reply to other patches.

On 3/24/26 00:13, David Carlier wrote:
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages. 
> For large folios this undercounts compared to the per-memcg path
> which correctly uses folio_nr_pages(), and compared to the bdev read
> paths which also use folio_nr_pages().
> 
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).


> 
> Fixes: 6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()")

Is that commit really to blame? I don't see how that one would cause it.
It would rather be the code that actually made more than one page be
represented in a single entry.

Is maybe a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()") to blame?

> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/page_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 63b262f4c5a9..1389cd57ca88 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
>  			folio_mark_uptodate(folio);
>  			folio_unlock(folio);
>  		}
> -		count_vm_events(PSWPIN, sio->pages);
> +		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
>  	} else {
>  		for (p = 0; p < sio->pages; p++) {
>  			struct folio *folio = page_folio(sio->bvec[p].bv_page);



-- 
Cheers,

David

