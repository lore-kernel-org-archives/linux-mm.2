Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1E1C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37A16B0088; Tue,  1 Sep 2026 23:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9126B008A; Tue,  1 Sep 2026 23:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7206B008C; Tue,  1 Sep 2026 23:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7504E6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:39:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAB551C2582
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:39:00 +0000 (UTC)
X-FDA: 85167416040.12.5EEAFA0
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C823A0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:38:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tdrqJs2L;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788320339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V8fojBHcWDAxPoaYVGsHqqGZ8A1ENNs4lsc009HVd5s=;
	b=b0+XtEKKE2lrI3uKawQ3Q9i8oMm6y+++KCZ8gUFhHEbzvlgaHpYM7k0+ws240AfqOHwRWD
	tiohMSgT1KWWAEkS12xXtiiOmAeuZByBg3IyXni9KHlUOmfexnOEh4ytjoNlLi8uPPDWyN
	vahUQ9uxYOQgWljRh7Y0ziNzCezOOA0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tdrqJs2L;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788320339;
	b=aPECr78JIftmQghNsFgKU5dH6/FAExgzKC1lLGv4VvkZbimpG85C7jD/y+LUAdPqtaufkZ
	X0+bR1VILKZCJJowQajF1JukqRSA7pJzc7UlVbiug8dLVNYMJCL5quMYtHnJQgbNGhaqGO
	Jpy8RyXF8C99fjYFKG6AOp2Y556qghs=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66e64e6e3fbso646005d50.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 20:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788320338; x=1788925138; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V8fojBHcWDAxPoaYVGsHqqGZ8A1ENNs4lsc009HVd5s=;
        b=tdrqJs2L25dKj0/RjOiFWiHb5T8hdjJKEVaiKGCGBMZzrif61g06t7GgAWDIH0NmVH
         ubF3L6cc/HV0P55lPjQejfY2vNvaE8QflvJ9Xxvd4a2mkiKi51sVPiCecBFNPqwLCt9O
         zE03TXKtSgJXoFkVUmNE4d52Njj4l6x2kH3v1K5EdpV9nO3qL5MoVecHp2P1FjkFwxA/
         zISHcwh9+1YMcl5QS+TNmuKcEc/ar6Imd+r4fKFS459K69Botat7WubqfQCs16LMJWiT
         8E9yiJBhqgmF/bWRYLNfe9cb1+p35k7nTmF/16tsoYV0xd+CsL4rqISY1rIWpCwu2aQp
         kiBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788320338; x=1788925138;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V8fojBHcWDAxPoaYVGsHqqGZ8A1ENNs4lsc009HVd5s=;
        b=Yw/A8lhOeXtuAzNTbaXC30kw+lKGoZzzAOdi97GjihI4mxVFzAZ8+ix00y2uK062og
         UdDdetZglIp+F2PLsuJonSWL2ABb8nJl5HNg/9Nos7TCjqiUO4A6RfGds0glwth6O1bZ
         HxBRAGE6QnAY/+kz1BTCCWgXpcQPxSeZ+7qtnDMgVhmPQUMDpPV8DbnoLVemB3mJ5fES
         EgfgHMVGfRaX/pQHuwRozIcUz1OC4FWv8MOxBJjOWQyKwtlWLitB7g5/AvP2ub+8Lfow
         AL2G+ZuYRbxLPQRsqAGzGqZQzAqKwVI9oGXVpYKjdBF2U2o0agEBaqgHd1qRaU5N1POy
         /Luw==
X-Forwarded-Encrypted: i=1; AKwUvByTPeVFtDahmO+uUTbFJhLHzoisHS3TVmodlgnz/HQQB10RZGhc8tYbM+gmDKQlrI3wZ/m38TgCtQ==@kvack.org
X-Gm-Message-State: AFuF++mhWbT4s+WVEgYLGQe6+zgxHO7P9cPaQWaIs1j9NPvG0Jn4niNR
	FUITY1IcVP4p6nsvUPfXuWC458Zhgb2n4HGZ+/AryjUHJc3KbdFWx88dO63+t5S5Ag==
X-Gm-Gg: AYBFou3E5W/Eu6s5Eb33xofz1jJkzjOEjMWMpjPMoWbayAkrWF/CQjOF8MFTgZfrIGq
	E9Nm4Tydb884M59R76hDm/vaBzmUEPD0kkGnXfrFnR5zh84KBCvof0kdMMvUVXzMrwUNk+AtO+u
	A0LYPppEpxpbpq3W1+pK3iB0YuZNpLlXiO1OGlHsygPuBPPaQjBaVeQ/ZQiKXsLzEHqmePsJRp5
	KGdMt8Il+nByKMOutv2VL7YilgKgabvKM9UVSP1wNH5AUyOEv+Ly3TjizPsjLvnMpoaN45EhT6h
	KjZ2KjFqp39lLxhb4fYtgUvHoBXIqLjawGlvvGA62it1ZWRJhfg9CAKZuT2chCWsknFxMKui2zm
	Zo+klCaaaot4+0y1qRjS9tWw4IJfsRiqv/puQuOOU5AO/VpMvjal59ajeD26K0Ea6zsv723JXHu
	bjNvZp1kct6u9tUpVBpKNbcJ+NofMsQHGD+bsscOUxAlbGWscszg5FBsJLXMfestpW989f3cKUf
	P2OXnzMaw/F71wl0OrDrszRBTA55OG8Pocj+7o0Efbb1gED
X-Received: by 2002:a53:d017:0:b0:66c:4163:c4e6 with SMTP id 956f58d0204a3-66f9bd4a3e5mr528831d50.26.1788320337604;
        Tue, 01 Sep 2026 20:38:57 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f9850c9f9sm1031960d50.4.2026.09.01.20.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 20:38:57 -0700 (PDT)
Date: Tue, 1 Sep 2026 20:38:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Binbin Wu <binbin.wu@linux.intel.com>, 
    David Hildenbrand <david@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
    Matthew Wilcox <willy@infradead.org>, 
    Sean Christopherson <seanjc@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, Hugh Dickins <hughd@google.com>, 
    kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm/folio: EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio)
Message-ID: <02876cea-5727-2ca4-bead-73659ea6fec4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: z686g3pn4ee48p6zhr5hmxybjcugwczg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4C823A0003
X-Rspam-User: 
X-HE-Tag: 1788320339-76614
X-HE-Meta: U2FsdGVkX1/HFcPlufPIgkREogqFDsF67fKMILDar5keyBcxGIx7s9QS4WWcPQ7oRTvGKAonTDNiSgdMduFp/dbqwWa9rr0wTBOiklfDMM3v2JYTQ1aNM2yUbjHS+o9anEPMFcuuFtBLZ/ZdrvFFfF7b/l9ErhZtICfU7DtG9Ww85F7f8PEVVXyoVlXOLgGdu3/N+PHDdMga7OWInaqjO/0Z3LnnvI63x25pGQrTBc0u6mUeudsm48+f3amIhynAJDnC4FtDsqxfHdGi8SNSjHyjV/eRgJQMIJVhTRt0qRAZmdofO/0i6m7nmoqoqFq5AuL/DUbDEQX0U3b0T3sVfd+24q8cQQ8+itsAyUcrIGjh77crp4EdjfLmcI2kX7wLerZaeRtWAKsZDRLJubv9oDRcZFhnyJBcvkMbz/sUj3Wel4naX5ItkFRd168MLWAd9rBUZPBK1UJ2Yli2bOR4co2IpR7AZLQRerMqf/SIohyWKgbm/atIy8U4ptz5EJqoXwqpQ77CvEeLhnkJo300UoCC/nNW7IrN87v+2WOc5Z2Ns8WKPqhnqskMhw3WjNvNkdrrvTCER89p7TNF8FVvBvhKi3fKvYZv779u9zHd1IzUbBAjNxvqHOo1pTrZnykfSP4O3PP1VMbt2MfBNoFXJAmbYm42cHVwOeiU0RyCAbiG86a6dWnPA+ou7pBwAPGi4CcFLUfPZOyhQmPRuElxpUdDUTg8PWwbNr8MowowNYDyXZc/Ih96NZKPIJigm40Kqtf5lL4jRnYoVCegYgiF+XHaMo8r68Z7GT8Zujdfd541/Hq5NjeNCb9RTOqLEeY3In42kHSlGzikvRn/6xgmoz9OfQyRIIZA1fkl+Z5LKWBUfRA7bvahYrAIaenUUspGL1vvL3TwyRMm5Ej+Msfp/HImD/6fqLu5I7BegXJkap+zH3LZe64CxUuSalmDhq+VQ+iXzVcHZgfFpxHuLrQ
 JIN2omcg
 TmNh+i6rlfIRDFoeQyvCSYEo/ntCmcC6fF44L8kkxNldvCFmqqlmItToZPlQ7vBcblibv9tIrQPWN0EvrwrRHtG35C1tomNVIyUGXwFa5xVE/C6qT9xRDyoISwVlH7xLkU2Z5KXqGPQlVdwFvut/1l7ILuifX7dJUdzaD2ViO8dnpKWEPDhdOJIQaWptyzcS+saaK32T/crj9fXunw6VrQsl/OmOF2HQMJ7HiWofUM+3Qb5H8dTRboHyG9Ts1E+mUKpeZT4SLlAY+HFm4hIwveAvHLMWV+Nc8QQezG63Zb0JwQvaxW1C1jeSsAST/2YG+yg9NPAXKlStCkRCP2g69mmOjPU+L9jYJsUmk3so1iAQCXPKl0S7B/FfwsDZ+Tzsqi0nZufr3gY1wif694Tfsah0ZHZf334iaZHgzoA1MNgSefKBn1PbRfNz6tEhlQSDazbuw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

To simplify independent development in the KVM and MM subsystems, now
export to KVM the lru_cache_drain_for_folio() which MM added in 7.3-rc1.

Link: https://lore.kernel.org/lkml/bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com/T/#u
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
Hoping for 7.3-rc2, which would make my life easier: thanks!

 mm/folio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c..50a6dbe55998 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -33,6 +33,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
 			*drained = LRU_CACHE_DRAINED_ALL;
 	}
 }
+EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
-- 
base-commiti: cee9395acd8043be0644b25c34bfa86623f2b935

