Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C34B103E19E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9468D6B02A2; Wed, 18 Mar 2026 11:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E546B02A4; Wed, 18 Mar 2026 11:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833D26B02A5; Wed, 18 Mar 2026 11:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7054E6B02A2
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4227E1A0827
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:37 +0000 (UTC)
X-FDA: 84559623834.26.E81FDDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8B87F1A0007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDPMxDLz;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glto3nNF1o9CHd2IWYLUNY37G4HJU66Jefs9tYxHtxg=;
	b=0tpCvG9hxbu9ydEeXoDe7HUqEFs+vORGkRv8UUE9c7OumdwLWQ9lQX28Il10IAinZqW+cF
	eMMVwLSGMgv98XIvAg+Sg8PFxnS+LoD8M7hgiNQFXA6E7++HCMJ0DYf1z+d8t4UX3ehGXQ
	ORFLWO+pPHfA8SIe6q7yxfQUSMD6Jdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849095; a=rsa-sha256;
	cv=none;
	b=iA856QNuThLDhR5/xEfyScb7XR6bQUGOvmQ8SKrLWIbNtE9jSUwKs2pREKNNHzeQOWwZaS
	Ol9XfQxgqjnTjzjOLGu58He5CZTZoq+vT4HEQ1uxXetbbACY0DUtMMLh8YeyZExdlf+D69
	D4NfrcPBLEkBqVWLybYNtCUmCb4KdGc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDPMxDLz;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DEE43584;
	Wed, 18 Mar 2026 15:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB3EC2BCB2;
	Wed, 18 Mar 2026 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849094;
	bh=150j1rGpWka5LRXWKCunu72PErJxZ/dfG4LF16Tl7W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDPMxDLzDvDDTbMPL2/3zxMJcUyos/Kd1krK7p0PTRGQJegUO1mUk5Q5Xf1QCFPHh
	 cmOM/2QPFmFxh9bxIBrCqlkQp3t2DXUBsQN7TiLXICJj27sUQSjx5hD01nv0TYVNLa
	 po/CcfNmhBTzUUuinyzxLAsS5JsdajCIt8aA4k9S4kkfSaWKlUeE93uFoI6TaABUJy
	 FP1L6CjQjhQ8349B9Yf6djzVckaaM9suzrhHQ4HkUvJTJ4WYydMQPStHwmL7Rby5NI
	 FLVa5pmYi3r1kS84AhGJs+gxE9WLqEykq5Z4i1FB4hnpQOB7ih2wwMO94sdFH7a9b+
	 De0uTburJz5FQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v3 19/23] mm/vma: introduce vma_clear_flags[_mask]()
Date: Wed, 18 Mar 2026 15:50:30 +0000
Message-ID: <b2edda6f00c10ef63013257f282cf155fb371b06.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B87F1A0007
X-Stat-Signature: zqmtko1u5hdugnh5wcf8ke5tgmw6a9g3
X-HE-Tag: 1773849095-208343
X-HE-Meta: U2FsdGVkX1+5YXnW2vWKnv6BDv1N9/NLmfHcHumMlYxOtk5s3q2N+PnL+uTo3yXr61EQoAUBhh2Gy7UnAtwngOGy9kMevruXLB2Y2hoPbYI/j3wi37/RJghebyIcLTuOzmo5NlTqYs+GHXqSwmj//MO98w9Y4WCz077HoXQ7peb7hHg5/UsJK9L3xsNPO7C+urtdNCqgxEeFlqPgzxIA+cundgGk9ZzOGd/T68MrciZVCFZk4zMXyVD7CCF7lXJNur+wFaYMmMWIMN7mYytdAw7FHJtRjlz6ToKGGb0GrgF1ds+7GES7Wyzvw+JFIlWBrPf21GJXFvNrt9/z+fxObU+lA1hXSvF55gvhA/Qpmxop0/V1UY/nlLJaH5o1bi9Pmu5bmo4URx5l435ix4hirAHNTSG4xOs79rZ+0cR3ipjKYDzmcSJPwS8OESbXQ9PM1OzJrPcQcSVKbA6lYXWPz1Ceo1ag2JSwUT2oqUmFX1kMpt4KL7X1cvjLyvkAvHnretCYe+XZcrk3haVvvyxD0IUdaChFfCs/HYybKo3lEszPZl4Xg4mlSpjdHGJi/UCax4ia6BJTjyQrApjBbf9HzCAq8vc6vUpSeHsGvvEAZbNkoX0whsz2d4a8t2v3yQuWiz3jWvqbu8YmJ491F3n3rXb8FShzGUlHky+1X1EtgaYULNko92lYj/Gg9FcOhD0/XMY5sIvj/E9VvI8nkh9YneWmNAqkpMBInHrOUI1yJCL4DG20v+XgYD5iQeSoxyorIEnSxRIONeittzFWXHMIUPml+hnfj6oi4zH8g8MEe8ZSq0ui+krLne/RF5mN71NFF3wQu17nat/ahmFHZ6GPgSaT+QzA7houoemjq+QPeIDwOZMFs4dibVeItURiBY4G2Y1zDnkKHxH9lJEgjtZ2zVfglB3+UdbQ1VPMlfpCTHURvFg0osCitRLyEl3h6S4BmsWz1mH3iBOTORz0WYn
 Ap6HylSj
 +bhH4i9bPBqYEhjUJFR+jg28P7Kc5xAMAYkbAwyU/NODG/4vr/KowDPQWM3prjtO8wBQ5GopqY96XwQiw0hKmriq98gff0+fG+BRxBr5x2eXOH/O93929+C9PE8G45D5hoB+txHAeYRfVUHTFyac5Zs+vM1NVytrqOuv/Uo+Qz2JU2qlWVO8qkdmW3OmDQzZZZc3vUSVg27Ad6R+RPiKQnNdRay3A2OMI18bNhSM8VZJ0pdgktiZgPOLSVKwcaxagpzcD877V0h1G3LEa8cJmxBBygArh9vMUfBASfl+4D6G9/DUWb54X7B7OC1rI8qIVgtXIQfsHm8kMDyjnXZXaZAOFnXTdRHGJ+FRF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper function and helper macro to easily clear a VMA's flags
using the new vma_flags_t vma->flags field:

* vma_clear_flags_mask() - Clears all of the flags in a specified mask in
			   the VMA's flags field.
* vma_clear_flags() - Clears all of the specified individual VMA flag bits
		      in a VMA's flags field.

Also update the VMA tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 16 ++++++++++++++++
 tools/testing/vma/include/dup.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index eb1cbb60e63b..4ba1229676ad 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1368,6 +1368,22 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/* Helper to clear all VMA flags in a VMA. */
+static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	vma_flags_clear_mask(&vma->flags, flags);
+}
+
+/*
+ * Helper macro for clearing VMA flags, e.g.:
+ *
+ * vma_clear_flags(vma, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
+ * 		VMA_DONTDUMP_BIT);
+ */
+#define vma_clear_flags(vma, ...) \
+	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
 /*
  * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
  *
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 36373b81ad24..93ea600d0895 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1065,6 +1065,15 @@ static __always_inline void vma_set_flags_mask(struct vm_area_struct *vma,
 #define vma_set_flags(vma, ...) \
 	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
+		vma_flags_t flags)
+{
+	vma_flags_clear_mask(&vma->flags, flags);
+}
+
+#define vma_clear_flags(vma, ...) \
+	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
+
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
 {
-- 
2.53.0


