Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179C8F588C3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1486B00A2; Mon, 20 Apr 2026 09:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498706B00A3; Mon, 20 Apr 2026 09:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5816B00A4; Mon, 20 Apr 2026 09:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B13B6B00A2
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:04:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C68845BD36
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:04:07 +0000 (UTC)
X-FDA: 84678952134.11.D240660
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBDDB20015
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:04:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TENHAvJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776690245; a=rsa-sha256;
	cv=none;
	b=din513CpCHnpyzYQoQpBKCcd3wsVubNfu1ZfwiDC13+3T5UiSAUPpkiFmh+8+w/AB+hoxY
	gu8P2qIiVntTvAfF/AJK4/MOknoVQ0YQNeUrF+uhn6is1pG+B9uUMqa4d5gBf7DoMinI+f
	xJYhc8ju0i6A4SqA9Gm0CZx24EwOp18=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TENHAvJl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776690245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILj1rkZZomftGRD4BP4HFLRr251vFfaSPamVX3D2D1s=;
	b=8BQFif2cPgUQwe+OuzCnsG0CEyuwc68Lqq+xSWBb1TlJbKoD2o29Ph1EQMV6/X39XFNZS6
	+VMjy1AbwdV3INVZPhfnysfu5IvzqRGL6y3lZIhU8kylhga9iPDT/jog4BgSuTcQKw6hZe
	BxTci928JeIHLySqMP6vkWiN1N1eIQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B8C160142;
	Mon, 20 Apr 2026 13:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68B2C19425;
	Mon, 20 Apr 2026 13:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690243;
	bh=6l/uKiHJ2TRLu8+eUqPvROgTVTLN+Kie5LYERHfBn3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TENHAvJlSR5HWZdXlH+qS8mibevUTztLgJ316ztE2xRMjxHu53WL+v7VEYffTzC2F
	 7jVF51Gb+oxB2RKPT+juxNZ7OXlqp1psb8A9VE1XB+NmSUf1B7ZWRymG2B29NXkEtd
	 jBt94Z4aRfDUu3pGSbNrZ3ei6HYUxqHv/U4H2Xx7LKuXKfxbogdOAjX11YaYGKikhg
	 QmE5bRgUgkqsYONQ/aqy6nt8kKHCYeptNSopGUZkrAl96+WPQgp77Qq8SBUdETKhBS
	 91pZ9YlSpIblGFnw+sorFkeZsffdpqTI+vD9Kvhfjbppm50N1JIxaxJEgcKAtDf0LZ
	 Boj/1q6sqtuRw==
Date: Mon, 20 Apr 2026 22:04:01 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vitaly Wool <vitaly.wool@konsulko.se>, stable@vger.kernel.org
Subject: Re: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
Message-ID: <aeYkQZHY7Vln0M5L@hyeyoo>
References: <20260420114805.3572606-2-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420114805.3572606-2-elver@google.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: kypgcemsfnj1wqysgb9bqi1zptw758r9
X-Rspam-User: 
X-Rspamd-Queue-Id: EBDDB20015
X-HE-Tag: 1776690243-620896
X-HE-Meta: U2FsdGVkX19fiilS8KGfBes/g5U2cC+XSaGO05pxkAKtgjsgNQvSlOq0GA/DbjorI/tsiMcpe0ISSfsNILXpWix1F4kV4oqzMZDX/q999ryuVSvJnVgN6BQTQQ5jYi1gJ6SUSgdpSQPzKtIkEZJuyKV+0sTZH0m2TEQTkPtMqGYSRjuDXc41VHKmKvDUsOwsRKAya5mhgRjGaTUY4VBYUqQcV0vZdX72kz5tvybuo8EPLTLSXu9krHf2UbEP3u9XzjY9/LEiAUc6BqZv/sFlDEgOoieZho4ncZDMgPzg9Owx4T6jFcGfoYT9fjtWM+OiIe1KicQoo6lgsPto2Gt+c2BKyrijXywP3DfkTsdKLZWbYGKLP13vXcECCLWzt5BkzgeU/oxh9ofeVa1BXbMKcPiOwGDb+vWoU2PV88fHNh/fwhmBVn+Lp+E8aQEdCqJKx92Fz66UjUEnurHTBux2GZ7vFN8OtLY75uvZi54DEXFrX5QnHanU91OAdwKbh8i2Zx4oPWNMBT+JkFYxF8eVuSRlJJKZBKkaaxifUHdNYHuZ1WS8N2cZp2Er2Bu2JA93NS31ejpSFET09z4vZU9Aq/4nZU22A6EnXPilaE8oCVK7lhAIUjEaIM7W1vTW+SSi0JqvaB0Th/ywfqgENJ9nQ4esZwkG84ZhJ3vkGrYgFudjRqQ1MYcQfiOQ3ql3rfms6KozWF0RVWEcfUvg4snG9ir7SSuW3XG7xfXXTvX/AZlqTp0Pooex2rUNaRBbBnDpVtHbYutO9JXi7RgaqxpaODmwgnTCPaZTDIgrgcsXjz2jOsnLnD5wcvYI+TfCasVPpU8DiA16jfwwb5BaeiQ3Sl5g3kdXHs+lDmte/EVu9wXNf2AWX8DisTMysyYCk5ZGmvgvC5rxQZunDhFbJ5WRDwnrKdJ/STKe6FIldjCDuIc6ynT5TBBRk0UqN6PgF9OcP2OYWO0yqFt6/GsNnoU
 t8iwkjl6
 y4mHhZf3jyi+Y2r8iRbgvBbaZspg1PtwdKFwdvAMMPOo69UX1BkZBlT1M2u9aB1HM8x0d4QLvY0bvZjilv3AanFeK8aU+RPUn8Yuepi6kMTgm5cO5k4D//v7mKoGn6owFC+yRR4X3/nHLpznVp+ObybOWTKX5ywvl+yyFuk68SWaydUV4JYe7tG3ZMy/LlHmucQ9or7vLEpuyxofaaeltaKHO1yW17/FGi9flUYcnm3+FmAv+hIzRArCfSQnLbZg1sVSH//jFDufwuxDeWrBNdu/Hd4ZOvULnY10H9roTUHUcBUBCsyjO5iltaXfAouMyaZe23itFPtdPPq51wAcFnclvkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 01:47:26PM +0200, Marco Elver wrote:
> Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
> vrealloc") added the ability to force a new allocation if the current
> pointer is on the wrong NUMA node, or if an alignment constraint is not
> met, even if the user is shrinking the allocation.
> 
> On this path (need_realloc), the code allocates a new object of 'size'
> bytes and then memcpy()s 'old_size' bytes into it. If the request is to
> shrink the object (size < old_size), this results in an out-of-bounds
> write on the new buffer.
> 
> Fix this by bounding the copy length by the new allocation size.
> 
> Fixes: 4c5d3365882d ("mm/vmalloc: allow to set node and align in vrealloc")
> Cc: <stable@vger.kernel.org>
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Marco Elver <elver@google.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks a lot for fixing it!

>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..8b1124158f54 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4361,7 +4361,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  		return NULL;
>  
>  	if (p) {
> -		memcpy(n, p, old_size);
> +		memcpy(n, p, min(size, old_size));
>  		vfree(p);
>  	}
>  
> -- 
> 2.54.0.rc1.513.gad8abe7a5a-goog

-- 
Cheers,
Harry / Hyeonggon

