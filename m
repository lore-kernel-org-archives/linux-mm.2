Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B774CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A85F6B0088; Tue, 23 Jun 2026 10:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659086B008A; Tue, 23 Jun 2026 10:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F126B008C; Tue, 23 Jun 2026 10:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6046B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:22:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B32FD140481
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:22:38 +0000 (UTC)
X-FDA: 84911393196.01.3DC495B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9053F8000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:22:29 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782224550;
	b=xtf1j272dZPkQ4urCINtLusZwIaERHRUmCDsy2Oh6CuwiVu8DUuMkjlfwB/a9O3SbU0tCk
	k+TAmYDB4delOzL9D0GFDjjP7d8JeuljmdxAgTj8Y8PsLhDsvCN2QCQoXLiduKkx/nPK82
	DMnnzi2Iilvg8K1ky47ypidOXW9Pqjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782224550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbJ30SnwEwUR3e8QYeawvmgbLBk+kjbCq3ADAQydQzg=;
	b=ve0fJSSzzECrFD4wkk7/SltJBk5Lgg8yswkA5cDPNzyvl2k/Btu2HNIq6s3KOcUVt9OdHo
	+00FUpyazxDnd7SaZhtRBVgS8fJt3ZVb4G13dAWJw5BACtF9tBBrdBe5wdW5P/B4QyuJ4a
	KOBNDglKFRnMInruQ6ZdL4r9+UOBxWo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wkJmvyRY;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fbJ30SnwEwUR3e8QYeawvmgbLBk+kjbCq3ADAQydQzg=; b=wkJmvyRYcFD3fRkfyKwa8m3t+m
	n8NWc/IW+IFlDBUKitA+2xKjsdqTGoNxB9Nlm6qD4kE4FCpe6Jt0CZqxzKTtthkJoEPw5MZr0xAvw
	Rzp3RcGEoh3p6n/YRjGwXvK9jdzd6vXMs0d6ShbFC2/dU3ZRwPpy6VrtirW8ALhR//DP+RFCPgRbr
	8SRtPYM0TyANAisg/ElWKSc8it83cr8rg1BRlmamwbb7nFMzXTlcPrcpqKTNsnY0FMv5EwdtPJnKR
	JI9cTB6IMXcWKKINYxKlJakAZ8+JdxND2hfRVv7b5tMtWu84leNe6PXZ43zPoF6ejL0l1XxE5WFJg
	1ta+nKsA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc21D-00000006QeY-3tdN;
	Tue, 23 Jun 2026 14:22:28 +0000
Date: Tue, 23 Jun 2026 10:22:26 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Watson Wheeler <imnotamilkglass@gmail.com>
Cc: linux-mm@kvack.org, Watson Wheeler <git@tazy.dev>
Subject: Re: [PATCH] lib/maple_tree: add missing spaces after switch keyword
Message-ID: <pbswbs3zreboqwtwqqorjwndrt666xm7obtdy3e6fqamy6tled@r2c57n4ei7iy>
References: <20260623061730.2024-1-git@tazy.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623061730.2024-1-git@tazy.dev>
X-HE-Tag: 1782224549-43034
X-HE-Meta: U2FsdGVkX1/gZ0tjQZA1ggoK3diaPox3l4RtZS8WUgZ0c36EOuUrnjR5wm0ITX2WE4wK/jTXmmLfiPVAUmfPZzW7TyxTbpLfVaN97K3s9PowGQnfZQKBV637DhytUN2+9k1IElY4BUebi8sIcVMKUtKkrahKau16hM2u1wV6QYtZ6MteoWdvj+3TF9AlUmEm30budyjnf/b1J2X63VLnaWvD6YvN/3M2THINTXWfCPVWANk0uSzKNvjV+Fnyl9ofaI8amS8d6b033dV/S8OifQ0pn7hadV7slywQc5JYGtaACfgL0wuXXIui0hne+a+ZwwZEfqZSNGVGUd77TDVtFzdR1IHH+RRb33dX+NMjPXT4HRTG0TdceRN80RZvQ+U2U/j0Ssv87tZqnBfYQ/s5VlZl6rmo3dOD53rc/ANrdm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/06/23 04:17PM, Watson Wheeler wrote:
> Add the required space before the opening parenthesis in
> switch statements to conform to kernel coding style.
> 
> Signed-off-by: Watson Wheeler <git@tazy.dev>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  lib/maple_tree.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index e52876435b77..529acc056e55 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -6447,7 +6447,7 @@ static void mt_dump_range(unsigned long min, unsigned long max,
>  {
>  	static const char spaces[] = "                                ";
>  
> -	switch(format) {
> +	switch (format) {
>  	case mt_dump_hex:
>  		if (min == max)
>  			pr_info("%.*s%lx: ", depth * 2, spaces, min);
> @@ -6489,7 +6489,7 @@ static void mt_dump_range64(const struct maple_tree *mt, void *entry,
>  
>  	pr_cont(" contents: ");
>  	for (i = 0; i < MAPLE_RANGE64_SLOTS - 1; i++) {
> -		switch(format) {
> +		switch (format) {
>  		case mt_dump_hex:
>  			pr_cont(PTR_FMT " %lX ", node->slot[i], node->pivot[i]);
>  			break;
> @@ -6517,7 +6517,7 @@ static void mt_dump_range64(const struct maple_tree *mt, void *entry,
>  		if (last == max)
>  			break;
>  		if (last > max) {
> -			switch(format) {
> +			switch (format) {
>  			case mt_dump_hex:
>  				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
>  					node, last, max, i);
> @@ -6576,7 +6576,7 @@ static void mt_dump_arange64(const struct maple_tree *mt, void *entry,
>  		if (last == max)
>  			break;
>  		if (last > max) {
> -			switch(format) {
> +			switch (format) {
>  			case mt_dump_hex:
>  				pr_err("node " PTR_FMT " last (%lx) > max (%lx) at pivot %d!\n",
>  					node, last, max, i);
> -- 
> 2.47.3
> 
> 

