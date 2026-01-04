Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A31CC2A069
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 21:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908EC6B00A6; Sun,  4 Jan 2026 16:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E04E6B00A7; Sun,  4 Jan 2026 16:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8132B6B00A8; Sun,  4 Jan 2026 16:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0906B00A6
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 16:15:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42255CF65F
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:15:52 +0000 (UTC)
X-FDA: 84295538544.14.9BAA88E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4591D180003
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:15:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TpSsv4YI;
	spf=pass (imf16.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767561350; a=rsa-sha256;
	cv=none;
	b=tQCMK4VwNVpcxGLgHuqgw9W+EKYup/dP4aXJ96nwzzQ3ZNHCTVjhANNP8rRd09BCTc8BbO
	UMzcexQGSN1jOrPeJ6+4oXIMqxlbyGTHgg+aqurKQRK/BWSpPHN/ceySV9wTlteqI+jACj
	bD6J1j+ZjQU+mY2yJVuR5PeTMxh3nkI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TpSsv4YI;
	spf=pass (imf16.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767561350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IlIrsuj0G1VmQJQm2jrruKAmlWEPSsKvc1kYYbu0tgU=;
	b=dQjS/CurcMrjxJpGPVCUFihzg0s5rNEFisxdJEyudwUbzkLj18Yw79FuFya/JswxVFGaXq
	aYRakwe4pqh+kglFew1TAnLOtWinYONxjR0HpmkaEekIrFSinhFDIMuBgkSBblQaToEyFj
	avKO/Zb8xg4EoblMc9QwThT4MrYb78w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767561349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=IlIrsuj0G1VmQJQm2jrruKAmlWEPSsKvc1kYYbu0tgU=;
	b=TpSsv4YI3U4ZdSm19/lkCX7XQTpNNw5XysDjlIX/acMR1jMxWQFI1weq943LSsO6HHUHyc
	8W8tjUln/7mHKoI6qQPND46Yr+2gUI3k2aReD1Hof/ctA1W90ZnuTtF5/QcprObRQIYUBh
	VtFeKc42fgrgt19vgHDU+BlWMbKxN2c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-YYmF9m-IP3aIT5zDsRAeDQ-1; Sun,
 04 Jan 2026 16:15:44 -0500
X-MC-Unique: YYmF9m-IP3aIT5zDsRAeDQ-1
X-Mimecast-MFC-AGG-ID: YYmF9m-IP3aIT5zDsRAeDQ_1767561342
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 793401956089;
	Sun,  4 Jan 2026 21:15:42 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0924C19560A7;
	Sun,  4 Jan 2026 21:15:38 +0000 (UTC)
Date: Sun, 4 Jan 2026 22:15:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
    Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
Message-ID: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5WQNBClBykKjZ4-CNk9X3cC6sZKKCWcX_tawxr1Z67E_1767561342
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 4591D180003
X-Rspamd-Server: rspam04
X-Stat-Signature: mcdwuqywnaexp93phs9canquyrt47x6c
X-HE-Tag: 1767561350-924588
X-HE-Meta: U2FsdGVkX19S1hHcQk9m4wCEzYXkGC7XQghui4F8BYDvWUuNjsnB0Ec1b4jSC4BkHHxZ1s6aqhJv+5NAa8U7NUTZGAmA9PVrnMBqdxVksWiQQWuCB8y5EZyHGwD/7cBZrqSt6MzPvnFzRYIc4cKikP1AzNUNrnNOa8FiJsIuy1M3Cn+FSx2pFCVwU7kBGxXYW+wR8xFkRk55B4SqJaaq5Ysbcx4II1RxBDl4BnIQrOQS3DGksLSVXicwv1ZDWhUjCnK763ecyUvbgpy55P/ZjNAmOU41MLRcnLTwd7A/KyHBx2PgFMGXpBqVYZeITJKf0Znm0bbK+t3vQ0iuzlIwmYfdKsS2Z4VnfPAe2bENTiFGXr3ZvLk1qxVlW/EdLA/rSnAiXNwyNb973+LGRD+gvBMqNT7MQ/mGGP4O/2Xi3l0tVUvTMpJLAmjcrjqiBg/BR43BZXdwzHuIRc5fIFhtmQgPzhoFA1Q7jSFxjCfeCS2McgTuSofoGu6mopeF4+hjkPogL+t07noDK8a/mjR0ZvbaOXNlhvLhUfngEUebsOH6gGrHZpdmCKfF1B3ROTu3RSTuiUBcciRHuYTug7oHIeVG0/0xQqbsBtB0VJIs/TvtmDiChHq+oXlKzFd6g7DZzGFq52EHkacKxVRTsw+90vApWHO/zIf8XZ8th0lc+zfvvOvrABvTQ4+nQ7br0OusL8biPckr53UNgr3KP4GstjZIL4PwLrQwwcUG6xtFwBd1bRORncmWn5JfWR+4xc6aaaXD2sfbMbFFlgUC3uwZ+d6LCJOOj6L/Zsp1PLpsceiJ2Yz3KFm4SE7D6x/raaWkTJBUcaVQ0dWwnx0wEayegxUA5VEICYZiKc8NFe6jnJpTdCJtsfcNMtzLJpWhGtFm81PKN9VCzzYflfVFhLVB63jktf1ZMccpOQGbLi/vsYwZsfe1urLoOZ2bFzAanhL4Qt89vIvn+h1pkobi65l
 FLT+5g4T
 3COseEpqxJgHBtSe8SAcDTbVtdyB5gjYa/ElLP8hUV807RdeIbGcQCT2DGqEq9gbtm5ReUgqajVdeD/NaM7asyUtU5wDMwLvWZkJ81OstQJJaLxNsGzMaWjKWl/CttcREvsqkxSN/7a8Ijb1gbWiTeAvI0SXRU1V/BG3jhyM9/3wMiT8TKhN2CAY8Vob4cIXrSF/QWOox4lV1OOKHqLuFRBRcjEg6h5EpyYhzUGereX9nLlyljpDDrJ9K27fUP0LghVyv9nEGwDFbrm92bR0V4e2GQtDb648hATDVvbXKYfkbluAcyn0WgFGjPA/S7Tch9IV2bliPX4nhGyfa7WM9dq525AlKTQsFTaEM1qm2ixIdJ6dZjXzPRypY6fpkClCRdjmHLdL+3xw32WklxSq/2YQXv07H3/5BptOMU94KMEBzx2oEggUOvHi6EsOgg7UQ7ydJ4N0zY/3m3oo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a dummy function fatal_signal_pending, because it will be used in
the following patch in the function mm_take_all_locks.

This commit avoids a test failure when the following patch will be apllied.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 tools/testing/vma/vma_internal.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: mm/tools/testing/vma/vma_internal.h
===================================================================
--- mm.orig/tools/testing/vma/vma_internal.h	2026-01-04 21:19:10.000000000 +0100
+++ mm/tools/testing/vma/vma_internal.h	2026-01-04 21:19:10.000000000 +0100
@@ -1364,6 +1364,11 @@ static inline bool signal_pending(void *
 	return false;
 }
 
+static inline bool fatal_signal_pending(void *p)
+{
+	return false;
+}
+
 static inline bool is_file_hugepages(struct file *file)
 {
 	return false;


