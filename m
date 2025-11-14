Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C44ACE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B85D8E0019; Fri, 14 Nov 2025 14:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC138E0006; Fri, 14 Nov 2025 14:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093C78E0019; Fri, 14 Nov 2025 14:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E88388E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87FBE891B6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:17 +0000 (UTC)
X-FDA: 84110128074.20.480CEB7
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id B176B40011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BstD+cYs;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKXqn4UCsx5taExigGhwZ/uQl6fonqpp/y9tU9NzApw=;
	b=5QShcCMV28LwELR1DSoVsn6hgGvjoYKVUJSJtalAYp2XxGAxHToqbPYwFktU9sJJ4Zyb61
	6AXOX3MGIiifQ6qS2iZ9QVn0TS8+K/D6YUkzoYbXZQ8bSwn51fTUqdAm/0ehjyJKQK8oUr
	vF8glfT9XBLyrUsMSy/dcwAFJVLQUd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146815; a=rsa-sha256;
	cv=none;
	b=jm49Bv+Bg9Gwl/sQvRV45IypVpgaqzeiERpnRdri0CKK26AHoEtBRrS6yI1GEOt8d2R2A3
	CHtSNl+eJlpu1XvWNS2t9UddtUTBH5kl1kj0LdE4MdhUU90MUMsms1LF4Pv7bX1qjZ6hKb
	K76irNuFHkZYUWxih+xcQKQ9eRTaOk0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BstD+cYs;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-640f88b873bso2108027d50.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146815; x=1763751615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKXqn4UCsx5taExigGhwZ/uQl6fonqpp/y9tU9NzApw=;
        b=BstD+cYsIgV+6MmXa4z0ACdrlJT89zJAzOoodBlyiMJqVwAzwb4HUVhkQNQydPKJac
         MEYzApgQpcaMZzXmr9EVhg47V25gjBR183VGrzOlUdy1fNcIFPhlE54rTZfu7Q2FQMDe
         fMF4zcR2UFq8rQSyvTN5wsabKK2NVuqI+iXUiMXB9loDyd8QWSFBrFgXlEbHo/ug+JwH
         nBoZWooYOwl6oT3Hx8JeIoGWOjy3LJAZE5y0UPq9uWBURdafPPDJZc+vm4po5RmRMIDJ
         mJXqqo88McmwrNbeS3brJSng/S+ocNC5dkYchvgxcMMmLIp/1rVVa2aXUSDasog+0dhB
         w7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146815; x=1763751615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sKXqn4UCsx5taExigGhwZ/uQl6fonqpp/y9tU9NzApw=;
        b=WrhGbUO0P8kOnhxTSpAz0uXzzBXmHmKat7kCR5PHOmvGnzjnUtjlw9o3JeKBzkqb46
         x/kr+42+7cAWBKeboFs6yk/kuGJguz25Ho4h7G5iIvuN2fYKFpZzm0wZKkZ66jOITQfW
         yqfnUdzIQ8l9XWn8CjJIvteJWszSWCy0dLw1+E95q1A9YUaLIIMCtul0t2dnP0coLuNF
         /JJCrS91jzQsy1TJ8ZcAp3wipTuRloqKrZrTrLmN8GLzmz9OCSOA1+RXDYBDpoV+eea4
         8/W78ZLuqi9cFdZoU/wUNPyqcl9BEIB3S7Nmpky/V2f3h6nPkbIZJrmvd5GUO+TvGXw+
         rB3g==
X-Forwarded-Encrypted: i=1; AJvYcCWyUP1lJp29hxWwL3g2g3j3XOdwJlH+WUH355WfDdDiMcHb3fhpHuaJMeQf37EC58/lvU9K13mORw==@kvack.org
X-Gm-Message-State: AOJu0YzZQkK17PzswwkZ3zXfxSM9l85liWogNeSCyH4fZShbdyVwH6oK
	kq5/WrSLghz3c538D8PFKGPIikVK9hYl2UPYmiMaTe3IKC8okeXCMt/4nVB3+mGhTHM=
X-Gm-Gg: ASbGncsG/nMxPQJUct5Bv8Fe6u2+3co3Ruzx0IrjmBxf3yB2oo5IksUtjiiBIXRFM00
	RE6FaUc6F4BjQsy/6oN117HnWDAgyK+8XSrNp+v4+01oSrZ/DzbpikfzbMDzrOe6RT+IT0te94r
	XX71ykUFxgIKIxAh3fp4Jn8c83Sa8qOUlqNfVZh7L9402Q2iN60o6MbR7n+OJbHRtuvwPSGuLVN
	DHAv+w5iU307d2fb1c7HPvnSYeP1sQJQJkGwrn1h+dbjBg1tLs9e4+GMnC58Uia5QoATxPe9q9l
	q7qN130bX7Sw4v6BDYpGTW1ZwpYsv+1Uda01MXPmUgynqJuB+Wjv09sgN9PKLN65HlWe6LHbjpu
	0ARjmcETWOD4fk8tlWLgR2sweiLJ4eQPmF486ezUuidrzbmyac3BMeFOB9FHUuiljShc2FQDR/1
	1DU+zAsqRrmWCmFTChaFiF3VlBZxe49qAyw+68SAuP8s/CPRz2sGtYxt8sEgBUdZn065qo
X-Google-Smtp-Source: AGHT+IGombylFpcjG2djxoO/obQ9YcdXjb9GnKr8tqI/Af7HjHJJG+neoAQar3y1uITvPYzUr69PHg==
X-Received: by 2002:a05:690e:15d7:b0:641:718:8a08 with SMTP id 956f58d0204a3-641e76834camr2719966d50.52.1763146814781;
        Fri, 14 Nov 2025 11:00:14 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:14 -0800 (PST)
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
Subject: [PATCH v2 07/13] kho: Simplify serialization and remove __kho_abort
Date: Fri, 14 Nov 2025 13:59:56 -0500
Message-ID: <20251114190002.3311679-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wg4uo6d8wxs8w5maqdeachguzxp58uou
X-Rspam-User: 
X-Rspamd-Queue-Id: B176B40011
X-Rspamd-Server: rspam01
X-HE-Tag: 1763146815-741153
X-HE-Meta: U2FsdGVkX1/w4Jbny/WQn+5t9DHicz4/4rBkDA/oeTawNqSPRmjpyEcWDYD+k84T2SOvTQFwGE7jbLE9a7ZpCMya5nhpIoTJ9y/6F7S4nIY4PS7f0k2x1Fhfq8Lri1R7sz1Na+GoV+1umO+kifSfZOh6pzmC9T10JtyKAuzBOmXtFBGhELCqCj6YCc8O65AkdQ/EtcRA+FTtH5S64T+P+Sq+6gcDeWRxLM3ukv4oF7wSgB69KXJpA/XopDXcIq+DMokVE7cG5B+J6x7Wsi1wyQONVjfdCKNeAAsC/TO8buaJLJwHvXHFJq1S8v/Z5MNZl9E8dwRA4mqXWXOe/rxAuo3jzI8GRpnLZDZBzGS4FP3dBGGaoTA2kelzt1+cgBPtnVcFJkuoKrJZRt0axUUi85DoZC8aXKK5FeCopEze8nC9XxnHXzZFXeQ5hWjWTiC9Wc/UoBoYuf+nPPZRK9/RLhDetgNhS7+pbxBWlwBQMxIaS2fP/DKtwa4C5glz/+sZJ3yetsQEJuOP6cGGuAAiXLYVVKTOD5rpq3arBjspJzZtkkI+h+pvLOUPw62hSojrGpxn7Y7zR57PGmIjSopK8u9dlY10Lypy4+6kuidutEpMKoYt2vs4SM/i5FY24KJneJbSh0fsJvNOcSn3rYBJZQVHo9f7HgEqztbUSY6cd+AG/jTifPAGUm7ExUJoODtH8mAn3e0DIv/ZRczEUg84LnzCFiUYUTpYUws2hCMPEDHXoGXMIFyLaNRLO7H91ihFkUArCYsHcc57p6d6fwQ5AmeUpJs9c+mMZ1uk82yFa8o1oXt411rQ+pWbbJVw67BgAXyEmV1GSF8b59pe8G5LxkWaCnd+v8EhbHxmCLdH68dcUlhhNhldM63qi6mgyKWO8nVO+Va5fOvSbZfS+6EmReLdf03aYPxrNOdKLYiXy3eyi9g1VtqCSNEG8RepOndqQhPoLywa70Vr5qT8RXD
 eRhUTiAg
 S4LqC27yF7YbDgk3iM1zbHrImCxkJbMwSZgppUbVCcFDwDTjbE11x12Aoko4c1+lKT4scqthhPloaYuZVLaIK6bBGEqKuDWT+9WB/noGCLLlNM5oUjJXc3ywI5Hl0zB+45aNOefreJ5JbHh4KQqzuWpxVUnjmXQq8BSOQD6gu4BIiMXQDBo5lu9XL+9njh6QRxkbpZR6v9MV6rcfV/pYB3sBYIBQ2F6FCgH1B974kzKqiZLoDWnpMaiEIRHKVfIsEmSRTOxJlKfCrs4Ugjt+4+ZVLDTYEdx0u8V+uGy0KjOVQiYRuNvDrGw2xWKrYy+OU6R00XQq+DcF/ZLgn6oX4A1SLWp6VagrXqJC3D+NvUdQWW7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, __kho_finalize() performs memory serialization in the middle
of FDT construction. If FDT construction fails later, the function must
manually clean up the serialized memory via __kho_abort().

Refactor __kho_finalize() to perform kho_mem_serialize() only after the
FDT has been successfully constructed and finished. This reordering has
two benefits:
1. It avoids expensive serialization work if FDT generation fails.
2. It removes the need for cleanup in the FDT error path.

As a result, the internal helper __kho_abort() is no longer needed for
internal error handling. Inline its remaining logic (cleanup of the
preserved memory map) directly into kho_abort() and remove the helper.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 41 +++++++++++++-----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3e32c61a64b1..297136054f75 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1214,14 +1214,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-static void __kho_abort(void)
-{
-	if (kho_out.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.preserved_mem_map);
-		kho_out.preserved_mem_map = NULL;
-	}
-}
-
 int kho_abort(void)
 {
 	if (!kho_enable)
@@ -1231,7 +1223,8 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	__kho_abort();
+	kho_mem_ser_free(kho_out.preserved_mem_map);
+	kho_out.preserved_mem_map = NULL;
 	kho_out.finalized = false;
 
 	return 0;
@@ -1239,12 +1232,12 @@ int kho_abort(void)
 
 static int __kho_finalize(void)
 {
-	int err = 0;
-	u64 *preserved_mem_map;
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
+	u64 *preserved_mem_map;
+	int err;
 
-	err |= fdt_create(root, PAGE_SIZE);
+	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
@@ -1257,13 +1250,7 @@ static int __kho_finalize(void)
 					sizeof(*preserved_mem_map),
 					(void **)&preserved_mem_map);
 	if (err)
-		goto abort;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto abort;
-
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+		goto err_exit;
 
 	mutex_lock(&kho_out.fdts_lock);
 	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
@@ -1277,13 +1264,19 @@ static int __kho_finalize(void)
 
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
+	if (err)
+		goto err_exit;
 
-abort:
-	if (err) {
-		pr_err("Failed to convert KHO state tree: %d\n", err);
-		__kho_abort();
-	}
+	err = kho_mem_serialize(&kho_out);
+	if (err)
+		goto err_exit;
+
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+
+	return 0;
 
+err_exit:
+	pr_err("Failed to convert KHO state tree: %d\n", err);
 	return err;
 }
 
-- 
2.52.0.rc1.455.g30608eb744-goog


