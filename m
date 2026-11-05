Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C27606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ScUWjmOT;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ScUWjmOT
Received: by kanga.kvack.org (Postfix)
	id 8E39D6B05C0; Thu,  5 Nov 2026 12:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899F96B05C1; Thu,  5 Nov 2026 12:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670266B05C2; Thu,  5 Nov 2026 12:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7676B05C0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA40D80B79
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:57 +0000 (UTC)
X-FDA: 85401680154.23.27031B9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96302C0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ScUWjmOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ScUWjmOT;
	spf=pass (imf10.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=mB7keh2ZhloqbPcEVzPvfxcEyqnHL+lzcILZRJZPDCM0PzrobvlF9hcZaJbXvLi2wALijE
	W7pUYIyPE1tfy1bUBY2IsLTjN2StSrKAx80fOWwoj0JiOKvNQ419V162SoBz4kkxyy+d6E
	lAd32HxNDi4b1BA6rxqOOuHLYp+WKkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898055;
	b=RW+MS/HpYgseTwBDaRaQbnq3NHWNN7Y51mbvcOCid+2cbfbxdXdh4jZeu+GQiwpZLTLLd8
	Wn0GhmcgooBM/7tTAOtDnSBMmgPkMSN6R9XjyVQNHYg6YmqaNASu9UOmfdrIZ/qxwR/Cc5
	POqLsT74p95BscV/QbyIbI8+nYr0blw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ScUWjmOT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZcwpmL0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ScUWjmOT;
	spf=pass (imf10.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B07D1F8AC;
	Thu,  5 Nov 2026 17:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=wZcwpmL0mpdBmgeFbL6TAWnZ3KpTQAk2vo2FQaqARxV/NjrreaAfTHteFuvP5vnSOY7amM
	nKJNOUuuo1R52BYjaZEXW2XIJqDD7OujtciEIsvOGxb+8g4BRvs9oGHRuXT79wQ7Tn3aDR
	PQUKmDFwSlsxsL21YFzmFe+SgREGIY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=ScUWjmOTcEgPwuaLb0MYbEyHbeErNT48bHZn8A0DlZTs5+YrlWLTp9TJGYai1n4VSOYWFk
	EXlmgoMvrLJF8wDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=wZcwpmL0mpdBmgeFbL6TAWnZ3KpTQAk2vo2FQaqARxV/NjrreaAfTHteFuvP5vnSOY7amM
	nKJNOUuuo1R52BYjaZEXW2XIJqDD7OujtciEIsvOGxb+8g4BRvs9oGHRuXT79wQ7Tn3aDR
	PQUKmDFwSlsxsL21YFzmFe+SgREGIY8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898054;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=ScUWjmOTcEgPwuaLb0MYbEyHbeErNT48bHZn8A0DlZTs5+YrlWLTp9TJGYai1n4VSOYWFk
	EXlmgoMvrLJF8wDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 264B713505;
	Thu,  5 Nov 2026 17:00:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T3
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:53 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 2/9] riscv: mm: add pud_soft_dirty()
Date: Thu,  5 Nov 2026 17:49:59 +0100
Message-ID: <20261105165004.2663799-6-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: aujgp43thbhg7g9jwke79ormbi8q6jpk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96302C0002
X-Rspam-User: 
X-HE-Tag: 1793898055-294329
X-HE-Meta: U2FsdGVkX19A1hBWLJV4wlg0KYJB6yr1z/RmwwKlng8z95wfiBotSbRhnesdr4ugTo2wha/FwG3yvetOqw2UY6q681uJG5Lb71iDz/bmtZYz6HSISBuYhnczQ5JPBMVBcXoS7heOCdP9LMK0m2K7D/4+5QCTc/AeYoRa0XxwisDORVf3/+HSxIl4/rxIZhdukWo4AVcJdp1ZHdLAYvISJi7fu7flWApeNHLaRpRp85ekiSElpOM+9vPNjKcO3VjGUOj0SUJjuj2R/PweZ0u7UGV+K/SmqcXyOBNzjkjbdJVRBn51o8hBW9gLgUO7FJeiru+qzi3xX6eCvcYUEnD3sLc7TDDok1EMgy2SBtDzWQGfIojiNVPvNZepWSymp5kmKWp+FEfIJkbnhtndJlQUldoRqidv3Z2P4Cw+M+UB9jG+1AQ23dO3cutMo1FazU1TQ5QDAlrQFGbh+dRD8c61EdnsWsJLxPpAXzla9GgXeASUI5VnbLYECoP2Wm5qfQ48V9COTS5XPJjFnVJcZNz1hcw8BVZ3z0UE3+/Z6pFEFUDiKWPhXp/XxtUoZGASxhwHWedUxMLljgHpgxqEam9NpPqz4lXfUB5sHErjd64ScfvhMmuApIe2M3y+088DAlzCqHLfEAyhOyArEBZFJf2YYx2h/wn06zVHR/dzj81QIzLar9shrOAMRHoh0/4cdgzHAeGZSCmW0owzEIR8weARRTbjvGRKV8Lvk8HdXayq3lSWoz9NxpulZjXKwVE6s0TybLx57Dr5eXA+N8ChkfIaK7pZgU+shIMnV29GsiJ3CwO2CKJquai3oItZtrS1S9NBNHSb3frT05+a0Ngbvm87LCBIakRIEGWFQPpC+sGeqHasYRv/NF5Lv+Yhup40zwgGRBNMJ25OMZxTdJTNu5EIeVgdQ01E6HUveNNWMMLzg5pSbp9jlCeFsJt+XGJuAHWQNbXTB3I1m1oBCqntFdw
 nkeQJVpv
 lCqXjg5iMiohZqpgBtawnj6Bk1mNQUvbcw2SktpKge5eh/Ji/29n7aVNdDypW7enfFmWpZjkclCEuJqpdE1NeTEaec4NHFnG9KELbsAjgZg+YS6RN/Pj6UBg1cuhyHKopzZb3Wv+rFwLFLyagOJQBkCyY8JQC4jD2O4lcVoJRyr57aB+O/vzwAssL2u3gllRfAhH+6DorX9Whith08pyoxBdDhBRCL+y2s8zABCwc5SoCUIjVyuDdQ1rlXH6Zz+Az2UM8CY19xyCGe7u+bPRYdPacRw1GvbPwRCpUUtZD1ZeI6Q3wHCWeM0udjwUH9E1XrhZhQ0eN6yWDVB5IURU7eD3xWtaEurAgYxl7tEsrCZpg1F2kYhodTOdy/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

riscv supports soft-dirty and PUD-sized transparent huge pages, but only
provides pmd_soft_dirty() and not pud_soft_dirty(). Add it, so generic
code can check the soft-dirty bit of a huge PUD.

Signed-off-by: Carlos López <clopez@suse.de>
---
 arch/riscv/include/asm/pgtable.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2ebd5fa5adc5..40890f51dec6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -949,6 +949,11 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return pte_pmd(pte_clear_soft_dirty(pmd_pte(pmd)));
 }
 
+static inline bool pud_soft_dirty(pud_t pud)
+{
+	return pte_soft_dirty(pud_pte(pud));
+}
+
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 static inline bool pmd_swp_soft_dirty(pmd_t pmd)
 {
-- 
2.51.0


