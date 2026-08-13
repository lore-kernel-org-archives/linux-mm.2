Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B144C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2758D6B01AE; Thu, 13 Aug 2026 03:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225276B01F1; Thu, 13 Aug 2026 03:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C61D6B01F2; Thu, 13 Aug 2026 03:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC8DD6B01AE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:21:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B83A1C1663
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:21:02 +0000 (UTC)
X-FDA: 85095399564.24.888AC7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D878100004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:21:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0J1WW1N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1zx2Qgzcucr1lr0qkaSYA1QLDyvjN3OglK+Nni4fAl8=;
	b=lq+qkm5WvIGgFitRmS7IIx5xk/hmf+NkHtpwfCb9lUTCMTudy/UdtgB9zx6H1NCsPNlW0P
	S5Fs8lc0laLiCIwpxls7A1ocSS/mUuIebj4gK1CdoD8kzXSEdzyc/9XqwKMjje9NSrCs/M
	oMmdPHTC0+pb0LPLKnJhsWsyhP9T310=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l0J1WW1N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605660;
	b=8O85uLSuYEn14xJuYBytGiW/iClaosH8r41fP5hLslgndUaSZKo38F8/jHd0ecfpPKHsrs
	5H32iwSKJzB/K0qdNJBDfmmpoMtv9cieCj3QZx7TLHLBgfnibf2lPrAwWK4g0iHXOL4PIn
	bpODGZ2z+jma6SYzwl7DVXlEHsjSTYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB3E416AD;
	Thu, 13 Aug 2026 07:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6DA1F000E9;
	Thu, 13 Aug 2026 07:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605659;
	bh=1zx2Qgzcucr1lr0qkaSYA1QLDyvjN3OglK+Nni4fAl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l0J1WW1NdC8WUCI+4hObk9BmgQxnhkoM5huUcC2I9a8fgeLpyDG+w8x6XSXMb/8G5
	 sIm5hRmA4p+smRwNrCiLU09vUZyeobDqwyLdbp8AuGN1I/9KSHfoq5n5FnYcdcXcVl
	 vcziya8SDDOlEJC7tZlrqDsd+YvKSvEq0h+kHaFGpeL9c9GnheAcfBomKLqKJdbjIi
	 +VBPi2jblFrzPStVsKWuqyhE0hV2ycsBtYK38gH5f4+nuRA+ES7S0XOu5wQyjT8Pzt
	 lWHtufmEY41W/Da7nfjvrsLcVQOJSiE5GhPUijyo9kUYEXA9TxcULKh7QsON1XrPlY
	 nrUj/W3+nFzJg==
Message-ID: <32873b50-c900-4fe5-9dc1-cb086bba77e7@kernel.org>
Date: Thu, 13 Aug 2026 09:20:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/15] guest_memfd: Use folio_has_hwpoisoned_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
 linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, Sean Christopherson <seanjc@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-6-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805210557.1118966-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8D878100004
X-Stat-Signature: kxok9okh3s5fzpdu78n4iqakcqg7h39g
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786605660-716468
X-HE-Meta: U2FsdGVkX19RDIVpVk7x7iC6wDSljz9GqnXVPCVUQ779DU9EQ7HjemZH9zWDdOsH5l6MmXsqtBRPTNDraRoSq8CIjLMHaShMs/ffP2H5XnnLSoWzl7ZpYe6AeBqFC5TNf2ZtQg1SR8IUHpzLIFQK5jJEu1tJuJESs7MCZmrYEpIFOAOFRFKonqTbWQo+Wf2T5AHwMlfBbqFYgevePgG5YNix/LCyMgZ3wFgy5lEGlMyPthprsBafGongDo3T9fhe51C5Bo0VnexFJnMVHmFHnMDEztI702k1jUiWbnAvn+k69JrjT+z08VUMI4C1Pq2zMT5KQMxe4MzPUQUtdoqOUxnf6OyRjDyp5ogsQYZ6D+mPuZpiv97nb1iB6OmArq8GL5Z+tT2sWyQzuP4FugP6NeSYvtQFxqKts5bd+yJJ6YBL/+y0ERIPjkuo+TwS7+hzX6uX6VQ+QNVEH4oUxVaCB9UeQJIIA3vWxXUIBkpVMJH9U0v07f1PoBbu64to7NEsjBvtDBXglZrpSmXn4Mb/Qe/OJXKfZ1ycjFKpSUGVZlnKiJjZuOQFgUUGIMb93I/zHymn3bzWRzsEh8T66MJTNI0gRoMSvTbijKAF9U5SM9OVwvQtwFIkX1D5jpQThb70s3KdwDMqKqbR8YgbCAeqOAyJa4+BwJ3UdYGQM8/zVcgWmyACdE1FIyr9Azqxpw22knpnliJZtk78WXUUhXTk2/PVHfzf0fIetXtahHq1Sl5Ij3cmXXsA9LJVwHetOJtWX+3+hIiKGBxr0shKMhjVsjTh7Jn9cHBpQCELm2L4UmnqvvUXnFzNmOyJktl9TxR3IPSE4TwI3CLEs36iZ0V8BeOb+DzOol9OKuEpdCDKBy94YdjkA7AaLOEk/0iAZ3Q2SGpXy9VpvZM43N1HaqajyMar0DTCgKY68sQe54C56IEzPU2eZyMHbBRFfmJp7nqTlVL1ObhnHKu+mTLBO1p
 WKELhShu
 EWRXx5f2NTqYRwryit4hzgEdIF+EAuk37jzqijjMaC48VlMNy3Pgoh/3vDrwrAlfALeiq5eQLp0h3O1lxAvU557iup9EmKVCoU1YsOJEE2cWNOdlQSu4EU9BSYf4Q3rWvyOdbY29PZnRkGizQ7PPTAP+XLvXKldJeTPa38AhaALYKL9s0j3AwnZR2m4WyoDYbd3Q21dCFawM8Eur1c176qKOcfEuOBtwBhU84NcTgjNp0AQvuj2gVJQpDsRneM4qASoVg5QrQ/p1uHgi7ld1GX7U5OHoGPZmAQIWC4TiHlbc/vNdXZwGt4saPS+HIhuVbtTX41dyTET0Fz0D3W64WDdkibd9PwMRp3kIBL6sQtJOrDevwD7RdrR45uJMZM3nBrWgaEW1H5HkwSqBOlxuDt1DaAuzSh16OCSV65z6aJc2i9CssW5o5XtCRyLsP6HAtpPZ1wiFO2QeLorIX8FtOb6f9SCDC4N8IuRKVPWGOI8OKDPdSDjJX2mPko28yUw3B0h3aYM4GmeD0VoJCS80AR7lB21fP+v1EEfQSkIPgm78bu7IRh+YY5T2KeXDbQ9xOy3GI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 23:05, Matthew Wilcox (Oracle) wrote:
> folio_test_hwpoison() only works on hugetlb folios today and will give
> the wrong answer for other large folios.  folio_has_hwpoisoned_page()
> works on both.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---
>  virt/kvm/guest_memfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..94eedcc7f1a9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (IS_ERR(folio))
>  		return folio;
>  
> -	if (folio_test_hwpoison(folio)) {
> +	if (folio_has_hwpoisoned_page(folio)) {
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		return ERR_PTR(-EHWPOISON);


guest_memfd only uses small folios, so it doesn't really matter.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

