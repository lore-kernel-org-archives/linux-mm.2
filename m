Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFE1CCFA05
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB808E00B3; Sat,  1 Nov 2025 10:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2E4A8E008A; Sat,  1 Nov 2025 10:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF71D8E00B3; Sat,  1 Nov 2025 10:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1D768E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B2E8140827
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:46 +0000 (UTC)
X-FDA: 84062256852.08.CDEA3EA
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 886E6C0003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QdFF6QG9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007024; a=rsa-sha256;
	cv=none;
	b=pSUwV8FWeCzBZRsM8cxpmCn3bilD6ZiYRSQxifgWcCUzOa5f/Dw1x1+d5H88IIuXzvy2lU
	S4WKzjaDWW8k6g1vd3NhLcjTdfJkFRKUFLQN+iS9vCtApHRLhLcM8fhBzjhOehvm0uYHdx
	ei7Hwg2hZN6f9qxHeRHOdA5FxSVDJl4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QdFF6QG9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3sZsODYdE+lXQW6sSfXvI4QX3oinLZLnJVK+OowB7E=;
	b=JA8LSlqHjW19G6mhjgjdjFRGBIy02L0irTcK/OB+QDUsCcLQxKPYwUsVmJeU//IpCrYfDq
	/sUgSNWmy/bcP7XDLBZuxyCCZJ4FiMw1roa6rGJDHaLoUZkaYqV8BIHW2ivrkPwimvAp4m
	IUblrO+xKEKBY9HszoC/RrLYySlIjhU=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5d967b67003so4059681137.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007023; x=1762611823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/3sZsODYdE+lXQW6sSfXvI4QX3oinLZLnJVK+OowB7E=;
        b=QdFF6QG9sPbQPPNql6+cCq8xTlU4qDu2Y0KIr2YMgzWRkA0/+c6/0EwIoEl4HnqAbG
         ivxoZeSFk8RNwkzmBM0lvMzpN/DfF7K2W9n0fDcZ5hfL0MUwuA0k25l1WRKEFzWtUXl1
         ofI4cszasRMyrO3+MQq10g1PV7Dq35X78r5NWGdXkaWJaFcZa+j62+u8Uito1n4RfBGT
         roCxpSvbct+rwzYAc8cifu7jqMs4ZzRuLolDrLpeZpidQ/Q+T04WNa1fv9DQy12rEmwh
         p1HN0szD656UouTaJAIAD2as0ShdRuaIO3Pr9Zv9kv59AUfWl9jK5JsYxO9rjqd5dndc
         6q4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007023; x=1762611823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3sZsODYdE+lXQW6sSfXvI4QX3oinLZLnJVK+OowB7E=;
        b=D8N3t94UE1dDXLoTIjn34a+CoF17kBZrCBY7ubJCy6KWzdCUSFNydWFf3wR+ndxPwD
         W5WU1TTLQIKDuZF/oq0tocTkJsKtZfXVQ/F/PJEin88hxomTB0efVBUheOmABu++y8LZ
         0Pl6kJQ4WOZ09xaiH4IB931nRKWXNmAMS6dvWF1RZzOmGb7nb2o7ha6897UpeUMK0SJp
         xtE6VDvqNCJ87TwfziE5EZD9srYPhyKXnhSH0E51PfeJA5c92ImyG7p48XG9na7UmG+B
         LHO6PWidflU39nOnJn+iBHgCtZDLOL6+U5vKi1XFCWLrIiTIVM635PQddk+203TjaCMX
         neKA==
X-Forwarded-Encrypted: i=1; AJvYcCUopYFqL8QmANg8oSUv+bOA+aGlijgtEyenJ5wQR6szCqfVIizeymjjcjYsbsd8i1CiQ0jOlLLt/g==@kvack.org
X-Gm-Message-State: AOJu0YxC5S58Rr7fyGwn97iTH4SS5djJPsNTb58I+TI1YiLi1jTxYYcc
	yRCh7ox7jKNao8LYL4FyIWjeWBU3XyCDCtkInCsrhH6yvoXJ4zWPC0iqqVw+0rgMvN4=
X-Gm-Gg: ASbGncsFLrPsa4Qr4iqINHOPHuRebnmFGRN8LNRpiKEHImW91qMTs2oeP788k5Nk65+
	Se20+b4xBMDpLfrrZLDR+u9rLwm1oHbFMERVPxP0pmQe9DfGQ2XTSYCAg5vODdMZm1ntu+/l24g
	rroHWPLlH8y49cFS9t1GDUkzgI4juQrF3JdMQdHs0EZugjjfH0OlqwjPFY50dFEhOrdZZlOVi5B
	QPj0DFTCCj74WpxzQtdG2li/T0MR80fJ2zpdPCcIPhwKH56owCg2mqrVIIBrm2fm5r5NkKBNcZC
	A5iINpq4GhjHV/mB2djzmBnE9xs+oQV78KW/OotbD2tCeWYkYi3KO+EZTqHhsVwR3p2dRCjH3gT
	3P3r233ZEQ4sCh//d8cWych3A22TWEIiPNbxlaUzzn4zi5IVELs9p1aTOpFyha0YIIoZ1+qX+cy
	MCBjSpxBOnwLrpKUMZY5a3OqjxsxFZVmlXCwIMm7u4M68QB2Foq5q5Na9+AJCmRHuY7jRb8b0=
X-Google-Smtp-Source: AGHT+IEW1fTK12XGUTtqXJsef8/76poVKTgBxu4YxD9HHtSEN7ne/NH+yy5cGEPUcuJdr6fOnT+fYw==
X-Received: by 2002:a05:6102:8349:20b0:59f:4f48:4e31 with SMTP id ada2fe7eead31-5dbb11f91c3mr1950860137.1.1762007023601;
        Sat, 01 Nov 2025 07:23:43 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:42 -0700 (PDT)
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
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 6/9] kho: don't unpreserve memory during abort
Date: Sat,  1 Nov 2025 10:23:22 -0400
Message-ID: <20251101142325.1326536-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 886E6C0003
X-Stat-Signature: sbp75ks6xohxmk9nnfcdprba8zwww9zm
X-HE-Tag: 1762007024-823702
X-HE-Meta: U2FsdGVkX18hEtuBFI68QrnkHgqAOxzxCM0Rk3TQpKf2sOtVHZIlVnfguZWJU26+SyrD/CMbz+L55nhpeJKAGgi295ktuq3sx8e98cCbgRSFb8X59sfNjJ2JlPXh7KvfHm+0wND7Nc0IbrK3IF/baNrEnmyEg9MPBU+gZbIVxJJ7DjOIrjjc3QW/9PRy0sm8b4oIXWeRTxb7OnmAILNwlAd53o57QiDdOLQhYrlO47uYXscZRhSTj0AuX2ANI0M73rThFoVpYd0rrdhwawt+mtfeoWKc9aSZ+EPmtZfGMBeEyGW49ZVXBFUGHQL7wF2Ufa8ky38+Xoe4C6n54PSiQgFh4jlZnClYUfyGyveyfw/s85VrlzZoP9VN0CfLkJxTwNeOONYz0n1ctkraPOpuYuYuCN1YO2ULsB5z0yKzg58st4US8qB91uqvSg56cOFizmjA/5fvk65smMBY4KHz5LZ4FYArv+vlGXnHyE5ly2MRo1bObgIM7IqR4hby/9hLia4hvYcsGNEyOpMA/rLnLuJJqVsZ82wKeN/9YcEOfmvwqMuQK5ifWDv37DyJLp77OK9zLgA/LNWnxZxp8q4vk1o5tt08NROppz3o4drTLYo8rvtmEB465jUyqCRGx/7kbgSXq9nbvuFwUo+yfwJ7TfN+6GFIRqQQ1BePfUCT/kFt6tWB9JLJ5BJSUqGDxKxEyNZNb8huOQNPiYAJY3+9yfBaeofhiMKkW37VwcvvSqDnP7MPql424xM7GVbnb3MZx5G8bRxSUNWWA0CyP3J9hX7V2gN0UQoM8aMKaxw6k4DEIIyo3FaEDTy/8pEiZs9HnadO1hLOLnaftg5Bz032Skd/o+nIFlh4DfgtiDmDdlP63kzL2se7ZiTPKWnG0eXIitQwScLdQxZbGu0n9NrzeQ0Y6I9wFwB8JSoJfUv8zOqLT8V/mRfRMtGT3T6q0N6XnLcTn+W2qBnBJziIdBx
 MNGpvpM4
 CQwqbqrrCGiiwz+JEHT3v+y/xrUJ2IeC2KHeHoiNp4NXLKyU0PnnTmuDv9Vmm/cY+fzUdjb8y7xBTQy/CQ/9SMB5I68Gd5XFF0suIPCUy7SsT0x63iPkbU3VYYFE8KSkAIJFqORhVnzhD6bHRWXWAapjx9QiUl/wCd7GsXxcWcuwzQvONXPLDY2CWv9UKOqmWOavY8HAtUNFvp/w+o5KG3Y632KJEFgxAGnLwfKDm1KRfk5QNM2VhDClNSWuhLC8nnIpKrdMw5ny9DcU3E9Qk2bdyDdG+ioGMKr/p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO allows clients to preserve memory regions at any point before the
KHO state is finalized. The finalization process itself involves KHO
performing its own actions, such as serializing the overall
preserved memory map.

If this finalization process is aborted, the current implementation
destroys KHO's internal memory tracking structures
(`kho_out.ser.track.orders`). This behavior effectively unpreserves
all memory from KHO's perspective, regardless of whether those
preservations were made by clients before the finalization attempt
or by KHO itself during finalization.

This premature unpreservation is incorrect. An abort of the
finalization process should only undo actions taken by KHO as part of
that specific finalization attempt. Individual memory regions
preserved by clients prior to finalization should remain preserved,
as their lifecycle is managed by the clients themselves. These
clients might still need to call kho_unpreserve_folio() or
kho_unpreserve_phys() based on their own logic, even after a KHO
finalization attempt is aborted.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index c514b300ebe6..3adf86c7c2db 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -1118,31 +1118,12 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err = 0;
-	unsigned long order;
-	struct kho_mem_phys *physxa;
-
-	xa_for_each(&kho_out.track.orders, order, physxa) {
-		struct kho_mem_phys_bits *bits;
-		unsigned long phys;
-
-		xa_for_each(&physxa->phys_bits, phys, bits)
-			kfree(bits);
-
-		xa_destroy(&physxa->phys_bits);
-		kfree(physxa);
-	}
-	xa_destroy(&kho_out.track.orders);
-
 	if (kho_out.preserved_mem_map) {
 		kho_mem_ser_free(kho_out.preserved_mem_map);
 		kho_out.preserved_mem_map = NULL;
 	}
 
-	if (err)
-		pr_err("Failed to abort KHO finalization: %d\n", err);
-
-	return err;
+	return 0;
 }
 
 int kho_abort(void)
-- 
2.51.1.930.gacf6e81ea2-goog


