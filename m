Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27855C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9FC6B0095; Fri,  8 Aug 2025 16:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C726B0096; Fri,  8 Aug 2025 16:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832166B0099; Fri,  8 Aug 2025 16:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 692F16B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:18:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D75C1A04A0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:12 +0000 (UTC)
X-FDA: 83754702024.11.5981140
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55B1740002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BnCLr5E5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684290; a=rsa-sha256;
	cv=none;
	b=0aNhFZFx+0eUDMc+ND80M3fps/UgmPYPFIa7h6GdWB1XxFLDC9yBVqKOfskP1FFvPhsPhV
	RA62w36auoR7VVWYkzzGTaFQ2vPvyNc2h3iHv/yNBKUCgfEp8PG6IBXbShCq+nKAaXHy3S
	9NifGHj9HOO9PInzQV3XOTdP2LYOCHY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BnCLr5E5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IhL/CIlLPj6jA+N2gUQ5Qd+JhoFqSryy5qQsBgiWqg=;
	b=Ac8yW1g0rhjvJoPEkEI2sD+81rdFBvSt6CgmRUp3zCdC89z7DunZijfUp5dADkFZqysmhg
	tvEY1QlIgmfiQ/Ip9IeI9u2awl5i2rxwxLjiv+2pU1BkXfumJGy3M1MacdMdaLFDMvI+J+
	I6Y3XOVUX6nE2FQrZPGfZfx0P9WXDlQ=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b06d6cb45fso31309191cf.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684289; x=1755289089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/IhL/CIlLPj6jA+N2gUQ5Qd+JhoFqSryy5qQsBgiWqg=;
        b=BnCLr5E5nQufwLd8eoyI6zIQtFVA1AAyZXGoHTHiI1pl68emDy7i6pUh7MDdCu4M3N
         +WTeozy2KDrx/zoSK6VWnlEYKTQcZ+iZ0dvJzLfoWBr99G5ewi0/5Y9NELEioJPx7h/4
         eor6lGZm3ubySnA3+meBPHHgsQOsW2Af7m7LMXo3LJaxCTMxnjRKWbQJ/9spT9EY/DiU
         H5ftrpgOvVvU0krP+tpLlq4HFYx4xKIQ8fJmwp16sBw3iJ2upAnb9RN3jopC7GQyO7gt
         ZKGilZHojaZPQpGYGHUH5QuRrRqfiPAj89yM6QSx43PJ3y1snlgwBXOY9FMw0fv5A2fi
         x+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684289; x=1755289089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/IhL/CIlLPj6jA+N2gUQ5Qd+JhoFqSryy5qQsBgiWqg=;
        b=YBrPbpptW59caWT866zt77KQxFXiDorNPrUwBSpLsJH3oTpTnspqDxHswpaSkfumXQ
         dSuqEhd6Luw+dzkJVb1RudbSN7dFBrVC7fjaERvCo1WR9AQYv/ko0v5u43OHdjWANwSC
         sNBZmGzmf2Dm/8w+U1D4R0nkrOpRRnjszUKuHcRZxtmZJwSG67BdJATAcX7EC0faBUEj
         G1hufWTWmBqhJGngvFuK1IiCRxNo35iOSfAtB/J+SUYCMPPR6V3D5iJVc5Dtt4RzpV8c
         OCsKqtxdtP3+SST3Z+me0sEMf8bec4x6wmTaDKiSppGC4oM9Zpsiwfh66U0ViegroFmP
         cfXA==
X-Forwarded-Encrypted: i=1; AJvYcCWQi0OnHal2YpxUHgMh68ubI3zjQBKc+uvflWw1dlyhX7VDrSQDehrHpKKDDtEINbPT5zrdbr5XhA==@kvack.org
X-Gm-Message-State: AOJu0YzF05TC8QoYSSt1c74L7XKmHO/fk/+2WmkOWbcR3ExBnBzf+s4a
	3VhgK3TKMd2C74F0WjsdQzwXViPjAW0kWLinej/MRku88JCqQBzUPGs8vuvBqA0DgNk=
X-Gm-Gg: ASbGncvsLAZ4VXbYpGSlJvKh6X7O9tIFR4UTNbSdQlLcnKH7g9xFtqsua5xi0LVjtVn
	hbxmyC1bW742lNd0y0UJV0xJ+HMwC5c5iIBU8q/IXQchegCbgcRwpnBMmPVchlFo5LyEaEZyjnz
	h7GQ77FE/REMNRdIyDl7Pp/EY2WK+cgqGq3fpL2nb9QoixyMs/yolaFSD024olxSM8XCgCJp1O6
	CNiy6IVwfAI44MZXlS3fFvy0eHmO+/QjwLUthFvqQFCCJSTBm4U5mbOl8dMXUjzAAcxyO0V8pmo
	zQRJ+7IEfrlEvZQ7sOJ9PUriDxmMig1TlPORpdnJG1w1WUk4ezDe1TVfikQgpsE+DtV0I4Bds4N
	WJb3pf6wWN6WGOmoHrEroTyiO6Sk/ilI2kXh45PkcUWS56u66OcosSZEL5spGnyyKnflAft5cR5
	nPCVwoOhx8YrvT
X-Google-Smtp-Source: AGHT+IGD0W3/4r3I4y7shiD9XqPrTR2Wufmh8nPmwN+kRpU8+fKQFyJQNnxe7IT04T5XIjK11kh55A==
X-Received: by 2002:a05:622a:293:b0:4b0:74ac:db48 with SMTP id d75a77b69052e-4b0aed032eamr52138771cf.5.1754684289383;
        Fri, 08 Aug 2025 13:18:09 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b07c80ddbbsm59490131cf.57.2025.08.08.13.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:18:08 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 1/3] kho: init new_physxa->phys_bits to fix lockdep
Date: Fri,  8 Aug 2025 20:18:02 +0000
Message-ID: <20250808201804.772010-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
In-Reply-To: <20250808201804.772010-1-pasha.tatashin@soleen.com>
References: <20250808201804.772010-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55B1740002
X-Stat-Signature: eisiw3r7559orz4kxpj65dpaz7ga6ted
X-Rspam-User: 
X-HE-Tag: 1754684290-171517
X-HE-Meta: U2FsdGVkX1/oowtd6hEW4pPY4Hfk/xL1LFLkVvqJlXOmTJ05h2nWjOmsxS9/SsKC5h/+s+vOmEq+HfgesBkjm4OrHFKByFp7aqjAmo7V2gs1F25dJh+9R1eULTPYIOlhmAuUKe9mzHts8PBdSCAsWT8TZGoBR4DKsvkksAD/aU0TXow1Snjo4Ca8QtZuKMvp1TsjjkOdHFRTQ6w3hVQ2d8WsDhcreBaD/qfVVCPLasPmlP2Y9eEZME7U2AxGPCz26KatXp4/T9jX3bQPIDn2lsWYYUxI8P6VgKH8kMyhpEJayy7JcjQlkumWhdw4z6b7LtNfCULEJckrEZ3VNDMeOFyAfKX1Krye03knUrmxN7OWMKP9sirTxz1t3WmZpGuQMvlB6wzYjvY+UVLsC9+OyU02fIDRtQdiH9d8S9kAsqkweA+A3LXbNx1c3iQLDP3FBaqG8OPklDVktGgjrvzucNaF6gkhzha81SaqKZNbY1Q9GkBD2sXbeObAzMQw5ZBy4aDbUhn5RxFoFcqLlNJZSGIgIEb3sdiQHV1Nzi0kyIqdmvOXOLzUUG8HFdDdJW9WacwPIlkCvc5pm19IpN8ICHwj4N6yWFL51/+1ZmRkDBfdhY9dwCHjfDWidZuu6l272/V5rPZ5x8GrjS8wDv9t9WGpRwNMcjHJmEhermhc4EXWY7DDhzOFq2la9nyf5O8372ZuMNaSnYZHAhSo4FWYudj3SLW5z38xK9yq+DBYsktoZLgLguJ2hL3vknX9XDCdUY4BVKileaGZrnjosWCk+OnWUN0cCs3tg58zOJl/ZH8NOUhT6WvITtoE024cpasPH8cUQ4AM8r01cSOkbchaOIddkdPBGjlKhv8kSL0HvFuzdks/MSx3+rVTkIEk49jePflD/UtvXLnqDUF6nxRRu18QG65WsGGatb2wKqeSDcwdS6ztwl7yXq+blqyvQj+BH7ekKQlovn9BuAvmNj9
 5P7kzQGw
 98i765o6jUJtRh2dzase95/sCLc7osGTJcmnU6So6o0Xv3RqFnuvCHLe/LaNiuzX3u8XAEtHPpwhmIIwFM5cKqmB3T6xUF2iSoNpEg77zvc1yO3f11XKdVApVODBlBGTuICzUjCM8/ng5IPE3XOK/No2ElgErGwxGzQVhTBZNyzNqIIRSQFNSn17omVtUMvH73b0k9I5XzGZrvdgqIZRlHabPcW9LufxEwY/vG75CdrpWsrtbqtm0TfsFkbrFu5ddcaAB+ymFMGall2+7NkhjYMjX/9cR7WjwcpkDCOFDAAVBrPG4DLdSyDmGZaaBtf+rCkg0jhtowelFKg1UQKcUv5XYvNuAnLkgSJoB7O9tD8/zUO8OTX6w1D+saaCcbZ3mTakS0clPgYFUdCvJJ26FJSxEdFtpxg4PS5MZRLGdDt990txslZ1DUiBNTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lockdep shows the following warning:

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.

[<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
[<ffffffff8136012c>] assign_lock_key+0x10c/0x120
[<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
[<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
[<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
[<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
[<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
[<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff81359556>] lock_acquire+0xe6/0x280
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
[<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
[<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
[<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
[<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
[<ffffffff813ebef4>] kho_finalize+0x34/0x70

This is becase xa has its own lock, that is not initialized in
xa_load_or_alloc.

Modifiy __kho_preserve_order(), to properly call
xa_init(&new_physxa->phys_bits);

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/kexec_handover.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e49743ae52c5..65145972d6d6 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -144,14 +144,34 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 				unsigned int order)
 {
 	struct kho_mem_phys_bits *bits;
-	struct kho_mem_phys *physxa;
+	struct kho_mem_phys *physxa, *new_physxa;
 	const unsigned long pfn_high = pfn >> order;
 
 	might_sleep();
 
-	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
-	if (IS_ERR(physxa))
-		return PTR_ERR(physxa);
+	physxa = xa_load(&track->orders, order);
+	if (!physxa) {
+		int err;
+
+		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
+		if (!new_physxa)
+			return -ENOMEM;
+
+		xa_init(&new_physxa->phys_bits);
+		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
+				    GFP_KERNEL);
+
+		err = xa_err(physxa);
+		if (err || physxa) {
+			xa_destroy(&new_physxa->phys_bits);
+			kfree(new_physxa);
+
+			if (err)
+				return err;
+		} else {
+			physxa = new_physxa;
+		}
+	}
 
 	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
 				sizeof(*bits));
-- 
2.50.1.703.g449372360f-goog


