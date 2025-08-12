Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E325CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD578E011C; Tue, 12 Aug 2025 08:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26DB08E00E5; Tue, 12 Aug 2025 08:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135A58E011C; Tue, 12 Aug 2025 08:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F27428E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EDF3822A6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:59 +0000 (UTC)
X-FDA: 83768090238.22.6FA94C6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAE391C000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZLr2Kazo;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrTt3YvXHtYUuoIddMbmkc8QXtgLzrL59sgxurx8fJw=;
	b=Whe7O5ids/dmrCg34/2nK8U9ZVpOLQ/yEpgfYS+fUyzQl5RLrnMhSPp015VU+yLpgot17W
	eWSubv6nUgPHCwD7TWZfz/9AKggDGK1lnaslHkLLcnRH/slcj+tyQZ3U6VIbhziqdYUEb0
	qV5Lx2ochAw71oJ76ytcCvkEAGKpE30=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003057; a=rsa-sha256;
	cv=none;
	b=R+SzzSJh4hZ17zyueVNaRMJrbCbiAsBtXZ0JZW4mROeLXPHyv856Ii7jx2hW2FNk0UuMnd
	4VnsW8y5rQXnvzBP4LOVE4clpULNnCv8AqF+hUnzt142duyM/UeWaKneEda38omB5yA1iN
	I0hAK9+fYRjr50uaniASxDc5cuh9ZxY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZLr2Kazo;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755003057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrTt3YvXHtYUuoIddMbmkc8QXtgLzrL59sgxurx8fJw=;
	b=ZLr2KazoO47gTXMnjlYGijCqfEdxAcb1emY/jcxf5hat1bZRGxtJdl7M7+xbBqS+f4fDMm
	Lhp6Ftgyb04dsL8SgCC/YUMlVgvLywnC3QB2Oc1MbEjA1MW9QpfkZSvvQsVaSzSGgDgEV3
	babjm4eIKkBcLJw8/d5Uk+tCoDd9H1M=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-IghP0uCBOV-OwVmnG3ieZQ-1; Tue,
 12 Aug 2025 08:50:53 -0400
X-MC-Unique: IghP0uCBOV-OwVmnG3ieZQ-1
X-Mimecast-MFC-AGG-ID: IghP0uCBOV-OwVmnG3ieZQ_1755003052
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E143219560A2;
	Tue, 12 Aug 2025 12:50:51 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.156])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F13630001A1;
	Tue, 12 Aug 2025 12:50:44 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v2 08/12] arch/riscv: don't initialize kasan if it's disabled
Date: Tue, 12 Aug 2025 20:49:37 +0800
Message-ID: <20250812124941.69508-9-bhe@redhat.com>
In-Reply-To: <20250812124941.69508-1-bhe@redhat.com>
References: <20250812124941.69508-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DAE391C000E
X-Stat-Signature: 6jbsshj3n7dfa3o97knpicbcw6nyqb1h
X-HE-Tag: 1755003057-462094
X-HE-Meta: U2FsdGVkX19GxzFFFE7zI6ka9qcMm3OeSADNzYgv/RNo58XzSYfwUiWpkWQjvCV36emrgl1+elcdkLmU4QzRPTiAGFkeWtaRLZ+9+k2RUCgampuk6kMWVb2WO4u9ksQnPO+lt/OxBTmuobWSqPXRuZ+JgwdIwQUz00gZ2N7J2/c/064OiiBvek2Yw/mR3Bt0LujzCiHHLWlST6YFy5cdqtnIuVa5fP9TiT4ZM9X4lRnnYQjfKCjNK3t8DkA3MAc6n1gztD6gOFOWLDQBOArpMCyIo4k/bAy8Q/D1n2Jw8OEedkBfFQRg+o3Wol1ZG6lWG5w4lBS0pK/3OM4AnaT1FyZImQQTY0z9PNQlTUDAOcjt096e2/D1jY+nvkHnshqWHiIR2mGWG0PrRufOdhfp6V+8VW2cIggOiYXIM02DTouHYeqzakUMJKauHsMnNQ1pOYM8Hh+Fe7jfxYHpyAjR58D/rlXDLXjBqNMgr43ORrEOFnxmwKQ9GzEDUAdWqvrRMBG3KiSogmN/+IArSEBNhZMw3IsxV/v44JflMs8eCYoHgQJW/hpF10BMhRbbqxzEjB/wHWwKbv3nyL64LxDL+Bj9W+BCAyNdzCRQpNxnmGG0Z9Vh2pu57novA2IxFKWER7cns1yZGSdyMmhZbfk1VbeClNUuTSukyBQ9oKde1MZdU1Sn29N4fYwIU3jn1B97s31Y8y2jLw4bRZ6m3nRg+qiKAfmAXX6TmsF8SrB2LrwQzVxvrveqbz7oW0H+DPEzgSXJlCGnRezCCrESeHE845Nz1mmL62TptsLKa/fw322MXU+x1iPBvSfCBe402BwzK/scW4I8eod2PW4/tGcVt2qZk1L/iRhrl2VZipSqti6cplLUu1d9m9HJiLexj/NtwAFn/Qj9Y4P9LYbQT8GoFnD/yioioGTpN9xRbs9wNQ0qior8JfzQ3qWo+oMw0LmXXNkCiV60/H8qkJO2Zp4
 0y99RAqX
 ERQhoSJhTT2A7YG0TzkBWDiotlMxjJfnDXMy/9mbyxFf2BI6TSz+DKndHK0mjdgQ1wcOcH3IebIrBp5tnHG24kaLBu/0MpCkrjGSMnhU6KsnhRe4DYTmeG7z+H+M9jd5KadKQv1vNUQ8V11g86isPNJ2CdzmmHUspTbnwMsBv/0zNp7qbOSLoeAbVk49EIcLHnKfRUum5N4kPLy2845ZOjs+fZQAmcZv6p9XHCrCG5XzBWgN5K+U993MxN9sHF9uWUspTJX+NB+N+LppYFKYakuFjEmGdvA63chphGt8l6o5h9oUnkycToYP6D4YTjOTT/oNb0g1P3TA5QVC98cQhMP/1WeCtUwTgWUinVz+E951452bkFnFZZEPQkSrSKdfohrqZT5QhMDjqsEzxHwQtx2wneg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/riscv/mm/kasan_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 41c635d6aca4..ac3ac227c765 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -485,6 +485,9 @@ void __init kasan_init(void)
 	phys_addr_t p_start, p_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
+
 	create_tmp_mapping();
 	csr_write(CSR_SATP, PFN_DOWN(__pa(tmp_pg_dir)) | satp_mode);
 
@@ -531,6 +534,9 @@ void __init kasan_init(void)
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
 
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
 }
-- 
2.41.0


