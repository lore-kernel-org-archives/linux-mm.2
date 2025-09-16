Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110D3CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309088E001B; Tue, 16 Sep 2025 05:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E05F8E0001; Tue, 16 Sep 2025 05:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6A98E001B; Tue, 16 Sep 2025 05:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3238E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:29:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 763DDBC058
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:29:17 +0000 (UTC)
X-FDA: 83894589954.26.81BF8DE
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6203E140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:29:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O xq/qRB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=YXX6VCaB;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758014955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RahN1nKreb/kWvqsVS3VXXptJiVPO4DE4jLNfb+LCo=;
	b=JdSEO1L//juYDXRabX7f6kDvZJFHBWCrFkqIMWT8pYQIUYNvOmDgcIVCXJQpemGsuw/g7C
	k0bsutL//bV9WtF+Wq0iKSuVuyRXDHN9Ya4837p4ETkYV+8h4wLQDx+K04sgEPpVb3AhbE
	SiasOn5vGXYcZPZb7hXX3G7A+ipEcbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758014955; a=rsa-sha256;
	cv=none;
	b=q8MsiBRukV7t8gPIgLAQTOm/WMFTCyZyeZr+SeP0a+ko2xxeXKMfeq0z0LhxAH5F3Wrhf2
	/1CdrwiR5nXAwhg8+xrPC7n92oWf2jpbFI/Dov6kSOKpBCuvB56rTwl11Y+Bdjxtp0Ht9h
	azKt7Skeej4nsuH54768VBvog9QEcHg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="O xq/qRB";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=YXX6VCaB;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 92C2BEC02A4;
	Tue, 16 Sep 2025 05:29:14 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Tue, 16 Sep 2025 05:29:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758014954; x=
	1758101354; bh=5RahN1nKreb/kWvqsVS3VXXptJiVPO4DE4jLNfb+LCo=; b=O
	xq/qRBsbLho52vgHeWVbG2UJWCayG7TLcwZHKz5S1S5pGQwQtx4Du8OVrtA56b1J
	RZXL+tohI5GYmR60L7dXKVvgpn18OqOiWPlKGnfohAKtUWtpwpfwTpUehYvPptXx
	NIPX1fxa8tUFvvFPSQ1inI6CfSbne3jLW9RCoNpFOkBE71EFmG8VOz2GheqvF6nB
	sLRp4SEtCepRN/dE6R9IagOJixgRF4CeB20ZUrmHxD9Py/oZCLKThxPhRwbiZVOE
	vlQ0aeBtzSCY1ah2m4a+qZt0xugn5MuySnMxMiW9XwQfwDMvBliD2nCy+wDw5X4R
	Rp3U+YRPWNVXzr7e/uj8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758014954; x=1758101354; bh=5RahN1nKreb/kWvqsVS3VXXptJiVPO4DE4j
	LNfb+LCo=; b=YXX6VCaBKueNu/Lsxgj0HauU9xiScWgLahxrR2WqlgF15ymBnlj
	G+44ldfKUVHRL0zT/2LrWUmTGWX6wHdwJ8qhpBU7gYT50Iu3NeOvxCzrlCgpo9e4
	n6/Y97VLbVSLWNMlA6E3S6gSuDPQK6I0jXJ9SmsKuBmfCS2CbT+NrDkV1o/qancL
	911hS8E2HK7kEMdfDve3sZ1zRisRB/W94p0pNj7afPVr6x5LPp9mtsB2mVVhLyjU
	n1qzcrNb3P8gGXP7XMQrliOpk2u0Ib08IofsCKCunc9wO3PysjfeSlD2bKsSNMMH
	jAREwwiJwUyplZu1JJJIYYD1gjgjOaMwHhA==
X-ME-Sender: <xms:6S3JaGwmOnh-AqDdFuT3whhLqr0u6ajgMukZckrk-FWMusBEu0h3zg>
    <xme:6S3JaEqKSWbTUjEoqu7lJ6JXhCxs_L1vXgPT6urzr5-HpMquh_hM7O4uzJkMFgh0Z
    In9Xf9-zwp0bwsOG-w>
X-ME-Received: <xmr:6S3JaBlfWUHLtTVTa6H0PR4C7hyA-Ou3IOm9or1qPfXSgLkfGxWvZ5HY8FjWBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegtddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlrghntggvrdihrghngheslhhinh
    hugidruggvvhdprhgtphhtthhopehhuhhghhgusehgohhoghhlvgdrtghomhdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtoheplhhorhgvnhiiohdrshht
    ohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepsggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggs
    rgdrtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtoh
    hmpdhrtghpthhtohepnhhprggthhgvsehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:6S3JaPqeSgPOCfaX2QbBr8B5U-EEHZGMHYEZHCK4dEwfBpdLxTLn7w>
    <xmx:6S3JaKZVhQ2Kj8EpSlxkWZkBEKThm7uZ8qajDh96BqObdZZ5_KHEtA>
    <xmx:6S3JaFHLhaNsFzBVAupFxxPpiwbn3BLueHfVyXX3nNVKHkbf2UkuZw>
    <xmx:6S3JaKzt7MYYHCompAFtPR0V_pjgr-igjGoObeIFdSElYa8LtDIJig>
    <xmx:6i3JaMNL22lJiUEyjS6wpOSMECdzy-s97p_RkvSvF9f9vPc1UH8sA0jW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Sep 2025 05:29:13 -0400 (EDT)
Date: Tue, 16 Sep 2025 10:29:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Lance Yang <lance.yang@linux.dev>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier
 in khugepaged_scan_mm_slot()
Message-ID: <ol447ofo44vwtyfwg3zrdtcdlkfzzmx4rre6qhyotmwvecnec4@usa3nonuk2sn>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
X-Rspamd-Queue-Id: 6203E140007
X-Stat-Signature: rqn9t7f7dhfbp8siwe9oi59ao6411749
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758014955-664009
X-HE-Meta: U2FsdGVkX1+dgcM1RGbNzw4WJFTxZXjBgoCQgPH3EhzGJc9k6uohOKDLIrEyaO3ieymGleWiNFx63OhbZl/gXkyS5PZl6JMVNv+4ftd2Q84Q5xT6oUHUv15JM+jsBXvdFBT+hxA4A85/cmDKOwn74r8oYpWJQVYVLcHa1hCkVlhO1lNL1ofO2mGbeYUwfiGBuaalYaxhq1nkyICuCaZBxAiTd5s5xFgY3GdTYDty+jAo9iJT/0ltb1QCu/CYPSPfadHuxIEwVansciUlHWYH60BVgM74Q4D5ZRk6YtWzWNPw+AkgiMYvNV1XVR9lzbsWIFzE2BCGQo+DrDThxQR77YZif6GmznAHFfVkIrQ89qNRbN8q1/tWrA6VmU27FCcyDLKSlF6P1S0rgjsj/hlSVcrQYmgnAlQ32hf4PgI2s1c6Tassd9rxNWUZEued3VsLD+jqfSHl8GcVZeNk1lTTrH/7LzCk/mjlj1LHtoJCiigbK0H+eU7kzg6MnHWY07dRnDM7m+EG7AEXHCQpuA7y+Bc7JrcD2ylngUSQek1Of+nDxEZfhIfyVeGeaaGXmei+hZVpO/5GzeeVWV/GPqGKl2ytG4Bi+CjLdkDCehZ6EDu2zfR2Hu8Y/ASlV4maY8IKKF4b+pQVyZFRoEwQhOWr2qir3VAvpwkbC2Ps6Wcpxs9BLv2EWL/LngSZZnmAhJ15Cwn0LmZIj4+evYw1GrTHEA6RTFoMbAV/TiWIesOKQtPRWT8y41uX7ZFxYzOwX6h5VRv+vWU5sF4j3W2n+ijSfFhwypZCT0x4pq0FPJgRQ3UlVK/ZNl4j1wTsVdALEd/MaSecc56OpERNNqGjBdpiQVbMCRJ9BLuVzDPxlr07mnBkkU7iVOzYYJYT0R5LCJJHNaA/23U+uyfmA8zkfcYP39MIm5vPM3WeqLqn3WfZifs/b29AeHedKblqNc2MenYkSMJIB+rwvyWIFf8VilM
 GuOa6xdm
 W9G9M3dqg/zNqLhjrIzKE9weKTQz+sbHppKgK2W1H7c0NfSIIJlHUj0NTEO3OG2GgLvbak+R/JYwvOmx3EAqJPaCd57aSvtXvYRX5bVSec1n5ZhLIkZ6tVW7zbHCt7VcFxkC1Z8SymKejpMOyXughcJbn7YbhYEOktOexEe3qCb0qYmCabuYNT6sY0H2kGjAHyH9oGPGb5ksLcxACI5fo07L59/Bcqj5EpFPAJoFW2I9hMhXpsxlXn7v4rulSnoVh87HkSAunhPz6UBl32dXpd4Koat0i93y/6Q6c+mbm1zzw3BUkZOoEiDenrqgsXITtE7SE4WVPVtgRONQbxC8vJ2LGKXJjWP9XTsFZ2EMAH7ZQ1xYitzt16JxxIR7Sbnhov2Y3NfSv2qhkkgkBEXR6eZLbXZ5vuxzAzx0RqgzGGGlZdWQcDQmwlhaqDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 02:21:26PM +0800, Lance Yang wrote:
> Users of mlock() expect low and predictable latency. THP collapse is a
> heavy operation that introduces exactly the kind of unpredictable delays
> they want to avoid. It has to unmap PTEs, copy data from the small folios
> to a new THP, and then remap the THP back to the PMD ;)

Generally, we allow minor page faults into mlocked VMAs and avoid major.
This is minor page fault territory in my view.

Also it is very similar to what compaction does and we allow compaction
of mlocked VMA by default, unless sysctl vm.compact_unevictable_allowed
is set to zero.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

