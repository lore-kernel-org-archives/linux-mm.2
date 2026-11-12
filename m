Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D830460A262E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=pcu88trj;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=pcu88trj
Received: by kanga.kvack.org (Postfix)
	id 09EBA6B05B3; Thu, 12 Nov 2026 09:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EA36B05B4; Thu, 12 Nov 2026 09:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6B16B05B5; Thu, 12 Nov 2026 09:25:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97EA6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35DC71205F0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:36 +0000 (UTC)
X-FDA: 85426690272.02.174761C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3321E180002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pcu88trj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pcu88trj;
	spf=pass (imf06.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=qFfSB5sKEIWuEbPCdy4A85SPp71FZUUjDKZ4gAFVc9+Gv6ZClTS1PowrxUj3/sh24gk3Af
	9zBxe7EKeeHyPoDEog7+QykCVpS7hnlzvjf64KAvJ+WgdZnkNv/c+OZPgQqOTkfjtHB/JI
	s5+Vw9dvsyNXkiOlofex9qDHfu1GyBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493534;
	b=XVbyKr9itUCmWWUP9T1qXOfxF4hlV5s6s0O8Cp7Nw/Acq9nIcWwm7viZMh9PnTInZouy0X
	h81JivJ0iDnfNZ5SE/ZzQ4t+qb/bI99pp7GZesjU8qfdMCVQhnD+R/guPWWgadNFhdYPMQ
	Bfm9FxxC1T+Cs2UXKJ1/WjrjbyWpUqE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pcu88trj;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ1JzRmh;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pcu88trj;
	spf=pass (imf06.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2297F1F8B4;
	Thu, 12 Nov 2026 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=IJ1JzRmhJB+1jyg5pCgn5nlsjCZQQcblG2IgVIsUEyxmDSn8wbK/iDhbqzwvP4PQj8JFF2
	XkLhsnaARIvc9iasv/O8vDYAqgAizdDeAMQSBG83PnKfbHi86DLayceFpiiniA8zZr0JQZ
	kZ7WA1Mfh5AGJUs8JY7Xr7QmGVd4nfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=pcu88trjNhOJVGCafuuVQ5n9cn/S2UvWpMZdS+iHleTTMFEQhC7gpSLC/y+B8VP/75G/t6
	BfmLZW/EyrOPx5Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=IJ1JzRmhJB+1jyg5pCgn5nlsjCZQQcblG2IgVIsUEyxmDSn8wbK/iDhbqzwvP4PQj8JFF2
	XkLhsnaARIvc9iasv/O8vDYAqgAizdDeAMQSBG83PnKfbHi86DLayceFpiiniA8zZr0JQZ
	kZ7WA1Mfh5AGJUs8JY7Xr7QmGVd4nfE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fSNuCMsN1VNgtr3D4qnj+zDeO7DxOLUKfJqgOoVCVPU=;
	b=pcu88trjNhOJVGCafuuVQ5n9cn/S2UvWpMZdS+iHleTTMFEQhC7gpSLC/y+B8VP/75G/t6
	BfmLZW/EyrOPx5Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F14A0134F4;
	Thu, 12 Nov 2026 14:25:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T3
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:31 +0000
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
Subject: [PATCH v3 2/9] riscv: mm: add pud_soft_dirty()
Date: Thu, 12 Nov 2026 15:20:31 +0100
Message-ID: <20261112142039.907090-4-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -16.30
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: ymq8axeke3c7xgafu98qsahfzkr5rc8z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3321E180002
X-Rspam-User: 
X-HE-Tag: 1794493534-881226
X-HE-Meta: U2FsdGVkX19cr0MK8apNuqt9Y7+fLX1aQFCznNFDAwwuN9U8jIn9b9nBy1O0ZG2MJd5sKSaJPZ7w342lo8WM0uPiZPou/0LOtHgY87TnwejFRk03L7I9pAV4U3ahZMFH2QM7aY0fwMBsfrTpw10uDt6k/gH/wQ5Ofn9oA0P37HD57wf9BXKDCVwZiZofh6HFTxqmx3tf2FryvqniZeu1lN6slU0XmisA7qXIOTbWgu/S626Zz22YPJoYFuoDLtFREFfm8EeVMbQhNZJzVJoN9OxLAJp4lxMdMj8JMEnUsnwl31rFzj7ExOQu73PLbif7DloMSlsesqj6fWe5IfPEUzjmi6ZZMt7mCBTOjrMbzeoBGpDjNbtNsEJMnLxqhvVGoXwdu1hZ7wd7XqdJC86v3F5+TVRVfgyc+dD/GEQuHsP2yh+OniSfrOopTq/W8fhvE854EdYRNPxX4CFkZJdsF73qnztgnz/F0IcKU+WJxpWa+REbUpT38nEW/4lJhcpKiryMcMio7096u51Wayrp2GC+qHk5BTyXRjUY/kb1JSXzQL+xkpWkQDSwwtHh9vbusOkctHsp79b/Sy/YDxKDO1UGW92hOp35NP0eJkVuTcdyJc3d/0LhF4f1ZpBzM4tA6/Ix4y2+eWU0RTlWpHbPsq+BdyPQiR2FRHa0naTDIv0AXYvBIO/y/3IEMsvqzrkz50RT/1NgFJtv6M7SeUxceMR7WLV5VxtAmqGlczYN23v9Sgw+w7GYYqeEfY0AVpLAgNrPHb7EPXoCe3d9A/aUGvhUAxtrPoyLFX50SAMp1KCc5y2U1mMCUcIAcV6LFnVMqr3xD5lZbGgIfKuzE8FnSoNe8hcSuKF7ecm/KS+YnRgzHAbjRI8w7XfRy5xBbZa9lUj9M19E7r277OgVWUyc6eP0ixO6AhE1zK4galZCGksURisWATmNRbuakGk40JAxA1ciKFkc7BOEop9MHH5
 nFVaKc04
 JBC6f4LBqOAnv+qYlTWwb358GgGiObaRcrgPSdoWUf7jvuLOAg1jjtMvCp6j/u3TuhFyvzTH2b9kULcrNSWd03fQHOBLtjwElGPEETZiKKAIkhnOicTeHVzSulbj3/7vUc75aOUMi2kBF15jMl6P1HhQk6sQItBo7uM41sRCXAgvxgW9MKMSDTFSY1rd1pIdpnZmQE5Y7NWFBeE4OKAYq/xtSJ+Tt09RwGWoOaHKhqFdu8r4jYy8txzsqgcLikldhncrg7XEnQieJ8d1pjtcV+P8le15YcvcmvDa5VKGvW+jOThx6OUOwSDkN+3sRaASrvAek0TOIpp22j7i29B0tBnZFKZ/UmMQ1fTWoiPWpaO8b+gZk/rEUaGbaoQ==
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


