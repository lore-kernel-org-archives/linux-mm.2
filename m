Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544D9CE8D6F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14EB8E001C; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76A38E001B; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BDF8E001C; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C78BE8E001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FA2612E402
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:19 +0000 (UTC)
X-FDA: 84110128158.04.7907FCF
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id B46761C001C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ec1i4CZr;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUeee70aoCoEDH7tpogbMA7MC1e04DJkCX99vV5Wq8c=;
	b=rqLVQMxoAugDEvEiJmI6uaXXoJ5hn2QtW6G69LQoxUbM8KXiG4m453PgCa++levQcB9bWy
	Zk1gYNpwGe+DecylVYY+Qrd4yY4aXjaJCHNZp/F4rr7ZJMoJkfPkZzbSlJP5NzrzX4PfvI
	Yu9GgdUTWq1iv3KvecxL0U9lhuyuFCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146817; a=rsa-sha256;
	cv=none;
	b=AKo8KBHrDI1Xn51mDSrPrLuYC/V9cxYbJrHiasSQdKJIrnK57DU6klJO7s5qx0WlDEqBJy
	munPWxVkpvjtPgUwU+t9qaSHcmWsuxql8hqnzYAeRfCCZUYRuc0vCoQbdYCTR9ky63iaMq
	yDk7fLH8IcpQMmXya2AQV0Y5p2yF73g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ec1i4CZr;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-63f97ab5cfcso1974669d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146817; x=1763751617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUeee70aoCoEDH7tpogbMA7MC1e04DJkCX99vV5Wq8c=;
        b=ec1i4CZr7hxVyve1B0YM3J5vctR9rpgClj4uBEzbul5dTbqYf0rYaeon/dzCrx7GnW
         iEhX+LWDpkVFPTimojvH6ns4+Fdrl6WbVi3WUJiV+XFlkuRQ0VwYaf4fEtRcXcM/XOhr
         2bi7Q9fi6OnTRAPT+Q3Bn6qccTCFToRTzDNRVQqQqPX9FK4SvbGN0mTX9u5NSoAnGUyg
         Zl9GT1nEM06vYJnMQ+YL5SxlPzvyuGEH31Qza4giePmHOE5IWLzTZUD+1uzZp2ZCT62I
         lWkigWbWMMW+wzEeXYKIHJkfLD2288JNdurU0w9YWWstXkobo1Tvh7/bUznaHQBby4Lb
         ICvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146817; x=1763751617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kUeee70aoCoEDH7tpogbMA7MC1e04DJkCX99vV5Wq8c=;
        b=V/rS1Ag5h/lXs5Znq2wysgUEJU4BQ09FZH6RsETFRX4BeGRLsG978qFOQSXhpCLxgi
         FUPosSP9JxRTHic9kR5ECBPAuSCxu/v7sXVv3b5zXmm8amQKEC2r4tPkpOOeQjx5YZL2
         REw5lvnNugAd/v/KH9SVnSvShR0lJSNsJtmaA2IRsvjpPz4TYrB5xyaDsGytEKLn3yji
         Eg8u0l8vJX2YM6a+MbgTVa/pBvSiPwmWiTe8nfVjnMIzC65V6vQ/SmZ/A3OEOv+DKBgw
         ipkjjMDF55STSDgFX2RAZ53hAxHs3vZ/NzXidiz1Sac4ZurtbXoUHhvTeN+XvQrKdrxD
         EuIw==
X-Forwarded-Encrypted: i=1; AJvYcCXUw0AV+81BP2UTJEwiQVefKhgy8c8Bko96ELjq1YT8AkqOmDj8k0GHpRXc1z6+izaCLcBLUSLWkQ==@kvack.org
X-Gm-Message-State: AOJu0Yya500LPTDXx50RgeCiGvlGTytNNlf2IDSC3nyOHpwAVwKKpfir
	ORcCY5/HuGb1/XsehH5wnlZM2vNeTUxSYLz01/j5Py7VCa9S3zwceOpuVVyHmXnwqZc=
X-Gm-Gg: ASbGncuUFVfgfDDAbZdHa5Pavp796tckLKljn4xig5hYEBuLdWhryFHwVE4LSDovFSW
	apsqoNACBiSWB7EKToKfTs+tOI7og4lfF9kiwU+Fk6tPGx4mkNggPILmG9c1Xl/HtJiUnDXjGGA
	Q0faKCRHCEewlJSvJ0Zy/HPZR3ZXGyDZoTGdDVCzOAindZNCoWHq4gSpTi13z+coFRNcNAx3mip
	6q8+oOIUztLYNk3W1NJlMaQdQMUcmO/lkUqD+bHKEpvPz9C0gMFElqUI31Wvxb95waeFlrJbKEu
	zFJusqlU10uAMHmr3IWrnroXKL7F8WZtUslXUTeCzAKM74VEPBcHo19WhdVOSr9djbUPKGSP46w
	BRL1krbnXHYfFjC8uegDMepntvq44YThoK/Ys5u1DquFZ2w6Wt7Oah8Wvhs2pxrZKVxRl9OHCU2
	Ri3oYRAPwVYDz0J+y1otVUmR6ALa/GLJjFYi7ioodMigwlBs6O9kWeXezAU80AAJx/B9nsdX+Pf
	09WVk0=
X-Google-Smtp-Source: AGHT+IEDAZBpiF1oFEsVLGFJo+UdrqqTZLyy4yADm49I+si1ealVeGbZmEoKhxOu20FcmsBgPYr9rw==
X-Received: by 2002:a53:b10f:0:b0:63f:9c11:cfed with SMTP id 956f58d0204a3-641e76402b0mr2553029d50.32.1763146816706;
        Fri, 14 Nov 2025 11:00:16 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:16 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 09/13] kho: Remove abort functionality and support state refresh
Date: Fri, 14 Nov 2025 13:59:58 -0500
Message-ID: <20251114190002.3311679-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B46761C001C
X-Stat-Signature: b57d3xe1oypsixoz7unyyasksc74u4i3
X-HE-Tag: 1763146817-899099
X-HE-Meta: U2FsdGVkX19HmIjj5C01KpCWNvPLATHndDhGYG/uOc4mzsIe2gpyzNpbkj5Z+o2KwILaE+oc9wqmJcn6HS9B54D7yYz7zjTsxGik518/TXaECaE+LiPWi7Lwhzpysdb8mAX3twoNEH4FSCI4NUnK6FyC6xcRTHYeT9qn7l64pVNhVUgTdQ75CaTXdze5VRBnxyv/C5v2Eod+8B2/3mSkQy5ZRhBioamnHx+8TE5sg7AWl3mqTX+sxyN8bj4ia67S7ufecTfHtYVRZGlE/szV1v2hxGBhz2a3xgswPme69NMA8gmhHhUc3rcH4uokYCO4ogUcMfjRP6Gh6ZsJqwkLIRfpd2HuHrAvNW8wJ/9hNOT9Xn2UqGS7PtUzWFQk5nw8TLM1WjnrLN2lGG9bYmyheG+Q/9ruMweavgg7JumH2b6w3TJXbb3ScskqOoRwPL/nGwfQiHO1Qwxlm5aHtcjeam77d9U9FBnY5b0lizB2BezIviPfftW6QPjmMVHaScfBHhJTGwxyyKvzM4Nj4ZTS75R4ggPOsIvSyskqtjRZp7WV7SeLtuQKLjY2jpgT/uUwdSkoVtqGvclNv/2gaMRMxUVTR9m142jP9Z9VPC3G20ElpFJoBcc1z1q82tF/B3lSW5MAnAb1HNM4yOvwDaTHudbKqXN8VwzHJMrQgSnhMtAIg1LS7OMQxtwAUYaLETlQSYM63a6+Y9HhwivGbi5KpEqr1S+FXUjuj+cn4sotevmN/mQD0CNNiHIc7EI0Yq+CllWBxhYT60Nx+9ozBnxpn8ERBnT8JvjKTby8s83alL8RRe0b89WgcQB12Ux/A9hlX58z+N/rh8VGROrXfnGlveTOct661AO+z0cQ42NDlBHNu1DJNekSzW/lrGk5N8CeWD32kUD7Enu+PBLjWf0AJNu1UXR9e9rDqLjiPuV9iM5cL/iJL9SnGfwktesrwOQNEbngbphtuSbPizZ6Xnw
 M2wgpBeC
 rdzZZZyyphrJ6mYPNvwI3HmaoBZELLmomwhZfQFlyNiI7FkReWD1XDVaFpo/AM+f2ZRN0Qq7EwsLkI2v8/urxwz2myg5kSX/iRYfHlQ3h5sa+1g/HMrHIyOKd+eJDWd56eOGVXKtNbYXEOQTUM/AlIZU7wXD2ieHMB/qsSrCc0NRtrsJ+CXCjBgBXbM9iYHqAHd1dxu1Yc6VkNLMQyTu2jmrPjrHb7Pz+fRkPK0SGb2nhDTWJGbg0D9O8Ep/tyDiYOm50DbqC/3GC6CjmLlWiiun6jRca5TQQuI5GUgtpwygioF6XQ026oHWOLy/wo2sxk/R1imSu8YkKyx+sLd/eNb3CXRpudONmLRMs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, KHO required a dedicated kho_abort() function to clean up
state before kho_finalize() could be called again. This was necessary
to handle complex unwind paths when using notifiers.

With the shift to direct memory preservation, the explicit abort step
is no longer strictly necessary.

Remove kho_abort() and refactor kho_finalize() to handle re-entry.
If kho_finalize() is called while KHO is already finalized, it will
now automatically clean up the previous memory map and state before
generating a new one. This allows the KHO state to be updated/refreshed
simply by triggering finalize again.

Update debugfs to return -EINVAL if userspace attempts to write 0 to
the finalize attribute, as explicit abort is no longer supported.

Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c          | 21 ++++-----------------
 kernel/liveupdate/kexec_handover_debugfs.c  |  2 +-
 kernel/liveupdate/kexec_handover_internal.h |  1 -
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 63800f63551f..624fd648d21f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1232,21 +1232,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-int kho_abort(void)
-{
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	if (!kho_out.finalized)
-		return -ENOENT;
-
-	kho_update_memory_map(NULL);
-	kho_out.finalized = false;
-
-	return 0;
-}
-
 static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
@@ -1297,8 +1282,10 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized)
-		return -EEXIST;
+	if (kho_out.finalized) {
+		kho_update_memory_map(NULL);
+		kho_out.finalized = false;
+	}
 
 	ret = __kho_finalize();
 	if (ret)
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index ac739d25094d..2abbf62ba942 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -87,7 +87,7 @@ static int kho_out_finalize_set(void *data, u64 val)
 	if (val)
 		return kho_finalize();
 	else
-		return kho_abort();
+		return -EINVAL;
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 52ed73659fe6..0202c85ad14f 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -24,7 +24,6 @@ extern unsigned int kho_scratch_cnt;
 
 bool kho_finalized(void);
 int kho_finalize(void);
-int kho_abort(void);
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
-- 
2.52.0.rc1.455.g30608eb744-goog


