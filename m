Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C58CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B246B008C; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD436B0092; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383426B0093; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D45B6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D96A61C023A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:09 +0000 (UTC)
X-FDA: 84836331258.16.2FD4A95
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 043794000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qkhGzOuC;
	spf=pass (imf12.hostedemail.com: domain of 3dlEfagYKCO0lnXWPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3dlEfagYKCO0lnXWPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fr6YOv97JYHN5mxeGTDHXogTsZjg8n737cnMXei3iU4=;
	b=E/x69DgDXYpuTUgr10S9H5AqyOcry0REEFFqQQl2H4ynzgIGt9TVnqfkEvNlVnqoGQo3ht
	t7Je+My1EQudKJw37VN7XfdJdGrgIg9h/yUMlfkmBwTRA9bIPcZE+LjQwCTkPpZRhxOnfC
	QMpcNCsjYRLUzMZZ3Ac+5hjkl6F0AFI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qkhGzOuC;
	spf=pass (imf12.hostedemail.com: domain of 3dlEfagYKCO0lnXWPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3dlEfagYKCO0lnXWPcVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437368;
	b=KS0QIeJbg0YsbG3q+2g/lkOsGktTd1Q6nVU3UplhDmKaZ+8RT9wkxBKg82DUn+y1d3j8hZ
	6inZQoqyPjtxYwa2cZIlgX0d8LvQz9C73FcOQB1f2uUWAMTi/v3yvgVxJlRqdPr5qWN7Ua
	5ckS+xVb0mrfPl5VQJe0vRVEpW5vRWs=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-841ef4bf8cfso4154195b3a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437367; x=1781042167; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr6YOv97JYHN5mxeGTDHXogTsZjg8n737cnMXei3iU4=;
        b=qkhGzOuCJOtK8oQKg6RXvfciCnZiU9pWqdVGYg8rqDCDRHBw1N3Sp7h+Lzl0IzMedm
         +C5NMvMIK7cOF5HHYfP0JoT7VpefDqps7AxmuzPJ1dm3I1FFWvvtnOGqmU4KxZUG1v0g
         1yTumdWY+nEhdMmsrAcKXBt+Vf56NiuC5CHpPa0yTuwVhG1CWWpFMcq+7VqMMCzdmZMJ
         g/ZnPNiQ3X4flCPGgoeuPL9KC/JMACx+dpbT9alzOD6iLSS3qoC5n2d9K3dLh3ZQeYY/
         k1187Hx31njUdbV9RC5AwCShUgClcPiSIISAagdSxFfI+qIiOMykJxIdpCrsuoLSrPaM
         HmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437367; x=1781042167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fr6YOv97JYHN5mxeGTDHXogTsZjg8n737cnMXei3iU4=;
        b=IfbXABgaJpEluzaCbdVbnbtYe49JI8L6mi96GGQ5I7+rkIGVh5MgTVs+gnb8YTwGYF
         87Td3bU7JzmCTg/HXeTo6TPmc4V8vdyTe/Neg3eTA6aCb4tNeQlxSA6/5qM/y0d/wQpM
         7ulzdBW1cOwSHmtA4LBzT8Axd004oc4mGximrBlDFV/bb00RaqNotrTpuWxweKqm2D+e
         /BLXIn2lk8VgotEI/gFJM4HNJxxUeam0r4w0wyEz4fiUETA42bTIPPDhmsUKe7wsDp2k
         LVToYYe2iytbPcYnmWXytBoF5/nR76+amB1oiKVmZOsnN+8Qc5T2kEVTkIkrASe20Hdl
         HurA==
X-Forwarded-Encrypted: i=1; AFNElJ8N7YO4M8ri3oeQ0i/WwOVzEp5pWtgpIha30PM/z3cvjqHSWcSyk/NTKosi/gjH+158+5qXo4EIVg==@kvack.org
X-Gm-Message-State: AOJu0YytJklxxB3Id3ma+2GzmM3faV/kEpQ6vBbRnoJsdtTxJKLK87hk
	6kbgY+ZtL/Ss7C3kPh5nkCUyZWtReUj+onKP5W1pLqrx512hQccWffO8BsmTCB8zIXmI+trHB2C
	WeaqlNw==
X-Received: from pfblc6.prod.google.com ([2002:a05:6a00:4f46:b0:835:4c30:5576])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2303:b0:835:4291:6978
 with SMTP id d2e1a72fcca58-84284eed054mr629183b3a.41.1780437366524; Tue, 02
 Jun 2026 14:56:06 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:42 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=1676;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=5N67K9Z/FRb4/h9EDb/dnLOi0/eD6cgQqD0Ji0Ch9S8=; b=L2txlDOSMZsr95mUVivDSrgEhoDq/mzN2uDs+L0Ji+lu2zWe5JuwFpcRNcm4/kttQfOvt/J4k
 N1cIM99c8fBCfTGaJcARyRhDonF5fnRnZi7h6lhqe8lIMDM6tkfeAqm
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-2-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 2/7] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 043794000A
X-Stat-Signature: 4z8hr1tffcusjdm9khonuipxz19d3yx8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780437367-620612
X-HE-Meta: U2FsdGVkX19I6UkVgzYrB2KA0HeTW4tXnQBT98XcMzcmiVz9i0yUBOfndHOtmhB+y0Jshgr2l47aRoXXZadOmHhaac3YVsNtP5iYWdXmx8oGx7Wdh2tTVvZ8enGuotFKesCw8p3Q+U8s2BqLu8cqLO8J0aZtv5Uk7Drvz6JVGbPAEsJiCQJltMtciFW6Ji15b++SM8oAhw+LdYetEUCQxklQxKAT9XKjfpFSLEiEZxbi8XbyNPpRia56DFpyPimy+FD18llW/yTPWHhvmCsNqJSAAIjLFDUTY/JMPXGz/ex/shaQY1pktZyiVe+rbcA+RydmlyYazXBogx/K+4ZGKzLB1Pj905FEd1kaGyas46lWq1kdPRLDLe/OCul+3jn5e/Udz529qEzSFlY4xe3IaaEb5GEb2Ugn87J4OYnnlpfZFEtfhkvHUinOHkojdxxlEMSS0RJdMNsYhLEOUDnVjwJz4gmRCk8OvHfHAfoIt4PyhkAIPq+HANzRHYTGqXUrc2q1qSTJJ5H3z6ZBFNCSqi6xSKEruE9Mb8H7ngVZgU1Qnpn6cidIc92jqcIWE2uwfLhJckX6T8uNlrxIDtuBfODFYF29uLOIHHUy7jJfp5eD+k64KF37fGoRl2otn3eHl587VcjDrv5IqmaPtn5mj1UU8Kzc9fL5EtPYJ8E5g5HPd+DI2WXA9HAwIIIuZMKHM8Cq711RKjulujHlxjp3DmxdaPDVKEeR15hytJaBU+wIzW4ekYLvTQp11ZugD1yM/4blRlBnvZZ2xQbVHIOTVnueHiqAl4K0zSg+vTyN/xpx+z+O7meqvjLsGplpTp440PEaBERndNRax52eeB/g3mr2vJY7hV8romFU/4Msb60D67OJFa6XqDggQ+xZByzRUF48Lk1acdCyLrQ9M5ZHj4ABFPlkx++VJT4XCWeP+9aXuCB9pCY+MHNVFKYPH5yR6nS43ITnVenxeKDSV/I
 ngvGZV0M
 mFGcrEa6p4L+qNhfGZkMSO/FQ7LYbIcdDZOEg5BPN4LJ+yrPAUOqF0I5n3LEeUUqmD6Moz5ixCPWPFJhk4J6GFtJb6yuBph1NcNjONOIJuLDV8eZTbovQAS/2RD5S1iNQ8kE9vM22nlckHSjXDd0TKiWYNTUSXyrKfqxnUTEZlj9fI8O+txwjgFs6+TYC2JprNM5stnjGmrcY6yKCB6DdMwTF1E4ArKgT8lM3OO9iTqLEqZ7PeMoqFTxrQ7pzg6U/RZHkyBEP6joymewspmvTXG43jwGszON2khTifwdE6SbW6Pbg69yE2mfYk4kVi2ygoLozCB7hHQfQ8RLU1eaQzQpMfhzuh9KZu1g+lHhwN7RYFPWjVl7CTjx1K4TJ2JO2BGncH/fR8DKOt09kYSjYu7CTYwEcNsTG7ABcDal5EQgNAubG/x6xbOzfab3P9PAUKNIpDFHrPERSxBfPRrxAwozm8x1pTV0ARf/+QvbYJGL4hV0kv+wyAxDkqN6OxVnt12+QRnMDfY/jqexpDRDWyt37qOoV7rVHpBdgwUXY8WoDgAQXfj8mmQDxCoppE1Urv/rnjkfdhlAu0tfXV04jDDh5Y4KBO1bVp6TVaP00En5V4qwdWrFtorVikF9Uh9kCN80GzWjACYcTLVqJYEve4ksawKhL0vcAZJbI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2e53b3024391..3aff0c981fcd 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -941,10 +941,12 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
-			pr_info("%#lx: failed to release buffers\n", pfn);
+			pr_info("%#lx: Failed to release buffers\n", pfn);
 		else
 			ret = MF_RECOVERED;
 	} else {

-- 
2.54.0.1013.g208068f2d8-goog


