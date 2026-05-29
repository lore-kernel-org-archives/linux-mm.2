Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36ECACD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6656B00CD; Fri, 29 May 2026 13:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967226B00D0; Fri, 29 May 2026 13:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882566B00CD; Fri, 29 May 2026 13:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771316B00CD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 393228C8A1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:21 +0000 (UTC)
X-FDA: 84821131122.11.5CA7773
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C8B020002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+LQqFiO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075459; a=rsa-sha256;
	cv=none;
	b=Cn8PaGVdaUY31xPxgYXIp8GVUCr+KWBQAir6AS63H4hROyWUN9trnUmNax4Gwt+yN6O+gz
	2z53fn1tZ4QsQLiIZYDEviMX5FcBR0zVEUozDdZ9AdiyQylwmlFKjJe4o+t/AKVf3EhPX1
	yNxu6bqaWR+HsvDe5mbSSLlzTPZBYxQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+LQqFiO;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XeG9LCEJFa4u0fWY5Mnfc8ZMY6z2gJj23YToDXVIM3Y=;
	b=hwMMXLxwiBf+YylHKh0OIS+hXHWHEjZYK01lAf2T/jEPo9W9g7UERhMKkIya2cZhqq/5KO
	bCYLKuMYQfotsUwd9OSnof20JkuiM/fEwOPcJYLL/PMimN38k4le2VICdsQDQBY4iJk1Ar
	FuD1Xz4buQmC8wrlK50LmEdZhOeDgDU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CFE943EEA;
	Fri, 29 May 2026 17:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37341F00898;
	Fri, 29 May 2026 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075458;
	bh=XeG9LCEJFa4u0fWY5Mnfc8ZMY6z2gJj23YToDXVIM3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+LQqFiOrrE+y48YJVShBHh09EBlf/KfbOr/+DglsfsudubBwGEcOuV/86RGkBrEW
	 PO6UUw2W6zT0zBEnQSu0Mn+8+UaYRFX9sMEaz6cdgqlrFuFBPk344udWQUkT8rSii9
	 jiF1+OfFFcXmtEWu15POIX+CzsIUL3BrmUf2+ifllCG3sRQ2EMMxeMU1mSwKK3SDug
	 ueU37TNVC07ovUNAdqN5P5gGDp4EjChGLK8e4Fpm6Bdg6Z604AdB4N0sLMtSgJyyU5
	 yaDLEeYqkHRjH1BVc062zkNLzMQsUzzvh+rm8R/VQ/vbVLf0GQ4k+bEEtAA0t/q7+i
	 95rhGgBX6x0wg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0EDD9F4006D;
	Fri, 29 May 2026 13:24:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 13:24:17 -0400
X-ME-Sender: <xms:wcsZak-NgfpOzhZZuL_DUVc6QSlV7NKTafXAW12NDzu5Yi__Z2OXog>
    <xme:wcsZajPEXzq_kv1SnUAjaG7zgbEV3QwhcNZFhX6PqT8mXSjKXzjWRIl0gKg8iGpY7
    Jy_0eQBHzKapQgv-ZMZwhAAd7wfLo8rMHRKDiK_FjbJiQeWAI3oVnBk>
X-ME-Received: <xmr:wcsZaoBm-pZZfQj0I4SXoa4BGVXUD_UVUbb6cwmVde0u3BhL8z2ZyuL9jaGtaQ>
X-ME-Proxy-Cause: dmFkZTFrgX5MM3DUSJ7xzqsXiT9K7Mp6hFpPFfxmC0MA+iN7AjFohwvWx7oxJHZ+5oTsa/
    eNprXeJ/674yJe1dHbWF7GZb1XnToVb0R4autdIDJiozLrBStYEb9fpXa/2JrApUqbrre1
    LdBuyJn9i8qKcJffyvK1YIhy0raIMBiWiOnHjwA5r86k+Zhi6bSohRFuPzPhOdP14jnWJI
    /xiWZuCo09JkwaiWtT4Gp2J4EUMHafSQnln9uaxNuylCfDh3CVEdSw0SaHR74GjGjlbPAf
    5lIf5oHRJw+wgkoNP7G5YvX9mPChAnbwGYXnMrRN1deEijcEXsq+k9G0Lzj5Q5OMaNJVHB
    4OOwyJkq6mBqr043+j7zRMjiXH5kV6zXX7/bgSmKaz/4+CS2nFJJ/vmFn/GaYqZ+ipcj+9
    zaCSc4zsH8zhnIMSsXMMe8+k11/OpeFmN4szkrGrgFc21nOEwGIKONCBFrCimY714mJP5y
    eKIrJe8HvjiBOndrTcALefXl4v4JeJuPsrnHxXfOBEoBkarzNgrbvXTpxFmHceYD/BAmlo
    sLsztvo3cGZYIOqO78ihV6vneu2kX8mZI5NKqYckQd3GswUUBMSNKmUqO3ygONGUdHdS59
    BfN7xsE7X4zcmiX30qSzkdNfO6eHulZVz1QW+CycnZ7Z16VTgUR+37tDLTVg
X-ME-Proxy: <xmx:wcsZanPwXsySgx8tIW5IH8ELE20ra9TtJi9lyZEs5dOgdbS_BIG1jw>
    <xmx:wcsZaveVZS4i744WZ1v7MJzcReHKQY9oYsVHlt5-hQ_G-6AltmbUXQ>
    <xmx:wcsZao63dhUGYiSYrJ_Dx7kTJsIx2ukNhbQ9vwY-BjKlpnzp9f0Bbg>
    <xmx:wcsZahIJ1e721__wC-Z9iskTxDan-x0gIATk8VBCChuhleyP980ptA>
    <xmx:wcsZaiVQ8z8F4yAQbed8dFKYJ4N-Qxkj-lmKCWttfOwkJqFTMyze0OY4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:24:16 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 5/6] userfaultfd: gate must_wait writability check on pte_present()
Date: Fri, 29 May 2026 18:23:29 +0100
Message-ID: <20260529172331.356655-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C8B020002
X-Stat-Signature: gaq59mwb114dqx3xc9chw6e6ie5onbe3
X-HE-Tag: 1780075459-757151
X-HE-Meta: U2FsdGVkX19r0OKQw+MhME+sv6BRggZMQuTZoFlLMzT6ucc/WdiCiSU52gN131xfuWC3rK8o0lYSY33JBn0tX2bA/hQMqdu6xU6YkahmwkmItheejlv9IBO+pC1AeSC1y7jqYQWJKA0PPNQvdGwwPQ0g0bz8Qgo3DUarvjfQ6s3xAS+3BNP/SvuDe99EjB6vdR/xhxTDrICKhiRUkxld5CFqEKSR5cIcPBSxuukDNH6D4oHVQ3S3rDqP1qusxS0W2XYY6zYrbhBTZurEfmDvXmSPYe3iIfdbwKwmk9R3ZEoaq7whM2qKuZoHyIlVgQF396J1uhI1AG4pvtARhQPgG0PSuXr5/8AUEwD1AWMkDXcJYXFN2aGnARXezGSenw4FWzDGgl1m6+LUk18rgsCvJKWcNPEaj/86ykIhybTjrtmsaA2IdOIy981Fz14D4vKiWhqtMruFTiOhp80EcAZ4CzVcJMVOK0M2Mpf+A3uV9YgCLUbXDG7bESBKEJPttL8qY9SQqrL2MfLSVyug6vlMyVj0kJ154vfJRpxx6jCulFkBlFNkfSXqAsPvaiq89ehbtcnSSfYVrF3MDVWjHJLHrd0iEOEIGABXP5xMrLw4qB9gRDfZoirENNGSuNpVQz3X5kDfCArj1D1mVxNC4BxLNgE0l23Nk/pgMoSWrxv7Z2eTqYpkipC15Y4oTvkJdMJyXeMO019qpnbThd+3jpgl1LsPRwbFU8W8RGlHw0nu9x2TdkwGSGJzQ7dXB3Rih4X+tnir1gfLOYGZYYWFLzKZc3xjXZu3jVWFKEc+4/Tfs9oH9cdI6qL+CrgB0fle1sTgFFw44bAltM002fnDQO9pka+9DbfyXJzvercYeLnhcHf3EaCZtvBsu6fLYe7ZxUGbbeRkkPy4PNRJYC5Jr6tXvTg7lNy3VG0Su6NfORPbjFMTCpvDFJq2lIGKb5YSrAk4pQWLF4LuGqJNWIc7lpK
 jFXrtJSk
 ENn6toMYF57mwBt655/IUJQshNuNNFTF1tWC6qLI0dpsYY+vLVcKyiwVM9nRLNykaYM0/KBbbYY8p/o2FeVQJq6SACiZ8DOQdM8Dn0lnMTldylVMnqaqeh8yHfnz8/v4SIkdPjjDYNcslIoki4N7h9ZnrePqF2LrcHF5vwI2T1uqthH58yRKFyyKcanisG4Z1jVbMEizIOxSDPhcO8NCTzBfpM9DFZQRYHPXatZar25dfQEdhCFAlaPYjM08vHRXnZH8Iowi6hQ6jVNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

userfaultfd_must_wait() and userfaultfd_huge_must_wait() read the PTE
without taking the page table lock and then apply pte_write() /
huge_pte_write() to it. Those accessors decode bits from the present
encoding only; on a swap or migration entry they read the offset bits
that happen to share the same position and return an undefined result.

The intent of the check is "is this fault still WP-blocked?". A
non-marker swap entry means the page is in transit -- the userfault
context the original fault delivered against is no longer the same,
and the swap-in or migration completion path will re-deliver a fresh
fault if userspace still needs to handle it. Worst case under the
current code the garbage write bit says "wait", and the thread stays
asleep until a UFFDIO_WAKE that may never arrive.

Gate the writability check on pte_present() so the lockless re-check
only inspects present-PTE bits when the entry is actually present.
The non-present, non-marker case returns "don't wait" and lets the
fault path retry.

Fixes: 369cd2121be4 ("userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges")
Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/userfaultfd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 35b206cc9aa6..f6d2a1c67019 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2535,6 +2535,15 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	/* UFFD PTE markers require userspace to resolve the fault. */
 	if (pte_is_uffd_marker(pte))
 		return true;
+	/*
+	 * Concurrent migration may have replaced the present PTE with a
+	 * non-marker swap entry between fault delivery and this lockless
+	 * re-check. huge_pte_write() on a swap entry decodes random offset
+	 * bits, so gate it on pte_present(). The migration completion path
+	 * will re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(pte))
+		return false;
 	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
@@ -2621,6 +2630,17 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	/* UFFD PTE markers require userspace to resolve the fault. */
 	if (pte_is_uffd_marker(ptent))
 		goto out;
+	/*
+	 * Concurrent swap-out / migration may have replaced the present PTE
+	 * with a non-marker swap entry between fault delivery and this
+	 * lockless re-check. pte_write() on a swap entry decodes random
+	 * offset bits, so gate it on pte_present(). The page-in path will
+	 * re-deliver the fault if it still needs userspace.
+	 */
+	if (!pte_present(ptent)) {
+		ret = false;
+		goto out;
+	}
 	/*
 	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
 	 * resolve the fault.
-- 
2.54.0


