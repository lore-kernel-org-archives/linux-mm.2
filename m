Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 800F5C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529246B0098; Thu, 27 Aug 2026 23:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2B16B009B; Thu, 27 Aug 2026 23:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC406B0098; Thu, 27 Aug 2026 23:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1246B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:37:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AA04140247
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:49 +0000 (UTC)
X-FDA: 85149269058.29.7ABFCF3
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id D58FAC0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:37:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U7D8t3iF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3igKRagcKCC8hQPWTaPRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--wfelipe.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3igKRagcKCC8hQPWTaPRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787888267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iw1AZp3bUhdmNrIROh1eTkPB8qZz7RwC72kTx0xosUY=;
	b=xxsd7ZaNkYYneDKXLLpbHCdOkkFrjS1faIVzI03+9OBRPKP2ywboeIQZD2be3pNrjd7xBY
	cK3CtCjHdwa6ca+I+KDELtdps1zu5ej0YUa1NmqlFYEYLsqErUf8ozj9necq05CRSwpnu0
	VcgJkWO7v/+biOewH+9QUwzHm7KGamo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787888267;
	b=KubkhmC7/CrvK0y1Fy9TdXwUz/bO1rd/PnujhmmN334zvkHozexlwxduWToIxCB0/pW1IX
	9+OUiQsyoJ9yNN9q3tjFMGU/IxIOKpQS97PnIThMKjSbF+V1kJJznibLgZLKQwHuejWv2t
	6GrgkkIgDcVL2lbnULZyRv/KAFN8R+I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U7D8t3iF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3igKRagcKCC8hQPWTaPRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--wfelipe.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3igKRagcKCC8hQPWTaPRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--wfelipe.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6c166bafcso5379785ad.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787888267; x=1788493067; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iw1AZp3bUhdmNrIROh1eTkPB8qZz7RwC72kTx0xosUY=;
        b=U7D8t3iFZd69fn704qPznO7p1PoB2TU4785WK5w5+sI5xMswTEKvvLSnirnVI/IkmZ
         Bjx2Oq8hrXCr40HR0jaH61UgBxEblhWWjWKtWqNMPi1bPoyCto3dVkYNU/3sZ0qwvQfe
         PYcH04UwhfcJX5mM1E7/9p+VWu7TQhLr9YmjvKF2IqjH0pgqlXCcshMcJXpSQmjNFBY9
         58PYgB3xJ9depCUNydS84TB9C42ogyXS5dVDlqp0Hgseuvul73tG2IjaxsYpkLQciypo
         nPOKz18R2GwoFy59rHyChlXN8wvjoYAB+fUU3txHVp+DbHz+dQcZia0+EtLAYeQt5hef
         BBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787888267; x=1788493067;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iw1AZp3bUhdmNrIROh1eTkPB8qZz7RwC72kTx0xosUY=;
        b=BPCAliuyYpYZzYliRUUVWosKhdn7YVT3SNLKbe/HJ0dvuYGPBamD0ZIHMqC/XRSSPh
         r0EeZgSzifD7cGRoP/7Da+PG7VCednIltZUSnah3EXRKqQk0AlcWklNXv/SXI6N7znZT
         Ov0teFZ4bslKFBHxs7nJ3P65sRoJt4VNTC93mptD+jXJk5tvmMm5BbYdNIAH2OhsOcBy
         /03obBmoP0ZSgihz32fjg7ee5f5sIuPcUDJc17+1RCnxBLEy7VQ1BJ/ySwxI7i9LwI2u
         3fiGA3DXNgfvNVRHS7KvIx2SysVtLy6QafvzVAYmsNuZz00aVLQ89SzGuIWLtMM9ijFf
         ZAHw==
X-Gm-Message-State: AFuF++k9JKs1HJEACMeAs5BLZ8VKiMuJUHGvfuZrz7wCMgNMevkqVua6
	1poirgOItDnLZUPMkrCHb2oXdqpFaGAmubs+QnkcGV1GWfQgJpNiptK0G9wSc9jOvN4erKLW6zb
	xk+bj6TWGeg==
X-Received: from plav22.prod.google.com ([2002:a17:902:f0d6:b0:2cc:eba0:9e5a])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3a8b:b0:2cf:a108:7605
 with SMTP id d9443c01a7336-2d74ded6a9bmr72947415ad.11.1787888266459; Thu, 27
 Aug 2026 20:37:46 -0700 (PDT)
Date: Fri, 28 Aug 2026 03:37:32 +0000
In-Reply-To: <20260828033741.2184560-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260828033741.2184560-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260828033741.2184560-3-wfelipe@google.com>
Subject: [PATCH v4 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D58FAC0004
X-Stat-Signature: sjnhuct41ijhm6ppc4gherswm9urrsqg
X-Rspam-User: 
X-HE-Tag: 1787888267-256646
X-HE-Meta: U2FsdGVkX18+S0M3BOgVUkge7s+bUWA3bLhigJxlfayZwjVFGsq31HOtXclufBP24aEmRyB40Emr2U2lr0WHWAcQ80Fy/jQ9rQLNkRIXSbc93yKYmUNyjyKyhxhYP61TMftbmoTIAD6N8KsOICz0JqbyU23M7hlfHvW/KoIn0FG1diYThpAnJLKpWFz9CZGgiUXg5amxWQbS4OWqbUkmBe+gEPi4kGu0gJNKNaxEzUgIziNrPG+rpLHBrW3+6zP+ZYB8Ok4v3ltdhGXQSEdBEaMJzT7urJXGPWsdq20UPEWVDHsM3VjvvNuFuFmN55EwaE4gDVGoLq6LVu4V29+Rjc+9SxaDVO5pHDC9JAjKr266ekFeAHjfSp+8DJ/RMgRFhpNFsXmvvcwlNUey/EQ1S8k10lL5jHr9yk8X3dSrzoK2wG+tXDxSGdxnynQakMIzieRYnPQbE+GxyDVlJ43kMhi5YRhEBokQo+5G3Cn2YMONv0FI3zMkXs134y/+6na/fWMGG2CWuchzyfiOgfd3rxFKnPAQ/JLF62gTzlcN4OhD4FfFLfIS5LwpS++kYl+LUhtR1RxfkWDW8D64ssqgOj5u1712zE7tEiBnHY1+8RRdE4kRd4FqrSiJ3rhvmgC/0y+pj1EU6P17+9F167+UJ+gseVdHX42xix6Jm/RJRDmqqJq8h9UZxOKpAe2uQ4wvZPoFhqHkiaeRdI4eT/XZCChYNJbgl44Whs7mPJygXRMc4QVTzKGQ6ohPUrrFmP3ekD+7VySmDGh023OYnQejv7HcY6Hyi7rT9Ul6RlXuYb2hYJtAgR1RGMinv9uBz58C+8eGpDa8Hdd1sf/5I5vmALARx10G83/ZbdLHsmhd58RN7JfAKAvW1MfBZ9iCr0yiJOYNJI3dErwb4Dsl/bkBBJc5hG0gsk5LUCE+crawhqNRJVcdj5nKo8ae4x7cVqofjbYtGOori1Gujk96/70
 cotYZPNy
 ICtg9ufKoZFKCB5576MvirB6EmgEOh7Fk26ly1mLM8aRAjsVc+qd7pdivfMsgjlejuWuBUk9+jceELUVsixgwfKhzU6F39iD8YBRGtwzZOC/iiJnJeroUBp6NpijUPvjZL5Y2r9pFwSUkVeZKfaX1NV62ZPzC9aJpKhsmPdvG6vAAQURMfAwdRwwglIYh2+YLmWbyS3DfbrngR6FfENa6FERNd9jRWqQ928bHSgr1x1p3GL3kYHTqiCEAmpIghkP6wGBvR02/kjgQjknWxLj9BPBEvKOfDpDcOu5sUN/9LEX/SDSVe4IwxrV9Wz6SshUkbaIaSf5CW2a8iRIO/2H3z0JxpoFSKUMvlVz/t1uB04dp0d/itD9RT8dJ8bn9h6DnwGyMO6VXriiUjmu3m0GqHkHO+C7Gwt9L4gc4syblKgBdvNf562FHGa8AO28rS1d0clRWaERULX9gVPFNPXDtd3gdjE/51varZpyWbuuHMuXGZ/gqYN7OMRkvqIRCINe6nxNrj+ttSqS4EwmnvGXWwmwnwNXCnNeLisUrACrbgGhRp4KMfk6ARRN/mPs5IAGsuWggDn6V/D5kOoKAPg3HGi7qks16EXVRnBbQfcCtd0bSC6SJBgDoTUhz04LUI9gRpJp0OR382rPNElOfB0xo3E9HC3/n/+C1a4w2tGtonQPL1oFUIteomN8fMseviiEnM6Pw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta is declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring zswapped and delta as signed long long and comparing
against a signed threshold, ensuring negative deltas correctly evaluate
to true.

Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypas=
s test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Acked-by: Michal Koutn=C3=BD <mkoutny@suse.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 1d3c410252e4..2e7d123e0949 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -630,11 +630,14 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswapped =
");
-			int delta =3D stored_pages * page_size - zswapped;
-			int result_ok =3D delta < stored_pages * page_size / 4;
-
-			ret =3D result_ok ? KSFT_PASS : KSFT_FAIL;
+			long zswapped =3D cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long long delta =3D
+				(long long)stored_pages * page_size - zswapped;
+			long long max_delta =3D
+				(long long)stored_pages * page_size / 4;
+
+			ret =3D (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
--=20
2.55.0.897.gb25b4bd76c-goog


