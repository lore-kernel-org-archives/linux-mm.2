Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA39CE8D4C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291918E002A; Fri, 14 Nov 2025 10:54:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2694C8E0029; Fri, 14 Nov 2025 10:54:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109B28E002A; Fri, 14 Nov 2025 10:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE85D8E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0AFB13AB7E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:12 +0000 (UTC)
X-FDA: 84109659144.03.4B52C1A
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id D951340013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wmim7CAZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135650; a=rsa-sha256;
	cv=none;
	b=GExgYuEnjQ+9GoihiOLGD4/hQRLX+AUCfvtiV5MRTLUtGaRAwFZCnGQazpd9DGeQM0BD5p
	nQAUxuTMoBPv7F/TbeSsP705D8a3Oow3BpBb41CzSDImCdY3PiTcfpqpPSoQViRDVwRbFP
	NElUvp3jGKUWomFzPq8dgxh7BzlFr2M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wmim7CAZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igCLvLEtUCW/UbsBfP3ZrnZSCO09iCMGfzuHZKMcaqM=;
	b=V6ZGoUUskDPDRPqI2j9y/rcKSPRBPlYKgTNdN4pKWze892TdtbnhPB0Ma4AgzEDJkW37tb
	rgRYv0taP9p9eoVxl1PwOCcfVyfQCmQGg/+TlRH1H38/K5gJ2JWHysOgs/JnWperrO2P+D
	7d9RmDHYexWHseWr6hXdThzNLZU1RNo=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-640f88b873bso1927333d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135650; x=1763740450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igCLvLEtUCW/UbsBfP3ZrnZSCO09iCMGfzuHZKMcaqM=;
        b=Wmim7CAZWkJaH9ghhDCTdRY4mVQgnO9wCVOmp/ZI3RmeyFPkXm5pCMgXgAAlakOYhy
         /90Io4desV4B96gcXjqhOXNw+5yISpWAxuKA0emHppQ4xsXhj+hPstrDczt29kmAQbqH
         m2xmNELg5k6J6McMKoYfkY23czHcItvfP/20c1Mnconn8E75AelO7qC3i5lZp5wBJoqy
         CZRdgvXqd43oerZFvfp+vTy6dhwBA/oHBnH0WX0AdiwwkhCAWmrE3lH54wXagC+WcH/q
         bRyanKuFXqxoGmH73Et36xSbntD+7PcRUAeh/pXXKKAOQG/nMbvunSRYKiu0g6QsnnYC
         Mf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135650; x=1763740450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=igCLvLEtUCW/UbsBfP3ZrnZSCO09iCMGfzuHZKMcaqM=;
        b=nNOTBGvW2Jna4DF2zKFoeWeuQtn5zwQxMUUi7p1W5jp5Fv1mFZwWo0BPxJ7nzoeF1t
         ZtW1C6/f7gLjhySSF0MaZzwGirocnzkJWd96BvWnTJel2rb7hGNT3P7RP0L2VwCJKfhq
         93zbjoG3HOJBzRwfFMyQrrKtvPYFKmEg35/c5Ua7H/AqwyRtcVNiPGs2ZoCaCOAXW2mO
         k+AVtFTMHKCXcITXHcOGtwXZwpz+nliXbQf0oUCKQKp1sq5Obps/6UKJDK2Rf+p4VzCl
         J3lRmnhggVsqUhkBElRM40qGCq86buSXWQfpyGCVFAEnipvz5mP+tCQpVoyqWPm939F9
         2Yqw==
X-Forwarded-Encrypted: i=1; AJvYcCVhkUAug1GufAaYQ62D7/k936H2J1bwzAYz+gbBUZvrySCTv5D5kMlTRGz2qqHCvjNH6bZUSdVInw==@kvack.org
X-Gm-Message-State: AOJu0YzW7587UgBoNE0SUNgPHlylr9g8tnLYyHYGaDcBSTYIKa8Fn9OF
	2D9YCNIpkecys/j6eRbdm6VBqoW5ZOTfutn4BtY3n5JAzqr+wUr7FHPGWAt4qOUR1NA=
X-Gm-Gg: ASbGncsNFdBfrdUPgR1GkbpNwf210YGF4LCqAtDOpe4kCQ9IgUFdH9DOAzHGYFoiY7h
	Zwd06OR7uWV2TImD5ylTq1uwkkkNlxw09jsopYbxdCzvUkaDAk5K8rspByIVBmKyfpK4ZUAfHUi
	GrT7w8e1HMUehpSsMRrhqJtn5UfUUJT4PsS9gXPfsebnjU+Tu7iIq10frif+RZso8wOALyQe/rI
	ZjKLnWbko6c8XBpnR1g8ROwdbGxikOCE6fTVnE2z+NGxWoPYWrY9vlXoFIL+CM5KVD4ewBqjYMR
	OY98hAWSv427Eokm/ZqDcHfZOuyBpKg3h22CeLk0HyJ+R3KyUtub8n3ZweCVVrNx3Zu1N3fesCY
	8EdzWSAZ83NCj2Rln7/PkcWN1PDP+u5zuDnRcNgz0st6BeWclmBvfUjJpF11EVbd6veOSFXk/xE
	iV5iFHZTggJ9+7cATfRvJIIhrwo7b/n8n+Mf92qHRXcvdPtwywhio/2qV12eukBqeIAveUjKF15
	KOdZxg=
X-Google-Smtp-Source: AGHT+IHbg7qHrmk7KLr97k4oOuXP3IULJ1XbsWmcMpEHUeh0oxpcL5aioIi8mM1kv7CPvyvvy//CpA==
X-Received: by 2002:a05:690e:d8a:b0:629:acb6:d8a with SMTP id 956f58d0204a3-641e7562fd0mr2830828d50.26.1763135649967;
        Fri, 14 Nov 2025 07:54:09 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:09 -0800 (PST)
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
Subject: [PATCH v1 07/13] kho: Remove global preserved_mem_map and store state in FDT
Date: Fri, 14 Nov 2025 10:53:52 -0500
Message-ID: <20251114155358.2884014-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D951340013
X-Stat-Signature: efpdsprr3weh9jzckzt7gittuqetddrf
X-HE-Tag: 1763135650-996933
X-HE-Meta: U2FsdGVkX1/p4RDICYDY89+nCfspM74/S2bE4EVBqp9DcCWQ2qrK6MmrVXVOEJAIlb+yiY0sIw1pQ1D8v/ZAYrqHA3CCWaBIByivsA1M6nM06FYq6wBJssvfTwY8TAWlLb5KULDvRfcfcZIOllYTghn7eWpM5LNGv9OzVU1LVNIKvTK4Bw+CwOcXhQZjAKhKRjMIV0goB9DjPpWN8XR0j5Y+Jel4FD4aHh6xd3VdqvbZbcExRjP2IHqixXMPbN1WzVPpsuMbgagc7GqlRT21SC/eX6ytXM46zhMQzGwzcjrlX0c0z24NGR9xCjMJ8LuM+3O0peROlfQwvjxAvzhSpeMx8xFPHQBQruaA2IGDv22OzP4xxHe1B1t6CHNZxWaWCcLnxTPZvWeAfRT6cDQGDQY3FRR+IpoVBsXFt0PFzWdcNFPfX9x2xEFk4mYUs/WWe6T3Q1MihSIO/rNY8Q2OuN7FrJZRjFuJjoUfc+06o2qk8sBxAbuC9emt+oDo1kSxCNtI4YSfFO0EmaLbp8MiNFcxSBWSOkPq9A0FdFlXYBqU4Fe8SeCK3F+DKTphX/SGRTsosEnE+DxMOwMxJAPqSzb63lmBpneGY33wj3yT+zBwipt/tLfYTCoiA1Yn2zFurm669xKDoATqFCoouxrTkYPoRbu0Uk1OmRegyZWxUL4kKXSjv2uLgKqiX+NSW44lr8gaP9ELHaat2xvjMMTjIfTi+3cGuoTjTL9R8ZfxjpGWd/5ol3PiXIvMiJQKbTjOI0nW07ytR4d5VnIRybvXAsuDrh/ivZlhsbooAAuDIBp3QPJ38h+jbGnjc2Ob8r/yhnHLAW3HDvxfF/3wMA99YE/mFHXy0bhfVefBKknA/cFFU8u6t3rQherA99YbWSUblgyKtjtGyFRh95yt3qyJ+5cPh/R8Xd8NfsdEZb9vWWo7To26iUdK5v4SoVqStS3rBH9TQPhh1fVHSq4MOLK
 RmMMCZHe
 ozaCAbx3ydlFct7aSlCkYx4BM+s0JjjHriU1nDQH96faR078Fmct6hqzEOXpiYRm3vRvtRTKwGzk2I1KtsyDnzA6328bl2jqWmXBVvIt1IOp010EolG8IepGTHecAn4CHbFG/tGteM64c7v7jqsztfEv6gk9vgrwyDI/hYmw0S3pgMUJVv6CbSTAv3VlCLQO4noE79Lufe1w/fmfhYMfXsHmv7E6JBqtCu0Z1a+8M8YLtwsLG0jK65TfTnfXh079hPkDmcuC3660nEcx+Xb4CyyQ13u60jOfK4y1/NAckWA+p7SOS0miE8ZlnFjebqU1Pi2QEvdc+phMUSZw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the serialized memory map is tracked via
kho_out.preserved_mem_map and copied to the FDT during finalization.
This double tracking is redundant.

Remove preserved_mem_map from kho_out. Instead, maintain the physical
address of the head chunk directly in the preserved-memory-map FDT
property.

Introduce kho_update_memory_map() to manage this property. This function
handles:
1. Retrieving and freeing any existing serialized map (handling the
   abort/retry case).
2. Updating the FDT property with the new chunk address.

This establishes the FDT as the single source of truth for the handover
state.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 43 ++++++++++++++++++------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index aea58e5a6b49..f1c3dd1ef680 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -117,9 +117,6 @@ struct kho_out {
 	struct mutex fdts_lock;
 
 	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
-
 	struct kho_debugfs dbg;
 };
 
@@ -380,6 +377,27 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 	}
 }
 
+/*
+ *  Update memory map property, if old one is found discard it via
+ *  kho_mem_ser_free().
+ */
+static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
+{
+	void *ptr;
+	u64 phys;
+
+	ptr = fdt_getprop_w(kho_out.fdt, 0, PROP_PRESERVED_MEMORY_MAP, NULL);
+
+	/* Check and discard previous memory map */
+	memcpy(&phys, ptr, sizeof(u64));
+	if (phys)
+		kho_mem_ser_free((struct khoser_mem_chunk *)phys_to_virt(phys));
+
+	/* Update with the new value */
+	phys = first_chunk ? (u64)virt_to_phys(first_chunk) : 0;
+	memcpy(ptr, &phys, sizeof(u64));
+}
+
 static int kho_mem_serialize(struct kho_out *kho_out)
 {
 	struct khoser_mem_chunk *first_chunk = NULL;
@@ -420,7 +438,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 		}
 	}
 
-	kho_out->preserved_mem_map = first_chunk;
+	kho_update_memory_map(first_chunk);
 
 	return 0;
 
@@ -1136,8 +1154,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	kho_mem_ser_free(kho_out.preserved_mem_map);
-	kho_out.preserved_mem_map = NULL;
+	kho_update_memory_map(NULL);
 	kho_out.finalized = false;
 
 	return 0;
@@ -1147,21 +1164,15 @@ static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
-	u64 *preserved_mem_map;
+	u64 empty_mem_map = 0;
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	/**
-	 * Reserve the preserved-memory-map property in the root FDT, so
-	 * that all property definitions will precede subnodes created by
-	 * KHO callers.
-	 */
-	err |= fdt_property_placeholder(root, PROP_PRESERVED_MEMORY_MAP,
-					sizeof(*preserved_mem_map),
-					(void **)&preserved_mem_map);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
 	if (err)
 		goto err_exit;
 
@@ -1184,8 +1195,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto err_exit;
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
-
 	return 0;
 
 err_exit:
-- 
2.52.0.rc1.455.g30608eb744-goog


