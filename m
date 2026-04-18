Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834E8F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1B46B0296; Sat, 18 Apr 2026 07:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79526B0298; Sat, 18 Apr 2026 07:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F046B0299; Sat, 18 Apr 2026 07:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6DEB6B0296
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66B511B7FFC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:53 +0000 (UTC)
X-FDA: 84671383986.27.143DC31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 919DC1C0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVA5jPII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eaw+4OjtWG2scfMcWirjo9PxqwCi8fA0+pBOmGItKy8=;
	b=cGZSnZ54BljxUVlP0bK0dF6YB+nE400h6njUM90RYbse8X2ZNETmAHxOAOErhGqyzTICoS
	NsUSvKJD5/mPIF7Ol8rxsM2iL8RflHYzzUNCSM0M6LA+Cn4xCIc5ITBeHb52ZBy/2YTnBY
	WzlaNRsB6BYURJsH6QZ8hlvAtV3fcyM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVA5jPII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510051; a=rsa-sha256;
	cv=none;
	b=KOlPYP3d5+z480cPbTYxkzBNPN6FwxvP+NfwTTno9Rnhr57hyoZGqe5pdWmRON2SSG2Bte
	VbNqI5+BR4k7R8pT8yw51WCeN04Fb2sW9cE/DX/Q+qcex/SQ9AwHnI23Zkr7mjtLUcUD6e
	imzHMgFvayY1s2y+5EK18Yp5n4WJ8i0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA65C40E05;
	Sat, 18 Apr 2026 11:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21DEC2BCB3;
	Sat, 18 Apr 2026 11:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510050;
	bh=HtpaUkBbB7ijuw6rctcgEdxPGwj4VxmBP6AvOyp0uHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVA5jPIINjA7F3oQghv84OSH2WSMeHnn/YBfm6n14Q9z0tjRkKUGb2q7gaxzMRmUg
	 o5yi0rCKBCxtl/HhHs1yr+W84697sgcBz0oNnYkqQaZZD9TjIfduUzlscnCGrDX0aB
	 VPO00MQx69uXOZfy+Yh42H58IVXOT+A2n0wWjEPjGCQzgrNZp8u3kdD74vNr6vMYvx
	 CAX+dPz4dP0GaqWHm48kwli5oW7KqjpjqbGz2hUBDVRHqn+UuZiZi4uv1CbZedn4wc
	 R/AlI+NDGTnqKxvPg0IJxenmMcL4MSz4xBKB3pmCzmDskIoHS3yFqmNm5wB2qy/twQ
	 monjMk+chBMZg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 49/53] selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:34 +0300
Message-ID: <20260418105539.1261536-50-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 919DC1C0006
X-Stat-Signature: i3hpdh1cagosdt45zefckd1ckijrkhbt
X-HE-Tag: 1776510051-888563
X-HE-Meta: U2FsdGVkX1/n7FmY/Jo4UsZhXmY+jUmtn3cs4G3TsFgvOhyDt3094jG0g60cTKbxJQ6lfIwJ/ZH1QJuFjRJOMKPmCmt2jg73r00FBCyAn0Fq31uxbplQb7rHoPd48hntpVBDOeFiAsFd/ByJ/LuNFFmWcfK1FNrKi4cLpEy8vT1eMeuI2l/wkdTFbDXAwsjvuwjr/A9/I6MXzuu3cpM/Txh/GDDvbBT3OZ0FIKSCEdn0NpKQtTuVedaQ705ZkhSD+v6+pKJEpy4IDDI7B00a+XfSd3Yr+NbHEgvT0VPqEarVQFFUqyF4s8tCXDZgbAHe+EkbAJonsFXlfLthdaWJhCbFlgOs1nQ1YCjB3yoGMIf8Gs4WVPBgZftDU1unBMuUf3VltCUGzuma8hZsXMz9sKb6jRR9VWpPwgtiqqzxRUQlbbvRo7weynpZ7HrC5LwUByjkvu0iCMi5sfZVn6OBL/6UzlZiZMl/P6AyBeE2MD3K9RMU0uZahim/hgiSJDFNwYFjZY3yxzdXAYJlc+IxI9/WT4nK402qpCIvYlJO9ldv+XlgWWCb2vWnFpjogSFI4z6uRdvO2wVeML3LxdfgVTGSaLduC7Su5NGPqHIEWmCdZydz7MsBy2B/tnQMESmlRVLKtdLFvncJdmNQOdGuf8Y9+hZTPHdA4cD6nl0XGjQKMNUam6tpnCY3KOGvXEs6dSiZzEtPL9JEGWSzEUMmuoHFdtq7gNOTxbmmq8K7gqDNhDRP8akKMXg7F3tTSoUrDR5CvgpJYHStnwPDqMzlU+ToI5rVMsWme8xBQl7UigugfYXnWoEulSY+ewZWHyWpYOdAnwLaVMRpCC5rykXEjsYQXFbDvSVQk+xffHrG4O0wqAeDT1fd0Huj+0wGuyYxTVyl/BxOGakQJv/xZFxMg1juhGittWr9AHYT++U9kY7duECDJBeHZbkHWs180twEu0UR9q32fa8cCofGMUt
 8SbTkSOY
 S+/fBCju/JdX/jo1hKdirqdpffotNk58GNg6DampOsGJtbMAIISXu2JedJKHTv4snH4AvvxQHrGwlBArzXe/4L4M7gFuhnl27oNr3yZFjfLK7JJn1NWXZDfu5s8g6Xj65GQ4egWShZA88mHcklxYi1dOa3rHzhZP7uIHsG/oVi+1o6jHdr0IqLS1JLTSMD/N0fgOuDVu6mvVBjEjVbmZc2zAwdrMPfQKdGEeKkkZsDkPVfQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-wp-remap skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 9d67b11c2f28..f63fe02f404f 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -336,14 +336,14 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	hugepage_save_settings(true, true);
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
-	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-						    ARRAY_SIZE(hugetlbsizes));
+	nr_hugetlbsizes = hugetlb_setup(1, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
 
 	/* If THP is supported, save THP settings and initially disable THP. */
 	if (nr_thpsizes) {
-		thp_save_settings();
 		thp_read_settings(&settings);
 		for (i = 0; i < NR_ORDERS; i++) {
 			settings.hugepages[i].enabled = THP_NEVER;
-- 
2.53.0


