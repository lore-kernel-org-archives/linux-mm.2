Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C62A3C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A18E6B00A4; Tue,  1 Sep 2026 01:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679A86B00A6; Tue,  1 Sep 2026 01:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568AE6B00A7; Tue,  1 Sep 2026 01:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3234C6B00A4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:22:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A750912034E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:57 +0000 (UTC)
X-FDA: 85164049194.02.5AA29EE
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id EB6F440005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FJZ/pQZD";
	spf=pass (imf04.hostedemail.com: domain of 3LmGWagcKCKUbKJQNUJLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3LmGWagcKCKUbKJQNUJLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240175;
	b=gt7BetfloJxroIDK69oAoSyfC0+xZdTxATgq/gJPZDW2ublDfEv6iSq3y82FF+CvtS67Kl
	yY12VBPsbsnXFNDbGL5ihhcDIE0q+iBeO47k5wN6qdIeIXAux9jyAO9KFB/QnCSrvCSTbr
	Rnlp4TziW+JiBGbX7ShPAHYDTyfRAoQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="FJZ/pQZD";
	spf=pass (imf04.hostedemail.com: domain of 3LmGWagcKCKUbKJQNUJLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--wfelipe.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3LmGWagcKCKUbKJQNUJLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txHyoP6V8LSeV3HcUyvKh0AUgxf1/LIju6BYMJo/v9M=;
	b=lvMbFSOiyYqjP5QOJbrLGPjkn6+puH6h6J5luBbILqqzsUpzmChi0vIaTCt9S88EY+S5LE
	Wda6hmIWZMWYgNxsi3K9uWEV+njKXigbHcWLsm96IbCa6+5KHhdlamNlCKh4SuT2frnFlI
	ysP9VPerRFOA9cf1skJw452rXk+GRUQ=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8538a72b430so570012b3a.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788240175; x=1788844975; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=txHyoP6V8LSeV3HcUyvKh0AUgxf1/LIju6BYMJo/v9M=;
        b=FJZ/pQZD8Vi5hP+ueBQrfhhmDhF3gtZInHLnWL7w10phwZ0S8nxQ+3zbiHe7eYuSkU
         6KvSqjC+NLw03Ewi4qz0/z0+dBBuwrFNV3puY9XKMrLtdREsDrPlzG2x3EZh41q6E5sj
         rlj+PkZ7iralIZXOQgOAeI5l5C0FnuUO1WZ6B4M05M+rNc5D54i8OK/dTRaG+XXq9XSg
         NivMGSaCPMzOY7Mpjol6ZyLPxronaTmgZYfQojJQsOgiudS5/uYR636/YkrHll7Ztvj7
         lFMajswhGFGY1ORNvGVwuala+c0SPOBOyJgiRxOaqX6CxETOLd3CcUgOLoNXaIVnVxzc
         ANVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240175; x=1788844975;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=txHyoP6V8LSeV3HcUyvKh0AUgxf1/LIju6BYMJo/v9M=;
        b=lgoL45b4jntkRTYkzN/h8i0Tpx/sn4kObcWGD+evhR0nO+l3YiXFyBZPxTTodB9Bh6
         hPWGY/iONrznsBczJqDK+nde+26o1I5Gts1HRn4loqJjhlvUEKpIFNepyD8jP1dQh8l/
         TY0FXf3UR2Z/Ok2ictWHFsiJc587zsLUBwkwjXXaC/rAuj5k+pkshRtyN4G3M/uK51B3
         oUgdaVj0/A3NnBC4K8iO0axXlsO9t4d+JeiRIx+vaSpfPf4PgpDYHocC3ExBjsEjdcBS
         zWRc/UsyJL8eu4GkIB+VNiLNqT6pPjcDkMDV8RCPFpU4oSyclLDvvWB4O7M9EK7UmhwV
         iClg==
X-Gm-Message-State: AFuF++k76Mm95aN/f0MjnBpwTpYD1WEkOmNa3DrnozEcR266Y4Lv4jpZ
	bVxFrKE4Uk/IV4qvfoA6lZW+U7NZFBLAQ89YZb4qxayY7muj8Z0s559Rx1FqKQ8OW5Xw4KdhVJP
	ymfRS81wDBA==
X-Received: from pfbfh35.prod.google.com ([2002:a05:6a00:3923:b0:847:a85b:6c23])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3692:b0:848:5f4f:289d
 with SMTP id d2e1a72fcca58-856277dba33mr51581983b3a.4.1788240174518; Mon, 31
 Aug 2026 22:22:54 -0700 (PDT)
Date: Tue,  1 Sep 2026 05:22:28 +0000
In-Reply-To: <20260901052250.154532-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260901052250.154532-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260901052250.154532-3-wfelipe@google.com>
Subject: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit unsigned
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
X-Rspam-User: 
X-Stat-Signature: ondmxrg9t1ogzjp6dg1xw8tf8dirzgqw
X-Rspamd-Queue-Id: EB6F440005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788240175-7342
X-HE-Meta: U2FsdGVkX19hfXdmsIgOu+lY2qn2yItJScSrz7YZrQSFJuZb1KDh2yWCQsx7UbJ/ZjGf2s2NsYTOd28t7StyhopeoKEyWLMl0l9K9O9gI2naU4CI00nQbkIOJ6bsaQ/6bhHoVaJDsKlnjc+eYIvBasULFwBj9l1PScu+CYPhCRrZznWc7w/O2qOoqIncBdPVw3r+gx6ehULbfIWajcte1IYXk1tOjTcOExX5Zry5K+B7ycXE7C3zmrMzbZXO98fto94RudhQ7o44cWS0IXWxB6ojWkmc/ZJiC6ck6WWhP5yHC1DIGEVdk5yO6m+WYk9lCgvX3Zit9Ega8EPF9iXA7ui5F6WdlWEFlPEru0ecP4mO0OY5gAfkPIhp3wraE3bCUBIl17X/G/NahCcIirrnp96pxPicNm77bWOJ8to6JuiQz3+FVBZPp3y8HpaD5bMRjHa+yw2JQ8erIK4EdaTcx8caLi/1jCzGx9D/KRLQqeNxzZHl7AmiymJl4ht/ZjF4rgHB+/Xg1Fiy1JwdipHdIFheEH7viDiAGeaNL92mFKyz70S90hIWaB/B6conFo1j3++9HhVcTLzDTHkbLNNy70Z3tG+L0MkyDTd4UNazr61GBlHhASep7Qel2nVACBvNh0tFrNXD+0ulGeiHodFGJObKajIOrDz5eZPuU+tYW0SJy416W725agH3jQE6OlfbUklRtiIlB4wL3PvpqlGOy38daaP1dqD+zPzn52br18FHbxMwD6X8RqclPv14Db/ftbkKkCnQKdHZC0kQCxF856p39iwWon31QbKZ7cmvMuPIsdaHJn/riyVLuSkFEnjECAky0lc5D2I1yq1PbMSrHZcDq66E8VZE9lXO/BMvQM3MdPs+C7sBY/6/Q5+90C/CCQ4npNEuCCmNW7Wj6lBIGf8WEY8cTf2m38NtVjaTlvDlD25tXOASPDqr5OWiVZc7AmZvDZBeZ/8ruuTJZGB
 2PD55eaF
 u1PgUo+tkPfVGXGAvY+Y59kgbY+qRDcqA9L19HXoYARmRj1bjystomPLGO/Rqqxca6pN0i2nD/1jGKjOs0zKtPAeEbDo0VZRGnBfJcCbbuNfw71xWOQviaeRXdtdGHbO49SmAGxl6tmVhMjnTcQYrMklcYNnh9U1Y22A99ZfdOSuyfA5Z0JSOgyzucUmz96Rw3v6hhVpkUfxSak72prCMeX0LozL4VDcOyQUSNpmyN9tbiIfV/15yaLOPMAayz5AzsEOLoqE6xejamdUKsjqrlsIhqr0PC46ze858l4kTm4v/AA+yJRtlKDZBKdF0ckoc5NgmedfVYNIxRnXikjCEt31glUcn/4rhq9+6Z8TIqmEj7zAewFC6a9fUPAuOLdOt7yGMOaI2y8cAuzS9db+Cok6RckibAN3//UuqYrYi4O9tQxinhAqXZllpkpgFLGi4jqE68qKjQx3Cgg1WBVtCXZGR2UqvTx51bmN+KYH4NCglpFzJLuRMWcTPp+WY+uNMYGvhUGm5F8l2Egx2IhlP/M5hw/FWsvLqsp2p2Sx65doWis6/UUqZjY+c4Wh/zSPR9oxjb6+mLNwCUMETb1rlrahnMx2xmTkuhpdKCxp9ShfXhGgGjOaGKlH9FBWvt6ZvxdDBe58PufdJer4Da1Eyj8O9878ae9+IRlvvvrp2/9CWa7NR4bvvGYwnyfb58WIT3aOp
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
 tools/testing/selftests/cgroup/lib/cgroup_util.c    |  9 +++++++--
 .../selftests/cgroup/lib/include/cgroup_util.h      |  1 +
 tools/testing/selftests/cgroup/test_zswap.c         | 13 ++++++++-----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..ce2dd36291f8 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -172,7 +172,7 @@ long cg_read_long_fd(int fd)
 	return atol(buf);
 }
=20
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+long long cg_read_key_long_long(const char *cgroup, const char *control, c=
onst char *key)
 {
 	char buf[BUF_SIZE];
 	char *ptr;
@@ -184,7 +184,12 @@ long cg_read_key_long(const char *cgroup, const char *=
control, const char *key)
 	if (!ptr)
 		return -1;
=20
-	return atol(ptr + strlen(key));
+	return atoll(ptr + strlen(key));
+}
+
+long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+{
+	return (long)cg_read_key_long_long(cgroup, control, key);
 }
=20
 long cg_read_key_long_poll(const char *cgroup, const char *control,
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5d39c709ac7a..13923534003c 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -69,6 +69,7 @@ extern int cg_read_strstr(const char *cgroup, const char =
*control,
 			  const char *needle);
 extern long cg_read_long(const char *cgroup, const char *control);
 extern long cg_read_long_fd(int fd);
+long long cg_read_key_long_long(const char *cgroup, const char *control, c=
onst char *key);
 long cg_read_key_long(const char *cgroup, const char *control, const char =
*key);
 long cg_read_key_long_poll(const char *cgroup, const char *control,
 			   const char *key, long expected, int retries,
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 8f2c9aa4776c..11c67dde705f 100644
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
+			long long zswapped =3D cg_read_key_long_long(
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
2.55.0.970.g62bdec98f9-goog


