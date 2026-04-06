Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A4EEF4EC8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC676B008C; Mon,  6 Apr 2026 05:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EA16B0092; Mon,  6 Apr 2026 05:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4766B0093; Mon,  6 Apr 2026 05:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A763D6B008C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:09:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67E5D1B799F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:15 +0000 (UTC)
X-FDA: 84627557070.25.3F9328C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D62ED140006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvLRVcEw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775466553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8dhWLz42+r4c1CmT5OkJ0Z9ttDF9O5nqHcpc3xqLL0=;
	b=PyGB4j3Q8wxbzMPkktXy3A7qE7u6VReKGY/sfiYfZMk30SxwdymT/2n50e8+eFUC9ORzTi
	UcCzFazeo3uWuf1RRV0ig9u0SH5hJe2/SRnjNRKEZfE2hBRdbgnnAlG7aKlBSwKJQn1+Cs
	0OhgcbQ6CnwLqRlvyvUkT7xdiLVMGVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775466553; a=rsa-sha256;
	cv=none;
	b=CXtJ3P8BL6nt6FZnghYYEXRql3erj8bIWoZMpBKIQ5QBGqLd0GHeG9+TSEkT+y5SvEIxAf
	QdB6eI4b1DAnEl8srj4d5Xp84/o54p2DMvMsJFzvsnmOHBtzhNEJSDJolonEJRxUgwucPv
	Hbmz5TFCWL45ipBV8d0MQYpV2z2qJ14=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvLRVcEw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D73360121;
	Mon,  6 Apr 2026 09:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDC0C2BC9E;
	Mon,  6 Apr 2026 09:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775466553;
	bh=G7Il7/mKFzoeV4Tz39MRaOQuT1VjBgajncJeVtLZGak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvLRVcEw7NVelGrpfAYeykd+hge9Xt3lweLjfyls/etqVow+h0lV5k0m0bjpyXojY
	 b/axaFmJkyiAVkRzz3IzbL5MVs7HUfLGKaLqBEnaZnUroPvY1B1Iqdl8zpcGVXZxt5
	 3sy7lcrRSwohEFIqn4BKY3xghHjSPBF4lJUXIMpWfqZrWC3igtKJryOhkuG3X/Naxa
	 PW/i5N/NRrYc0Wq9LBOe7HLd2wZbi8E63jjlDv7/8RUAxr22LQX33GWoECecbdnHPL
	 8ESPRG89JFOuxjF3W0v8qNZ3xA/Fzkg5LzoToKqMv8tobW8uBmtT8snojC/6IZ4Rd/
	 VfEaH5X4W25Lw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 1/2] MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
Date: Mon,  6 Apr 2026 18:09:06 +0900
Message-ID: <20260406090907.11710-2-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260406090907.11710-1-harry@kernel.org>
References: <20260406090907.11710-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D62ED140006
X-Stat-Signature: d3n5cqxofoy9f437z63yi1td3nyjidan
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775466553-424659
X-HE-Meta: U2FsdGVkX19W0UlA51VlxVdj8XS6/hbdbfUBijzuP8t2Soi8FZDfWmIzoYH+C96kETencvDsVOVyBaagWEng5wyBB3o9e5jh7oCk1HZ372G6SyR2Tc+h0NmhDsFSqbpPCv/Wo8bSc/eR8ByaSqtXs7owYmdKsLpzdF8ESl85ueIKt35OTmqm+usG7FnfbBpzVGZ0JWy+6CuQ0ZX9kyxezQ4WYCGCzrW3ZZwl0dZEqdUOu+9MlzQMZJJWNq+vBpdUGDp3HnRhPXXEWIg8NsD/zrrNtWw88lEmKd5IRShp1oF6fLHEg2KXxDfOsaUwlX77p5G268FYrtb+zvLDxfwuZXLF2i+pdx0UouP971q7BtfzMI+rK12yaikr6ZySKdQAnsPKWgHtszfnHxwXu/jVQAZzoN223IUReO/m7WJ/mV3hlLD3ni2bM1+9KYj+8x45GgIxp4Jl/umi2hNOhdZyZGtpXQwmuuGKg139jwFKENCUmcjF0o/0GVaQCT/pQtwt2ipcKQEYFQfGUM152n8UVG+gqKiRbztyrTLwdfwKCdtkFOZrqSkgS5WmAKbcVRmYyooRRrfnWFq7SJH3bpVC3ytTvFHwn9p96iRh9EnBR8JItt+ZM/RWT8LmQ9ygoYD5eJbLw59iL4H8VOBx2TCE/ldQwYsY5wJSTwvdE06ZBnOctQbdVvAZ+5xOCQ14zhK9UYwo/Q6y21tfYXWSMETrV3pwPhc6qP2JZdqCJYiqwWqs5JblcYIlxKJCS5MistJ0/XEkTcJxah/I6OZDV6UW0oR0pQQwYEkGXE/M0g+cdlulBMG1sDHg9/rafsEczonUgsR1TKAd4R3I3NxgScL26y+3l3Mi68qwLaweqEVMkts2H83QvdUv21fEAEKwyxXU9R1l0ZMolagzZCH2qft0cu/AoshBgw9bnt/OMLooEABEDeSCoNt76jXnShqMJqX1kxITcboBAFQHIdTa7/6
 p79HKbrU
 jy2ZE3bWYU0N2iVjgHZ4DaATQuWACJwUkML9LxxTUbwMaRMHrPoAiO38Jy7+TXntKHKjQaZ9AV7QR0sTtiV1LWeoJwq2CiprISHjd1IXveNTYtArznOQ4I/CQn5R3c9Yl0wbxjM3u3s9tq4Vudii8Y9sGH+VBeNYbjvm6YhzQr0LQpJbDTdgrcZyEzCUOluLBvXOwotX/nIytjlKVHvUp2PUqAcWhLzfcQjEZeK+uU9RjE6fzp08D9jge9CqdKAQWN2KYCnktFYmcJlmQf6SsLfxYry27rq5ameWr6WuAOPg1h4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slub_kunit module has been maintained by SLAB ALLOCATOR folks,
but is missing in the MAINTAINERS file. Add the missing entry.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 96ea84948d76..5f5add4f72a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24354,6 +24354,7 @@ F:	Documentation/admin-guide/mm/slab.rst
 F:	Documentation/mm/slab.rst
 F:	include/linux/mempool.h
 F:	include/linux/slab.h
+F:	lib/tests/slub_kunit.c
 F:	mm/failslab.c
 F:	mm/mempool.c
 F:	mm/slab.h
-- 
2.43.0


