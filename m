Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DD7D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D310D6B00A0; Mon, 15 Dec 2025 16:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC256B00A1; Mon, 15 Dec 2025 16:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD8B6B00A2; Mon, 15 Dec 2025 16:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 976F16B00A0
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:29 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6626FC0316
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:29 +0000 (UTC)
X-FDA: 84222966618.17.A892DD1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CB031A0015
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B0NW+ThO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833447; a=rsa-sha256;
	cv=none;
	b=tKiZN8HqWSZwnjjcknK3Hbs/pIikSGfSH7+sAvZ5wpfxBdHqKzQmo7A+9YDUfh+P5/PnKZ
	LJ282LUqTIxX7L+pOdg5lxg/3MUHYHAFdJOe5zOvD9+th3pR2saOFyufforZfekM5qWde5
	Sbynk1gmoaaKzl+eSuvz3SnR3OSBnxk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B0NW+ThO;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTSOH2pctXhaKsGHgvQmmsRPhPghSOFVRWwpawQqEhA=;
	b=b1yHHQ+FpOT3AEKAw+Mf4LL27HRO6jvec3F5V6OT/SmBvTb+Y9laXi4fYbQ+paNkE41EAx
	l/C97oyois6OR5mg2Dd/Unw0hw+JIteytscl576BvzXO0bHvDrVvhHL+BeBzVh5N/svoej
	C25q4kVC7rDgbb+a+JJqd3TSxKs0+hc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PTSOH2pctXhaKsGHgvQmmsRPhPghSOFVRWwpawQqEhA=;
	b=B0NW+ThO4NDW8t24Ach+dPcV8oqnC9z4IdC9lf/Er0TkBDfdHpoGdQiFcX9FVLP9CwOtN/
	VgrgQUjr7sPqrjfDYUOYdftr72aD7ZSTCXn8IgrzLxoc+olAyFDzAd/7WonmCer/r7G+sY
	E9uO4g5n0Oe9QAIvnpu4iIP0BOrPhak=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-ZCqkKNbwPXKyRb718mBwbQ-1; Mon,
 15 Dec 2025 16:17:21 -0500
X-MC-Unique: ZCqkKNbwPXKyRb718mBwbQ-1
X-Mimecast-MFC-AGG-ID: ZCqkKNbwPXKyRb718mBwbQ_1765833440
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46AD61800245;
	Mon, 15 Dec 2025 21:17:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 244601955F21;
	Mon, 15 Dec 2025 21:17:19 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 11/11] mm/thp: x86: cleanup PSE feature bit usage
Date: Mon, 15 Dec 2025 16:16:53 -0500
Message-ID: <327e07e0ff3579857b11d14c837ac6231cd113b4.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 9CB031A0015
X-Rspamd-Server: rspam03
X-Stat-Signature: 5kt1edziyza6f9ms3u5pannmwn9djuhp
X-Rspam-User: 
X-HE-Tag: 1765833447-698739
X-HE-Meta: U2FsdGVkX1/6Y64ZTewUu6llrecxCGXEfWiN9zFqoSV1vjgWYaNLfTc0hI6gLWmt5l91wQ1SK3cxpiIDSCqZJsS0pDqGPNXvdm4S42LleRgsf5pz07r/QL38TkOvoVLMZTyr7QGFIAqw6SkFHyBWe8M8h/xcPix2BNzuBk4xh/kzNoDT4QGT0UGpNym6pNROZO9SCmXrGrVSOgy6naAigjL09CRvFhaoF1VpaSJmTvZS1bspYJ1jvWGZ8ZZppsmm9dDAIuGTt2cYfIrhIyV8xfhRgA6DZkNRvvDB6TbAUv5dolWN3lHkjSav3+p3FQLgtOjS5ZaU7VeAxxOHRY7z+VnK6YWBduBSNrWEM38q2eFt++Jz3oYgenJPwWcY/akNopZQCnjAM761S0uRg6gNNDYo2fxp1Ht2K4x7nH08kRl6fpBVwovfj/gcnzXLkNjeJS+/Pl9wvzzO5B3dkHR2V1egR9NbLjPZknXrfFbbinvIzfAxEW0z5Tmq8tkNhsh39/nhuTG9xR1BL7IAvC65Z1r9l2tVi3JKsq1KfYjbzOV+5k8zaq/KKSRbpLKkkDv4pXYV9P9ndsEqdDLCjfJl0HWKS6y2MavR1uJVKUueq6qS7rzAMrToy7ASYSxR9dV2M293ih7sP+iFguVnrjk9YzTjaGWX+E/ybf1qfBILYHmOSstmAp09qdmHQLnImawz7egkStsNZMODCpqnnA+ybn8xRPJs3E+POJ5bnnXOPgEApUf7IYtZPmJsTi7S+WYMteN8Jc3K2pHm6qBzD/It5ZbHBaGS18cTLs7ppkNARQI2Vq6ehTkbEsQo1g86c1TdibAh1Vs22KlE+qWjw7R+w/+PL9/3agsWK2lpL4959A0/DMc6+oiwTwRcYwHGN1aNFptH2Fi9w+Sg6NP5lipkgDDocoTAwdt5w3HXfFxcNogiyyeX4FFWAbRBWDqFANgFiC4KsCW/i0PLAZ5jXXH
 f1k4gBa7
 pweQYVZz05Pr8M1xDbqinOex5+GUXurExTd5pjx0WZ5h7p4GtXqPISvrsApfUc56rUB9COmbJHh5eLlaP2Grt0USMhIM598uwrCqS2jrOiCyEVNWJ0UjVMvspaMdl5Fb8LXDo2siDlFX8SmalKJm5Lznxd2lxg5dWvZuRCAeZ2+1j8O1kISyb1pVhA3CTX/zknlbvArOG1v7dRcq3wH7kwMSiImOBzJOqomlh5UZpBZ+5K6jMnYLqRgnym0nCO4OJzuKFwuthjVAdhrnrcHdV3Bxhzl5xu3PRsgmXYokMAHnqF2qu4rrG6fHeZYzU0u4XuI364J0PzXbv3HQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically, THP support on x86 checked the PSE feature bit to enable
THP. On 64-bit, this check is redundant since PSE is always enabled by
default for compatibility. On 32-bit, PSE can enable 2 MiB or 4 MiB
page sizes so it must be checked. To clean this up, this commit:

1. Drops arch_has_pmd_leaves() from common x86 code. For 64-bit,
   we assume PMD-sized pages are always supported

2. Checks for PSE only on 32-bit by implementing arch_has_pmd_leaves()

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 arch/x86/include/asm/pgtable.h    | 6 ------
 arch/x86/include/asm/pgtable_32.h | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 08d109280e36..55b88de5178f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -313,12 +313,6 @@ static inline int pud_trans_huge(pud_t pud)
 }
 #endif
 
-#define arch_has_pmd_leaves arch_has_pmd_leaves
-static inline int arch_has_pmd_leaves(void)
-{
-	return boot_cpu_has(X86_FEATURE_PSE);
-}
-
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 static inline bool pmd_special(pmd_t pmd)
 {
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index b612cc57a4d3..3bd51cfa431e 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -45,6 +45,12 @@ do {						\
 	flush_tlb_one_kernel((vaddr));		\
 } while (0)
 
+#define arch_has_pmd_leaves arch_has_pmd_leaves
+static inline int arch_has_pmd_leaves(void)
+{
+	return boot_cpu_has(X86_FEATURE_PSE);
+}
+
 #endif /* !__ASSEMBLER__ */
 
 /*
-- 
2.52.0


