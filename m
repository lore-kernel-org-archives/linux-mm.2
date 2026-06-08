Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D39BCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 07:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3FC6B0088; Mon,  8 Jun 2026 03:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283DD6B008A; Mon,  8 Jun 2026 03:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172FB6B008C; Mon,  8 Jun 2026 03:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 018436B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:25:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5408B1C21B4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:25:51 +0000 (UTC)
X-FDA: 84855910902.11.E9B8817
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC7DE20003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:25:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=km2IxtHZ;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780903549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KTBGi8oCZ29Roe5CgH69uQStkzIgyiOeC35FA5eeDPU=;
	b=HUlKd8CxNCx5R9fha/NCU+PvcMIhzErgx+lE5cj3b32OKzEystor+nB8SMxUMQOhwCpqdA
	jTCbfw8Vi6Ba5QFpP4Zoxhk/hL6uyg3ov6FaMr2A2CYspwxWZotBfiunKAg2T1e3JnwgVo
	MhUeGJZtNlBqDpR2w0YJUM/Q1EP6eeI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780903549;
	b=Texm+WzFOZVTEg/rgkjQSHm2AAvtg02tDBO/9EDpkZAWRu3Z+gKj3gh358dwILhPEqzAPs
	GlB5V9oiviqamuiamOu/tN1F1otqlUZG1oxZ4GrIYbjsoPXgOPag4xosz9eysQVMpLuTEP
	uHIYcAkYKbMnCIXBEtX5I0lnUo2rqaE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=km2IxtHZ;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C62A240715;
	Mon,  8 Jun 2026 07:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F141F00893;
	Mon,  8 Jun 2026 07:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780903548;
	bh=KTBGi8oCZ29Roe5CgH69uQStkzIgyiOeC35FA5eeDPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=km2IxtHZIktwRU6635g8jlJprIRhl9fSIjqUyOj5lz8NlJoVU7udXLnh9gxiQHqfN
	 Ho8tP98QVDYT7e7M1vtNBaxY3ZqxywP7vPxCLlfSpM5R37nNY4LON6vctCRHBZ9rTJ
	 AOrOiBs+dZ7MEKnAO2NzHFmJsnmNM9zdqPbSrcKfbT8snI4b0mjjwpcfKftahXkR57
	 Amyr1wvgAcMN0xcrfpIud3JS0pAhGC71a0s36Az/truacRX9P6qr3vVc8dGSr6VpIG
	 ibS5OGgaRSMwuZ1n4j6e4QEzUSpG0Bs4StxI4B6M5tp9/dh5M/m70rDA3VfPBW66hF
	 KKSdU8i8BNyAQ==
Date: Sun, 07 Jun 2026 21:25:47 -1000
Message-ID: <7f5f7c94601312c1a401fb18998291cc@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrea Righi <arighi@nvidia.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Yonghong Song <yonghong.song@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 David Vernet <void@manifault.com>,
 Changwoo Min <changwoo@igalia.com>,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org,
 bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH v2 bpf-next] arm64: mm: Complete the PTE store in ptep_try_set()
In-Reply-To: <aiXVFK_qb54is8b1@arm.com>
References: <088f52fd25860ca961449d53f91b214a@kernel.org>
 <5f68f44310d4878185fd5ebc52d66530b99f174c6d04ab1170dc53cefaa54568@mail.kernel.org>
 <1780862659.ccb18e27e916dc4b@kernel.org>
 <aiXVFK_qb54is8b1@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC7DE20003
X-Stat-Signature: t3aoewurb956n51gwbhqgfnr6fnb4d5q
X-HE-Tag: 1780903549-45834
X-HE-Meta: U2FsdGVkX1+aDUqs523CafLyDOSzmT5M7CXoOkeNiBlGeOl7Us2mNrZzJIP/sqNHsNHW34+NAH4IZr40jhE8ewPxdvPu43w0yBC6qEtOzqlAimfSiUzAGRC6MP8GaNYPaPDP1KXov/39p4Xza0mbZO4fgDYGFyNmzIVKXNOpg8AQiwKKVYIGZuJ5Eyau6ZsyOPTtkriAucEnmTXIUEppyrwFV2owKUTbINruuCmFrK4Nul68rUXyglg0L38L59cvrPMAVdU1oXr2ahbKMHjXYL8odv6heY8LKrGvsMY0vWK1nvKKw8vSIN8BOecOqQpcfLhdQAYJtXxmwmNYeogfsibRJOmb3cCIremQlVB4KqleY8c1qt2XYedcSGOR9aV85PqySHfBZCTFgm/Z1XCjkf2f3MgpSVpSPqCoI5Q/C+Q1pqvsSWtJ0Cv3KhchgDmWmYMHboraTBM4QWYKN1FuBDady6PvmQFzm52V1JgFM6emnuA1LO8CMiQHklm8WXEnORjWqcVfjapzmoAtWL3NxPVE7KXeq9b1/QYPLGkR+6EyaBlB6/2iULd1NepE0mGTdA7865AUHPoZbWCGGmKS41dBfO2zrCUyE1FFXY8F0tEhhqLvSibrxREoopF0T80+b04d9XHa4ciZOnXZhu8dpX4tXZ6pJ4SrVnOLinpUv/fjGDTpmFXH1Pp33HVni8/AVtr93W1kaQTu+e47II9z1GygEoouXrWDpbl01WrJb6Awhvlhl2vcm0p+dPS7sDL/9RIQhxq/IMLMw+i4fJFZGXjhzVLuXPAptvPhix3GdeboKL5lfarZfLQw2M8Uk5fhcjycd3NoL3/GJzpoGxmMyLJ+q41/hvxNWwlyH0RF4WxMgVt8WSFnUzSCFuausolb80OWQ6FF+rWNDaY4uhPqJhgLT/w4u/lHhsfV9gkvUzArpD3pTlkl2D0HuDzCm0VEutlKCxx0Qv0UJ6PEjBp
 KgZ4kRFf
 xFWUzQMFw3vyF7y97y252pIq2FyS1QwtDCq7upUwF4kug+LywrxHTFz7asQfv2EnRbk3dvP760vvZDdjuOyn5065C7fIP+J1NvOa2/y+IyFCv2u22NPeVKj8JE8gUa3EIyLPGQTngw1wWKn/kEwCJTdPC1zfWU4313mSNAxl2G83SCkwqybxgUg5cbB1pOSkqBa9bDqYt0KR3O51fxfHG+YrkaamOoKfUCWBStWL1pxIjqIw3c57qHkLuFjli5zv03K6jN6BZ5kvSGBJ9KYoKOxE7/+XVc7qmV4IXezz/fUReLstCz3q1mDB7bybc0v8yWfUuhF4kEqr/hCqSan4/4gD+46sGEGN4kn+kxhGZypxcU+8B3NLXxDK+2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_try_set() installs a kernel PTE with try_cmpxchg() but, unlike
__set_pte(), skips the barriers that arm64 requires after writing a valid
kernel PTE. Without them a subsequent access can fault instead of seeing
the new mapping.

Issue them with emit_pte_barriers() rather than __set_pte_complete().
ptep_try_set() must finish the store before it returns, but
__set_pte_complete() would defer the barriers when the calling context is in
lazy MMU mode.

v2: Emit the barriers directly instead of __set_pte_complete(). (Catalin)

Fixes: 258df8fce42f ("mm: Add ptep_try_set() for lockless empty-slot installs")
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/all/aiRFcz78QTZdIHHB@arm.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3ce0f2a6cab6..3e579c26b383 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1838,7 +1838,16 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+		return false;
+
+	/*
+	 * The store must be complete by the time this returns, but the caller
+	 * may be in lazy MMU mode, where __set_pte_complete() would defer the
+	 * barriers. Issue them directly.
+	 */
+	emit_pte_barriers();
+	return true;
 }
 #define ptep_try_set ptep_try_set
 
-- 
2.51.1

