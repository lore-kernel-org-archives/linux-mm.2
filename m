Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F011CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797E56B0092; Fri,  5 Jun 2026 12:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7483C6B0093; Fri,  5 Jun 2026 12:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E466B0095; Fri,  5 Jun 2026 12:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5741C6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:06:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 205CE1C0A57
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:06:59 +0000 (UTC)
X-FDA: 84846337758.28.30E1FC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 95EA640014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:06:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kz9mMRVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780675617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a3fjsrZVTPw1aYZ68MOZRhjvWhbqU4WKMYbQM6/kGaw=;
	b=0JHAT4L8BTzSt+gICb8OgQ1ddq9lMVpO3C+Hl6lASJayjIy52FxQyxLUx5ToVdvbF2t3Sf
	mryKJI7SndP3cYhpz80lgF7hxSxPBolMnFMnuEnA6YOcV8fNLEQ6NXs4/ei2IwZvNY572f
	Z4QRzkKz0u6z2NrCXVE8ahDS6AcdP1Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kz9mMRVc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780675617;
	b=40WpmeYp8blfjoYSP3josq4FbRlqT62SPJ0hnfe4qyE/Tfn1gKDSuhLWQzb7klz+HbaeOj
	f7nTReTZ17HNM46NgwXyeXPqNdCmYToPlCRINNBFVVfnCn6FzGNB17E9VsgQa4B1vL9LHW
	d4G0/I26UQF+0M6Ybc40gK45gl+8Ze0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99F2243E84;
	Fri,  5 Jun 2026 16:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFAE1F00899;
	Fri,  5 Jun 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780675616;
	bh=a3fjsrZVTPw1aYZ68MOZRhjvWhbqU4WKMYbQM6/kGaw=;
	h=From:To:Cc:Subject:Date;
	b=Kz9mMRVcZz92zZUMcK6kxzN4odPq1f1//hDJhb0psL2PVfB4ZrTpTN7o/h7/cXxb6
	 zIJos6d9BiwKXpgnTCycLVfFfmxmTTlCA0TX3xy10eYh4+RXZRgTw044U4kOORp2P3
	 sc0zQftcqpo2y7nOMN2wudqSXN4gUgM5AB9CxVZay6/f7NM+fnxDOwKeF0K2XCx6T3
	 8E235iZ7PyFotYwS/OJkPYCJAmlFXXTIPl4IMPC8vL0wB1SGd6JbzeABJV7Zf4l1yZ
	 NpbFRDV9mq4cvDDKe5MVd02GjQ9yrYP42VYq4rChYdgmoVpBGnnK8kfYMcowlkctHJ
	 oOjbrhEDcD6YA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] docs: memfd_preservation: fix rendering of ABI documentation
Date: Fri,  5 Jun 2026 18:06:44 +0200
Message-ID: <20260605160645.3650271-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95EA640014
X-Rspam-User: 
X-Stat-Signature: 4nbkwf6fcy4ji3ydhbfndsa8d6yp3hs6
X-Rspamd-Server: rspam09
X-HE-Tag: 1780675617-828459
X-HE-Meta: U2FsdGVkX1/gCbKmhIQE5As9CYUAHzFCOJg1ROBJHqLQ4VzP6izr0PpOGVzkhxn5NBsfy/egolFLz8WrG3CAG3kKC4k7eRRR546WpzUtrHRbg7vM6PbwKNOIn0tOm2NRsno/3n6vOgnnbe7tP6+vZCQm1/TL9eyMmkE28wgfTq3uznKQBPYKiZ+M8pk6Xx5AQ+VBodViyiZdfmIRIs+2KEZCx+G1XunL9ttPlGtzXYZEbXmdZaMxeuygk94lvQcuKt2JW2i+QaM2ACGJytHMNSekeKUHtTHINiwJACNmdPqEGK6c4hGffq/U5W7aGyjXg661VvgUZFIuRf6G4GLBMqvB/yfa9G4DJp9fw3WGjLZ8mXcKfdSaq+BL1v1RZCfIJ0HhPgc4200afofjlJmtvtgcsdGwcc1fwDpA9l8gA0X3fwU+8nxX3U2ANgrOt3rip1tF7C3uiCEbBGEBC24o9mTkKfSUhCIf3iiCuyi+jjeht1rZzp6PyU9TLu/tX+3wZvJNXm0/oRB3RmgnQ7kgIiAhAdqyfc2gkR8igCSjV1jrDBiP+RZQTU2XEvAhC6IlSrPsN6FMch7wT/EReQZvUR6D1fl43xT4+No6I+bVh9OOYSjqfWMOgV27RGfzVI0A6dA/ZPY3WLXpihIf+wrs2nEudUGBw04Fc9ePcAKT9u3QLZzK4sXx1/gjzMCtzulq0XQc/4HkORgQP4MO3WzeqFiS6g4M0kjmANTwAAVj59MHtxj7hrQ3OKoJgR1F+eWhgS7aa1LadH9S2eFqcTDEhYcK/vxqoTbe7dvkSiD2kdsIWjepYVq+eaUhTb5nyWubxYo53Key5xvMtWwtEXlkFyE9b5jvfOJ256H2gEe4vZiB2F7Z37/vF08SJnHxTEnvTzFxHwRqYnciOVi6aGMTTKoAfu8hOfddM5WOkAvcMP/1vRATGb8XkH+iORUF782VJGqsyArcdn6XlcQ0VOP
 hzpJLipn
 /fTosqPTkbDnHe+RfhkE2ScQEMxTknmYrNPZALxnTf3XssIM5CK4e4TiAQ9x6NSs3NEFOG24jONjyxtASHmFZbWWMqY5ECvG+HUS3ZJis9WgABp0HGSEAV5cGND/3SgDXNs5STX8UtQwlA5bVSxi01T64V8k4eETkYr+JqeNs8rhH1u5YRlXRuUkx8TYXV3M/ApbPKqKFJbgwr/LB5LsY7vyEkiZipHlp9/jM7tUZX38PMHT11k0XT0ATDv7Qx+jqS+LXyN7T7yynRf/VZF6QM9yN3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The "memfd Live Update ABI" section in include/linux/kho/abi/memfd.h
currently does not render in the exported documentation. This is because
it should not include the "DOC:" in its reference. Drop it to ensure
correct rendering. Tested by running make htmldocs.

Fixes: 15fc11bb2cb6 ("docs: add documentation for memfd preservation via LUO")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    Mike/Pasha, I reckon this can still go in liveupdate/next. But if you
    think it is too late, we can probably take it via -rc1 fixes as well.

 Documentation/mm/memfd_preservation.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
index a8a5b476afd3..c908a12dffa7 100644
--- a/Documentation/mm/memfd_preservation.rst
+++ b/Documentation/mm/memfd_preservation.rst
@@ -11,7 +11,7 @@ Memfd Preservation ABI
 ======================
 
 .. kernel-doc:: include/linux/kho/abi/memfd.h
-   :doc: DOC: memfd Live Update ABI
+   :doc: memfd Live Update ABI
 
 .. kernel-doc:: include/linux/kho/abi/memfd.h
    :internal:

base-commit: 2935777b418d2bfcbfe96705bb2c0fa6c0d94e18
-- 
2.54.0.1032.g2f8565e1d1-goog


