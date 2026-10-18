Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C7ECCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376206B0092; Sun, 18 Oct 2026 08:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327546B0096; Sun, 18 Oct 2026 08:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE116B0098; Sun, 18 Oct 2026 08:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5E026B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6344D120518
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:48 +0000 (UTC)
X-FDA: 85335673416.01.4C986D6
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9FD1A40008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=IqUC9U3b;
	spf=pass (imf04.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326466;
	b=hEwPDqIkSgqy/auJ1Vvfecx2yt0RyNjfBQXNbwBX0h6HNQG0DvJuf8P6kEGehlXo+05jgl
	93XIeljCxd4BMFY9f5BbbuHh6Vkn0e/CeBColBqgoKpoKJVjyf58hSCb+can8uLRGVBlLV
	yaj18KbC12xcwSaJ5qCwr23nlxZpxVU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=IqUC9U3b;
	spf=pass (imf04.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIZSyB3o/yi3/I0EuVXatOlWLGrztINLGm2bYmFUjyM=;
	b=ScXZEtWGygKZHcEZ/ssV5W/eVvzmkuXyEvHnN8qrn0qKb0VlmP2dkF/7NxJqsrWAHCDsGX
	aYfm8X04JgqYGXr39yRkLQnJFJMtIbUo+KAv/K6qEVV8FYF4xDei9zK6WTQa6pCiwKpe+U
	2O8dzWgkgTEFC9hhWMi0cfGMDhoM5ZA=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792326465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIZSyB3o/yi3/I0EuVXatOlWLGrztINLGm2bYmFUjyM=;
	b=IqUC9U3b2xO1fhtYmFEisC35Wimp0V2he4OAU4hZuhjOHjCZ5Th/YIlzcF8Omz/cH+TshI
	I8n7bm+J3+vEJWn4uq93HfUcgDjDEq4HcSsfKzaas8vfALVhJOz4VUhVFVuaYUKtBmqaa+
	07I0dIQ7Rym31z5PK1RlMV1+/GsDFew=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	Jan Engelhardt <jengelh@inai.de>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH v2 2/3] sparc64: Move the 32-bit PIE base below the legacy mmap base
Date: Sun, 18 Oct 2026 14:27:33 +0200
Message-ID: <20261018122734.2594904-3-stian@itx.no>
In-Reply-To: <20261018122734.2594904-1-stian@itx.no>
References: <20261018122734.2594904-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FD1A40008
X-Stat-Signature: xq8furk3g8pjydf1ujxayi8ecynjcqok
X-Rspam-User: 
X-HE-Tag: 1792326466-483572
X-HE-Meta: U2FsdGVkX1/PnCfu3thXSKVrBfPLDOUMOkem83UM1ObSOw+zNfoi3AhJBu+8tS0RJMVb1MskUrIV84MQem27YyzDJ62e99Z3HWlL621MN6PoiO/t7r5Fk4OVwxybwsNwEOcD4q4R1+3kORrS/Y+qUlzA5N/p6jxNgUDZ7j3mPOhro2w2AQQowcniJmDgMQIQJMR9SCBYO8ZubjIC27XpQF2idlyZL9/lDYXIwpjwK5AGxEmIp1sK4ok9sQTUoXcj9L86QDN6O4Gv8sBLXsN6CShiOl0TNzBOyC7+A9El66b+27WvOMSXcZsVx2AENUx6nmc8YsRH/TrELrnAxh8S2N3U3wdTrnJEAiMkRm/QZVcY5cZFG7F/gZKA8Z0l6DC3KVtgH+//Eizub7vFZObjg7+rH2Fra7aJ3bTYXTtDQNabNp8bVhG65DdpFAdSXJ6HzIjpdBxuErmwHQm8EU97APeFcUua3egYaAxigvTzCP7mMJsXUzxtCXdI9GRuVnS8rr1UIdTjop2PmN0TwoOVziiBjq3MdU3V+Hm0ysUDVZRtr9nA4ulyswX7R7AOIfGgzzHmdWVGOq4Pu+i1B9QSqx2Ogvl33rhX17cEwczS/8SVAa4wHQNmDle8FnCRDsRn8VkWbSM5UPP5mnmcU4D1WMwEvG6ct50pUC+wkLRdcI9g/08O+Rb2W8BUMFs3xSPNdzMlusdmym7HBDCwP9iWEQt20bggfj/FpM4AmOUVQagYr7sE00iMW5dZjnK4b8uVdiX6U8OTBrG9iDeKi/m3Eb9A9A9aBS7S1IZVh+inp/tH2Fi4m1QdpMk4RQl7xzF/jEWZwkegHvBjY5aoZBp45wSwVpeFrd/S0OXZLOTsJCSkw//aHrO1t1Ookoq1+BcW44Eg6QIYwsAzFkij4SabVXSUvm11vVJSQnrZbmFjAZi0T6/NU/NJ+DnU/sHcyJ37Olx40gEnJem3N5MdRwL
 1NoR1/ub
 ELS4nji3I7HqyPKbb2cF9AgNGyM9Gr1gciicr51OJ3/NbqMku78DScthQWutVom8JTs0s5G/C+p5Vb59yjnzXHmO37XeFaBYy0IiZhqxvTjdFQ/z5b1b5cNjXdKgnj/U/tIiM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

COMPAT_ELF_ET_DYN_BASE is 0x70000000, the same address as
TASK_UNMAPPED_BASE for 32-bit tasks. With the legacy bottom-up layout
the mmap area therefore starts where a 32-bit PIE is loaded, and once
ARCH_HAS_ELF_RANDOMIZE is selected binfmt_elf also moves the brk of an
explicitly executed loader there, on top of the loader itself.

Move it to 1GB. x86, arm64 and powerpc use 4MB, but binfmt_elf now
rounds the load address down to the PIE's p_align, and from a 4MB base
an alignment of 8MB or more can round it down to 0. 1GB keeps every
alignment the old base allowed and leaves room for brk below the mmap
area.

Signed-off-by: Stian Halseth <stian@itx.no>
---
 arch/sparc/include/asm/elf_64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 694ed081cf8d9..3f7050369f79d 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -190,7 +190,7 @@ typedef struct {
    that it will "exec", and that there is sufficient room for the brk.  */
 
 #define ELF_ET_DYN_BASE		0x0000010000000000UL
-#define COMPAT_ELF_ET_DYN_BASE	0x0000000070000000UL
+#define COMPAT_ELF_ET_DYN_BASE	0x0000000040000000UL
 
 extern unsigned long sparc64_elf_hwcap;
 #define ELF_HWCAP	sparc64_elf_hwcap
-- 
2.43.0


