Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26EBFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865F16B0092; Thu,  9 Jul 2026 13:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CD26B0095; Thu,  9 Jul 2026 13:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752E06B0096; Thu,  9 Jul 2026 13:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D28206B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B02211A0257
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:42 +0000 (UTC)
X-FDA: 84969948084.08.EDF8971
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5F591C0011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VM411R6N;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8rhN8Ms1XeLpjAPQvoH3qTAPCovc8Zjh9DU+rsKIjo=;
	b=djNfNv/IEe9P5uPqM20SxoStjuQYDQkxiaokwlCVPq+B2YCHw+ursG/geCD30WgFuebOlM
	NsFVckQ/H3eaXcVkwZpkGJ7UeSxDKrB+fpStQqVaEolytkG7p2HBs12QMXEUJ0vSRWyrWp
	OYteGf1IeSaS/nSdh3i76q6SJK908f4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VM411R6N;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618721;
	b=KGswONhUpVH/m9V6RShLLSTPTZGTosGsMHSjpQ3NJpUXS8NEeyROafvQv2wE8r0N6SsWke
	sBJaow5STbRD3d4Pv5LUCtImdVKABuKO6R+A8nfl7zkGlTvi42bTpkSZoSwtGqAdpFlIsU
	FBLUFLjitZbQE/IUPMyLHTB/vd6OSzs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D8D242B6E;
	Thu,  9 Jul 2026 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF611F00A3D;
	Thu,  9 Jul 2026 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618720;
	bh=s8rhN8Ms1XeLpjAPQvoH3qTAPCovc8Zjh9DU+rsKIjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VM411R6NNGWqRKQ924XabZNdvhSd0XEacZDp7SuXrbTuQCp3xqeKcPaK8g+sQv41y
	 2ay5kW6bqgErIuCKzUr7+krx9dlWwPd+Z0GMhqwVKh5CC4u8A0A7kTfwjdSAG1Tni8
	 Im+e/zfCSOwDK6zIvUNc8SJQJW/CFkcKmK27t+oARDKsX5GO6tVKfS2V2Ar0lGtkcL
	 lL2RmJ0uAc6NFOzoJafHM77HVZ2YW0dfGDIoV7W50jpDRN0oCw0a0jTGR16V2T2l/I
	 +I0/14rBSt+clzDG35ZUVE3hXxpVyx0tj8+63qKVTZOWLNRNnCL0yifhrPY/hcI9W1
	 E+UybyB5AD+Xg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/21] kho: disallow wide keys in radix tree
Date: Thu,  9 Jul 2026 19:37:52 +0200
Message-ID: <20260709173821.429921-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5F591C0011
X-Stat-Signature: n7464zgeaiufsff93xh1hx41ua8idwwi
X-HE-Tag: 1783618720-277957
X-HE-Meta: U2FsdGVkX18Ridmd+68AiZof9jalUdIzFpI2GeZoSMy/3kNWlxfmoPcbz2IOpRwe+40yTJnTI7OJH3wrMub2g5aVcZ9Z9pipvfW8SQDX+Zh/gNEbIl6eHm2MIyA2WcQZyHUCEdRY+0GgHFwNuxJsj8ZDxmVEJBqMaDz7jlgZ38CZNeaZrLuwkwFOdX5u79lO7KrTfXg7q/l1/6JDoGb9ax3OzVPO/Y0ppIP9pxufgXB8HgIpUEdmLUlNsF+HnDw2l3DQ8MN371jjocOynG8Tc4zzpj/HRuSMa+yiDBTb3hdy4Lh1wNtHx11JvS/t+XHJjWUqjY7hJIkl2t4ykbd4Cevg1PyZ+xC5Z2ZfTqQ4Lp2Lsqmk0zSQ3beomPvZiXvKQmWrzE4WYsnIfYzqIX/O2eSBV2hN7WjRBvivG2avNC6tJKiGji37scVnjx32DnD9bV918q9IIkqkEOglS/xHhm35RZI/Az3jyaPF+iT5dz5cFipZZ6lGWAL4oBqozZ/JKdwtkKgMs3zHLjFEhU5LBxDNBEGw/NXVgDKFFDiZoANcEw0FmH9oHdx4GUgQ4XHMC//qG3fERFgvbzCsrsNOPHaNFs1Kj7LYiP00Qeqh3AHZY9hD+KnUEDEQq4ElOX4tkoPwyQrdnYSIt+pSZ2Y+NMRAXdIgefqNE9f2yOogGv0FVmnME2GBmS3gol1xp+CbKqUW/1asg5P2M+eTK15u7Jz5TKlzVgSxZN2jIOwm1TrkmQxcI5iqCPxTTBMJgXcuMj+QNt7I5sJVoURdTHqm1axpRJc6wXchHfJj6H7tqW1qSFNBw/DYND8/WYPpiNcMknnKhBii0SOX380dqDy/x4gQBwN2SZRCza29ZhCkqKYF0lw9lWFwo9M60qRgHnduLbvZfOBEeb/o+kpw2qalVl9QznrvcN196F62mwCUSil9Kz6PxAdPNlcFCOEb3uZZNE80REzNCveM2jrxpTC
 kQ59Cirt
 RBCwzoaWLNn7Ed9WAiNNm1uWgxIoEZ4YyCfmbfLxyYCQ2o3iMJDxQ0xf8oSUpqdMyM4Ksfj3MzOnoRi6FZC09oS6AF6q6wBkyfgcV+j532SLTru4bHvE9A645wqh65DvQAmCIGvGjidikBZSO4bQR3pt8gwVARHDD1ARCLuGpavnREj9Gq02/dooDQlw/JAVOMbJNoUcFFczJrGtjfHID7pSyNqcGnvX/emfHURy6wIPsyxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The KHO radix tree was designed to track preserved pages. So it does not
provide the capability to track any 64-bit key. Instead, it limits the
key width to how much it needs for tracking PFNs and their orders.
Limiting the width reduces the number of levels in the tree.

KHO is not expected to be the only user of the radix tree. With the API
generalized to allow other users, now it is possible to add any key to
the tree.

Check the key width at kho_radix_add_key(), and error out if it exceeds
what the tree can handle. Do this instead of increasing the tree depth
since right now there are no users that need to use wider keys, so this
avoids memory overhead and ABI breakage.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ea24f23ce292..e7451743b87e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -156,6 +156,11 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
  * intermediate nodes do not exist along the path, they are allocated and added
  * to the tree.
  *
+ * NOTE: Currently only keys of width up to %KHO_RADIX_KEY_WIDTH are supported.
+ * This limit only exists because current users of the radix tree don't use more
+ * than that. Changing the maximum width requires changing the tree depth, which
+ * needs bumping the ABI version.
+ *
  * Return: 0 on success, or a negative error code on failure.
  */
 int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
@@ -172,6 +177,9 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return -EINVAL;
 
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return -ERANGE;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
@@ -244,6 +252,10 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
 	if (WARN_ON_ONCE(!tree->root))
 		return;
 
+	/* Keys wider than KHO_RADIX_KEY_WIDTH are not allowed to be added. */
+	if (unlikely(fls64(key) > KHO_RADIX_KEY_WIDTH))
+		return;
+
 	might_sleep();
 
 	guard(mutex)(&tree->lock);
-- 
2.55.0.141.g00534a21ce-goog


