Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA13C2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 21:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C9D6B00A3; Sun,  4 Jan 2026 16:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566FD6B00AA; Sun,  4 Jan 2026 16:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489FA6B00AB; Sun,  4 Jan 2026 16:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 383DE6B00A3
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 16:18:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4F09161734
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:18:07 +0000 (UTC)
X-FDA: 84295544214.01.EDA4832
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BFC24000D
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:18:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDxm+nQm;
	spf=pass (imf12.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767561486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hyp27LAQdCOuI+jR+Ub383o9Ghg3Zj0WM9a7WADb1iQ=;
	b=rzx9hinMcj8anEQDFlRqSyLtFZB8Rwtq4k7mvfT0ouAS7fIzfADpWd8BkwrkAlPBHS+8mN
	VGdfioNweyZF+1rCe2mtNyDo7JJ3PFFmQzHTxMB2h+kqDxa9aw48ZHFaJYO4sj1M+LSf2+
	sH5lbKlcIMeqLwutg1+3ivqB9RJDCCw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TDxm+nQm;
	spf=pass (imf12.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767561486; a=rsa-sha256;
	cv=none;
	b=fTM7nIVUXI9GczZgCqO555VZdPdRuQZ7bcgI0hhb5JBUrHd+xi2F6nQx2T0wuBsIbwXg2o
	MdlWXgP1oAmw50HU6c6yua/u/0eGJu2El80SGqgFjpLYhwz9eHk5XrEN9zeXDwLfNz/494
	VGqOPYFPMPPXOcaNdMKEOjnoTpM6FpA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767561485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hyp27LAQdCOuI+jR+Ub383o9Ghg3Zj0WM9a7WADb1iQ=;
	b=TDxm+nQms4xTUMzQiFhtZOHXJwB7ppevGvYhICqnitB0lVfuB5jMLF+4y9HmVBCmtrZ3tB
	qcAGi/fNA/CS7Bp2RclfyfBQd+ofd1kVxqfXrdQEfCupejT9wvXloAHAHW1BZEj3svqHpX
	TViXDnmfK+mYHMYHyzXXSx4eOSuJzYM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-198-HxZuzOLBMp-yB29UdILreA-1; Sun,
 04 Jan 2026 16:17:59 -0500
X-MC-Unique: HxZuzOLBMp-yB29UdILreA-1
X-Mimecast-MFC-AGG-ID: HxZuzOLBMp-yB29UdILreA_1767561478
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0607918002C9;
	Sun,  4 Jan 2026 21:17:58 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B463D19560AB;
	Sun,  4 Jan 2026 21:17:54 +0000 (UTC)
Date: Sun, 4 Jan 2026 22:17:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
    Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
Message-ID: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Kq4ruDQVBWLM6DrDIVkd8YRzPcny2mpPYhrMyksGPjA_1767561478
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Stat-Signature: 6ftjgqfdsbssxonqbxixhrmuo9b38ehe
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BFC24000D
X-HE-Tag: 1767561485-140977
X-HE-Meta: U2FsdGVkX1+9Ktb37JsZGjaJt6Dx6iroy1vghwPXP8TdpIvjrDL1k3cgTh5b63PLH85BFzTsTAES047if4f2kEyf4BhQ6bmOU3k56Q226GpfT8OExKlgepy43/iXqxmaTg9MVg4TPgdc9a9Zfpeq5e+TBOkJ3t0NzNuNC3siUuaM4XefXkZb0Ac7kXNK1/36oLtkZdngznUpqhdrHhdshi3gjt5hDQdyJFqEOOvrPe012R0+ohh0RUJkRuLtS2FGMjTWD3ykLsexbXuSnF7vuSkFJ9As67tc6mVydKSraBEZMaRAmUjMhSY8K6UMF8qZDcQOIeXaxlSELq52Hjjyd/gBTUYW4cUDcOmfOhiPOva5FpWq7AnjnXIhqpG9dvcxXc7dbDtDtQcHykIuEeswil529L5c/21fNhPdlTG6axhHd+ZEzXb//WYVPbwoz32j3Q6Lq4E7l44Jxq70bMjChOsTb7OZOTbpF5PC8bwHEFqMDpPc1Ht7uOT0Vhfe885ok5F8RfjsEyPjvKoT4mcUMJC0663+dbGH2PcfsaR1bevUzoeXyyOf4nORiKJ0sznYtb6+5I1vcbWyeiAat4dB0ZL3G2XpFXVIstLxRNGkky7VkGj2ibFrD3EfWdj6dAGL685/WKvDDSTBOjw1YT+x7sDuH6x16kLlw6JISWCu6x7U+Jv5agAhdOdwD4ge6CDQIBIsoTnCJcCDkINHsnyoSDrDCW/HcHMv5BsVm0fvum0bn9EYj9fbzoth1c77JsVgchfn2aEzRL9fZFCXMR9NEEXwR3YHhO6ygzdmwTqiGqrua0BaY/BHsLPNCrg9m0czg6n/yFMV7JSAmFqP+yDBacFaCXfzkgn3bo8H7FzUGCfEsZ6q20c36AyfI6QQxKOgbV54sKNPj2xbkPZFChnK9ZMduzywxHN4S79ua8xK41oqGQNRIUO0DSarxH6xMM2VS9WFDfFV+ooN/XVFSuG
 Ao8RQ9Rh
 opFB+jN+RlTS0hWYrl4K1o1aVqYwFrNRwfGHBMewEA7VlkUQfDWqzEQl3L7QXT+Re6ywAotc7XGDVs4RKKlZntt3sLey/hkp+/M5rhXYMnG+xmJISj8aQkg6RXEop+9nWZz05Oc5pW/w4Kt8KSWDJAw/9SXrrRCxl59AtTks4xX/sNZmI8lqYZvgA9D0/v9M1s0ZxGlZ+zFzfK2ym8aWXvC1OtEn+9/2cOsTTIIbzYHR6ITlckOh43vOzU+eJDEmOc9N4R0+CI8yl9KtpTBMiT1Gf49FK0v4wrS9taBED2i/+wTYsFBjw/A7EF8pyLj3OoKCR41o14sjDFaxYNwb1uZAqmC7fun4D/oCVFvrxePw6JKu1K0bPKucSiC8NcY9JUr3u0cSbYrL26wUHuE431RD2N4zLaoqyS/YGG4VGEXVEHww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the process was killed by a fatal signal, amdgpu_hmm_register could
return -EINTR (the -EINTR comes from mm_take_all_locks).

Don't log the error in this case, because no error happened.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
===================================================================
--- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
+++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
@@ -1070,8 +1070,13 @@ static int init_user_pages(struct kgd_me
 
 	ret = amdgpu_hmm_register(bo, user_addr);
 	if (ret) {
-		pr_err("%s: Failed to register MMU notifier: %d\n",
-		       __func__, ret);
+		/*
+		 * If we got EINTR because the process was killed, don't report
+		 * it, because no error happened.
+		 */
+		if (!(fatal_signal_pending(current) && ret == -EINTR))
+			pr_err("%s: Failed to register MMU notifier: %d\n",
+			       __func__, ret);
 		goto out;
 	}
 


