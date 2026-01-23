Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A7BD72369
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14366B049B; Fri, 23 Jan 2026 04:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBC56B049C; Fri, 23 Jan 2026 04:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21C76B049D; Fri, 23 Jan 2026 04:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1BB56B049B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:59:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BD2DD29EA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:09 +0000 (UTC)
X-FDA: 84362780418.27.B24C54E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4E17100002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:59:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJ7og4ho;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769162347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w1MBNjkWGTQKD+0yvtdp75Gw+2OA0Wj33WLt2TbOs7I=;
	b=VgoxkxdUE0y0019FS7tr9KUMRiKA6JIiCA94zXB7vn2sapQElzno46IgWIzKay6RxKCS2K
	6YC4zjYQQzX4DxX7jXvsW8ajDslZDRjQVAPrXZlU9/r79b/v5YM0ptbDZhVz3Q1Ldk549E
	i6phjmTErJpgQ8QcIf3D5I7t9Hm/kTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SJ7og4ho;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769162347; a=rsa-sha256;
	cv=none;
	b=raYvO3uHmHTgzF9hDzYia5zBx/ZUs0fHokXmx0AKk/f3bdVRg8M3RhHC6N//kxMbvjVqP4
	jC/yha1QIzzlY12thEfeyJASzyGZ0sAvpymRoXULulBOvz5yzwb2x/HZtdzIwfRufGbpxh
	5mF/37HwFnlLvX6e5oWLWXc5S8czb9k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CF3060010;
	Fri, 23 Jan 2026 09:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B91C116D0;
	Fri, 23 Jan 2026 09:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769162346;
	bh=lJjM8x7dS3YIgG0GBsn8XGVAYDTLZLKZZO6yMQTePbI=;
	h=From:To:Cc:Subject:Date:From;
	b=SJ7og4hoGhYtUQuzu2z/K8eaIIthucOHysug8uhYPPd+WLGayt1UyIKBjy24YV13P
	 idAlxjMzQXTC4m1HbSEm9j6H0MECzsdPtWn/v26vXmncrJ1Hsf/fSuAeOx+BP3rgk4
	 ljpK5ICNBbyh3QCUlo4s4le4L+rZSzZ2VV42UhQcJdrPerdzXwmJuZGgqI2Sv9STgi
	 RGVk15w1XwZnqhbDvNwFQ/ybch7b+vLHcmQKG/pSA5PlRN8P9Ic+/32IkL+43CyLnk
	 ExwEiRTn3JFyNdBKgX0pAjlRAsXNZX25kKXUjiSOLA0KXF+mtfllcQ4kHdR9hDZ0Rr
	 v10Ii6a+dHEJg==
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
Subject: [PATCH 0/2] mm: memfd_luo: preserve file seals
Date: Fri, 23 Jan 2026 10:58:49 +0100
Message-ID: <20260123095854.535058-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4E17100002
X-Stat-Signature: uantwngr7xz4d5ewtcgo3r75b9z6ke55
X-Rspam-User: 
X-HE-Tag: 1769162347-152247
X-HE-Meta: U2FsdGVkX1/PVCIjCTDTZKiaAqzuoj5AMwMDvwLFoaWxvT4R7y+Y3s76TQiJrQVoX8Tup5qxiTkSaTuhOje/XmJnRXdllvWgEdtoda/cMEn2Uy08H55/5fw7LyNNbGAHV7kMOm9TDIo4qaJCwF45Xv+du+5IacOEgI0om8LFmHVNThZvMAfiu0NjVZKZlMRcnEPdKc3KgFWVVl4mXBs/h229glvroxqErmrrbM22TXhFqkfrSbgJUuGXpf6ZNHfdwWfJrteCpBX4wP1zrjA1RZXrQJCDZFNS1qXJdXarRJbIybn6FGVT8XpiwjsAg4bSr5fnibKRtLvmCYx7j5gFyg9Du2lBwEAMzY+CBQHrSnAjQjezljKbDWB7DNig81UaONCiO11InuNRYR+7VzWeyza6phg6adcPKloIzT+5GpJdl06N/Ej46S+Tx2AG3P9RjnxWDMktY+JfFSTSBOVdZib44bkQ7Hk2LvZhaxZH8snnwStMeSJjicfNIJmXBfZ+qhGMXhyV87Bu30qwxFusxzcnrNnPYdDLTXbFdFFIexIcc2eo/Pdap1Y/2u99zCUjMzV6SIsgT0ARFUJ8d3oQE/NOKCjNJ3gnFqZgH3uFwDDFQYliBopVBfF2o44bJSKfTOH2IJfGra8p1AIZJIz/2g/qBc7C1mosN+1bquZeCuXt4Yi1JxRP8LLQdKyA+esgWnTfJTNIT9RkeXGS1sH6DQrJOUlDfSpLtAts77i5LgiN7zdI3uhdqPQ2HZt/wUw1o68WMpOeiT7Tq2Y37AmpJWuYpiVqJ87okRqaU116Wz7RUh5ijF1krtCevi5v4mxzKUM5SJW1zmUtamwNjqI/oIIxcq5xjGQVMS4rzjDx3XeVChhG9kkEcJGPKvdPY7UEbx3Z17Qz5JoTZSB8P2DwNYuDAkPAhJKqhkONAa5dCbdwpQNDnesNyXMWSBQdc8yFiRu6rGJayeU5b/QPmAx
 VvC5vHJf
 G0nYOKsKnp/itZmjfIB325KvaJ+BomxtVyDFdpHCFeP52EROZNYAg7Jpb/ZCTvUrqevM/iddhaKtGWUQgax7gJd5Dxj7A6/V1UY+xZ9uNVamzIPTR03tJKInKQbt3iYsk292bpOqIg881/OARwbDsJS+KeYO5eLSh8LcFkLcWkK+YreF9AQbA6lW3T7q6h2N1buODmQd8rzwqAAIh3BsP2aRv793ExiUY81WWhGftnKiJIv4LGi6VD9gbsx7dAIJCovu/bgiwlUwkEx1hvvlK+d233Q==
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

I also plan to add some tests for this. I quickly hacked together
something to test this series, but I am working on some patches
that would add multiple selftests for memfd preservation. It might take
me a couple weeks to get to it, so sending the main support now in the
hopes of making it into the upcoming merge window.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (2):
  memfd: export memfd_{add,get}_seals()
  mm: memfd_luo: preserve file seals

 include/linux/kho/abi/memfd.h |  9 ++++++++-
 include/linux/memfd.h         | 12 ++++++++++++
 mm/memfd.c                    |  4 ++--
 mm/memfd_luo.c                | 23 +++++++++++++++++++++--
 4 files changed, 43 insertions(+), 5 deletions(-)

-- 
2.52.0.457.g6b5491de43-goog


