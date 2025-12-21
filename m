Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F8FE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A53B6B0095; Sun, 21 Dec 2025 03:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352B86B0096; Sun, 21 Dec 2025 03:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234886B0098; Sun, 21 Dec 2025 03:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 143946B0095
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:58:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 930CE8B79A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:27 +0000 (UTC)
X-FDA: 84242877054.24.A9AEF99
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id A532EC0002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agma9H0E;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766307506; a=rsa-sha256;
	cv=none;
	b=18v+GWOH0YkN2ZMkhpyF09lioJrWvokqc414uvJhiWRushXab119UjiczmyeEG4gVmd4UA
	apGL8QOb+OQbvhzlMChYrGsOdk8S4WgnTNNIdLRGlFpUjrK1mnVBO+7fsr+8sprtUkaauG
	UdUGqQVQsBdi5NV+B1NuJ2t67dXYFKE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agma9H0E;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766307506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Jv4+N3yPqzFBNXywZidTgEMmHvkbMjhW+YkPHiUuGYg=;
	b=ZPzOexjwgReTofcIzfy2yHOYi3n6uGiykjjlQwM5wGcn2PLeBEj4t/QPEEHURMP1zHZ6qs
	r257qOBh+5Dy3L4djKtRitNSgVUayKdDFPfQRQhNOaju6+V2JpixoYpwiTAr7cBnbNqq88
	+7KePii9paWnmIjz6NNRimYiWLOR+rw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766307505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jv4+N3yPqzFBNXywZidTgEMmHvkbMjhW+YkPHiUuGYg=;
	b=agma9H0EmhlmQ5FAes3o9JnFNBRungPJ5iZT17P9Qusqgp0CZE8iFA1xyBki4ARzXEI09k
	jsH0jdKxsi0RUVoNIoOuBotgjGwqK6Pno2rESpujmpuZawwtxhbwJYXDUEHnX0Tw4AMJ64
	rkN9cGQweyHioElYWum38Vs8kOOlsms=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-sMSeTc1RNy6-vFsI9gpUGg-1; Sun,
 21 Dec 2025 03:58:19 -0500
X-MC-Unique: sMSeTc1RNy6-vFsI9gpUGg-1
X-Mimecast-MFC-AGG-ID: sMSeTc1RNy6-vFsI9gpUGg_1766307498
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE806180060D;
	Sun, 21 Dec 2025 08:58:17 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CF2F30001A2;
	Sun, 21 Dec 2025 08:58:15 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/3] selftests/mm: hugetlb cgroup charging: robustness fixes
Date: Sun, 21 Dec 2025 16:58:07 +0800
Message-ID: <20251221085810.3163919-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Queue-Id: A532EC0002
X-Rspamd-Server: rspam04
X-Stat-Signature: tcuyna5shfcgn6amaex96k56urqch6g5
X-HE-Tag: 1766307505-602217
X-HE-Meta: U2FsdGVkX185taHsBBbfDZzLI7EaxZ/lyCaGPVN1+WT7wS3LiLbvEQl6mCVZdX/I9Ea65NuUm2Wz5tvmk6SVyQrxbjPtC6l7N5uivoKIzDw5rQgMnabQxyDyoVsdDpARNQVOL/Z46kHjPfRjM0I4zffRpzUC+XeTwqCQr/bINqNuA/gV/S9Ul/T/4NFNhDsQB/HjT+cUtVCYKyFSx+MnC4yx5meFt+EJDp/8znMdghPeVYSjyatjP7YAS0twqY0w4LiXfeEfIkRwTfrhj/+jIVIxcjpREtv2o6lhbL0SjFnQyKCvhQaTtAM9a2DgV7kcC2SI0SJDBlYTSeMlTIs0ItfekmMjUrPp4km9BMJs+U9VVGR6cSZE2DYPKO4f+btG2CBDViKTamixja4vC0YGenf/qpkXx2+3NU4kxxjqktnsJwhMZiKNvIpdlf5XPBsxz31jlMsaf0AWKigcVDwTrwrJZaMnKGPF47Z0ExBzcpxURNTu4f6zy9UUCgRdCMnWLdlrmwz1haUGQw3sEksqVUHnKGrndoK5C4rkRwWhnyFk30BbK+7xiiNZ6CiuDtOKU7JwE57kHGxLK4R+grqGwzUt4/2yMje4pLLqV6z+mK54hHfz8gUmGPsbmqNhps/afw3CLtUS8EaGIuIvJXOKts5TSLIc73i8L+efGw0LVa4DhLi2v2A0J0gbkn//o76x3f/aznu8616boXX907LLwd7bO9yJq20U+t+7ViPTJw/7VgKyv30YOS16r9UX4yc0vGwy0zBZPTUi+E/RiNVnpyeve63ebRrHmamkUc4cttGV14QU3CAyf9q2bKNgpNrqbX1Eu8e83dgguJoLm3LK2s6Tb3ML3WlGLCFxx7qnCNQ04Nsg5kP+c2G0p3ua6R4uAcKWyHj9KcD2wEt3r/YXDCoWTh3bQmQZ8G7sxMoxp3JkAsYZimLiOtVvkuL2bU/SsQ12bRJT/zS8q0b4CmL
 1J9rPKg4
 MftbjbXqJWetHWHE8t174idR+2NUwxF8CDuXwg0+YY2Z2sRaeOtp4QVOExbG0qwF46eSdULZxoD0oKduxxGi8Bi3sqJsSRRVyg5dUC9fnd5vUX1C4hlFUUQMtKGV1WqZ5i+oxz5bz1+i4wmS0S0rlFLIyZky0UNNF8NtQOM3PN+XKl/V2Fye7i4sO1E/6krGEyIHSRsEDN45hzucnlU5aOWRAV2xtTmDbqqzpJsmP2EmTZBtjlVc+SDhB7gE53YOXKzUGSrVZSphyt0dB1dc9LBv3rfdjZ83ajyPAElU5WU8kkHGDlI6WKOkTOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
  selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
  selftests/mm/charge_reserved_hugetlb: fix hugetlbfs mount size for
    large hugepages

 .../selftests/mm/charge_reserved_hugetlb.sh   | 51 ++++++++++---------
 .../testing/selftests/mm/write_to_hugetlbfs.c |  9 ++--
 2 files changed, 34 insertions(+), 26 deletions(-)

-- 
2.49.0


