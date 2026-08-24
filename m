Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2070FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C84386B00A0; Mon, 24 Aug 2026 04:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B4E6B00A1; Mon, 24 Aug 2026 04:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98456B00A2; Mon, 24 Aug 2026 04:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9A06B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:59:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F6F0A0423
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:51 +0000 (UTC)
X-FDA: 85135565382.23.C07B7AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5142160002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:59:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3tRAdSE;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYa+E2MlVb9WrdENOVOikhAmxarWWMZdxbjn4MZkJMI=;
	b=06m8nztR01YQHWOKB/Vd2zgV9sp/J5V3lhJmzHgXyeYNebIBF87gzZK4iB690WeDw9lPGJ
	IqFgrateicoooDUk7lSiSmZbb+kGEweFj21mMR5dAvWFFq5Eu0dZ3/ofxyljeHQO+MQa0n
	dp7mq8kqFO19JqZs2H5ApQXVV4rI8Kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561989;
	b=XafikTChKNXBz5iVy6N7KVFfbxFXV0SbUlfwQroFuk+KAuJBkRsku3CNInISFFZRjAs5kU
	+/l1uZSPJH/lCCLsiB8ztRwOg1eS/0Mqxrz9mFv41iA14hR5ruvLGgnS5B8cCVaYD73ypo
	6TvL4ru0XBYUsgj+cfmLIxKB3CaPWuw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3tRAdSE;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDC36440AC;
	Mon, 24 Aug 2026 08:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46DE1F00A3A;
	Mon, 24 Aug 2026 08:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787561988;
	bh=pYa+E2MlVb9WrdENOVOikhAmxarWWMZdxbjn4MZkJMI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=f3tRAdSExdt+3cPBAx6h+j27Lcs7TwSphXepAhr3o0fe/ftzXL1XpGwFP4dgzkM6q
	 G5UFYhh83hsLqvbSgqkQdQqiAoSa1XbJWjBT84u12K9GAgFvW1iPqW7hBRxEdgAbZU
	 LCYTwUSwBDnhpOwRaHsfk7BwblUqlSf78/SuvihnK41gqobYTzkqpTz0TpIEQU4Ip4
	 0iwR2nU0v9uLttpV57Fgc1Mftovcb1f5AX1lPIGmOpGkTASoj56CuoYf8iWwXFqXJt
	 csLgVflvoRUONpuTDfqxFg72eGARZtw7McRfI0UbjtUQe263cJDC75J+xXBoi1GQOv
	 l3x+wUnCsp0DA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 09/17] mm/sparse: initialize memory sections earlier
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260819095140.17252-10-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
 <20260819095140.17252-10-songmuchun@bytedance.com>
Date: Mon, 24 Aug 2026 11:59:27 +0300
Message-Id: <178756196750.3606540.6986361782984220401.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: mjogigdd9q58d5yd4mbg6qtx4xzbpn6z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D5142160002
X-HE-Tag: 1787561989-335832
X-HE-Meta: U2FsdGVkX1/mfNdB47KHym8VHyo8lZV6St8mPsT13/EiUbGW1zN3IuTUxRdkVfm+OX6hTVfD9X66T9muHi6FC09V6r5vAoBpCWTsylXh8/LGffkzVkzfCKbpEO8sF1oW6R8AXfLEOJHl96ZYbayz2qcluQx2XhrRvwQ88RflcCwI9TIjlRFqYQAdslC9loRsy/rrgX5J3vyO6i9QwwA7b1BZubIntFCBPiGEXCL41zsD8DVkmoJvHaetGZ57uWi7K/NqQG6alXTvVr78+ixSzWWkQIl6yNLET4iGdmnhWK1r4Z03gt+CSreEL5uogNR07TspGaovfaWbYOVYlXQjmr96NYK3FHthZymQ9rxAleZNS3qCo/tSz6lXijSH6/nqxHrGURgRMHvo6FcqirSfduhB4zx03Nyj6qiUq0MY3tcTjdrpj27A1lZqoiIp/cPKIw9mswJNox5TRI0ylaPHnqFIMk44oYkRkmFeyhLMeMFAQb3vxlBgpSz9aAT+bFL05+nfnrSQ48yS+qwfBrBIFu2lDEANNM2shZlNt5xxf+kup3yFvANL1hYSWnycn76jigJtt5yVjOmuFaP+hjf7yThrh0imD2L4dgDFpYBAYkpWulBIiLIdOSiFw/zSa/M0rnamY21Ks/VsRBtS3kLSpYq7ydtQG+WHBTDvHL8veztWva60J+Ob8DL/SPTg2cR2s2pRZ4dFRA/xeFJol8thYM9yVY3YezajWUUNAYlHXuxGutSk5FZa8Q0n7+7S7Kx7TbAHognXmPp7ChpNv+9xHv/jBe27oPB1vUrEtJwz392BSaI5I9uR0J2cUSAIIWoySpEtJbUshQDgkCtqGcKoS5krOipsmiJckIYeANv8cNsc6iS5vkZD4QXYherTp29LuQ0jP8kSOnToraVxpkei++cscfK2jNdNtoLxiQ1CSWE4FzP703+r68Y/gJLp+e1RRYz5J9LvxWL4dvcoZ9k
 dPXAv5TD
 hffav2MBSAjCfUNrRt3e1mXGm5QRPTbLVzIRb0Fe907D11SrPEo/FDlMyw5rkyqQN/sYYENAxKf6Rc7qolGMmXhNaZ5dTW5gwvgEkJIUZKFbFttNHUYq0l5TvLQ2Dy9Tgki4x+j8mjYXFUemQk7Pd++nPA0O23NcbFvPf2jO64RueI/t8BlqDBCBtkfxJ0gKVelW3nfU7i7WQdyHbhhOOqN+Q4Nd8JqX+Y2JUn4XXutJPaYx7s9GYbUajPphRXSLYnnUalNr0uYPDMf8pGyyNP/sS7LPESe82cye6MsG2Kny+/MEmuezMIc2OxQMnw4VfL0WlQDrUYZXBby2EZBZIpMqRbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 17:51:31 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Upcoming HugeTLB bootmem changes need sparsemem section metadata before
> the HugeTLB bootmem allocation path runs. The memory sections are
> initialized from sparse_init(), which is called too late for that setup.
> 
> Move the code that initializes sparsemem section metadata for memblock
> ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
> bootmem setup. Rename the helper to sparse_sections_init() so the new
> caller describes the sparsemem-specific initialization step.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


