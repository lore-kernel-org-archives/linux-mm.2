Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE2BCC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E8D6B0088; Thu, 15 Oct 2026 05:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042BA6B008A; Thu, 15 Oct 2026 05:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72BF6B008C; Thu, 15 Oct 2026 05:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAA886B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:35:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33063120938
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:35:15 +0000 (UTC)
X-FDA: 85324352190.04.A68F028
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71B89100009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:35:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNXCdGfN;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792056913;
	b=mq3fIncIxQn+mjaz04xlPX5RrltwXbXSJC4TwpBtCscVFONhHXRMkBtjnmER8cySdI3KUS
	s9AXvJfrAW271o0TKxlTzn8gait9rcjTCPpVuYB0LcQ4M8Do8oSPxfeI2yW5uhgzEEq983
	DZWfn48N0YNN/xpmb5Hl8QZn0kg5iOs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNXCdGfN;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792056913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wd89IB6F35+VrD13HO5qIH7pRsIPbB4O8y5yfSMQE9g=;
	b=cX08PgXgC+kSeGXATNoYRDSsKA4GvTqYXuPdn8PZaNXJbYwn6bSxWjlzjwU8q+yektLjNy
	orQv/4NgFdofdqk7l1w0uS1VN4PDG8BbPhaMlYZZsMQz+pcFInzJcJliv6Dlu8+dxYAHYu
	ZsvbhGQbdNieihs55QjuX7PRmHMxhVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7A126020C;
	Thu, 15 Oct 2026 09:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EFF1F000C4;
	Thu, 15 Oct 2026 09:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792056912;
	bh=wd89IB6F35+VrD13HO5qIH7pRsIPbB4O8y5yfSMQE9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KNXCdGfNYckgMfgIYEdWmk9/QXs4UpBJDycdgK6witGS0/JGTw0WV/VcMnL0xRZDU
	 YeJ15zxkR+pKadSfoBUOsdrTjGG5R2EVykZBcqMnntHursaW5mzLZ1R7b2x7A76l0O
	 Fcj+ez7e+VppWxXr1tWbMl1x9htrAcmk65OfY9NdsstkkOfNTy5IY4UEzbFvW9TP21
	 ukb4e/hgurPg4iiTOniwJ8HY6apoN6ep6kTvHslQX3K25i/tdBKNYJTF2VE8jltE6I
	 ktz+XbNRRv2deMYEc96fv9A0e5+5r+AneZTEESAzZO7nd3BL3kw2qQOa27/qAXgUuk
	 iPPaBbP7YCmHA==
Message-ID: <8d570d0a-e65c-43e9-9266-175e883f8766@kernel.org>
Date: Thu, 15 Oct 2026 11:35:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Sashiko change proposal
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com,
 akpm@linux-foundation.org, chriscli@google.com, hannes@cmpxchg.org,
 harry@kernel.org, jack@suse.cz, liam@infradead.org, muchun.song@linux.dev,
 shakeelb@meta.com, sj@kernel.org, ziy@nvidia.com,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3gku7uqb8i3s1snfsozjyys77fd7w9nc
X-Rspamd-Queue-Id: 71B89100009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792056913-27959
X-HE-Meta: U2FsdGVkX1+UYILqWUluAD3A4Q23wf7FXx/8bBeuphbHbb/j/hvr0Vsbp3GqHHfKk05qiKpvUNJDOTuplmrbzJBUvrqtsKlqdp2zCZs6g6MKjGIJXoD2aLYF2dZ5WhmC6SvNaQNxLU41GENeYlLOfn6q0PY5MEYZaAMQ0/yZ/PJemri/VXRH7g8V1r9lWnGgbHKPRen1+OL5q0OQR7S2indLhC2a02egMY2RgaCXByoONKKSG8l9vvDWIzQvu/NhXY8zcVuIIDB5kXII9jHZD3RhmgxA/ppQACS8RwQXL55Vdq/O+oh9DfR/BKHcC4ZOj5vTDU0lrxyWZLfN3wn6q/wmaYvZH/oGhQUBTqnKq0ikwG67YE0QLY8WLoGHQxdOyJ8gEAiwuMex1xfKUOYF/+UuIzJRroErJYWmqEXLIeseHB3BNWUU5+7QHQTLEM25QwSBtx3svweq4DBgyDnsUxI622zXqSiCrwN6WEq/fl37/qs981Cbimykv6MUOOEQlEa8zdiaj1D43xqjoYnciVimfamvY20XO1mmIdjysm7vZuSmjvAefbYyaAqCfAv0xKze8Y2Hrbwc940DDdd8C1JaBgT9Uhnrmesx8XCUcJpDt5qhVwAOVZVYz6yXKtCErzjp3Sb3D8e+OzloU9SECysigFf01I3m/ckoz5h9zng0sZ/L5elGNYHpHtE/UPROpgt5CF5xVImFqpZhr+Jw2jsu/bRKnuqUDroNXyKbOfTJOEKRK+ftoiHCyOHMyDSUqabkTwo1WkJWhwIK+Hlk5k3IdZlcaNoAmXGkZQGW3iADrU80vF4c/GVwn5AT4zNCqHtav06FO4FXJJT1LBBhLNaAxgE54ks7fPxmGbrA9DyOSaATK5XqOmoyZS1rGaVZGzF7yybYv7WPGKypsZNq8kmO8ZV06aGcO9q2mD9Q95+Gc6clRXfH+KaPpihInqthr0Kg0Gr5I5NhgD8kWI2
 f5xYxswH
 vR6sH9pjeIJSATTwcFnQMmkJaskodAzM8T0x3N9FjWLpcv9nLiIaaayFyS8Z1/ChyoaW5AtxaORYfkOsLiodyEoSpL0YSB14EVf1cdobV8I+GUc2Pz5Q/xFLyZUONdF0RZ9CGKZ6iDelxzhIKj9wmu8D1YP4rin09gzxjVO/62Iney0Du6Y1eSKDvDNVB+MaFBRSQZ+GmoSkr2BJ2LjlDGZ6dXtQkwuaASQeOf25rvDWdo5BE1A2QdlcMKovag5NCfbURu5aFEna7mFDoBGc3mm9KD/HOTVv3GPpa3t35hEhskCVqCMqatx4rE4G94ltdZzSUwk7tzUjc2li1TCKSjYdvcbMA98wFRNS29DwnoVl+R1Y7q7nxva2te7FyjuHg/eA6Afe2EKR4Y2BzgBuPeFscATYseoZlTaUU20xE6bvll1fDUHOBegSA3T2fvMSyI/aaAjVLbT1I2TlffY4MrwdtxcxmlBqS8y8l7KxNasPYSFYh5Jmt8Eplpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/26 10:38, David Hildenbrand (Arm) wrote:
> (CCing all people attending the mm-next call)
> 
> Hi,
> 
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
> 
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.
> 
> I suggest the following sashiko change for linux-mm:
> 
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
> 
>  ["fsverity@lists.linux.dev"]
>  reply_to = ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to = ["author", "list", "recipients"]
> +embargo_hours = 24
> 
> 
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
> 
> I'd say we start with 24h and see how it goes.
> 
> Thoughts?

LGTM!


