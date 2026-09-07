Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6395CC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DD06B008A; Sun,  6 Sep 2026 21:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF596B008C; Sun,  6 Sep 2026 21:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F85A6B0092; Sun,  6 Sep 2026 21:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBE0A6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:20:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7125E1C25A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:20:43 +0000 (UTC)
X-FDA: 85185211566.28.1C859B4
Received: from out-zbxj-a78.jellyfish.systems (out-zbxj-a78.jellyfish.systems [198.54.127.78])
	by imf11.hostedemail.com (Postfix) with ESMTP id 800CC40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:20:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=jlH7kWS5;
	spf=pass (imf11.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.78 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788744041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BhB8kBxt+StZvcY4KWOzj5LwCM7hEqB3jFqFsqshSc=;
	b=yUhwF3PMNZQ2h9wolMxky5gw2GRsK3xRIziCkmN0FLbybsXAozApIxIPurAB7fWVJgN9w5
	17aEyqDS0ZpQPtf80S3Lu8h8W4W0S/OcgFr248CjC/UBF56ozJQkTxsiVNdeQSXLjJFfvL
	LHYvxgdID6ZUZT4C1TzYLGpEPYuptrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788744041;
	b=FhYP44hDqch/N0UDpEOl9Bg+byeFwofVbeQ4BqwAU89HYGZ6fU204Kz7GsPrRw6w7tUKBu
	znOAe3ApLe/f6FObRnmZlGJBOs4jrhQvBK71Jwd1iVQG0Ezz7gaG6DTmNpqVSZh0VHSOHy
	UHVLpvWZFHVVtcm1GMqWFwaRzF77h9o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=jlH7kWS5;
	spf=pass (imf11.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.78 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from 192.168.5.3 (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdTll5c2Jz6tlq;
	Mon, 07 Sep 2026 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788744037;
	bh=/BhB8kBxt+StZvcY4KWOzj5LwCM7hEqB3jFqFsqshSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlH7kWS5skDnhiS31iqUSJZjGySerBKY9Fvytx/7uapbvF3odxkFdh+9qGa3PuBC4
	 htaU6nzdYXcmY0XzV/cTM4HhH90q1fQRE/eHssDDxqp+sE+xe+I5HesQgHbBGBF6ev
	 IlqQMym00YkQ24ZWDIqjAvgpj+tvJPp2HWjKjl9DZ8OSnvPOhQ9cKscN5tI2+7Nu6F
	 VQLaAoOF3KHnqP1G/5A8k8faH44NzJx//Wzxbq+FSzqIH8SbFfZIcM2vVZDAZavqKE
	 ZNqjhGdMkZOC1+7OLE1M3hwV550P6ktiYEP+NhxgSYo9WBZjoiGkNIlUqnYDwWjMjN
	 x3kQ+um+UUyBQ==
From: Tianyi Chen <hi@tychen.cc>
To: rppt@kernel.org
Cc: Tianyi Chen <hi@tychen.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] memblock tests: cover low-address allocations
Date: Mon,  7 Sep 2026 09:20:31 +0800
Message-ID: <178874362959.1415955.18132997964995947947.memblock-v2-0@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906144011.848898-1-hi@tychen.cc>
References: <20260906144011.848898-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 800CC40002
X-Stat-Signature: pop1h1thybh1k8nzutob7nobyk8ppukc
X-HE-Tag: 1788744041-18273
X-HE-Meta: U2FsdGVkX1+ashJrlbB9j2TJH70IbzbI9IjaHzqFeQBSXKFnxLRDN9jQ365193ypwYSR4gX4yZwrGFSeylYUVtOJKfqO5FKX3V0EpekKCmXmAtZLo5NHtxPu5RU6ANgy96INtOWwBkPxO3ZjjlUG57aR80xMJCGJoyloh5wTSIS9FVFQx88m6Pvyya8mHWkKQquWfmptWpK3i1VQO8Ng62BSU6uSB7xE64R39Mi0SQJwFaW7mqgOmwcHAYNoTlLgeGPd4AK5NzVd3c2KbbNh26SP5Rn7XaeaD/7bpH1IYlEyVQhn523bLZt1rsNGVDu2ZaHMmKxwwc8DpxoRh5XwBR1ndkcIDZvZgcEieIwonZxJjp8ZjkYXTwJJXWMUAYK7sPi0usgp4c3xxJVZnSYDz/a1MlX+Ag9jnqOrGmMdSIYDg4pYoHFqDdZC2wdhZQxNqBiiZ/eR2FUlzsmXAdFEQDZSWKBMsE0ThlLvxfHL/SGqIcdCu9Oo01eWsFAMqcSptxCQybqpMgOoWQnIKU6Udr0qkeA6V60e2feDF776Ux4LWg/dW/JM2nRLK7FNcasv2/cGPRLfDYSbss2DuruUzL+Kjj9LdC5BSZ/SRy6RZwHs8P/7VhaEnV9zUxH3fpKEQUIJZ04i+90nrXTm0KrvOfMjglXmOD+Bj5pY9/HM0JMiNdr7G7z/Nlzx1ukZbpkuuxa2o0rOPLPbDRXh3xlAl3Pz87To/tgZ7oQw5QvuQ56WRfMa1OlJ69W0XYIQJkWLVUsy3ftVuVvRGmV8pRV3/rk2xJmuSmPXCVSivI0XFTmOhDgqu3HL8rdnkppN1D04aUFDjmHPYZz4M81+utXMNDP1y5ILUMJjCSEq+ue51D0HJjT6xodAp9rou3C1a0HMjnXGGXNfUz8k1RhY4cJaYkJ/DLaJ70DqgGMjh2/gRR/6pwo33okhz/uleH33evO5l5v6LXRPAlv9JIlOhJV
 S3hL201x
 26y82TtPOFwW69tp2+jq8Pa9I1Ie7DoMBWY44rlW7mJWnhMUGISniUg09SYy9LhTwMl19KFKBOObdSKxS1hvfQrME11rkMIJVlYbKmC5c6uTP7U8DtIcN0vSDUumtwQE3rwpLb1MmtAttDS75D8+p2B62C+ppYq7/f4dSHDKIo8UCFrnFpEi0/7OdnEElRUGcYaDbU99kWT2NOhtMdLB/oihQiy1pO7KT0Ee/d8vBJAMENEpxroKoYN7f9B2zbXjgdiDh2d9tvdHHNRXpei+KCPFQ6fyx+75crAxiSeNj/Z4kBaMWB0Bux+GdaJB98QfMGaxApkYq9zEuWytfiGZznocvsNsCiKEu+JhXhpUkibM8k1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Model a low allocation limit within the dummy memory registered with
memblock, then exercise memblock_alloc_low() in both allocation directions.

Changes in v2, following Mike Rapoport's review:
- Clarify why the limit splits MEM_SIZE, the region registered by
  setup_memblock(), rather than the larger PHYS_MEM_SIZE malloc buffer.
- Explain why the malloc-backed base still needs alignment.
- Describe the boundary in terms of the last usable byte and clarify
  that reserving low memory succeeds; the following allocation fails.
- Update Assisted-by tags to the required tool:model format.

No allocator or test behavior changes from v1.

Validation with the existing Makefile and ASan/UBSan enabled:
- Default, NUMA=1, 32BIT_PHYS_ADDR_T=1, 32BIT_PHYS_ADDR_T=1 with NUMA=1,
  and MEMBLOCK_DEBUG=1 with NUMA=1 builds passed.
- Each configuration passed both ./main -v and ./main -v -m.
- A separate BUILD=32 run still hits the pre-existing
  memblock_free_near_max_check assertion in basic_api.c, also seen on
  the baseline. This is distinct from the passing 32-bit physical-address
  configuration above.

v1: https://lore.kernel.org/r/20260906144011.848898-1-hi@tychen.cc
Review: https://lore.kernel.org/r/ap3LTQlKTpDbAEJZ@kernel.org
Review: https://lore.kernel.org/r/ap3NJsaG10rLDVpd@kernel.org

Tianyi Chen (2):
  memblock tests: model the low allocation limit within dummy memory
  memblock tests: cover allocations below the low address limit

 tools/testing/memblock/Makefile              |   3 +-
 tools/testing/memblock/README                |  14 +-
 tools/testing/memblock/TODO                  |   5 -
 tools/testing/memblock/asm/dma.h             |   6 +
 tools/testing/memblock/main.c                |   2 +
 tools/testing/memblock/tests/alloc_low_api.c | 148 +++++++++++++++++++
 tools/testing/memblock/tests/alloc_low_api.h |   9 ++
 tools/testing/memblock/tests/common.c        |   6 +
 8 files changed, 180 insertions(+), 13 deletions(-)
 delete mode 100644 tools/testing/memblock/TODO
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.c
 create mode 100644 tools/testing/memblock/tests/alloc_low_api.h

-- 
2.55.0


