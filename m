Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834C4CCFA09
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB608E0093; Mon,  3 Nov 2025 13:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C438E0057; Mon,  3 Nov 2025 13:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAA08E0093; Mon,  3 Nov 2025 13:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D03148E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:02:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97FFFB7387
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:47 +0000 (UTC)
X-FDA: 84070066374.06.C300F20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAC4C1C000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:02:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IogQUODJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762192966; a=rsa-sha256;
	cv=none;
	b=PUvz9ewtFv3eOiYcfrHMrPDSGR3gcIP32WdUqFH0dS1GqwWDtDYzTi+z2w6EsDC2BDlx2h
	WoMf8FXXJGSkkSsiSiJl/r0WsK99m8X8gs6DA+hLmURl2ADMaLCsfxG1hcw1RuqXZRP07o
	nBZCsKpWqPxjXXKeBhktcB1qVhmRD0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IogQUODJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762192966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErWge/UzD1LqvuHl7Z8/FN67Gq0geRz5k29l1oyq1Is=;
	b=KQJgDXSVY4LVcwI5KSscHsqqxOPF+xc2WcjOuFoQBTGDFbGMBc9bbwUMd5/kMYSTxu93w8
	DtV0AgG7OYrbpdBNbgLiCUTENxAn02nQqtPZk7HRVOdaVL2tcxIn31TxOa2Z851zII5s28
	8TEMTH5vKcDB9znT14+ltnV/u7oQM2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 068FF41E48;
	Mon,  3 Nov 2025 18:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD2DC4AF09;
	Mon,  3 Nov 2025 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192964;
	bh=XAwF/h8XdutL+ENyQyWob7z7axCXjW7g+SCPNNUBiyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IogQUODJjyTWMTWVWaSKOwkSJBVW67K2O34Yde/KtslQOOC/Iz4sy8KaX6kqBr7H5
	 GFb0Mcw/CkdVwmgfsioszFx5cEWJnFMulKlO4IIWvyPCxOY1jfelhxhEZQ5AP4Ct20
	 0Vgjho6r1cDd6BAXDhjF53c2kxEy94T2XEauW2MpEwvaH7ybnXWy2ukCRmB/8Xzbk8
	 Q8XlwO1XtdHF4UuXTBo9/62vnf1B1SOwpRq/JctgNqhxnH4iX4n2dIk3KVMpmHVZDY
	 fl6Itix1asg+IRwQ/C5Alq02OX92QqFS6qSZ4BEdLJGRyEcSa9MguO0nJ5vMyR8QXe
	 Rxj/Q36Ehv0Gg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] kho: warn and exit when unpreserved page wasn't preserved
Date: Mon,  3 Nov 2025 19:02:32 +0100
Message-ID: <20251103180235.71409-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251103180235.71409-1-pratyush@kernel.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DAC4C1C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 6uwcouie1x1qkjquukatsqt1e5fg1z87
X-Rspam-User: 
X-HE-Tag: 1762192965-776363
X-HE-Meta: U2FsdGVkX1+sFWw36GsMmdGuhSeczmg2ortiAWUIoCCjc4UqCpAD1xAPoLcF/xQWza+OYjCngXinrtART4wP6RM/i/DLakE4SUS9+to8sUckidTKVVB0qyW/cXdoe6j017EW36P+tnUjhV1pkuKjAKch2tLtNEqPADU30qNIx6HQKR+89fWq+DXgJzscWhyguficvhnvj+hNi02Kjns8ee/f4VNGAHtJh/8FWwLH824CL+TEY4i3NXX5Ft4vn5Ay69theMc+EWwlaxR0n/v3zEMSXiVQgXbnUET+TAqbK9WVo/OKMFxkGKDIoV0iSW3YmVgR0yL0/Wy5YyEYUaReMz2hU6BUU4jLbzvenwHP+KX1azFDyMzE1+e8CSdbZQ6t4AT4/I2PX7bN7retWxSlyJJiS0h1vq6JMjuPg2yNXRVLaIJ1QUCARMkGJJwMoyYZmng9OZWhb1l4gmu2NF04KYg7K6kFGqzefD/GZITD3vJ25myaMKIIJ9TJbHvosnWk+6P4wlTJz8TI9eUOtjqYPMaB016W67Yq1BQGSWYdAHqsPElNSdf+ffQupIL2bZjEAMkNDCW8bJ+vghowAgO2nW50CXv1XdrIEAa/JJvlGvGkkpxaf0EDLKivaw0mL0P6xNZpz/tu6MOvzrK89fexkh0OWYjXakPcLEmQf7VW9y4il4W+HTFUMzz4QQj8gHyyI9ngFMOuDWsbfYFSYlvijF/NH+xLBvXwDTGvlVapqL8/EqkPWm73IVIRHkoUKc7nwHzxbxDysfEJHuzPonPyV3G3XYP0RfDiAFd2t7x9W2N/oymj2i5nLYIgra2D/++VPXhtlsY+N8vtm0dWVlXoBi12RZIkGowDR5kEuz/Fu+mrpJrDbjW7FXFCPSqrXubmXAxk2ZcPviKsAhEN9K+lMlRfoaWRdRnwk7a104yENFXp7z6GWG4PqzzihjoU+Z6notFp2e4MXHz9aRPjqqQ
 oaGdVDZe
 DXW1Er0srSK604KfU5TbirJo7H6o66xYLjpEUE/vkCAnUKfGU5Q1yHBZ9+BnATe2U2gdKUhZ1NoBZ+UMowqhL3ltNJh42LnMu60i5qr3LQ2BM4epqGRoCGw1bsH8EnILKX46QOJhOXISBoE0ExEr/RWF69K7HZte3vCYnll++54iV7OgQtTi3yRNAKvLrdyLrpOKC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling __kho_unpreserve() on a pair of (pfn, end_pfn) that wasn't
preserved is a bug. Currently, if that is done, the physxa or bits can
be NULL. This results in a soft lockup since a NULL physxa or bits
results in redoing the loop without ever making any progress.

Return when physxa or bits are not found, but WARN first to loudly
indicate invalid behaviour.

Fixes: fc33e4b44b271 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index c2bcbb10918ce..e5fd833726226 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -167,12 +167,12 @@ static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
 		const unsigned long pfn_high = pfn >> order;
 
 		physxa = xa_load(&track->orders, order);
-		if (!physxa)
-			continue;
+		if (WARN_ON_ONCE(!physxa))
+			return;
 
 		bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
-		if (!bits)
-			continue;
+		if (WARN_ON_ONCE(!bits))
+			return;
 
 		clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
 
-- 
2.47.3


