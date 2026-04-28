Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697BAFF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8F66B0005; Tue, 28 Apr 2026 15:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A4B6B008A; Tue, 28 Apr 2026 15:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770266B008C; Tue, 28 Apr 2026 15:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69A006B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:43:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07D461A03FF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:43:25 +0000 (UTC)
X-FDA: 84708988770.14.14F88CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5362D100007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:43:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2BplrKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777405403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1SIam/UzUzWzReV8qPmdwwBPQt4Mh8U1tg/RPmWvik=;
	b=yUF0EF1+3uj8v1SYISHbw8M6bE27itIMJgRGWJY51DwTygboIZHs5fOUURreHXA7f6ogsc
	dh9Hq8p7rLtCYOoZS956AGxdcKsZSuCVlqbCun3ZRmQxVe7VQvYsnu1DCCXcXtbXmjdOZY
	KLTmu0eI3Hl6/7LIX9FkF+fmAaxE/TA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777405403; a=rsa-sha256;
	cv=none;
	b=VcFKOzpXmWiimP0mH5NV4FdabFY0afmGLktSujbtK/TCh7Kwv6cKgJLlbRRWnIoOvbUIYA
	o7B13yP4iU98caBbMfuIX44OUbOQJgeL9kUWWH1Wl8DgOhxr1j7uYaZbMgyXzAMK48NQcB
	AbeN7e4qGrnaAHBemnQ6L1p4Qg7KdxI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2BplrKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A223D61145;
	Tue, 28 Apr 2026 19:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5C8C2BCAF;
	Tue, 28 Apr 2026 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777405402;
	bh=Xs1yYmR71d9Lw39gplast2MaWotUBYysL6c6C2w0ZGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m2BplrKd3H0rONOi+g5VlqO9HezNy/LOKviHgnDH/vDHEn5PJZ6hEO3kjdVJbd8F0
	 12HM+00rdQHHiYDYWwStSy7lXyjKl0u7f11izMqwVFEVwHVqluQch4LEsVr0GMGo5l
	 a0FdIL5/wXGdjnKswlu7r6eYWlis/DyF8sjcVaeQjk3deIN3O4eNiNtd2pDg2jOO/g
	 6ofL1MwlwsDN1jPf1cO94xayrw4715osb2yg3zEQQlLEUv/E1sOoxJvylhg7vGms6a
	 vCqmXe3JJGz3WdAm21UZDuNaEk9mhtg9DeTV6j7dthSqFWi/M0LMln78sJPVDMm+29
	 Ya/vLAPF1X1YQ==
Message-ID: <5c2fc6bd-b4ab-4706-a0b0-df8350094fb4@kernel.org>
Date: Tue, 28 Apr 2026 21:43:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory: update stale locking comments for fault
 handlers
To: Aditya Sharma <adi.sharma@zohomail.in>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org
References: <20260424092217.263648-1-adi.sharma@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424092217.263648-1-adi.sharma@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5362D100007
X-Stat-Signature: z5icszu3u1de3698s5ob7mpu6ysfcj11
X-Rspam-User: 
X-HE-Tag: 1777405403-179325
X-HE-Meta: U2FsdGVkX18fiZ5MlpHCSjjVNPVDum0NwppO+6dtTmi/UqFjDzaPBG7E38xNYtueKbC8P0ESLKjWOBFeDzz+19vE4Y7qrc18dm4fiu6CAGsdmfKuoPXBPwjQx4suD6/Ogf66qbneNtD54LWhN7SgGKcoYNcgglKsy/TrYeyZa5F6QBmdKsZyGy1pTA+Z2IJU4mq3/DmqdKGyqX6yixh4gqof7YNbVtwjqifQ12GSTQ7A66Houk9zqo4EwjeHjjKL3gAxxI1fZ1SOrTsz1cbIOWqqKnKBlk71m52lNSTTwbCnasylufAK9HUMvIyLu6lqcM0cuhYgzR300k51DR865edtKCqtYIUnkDv3BJL2HzcJMVv2Cr228dcChga5lgFaadzkFw+mgorId1vzvfsdTyQGeXppkceHiewwmBajbiKmshSohtTPf7FiLZmG6B+sL/AhVp/TdFolKBFW5QtCVGaEVhvOiY6WqAWoOyEgSnm+Vdb3TJX0GtYt8cI1y3x04NlGFMOALZuGi7CxO+TVxSlmiKgyT3mvVSD9+s3U5MNhvmq/mrfHlQp3dFDIqmlpc5mXTsM1LTTOUqqv70Cdm+OQYw5ALvCttb4IokHW5kBemoz3XXJw5Og+3MCkk5zzdsI6j7D6ubFf+ti+QafJm1/xd//WAe6WUoD9BYbwmM1S8FPD3nzw6iZfwFcT7X0Ku0TFL9qSPjcoK9cj0GRYinRkK1NV7qswOP/DBzUeziA+DJmRysPRv9BxnD13e0Fv5rUEtCZahjiLZZtw4XX4QmqthO4JQ8J9pyiABDld8p5+c5rMWkv8VxIZjDK3DIkOJEfpoyTQheSZyJRuYYtxgF1VPKBDtqaa+dgwBu0t6x+KN5BZ8V+ocRb/7Fgrg0/oUBxJrqY81rr8mnfyJNGfimEjbpY2OudlOWKpVk9LtF1vZePzBL1H1hczojs2C6ALHgxYMHr5KecYcOIrFNC
 dU27J/cm
 VdyUI2CWoUEaA7YnpSRIjEwCx3fyZvb8XvLxanO9TZtTamZBGdPZ026E6iOX3l9OemBUTi6EryPmy2VDIZVHDGO21op5OfeYq/8GPgThEwVzimZoQpm//kOasnE7h7IjejzavNsCTLO6UdZBtCq5Mcr6wj4asumW3fH8G4jMb5CXIE3tUjt9PyVqEN+A9ig3n5SJYGZcC0UrkJD5SH7VyRKpdAys3qCA1oSQDcO9R660csnbgnoziKFQmVQJzHbwWRpnOA4T5RuRVXchyAmsPsLp/Ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 11:22, Aditya Sharma wrote:
> Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
> do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
> __handle_mm_fault(), and handle_mm_fault() to concisely clarify that
> they can be entered holding either the mmap_lock or the VMA lock,
> and that the lock may be released upon returning VM_FAULT_RETRY.
> 
> Additionally, make the following corrections:
> - In do_anonymous_page(), correct the outdated claim that the function
>   is entered with the PTE "mapped but not yet locked". Since
>   handle_pte_fault() unmaps the empty PTE before routing to
>   do_pte_missing(), the comment now correctly states it is entered
>   with the PTE unmapped and unlocked.

Yes, that is correct.

> - In __do_fault(), update the stale reference from __lock_page_retry()
>   to __folio_lock_or_retry().

That as well.

> 
> Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

