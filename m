Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A67FACD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 17:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E186B0099; Sat, 30 May 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEE06B009B; Sat, 30 May 2026 13:14:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14DF6B009D; Sat, 30 May 2026 13:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A45096B0099
	for <linux-mm@kvack.org>; Sat, 30 May 2026 13:14:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A2CD12038C
	for <linux-mm@kvack.org>; Sat, 30 May 2026 17:14:30 +0000 (UTC)
X-FDA: 84824735100.23.E6F8605
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC798C000A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 17:14:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="al/BPAob";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780161268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NjWhMi7ol32O9kyUWWfMx4g883LE1ApapjqDf0LQz0E=;
	b=kYLSSxdcAyLeKvwLAoL2u0uTEgGcjtGHeqdrmtYV3QdOuCZBW5ZtCT+2xFcdD06DEUdkhu
	jbfIkTfWlbyt86HZ28T4sGrnvxv3vNQMGxxyeRLtApaJYfBuPqza/w6fH47pvmsNczJqJi
	SdhqSiS0qTTtpc+xBDHpp87pXQNzGG8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="al/BPAob";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780161268; a=rsa-sha256;
	cv=none;
	b=gOFsaEyC+7wFOwr9GWtYrNotZu839sszRPb6AqJSVYTKlEjVpBJQG5+L72fjsZ3imP6uBT
	7sN3c5/83hnrNOYAMGS/pk9jOWRM9AUDXbgRlwKzrvkEUG7Rq3nIXA/0Bz3Xc03Eaq3oz8
	Vg7P0Y68p66o2lj6XSqipujb7q/7CXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A00142D73;
	Sat, 30 May 2026 17:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955201F00898;
	Sat, 30 May 2026 17:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780161267;
	bh=NjWhMi7ol32O9kyUWWfMx4g883LE1ApapjqDf0LQz0E=;
	h=From:To:Cc:Subject:Date;
	b=al/BPAobx1/Lz/FncLND9xcqox0xSzkYfo42NtlnYuGME4E0iqZ1SQB9azH6CcU5R
	 62vn3DZFXhpJTZwaiSNKfvjillG6GIl+kczuklnpRxOjXiPXS2lnmtLmIkALgTPgGs
	 ZYwhbAdcZ3j9acHTRj4Om4Iz5kGIUYcvUqqZSH0jJYs+MYabYI4Fqyv4z3WdShuvD6
	 77Ay59ZAbjFA4A+GuCQKlFvx5AllbmaIzfb8Ih1gm2OJlc/UUa6GP/O4h1aY37DS0Y
	 hxS/pLrWrGum6WdOv2XK10wdrBWljSrKvkT1FuniHm9YlW+3wS/L4d8xVMo4ir7U5a
	 m0eN3Jdh32vFw==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] liveupdate: kho: two regression fixes
Date: Sat, 30 May 2026 20:14:20 +0300
Message-ID: <20260530171420.1430298-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kwuec1m1d1o34hrdmbhnyo5b59muk7e1
X-Rspam-User: 
X-Rspamd-Queue-Id: AC798C000A
X-HE-Tag: 1780161268-908363
X-HE-Meta: U2FsdGVkX1/M95MKfp1Qqx1EJqGTHavrmKOEDXK52a5FrGy+EXMrJH0pUf23EiFG8CIUQqUchvpOyg9pDtvePsUB4TA2nG1dSleOjtubp4vGxwRp6VGJKVezUPUfAON0xE/uhLK8eOu6aghog4tS0oKcjrpohoht4RPMHDYrI5MB6uDDO4xgVJu38Ukl94Mv9mWQaoxi2gtfQ/V4QCsdOPq0H8RcTUcvldamwvBPDKVRi3O+mQdWVHYZCWs10DowOnmilsD1SpwhRNQm/GMjmDCnY4xDgY5GFzwmWBLqWjFF/iiYgGIStuV0GnE8hv3VDf4/wBQ6KgAzI5vXCBq3zMFqLCQ9fNaPiG4B/N9v2BWIFTs0BAXKCn3Y6fuQazKyBocVq7ovb4b6rNl06PinZk2lIM/sGJA1/m0XBOR+aK79jrCvKhCP881wZc7NuY2GNJiRC3IG4bAXHscmgjByjgg1SBL+yjmSzeMoMo7WebeZmoIaIy+Ss6qpblXWTIj222K9xWJ49ZpUFJlAxgaMfNHDu8qX850QCe7/lr75yPMrv1IWjKfaoH8xBa/gjPfGRfIppq2+uxMGwSBFzZmQYolUxARJE2m7uwcLhhSv5y+EusIF9s69shUoUfywR2JqiX4ofPtcTFAHmhblm4zeI8mdgIgauU68GQFjdFiOSnfpXXMbLujATk6EAcZC9YgNHuM8SjovyRnfu1HeKPNkkZ/+c8pNHdPxqNHiMY0JL25eDcWUidIfsYD7qYPfPZEQH/YL2cTCdn6bb+iqfA5V+ZZq3aPMUFR2WBKOrkLKnXocpaKtfDhsEa4ZWfFVblfWuGi8FkvPXoFOxtTRJxxidPZu1WUTie0Sz5T0hTsY4WewBOlORZS4z4ynVYXYIHyVXnDJ2L6VWZSznQCaOLNy5IUucGljaoTsYS2jQj0GQvaQ50pSvaJizLmsTkIZjQY+e89Cn5hkEBRVw2phnbF
 kfY1gksl
 n+Ul7uXRe9H7kRExGxIpQUW21EimM5st1yzRM18VxcDQFOdP9mAzhRQgrVEweWX30Manf/loJN8Jx1l0XA1J0QKZonnh7si3qUWOy/RSjm8SbdNoJ/SyAQxRr5RAOM8MjRcZmwi4cgm8RnU/AM04ewqSwk0i5xAibqP7v0QVm+RjStxcfVYqGQI9a3Tsn/qp3CIWkW4pW9oMRGPtX9ZItywm63wE2NxdQJnO5YtywcVe6ERv0UUQCn3IRy3TBG8ZsldW01MnxASnv1TkL8+YWvEMyHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

The following changes since commit e7ae89a0c97ce2b68b0983cd01eda67cf373517d:

  Linux 7.1-rc5 (2026-05-24 13:48:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-fixes-2026-05-30

for you to fetch changes up to 8fd2f26fa2a33cfe8ac043f976137ecf5b567f03:

  kho: fix order calculation for kho_unpreserve_pages() (2026-05-26 11:01:49 +0300)

----------------------------------------------------------------
liveupdate: kho: two regression fixes

* fix order calculation for kho_unpreserve_pages() to make sure sure that
  the order calculation in kho_unpreserve_pages() mathes the order
  calculation in kho_preserve_pages().
* fix math in calculation of KHO_TREE_MAX_DEPTH to make it work with 16KB
  pages.

----------------------------------------------------------------
George Guo (1):
      kho: fix KHO_TREE_MAX_DEPTH for non-4KB page sizes

Pratyush Yadav (Google) (1):
      kho: fix order calculation for kho_unpreserve_pages()

 include/linux/kho/abi/kexec_handover.h |  2 +-
 kernel/liveupdate/kexec_handover.c     | 56 +++++++++++++++++++---------------
 2 files changed, 33 insertions(+), 25 deletions(-)

--
Sincerely yours,
Mike.

