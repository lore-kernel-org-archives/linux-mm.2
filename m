Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5DBCCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFEC8E0009; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67A88E0006; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EC58E000A; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 587FD8E0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 061CB88F23
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
X-FDA: 84062853840.12.850FDAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 677A44000D
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIzuvFW0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAy3Aa0Vrh0cnw9sujTxz670nGm4e6vTZ71LY2LwqlU=;
	b=Lyxve+3eZZDufhiGRDe1YW9vx+q1u70euLMYntp2DedY0UIK7W/gSHxEBZ554wY0RoobNK
	cn9R6mh/KtWPJuWOmdhGTIxU1hrvAuDusw/80tCdr+Ri330EB6Uzk1vVKwFDDOrb0YmDqP
	eVIvcWS96jVjcjNXT0yoGMW+TOVI/Cs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIzuvFW0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021238; a=rsa-sha256;
	cv=none;
	b=srsA1z91Cl57nonqy+H3Df0+s4WkclHa0W/x59aXjZkT2FHxs+tU+5PqpypCz1zd1tyJCe
	e+v35wupSz7MMWLcdOuB6oIA5Lo1r/51S64IJeNNdVbaJjgL/+Xh0sjcCESF1qij612Nqg
	B1ek6hgo4ovVuBTx3VDQTTApMkZ9G7M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 757504403B;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF6C113D0;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021237;
	bh=MAHj0zqutyRZpbO2i6YXcMC7MCCsz7KkFpvZC2OrxTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIzuvFW0beDimEA3rhSSda12ZcO/KMSATCqAyuGISaMV5hCauIF/+XqjyCAc+J2/T
	 QaGsH0X+/Eoheu7F64I6YbtbMgHUhg+00l/5iLqqGfKKF6g/kH/zS8E2pCW7PQzJ88
	 F9Q8bGLFDNIQlsqbAReQHcU/UqZt+9oV1pFy6IbeX8kTD/96mcEBPwpVIoN00/awFB
	 aeYYrqdLju9ixABzTjJUPAXFcwhvwoqCsu2mdsUafcxvTVM+HptBM0FrSLxI0DWGKP
	 TZjUQwQU+sClOrLEBhUeR4FQlQd7uBvNR4XJZkx7EhenNkCuOSLwD10m7ZHzLFOu/S
	 d7xrjSuiegTXA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/22] mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()
Date: Sat,  1 Nov 2025 11:19:58 -0700
Message-ID: <20251101182021.74868-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 677A44000D
X-Stat-Signature: opigwfs1fudo38six9dfrzbhod4x7que
X-Rspam-User: 
X-HE-Tag: 1762021238-473389
X-HE-Meta: U2FsdGVkX1+0+G+q8mR5qHH/h+4i7RJs2hoLYzqiL4nhoXKljsclXoQiKQLCruUj5v2jNyRkiUPdO6MJoPMNgGjWeyUtTrjoTHmM3IrwGwKLD4y8hgqHXuSEcjJN1fh+T+RZPp7IRP2zST64k/JzEW6pHg/6DaFoyoziLbsgJn2OwrjzomJF2AWr6wGH2Xp0SwYTdiecpYPsD2uTqHtBln9sJBJEHjMwSO0PovG4BwZUKk8nYUC5pQtyNJQxvQ4/8wjOXGXyuBMQx6fpE7OHlVvlAtXiQoZLuEzTNivg1gnYIN0Gm7OcT8NGCqNSBUlw0ia78zNSKLbCjCnOJ8FRT+35pFdNBA2Ei0M6yZgDcIoYd0Upyf9GLEu81tk1J1KBjEKiOebHgHhAGldsmZcSsdSTyUGAS15aPf2cF2cWYamkOi38bzurZ1MGx5Aegr6tCagV4EUUhJ+2IlHTTxTeFyi5vSXBjtUl5QzFcinyYxDiKjm0E1dcOk3FXRe6BS1t3jFfKlHzO3i10PRB/fpUpljQQRcoH4Wl94SU4fBqXy6ica3nEQsR0rHAFG1j2UV1j80AcNxJrN+U4/iht0VyurnUuCiHfw4Fjx69tJZLcMeZog0DLqJkuJMaO7Zb+6QOLamGXMxoquA75duk47hntfH1ydyWnsMDB46SurkFiE0stVmOJgAYRaV1T14PVDeDJQmUF+kB0sPlr64gnUjm8jagpm/55y6iYchHM/O7X/XtarIhh3kfD7kyDzozStOsjHxL2b84kVJXZyEuAhRUPHMLt6LKQm63WtEkJcwqR+FGIQW3jteidDtfU9h2fS3RQSj8w6ls6DBNnPbIWtJ8AfCrvg/E/wlEBU3njnoOLtb2oyOGqKi04DsbMpUGkua6B95kQw4b749/KURzQyRHeqoijcltSxidYQaqG9UIuv8NGjlzbzhAgTuZbSahow1pPRbB322kg/ZsJ9BVFHo
 AT1IaFGj
 qR2imXbCE2to0RHM0ldpVnuFrhvcHXucxDPYyHtfTTCfrrmApJF47E8mBl/CxRsLKA41wNhOF6Bou/tdDz6Bp2a6XPNidR8bmU9yzqij340aSTZLOG2kVxEZHsxPL3+ePY9W3AvYeBc4TwEekcrrKCvjfmHX7v/vWgcQyiQ4m5SKoouCMBcZapu3rsTPB8qTN93SXqQZZtnMPkL+Zypg8I8atIg38uMRw7olxZ8hXOwhf25hIgj5tbGGI5R64fXtvvpBLQZL/DkYdlMg/ReuJcss5lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_aggregate() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 6e8a605277a3..fd1e1ecaa2c9 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -97,8 +97,15 @@ static void damon_test_aggregate(struct kunit *test)
 	struct damon_region *r;
 	int it, ir;
 
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail");
+
 	for (it = 0; it < 3; it++) {
 		t = damon_new_target();
+		if (!t) {
+			damon_destroy_ctx(ctx);
+			kunit_skip(test, "target alloc fail");
+		}
 		damon_add_target(ctx, t);
 	}
 
@@ -106,6 +113,10 @@ static void damon_test_aggregate(struct kunit *test)
 	damon_for_each_target(t, ctx) {
 		for (ir = 0; ir < 3; ir++) {
 			r = damon_new_region(saddr[it][ir], eaddr[it][ir]);
+			if (!r) {
+				damon_destroy_ctx(ctx);
+				kunit_skip(test, "region alloc fail");
+			}
 			r->nr_accesses = accesses[it][ir];
 			r->nr_accesses_bp = accesses[it][ir] * 10000;
 			damon_add_region(r, t);
-- 
2.47.3

