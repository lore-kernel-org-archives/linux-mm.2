Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B43C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294496B00C3; Tue, 30 Jun 2026 15:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C406B00C4; Tue, 30 Jun 2026 15:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182B06B00C5; Tue, 30 Jun 2026 15:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7B756B00C3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:29:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61A89168375
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:29:44 +0000 (UTC)
X-FDA: 84937568688.24.E25762F
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf31.hostedemail.com (Postfix) with ESMTP id A45D620004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:29:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=cj9mcY+P;
	spf=pass (imf31.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782847782;
	b=s1DLj38iCxp5cnl/N+tLE5bFmZXagWK+pHsmAXAfiTiuJrZk9e/Uz1sUZtL+gtOsmCzeFw
	7NJLZ5vMBrIzdhYmo6Sl27qwN4IRQnkIbAyJnhnznF9S+yi7HAZDoPjkPCXphGl3sc4/AS
	Fy4hSWkQbg5+5SQjeSzdR5ksvuMLHLU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782847782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkR0fSWSSaU0xZIqLdBJQyReg3okUNCxMQMxES/4kok=;
	b=mvjzx7y00Vy3yNWiQ6m4jz5wWmykg0l+fTAGIrX924SFM6FaeVtFbglT5VxJWvH9nU7lB3
	wFelM8dwOyNVT09XERnO0GANdeJxO2/tXEl4gRjf7PCzIXR0EGk3UNBhn3RWBazgoGa3RH
	ZiHuaMznnnKlSvRdXjJixqvhQKB0VrQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=cj9mcY+P;
	spf=pass (imf31.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net F05C840E27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1782847781; bh=XkR0fSWSSaU0xZIqLdBJQyReg3okUNCxMQMxES/4kok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cj9mcY+P4vWZlMA+rt1tZSZAmV6OQCV6n8YU8VaGpDOo10os4x3Lwj0Q4WA59dvlh
	 R5pVPatfnwj2PgjtHy99nl34sJy75FaIDLryS2eHm9n1eGl//SC1XMwLno5pYxHQKs
	 4LYWbysw17acNoAUqVK5zDsgEYq+MmE8r4iht6HfnaHFt/xcVXR+YP4Px6NlCtcYN+
	 CxgdGz96i9+FpujjUAssTV2V8m62MR9+4GALAXwGwvPaTRoBojtyeuLuK8+hQlPQGW
	 CsK6Gll43/LN32f7SEoKgtybPIa6o5eeU3UwCP2r4y/xuPvH+Ziws1NEH94dGtS4BO
	 mDzvTX2C+gBFg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id F05C840E27;
	Tue, 30 Jun 2026 19:29:40 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Ebner <manuelebner@mailbox.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Shakeel Butt
 <shakeel.butt@linux.dev>
Cc: Manuel Ebner <manuelebner@mailbox.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs/mm: Fix braces
In-Reply-To: <20260629161156.90213-2-manuelebner@mailbox.org>
References: <20260629161156.90213-2-manuelebner@mailbox.org>
Date: Tue, 30 Jun 2026 13:29:40 -0600
Message-ID: <87ldbvsu6z.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: f85qphr5umhjx663urr5gnmm3uwcewp9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A45D620004
X-HE-Tag: 1782847782-864531
X-HE-Meta: U2FsdGVkX18w6rAVzt6M2qsfNA3b0XavTavmzg6X8UsRIhZiZR9/r6qAjbCNb2ocAQhKlUJr1dOHEdBhn0UbMbAp/ZfHXh//nMzeB0GePoe/hnKGCPOolcX+ZOADnsyI2iA3lo0aP2TNlR4nLSfahlapkFHKFXBzBzWREHoakw0AHl1Jr/wo0cqmJ0NLvxutg1kpa9RawGLlEe21IDIFaoL7csNxjcuzAaGfm+zfJkj0LBUzEMhOflLhMQIkdYqkIfAqWrhdxZ1BcoWdUyt86UM/r3ecakDIimodVoE0aPoA3YN/rI+WbIAhCd2H8VgbjdUf3S/oJfi8bEpWUQcN2aPsW0ngHHQ7HdMaWxAcnXl1IRHRT2Lsve9sWKyf6MvMuANxHTwnooXjbI9IKPl7o13lVpUusCY32QxTPhwUYmdNZp+z8DkmFGm8cAelmCr8RNHfPT4hf9DXPHo6Ced7c5Fju4NanlV+ht3WdCy9u39qhQNrE+vf31CDaaSi3J8QnE9df0kWnAE2oEJP69vlhZYtpAp5AA90sH1n9NISNfaHsTVO3+8LAOdPzSwFSk9l7FcFwaecmDX8/J5VPY2z0wZmFea205Um360KWIfsIb2K+ZEHe9TN41+c8p+SDdxtX3wFy5Uwa8MTLAhe04h1ghTGKTc4l7Ty7sq5eF1YrVQAjKHC/mrpVoYGqbuKbLOAKQcBaNAChqj3dUnUjG93lIjYL8++KyQD92sm3HomTkt4Z0wlxZ7DlCSd9tdIm1bD41jjhX4CAldw6N/hR69jyKOQTwLZ+xbvI4TI4teT/SiHLUdypknMAnGPH1qhrZfYQxFdz+5xLExd6OjUNTlQPKoZxsSY/Fy0uEZQ1ak38tU1KkmymmV2+7B8l7x1TBEU7yKJskzCqqSe9jaoQvATiI2NXJXyeHramKqUMtGoG4DsWbs+4uwfaTu7/QYXAE8IdbJbF51AS++KIWdvb3Y
 QntvsGS8
 77U60sJc0Ve/DIRQguJs/u1zOthfOMeR//rSaENc6rBK7dA3ackftiaR37XUHYM5Uvt6ses3hVcSYKQYCiIT4TVNTKMKC4fR7Lvovk3r4LnfgeUuezloABKMlbuC0M+oGIPL9T3KnYk3UP2NtwCxg63GfH8QsS2uTQ5SxhwhMOaoxD8TctAsi+3LhhTXi0b9KAaTW6cAY1EZ6EDZMPW01S37gBye9xCsHT67T6zVhdaJhOKxrb1vxQBLmdZxbUSCN4F8BnwPESRCXhw5Vvv54EkyS2XYotjGmfQ4FrsRkXLrN3JV4okfGAM3cQXvjdYktDJb1LkSw3r5n6DCwJ1//ObP4OlzCqS0SFZ2ZDt1on6hfSQAozCRlxTgvjkBh4XZ6XGzDwGgm1ISnzD1hV5v8iLBAfR5+sy+nc5j13QK0tiCqC1TWgvg8tBHB9DpPwoaolT/K1cE12IO5Q0K0DLVcPSbPlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manuel Ebner <manuelebner@mailbox.org> writes:

> Correct typos in mm documentation by balancing parentheses.
>
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
> [v2]
>  fix commit message
>  add tags
> ---
>  Documentation/mm/hmm.rst           | 4 ++--
>  Documentation/mm/process_addrs.rst | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

Applied, thanks.

jon

