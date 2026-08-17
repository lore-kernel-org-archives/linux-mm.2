Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AAAC5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2FC6B03A3; Mon, 17 Aug 2026 03:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A43B6B03A4; Mon, 17 Aug 2026 03:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BABA6B03A7; Mon, 17 Aug 2026 03:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 191D16B03A3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:43:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1CF81606B1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:43:46 +0000 (UTC)
X-FDA: 85109972052.15.D5AFDF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12BCA180003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:43:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUoBGxsw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOLwOWFWj2EYoYuWpXUI7EDELr3uGT+bmLAYafUVkn0=;
	b=d8/tMCZSpLEbtEGhwNoOwNpsDmncMC/fbn7GLGWDxiE/FI5hW6v5xzB0JulA6HGJqtCfZg
	9TZYYLe3tzI+dOa7T6BzDU9FlyroqnvkeXaTwmTNS9nmzWEpJwNM8ORjTCLTQb1R2IT4JM
	Q38nNrUx7zqwYUy7oPcceoXPSPTwBDw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUoBGxsw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786952625;
	b=iM3z1E7+hKoGgjck+aIt0WLjBHT5gS7HI4DrWarL+WOg3QV8G6kxCh47QNDT4JD40h8w1M
	ksMsaYVLfJsR1loXULYsb462h89t0T4pyDf1dgHWMKBwVkmMtt9dF1KV7JoNtjRplOo3AB
	OTN1zLbIawqIggFCLX19dYGg8QJq3Mw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7939A600AE;
	Mon, 17 Aug 2026 07:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB4D1F000E9;
	Mon, 17 Aug 2026 07:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786952624;
	bh=AOLwOWFWj2EYoYuWpXUI7EDELr3uGT+bmLAYafUVkn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JUoBGxswlMbMNlRDd6T3OhgILdAnkLgoonaUHwmaP+Oif9MmC9/AD6RRobKpLvEob
	 ALnBBdihKWjC+fkxlWbldyGwDfCnozHWOvvLuQPvVf2HdLSVLwUP+7yphSV0cCDcNk
	 dxM5OFqOjCLdqZ6d3s1nrrRAscdPc0HQjzVhRw20r+iofJxeVWVgvV6rln3gyG5l0y
	 Q1cHzjkyp8nYPwohNJxyvsVBHfIopB13EgE430aeRNqznB8Gf25bfLgaVlC1nCln3K
	 0Nol2Y1sJ5fntS32nXYySYpgjCDb3eK9qAVARupMYbzVnaXQIyr3/UFadpW9oKHH54
	 6tQ9XJpJ7wcSQ==
Date: Mon, 17 Aug 2026 08:43:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eric Kim <seohyun.kim@outlook.kr>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v4] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
Message-ID: <aoK7Ko9O8cGz2iTF@lucifer>
References: <OS7PR01MB13914C76BD66EFB5AE2BC8F6C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS7PR01MB13914C76BD66EFB5AE2BC8F6C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Rspamd-Queue-Id: 12BCA180003
X-Stat-Signature: zr77jqftfx4xa7gnektyw9en1sjz5tee
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786952624-194669
X-HE-Meta: U2FsdGVkX1/b7jHysYO++lpdjASW6w/52kfzlSV/XLPiCeLp0arGXxqdrX6a1ienPoejOMVWXqFWMs/sgL9uLoieoGYVjJaT38bJOvwfLj47mL/IgqVZOg2Y/6XCy3kkaei8REqXdb3zO/8UxMhMkFWRMdB/JcCbOZ7xPXeK2K9qfDGI6Up9ZD0heIDAHWtZ4425bhtmoH2mWrzpydGH4NdBlDpnzkAfkpPEiTtUi/KEyrSR9GY2DiGxVnqSxLoizpq+WQPWY727Qq/PV3gQtsaXygcEKABF881VWDBdoeGxWXIsBHsORSG9GIc3bZZy17oaqdLblFVwqFEeB2iQY8gGfzCme8HSPLPNmOZSonwDVgmzFUWNoxJ5tx7lL2Ji8/+2h7LSTxYBOIXlaRxZ2SgtwPSZ1rfF5a4wZ8HIp4PllQ15JlHsslUvokXBNzwYNacsMQkKhNQJjWCkMpzDxAX9+jmzIh3IKXsq8t1aOgpMkRh4Lh3eAFoxyMVTbnDM5KmCfq2t53FBr54wcsfYroTSGcEhEuotUC4POG+8vyAk7UyBFpacwrgkd9Gv98PEZZiuJYHefbQJPz6jQ3PoWcWvl2Any/53Y2Jg32ffijxF/zbJCiIeBsbwNXJyMj3s0CpKZcHYYDmyg2DYF9OkC2Awfa/7FpColJzpq4iNHQq4ZBGv9aUmGg7+lhncy7xyaDt1fq0HgoRfl5MYRFGVj+XiRzQ2bxEteDqTEKz3S46BgKaHxhGdusI5dhsM8/gTP3eu00duS4njfLhzlUh5ujRF+u8d19puF2hyfJ/XGmtknh8xZNZbdTrRZSniFjucq0xFGog5+4NCbVsSAgnsb9o9wz7GbrIlIhJj5F3feqblQKWKFglZbunn+cwk1VHDeEvOEzogqXnclY7cob9KzcVQ3qO2mv8YhAvGW/jgykuA9xbkmEIBMWqBK8lqww9zSTx20VmqSijgRGV6iQW
 5krsXPiO
 QpA5gnhf0O1HkApHmPkeVOTCYLqp+eP3pBzE4mrnowKHwXfNM+1wWMgzvHBlHtxzCqlwcb5keMQKYLvSXq64MV2i46JmJl67wj+/I6r98dk7ATcZo4j+y+DpPEjBwzyUeFOmY6yjMfRcZ5oLP3G+A7odbILGEap7kF0gS5IhBqHU39ANiWGu2jYm9FSVjwOud4ElrbwKK/NLoUR/LT1Tn9GdnBh45vQdtGus+e5wLkqyjo6IWivl8U2SQpknUZwZCnOgC3dV1F5CIiZVXYXnxrUDTMx8rHOZcNNm3YoDSLRxb8QeCuXpVQZON1TkOKcUqBURqHVLYqiDDv5G1+C0O7MCzCfOvUT2gW//oLmN5JsbbPMfhadIa3INj0CdoWnVblu4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:25:11PM +0900, Eric Kim wrote:
> Currently, in anon_vma_clone(), active_anon_vma is assigned from
> src->anon_vma and is used when unlocking anon_vma after linking
> new AVCs. However, the corresponding lock operation uses
> src->anon_vma directly.
>
> Although they are actually the same thing, use active_anon_vma
> consistently to make the lock/unlock pair explicit.

Thanks! LGTM

(Your email bounced for me last time so not sure you'll see this :)

>
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---
> v2:
> - Clarify the commit message to explain that src->anon_vma and
>   active_anon_vma refer to the same anon_vma.
> v3:
> - Carry over review tags from v2.
> v4:
> - Clarify ctive_anon_vma and src->anon_vma refer to the same
>   anon_vma.

Extremely petty nit - and you don't have to do anything this is just for the
future:

- Prefer a reverse order, so latest revision at the top.
- Nice to have lore links to previous revisions.

:)

>
> mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9..f3fadfb69c7f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
>  	 * Now link the anon_vma's back to the newly inserted AVCs.
>  	 * Note that all anon_vma's share the same root.
>  	 */
> -	anon_vma_lock_write(src->anon_vma);
> +	anon_vma_lock_write(active_anon_vma);
>  	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma = avc->anon_vma;
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

