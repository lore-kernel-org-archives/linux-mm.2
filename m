Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97735C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35256B008A; Mon,  3 Aug 2026 12:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D406B0092; Mon,  3 Aug 2026 12:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A4C6B0093; Mon,  3 Aug 2026 12:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD5A6B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 389C11A045F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:19 +0000 (UTC)
X-FDA: 85060531038.22.B3408BF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E73F20005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3x27maYe9sLm8bo0oJ7O8DP61cqoJcvabppJsnYlRM=;
	b=Wyf5YdpyVLZixNrhZo1+I/qNYCy0BWmnZQMeRBsK1bnYABHeD4D7z+H+oxwcMzdU72QZP1
	8bZMLb/SntavXNgdXQ+51rVJAwnFQweZkSFGnzbLSZxjMaTd2OQpTnc/SSZRXo91D0Vtj/
	BcsZsxet3GL0ekNbL9EM/AWnFZ25wU0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775457;
	b=xS/nsvxonDLHvs8U/seQY3Jw8qfzqXX2BIHc+yfJB9/w5rOgO6YLpx7q9o+hyyHqaikolh
	Q61xLVtQUYn/6To+t6aZ54kI9eEVcku5SuTUhU2l66RYK+WfEUp6hmCAAEH+txPgCVTSAt
	lXOVej88GR/i+YwzymoTlaXNljMLGoo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 05BC97F294;
	Mon,  3 Aug 2026 16:44:16 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16D3A779E7;
	Mon,  3 Aug 2026 16:44:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6IBxAl7FcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:14 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v2 4/6] mm/s390: constify ptep_get() argument
Date: Mon,  3 Aug 2026 17:43:58 +0100
Message-ID: <20260803164400.531199-5-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E73F20005
X-Stat-Signature: oz3tm7basr9d5fn13jqt6q8domz48f75
X-HE-Tag: 1785775457-120304
X-HE-Meta: U2FsdGVkX1/m8zXf21lKU3jemeTGRUuJ4J0buslgtWN7CIRA/YrLHIqoPgoem+HmxUqbKY6cZgL5DPSySR07ZGf9KEmPubxXEXJQs4nIcKHU+ZUvBoKhy3Ktij1VXANKWDUjzXNE7qHtS3l+V5cp9afkkWEB71/P8L/ETdshPDwbp/PVYV9l17lH6Ipu50HSGSZnHrNNqoP8BF3USCCtJgtEFzQc6few+8WkRINoIeEvKELRM4k/WNDuyI0tzCm4GMuqPeNIHLd5GQcTHkrLZX3Kg4fqft/NPkUOjGOaj+VI5aIPXFI7nbmNEc/12HWWuz2o2TIv4xtmSIc7yGfvwaJlRTY9la5aydtTzQFtB2Ya5iRsuvktU3HQsKjYU4Ps4gaQkyUsV0vUTMpuD5u6IDZFB0IRdHIUHFuSC8G2hWiw+uU59H/jFhr0xABM1qZlvFGWy8S2vZGHUIK0ZejR2gl47li46Fht6Mg/eU7QrxGFVWksCADNCxEJn9BEpATbQN9ZYMd18yWJwcNW63QIMcP6f2C7+slrnKC5QDIGo2yoNvzsMmQH0e1LEmox2XE1xwYhgsBtHcoNDvlHpcDDbAiXTp88D8vgItUyuc7NOtUMeKibDe1HCQxn2mxN9ntfsqSKG/s0ncNhrUsEOoyOMffWXuyNuZl0N2lfUo+HKor4YOAjer7G36nX/pMOnyTWSvDTYrtEghR1/ztMCCnLFugYiDdpitBuJPtR8ggB71tKAw7RThm0MA76ZiHqRfGzW9sbqT+IUkkvznSuE6/D1yyyAup1t/JL4H8L4T6lmc/YV425vqzKsGFyupag4MfyKc5t0rycc1ThHSpj/lcHgiGacW2/buboOW83njTYiua84J3Et5/MAuohghDSvVlgOV3jsQcv9Cc3A+3yM+8WUmqLlaMyKcWYOefC1g+yIwu2Er96hJqnre+0Y6Sb3y7y3HwTHEMUhaRnLcbt/Za
 vqzbCA5l
 YYQrTbAoQYH7a3vyn79DhgT5SXnecY2AUNwTm/NLXtPL6/Xl6DPBDitHxsMFYv3vaPB87NXOVscChNu/xHdiNg3cP62dASvDBHUDR3xObgnMO4fA1TdP7uBd7YX2770uPlBFW/mQHVO7XLxZVKpyHQkcLK2TULvxdeRYve6kxMobbvaYMYzMeYVYUkLjbjSyk4yasXgT5CeusxWFIh0wM1sCkeehmY0p2+wa5KdOo8JfbBGavJxOixRkSQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's a simple READ_ONCE() dereference, therefore it can be const.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/s390/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e882663a58e7..ec331ec92943 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -986,7 +986,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 }
 
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
-- 
2.55.0


