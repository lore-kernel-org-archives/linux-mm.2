Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CABEE98DEE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1056B0099; Mon, 23 Feb 2026 02:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84E66B009B; Mon, 23 Feb 2026 02:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B324A6B009D; Mon, 23 Feb 2026 02:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5AF6B0099
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59E185B7B7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:05 +0000 (UTC)
X-FDA: 84474834570.25.60F44D9
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3CB5C0011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dkgLe35L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3HvybaQsKCNk57F9MG9TOIBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3HvybaQsKCNk57F9MG9TOIBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830303; a=rsa-sha256;
	cv=none;
	b=2RQn/0oxd7BUt7gOSQIjS6MvITUeWYy4UDv+7RlZfVOlsZx2QTTd7qYPSigWvmMbPPsSDW
	yS9W3HvjwUBrpxQ8p9eIEBzbDGatufbgteFhopoDMz+LT4oEqps/AZoLOcmwHjRNpUbI++
	vTeqrGQa64K96Vt1UaYg6CiVAto/NmY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dkgLe35L;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3HvybaQsKCNk57F9MG9TOIBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3HvybaQsKCNk57F9MG9TOIBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hvlyYma5WxiXq2U7NpPf+2thlXYSRdGBqdcHHPoogA=;
	b=wHcv1iKTaerm+d8UZuVSYyOq7KR0qvsaqcpkb2F81uDl9Tt4bdGueQZnUpy2h3TuJBTODN
	vmwCPpdein0wxPE+fx2pG97mUT8cwlDDkithjpmElPtb2fUe32vYYqPFj8VG8q87b4sPzI
	VRmETDNLfaFlAsOBTHi/z6VQbq8K9ek=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82442b44d94so1634569b3a.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830302; x=1772435102; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6hvlyYma5WxiXq2U7NpPf+2thlXYSRdGBqdcHHPoogA=;
        b=dkgLe35Lw4zJB45rWO3HBJxITs99OP1PWGpr4/H6dnQ8PxkaKz8wpm5rhQHjKYTWqI
         9XHzzdvoDwl8OviJ19hO8oax4ouMzVAEEaejZlM87aqBuwWTe5hBmH9lCcsCyXD1uJDr
         YcNovdfCtYH9TdX+y2WAXb2jMDNBOXwP9eAWQU3RM8qGk3CadXPzFJbJm1eBPlbNrhaf
         2g0xSSwHYUXMLNrDJmkbMB4+p+Kf8Xpge1mbUWVcFOS2sbL6enPgEzM8t2SMRjs29xAN
         mCFp3lOY9SmR099PhV9SMpd6f3hcWKG2IPhxbnjfg6i2U39gjqjkxbwP9uRqaxNrLX3y
         k6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830302; x=1772435102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hvlyYma5WxiXq2U7NpPf+2thlXYSRdGBqdcHHPoogA=;
        b=U+VnvNQraYay5C3UAImVCom27D+sr8YQnF0J1NX2EcsbyIamQm0bv77yo82Il+e4Nx
         h1sBqay4gsyssbI/jXaGuAzZ1T6dbKrWEQ2ZJ2VePT8xBG3LteXsXwbWuUpgCezlKKJn
         97ZTwi6pUisIALWOHoVSzVdBoB2t5C3rKgK4dCyeB3MgNqW9DqEaJsdnrzNolzjZZhCp
         7RyyJvT7asuqK+4u4f2/H0M8+HqM1SJPUUhABU9EpMY6PCyPxn3oSvhDyWi1QvFyIf0h
         tJGCOLbeSP7+QGOCnKO5EJEQl6Yrw2D24SXw8YyKc6TrlSbTGFsYIvzGeqN68vKZU9hY
         cxsw==
X-Gm-Message-State: AOJu0YywubZ00vjLK/sQucqbMjFPI6Td8gdOCe3eb2B7x/oJdbprw7n9
	lpZqImyKqd3U2ci5LrT76fO9wV+nGb11Tn8fNFQmxGCaMuCsf1fKL6QvKlr2RkifPAMjgEkCJOF
	Df/tvMzsLOvnI5dWuhf1Puzq/CHYmGF4ChMtjklWam6vJGyvVm/1JT8i25aUWQaPdUyGqW7TcnM
	L5Nr9ajzO6R4HhRXDmDR/1HiV3oSG0+stl439BdnBUTEQwOSmFs42hAZZAog==
X-Received: from pfbgi1.prod.google.com ([2002:a05:6a00:63c1:b0:824:ad09:9204])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1489:b0:81f:4e60:1c6f with SMTP id d2e1a72fcca58-826daab9ee2mr5973915b3a.64.1771830302254;
 Sun, 22 Feb 2026 23:05:02 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:41 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <0f1f7f4643157eb9612e368961fd05fbcc474935.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 08/10] KVM: guest_memfd: Track amount of memory
 allocated on inode
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A3CB5C0011
X-Stat-Signature: juze9a33rb8impyj859dc4gphtteprfy
X-HE-Tag: 1771830303-888536
X-HE-Meta: U2FsdGVkX19lLik4m7nt81JEmG6yGqWWuG/2Y8zBfjan8NTS8rKD7afjb5gnMjwJFvIVoU7mGlFxyQtTTTm+RTAs+p3k9/MNnfN/wGqQUDE0DtQm0qCNy6rtaXYm6uP8Y35GiDjk8d/LIRtMNRRGsWiNmtfnIK2pPCAfbsZK/hYwz+AWeYpbw/a2/0/tzmyle5l/BzbizbjCnWFoA0rxgWBz5GbXhnAteRlZU59twfJfJjVUops1IOxXPRbMIZqoDPAdq3Ck7V37Vx86I8KbeLQEFPycACED8o+A2V2iTm5+pcV7erynlklCEqcOHOXdfrYBq4/GPg8H9gyVuwQiFfcbIPzy4P+cG1aw2vYOMRBDjgfHhMr5dNY89IU4Ye7Y1TCjco27UTmI0s9L+MFz8EYegnFVvArfva2WRScvgJSjw/m7SsdydLwtRqENdb8lGLRNo3UL7uKVyXv6ycTFIk84Oz6oxiWJ71pYjXGO3FXMFqUWz6NCuqFSQKrZqi0r3RalP3D+vVP0Ja4IXmMMwvFmyQKP+yTKM5EFOS+Q4DiUNWBK647jmsUkfMGsAateGuC1yMdCUAiJt78m3oCDK3OSh9mFrg48MgZjkzVgNBCffauCU5g+HYCGlqe+xCBhLdwlLPSjkcM3RWgdhCwj/ThgJvLF74BF+5moXX73xG9mefIvj9zqV2uID0qFHDLXLaFddfrLZhxdDrPJm/8lthhcYOpEYfR7XcMQalMSwFTTF/S4Q8q3eglrfQcpAdOgxe45RXuqJuzp/TM8DQ1bWiyj8YfzrkIPPQo0K1SDiiuXfb8+aymG9oDiqOEHMYrkrKLiD56X+M9I3etLaHbk+STtxRUskiUny+M7MEqFgoQFKkVH+jOjMo/Ge9kBny9otcc7ne3vFtHgynBAVwWGyluLC6mqW7up+IJRgY8lGD4Bn7QFYLgosjmEpBJMUqmsmZNkup02+5d53i43ZN1
 QmGF/UWB
 KoBqmxfexQQWnSCdpVAUKH8AAXNGt17aRmiLojHXDppn9pRuUKpXPpMC8JFj2hbgysxhttODkgobrhdNjPp/nF5vP9fKPQ7UYhEp7L4GbyBEfP8M5n69THGYAeOYdLu1ZL925sqaxc5Ftv/qiqpbvkNc5TVZSJ1R95GMXljUpGtoCiGR4RpBKAXX9lDTQdYQC1KmAuGle5WyrV918pPQJhUyYs1GFgZTfIJUZ1ucWXuTr87VkPgfWujcfMkRggWuLW5oF6ndXdUWZDr/WObsJ7rR9RwRyC3xJSZ5ZDjhk+nR3aO0kPbsYUxuQbN9vr7tYJ8UKpcb7Xn0e75Jt1eVI+IsLONOaHRVfQ/G7HP6o9zCL8oncKLX4Lay40eS7W5IiJlGWf4x8cEi0F5ohx0vUBHbAY7oJH42wqtRC0PW31bR37oZAluv3FcvOFxx3wBSOm/JEt0zt2HBAy12neMdSg3fOwhAkbuXjhZJvnQbsmMontec5YSLgly7ggibnkaeF05X0c3Zhx/JFyZqcZmTIlke4zUkcTWgxjTjJZkzubi1jwAv9mzwifH+boPKtunvl92S0LOUCiz2di6WJjzR5xSxFWxE1iUL/JChsq2zfko9ijX+F79r8CXH29FqkxC2EtpuPQZW+O5awlb1deBoob0lwvZUL0V7ZrxzC/qSX9p3tK3bJwyJpjFQuvekmeRFw42iXlU/4hrw0XgrxNqERPWaIvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The guest memfd currently does not update the inode's i_blocks and i_bytes
count when memory is allocated or freed. Hence, st_blocks returned from
fstat() is always 0.

Introduce byte accounting for guest memfd inodes.  When a new folio is
added to the filemap, add the folio's size using inode_add_bytes().
Conversely, when folios are truncated and removed from the mapping, sum
their sizes and subtract the total from the inode's byte count via
inode_sub_bytes().

With this change, stat.st_blocks for a guest_memfd will correctly report
the number of 512-byte blocks allocated to the file, consistent with other
memory-based filesystems like tmpfs.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e6c66ab7062b3..ef7f049dadace 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -137,6 +137,8 @@ static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		return ERR_PTR(ret);
 	}
 
+	inode_add_bytes(inode, folio_size(folio));
+
 	return folio;
 }
 
@@ -247,10 +249,14 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 		__kvm_gmem_invalidate_end(f, start, end);
 }
 
-static void kvm_gmem_truncate_folio(struct folio *folio)
+static size_t kvm_gmem_truncate_folio(struct folio *folio)
 {
+	size_t nr_bytes;
+
 	folio_lock(folio);
 
+	nr_bytes = folio_size(folio);
+
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);
 
@@ -262,6 +268,8 @@ static void kvm_gmem_truncate_folio(struct folio *folio)
 	filemap_remove_folio(folio);
 
 	folio_unlock(folio);
+
+	return nr_bytes;
 }
 
 static void kvm_gmem_truncate_range(struct inode *inode, pgoff_t start,
@@ -269,6 +277,7 @@ static void kvm_gmem_truncate_range(struct inode *inode, pgoff_t start,
 
 {
 	struct folio_batch fbatch;
+	size_t nr_bytes = 0;
 	pgoff_t next;
 	pgoff_t last;
 	int i;
@@ -279,11 +288,13 @@ static void kvm_gmem_truncate_range(struct inode *inode, pgoff_t start,
 	next = start;
 	while (filemap_get_folios(inode->i_mapping, &next, last, &fbatch)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i)
-			kvm_gmem_truncate_folio(fbatch.folios[i]);
+			nr_bytes += kvm_gmem_truncate_folio(fbatch.folios[i]);
 
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
+
+	inode_sub_bytes(inode, nr_bytes);
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
-- 
2.53.0.345.g96ddfc5eaa-goog


