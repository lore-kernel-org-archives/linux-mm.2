Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88CAC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1566B0092; Fri, 24 Jul 2026 06:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1846B0095; Fri, 24 Jul 2026 06:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1AC16B0096; Fri, 24 Jul 2026 06:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D076B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED74AA108B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:34 +0000 (UTC)
X-FDA: 85023275988.11.B2BF88F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03937120009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q1RMzMUl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFLIuEI0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q1RMzMUl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFLIuEI0;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=JKHg9624IS7Q5+VYc+ijKH0WpXofSxktp9wcomjN019NqJKu+9YYJQE9Yo3Zcp0IT9TDpX
	E1Q47iHPVtepJ3HycZcjHelLNj1fTB4EGxMVDD0HvPkxzJoICSJ+HJhJ2Pfj6etqdn8r57
	JGAG5NB8IuW1TZVo/3hUSiGy+y0+eyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888433;
	b=tR4gcHGPJXaobM8+2CyzbcImJUHUCQX1vhmCrpywjA0XgBhkxhzr2kvS/z1IYq3S8PnL87
	7uUbVZO0iYHlZ/r7sRBiBSw6K1UQIN56swxk2Ujh8PLQPWxmVsgwi7J+cHaioP9HyiCJKg
	613s/futrCQXh2EvQ8q3i/p5hCY+8g4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q1RMzMUl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFLIuEI0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q1RMzMUl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CFLIuEI0;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1B443E87;
	Fri, 24 Jul 2026 10:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=q1RMzMUlwCrVMfVNtSiCUY4CDMkRnRgyGM65TVYOQADInq4UOGSp64phdLPTVxL0t04tnE
	MWxUaOiQWD0Eb72Ky38+/9WYZsDTSJZe2zI1zslYOn9ZENrMmp185IWgdTQRYnewlQgu5s
	zQDcgV3NB0RaSLjD/OZsYy1MWdoUGgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=CFLIuEI0lsvi7etRaA0czxajNB6MTttLI1tC7g3rtn2pfl9hGJKffR6W1KeRQqV6OGSXPk
	rXiwymbw0JJHXmDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=q1RMzMUlwCrVMfVNtSiCUY4CDMkRnRgyGM65TVYOQADInq4UOGSp64phdLPTVxL0t04tnE
	MWxUaOiQWD0Eb72Ky38+/9WYZsDTSJZe2zI1zslYOn9ZENrMmp185IWgdTQRYnewlQgu5s
	zQDcgV3NB0RaSLjD/OZsYy1MWdoUGgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VF9+9aXKTFOiyKVpG0eaSz51PqWtaVxgoEgQhQrqJwc=;
	b=CFLIuEI0lsvi7etRaA0czxajNB6MTttLI1tC7g3rtn2pfl9hGJKffR6W1KeRQqV6OGSXPk
	rXiwymbw0JJHXmDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C13D8779C3;
	Fri, 24 Jul 2026 10:20:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iM7EKm08Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:29 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/5] mm/powerpc/8xx: constify ptep_get() argument
Date: Fri, 24 Jul 2026 11:20:16 +0100
Message-ID: <20260724102017.141532-5-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724102017.141532-1-pfalcato@suse.de>
References: <20260724102017.141532-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03937120009
X-Stat-Signature: 1gqjgigmx89k8ngzghu7iogs1p7x1391
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784888432-242436
X-HE-Meta: U2FsdGVkX1+7jeTcRMtirzg6+U9cWOR/I8jfcGd1D96qe3UPoSe6CUqxUXrMkl2Hep5MhpX4gRA/lY5cqgaEohx494nQe07zSAHrgNVly68exXAUs/1yIiqVRFnVMyMDdEF+yNPxu/Yp8q8gXrxS8UHA9deTddj8raD8umr4B+FeTO07jtnWIqN9gooOzVWkFbQ18FifyPaiboeiWu3Uju+KVtr+nOJb2THZeSMdwvO2GX7OyKMLmPoVoXFgWwV4kMfV1nck90hv9kqPnEdYvz0hwYlrvXN/+N4wngVHWLCMLv/QbnGplVo5KzSyvAOuLtHHS9bMy6BSRtQNoQFjRqcolmDM0EG4Gjo1WJF8ZyWemm9cvTeHnQAMp2jlw8ifIuRuLNoIT0B3PhYHmZS4U7UKb8sKmqEI/sxSv8dUrha0gD3RNpljpJuUxw8ri+RMIpp7d4c27tQNiMuK3BQ6vlLodhwVKRdPblL1kAytRo4Jzl5pGhKuGm7u0pWFqOJzQM/v+UHavZSrPuGqpYKiKsdp82dCajbzxcvKUCi7TULB8pHbjuekiwNydz45Wu6fUvEu9u6u4gtcs+JgI/S+TuTVE3oC21s3XPNsAYTILn/uVGMi0RfbsrbBJT2ZnrhmuoYpAAUEiV44zkBtep+ZXy0/O5SoC/WZl97dI5iBxkjGCn8T1yn3r6ad0BIwK3wcRw/kkJMNSHNYQ1z0hC5lW8SpB2OMUXbP4QT6QHsfJWB1tpu/6VLwF2qqkxuXU1eYgRZkbtnn5gCXLdCvSFhzosVTbN4ISGq/kVMEmc6wirYKIZtKT7zhEgIiE+Vuq47/xHEswhHjG/lgO5GIEY5tRqYLJtE0M1EwiPHhxiJX2jIM+aq4uZndJx+FAMQFo/el04lGRPClmW6gMF9LFBnIkfIklZkSwzzoHa0M7fyBF8a69PYDpj324Zk9gfA7eJ5VT/rPqhd8opO41jNnnUe
 hsoCFJTA
 /t2nLErlsGqCrMn+DS9mdzvfR1+9HngIUrTdAaTFf52131yOm0/Cy/q6Zw5KzDzK6kF0It3Nd4xa9Pm1Stu4OR+6Nkz85s1AcAq8Rb1aLQIP5d8zIY/e3TNhXfD5N0VUu2ySKX7e59mes+tBFIxpo+xaHH2VU1Yi5hC+Xr4IzlnlnLQgG1lRyNhTNQ+o5CuMq1D8XXU3dJaLQU9s1EsgAF7pmFl6luBy2iNj2TwpYb8weKxOBmPokoco1SiMvkyMA3uuAGLRc/AHwTO1nWDQwigS+4Yy4HUOD3sbr7YuS0MMA9r1EotivMeN1jGLFvNeNQAS5kHdbtAC9/DnPu4thw9hi9ZJTVKAON3VhkyD+4+a0N3mjPupp/DUuKPTSZW12ofCgAifw9F2oKypHIXk1LT4htw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need for write access to the PTE.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
index e2ea8ba9f8ca..f2bab31040c7 100644
--- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
@@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
 
 #ifdef CONFIG_PPC_16K_PAGES
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	pte_basic_t val = READ_ONCE(ptep->pte);
 	pte_t pte = {val, val, val, val};
-- 
2.55.0


