Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8812CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65446B0005; Tue, 12 May 2026 20:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E169B6B008A; Tue, 12 May 2026 20:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CD86B008C; Tue, 12 May 2026 20:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C493D6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:40:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CC744065B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:40:51 +0000 (UTC)
X-FDA: 84760541502.01.2E2C451
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1668040007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:40:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vrXkr9ey;
	spf=none (imf12.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778632849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWSCvvMbcOt4oyBzkMPihDFskX8nqxG4mp8xjrix0OA=;
	b=O9Yt8E1CLYu92Llo3voGVqdHQYfhwuoIBW3f4hPgAO1fSNm/0w0XJUHBKBRzeF8qHitKqd
	G4+cwGo7Cpuy8uhoGaSvNuPjrPNaG3kO7cMVDjPhF5u6xoPgm0DN51l1LQzkO+pbhUjiju
	6m/sjU5kSRYOa4CSSaOeHE5OX8R7P68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778632849; a=rsa-sha256;
	cv=none;
	b=e4J66EFUgS/MGtXRXF/gGyCHlFHgk4RZP6typ+I8rm4UgD2Ptin9ROwFADlvoReSlShMqn
	97iWcaXD97fap2uLXsL2Qs9oodGNIjmSOrt5YoUAdABWf8S7VxxFb/wb5Bj0S3ZUY7B7e7
	GonJ/tuFmUwjUAbLEmEgYhfsAinTLKM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vrXkr9ey;
	spf=none (imf12.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WWSCvvMbcOt4oyBzkMPihDFskX8nqxG4mp8xjrix0OA=; b=vrXkr9eyWPpTmBd+IiuAV5BoFo
	+epxNyhTLba4WFXnUvKgytSlIhoX4NgLFAPfnZ/DoLRJOF7IYjbVkclq6yWxATkpV6MYHvVbrk8as
	/MyxiGDbXlzzvzSspwfKayAqdhRLYdpqFuGnlDfLI9yAKHS/TUq3EPhjh/6I18fhStPf3gpEbys3p
	NWo6cUC/6vMCbWDuJtbLCP+lzJhjqmDQpIr2/ZbRaCwV4zES0i8gwnYfeRmAZs4pO6HNRABpMRwaZ
	HNJH6d9uSx5Dkjr2g3yuFxsB5u4VEiAfqJdQUNYsCr/v5l3uv8aX9/HpoPJrtCvEV4yQO8VRKYC3q
	5H2Ymjkw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMxeZ-00000000nqA-202J;
	Wed, 13 May 2026 00:40:47 +0000
Date: Tue, 12 May 2026 20:40:45 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Steven Rostedt <rostedt@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	maple-tree@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in
 mtree_insert_range() is inclusive
Message-ID: <v2f5frxu7qt622llct54hhe7vkprjjjwuxnjg2mtq3gqn6bqig@ke6rurg6k7of>
References: <20260512175623.4c5ca8d2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512175623.4c5ca8d2@gandalf.local.home>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1668040007
X-Rspam-User: 
X-Stat-Signature: n475wia5yehuncz7qmq65wpkgqztzu5x
X-HE-Tag: 1778632848-104611
X-HE-Meta: U2FsdGVkX1+XyrwYX0LxlrZTsAbmVqm8P6ziVQJYioFmp9qsl9czldha3fKAnPEnqxSjFcjMsdVFx1OZBlAIyfOhPUix0vGvPlknOpZgq/2XvHNC5uaMi+EwkGR151ol85wa/FTA5txBRlyksnsXRqjDVYqAWS0zHEaSzgfqMlZDMmMl3Bt6BoCrvU4kVY005HnnlqI1GKOLzBUCydM+vyOWANienC2c1h35KwZ7Ajcs+0Xzwx8uIARXLzawXxu/QmdG67S0xjrEORfsKpwwXBMlMoZUHnD+gpBQAj1KqBFQw/m+4iqzqoI6JAz51FL8cTAuF0Nmo1fpauxtEQ7pCDKpFpv4ODPA+wfvbfzMODwm3mmWHmfO9ocIMwC3RJe7C9jyWHuSyNffjvZRYAVRMnMR/Fag1Vm0A30UCDFZ9i+GhD77OvINQx89vmbs9ZqbCVn3VCTYHaG1XV8ZNl4IMW8gJj/OZvRnCH9Ce8Ukb+LEVx5B1BgoGDId+dZTwckTZBXstGPXgldjJLE97KvOuD1pLaM4yhf4rO1dHGBunKToFsOy22WLxwKWutw4PQf+0Uevlcr5pkBwWoA4EpUt+OfOUCApKhVcuYg1VTQLwmohOGbgmpVtclN88i65JURRjlbJY90erqbNdlK0cEbJTdqUlEOWDSOTvah0HmblAXW+RXUCA5pUb10F8aQn4rze6LI81r/hqbHNv8439uV6JsmolZN/gvdbORqwW4u++RO5u+SfBD7JvuZH51dA6iONfgkpT/dNAIQdER3BzE7+6JYI0D4JYSf9dq4aZ7///bUcOo5A4G9RpNDWuDGmMpmMrL1n9j+WHded3MAxuo7oqKuXSq6ZYYHCNm9ScrxH9yPoizrbLmQovVCKJk44Rtda7tTlI3CqCeRadBqzAv68kRX7qGAWdB42pJq8aPp8Z1aNtkVliBOzTpZ+H4zmrZfq5rU1VK2DQ4CvTb3mwFQ
 RiVn67Ei
 +juShkuZk/85bJ1plEmFtKD84NeojzNuZOB+wyFtDoO47mS3D10ZKQ23pg6+4aL6k5xPkSBmlGhXhj3lO3LGBgrBgGNzgoVgV7BETctx8dbLERdLfvNwsNxpdtCVeyBA25Um/Wwer1Poqz/2hmHR7iMk6OTIs8qGljeeZGJR0hoSpK4heRPx2o6w4tL7GF+KRqTUFChs0YSf7Xa67fOQwEpeUwJ9agFFzJOX17nDKvYDOwRBHQKPlr1spEkIlfiAPbw4c5u7n90fZhhpuZDCDw3osBCRV+ZUZya2ebuLWrlck5Hd91w55Xwc93YBC6qEuIGZH7ZU7vONs8uz8zBV8XXajXAMMMy/TVD5SThzDyyyJ2A1Yjl4tjy3l6/nuf/V/UlU4QWcmHv1YSV90jhG5QRrxQJTEM4jcjOEvCKN/SnOsZfltYsb9NynODfmVQle1H2ib5aNAGBukVrYEQuojrycLGuoCfehqzT7ciSCqOmpP7x0fTU59TBxwtYntecgZVx4DDafw0A9VMWS43mrPfMEs3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/12 05:56PM, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The kernel doc of mtree_insert_range() does not state if the address
> represented by the "last" parameter is inclusive or exclusive. This can
> lead to bugs by code that assumes it is exclusive. Explicitly state that
> the parameter is inclusive.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks, this looks good.

Reviewed-by: "Liam R. Howlett" <liam@infradead.org>

> ---
> Changes since v1: https://patch.msgid.link/20260506105218.2d027cc0@fedora
> 
> - Use "(inclusive)" instead of adding '[' ']' around "end". (Alice Ryhl)
> 
> - Add "from [first, last]" in the short description. (Liam Howlett)
> 
>  lib/maple_tree.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index d18d7ed9ab67..7f6c9b729a1a 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5727,13 +5727,16 @@ int mtree_store(struct maple_tree *mt, unsigned long index, void *entry,
>  EXPORT_SYMBOL(mtree_store);
>  
>  /**
> - * mtree_insert_range() - Insert an entry at a given range if there is no value.
> + * mtree_insert_range() - Insert an entry from [first, last] at a given range
> + *                        if there is no value.
>   * @mt: The maple tree
>   * @first: The start of the range
> - * @last: The end of the range
> + * @last: The end of the range (inclusive)
>   * @entry: The entry to store
>   * @gfp: The GFP_FLAGS to use for allocations.
>   *
> + * Note that @last is inclusive. That is, @last = @first + length - 1;
> + *
>   * Return: 0 on success, -EEXISTS if the range is occupied, -EINVAL on invalid
>   * request, -ENOMEM if memory could not be allocated.
>   */
> -- 
> 2.53.0
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

