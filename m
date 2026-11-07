Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FE1606A330
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oKVdnlDk
Received: by kanga.kvack.org (Postfix)
	id 0D8A96B05C0; Sat,  7 Nov 2026 08:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0A86B05C1; Sat,  7 Nov 2026 08:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08B36B05C2; Sat,  7 Nov 2026 08:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BED096B05C0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:51:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EA99A031E
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:51:09 +0000 (UTC)
X-FDA: 85408459458.11.D4B094F
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6CD8720008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:51:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oKVdnlDk;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794059467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baZEbrhbhDEpq9QKIXgzBR/d0LlM+jrSsgwjy5hT7Ro=;
	b=PIttoHt0aAASbmDDdnMFOsXU+SF7iKS39OawgLnRx802INgonOXyHUOvFQ9ajjdEpgJJX3
	SMon8ikzHDAcgysz5bSCSuA4h+KR+gTlqdBulyNhfdpwfnKcTYpPMyteBPfwZ8HmVH07+A
	/T2RlqG1hYWVuVy8kGP+Qm5N+WgiF9g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794059467;
	b=1JBl0Lk/c02Wh1hOs4TADZyeHQgIvU5C6KiyO6ZLIGyDnJpQFwyFT6S9nJ6uMHWMiWhVH1
	esFHFS0dM0E0iekZOTWRUDPrt3Vu3A9upNbJYMWKaMFqADGlPRxT8u5erGxPDY1mTpPVEa
	FHULD0cEddrpk9YvS/LP4UZBuizK7+E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oKVdnlDk;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36cad25b8b0so2552101eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 05:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794059466; x=1794664266; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=baZEbrhbhDEpq9QKIXgzBR/d0LlM+jrSsgwjy5hT7Ro=;
        b=oKVdnlDkt3wRtn9gHk7uOUKi2P88+YKNwqsnk7kCL9JgPpXe7upItEewcg7nVTFGFr
         27/i3n980+gOda5um7kcXc23iJWVp5y6Xi+XRJphOjk/TjAzQf5NNGdG2bFXxCe+Sjrj
         A2mnFjfsAhIlB/c3gk24IYHW3ZIPgxaG7jD2wdKfhbgd/bqKh3M7kbFmm27FR2DAOaqP
         F8ZW+T3K/5KxL2ReiiiGGxs6FNZ7S2GLNo6VwNUK8B3eBzhA1TzPK4QNRbB0/fhUX9tZ
         krly8JanUXb6UOScXkAFrr4lVZqqDbV5A93tFHVSm4dUOV/3oBGg84TBZsNO3TXhPalf
         AV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794059466; x=1794664266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=baZEbrhbhDEpq9QKIXgzBR/d0LlM+jrSsgwjy5hT7Ro=;
        b=hyJgK8eNDIogILNvmraqI2gP0iKeV///+8CVLKsepl7NEzUZXT4qdduBkNaXQ0cymc
         fAo08/mUS/aRZj+rYALVbgWPZzZxgw+Jus9zwUW8NpsbQIYMFJX3/8XFM0ttZH5Iv64q
         02A6HDgtBhvSehc5BlW4aH8jBfbRYJvwytc616vaylOXgjWO6kPXwvGIv1wOdQZwdCpd
         hlqSZ1LxjemSf9NL+C8JTzhN2UCnoJXw1ME5Wrs3UqJjOrvlITHUtq0N/dV/dFQ0IrfU
         wkQU7zszjQ5hQkFnvm2kxFRd56JwKRf1GWwyHSvDbb9uNeyEqJb4nmmNKNfS3NNHL0zk
         QFTw==
X-Forwarded-Encrypted: i=1; AL+hErF5r1J93nsBv2yyLqfmWF3z/R4SQTK4Z4tRUw/uFq5HtjgA6WFWuZ1zsOgpv0WauoWWrVSkK5jMZg==@kvack.org
X-Gm-Message-State: APuU4Z+OU06O+6cIgJRUbPVPK0BgF22fnfHCVDohM8UTlxsMH+ik/lAn
	DKku8GBlXtnsCnc1OuTqgqPt5kh+UpHuCZu1PgMGF4b7JoEFxkdnxdiQ
X-Gm-Gg: AYBFou03HjpDGE7z8lGyqVLwpb3TetNUQ4O3OJ0LJB1gMQMSwdor0tC5IDpsTA8yrTq
	+aanVqNjbSm0iYMhDUsOxobideR1kkV0mORpcVbWTUHZisPXINJZBm61P+5lSqjco2De0iQ+oYO
	t/P1P4kc5eToXVS6QLaEBJalSzNgmpMtV/1AXYX7J9rnec2r9j/v+ZuLG2HAd1GZyftB4SDbnQ2
	kDP4z8IpiVaOfIPrZ4PhXY9tvRwmbeI/9bOMDPPjv62y1cokCuQOSw1n6mIWVbqfml2XbSuWMU+
	ffhDseEsPP74+8/XDTgOYBO1LcuEVkMc+jESxhVTaQ7eCQ0IN/6zLwUQjXWALu27b0dzx0Ap3eK
	0WeZ5NouE3uPlPT2pt0ricyGPLcOiEtM+k9hcytaIBbUAs9u1ONGHZ7UGaOEavnsVErtFDhgvH1
	E5OfqUv2QRS+zSGsEVqY0I4FbXXCrdgbU1XFyuIlp9ViE3908fhnN/f05W8WLkYTA9DZpo7p2bu
	//x4Jm8l9XjrchHpX5SbOsxfJyskElmCwkkHk+1WrGeISQIpHW0fFlVr7wFFfOTzlv8Sj8RrJqC
	QUmKtg2IibgBmXhva3AjepKrvPuOLyC2G5OzwV3+/+0C8ej/fxCBmgmdcw==
X-Received: by 2002:a05:7301:6486:b0:36e:97b4:1071 with SMTP id 5a478bee46e88-36f75b1f828mr7447409eec.14.1794059466185;
        Sat, 07 Nov 2026 05:51:06 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922c6c7sm21280820eec.10.2026.11.07.05.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 05:51:05 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	urezki@gmail.com,
	linux-mm@kvack.org
Cc: baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	rppt@kernel.org,
	leo.yan@arm.com,
	xueyuan.chen21@gmail.com,
	chleroy@kernel.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ajd@linux.ibm.com,
	jiangwen6@xiaomi.com,
	jiangwenxiaomi@gmail.com,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v12 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Sat,  7 Nov 2026 21:49:53 +0800
Message-Id: <20261107134953.748622-11-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oq8c75z5ccfkgkb7k3fynskrowrhjjci
X-Rspamd-Queue-Id: 6CD8720008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794059467-968831
X-HE-Meta: U2FsdGVkX1+M0nw8lP5z8aokzMFrbZZhO0amTTfS7HZkwKgpVCTuYjF9SsPXSZYXV8n9TGOJyZRj/C3rFj+UR1m9VSQ1W3wztDN+q81X9JuUbjvLC5a97tHcX37aNxdfAPYoVNRAPyDPqKgfb+xTxRvBc7uqSx7SMruDUEO3BN1NhnMC00KVgxJupU1JzPP0VeULfYcFkU55U0HHIOcAfL/3Z5zDbrETrj79zG5wSLZFjf3vWSWuFOCIpeVM0UFBGUQ6PZuJpchW3WsOAjAv+kwbtsBy15c9ZqZBQRWbMBL72eATAdHt/x+9r67CaZQwwHceUDrwFH7NW02ebHwhf8eulAFYixKJBYPHV95c+B2HJCSgEwqqNkW9rGp2DooCu3pQMF8LUoYVsp3jYb/uayU7pemMfOjt1RH8PLpycPd9PzNmuFYamb8nN/P8no6BhyOPMyorzJJ/OC67h0k+iInfc9Q7FF1k+Z/Gcew948+ea08CX7DDMjrONSn8rkNRlXuvS+q5/fGq1ZnYimo9+0wIma191Mb+25tQ7JVDkeImSSSm8Yrxoghn2c/2/pPx+dST6b/12ppQklDtUMM8m3jcOHTggkiZc5a3yfxcqtRZkcKIrRp7FmUiJFUxV91BuDlLIi4MTmUKBzZOXeRBK/1onieSKbz8mY42hrul6d9lzGvj/M7D2cGvQa4JCsIm8x9tekkhIeWeDfuIgXvDUwKom4g8M5zh507g3Jad0ZzR+OdkpHJX9ib0ma9AluQw2QlD5bqz1ok/ktGQvI4ywLT4kn3OISZbU257eo67NUKgLgXnoEcoApNwE/sWPCB7CD2lEAXo2KEJ/yDSnHvAxusTVF3MtdwirrGKC9xUJiZ35Sgkg+ERi0slQhbiFDpL0EuVR8nZTBY3wwyy89DokQh/KDI6192RDxBE18aCQlnFN2J1g7mNJkK4iiRk3AWby74/59PFdXgNnqBv2tc
 an1Hahdf
 WDNjZ0NxpHQLs4kPgeENVbz4Mcjv+x+pCPhyLg2dcW6fQX2Da/ObAsFk9EcmQ0tWMOIOvx2XtCY85cw3+iJzUq38O8I8ISUHm7L8Obj/yH/ze7lvYbm+TMt3xBcyJ+T+MtV3iyJDuDVpYNjZlXZ5mpX4Su+svP3ioC6ByEPCgSdD84kTFtV9Hfu2cMwkjtI4UTKgokxZ5KR/xmG2HLh553GOdR7Ef1COFlaDumQzciSLCgtC+lIwH+77UGvGwdO+53cn9ZbmN56phUAMpYvTf0AfKMgEg96+lRCjZNOJ9V5mju4eLouW/7ReifOhAHj1kAfKGqNtSiR01Br2X50JVWhxRMWd5aRKhUkh6ySv8oXde9hhOoGy4jHfh77XTmYAG+LN2N/7beD9qQgSTcA1H0Ua/Vg3i8IqnWvGIZFhKGzbbzxaYxifAwh4NHlydjbeAEmfDU6+eWdomUm1YrIk1wekiXg3ZgfCnRTFVEdc2T2yXLNdVB02O09BeQcajexFp5t3D6JFPE+/cPt6dY9E2NqTHmR95X7QcQYy1YPKa0cX1NqUG6eEdk5lIJdEcj8ijl8SLf4tm2IGIPtOXuoFuUTUVq30IHiQ6y+yBKabJIYGdBzV2igejSIyuQDAsdkcLMPxStBYjlCcV648=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries. We do not expect any significant overhead for
this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5b898da0826ad..6a150b11261a3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3365,6 +3365,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
@@ -3696,6 +3704,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, pgprot_t prot, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3734,8 +3766,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags | VM_UNINITIALIZED,
-				  __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags | VM_UNINITIALIZED, prot,
+					__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


