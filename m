Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BE4606A338
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+sgLxGr
Received: by kanga.kvack.org (Postfix)
	id E2E736B05B1; Mon, 23 Nov 2026 08:05:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF316B05B3; Mon, 23 Nov 2026 08:05:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF60B6B05B4; Mon, 23 Nov 2026 08:05:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04246B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:05:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AA5714089B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:18 +0000 (UTC)
X-FDA: 85466404716.18.A11B439
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A73D12000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+sgLxGr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795439116;
	b=VWSYbg7FwXGVUtjlK9eATrKZHohckjm+aZutptz030cUHHKOlnTb0ZpL4IR6G6kLzsZOkN
	JrLXYnP739YDYsH3vSOKPO5XNT1jGGahCipHEZ4MHpoj6mLGAAanWhgpSdIBUQ2GnTI9Dk
	loZkOX7JlpJIjWmcFpHUotS11hBm7Us=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795439116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=03p8gBbwhN0/a1fezsMSRz0eiTfq9c/8Q3jeu/5CZkI=;
	b=yvkEev7dUh234AK6+nwjLcAe1rC2aIK2ab7w0pqf/OWnDiU0XdrYfiP9UiZQ1TlylBRWPm
	XlXHi3T8K119M/6xkMQnOv3b9rDG2ZzwcnX9JuA0kmziiBuuxshBjYXIur3PmAHFgcWrfv
	I4CXiyWNL8+9/SdXlOkVvTTg23f7GmI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+sgLxGr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 461D640095;
	Mon, 23 Nov 2026 13:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5931F000E0;
	Mon, 23 Nov 2026 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795439115;
	bh=03p8gBbwhN0/a1fezsMSRz0eiTfq9c/8Q3jeu/5CZkI=;
	h=From:To:Cc:Subject:Date;
	b=n+sgLxGrJanpQVxingJTfafcfka71+Qt6nGUufSLEbqSb8C5hi48hikcgRmCcSd3R
	 2kmX2JgAD1IGTwpsTWrPfBv6v4IpXO05T5zqSnAS/pZQOabGGJkZS9ZiI3i0qKqVs5
	 OG1b3WshJW1LJRFvij2gwPuRrC5hNDjs/Wn8iCL13dEhLSjMW6SPIOv8QM/SkKOuWz
	 4JyDkcf9S4Qx6LEb/ZpQSXuvzixR9rKeOC1ilXXmzEoWXWp8yhDqI5JRf1f11stOVQ
	 nx8INvW5yPVLHf8Ydp3Upb0cXzEvVOdEgUAK7lsfHS51kFANZaOI7IoMDmcTMItyaF
	 hepOP/5C7Ff7g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Chris Down <chris@chrisdown.name>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/2] memfd_luo: keep memfd frozen until finish
Date: Mon, 23 Nov 2026 13:05:06 +0000
Message-ID: <20261123130509.4032642-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A73D12000E
X-Rspam-User:
X-Stat-Signature: gf779juci5ha9w45wgupuk35rrpox33z
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795439116-621253
X-HE-Meta: U2FsdGVkX1+eGgyGW4Vs8xTRAUCh46gP6uPoUt3Jbm7Rmf+UmurbYXIdqQdJ1dbkhXrwG42kwTLyQRsVftkvqDO4bK08aY7xXOQS1hOcw3T7sDEoAygFCU4U41KsJ6nmo37fPPlladyCggsp1/Q/V5CIMk9ynvG6TZJUHWDYwehsTv79lhxVIpB3myAeFDgYggw2N7FrrN2XeSrKcplCJFr0WpY4SsXA2dEmXjZ/UzKEmIf8lGZC3dpW6cBrI7TOZ/4Cz3+eQllCK8kymq1ZVA1mJpiJW/xTTS64Xj1E9Ez+vM2+jt126aqeGgFth/QNpi9oaS7N+W//z0bavRzX9X21sjWors2iyhYwwbt9XSfk2sCm89IIznyDSYkzhcCr4h/X3vRUeiN+s2810ijBvlkVxmPDjQiTmZPb657ID79SifMvfPZRFXyHktENM0NWOdW8dSmQk8ecoExo9sKla3xc9Bv7sBVDD+5go5ENEkZahlnCvkZ16yl4y4QKuQtfAvqyvOM0/UrPz6MGIT7eZ1WmlWxBTBTUtq1PfjkMPOYXPNDdSoOQ2LSHdO1ZY2Esi0VEvtsqH7JpjCq5iA6U8WhZ4/ti0ZjXxH8DfuUXLVMWm78SA7kEqZjurhRuPXfM9XuKkRMaEHQCQ/a1T2IlZ/MhDXMKflghm4jsatWeRxEdOA+iRD0hNis5cnS+SG3pb9pz7al0jDWajfp/EKOLxBZoA83z7ZZlXpZP8eoLdEKb8SN6pUFLW/5Uh3z4f3muVQsdJORCJPB7oeyH7a+AE0dvlDzCUkFYyXnOwaete4sM2GRFtS1bVw014fUpK6wQwO3keuDSF9j/P0zsUWFbsQ4kNMZ0+p2TzoZW/FwM3hHrFJjHaTd61025Gp0Fr5HkWMDkmaWhxAvszD8jC5STyUGpTYd4wsa2/RSfTYBhTQhQe100XMZRvVq3tLDddclk9rsC/LwahnLrX2pdrBm
 u0rqMtTa
 PeRNnKmE0WyVY/4fvQYzhxlqR/1o0+ASfk2eXaDF5YGBPYI85wr14SZfnYFxDiyNO5olvLfclpiedgcN3lz/Tvf4JwPjWK51lPj6NuCzW0j5+/PZLbgXL2SawvGd+Jf1LS56MfZgTZ11r4lEMnB9XgeIOO4VbnreLwmhK+yfUO9h/9K9qIXCmqBSiwQ3/7v48Q3SAUYzdmjH5SCQwLbQFjze8sMoqvlRF1JW/RzKT0kNnef6S4DjvNaHYWPhaqKTBwW0OYCL8STycQ1VJB2eyNjUs0zaoezwiUVRxZKjAAuf/oEYQ9yTIXeLAhaXiYg8wewpZU19Cc054pwmpUx2QTWGv92PZ3NQpUgI+ZQ/o+Z85xfTrBDxM0UIt+xOwWF/J2CFeWjIweCTaiwcUtId38lMqRdowkt9psQIJaxttYkV2SHtQpOB5FYpUb8ZdmeFFNKVzJ92uCDYjcyTkHRRbsD5++74ZPfr8RptO8WWj5zpgyIlZopziSJpXHLslaVUW2xWh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series keeps a retrieved memfd frozen until finish. The main
motivation is to let dependents like iommufd have a chance to acquire a
reference. It also fits conceptually: finish is the point when the file
should be back to "normal".

Patch 1 allows keeping private_data from retrieve to finish. This is
needed by memfd to keep hold of folios_ser, which it uses to give up its
pins.

Patch 2 does the main change.

The series is based on
https://lore.kernel.org/kexec/20261123130115.4021199-1-pratyush@kernel.org/T/#u

Changes in v3:
- Patch 2: Document in the Restrictions section that fallocate() fails
  in all modes while the memfd is frozen, and that adding F_SEAL_WRITE
  fails with -EBUSY until finish.
- Collect tags.

Changes in v2:
- Replace the stale reference to the 'data' field in the struct
liveupdate_file_op_args kerneldoc with 'file', 'serialized_data' and
'private_data'. (Pasha)
- Collect Reviewed-by tags from Pasha.
- Rebase on the latest liveupdate/next.

v1: https://lore.kernel.org/all/20261103181916.2462825-1-pratyush@kernel.org/
v2: https://lore.kernel.org/kexec/20261103172251.2348370-1-pratyush@kernel.org/

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  liveupdate: luo_file: allow keeping private_data from retrieve until
    finish
  mm/memfd_luo: keep memfd frozen until finish

 include/linux/liveupdate.h   | 11 +++--
 kernel/liveupdate/luo_file.c | 11 +++--
 mm/memfd_luo.c               | 91 ++++++++++++++++++++++++++++--------
 3 files changed, 87 insertions(+), 26 deletions(-)


base-commit: 4209b08181c75ea02164832cd8f47526de28d40c
prerequisite-patch-id: e225259e2b7bb6664d8efdf9ca0bdfae24616fee
-- 
2.56.1.750.gf70dc682cf-goog


