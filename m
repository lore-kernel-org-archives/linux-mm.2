Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1EA8CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 21:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483748E000E; Mon, 20 Oct 2025 17:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45AE78E0005; Mon, 20 Oct 2025 17:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3982D8E000E; Mon, 20 Oct 2025 17:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28E378E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:08:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA8D11602B3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:08:33 +0000 (UTC)
X-FDA: 84019731306.12.9FFF86F
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3CE36A0003
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:08:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VGy3JZFQ;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760994512; a=rsa-sha256;
	cv=none;
	b=0Yy8iMhkI1Nid6sa8rcuySIGdugny8f2PV9kYZbW+c+F4sRKey2wDLwq9+gKB7ufsWJM8E
	Pg5KaahwAR0VVvIrRPjkccqKvKtp9KDENODx7PxpoddL3yfNTqsppNVUiE0sZdT8K5ekba
	1RbVVNu27uujsN5jfof9A0qdPwXEIBY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VGy3JZFQ;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760994512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OWs3rixB8Mzl55PE6ULVQfSrvZtFhlgG1JKGhyoVWm8=;
	b=s0LQs9I7TmrGyV3X5rpHvrGgkiyg7G0vYDbro77fAVj95T7to258T7WcOerzrnwV/IoiEv
	7BhY9rYANAMcEVB3ZEY3lvsk/EeEs7IIXGKyvj3SR/WarpgBrTyFv9bzN7qiuXCXOcuk8Y
	g9qpW2+qTZJI3TQ7aWN3kbJZqhCy5T4=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-87be45cba29so68459716d6.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760994511; x=1761599311; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OWs3rixB8Mzl55PE6ULVQfSrvZtFhlgG1JKGhyoVWm8=;
        b=VGy3JZFQHGHcjL5ZXEYo+eCYzuskRrSG8zMm3hLH8eGKB/LZHXEKDohhoKtqJlgKup
         PK8F46oRhTzWyx21/oDH2CoZtajwbfycO1fDEdM5q/b3+IOAO2mFPGU5pfqNoUYin83i
         wqhZccbRn3p7XjibLCa3L9mIFYeVUl9e0936NsSiSnytj3wa7iiTymEcRLNwV7nWiCs0
         /PwswMInA5U7zj+EQG4OgOvtEaJxLt5AHSqVKabwE/zYDAIpnxjHktaFxDkG/8RN4sOI
         pgk6ch9wLv2XE+h59FfQoDjZ/SGgQcIvlb4OY1vvd4sVLXfDcfJf8mL5l/e1SG9X/i5c
         F1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760994511; x=1761599311;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OWs3rixB8Mzl55PE6ULVQfSrvZtFhlgG1JKGhyoVWm8=;
        b=kMC4cDenGp0x2qTprDrzhRcfR31d45Ljv26pNZkXU+pho7buAEdbHJsrHRsW/ORz6o
         Ebxo3hbMUJGrOjqAcHUiDBcnhyNyK282joMVeqOahheT4OHFuPqca0vxanoxTetQzP7O
         mR4dnFH3sDTGWzeVP84b/Ae+dXn92i5ckYZG8C104iCU6HI6XNWhpCqxbE5IkjAGf4Gk
         4+fisy6RKwvOlfNgY3gFSQA+0F79tP0QKu9HjCeV8ExByPR8slqi/ikuNumelfh5zpgA
         mqSDJqqmY6ApW/9ib11JIaQrvr5CndVPvz90SdWoGLAho4ANFFcMsG9lWj220CRgOY5n
         1TKw==
X-Gm-Message-State: AOJu0YxnfIoEM2DyKzadTU00aQQwFSbD1BF6e8+io94A3/ZN+wUmQMfr
	oH4KpRWbZLlAr3H/R6Oyb5gPHDyAXuCzkTEZ3TaUoFRYK7RfTOF9zhLFQa5Jw/bAstxONEIwSlh
	4wLXd
X-Gm-Gg: ASbGnctJYiKHvTeEExfBIC8VQqYNSkXpQJWwbVTRkdXeS4e6npfTjx1dsLId77JySof
	HDKa6DOCJJDT1pVXBGrmXDI+LKkO3ggJ1lGMocDY1KoKjsQ0ILU2d+YcUSEAvGb9XlpIWdteWru
	Fg5UT13XBdC3ilqaoZfXk4riBBFE5LC5IyEJKg0D/Ts7Ah86fp1NHrp6UywtBcwvCjpI22PlSCd
	RAncV3CG/HnPzPv2lcMeFelaQYa7Cwqai7D9JVG3dNgU7JUZuWuJ3WDk2I9XH8Q9qqssL0C9N0m
	+AJkoGlIDcNWeGdjFZ4wH8HPLlKrTTw/BTuXHnqdTE5zt5XVFfmydi6cmgl9KaLRtKjpcDz57lc
	ptUjAgKnpojkJ7EZv2DtJ6VV2l8puSsdTQiUPXTUUzofm96RMHhEbRjgfgsdtSRteAySBL1PrR2
	cQRVVzIpdLMgdIXQtiSEn42ZryWa8rlTXzM5PMFGGsD4hKkf5heDC3ZVG+4MT6yEss7BVDbGgZy
	gk=
X-Google-Smtp-Source: AGHT+IENfTNM2VO5U6qloud+UsMTLsA87azdHw6yWf8IBWAYsxqF8ZYo9h/XbXj3UiJ3yHUAuGEmrA==
X-Received: by 2002:ac8:5a8f:0:b0:4e8:ae73:f548 with SMTP id d75a77b69052e-4e8ae73fe70mr96782901cf.82.1760994511076;
        Mon, 20 Oct 2025 14:08:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aadc2032sm61826211cf.0.2025.10.20.14.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 14:08:30 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	David Hildenbrand <david@redhat.com>
Subject: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages during contig_alloc.
Date: Mon, 20 Oct 2025 17:08:16 -0400
Message-ID: <20251020210816.1089910-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: onbs7st8pikyxinrfeqt5bamd39ho4m6
X-Rspamd-Queue-Id: 3CE36A0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760994512-259204
X-HE-Meta: U2FsdGVkX1+GL2++TDu/iz21N4flDHRolD2dN1+dyj51G7Iq35FZsK2s7GccKUxUVOJrkkcyFR6haOLmc3GDBpXsfZzpkgyg2cHPhtkUuj95rOv3e3zcOvS1zYhNvqmav+QZvT/+z2O2CIsMErTxGMtVndHbWXkfIox34GYp4kTiRR6narYel7lAyO0SqTM0X9s0AZoBSByNHy87pFtaXHD70PGqmI9HyyyqQPxd6gkDDPSrfvH2rXTF/nq0EcnvVqWCkDJ/SB7WWgO6Pp/m9Noz54oGYdOMed1bWA7cuGEqFGxYZ3bbnmQVHbQOs+idFdXckvB0pQjLjNvSSckaM0q23SAJnBGfL8q1enHXF016A8IaIlWczmQ/hnOl9F7EborS/D+9naYXZHpOQSCgBKZ7meM9RmLlgl4GujJDRsH64oWRz+CcswX0m66VDnvhhC/RmREpOjkiYdyhUoaQRWuc9DgVl2dXm8EVu5Ga+02eEzicciuugJW7MgqmT2KrcU3xYN/WilpK1Vh6iIhabeN9u2yT8+5Y5P4sLN5A7s09xLy87il0tHwV+U1geAGDa76Q09yPAkuO1RaUHVNXhtBHcrBp1nO4UOOwrMS9wdeNo0iC9HSyrutiGFm9f+avs8PmhafvSRQINdwcUmIWFvLIXPTmZRQOq6dnrZNrPDe9xzolgrFoYN+wGGlJRw6OErIh4A3T196hi+dFAnZQ7mCyaR13krCrNLgRtEykWnassuOZssBlJTeQckRP3F0/6HEwrWa1bdOZ05jcb0fL6vbd7Jf9Gyt2oa4K8Ytwi3e+lvTq1S7eWJuUBzG/+mZcPaqww9ex5quoTFrNMXQqCz1vzkuuB/XMGoaxCORb0WtOlReEyXHyFalyVQcbWNkcj5LeBd+wFmHlnB8ht3xZPt2OUbEYUiXem3CY2mCu9D4+FxPJmIvw8hYFw96+VI+iazdkU8CmOotD93lKzbR
 UIqKoLfj
 ir+MtUYYrvG6iZF/oxJd18t9UoAJPkSBqwHO5ihELMCHgcfnacwlM0AB7vpQFteM6Do1LFhL+kDr9f3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We presently skip regions with hugepages entirely when trying to do
contiguous page allocation.  Instead, if hugepage migration is enabled,
consider regions with hugepages smaller than the requested allocation.

Compaction `isolate_migrate_pages_block()` already expects requests
with hugepages to originate from alloc_contig, and hugetlb code also
does a migratable check when isolating in `folio_isolate_hugetlb()`.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..da2e65bf63e3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageReserved(page))
 			return false;
 
-		if (PageHuge(page))
-			return false;
+		if (PageHuge(page)) {
+			unsigned int order;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return false;
+
+			/* Don't consider moving same size/larger pages */
+			page = compound_head(page);
+			order = compound_order(page);
+			if ((order >= MAX_PAGE_ORDER) ||
+			    (nr_pages < (1 << order)))
+				return false;
+		}
 	}
 	return true;
 }
-- 
2.51.0


