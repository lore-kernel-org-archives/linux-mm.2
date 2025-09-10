Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26652CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A6F8E001B; Tue,  9 Sep 2025 22:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672218E0016; Tue,  9 Sep 2025 22:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587F98E001B; Tue,  9 Sep 2025 22:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 482728E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 117B21A0750
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:46 +0000 (UTC)
X-FDA: 83871800292.22.CAF353F
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FED9180004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UiPZTYKA;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tO3gM8aH95iDkX6qv/L3rj4+V1nSK5Vf1Drqukjmutg=;
	b=2KYsVsEqBO7l65+/K7QqGuoHAg2+GHRjSe0vmP1AKA0Xi6T/5Pzkx/W9lDlh+0hJffwAre
	jtQ5JvWb4AWIx8bqU8TJ7AiOubetFunXnvmCgbBWe0jUEv/TDU/Fua/zbAill7GkLfc1j9
	kOv3M9Ge0EFqV8feoRFyCgm1mEqMtms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472344; a=rsa-sha256;
	cv=none;
	b=7cs/B3Ic3rs2gfkOUUsZSUigiUwJ3NPT9ks13VVd7Gf5Mb1aXvN9VXnzjU0ZSNiU2g6sMd
	EozQOyF+rp2ywu9Yz/G3LV1+7NpkAwAYAeFp3A7PIRGZ9T4qpIuWLu1sPYqvqhCks8ge9S
	SLsvbMlUGqjjQd/dqVitmpJQsynt/zo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UiPZTYKA;
	spf=pass (imf24.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b4c72885c8bso5213195a12.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472343; x=1758077143; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tO3gM8aH95iDkX6qv/L3rj4+V1nSK5Vf1Drqukjmutg=;
        b=UiPZTYKAgxTlRiXmivcQudLnQccc6BnqKvGOnl/MLD3uju9Kc7y4Lp3j96eoiowMcB
         Bo5ZW1y0vjxTnKeC/qLLth5RU2gGdYPp0bw20bHWBevWJ5pFJ8gUD2pe6eyzJ2UvmdDa
         t4Uh4w1Ay4DywahdAdN4KAYHpFqKFX8UyW2XtS3bwllxVQRfc6K4n/VIq0qoBLisfsJI
         YFS+GAdujbu3URnZx2upHJrhsptxF/QY4QbxrU6HRJkj+mBicp4yS6uqN9qlYRVE8zud
         idO1c/uC7ACg6gF9aH4E0aJrIh5EA1OgljfT+1s3cu3Mcu/t8rx/8d9PtMOd2zgmEuJe
         Vh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472343; x=1758077143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tO3gM8aH95iDkX6qv/L3rj4+V1nSK5Vf1Drqukjmutg=;
        b=NlqplHknQqedYFe9eF0dCZfNWfWBgKfBtSHtHMLdtV3La2EqcZ3psQOQwLnRFWd+Kt
         ny8s13eSdX52KUndQVAehrzHum8lqIGk2mlTscLpH8L8QAtEmD5gyj6yyNQiyubDS4yt
         NjIcfJHqtObh7EsH0klOhFX4SMk5cV9uJASPEXhyb2+DxuxjPEcDMwJRwNUPXpZz60tW
         Hcg8EQraNGJpoAsmO+pT0bHVWoJDs7BIHqrt8RtHG5BPmNFhoU32cDBuP4JOhhhGEgf/
         nIU4BO9vFAPC6Svf/VnV7mw1B33MShHDv8bwonV9GMNqHAwMJhnUXCs3tlyXeNnVPvbu
         8UmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXs8ngaoU4Ip7X1sbkuzYuT4i2AubBVxD3OQxeY2ct6thCm/dpCKSPay1C+ZfOxf29+47IWFLophg==@kvack.org
X-Gm-Message-State: AOJu0Yy/bOAccVZuGXgeLtGvbtSvNEx6Ret97UkfCbhILH2FWMEEeKo/
	at+sf84KC/0cguNXvYBOKTXBhCpQufrPOTjBto2hAIeEjZgZr4Q25Hkg
X-Gm-Gg: ASbGncu8iRmRXzvZF7yequeYe0I4to02nOwGhkVIogHW9WX8T3OBO0zLt5Y/X4oFV/f
	p9aRW84mCi+zvbUgUE7ypCwvsccZjwBpQY1biaYhm1glSvWP696TTHDH1ExLvI4SEHFlRaFoIoG
	wqHjX6+TcWXjaZGPz+Bp92qrqUGKblF/6x6PHLhtJDjBKJ9Wt4ihGjEcoDTBVXHi0aIrgxC1OkI
	jDC6QHWTpPsHsKzWiHMra/vLRxlSGDYJ8JQ9i1fE230JyC1lO6Ps7s2R8DE3ik778yKyGT5iJOS
	Zb/3oK5TPmcOitEJh2CpxpdajybCOJXsuxVOAzhV/c8cE4Jx80/1I6kUg0hCGICc9naYJw4oqN2
	WGUaoeefdx6DgSfBc7Y5FWBgsVLAYTKmDeaN7zPioJRxBjtvNtrdsLJzCSlRVwpV9FiCo9UnKIW
	SLaU1yBX5NgsEZoQ==
X-Google-Smtp-Source: AGHT+IGLHrt/+HHcQCfm9JLX/3iwkEcxPxZknY81z3v648g7WOhOZb2datUTOMB4DPHSP/I5lhyKEw==
X-Received: by 2002:a17:90b:5185:b0:32b:d851:be44 with SMTP id 98e67ed59e1d1-32d43f0b8e9mr17115914a91.11.1757472342979;
        Tue, 09 Sep 2025 19:45:42 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:42 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation exclusively through khugepaged
Date: Wed, 10 Sep 2025 10:44:41 +0800
Message-Id: <20250910024447.64788-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2FED9180004
X-Stat-Signature: 17km7owscgkseagm5eq8y78i1ore1hzj
X-Rspam-User: 
X-HE-Tag: 1757472343-61646
X-HE-Meta: U2FsdGVkX18yLAuaLi0SKQfi8ocTLF8JfRIfPkK7MGcwz0k5GUV/jQBgypKwQY3sjV3yU0xRgpenI8lR6b0udUr7m0WJKYhlgA8l59/GgKYCJ0+0CNkTo1kfma9n3035Q4fCzewzwba1Kurf10aFpvtYiKfEi3kPkG65oM/6AWJdfpaDA649RhAIoHE7rPSQcqJsCuZmJ7/x8R6yNG1+IrRgVySTLm/VhQjxSefLEd8S3L15J7MYDM73HcXqEz89/qHX5YUFCcRK1cgVS8CG1hdg7mULttyqf0A4Pjj4dzqrnp2g+gQCjuZ3ucQFXV3x9w61sQPmUzp7NilDHneCQUf6wcZWKNyZa+cgoOfkRxu58/FTGfCWYuCVSxJB+ZqdjVjquRcFQjOCPeSMME2Qj7opjT+13ezD6ce+R1X6cVz8OPKovn2hAU1TTGUnOCBdweH3sRUPb1vjzfe48zqOzT5wA/F7UK8nj8qjWpJfkx6rMlfARU/yAkPU2A5oG0GLn/vgyl2NCMqEMx9f4Aazc3w0srA/g/jnFSS6JRWjnwtSSONkWPGG+JH+80p3kZ7gOf3uNWBoIqPpdkwfp3YgxlcYZBOSwj6dMFD74tE6XcilMaSQaKtCR5cEyhFPP9uYF3Y71Op4qog311JjS9nVxukpzfPGUyq/c3/FJAK+U1DFEXAchkW9SMo90KJJS2vnCMcFJuHma6EGLUzE9ChMCYZPHmWndqaCmdKUbQ4fUPgk2yFqOvTLGlfRdtStMDtKjUK830jf6nKkh5KTMqdl89m0ryQTh0qE7SCQUsMzBd0OO492GdWs+U9+yp98Ab5VRwZAA1v+9wT9pFVuw6lIQMb925T87ntKhFNPsHmsH0j42KCFxd1XeChQ0iWJa48XfNJljEgPg6DxT/ZlEiYbeTX9ZEkAyqN+wcurpAA2sRzAj/JvLZjMBQiWg+G/m1oCPymJD0ci/couljeAgx6
 iy+eOSXW
 uJrVtTo1FjD9oc5Qyi0G3XKrZg0tCLE5uazzi1Q6EaRS1l4mhioJ7V+5dwwhm+EvLZdNBFxwFke23KYm9XnMSR5O8BDl1Tdi8PhMt36L+BAwRnEzQFq6Mu4sqPmZZARHYijKoUBwMuWSLcKF2FkuACLsWDV3BvfUrWCKwSysJ1DgsbGp8ParFl7lNhH5tCibotp8a9F84iEs5Dr9frvZkymKg77IOChCG+9/Ukb/a08q6vlLt8Bll46IMvOAAnBU0/p1t/b3kfGDbcmj1SdLGsmLh2hgxiZWz/6joLEIzydNT7rK6U2e8eyDUEZO4WPzyGMDrJSQoddats2MS7tS9XTuO/BNa0NGIkmJBSxDjCxWtdfLMGW/+fJcaRURKf9Si73tFMzoG4Dg2g3sCocrfrFTzJX+MbfBA2JE3i5d8U+jl9vwnqdGGjUkNQ94b2UvyeYNPZpjk0aeXaUNksgGVZtuv7kl11tfQcZU4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, THP allocation cannot be restricted to khugepaged alone while
being disabled in the page fault path. This limitation exists because
disabling THP allocation during page faults also prevents the execution of
khugepaged_enter_vma() in that path.

With the introduction of BPF, we can now implement THP policies based on
different TVA types. This patch adjusts the logic to support this new
capability.

While we could also extend prtcl() to utilize this new policy, such a
change would require a uAPI modification.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 523153d21a41..1e9e7b32e2cf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index d8819cac7930..d0609dc1e371 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6289,11 +6289,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
-		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (pmd_none(*vmf.pmd)) {
+		if (vma_is_anonymous(vma))
+			khugepaged_enter_vma(vma, vm_flags);
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
+			ret = create_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	} else {
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-- 
2.47.3


