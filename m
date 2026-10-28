Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A918606A324
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vNZJ1Y9v
Received: by kanga.kvack.org (Postfix)
	id 302066B0613; Wed, 28 Oct 2026 00:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3256B0616; Wed, 28 Oct 2026 00:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA126B0619; Wed, 28 Oct 2026 00:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6B56B0613
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:33:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68F22A88F6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:33:28 +0000 (UTC)
X-FDA: 85370766096.17.FD058E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D417180002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:33:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vNZJ1Y9v;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793162006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQliSYu5IO0Ztf2KMR9ZclDlsE5PuZwsA7H/3S4ytlk=;
	b=Obyafa5ncY6xQeC4RVFFM47GYGNrtbDiERU06fZlK9g+D9BOsv5TqfDbvMPDJDCImul+QI
	tZaL1zA97JqL+0AZd/tkTAkgvv7c2se6BHfWprxFP9lk/5PmzES80pp3kksjjPNAxLkBHf
	v6+S87ik5WENEG3qmSv8Mtn5dlg2qBU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vNZJ1Y9v;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793162006;
	b=5gcEwHp6uAuheS3rqwaStUumxGqONhwGPxGbfOVwW9+lgFE1WjQ0jSyGyjuj+sNCgISMvn
	3YMGP9BgVbv5Ds2WS7QZ+vgY8D1M5Pf+fXQ7Xx726wx7LquM2syxMf8GK10Fp757WWWjEK
	3bXOMYhf/E+UCibJxQUTdEYGYYg1g3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C398743C04;
	Wed, 28 Oct 2026 04:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B331F031E1;
	Wed, 28 Oct 2026 04:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793162005;
	bh=KQliSYu5IO0Ztf2KMR9ZclDlsE5PuZwsA7H/3S4ytlk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vNZJ1Y9vgwzm5vi2q/Ro/QE7r6JtOMQI/X+zg6SZf41Yqbhh5Dmq397ZRxr+++zBw
	 YAzgHNsBD8KWgp9VqpRxOFCiAqE0jn7QJCo4yAQZfuHNs2lRzHtXBX2f5fGuJCLiaw
	 AbvahUgZ+Ds6OFZN1RNimOCoo+eYNPJ0Y4MXjObU=
Date: Tue, 27 Oct 2026 21:33:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Guangke <gkwang@linx-info.com>
Cc: rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix typo in comment
Message-Id: <20261027213325.d28fb3a913c68a982b5a6591@linux-foundation.org>
In-Reply-To: <20261028040625.204-1-gkwang@linx-info.com>
References: <20261028040625.204-1-gkwang@linx-info.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9D417180002
X-Stat-Signature: tgtxsfn15oonyf76dhsm1ahqrphp7cpz
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793162006-130462
X-HE-Meta: U2FsdGVkX1+ZBhCImOHCiAxcGy78RMwnCtiisWsUJ3lvv40Q0uCIyXlDP4t3V5XOeSwB0gia08LUsF5vGBn2163DYpKlHEJ06qb0sg5+gSrjGEUVcHiT4PTYsQZJvFGd1a2eIMVGfqYVvEkMBDyXNejvxNT7lPwrNXpQlGypRlo7uvM7Pxiewnleh6Cm9iCTRB6VlK255TqUc8GuQmWF4IJKmxDwhFt4hWpXaqglkE8xcjUPezIklXiPaK8vu3IxPciv/Zs+RjqxFEUn6yEEm4E7KC29sstoeAVvF2ivrjVYcV8jZbK6OnH0QDxigLfkjFjbmBGEqBCYeJqcFuVhcxfrtFkv9PK4eJ46u4V+fOVbQ8t4OZx8YwFMq8NWQa13NdCOqJYzZKhtX3ffdyE8gLytu4/gqFCGLVyiBshBqOZ8mGZg1vKxUdAhl8l1QjmOuVMpPzNZX5BPvsS5Ne3aNygfAHW9sBvpJuFPmcq3Jf/CddbO8+fpCp9PMhflJihZmokBYj5ELF8RrUSre59Jp60+3SQVSCN6pQziH0Z91wG7E+MrquVlHhYeEkQgiloPi5N+z9cJMcz6yLu+FYVMWSLpe64Pn/65UQCRltFo3vpI1VXlwsgtNnllxt+UhQ+1rCgudgez61xdp5bH3bWadSu3UviMgABOTNxKEvZAVF43t6W/k7Zvmu698nLKChffmJFPJnZ1xOJlZqDE1ClweEjyUjspRnfpCewiaqevUeocw+ZD/XvRKwzeoF1YQxg4xmfF4ZA8gnnsGyRw7AOYG3XiDIW+R49vvvJCRDWhpRfO8WVeiyvDpphrQqb/yTtC/UfEkKYFQW4AjST5gftLjgd7U66TbjGQh7SYE9lSVFlEAKj9rnmZsJ22wS2hinInZMqzyaFp5AhS45MD1UXXRan4Ms1ulqV0JGQu2K5h0ytb59oGweg9DhyNcd+MPxsNNfpkMPr8w6URhDgSzdx
 luOojJZv
 qsoehdDq+ji7amJrvN+HoR/h8ffNoAod/emghm+FpEiE7llOqW7BykeJq45Wl8D7NdDMti8ITGgR8Ohv1AVFZKk0qUbOkFLfvHSszoF8PzAe4cF/2W8iTZMHsXWZHZ9Ssmz67qH7T/fpy4olYKaKHn8XVV/f6S2ARV1zhAmfnZmDvWqmev0LEGNjFnudegF3Wtds/Q1Lx+D3//nEr97FQCj1OmQ8q/rP2kB16qkIRsu3y7GkO59vkWDAcXBQmoYJlseK/5phOtgeuH4gIyw8d6wPzBcRYeWZXVCtXD/9slh+7tln6HLRLvmIwvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 12:06:25 +0800 Wang Guangke <gkwang@linx-info.com> wrote:

> Correct "pages frames" to "page frames".
> Only touches comments,no code changes.
> 
> Signed-off-by: Wang Guangke <gkwang@linx-info.com>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1533aebafb68..9d233b6af7ab 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1179,7 +1179,7 @@ static unsigned long __init __absent_pages_in_range(int nid,
>   * @start_pfn: The start PFN to start searching for holes
>   * @end_pfn: The end PFN to stop searching for holes
>   *
> - * Return: the number of pages frames in memory holes within a range.
> + * Return: the number of page frames in memory holes within a range.
>   */
>  unsigned long __init absent_pages_in_range(unsigned long start_pfn,
>  							unsigned long end_pfn)

Sorry, but a one-line comment typo fix just isn't worth a kernel commit.

A more substantial file-wide sweep might receive more consideration.  I
asked LLM to do that and came up with the below.

But even a fix for these wouldn't be smiled upon at this time.  We're
all swamped and stressed out over a maelstrom of bug reports and fixes.


I found these comment typos in mm/mm_init.c, against mm-unstable
4685a28187f4:

  55: "then end" -> "the end"
  377: "before borrow the nodemask" -> "before borrowing the nodemask"
  1090: "smaller that" -> "smaller than"
  1092-1093: "in the lack of an altmap" ->
             "in the absence of an altmap"
  1217: "sized independent of architecture" ->
        "sized independently of architecture"
  1223: "in order of monotonic increases memory addresses" ->
        "in order of monotonically increasing memory addresses"
  1279: "pages frames" -> "page frames"
  1524: "been setup" -> "been set up"
  1631: "0 ," -> "0,"
  1651: "`struct *page`,so" -> "`struct page` objects, so"
  1921-1925: missing spaces after the leading '*'
  1957: "pfn's" -> "PFNs"

Two comments also name the wrong thing:

  1481: "multiple of pageblock_order" should be
        "multiple of pageblock_nr_pages", matching the rounding below.
  1834: "arch_max_dma32_pfn has no pages" should be
        "ZONE_DMA32 has no pages".


