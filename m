Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2370D41144
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C936B00A4; Thu, 15 Jan 2026 04:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127196B00A6; Thu, 15 Jan 2026 04:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CA16B00A7; Thu, 15 Jan 2026 04:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E70E86B00A4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:21:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A050C57ABB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:35 +0000 (UTC)
X-FDA: 84333655350.04.B051899
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C3DB120002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:21:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu5cnsss;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EenS6axDsQIs8DcrM4euNT5BSxpIt2vNmE+FFtH6lA=;
	b=3ufq94n9AdqRHCXEYqrPS/6UEyDwGRa2hBhP+SpT4kUK6GlHIb+Hnrn6Yq6b7hq2HeVBPM
	YY4Jbh5zKmjyEbDBezs1/kWL6SLMVeyDzHtZaRtfxPUqOy3mGNOR6X0+Y0B3lTVKOM6ltW
	7bwrReQJ8OSpBIso6yyHXvUmOh+CCno=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu5cnsss;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768468894; a=rsa-sha256;
	cv=none;
	b=2juKOALdkXMMyo0bCjMFcM1suOcZxjJ8pCwAO2Qv58aK5H9Fzo3Hbmf6lk5PiqfJ9osZNf
	Zwe8Xf9gba23XoZ6eRkdlehb/aiS2+8ycqY9ICstWSxAg43bAfnMSbBXn+tMCYNs2J2FhI
	h6D6mkJ2RHRTXBN1l/FS1kQmDxHT9s4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29AE6440E5;
	Thu, 15 Jan 2026 09:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D840AC19421;
	Thu, 15 Jan 2026 09:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768468893;
	bh=6msByTrRia9i6vND/vW1jweXAy1e72/r1CKD4n734CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu5cnsssHM0VOA2MGc8aTwkHs5DfKAxz8/KwFTSko1lI+ScylNG3t6KiXREGnGYG4
	 bbajnHy0fVOa5j3ek1JI70AVPeN+FZW+TEy1INoJw+F2pAFEGzIjvs7q8F0zIqdheB
	 5SIpjUgk5E9J67b6iBFVQmoZiYC+BeHVbM658tP0rwFlhllNOQDloLuGo7VYiWbeIk
	 ORaDqAHDYEraa10Y7nrOVGW6wIKuRACCqbuew8ilXlfJ2fEj4fTQYD4OTtSs52Uagr
	 8ZwIkkfcpdPLwwkRUB5iFUqhulaWwTq3TRtoMlYOChCsWG1c1YUkGSDalb9T3rxaXa
	 W4fHfh+JcLDbQ==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v2 10/23] mm/balloon_compaction: drop fs.h include from balloon_compaction.h
Date: Thu, 15 Jan 2026 10:20:00 +0100
Message-ID: <20260115092015.3928975-11-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115092015.3928975-1-david@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jkr1nwaz3tsq5g4gtmhsgit81hzbymoc
X-Rspamd-Queue-Id: 0C3DB120002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768468893-258782
X-HE-Meta: U2FsdGVkX1/pJ3oy0uycVOilo7ctLgiOL1FOzbvXnGDxgZ8ZGBwvxykxyKC5ZZVeYuNrSRgRykfgjkrJWFkSXkhNFimUJqQhLJqS2UHR2WlhPIrPXSBChgtDwsySw9ozOS7n402vizuyuYu83Nyt6ug6f00jZkyZ/Tse2yAWvXQ9umbcUsIeLB7tVmQ1BOZrdIKIa6DdWNOopkejsDbmhEPDzWKl62gY9md1IdT8g0fnfgpnRuDK7dAQ9HV453aGwJdMD+UAILjmI7y1TJfX0dNzBuKy/E/V1XNVl79FP432OtrSbTtdwDcoxWtohAdmflOxFvTB9aq+1zFYGOqXHvdhf8+FGRHq24BfayK3V6dnzjIm03OmCM1Z5WEns1MKCOCekT9Z+LmQepL63hr48z6sif1VjGDXQR6MGe8/x5lRxXwOISa4tPkPv+SY9Z5VxxYzrR1zpVxL3AjHwQDl0QjqT85i/NEejdc9yoCXJiznRcfPr9oayG/VQ9JtDwVqTjB9UsfJHRh8r7HEPt9dUSLdkAWXjFBSSJjUUolf4tUxxUgsaz4YbIjt8KPQ3h06hhbSPAhZuk2HZOwiX5+iCeMY2G34zx1RUnhKi+okPwOCIf7va67jocx7BZRFSgSkB6LaN6vyE/+frbkR/jLcJmi4hPlk6Ny6ngBSogHmuLWwz3wv0SkWkD5EZUVac2PS3JhWMfi0bMzadRqmiDERo/16O1OxSLs6FQ/upcsX8Ytod2HGAOPmkbPBexbGKiGYc71ddX8SuNpXkLYbLb1lxazobVt2ZeRzpM/KdYHsaw2dTIyT0Qn0PeEZmBPEUlfVqpXYq/A9s/uOsVL83l4S+So5pan112+yi71M7oI8gZDLx250JNHS9xUlhFVDibNQfxnQ5JpyU1eJsFCXwdfXLKAjtd751K7g0Kgt4BmxJSHsf3Og7uvd4Tt+N2XIDd8ZFpeBGp9ygQvMkl1Em1s
 n38qiLeC
 y5kFqifM05QAyvWXsUmIjPu8CJ4TQr2BFeMErh33S5hhqcxPsMUuoQJBXLaM46JxkGlpa8/d26/QEncKtb4xXw06wlvJbmdHLEi3n5HZHT//8z0NdNQ7wqbtNYJn5qORHyflcY1HFj++Ord+a3FmWWqgoWemkJGsaDDdRcG3g1CNoFHoPhv+s1mXEYdnSlisQJqy1UAbcMVthV3hmeCx2CRSZObS0E5Z6aLeefYr8a8Hd41TK+Flm8tSEu6Ot5ss3Oxa2uX/hKWzSFaWUbxTFQmPNyEsiyDMzyZJuEzm2IccCbKsfAAzwsKI6WwTv9w7pTs1tsMUEtLmLzFyO1//6f6l7/pn1MZbGN6Ll
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since commit 68f2736a8583 ("mm: Convert all PageMovable users to
movable_operations") we no longer store an inode in balloon_dev_info,
so we can stop including "fs.h".

Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 7db66c2c86cdc..1452ea0635245 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -42,7 +42,6 @@
 #include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/list.h>
 
 /*
-- 
2.52.0


