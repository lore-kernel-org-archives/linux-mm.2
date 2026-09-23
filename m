Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADA2C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD956B00A5; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E696B00A6; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793526B00A7; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1756B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:32:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC63380672
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:03 +0000 (UTC)
X-FDA: 85243452126.08.5B10F1B
Received: from out-zbxj-a71.jellyfish.systems (out-zbxj-a71.jellyfish.systems [198.54.127.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id E310740007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=G5wmWHGF;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf04.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.71 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOXnInNUODU5Lzwbj44QgpGQDJ5UdG0pb1N+gcZ3ygM=;
	b=dyQhj+MpD5RaLRV1dcI4rwjafwTWU71By/qLbOqZYCxKUUBpqKoSq2GgZPUmH3YaoGcvda
	05jfnoAc/LCJbG8zMnd1Fl0UPm7H8adEDLMReCGM68H+DbM6we658r2XyBCE8nvXkSB+2M
	FAb47pVYc5g/YhxH2PQx4ufIWnaSwY0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=G5wmWHGF;
	dmarc=pass (policy=none) header.from=tychen.cc;
	spf=pass (imf04.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.71 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130722;
	b=Q+wupb+P6TOXovYE4vVzN7Ob1SvotM4QnsBF0RmvLR/qBbLtvn3sbxk6Yt0Er/oLwt8Eti
	ZpR+q6Z6j25OyRo4LJMdwqPSszdbtZlH8uuD1CCxUSFebcIGnj4FQ3ugwpN4BUSp7GAloL
	T+xUyN9I3DDXY8XGWbAu5BQtJl/EYUI=
Received: from fedora (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLZP2xcYz8sYH;
	Wed, 23 Sep 2026 02:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130703;
	bh=yOXnInNUODU5Lzwbj44QgpGQDJ5UdG0pb1N+gcZ3ygM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5wmWHGF8x5Fjt8JXLIilAfxBLUl9aQ34u42tdylL7dNFnoM1NAqY0nWyDDx+J9yx
	 fljLl8gdfcAKGAoO9WyBRPyJoNOCD5+BqPI+iyloAdpemuOe4MzU0THBcoz/JBisi4
	 TI8CsTXrHcTHpshU1yOCiiPwYTKWdYSbmza6yeOY5oiEZkb+eoiSajTeC2dkPnAVxo
	 s/k5vnjcacO9S8zSilBs9zOwA7Ar2A+9aRXWn3aagBwiOmWna9bHrvEOEKQUIQ0B3r
	 RlLNzSWPlBYcUGGMBFkZn6CpRIsCU9qQLPkk5IA8lPgRlj965ZI6YmktGqWBm73Fvs
	 z89vhmX/xvmuQ==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] memblock tests: zero-extend simulated memory addresses
Date: Wed, 23 Sep 2026 11:31:24 +0900
Message-ID: <20260923023126.1910311-3-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923023126.1910311-1-hi@tychen.cc>
References: <20260923023126.1910311-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Stat-Signature: 1nw75ic9nkai6ukpm1gpbmgw5dahxgxk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E310740007
X-HE-Tag: 1790130721-685026
X-HE-Meta: U2FsdGVkX1/9eiNhvLfz0ltqlj/5dpFmwPDMG7lswVpm1JvKn2qyH+LgsSyJzfXAvPtVXASseBSeYP5iEhj9bDaBXtIxGkBkacRLHrpPjTpAW40jLjB7sMjVmxg3EcrR3HmkKtL8E60Dmi5EgBUw0S0d0LkPzdedpudF1sKt5Uarf6OflqfxHUq9nlBWEk5kR16X/t2jQULcqf3XWaOdTxw5+5tmmEft1B1S5phex7ZL2RVPOW76SyMjgX1GCPUv62ZfDaK0VhiDBR1RdK8g09tUY3l7HyNfv6rXDN1NorKZHEFXB3BeRBZ87RRYSEHl1ASc+YhlkWVYntK7dCG+XN90V41V0Q8tC1w/1jG59gqIYhH6Ca0r1vHDeSqqYZJOJebKT/pT6UDBDIE6ZMYwQiKPVlrpv28zL74r0jHoZW6AfFn9EDU6kP404rlJP3y9+aMabYLaDS4DHIgzFfRD78OPr9K4lz6C5+fq9eWFWu4XnrBviW9rcnDUWOwzJeDA0OiyEn1QMAUsjymuTItrkLn04rNtF80yE9C2HVg8Im1LQ6wVe1W/Dsf+3fnVs+BaaFOxRk7f2s3EOWGEqqGvWNP/TIjnLWbZPE27v6MUVuM2bQbJkazqxM+v8aFEtflGHRU65Bz/K0avkFJcXFZNzsB47tfibcxJikHu8VzBZRwZVLhoKIddoInYVatv2CSCzpqBbPe7umg2JHMPEpVYFD430gYHMccEqvw9RTWRw4wMJ7HfkSPG9gXth2zRc+G+nYW57UAV0+1QK6r8pc4YhYbGFT+jOyiAFrKp2YxjCl9A9lwn44dsERjla5jtz5eJYlngNTqPORfwp1AE+WTWzK8ViCB2h3lAdYUbgMEIqS/S3z5ehsI9HehqP6lrSsZ74IC9PRy8xJumnVFPRUcI6po+s/uZTMhxHVR3hLms4xmlP3qea92qt7oey4snp4nF7Y4UU79P9MZqaI3CP8g
 xQEbtYlE
 GP8o8WzGcV662a4Np7Fm8dep6Cgn12ah+tWk2LsxzkH4bItQCTRbAN1dubEX5TdpAPBR+kwhhcnCMNHOhtt8/1HSI9xG6qWOYDulVL9L8XmfXmn46nR6SCzTDGrYYlDWJ8LSLFItLhOvU9L2TXy1MmGdy6OiB+zuS/MABZSFdD2fmOOotqzUPYCR5VOGPFXL0Dhm1ElS16e6csKXA32Jqe+UOL/b2NvzeKnpJtih4xyjndismg+3aoLlB5kJ9UN1zAKpW8lzsLHGoKaarSFOlRRqYipy+e2eb2lLT6YbgDCZSA+uQ1FXjMc4WheCm2vgV2oMPYHJoBAVJUWCicZj9RTdTp8n+crnMjra8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Converting a 32-bit pointer directly to the 64-bit phys_addr_t can
sign-extend it when BUILD=32 is used. A dummy allocation above 2 GiB
then gets registered at an address different from its unsigned pointer
value. The low-address tests compare that value against the registered
range and fail once the earlier maximum-address free test is fixed.

Convert through uintptr_t when registering and reporting dummy memory.
This preserves the pointer bits and agrees with the simulator __pa()
conversion and the allocation tests.

Fixes: 284d950dd6b0 ("memblock tests: Add simulation of physical memory")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/memblock/tests/common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/memblock/tests/common.c b/tools/testing/memblock/tests/common.c
index ac032610a56e..2a248973eb4c 100644
--- a/tools/testing/memblock/tests/common.c
+++ b/tools/testing/memblock/tests/common.c
@@ -67,7 +67,7 @@ static inline void fill_memblock(void)
 void setup_memblock(void)
 {
 	reset_memblock_regions();
-	memblock_add((phys_addr_t)memory_block.base, MEM_SIZE);
+	memblock_add((phys_addr_t)(uintptr_t)memory_block.base, MEM_SIZE);
 	fill_memblock();
 }
 
@@ -88,7 +88,7 @@ void setup_numa_memblock(const unsigned int node_fracs[])
 	int flags;
 
 	reset_memblock_regions();
-	base = (phys_addr_t)memory_block.base;
+	base = (phys_addr_t)(uintptr_t)memory_block.base;
 	flags = (movable_node_is_enabled()) ? MEMBLOCK_NONE : MEMBLOCK_HOTPLUG;
 
 	for (int i = 0; i < NUMA_NODES; i++) {
@@ -115,7 +115,7 @@ void dummy_physical_memory_cleanup(void)
 
 phys_addr_t dummy_physical_memory_base(void)
 {
-	return (phys_addr_t)memory_block.base;
+	return (phys_addr_t)(uintptr_t)memory_block.base;
 }
 
 phys_addr_t dummy_physical_memory_low_limit(void)
-- 
2.55.0


