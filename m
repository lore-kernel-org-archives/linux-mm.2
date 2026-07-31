Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D211C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A862B6B008C; Fri, 31 Jul 2026 06:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DD86B0092; Fri, 31 Jul 2026 06:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0866B0093; Fri, 31 Jul 2026 06:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE1F6B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB8A11603C1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:50 +0000 (UTC)
X-FDA: 85048660620.24.7977F1D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 357B64000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:13:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EFFE+9nM;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785492829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV4fEJeXNzRRTz9eyzhHqxzd2ssVnPioX8g4LZc5jns=;
	b=EQtJCAMfBIQeZUnuU6eWK1fL+szzQimFXzWyLocgZu/RPiGe36IvPMXKOWRf+hlPMnG6Oj
	tjjTxHiTauK5LBlHIleeQPI9P+uB8krpO1R2rD/CNnIbj6pkGUwB06t/H9ftPyHZz/jtRV
	Fl2qDgFo45gTxjmDjOGxugZCXDGQLlo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=EFFE+9nM;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785492829;
	b=oW1lnv/37jvrWH7ASh6VLIyxWZCMAJ8AFtkwPhSuEyvVKTAYj1QVAe0H2SnJgH8ceBILlB
	7uiR9yeaH72nHAdq6F3fJPKvB79J2E7Vnb3NahUPVnEVVFiD76wf76S3gv71m6iyDVGD8r
	/AfqREsAJaKRoIM8mT9hWbLPR3zAQx0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=xV4fEJeXNzRRTz9eyzhHqxzd2ssVnPioX8g4LZc5jns=; b=EFFE+9nM6xVpiuj8tLWcGSG3QK
	So+ZKmIWLcq7SzyIVr+PhfO/kMpiQSIoyVCxtUZTR/VFza+ivXNDfsif+3EUOfD4IJE4mGjRbXkMA
	8uPN8FkhXMPRFjpRDzSvXJbMUhxzcTBIoOCXX3FBP1/jYDf86MsGEg2E9Q1Jbxp2uzguwNqEdjV44
	cGzxb0f+CW94YTxCin6JLhxY3zLCXiH5kyGqW3Y0tT9EfUKUCZFF/r0a+it7OW049t9dmiAeWCv0g
	9E7w1ZS+f9GfzQk5n6nZpfVxK1a1qRurXXajriUCiwXW12ql/CiLFd8irJRnf2O9ZNCE/qJtOKJFr
	jchBGW1g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpkFE-009wB6-1X;
	Fri, 31 Jul 2026 10:13:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 31 Jul 2026 03:13:05 -0700
Subject: [PATCH v2 2/3] Documentation: kmemleak: document the conditional
 min_unref_scans default
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-kmemleak_hardened-v2-2-7b9689ac77cb@debian.org>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
In-Reply-To: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, workflows@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1829; i=leitao@debian.org;
 h=from:subject:message-id; bh=yushGXHZHDaSIkXcWCwIaU2p131csUNRGVUynS0/D8Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbHVAkbMzz1VnyGwGOef4ZiEzj2NbeGxr5mJpq
 Mv6SE71RKuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamx1QAAKCRA1o5Of/Hh3
 bSlmEACfchMqlXsVkdT9/a+9nVdaRgU7yjDLJWJnQzY/f1pqyxIZVO8LKdjRhDQcjuquiFPAyK0
 iih8KXXYxdT+qjkc2o+h5QXPRA1Y/F5F/Wc8jeLib+XxAbON9LEeFWQbHDkh8crWUQd8Rrm2Fph
 kr95DQSmCJmtyrJrE1KgH978QJv6mnUfM00iwGsuF0rs4wTym01lhT6H2LWtR8g20s1dQuhXcml
 9Mt8Xj1N+y9k8Qs/6m0hdkkIE1/CT9AxXovfdTUaUzvIzJZIwv4ESXYEKaKEmbUIlvPg/6l8NuN
 sFtUpJ1KvVlFIIgZTt8VpDtYZi/eCg6fbHSqehBmU/mKhCouRBp1OUfaIcKMPiSNgR14gWkI6nX
 5/PYU1tI8QiUoVceE6xRvwBAkWYiZNXptJWZ1N/PsqLmW7x8LKzH/a9ZDBDXGHmBXiLWdhwkKrk
 BfoTjefFk4NZDwebFcgo2stmynjLgVrcyXy8koRUm04NM/2wiFNFhGcPdeGsRRiB0FTifOAI0bk
 nq9dtNdBqImemco0ADvxNLWXE2wbf3G/N289iVUqEFhfOUmjhH8WiqaRA/VPUtOGeb9OFt9n6/T
 tFn/LLSrFf7bQCFFlccBFv6ivAa+lih2Whj477mmmLtT3N7F92E3xKYp6nPistjW0+BCvuHXAZz
 8JCoNWOcFKaqFPw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 357B64000D
X-Stat-Signature: w9wz663e59fxy9n6rk54a6qy5mqqmzjo
X-HE-Tag: 1785492829-611079
X-HE-Meta: U2FsdGVkX1+pvrVGDJNYei7bQBLsN/9gw3Lc26bZg5rdE6tC3F5GzPgfJnIOKvg+6XzwO3RxN1hC4PozrR9uwz37MbCgu2W1Ife2GcUoEEhpH9MBV2pc5zrlRo5C+1Mb8eg0lvfRP2kWvST0/z5KF1cFc0QlQyD8xusZbPDcrhGJW91FS0KvoRVTUwlMVa/XjBqJf5wACHKTVQjR6BFVtnw5lr1oHi1yziJctLdsB/XE2Lmmkae5QdCLXpjEo/F8egkRSdc0fRZDWnjy+YosWEnR28js8chpzkEFoV6x7thGGT20/AXOBbT6SCS4wbU4Du4asa1Vy5UUFQFnu/bzHdtkZ0GG/BnQd0/YEBcow6PwECB7/EFRjmG4hAdIfsN2yIVsGrOmtDPfNe+HzZ5eozt+BPQ5gRmyEqUgXT+BRGkWxKIPA58VnfZsVN283LOqkCThFT8mRHvNzTB/fDgCIIgaN+VHeBrDjunK2/crMzru++dJ3KRMWMEpkbNwgr0CMI2hH0XV1Vorc/f1cpbeyDypNOX9DUos8bj/jCyUt9q5ceo+vHbuF3H320MoOnVdlkrMI2LDiOMFm0ME8IMj5FcFDFyOgy9x4A/8PJeDRs11lT07PGKYSSEK32IpFqZFAuaqmYfDtmzgrP2mGxK28P8+k+VLH8dTNAbBoHOVSPnK0h9tnzsRCT1ySSTVFKeyTvtUXD7sfmEQRTCyV5jKm640y4Ij2wfMro5ufd7Zp23FC4kkUA/bI4U5ToAvj4gxaq/i0k7ZM0iB2wnOLODR3LCwjox/N0wZsnvMC5azlza8e+dlsi84aOkcy3qah2rsRytWC1G7/HKZQnKUlNc2Ta2Id+Mnm6SYnDShr5RTNciYVNdQW8YWB2MN6u7td7uTSLPoamV3tvfJ/mWL2I3Yo7/yeTDjSiTSO4KdGsRO4dufkcgDqi/YupTxWCPMRfQcXwPSzC3Cb+mdwIZnrUq
 NdFcu3y3
 sQr5S4HYBRLczqxbOyE7exa5izRofGhEbKbRsRx43K9c6WB7AC/qPeof13GCa3FQNon/DYhg0NZnyde3lb37OSwz/Pd5aiaKSu3p1AIAelAornaKfkBEql2fNwXXaTgDEuzjExfo01XKLppt7fGMRMJVZ2OkVDNLd49OMo5Qzl+SiA3eswS/CPwCAkwPiW8k5fhwYmzJCQY+BUOf5ornS2LW2FpZt8qiTyJq11tYFkLQb7ByHXZ9OieGXgOnukCwivftRlHSEKZ39f2Olp92AMTvV58f2RlCyLVYnrt/weU644n9jg6pOMMhlk7UMotE/2rrx42jBj85mMj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_unref_scans now defaults to 2 when CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and
CONFIG_DEBUG_KMEMLEAK_VERBOSE are both enabled, but the documentation still
states that the default is unconditionally 1.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/dev-tools/kmemleak.rst | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index a8a83bc69ceb8..d1b690b171696 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -198,11 +198,13 @@ systems, because of pointers temporarily stored in CPU registers or
 stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
 the minimum age of an object to be reported as a memory leak.
 
-The ``min_unref_scans`` module parameter (default 1) requires an object to
-be seen unreferenced in that many consecutive scans before it is reported.
-Keeping it at 1 preserves the historical behaviour; higher values filter
-the transient false positives described above, at the cost of delaying
-genuine reports by up to that many scans. It can be set at boot with
+The ``min_unref_scans`` module parameter requires an object to be seen
+unreferenced in that many consecutive scans before it is reported. It
+defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+periodic scan thread confirms a leak on its own, and to 1 otherwise. A
+value of 1 preserves the historical behaviour; higher values filter the
+transient false positives described above, at the cost of delaying genuine
+reports by up to that many scans. It can be set at boot with
 ``kmemleak.min_unref_scans=<n>`` or at run-time via
 ``/sys/module/kmemleak/parameters/min_unref_scans``.
 

-- 
2.53.0-Meta


