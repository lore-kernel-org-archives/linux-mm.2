Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E504CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75F766B03D5; Tue,  2 Jun 2026 07:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737AF6B03DA; Tue,  2 Jun 2026 07:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675356B03DC; Tue,  2 Jun 2026 07:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55A016B03D5
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:33:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB9941208FA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:33:04 +0000 (UTC)
X-FDA: 84834761088.15.4F7F28C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id DCFAE2000C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:33:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+oxHKPO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+giorgitchankvetadze1997.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+giorgitchankvetadze1997.gmail.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399982;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oIHE8G9xS3k7NqawNRJAvGgH5ArThZfFUa6EHvmBop4=;
	b=FhWlb98SRAcfQ+0xdbZp+nEl488XK48BQu/IbkGs456v1TKsYX1yOYFTFE/AahFUdTXB+z
	2EoWH20GhhFB4Q7qC3yL/WvjX8mgaRvbVmGBfh0Dc2rpjUESOUzWPQvhWJUYfhFRdGmjyI
	GtO3eSx0fURGZSdn8gV5FTv4TneAf+o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+oxHKPO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+giorgitchankvetadze1997.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+giorgitchankvetadze1997.gmail.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399982;
	b=DoQ3ooMGBx+69UnjgykabpHGKfpn8YVGj27oHtFS89pQVCt+cF8dWy22Rj1uGs/XdCMzWH
	jCUuXY425mWL16FAvB0RNry6PF2Ugsstx6kKxCGyhNxdnkO3aPA1JVhQMCp72mPXavg3Xr
	p8qvwx3hN+bqIoB/CakQjSbZTspmPVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23A2141B42;
	Tue,  2 Jun 2026 11:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDC4BC2BCC7;
	Tue,  2 Jun 2026 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1780399982;
	bh=pd8JOVOEz4rV8NNE4PybzDB11MHSxrwTkh2Jz1uKvD4=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=G+oxHKPO1Ta5pQhT6k4krHVW+9Z9XQcIXlEkazUwa4gXIZ5dcBVGhVxANafzANVfZ
	 beEW1vKPsf+L39Z+cPFMRyhUr65k/31QRAZz7zxwP5wHAwegc2CTYUPHBD0ke5qSWs
	 RVVe2Dn340xCncvUQKHmWOh6CUKuJ+v48Tp3ePL5Ccak1PA2/kbr3HFY4YlQmpeoGe
	 LOm2DjIvpQ2lnN/EAS9Wmd3tOkXhg/ClUnYimbvTlSs1wZCiMI1v2MFh0zVJLyGbJ1
	 nu+gdFmTdntlvD5oS1uHIyLVB2SzJqpxi8nRACjWz6HTPKBNvjN4WhdUgsg40rpVRL
	 g5gKSyd8sm3Fw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D750ECD6E5D;
	Tue,  2 Jun 2026 11:33:01 +0000 (UTC)
From: Giorgi Tchankvetadze via B4 Relay <devnull+giorgitchankvetadze1997.gmail.com@kernel.org>
Date: Tue, 02 Jun 2026 15:32:45 +0400
Subject: [PATCH v2] mm: mm_init: use div64_ul() instead of do_div()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-mm-div64-cleanup-v1-1-bf5d67d89d93@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAMAzAviI9W6hFd/Ar4mG4qgU3x4ZDEP/u8
 BhC8kCWpJJhbB5IUjTrGSp0bQPLbsMmqK4yMLEhQ4zeo9NielwOseGKOJB11dLKzkLNYpJV738
 5QWGY3/cD8nlNO2YAAAA=
X-Change-ID: 20260602-mm-div64-cleanup-50ad2020f2da
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780399980; l=1366;
 i=giorgitchankvetadze1997@gmail.com; s=20260602;
 h=from:subject:message-id;
 bh=J2B8gGLDwptZpFtucevPEHSpg8qUokxrjp8b+S4c/dY=;
 b=IHwk3v2WYj8xDPtjn66FVDPMkmX2ieJh93XUEOtNj8TQxXIWSL2vr6Zkn7vrk4523G/Hpp2WF
 FwFTOOWtAp3CXDFOFZchH3Tof7Jyj1gdbiBJe9KWcPfbUA9GJuHOlOL
X-Developer-Key: i=giorgitchankvetadze1997@gmail.com; a=ed25519;
 pk=D0cYZsZ7i5cTf2kRt6N7un+iLfmUPM7OwMURPmVnmEI=
X-Endpoint-Received: by B4 Relay for
 giorgitchankvetadze1997@gmail.com/20260602 with auth_id=804
X-Original-From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Reply-To: giorgitchankvetadze1997@gmail.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DCFAE2000C
X-Stat-Signature: z7bodahgkpkdjmny4p3esthbmsuyqce5
X-Rspam-User: 
X-HE-Tag: 1780399982-206619
X-HE-Meta: U2FsdGVkX19PEjlC4+y5wD0huNmwMLXxttVhrTxAbbA5nYn6Q+PlRzf0jrIYmVbjZFNR00yubw5D+KZlL/+nmK/y4oPihxaPxr8y8gRO0CpMl3dYl+NFK4g7LAdY1WQn7656oW9+0nMkqVSPZMHnToiV/K00oi523sCYu4X5glxO8GyRCopGmXbGEIgMfqtnbcBvknPqcoCRf8vEGdsZgEJdU6Qw7WKfAOkATDs+sRemS6Puw1OJAHCijOSgnlf0JCTjxqFjFJNPZ0Ke6hZLquVNldk2FxQ9M6nOBu1NexyUr+2EholZ9hTQgRjcXEkuTe2Ww/iRj+fBL2HXNf8bYSCSMLo9JLNXXYmTu77BUABoXRsuc8UpLlLpslXb/NhTE3IeSgwjb92vLFPyTQmaPOo+8LXUV2ndYHpcZ6KHGItL/GMtDXLi9/kmVZkl2lN+wc9G3kzGhY02OPwomHoHxY1ME0VzTUuaCjAy0SYTfg/PjaMmvTzr1gGiSoPub1Ln5DOK0OSrzKg7ehjJfuW34++YSrknonClfT8E1tqr1H9aI8XuA3Rd9gKwLWRV5H1ET7rk6Dfrn/D1a2FhOrMdJcnTVEO/f4kIq67bJwVn3keuAbW9STF8pppfmwbn/MAGM3BB3qT7PsZnai7Tbip+S41OqCEXul8HZ5qoerssTZKXRrAHWHUif9G/WwqdD9qGaxKU/cCTM1x6PJtIvj/q/yXebRvQV+0xhemhHI7LQn8OiDjYywZpAG8Cmlfs7RiPR4QogDINvycprOGhdbtvvaiC4ff3jBc6R9BtKzHr2ojuVIOlDKatnfKaD8Uz1+QB6wMn6qBcZYtjak/SsAYf+Vd5eh6EEZ0+PF74vmKThpw/07VtRs8yT3z1+FlfXIqZthvVe6Rf4ZTfWPuC9ZBurKXL4rWdJJ46AJPUAH24CHt7Fd7U4pa3txAPTmToIX0FkXygvzzbfTqvObl9NWA
 9pJ3NaTa
 ohRz3zC2G5IStHJ+aOXui6PlGozpv71YDb4dnp1dLoKsxyNCcju5D9h27GhrrRmx340bGbUd9EKHlw8mYOnADv+kfmzLMOUNUecN18LiokgGRHv2VlNQjn27X8Zewvot3IAFunN+TSpUCDkQ2NaEbsiITS0ZnaM9c19jcnj/rFLXOrYSgjYZAKfyurwMj8P8xg+BJsPdrF3nh5viJhQVrYvOf4V3poe2u4DCPwUKuMe5C3r+XN93A4Nrvd/5/ivFNNVugHI5cmhiH3k/4OyazaIbwQUtpAI+T0QP0RlXDej2cBt4Qz4GydfuimY3AlHcHkJdvOaHsy4iyiWjj7RZ4ue8kv2RH+YwpstNXpi+jE8HwXW7QbvVg7KYeU5wDvywmj9ckMof1DmdgXjW+HACoM8R52Yk281WA1Pc/rknlVJmd/KsQMV2wmhIQpH3Lzbgv30EwdKDOlooBrgsPqVmfi9jh3Gz2Y1R4ozKNFioikQ0w4XKtbiFjhK3ks2u7W+RiWFKdmcyvXDjM0L5yTyB8LCIP4U8u++3Xdt7GKst0TDS53iHi+woj8zAMHA4/pKSdz6N5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>

Fixes Coccinelle/coccicheck warning reported by do_div.cocci.

Compared to do_div(), div64_ul() does not implicitly cast the divisor and
does not unnecessarily calculate the remainder.

There are no functional changes. The benefit is purely a semantic cleanup
that better communicates the intent of the division and resolves the
static analysis warning.

Signed-off-by: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
---
v2:
- Add changelog text explaining that the change is a semantic cleanup
  with no functional impact, as requested by Mike Rapoport.
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921cda91d812cffdad2f1a0698cfd6ac..4e0909a721d227b097653ed6aaa019960a7c3383 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2412,7 +2412,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 	/* limit allocation size to 1/16 total memory by default */
 	if (max == 0) {
 		max = ((unsigned long long)nr_all_pages << PAGE_SHIFT) >> 4;
-		do_div(max, bucketsize);
+		max = div64_ul(max, bucketsize);
 	}
 	max = min(max, 0x80000000ULL);
 

---
base-commit: 6f3ed7fec72fc8979b2a8c7219c0a9fcfc8d07b5
change-id: 20260602-mm-div64-cleanup-50ad2020f2da

Best regards,
-- 
Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>



