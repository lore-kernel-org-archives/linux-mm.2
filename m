Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDAFD3EE74
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123546B020B; Thu, 22 Jan 2026 10:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E41B6B020C; Thu, 22 Jan 2026 10:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BA56B020D; Thu, 22 Jan 2026 10:19:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2FE56B020B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:19:00 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 769E81A03F6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:19:00 +0000 (UTC)
X-FDA: 84359957640.28.919D0A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04F3918000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:18:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3j50Q62;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769095139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u52WVtggwESo+ngof7T5gD1m76nZHMpw95jSdX5u/iQ=;
	b=VY7IPHFpip8K9YYTNxpW8fUZMDPutwDA8Oz4vO/eJEVFL4lUxV4A4zzLPr3dl/3d2B/izB
	09EWfkNNivn4K2iYzjLXgMkgJUe+5Q2hXFicQlM5LuiiGma40d5UVV9OLHwnyM9kI2AS08
	yUlqGYsZRZz5EzNi6QNye7KE7961RtQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m3j50Q62;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769095139; a=rsa-sha256;
	cv=none;
	b=bLs8/udPF9X9dPA8Rz1nr9KYzvOUp2QBvPn3XZB4Ac7rZwFq8OcPX1QkAshWE0P2eJMt2l
	/IRo2fL22L4+m3kAhMMFmZuF4aeMv0gV2M+7nuewGmJNbOvYXzOBfXIKHQjl3d+vHIFVoG
	hTMwG7gnvn7oFyOM3VEyYFCiuEm3MjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 077E560053;
	Thu, 22 Jan 2026 15:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552C7C19422;
	Thu, 22 Jan 2026 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769095137;
	bh=YWtRqEQX746dBC046hHOHXXVAXgaUJFRqU1AQ+gWZrE=;
	h=From:To:Cc:Subject:Date:From;
	b=m3j50Q62tM8nbh1mizsCGhX6uttEW4qp9B+nt8Vw9EI11WwosDlBeDMECQE9lJ79f
	 +zO82adThlJuxHL+LKXf+jr/A54aEjo/0RTe5rx3lZ7y8Puhb7o3ac4qNtXLa/9pUK
	 qdY87KXtNy4DLO2jjaoyOkLKqvFNL3ETXFjykduNmFXySjVhWjv2YTRArBuQ90j+Ot
	 eXGVQeoPZ0BZCKQZ35+cxuV7hEqXAqx2ZeKH7dftF7wUfK94XlBOy4Rt25gnM8Ysai
	 q8NE96mm/9DaxyauHHeVkSp8Wvk0B90eHZi2DehbSPW6qHnQRctjmjoO6Sohch68qa
	 c4QyZ9LfRGI+Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] mm: memfd_luo hotfixes
Date: Thu, 22 Jan 2026 16:18:38 +0100
Message-ID: <20260122151842.4069702-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: hc9ryi8sw3fqq9t69ieuzh8n7n9upwff
X-Rspam-User: 
X-Rspamd-Queue-Id: 04F3918000A
X-HE-Tag: 1769095138-192262
X-HE-Meta: U2FsdGVkX1+UmO2ymPdGawiLcZR7SeGrSnj2xMJpgB/oiLWtxmMgk5y2Ptt08Lbt8dcS+VCC6LqJoeOjUpHUjAA45nmTi3seQLGQu2zanHmNJbX9ZLMY6jFThVzyjoNkF99bob/vAAELAsiiRALDDbuHHKSsnul6z7zsHMmM7McRNTXz9rCfYlSvm+D4gDJ3R6H06RX9h2Ap371cLd+LurBIzrNHKQXKBt4uWshZScffXdTAtABa+habGiBQzBYydh5DtJK4tHz0P+DdoNlkPtwYOyYBs6EqIkGc3lmnQbMXtxVd+i+1Yjjsdi87NqIzhktbYqceBXV6ea99cB1lI5KDyObfQeqpE+ZZ3m9I0p1DSGvPN5sKDIz8GIBegEEqr8toGoyYTZb8iONUSnpEBe/qtYCoPSFEvZ4NUbDp8F4quX1uxTqg7RZ7F2B9a0exhhFMh4DUwFTW67xxzyd5b0rNznWt9OdRc5n1nslBzGa2EBtN76vCiLecfHT+Dmi3GhrSh6ZzHC8+8PL7RvSDiTkUkPu1vQT48UIBZWevtUndmS78BF3gCyektoCT+MfpmcgOFtLx55aRUy9CHOL/ZDkfc9oJlwG5F9TcjIUerEY3JT492x+VJtxpf5qlUKa5duWR3FiefYPgkjLxeCsnAdaAvVi3h9t3qdqfs8Fp3zLJ8dYRK/wm5Kx3SfIsTO6NAP0Y6tiOF3qdiprSNxKRD7D6ttELC1zCI7OsKD5c0WIQz6GwPiZ6OabcbyoDgH6RQrRSiDXUuvmZTDJfoVP7vpEJU29ZTH/BGUQBf05ILyZeFCdJ0IrCNtYfAq4EhkjInAX026PcLmJe2ZgvqSgqljocLIgLsvuvS6ajXMymyINbrBbq1qCKXGN3rhYoiv8Dv5u1Tp2B6zqecrNbhzZr/ydfteTq0BPF5SPyyk/3qfSIK9BDgcmVwpYvnolqbgF7ptuKqF8ZtlXlOOInKTJ
 LwtTsqc6
 PQyU8lxByawLm3MH6LPQt4UFcEFYV7fDb/cs5+ZjxRs61zjrl/ssiW1rRHPSizbYLzRnNOBDdToWMF2viift0k+9NljEeKVofj0Hk/6exLRYRQPWHVpdD4JwaECp/ld+eEzlqphECal21/5cSGaiGysV7s2DaOImj9DwDs4UzNtUAN/lvF4Y3iVaVug/wmNkjE9V72UrmX1+yzYqU4MpVd+TRnFDDH5CpEjdD0AlmlIV50A2c9k2qmbF82CcY1x7sxyf8/aCsmvVDiSlv5NXZY5eCVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series contains a couple of fixes for memfd preservation using LUO.
Patch 1 is a preparatory patch for patch 2. Patch 2 sets up the right
flags on the file and makes sure security hooks are called. Patch 3
fixes a small memory leak in the error path.

Andrew, it would be great if we can land these in v6.19, especially
patches 1 and 2 since they fix a usability and a security problem. Patch
3 can wait, but then it is pretty simple too. Anyway, since it is pretty
late in the cycle, I'll leave it to your judgement.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (3):
  memfd: export alloc_file()
  mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
  mm: memfd_luo: restore and free memfd_luo_ser on failure

 include/linux/memfd.h |  6 ++++++
 mm/memfd.c            |  4 ++--
 mm/memfd_luo.c        | 10 ++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)


base-commit: 1ac8a55c76e78fc4fc406fd7bd872d0127d04feb
-- 
2.52.0.457.g6b5491de43-goog


