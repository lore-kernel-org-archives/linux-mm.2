Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6338606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EXW9HLYr
Received: by kanga.kvack.org (Postfix)
	id 849E16B0827; Tue, 27 Oct 2026 12:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 820806B0829; Tue, 27 Oct 2026 12:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8BC6B082A; Tue, 27 Oct 2026 12:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 464266B0827
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:14:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9F864035C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:14:10 +0000 (UTC)
X-FDA: 85368903060.07.AB7B03E
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C3EC10000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:14:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EXW9HLYr;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117649;
	b=s4bqTYAaN2gi97M3KkgI1ZUX+0bdVVKR9PUdygQFYO+MIpNuJcNLzlzOrbibNdeEBEutQ+
	zBKvZ1shKLrj6pncAiNQ8KFgy1INYyBfGmBLGLO/IqYN3n2JbAihZh0NKU93AHONqbyj+h
	hWbuTB8xC4+3TRklHs5osUYMmHC2nV4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EXW9HLYr;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toOq0XEZ4M3UIbIsRm37gKrEflyWkQwIZA2AGozjzx0=;
	b=RzCVqYO0n+QxZHOJSNJ64ziCg07p+FFA/9Co5jwa1R0hvJ+z9yJOD+pwpB4lGsCfs3QYrw
	PC9O4FaDdPfylNZ2aDBchOlXlMy6vY9O9qM+TRMiPFTKMbux84PryWEAihTmtGzIvS/ppy
	Ad32tdNxuPtTu6tIhik8Q/LVGwzvEvo=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e60f9af6e6so37063015ad.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117648; x=1793722448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=toOq0XEZ4M3UIbIsRm37gKrEflyWkQwIZA2AGozjzx0=;
        b=EXW9HLYrLHgQKdFr9M5mvnhPQYeYF2fx3AONSLQPCruNWaAab9wSX5UFAQqBLUir28
         fRlT4P0YlhuEYnBL6ohV0lVTs8FGRVtwRDE5/acEnNruQqo2It4CAtSLekJOUVMh7u6K
         BbUxeuDS63camlZSZq3IcOK/ayMJM6DAy6+hdOiwsCbdU1/W+Cvdb3kMchI37Cpyqpd9
         Pw6GlAPGkFfm6NDTLA8M/iE4lQ5XES71iw07XOaJSOA9/CQ/T9yfGaTSpee3m+EGabvq
         iEVSJ43UUO6RkLZF/0PIEp1arOTckHPYxUUk7sFJg3zOvGIYp9aCL8uPLy3idO+yKvXo
         R/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117648; x=1793722448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=toOq0XEZ4M3UIbIsRm37gKrEflyWkQwIZA2AGozjzx0=;
        b=DYKhC8Lb7WD/N97HrlOEpvF1JqFN+cPknLB0f2iFCI/RFO9Q399mSnoamScE+iayfd
         jJJ48hu4e0tegLOGE0ijsJPcrYfpkM9FGi8QMSKkdFPrfjqPwkOJqClsiZRVuo2sGyUU
         pV4/60dR90mcGZluXh3GHKyscikaU4wdWsEmjq4tjOLqOvb4DyeYnMD3aiaufiECrhXX
         JPDWbaudv3J94LjXnDEj9j4e+b6oK/lOaYzD7UUIBh5JW91n5BHOZ6x0fkmt6qlvmYdp
         khSarsEaODML/nRjyyJA0lGFglam1vSEtEBNSrFZ8l1KRZG6om3mnj+vCIYPpAxKll4g
         7Qkw==
X-Gm-Message-State: AFq9FYIMjgqkCfKldhJas2nnP2iD9hfDS2mMTNdUO9ug+lN1Qt/xvrp+
	3ZuoEwEQkS77JuN2k6Hq0sUDDpdil+cIpDhMHqFBHmum4YQFPjnkpOdprSB7pA==
X-Gm-Gg: AYBFou0t9WtLN39HSG8DfshDuGCiyUfm09yqax15tUcRYI1Q2UqT3IY1BKRD60I0d31
	BJuIoxwLioIKt2NS2Tk/4VaqZWmDD/CUxOEB9CXq1pccfZW1UqnusA/3acT+Osvjyf3o4lw9pCp
	W4ZZ/DaRzgTeO7NemqEOooaXcyACzGcrixA34XXsRNP4A9kJxzOnoBIld4h3Tiia4XRIK/lMCFi
	ObXMe5VuRKO2P+6SavG1/Py8Gc5o3roFb1O0v5UC6D0XG5ZIkkTk8gXKO4IzkT0XYggeIvHJFjP
	ldakwXkGgd29RluFuKEFTwXJaxN/Wd5VlomUTnsvqtd7pnO252Te9gFHb43Nqmgt9rUzM3YMEgG
	9k4KqRXK9sycUusx7diK6MPL4okPSWSBJ7Q6uWmuLDDmhBM0ozWf+bSymYOQnyb3rfNzdjz92E7
	MFhZnFs15XxRw2F3ebz2OOcbE6ky0mrOMObu/Bcz2M1fiZsxDvXOf7EI2ZSulTFwi4lGzCjG1eZ
	nZ2/2J+ll1qPUb8Egip5/bJIvXWe8bAmLnkvM0PytNJTaYRe+weRL1lW+2Jyw6iCpxkkVioiwhd
	LjpJL92Wrspn+5tn6ck=
X-Received: by 2002:a17:903:2389:b0:2e9:6788:9379 with SMTP id d9443c01a7336-2ea9c821072mr82928135ad.32.1793117647793;
        Tue, 27 Oct 2026 09:14:07 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6455a00sm12395875ad.2.2026.10.27.09.13.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:14:07 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 17/18] mm/swap: skip reader rotation for single-device priority rings
Date: Wed, 28 Oct 2026 00:13:30 +0800
Message-ID: <a2183392a7222d0a6070639a0a45ca86e2d922ae.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C3EC10000E
X-Stat-Signature: bq1dfwy1rek5uwtdibamje71hwmx9bjp
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793117648-909097
X-HE-Meta: U2FsdGVkX1/2sqbcVrWrRI7CUBqFmAI7TXPM9i4Y4UjWPYI4bKobcF1xcIg7eWBP89K2NKQSXSVQJBBJTrHskz7uipB/mtGWL5s1XK4987T/ZWU3NUy1qUHkqaesE0l6vVQo+NoZw7bF5Y/Fg+wiklv/NDy2zkzpc3XQQZuRfWMjrVori5h93Q6ts5Jau66Utd2MQ2BOAwW6MSkyFq5FlZZYI1FvqojK5LgBOZ7Ag/yXnsx0V3IXY6EnXOh7p9o9R1Wu/SUmcsrk6tFzcZ+T9AcMTVjdn4dVQ3+XD7Az1xTFVBq580iLR0zfv8Ft4j51XF2Pq1blD7bJ60LOJ2UjkA++Mv1TDq2fZfFPnXUJMHaW91e9q772ZkftSCg+PlM9WJeL5iNVjSgEj+Lc6Tn3gwOomZZuFI+jFglD4pHNdexYQ3ecawts6PPli+9tBIn1nc8IffERArffy1PTEKqJ3Lu+v08ZWssFZSf+ApoyEsGbsTbJvWcdbPcoDokGrEcd0y9lno237kpNHHYiblgK1EvU05KDOlG9++Y7xUp8IuOfpxI22VXmdva+8BU9wvBGcPZhMrikxh507amjyOEva0OoNMs8XBK0009jnLLO3jw82LyAcQNZ0Ep4a5FnzS0laYoWRrNZEw0+wxkWSATQv+x0tPBK+SxKHQ4csBu9vn6G827slG/+XCEiyRdADtH3PdHM2x26dXbtKJUXnB7j1i55krqgoveE4SaN0z3KZtLk/pyyfGZqssoXxutIY+13VK0/IAfeOkZF+uVBODRTGIJo+jCpZiW/NFKfTITuD30U0Giss68a370ZdGUt2asXU6DLrLPsIG4L98b43rQgCH7UeqVvP3Z4AKUcyQxo0tqSgBu3nXheyO/U/cQnvkmRlMrNSqJhVJHr43ZZfF2NTjmgKf5UlYgMQn3hsmfv5JLWHqZM3xpn2YWPKmlzjdsGq4o5QkDdcT5YiKawLKI
 zNhqbze0
 mANrMwu2qCnV5IVz0BGR461zHvByVC0OMQrehNNQz2sYwPEd6W3bwXhuMT0OXElWNCBcWwRQwt/YbU132iChT1aQ1aLGb6UM+Jq96BGVvui3zG1MCC3phREzQIA4UTngLwek4PaTZ3tpHnbq+iOomjWSivLPu3bJ8f5QwYqo0UzSJiNYL0HBWarp/Ox+BIOr3L7KNrTbndLLitdnI+Q2uUf0KZbfXU44maZXjFTCDb59jr/VNigFeT1V4u6qV5o6VLwlfViaDaKsxe7jfpxpm9gd9HAJMOWTs6JL3ci3CXAy8Dm+FhMorDSEZPCBGt9h+2iCFjpo+ZI/9QdzjomPh9FE90qWrnWgLalK2h3SQE2Yy69ILNHqtfdQg8lOCKKLf724hrr9uRA+SBY6NBP8YHj5VbfQmWqWHx9qluF4aQKreMtNhiuso9l50DluDYVLRbQqASh5NtYmauVGJJed1QWUaezS/kZR0gnbM+T/QqCg9a9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A priority ring with one device cannot benefit from rotating its starting
offset or maintaining a quota. Read its only entry directly while the
caller continues to hold the topology read lock and migration protection.

Consume the cursor attempt and check the full/disabled pointer tag through
the common path. A masked singleton therefore terminates or falls through
with the same bounded behavior as a multi-device ring. Keep the existing
large-folio same-priority failure boundary.

This removes reader-local state updates for the common single-device case
without bypassing device lifetime or availability checks.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index bbd114f043ab..9e90f815f99c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -333,6 +333,11 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 
 	/* Consume masked peers too, so every walk remains bounded. */
 	nr_iter = cursor->nr_iter++;
+	if (ring->size == 1) {
+		si = READ_ONCE(ring->dev[0]);
+		goto check_device;
+	}
+
 	local_lock(&swap_queue_readers->lock);
 	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
 	/*
@@ -362,6 +367,7 @@ swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 	si = READ_ONCE(ring->dev[dev_idx]);
 	local_unlock(&swap_queue_readers->lock);
 
+check_device:
 	if (swap_device_masked(si))
 		return ERR_PTR(-EBUSY);
 

