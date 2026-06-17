Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF355CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9FE6B008A; Wed, 17 Jun 2026 07:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AD46B008C; Wed, 17 Jun 2026 07:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C582F6B0092; Wed, 17 Jun 2026 07:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93F2A6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:22:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C23F2C1D39
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:22:20 +0000 (UTC)
X-FDA: 84889166040.08.A5B7CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0BFFB180009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:22:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hlN/psn7";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781695339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQhB/401jptiGb6RHclDY+GGltdU3xd1uAGY75OTgzE=;
	b=6oG+6gtKTtueMqOWYzIUfpN1yNwZSn2CELPOBJrjERRXcdke72N9Cs1BUL3k1anzDhZIss
	F3DX2I624/tXEyqQm/dyQR4rf78I9cBsznW5Z5w4F5vHxmsYyorCD8ZWByXo4JsqxaAclP
	B4UIp+JDCOkVM6uuUiuGk3IJRZ0FVh4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hlN/psn7";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781695339;
	b=ObjDTBzZE2ky+lQbsP8wx49WPJpgd0/hg6NQ+O2G6EEIGnH6Enh7ffwTTJisokRhdb2iN3
	zB6xpaliTEe18sDEwuSSeXA2jzmG6rg6o+pvJoBKKoMYy04LHhRqGK4ie4vH+wreCBkXb7
	aBv69zcJsSZWdNPpixTUREq3I82V5z4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F4CD60103;
	Wed, 17 Jun 2026 11:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821711F0156F;
	Wed, 17 Jun 2026 11:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781695338;
	bh=WQhB/401jptiGb6RHclDY+GGltdU3xd1uAGY75OTgzE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hlN/psn7CPVDqC4Q8psBocyQ5V9FSKg0dbWlUOkqzqKU9HzP+rU90xc/p73oOToh8
	 Y4R7U8VDszaizTP5onpgBarKsHDbYeIOPX5wUr2p/5LY+jQFAfWz5A0eDDEbQ22Zzw
	 H2Tn10e0XVd9yW0tv+kAWT3TTBI4qQWSXePBc/oFKq3B99tRUlIuz1vsppLe/eN9bN
	 1YwJ+47HyoQZBnw7PBJDmp8Q4CdbVHGdh/xtfaPKteJ0uGDpHR+n7l6Cb5EqYXvKa1
	 03KjGB0D0zB8gesFjz8UU1UMPBQfdcGqQPkWOdrMj5PeTN3VXncclGz7OOAUVUl2tD
	 tIpm3hojYY/OQ==
Message-ID: <aa419310-de31-4119-84cd-67474d2ba917@kernel.org>
Date: Wed, 17 Jun 2026 13:22:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Document the folio refcount a little better
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
References: <20260526200032.353868-1-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526200032.353868-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0BFFB180009
X-Stat-Signature: nfrkkrfzend3rspptaerc7kiaexfnugi
X-Rspam-User: 
X-HE-Tag: 1781695338-213541
X-HE-Meta: U2FsdGVkX197EuvY8xEURMIfHbAP43W1Y39PMGFwQlQMVb72fTKZvmIaheELCQHvpVqARTUAireUP+IrOFdLDvC4C/xtLgeFP/4nCnS9cmIe//+emFUEELi+HxhNngQhlp9F0vC+cJaeqn774T4G0iWMMQHCO1fgTxScawwni0RV7Ip5cwPz/JpnmHkb1QEFaBRdrMB65qrgIMQiZSdPtQoXXIlPA8GW5I2mmuzuswXjxhrUBJXIxG7BY8l7XycV8kj+5/mhPSrF/gMxyrD2nJVM4FtmMjEzmwmjAvJwCkTkxRRKqz7/FV9Onndj/JEhItmtX/u76dwZjV+xYhhjoeJym8b70yq4MGwEiAZmpTw/BUmG4/TuG9i1HUOtRZRWpcG1PfOvnTubfXo7Cz7FHCN73YoXhCkVzfVTrdwdXPd7CcWM/Vlc8r6aX5pt9eNvxqWFWtE92B61+ZKuLmtuIF7L9SLIB5VZj0/tbaTUEIssc2aIQ0aJ8v5a3fI6cqIQS3whQ9JlLNHBGOcnQarBGURE2QENy09vi5qe8xo27/ZMxFOuzruLbO2hUC0QQPZuK8FFFQkuFAgeWwcihAUsongQCsCsyKYh1f8RkZy7P5Fjkv06HoeAc1Jv2jxjVlNgBJ/sIdZ/JnQocGJIK0I3dZyKiVedKt3vhp9y7ntB72K3MU844nBTZvGcyiWsZt0iQXRArlD4a/madFh1vhVH/X3OAY2KLADJVegd35hgHD4U9EtEUm3qjTca3vuRGDP36+2WDxqx/Hy8Mi4fJmuCNPPAL2ZPOZpV3EOpf/ZTduH6XuF774vF1c1BJ0EUIuILONniZ6pxtT5RYlq/7+tY4uaUcsAnZnn2VTDSYm7UqjTxNzdgAISk3jAycet2tjw+eWpjnWm23/ssaI7qMJcDCOhFuqqSOFuyvV2P3ogkUbVoSe5L8jlF3S76Fi73D+9q2x0r9rgH5Z/LKjwTu71
 elWR014/
 lo1QQl8RN2nBwhRHKDTPdEw+9SmP9jnbng4HmyA5k+MQkH+LwOTeyxm7JgfEjMIkI9M7LhXFIj0BF+5gtsDHwfwYG7i0nISSpu7nY54uNK/abu8yixiPEC6iQzlOz3LpJdZeoHTIujnZ5Ba2LekO7g/ir2IdQmO+XKzr/LQLBsiRkPDEL9et5ANYDHjNZf2pk+B75xq2zSl4+h9tGgGyEo/YJDwAsEgAXqXeye3qG9CuR+6sI5GG6Zp7JsKwfQJYAIcKd+CDZvkrNtsaHYt4RK5M/goSuDpZScNi8pAi8xvQHXhak+mVlT2FoMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 22:00, Matthew Wilcox (Oracle) wrote:
> Expand the documentation of folio_ref_count() to talk about expected,
> temporary and spurious refcounts as well as the concept of freezing.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/page_ref.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
> index 94d3f0e71c06..9f5c75d06f76 100644
> --- a/include/linux/page_ref.h
> +++ b/include/linux/page_ref.h
> @@ -71,6 +71,12 @@ static inline int page_ref_count(const struct page *page)
>   * folio_ref_count - The reference count on this folio.
>   * @folio: The folio.
>   *
> + * Folios contain a reference count.  When that reference count reaches
> + * zero, the folio is referred to as frozen.  At this point, it will
> + * usually be returned to the memory allocator, but some parts of the
> + * kernel freeze folios in order to perform unusual operations on them
> + * such as splitting or migration.
> + *
>   * The refcount is usually incremented by calls to folio_get() and
>   * decremented by calls to folio_put().  Some typical users of the
>   * folio refcount:
> @@ -82,6 +88,18 @@ static inline int page_ref_count(const struct page *page)
>   * - Pipes
>   * - Direct IO which references this page in the process address space
>   *
> + * The reference count has three components: expected, temporary and
> + * spurious.  The expected reference count of a folio is that which
> + * we would logically expect it to be from just reading the code.
> + * Temporary refcounts are gained by threads which need a temporary
> + * reference to make sure the folio isn't reallocated while they use it.
> + * Spurious refcounts are gained by threads which, thanks to RCU walks

I think we often call them "Speculative references".

Not just RCU (GUP-fast doesn't even use RCU for page tables). We also have PFN
walkers that don't involve the pagecache or page tables at all. They don't find
stale pointers.

In essence, all these users use folio_try_get() and friends to grab a reference
speculatively, while the folio might have been freed concurrently, or the
pointer from where they might have obtained the folio could now be stale.

Maybe it's clearer to explain it from that angle.

-- 
Cheers,

David

