Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B70CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 23:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4B26B008A; Mon, 12 Oct 2026 19:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085276B008C; Mon, 12 Oct 2026 19:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A4B6B0092; Mon, 12 Oct 2026 19:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBEBA6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:59:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38A9F140A3A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:30 +0000 (UTC)
X-FDA: 85315643700.23.B371CD6
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf27.hostedemail.com (Postfix) with ESMTP id D491540002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791849568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XpAt/RPvtMw7HMqw4E9cemrbdib39PsgDJsZyN1sftQ=;
	b=yy2ruDJla7sHGddy+6z5CCWjRmuiymxVwMAegI87LLnhmHuot2L2LQsPzk2qnq6TqYw/XB
	dKcknI29B1WXU3GJf8iDLUhMbXr0hdFjWD8jz5ThVxwl6HXdUckllff5B+LuMAN/ERK+Ig
	EsCn+IDx2+JHBnvIEGJ4ZdxT1JLSusg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791849568;
	b=V2+Gt8gjx75MgjcgOo9f86Kr2COdyt9oWc8+GDG0vslMKze3aFlZuDmLlWxxRVaoGCTlNj
	K9H2lugN6m/OkYx2ryOnhjEXXdJlObWjNrBR3GepJg4NoOwG9GlFyGxI9irIG4jofUUUfO
	cAmm489s4OkHbUpmJMVAhKiMaih5xPQ=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGPvK-00GbRU-HA;
	Mon, 12 Oct 2026 19:59:18 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 0/2] maple_tree: fix RCU-mode destroy of trees without MT_FLAGS_ALLOC_RANGE
Date: Mon, 12 Oct 2026 19:59:16 -0400
Message-ID: <20261012235918.773421-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D491540002
X-Rspam-User: 
X-Stat-Signature: 6pcmztdb8ziqswujzzui5ccumkhbi9cj
X-HE-Tag: 1791849568-446478
X-HE-Meta: U2FsdGVkX1/RL9JO+DOQmE7hFKMfTRTTe8kLHyps/oGQhg0fyrvVW/bzN/l4Tbnu/6suWKi3K7d7q2RJ9SQ+1Np6sUvR2NeFWCFxLaJozHkjdVPui+fb6d1/f6Mf1yKaxQXkPr/wamvdyeDdiELmbIBd4BfkVqStBDGrhjT8vP7UqrjDix914Ovm0A77ZifOa5HAiBJZKZC64eHARTM5gKe/mOE+HTZkH38yQt2tmomsqWuWBsH2K4UMunzE6GDRMlpDY9JRWU9iLbqt5F8Ht0eECZUN0bOs4XCyl+m45lv8lMzx4wid9y4H4DbHYRi8Sf5u4wU51dwzuO0XF+InbhOwbgk//yN+mfymOuOBV4Dt1Jw+ksvibw/qUPvRFBF+hkDFhw0jcvLCA2kOzuEeBgW2WoTX8Uy6NSUvgc5X0fyUdq4CrdtpTCUEAIiPTdgneUIcR2rkcbmKnDGVHfTNyST4lwvL9HVg0IwWYDdzbHy8v+/06HJKrkd3IWCnvOXGDvZe/fbe4YupSBv0FREG1KpXytYtgxP0jik7S9LExQrlKbFW8lt6YfnPkKLFBf8tmGdLEChA7c22q5q2nE/dGeUYd0E20KjilwW5U026APay97tWBy365djSDXGdOaT3D78hM5taDcHYZ58J/zGHz1y+reDXA7H7Z2geYuJcHIhOgWUCzS8SaOdeY87pb5aHKjmetN7noTvnkMpYFuucXLF39Sr49LCjOfzIXEqUWaL2/YJq7jGwiCOWJ733slC2YrW75y+4vR8Y3o2edo4VCCwF88RU9pr7R3l9pNypaGLZ6P9ZVh5S30LzwbcjB7UBz1rFd64WApJ7Avw69CtY3ifhhddy3PNJKIFXQtkZTmG6QLXBD8S4K5oMRHV7xeEc+Hftk8+mAZapgW+7xvTuNIKRBFlCh2oA5u72q8f0yGJC5kill43C45gsgTXZ+q7vmtn96rRhA/Km4g+pOs6
 UpeIH+CN
 4fkutjvUxiD2tzzx07a7/7f4WrqeWeG6FJrXRBUGL+SsoZBt3Jkkk6+iE0/8G/xBfjLC6sYIhVI2co8SpetFTSNwCFnEs9f89F3hsm86W/8vsx54xUsyxMDioo3EJ7YhgrpkU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Destroying a maple tree in RCU mode marks its nodes dead and leaves the
freeing to an RCU callback.  In a tree without MT_FLAGS_ALLOC_RANGE the
internal nodes keep their metadata in the last slot when it is unused,
and that path gets the two cases wrong:

1. mt_free_walk() takes the metadata of a 15-child node for a child and
   dereferences address 0x0e + 0x24 from the RCU softirq: oops, panic.
2. mt_destroy_walk() "clears the metadata" of a full start node after
   its slots were rewritten, which corrupts its last child pointer;
   mt_free_walk() then frees the wrong address (double free or freeing
   a live node) and leaks the real child.

Both come from the v6.3-rc6 RCU fixes: 2e5b4921f8ef cleared the metadata
of every node in mte_destroy_descend() and once more at the end of
mt_destroy_walk(); 790e1fa86b34 dropped the per-node call.  Patch 1
restores it; patch 2 removes the late call, which then only does harm.
Patch 2 depends on patch 1.  Both are deterministic, no race needed.

No in-tree user reaches either today: every tree used in RCU mode has
MT_FLAGS_ALLOC_RANGE.  The API allows RCU mode on any tree, though.

Found while formally verifying the maple tree destroy path against the
kernel binary.

Testing: each patch adds a case to lib/test_maple_tree.c that fails
without the fix (userspace suite: SIGSEGV, AddressSanitizer bad free;
kernel: oops at boot, KASAN report) and passes with it.  The userspace
maple suite passes; x86_64 and riscv defconfig builds with LLVM=1 have
no warnings, W=1 and sparse report nothing new for lib/maple_tree.o and
lib/test_maple_tree.o; x86_64 (also with KASAN) and riscv64 QEMU boots
with CONFIG_TEST_MAPLE_TREE=y pass the maple tree tests.

Nickolai Zeldovich (2):
  maple_tree: restore per-node metadata clearing in
    mte_destroy_descend()
  maple_tree: remove the late metadata clearing from mt_destroy_walk()

 lib/maple_tree.c      |  3 +--
 lib/test_maple_tree.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


