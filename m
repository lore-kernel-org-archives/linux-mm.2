Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09B7CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514DC8E0012; Wed,  8 Oct 2025 00:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E408E0002; Wed,  8 Oct 2025 00:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3666E8E0012; Wed,  8 Oct 2025 00:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 202658E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:40:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2F261403CF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:16 +0000 (UTC)
X-FDA: 83973695232.29.D6FD1F0
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 12BA780008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:40:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759898415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgeK9txdpLwb4kWStPacRxPPvf5dOZwITmGfD3OrnjM=;
	b=2BmK+ZwlEfXvginHL8INK9EgWjM6F6lxH6pEWy2egZMRa+9cqrMxsCgCsCZQ9U8f+L/pyc
	FM3/AmvlyQkzbUuL+r6C+JogQzMux9U/gm2noVMi9QUizowvo4UY8B7X9b9j+PaoCRI5L+
	TZg/kgrNsXCadi9pRc0J/KwJzWDmjdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759898415; a=rsa-sha256;
	cv=none;
	b=CsiWX531vhjo8bBRlnHY9HHShK1cmkPkIYE3kz2HXgcICUgvr1JoNCS86IEEGiy8Y8429q
	lunK8OW0L13HeIHvexuD9oViNlAYbK93QZfmC/xwUfJrQL72TJOuXAYWZ3WXTmm+o59Hcs
	rtpZxE8V82dk5fEhnTeu4Jl2WO3M0mg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf30.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso55736645e9.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759898413; x=1760503213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FgeK9txdpLwb4kWStPacRxPPvf5dOZwITmGfD3OrnjM=;
        b=rUbAPlf1e1QI8mxZ1dHIGgTwjCoMAtkWumvOTkBk7BNMoJw2uvXWUekvOWaLfeUqSP
         yNpES8QHjXcTyOVSuYzul0vE1/TYvVcItvTfdQJv0s7adsPW8uF4pY3NPBwpvv7uwfIL
         X78rWX/kUp15uKO94kj9BjNsi7b+OLClf/7VT5owCfwdiuBRxLtnl42DuMgcqoyQPcvI
         hKukQKm4PZ8HgPSKY42mh7S0yb4b8vV14FxmCktAEKHuY7lRPWWiUYr+BmBjccIjbh8P
         oI/CQbc9tLGy9SMuwkAVqbPrN3Mw9f5fbYJ6i4oXKhfwo8tF+zg7lJZBAPdyXZK9gnA6
         jLVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIbOK6GdLYSAHEv6WJkeaRvgKkv342kp8u3Nf8K3jN73B+I4dzAEvWvKQ3wCmUjdk/7Ag8sHed9g==@kvack.org
X-Gm-Message-State: AOJu0Yw84HGVskbiQC63qnioUhCnW649Bj4+A2cPAsryUcOWCM4yAz7B
	Wvru4zUnApHLoHTwsiMII+TuiuM60QzbXN5b4H+j1pETncvYyDoI4+ZD
X-Gm-Gg: ASbGncuSm9WxAEsYIoTibJ6AtRyYFniHzCNBY1QNRFwmVznQuyaZufZ1NDj/rBu2arc
	Jara6s9O/OeIF9IB1dt9nQakRKNr+A8GROKRZTSYlvrvOK4IEhCOY3DF4UdxstLeGTauMCZCgfE
	j9KjtY40CRV1S8PCxvdf21pVpdi2DfGWqCc66yMCgYqvujOzL+PhKYQ8v6laA6TPd5r/TE2PyFD
	rpKS3r2rv4zt6VKtnR8eu745r1PvDuCFy9Us1TdW45SMHeR5IfuHxoFimu3yBJAk0vY4PQiRgqw
	35TaCyr5TtQxC2XWummWxHiWlzVJgkK6LuwMihUWRN5mGeEpbgIErrULIceoWGGKznjhr48S1/l
	weohydeVmhg7Aw8xyfmkqHgSNYfO/bngERsPJkek=
X-Google-Smtp-Source: AGHT+IFFXobL07i2VJMhEzLhFg05M47YN+wsWxZdEN4xGgG8V0Gor51hRV6tBPzlCpXcq9XDuLQd5g==
X-Received: by 2002:a05:600c:37c9:b0:46e:477a:f3dd with SMTP id 5b1f17b1804b1-46fa9b1b18emr11613395e9.36.1759898413470;
        Tue, 07 Oct 2025 21:40:13 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c49sm28159164f8f.3.2025.10.07.21.40.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:40:13 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v3 2/3] mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for non-anon folios
Date: Wed,  8 Oct 2025 12:37:47 +0800
Message-ID: <20251008043748.45554-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251008043748.45554-1-lance.yang@linux.dev>
References: <20251008043748.45554-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: iaetfucpac3qi9n5ec1t1c7g5hbhjmke
X-Rspam-User: 
X-Rspamd-Queue-Id: 12BA780008
X-HE-Tag: 1759898414-415251
X-HE-Meta: U2FsdGVkX19x7UlxcX+ReCMay2Z0reN8/JL9RdVCM2mVR+kjljLi8BIi9jWZ+/d1a+tuzZmATq/IIoxYILc6G+lrifB90HcZsaYmeHW82m8lGUvsre/yfsID9ldD2qzPAS0vVX33V2lFOCAOy46q9xSJPmNMI8OZWpEhgvYQ26lvhIEA92Bhl6m9idqfQM1HZ7+eqcos+TV8xtome+88ENqReq8UgyONTdWGkkrfOBBmojYKv5u+c7/ZvvoSQd6qhGHiGMTR4X4LLc2OFNhX13DNx0T5dq0ono2Tu845BngVZ3JwP5hVppOjjJQmFGn3nv7T5tXEz524z9aRLMx9z8DxfSQ24CB5n0g7AtKXmVmNrXQEXp5r0S4VSm7ddFKfLKDG3jlTkIY408g67ULxETR/yRe6EQ8EATcNSSD47ol/Kj0ZLiyh9/ICkH4R2blhUg2uwXg2m9zQ4oYY4khZH/iL/3cZF2q3ALjv6WUTTfCHxcEQJJbFnjDJou5QnCpTmAUBhgzX4ZEfsm6w5yqDhKdZuWG+mg9kr8K8vB9aZE8QN2hhf9lSaCIBJksIpavzs0TzfA03PhaGmhvwEqhvnl/xXWkFtEU8vfzGVfpDg1R6dYPlqQr7HX1UnQR/hiDriSdpGFo9/Usbez+xggXG6YJbaFZt2pSQvfi8OXZLxxV8hYeP0yxo+klc8MZg/owxnv1uqUGpIEr+KtNPYxnLCFFDBJhvae+CpHvszEv9qHz0EWp2YoI+xIXG4lMeJV8MLja9AumkMh92PQr7ZbxDvoVMNkMS7iVpFIlGwSQB1OAL9DnL4PA7gw+TOo/YuKvwqa9dUKrp1uAjrpTddS7XQpJLAqis0txqUD8Vc+9XzmM8kH7N2vyuh0McMWLUU5zvFRzWGLWBF9fsqnBk0i5quDEmCUvz2Bu9EFznyycUoNixuT62AHm/oQxmJWz+2GoFPkEb7csN4WNG+Q2BZOf
 s7jYSds/
 /PGQ7BudqmuM5q1p4sFJ2gGRlG9JOo2ebstTbARfB0caT2Ae56XsNkhdFLzV8LEC/9uMHXmzb1HKbpbrLKjfM7GOwN/7Ugl77HhsVumSntX5E1vcm7OEDNsns6ISNv4Z64wM3yevxDgfz1sCQlx+Wy6CDoogQ7HzUxMlcJDJqNGIAYXdU1kNZch5EmAC4oY51sxvQTJwGi6drUfcqs1heg3XOrnI+m+xGKu2a0Jt9bXQK7IOtuzOIVB5NnpIKJNZfIJQhKaxXjPLuVODWVItOrKC7vl8JBVAd/7U6Iunv1DcAnQnffDcEZW9kLseRJ3H9C8QLaEFCm1BkMLWaC8m/20MH+IDeIoHnT6kMbr7rGvoKN+Lp5gwHbYhT1dWLoFcCFrJ5f8urE//5jYHTOrunvW5CdoxuEkNvPEq0+GYL4vnaz5vbrlCkwimOs/TLdHVUpagfp2YfI157i4/6VhjIP/mpFBr2NacB0AI37qrTuevTTU246mdQHEyMtH8HrQsKXnw9x7C4VDpOn0vO3avAjZMhD/YSbRmycnITtJqKTAI6Nepr2nABesCeGeTMGJBZusoK5rOlgkian6WJ1wjbqTKcLvvi9vzkeGW31OcuS9T46lXZ+J5VB+T/iNJcItGDE8lTppNvYEGlvNcEZg9vI/pYjcpUWI0G+BMRz9ptrEvUfMrge4Csyt9oGDaZBRoKrY49W7yeFFiBb6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As Zi pointed out, we should avoid crashing the kernel for conditions
that can be handled gracefully. Encountering a non-anonymous folio in an
anonymous VMA is a bug, but a warning is sufficient.

This patch changes the VM_BUG_ON_FOLIO(!folio_test_anon(folio)) to a
VM_WARN_ON_FOLIO() in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd(), and then aborts the scan with SCAN_PAGE_ANON.

Making more of the scanning logic common between hpage_collapse_scan_pmd()
and __collapse_huge_page_isolate(), as suggested by Dev.

Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e3e27223137a..b5c0295c3414 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -573,7 +573,11 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		}
 
 		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
+			result = SCAN_PAGE_ANON;
+			goto out;
+		}
 
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
@@ -1340,6 +1344,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		folio = page_folio(page);
 
 		if (!folio_test_anon(folio)) {
+			VM_WARN_ON_FOLIO(true, folio);
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
 		}
-- 
2.49.0


