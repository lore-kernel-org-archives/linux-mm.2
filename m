Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D0BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89BED801B6; Tue, 28 Oct 2025 15:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8740B80199; Tue, 28 Oct 2025 15:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0A3801B6; Tue, 28 Oct 2025 15:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63C0280199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:10:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B75959716
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:10:27 +0000 (UTC)
X-FDA: 84048464094.11.DE3A91C
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 716F9140012
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:10:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dk64gApC;
	spf=pass (imf09.hostedemail.com: domain of 3IBUBaQ4KCJ0FP779J7KG7OOBPDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3IBUBaQ4KCJ0FP779J7KG7OOBPDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761678625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dKmYj9Yio/TKjjo3MdLkJeEKLETaJdriEr5g0xrMLzs=;
	b=0oPY8xERCF4yRR4rN/+qCNGg66Qo+a6yuZ2UgA9pzciJ5f/rVhkspy18N+R9q50RHe48WE
	q0kC5xoFDR9Ws3I3LrFMcqGUpcXS4/WTsioGUvpoOEizxCFiQKGDbp20QqWEwUBjsNuHT2
	wmw6qbaCakUMnZqroQC8WDChjPnNDBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761678625; a=rsa-sha256;
	cv=none;
	b=7CRF6+NrR1fuzxfjtC2p4LIUyqHJ1WVVuix0ZlTRHuIprrb8LlzTJRZk8QnqhoC2deVDCw
	bsh9R7tzLGIARVMJYio67wyk6GeiBDpdl3zDYixw1L9ZRTSgEzrr/dRDOZ3HxqymHVVzcO
	+fVkV/WkOoYjsfq4Xeu0ep1Oa9W7ZNY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dk64gApC;
	spf=pass (imf09.hostedemail.com: domain of 3IBUBaQ4KCJ0FP779J7KG7OOBPDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3IBUBaQ4KCJ0FP779J7KG7OOBPDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b5529da7771so3748714a12.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761678624; x=1762283424; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dKmYj9Yio/TKjjo3MdLkJeEKLETaJdriEr5g0xrMLzs=;
        b=dk64gApC8ZY/t9/SPDHvC3U53nEu0kV4hWopVPZFLjHOgdcgJXt7gT0pQ1PpkQ+tIW
         ywi0NaMWwnZfhnyXuaUD2dOgKrsT9anjzlL1W5zK98KQ8qNiS205svnwbLTh5GocOsFy
         Kz9PaRBTUjhlH4YCBPZcQylHFhMiJVAJvWFvIV3rrV5+aCEM+hVAuaT9nV8FbnA+NjKs
         ik03u/o17x+8gfavP9x8WEMtWb+hnrJh/Owx5QNrjhAb5Fs+zzgfQ4+r7Lz2pavGYD1s
         lZ2Dy5pIe6D4h60iF81w5Gf9gfC+OEzBp6aJs4ZQW0N8grUnTfwJk23YaGWSv/6VaWmf
         Wkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761678624; x=1762283424;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKmYj9Yio/TKjjo3MdLkJeEKLETaJdriEr5g0xrMLzs=;
        b=SIVinVupuXUyDMPV+XR822gkGY8CC5fpjIzwoR+3DtnGJ4eYNAV3S73lQNiLcT/+2Z
         clgXGyjwAbIMC0vja2Jv3JZnN877KK3isDeXGTadQCMzt2oA90mmpkAIi8aXfvyZXEiY
         frsRaD/LyKJBeK1iSdrb4z/kbNQQUNThPhz/EfNt2ix0o73nZecI/5wCfnbYzoSnDDeH
         C4VQZpHaM5ZizUGlqS4JC2LjSCeYGbYyoNB8NK/+UgXbdG+RZgRIrkt9Zx/mpdITKc2e
         5UgQBZzLL1Wt6Ij6a9dUZUiQ2CAvJBqagOKYoWBxI8Eh5fHpbiUJmAu/j80OEr6BeF7b
         lgNg==
X-Forwarded-Encrypted: i=1; AJvYcCXhft63zfPJMvHMWcufkaKxniPTYsuE9uOQrS1aaWr5JB86hFvyhURru+Iz8Yy93wFQLIQX2cn4LQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5VF0u98kskXh1bNCWC3tqLzhcXQ2AT8WWxYxoLKwq6WX3eWsu
	660xplvtb82w0fS/i3rnklgjRGPXOQtXQAAhHs+6KrIzNXf3QpHC4X80297SvXv/ffTVTcG/ngI
	Iuj4WSPwyrC/dVFw4PIfCyWBZLZ3YvhUyeGm1fA==
X-Google-Smtp-Source: AGHT+IHoA+/xXI9fzl3kptYGRMT9ubFjslD2sGL9QPl4+LylxBFMy1zqCRVgSQOB8Ay6n1ipp3kyRxf8KTocGr4A1yANqw==
X-Received: from plrt21.prod.google.com ([2002:a17:902:b215:b0:290:28e2:ce57])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2406:b0:28e:8c3a:fb02 with SMTP id d9443c01a7336-294dee12958mr3501255ad.14.1761678624199;
 Tue, 28 Oct 2025 12:10:24 -0700 (PDT)
Date: Tue, 28 Oct 2025 12:10:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028191020.413002-1-isaacmanjarres@google.com>
Subject: [PATCH v1] mm/mm_init: Fix hash table order logging in alloc_large_system_hash()
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>, stable@vger.kernel.org, 
	kernel-team@android.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: m53unw1wjntm7nwerg54iq561t7t4miu
X-Rspam-User: 
X-Rspamd-Queue-Id: 716F9140012
X-HE-Tag: 1761678625-270056
X-HE-Meta: U2FsdGVkX19s3rmLXYFd0xZgKBg/7NQlYUpf2m/3QzlRuG3ahD9QcqcbkcMPB9fzlHEoNMmTY1VOhtuSysFAUPaUfkTwXXIMeAPorEDRdVZBQ/AzXG5XS3YH2zgdPCO9Na5NVwsTgQ748YBzglkRhEs2HRVcsTJOqURtZyhIVbzuVQVYl7xLkHXGUMVFwrcnzg3gJScV/VSq0KX583CybWwpZFfXlIBVr0V15+w8nqppUWXWpe8Mzj8CRTsJtej3cdAnTiIEqW4ENfm1kOgWt3nkfvmot75yq9REHUTb9HQE6ZjMzWpByXTiQzrjBP53RJRDVEWdwBoL/90OqU0PEY48Ah50m7ijZIalfj6/Pgyf2msljbsiJ9Lfmtw4SCwtmu+Zqjliw4gWkFnVhe2OoXF9j0Wz4jf/LPWr81yG8ea5Px8J4W4xQ9VggA8XiE5lTlFHKkbvrtNiIPOBHbDZolQ+0VZDZP+Ak5fkZmmBJZjXimCj7qUNyxQC5C7H4eZcMSiDwMJKWYGXJGn9/bS+b8KipbblgoMyx2/J5YMbcqLF8iBdIkN1oZGd/Rolo+umXiw0SvKT6VtKAaNgUA/QFXqni0TM/9ZH8pxqc/y865mSvJO+YPXCZK18c2g5Pnz/aM2beE0UGgqnkdFbIBvxVLYO8tJo9n40q1k+316IYPRMWMFFUEQjoYseetH4Wu8/o0B8/eObNUadA5CwuaCHoR3r1WTacycaVe4az70GgOJEWA9UVjGWuPIh+NuZapH5TVlaGcsg4TA/AUVQIc9K49FJV3YjYU1oCDr3PkFLlrenTL53ZxBNPfVY4+WbqCAVgN49gRvjGsQD+dMnj4fTiVNPvu/vlmwYjyyAsbhrdyiksBnFs+pUKUO29EuAloee8h7aWKWhNzQ9uGZf3mMBhbPGd9KJN4Zn22EjQNJZSnIWVwC1kBeKStyUKDnSM5XFOCnWtKEr6eLrPx50iDh
 dvcpMhBm
 c0uWhR58SjPTC/jT6MKU8ov3msWu8QABSrzYQ81dgl6mPIGmm6i3Lns1WdN1UWOwquvN9ALI52qRYTaFX7w5pC/xaUX2573CaN+lshiR1Zp9r7g+ueuYIU9LdGV/HuIBlU7XlY/ollzM2CzTvgPg8T6IhAFlFtTvsafbUTwuGcwk3ysfnl4KVbdoM2UmEkJ3LYqemPonc4Vqi2M5ErM+pnEzcfuAqKZVOg9NDaZR2ocFkUf+TW7wXZ42yLY8Y+5Qhpn/RQLvTzcHo9tMHGtW5hcL42fKNIqY/vNEVFvbwteMyJpHW9V82zZJsHhbS0FURYUtOHIt1zAZASUIZ7lNbHf62xMRHHDrwmCeseXlwD5N5Pdgt4c5nuK2fN1WeiF4DUPtExs54PoHwKn3u52hdssnQ9N1bT8n0WyCJPU9RxOtZTedrW3CtqVVB+8nRWtQcvWhjqcMPFh4WvIEzQ1gcDs66TKIjG2DNemrDtkOHTVagnt6Z8x/ZY6C3Ew6LfiQNTAoRvhivNoJOsE21SykKCRlfo9P18WbhJaIx86MWiZG2lJZxQYjdLllwuLTjhyQ/6FdubAdejsuHOcEN2p6iKQxwjNNS0GppqZNmlIAyKIvw3WBZzWfxWtVK+lym807u54xFwofZF5/M0gZMGehKEYKjsDMs03TpQh7s0f47iYSjavM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When emitting the order of the allocation for a hash table,
alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
log base 2 of the allocation size. This is not correct if the
allocation size is smaller than a page, and yields a negative value
for the order as seen below:

TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)

Use get_order() to compute the order when emitting the hash table
information to correctly handle cases where the allocation size is
smaller than a page:

TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 3db2dea7db4c..7712d887b696 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)
-- 
2.51.1.851.g4ebd6896fd-goog


