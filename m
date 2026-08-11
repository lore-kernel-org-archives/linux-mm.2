Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBD81C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECB6E6B00A5; Tue, 11 Aug 2026 13:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2A16B00A6; Tue, 11 Aug 2026 13:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91D26B00A7; Tue, 11 Aug 2026 13:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF60F6B00A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C1FFA018A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:34 +0000 (UTC)
X-FDA: 85089735948.05.EB938AB
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48D78180006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=ijtaT8kD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="F 7n+tHY";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3ArJhoaqsFvEuZHlfyWAtV6SGaCuVy7Av0qaKtOt1k=;
	b=NReFxx5B96Svu2NCz5V4N830F5LxThaGEweJoDRCO/u9ctpb+1xjuk/Ik8Jn10DJsYln4y
	IPrllOKLyJYLqrN+CRdIfZPGr/d9e6KmtcIX9bCoqkzeAoCiVmJAMBYrBqIUABU6XSd+AN
	dU3kshrzQNsI/3pr3nGbtZpNJf5grFY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=ijtaT8kD;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="F 7n+tHY";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470812;
	b=OgxtpTToU12qaUlSBZTbmfyiBxV04j59JHWxSFqttjkrOM1Qpc02oZ8rWTOI1KWnIfuROC
	2SSNCEmTFeTX4fvKZrjKoKaPsXsS+nRwEuRcJoGdyW54hcWGjcSnu3Af1edUzGkBLunYIc
	qDy+wokfwvZeTLaJzItZ6AR4u05Z8+Y=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 2036D1300386;
	Tue, 11 Aug 2026 13:53:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 11 Aug 2026 13:53:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470809;
	 x=1786478009; bh=b3ArJhoaqsFvEuZHlfyWAtV6SGaCuVy7Av0qaKtOt1k=; b=
	ijtaT8kDvWYfd3yO7OtyiAlRE0ZIplb3TPK1W2M6BA10SuK0UgAtjcGX0oE3nhdJ
	PiZWC22o8wcjvWRNS/zjkaIimr0n9LVRM0tvbIy4UML1hZWjtYDZl+CiJ/g69qP2
	ha+ZWvdrDWeVRbtW49NmTxjxwlmhD+g2G718CyihW1245v+yYuBiLqm81Xi8pn+i
	lDW/+3bli1cJsp4GgqYBlW2dnGvdRyH5uazX0dA0QPmBy4llq+Ru3JmXd4W3Bfs1
	ON6eS3YwR6pclmES5s264NOV2erZgIAUuR+AxbOS0JUZEPv1qD5oKKpQj6wQnekz
	zP7bJ3Ky1wfC9BUlGo7URw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470809; x=
	1786478009; bh=b3ArJhoaqsFvEuZHlfyWAtV6SGaCuVy7Av0qaKtOt1k=; b=F
	7n+tHYSFuWlN4o4SYZgF6PerK9cXZHzNOIbAIrxvG/Jw3R42BCKEUWgzv74DtCyw
	rUcgXzQbXuFLrIutTWJ1kejWT9+CRwoJUT9aiVCyOBR/uPiZRKpdwLiSB7PM5+/H
	BfnYe93/namBn1D+o63fBYUwZC/UaAvT2VSMRQLwopNnnawgjZ0iSlRNOa8tZqwO
	RR2uHPELbcTiJi77bnhtXa5CfyUJ8inB8K20y/BcPQe9YbbLeDiFu9vS1GRwTVts
	krh7NortTp/iCcQXgux/TCCZV620afOa+8s30z4mKCT0g8nwlQGQln4AY19Q6hjs
	GQdHtxAcicxAkr+1jlmwQ==
X-ME-Sender: <xms:mWF7ahBvdgF8epZoerAsdMmQKRY9NCiHXLY-iobD4PC7qsqhsgN0sA>
    <xme:mWF7amGXHNobEqvw6CXL66lse6ZIj-mUZTYnUwZsc4tt2a8LmkkPi0ScpExFULbgl
    Wf4JNbHgYmNYFzV7AmvfZn_wASXB3tZ8wNe-Zs5Yi0b-2rD7t2r>
X-ME-Received: <xmr:mWF7apUvnSnecSShUC5ABb58WPvKqOgvN6WDuAu48TYhsYwpXuTFlyHSdxt0uIjyD3MLG5iU0GKAHEjItUvhCCw>
X-ME-Proxy-Cause: dmFkZTFP5tmiXRyqpvhao8uWnDWsuVG58E3QcpY8nNF+TN3d4+2z3XaWQJ1+2uEKcUq9Jg
    +xH/KDfBOi31TfxVE5vy2aZ5W5Eono+bvv7mBiiNvVW/C9tjIvrxCLzv7Tz6GJOSvAG1cd
    t11+FzpQNbill+yp1ZC7JKPVzEaxQ4CH2HewKTU1gYEn0mNFldMXWgoBvZ/c5OhwLZogLW
    sZeOMCUfQY9vOvCjGHA0ivpYn+5HBy3sK6RswFREIaUm9jlhbU7pV5ZXGDLpJAMlUAJ/Lo
    y1vjaaTNNEiBF07QqH8YbZg0fsVTsE2lSAku2XiqZRlB3GAWdGnDFC/NxQNHJZjZwh0bAL
    NFU+sk1NjKbEiriHkWskXNqpRyiqngUiDobuBKM0QHx4IectPTiNVC0LAnkIil116cieth
    zlAJFqSExn0DMecmyqjTsWkD2ngU3mch+rJhp5ghpPvHYcUsU6CHEmiNL5gcm7pKojpoO8
    fUnDVi8q2D+tB3RNg8+bAG4knndc4v8UKvQON5b1dgXr5OKaBku6F7yXG1GPPJwkfrL7jQ
    EGcTagLVCnPlAjtfXZXy0P8J7sS0XyACESJHYYDdJ2OUni4Z+skjWf20Xpwr+zWL1ubmDC
    Ll6gwazrEjfo6CiwO2x+aWpiJNWOBFsNaCTo8jTyf1t3R3yZMgHWANJia/Qw
X-ME-Proxy: <xmx:mWF7akYLbKa4Ldqion9AVypKRG2td0FOiQT0IMdx4BEp4s2wNEAIiQ>
    <xmx:mWF7arB2K5jQ7vH9tLL3KCSU8nMwn0AZVF2DZWl1CPCuZItwReOsKA>
    <xmx:mWF7ahFAC4F5KSyCw9RpCBXNmmg4CQcvBQvPsk2Ct6QZdcB42lOoFw>
    <xmx:mWF7atDdhYqdhtincgzKdDhXKGMZ16JSVedWEWvxbhg-Z7VjwfQr3g>
    <xmx:mWF7arIkBDKrbmh1nTENBMBX06Dyq0TxrsND73UjyTyhqXlTGHTyLPQL>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:23 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:52 +0200
Subject: [PATCH v2 03/13] arm64/mm: add set_direct_map_default_nosplit()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-3-9561d13c2340@jaseg.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Stat-Signature: ogzsee9c7eoacqsx5sz4zehxdk6c6x5c
X-Rspamd-Queue-Id: 48D78180006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786470812-170868
X-HE-Meta: U2FsdGVkX1/2aCBmv3lAnNHGkyGHK6apIwFoGjK5uztB59dSEeUhVzSpma/mjrQ4M/PWoKzR9aurrqynYCgumTzMZQI3IWBhwMuC01ujz8i0TqWarBvpJKtksLNnMogISvmYtMfPfaxjYhCja+0doOZ1/jeDou5v2JlFxH2IFADTar0DyHjGNkBz/7zjYJibcwy/9TTZiN+E1ZMdR2b+AE1tBVwMbl6BuYhP2rVR7ohUnK6vRWD/eWkQj5Z8cXYUL1tthrvVQ4kCRt4J5D5MbPKBQ5K4wWAxMcvWG4LdWVBRJtlbbN2ryWmzJiuVEb5lzZVQYPYSzzN1dtlDL+KZobpLQCKt1EQ9Mvbj3IppzOl6MIXOKjTBLkvkovnCVe2IvB6OUDaUFFih2M4KE/TeVj8gkzdcn/aEa9nwl26wYlrHQrqqo6nuwzHochYEQgozh5P/YOO9ig2B4twz1T2OzElkBTuhMicDie8i9cO2iI/Is/ZqMaClaruHi+CcVm3CPg7+nHTJJ6Chy4VUrF3XRHbqYYq9gnrNyxjWN2LOnn2NMGU+/dMtcCEAXtTAot35ofcRCLIP5P62lKhaG3I65iZUOlqQGeHBDwJLhw4S5WlOY2gkOqjBuqsKqf7K2zXu/egLTVi6l4A4RPigc9TE5dTVCI7tKrsFtsIjLgs++OgTpH9uIKmsE/oMLuwpEHPFK0S9xQiwVqxZqoeAxDUNpiK2O7J0OQBvcM7YaiQXI3eY1oSjVPEvVZ1MlaKPKY0M6zTSjS6tMpSJmCHaWI7xfqsnQr4IuFeJfu4Jy7htxVZ6jW9gh0NYncI0zQ2KxEFGnx3tVQoDemwzHQXAJJYe7EmuTtQr2mH0GxucQqR1pF6twcbDznzxWynPHzkOKcy/qPIqWHTCZh1dr1bexS9lpROnJJjkYhYOCv+KeQVFQ6KaBQc6o+/Ut2Z+hiBF7JjWbC12/tbuWTfzcGR9HXc
 aTKuMovV
 ZU/oVmxgzVHYfZc2cUAoL8FUDKTq7B6ROrGs5eZemH4Vha656KhfEWNEZFyVqIJpqO0TOTOpjee3GgV4aD7xkX7qgPgYkUo6RBc1urfrWiWTC5r8zs32DKJgFTACiAgNKZpzshWu6vEA85gFjZkNTty9KCs6Bui1FTNILzRdxeWIbuLoG0Sk1EABN5UjdMZ5PHvSzS7+fOuS8SgNT7Kv5yckThVYf814gseoi2G1BslHWbPhd+TqRVFa3BHcmPiJw5bjRtrbwNgmmxHeJvt9cQu3bXvm/p41LEGBB0qEcvvk32nU8fHgldWlBMycIJS8d937ygig2e3Nf5htKBP/2OTVV5FJ4Fq+enWrU+1XoUIta2WNLYdT+IGhb2prb4u7+TgjxoHq1MIzGgao96cNu7/prcB0eAxjOLVcQYZOuSzxe15SDTghtyVPYNusbZEdu4jIu2fQCXdPz+k0X1p80B2XxHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

set_direct_map_default_noflush() goes through split_kernel_leaf_mapping(),
which takes pgtable_split_lock and may sleep. That makes it unusable from
atomic contexts such as the panic path.

Add set_direct_map_default_nosplit(), which skips the split and only walks
the page tables to apply the permission change. Callers must guarantee the
page is already mapped at page granularity. This holds for any page that
had set_direct_map_invalid_noflush() applied to it, as that call performed
the split.

Architectures that do not need to split the linear map get a generic
fallback to set_direct_map_default_noflush().

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 arch/arm64/include/asm/set_memory.h |  2 ++
 arch/arm64/mm/pageattr.c            | 21 +++++++++++++++++++++
 include/linux/set_memory.h          | 17 ++++++++++++++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..cb5f44bb5a94 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -13,6 +13,8 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_default_nosplit(struct page *page);
+#define set_direct_map_default_nosplit set_direct_map_default_nosplit
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..a7bb6bfa12ed 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -275,6 +275,27 @@ int set_direct_map_default_noflush(struct page *page)
 				 PAGE_SIZE, set_mask, clear_mask);
 }
 
+/* Caller must guarantee @page is already mapped at page granularity. */
+int set_direct_map_default_nosplit(struct page *page)
+{
+	struct page_change_data data = {
+		.set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE),
+		.clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY),
+	};
+	unsigned long addr = (unsigned long)page_address(page);
+	int ret;
+
+	if (!can_set_direct_map())
+		return 0;
+
+	lazy_mmu_mode_enable();
+	ret = walk_kernel_page_table_range_lockless(addr, addr + PAGE_SIZE,
+						    &pageattr_ops, NULL, &data);
+	lazy_mmu_mode_disable();
+
+	return ret;
+}
+
 static int __set_memory_enc_dec(unsigned long addr,
 				int numpages,
 				bool encrypt)
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..65d0fa010368 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -44,7 +44,22 @@ static inline bool kernel_page_present(struct page *page)
 {
 	return true;
 }
-#else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
+#endif /* !CONFIG_ARCH_HAS_SET_DIRECT_MAP */
+
+/*
+ * Variant of set_direct_map_default_noflush() that is safe to call from atomic
+ * context, for pages the caller knows are already mapped at page granularity.
+ * Architectures that need to split the linear map, and can therefore sleep,
+ * override this.
+ */
+#ifndef set_direct_map_default_nosplit
+static inline int set_direct_map_default_nosplit(struct page *page)
+{
+	return set_direct_map_default_noflush(page);
+}
+#endif
+
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
 /*
  * Some architectures, e.g. ARM64 can disable direct map modifications at
  * boot time. Let them overrive this query.

-- 
2.53.0


