Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BD4F5A8C6
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 21:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EB26B0088; Mon, 20 Apr 2026 17:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26046B0089; Mon, 20 Apr 2026 17:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963AE6B008A; Mon, 20 Apr 2026 17:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88F2D6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:03:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2939DC358E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:03:28 +0000 (UTC)
X-FDA: 84680160096.08.FFD6074
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71249180014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 21:03:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHYZkX4X;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776719006; a=rsa-sha256;
	cv=none;
	b=6bWy5rWgo0Hyr44zhxSXpJOM6f64U8oK8ZiWuw4Q/Ih7+xgYmrGpxPwMNCl5UjUHgX1D9T
	VDWlNuB5X/lmZX30yJJgiyhuIpOm9mvz4PL5WexdDN70TDb03/KlTXHIVmeVKpu2o/+zJ+
	iV2nkfrgU1r2OkUVCpool8MYgASnvVc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHYZkX4X;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776719006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/MKlWkIWmvIpGQfvmij+lfriBKx6pqOQmrEG+DIYs6k=;
	b=DwsnXxTSiypR4nR3141CsduizFBz2MdPakFlZNhLFzPnuksIX8lQAuXCFqkdqFsUJpSML2
	b9Kp2uscMqGrwgQKl26Nd8zoAGZWXEu9we8UliSpzOO0ascL2+eCi1SsQORDH2gL/AabB6
	OijYE6ZcDaQJevnAjBt0RwVsofmemBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CADA441A2;
	Mon, 20 Apr 2026 21:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48236C19425;
	Mon, 20 Apr 2026 21:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776719005;
	bh=VP9IrJ4l0SklCndrbkVfEFo0OIEf+svLpxw4cCq58sA=;
	h=From:Date:Subject:To:Cc:From;
	b=ZHYZkX4X+t1uekxCCKt2BxvMYVS9JWkFL2KxK272j37gx7wlUlUc64FqXCYa9x0Y4
	 hcew88WEu5suzgwjNPRtPfGM0JilyidCIP01H9HXRc8PWzsqbMSjOIXklT/AcsuajF
	 aAqlfKA6bTBrfCN7WsMUAP0oswwQxcaROmjMUe8LETkWym2YrQ5+ZpbuoZ2J1qtpEk
	 lDSvWJK2AN7xuZgMWV6hkbb7sR7+tpPsg0TdXAMgjnq+CNnj+eLE1XWTAZdMykJQrk
	 +hjSknHB3Yedxsfbb1sM4Hov4RnUL70z1vBW0mLSooAaESBqDhEdu8qZgZXRSL4Mk0
	 +ooPvqhCL/xgw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 20 Apr 2026 23:03:16 +0200
Subject: [PATCH] docs/mm: clarify that we are not looking for LLM generated
 content
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJOU5mkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDEyMD3Zyc3JT8ZF0jw6Q007TElKQUszQloOKCotS0zAqwQdGxtbUAIqR
 GZVgAAAA=
To: linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 71249180014
X-Stat-Signature: ays7yppeup9dkfqunbmtprumizd4z3o3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776719006-370879
X-HE-Meta: U2FsdGVkX1+gl538rCp/8+xLtfGOb7oSpTcnGo4T6SV3cKvFdLWGKlIhb0cI95E4/c1CkONpS57EKGXY5IxAxnc6B30C+m+Dkw+fM3cOKFqSeWxJ451et40o1tamuiJpjkf1k5ZlYJIWK6DORTbyOG8iEUc1r2HRLVX+25Aup+ykpeeLlcW5OawWgAX5fSWFWr8Ln1IlXqEqdw6OH/Dgae1eyYzVnjAa3l5zVxuaGKztnZg1HOjK+7ZiFPUnejuyxHA4BNBZVF8NIRBYyaXsRM+mqMtPRrmFA8N0OZwm3L1DlO/7EzN/GDSikmxxRJZSU5mgbb0jwAP2cqYjY7EdsN+Gxs7B6HP8/RVbO7akADxrClUrRyqX78kXwaWKTuR9b1/2BLBM/Ho+VWEtuG0WveVUfoCsTYoPL5u3GRZAdACog2NLA+c1Iy7rCQACwQ9AryD7LF3Nz55HoATm3PbLamog4SBv6X1MyDhog84//h5gur0k+Kosv3b9kYNme7xEKZ5pHQbaT0H1eJMleV79MxzQx5gAR0e4BusWQePu44d3Ho9byxjyyqZH7UsrN6+FyP3Mjb8/UzN91zw7EUJEbLFPDjD2JAdnoNDX/jheo4OCHPhiQ/hcYJqtwaJD+fUvOtphriidyDEXJyLmSvH/Rs2NDsaNYoZ/ClQOB+w2NAeBuAJ3Vc/Jb4cNGTKKop92T4FBBCtNhDnpEeJyfoefPg+QbZ4wMN9Dka3tUnPiGKoGJ9pvHa9p25KK1midJ6ieDZX4nHdY6A0Xym3ffiHfuVmWAqcCj0enO9nGQwK318FM/oN3of2tijAv5VHT+fqvJcldQr26T2wWEg9Qw186waVLkRYST9iiIb7r9/tyysB+urTjuUlyrVEOBJr2Wql4byAdTxW40rm0jv3Kzo/fz6gtme1UyaOV/T7E/HIwTq043HAEXgspTZIuaSee7jNScRsPqJCqnR/196PKhWM
 6tGMRbPi
 OHGKUQyu83LPdP5fhrhmZFqldbLB3nz8/p2/6InGv3c6LvvYiZnqkBP4kzNdzoh1PQNDD7rI5uP2nXtiQZ4OEnUvY7c2hekHpaQ+5L23qs3CCHdrLziUGadcPoZE/uOJBHieYoyon2dLeMS5QSXj57+gC5SrWkexmfHKXbHA56tPOS963lKQvGP/qOFwPaYLMP2moywkBd7HlBy+e/1bzrifWOk83qwpf9vEuOhuKK0773PkqGAvl1UWxKBFdB7ePg3mY6gys7RWREX6qdyTYNJdk+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's make it clear that we are not looking for LLM generated content
from contributors not familiar with the details of MM, as it shifts the
real work onto reviewers.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/index.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 7aa2a8886908..13a79f5d092c 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
 see the :ref:`memory_allocation`.  For controlling and tuning guides,
 see the :doc:`admin guide <../admin-guide/mm/index>`.
 
+.. note::
+
+  Unfortunately, parts of this guide are still incomplete or missing.
+  While we appreciate contributions, documentation in this area is hard
+  to get right and requires a lot of attention to detail.  New contributors
+  should reach out to the relevant maintainers early.
+
+  This guide is expected to reflect reality, which requires contributors
+  to have a detailed understanding.  Documentation generated with LLMs
+  by contributors unfamiliar with these details shifts the real work onto
+  reviewers, which is why such contributions will be rejected without
+  further comment.
+
 .. toctree::
    :maxdepth: 1
 

---
base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
change-id: 20260420-llmdoc-21bf5fadbd6f

Best regards,
-- 
David Hildenbrand (Arm) <david@kernel.org>


