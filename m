Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85329C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4E26B008C; Tue, 15 Sep 2026 11:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666F26B0092; Tue, 15 Sep 2026 11:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B7D6B0096; Tue, 15 Sep 2026 11:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 332D16B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:01:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0DFBA5694
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:01:18 +0000 (UTC)
X-FDA: 85216309836.15.F7EADD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1EB5F1A0006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHcx8bnB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHcx8bnB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789484477;
	b=sDYcwJyKYmjT8qvHb2zCMAH3mtAHX2bngosWNQO6Xwe2Qr4cBol6+Q+Wb+lEAwjt4N7EEN
	5Ve8FUrzsbmO4AtL48QqunOe3Q2UWpYHwvZ+6ZaMabmuIIsBwQrA/YWfFcTnpN3NQn+WKs
	wFmmK9cSiZj1JqFIYq/e/PBXMGRSo9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789484477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sDh1qot9myjlJ0S89pmLSsamlOt4QuZGlDO+V25QSs=;
	b=G+2RpcGYm7/d3obyDBy5nXbG2ejqJv6ipS1lBOK3TsHxEFmLGM+4NirhjCBAe3w48F4kK0
	HfNI3aoGIrWDIr4B3FdM5M6mDrjBHgIrPV2H1289cmij5PfodlcFRqC7iEloMiGI16De7C
	T9lp4OFKGEDEvLH9O5w/jKjmWkHYdBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E98438EB;
	Tue, 15 Sep 2026 15:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA671F000FF;
	Tue, 15 Sep 2026 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484476;
	bh=0sDh1qot9myjlJ0S89pmLSsamlOt4QuZGlDO+V25QSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHcx8bnB+zWYSYQJXQa6gb6cMnklCxMh3CDVE6sNIAaUHY+fkSAonWzkCHNn0Y6u0
	 MRxU/qI3XJtc9S2GxTGFlB4mWY5PjbAaYIvusoLnYRUNw5FoA1Sb7/9ZJ6pgJ5w+QS
	 W4AnEZrEsJdbuJ6lPwMSE+Z9P5JgcDRll7KrHfZG4g56Zi1TVL2/NeO1C4p/tNEnWJ
	 YS1qR/EkOJtbmHTeLH3vYgPYUpQdejrkIIzGFHvAL/nCN/bobQAegL1RNeTze4RNPQ
	 57A8AKYjfjJ1ZaD7Z2/JSoUmngr+JfMsVTXnu8hU6H33lcaknrnsu3OZhCzfT/937O
	 ItkL+2ikxpVWA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 7/8] Docs/admin-guide/mm/damon/usage: update for hugepage_size
Date: Tue, 15 Sep 2026 08:01:07 -0700
Message-ID: <20260915150108.92484-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-8-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EB5F1A0006
X-Stat-Signature: deo7x4s6te3tfz3pjicf9qu5733gxf85
X-Rspamd-Server: rspam01
X-HE-Tag: 1789484476-611805
X-HE-Meta: U2FsdGVkX1/9hqBvF7/sLoJT/LDEEPGATwuL2pVt78Gq2n/g+QBszmYY//kY1e5zrf23PCBbcAD+MsrZq6/aQAdLxD35ynZldFAoARnorYA65O08WG/xyhT1G/y2+lp+3oujeO7flynVsb0ipa3cwayFOPBz+37vPYc5b9uwSkvJlZSbq99o6QbOHQ0Yb2r9LnOvkkv6+KRdvzIB51RGN90Xlg+C0YRE32pKzO3jy5Qdjwibt1kdxf2nrXPjBmrvAMGilkl3ruKtW2GTdlBaFm4rL7x2qzd3bOmbRav/3yTjZCr0jMaeCRC6/2lbEKx0DfZ+5KjFZJptuf8IINWIJnrISI9gaD1wUZvv7FYVY2oazEtz9tXlsuoT3OIwSGiKHgUlBacKXtsKSDQneT2b6Pzr3pRN4N6zBdok1KGetLJbZTH/XWMEm20M03FLf1ST2NUEbYdBlQz5TU+jYDQ825BzQvxLDP3XPlWxdzBgJmbR7x4qN2sjn6vDXkZxVxSApC6V2T/LlRcFcSH7zTEp2sPxGw2iWUJsx80YjWRAFZfGQVyCBcEbaOI2mmBNTNE4XHUROSED+wYP3i7CSobgf/xODPWJRKGJuoh3qhctb3suUu/cbumtbuH667WEJNfV0He9rSOCPiBLTxdOjEznhl00Mk9HyNtW74H4UtP41/TMfIF0uMJEDcVXm6YxqhGlNm72aJkEoHjr6zbbpo3vIYkEZLlgfZSOiFk5auYAemegNitCtUV0axgPYDucqJu1Rdz3lIGKmM76YOvDIDIVYzMLVzupmsGMBUE99k5DOHUL2ZKMvvixJGjSy23xPIzRzeNQOigtRJBU7EJ3W0OWUH89ZTVML4ArgPzTjF7Qc09ds7UEynOmY7usaj4YfaVVGepIS8SUM6xjVG0u4URs7xhVsM9pp/WbCMeIoh79ejZ8lOnTH6rXJrTu/xT2h7sPPLFxDd6y0YxOswMrfDr
 aIMr91jd
 UwjgkCqx9SL/twtcX3eQBHyRXb1rcuAiK+eUW5L9cUfhMm2cMW1boQQ2Ijh2Uw709YmhmwNsE4p+lDdvhA5xq/FePnAfUMXlYcwuuFNlvQU7KKY3CqGXaBFvCX4hmg2hFtfxLyQih1Eo1L3VwnHIVfYNCzzIbbGpPj/nKcK9ZKW/1I9ZsGidoMBCTnNDxhIc5qQXeUrrBH65niMbJLiq3XrM4BI/tjTXoN5E+ZYKKss4P3aO1jLNLKjV7VdPoW+61+xeohmJdPtgzEksUNFNsz9D9TLqkbnf12Le9rU0Xkwpvx+eEtnvRqLMMHjGgD8r8mJl4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 07:33:56 -0700 SJ Park <sj@kernel.org> wrote:

> Update DAMON usage document for the newly added hugepage_size data
> attribute filter type.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  Documentation/admin-guide/mm/damon/usage.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> index d3e37400367bd..6b80bce5d678d 100644
> --- a/Documentation/admin-guide/mm/damon/usage.rst
> +++ b/Documentation/admin-guide/mm/damon/usage.rst
[...]
> @@ -308,6 +308,8 @@ Writing a number (``N``) to the file creates the number of child directories
>  named ``0`` to ``N-1``.  Each directory represents each filter and works in a
>  way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
>  ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
> +filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
> +``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
>  filter <sysfs_filters>`.

Sashiko found a grammartical error above.  It needs 's/files acts/files act/'.
It is too trivial to respin the series in my humble opinion.  Andrew, could you
please do that when you pick this up, or let me know if you have different
opinions?


Thanks,
SJ

[...]

