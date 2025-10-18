Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B113CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857D38E0011; Sat, 18 Oct 2025 13:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7948B8E0002; Sat, 18 Oct 2025 13:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7F18E0011; Sat, 18 Oct 2025 13:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4205E8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE77CC018E
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:11 +0000 (UTC)
X-FDA: 84011893182.24.86543DC
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id F35BB140005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Pa/A3vL2";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+4s/LMKH18C3S9kWxUuCFP/sSm2GXOGXRSXRIxgHJg=;
	b=fTfWNfjJdYS6DaFpu239QqBJvcgk5ArjRkXjFfuuiyqlq4yK8SxiLq7IlFQ04Ej5/HAcL1
	Acd5yYEKTgnNldGmdHYz9UQBpmp+5Sz+5Vgd1gtZR6qvWcmxLee9uxKK8FtiYxXkQxNfpq
	Q9ZOTIWzwSFxfA9bugsO6TE1Ccebqis=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Pa/A3vL2";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807890; a=rsa-sha256;
	cv=none;
	b=N5WHiMdKvAcseY4/POOpU0Agd1JAmu96XvHieWKyqj92TRA7aN6eiqLXLOYpo7WPwzkpKg
	1Ap2dqeEFDvc3oXrt4U8kXeMcbRSi89cO946vmOJNHPLgGnD1Sc9lSx/9se726qkLZnWqz
	KcxssZfQSe2RXUzdMaKs3TA8Xfn8ZPA=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7946137e7a2so52664676d6.0
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807889; x=1761412689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9+4s/LMKH18C3S9kWxUuCFP/sSm2GXOGXRSXRIxgHJg=;
        b=Pa/A3vL2cRBtwCMSOEyXPreqH3xxhNAqsDJWxTXbh6r1hxnPCnWZn8rd6yDgttXqQp
         kGpq0UmYgfUh5CechlzfOPewxZvWARO/rtZBWds2M6OjlLTybLCHAq8Al8U2fqPwMicX
         XV8341igwMgvFopQeWvRs71IEEaXjutuTyCEoZ3uTeBka9S2fboNQI9P4zzRIoOxmGg4
         b6cD/BESDsBZJPkxW0rEM3+nR4GJoZ5UyTJWwDZrZA0+x3snkyLIJC23/trNrlDLydZ7
         wRM2hIsukCaqQ3aR2UPVLMqZPOmbzFDrroZ1UVz6r9MH44ucJVPnVD/PuSHqDGh0JzOh
         pixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807889; x=1761412689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+4s/LMKH18C3S9kWxUuCFP/sSm2GXOGXRSXRIxgHJg=;
        b=B7FkvyrjuZbv5fa2oE1Df1EBUtoX7cCQ/aXw3m7IfLufq/IgRO1EkqS+ApgInZu7Z/
         yuYpa6vlD4qwLM21ER/DChpxKgV7hbSuCWTw7L5u83PfDo71uOwCW31evrYCmERiRoxO
         N4XonhyDSXRhKYinYM6E0245hw1WoAw6Z9lvmS6dL/1gYfW1ofLUmFfaNEsK5UJVuyPx
         Eu2TeFz/uJaqeezhP+sooPjFYvgmccT+mZDF/umnck+zCLlBKvPw/cwn6TF1xY5xPEtX
         Zdmf0l+0CiFfc9BF+9OPc/AjVp9DbZrk/D07qkiRACGbpyZ52iaMdRmfV8qh/qAM+FQX
         Br2g==
X-Forwarded-Encrypted: i=1; AJvYcCV2Pd5cDOt0YburWBF2P1BjxsrIpGXQAsJfj/SfmWuoHaxnaQ4aCAvqstCA5hLjuQvPNj/xKfVz1w==@kvack.org
X-Gm-Message-State: AOJu0Yw2FicNfLCBalruBbtMBYYo2PkdDUtKUxvykKu+hhdvYzVTlkvO
	4ri37w37DvyFPBbujZBstqjer4cFQ34EFib64JW9/ynbVtUr7p9Qc3Pwk9g24OSVMkI=
X-Gm-Gg: ASbGncuNZyTVsS8W6gP98TClL34cyv03UMtj44017vDiw5gNUMxlf0Y1dIx1441eC7a
	Bn7ZjSoQrf1STaLwOizTHiFaFueID9yXXlqWd7h8eigWuJ9h33ucRbhqzezLhxCuTZuVixEuz9x
	aR8gbZSFRNphmjOw8IWnVZ7QPA12tCqJIKjzQFDJ1wpALngC9r76/PQRejX1xqvyvlMIClLl5IW
	KnsX6Tf47r1Pwzv+1wj3feGCY3S4UzYDMEEKM2ofWM3pr8nispPH58HvLpEDRqDtYOfb2aApPF8
	Ze9QF0/z0YNUT76Y7llWHiw+owgcZlLiZ/29SmzYFMP953brmKMVKik5NEr17K0uJhrnbaz8fqC
	/tFsYB5ECCTS+ywCYSlzjXP9Xd3bwbBeG10InvWyv8QlkeDbfiunsFa5Lk7VvHopvUG8nvpmr6U
	PZjvBmzZRNOR7mfaCmaKs25rREvi/eBlPGKuy2qIzwL1ONwPLQx4kRFlh8U+eHGJmXQ9K6Iwygy
	/C2nEAOu8oxK7d87YJ17ZIbs5NeESwHSoRrnZ9Jjuc=
X-Google-Smtp-Source: AGHT+IGwicpZ/o0IuY1PRlF5+Xwpp0Zedm9EU1jTpFbIRqEFcd5qCkFHdNzCn7aZrNCsS7eWlfmhaw==
X-Received: by 2002:ad4:5b85:0:b0:7ea:1156:def3 with SMTP id 6a1803df08f44-87c205b103cmr120184846d6.28.1760807889222;
        Sat, 18 Oct 2025 10:18:09 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:08 -0700 (PDT)
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
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 09/10] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
Date: Sat, 18 Oct 2025 13:17:55 -0400
Message-ID: <20251018171756.1724191-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F35BB140005
X-Rspamd-Server: rspam03
X-Stat-Signature: e4o4rk1j6jxy6d76xunn76xqmubneant
X-HE-Tag: 1760807889-408798
X-HE-Meta: U2FsdGVkX1+a6ZSdBvUj2DNomTVskXYxKJQOAVQWxanaSYKD/6sHXldktheHa3uQJxB7ra2uXY6463MLYvtC5oo+XCRs9DH07XkBEKGjgxDWsuLqjvaHqjvDON9ZkPTprgGb/wqiefbZOU4b+dK9IfZhHbdefPdaEJot6hcLBqgsgN1myXVhN6JvE1ejuguS7DDNW1vNvTi3D06qo/gW9aPt9K3j9hmqXxiRoll6cFUpP8Omc4dPH6kPbGSgU2FNxqAkZmj8IGXZHg4oYVy/RaTVybA2rPpYUkrfXtb5Z/I7olRJt9EX0TD0bvGAZicUuD36Qu+DtscXSLeh17i632yKIDwBA84HEs2Q3BUZ0bALdYcUGU/NR2eWChvljwgWuyXwKLHAMbNDjtyxQAj4adFrqZ0jbjKH62+6VIkhK9qnzVovvIsWLLUqF6zdj9VnqkLcGxuk6/oGShB6kSsmEFNEVhwQ0Q1Pjjp4StAD0bVhpQG8QfkAysqlWFc8/1SVdPrlvGJEYkae+yu+HvD4NsSE8XpL4aHrkYnDfpx6T9AneO+ONuT57cziO+/7odK7i5klfSwGCywDaks9b3tvBamZIrjgzppcqUYZS1Cq74lCdWAJD+5mnIGQ6PaplsChKRzutMLmxYw7NMGFefXT1PNyalwIK/vfj/XOMnyKkvLZJbs11a0p0P0TW0+OICwN0CJ6LxNbwo/NDiTBGTja9jENL0kCvq2yKA/2hwLS5sTf4xyhRevQr1oZaukQPcsC3uraKwYR3xrnl1zgpE4ohOmFzbFl0FjzktIzfvMD6g8yp+EEIWAss+GjaPtuY5GotYFgMuAW+hMMPr93+MF5kzuIio98CAlIs7Mhe73khDo3qWQQCBVJL2uuOfjJO0oXFExVKvKo+vdUy2oDOrei+iNkj8W2lDe90MwvhYKZwzMPKDRBKXrUdkJ098XDSNp5KhFQaa/IqjElxDmvd1e
 A6zUBh5g
 9MBoM6WPhv8jamwqw0HkI1W2JYb1leDtHSDQrA9qPTfFjRGY934lUbaGFZjHnhnog+gVMsq817kic6dN0jCKsoNefUwXICIrJqUumGrLsl4VTdDqbTdD2570pipxJ4eGx+Sz4t4ceodtXtPPxF9ZZoooVYWUC1tc1BgR6s4lGxZTeKPssh/dqUYtl+GbYJF0hgpEqpMhYzSC8qqnnLFmznYwYAq+2NLGiHpCTZcrsrFWdBXOprVTXQtEWkT3o8ubCUjtYWPRrOrTejMLqm0uc/huYntkRD+c3wfgTRq6OXPX0LZqzTyo57bJ3VhRdXWBZYdaSUrkepmUywWKIIZvLCblfRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Metadata is preserved via 512-bytes, which requires using slabs. Slabs
are not safe to be used with KHO because of kfence, and because partial
slabs may lead leaks to the next kernel. Change the size to be
PAGE_SIZE.

While this change could potentially increase metadata overhead on
systems with sparsely preserved memory, this is being mitigated by
ongoing work to reduce sparseness during preservation via 1G guest
pages. Furthermore, this change aligns with future work on a stateless
KHO, which will also use page-sized bitmaps for its radix tree metadata.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ebfc31814d16..7c8e89a6b953 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -67,10 +67,10 @@ early_param("kho", kho_parse_enable);
  * Keep track of memory that is to be preserved across KHO.
  *
  * The serializing side uses two levels of xarrays to manage chunks of per-order
- * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
- * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
- * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
- * 512K of bitmap memory will be needed for order 0.
+ * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
+ * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
+ * allocations each bitmap will cover 128M of address space. Thus, for 16G of
+ * memory at most 512K of bitmap memory will be needed for order 0.
  *
  * This approach is fully incremental, as the serialization progresses folios
  * can continue be aggregated to the tracker. The final step, immediately prior
@@ -78,12 +78,14 @@ early_param("kho", kho_parse_enable);
  * successor kernel to parse.
  */
 
-#define PRESERVE_BITS (512 * 8)
+#define PRESERVE_BITS (PAGE_SIZE * 8)
 
 struct kho_mem_phys_bits {
 	DECLARE_BITMAP(preserve, PRESERVE_BITS);
 };
 
+static_assert(sizeof(struct kho_mem_phys_bits) == PAGE_SIZE);
+
 struct kho_mem_phys {
 	/*
 	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
@@ -130,19 +132,19 @@ static struct kho_out kho_out = {
 	.finalized = false,
 };
 
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
+static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 {
 	void *res = xa_load(xa, index);
 
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
+	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
 		return ERR_PTR(-EINVAL);
 
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
@@ -222,8 +224,7 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 		}
 	}
 
-	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
-				sizeof(*bits));
+	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
 	if (IS_ERR(bits))
 		return PTR_ERR(bits);
 
-- 
2.51.0.915.g61a8936c21-goog


