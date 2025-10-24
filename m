Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4708CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBDD8E00C8; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C6D8E0042; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38ACC8E00C8; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 210348E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:10:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDE9D12A3B5
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:07 +0000 (UTC)
X-FDA: 84033494454.28.C4C6407
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id CD00440018
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:10:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D56W8QnE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761322205; a=rsa-sha256;
	cv=none;
	b=hukuhuCTReTreAh5XQlzk9TQ+vFSdewcxsQJ1B/0NrzqHlFdMQ+usrqcUUIggYXesmt9+G
	isAsojLEPVp1Ve8rGZB3CITsm0SsCTCEPG4x4bEmLCj3gpfL/qb5paoJhVPv5gE5+/eoQP
	Vox+0UYNfukv0oS/rlq4bpdzgW2CJhQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D56W8QnE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SbWqW9Qai+Lun71fJPV2ZvcU3Evl3TvbhEARlh+dkw=;
	b=hyaM+vAbFP7+XYId7YdnWWeD+BWI8trIUrb5cfNgue3nVyr7Z9cJRG9tVYmMlcfCUBuY+r
	439jtqRGqdk2ZM5CPvzR3NHE/AAbzQ+zWyfgnlgC490n87Knx58J0TELJ9z2AQistmYaFO
	gKpsK23Tn/K1CH15l920VwDRAi39Ncs=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78488cdc20aso28634537b3.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761322205; x=1761927005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SbWqW9Qai+Lun71fJPV2ZvcU3Evl3TvbhEARlh+dkw=;
        b=D56W8QnEVJM5XiL7wZgPyrKyL4DpppeZsI3BP7Ubz2lQUAOaJxEVjqHnz94rmpikwX
         OhIEp8t+2gvFmvHvk90SJdsFps40SjDmGDkPJxgxkTAGOdk0egSBsaQLoq3q5CgmSKZS
         820fu4APXoFa3oRiUCyzbjgCtsugt2CwKCxZQ2QInAFvrxRJKfHmOSe0cjYUlPnALmz/
         GTb3vsPTiOgsSE913OLIadcbs6LZKCpUz46/MhOJwSEmWAvPbSl4vEBVe/hbhHfLC58U
         IX/rpFaE7iKK9pajFc4OvTlbOL6UKmpLQRZqckouLJyeDg92dwmXaeEsJP1DBRrWHg//
         FbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761322205; x=1761927005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2SbWqW9Qai+Lun71fJPV2ZvcU3Evl3TvbhEARlh+dkw=;
        b=OD5nEJoFYzNgMvLD0/bt3zCoeOQPoiNKRpdB+o5NG+qxoXmKk60ozxwdhNeprja2Vv
         Vod56EqwIPlxb8YIyP0ziMIi770E1+hO6MtxXzbIcQd7+AB4YyW5GOMOKkp7mf/UItUk
         h86nduCnS0MCYYiZXpINzAIlYbVSLCIA3uVHAqsIQ2cLHbyL3Yy5VLUHxr6Py9xsUvAK
         07u8tiorL7zmJOnqPbA0JrEdOwrmQLXWEHrMkQy+v1djvQ/1+0VkcapZvjFViB+qD3NY
         UoYNRHuLTi2ChCfLi8iAqhfhJ1I40K0OMKnCKqeXrwM9BU26lVp1CYOt3h4upJsJ/SAR
         7zAA==
X-Forwarded-Encrypted: i=1; AJvYcCUT4uu2PeM15KhaRXR+Lt9KhnfDbozKgwU2ZJjZ7yLMAjEjo3WaIlAAawWG5PBa9YyxwqJ5Q2LQAw==@kvack.org
X-Gm-Message-State: AOJu0Yyy/GFuJ/8AzC6yl8jNCYOfZ4jkt3TjxbU6krLrYsWCGU+DYbJr
	1+hqw8h/homnVO/73ouRtQA+2MWN7a/duPzcMY5lHjGS6+bUL9k0mizpdRokIFpVDsU=
X-Gm-Gg: ASbGncs/v6TP103zwYTfJEcAKReUnPsDQFzMEl4zJNzpcfIsxEHzb0kPJRisvNjOKH8
	946eEfcO9k3pO35dgLdvaIrmeI0YQdLjatISP9qxcr7UK2uasKhH6jqZbiaJF5dAUieE6I5gLGq
	JgNVUbzrqUi3dPiMYK/jnf7ug8SCFiDd+m/q8lxyGZh3k4x/WMUH5ysf1yQOwY63DghQtbHMASq
	uOjv2nuSxrODw2aRHC2xDUjo6r+mQsK4HIWT/LR8GwBBbxgX3VoY91sf7inY1E1ydupU9LmTTg/
	Si8VXkJ5BSPHazvadom2NNVM4OLRdPfq8PBw5QVA51CESQOvJ0GHcavjfHrBXFhhQN1PhVJawpS
	YM8eomJ3gaEJgFkGzfY9YLTWzXqRZOwRpVzD5/DKGvJA+80VCjolkXABGwu/zBnuV508eFWlMqp
	4xKeWHh5eSptov1Bk/tBYiZmZFVuHx6+gPiT/3KPwoc3E1Kg/uu+Lw3t2i6O1RcQPsAlgmxwDEx
	8NoJYYemXU11H00wzBLTXCa8YnL9tw2zg==
X-Google-Smtp-Source: AGHT+IHZAItAvq+Ap/Z72KhPLfQ8TowTJ5+sfBUaR7iDrNtO0b+4ThX0ZIHOf9SDvkQBFhT4ShLEEg==
X-Received: by 2002:a05:690c:22c6:b0:784:8286:fde3 with SMTP id 00721157ae682-78482870f7emr209860417b3.42.1761322204728;
        Fri, 24 Oct 2025 09:10:04 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-785cd6edd87sm14099197b3.51.2025.10.24.09.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 09:10:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCH v8 1/8] kho: allow to drive kho from within kernel
Date: Fri, 24 Oct 2025 12:09:55 -0400
Message-ID: <20251024161002.747372-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.821.gb6fe4d2222-goog
In-Reply-To: <20251024161002.747372-1-pasha.tatashin@soleen.com>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD00440018
X-Stat-Signature: 8a7nawsdd7m58iqh8drqoeo7zyqfyzzx
X-HE-Tag: 1761322205-9048
X-HE-Meta: U2FsdGVkX19SbIHNo56d/DANI/0jiPtmxOd6qwT5hPdIJQDmrYEvBdZjbIR7t84EqXr/tsVdJFUrJMh9QObGXSPoMM43wvDaBw7l7xOdxkQrK8iOZJbLpzPB2VwJgapT0jstjebt/uLJ6ac19/qIjfpyOhWcjZO+NFIcG+qTB5btyX/p7U0mhsEz/UwlhzrdI3he9NSnQFyGaS67fZnUfiiE6cDKP3ZXyN2u2BQUIQLToU2jiPx5i9/1bltbHLzqJOCCvWwavPx5mBoQxfmTOhXNdAwSnlkgJyo93cvhXLKhpVSO5wkU15BhHzwyauu/VZU1jCaMzejWYB9lnbk4VXXr8WWaZRmXOd/1W4J0FwNPeuD2Qu0l8ne7sYEL79mTSNiTX4nqWxqef4q9dPAhvM09sNTiGxSq6BO811kv71moD9s4+qC5S0bwYPHkKya4NijiPBV+0gqoO87YTVvSKbDkifmWkZQ6ECndIXaKNMquRQuccOnHIPN0oCjs052EH1cFdjq9tuCEjbVpiPBs7LCsQpUXlb04VVGnQoqSA8fnCUIyEC3iC+Ga1UjIfoZ5Ej3ru+y6ipg0HORPyff1IL0Wh/MiS/HBRawvXuzPHWVYKJKaYZisy6UfieSjTJu8vowygXg6ii4A4LbN10JaAHzd5dLu6nlxvNm+zYvjSXEnuulfEvSf0aMOiCJELLPwrMsAKi1eJLJYFLoymp0DXEIK+9qShpGx2Lr+ZQCzsCj3wpchIDVCDQo5uJZ715rFe74rTtbf3i3TZjUf6mvTpOZafYHBN9ThgFqI/8P5pPhR5GgELY/KXsknNTwvSHvfo7kwJbn+4Ql6dCT4loBghm3tOuw9b0r/kSJ+aP+OO7MmyE7FaiI0+NO1nDZ6lE0J3tUuz36lFvVI1r9wy0pjHH3aQN7GNZp5qrRHmeymkIliE8C6fLIY3vwu//TSpNCn1FXAEepJP19P8c2K/b6
 iCZKJgI+
 8vuzLNsAExp/JrX7en1M4wWqcam3AKjQJY1CMoGGT8Ts4gvIGTOKrCvce0YddMifYfGbYoSu1tDp4IfeMy2sHAzLKf+lY54/mm3VELrI49jXNWUuxDtnj9ZZy6Y7LMsfW/D+U3bIPJcdsYg9fB2ydRqdyVbLxqDAQzjvYsnA+QZuIh6CTTJS2HOhcwyN10aLon09hfP2scJ7iUs8zhQv86zjsIZj6aL6XLMWmgCHtiVR2lCI98u/kjrOX9DbRp7KdOBlmEUbdkHw/tobCcuMZhRooLLN2bHJN0/vxUXrb6/ANP4r1xH6vVFWFpkw292exvVm2o5xnq+YG2ZMih0HH0JT6uS0coqCRHwu/w9mYVU7z2xxJSLJOmB5lQrwF+jIYzcxV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow kernel to drive finalize and abort without requiring triggers
from the userspace.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/kexec_handover.h | 15 +++++++
 kernel/kexec_handover.c        | 75 +++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 25042c1d8d54..04d0108db98e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index de4466b47455..6458f369a346 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1087,7 +1087,7 @@ static int kho_out_update_debugfs_fdt(void)
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1120,7 +1120,27 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (!kho_out.finalized)
+		return -ENOENT;
+
+	ret = __kho_abort();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = false;
+
+	return kho_out_update_debugfs_fdt();
+}
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -1163,12 +1183,32 @@ static int kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (kho_out.finalized)
+		return -EEXIST;
+
+	ret = __kho_finalize();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = true;
+
+	return kho_out_update_debugfs_fdt();
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1178,35 +1218,12 @@ static int kho_out_finalize_get(void *data, u64 *val)
 	return 0;
 }
 
-static int kho_out_finalize_set(void *data, u64 _val)
+static int kho_out_finalize_set(void *data, u64 val)
 {
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
 	if (val)
-		ret = kho_finalize();
+		return kho_finalize();
 	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
+		return kho_abort();
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-- 
2.51.1.821.gb6fe4d2222-goog


