Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1372C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F496B00A3; Mon, 13 Jul 2026 12:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8D56B00A5; Mon, 13 Jul 2026 12:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6B96B00A3; Mon, 13 Jul 2026 12:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3146B00A3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23F1F40206
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:13:51 +0000 (UTC)
X-FDA: 84984249462.06.F2CE92B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7061B1C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:13:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmDPBYv6;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959229;
	b=FZ6LlPNsCkf2gdytx8B+ZL8sg/TGXwa1gNuy19v6g+sszWxDr/udJ65UgY0PDXoD3V2EBO
	2N0TdGcwiPJNkyGLopmwnPrlzQac73ccYCZ/HLaueRANO4tWRjY5JrkAilJabpnssS2d1p
	tki1YA8GpaIxJhMwgPJjhKST+kkgwKI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmDPBYv6;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ggLaQyM5HWvBPO+q9EAN9S5KITVNDf38aQ4yiSX9v4=;
	b=nvwScKjaWVGXxRtqYFysafeWx0GqOAJGnydu7Y1WcTEAhdZ0SHat3CJVsE/1ie1FH2pPlf
	rU/r2uSbL0E8a1GR6Li4XB0HnrHd1uwawswaII/SppIgZ6oA3J+kVPNcHFLW+5CedtK9zS
	v0BJZzxpo0bM6wFn7uTqQAukeEr5lrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2C9C42B6B;
	Mon, 13 Jul 2026 16:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BD51F000E9;
	Mon, 13 Jul 2026 16:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783959228;
	bh=0ggLaQyM5HWvBPO+q9EAN9S5KITVNDf38aQ4yiSX9v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmDPBYv6lYb6rD1tAjX0/MlpQY37ID88BRPfLYeEmA4+NmZDwxmgNMHdrrlxBcZ2W
	 my0/u17CQENYcRbDHFY+kiiwzK2dPp4Xabp7hH4DHDT9NF7cNFrDzZuQzdw9osIOgu
	 9VxIx52ge/CSbkavQ6iBAoP5Ucr5vsLe+suvZoJBmJ/clxU1KEzZ8zg+YgChOA4E7y
	 /gLfA0Bo4BUDpWT+ZX1w9p96OFs5gyw9zMyWi0s75ibt6acgwUKF3kvE8Bsj9J8yYl
	 xzQ7+teqjy5PXpzvYW3YVdkipm9T8a1qqHjNvme0+iUXuuYx8JaI2SDp4WtSBxktkb
	 X8h/1DmKjvW2A==
Date: Mon, 13 Jul 2026 17:13:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	chengming.zhou@linux.dev, qi.zheng@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	wang.yaxin@zte.com.cn
Subject: Re: [PATCH v2 2/2] mm/mm_slot.h: clean up macro parameter names in
 mm_slot_lookup() and mm_slot_insert()
Message-ID: <alUNQrCzt6Las0PP@lucifer>
References: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn>
 <20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7061B1C0005
X-Stat-Signature: 5bzm81d1prnxrdm8gng9nzhec5os3gk8
X-HE-Tag: 1783959229-474100
X-HE-Meta: U2FsdGVkX1/comQFWA3YBP+iZT3mS22iRAFh9vOCpfsOSl7CAEZ/pBwXZahgKKFSzP+7kjTq+lHjDx8AaZ78saF0n/08Z5568RBAi8OOHnl1pr7L2XGqjzc5uAE7VOekcLOGRAzTd2bLLp9eLwCb/Ge47m8Hnmq3eh8RRsyF+HTaHEij38xdiUkFOK5ILs1QrmZ5sT9m10BlDamXOpaNcuXdkN2qr+8nrvMBVY5DKL06swMNrfJ5c/E/73HHhUfei81BenrDAYKp93sz/SQMRPZ5FvvbpGFdqzm5ydLK1L3Nv8AYsBsqmLepLabn4vY8M49mYUISX4T/1SvldJw4xyomL8P/LROiUrpNILhchF/xSJ0iMJFkLqAMyLdEPSmZF1ap7ysaPFKls/R3sRmp5DfBO4Av4/mdBZOo0rybcuSqwLdvZff0hKJWv9ku6TyZBpaCOn2KbU/b2TvLQBX+yulp8leZ3p390mm8+YCKZd5uZAWVEDFByMRrwrEMYvvIXg/h2Rtqc1nZx6k+jkfg7FTRMomp4vQJC67+67LeFX7lQ699XlytYH4NQ/+bhJqJL3huzfMNngsTxJEHjERJBpLO0md3aT+pjsz/ockvFzp5onNHoy0DTClLW09YIpg1fukU2LKMieJ7/QRDa744id6CT67kdH7TNGYhc+3ZHv06mwF9cXLHmiNnpjVMvv/MiHZVhjgMht58UbRWgmkNbCi4JawxNpmnXzpTpAV1c3EE7zJhFcnHlUAB/UHes/QKnleX/TACnq41y8VOhdlqlu5Y9UImiyWqbTArozSYu73WZCJXPKuDb2HHA4BIsw5hESG0suDlnatXtX18XqXy6Yu8GU1qVjRE7dmspFWGHHmTE8N3iaRyS+UqZArccPSwembCdIzj/nAUCIuvr+bUpUlvILHQTLmuM0ShdatFHdVnmfJoP1N+iI5O7Beya4LTF6DWBGnzKewJxbE0DC3
 6EWDeOsG
 06irN1Hc4wen4XBgOIIQl6JHyG82QInhROgOt2UYe5MKpzfKWpDL8jM/dpoa5gk3JrcOqz2RI8zROR204kFw58fHQvJrzPsOC5B+qUTazPHKFeWIUurozeVZCQvXBTUnVX2TCyukabbdm4rktTxy2qSvJFO2Tj8DLSUpx9WjF4e4oDW8J13ArKrvRo986doosNlXwny/g+YrZsUC1p062+HDRAEr/Poh1I1K/N52kO+wQr046EicPkvrWiYz3L+FFdJ6rcu2ZpPPrVuj71uUAfmDF0O+jQHKQ8gW7eI7Dgbh9nMPW39M0DNwJ0L7LPpj4xTGDJeVOlpTvVzJk2/aNBitf/4QX+OEAKZEOrHTV1GLzZWM6CfmXZK/pdPseZ5n0XiBA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 02:41:53PM +0800, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
>

Obv. as others have noted, you're missing a commit message here :)

> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>

Hmm not sure I suggested adding a comment to explain it...  or removing the
prefix _ from the existing macros :P

> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

Honestly I don't think this is really adding much, but I guess adding the
comment can't hurt.

> ---
>  mm/mm_slot.h | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 5de3e91d86b4..710c70166c79 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -33,12 +33,17 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	kmem_cache_free(cache, objp);
>  }
>
> -#define mm_slot_lookup(_hashtable, _mm) 				       \
> +/*
> + * Note: mm_slot_lookup and mm_slot_insert cannot be converted to static inline
> + * functions because hash_for_each_possible relys on the actual array argument
> + * 'hashtable' for sizeof() instead of pointers.
> + */

I didn't say that you should change the _macros_ to drop the underscores
though, there could be some nasty macro hygiene issue without (though
probably something's broken if that does happen).

So let's not do that.

Also you'd probably want this comment above both with a newline after so it
doesn't just seem attached to mm_slot_lookup() :)

> +#define mm_slot_lookup(hashtable, mm)					       \
>  ({									       \
>  	struct mm_slot *tmp_slot, *mm_slot = NULL;			       \
>  									       \
> -	hash_for_each_possible(_hashtable, tmp_slot, hash, (unsigned long)_mm) \
> -		if (_mm == tmp_slot->mm) {				       \
> +	hash_for_each_possible(hashtable, tmp_slot, hash, (unsigned long)mm)   \
> +		if (mm == tmp_slot->mm) {				       \
>  			mm_slot = tmp_slot;				       \
>  			break;						       \
>  		}							       \
> @@ -46,10 +51,10 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
>  	mm_slot;							       \
>  })
>
> -#define mm_slot_insert(_hashtable, _mm, _mm_slot)			       \
> +#define mm_slot_insert(hashtable, mm, mm_slot)				       \
>  ({									       \
> -	_mm_slot->mm = _mm;						       \
> -	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
> +	mm_slot->mm = mm;						       \
> +	hash_add(hashtable, &mm_slot->hash, (unsigned long)mm);		       \
>  })
>
>  static inline void mm_slot_remove(struct mm_slot *slot)
> --
> 2.25.1

I think maybe we should just drop this patch altogether and stick with the
first patch only.

Cheers, Lorenzo

