Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CBAD374B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F4C6B00B0; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6146B00B3; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B860B6B00B1; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97CA36B00AF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:17:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33A2613A9AB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:44 +0000 (UTC)
X-FDA: 84186981648.17.6132F0F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41D1716000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:17:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UDTOFCyk;
	spf=pass (imf08.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejrce1XdxpWJWHE5Wtt1V02tXeXE+vjGDq8qzCrERNM=;
	b=ejh7pX0LR1SKEoffwe8ofWrK4mPm3KkIX6s1Uul24Lp1pDmt+m3LAzIaSPcWh9xHFBE9/W
	94LMp21Ss7V0ara2kLtAuhQXLQwa/n7H9U/UtW9s4W9kQqsN9u3bWC3FRi0I/uVvjbXx75
	W3CJtx75N9qgy4szl7PmykXz5OtI2R8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976662; a=rsa-sha256;
	cv=none;
	b=kgVcTV7tl5DZzrUMvE2Hsiwq4QuIV4mm+TssKkSljV/LcHaKtRhhnEqV2QPrZYaeYkZXKB
	JIleBK6Q+sylU15z7VOCnhuUR9c9T31N3XV3H/GYbHaPt3k2NvARhRyxUov5qVijWCak8d
	D/rqYa+HyaSmuupNPUYgxgToulhYy3A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=UDTOFCyk;
	spf=pass (imf08.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ejrce1XdxpWJWHE5Wtt1V02tXeXE+vjGDq8qzCrERNM=; b=UDTOFCykey2R4x2elUbcoVM3Rz
	MyYhKVZ/cUjO++zOwSPvfeiWj/kUke3gfaRIGzNP74ZI5YSuPqgPFX8IR2i7vOfslE+++i0/Fx5At
	YIJQvjSD6hSqmVX0lEZkxp4m8WUvW2AfRGRsRhD9urL9prArVeXKT46tqDebyx4ASMFX7A5Iw20rg
	Kau5ByoyZB++7okKue5brOeEzqXy9gEuv8RctToi9OqpawawA06uUpt+gGM4vns/f01WuRBwmvWdw
	TwjmqIm4uHHxjoUOb3rCwxCL1beCuLt5cH/DjulA2LeFDz0SmEzCpxIVp5kaRx03fe57afvIyOfbl
	YHAGRsMA==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3P-009H1j-0J; Sat, 06 Dec 2025 00:17:35 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 2/9] mm/page_owner: add parameter option 'page_owner=on,swap'
Date: Fri,  5 Dec 2025 20:17:14 -0300
Message-ID: <20251205231721.104505-3-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41D1716000A
X-Stat-Signature: e4etgw7s593fhybsgs9r77xzcjunuzh4
X-Rspam-User: 
X-HE-Tag: 1764976661-95301
X-HE-Meta: U2FsdGVkX1+xGa1mjgz8zQP23nJ1MRPn5sTLFmU6eDdmeitCMfHqULlj5AAsiiH48mKVrWEndHdPA2TorSoZhqMYpR3OgtkVzxYcTx8k3KQ0ju3ZKmRD3+FSP5xBd8cOtIqG4d0lNt5SZ44FWloS5N5m5za/W4icYPw8BiiNfUpWxeeSIXs2yUjUq3iSVvUb9Ylhd7zdJLnD6kSbTGVkTwbJi6ZlmMVUCDIvxJw6kqEZNtD+31hC7qMsQRZNqwWYumGpuoMMmweos4wF4y/wgWDmlKal7WlKOWMUhtwzPCOB7OKi+DuWtnBFoV4muwy3kbHDkuIiOz74JQ87tz5RQzDH9X8WLJXxfUNSMFWZYUdcq767AGJCnK69CMLfA/a1ANz1cj5fmd2o6ADsTkJ3FjXmKBvXTvQf0s9MkyluxXzPlg4kgL+Y8TncoAxnp0PWH3edrLWfZYMMPVdj9so/dMdPNGxRk3UPLDi5CwlyFoiBE4jR5un6QXlr38RSarqe3KgGUlHbQ9Nh/J7J9efXiwdw52t0pruTs1YlMJcylKbuklOy+ljrkyqsL8UJEu4CKm6Oykns71cr8nN53CwQKgfN3nWJfw89yRyvNRTMDUPSSZpWEHmeXrnkree7dJn2hi22/C4kYegc5cKshzjPJePtVifzAD8k8W4dyy9S3XGKDk7Boz6pqP2x+prxKiiwk3LcM/gqgYzbqm6bNz2AhAFHeTJhCmI2gVUQPb490MTGfDa4aSmp+ZTI8kBTjaCLbfMp/zPyl3Qt/N3pbZJmL407Pt+Nsgo8GfsuOWtF/pTdUsJ++b/9AEh49acdQxwbqvdPXuA7284ub4Tjqy4q38wr1nGp4NAmOWLbDIRfZEfzPslM2i7T+Zr5G73e2SWGY/9VwD09Er2CsoVr7cvuvGrtTMBdLZQ6gtMPsjg0O8u+FXLMZYp9qofLtQ/kJ/fZ1XDMHCsVXEHhEr1D7WS
 4AvDas0C
 TcRnAYStBskGyF9rWkwrOq9iAaYUaEki45KDjbC9dm9CTLcf9V/Hd4/q06UShdd5Cjse9ZEJgYvvbWkA23VjUokhMVvy8UpMvXMWBjlmHCgAFxFSjycjrW6q6MyoTjbFaxyKECSSXCEaFok8OWAvz2Qpb3sdnMcXuENhJbUuxVmIxIhLe21OgYD1QQcKBZeC74ddiu0+XMkaNa4fwscGCbfxcRgVur8KDJ2eG1vPOTr5sr2DRcu7869q6zoPnE1tXeuAgCZUjCCzXm7aSCBdLf9CyILgiTuKN7XygdY9lsPcZb/7/vMEHQpxmGAFN3CoajbDn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_SWAP_PAGE_OWNER will introduce a behavior change in page_owner on
systems with swap space. Thus, add the 'swap' option to the 'page_owner'
parameter to enable it ('page_owner=on,swap').

Currently, the allocation stack trace of a page is lost at swap-out (the
page is freed) and reset at swap-in (a new page is allocated).

With the new feature, if this option is enabled, the (initial) allocation
stack trace of a page is maintained over swap-out and swap-in, and the
refcounts for the initial and swap-in allocation stack traces are adjusted.

(Note: 'swap_page_owner_enabled' is parsed before 'page_owner_enabled', so
'page_owner=off,swap' could set the former but not the latter, but this is
a nop as then init_page_owner() returns early and doesn't enable anything.)

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index a70245684206..a27958872b07 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -57,6 +57,11 @@ struct stack_print_ctx {
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
+#ifdef CONFIG_SWAP_PAGE_OWNER
+static bool swap_page_owner_enabled __initdata;
+DEFINE_STATIC_KEY_FALSE(swap_page_owner_inited);
+#endif
+
 static depot_stack_handle_t dummy_handle;
 static depot_stack_handle_t failure_handle;
 static depot_stack_handle_t early_handle;
@@ -81,7 +86,18 @@ static inline void unset_current_in_page_owner(void)
 
 static int __init early_page_owner_param(char *buf)
 {
-	int ret = kstrtobool(buf, &page_owner_enabled);
+	int ret;
+
+#ifdef CONFIG_SWAP_PAGE_OWNER
+	char *swap = strchr(buf, ',');
+
+	if (swap) {
+		*swap++ = '\0';
+		if (!strcmp(swap, "swap"))
+			swap_page_owner_enabled = true;
+	}
+#endif
+	ret = kstrtobool(buf, &page_owner_enabled);
 
 	if (page_owner_enabled)
 		stack_depot_request_early_init();
@@ -138,6 +154,10 @@ static __init void init_page_owner(void)
 	dummy_stack.next = &failure_stack;
 	stack_list = &dummy_stack;
 	static_branch_enable(&page_owner_inited);
+#ifdef CONFIG_SWAP_PAGE_OWNER
+	if (swap_page_owner_enabled)
+		static_branch_enable(&swap_page_owner_inited);
+#endif
 }
 
 struct page_ext_operations page_owner_ops = {
-- 
2.51.0


