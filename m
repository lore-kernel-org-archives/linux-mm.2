Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C631C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 19:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97116B0088; Sun,  6 Sep 2026 15:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FF46B008A; Sun,  6 Sep 2026 15:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55EE6B008C; Sun,  6 Sep 2026 15:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 878DF6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 15:05:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1773914056B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:05:08 +0000 (UTC)
X-FDA: 85184265096.08.C076014
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7D57614000C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:05:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+KNoyQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788721506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKp3qCBZSkqY8pXJev2cRbeRm+iBrgscyKsMOZzA12Q=;
	b=MhEzW6b+iWRrsYLR2vH20iWKUXFa+4zyzqfc3kXWD105lYBRLXoqIRkcisdiiX3h4R9TKr
	yB3aDYywdHpAQ+e0CFAdmyXkDyvvHW7b9MJBQUZZOI1PDyheJseamO75WiI1yMlhB45reb
	iBO0zHcUar6dXInLq+IgilnxeM5K08I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+KNoyQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788721506;
	b=Ekjq4UQgyKGzMWFWgPhm/lWRJpFzHUEizvv+ZeKVP7k/18rPLhw3qkdg5hkmH4mXJsK7Zt
	RehQZU3oA2Tv6A6JQO0/XQ3ed8v+4EdTAH9UvnavJDc+vNHRJJK1hX6nu8/SfqO05axiSN
	pL3D0Tg55yDt+3I0csEosrniSRBOF18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84FB6601DE;
	Sun,  6 Sep 2026 19:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DE61F00A3A;
	Sun,  6 Sep 2026 19:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788721504;
	bh=HKp3qCBZSkqY8pXJev2cRbeRm+iBrgscyKsMOZzA12Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U+KNoyQBtkppQi9T9PyNlYHsgnWIP7ZtHskFM/Mu08J4KHZKizoeKU2ituucivcE+
	 oiiGmw2BIfmqe6h2JInCY/0umyDidzoWhlajD2+RYLmsspBY84qp+XdAgoI1JC6ObQ
	 48rdg3INsHMNlE/Sl417+5kUtS+AZ5yVOJ9m5HvklzByzG8tOdX4bgQ2ax2qnGuSZF
	 4S4labuLpfFKoFEcotWGxxb+VfWq6U3V108vRd2Cno3D6OExIjJy/qT97rZAhRlKnr
	 BjobNyHPOzR2/Emiz0kG5xJ8xPetEDk5DtG/KArNWQ+W0Kr+6J732rFeV/Bchl+F+2
	 anWWQBi+m0TNg==
Date: Sun, 6 Sep 2026 22:04:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/secretmem: Fix the enable parameter description
Message-ID: <ap25Wj-kt2nsMn59@kernel.org>
References: <20260906171523.3009-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906171523.3009-1-kmehltretter@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 63g4cfpbr3wi19ipejtzknt6noqdaorm
X-Rspamd-Queue-Id: 7D57614000C
X-HE-Tag: 1788721506-336511
X-HE-Meta: U2FsdGVkX1/638TOgjPLh1ciHI/QOia3W2w1wbJkjZN975UzYO8tg00Bq606YW7jkHfMcEXByGrQUGVQxgiTHDwN+fNbrxVhQCNqiOcXPqQfYDpIau4bRmIzmPSCt7A4lYSIC/4BNyOtLhIyOk2xexZHIqWBpLba4XiuwSqW1zxUhhQ8Nhry0j9Lf0LiefUPq5j1VM+z4YNYzdaWFCYDAxIZ6Rn3QRegLHW1MrO991kwFGUw/DlJur+QEznFBpIX79HQWs94ctKQ8HSS0B+3ja97J+soU+PQqLtEr7SHjvPRGHJVkyG3GQozZ/uTc+m3lZElOss5YasaZ64n+iD9vMzGdSiFioROgFRoeR/S7tsV/7PC0G8AKtVZ8oi8dnPz09DQ03pgfyH80PJKoUL2rrFkNwGDikAUiJoVPmgZWB2mdJMtZdUZUoi1XB0MfGn6AuDm6HOaTbvXSpYenNyFuT4i1Lfqbygpu6j4FeiXeTebTHqr8cq56GeMB/bwN7/2G6MeXW4aOaW9TFN9njKpUDqIcghm4kURNXaCdBe3ddcPWsI7hEF3C9voS8ArJQYPKEwd/6ClYWLr67RVoWhY8/SZh2rLnidRfX0eSGYtz+VdfyxkLFDZ/KVp+YHvLyW/frQlfQNN5bJUE+dxcyQSB4vR72fV8On1K+jk0ic0rVL5U1iNN9nawK8FxLvKj4oVLvpeBpeMMyc6aBXQuXYA2Zi9DIBxByD00pT5N+ghO/gDskMdL6FPqL7AbC5GKQnkTQcSsTlzNY0lRSTwCaaUNmr5zXFYSWO+n27ygwZacdEZLYDDjtl/DySu2ZrlngvE/3rq5JzBcrfAno/OJkUTL0tqF5agE2zB+OrMYEmEIfhtxjbqwRrmmoe7l9uI363o5FD5JYTztny8rTk4TOApzaIbcx+FMXztDCi4MJ9hsgeK4Jc5MKdWtZF0Cg5S2Sly8EZNgSidRsN0Xqps1pp
 qDOojbuW
 tkEylTdHXES5qUXHr/wjWmmqmKpLORR6a4YuQ5p/ijpKGS99HQhcYZG+BLYUNJwJ8+y+SuECW9BlkDmurEeUsutXKmGptay+nAe9GtaV6QzjQPMvN1kB8yotE8QWN7ZqB6yqifHbUUTRcljJG0yUx/iBPkO4xlDdlgAqmTNm6NltAGQ7HLNWKQTiegBQchg/0RSS7VOajFVsniXPaumTYFc+zpKaPxUG3Wl00Kx5e/Q0onEuT/FDB9kdVx1nN29jPS+nBliEfCg250t8GcO9xZTj18rWLaVnoveKk9+ZnwljtkVLZ/dafWD1YnnD7/+Z+Hy2B3GmES/KKoGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 07:15:23PM +0200, Karl Mehltretter wrote:
> The module parameter is enable, but its MODULE_PARM_DESC() names the
> variable behind it, secretmem_enable, so modinfo describes a parameter
> that does not exist and shows no description for the real one.

Hmm, does modinfo show secretmem description at all?
 
> Use the parameter name in the description.
> 
> Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
> Assisted-by: LLM

Please use the form described in 

https://docs.kernel.org/process/coding-assistants.html#attribution

> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/secretmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 384f5cfc457f..4e32bf55a599 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -39,7 +39,7 @@
>  
>  static bool secretmem_enable __ro_after_init = 1;
>  module_param_named(enable, secretmem_enable, bool, 0400);
> -MODULE_PARM_DESC(secretmem_enable,
> +MODULE_PARM_DESC(enable,
>  		 "Enable secretmem and memfd_secret(2) system call");
>  
>  static atomic_t secretmem_users;
> 
> base-commit: 986c24e0fe44f844b44d365b71ce831947f50298
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

