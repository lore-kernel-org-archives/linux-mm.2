Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA3C6E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 11:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268576B0088; Sat, 20 Dec 2025 06:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215BB6B0089; Sat, 20 Dec 2025 06:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8646B008A; Sat, 20 Dec 2025 06:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1E226B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:16:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7F0758DEE
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:16:58 +0000 (UTC)
X-FDA: 84239597316.21.56EC18B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9113160010
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:16:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J830oYaM;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766229417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Rmi9edjl2rxC9XwkctLUMSZhJN2qqQfsLmWqIRP2Jzc=;
	b=C5yAHXmfOrnLhUM0rGvGrchyXkocFXVHmQnCd/hZheoHoovVhVpLgH2xkdK19Mbii9Noqr
	ukfPYCWyFsYlC4uMgkxBiE82EfHcUQesqtOv2XTtbPbgKx3/xlv1r5gy8SiKOyBN4ka8tM
	MvNxyFevmwkD5Q3kijIFvcdtHS1tpiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766229417; a=rsa-sha256;
	cv=none;
	b=vBWjoN+XFlChDLSaRHLOiCJ/uZYsxJFbDkz9ArszSzqpHfJtlG7JpmMWZCiRS9zfpeJQvn
	rR3DW/yzf5RJRd0fxOzwaR4FTIN+Bo9lSKoqFCYP0p/DBUaUR9qho8WpKafwG6uJ/hHs+y
	giG/DHuLUhjXeRxYjmD6R6QyFgC6pe4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J830oYaM;
	spf=pass (imf08.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766229416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rmi9edjl2rxC9XwkctLUMSZhJN2qqQfsLmWqIRP2Jzc=;
	b=J830oYaMIfpTxuxa2HStwiq65ohkv1MQxnqIdaNdoiYPhtVSKyRbgYdKPS4qwWvrbmcy08
	CahbcoCkWXRL+o7iNwOucVmUeu8toYrb84/v5RxavJtrpht3B6ePJAj9c467O+HzhycjWs
	NUWMBQMzU6ku5WZIXoZI7Nhrt6I8B2E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-414-CvNoNfvlOYWxsHuC7xC1pg-1; Sat,
 20 Dec 2025 06:16:54 -0500
X-MC-Unique: CvNoNfvlOYWxsHuC7xC1pg-1
X-Mimecast-MFC-AGG-ID: CvNoNfvlOYWxsHuC7xC1pg_1766229413
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB660195605B;
	Sat, 20 Dec 2025 11:16:52 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FD09180035A;
	Sat, 20 Dec 2025 11:16:50 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] selftests/mm: hugetlb cgroup charging: robustness fixes
Date: Sat, 20 Dec 2025 19:16:42 +0800
Message-ID: <20251220111645.2246009-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 4nsm85igo8uw797qkd5sgp681ukh9ick
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9113160010
X-Rspam-User: 
X-HE-Tag: 1766229416-565021
X-HE-Meta: U2FsdGVkX18V7UBuVvF8Eo/kayszQ4RFnpLrStOwu+4u9GEAzxuVU5ND/QXjl5zZDqu93GCpSbgoXLmatjEotx1dKcxq7/U69SOsOUvqg4QLKo38Tyq9jstcGsKtfQv9/nX3wo9b2GLB02JYEStkTCv9+ehkIwvr1rvYAD32C4VlXlSjvTv7V/L6CSPj9lElXcn93NgFOCZ6lfydDvFj0Fej0RBWFM6QOfG2CUQ9NL8gproyP02giXyisbdK4CuE8vwiDyVtG0Ak8/QrPWsoNBBX1pXVlzHHDIXcVNOzKqLI1SDY78Vq1BrQAWL32/4azi014pFmR9yV2uUr57Yl0VBDCdqlB9NJcLrhO37n6MusDnkGzaRBNwKDsmB1iV8KzofpaDXoQvBAyl5MvA53nEzrlcUBm1YJSX1b+Lq/JeqKVgBtV1nvXK1J5u6Jaytsmr/D2cGhWK9vE/y9sTlaKfk4CbDCKoSCMIJLs19zYonsY9T5ItDD4ZQYJ/iyYXU8SuW4+9OOfsoCGRPj9uCxONi/w+dTgHisAVU72dPmfgWk1Sjw8L2hzL0KLieIaB4kyNulQDebpE7rak5RkjQI7RNNkOZYZhYovjYA1ggNgWQmv3bPNauAR2+n7f8WMB6Sn4OQbh+7LLlsgk5WKB2WeIpR/xoJLsIIDpXvgSXZ4DIn2rM39yTQzeI+P74NM8hMlC4cVA9Bwq7JZ04jJ4JWJhFZkyU0Xv2+jrR7nsdYccIyFE4jCOz4OElK3/KPzela6Ioi7jSIc3jxVM2afbaPFg9g+cxJWtYge1uCX95WL/rM5aEzNgy/vPft2ra9ZJdXkwbcLg2U8hQW3JH8I52N36axWp680LwiR5iwZLjVX5YO0KR93S/R9cJg17m1oD134NpFYtT9T7zdUk8QBaMNSXRnjSaVhT0RK2MfPWBQS5D288ESKrOQ3LIuFv5sJsckF0nUxx5hU9WXqYExGoe
 oY6kHAFH
 cniSygXfNS1uHsbtqFhvI5iNvdbtegJWGODiMh8JdFkqFLxOLjCf1U0ZbIMsvhzB7DlRKh4G9oONEMary7y5tlJBCtrs+HImtW42MQa9xckan7nMbZnh8Rmcs3/3Y7b7MchKed62xHOW9A2Dyll8ggM0/EXA3g90RCcY40Bw8Gh767tACdLDg49f9h6l8zpkhKIGAl7mUEWo+jkEh50p2oxgI1tm+XWA146QjQjLiT4FnNnHNuzKILT1A5PVcfRbafoIfijYCzHN3tyv0cckJpb48w7KH6EWpRfmIN9ULeX07KiWe3taFUyftbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
  selftests/mm/write_to_hugetlbfs: parse -s with strtoull and use size_t
  selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
  selftests/mm/charge_reserved_hugetlb: fix hugetlbfs mount size for
    large hugepages

 .../selftests/mm/charge_reserved_hugetlb.sh   | 49 ++++++++++---------
 .../testing/selftests/mm/write_to_hugetlbfs.c | 19 +++++--
 2 files changed, 43 insertions(+), 25 deletions(-)

-- 
2.49.0


