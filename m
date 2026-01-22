Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB038C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 08:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8A86B0112; Thu, 22 Jan 2026 03:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1686B0113; Thu, 22 Jan 2026 03:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF52B6B0114; Thu, 22 Jan 2026 03:32:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEE6E6B0112
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:32:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81C26B692D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:32:47 +0000 (UTC)
X-FDA: 84358933974.18.7E79CDE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id DDB4E100007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:32:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyOHD67W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF8bn8e1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jd36sMSt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Jwk37qx;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769070765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aOmUmdAgwAgA81uoRZYrgnrXyhYcc/zOlOcDMoVAz8=;
	b=UBR78Vu/pHaiPaow9kfllNuE9NFCo9scqVxAjI2FL3OF4IaXvpW4MPNg3UJhoGP4JeuV/d
	El6nL0uoWIaxnuQGqa3UIEifYfLWAxVmyEHe9bCGsbXJPKxu6zsH/134F7r32dG2oWJWgZ
	pJGIFnhU/h/rCYgGnG9mxAYtVInaWH8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CyOHD67W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vF8bn8e1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jd36sMSt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9Jwk37qx;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769070765; a=rsa-sha256;
	cv=none;
	b=sw4lqEPSJiK0lgKzF9IFIS7nKjz39lvmeXS6S10eSZ27WpnfVBaNGppgWY7QEEbc7ivK5b
	NZmJwKwuSE95AAydvRNEUpv1oj8OZzkb78poRngGmF3CMKjAkY/rI7BSHVQJXWsmQJ1Vcw
	/B1dY80JYI4vrAe+OzWoMYpkHYu809I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E9126336AE;
	Thu, 22 Jan 2026 08:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769070763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0aOmUmdAgwAgA81uoRZYrgnrXyhYcc/zOlOcDMoVAz8=;
	b=CyOHD67WOgxxhwxs9wUWMufZdLYjY5wfGu2utrAxoN9E4dGiX3FfaDJjf20rn2IzoudVBY
	7NOqqUJLKGrvBEtm3KWFFVkiNsNm3wvht3MUr1ODsEg0KBR6PvMFba9jo5hffkXsoPl1rG
	BnlzYPy8A330oi+32pZRNulAsJq9AtI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769070763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0aOmUmdAgwAgA81uoRZYrgnrXyhYcc/zOlOcDMoVAz8=;
	b=vF8bn8e1pbOzUIJ+ghZ6iRRNZOzroHL66EqPkNVYvS5qE5OFwwn7g07FmOnC9MLZ4I3XrL
	fM189b3zWyDAn+BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769070762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0aOmUmdAgwAgA81uoRZYrgnrXyhYcc/zOlOcDMoVAz8=;
	b=jd36sMStWaYrKXoUCSPdR0AfhzdGrbdk556t0F1tavZ5KxmyqYYwbi6m+CXOYnveXxM+KN
	RoQI398eFm/THdd2HzIIveIZVQGl/AhqnjOgDd4VKuuLzBX319DJ6hK2dMBYHgykMrH9xW
	4YWSSacJnKkeBMzZ82FBE8XsqwHjC5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769070762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0aOmUmdAgwAgA81uoRZYrgnrXyhYcc/zOlOcDMoVAz8=;
	b=9Jwk37qx3lfbSGnOl/G3QxmjEfxUM7i1Plr4WZtcU9BuFqg+UXc/eF057LXbX0X024bFYc
	50aAPzrjgXKjdMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA1193EA63;
	Thu, 22 Jan 2026 08:32:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CcwWLargcWm/aQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 08:32:42 +0000
Message-ID: <317f1725-5fc8-41bf-95cd-4f85dd1eb137@suse.cz>
Date: Thu, 22 Jan 2026 09:32:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/21] slab: refill sheaves from all nodes
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
 <gmpxnzifhxamwnngr6holbcfdd42fvuq2xtqrqvdz75zv6fb57@hxbmcgfxtuko>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <gmpxnzifhxamwnngr6holbcfdd42fvuq2xtqrqvdz75zv6fb57@hxbmcgfxtuko>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DDB4E100007
X-Stat-Signature: w4c1moftf93n1qhx4ion1shcrhy13utp
X-Rspam-User: 
X-HE-Tag: 1769070764-602920
X-HE-Meta: U2FsdGVkX1/goyCMS7vYsvTJGtv90d5PRvz9zrm6r8j5MZk40PlUfqRRXhaOhgh72BSFPN4wpdMTXWByocqMoptuBu+CbB1efoKhkjvDgkUyANK/qT3fvCjf6iIh7IAPLdrOas/OMarLiGMy0ODppUPMcLGwMMBfDpo2YqJNvcsBmwnUvu0GX59sOtgPMrFeiFmk6++1cCYwi3IoZRfz1Y5VHrquSArzVL76RQ38J84OwYxxRbkvC4fFZKCYn3Lz2fOi7UoxDc4EQmoBra9YmVpSFqcJl4g/HYQrTDM/v/AbbM7ZzlSk7jio/Pi9R0yVm27eGPhSLsCOCw9uB0jxlG2yAse1M5HZgxuP/JYBOMcEaF9oVBx6+KDOob7vMb9CgLQeHR/tKsABisIhNVXkCRUiE0KnVj2XKwCZSLeavFKzu35WLuAtMIOJoNa/CWIMm4ItxAhS5GpAY4T7RvaeLXEMJK1d+7wSvtnOnnXMtgREjmpIR5kdB4kx5+0TQmbXtdEnGqq9IzxNstcWbw61peoH7uMh8+NHB8/4E/1pEipgmV9nu17/295By9Vbere8kWAHjsLwl7XKSgaALRFo+KIDYvvi+yQlq3NhkbZLyuaOu0V9vG7fBOxCL0pMw+CI4h8TTyfl1Di53EeCgROOYdijTDfvjkuN70IjSFlhezUIXF4jDIxhuIiQ1UhIt/OrO87ZhtY6AKC+85EXO/sgf5vkV5PzIEv1/YEAcFuei9K07e4BBrWAk3EMD2Sjapf/RX7Fc8m/0ogbzyQ+ZQjVi5+kfd9JHJd41fvXizgBqYw2l0oC8GyHjHdMH9AosfO3EmUWjCPfhagnF81oMKhRo+xN5tBi5CDfXqTOAg1UezeewUo0a02CkMaI7TJmoRBboMVH7mW1kl9oU5ed5aNIqUlHfCbLEZ4auCjYMdqjDCRZTSDLHa+vYP0e/mU8sbnBEAQoXVBLnM7xI2VY+An
 HYrbhrcK
 q195MbB1mBhhj4KQcWOY2md9tORoJwtcaaqCWwkLZyjHYmIblkwA4qUDWWQ+CMkO2QR4FYMItMgyl3SCNf4YTe+Hy/OIwfp11P9czyhF4EGye++wzfE5x7E7FbMwZ2+muFK5woJZEhnGxNwKOuhzf214ha9V2axq+BzpN5HN0x9FXnS4lXM1caLoT8L12SgLVffKJSva/eag5INW5FY4yrN5QnOM0Z4XARPGHg0bWuY6OncOf0JXSVotBQT4l0W7ANsWr7jUeQkLN6uDDsa6hXSCw9/MJpo4l+Q29
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 05:58, Hao Li wrote:
> Just a small note: I noticed that the local_node variable is unused. It seems
> the intention was to skip local_node in __refill_objects_any(), since it had
> already been attempted in __refill_objects_node().

Ah, I'll remove it. Such skip wouldn't likely do much.

> Everything else looks good.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!

