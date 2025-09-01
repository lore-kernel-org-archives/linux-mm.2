Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58C49CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7A68E000B; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7494D8E003D; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526F58E000B; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8D38E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01F741407F6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:15 +0000 (UTC)
X-FDA: 83840409912.04.2F5941C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id BB828140006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z5c+ySOp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=90sQNf+E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z5c+ySOp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=90sQNf+E;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724954; a=rsa-sha256;
	cv=none;
	b=sBu9JsjCU9E+yIyGRYoAz9c9TaLmLcexRlaWQYYplIuBLzUlu/l+repax24qvgdzce1GKq
	EZuk8zbXYNqmLXVLEz3cuKGZz7gLhXkTeHii5scE21GTmK2U5UXJDfZvXppP/VmOgGKrkg
	R6zpVqhY56x/yHrteE4sic2jCpEKw8A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z5c+ySOp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=90sQNf+E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z5c+ySOp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=90sQNf+E;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jt4x7IV34QbOESa72I6EsO7Rh0wlySwqCcuJjlcUiJ0=;
	b=khDDECfwAoxsrWf5xYn268RpfKVwmdKZ9lcGx4SzNZtkr9EDOXsmWZSqtKnqXeEOKQ3+Em
	hXWUXcCwcXT3mLLXC7WFxR+t7k6IAfuv3aXYEoDX4HDr2Ayz78NoLUBc9oF9fgAQCEcZXy
	46pw3MHnVt/9eapyrqJ7s3E1ejYSMps=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 91D421F38A;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt4x7IV34QbOESa72I6EsO7Rh0wlySwqCcuJjlcUiJ0=;
	b=Z5c+ySOpAZmhexw/+8cxAtn6gqTZddJRBvPDlb9TZPBBLg0KYg3kCb9HKFMI0KboUKPxIg
	YceR05iAiJD5o8y0wKlxvKnpZtb95s833EhLWKzJXSqMUSiAJacgfoMWb/5forB+JHGNXe
	iUGGsgJCI4ydnAzni+0OfsSccBtz/ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt4x7IV34QbOESa72I6EsO7Rh0wlySwqCcuJjlcUiJ0=;
	b=90sQNf+EB0SvmEXrjKaFlLcDyjlJQIeqr3bT4vCRuyB12ePlNmbp1s7GH2e7QPpFKPT2/Q
	iwZmvuD61HWZ1TBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt4x7IV34QbOESa72I6EsO7Rh0wlySwqCcuJjlcUiJ0=;
	b=Z5c+ySOpAZmhexw/+8cxAtn6gqTZddJRBvPDlb9TZPBBLg0KYg3kCb9HKFMI0KboUKPxIg
	YceR05iAiJD5o8y0wKlxvKnpZtb95s833EhLWKzJXSqMUSiAJacgfoMWb/5forB+JHGNXe
	iUGGsgJCI4ydnAzni+0OfsSccBtz/ao=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jt4x7IV34QbOESa72I6EsO7Rh0wlySwqCcuJjlcUiJ0=;
	b=90sQNf+EB0SvmEXrjKaFlLcDyjlJQIeqr3bT4vCRuyB12ePlNmbp1s7GH2e7QPpFKPT2/Q
	iwZmvuD61HWZ1TBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 710861378C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eJlQG8V+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:55 +0200
Subject: [PATCH 05/12] tools/testing/vma: Implement vm_refcnt reset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-5-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB828140006
X-Stat-Signature: g5pz1ffw6774jd1954azoaxsrs7p6t6b
X-Rspam-User: 
X-HE-Tag: 1756724953-140954
X-HE-Meta: U2FsdGVkX1+8xi2xQphL6MnqamGKlwFBBXRpTbzyX9cpHrdbXnLoJ+dfVxRzss7giRMVyN47xqVT2gUWPYYeXlEOgQh4dICmIg1Jz6I+CzOrXZGkmi7H0NyWLjvw+DL9TnCBWmrrfJQsyrNvVMUgwn0eeThLmeMT0EhFLPkzhBcxOAIfW7A4eAjNSJGc0Ib51UnUcG2MIi7B9XRPv+vOF15xRzW/XrmMxJjiyJhxZ7DDz5Xxign1IjPjCl+m8tQeCIqs3jMs4+A99kDNBZwGWTSGxU5IGiDk5363w6ewsDmAWgOk+e4x+nTFultwSDRvf1IyK3Kfrg/NCNKWJD9xQhQdQrUSCPqbuxWGw9rzyYXXXgBLddoe4b/Wetc1vyOqOTMacjcYokdBgSSf/aTtnyIAyUMogV0TIPTtJy/H/ilUwrTNOvcY0VJByb62u6Iwa3G47DvL1RSBmswVfzS01dvCgxELwtdBAVOBkVvOHJw3WqbNYsiRfWD6AM2v+5FE0gs4e2dO2DzO0z28kDEt57wGmS9nCsZJyGc1wuIjIU7JOjBOxSZBTbrLGBCGAr+l6K4ALMdnfyOkPaOtxJakjmjwuRANdRm3G6TiQ7rMCcbzug1OLfTWmNgNgsg5Mkn95UGkwHbuDcJ+tobFs8dIoZ0ByPAJXCSFn5RnXuadFB/aQEdrIpErp9s3hCP66KEY8gaJD/He4KSk55HAXVL08874ojclXtktk4Q24I+L+xFKI6bWy2zrXT44VOWt4pmrom8sGTNVttJgHPkbODHZYVXqIxVd+IOJC/zbIx6HqpxJHPAQotKO5XniOUduomoepEwpIcKQaS4OCZ7x9JqygFgbE1Mf+gaq4eBh+Kdt8bHgbGlKFk8KGyZKGEzE6fc3oaKhEtZaezSsYyhi1AKOhFPw9OQfhQNOLcHK2bP+8uuaRaxmYj+m8qVLQ3gd9ZV1XxBpiUrE2DtkMka1Uzd
 i4NM+FV5
 E9aImraskeOA2mUjU5mtenv2xaXTTdXobPwrO8JrfKt405r/NyGOmfd6Y58igwqoq5dXJ/fLi5W5UD2xU/TkhDr7Rix9OWzlbSjnjW5NJZd7izm1H54mChQajKU033HW75QNO3+93XjYckEEcjSbj1ElIVH3fHnuuDPjsaH4UYmOzJg/UbwIBN/kGjMScdtoliu39iJM3utZAugJYLjyRHBXhuHLUeRmZoOiRNbRk6g+kUa3MfdULdv4RX1ReH3DaKS98yz9AH+Jt1vcaDxZqOAm6tA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Add the reset of the ref count in vma_lock_init().  This is needed if
the vma memory is not zeroed on allocation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/vma/vma_internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 09732eff8dd84555563b3d485805ebab7b204584..972ab2686e0a3654cef611ce9f3409bc0c38dc80 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1326,8 +1326,8 @@ static inline void ksm_exit(struct mm_struct *mm)
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 {
-	(void)vma;
-	(void)reset_refcnt;
+	if (reset_refcnt)
+		refcount_set(&vma->vm_refcnt, 0);
 }
 
 static inline void vma_numab_state_init(struct vm_area_struct *vma)

-- 
2.51.0


