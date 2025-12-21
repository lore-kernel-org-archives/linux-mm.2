Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50878E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826C86B00D4; Sun, 21 Dec 2025 07:26:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D45A6B00D5; Sun, 21 Dec 2025 07:26:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3DC6B00D6; Sun, 21 Dec 2025 07:26:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4D06B00D4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:26:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E8BD137D60
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:26:55 +0000 (UTC)
X-FDA: 84243402390.02.93C05C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 648311A0003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:26:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IztVDtGJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320013; a=rsa-sha256;
	cv=none;
	b=srENG4EU08NwUtfwjB0G/RmdIY4KWiS2lAR6CVULppqgqLruQJovxh3OlYb/2WS+lOAHo/
	EC81aSzQ2dtU287olg4eN2hkmCW7AOQg7gtKI+Ba4WFCk1cIbnk0lg2Ty61fLAn21Chw8H
	NO4LkjAMsS/UlzKQw2fHizM53fGgIBw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IztVDtGJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wR6RJvO5q829q98KcHX2afv2FHKgdC2z2h5jm0IRqMc=;
	b=sdhe8ZN+EAOm8byBM7hlNCWKp6iVhT7IZCJraeZ0QODO1xgPfcdOxQgf7bUBFd86NsGp15
	jy2cQdezd2p39mR6RdAm5d/kECLebXWzbJ9aNfkVjaStdyoWuZhnt+p1B+f2y5qCUpFsIe
	shsKOoUsQhHTBWctuvEnwpascY9Gpho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766320012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wR6RJvO5q829q98KcHX2afv2FHKgdC2z2h5jm0IRqMc=;
	b=IztVDtGJDIEkOAgT9CbD+E2zx06F5JlC+hkptsqDSOR7UU1iX6FXum8aC3jGCiHBC5XYjl
	OXkGV56x5ggG7FEsnTVB4sUXlmFggQ2ZE3s61ebkxaXPrE8hp2zjNEXFefPj76R5lVQRL+
	STqC8sjjx74Mp4goJeZ01z48L9L3ECs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-479-s3nKjBC4P-a7eJnzjnbJqQ-1; Sun,
 21 Dec 2025 07:26:48 -0500
X-MC-Unique: s3nKjBC4P-a7eJnzjnbJqQ-1
X-Mimecast-MFC-AGG-ID: s3nKjBC4P-a7eJnzjnbJqQ_1766320007
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F11461956080;
	Sun, 21 Dec 2025 12:26:46 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD36D19560B4;
	Sun, 21 Dec 2025 12:26:44 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] selftests/mm: hugetlb cgroup charging: robustness fixes
Date: Sun, 21 Dec 2025 20:26:36 +0800
Message-ID: <20251221122639.3168038-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 648311A0003
X-Stat-Signature: b114ahpg7dd6ibcaokpq89x7zribn1gt
X-Rspam-User: 
X-HE-Tag: 1766320013-985236
X-HE-Meta: U2FsdGVkX19PMyuUulCj3dzGTdPKZLN7vKLsQqmKWpCVitzzaYY2mplWUjT3WW5xlL9nzwToNT2RLjZBqm6PDFVgw+dK9nyXFwgbAAVTWRyUNmV4cjCzFS4oDpEB+sxfj60RTkVYXs+UR3jShfOAF2Aj79kpKWJLnLY3/RF8cYrVP6OEOOWKmVGfUaxQa37iNhy7E1amQmlm6xhf+W2nA2sPWdHWviXLxqfGzjUM6kKyh3dGckVxEeXGlcpYZF1ZKstEB+RHQk7rViLgts2gvvcUtz2MpguEPY6eYGd7WwP5/OxQd8sgiuhSV+HPDCcCEdItwcPTzihbYWW5cepA9Ef6trXsMI/ZYUbF3xSSCv7EsBPHKfjReCBLSW/pmhhV30mMtwKjw7vp7YVBhZHf7qL8Y1KXa5ZeOkhPRbnPtVnitgVphUaD+romG418vZrhJzMIlxX1Paj1HQbne8vNCAnXBc2Dg9w5XIRpcbTOTBD1FvYfzf96fXkwiPGfWWVmUWg0MwczXEjvuSRt/FjrGsbizFTNZ3FvEKpSAgvSvVjDW12j9E81ydoRggOmyULk4l3HCuEjtSKym4aiIzEQx044f5qJ8Q/zTYsuaS/8MTf6FJcsA5X45mcmSfEfZpVNdq0LiUigen/CIrwkVaGz0XFN3pDDVJytFwxL0fltk0OY3EcpNar+x4MC/0RKclEl6n43KnAvoxi+5iCGovKB3VP+XF9gK+AAj4j8mvK73Hr5bIF0gwc0FDQQYssSDq76Ko32j7SXI9Sac8S0V/LgPGb5i14Kn3nKL6JFxF2vOVROMRBjUyxenVf/kQvgmaj/4XnIklfCHnrejnO1i0CI0XALepbst98ZPiTKWgjBANBJKiR7LreqP8JTCFJ0cQ7JXdjKaMX3RfoCgBvFVN/Fjbe1+9BV50b8TZTqLeSGKGWtn2YpFP/KIDbhe5rTVIID1CcU9DoBYrv8ToX5+FX
 e2+acZAR
 agSRrC85CsH0DQDm7dcW8J+sJBFaWZ/IqtMRfL6hq+g52ZNJkAB2KQ8h0jQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v3:
  - 1/3: no changes.
  - 2/3: reorder with 3/3, and drop the 'size=' mount args.
  - 3/3: add $path check, improve varible declaration, sleep 1s for 60 tryies.

Changes in v2:
  - 1/3: Parse -s using sscanf("%zu", ...) instead of strtoull().
  - 2/3: Fix typo in charge_reserved_hugetlb.sh ("reseravation" -> "reservation").
  - 3/3: No changes.

This series fixes a few issues in the hugetlb cgroup charging selftests
(write_to_hugetlbfs.c + charge_reserved_hugetlb.sh) that show up on systems
with large hugepages (e.g. 512MB) and when failures cause the test to wait
indefinitely.

On an aarch64 64k page kernel with 512MB hugepages, the test consistently
fails in write_to_hugetlbfs with ENOMEM and then hangs waiting for the
expected usage values. The root cause is that charge_reserved_hugetlb.sh
mounts hugetlbfs with a fixed size=256M, which is smaller than a single
hugepage, resulting in a mount with size=0 capacity.

In addition, write_to_hugetlbfs previously parsed -s via atoi() into an
int, which can overflow and print negative sizes.

Reproducer / environment:
  - Kernel: 6.12.0-xxx.el10.aarch64+64k
  - Hugepagesize: 524288 kB (512MB)
  - ./charge_reserved_hugetlb.sh -cgroup-v2
  - Observed mount: pagesize=512M,size=0 before this series

After applying the series, the test completes successfully on the above setup.

Li Wang (3):
  selftests/mm/write_to_hugetlbfs: parse -s as size_t
  selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
  selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper

 .../selftests/mm/charge_reserved_hugetlb.sh   | 55 +++++++++++--------
 .../testing/selftests/mm/write_to_hugetlbfs.c |  9 ++-
 2 files changed, 38 insertions(+), 26 deletions(-)

-- 
2.49.0


