Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501B6CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E85E6B00A9; Thu, 25 Jun 2026 16:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D196B00AA; Thu, 25 Jun 2026 16:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AC36B00AB; Thu, 25 Jun 2026 16:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19C216B00A9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4910C1A01F7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:22 +0000 (UTC)
X-FDA: 84919537164.19.5B9E812
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id B21FE120002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="D/epA+V7";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418460;
	b=2V7WISkkSF+d+iJYTGoWwfnXO/x/gEv9aBpVUXzT9EsGBkQSA4cKxqtTucA0+1jW3sCnTk
	MB9EGu+D1DdFVS3g6Zg0Jz9joZi08A1Jx7ooiWUUApQBZfAu10cMjfnjNr1cPs4lbKMSgH
	6kzOvozmlmiULqhvv9xSqKJvaAJRFtw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t96ioeKVh+URwncAcyewKA61MVuS3Y2+HlJwL87XcMc=;
	b=7myDbD9lVZM2jEKo80AMSLAX24fC8pXuLFmymkpPdaE71aTxJzK6DEuvJIkNYEsdymhW5I
	jvaS1A+YLF6cpx4+enQoXjLwO1qbx0wWsdUAgJGaIl8e5Xo3V/QckQzpBWTQvCtHi1lMgQ
	E/8ZC+VAur9B8ZHM2LJo6+kHvmUFKXA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="D/epA+V7";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=t96ioeKVh+URwncAcyewKA61MVuS3Y2+HlJwL87XcMc=; b=D/epA+V75l+e0ajsNhOSm1iyQg
	1hzE69/MFpdBn7lBCCyUHpU1ayAlCQot9jdI3rYkE5v9mkdfSTp89TQfkNeyX7Y70U+1Kh5oEEhKz
	i2lbscRvwZ7qbIeb5g1tjrwHRcMPY38jWKTf3BGJKOHrN7lnrq82DZGKmg3cZKp2dJT/8stp0CBou
	1S5GlQPKS5WxZ94Ax8AZPrGzi+qKfrh2TqU9CN8k4KXaS+keeoNJJfln6vkxvOlHcSoP1sLC1KIpM
	bZRd6EfjFaq/ZHt3q1bVqiBtgLQ94zE26YUyHlkXaBGqeF1csvB5xBgywzm0Py0wONVwfVUBE0A1x
	+ukj6hew==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq60-0000000AWYw-46fX;
	Thu, 25 Jun 2026 19:50:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 08/11] filemap: Honour FAULT_FLAG_RETRY_NOWAIT when creating a folio
Date: Thu, 25 Jun 2026 20:50:34 +0100
Message-ID: <20260625195040.2508362-9-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h3fhnnkhcbxpbi4pbecuw3i7yg5b3q77
X-Rspamd-Queue-Id: B21FE120002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782418460-673152
X-HE-Meta: U2FsdGVkX1/6hhRO9J0FqlDJDNBlrxj/0is5yirPujXKcHMQ0hzQydM4dvAeDFd6t2xbtjGDPh7jXmvjCakZyrD3t8g0w9URstByS9ZcG7T8qMeeTm9Jf/vK7dKxXLu3vLZ8GHM15NTyXp0Gylw4AmgVKCp3yUWCD1fnQAAX/ejjhKRsfxF+A6re58NXTDCWbGsdrbUmWH/TmnPqMrWB41yYIszu6/x2XgN2MDbt/EqEx0Cj2EsrQEMSErUsoFQxHSllP/Gif9IbLWgYmBfW7M3kFzKkxUf+WDiIKATUKpipcH3UeD10pmvA7ceVOavC72idTxsWFhR+puXMEga2AjRpdLgca4wjtdWs6KBk0Np8b7BpU8yEy/Fen5fjvL/FxMz0Khi01ek0AjU6YJm/ltB+exmU7SB1xftTor8mW/ICSod0smtx/uPR9ryhTmskoFB7UFyXrg5lctKatWBcDZTDTLpuwFFH509BCqH1w+BdNahqMcSKbw54hvDkdmXN+eQWWr5srBhmhtmh34LpSApjX5cJgHYUSmJxzDNz7xJTicZrUA211v5wspUGZDVD/lIYiDOw86EngrGsadVOBTkLKJxYEbmegcRfofBccKYGNlMI12mNht/xTyfEyUd7+1dGT51MuFDF04HhmLp34BukdC/PpOMGbuGG0m7EsbT/XdH+uTblB9pI1H5AXjg5JHQaTag6+niw4hbeTnA7qcoVYmS/RmuY1XNlSytdcXPK+3XAGmEq9ZE05p8540UxGB/wRKKX5NQIY5XE2Ipoizq7U1j4oQg7fn2tE4BFrfekhxcRZyF3hObs/zlUNid8o+MJ+bgH2Sn7f7JPW5jBEKaibJmyeehVTw3wP1B7Fy2yobpJic9FgEtRWViPUlCcloTLX+dA3w8Z0LXjhe9vll2OWW7SE15qLH7otx9p/rh4siQ345E5i1+CtKkURphOs3VtezgISe5sTEIZjHW
 saxH3Fep
 6TU59fnPdLml3Gu3izmwenUIla8c4YY6BIMHEesldLbedbiJ7dnmOlm0MZcBTI3SDmP9kFM0gjIVrpm4cKzUNKFs/LGh1nPEQR3m4ouKg06WYbLjBmlO8DfQEkBrCeifj6GVYUAC6y7V76rp5D+aR0/URixpHRXt+Jl8k5392tpzBJ1bQobwSYW47oi9J/aLtEeW/6MbwMW4lPsgngP2rkjLMuudURjOPHomzL1EK/lKT0TNdaF//T2+GiTr1TFLSqIFyYkBbTz3qo7/lxn+0cATrWA/FnC3vSK9jCHHxVH0l458=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If there is no folio in the page cache, we allocate one.  Unfortunately,
the GFP flags that we use allow sleeping, which FAULT_FLAG_RETRY_NOWAIT
wants to prohibit.  However, the FGP_NOWAIT flag will forbid sleeping
and so we can return VM_FAULT_RETRY in this case.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b504e3e37836..54997e667246 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3508,6 +3508,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 			mapping_locked = true;
 		}
 	} else {
+		fgf_t fgf;
+
 		ret = filemap_fault_recheck_pte_none(vmf);
 		if (unlikely(ret))
 			return ret;
@@ -3526,11 +3528,14 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 			filemap_invalidate_lock_shared(mapping);
 			mapping_locked = true;
 		}
-		folio = __filemap_get_folio(mapping, index,
-					  FGP_CREAT|FGP_FOR_MMAP,
-					  vmf->gfp_mask);
+		fgf = FGP_CREAT | FGP_FOR_MMAP;
+		if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
+			fgf |= FGP_NOWAIT;
+		folio = __filemap_get_folio(mapping, index, fgf, vmf->gfp_mask);
 		if (IS_ERR(folio)) {
 			filemap_invalidate_unlock_shared(mapping);
+			if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
+				return VM_FAULT_RETRY;
 			return VM_FAULT_OOM;
 		}
 	}
-- 
2.47.3


