Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AE9CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 07:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEF26B0108; Sun, 31 May 2026 03:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3D46B010A; Sun, 31 May 2026 03:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BF46B010B; Sun, 31 May 2026 03:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5DD6B0108
	for <linux-mm@kvack.org>; Sun, 31 May 2026 03:03:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1B5BA0394
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:03:04 +0000 (UTC)
X-FDA: 84826823088.19.9C27383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 544F18000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 07:03:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EQ1d/NT0";
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780210983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZgXT2ovXS3IZ2JxTPqBmcz8kuu7e/GyHmKzI+j+wn8=;
	b=ISj5eOjQnr/tNJ/h5z91NGwquuIfjyrFO5MTiwMWUQAQRp+7XJa2CRNcBNVr+QK1UF7lyy
	Z9HfEwrNTDLthHj0vwDk0+MS3otoUTW9NScnBiuoi+DiYVtrceiJok23cNlCDjgs5dNYku
	Hi/VKL7/9ItwmwCLcrSV5T+qxqs/8Jk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EQ1d/NT0";
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780210983; a=rsa-sha256;
	cv=none;
	b=HyOW36Ov0zl0F0WVYY9UlBrv6Az3mZzQ0yL40FFYBNdVu7Fv5a6qNCHT2tH1POXqqEeGN/
	AZ63/ogbN46EmzankM7vl7vTGMFbOy9awz21cUdFvyZHTfVXt3DssE5t23mUMcVyMBeUPp
	o5R4NU6v70utXHGu4m9DundpDcQfqFc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FBCE43CFE;
	Sun, 31 May 2026 07:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47961F00893;
	Sun, 31 May 2026 07:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780210982;
	bh=aZgXT2ovXS3IZ2JxTPqBmcz8kuu7e/GyHmKzI+j+wn8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EQ1d/NT0ktwMqaIaxkjQ3YMSMwQ8G1/81ix0mzlqQKvoKr2wM21vdAXDQCSv9xYT5
	 YTgDSzC8vXNypKaBKCRHnofmeHsKAEygjKrnsoV7SS11gw6GL4i6Anp53r+H4gz/Wh
	 ovxIg3AwVoGB/RjMcqZeEDJgg+cFKvgxD+oDNL7MQ7aPeklBmHqSdhfC3/fPP1T6cI
	 X8y0sOtIAgmDjgkIIV4gJw1Dv2h/LF/egkayhlB/heyzQ+1v4hqT6qziZ6ErKQ2tQ3
	 dI+kNrXaCaLMdau40yq4Ubva1g3Q8HcsPYQCAv+bZzzwed3TvcGhJZ/gYqxztsIl8+
	 JFxp3hcNuC/0A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 31 May 2026 10:02:50 +0300
Subject: [PATCH v2 4/4] vc_screen: replace __get_free_pages() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-b4-tty-v2-4-f7149947d4ef@kernel.org>
References: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
In-Reply-To: <20260531-b4-tty-v2-0-f7149947d4ef@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: zfypffbnpqa7gaqu8ec7b4e839ns6yuy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 544F18000B
X-HE-Tag: 1780210983-645452
X-HE-Meta: U2FsdGVkX19vV7iyYNYrlTGp3B6MrtCVtwSPEexppt9YLVB12zcrxelD6k+xsGZbpetaqIgN3yd3nq2gH/QY317COl+aN+Ra5uXtpD4/TwNgsX7xUVUBS2nJ1ed9FaXvCJIFNffUUTduqxbRq2Kz+8fAGgqYKOiP1Gu7ODgHepuGR67wmwumTUpH+4omuiyVbaUkFWyAsCG/n0thJBiYym/N91s8HGquUuzk8DwAtEjjzPxQ8prSxJ2noKyXwJskoUsLeNNza3ghSnnoJFLskjcNwBE92V5anno+/6x7tdCBDYj5tAsfk23RfB6a68uQoZfp2jCgMuk7mPPBWEI1r7jvObMv7vO9C+zPBXPazpzbu+T2VaWtnbfdX5VF4mOs/N3sP3j2ev0kf9k9W78n6H8D+qUHkKF1PpSL5kY6IkOILN6HRP1sK7ceNh1VD0ptMLwhpY/ZguBBixBwx6g4YRB1jN5+him6oAzXyGLqJo9Fvmn2Cfl9MY39+zWsWdHI6EU7Vv/l6C39nVaccVjxdliOC2X/4WyIl8Y+mZ7BNoCJ/u8gRjKBgMuQfkwsnwsB1Ou3Ge6JFEEZsa4YAdQavg6pLAeVouRBeczo2RKHdw6jVrcneqGT5PJB5Hse62hSVosbEhufGOl6NmZxopBqIUUxmsa5MTCb8O0kn1LZh2VPDPR62TM8aS36I3HBPVLoJGM3zxgwCHPMXm0eu1vBKmvCbdsAXcaGSKljgdBNmY2DIjG111IempnYWndF/3HTj3oahcUhGKAH52lRUS5abB6Pv8pjFcOgwGpYU4zcAGHGAqf7cahk6gFxkWmz8r8GNWY81QgzXcUeT9UE2AgVuGrufn4a9qgrHqFshMcWiAejMhMRA3h/jbvU7aWylmn/S9T6uFs6g1dOKO4vLB5QuNZ2960mVdw4Q6dzq3QQ4h8yTRz3gEAKAoj30cpOLuqX/N0NmX3i4StC3JdjxWR
 DRvjxdbK
 7NrSROy2+0AHQRucqeSYIclS/NrhPVeEb95l47bwdqgRDKmqu/NvuP33n3JK2KgbtoZoqXONAZtT1M6ifoe+t0ly+N9fzZu8h40N3JARyLjR0UCBAopPKIgAekbHP2jUkXafvH30zTKQLkLHer81zaR9+sxRVUYfiDrCy+38krEwZw28p9mh5Y3Qbg+T6rQH61q6ao59BamYGLv1SbU+Liyr87BgA+95bVKAUZE2rOix0dguKjyoutDwS3b4hdhq/BXMvEACEwNEh0Wy/NfVQkUUQNY5ZkQC9UN1FW42wPVlqdhevSEg6lwpkgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vcs_read() and vcs_write() allocate staging buffers with
__get_free_pages().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and it's a
modern way of saying "I need a page-sized buffer"

Replace use of __get_free_page() with kmalloc() and drop unused now
DEFINE_FREE(free_page_ptr ...)

Link: https://lore.kernel.org/all/700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 4d2d46c95fef..386c80efc672 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,8 +53,6 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
-DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
-
 /*
  * Our minor space:
  *
@@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 

-- 
2.53.0


