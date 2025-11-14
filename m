Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF071CE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291DE8E0017; Fri, 14 Nov 2025 10:54:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A7D8E000E; Fri, 14 Nov 2025 10:54:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3868E0017; Fri, 14 Nov 2025 10:54:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC9C08E000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B656388D18
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:07 +0000 (UTC)
X-FDA: 84109658934.05.31101F6
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id E51D840008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bR8A5yYG;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fcc2P38UXx+hVgmb+4SxxQNGh2d5KmsLcTOMGNeKk/s=;
	b=sAbiDzFkslvGi/ZTKpkJXU6s2iG1JFE7q7pwzU8VFBxW4ltrJYOh1n6BAd7oMk2ehgYyZf
	3ADwRyzM31SVpWu2RBM6jgo86JwRsYe1SguuRN0aUQcBNfCR4YEwLkj4Wj6oCO3CldsWF0
	OSs29YoxbknyJvbdHlrCu9/jFOXkdTo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135645; a=rsa-sha256;
	cv=none;
	b=k1cJsg0xrFKeajvzVQyW5ctIvoAhLPS86gXwwy+pS7MmUfQC8VPnbl9fi+D2VXmKGAwtMR
	K0hTwEu9247gF8sH2b+Ib8NzSY5EZsqxUIDeRlWYe1vEzKUIbkCwJX+te8r+SI08wOxhOv
	zl4eW/qaTkPgfZW2pBcbSyKbVjSXMrE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bR8A5yYG;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64107188baeso1973138d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135645; x=1763740445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fcc2P38UXx+hVgmb+4SxxQNGh2d5KmsLcTOMGNeKk/s=;
        b=bR8A5yYG884v6JCD2ugfKzUPk1chTHB2SkVkf6OPJ8+De11O0EmN8PkOsWN+JLVWmN
         l5YReqe53FsdiDhbjJY7Mn4B8v7N/bSdDf3AtLF5L2xPs8VT9TBD9gDGnsZpmP0z0GF3
         PHzsQPcVNNQPGq2bQtMVpr54Sj/UMOPMukSQcIh023mgvFZkcreXSZOHfvIl1IZrzW0o
         Ta0CE0JXtGLX/w7glPxAUQcm8ToYOHFXgYt8bqVy/5Zq0H+7sVvjm5J0oNF9tk/M7bTj
         vz6K1pY1a8LdBgHyPgI2UTvcCct0iO9Ai8kf8ei8rf6xgkGFqI8OfKvHM5BmtVhBMm5e
         SdDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135645; x=1763740445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fcc2P38UXx+hVgmb+4SxxQNGh2d5KmsLcTOMGNeKk/s=;
        b=H9zjvgJ1nt8nqV20CPRhxZG7atsO1QZT0hGy4VZB7dAzqH5AjDPxRTuyQitSloZ2uu
         pYpAXLuUPyJESb4eJrEzqnhPE9Olnzz/7sY9kaX3xQqVDuxZye/x6hHeU7K6Tbk2Nxq0
         LyleAnG8vu277Vsemrf+cvydTkr4Fq9GXL+PILO9DJd8RIrwTOymPDos4bEu2T2A2EMA
         k3vdsCylxTx0IQautCa6AMh3bzbNpVS7iIB4ZPy0dr9WuBlLTC2QW+CLbPU9Ef/Yvl22
         T/QUJideCGg083QrRzpVjKqcYmSgb8LMkioKz/0i+WQse8uEEGCVQg3tW2jNdVT3oxTK
         bqkA==
X-Forwarded-Encrypted: i=1; AJvYcCV3R+obNBXzxcy6OcfN9h5XRnHsPKCrYe5KvSWAVTMxb0dHw+UcGFFJ9EpI5ybtqFjKJD43uCen1Q==@kvack.org
X-Gm-Message-State: AOJu0YxUh97VSOg7jJB3mORhV7H0cQvlXbTudxCSSnf7s+PLRXHiWKY6
	RG7ZxPgAvksth4qruNRN88pJCP4dS2p06zaNfv2Ix7yN7EBN9zeGWoYoHNx+OLEIkDk=
X-Gm-Gg: ASbGncuwzj7ci4JVTCHfSvXkkQEjbKHphrLA40Yy3kKV6t9ocaWiykqE8q62JmhtAl5
	NovoGApCEwEjOGxEHXGV/VBT9V8nDNByUEYGtV8H+6qLQmr2rFHUmDrtfJqmXu2sLnUVHYigzUE
	x8ArBjDJBehbQwni3yRQiETjHEyyiUR3wUNwAAmuUrBkOBumbIxoIKTllGho9iEJAOLg5iHji1P
	2YMHpxYgcx3WabFKQcLw5DBEiBqlDItwER0N/KxRlneGv5hKayhShN1u8ehqMaIAcFvkzxFOlyf
	uP+1Z/XW14OpRCKUT7zuhmFNHKP+PgmhTet4cuAX6O1Kp6gsephPHx3TPGyY1KwiHwow3oQW58q
	d7q6z21dTCGO5SCl1l/dXFX7tyl1kG0jDK7r2F1tV+AXsjhHaOSQsSzl9z84zXPEZenDAd7mOZH
	HZLSZjgYX0lIpwdMn95HRAjpfBFl7KI1hEm7oY+PH7IxpdgjNOlo9CehnSnpUPXWKVLbAhty6iu
	gMf48TWg20HyAuc/g==
X-Google-Smtp-Source: AGHT+IEryNh271MCJ4rrcCUSvX2q1hEPoAUfB2GLhMC00ZkHNbgwj+jY1D/l0YSpdPxZL/e++/fAwQ==
X-Received: by 2002:a05:690e:2516:b0:640:dda6:e957 with SMTP id 956f58d0204a3-641e7605cd0mr2400614d50.36.1763135645015;
        Fri, 14 Nov 2025 07:54:05 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:04 -0800 (PST)
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
Subject: [PATCH v1 02/13] kho: Convert __kho_abort() to return void
Date: Fri, 14 Nov 2025 10:53:47 -0500
Message-ID: <20251114155358.2884014-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E51D840008
X-Stat-Signature: sjb9wrd14nj54xmuymfwjrfjuq4mdggk
X-Rspam-User: 
X-HE-Tag: 1763135645-273351
X-HE-Meta: U2FsdGVkX19ZhNPJRaJvmynn+gFyBeDzj4P1TEcKA49uOK13X+qKPlJEUwdywPfI6PLBQilnTeKQAWhTtxyOZKSkuHk7iabSkNFIEJYBKKdL5OKETwdgVx6tnQuFYTACk6c1XaBgDt7eSS6oI0HoOoeEryWMHJgapd8G9fc/0wlTNHrzPsBiTuCqF2e7QX+QF+Q7jsvL1lO5w24FizHghJMnDDd1aajilKE8+EGippmSKsLDhxmM01obBUmTdZJ+J8PwP+nlPhLuHRIIiM9GycbcaA5O8zXpxm1pOw6bRUWXOZf4AZuhUZUUJhLlM9qDDEoQQtjNk3HoKO5q91S2Quy6F7JLqyCoaDvdFUpH+kPo8sZb5I97PK/s0nYfhGwYoD2eiF9wSq8frRSK+q9gSIIudMeC6RpD8RabhxF2IymHh2lxkzNXTiOwfo5drPqSjlGuP0s+gCKCWZpRONGtTVTRQeIwM3o0B2UWqz4ARZZd6fw/zu1jvTM6eIz93jLJ4BNMcTtyf2P2FLABCTi3NrkRfTXjN9s3EnvrWKmyoFvetX9AIOE+jKWVrGTq5iK5LRPrjGLv4FC9CuYD3vRvy/Wd5uVH3HamhpdBnQtUb8dAGknD/uuQZWl3uXBNDWekoFXJ3O1coaC8tjkMEtullAwXHLcuXnKhhJj8V4CBI3nqg9+TJHhTNDJIFKfD43iQplos+YoswNxT0LXaE4hafWBFIRMcu8jhDHCNFYFTSNS6BUxrmE2d79hQUmwiZ6HQ5ExLch/zDgGqoRZzOxvjP5exWyZo+ugFDxdn/dTTvQ8pWBXhvc0diH8moMT3lV13cq0w8ZQhHOfqadJM3IaTG0ikRZdX8puBWh+iUL5IyF29Z36Zt3rMPSsz4dLJFlx/ytKkQ8y0CTqtuwoX7xo4SUt+rkt1xV8XnEmmZoeYWpoyju57cvp6jVmGhy64biDCJfQ8i/JegkqzYJTORxz
 WeUsnw9j
 SK7HLw9uN8rCNYU85p8ZROQxvRpeF/KCFG4DbhbEsnYnFOs+Uflrtq6vg4brmOYFhkjO1WXkR3httqZgJxLHEsAmS2vUEG45gSiub3srubd7zkkgcJjLU6s2kXRFLUjs6f8bXAIHyL00Pp6hnCka5YAo8WSmLQetBarG+pqkdw4H8PXtgNGFbqPblm2HBQvFkO83jNSuraJx3VPz8ZkI6RJiWTs5WpYZriXZq9vM/PcOsuzjqU9Qy3TmlaSNFihoZy+Az0vxfmpWuZG5cvorghMVPFNhUc3BWqZyyvvaDfAviTxw4JGE7CBfDqFbNu7jOYT2tmaE13NSHwK5dbeyYjQbbu8zxsOy2fOsotcuK4UgvZ+e5F3/YbDTiWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The internal helper __kho_abort() always returns 0 and has no failure
paths. Its return value is ignored by __kho_finalize and checked
needlessly by kho_abort.

Change the return type to void to reflect that this function cannot
fail, and simplify kho_abort by removing dead error handling code.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6ad45e12f53b..bc7f046a1313 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1117,20 +1117,16 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-static int __kho_abort(void)
+static void __kho_abort(void)
 {
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
-
-	return 0;
 }
 
 int kho_abort(void)
 {
-	int ret = 0;
-
 	if (!kho_enable)
 		return -EOPNOTSUPP;
 
@@ -1138,10 +1134,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	ret = __kho_abort();
-	if (ret)
-		return ret;
-
+	__kho_abort();
 	kho_out.finalized = false;
 
 	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
-- 
2.52.0.rc1.455.g30608eb744-goog


