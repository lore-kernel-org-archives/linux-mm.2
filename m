Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B007D606A8A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eQbhO6D7
Received: by kanga.kvack.org (Postfix)
	id B63B56B0650; Thu, 12 Nov 2026 21:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B140C6B0651; Thu, 12 Nov 2026 21:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30876B0652; Thu, 12 Nov 2026 21:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5F26B0650
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:51:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1306A76B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:29 +0000 (UTC)
X-FDA: 85428569898.12.40C881B
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1FE51C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:51:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eQbhO6D7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794538288;
	b=1pxVlS7gKwkjMAbr+O7qZ4MAgIDAUJrkv/a9jawcmwFkZvQPlKz6kSwvfTdN4OT2+lNl6D
	RR0snIwGaR1wIwD7m4mIN5KxC9FQb39pQkTYkjUwVLVVFCI0B0lyjR27FtpMCRRQ8va93Y
	SOaoxvJHZOhXBoSwEPoNI5z1OjTFAdc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794538288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BEjGpvcrNvlHhAnch5bFQ1ZwAUgnUCLZ3mkaXsk+SiU=;
	b=K5pAXWr5y7FB4hhGN7/FS5ydEQaRY0/U1w/aRyQ4S4r6yR4vJI4FzN73JtqiRNQVuV6zlr
	70FzrU7r4yNernr5f/xizXkBN9ibrxnwouaSKKR+OTUYUHttlXeb0z7CTnER/Qq2AMC3uE
	iXSBEDleXMe2DsMSddXjfDAOo71uERA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eQbhO6D7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15dd124bbe7so324230c88.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794538287; x=1795143087; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BEjGpvcrNvlHhAnch5bFQ1ZwAUgnUCLZ3mkaXsk+SiU=;
        b=eQbhO6D7YQEBfryAZpIv3dJ9p7x55aHSGQruubzZXxGcujcv9DxEw7j86FwFXTh40w
         cLm7i1AFINBtTx/UbxR/3PK2ueW+twuMbAGPxAU7nVrXXQUveG+K7NUJa2J01/ixqwLi
         nT/dfEGebG3iEsU1blJF4CoTLOKXPu0XhxgGl4F65eJI3hYU3xfdmWQN9t6LEO0EuQbE
         vHzcGLIAZuLOdRHEoE2eYsUKbyJZ77kJjXvgBk2kWzm3qn5Rj/Dg062XczdPLm1TXvIp
         ld2c4VghZ9e/FNUGnlgkwspcwDgfisoFwAfAH4ucFaKCnKVN1NIUJ9DxOtkOxKCvOT3u
         XP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794538287; x=1795143087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BEjGpvcrNvlHhAnch5bFQ1ZwAUgnUCLZ3mkaXsk+SiU=;
        b=HnzeAFKh3eFNC2+S3HHStugF7KGTOD0dkYNuN7SC+zyraOIgZvjKOuL8Q44zFr7Lqj
         KdlqqC1v7puc79XjZiXx0PMGp7aB22FY2oO8BeUj+fY00GcNgNt91Rp9JutkXPA4NSAl
         vCVGikysC5qKsX6wV4/InSOBPkiq4vEcA7p0kviBZo254rlTAC5G3GpJ6FYCEbEn1hWx
         nMK8uyIFCyarTJPtWHtK0g7HJee/ZGbis+6ccxACcjXyR02PARdUvveXiq2Gubawu4OQ
         utrxReZlzVNY3I83tLNMeNsHSNrcCp3Mlx+3e4XAm8jucd99OgolyuaoDH2DtXG5+Dxz
         lDGA==
X-Forwarded-Encrypted: i=1; AL+hErEqacoVhxFMkb8sSc71eBLKcbOJX2OxSQ7NRENd7gyFGiFT5Gv2SdA8bvUS3illbyH3OJ1i2qYAhw==@kvack.org
X-Gm-Message-State: APuU4Z/xHIjLt06vnwhu0Dh4tGkxHGPNykvsDC0AR2j4K4ZXFGYBd4Rr
	g1oB+u88HgMMEvuyp0xfLixsEOgLXnZuReHKLzkEANtkdqAYfkdVokfm
X-Gm-Gg: AYBFou1QwjlCw/9+yqvMmf1HUacoUMDjpqaTIyZ3wCtdiIMzB418FuWJEL1a6zVhmcV
	Rae30AUxKWvz8anxpJBEnf8HkaQ/IH+vYUQBQNKbRHYbK0bISiOUqRgE1Y1yQEm40XGWTuJwatL
	O45bbyhUmVlkUhQeDRtWR0ili+EcEam4dprKLqLZcasiv7UxE3/wybuTZ+0YNkJU7YaedFMtGq2
	aPTyX4YWnODlfRedNIJ2V4YaslaA3b4CCpzqKNMK5wkVO0ShvGiN7PqGX+rOjpT7o3VbI/qnFT1
	CHgcVYFhghl9m00v1bATmSHmRiN2si6WjORZXSloQbdNQNBtiHyk7PSWTuSA08n1/v821Tf8CZD
	eI6xdfqbpJxHLrp2Qp6uNMmjyukLKjrYycUALy9ZYIpGTbvTPyPXR73Jb56skDDQld312fGf5Fn
	gw657IKR5e3XWJJOJuy61qmvPT12eTSu8SNJ/X8QlJCxrOE/ASxlMqnuxvAraj2IawqoN5fjrjq
	rzP93aWCUCoOrh67CVPmm3c8dYtTfGwpaE6e+PIe+U2gDgvwEaITTMRRgSd9bTKGPwH5QH4LK8P
	qrcE/Gj2AF2jGV2iO3tc+C9NzWAgUgOMqw==
X-Received: by 2002:a05:7023:a4b:20b0:1b2:4e2c:6838 with SMTP id a92af1059eb24-1b50314bed1mr1240666c88.15.1794538286798;
        Thu, 12 Nov 2026 18:51:26 -0800 (PST)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319d40asm2853771c88.11.2026.11.12.18.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 18:51:25 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	chleroy@kernel.org,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH 1/2] KVM: PPC: BOOK4S HV: Fix memslot rollback in H_SVM_INIT_START
Date: Fri, 13 Nov 2026 08:21:13 +0530
Message-Id: <7510ddb55a34e8a669eb7c2624d652264701bfba.1794537345.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FE51C0003
X-Rspamd-Server: rspam12
X-Stat-Signature: 9srkj1z461rmijuwjqppsaxx5f3pt4bt
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794538287-588478
X-HE-Meta: U2FsdGVkX181acWPXGfRkIFGW7SwzBeggDw/2EP4+639evN6fcQXqNp0nQgvtePPYr2+kt7F1W5HrzusTW3uJa3Bsnr6zOx+R0KT7uD1vznw+fvw2Q6yj5x1uaq7VDz8E6eBLfOKoqijGcDuCGBPrApljcinRCV8C1YDJwAyq06Wyckpxp455YujhP7t6vJCVZlJKykMf9GFnudBlG5eqcYqwDXCJFOMPAxAKfkt9ZJSuVJXEpYlaZajiEumhUdPiRrEDq0cDjkVhgXU/KSBkPe5GOLj211DRZ4xeo5H1IGt1zayRmDWCZ5Ab7NoluJvA/BGMDc6kyNH5BlON8Ru/Epqo/pqqteSAJnw9MyOKkLsQ2kz1Sx3e2vBQFgVnD9MXa3hKuPcKw0gZlUU66bMa2QlC2Yn0EyzP2z2f7xa9RLTQ4TRFTHOobzrL0DngJmGZLeYeQ+RFMRyqOwP6n2LHveaEL+RnHrDnZ6Bw4lwpCiYeUi8o0A2b2PUxJg7MF8mN8VyUZT0jWumR17iUow+AVK1CUtPbW3+v4h8uQq3HlfuAax6xcpaPSvruhGff11nAiXi8JxyJqCPOF/9iX889CoBR8KxG7y0JVFhn2mLTyC0rGmySH2QK9y1xAWIQn9n2UZx/LX6BBVsp7xpBr/572Zw9fhXvg2qH7cq/5Css3iJlb49ujFeOT3i+fJsES7B4zKZLF8ThRLBCMgDjF/fnp68kNA51zc2P28v3i0kp0NE75F7nlhH68Jvxs6c6n9QuSb5f9CZxf0revUkmK21g2Kxzv5VP8YSPXQMpBpL8SMLdFHQ1+RHyIlqpv+4JCKKdseCyQqEDV4ZsPxm4nBsjSbIGaJfr9ANg7j5OCXP9N7NL/aZV+JG/SidgPa4A2RoMgwEdYe1g1YMqb2egVMqlRNX4t8I4aAbf1dh0l2tiK2OA7iYT7m1PrARQPMZJK23uHVshH7TbyG7w51TeeV
 MOCkthO7
 KdFN3Yh0Jw9Y7hcBUPXA0nTVHr11kNw6YERTB6LEoeZWujNDtMyMsqJRAckV0ywWuwsgz6eu+Hs3mbRakhI1QypcFEGdZl0HgGoKiv9a9Pxh8s/Q+8DQtCl+11OEUlIaSe9UNzevXPPvWy63mtdZDNwgClwwJVkJ/2jslUgQC98VxTCCSqCSfnXcRcSK4j/b9fYuY4/XKdU5c0zqe2g0cMEVQRatjtr2ahdRf2BskgFaGYOl7St0JjyaC5dfKW9ywcfK17Bf1/Zb2nVI6xif7R5qBCpJShky8Uk7t6HnwA5jvrPWzsV0b10S1rMbiKaepDmNM42ZSuTrdk5mR9VX2YkloeArp0EN8rYNXXJNOaESGTQv6SyeYWRSk6jK6lKucU1AwDb9OGgpdQS8n999/SrvMd7f735xNvSbd+1k3tKhL1TtKezAf0/GhqqPzgDwXVDblRQczGjlPjJpNET3Er1aHhWa0aDFrhzPM3UTM/PoTKvNq8CyXh9vNKgMWxVA/hMTbVHJUwrTNDCDH/C8zeAfHMGN3UheAMDUtgBnvf703m01LfRInk9xMIChxFoulObkKGI4Bx2KQd1o2tMLf5Eh56oi/VGHl2U28BYKQU+t8G+CfiqQdu7aaeuRXzI91HoUg3t/VgdjGtedy76Q6wGFCYNflgpiDhAGJMgvN8Ap05F8/FAP2coKqKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If registering a memslot with the ultravisor fails,
kvmppc_h_svm_init_start() is supposed to undo the memslots it has
already registered. The loop walks them with "m", however it wrongly
passes "memslot" instead (which failed to get registered).

Fix the loop by passing "m" instead, the memslot which was registered
successfully, for rollback from the beginning.

Fixes: 2027a24a75ce ("KVM: PPC: Book3S HV: Disable page merging in H_SVM_INIT_START")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 463aef870c4e..190f64d992d8 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -497,7 +497,7 @@ unsigned long kvmppc_h_svm_init_start(struct kvm *kvm)
 		kvm_for_each_memslot(m, bkt, slots) {
 			if (m == memslot)
 				break;
-			__kvmppc_uvmem_memslot_delete(kvm, memslot);
+			__kvmppc_uvmem_memslot_delete(kvm, m);
 		}
 	}

--
2.39.5


