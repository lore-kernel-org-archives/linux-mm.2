Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9738DE83821
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 19:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D994D6B0088; Mon, 16 Feb 2026 14:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46696B0089; Mon, 16 Feb 2026 14:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D0F6B008A; Mon, 16 Feb 2026 14:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1A526B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:00:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4948A140F21
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:00:01 +0000 (UTC)
X-FDA: 84451234602.05.22A4FAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9C7118000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 18:59:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z7j84/9T";
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771268399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FkfExXpZWckKd6SgoaSjuTk6MTr1egwXV+v1Qow5XSU=;
	b=wD/qKp78oLGXsckX481uI1f0FD3T2HVvafG1wU+KaM6ID9mtFSYYM+AQI3Z3YGjdFHMP5v
	z9Yq/1/nccksLePXiP42WdAsQJtHb+ZNgQzvfSYJjQRNQvU+nNrFbXNzpbc6p6ht/IVYla
	PWndvuOmosiXHWhs+ImV37gyo5S43eA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z7j84/9T";
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771268399; a=rsa-sha256;
	cv=none;
	b=MaU5uJMnIaR2bNyHFy7W4hNEpTBJsWApywR+Q/aBqXXZsxIQJsRD1Wba0mRpJIN3Nqr++C
	sW5A93aqz26K0VFSer2Agc8Var0ZYgteYU6Me0Dxeq6RG1+aT9jNrApl9XGUphW4E80bEZ
	AS01wdsNFnJrhTrYjU7mJsuxl6A2fd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32A3C6013F;
	Mon, 16 Feb 2026 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB10BC116C6;
	Mon, 16 Feb 2026 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771268398;
	bh=N9wQ4aA83fUFDKk8sMuj4R2Ktgs7ll1vpgEUx3H9geg=;
	h=From:To:Cc:Subject:Date:From;
	b=Z7j84/9TmeCX5asCWLDzYYJ3DBnLI9qKK8wHfKDmGHp5ETpMH1oDphtnS/faLRCIJ
	 r+uq+p6A81c6o4idpYXovYmruGfOUkK8P7YfgnZhx98BElAEC34vQDafc5ayLCh4Km
	 3WD35QQaLjHz7F0O9oahCwTlUcUlMF1qrNmDtcfYgsHkgiTHpx0aXZaZEihSpWRcJM
	 F9TSp4+2dZ/UPOkfUfIV0fIdVdSjQihxKFJQ9wyRKPpuJGhsKnf6NvdRgMFFFJtceM
	 bdUi/QNn2XDMK9Ge1HO6Cz7bGHUVWGOAtgM/WdAXJX2e4U2jRGBOG0JfIGJhhN/Tp0
	 BJW/RzgnNl/SA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm: memfd_luo: preserve file seals
Date: Mon, 16 Feb 2026 19:59:31 +0100
Message-ID: <20260216185946.1215770-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9C7118000D
X-Stat-Signature: 1aecsf4umd8gfeigki5xd5c6yns4rhhf
X-Rspam-User: 
X-HE-Tag: 1771268399-993655
X-HE-Meta: U2FsdGVkX1/HSyolfGeliso37EoatvDn5tx8SxKj9CBVRCyHxUJ8EyL6hjNaR4q0b8chxKHQg5nAulMLDcVzRu82DyIL8/lr0T8sQKVBldzmbTuoUEsdtpWPUhNhMmyYjyxo56WHlE4ux5IiPotFXFDjV5b9RUaGNAp7OisQ0TPhDs0GPov/yA5s3h9rIe3DbXbuFxi2cnGh1C99BAkwAhpvr6G0WVkoRy0jBJDQa6GNsIvCNJ8Z5p8Vavt68X9h1twtl0yKhAr/0CtQ+d62kFxD5fxI50xOj1i9+MbW6pr23rpSMz8q4PdQWFtuygZd/546nN0y+oqIkYdeWLHil/UMOz471WABYF0oorGXX78ZLgexmSl/v1eN7zIzVb51ZyKhu9YzD/ukjanNxgKcBGzZn1ZdYbRPNHP3Xz3h99XnJu7nuD235KxLxX5teUpn0KH3iXbq9LafPdQXH3IuU3R7sLom96DFj9pNKeWeJahIgBXIw5nxjBIau/XxZ2aruX//L7KxYKzBMDmyuBhPbucUaIj9bYcmSnszraWSpJuwI7V8OmNZiRxiN0ZZ5pVb95ThSAwU9hKJ05dtfW5vdX74TrjnNoNSyKvA5AQa8Gkn+r4Z4PxLl6SjVnv+ySA7Ibzv+jfwoy/a5ASTN14ZkfmE4h7UWETUsrapZ6pXlFX/iW58SS8f69woaOYHb01R1RxRBfZsyKLRTTV52cB9ggb7Cr5xgFsk+c0/Vw4D+uTu9T8Ls+cMYkHNdZ3zQXq7jRjLAtG7sC85rbuTFBA9eXJ/vSGdGEB8YnfOG85j2uwMFT6vHCmwkBjzwssBvgoBOfg8sA53G9yupWeJKxnJrmZPydUIvRUlXgVvuBLDJg1QeNokAAAxHDKiAtLxLrsh8RGkqEqhUL3Oz1pwmiLcQ1lTT0pK28sEiHIrQygDGbk8PuYAubt9jHC1/Xs018ST1VfcK+NFVJV0YXvB8K4
 pMj3MBR1
 9MOxw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

This series adds support for preserving file seals when preserving a
memfd using LUO. Patch 1 exports some memfd seal manipulation functions
and patch 2 adds support for preserving them. Since it makes changes to
the serialized data structure for memfd, it also bumps the version
number.

Changes in v2:
- Define the set of seals supported by this version. Support for any
  other seal would need a version bump. Make sure the memfd only has
  this set of seals. Reject any that don't.

- Make seals a u32 since uABI defined it as an int. Change the
  __reserved into flags.

Pratyush Yadav (Google) (2):
  memfd: export memfd_{add,get}_seals()
  mm: memfd_luo: preserve file seals

 include/linux/kho/abi/memfd.h | 18 +++++++++++++++++-
 include/linux/memfd.h         | 12 ++++++++++++
 mm/memfd.c                    |  4 ++--
 mm/memfd_luo.c                | 35 +++++++++++++++++++++++++++++++++--
 4 files changed, 64 insertions(+), 5 deletions(-)

-- 
2.53.0.335.g19a08e0c02-goog


