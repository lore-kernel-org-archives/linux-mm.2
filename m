Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1BBAF4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2845A6B00BD; Fri, 10 Apr 2026 08:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2342E6B00BF; Fri, 10 Apr 2026 08:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D57B6B00C0; Fri, 10 Apr 2026 08:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEFA96B00BD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:20:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAEDAB9B61
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:11 +0000 (UTC)
X-FDA: 84642553422.20.855ED5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3B11D140002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:20:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEmycwX5;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823610; a=rsa-sha256;
	cv=none;
	b=v0panYk9/Jh8sF8SwHbw8GVFdwpdkJNPTSDkqAQqDsyildqIWHH58GwghZ3MXSHUJQxc7r
	LsPihf610F4Dsub2CtZSLovoG9wccTYKzCNcJ95FoYAv0UHWEL7AqiEaOPjNpy6EB+ldNq
	i/jcuxm7OWiF9R8Lu5/ErwD9x5a+/Xk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=7Lj1aNml9xNTs4vJYi74RnqcLcp2m2BsrRjTAYhHjrw=;
	b=OWx7sh3eAVpVFB+I75H9YJOQx/N6E9/DG/B33kRfDngCNl4awwLpkvGnlR4lEC23NvwobI
	d7NU4G4KqjOvxnb50HysNRwpIKz+ynhCfHW9cwSgI9veDn3WyMSoqsMYyhBfQ5BebatfjS
	EDedRJ57SV7N2OaEs8nyuGpq9Qip6H8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SEmycwX5;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC2056132F;
	Fri, 10 Apr 2026 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA3C19425;
	Fri, 10 Apr 2026 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823609;
	bh=UKj6WoZFsTQfNpLsa4hK9AJwWp/c6TyAgfAmmgBM2Aw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=SEmycwX5s0//+gtSPktg47GJS+8sJlwAPsv65Bq7Wv5tg7uQL3Gpghd9FaOczcWIN
	 ZQaCuA/qh+jNH/riNYpmVLmwYhqyjM2JbqnNtt1yhbGBg3HT7iCiqP6g94wS0wTPIA
	 99ougHo5Nu9h67SjSnTNqyHC+/lIAAGR6p7tHCAck6aAnXmlbTDue5R1sT+DZ/waOZ
	 GXIvFpg3p1ueseORBf9eozHpgJ3jpkMWN+atB0UvtcxRk8vKXhCteFgdwrDai6rThh
	 FHU0CtO/nkzQnAaFOlH62oLpy9zcH9gwc0II0cebCdnPQhGplJ3L9nz1drcdz9bKdB
	 3Oc5+96qoKgtw==
Date: Fri, 10 Apr 2026 14:20:06 +0200
Message-ID: <20260410120318.929806643@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 kasan-dev@googlegroups.com,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 20/38] kasan: sw_tags: Replace get_cycles() by
 random_get_entropy()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B11D140002
X-Stat-Signature: fn1pc3g9igqcuauwpqbt5qc154hnyiwg
X-HE-Tag: 1775823610-219392
X-HE-Meta: U2FsdGVkX1/QZbSoXntyswfj5AVXZCb2b2oHgpcQ8xnPtxEOqklR/EClwHauwuIyZGuRg/3XgH+TmvwJuZT/71J9sbYox/Ex1obXGCeojpuHKg7ryWRA9mNIc4XKax6Hjv4GepaiDEeMGsTxXSw6b64qTvy1mrd/21x50NjyVvr8N369pcIRq1lOjHkiVqrfVMINeFXqzfLT+ytkJB6TzfpP2VuXg43MGh+udueH9rnvtg7f+ZFAxTgGz/twZTtJwvZfJG7zxHh9FZ28LtlnAXbStV6AA72x9jJcl3221LlS39VNlYGPsgGfNR+WTx8bmYgr4xvQMr+CxvObjgRHUPBOn8rQbQLaQzeExM7VcLQ1dvUkyagGNBfiWm8RV/ssoasrhd9pd1T6rYpJl1JzwayKmeZVv+rJoGYe/JQgrphfiYKErhnixHKd8nd6U6/WR8p04GDi+8nZx6KjigqVXlYiGaKdPdN9b8EyfllZ3z9FFNp7FbPPU2YmETXOGXpQMlMzYZkpRzRB9gdJeUymt9v4N7jDg72d4qaSEeYfZSG7q6OwieICmzp33mqDfhxbj3evFTiijfMEuQXRsoDprs7t45NDu79RmWdrLGXw3t0O4+rCa/6YQ1nVj3xG+DfdpgZ5FeGN/wST9SbyRU4KszjmBHJxJW4INcWZr4Oy55AW8F0nCM9WZuv8iYtsvR0UQ/nDmhs5Wx+SCaz6D6L4phxjj0OzCp05hPp7LV0gY5BsJph2Q26isy2K7xCeOnatMkW+ATnJLkWIn+MtnWE+CmKAcssV3uczpRgHuzLqTCP+3ad8Sq0IA8yidbliyNqIk8IDnagH7c6AqQHLpOLRjzyeEMJPSY4sGE7io1ETx7fmp5VVIMKrgVTI3qLyyOBqMx+VF2pEA8QIEIfmtBGh4LGgaLh3uOceYc2BrUTPwI6Evg7Qs/a6NTph+Pznge00WdweAExhZWtNDHq5P/p
 XdEtxwNU
 4Ik32x9Ix6Y+VeEcMHbEHYm2p4yo27KSm/SK19Ecd+Hf/FOmJmxb3EzD/PEq+NG+ZZnuoNI5l7QXMGhdLW1zpUOngbZd7g0TrQ5jWTUqjSIiD8liHoY3HLFFbnjurHbPrc0oPwDNRWUZEvwoMQcNU0VuQbQSLmhwBGJjxmJAy3/XQ4xzGDOGBAT6R3sKOAb9UWn/x5WXAAlvVNLpk5xIJMyes9ejO4TXMWRb8vXc/DEf+P+ZRLyboSEucrvim8zg6vUk4fWV6oIZFiig1Bnyehq5r1yQjnYn5ju1LuAG/Zuxn5a+7O0GEwioVMaAyoMCydzvZwy8ffBJ/FFQBNfXvfjih/vOySYvcL6MXbHYVe1gNCuMh2fL6zPH+SQimMbviDlqgr9ig0LDqS3DHNpax7o3q0wl7JvozZ3qthROroyGi980zC7V5gCsEBTVD7RU2FL9M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seeding the random state with get_cycles() is functionally equivalent on
the architectures which provide get_cycles(), but it does not make sense
semantically.

Use random_get_entropy() instead, which is the proper interface.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: kasan-dev@googlegroups.com
---
 mm/kasan/sw_tags.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -41,7 +41,7 @@ void __init kasan_init_sw_tags(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		per_cpu(prng_state, cpu) = (u32)get_cycles();
+		per_cpu(prng_state, cpu) = (u32)random_get_entropy();
 
 	kasan_init_tags();
 	kasan_enable();


