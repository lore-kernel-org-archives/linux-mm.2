Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253EAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31F16B00F2; Mon, 29 Jun 2026 14:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B0C6B00F3; Mon, 29 Jun 2026 14:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83756B00F4; Mon, 29 Jun 2026 14:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADF76B00F2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0E85116761F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:07 +0000 (UTC)
X-FDA: 84933862734.13.D13B980
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 40795100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hFVPcNbZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759545;
	b=5YDHXwyDx1+Ec1ZU3dzQko394tVa4OwPGPyaFj3hPEPnsuHlGbj190+R+INnFvc/p5QhSy
	lJDVbkdPvbMN5fL8pQ3G0RFpOK4mxSJj9rzIVK0FIoBfLnQ5mfvJ83CN4Lkj+M9iT/kDz2
	y+J1vAtJQ1ZyCqmn9C0Xy8fmPIqtQDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My1DbXUPRns8MM8RQE7EVMjU71GQnMwCyehhLcnwXmw=;
	b=n91vG+W5CvnFv9lYe75szU2MtKKIRLpkJctP+ZwjUEtwxpgIpEfcv9vX0kqd5LxlYdvzgS
	nTdo81mh4BBrCVFeAYrKYNpQZ+0LfE+hP4FXyELR7UIUsXCygFdu2ozJ2BJAUBvEGEvNe7
	7LPFKLVTtKWgKmE48+vLylZn0l/rMRM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hFVPcNbZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845537740ddso2122927b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759544; x=1783364344; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=My1DbXUPRns8MM8RQE7EVMjU71GQnMwCyehhLcnwXmw=;
        b=hFVPcNbZuj/DK8/UFZ+uCH6Gud6EQkbedQAL66eBu1b91uXPZObxXSbE9nT+lWmzUx
         an+2TUxEn85tSsREBWyqyBBVDF1Pznim9vo2/9qcfcDX5X2hmo50fjCvy6+BmhXqOEm4
         JBRGWTSBDC0l4l9DvcKIdNshzSZij1c4dNwvFvYL0s4oLNR34KISY8o9IrnMPDzpBlkF
         AZ+1yqCxPWbRNf/EvIlICiSxdtnZsjaM6QM2S56pKpMY5wVa6cD18j3F3qhsyjzJKCsN
         d+A+9ou9dxCBAt3is11Of0Yw9bOebLTx3q8AZf2pQj1CB3aTQfO7JgJqqbtgeMRqjK/W
         4QvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759544; x=1783364344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=My1DbXUPRns8MM8RQE7EVMjU71GQnMwCyehhLcnwXmw=;
        b=sjqPpqGxqjTtc0zuCUwJ1TXRu07Gmgs47QfYnqW7pIU3XmjGJXKO9a/Azhl6wHi9te
         kNd/TKB04s8VYNRNLOyk6a1do28Yj13Y7Ib6SNjPjCcDMk/XPoLQKykPtmyWWmskqe0i
         UWRIuCwvkFBWhDh1UT7GKCDED4oHRQBAsMaYynnUlHUIh2JOky8MePaUZKTD88iOSK0Q
         dLuPKpBSbNjsod1bGenDRQBxw1GK9pfITpS2ZPlPotmMuzSZx8XwnpGOGyrQ8CxAaJc6
         hKZgmXiA3OX+02PsvC0w7HcrrqSuakJ8UWnwzBCwh8y3LwViGf9lXGpqhcml43lMJ5Ck
         uHVQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMTvbCSJxZhu5mCR78G8wtC59GzyvihYkJeh8ojYLLUxJ7GVG1obZLAuiVd9WhVbduu2pS+Ik/6g==@kvack.org
X-Gm-Message-State: AOJu0Yxg19p281L3cIoBoALWz4EHXKP5xGZ4FY2+dTpuZzg1DlM0SeEh
	QXx2PIRSxVoACS4FPIh1y3SS5ROnFz1YIdjWVzR73oHpa6DFC7T3sVTk
X-Gm-Gg: AfdE7cnMTsBqegz9FJ2YZSVPIMxD3ZPhiHJdGvDyGlIOZ40MYyCsDefmlNeVnv28bn9
	s/6c5rRm2XZXSCSlbOXhmOqMElmK+PgNRM2MVJr7TYUfHt1P0FOOBltWuMW/TxNltdH/1O2Fflz
	iAoLf3SI5NabQli/499+QNHRvM4NVcRjmt/kdcZuDYUb+y2eFHuTd2zZhUO29SECpRZCPkM/qiL
	MyhdgSCLY7lIgp1ZdsWlpIyTVApOf8lHACdTkZ5cUPfcccfOgi7shJ+gDJ6fnLBmTC0AFEODTYV
	Cnl42YnSN8kBZvW1Bb36mxMUZYdMJlZmh6rHJlV+xmgKxi9KVysj6FN6gdZcRiNfW9QQQtfKe7L
	kcyCyOLN65ljsCqyRYMsPPJGlpVMeu2uCK5FVbQlpjwoO2fgcKqHhDvf2OPNdSxQQDF5KuExYeI
	sU+1iL+1E5uP/vaHlYqWqICFEjnMsGNgCUPhfvPvcPQURrdrqo+IOY1Ff078hHyW3KP/M45fg=
X-Received: by 2002:a05:6a00:14c1:b0:847:8b11:596d with SMTP id d2e1a72fcca58-8479f2718a1mr464271b3a.41.1782759544196;
        Mon, 29 Jun 2026 11:59:04 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:03 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 6/9] x86/mm: Convert sync_global_pgds_l4() to ptdescs
Date: Mon, 29 Jun 2026 11:57:39 -0700
Message-ID: <20260629185742.126987-7-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40795100006
X-Stat-Signature: hftm65j6gxazekbxp47wgaed4qe93cze
X-HE-Tag: 1782759545-640233
X-HE-Meta: U2FsdGVkX19SBmerV8zYpcsWluNP7Teas5cTcRF3Xb4pD34eHc/gbjsW4jHKyugtxhid/u7IsGPysU+XqfxaJZc7GcfSkEq7BEodo9Dt8o+Vmkg4MzvVMF8eTjtag7k09ie8B6yLNW0s424L9dhfpkrvQ3Lq4BzPdRJqfkwapb2ks/svu2U4ucfYKYr1AkEp5Evm3MUnR26jEzFZJzyrFOpciEfLuvvuly7AZMnTSFB1qWD1dJeXTDibduUKvjE3ChZUMwFyml/fdL1b9poOSPAccKqnN6/9mFMViKax+YXdJ97G51qRcrmpPErL98FfRmaPs8/c7XyOptdKcn8PTEgBrTh7nDIvaFbYc6FGp98rmrUlQ7GY9A0bJTxamCEa5iS+Uc925DCxAho/WgLePiNcf7SQLYIXoYTK1Isuot75EPseS62SJJqAigYlcD9gMm6tKshRTEyWqJoQ7ynljfhh3OdOAD8ovQ+wU9XDhejLm4rsRFYtHzqf4MejvGnTa+6rxMJ2u4O387yjcUWSwguX+nq1mDiF1pd1Bev9ID6X3b115q8vfM7V+mbdmDgJ5cB4Z2AJb4vtQyWQnG9HrJlme3kSva+bZcT76tRGga+clLnwLiaewP2hBtxn0zmDc+VbA7CRN0q6VdSu21vevGsKG8JM0qTmncEGrluglCwxEs2sjfU4ufu9j5EQCfkil3UpMzALgmflPMHr4myNMMRsbe0CZL5Gv5UScB0sdE/uPUPFSD5A/JLROUEY9sJHj1OM8fUsCSX76J2d1SazjmqU5gw38Q6tbLcDCnAB7MeUIXHvPijJp7CpC2QeufDtVT9aIQSy2wVnFQ3YIwUM0gvImk5FHKAU8Fa0LoS5EmV3CcHh/3IJ3TZYapqh9Mvcm8bqur4N8lPqy0UU10yrUvJs7WnjQwOltpfI+EUxkT6v1t0pdnpWnhuKN8Zg+4iiG1Um6YuWMn79FTzyDBc
 QAvbffEJ
 oLZF3goENrwy9UN12eOINpgxahcT5rMWFLbfcsvRcyEZruRad+K8CXheTU+KoZgrkyvns/zDJYvxAJ4DkM5gCratfXFDy8OieZn4r9YPR1vVxQKKzCk712dc3XoA44IOhy4A3Vjc9uXV47Bu4SaAR+nxxjOo5ZpA+0rJ3gVx7gBHwQVZvgAIBhJvdU18VgJHlFkI1ek+oOK5J7a2LI7iPAojNi835q9KXNYpwg/Jl9zXR4sA6Z8Oa+w5+fUO4U7/TaOqz3oZPsVVOb7k6sn/UfTwNYxwp5bbu0IAISnlZRZFqKR1vP9kgep/8xs161F79wfvcaC9y43bpZVKta0MCwinrgq/CVFwNbgXI4f9Ei00mEVSAY/MP0T5YtcGWWhDamARG4rafNVbnOFFOAay7QPlAMQE884Jb2fYUhFg69ENpf/5EuSb84KGiSxlYebYl27hdzq+CKpbAgo0e9H76kBtoJ5cHnadfgqDhE5Db/NBbFLuYaEnC+WSSXuI2arZc9BFf0/sOAvgT6nzk2/02wcCB55ccg7ypRGLA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert sync_global_pgds_l4() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e89b51aea2cf..a6ccb83f2d26 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -174,7 +174,7 @@ static void sync_global_pgds_l4(unsigned long start, unsigned long end)
 	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
 		pgd_t *pgd_ref = pgd_offset_k(addr);
 		const p4d_t *p4d_ref;
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/*
 		 * With folded p4d, pgd_none() is always false, we need to
@@ -187,15 +187,15 @@ static void sync_global_pgds_l4(unsigned long start, unsigned long end)
 			continue;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			p4d_t *p4d;
 			spinlock_t *pgt_lock;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			p4d = p4d_offset(pgd, addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!p4d_none(*p4d_ref) && !p4d_none(*p4d))
-- 
2.54.0


