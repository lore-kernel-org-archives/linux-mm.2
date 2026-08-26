Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3F4DC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D877B6B0099; Wed, 26 Aug 2026 04:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38996B009B; Wed, 26 Aug 2026 04:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C273A6B009D; Wed, 26 Aug 2026 04:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0436B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:27:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1843D1A02EF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:27:19 +0000 (UTC)
X-FDA: 85142740998.13.FC250B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 624BE100007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:27:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyN+e6X4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787732837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4VXwukOvzmoVUjOHFr+/WSXxAsaSNTt7jYsFS0Y3YQ=;
	b=SIc90T4iSMXUqOiO9FIzgrkNWNwUjxO60nN/1pnkQRvvLspSQ+InBFFU+0pCtBHjZIoP1c
	wnLhGcWoQHPFmjKApvz8LiIBFtJS+yhjqcp6bAHWpszMJvTc0Vp17cgGNyysDz7X3skEay
	MdjI9sRbOI3uQoyi4N1ZBbWLhfhmJI8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787732837;
	b=bga/TpDDSmDShEGfvgXc49caXEdE2qvyLhvb0hIocPMTE9RPIo1aB1A+GaHXv7x6O8HBTp
	UAzNb+8QCS3ZIFwAAGbGLkl/bpj1S45asE6zL0X5yp+E/JvsjzfK19NKKSO0cSfAKcMmJZ
	YAgsAy4ZqwwYneQlwmnazs7Lr9GKWMo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyN+e6X4;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC27C6020E;
	Wed, 26 Aug 2026 08:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9283A1F00A3A;
	Wed, 26 Aug 2026 08:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787732836;
	bh=L4VXwukOvzmoVUjOHFr+/WSXxAsaSNTt7jYsFS0Y3YQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eyN+e6X4tm2Lp7KCNpBGiVXo1xBpSrkAzJ4DEe+2iUAPt86j9ZkhDC0cfxFTHhgay
	 no/k/Auzl7iLDhRJZKqv0wn3dOmIl7Ejo+to1t0zhjJ3ONQ4lHECKlAZfVXEAz2mu/
	 0bLuuVxW1ot9fyc5u17BSJ2JE0y1ENfGc8RTtzQAY4Ppdt+eREuIQLIvNGmrs2ouYb
	 BLrBzaiTXBddrLxNOhVvHb4TuHmEO8Gz78AFrBvUi4OQ0yj5T8cefv4FyQOobCggGJ
	 eLWHOkTn8BuoFxluLX88uMOI6MhYXVuBE0YzfR+4WcPbMryCmQjzIRmspHlcn8Mf29
	 XdM2g4d1PTR1w==
Message-ID: <63a72a5c-6e24-4513-a83c-d8f63df3a600@kernel.org>
Date: Wed, 26 Aug 2026 10:27:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
To: Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org
References: <20260811025157.1632867-1-riel@surriel.com>
 <ao1JwEAeNcP9OyKR@infradead.org>
 <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
 <ao5t8lxaCWQvph-l@infradead.org> <ao6XSh1YRiqPA3rA@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ao6XSh1YRiqPA3rA@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 624BE100007
X-Stat-Signature: qzt7ojxnffaxziuit4eowekekxjk1t5d
X-HE-Tag: 1787732837-552116
X-HE-Meta: U2FsdGVkX19EjBqvtqk3upQtRzD1eozO3bwN+NdBAahp+FY9ZicvLAKW58yAh0WQjDGcmFwbWxErDSMKe3J/++k9Ae9NMCxwgJiMgtMTJeC771jt9WzIZ6cTA1Fhh82P6lzNwDV+UvM9Py0WUNebcuCSdHSZnjuYgyKDrgQy6W8s/XcnxzqI4sqRBf5/8snJGfOI/KTRnVz4wX00PdbfAAtsb+ij6l1jRbEOIsTOm9LZPkOBWa5IkFBNDjA7xBbaKSiJ1llS6KOXBXFtix+T1KQhDS/XOyYZ3w5bUEL1Z7o7Xg4nHzK1yPiWnxk/BtPXh8/xrFqRFgasSXgknjTONbsM+5fImD1jMpVsevogi31EarEQndFyicWnOuuXbKs0GOT9nPUPdAg3d9iBziXvnQ7KbY6jrD7pZfSvmg20qvjL9UjW5kujft7TEGncSmeR1GWKm9lpSHYzNAPHsWFXyT6r8ntFelR7YlDe3HGqNzrIRgTzOHedRcuLPkHA+VqBBbWcVjs5YtcOynIXudJsbyZrlvZCBLgvtrSYtdQgfNEixmjzCuTpkWTClknCUV/ZksbdyrB1opD/2NwOl5/ftjtbk0+knnv1UVxyixMDSNa02ZJOGeadf1qxltvOAsuLIqB2E0rM5Pz33JDA4fi5Ptp0UyFnmmDnEVyTZGttII+NB75LMu2Id3tTpZzSQDJKFtW3yyOsULMf7fMJBTo6ekmSdz77xH5wQvoD+t8vbPkgfYGU1Mo1tNrY0v8kTlYdgtE+zYHC3r5wtiUqBdw2zv1gCdC7QFDiLHIBd4MN69lW7yf+yaC2BJSK0AcbIr9b2w+RXJ6trru56ExGTr2ZEHzcMmm03l/KagGZZSkYIyZ3HdDzFkQcIz+M9owDPoCUWlrZ3768fzZcuGDM8ky8AasGHlFtvRAAFKjTkWETCKkHWjJ0xTqEBaDXyPHYiFpbmbzrbPLBUtTk3TTLaqJ
 bGDUatbA
 ZlVl+iY3NyqVZ+1ORDIZ9dkQL6mK6u20jPKWO5gN/wvi49M/+RTxjaIDomNG+WGTPdLelEbw8hVChZ2IwllhLvBWbCuYo3d3sLzzoYSiu12x+ZK8+AsnvyTgtpYLnbb4tuP6tah2TO7KQrK9qt/mcs0aTiFCLhMVLXoC7QTg6lxTRxlcqNNlw9uQFO2xlp/a5a2auYqyDUt2CBwR0IaEAsiX40ANtbMpUc+mTSqk8Sbg2V4LLpjkKk+3VbRViMZGfPyOUSDR72gsCKaFsMmd5qhBIsWnyTV9x3nKPrZb9qEG3oNjwO4dv8gh/xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 09:35, Christoph Hellwig wrote:
> On Tue, Aug 25, 2026 at 09:39:14PM -0700, Christoph Hellwig wrote:
>> The other callers of iov_iter_extract_bvecs matter more, but this is
>> the main user.
>>
>> And iov_iter_extract_bvecs right now is very inefficient when used
>> on larger folios, as each call to iov_iter_extract_bvecs and thus
>> iov_iter_extract_pages and iov_iter_extract_user_pages can only
>> fill in up to 256 pages.  On x86 that is a single PMD mapped
>> folio.  Passing down the bio_vec array means that for PMD-mapped
>> ranges we reduce the calls into pin_user_pages_fast by a factor
>> of 256.
> 
> Also in addition to reducing the calls to pin_user_pages_fast, it also
> removes a fair amount of work to recalculate the bio_len in the
> get_contig_folio_len loop in iov_iter_extract_bvecs, which has shown up
> in profiles (although only marginally so).

We could think of a mechanism that fills a given structure in a better way, and
I think we recently discussed returning folio ranges, and might to that through
something like phyr (or however that is called :) ).

But that's really not something is would mix into this work here.

-- 
Cheers,

David

