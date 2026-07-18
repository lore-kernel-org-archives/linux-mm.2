Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6A2C44516
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E726B00F2; Fri, 17 Jul 2026 20:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF546B00F4; Fri, 17 Jul 2026 20:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6157B6B00F5; Fri, 17 Jul 2026 20:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 352146B00F2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:00:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45032402C7
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:00:16 +0000 (UTC)
X-FDA: 84999940032.27.A559361
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99BD6A0017
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:00:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiHGZQni;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784332814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vx/1W3ASfCVSI1+TnaFoLicuyre8k2pmNf54ghLrbFg=;
	b=SE15fgjHbIGzuMRWSC4WV/gVGqYb9OX5L1Xn2vNpV+BCYIE+tZuUpoWBVY6NgOhAKJdcTC
	3wpCS3oTxAeDSbRL8wX3QMIN+rv3BP05D0e4ew0KS0Z2aeakRXI7frVxuST4efv8bkOehJ
	3fKjq+D2phREUkTEPPF0+y/NgXNlzKE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiHGZQni;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784332814;
	b=TNSYX+Je1lwWRAmCBGaPh3Y3OuXWj2m4OjEdcwmp7hWCjuvakhmKeU/6mSFTzNzkc0Ok3z
	TWQiTnzVC9w0tUG7G3uTJ/TTN3WX+SQKVkNDjoLd+Z0RPX/LqVuOu6DDyBUzwNBEZ7gIBj
	0f263IyALtcD7ShWE1iRF9awpSCU8u4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8B6B60AB5;
	Sat, 18 Jul 2026 00:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117AD1F000E9;
	Sat, 18 Jul 2026 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784332813;
	bh=vx/1W3ASfCVSI1+TnaFoLicuyre8k2pmNf54ghLrbFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CiHGZQnihy/9CHtgE2dzXcNtjhnY8ODCogd+7UndlAkGpnJ2bb1JAElCFAbo0FHMK
	 4VVFWkymezZgoYcdFBFTTJqFXRhPVI4b/M21qR6aAvCKVQsT0Gcav3gRLQtSPylB+j
	 PMDwY2bEvzNmCcbdwL9aF7a8jVy/NNd9RbSNxVdFA5iY1Qy4+eOQ3GPvIaDl8yd6Ae
	 x5GN3PygEIWU6v6lbSrCxbng3EbgUwISSxq+nbcrQ64K6RhGGJjDXpk+qWtIikFzCs
	 537GY8yikzEGB6YZlso3AWqySHeeVj1RsXrRZVBGv36KC3Bg8slcyRkovweMfunv48
	 Vr9cwPpywSmJA==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: Fix BUG_ON checking wrong variable in mremap_dontunmap
Date: Fri, 17 Jul 2026 17:00:09 -0700
Message-ID: <20260718000010.85576-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717070251.73212-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: msdowk9zcjp837d5nhegua473wrd3ht7
X-Rspamd-Queue-Id: 99BD6A0017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784332814-478447
X-HE-Meta: U2FsdGVkX1/YF4JMq+5i7bqdDqFCVAqaAhMg5SfaGYXgX0F3BiyWnTJgF3UO3z8XTIJtRlABilQYuY35QaXchwnuXxlLZDstNvmituw9wqTPV3tolapIrR74LcaVqBQXINoSZnBx78hkbMkEuvVC8N86ZBpEcF27R4msaTYrJGJVhzY9giXmVpGi32V2Iq4L+1gX6X2qfeWNnkpbGCiQqLCDPX/k6SBB0j2G6y+zbPeloo6LA3ncNESy9eCe9uylJ84EEDHiUMNfF49C2I1czlSlsXz/9mZuxGTBTmqdSYtN6SHnktLLNqqWNKPYvz4p1vzkqbJnOGXGLIVVPtlToOn15J1EgXMM8ktFIeDKSF4+2g/8uniZO6BznHqGVK0hKdXTziVEw80SBPCm3K/20TpAl6/DER1VqZJF3GPoka5d7bbi0a8Y5pcTjNF4tWfNVnrcbG6CAEUj4euBNJ/jqj0zY7yEc47AqTePmLWCrGMXr5IM30PvwZLjSI71yybv+vqNdPUWYWKhGS/tVTsPVERdVarswhWf02Ag9w8ufd2xImrRKldHAgTkDGB/xPP8hv2I5icxspUgmCRexyfbTH2Ysk7i2nlsVi8WrcMKdgBCvF49ojXM5Oykrk0PWxUuhnLeL/6DZ2BqJYj/K1keQtcP/FilBxgI1GXmbByNQFm4AY2MAHZhCqvnWbwcJaSngyytmiBuf6PUT2JhBArp1TxRcKFU6PDfQ+lDWjowDJm1OutSFAidTcQuFW2UJn1d0q0wSYBoipeM6k62ZAhqmiZYPLGYqmSs7/IJNUUddq1ljnFXhYTw2HX7Br/q5qPgx+eo6+DWIP/EW6BXzRh0XdVrLvMph5hMj+qhX2pN6pBC2yTbYkhpl8y5m1QWOaC5T07tVVXoFIOnCruywbOF4ZUoTiqCaZtHyMKqJGSwO6m474zWawT053MfxVmXJs1qB/106mzRw7DK7sR0F/6
 hrfVMXAp
 kGld0g2yZlMUjnVmLCYfDLhXt20MVMbofj15YfWUQHtMidNilkOBBSNo2g42h+N2Svvb1mkBKYTEuC64mRk+CYIFsq/ccJYrlTXnuGCQ4grXg6qL4LXQB0aSYPUQit/LAdX2PMhIEs25oZYssk4h2gXjtDgzudcAh5Ti6NTHl6ArqNeSNkYJufGiCnoYbzsi6YgOUuo6f8Q/Bm8yeO4D7xFAUsVvdCTjjkuzrPkVhA/VW2h5Z16A3507LatDDFBk7Rs8E+lj70cbsKALxPT1mfe9VzYvyDfOOgyu8u+XKia/HaZRw0AWOUBuLhBhOwsDgkeLd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 15:02:51 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> In mremap_dontunmap_partial_mapping_overwrite(), mremap() stores its
> returned remapped address into remapped_mapping, while the BUG_ON
> incorrectly checks dest_mapping instead.
> 
> If mremap() fails, dest_mapping still holds a valid pointer obtained from
> the prior mmap() call, making this BUG_ON never trigger at all. Correct
> the check to validate the actual mremap() return value stored in
> remapped_mapping.

Nice catch.

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

