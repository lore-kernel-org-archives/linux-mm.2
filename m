Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3217C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69006B05C2; Thu, 13 Aug 2026 16:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA0F6B05C3; Thu, 13 Aug 2026 16:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1306B05C4; Thu, 13 Aug 2026 16:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 969526B05C2
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:49:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 337341602A0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:39 +0000 (UTC)
X-FDA: 85097437278.27.42BEFE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 808CA180007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:49:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pd+eHJfw;
	spf=pass (imf16.hostedemail.com: domain of sandeen@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786654176;
	b=k3V6bOVU35fyG2HziPRes9ebbUSj3mvdN/E9PUnfZrImQ73R6V4tHHq3Ti5IYEUM8oIAg2
	G52PA/ze41ZkTfXJxTvfqZQaCkBcJlLE16oZKX33xvFIBJ074UOVWVmqLrvsYUhv/ICBXK
	3r/QkBu1lRDJ6h5Xn456VDUqFSdZmQE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pd+eHJfw;
	spf=pass (imf16.hostedemail.com: domain of sandeen@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=sandeen@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786654176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
	b=DI4Oyh/SDOUuMg1AI3vp3bLhLcCQ8JciPDC+zt84iBTjQoR5IksvOUkcSnPaO1DHaHAYP7
	er2jkhNzAjE44lAVfzZlmj5tpTq8+D/Ycis7rTTePpkLw/b3BcJTpPh52lW/K4DK5VGFtV
	TukBUqTPpLjdy2C++XkYtv36duSsNcI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786654176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
	b=Pd+eHJfws6m+R1zfCRCNYyBHprV0d04JrFhdcMZWFPVClorpGpJxZYgRZm3bZs+jiwvpq8
	grkgotxsX2jrZOiDztx2yzWKw1km1nRNGeymJ3RBmKcWf8W1RZzgERpDoK8lfQS6+Eq0Ys
	mUVTBhUBRN39u3RunH4dKjnhUAtNJ1Q=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-RKPb7qHuO_6KGdgUaEpakQ-1; Thu, 13 Aug 2026 16:49:34 -0400
X-MC-Unique: RKPb7qHuO_6KGdgUaEpakQ-1
X-Mimecast-MFC-AGG-ID: RKPb7qHuO_6KGdgUaEpakQ_1786654174
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ab8b4887d4so118492b6e.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786654174; x=1787258974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aONRfqKHiXc4KQKv9HOJe1ML1WHA3J2x2iZH/V6rhN8=;
        b=HtumTvQWHdZ42FRhPHwYnLLp+LuX4QGRjtmY46OlGaUT6GRwyLeJ6INZDzYEFsv19Z
         jxtMnx6zU4F3zQJMdilzBUsTwEO8zIcJnfSETNgn1+acaBRaALUIIcE0McXYMSbUC3tx
         B92RilCdl4To0/PQXCvoK1ftTK25byc8q4W8BGXeg41L7qaGT13rg2Ypwe30omETg3GS
         rzN9og+FZwxYPjW8z1aacIYPNckNspf0bpaQ2IRMBC97lmGhDw2ANj9iTDr5AK/cY5IL
         StEAToBkvNOm7hVJc/c5ePv+SY+T1XI+aD8ZeZZdrsZ69kLjdE97hdPezsHYoygNWzeY
         1Y2g==
X-Gm-Message-State: AOJu0YwWcyE8/rMylJbOESI8ixUUpd69mtllddFd2sVMC/+uH0nTjua2
	0C4XSRmdDTobyEAIon4o2gNp0UwlBCGrxV1DH8CCwjJzKTqbJjuEu0rSI24YYi7DlQpHhW6sFRG
	KUizMTIB29GwFLtEW5xsiqsfG8ahUKsPhPIHEmTSWzBKVES+zT+YA
X-Gm-Gg: AR+sD12ec3aGu5ZS8b4orUqvHr+Gz7NPjicHerDn8611n2zBDU3GQfP78gOpsl+Qwz8
	I9n/Z85vuhOIqB/ckimVDCysNb7ksUe7RbwiWbXVfW3VU33KmukQDXCeSKA3Kr9opcizDUCUVnB
	XQd1HG/xI1jfrBAN6TnWBFjILqwItZLxxZAMFAYI67xt23DNndMwQlp49WSuPqxjUuK3DNqn9be
	hp4rcFR7M/0VocoJfvjRdHeXHHCEYjCODUZgpbkiu+4ORhEXeBST+MHo7rTOGtETU/AzS4h5xqL
	AfM4nzpEoTQE6N8z1npUiwUsscQfAv1bVWvlZxQfd4IzhcJkaFrsIBfn9sBU3xigJjnebrEvm19
	Lpb1qz+K3lXY8UgSkpjhqGo8lXDyvoEXvnnfrA57Sp1s=
X-Received: by 2002:a05:6808:191d:b0:4a3:d333:2258 with SMTP id 5614622812f47-4b241cf3d20mr715191b6e.14.1786654173942;
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
X-Received: by 2002:a05:6808:191d:b0:4a3:d333:2258 with SMTP id 5614622812f47-4b241cf3d20mr715166b6e.14.1786654173544;
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b22d004c3csm2555958b6e.18.2026.08.13.13.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 13:49:33 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org,
	Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] xfs: mark kmalloc'd xfs_buf items as __GFP_RECLAIMABLE
Date: Thu, 13 Aug 2026 15:40:52 -0500
Message-ID: <20260813204929.2253988-2-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260813204929.2253988-1-sandeen@redhat.com>
References: <20260813204929.2253988-1-sandeen@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VkCYMbx_Eap4roNNc4E9lZO_nLJuy787c8Aj3eFbU5I_1786654174
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 808CA180007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jm5inft63dn388eqgchde6yy54dscwu7
X-HE-Tag: 1786654176-564694
X-HE-Meta: U2FsdGVkX1+d1qUTwjW+K5Rhdd3meHtP+kWzDxEpz2hkQQYOOQU9SYMnAilvJxxkWCZR2qaBZEIQoM3W4QnneQfB9DlmZ9o47f1pSWdgC4HpM8CCvskexuP2mwSR5e9WsVU8K+m4UCXmP+7kaG006V63r1CGrDQnGXc2cOH/wYLdcawgk8MpbGyeYNbu4+urHbbqdSeYVOEQJwji6OcryNVDgmZZ6q+GbOkTbzrZ1x+OlPQtzuqzcge0COZToZIBSkKL+QKnNGVKF0quhQhp9a1BoW2RePdAOYM6grlwXdi3yZmbe23c/zxv3OwJI0EBSZsKuaBTa8UQ8r/NtNAeKap1ZtuAF0XRjGObskA/awALt85tK91dRm0sfgWs997FFIO70e0xVXBBbeY5RfceJoHQi2CoQ703eHDL7NLGmKo55SpMtf53TOLBz9KTgI0eiYnQWmjwnbIw9W0Xce3LihOADni27J+aSRAvReer9gEVx1d2QKk1rbf47Df7YhN/3OoHFIobADHMR7km1OfOkZJrkuatENdVMRjrVHEXVwxD6EUEF/HtvNimsr1r8S+6i3uEkgyLfCs+01ityRzd2+CCcEBLLbuTX4l/cNWNuTje8ZT/ibSrKu8XSaivRDN5YCSO/wY9U/59QVucudkxWn2IIWtstlML5mlZOxugXeNLw42jjct5iUrAoQCGAxDkEA8PlPHioaDxUhqsNCG304eYdKw1cMDEtsxQ1pOUqS0yUwQTbzHEr6TZa4eh1wfKSGn7mgc+W9289h2GSqYydUg4BdtkR6JbH2SVlbN8Nlsf9MT4jJ5e+hVK7xnDNsEurvwEd73gBsv5mZfjc0a8jYWI3fNKzUlpf4bhTsEEf9tuM+bJ6fp8OES3sdWJ4igAjTJFxZvu6phrKsSesHG1mA315Q7/R/OyOJfSChhooriZRggnWf0yv7UJdcmGVXWx77jmOZjVfhkrmFnEGlB
 ntbB0zXI
 ATxJzEt0Re3BYOfegR6XiDRcS2h05vinPBpk8Xu9sYa0BujZdr/hyPQ4i9hVI99D48EDp+jKfbJR9FbWZNaZP9Rxf0/Wx8zKwwsGq/N9lWUhiIUyg79NXVjQSK9gjKZ6Ae7GM3Hh5Kn6bi6NXNRWmYebua+p0IbjrLZMZN5yx/8kymgd9vuLvA7rLCsnFRRXfYyQRMiKozsI+XZs75he22zjQsrFN+NbCFaareA0HVMFSQdwLY5/gatxJPC+xDKiv10dj+K3fH65jaPRWG70SP3cTCeC9aIAX/7/ApDAV4D9+Put/y2wRjGtlA5UqtQ9Oq0wvxwQOtJ+LzMQDmFL7o2GDG/ZA2Wmsv8p/av+9HW3jWCqI3MOmDKRU8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xfs_bufs have a shrinker and are therefore reclaimable; mark
them as such in the kmalloc path, so that they are accounted
for in this way.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 48d7dfd3e15f..2e00a33ebb62 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -145,7 +145,7 @@ xfs_buf_alloc_kmem(
 	ASSERT(is_power_of_2(size));
 	ASSERT(size < PAGE_SIZE);
 
-	bp->b_addr = kmalloc(size, gfp_mask);
+	bp->b_addr = kmalloc(size, gfp_mask | __GFP_RECLAIMABLE);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
-- 
2.55.0


