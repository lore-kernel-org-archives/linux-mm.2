Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B8AF506CE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E086B027A; Mon, 16 Mar 2026 09:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4716B027C; Mon, 16 Mar 2026 09:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C356B027D; Mon, 16 Mar 2026 09:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34E136B027A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 075111C1BB
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:37 +0000 (UTC)
X-FDA: 84551957994.19.C93AAD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C9EFC0016
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=juiQJPuZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPhRODiUmhApdZ9nninHZXaKw/32D++OFungj9CnSis=;
	b=2OdHXjnXdG33e3BeLlo5FrCOI36h22/s+yXOiVS8dLv7ND7M90/TLGR/a3SKKQJ1al/6bY
	WGbLZ552QO9pphomaoMDB+Be6VpvQU0v5w2TO4iFK85Y2Iti+N2BgW7UEIIGKTCYh/pcr9
	q0mVpFmM1cM88LIk5RZrKyonGDOYP6o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=juiQJPuZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666575; a=rsa-sha256;
	cv=none;
	b=7Ch8BRvQXok3YtoBoQ+2Y3G98DgwjzPGPFbEHIAXlRnXA9oVtAK61AdlC18UA5KtZWnD6X
	/vW2uTvc1pUosNMXQSgxhAvs53dhmLCxFAW/NOMEMesvDwNqjj5f2GQSnleF9i+tYti2Ym
	8iJzwTeFurl/IA+gdb9hbKMZdHCDbLM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6927540022;
	Mon, 16 Mar 2026 13:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24FCC19424;
	Mon, 16 Mar 2026 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666574;
	bh=Rovsmd7IqTNzI5EcVU23ecGwNpd7/HeY2RA96JWK1G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juiQJPuZfc9e5wy1LHgzPcJMKjyytYu8YDhD+rkUcOHfZ++HnboPrPs2YO0Ft9ix7
	 qyOyvKZw6U3TdXhU1+ZQ8rmaW9ZvOCCszAK44XjdsPQ/A/sGni4fIuKY/qM1x8jWK+
	 84Rty8AQjyFmsuRlkSKxEBig3RI4/typwyJxITDJ+dOjfizmIP5yRxN7XDkiadZcvM
	 mECermzA+YJNLkvKRqGPQ/gvxI6nJMyXtUkSsHKF1xbQn/1K9+qiE5JOPSbz4PidN2
	 6jWyHX9Q5MlslBfNynomb5OViTOuvMt3T5QY0+Y2CX/4QrKPBhDLRZcbH39Rn0JKvJ
	 NR3xw++7nlksw==
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
Subject: [PATCH v2 14/23] tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
Date: Mon, 16 Mar 2026 13:08:03 +0000
Message-ID: <ecd6e0134c4495310d6914b8177e99886e17d22f.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C9EFC0016
X-Stat-Signature: gh193tasmy6e8yrye6m7ohkf1s1ifnuu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773666575-885246
X-HE-Meta: U2FsdGVkX1/HDDei2iTC0P9oIKumIG/KRe9M69fXhroUnCO143yJrspoLnPwVY7c0VMvutTFm6uWdIdCkFc8ZJtNk0NjrjkcjlCNE/jOEGinYcz/IJ9zsC1cHOYxYB15zUO0QkraihJXO1t9dxlMmKoDMr9W0PY6B2ODwYp5/sO7V3J9JvFf+YEpTbps1D1ClEegzOX4H2dAL3w0g8+diHAR5n/ciZrXXqdfNzzaUlHZud5T9opBWiJWVzeaJhFCx8jsiXy1LEzxA4hRMqufLj0AIORpClWwhJ34qkwHYhKbkwaFEspjmDMs83wkS6kBZRDba6y+UAB5qGzqhIlhoWhQHdoMWpWgF+l1qggQfbflf9TGOp/uF9oUnUTtkkgYzu4aBdl6IDEmxu7kw7NAjdPeq1CpinQFvjunyH5XDSVJXza+i+1PP/hv0UkBo+cUUQ1XlEv44JA1sJDdbUDjPTDEl2HLjoCT91FcDO2oVW2hLP1IO5I568nfluZbXJKGquHQ7ALbqzvVOSgpYV20XRaR01ytmzBOiRr8QajHVaefDjsysgxAL9prIvYVIys9BOOx9T4hkxEMI5fkrqLMjbFaTiqwL8A8vNppUk4Zcn8OgOXSjnTem/80WQrjgKd0eXSFpSJdfLT+Yz4f/uvihzgPGABrvb54C7rlV+t7L9xTtXrrPYALe2003O0twtKuzDGmXoHEGXAnx+2gwfQHovxg8FZCCJa3HixCww46yNqL6RfKz1NkIvmX7GfFafxe/PdXuFzL2lty9poo2OXcCedjK4h8SkifOXaZhSESGFhoRK/qVqyP7lJi0uKXbKn8cyBoISZBY8DAMp7gUkSo/kafOJiLgpgTHUS0lMn1HAGvRJQ3PjsxqxZXQmPVFinXOBsxFtBfHP+gLziMcuxQ5v3uGvJK4TruIis0joMIC2EK76nEHS8ocI1aktRFXWaX1KO1yz9jEKdEmjQBrNe
 xvBdztLh
 F54nl+6GmhCY1QgikTr7kMsiu0YH/IfDVq06pm43xBKVzEJ6Y+HItN0/9wO4wfoUFvp8nrq+pRyEiS9DFCKJpaS8wZWgH5B4EOhRXtWavB+gpJ4p5YjlRXrZwgnNSvcz/bQI5Kppk7JAs7279UGGt3nkvqShQ+aJc7BWA6YKcPaAlUJY+t6rUkcSQG1Mz6NQEXvbwCvtC2YTrpDXsmigHUmM3DLr1s8WOfeRvoPa9FxD8UBCxvAeyEFkupmBWz/ECmi6xK7In8ckck5RqpuBji09WKFc45AvMHHkFxA3QpdbgC95zpgFFsE4qHLyBvzgUaHDEnt8NzdyUooHJOJTKJfBJBCegp66Zxs8e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the existing test logic to assert that vma_test(), vma_test_any()
and vma_test_any_mask() (implicitly tested via vma_test_any()) are
functioning correctly.

We already have tests for other variants like this, so it's simply a matter
of expanding those tests to also include tests for the VMA-specific
helpers.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 1fae25170ff7..1395d55a1e02 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -183,13 +183,18 @@ static bool test_vma_flags_test(void)
 	struct vm_area_desc desc = {
 		.vma_flags = flags,
 	};
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
 
 #define do_test(_flag)					\
 	ASSERT_TRUE(vma_flags_test(&flags, _flag));	\
+	ASSERT_TRUE(vma_test(&vma, _flag));		\
 	ASSERT_TRUE(vma_desc_test(&desc, _flag))
 
 #define do_test_false(_flag)				\
 	ASSERT_FALSE(vma_flags_test(&flags, _flag));	\
+	ASSERT_FALSE(vma_test(&vma, _flag));		\
 	ASSERT_FALSE(vma_desc_test(&desc, _flag))
 
 	do_test(VMA_READ_BIT);
@@ -219,15 +224,17 @@ static bool test_vma_flags_test_any(void)
 					       , 64, 65
 #endif
 		);
-	struct vm_area_struct vma;
-	struct vm_area_desc desc;
-
-	vma.flags = flags;
-	desc.vma_flags = flags;
+	struct vm_area_struct vma = {
+		.flags = flags,
+	};
+	struct vm_area_desc desc = {
+		.vma_flags = flags,
+	};
 
 #define do_test(...)						\
 	ASSERT_TRUE(vma_flags_test_any(&flags, __VA_ARGS__));	\
-	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__))
+	ASSERT_TRUE(vma_desc_test_any(&desc, __VA_ARGS__));	\
+	ASSERT_TRUE(vma_test_any(&vma, __VA_ARGS__));
 
 #define do_test_all_true(...)					\
 	ASSERT_TRUE(vma_flags_test_all(&flags, __VA_ARGS__));	\
-- 
2.53.0


