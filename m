Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251D6C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303256B00A2; Mon,  7 Sep 2026 12:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4126B00A3; Mon,  7 Sep 2026 12:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A28F6B00A4; Mon,  7 Sep 2026 12:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2C1A6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:20:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84C071401C1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:20:38 +0000 (UTC)
X-FDA: 85187479356.20.1F670D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CF1594000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:20:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH3Ab38O;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798036;
	b=6H0LvsCgBzgYxr5FJ68WmXwG9msGOhVetlJG5NxnNuKUmr0WmruTd6hhqxLFGCSqE4hyKf
	b+61Ij/GpeqUD10hPNEmAbw6Mc5yk7S7hFmxrHCk+7uiP1x2uGFknqSdJJJt76eHFuI/AM
	jRZmHFfguHg1lHe5Ob8YQpfNa/i0HXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kLM4fZHDiz3Py+ARq+PlWNVvvJZV6fZYvS362NZvoY=;
	b=CoUS0W8AlXZeqMFg5unv6bU2SCHRRDDZ34rmEfE4ors0GLHELuuhroQNijB/PsWQggnMlN
	kp65Tu44yLEMuhFbu65isjh2gfF9t2rtwkOd2KG1kpQk6s3Z6eBzWCyoUn1kxLHxJfKB0J
	VcOUkadsdk7wJV8m2IL8V5NNl/rheY0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VH3Ab38O;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94588601DB;
	Mon,  7 Sep 2026 16:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046CB1F00A3D;
	Mon,  7 Sep 2026 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798035;
	bh=9kLM4fZHDiz3Py+ARq+PlWNVvvJZV6fZYvS362NZvoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VH3Ab38OqLqXSfjh8woYnu9BKgzQP+llv4PleY5ru7pSjMALkHlqOBp3pWnVdMAZY
	 cqvfNkBg7hychvUk5kh+Hyx+k/l3Cr9V35glCHklUfbtLyqZn+n3D96Gm1o/Vw8tXt
	 bycNE5LSYG7GLlxwUnKJWiLPS11qyzzEFG8SHCZhrRBhotOVDxOuCVK/Oe3Y6fT/6Z
	 CNJEDRdV/qy6aqqjZ8Kb3Esx86xXSkr+d9VglXkIwGBzSCL8Y0K+a4XUaxggLRaltA
	 UCTM5qmFfbOe0VAkK+PlZOE/ME7V/b6HSBRGElkUEfv8SRxh5trEbRsp93ptz9OIjy
	 b0aeS1FPsjkoA==
Message-ID: <9f124981-3149-4a58-a78b-290fd9fb2c87@kernel.org>
Date: Mon, 7 Sep 2026 18:20:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm: move drivers/char/mem.c to mm/char-mem.c
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-1-a578c730cec7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-map-private-dev-zero-v1-1-a578c730cec7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF1594000B
X-Stat-Signature: 4fgnyxu1tkodrg5ggfqg5cct8una1kmh
X-HE-Tag: 1788798036-184540
X-HE-Meta: U2FsdGVkX18RUmHMovme6AL/jc+kqoz87THEi5sAxIyIRR73s8e0H442/wJIYHR5cACSh4v3HZ8up3/ofM/wS0kkNfzzmSN5SUxgnZYZ71JF4tejOcakRTH8wy04MdACFYm1wP/cHevci+cwhR/cAuTB13sbAxmtZVpV86znjbNEk9Jozhoopif25/MqYJ1jx6HTeEjQ6wrQ5uqkcryVtRLsrKu7uA1lZWdFw4DM+ABm7+8zsUOouYXmmFwJEqzGY1wGgRlQO7ZNGN7r7anRiEYRhkqaBLtjyGTTjdk3nbEZaikmP6Wt6JzYEmDyawur4DSV/k/tRkke52kwGM8kwXfZ4n16KrTZP06HdJeck3MIRLJrLB6csXQRTWZhOUh/08+7jBG6ReDbxfm/0X6gqpSE5M+hMLcg32ZOCu3ArqKskM21HX3SJVu9wj2cvdTppbLaR3J3u30WZ3xxkpT8mp+RJy7RPeiCzMDM/B70bZxtCfv3/tCSDtQ/ymeXD8pA6/FMLIdkcfo/TBs0Qs3ZNHQgZ+hPOwC+JOdZWTacOUBqs37gHjxscc044xEQXyqG8EMG1bnsex5cfNALZ/EdhhY99zg5xnsfo+T+7cDpjsYP+oNDzLJ+h0Fu26EX5VoffgslZgUmZoXf7TWbrrqXv+NzhclT1Ib4JoJz5aCuN7nhh0hQWIDGEb4ACeSPgy1VmgdqGeNKpn0Q7WX1XauKzcmUwiaQXy+s8dpypzX78kjIuSuT/MgY1wYWwjO+rm/P4aeaXRFQOWZgodxXHpY/aXsuerMU/yxc3gllNr0OTVqhQfxONbalHEgzP0UaFFM+0CK9eCPKMg1GXDcQ5EJGNHCLJG3lq0G0dbYXcK/4So01aZ4u39l77kE/Eg860oo1/89s90M/GYueYtRzHWzA3/nsccl1GCH42mUxjTt9rnov8z7nTs4T3JKHxbVG6lQ7YbMxDpnJOZDaJjhlWE+
 67mjasPL
 StrHS+zTRwfW905jGXAiKZur8NIa9mMLLGeoBcmettH16fyqr+pkidNrQ4hDUndVl5YWnP8UGAf3qO/9s0oYDCONMGHlyNtYh4Kp0NSLgJLHQ3K4NhKKah1Y5duEpb/ceoAHn/yR/CUOnUALj89z64Sk++8bAMthuIDCPu1ufNrRTYF56x2vkUKYykjid4+GYDVYSN5vIvwoYML7yftSt1W16oxwfG65/dp5Xsil9BgIgoZdaIdqtdqumpTWsNIYVgkpsBxkrifbr+v14IGmSy5c6alHvZpPEOxV9spye5Oxw3WWQmv62Za1tUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> The memory character driver implements several mm-specific features and is
> always compiled into the kernel, so move it to mm/ where it belongs.
> 
> Among other things the driver implements /dev/mem which provides raw access
> to physical memory, and /dev/zero which either allows mapping of a shmem
> region (if mapped with MAP_SHARED) or, uniquely, anonymous memory (if
> mapped MAP_PRIVATE).
> 
> This change lays the foundations to allow MAP_PRIVATE-/dev/zero to be
> mapped precisely the same as anonymous memory is mapped as currently it is
> an edge case within mm.
> 
> Also update a couple of comments that reference 'drivers/char/mem.c' to
> reference 'mm/char-mem.c'.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Yes, that's the way to go

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

