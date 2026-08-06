Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 106DBC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C952E6B00A7; Thu,  6 Aug 2026 05:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46576B00A9; Thu,  6 Aug 2026 05:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C0A6B00AA; Thu,  6 Aug 2026 05:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAC66B00A7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:11:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27027A0737
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:11:38 +0000 (UTC)
X-FDA: 85070276676.15.B264E75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7D29140003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:11:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyLZ3Zh3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786007496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in93mgYbw0F04Zxk1y2Zn0DH94LyJQ4nBw9npqUTqbE=;
	b=7M+psL8B9pqsgmogKVf+loZ/+FqP39zoNf5ofau6BqSaA85hPdBSvAYqO6q2BwFh/dqElY
	v6imqVxjOUGTrkXsDoePpeSTNiHF+VViV1IQ8ZBoYPc03r7+jjt/4nTmarNzJbz9DdFW2b
	Whw5XtdujKeUx7VnDsKNxVWK6j+uY3Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DyLZ3Zh3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786007496;
	b=ic2etMjBhB/5KKclQ6LSmuCvSuz4ky3LejWjYlcvCxo2FcF96n4dSYH2MSPuERPY7MXO66
	01ztzf5OH1RQX5zfsO+4pgEGrAPDoPM167nafFaIk9GDeH46lxa62TXDBEqCIJD3tNYUGE
	FhBtCMTq+x+4DWqe7+vS7F5h6rNV8c0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D565C400CE;
	Thu,  6 Aug 2026 09:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB891F000E9;
	Thu,  6 Aug 2026 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007494;
	bh=in93mgYbw0F04Zxk1y2Zn0DH94LyJQ4nBw9npqUTqbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DyLZ3Zh31dW5z00axg0BKCzVlVa7D7QuO9L9lSSWy/WGXglK73KJqRoOBLZFyFxZi
	 zmRJwFsNtTbD+WCrIz2DACQ5RloEdH0v6wKvmoGdHmFcBVEK3x1agC+PfXfRYVDDGg
	 6Bwmehy15falLfdD4IzxdAmEbOTOC6LdnDZyNYNyPTq2Iob4nt4rUwO6IJwn3CxYBy
	 eQ7iVcNziIRujMXenBGqPiO+QwBPColW6sNa67PoYU/WtE+OX6XJNSNiOAicQeq2Ca
	 Xn9o1cehGIA+Kb4v7gzBMzQa9jS3CZcCB14KG7y/GP3zTPgjmCwipqVgURhOUU8FGg
	 hSfJLoFIDBntg==
Date: Thu, 6 Aug 2026 10:11:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, 
	vbabka@kernel.org, jannh@google.com, 00moses.alexander00@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: avoid skipping pages after splitting
 large folios
Message-ID: <anQyoZgi5Urnvvjw@lucifer>
References: <20260806055501.56761-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806055501.56761-1-cuiyunhui@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D29140003
X-Stat-Signature: r9pbrue3sabbqoud5wqdyent1d6aqmb4
X-Rspam-User: 
X-HE-Tag: 1786007496-581956
X-HE-Meta: U2FsdGVkX1829ESmDHYJYu3lvvZubwZCbdUP9I+no9naYLFoTb3jOlalKIRxIg1Ah39IOfF1EPJJ0YpBMPth7cIM3yhCa8YAg8QBnoWkh3ghdWcQhva+CSsf9qvFqPgx0CoNCWb2MsUtPcJQPvJ8/C5clF07el8UhTiri1VQJHG1OYt61/oXcVx7kvjNXFQA6R9hYNMOzhGluOBMx0SJcf+h73vcUyhpXE1gex54D+YAZXqjr2hhNytOOmvMmAtlVDL281QrU60CdTdlt3JQPKwvJakvb24RL3uKT6cdHGzJEkX4VYvLDhXdLxHTZL+RtCcA7BESzlnAGf8ydnidv1CJCV3ZYerVbNvkBjARcR9TTWqvlWHGcVtXMKhuoYgPaqWyO8IaY1dXzRbtKZ21bygiLCHU7DsKuwqHW9KG34wfU/5Gv74nuh27loDM1LC/fDrWgAFz1iUaxf+0otY7RPYqACJqxXVEd3Y6EARw0a5lU51PEiyRoJJ3vkNxYWGkmemzmENGa4kJzgUVE75gUvtsr8rbQmppo5FrduXBcyRE/Saow5LkVmaKv9OMxYV43Sx9s+8GpiRzBlJUKJGNNvymEE9hGDHnm/si9l+ni4/cVLcyaNlSBSObzEQH4Yfgwtt3gcuby33BunnY4fueOutgjxqcK1fi7dJST3nXPgqWkVyMYUNhxmH+MC5YSawvcjST1XuYjQu/YteQrasAxqYRHOEHNQFC7Rqyx/53DJpMeHL18Qbv/OODyExZ/2Fb56WjLI+pWfT9j54mvxN9PiBiBe5qbL5T9iB0zzNKDCvhgPMdIrstWP9oPIJQJEooCNPnqN777tkHq62QYBFor44CkSU1x/xOikRWFxbRwCl8nNoDCvLtO7ZbmbnQSwgl9v7QkbhLvjsZ1bYK2iaqKk06wH3/ZfB8OD7hp8ZO1sYsXgPKK7Q7BsXWUmySDOgKJKYwhIxjR1aNOPUt5Wl
 aDAAK8pl
 SObIzgfpuHZcTGyWnBaAJb2NfHLyoApYLv9ipoF9KtTov3GyIVKcn+fJ5EV6UGhMiEl4r9UUb/vlIaLGcNdnXHdItatyf1Qo//PbRNjkv5e8G9OkO+kTIVP1aKRCB9xv9B91bmJUQsrt1ODiPeIGEyQnkkDtmPb+nUHnaCZarzBk6cu6gojskIdqAKfSopT3rPES8/Fn7FvpAb7KXAzrFaztzor5kcUPDKRCeX1SboDIRT/jnTgRZTeBVUmBshow6G2V6pM6mNEb4F4MQvdMmtsOtsSM9ITzRH6eny4arxwyVYm0ZXUvUGutl8HIK6S4v8MVzhEV0HD8S4RTs/JHU6r4+Q8zwE/5OZY+U/3xtwhHVVVj4PGK1EI6sHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a newer contributor to mm please wait for feedback on a v1 from reviewers
before respinning, thanks :)

On Thu, Aug 06, 2026 at 01:55:01PM +0800, Yunhui Cui wrote:
> madvise_inject_error() advances through the requested range using the
> size of the page returned by get_user_pages_fast(). Saving the size
> before error injection is required for hugetlb pages because successful
> soft offlining can dissolve the source huge page.

But you're also changing the behaviour for MADV_HWPOISON not only
MADV_SOFT_OFFLINE? Explain?

Also mention the specific madvise flags...

>
> That stride is incorrect for non-hugetlb large folios in system memory.
> The memory failure handlers split such a folio and handle only the base
> page for the supplied PFN. Advancing by the pre-split folio size then
> skips the remaining pages in the requested range while madvise() still
> reports success.

As Andrew also asks:

How did you find out about this? Is this a theoretical issue?

Why? What? Who?...

>
> Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
> folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
> folios are handled as a whole.

You get a folio to check to see if it's DAX when you have the VMA that you can
check for DAX?...

>
> Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")

4.14...!

> Cc: stable@vger.kernel.org

Stuff that touches folio and soft offline-adjacent THP is going to be tricky to
backport correctly.

And in madvise(2):

              This feature is intended for testing of memory error-
              handling code; it is available only if the kernel was
              configured with CONFIG_MEMORY_FAILURE.

For both MADV_SOFT_OFFLINE and MADV_HWPOISON.

So I don't see why this should be backported. You might accidentally not quite
offline/poison everything you intended in a test but that isn't a bug?

Given nobody's complained in nearly a decade I don't think this matters.

Also you're suggesting backporting to pre-folio ancient times which is going to
make this horrid and tricky there too.

> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>

This could really do with a test to reproduce the issue. Mm selftests already
has memory failure stuff.

Please provide one to demonstrate the issue.

> ---
>  mm/madvise.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 5a09cc24f04a0..e9d4c3bbc5290 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1455,20 +1455,25 @@ static int madvise_inject_error(struct madvise_behavior *madv_behavior)
>
>  	for (; start < end; start += size) {
>  		unsigned long pfn;
> +		struct folio *folio;
>  		struct page *page;
>  		int ret;
>
>  		ret = get_user_pages_fast(start, 1, 0, &page);
>  		if (ret != 1)
>  			return ret;
> +		folio = page_folio(page);
>  		pfn = page_to_pfn(page);
>
>  		/*
> -		 * When soft offlining hugepages, after migrating the page
> -		 * we dissolve it, therefore in the second loop "page" will
> -		 * no longer be a compound page.
> +		 * Non-hugetlb large folios in system memory are split and only

'non-hugetlb large folios' is horrid. Large folios. And 'system memory' is
redundant.

> +		 * the addressed base page is handled. Hugetlb folios may be
> +		 * dissolved and ZONE_DEVICE folios may be handled as a whole,
> +		 * so save their size before error injection.
>  		 */

You're discarding the whole thing of the page no longer being the head. But I
guess with folios we don't need to mention that.

This whole thing can made more succinct like:

		/* DAX and hugetlb are consumed in folio chunks, everything else is split. */

> -		size = page_size(compound_head(page));

Yuck at this existing code.

> +		size = PAGE_SIZE;
> +		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
> +			size = folio_size(folio);

It's really disgusting that hugetlb is treated differently with everything else
treated page-at-a-time.

Honestly I'd prefer to see a folio helper so the main loop can just assume
folio size stride.

But you can enter midway through a bloody folio. Ugh. So maybe that doesn't
work.

Let's at least split out the folio check into a helper to make things
clearer:

static bool poison_splits_folio(const struct folio *folio)
{
	/* Hugetlb is, as always, a world unto itself. */
	if (folio_test_hugetlb(folio))
		return false;
	/* Soft-offline errors out, hwpoison traverse DAX intact. */
	if (folio_is_zone_device(folio))
		return false;
	return true;
}

Then for your patch:

-		size = PAGE_SIZE;
-		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
-			size = folio_size(folio);
+		size = poison_splits_folio(folio) ? PAGE_SIZE : folio_size(folio);

I tried writing something that was neater and nicer but AI kept pointing
out how it was totally broken and I really really hate this code (not your
fault :).

--
Cheers, Lorenzo

