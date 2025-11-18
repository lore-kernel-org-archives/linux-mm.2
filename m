Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5249BCEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756338E000D; Mon, 17 Nov 2025 19:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7070F8E0002; Mon, 17 Nov 2025 19:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CEC8E000D; Mon, 17 Nov 2025 19:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 516398E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:06:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 024C612E2D8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:06:03 +0000 (UTC)
X-FDA: 84121785048.16.B5A4938
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E4FA1C0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:06:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA5b6RS7;
	spf=pass (imf21.hostedemail.com: domain of devnull+david.ixit.cz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+david.ixit.cz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763424362;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UXmXuZ4pECPeQqy3o+lTuH3pl0EXEQ+j6P92s2NRBNo=;
	b=09RMMyy0iMwSeXOyHMelperr8AbfLSyr7eV9+ITPPucmSq3ncIgjR/Rzuvdde5hy1YDIYM
	hos5VRHDyjQUjRyIC7DHRgCVon7ChvEgm/94y9LTLFKNkOzYNZjRb4zdf1B8ZQcJPIKtva
	cLxzPH0bXlUS+XJvMv5iwmvuZTsQB5U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA5b6RS7;
	spf=pass (imf21.hostedemail.com: domain of devnull+david.ixit.cz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+david.ixit.cz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763424362; a=rsa-sha256;
	cv=none;
	b=2avZ2jq13SsP7n2b+P3S/bnsN/92hFOZlAbXdcDgo0yEVbCIxRfz4OQ5o4Ink/0VEhvfKu
	TLR28nOgCnMPboWFRHtfLyXzKh6cliZkCIiL7AP6NXn6pUJUORVLc6coyW8Kt1dhw37LRN
	QObKhsFKh7JFYQhLEd7IpVdbj7BVsk4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44B4B601B0;
	Tue, 18 Nov 2025 00:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA85AC113D0;
	Tue, 18 Nov 2025 00:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763424360;
	bh=idLT3Sl3hq972dwsE+XR7Moq7/70O5GW00jrAtyDqL8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=OA5b6RS7emS/mHRyEnDu1izqu7MSozCXz3w6g2ripeMt+xV8s8GdFrWIUB6CLuw6O
	 dZzXcgnCwxv+s6GDWpwdNTmp0zld42SRHL7oSNJ0OhYiZX6o1NWlXXBSgcDjpw9fQc
	 AbBYXBq6FGTQcBnB/R7E/czQxCD4v1HsJ8hWbJKzFrJaa7u0PKhujCUf10mycFTlyD
	 lqkuPIBWv7XXdGXyZ/gagYTzuLPiS/cLbknNp+0W9di5vbKjDesmU9qxNxIVwQp/Bf
	 gm6H8oKfnRJ8AYjnBPPwRDNRLYywO/DO0L9WpyrHWSrTI61jXcHol3UTWEZP3SKjDU
	 tZ0qdAGKTa1NA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84848CEBF92;
	Tue, 18 Nov 2025 00:06:00 +0000 (UTC)
From: David Heidelberg via B4 Relay <devnull+david.ixit.cz@kernel.org>
Date: Tue, 18 Nov 2025 01:05:57 +0100
Subject: [PATCH] mm/vmalloc: warn only once when vmalloc detect invalid gfp
 flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251118-only-one-vmalloc-v1-1-29f8eacb4605@ixit.cz>
X-B4-Tracking: v=1; b=H4sIAGS4G2kC/x2MQQqAIBAAvxJ7TmilKPtKdDDdasE0FKKQ/p50G
 ZjDTIZEkSnBWGWIdHHi4ItgXYHZtd9IsC0OspEdIg4iePcUkLgO7VwwYhmsUn3Tdr1CKNkZaeX
 7X07z+37nDonqYgAAAA==
X-Change-ID: 20251118-only-one-vmalloc-b8d997045791
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 phone-devel@vger.kernel.org, David Heidelberg <david@ixit.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1266; i=david@ixit.cz;
 h=from:subject:message-id;
 bh=+3LV6m3PqRpzFWM6pdP/J/h+Ov5Mmi3IXlzFVsT12F0=;
 b=owEBbQKS/ZANAwAIAWACP8TTSSByAcsmYgBpG7hnPrb694PSAtJVrUC41ulsIGwk2mg7uisJn
 XnAjQL2gKSJAjMEAAEIAB0WIQTXegnP7twrvVOnBHRgAj/E00kgcgUCaRu4ZwAKCRBgAj/E00kg
 cqr2D/9RDSNedfot2LwKkIjnQ1JC5RtS0l4ZwgScYSeT8uLysnaMH8XbHHvgZ2HrEvIvSi1DmYN
 +lRq3yAQDBbAZGPheBtnhq0KR4Tq1vUMg+VUiTjjESM3aPuNZDVTzHSmdFrKNBCq21Rmsa1zCWa
 BXBoMKH/u10LIAn5cYYim3gMZYeTPL9lSsAbIkrnIkWFQnsZ8Gg7xm+3j4EldkLpWYwR2m+NL38
 jsUBtlCxTukzD030BYcXChxL5vTSUa5jYxeZm9l4h5RP8/6C159fE9EJjSI3KVjVRHO8/9P5o/P
 /yRU/gvp90rpTY6iRdMaFhsYcOxJXeCMXvyTJ6tGKLH4b0rP+VicjBzf6rzXEFKAelUEX6VxY3K
 7qQ0a4KdV7Z7SFOsShotfcZpgH8HWKX5dJxe3wK40Fue+1WzmLfo2gXpf73pLk6/xGjDnodbLem
 Hl9s9W3jnlpbKr7fMbcfW2GSDhK+okv4u84GPYIIK5IMPBDxACjYgouhFxS3SFm8yZDTdF2QtBd
 +DsTlLuL7DaVQlhsYr8vuBxKhyTEkll3U4FTSznfMqaHNqnKBHHgJIecFWfPDoCtaLUPTSPkQ75
 bF4b45mzh/e5Xge43nUsHoJ8JQB/r9KIXXnjsKGLZCy1IGgwbmBS7AAa0XIcMGddxIXT++TFqu1
 ToK0FBKpdHKOnfA==
X-Developer-Key: i=david@ixit.cz; a=openpgp;
 fpr=D77A09CFEEDC2BBD53A7047460023FC4D3492072
X-Endpoint-Received: by B4 Relay for david@ixit.cz/default with auth_id=355
X-Original-From: David Heidelberg <david@ixit.cz>
Reply-To: david@ixit.cz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1E4FA1C0002
X-Stat-Signature: zzibs476azweqrbr8cg1bbikspqn69w7
X-Rspam-User: 
X-HE-Tag: 1763424361-435214
X-HE-Meta: U2FsdGVkX1/M1UjlvQ/19AO9d/K0br0IEBvA/nnDSoJ22meCKYjiercVHs+r5aXSd2rBYm/8oA1nPdAJ01Gyp8gFyl37c4v2KykBaKsvewNFKq2TXB4AAsnQdI6m317XZXfpVbvMlFpx2mF4MssnYwykUNxP37ZEUR+vEsGVA0/3CC9xiZAVfnn94pqaHq7XSlMSr+21u2RNbKxmTNrkK4VOplpAgzcqFVMi9imm9r1derPBLn4228dDjwF5rH4rZH+SNNvJcitbHhSPI1sywKuK0UJetCC0ITeF8PQt9OxtftHGheSE4xbgKjvKU8znwDcZsbpf41Bw97T5L0QLtntgYvwE08pkEaPhvTUqP75jYYy0RUijLjQMYvaMBGivRQB8ledrM23c+Gt9kuNIx2YKYX8dxyUGGQKWaKmtqhJ+YRXwXJWBy2Jio0o1pXyWCWF4c0aXe/jCzwCEZVVAwlY3uwr+iBNAD5eX9yJrwQMtY1aqPsgp2KGQExHvuz4cnIPAmFYTyHzVCMn8zcS5o3OLsKOfYdzgZYcaKRkvpmx6m97mfH27D2oxpmeGtn5tuQKF6S/kDxi7orsNfznU3gQVtqoa0bqBf9AWTjcw1vunT0XvDa1CMUpO73Dqt4JbGaDgC3Gksd2AQPDQmavIybkkAdhVvYKKezLrC0Cw5IzzCvm0B3g7eg+EqWo6FK8ag+vTaVwSYbRfFmWckUIT0kn3QsthwE52bYEb4re3Iny1IXq4rb28ClNkk2OoWjP0tHwlZB13/Ms36ZflkXsTzRtWIUuNOFukjOi9wDpXViHVSalbfS8sim0yY6O0oQ29T8cFn7HH5KYJjGaL5UPT8w4iJS2Hlm4nF+FN4O/psnOfAbB8BPha5Cxb30wV+FnJalkhgcA5vSTzbs4BhYEfrRqNPAzLShsbXI0/bwqk/KIgGmwwziuON99L+duwDOZMir/xY+77lyhY2TPslmv
 fEALztYV
 i+DkfRYfjJcSr3qWCAz7V+zQQoDwyvKI5ILoFo6Jew+9/Su7zRShMhryvYfEKmNjwBPn3VpLoFcBkIFZ4J6HtwbxSHcsmaRPwdCMSXn/5SSMt14V0GPF35zvoZRy8kHv/dn8Wu951U3W6Edp9BzfZr/FmAzO8R3mZ1rH5mjfGkZBM3DKfw7tDtBEQ4Wp82ftU0lzIyU4yMHjAHXARXyeYJgXBBfk+3Y6lsQ4Ul6scfiZOVItiOtITe5yp+Wz1uqfacFOLN68NdQAkGQk8dKCAzg4lYQOCWsR3/QCFoXlqtCaCyG/8DLPmUIXzDToPyKXKFFg4EtP3xa0RzUi9baR+4soz1cPDt87ACPuuoHD35oAcxsvxvdhcorxBA6UAaxLk4UCKUD57ugw8K75xoqIfkZ579etQ/nK8ECy4gzrXKYfGuXnGnmBfQ1me4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Heidelberg <david@ixit.cz>

Without WARN_ONCE, the logs get spammed immediately after the boot,
on devices as OnePlus 6T (Snapdragon 845).

Fixes: 7179b2256315 ("mm/vmalloc: warn on invalid vmalloc gfp flags")
Signed-off-by: David Heidelberg <david@ixit.cz>
---
I'm not 100% sure this is the right solution, but having WARN_ONCE or
rate limited warnings here helps a lot on devices as OnePlus 6 (sdm845).

Please let me know what you think.
---
 mm/vmalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 49e0b68768d73..2a3ee17093d6e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3934,8 +3934,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
-			invalid_mask, &invalid_mask, flags, &flags);
+	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n"
+		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }
 

---
base-commit: 0c1c7a6a83feaf2cf182c52983ffe330ffb50280
change-id: 20251118-only-one-vmalloc-b8d997045791

Best regards,
-- 
David Heidelberg <david@ixit.cz>



