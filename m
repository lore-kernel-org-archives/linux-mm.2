Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2390510F2865
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE26C6B0098; Fri, 27 Mar 2026 16:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44D56B0099; Fri, 27 Mar 2026 16:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DB26B009B; Fri, 27 Mar 2026 16:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD2596B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6979316120B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:11 +0000 (UTC)
X-FDA: 84593048022.23.7193A65
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id A9FA318000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XwcCA99Z;
	spf=pass (imf06.hostedemail.com: domain of 3rO7GaQYKCPktvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rO7GaQYKCPktvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
	b=ilqi5NVsvVk2G4wZXKHDlZ+096VbOTCc0dh/CxE8joECq/gbEVauFkhMpi0pWuEqCBogrK
	mNByOXc7mDkMD/UKUJaK12YcP0n4kXVQue6+rxsaosxk9B9XPAt1ngS4qgp1ujcPteFPR8
	OjnK3FNSTTQ1AX68WK8MmJISw9fPSUU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XwcCA99Z;
	spf=pass (imf06.hostedemail.com: domain of 3rO7GaQYKCPktvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3rO7GaQYKCPktvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644909; a=rsa-sha256;
	cv=none;
	b=O07OlmAyfcD7kxJ5RZ5+w1ZijrxkUO0xtucr4D3sv6dDMVWwA/ynFJHm1i33TfI3oMjLFx
	nhJu0rRO8XjUgaXcXNh4TR4QlCB78SF3U33rWothw1XPcgj3WWjSsgYRabQ2zHOnSZ5vBP
	V/UytryetQDRwNpr4TowrN8tJMLjid4=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1273dfdaf5dso1689828c88.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644908; x=1775249708; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
        b=XwcCA99ZMEdwEFip3y3Tz8kL1gQ/lztOc8ODyL/SYyI/EYajD08RdRoAMOl3Be4bmZ
         Cyg6ydoC7GGfUzPf4xHxi8yZ7C7OUCYK0ce19QxxrUXYEyzBmljMkEfIntaDaBVORScB
         8NVk8OjOZJgJbp0YFTXDxTX4fF92tJliggixT6H0+nmH9PDSMYafqg34H9C8Sqb3SvKx
         ScXm+1v9OyYjVMtWTJzm5++crv/u5VCL9icufkZBHMSRcdT+XZ3/qYG07xNDaMANfJz1
         bM+DEuA9l0TveeCQdFn4szuR9e+l1WIUm8q6uiIE9VLVE92Tk4zV+eJvwpW4LFloFgFN
         gynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644908; x=1775249708;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0m3laKqVZc6BVbp9FlOKUOANtvuTeySm/ZmFaYOMpk=;
        b=sN1ti8Yf2KzDZZyDv11G8HwrshUry9Y9Vpt8qAx0iXCdtxjWP8VeCectUq1Z/K8WJ7
         FfjYgpIhpWLego0Wow4gdBiPm/cKPHQlAoSHKK7RcPNt+f/N6aaZupy/IWZf9BBjtzIn
         oUg+uPSkv2BVCcfSAY0GvX05h6BzacoVsm5JbFfnF26gNdiL5fmPpLwMNxgkPcToggzB
         FeMxkUxz9l41MkrVOpxapBMAX1I9W93p4ZXDxeT2NQ6FjLhEs2lsKAh8lADOqs1IKXKo
         uKklF/jjeI0z1PNetT6xkhN8hL0lfO7B/erGHvItxGWKVhPyKmOJ/ABuGcx+3wHhiii6
         Gg4g==
X-Forwarded-Encrypted: i=1; AJvYcCUAvbAlDeihPVZ+slKee2SEmjrspyntqMJXZU/ebmeWnzeLrjZ1EtYfCl1iGB7zN33DaFZYRmiDfg==@kvack.org
X-Gm-Message-State: AOJu0Yx/HQz6TgzQ/2C4UoMFZxNzC3l43oRDjnib3HdxxpGheT6X5/E9
	JITKpC/6Ob/B82flzlX4RXXfGC0CsrIjP66QyDaLqU5V6Xljo7PYd+h9GGaEAjzqJqFilRTVi7Y
	k0sel7A==
X-Received: from dyz2.prod.google.com ([2002:a05:693c:4082:b0:2c1:2155:75eb])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6981:b0:12a:80f2:89a4
 with SMTP id a92af1059eb24-12aabb97edamr3324672c88.10.1774644908020; Fri, 27
 Mar 2026 13:55:08 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:54 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-4-surenb@google.com>
Subject: [PATCH v6 3/6] mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, ljs@kernel.org, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A9FA318000E
X-Stat-Signature: agc94nuogipciyykwcdth9ed6woyr3za
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774644909-858393
X-HE-Meta: U2FsdGVkX1+gCVmvpTXvunPnv9niXUPX8bjvUAwwOEoDdcDXHBPzPf1NjHA/iGgf3nDfDFwEcT6H8HreFXmoPryGafcZXQYSDenX5fQ+4aq6H/7DxPUgWj0K/zFFCAZzjLKYyz1zKdTWt17ey0fHSLiRqt53EXAxwwYieExv4aauDHq9Kj+6r8Hx25u9KC+0lMzV46ub1mqxXb1wPtN9ru21QH1F/YeJLeiPVXYlihDNuenRh+iPmNdEXRrSoJc1gYKtKvxjSmRHGVrfnroQw1fQSl3y3+EzR0Ce61yl6hV9aH9hLiEOxFMtGo8d9rNwdkWUB4slT4/bf5VXSd00dw9TRM6Q4m4rxSxfu+HRgWMxzDhYuprkoHFlHKHc8FLM0xD6XBF0RPjWDW/q1h4hq6uhnb9dq+P8sschDH+YXHTJ6PqNhnytMT0Swh7QIYFBwQMoE6aeGo4Or2y8ohWQPifyIAvYLmyo2kam495/NZ+EiiLL129lZju+H2RpWTGBnyI8Y6YJjyswGshYiSs6VvJ0li+pZPv0l5jbgEdbhWTOYegNazu32/zCHOyWt16YyW8Avl/h2gQX6WW32f2gPVYNhblqky3nhKDccEw4nSes5QYxM9VZfJhm15QY2igCWuk6y/Pbj/D/KBaqBf3KIYFceE8NH2ECA13OIiivagdu5ySWGlHvFgfg8PIs0NbRkFGB8VBg18BtPbq04pTktFbtBPMDtZSh2GMCr9lD6NTehbpZB9omSGN4casUQJtahld5s4DlDb3J0vxTHvBU1CNXBd1oBysBuq4Qb/noCFh3RFF+2S+C+MleEgrKxjbUTGFc03qd2RQcf8ojMP2p5d9DZKMjiceImDVDOnZln8X5G9O9tmRsiHY6890VzFa55nG1LXbASAhYOWrimytXgxkC0K3UvEXTu1rq7sRlfeayEjWRlMQ795FU2H8vF+cHIT1AzKkC3GIxZ16q3qh
 KPk9zuz2
 cVXM37qPHkIdFZo+FR9ME1pIXHRYw6VUOlt+mfEfrvW1fFQrIxGZvz1Hy1Sr9XgaFBNanPUm8+d5Tlvv2sO1o6sTZOPvwC+/CF1ObpggP/RC7LFwMNE15jSkwimk7VxsEtOz8NqKe7WA+fyXBri0skgLRiZs4/zicyqcazX8cd92BDOg2DTmMlnz84dw/AHx0sUnYvKXBszrQYYsnY4yOPWcw4WoPvmKNAP/UQ9MHQesnlOzbXGUhxRVpUlCTxIXlKOSkeI5omfjIIyoiVebFNvwPXSdrnS+X95vJ2LtoPGKDdjLC84AUEM0T3QnoJKB16Ot+8RREnFVFhoY8oDWHQAjwR8QirLXlbH+JtqPuJiD9YUCPBJ8hl7FRp92+bK7pkLaFE7uAk75ihgbCNL9W54CG5pcZgJOnGGTDlVpFKNYjKkCtxFhXrRH16+lXA3t4U+fz8R03sajNTMDLGeHsgERDV/yhIRb668J+dwlEKEpTUTyLb9kKdHIWIy8eKHhZjw+89BWCK6AHoBzBVrWFErk+xzUauG2LNzFTGU+hVOFDWfBnjpBYWFgEu2pRAAWAfVlmQb3s3S6mqVuxRj7fgLdxemSMyqD3LkAUQ3uB8atZGGQ71/+AUVkI/pmSKk2Du+7SUSZWg76zznpvcIcseTpmIiuorFvbh543Wvk67dk/eQSBzsDxUWRpYqERlCu3tSKrHJschRIdIwMrerNu84bpBSywh2rrR0brkcnMnuBQYgmlecwz6jQ5vmyL0VmBRhjNHTWAzExZjxkEBnXXEYqlrHrLXJo1xbWk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() in collapse_huge_page().

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/khugepaged.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d06d84219e1b..a1825a4dec8b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1166,7 +1166,10 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
-- 
2.53.0.1018.g2bb0e51243-goog


