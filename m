Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE17CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958666B0137; Mon, 11 May 2026 12:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908B16B0138; Mon, 11 May 2026 12:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0956B0139; Mon, 11 May 2026 12:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5D46B0137
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:34:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BD521C00F2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:26 +0000 (UTC)
X-FDA: 84755686932.07.5E57624
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7261C20007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:34:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NX0zFW2U;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGNAVeEC1jkuPmaRRGWSW4UYpvcyQXIga7GcoPUZ4lo=;
	b=LsmmMUf8NFtoaBs1Y5W5jwa+P4DUs1kBJnTF/s/UqFAbQgxjfnmqNSzUnWCCmF9R3EFefJ
	qhnQiU7NMWn8H6vRZoHeyt3a4kih4aTKrbD9wfQpmMfeFxOzBE1VEwjtobFafeFTBHz5w7
	U+nc4DahmZmOJs84xkP0Lgc33Nz9jXQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NX0zFW2U;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517264; a=rsa-sha256;
	cv=none;
	b=xYUGVaoExw4X3nF9W2zSRknHLlZwRWdbxsWgvss2qNiR+1tsqS2q+jrVkofjlkQFBDdBoX
	226XIJo3+xBOhJ33PLlxl7O60TqMbqIOZow7rWpn7DxxdT/P57lFDiOdafZPkheXixz9Lv
	tVXkzl6BNvMaU8mA3gvDsqlnhVmYFmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B5D543832;
	Mon, 11 May 2026 16:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78793C2BCB0;
	Mon, 11 May 2026 16:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517263;
	bh=E1oIrYUogHJ+9UAiYDAHUarJog8LSuDN15FTDfeEGR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NX0zFW2UfIDNSCCKAcpcryW6i4H4VNcwtdlTPYPmGbcuQ0G6vcAZlRRj7zgTtj0DD
	 k96xD2L+hXv0r5kFZ3f91QIePWzacy7/4f350zd/QnmE4kXFq8iRJ4kKdt0dj2Hq0o
	 bbI/0MHSG0kVOjMZ6cEw+UvluUZS/+8icRpD5enKI/5OZ8IWagFSJesrx4qk7WfuJG
	 sWNtcWcpigP+60hIEWMs85TLl7syz1DanAQIP3dsBebrEDabh/fLgELQMDThfJAP3U
	 EDm7RBVgMsIDTctz7V0zAzuJdgARkcvOX1+u0kfzehEJ5eyPFw7CRP3XTHuDyXUkPT
	 ExR4u9gZ9k7kQ==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 51/55] selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:35 +0300
Message-ID: <20260511162840.375890-52-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pxn6ihkwd1pea6zi8wshtihghirkjx9q
X-Rspamd-Queue-Id: 7261C20007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517264-818120
X-HE-Meta: U2FsdGVkX18j0jThLuc6YBTRjJ0rYVoaZUnWmkt5XcF+FTmLERnxjK2uCusLHEgs1OQRFeWRBl/vHE9A1RlCZL9/3zGMWsHekSlc9aCeODkE+mY9JO6X3hoRv0p8DVp+uq9DdVhTNRaa7fV/mm0HF+wm+8gyGFu7SGtJGh7Oz0hD1R661/pyJ3Rtn5aAuA2D+9wsDXAzVSQ0Wl4exxd/ngkNpjSyT5Qcmuh3BTg29LqhGbJtPLbFqTX+2P/yTIRNrDL5zMHGXrmOOxPUcqZKL5znGak6tJCyGuecED/wXB3ezSoBvBH4T/YuVUnoMGQ0DZqhB7XnAC1VjJBe0A/RqWIwG2zpmQVHtBWOxN3ZCx/+PiCIaAO1xGtLXz4JO51mUwBSwZFu97JH94DTK/vnZWnhEgNu5CqP7GKqCV3dHR4UjI/7CXEkCKv/2D7RU9yXjdwFzS8ELTAVedAKEN/cMYTy+Wsa970N0E/S3n+gX+1u9YDzVEXT1rgSIw0vgRkSN+Jai3/eEYPvxavjPy1HrKd0K6yQVaUq1ozp85hb1TG+6+i+D6Hu+dCpbBfXpioXPF1OnKbS5IwwZ9XWyPb3LLtjxDMJlMeB4pJ9+6v/RcYNeI2JhnTsoQ2BI/zhDqgTnsk3Kw5uY/qdsOJvlPWLgunRdXFTegH3Bp317Jhe75mEI1XfWqlf6dBkFgl7QJq40ZmChK1UNRHxlyxXJxpT4P94lZhOAZoM1U7tFkrDstdUKiSJaMlVdNOMZi9dOGmzSg2mtT8r491tZmms8t7RbF5wBuV0F/bSnSfcF2PIQx6AupTFTMkNIwNSyi2j+MFFM6rovM+mYJDcBHpjWSVJyv2OkpsU+9buRNdGhXeZYZkLs0hSPLKXPL3/GgO5cOt6PReSGI4zsJhjchoPwQRrXFM3KFDt+mymtBjNL9X66o98KAVjHTjJeYvpVaof/2EzEUbfOnI75byNraftenO
 EUkT6IL/
 7eomLj/2ycAja8rKvvDbJisAgLz/6d7PWWfwBRknIi/tMLFBuzueE7C0uA7V/ewiOXokut0DImn+f4NUi4ryYLPmOauoM++64kljYDHd4vL94v0wVgthcOcJFx1yEd9B9MIop5Q62eTleKd3RgGgFn1zFIO4g+d/u4lZAinJVUSbNYgWCO2nkD63V/ZDo/P1aJPNh3Bb+pyFnSLFX0r1qJehD6EPxUTaq9eKsA6OqZRx0ALfoYz7gJRq/icciw2D7j1uLs9NyzKeio9h1Fu1Ts0JqMTq6jGyGP2i7iNWH1FnMAGdqUTsMbCiXiQbXCEioV6kK
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index b44e02840a5e..90ac410c6c6f 100644
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
 
-	/* If THP is supported, save THP settings and initially disable THP. */
+	/* If THP is supported, initially disable THP. */
 	if (nr_thpsizes) {
-		thp_save_settings();
 		thp_read_settings(&settings);
 		for (i = 0; i < NR_ORDERS; i++) {
 			settings.hugepages[i].enabled = THP_NEVER;
-- 
2.53.0


