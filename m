Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16832CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D08D6B0129; Mon, 11 May 2026 12:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7811A6B012B; Mon, 11 May 2026 12:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621C46B012C; Mon, 11 May 2026 12:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9D06B0129
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14E474021E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:40 +0000 (UTC)
X-FDA: 84755685000.13.2E423DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 87F7A140018
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRrFdUev;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgGGmB+k/N3oKx8I5fVogVKI0CM6GGDkVBdF3OT5S4g=;
	b=pj9Ube1PMwAVjwWW4kSPyZ2sxHrnuDS4b3gsRoWL+N5bEtudaxF7l1JDrJ7u1m/Nsn4ey3
	KdbFWqgWPkhFg9bQJaj4WZRl8PXavtMfecoe4RDCdH9FU7JpLxB9wjEnE3OqSgQUgcki4M
	d+j9+hMjjO1J3pay5dGBKqvcjFtEQ0I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRrFdUev;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517218; a=rsa-sha256;
	cv=none;
	b=f6DTuWo3tY5TfDHOUrSUVXsF95qQ/OYyy6qJHDF1CH/+R4/pYcRhqCwinvb3tskOfxUDMT
	rU67KVpCaM9ZR0BHVP0c5xQ0iCBzDLk1UAulftJHksLaOkezVLYkLh3LNubZ8FSeT/kXwE
	QGPMn4b8HmbxrPLoZmssxia8Zdi4y8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A331600CB;
	Mon, 11 May 2026 16:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C686CC2BCF5;
	Mon, 11 May 2026 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517217;
	bh=RANINORwxgnBLj95qZshBsdS6l3lpxQnkreW9yzehS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRrFdUevtR0hUVm7Kyd7LyyhUIMKoUj+bhCCB6cz+aE07Dhopi2C51DmzZ5NvdZZ7
	 58EN3Pe+DyCJx2yBtyY9A1qo8nf+I7ayRQaUDR/8CIYPm7rweIw65IW597a2TYlqnp
	 yNA+xCPHc0JcO0b803Rmba5/OC35UEOdcheFQEs0QsMMGzKdYvAMNiOQOhGTBWpoPd
	 G70KtAoNAt03ZpOGhZwNM9sqZdWQI0rXRfIC74zHTEL1Ilyw+FK2BybJ31FMNRmsUN
	 qv/EEL3MFBcTKsAL4wSqfJBT5JAvm8z1W/EV6AcQfhkRrTfcycrmNip8dWCvHUnqVO
	 8Xlr21MwiZ99w==
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
Subject: [PATCH v4 44/55] selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:28 +0300
Message-ID: <20260511162840.375890-45-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87F7A140018
X-Stat-Signature: nxzoinxzkjeenexe5aos6fmxwgzf4b1e
X-HE-Tag: 1778517218-362172
X-HE-Meta: U2FsdGVkX19sCNjtgyoFbp4ag6H/+rf81y94wlwP65plhGrG7e1bA5mG/+uU2WGYQrIzkZYB3YJ/y1seFvB5XR0E1pIY451/mBBaagN6y2/o3YnlVZCC3tfzgK22xJwAcWvKLLolI21Ve9ei3lQu1gahWReJ91Vw86KiYTkW6vp8yL1X7+GgwlfXMRorECg/Ind5Hncu9Pht90KxKAc3IJu1wxJw68Nct15UCziL251GsEGiqrAUYAF1izyjB7jhtPgv8pOMU1TqvILeQrL3u3XZCwQFa5boyvn99aVAL+gudnHRJ5hObpYlDkxIZL7km/RWWrdLl+0uQi3Muuj00ewLOlu+A5Yv/RY0j4kgpS2LAwpaW5Pj5OEbp9Vb7GSTo4zxEM61EhlqlTxYCSI5KweZO8HA4+UMTKTcigM43+/GXY2oKJ25EY0O7ERcrjhkEuOlB5wq1m5o9aKVT+6cG/RNKs1rU+MFuWLcN3nBOGTO+Rg309KAP8boa9GAWGNAiwRFXEydgi+ed9sxjScY/zzenzNSy6kh4+gdgGKs9jKU0n+72VvirwLrHRhCp015efnp7GR6pY9CQrlLrLGGZS4JkWgZPp8jsKnxvt8+vhxTGb+JdmJa0yUCZYbrW4InALd7ylKhEw/8MyopIjT95w+xCqZ0j9phRo8GAPNDrINZifJZ3+sYyHZ/YdonZTJaT49DtCowjcMQCDyOhlx4g3iYWGM95Uc677cjSbKgQM8WRHSRoyFt/DklQo6jaaS2/81RrrEGg5BR6uFrwau+XCYb1VaoOJc6DQmnB3PS2TrUA5kyvCMBElAeIs/J5Bzt4nHkL+qpVTf/jzYIfQ6UFPyM0a3ATMgj2d45XAcvYtFVSRVXLRNN0hAdnY+IGqWtReNd9zeTNkB0bki2HuhWXCkHM2VFGn6T2jbNWvn+KgcGQij4FLWa716evqVAd4tdBOS85V9jz7Xmb2nQvtq
 wbCspbpz
 SEK02nPyV3x1MjseQLH9yTgVvpslMOPK9EtDITnB1q2ULS6pEFKuYQMdDSG8V9yehd1Rls6lk6yOA7wzEqZvspWpIJyd6ieV8D0LhsfjFLbxpPSlvplysxRyZbJr1NuC1i51SZLsj0g2E5XJMwxTHsnyZexkFmGa/buo26cZU6hfDS8R+X/yytylOIpv3QZDTZJLYGsildhaZcZIqPI2JDpyI1/HVt1DMnSgeDLRE5llzXqQBiLR1Lm0DwDPqVNWIsTxLLEErxALYqBhx0je2LOg/dk7yeCIsCw0D7cPUrNNBIp3MSgnefDm3IpQw1M2WKrJW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-vmemmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index af5786bebfd1..507df78a158d 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -97,6 +97,9 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	pagesize  = psize();
 	maplength = default_huge_page_size();
 	if (!maplength)
-- 
2.53.0


