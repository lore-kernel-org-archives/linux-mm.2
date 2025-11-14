Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55359CE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A948E000D; Fri, 14 Nov 2025 14:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39848E0006; Fri, 14 Nov 2025 14:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E280D8E000D; Fri, 14 Nov 2025 14:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D14FB8E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 700201A04B5
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:11 +0000 (UTC)
X-FDA: 84110127822.23.032A3C2
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B5A24000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Fh+oj1gH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146809; a=rsa-sha256;
	cv=none;
	b=hUh0G7LkxQ1KFPZiI/Z8Uj4w04T8oyfmefKYVSFF4YraccoMfVdJZdaWvnsNahRzpFv7K7
	2D9Ou1Oq8xrnKVHwW9IhBwavI/TxFPHatmKq3teJlCO0reArcenQEZWRWYWgeGhdUT34v/
	+sVkPElEHzf44vftKWgQpjBggnBT8ZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Fh+oj1gH;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRhbySqLkOs1S7yd4SZQFQOHiDhSCvUI44/bvvGGGJM=;
	b=6fY6mHXqp9A6D+pyntl72V15a39EmxWO2dUr7bJuxsbmzZJ4so8Mabc2vUGuhbVqo/isNj
	eAHiLEz8PJWGf0574tZ6FUmX7/dDgKI+ZAeBPaeYQil7pzXDX4yXEbGREqs1iPNXiQGtY4
	lrxaMG/2tTt1g7s5ZK6n55+bLN8WvgA=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-640daf41b19so2951295d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146808; x=1763751608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MRhbySqLkOs1S7yd4SZQFQOHiDhSCvUI44/bvvGGGJM=;
        b=Fh+oj1gHPgIDUXBpxkGfDnQfPr98kKaKH8Ifk2pxJIuZpZzvd8mSXpfMT4u4l24UkP
         LMydWXnVKGHI0lW2fzPJ6LlZQShVmgIB94YcazOOId58Wbq6qMJfbiq6vQGbRpLjafZ6
         acV00hurKzQfuvwn69JaIBOzHtkGt/8Xh5mCeNa8bKluFV5GxXGk9/S0lmAJBrNuMNN8
         DGxmw1KZjsM6ZGCLbfv9xIS7lv11qV3yTmO56CSoB3dIY5iermSve6OPRDAczBLWLk9w
         ijiVbsYWDEayBnrXzyOgNmA58xTe5uWDEzDAe7jFW3D5EWzr7PU0y4V6L7jO4x9MwIKZ
         yHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146808; x=1763751608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MRhbySqLkOs1S7yd4SZQFQOHiDhSCvUI44/bvvGGGJM=;
        b=dsE5OdJiB/Ov/ZmA7YMIEcersWxlj2cjIHWpJXlF5gWAMFLzso8L0jAXRyVBUNiJ35
         EVcMCcmgt7ezcVJYMxm3ZsKZqmYXdjFQxWrMjNT/9oGbDSEywp751LV3yCi8BdJHUtPD
         Hc9WxFHrzXhv++nfZMky8kBN+VOlnoc+kn7Yhe5YjUGjz2WKhOz/jUfTB7IJaQt4aMJx
         RuKNJV73WYRppgHPKdPn4CIyJJZ6A3xy7kMiheFnW2ntFkpZunSOmjhT9ag7tnJscqa4
         IFbMVjXkdPK0AM/737nwgunPeZ0rGaQGHx7aQ+BH7h/bXhUam3C9pAvdTmRXrjmoaNL9
         t5AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH8c4cc9BIIhP9x3EGDUNzfMlIeQbesUdXE9kHoxcgLv/LPslKqs0QM0N2Qhoxbh5uMiCT4nvMJw==@kvack.org
X-Gm-Message-State: AOJu0YwobuRpOBoJ2E+9fnFt3GGrHH6OZWOfMP6+gffCqhQTW4H0Z3WM
	WA3BmFaMlTsqOZCYqLh0WUUXE8dS9Ur5yvFONN1ZeZCE0sQZd3KklQXHjpqdzsLIySQ=
X-Gm-Gg: ASbGncv+uvy+ee0qqaj/w7CVIJicdG4tRmRZItaPtYyjjyArbGhovENY+tlJEEJpMKW
	kiEjMc7PR42BWpMnI8yM6DC0i0ke2gDKlgWILE/K4VoVkT4Urg+FUaNaIOhTnONu+2MZmSDA43k
	ktA/JVfpLd5NFS8FUBVPlQrzsIpzs1KZZm+ihWcYXAj7e1Ffv4BckLszmTbPVuEbCRq8mOxtEtW
	WR232EX+ByeA1Dsyng3UpF3kky3w48CdRHIfmUepwbddlrcVA615H+idK61Lph0XmSqZeM+kT7w
	D731qdSgO1b+N4TeljStK9HCmJarU4lnYaxZkN0OwYOHRqM65lGCFemaDSb1e4V+E9iO1ULCabO
	ILguH3qdX+t6G11sSi50HYf4+4lOMLgt53dbNYF2Y0uARZWUXdgKm9EyBK5AV/3tZIE4PW6AH+W
	YaAu3LVj96B9YYKMkwpghbP6lAFpjzNVYSlVOrYhC+5QM1wIabhXhFFrAYlfIhTLQ4WCwCd2Fi4
	wgnNcY=
X-Google-Smtp-Source: AGHT+IFRipa5kdjo6USd5eBEs8ufSqG98/LGRDsWM12ipJewFI9gcyDDCxwJYHschZedkB4cInZt7g==
X-Received: by 2002:a53:d013:0:b0:63f:b61a:71fb with SMTP id 956f58d0204a3-641e6d71af4mr3935840d50.3.1763146808367;
        Fri, 14 Nov 2025 11:00:08 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:07 -0800 (PST)
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
Subject: [PATCH v2 01/13] kho: Fix misleading log message in kho_populate()
Date: Fri, 14 Nov 2025 13:59:50 -0500
Message-ID: <20251114190002.3311679-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B5A24000E
X-Stat-Signature: ep46ssgxtkz184ann568k5ddenf8ts68
X-HE-Tag: 1763146809-293268
X-HE-Meta: U2FsdGVkX1+I0jv+qAcQln0PVIGfE4fqlg36izpEi21CvJRHrMI1EuMuhk3YQxjkVyFrEbkvWrOp23tKszx1LhjoXdo0eJgcWH8+nanGnvOZwcj2U3VyrQevirgnjYdZRfkXXhAQ2EFg9rOcXmMZmf/EPuOHI1lgckwSGwu0Pz1G9oHW3VPC7rNn8YZslhHjM3f6zdJV4kQVmJuuR8uKnuU8ww3V1yqQMHn84YxuzelYRWPiKHTmO9k/BJt0Ssjc8g9hLiObCPMFigpiK5A1Wsj7WDoOM7vG+7oSGYE3cabkGC+kJaGA+Kh6sN0HbKWo8Xi07EiM5wFb5koKFSZtbicaIpFWSpZiRzxd5giHEN7E6i8OLSeZdV8lVJNKGnj5DAwNdllz6QmFul51DRChbHvK9otZaEK1Q2kOb4CoNYFpGr+hKcQx1/sPG9tdfjS7+mGEbanDkuvKx+SCxHwmFVnQpqtHbFvvPy43rvBQdi6pqs+bFG46Inc6YREBxdj2LQOU1rXOmMYcNUF0KZUjpOw9Zx31bDC4gsdQTUi5Ru0T/eB3qZt0pFXwyAP5NFYMFapATj+7MVWxx03qyPJZ13yNP0+d7zhNyewJQ5kAlIRkOuL3bInisyGMDfJ7T1igpB7rf/OxpOgdRAY6n0DE1A1Jin16ezX0885NAoAsoMqez5p9rKkSSDHgwakcVq1K3xyLkz3RAwLZ1EJ7KHki86TZjFqj0LFwLNaW4iONVbKbw3Fn3C785PJ8BMfqOYaU/BdBUfSFHmrHRg7yjJwJ/T3/KALn9Ew/FsZJg5Y+8HM8DS00Y4oajzUsNmQOu45zdQqvJWr4S+0jmAT0O7m7RCdaItNfN2H6RNvmpDPCfFrbB8TRRMJGCXy7xH9t9GpLllPL+aOEQlmGvN2yeMATVancX7XKX+MlLqxGiPt93wIAPuOAp2RxO5kgfmkQ74chGk0N5uu/xjI8bxekFM3
 5OHdRTAs
 mRfv8FTbCIuEK7SozL5RtW7FTFY352YHlolwvzmNYKcoUU3mvWROhd+I0KTKWMdFkaaEFPE9e/vvMDLSG6+Oqsu2pCFhs4r1/QzU43owAN3JAiQ06zsZVXjP0+sXyJ0C4PuS7yRlgLRp4tKV6vt+ZId2WrJrCm5ZKVrrhlQLMjSTGK94nSiZBLfpYtL88odpZ/v/KB5h/7+pERaTnivBbZIwhIH1TGPPYcKw4fWuyJpgTEPDxPEGKSgt6kjvnI3pvc0aNSqXtfndH9HRuIdIIyZV6XvIieR3pYd9GDP33RZ6MbXVplADqKefB70RCNA1PclHD+pIFAVDiyB2AenBy1vYACRZUquYxyM3dgpWek+eybtueuO9ilkjSVTndiOZUnkBYtStWlpX24S6pLBrRD/TRVPBwz9G6PJsGVoc+nbGdlzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The log message in kho_populate() currently states "Will skip init for
some devices". This implies that Kexec Handover always involves
skipping device initialization.

However, KHO is a generic mechanism used to preserve kernel memory across
reboot for various purposes, such as memfd, telemetry, or reserve_mem.
Skipping device initialization is a specific property of live update
drivers using KHO, not a property of the mechanism itself.

Remove the misleading suffix to accurately reflect the generic nature of
KHO discovery.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9f0913e101be..6ad45e12f53b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1470,7 +1470,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data. Will skip init for some devices\n");
+	pr_info("found kexec handover data.\n");
 
 out:
 	if (fdt)
-- 
2.52.0.rc1.455.g30608eb744-goog


