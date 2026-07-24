Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AA5C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBD26B0095; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D616B0096; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33EE46B0098; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0514A6B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8199F120330
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:39 +0000 (UTC)
X-FDA: 85023276198.12.D6F9965
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48716180004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vs+kw9XE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lmEz/+Om";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vs+kw9XE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lmEz/+Om";
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LqYKL1KgQiaZNKY91FKHugSBLG6nF0qcbOPSXZEuCiI=;
	b=MyL2v1JQJdPU6pfBtFvwMr/45sYkECVpfO2f9tAkWpkOg/0EnO7WXD4jfdOTQTG+nCAhR5
	OOY8bUru5EVUpqBZuuN/LG+32VKPw3Via6XtvD3y9oIWAop0RYWZ0cTurAVyiTYwXDgl+T
	sTh3xqVQMIgK8j4Yb4k38dC6PykXm4o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vs+kw9XE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lmEz/+Om";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vs+kw9XE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lmEz/+Om";
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888437;
	b=Ld+ghDeywj47QrZXTduncuWE/vRTvNhMsaJJzOjQtmxIG3Xo8skjPHECOPZroHvT6tbQ4L
	AAAsuD0S6ohgnnEvgXlBPFi8VM/jWjs+eB+ErtmuT1+HvLYwuRlwcddqMMecYC6Yv+0LCg
	zqs2bSiqwIvhPQ8NuIUptSemxr7ORLo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A46FB7B6BF;
	Fri, 24 Jul 2026 10:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqYKL1KgQiaZNKY91FKHugSBLG6nF0qcbOPSXZEuCiI=;
	b=Vs+kw9XEp0WIG1GplyD6wndNLF7JOao5sUI9f2Aknt9wvbPAnmHbgRtvf4y/Cl/cbqjvo1
	pSp8MsYB9TK4AQRP4vovt7vf9LWqjAJvJkNdoZpA36jwN6/x6ZHiXfbKUM8arLNd4jAW5d
	75G8R9dVlLWjfsQAO1SwJwEs1KFisYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqYKL1KgQiaZNKY91FKHugSBLG6nF0qcbOPSXZEuCiI=;
	b=lmEz/+OmSqB7GttsygQFgnq9zXB5TFHFXyPu+rHe2bVlCCkLgZnVDL0JonV6nnpIQAkYuo
	STPU2rfco6AuepDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888429; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqYKL1KgQiaZNKY91FKHugSBLG6nF0qcbOPSXZEuCiI=;
	b=Vs+kw9XEp0WIG1GplyD6wndNLF7JOao5sUI9f2Aknt9wvbPAnmHbgRtvf4y/Cl/cbqjvo1
	pSp8MsYB9TK4AQRP4vovt7vf9LWqjAJvJkNdoZpA36jwN6/x6ZHiXfbKUM8arLNd4jAW5d
	75G8R9dVlLWjfsQAO1SwJwEs1KFisYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888429;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqYKL1KgQiaZNKY91FKHugSBLG6nF0qcbOPSXZEuCiI=;
	b=lmEz/+OmSqB7GttsygQFgnq9zXB5TFHFXyPu+rHe2bVlCCkLgZnVDL0JonV6nnpIQAkYuo
	STPU2rfco6AuepDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CAC6779BA;
	Fri, 24 Jul 2026 10:20:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gNvcEms8Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:27 +0000
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
Subject: [PATCH 3/5] mm/parisc: constify ptep_get() argument
Date: Fri, 24 Jul 2026 11:20:15 +0100
Message-ID: <20260724102017.141532-4-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724102017.141532-1-pfalcato@suse.de>
References: <20260724102017.141532-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 48716180004
X-Stat-Signature: f7n19drehhochm9mcwzkbpy31dd48uqo
X-HE-Tag: 1784888437-508719
X-HE-Meta: U2FsdGVkX1+xVdsXLbG6jJXSUg1hY2cncs2ZMldJ4HGKME23kDAr4NdU6mkjUlQE7MEjwLS7DSpCi49J6K3d9uFnI4j9JnCIZ/XQYwYTOU3Vn8HeVpsai8L9LZH+UiyvPQV+Cg7wRGrzjtbeUDHu493BrobXxZxh+BTC7BAriL+Y6pK6h0ATwcYKvb5loaB29he/NJowP5BpPbUCE1UFDzdwszbGFfUSXGLAsCPLIgLqPYptq6GlkUArMdnJiCnxL7gq4OwrQEkmI6QiHYgd6gEv1UPpiqh2/wQQY6zzqh4IJKEVNYADnPyKApJU9dM+HmLM6FB1j5RiOeBSkxldrwnN8oPKQGZoAA8HYCjf7seP+BnMNXn1S18ss6mUMRj17paM1c1eQj0C/7LmbiF9iHPNnuvB7C/irUo+eSCvvNVIIcSzyLgcwOLVQkz2Apjssc5zLlH8sD2YudmPSIUVhmFMpV30QhWJ6zu0rbaMuJVIVeQYjIQYU1WDRu87dhPIPCRFMrI0EIw70F+B0MmhpSsGpsryMPsr9gAmrK4EAKFsii+uiMC7vGJdSy/TnnfNF6joKQGPSgfyIUBmT0hYbUuuvHBCdg20yvKDXeHe63giyTD9g0IEIsGmOAfyBj4hZnaUX/Q0okF5Zk37KKZa9uvVEkSPl74mkGKEw1iMNCcTKnN1v8VWncK4kCMCy44l5hM05N74qFEc1A73byg2oLLp3GYqFn+9IFj7HFvuC1YtQRmYM01G86EV4JHYsXiFfbNG6LEzCAfpbfnV2KjCmfLO2YwkNjj6HtAqDEdBdti2Wu4q52x4iZtRiK8Wjot+XGxvFBaiOMQo8hxM9BktpCp2noRo3Wi3J5qYheg0X+ysjRPTWnUAgujiDVja6ZEPblNTz1rSvsqwKrbK1XIS7afAmItYLRWZT8da3+KJGqhMa1FY6RXNLa0aPom7ADq2DOfx9wnVTZoG3TURIaH
 GX7p/jrb
 Hjg6OoPnnvzSreYYoZrLVE6XxV7UqQ+8QSOCgCInWe3P8MGBALSqz7UvH7657fbmP1Akth5x64/ODUmYG2okoVHlWjU2egZWVRCj8oz8ZKU9su40WZ/BTniKaHykYr5zYbByqywygGv/LevBcAF+fQS7iQpPAWXWjz/CofAu0PIMq1NWlW7Ddbyn3efv+auwJgwf6vO4I9Tjd+NG56kEIKl99qR5Dy2ZQuRmXXXART0diCxaVHTowLPcKTU+xzd9EAGDBh3tZEesUwctXE1vYDEtlrGnER5CaOomcj7WHHuPE8nmewbP6ntc3Jl7efTIVfIIre4v9AIrUXKvlR9ldj9gmGhMM7dtZJCwjkZrzLM/PvS1RbH08LjuePoHNGAZHYZUdW/hcYEMGKLdbnPCIcwveyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_get() does not need write access to the PTE.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/parisc/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 467b8547ac8b..83f8333ad099 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -432,7 +432,7 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
-- 
2.55.0


