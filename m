Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C603ACD484A
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E856B00D1; Mon, 11 May 2026 10:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375286B00D2; Mon, 11 May 2026 10:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BF76B00D4; Mon, 11 May 2026 10:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 193466B00D1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:06:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5F9B1C0129
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:15 +0000 (UTC)
X-FDA: 84755313510.01.5CCD9DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01117180009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:06:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MC++Iby5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3z4GklFCErfTQtmmOR00Q4UhPA9FcZSnCFOQyXtKW7g=;
	b=T3D2ABUdwOlK+ssd1xhOzMgocU0K19xC65fsCdzrGgcrWXuOi3vB3FSEMcRBVCO7ZTxCUR
	r0ICVXSMGpZso8F1jaFbRCpYHWjw45edHH6xVxTbgSHfbUaDvxO5LqFX9zoBNAJSyEAK3Y
	S8v0gAYceSlpVsIPt18m1VuPits3uKE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MC++Iby5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508374; a=rsa-sha256;
	cv=none;
	b=txv613v2dHPErPhxRYGHssqu+++cQk4UQqMz/sRVFeN5qDHq7z1qea4xHlNrSsmT7Q69Ip
	MNxoyRexxcBcBfd3ulBgZV8TcH7/Jq7a6pWD0wDRK9ikT4qpqbTSaHLTjpuk6AQ4SbCGc+
	Hf2IMV+MoKU3gLQm8E+sJPoz/DYOTcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84CA460172;
	Mon, 11 May 2026 14:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5FFC2BCC9;
	Mon, 11 May 2026 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508373;
	bh=7BplXJKZlQZOSJidAvpNkGSKkzbCMEkCK3cF3mfqU+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MC++Iby5ok7TXQGGc+uvg4Efk5zAMeJWOG3GMzC9znDRLh77sNxq1/rWfakudf+Lf
	 ryEJQVBagPaPXTKqmKiLzgUcFrnhQ8eOCrfmxUdkhB3iXLgVsV1Tvfklz9fKrJOhCN
	 CBaXJF9ug+ycGiW0eTVI5IIFRqbQjitiB9Utta6xmp5xEwQzK+PYR9jG4kLGMLYKbM
	 hB/XM1I/3Cp9r7hbhk/SBnPybVltI0bkF+F52k7f+2LivbjmQfB8GxCq2rfyHJe4xz
	 JsNU1b+6kEJ9qZjaYN5n/MZmWZxyntdGM4p4s3lOh7wJP0Bcyk/9jekF3yTJqi7Wi/
	 1sEPxTCVP5VBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:35 +0200
Subject: [PATCH 7/8] s390/mm: use free_reserved_page() in vmem_free_pages()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 01117180009
X-Stat-Signature: 1o1yiisocmtki8ex7aqbeb1naizhzowp
X-HE-Tag: 1778508373-584691
X-HE-Meta: U2FsdGVkX1/Q2HWAcEu4fDhfs/gkiCVJdP8nN4KJ9/5bdD5qC9P6Etx1s8w1zPPD94Sjl/vUgY0h7yGfuImkAv2NX/60gzvO7gL0xyhHSxKbJg3razZ/gvp99txnc8I85M311JqZ8MB1VMmSRnbbkqki0bBsxJnpPQRLvw5Mp4ChhCvM4534V9QB24d2fU2H5wT5ExxrKtUknQKTJ/v/lGGy4giRDH57aDwXIFV73L2huHLnyp60iPrNQi7yX2jBM/oHuSfAhUxdnbZiXKWINUOw2aohppkEpIZ8yHeCXDY8QWE2rRLe4qfxM9x90+nio78b7uduDgNEHEElNI1gjQj7BkyKPO35wn8fgvYCyoelidWQoZGDp/JN1oDwgXIrvZC/AhSpRmkofxukdg9BdTlcMsdxde+f50yomfO5kwv/xgNNBbRbDFcoKKm19QM9Vj9aGsQC8P3/SLrGakOztBz7yoNwAKvUDj47coufbQanXLpdAWdIN5JKZGb/siNN6AOPmDsjJc9DFD0YzqMGQPuNEU08oRPoStWAhku/RMJXJODtyDZWvPlnS//QXaVGEwD6b9KDlTNjl88c0zFSylsnB3nl6XurgnDMbnTgJ3gsJCPWssPJ4R03FuGFX+octW5BVgwLVMX9TKhhrJu9oJfn8u14VKl8ROE4SXAxWifKs7liXKkNiF/nfn/SG85E4jbKIIBUGhgiUbkd24ove7wHLFGU4sC3LOOgOM1k1Gj1Up697WwdH64QO0CFmkL8Vj7WyAqOsIIz6iJR36lqkv1qRn6Of6A/JPvDKBwHfjO13vdRb7LSDZUZnufaWo3VBvBh4Y5LXqF2tntxB2FC9IA+69guM5oH/aaGcPhipK3mGeq16S8XudtRa6BO24I3DA2qb9knbd8kooBSipvSi9wnhV3xg9zbFHzySimdWfqvmwXSUBJfsROxoDk48xIc6S445mdHHDRMe8R5hZF
 sDZhvjUI
 9Z+tQeRrrPdACON8hhWBcz27Np2C4ld1xyQ/U2FzhDotK90fl1QMitpqShczx2FeD2Vqe8667ESjR5hSleG/RBrEzBofND4KgerL+7i9bbTlbQKZZ/l2FIDH5L0/LP8Wc8Abro6DQ7d8CIvEYN9Re7cy8lqfvukfwlm3to9H9B6Os7okLFLSBssylUz3yBPV6BBNUw7DfyMzRYJ1sKed4ioaC0xEGA9KSYRnnKq+4x93varOLQaHfTIN6v2TrJUGF00YRp5khXLNyXm2gScEKiMZsOIHePZUkSQ9E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
free_bootmem_page() nowadays always translates to free_reserved_page().

Let's use free_reserved_page() to replace the free_bootmem_page() loop.
We can stop including bootmem_info.h.

Likely, vmemmap freeing code could be factored out into the core in the
future.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/s390/mm/vmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index eeadff45e0e1..d8b2a60e0c33 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/memory_hotplug.h>
-#include <linux/bootmem_info.h>
 #include <linux/cpufeature.h>
 #include <linux/memblock.h>
 #include <linux/pfn.h>
@@ -51,7 +50,7 @@ static void vmem_free_pages(unsigned long addr, int order, struct vmem_altmap *a
 	if (PageReserved(page)) {
 		/* allocated from memblock */
 		while (nr_pages--)
-			free_bootmem_page(page++);
+			free_reserved_page(page++);
 	} else {
 		free_pages(addr, order);
 	}

-- 
2.43.0


