Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8139C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6A46B0092; Sat, 29 Aug 2026 13:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE556B0095; Sat, 29 Aug 2026 13:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5136B0096; Sat, 29 Aug 2026 13:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F79B6B0092
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:11:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB5C316019D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:34 +0000 (UTC)
X-FDA: 85154948508.19.005F3CF
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C1871C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N/vjkcrQ";
	spf=pass (imf18.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788023493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6eCHp0mkiyGBMAqKC0slmIwdkyokeuXLEojYHEhzvrA=;
	b=BA7lo5ltBI1aB5xkLfohGrbecjr+VKS/+PJpObAEhTlSvl5/24+PbxIXSzVK36GYFV7fo0
	CbLidCRAppHKimVFGX5WukfCBDsZ4Teim3rfbptX+iPc5kgGHeM4b98DxscGlmXhZ5giS5
	yUdYGY5bvSgSCoNpjOcZGN1GtkgRY50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788023493;
	b=DKy+COILYt83trWO2IJ1gSqrtvQQz3qaftBRirP/iRCa8tf9ZUHbeif+YoRS45btxjzeQY
	gb2g2mGNpXpZ1rhsxMH8VAu+Cd5KYK1Sp9StjQAXc0/iCr+nm+G4AE0G6jIbWlRtYWzDfk
	1NaPXL87qAb6DcDd7H40ppWnIuVVMWw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="N/vjkcrQ";
	spf=pass (imf18.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso7123885e9.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788023492; x=1788628292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6eCHp0mkiyGBMAqKC0slmIwdkyokeuXLEojYHEhzvrA=;
        b=N/vjkcrQ92cY3t/S4Aa44Vzbfpifz651McU5EI5ZCCyWHTreBrXVfEHjFn0l6a53NU
         xal17bZEmPQswNh6H1re4IYwm+xgBBh5Y0LnU93UBpGRPbzF15l4bo4UkTMRxGJNhycn
         x4kaHFCBbHiZ38JgNW+RAwsxBzLefdv/7lZZPmMuAmSK9GZJ90Q6uqB0JwgeBXxdbkwM
         aWNw9qGpfR1Xjd1Xaoir/6oAPHKlTdCqebjFnBFwahLkwZ+Eh66I0ZWnV6P+RgaXhdIJ
         Ap15Nn6N71ONTlSnKVjEIwOVdcfc4anJPQDFiVLh4XWbXxIWkSEP0xEyFjooibbEVRR8
         lE3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788023492; x=1788628292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6eCHp0mkiyGBMAqKC0slmIwdkyokeuXLEojYHEhzvrA=;
        b=AGQdXxPD8/SjeRkldRcVvtRSSl7rpiarorI6+z7Hhe5vD3jLe6oQt+w6P43EseVSxj
         LnVafycrIHluCWu7DpgZu3NWONxM9cDrOHM/DXbU7ohTgNC8buapGIi5J5FCQAim/+RV
         PXWaLfEHE/ooFaFF6EkDeVxEUKUxya5KuzcZUXGoX0xaqtKSVmturMSkn2hiDnfo3/9v
         cRq3/AhtT82MQPuu9Gbvn62pOLTba3gLs1SjcwqMJ5wSEVwjrky78UDWYNJlXmJ8pb23
         v5WkM2DkmxrHuQtu/vO+v7whu4XbkmpvsS302VmHlBQZmTIh/SS2GWZyTUUjqzYQlKYN
         nc7g==
X-Forwarded-Encrypted: i=1; AHgh+Rr6xdmqhjSzFrnFuuA5opIM4ptOtEG1womR4WFJ3mmeUhbwRDlh0TJFFyONWV2utP/mfj6fIskkCw==@kvack.org
X-Gm-Message-State: AFuF++mU5xk/YqC5gM1zUIOLEmVsPyuU+Zj7yFhRqC3YbAIwHBmfcZ55
	FN+kFD+PsvtAVIh7n3dWfd/ZjH0b0h6wEYNzuKcXc5UW8mB3niEZyuzj
X-Gm-Gg: AR+sD11MSxMX0PCaOI8zXfAA2yPHM60HTYMxfD6p1ncU7iN3G/YC+CkgcdmzXk951VB
	rToIAWLm2xR3ZwFpJ+E0iEkWgLxrQsOsmW7eQHKoviVAmHqieoxvk96auifrpMchPedoWA3r8iZ
	wIwkN41YGjWlmxAWwc2YHRWJsw7mvoq+ueCE9wM/wRSIJ66OUoqvUMBrkvgRVrcvcJwArZzG+6x
	bdTiReIhuZOMCxoKck+wOLIq3ucznkXvtQgDI1EVXOXng7V3SwXYSPyCc7k3JpA5T5BC5oUV4rG
	6UMuIssVH8oNAL0oCQ5fWPPXpNocPfHEs6oPfE/cznDLSSM8zQvZlqurS7Wqc5wedvYHtd5dHU4
	eOMLV5brcyJCbc4FIPZcMsIeRXannP9KkeYGVx/F99oXrnZNxKJdG0ME8LdzdNoBEuojRq9gbYL
	sbDuuuC9Y0gCSXr8JN2dPlhFV5ZNqWk2eCtfQ86bRo4qf2XwCK2PJ3q6WscUlEL5epDf37ZMt7J
	x115hVEzQ==
X-Received: by 2002:a05:600c:a02:b0:499:da8b:1476 with SMTP id 5b1f17b1804b1-49b91c52579mr198169545e9.14.1788023491596;
        Sat, 29 Aug 2026 10:11:31 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a06:c701:4cef:8600:c993:2682:3ff:b27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c7cfsm154861105e9.11.2026.08.29.10.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 10:11:31 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v3 2/2] mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()
Date: Sat, 29 Aug 2026 20:11:13 +0300
Message-ID: <9d990c3ed43608e674d4b12a8c221a09fd200f49.1788022178.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788022178.git.thnkslprpt@gmail.com>
References: <cover.1788022178.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohc849cjbsk8fyz3kug4xyixz7sma88t
X-Rspamd-Queue-Id: 2C1871C0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788023493-725412
X-HE-Meta: U2FsdGVkX1/yUR7rs3f9nwfDmVYEVtAH4vXhsTdZ7MaDkzGiDC1jNaMrffF4B3iLcVxM+l7pwEQqS7+Z6dUeOMg75+VIwdoqCU9CcD4yj33ZxRPRQcUSQbN/RmhM+vjBzXlx3+bhQmzftubJVwtMs56HUeFgjupvwHq2NOR7p4CUpue9Urb3rtt0shFupOKDXrQrUU+HHNV+TOGc5Vr1u5lyQ3iMc3dNrgLg0OzoKHsEo0kyA61hroymePCilMhvLIfS+8T/RTzyT72OJ9CNSAaMX44heL4o9dIxz6QwNWfZ4CVtXUpEOpukh2QHmPk0lLC7KKyjJVmNRyXqKVlsyUoBLowCJLUqCeR5vzFjxcurYUXwlAs0cIubcUsfcNey/blPAoy3pdGExlDEDZY2Xi0h0fhtKXybziIiYzivbCapF8cxkdWt7xnK3RAuTI2ssk5WNJitEiDb5xEdjXXsaLqJs+xvatc9x2uTzFYPG3QRimSoqEQPlttkDPEniTeZtshtEcjHOJ0HB54G4BW/c947pKjC10y9PjSWVF+0oMQ0EDkSvIPXOyHVyDmAD1irEzLJhespPSnVUSUJxyMTQf38LrsDH6tWYqKtMlhqtcJqJ2cSXMtGeXkvKapxjFI9BvgkGE331m/T07TDFGSoKlPQPZj5O+522C5WgK6nOnXWJiimrgGHSGkVZLyuzn0iQwHoW3cN8QNsQ74102mpmlANrCiz7kyqqPwYyLToacPKSSygbeLCPbbumT8F2Dx34QohvM1SKc26sVepReIF5fMKPIULUl9bPzWAW7ccKwf0MAkr6EQkSuchUzQMoJLr6YCjYEYqf8CvXYIkdQH6Zaw+3v5ylOSkBq7/8xt/iOwEFf0uMnWLwTBhKbdLjE52Jwucs2i35bb4CxRlaFCgckvKglsf4FR3lKC3CXY6ikirTiI2asoLi/BzfVDmvT7ixrqsijriwFwPT1O+z3e
 eL5LpRKI
 sAMIxDda+DpjAAZx5AH7ck7SRBWrIgmWLEZSaIl+9YAxihjlXxVCpSjTDSZsiX+TqF4gsTH3Vr61EQCg8AbPorvBmJXIANXEwtHNQWTGtqT9NbQgNU096Qan2CU+ayjkzLhnP287sngPm3A4crk8UPYoXCq6y2j6cFKn8JIKxzVfyf7XEAHXUbNNVXzVEikfY+0SzS9rd0q7QFrxZyURNeBTOMoug2bbt7Fl4BqSRpafxoog459388RbEy8EBctcivT6IIbvA/mvnP3g5seF8UdnUTrZjgMq7EecbGh7pjXLIEAHyPKy/hOwWACGO//l1JUJQa5GyZUY9Inz/Y9zuuJTrciXG5XA+b2akLxpHFO7hpPdooJ3c8IK20VbA+hR8L46ZXhxzX4HmyHt/O3RAfmTE/9idGo/0u5pNqYpU5mgrXkEv+gQ8MHkk/WJFt0SLt+iyDPAicTQxeRpkuippSqZ0t7ceHaeQBVBj3b9/1hYm7xmVTgXo/C7HTed94uXvIvseZb4XPGAZxbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
pmd_alloc() fails. These are page-table allocation failures, but
insert_pages() currently reports them as -EFAULT.

Return -ENOMEM instead, consistent with the subsequent pte_alloc()
failure and with the single-page insert_page() path, which reports
failure of the same page-table allocation chain as -ENOMEM.

Address and range validation failures in vm_insert_pages() continue to
return -EFAULT. Keep the later -EFAULT return for
pte_offset_map_lock(), which is not an allocation failure.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2561dc6bdde6..27ffe1a99a08 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2569,7 +2569,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 more:
 	pmd = walk_to_pmd(mm, addr);
 	if (!pmd) {
-		err = -EFAULT;
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.43.0


