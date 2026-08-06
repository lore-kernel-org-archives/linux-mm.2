Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A46C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE0C6B0088; Thu,  6 Aug 2026 10:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FD66B008A; Thu,  6 Aug 2026 10:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E516B0095; Thu,  6 Aug 2026 10:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 797176B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:21:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D3344072C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:21:02 +0000 (UTC)
X-FDA: 85071056364.23.74FF243
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id DD2E0A000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:20:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2qalWSES;
	spf=pass (imf15.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786026060;
	b=SbfDBHd/wuL5FEG6wV1ou2nTHNRNAfkIvVBjSbFdZ7+rz7ac1GG4T3DbRA76SqaJFQkYDO
	3m4XFQN0hSOFsxnHKrhOQYP4wCkff5AfUc9aw9IuJF7BDuFhNkg88RjjjxetANKynkhtYY
	LyvuSoz5qf9VEy3UlHLfgHhJzPN+KMc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2qalWSES;
	spf=pass (imf15.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786026060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fca0tIgG3oEdos4L1qd3KNaXkbIGJZeAdl00nCfOtDk=;
	b=HK7Ej3ToO5m1VUOCPzy/H2oQzhGnL3sh3hPydn00bsWOzm4OMOnqgMUghvoifUMPsNE6j2
	mn8CLIgmsQdplfH3ViVGNdL2uji/dqJyf8aYtJaEMvyqjh0R7l0BRiqj/WBZuoiiJA/fim
	jXQwdwYKc0U0rB9qv3kZZ7uMKAByTvg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fca0tIgG3oEdos4L1qd3KNaXkbIGJZeAdl00nCfOtDk=; b=2qalWSESP6SRJiLjdPv3IonXnZ
	SxdL/qoEeAJMN3ceNUpCMqY7kCU0ktGfsh1KB3cT+dxox25nGGxPl25LNz5OZ+5ntI+lN4kBCbLzl
	RVpc/uiFvMDRU11RpEj6jTQu7fK8D2nJpGs+VByWd81Mnq85UkGZdbd5rS9wMOM8C+1FlKt2mOvlA
	KmtMC1a2XqsEzkez+6GokBXE5ItkwgVb2e4XikvR7zff2lxHy8DHWR4t0TA8iieh+SiBJNIv/zZ0i
	9vabymasg4HSFV+3W1HuTWEzQyYub5lpOriT0ft7XSCPcJALDN7D4WJfwFAr7OVa2N90sNKZMOPFP
	XjBqlmbg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wryxr-00000005yUi-2QtR;
	Thu, 06 Aug 2026 14:20:55 +0000
Date: Thu, 6 Aug 2026 10:20:52 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] maple_tree: Remove unused mas_is_root_limits()
Message-ID: <khwyvdhbmc5fbkzwli2tpv3ujr7tnfdfh327bbebpnlmhc5loe@ygwbnqptpqdt>
References: <20260805070529.4118794-1-zhanxusheng@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805070529.4118794-1-zhanxusheng@xiaomi.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD2E0A000A
X-Stat-Signature: xpkj8jk4g3uht58dbxr7jce6zcyaqboi
X-Rspam-User: 
X-HE-Tag: 1786026057-281419
X-HE-Meta: U2FsdGVkX19zaXijXGj4aDAyV8MNPKqBvd35Rf17lT7iAqdOZl8LAalmD37Kjbd8XUBQT976Q5Gfo2m8PFlD5lXEH16qQCKK7rqACAW64+xCNRkBXgnbW2giCMwrMHTM/6h3QnaF3igzMhp4n7gioEeaJfkWQoHlfrmLHVSbR2aN63zdavpRo7LHPk8PpKXfx8bkEHPVzdTfuOnnDSEZ3XckTXhSk7+dOxgsJawSj4Zi92H89ZA1A2n3BoI6Vb5OruzECkURERnuDak30CJW7poiKUFe7XrsKzgxoXNesxV4CABNaS90IGn1B/DcYYepatPypBQbJul4y0j3hXwK3liB3dAfBp4WWnOBGEzTkGc+vl/E+o7sKrv40W3XxUoPw1QF1qLN5suAdEyLIMFFr2/Fy9GUZYU7TIxBNwWzi9U8mj5i2t/ji3QOsWCd64zEBh8lOD8a3TdPX2kNv83pGi1Bh6c/jcdu7pK9JNYQeBlojjsnuBlVhsdoRrhuP7PKAzJw9XmwJwHHbQt7I1z6UF59gZvKakcjrDrnc5L2Oa2mGYkYRGl411bf233AouZVoNYGnGdB7YGmIH77+myMgHWwsehZ2qggNpuK7L8S4IOdrk/itm8xm+mCNmFMFlDL/HUL9tEx+ZV17Yo2V7jUeSn3GnbOadZ864NtULMv7aTB7DAFZoAVXW716t7KrLfNSZaigNDyrgMFW/qK/3yUcrNcgjblKwh+2dn5lCaU2GzunmKo6RoVumAdwLpIFr3LvpNeUjytg/sg7yUvUXh+ZlMN9GnZ1udYeTJlZJrnvh8CysLy+0PDX+4i8To5grWeNxViXH+SiMaIUblNxQJce6VFPV/8DIBRXCZQdtWJ7ce5dGC9nLB7YFI5HaaXkzRsdZHCvcq3GUK88kowjblwM1OPckJXvB6o7j7a0rGfvm26t6YW6v+LIPswu1FFTpkppeTJU+fWQcAlQjqBeKr
 T33+tuU9
 uzFWnEy5opTkQX5ahq15NLaS0R877dtZsxgnu+5tRHUfTvFC7OWtBP7Od0C4hUEyTVuptUcCn6gJciLkluFSz/Yi8AXGXIuEnDyeYU4i50idVzLFdc5/wuZQM+wwwXcf0jTgfv5g9aPKr7dCOlMuuxi3WmBzWZZaE/Te4vUziU6911UNX5/j/3qG5umT6kId7/e1iRz9nhmC98n46u4cBw33BEd97nUiEOvanFLxhb9F/QAiHolJTKDz2JHB2LUrSOnazwbpGYfBrkADNYViwq3PvzyXJXA2cgBbo0C8moNIaKcRFvGCmmy/q5Q7nrsRvepFxdXyhL1CkhBw2TRVcSCXVwy4LBEWwIbY4hmua7TIjMcEC40nUDJldG8ABVrtsE1r4+EoPEE5HICKT8slvvl//aPiRZgxo+Von
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/05 03:05PM, Zhan Xusheng wrote:
> The last callers of mas_is_root_limits() were removed by commit
> b8852ef30c67 ("maple_tree: remove maple big node and subtree structs"),
> together with the maple subtree state (mast_*) code that used it. As a
> static inline it does not trigger -Wunused-function, so it went
> unnoticed.
> 
> Remove it. No functional change.
> 
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

Thanks.

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  lib/maple_tree.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index e52876435b77..1bed455bdb9b 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -356,11 +356,6 @@ static __always_inline bool mte_is_root(const struct maple_enode *node)
>  	return ma_is_root(mte_to_node(node));
>  }
>  
> -static inline bool mas_is_root_limits(const struct ma_state *mas)
> -{
> -	return !mas->min && mas->max == ULONG_MAX;
> -}
> -
>  static __always_inline bool mt_is_alloc(struct maple_tree *mt)
>  {
>  	return (mt->ma_flags & MT_FLAGS_ALLOC_RANGE);
> -- 
> 2.43.0
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

