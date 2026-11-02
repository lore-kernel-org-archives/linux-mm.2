Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B38360A2620
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j6EuI1Jx
Received: by kanga.kvack.org (Postfix)
	id 76F9C6B05BC; Mon,  2 Nov 2026 05:41:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F9E6B05BD; Mon,  2 Nov 2026 05:41:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F716B05BE; Mon,  2 Nov 2026 05:41:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2642B6B05BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:41:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8709AC0C63
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:37 +0000 (UTC)
X-FDA: 85389837834.16.FD2E1D3
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id B6BD320009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j6EuI1Jx;
	spf=pass (imf13.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793616095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4LlOPP020au30EZIDHlk1alCgqnzjFeQiEleoj/jqY=;
	b=LTUvKNtwNv30vamnyck8kIQCtTKehyRinavI4IHZbZaUaVsE2CfWBhAwS42AiyHgDd8xGL
	tIDn6rvIo2+nBYkyLdFtT/0v3Zh/JOL0Zf0MtvYn09mtHq/DkPNWub4xAP6QwlYDLnXdMm
	M/pJr5JNCzQuhQ7sacmpL6iLXL8jToQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j6EuI1Jx;
	spf=pass (imf13.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793616095;
	b=ZyTP+ueO5c0ny5JFkPcdiTYtRrfYAr1jtjwM62+z8Hn/VT2YR/PFH2FX3eSdcBGxk045Mt
	SzJwIjpzPSyZ1w54M+gKkEtVKXNY9XuWFKpr58RVp1iJbl3QuMp4nNY2TlR6hJYSh90jsz
	y5Tl7Dlk10i1Eha9S0d5odOF/KsxpWY=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e8fe8e343fso18691975ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 02:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793616095; x=1794220895; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w4LlOPP020au30EZIDHlk1alCgqnzjFeQiEleoj/jqY=;
        b=j6EuI1JxFO+awfY9Vhh56CP4EJgrvoQoXuwO4fOKpuc4bXNpYUtcNNrZVTI6o48YaM
         CRc2Rdu6AgZiS8M0aXSzjDSUf5M/ADwUUW30UvqMe7gpbqOViaAWRTTEKkSYy5saN3Y4
         UC1h/Tdegvmix2TE4aHeBdxKzC0NuvgOl4WysRBCkMfwTBSviouPTrH1q3fklR3kEx+b
         cwztEYgT8k5Kmj4DEW6SnS0JTXEy7F3OT1v57E4EZRQJHIK4Y71glKbHxoV7qLTr2Zvd
         XJWBlBrRln3pIecluTCRa5D5gHNJLM+osNsRPgpK0waJ1pejKd3+8nyTF98fMlO+B36E
         sBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616095; x=1794220895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w4LlOPP020au30EZIDHlk1alCgqnzjFeQiEleoj/jqY=;
        b=ETN4E1RFxEFGSfNbOqr79VMCKQqdvk/OWM5vn3oqrx9MJ4ydqWh8fOODwqGteNEcGz
         yAbZgRwatxM0UZ79dwNZsxcwsZMhIFjP5UjyKtaaeaWv3DrEuPH6GCRMUN1qMEXcbE3H
         WL8wIZbWOxKzMHErz/1Los7ImT2ylDV2dYXhPUd3j7WahzkQcTvumrATnreiJbxICtb7
         j9jzC14Ekm/tp4Rx1GzfjaqIlis72QSsHi3+SO3rxobtBbf6vkFahAJeVyV0iRVL2ULO
         nKFS4EjIxl3mgTByVphFHMSFQVr/Tp7dB8ct4mvCWTHd+ePxfvEH/oCMjZzmJAhsl0SP
         YRUg==
X-Forwarded-Encrypted: i=1; AKwUvBxE1Ko9fiyXt/BC6gWx8LXCY45SIOBPyt8UhjYdQ6Ix9CvJepcVMRCyxVaPJfWwxwS1sICXW/9rqA==@kvack.org
X-Gm-Message-State: APuU4Z/LdgxXn5/hqsZjn8RK5KcF8136UAVI/mFMRDohMKPefuJrYzRS
	CkN5d3JDh0q7zKM14NF4sKQaJvchKcV/dyrNqqCW7YB/+tKL6FdJiOSl
X-Gm-Gg: AYBFou21vB+C+HL/ADRGjdhzntNI4mPeQePDxMNuLqDoRAezlg+NC5UK/A4hdJxIOfS
	HOBFo92FgAoPoUaPCQ88yV54a6jGyefk1iUzUR4wYB+wF04dJEaEN/9Yymq21wP5UpeiZI0SGRN
	I0IstCixgatNuYWn0oT74enBGngQDAxPV2xmkApJB6C1192g06oL0q1mCKxdiUfKY0rBGb9mBR3
	JFAWGWTU2QhIsquchpy/upk56UMHw5q9d9rrZ4XtQGGNH35e+exlur9BAXi4IR4aSjLa1Vk2tgM
	lQhkyltCA4cERG8bWtGW3BVwyim0lFAemmSRUMHwMVSW4fq3uaCz89TG9AVx2ABzjoFTZXGLRmN
	cCgqWs1ZAtvCBIWlxyvjCaG7fyd59dnm78hzr61G9vnAesprnKoIlNYK7dQoL1BWbvd1evDsdta
	Unz7q+FtP3ZX+gR4YIAO8Duz6aO+XKOverjVRaP7/dgLUI9/MHpum0ZALHn0zIE+P32hQ6rfMvJ
	oQGh96zJzkjuRBs4UeMbtna7I3/p6uyBYfu5MLESugC9Huv/0fJexHX89cq30/Ocd7PTxA8PwnB
	RDFaZdBdKnu+Iy9E37Xr+kp88L2oCKODQq+bb7dbW0AN2XvEogw+
X-Received: by 2002:a17:903:3bd0:b0:2e9:f354:e97f with SMTP id d9443c01a7336-2eb36482f5cmr79668765ad.60.1793616094571;
        Mon, 02 Nov 2026 02:41:34 -0800 (PST)
Received: from umang-Inspiron-3501 ([2401:4900:1f3a:7c59:eeec:de7d:b077:9b9f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3925ff38sm25195465ad.36.2026.11.02.02.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:41:34 -0800 (PST)
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Umang Pokhriyal <umangpokhriyall@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] userfaultfd: validate the whole range before changing write protection
Date: Mon,  2 Nov 2026 16:06:20 +0530
Message-ID: <20261102103621.156928-2-umangpokhriyall@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102103621.156928-1-umangpokhriyall@gmail.com>
References: <20261102103621.156928-1-umangpokhriyall@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6BD320009
X-Stat-Signature: hep6fs3tg3fpdjzmx9h67ankbh4sin67
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793616095-5035
X-HE-Meta: U2FsdGVkX1+rBxxttoX72AuaN3yBysYHf3ZRVKpH2r+IJSpICT+cVEDZPA9bXDpNVERThqEXMvfCvgm36iR+l6eHw+JXFKsZzvEq7U1RHWIRPxyLjEIMqM3v87Pusj/H5gk9pOjSN5gkVrSSpDh/PfGQPTLOH0wAoxnGwWwBYKdMpZqyYrnO/2uY7SWDLSVwcWcKl4y0yvfW7NG0+IG5uoqb7WzG4b+zq7NJ71P+7xUG0KLMV5FtHHPmezkcLIU8dtOnNav46eyHgLwaT8FpXHmuW7vJxwSjRfmqoo1lxHjvfSCYM79uw9BoAv/oHHel6pmqoIsFfYIBs+Q8foJm2Aouhx7vkuXzZCWaHvC0JR+elSzJNO5sxQTcnEw5sxfpix4X2QAb5XwbrCBky00YXXh21Vjy1GNJt2cdcHZB8NxKMuImKEh7QH3PBsPFKdPVvG3rY3prBjb9SyKnpPDx0GM79uE4R+rK5eLnH2++pEm6WjU9HXVO/9xb0BczW+lPRE3kbYzbMhyvMgSjCtCMkERqVsunw6hBWn/tBgF+HKTeH0b8cTrE408RiniRf8W/2NEce9xKvJZtYDM0HNYZEfD3yxOucP6m27JI3mCheazF/uss0kRmT1lGl5K5UmDg5XEk3swMxsk2Jz53Oo+w0xBPIeNuDjJS8EsULM9ru3Jo6E/xv/sJoSLHmh59nxXyW2kkmVt3yGyCuk4Vp2VF0mdG45z28DrWgq85jvsqmmIHZUwvV/5ddOCf0aInBbQNXWFuVegFwUtEWn2lGo/R9Dv11ICm8rg4J11PEZU/XoJyjQNil01tg12wqLNLuju+ObdaSsN3NTA91qClxDYVGA1u8RUQ6mpkEAebR0S1sygUI9jLB1pcEarHvLi3LkyhagDCfA0yTI6xMifbydm1BSokUdCsCvHvXls9rzfrkX/V4IHDESwoE57uKrzGb4k6axScwRrYqjlm7F2iOJo
 eN3tRos/
 nc3QEIn5kHSYtoToQusAmQGMpRrMNzoLO26Fj2ONRFGOqCyJwdWiV6qK8RsFxc8KIxFn54lRr+Q+gmasE79OtXNdmJXNcRs+R66/XQjRGMEnouyjEUvJw8+9COh14ylcF1EHx/d7nZITpUQ68jEcTnamjWjtBhpDecX++roANI+Ksh7yUVGQwpbrf/YkZ2PPnIiFIboOFcm6hohJ2Z8ugeMDdMd4FNu7p5wu25Qz1dMNDYAlwwsuypa26IleFAA363BJxlkMgOjeM5nMHe9R1xMbwy4NBdkRyAg6mo3WxYe5J97OmCUdP5o3Bp8JKJ9QMSPmwL/AYCfHf7R+5rtaqg8ygmS7vkaPwHIGatLiVbpUaTawiB/k8jLVkjAEaDEuMQjlF/D6yTcpA7czk7FhxypEgXA4gTSI8H4g+y1BfCI8MnEGB9R4kydZwU4DmEjtwoBtR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mwriteprotect_range() checks each VMA as it walks the range.  When a later
VMA is not registered for write protection, or is a hugetlb VMA the range
is not aligned to, the call fails after the earlier VMAs were already
changed.  When unprotecting, userfaultfd_writeprotect() then skips
wake_userfault(), so threads blocked on those pages are not woken although
the pages are writable again.

An unprivileged process can trigger this with a range that spans an
unregistered VMA.  It hasn't been seen in practice; it was found while
reviewing the userfaultfd range ioctls with an LLM.

Validate the whole range first, as mrwprotect_range() already does.

Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
Cc: stable@vger.kernel.org
Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
---
 mm/userfaultfd.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 87da92526..b8a9d9574 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1105,21 +1105,31 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 	if (atomic_read(&ctx->mmap_changing))
 		goto out_unlock;
 
+	/*
+	 * Validate every spanned VMA before changing any of them, so an
+	 * invalid range is rejected without changing part of it.
+	 */
 	err = -ENOENT;
 	for_each_vma_range(vmi, dst_vma, end) {
-
 		if (!userfaultfd_wp(dst_vma)) {
 			err = -ENOENT;
-			break;
+			goto out_unlock;
 		}
 
 		if (vma_is_hugetlb(dst_vma)) {
-			err = -EINVAL;
 			page_mask = vma_kernel_pagesize(dst_vma) - 1;
-			if ((start & page_mask) || (len & page_mask))
-				break;
+			if ((start & page_mask) || (len & page_mask)) {
+				err = -EINVAL;
+				goto out_unlock;
+			}
 		}
+		err = 0;
+	}
+	if (err)
+		goto out_unlock;
 
+	vma_iter_set(&vmi, start);
+	for_each_vma_range(vmi, dst_vma, end) {
 		_start = max(dst_vma->vm_start, start);
 		_end = min(dst_vma->vm_end, end);
 
-- 
2.53.0


