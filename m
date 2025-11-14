Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46159CE8D4C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEE88E0022; Fri, 14 Nov 2025 10:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687C78E000E; Fri, 14 Nov 2025 10:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4528E0022; Fri, 14 Nov 2025 10:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324568E000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C444588BB8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:09 +0000 (UTC)
X-FDA: 84109659018.16.FF643BF
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id F26F2180009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E0ijEuJb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135648; a=rsa-sha256;
	cv=none;
	b=BSD58zRvqPIw/lRXiLNlIoRZNyrUwDJp1nQ04PLbgMOwCPbTGwXLKcdApBCyK8vVBSHMXm
	Nd9c6AcQG5bzvOVu6xfaG04Lzr6TixHRZlYk8DsIa2cadsuz3VwCZhK3zgxhxQqtc1EcvT
	1HilTk8xUcNpKpcYaAkklWNH5VVJkKo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=E0ijEuJb;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhKTIQNEYkcaFtj/KVfNXsYw1sfQy1wKIwy75vaOKnA=;
	b=MvOeVYj/GwdOIq2UqCf54/A0T5k+t0SALdtPn//Z8hOBgIAa0/Q73EUod8Z1FsVhNMuQ7b
	uoJ0YM248npE5rOELzUG7EPbxgbUWDtjTk3t3eCcuMs+ZrrV0069R1P3aEqZ/k9qTNcQcV
	TqQyxPaYs+W1lqXBlqXDJwE/62qnCl8=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-63e393c49f1so1782866d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135647; x=1763740447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mhKTIQNEYkcaFtj/KVfNXsYw1sfQy1wKIwy75vaOKnA=;
        b=E0ijEuJbw3nX148ACMF7GkObeczIYhV/Tf10a67BFa9lI6oDzqVuMr7Lix/M8cNNKf
         JxFK5gQio+edMW1yAhss267+41GmIrsute1d/xbl4mdS6KbAV7KSaQhTPG8kcZBKOv4O
         ZC/9E51mmHv4jnSSIDFwHtJHgVf5fwQ5qbdmzHFrnL8UDTlZ21rsz4geHMFca6Y8p0tV
         lj8ioqdutd2sIqdZf0bguKqkPQLlp+EbywgMqzAXdmJr4QsZ2wS+05Shher2SSTB17EQ
         mbU97CI3j6ZAq+yFB0tte5NWc3+LdAw3h26OBsh9DtEAjr6IHvgzWRSWRmRZlX02xfyW
         NmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135647; x=1763740447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mhKTIQNEYkcaFtj/KVfNXsYw1sfQy1wKIwy75vaOKnA=;
        b=KhjORhjFr4bu96yXD2Q7n/jtcYJ0vEiIlajmygp3ouQ8QkHDi1rJwq5nzdYTCBcif1
         Pmbq0L/Hf/JLLpAomebxnnM7/I5+PRbfRHiNZJ83qc8BRJcLFneSKBKu68xStY45H94F
         biWW5FWmVuHxVEh/nK1vj7u+/6MYKXEjEYrkoMycqsVSS9jDbHrO4TZqHe1cE/qxHU0A
         m6PeqNXmTfaKrGRlFQFXob/GmAwLZe9ud3Yt1BcO/Jt3Qx8GiRZhnRnp3lLZSWDL978W
         8pgC0KF8y4Vrb72ZXVZ2BWWjLiPA1QqTtNMdWYik4K+6C4yFTET+V2lAI97Z5M02To7T
         ljlA==
X-Forwarded-Encrypted: i=1; AJvYcCU2PbADXV5EHFo/tanb1qY8NDVox7QQ+HZlglXfTVyvx3PLuQdwzfALnBRmZqKBr17VEu363rzqwg==@kvack.org
X-Gm-Message-State: AOJu0YxDRAlxX1b3Vv0EO1PcBdaSX8y9oymhyVHm11DTPtmZILYi8qyL
	pmN6zcRfLuQL/z1c8zUFMo++5hvqheTBTdI1+qHt6/yt9MQlg77aXbGmDxDvCOKdL0g=
X-Gm-Gg: ASbGncsmrkmJZYs9FLdap9u4cUZwmnN+XjjHNeqJ6XwzLf1BZ0qEvDE+tSNrb7kuG6R
	N1Ew9E5Za2bAGPO54sdQAzP4cwNicmMU3OTFg63a9omO2KAQQ5XT54vuytIJzCkY/E9KB6rn6BV
	Nnc7ILeFOn4zWwgLvsCjZnkF3LKoCZMXE/TMK2ZVtn27SnS2XmIAB8QHs9a1V02hUKFc9R+el8O
	t4EC6tDJZcCfYW3S/M6444KVlNJvtgaP1uPzobGYL9iUlbx+p0ywk6p3NcA3WrksTWnUyDn7PvR
	Q4qQcOH0bYq8GsROZ/YClrHev+9kRWTRl23itq1Uxeq+1GCtwf/K2fVEUBYsMQnisndbMD0qezB
	JW9SUdcQ/sBzxE+YmLBN2ejTv8eZKSuy6o+wRDROEfRa2mkGCk/Bn41ntR/c0aDhU5aGyNXjxDC
	PrXDoNVDxgWXXuUbX1NlWuF61isapoM/1rGytclTPldeSZRXh/jXJXG+sbfmLY49J43GiyCr4CI
	ksra+o=
X-Google-Smtp-Source: AGHT+IEJQtu/Dz82I0FeERgoL2lysnBiw3v4C+//1rJhBKK/+KWOlrhz3FcpRzXmN9PhDx5QWGdAiA==
X-Received: by 2002:a05:690e:259a:b0:63f:aa5b:bce1 with SMTP id 956f58d0204a3-641e760a530mr2430273d50.39.1763135646933;
        Fri, 14 Nov 2025 07:54:06 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:06 -0800 (PST)
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
Subject: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT alignment access
Date: Fri, 14 Nov 2025 10:53:49 -0500
Message-ID: <20251114155358.2884014-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F26F2180009
X-Stat-Signature: 1kok61mm76wx4ks4bb5p18g99o5kqmtb
X-HE-Tag: 1763135647-892042
X-HE-Meta: U2FsdGVkX192HR+aXMEZIGxu/TkkIMF3vC/K8jA1taFOdELmx2V4hYdWGstJ8PYk4OOAQlpVX7/tMQQDuFulWuXgYME5qbbkrPdQU8UJZ641LWbpYrI1Gis5ub0M7pDAgklkWSkSCzdx8pQJ+r6w8cwWRqs5mi1J99cQHNP/CzRjFqIcK2fDupTWX7xTgUU3y2sqjZgnFnJbyLgX1DvPo7hJbA3qmi0qpt2naC5LsI3WMeNzOw2SjdgPvxZWYZ/IcR6RURHS0PndAMEL+Qy0bKFCjzQxEAXFGBYbYSnsok3nSo4CqUIXQlKGb990QCqWv9cg4V2N7TsVL0dYYY8JlfNKdFiRWSXQ9yCWQ6lLBNhLZe8ZvXCxDMike2DB2MHfHmtT/TqwBFfnASVE/212tH3FPxJUvotEOqfNB/snWRRsxKVFyKHvuy1MXhnbzsPCkBxRmh882Z2qVULeRjlWv589Lb9UwsDy/zdBo+YGhokWWGUxLKP5byWLTevgxEy087ZW6GBQeDuGCoHn2qRXPHEbXgUW4CXVc/ynMJqLIyszXsOS63VB+9DsqM/c5XNMxjFonLQcZ3KnUex7AINxEUuSQ+uPAeo1GOcLJpOXdqEnZOPsIjv1Lc9nDQ8q1tSZdsIeR0AeMXcNl6tsP3EszcwsB9XjqViBJVRQe3OjcolGRxtYViZEJLjgDP1EVdvLbqjgwblGyzIqrl93RDisVE/u95IEIkQMQNQgwrLZsxYFI5P2GZZfC7eVWh/4TxwKBU9aVoIBjf/pFb988sXc+JY2pRJjLCfkbKccL4ihxaVm39j9/uHYlEqalQxxnbMEW4ZfYAB+G1n/xNGacLqTObEw307ZwykLsEck0do+XIBJTQfwgbn8iOGpABF/xFmhNXnDSVffmP7vUSb4v7xduj40W5lNB7yjRdP2k+YJIZhdS4E7fywm5tJHAg1WJ4VH7ZmtDF00s5boXFWoMGw
 zRd4Va+3
 6lTOW3ObBOvWszdkmf8BNuJppIkwCb7AlD+LE3/NxnOX7bsXLbuR3Zs0DVbR3B+YiEXPusuTi2VjA5iP20cME3AjYquIZa6B+XTXDv9wI8I2bAdDjJ/QPu9qV0uOWJr7f6jc9pZL8C5a/v2XnkPcF6Gxq6bfdiBHYufORV+FD42WXuaZUpYZtwj7EN7ofEXahwfhVww4KHmEZG80+sNz2OFJFjYwF3Xp7Ss8LAFwa2pSs4WFFcpHUuG66UEiRoL6kVh1Sk6DC/rGfEvTppAl5bT/uuiVa7ynzPNXnYVaZnycKWv915WJHrJyS2ESNIoObsI9PLnoMavwDE0KT/nYwaOjVkMjMl6mDbRHF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot, kho_restore_folio() relies on the memory map having been
successfully deserialized. If deserialization fails or no map is present,
attempting to restore the FDT folio is unsafe.

Update kho_mem_deserialize() to return a boolean indicating success. Use
this return value in kho_memory_init() to disable KHO if deserialization
fails. Also, the incoming FDT folio is never used, there is no reason to
restore it.

Additionally, use memcpy() to retrieve the memory map pointer from the FDT.
FDT properties are not guaranteed to be naturally aligned, and accessing
a 64-bit value via a pointer that is only 32-bit aligned can cause faults.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 32 ++++++++++++++++++------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a4b33ca79246..83aca3b4af15 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -450,20 +450,28 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-static void __init kho_mem_deserialize(const void *fdt)
+/* Return true if memory was deserizlied */
+static bool __init kho_mem_deserialize(const void *fdt)
 {
 	struct khoser_mem_chunk *chunk;
-	const phys_addr_t *mem;
+	const void *mem_ptr;
+	u64 mem;
 	int len;
 
-	mem = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
-
-	if (!mem || len != sizeof(*mem)) {
+	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
+	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return;
+		return false;
 	}
+	/* FDT guarantees 32-bit alignment, have to use memcpy */
+	memcpy(&mem, mem_ptr, len);
+
+	chunk = mem ? phys_to_virt(mem) : NULL;
+
+	/* No preserved physical pages were passed, no deserialization */
+	if (!chunk)
+		return false;
 
-	chunk = *mem ? phys_to_virt(*mem) : NULL;
 	while (chunk) {
 		unsigned int i;
 
@@ -472,6 +480,8 @@ static void __init kho_mem_deserialize(const void *fdt)
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
+
+	return true;
 }
 
 /*
@@ -1377,16 +1387,12 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	struct folio *folio;
-
 	if (kho_in.scratch_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
 
-		kho_mem_deserialize(kho_get_fdt());
-		folio = kho_restore_folio(kho_in.fdt_phys);
-		if (!folio)
-			pr_warn("failed to restore folio for KHO fdt\n");
+		if (!kho_mem_deserialize(kho_get_fdt()))
+			kho_in.fdt_phys = 0;
 	} else {
 		kho_reserve_scratch();
 	}
-- 
2.52.0.rc1.455.g30608eb744-goog


