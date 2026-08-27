Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4162DC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438806B0092; Thu, 27 Aug 2026 08:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8B96B0095; Thu, 27 Aug 2026 08:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFB06B0096; Thu, 27 Aug 2026 08:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09FC96B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:58:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9347880429
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:58:13 +0000 (UTC)
X-FDA: 85147052466.06.5560ED6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C353F20003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:58:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkuouyXQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787835491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icq6GR557utcRKY4Hi7zrkMy9lh0jxIEUolMYULeb1Q=;
	b=DpjZHoyzFLiKzZPRSE2VMrgag4g8PJ5ulY+T2Nk55Pi+mKtRbcw5EItr578GHXPS4+3dju
	nSFH3k9inft97TE577dt92URrpWqgJm8/aiajCsQB1DhDVpqME4Eu4Fw/WPZ4t/DzePc5r
	Y7D6GSHdVRaxH/+sViVGUIwTBXwUiH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkuouyXQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787835491;
	b=C5Q8GmwNYSqH7wzze7TdSjl9oN7FWpyBxc6x8gc5NYdopamsG3uPGOz+be6uZutywGyJ34
	BcPb6xD0CQtKBlTanVxyql4qz7jXHrTxYMuyXbALdit1liJyQxvb/2fE0zWinseQlqHbxQ
	S59SwNAQrLM/UdT8z91xwscUvgxDKaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9A0143F26;
	Thu, 27 Aug 2026 12:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579BF1F00A3A;
	Thu, 27 Aug 2026 12:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787835490;
	bh=icq6GR557utcRKY4Hi7zrkMy9lh0jxIEUolMYULeb1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AkuouyXQkkDp1E2RCTvAtuPn/YhjmLgeNsfo4VAbqzhI/dklvnL/dkP91tKPaE/0A
	 4nyuQ9TWhZKVRt32XdT9CLzWhk/BwYx6Xanh03KopldvldMthoFlVs4CkX3YMPbsJo
	 NhS5rATU92F5SUC5e4rfImpj1v7MzFAFfqoSK7S77e0oTiSTHWT1mNen3aadaUN/oq
	 2EZjWD727ELB6f4S8HdnTK3SBOxKUS7bOdTgA4gP9PpOn4dULIHsV3BvKqZN5adh6D
	 3e+KlM+yah6Jf0CK8g8VH0sMRWsPVIoh/vWzu/44kPckq1aVtvGsMHSWvUMusc7leK
	 XcaVaYmPsVPfA==
Message-ID: <982eedc6-c99e-46e0-92ca-450d0f4a65ac@kernel.org>
Date: Thu, 27 Aug 2026 14:58:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove unused anon_vma_trylock_write()
To: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260827071845.17636-1-hao.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260827071845.17636-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pd4b8zpzn5usi9snh8hbifrcunjhmtwy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C353F20003
X-Rspam-User: 
X-HE-Tag: 1787835491-345546
X-HE-Meta: U2FsdGVkX1+8YCZGAo+aTtglrUobnt91HFBTNJXANMa4J0caAyr9+b2VkpWgYmom0qIEhoaHI0ImcKu1uFAttz10TKEK2gJm6BLGffAdbtoYao8pTFTa5hEIUqmbWN9qLZSAmxbAb5ok6198zVtWEZC+7k+GdYAO4qPNPCyHP2AZALs4eoVv97EJArST+9X0RZwwsnQSaB26+rjy882WHCLG3+dgcNmlW86Yc0ogj+AtxXfgl2sqPQg+5C0W2iTsR869X+y+tfJfaN0AIiMZQ8oVPdLLDFlHqPqlJnYEgg8h9P5snFt8Ripv4vr4AjoLr2SNAko8dqcOxA9tnW0XrU1m5W36BZ64TUb0ljjkp4tne6wgosSQDLShFF2JpCQzuuTdD0OYK2xZsNiRrgThPB4WSWUb/+WKsCtTYRplbn6yqhlJJNElfAotSRYPeLMvdDU3cyR0ZYBuiOGZz1AMefihGWK8gP3N1c1YyuOVtcF1FtI2T1lgRI4gj+6hYfoe0sUOhxeorf7xakhVhv4RExKZPtkxKKXWse7kkLXwv5s1g2vUUxCYoEJZFelLizBV3e7vXI3eFJN59pIC9wfkzvbyM2u9vi/mtTqjD3bgdIESjYtzT2CLEcPpLr7WqZzPXq+xPfETI8YL1Mofr9sQfJCkJTQE4f419Vjg9f9K2uSb94eM9XrmWxFTPRlSpQ5F7nPAttLLujqHCEtPFLYqieCDh27bIlqBngLGimoA82/uZpoCdJPpHrlDgI27N2IZb8acT7fnBQJXbT7g+C/uGIpLKy6XXlIgEYJ9c/bGMpZotlqMjuJgb5asob2CtAZggZXXL8zmvHRWMxm6ta04QUrUad/E+h37V+1Fo6lg0IMHDLsbdoAVC07NPw9wALbgun3bvtQjEdSDjovwmgpSpMmIZW2MQilShzQ/lIioKG/DC171Va8Ght649mBY7hSrdSLEiHiR2dqra+geDXh
 GKq6xxaz
 b8b5vhxNcGCaCHqbTslJn84pjtStjBn4kma637522MrgDUF/ohVDqps/36KdtoWmNUfY1l782VIkxvyMl0AXuvFRBxYjkeX4GKtla8W6kguJ92OQHzawm52/XivESf+JwwkHVrvRMH8EaIIseBaU8ty5Ojtx+I65bpbpgEZVkLXGt9Y3zIHbAQUjWn1Bjzh4s+UvINeyYkHWVJ/UWvQfNxaA2ukaqHvItQwNpbZMCs77SCoXZKNjEW/kzczhAkyFbGQzR60dyevxT+2PgISpGBEqQ1XCNPboWNH2K3f9ASZtv0O2AUfPBsYu584EXzWcAkVJRcgLIRUkS95zuf3AVgWyxosba6AS//PWmReEw1hLWgv7Bhq1cXhqYd7qy8GbqgSpMY7GKko4tKeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 09:18, Hao Li wrote:
> The last user of anon_vma_trylock_write() was removed by cc22b9978509,
> leaving the helper unused. Remove it.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

