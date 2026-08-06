Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4854DC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4128C6B0095; Thu,  6 Aug 2026 14:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C736B0096; Thu,  6 Aug 2026 14:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A9B6B0098; Thu,  6 Aug 2026 14:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2E6E6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:19:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63D5CC018F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:19:04 +0000 (UTC)
X-FDA: 85071656208.06.330ADD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7AC2318000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:19:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gCiGC53v;
	spf=pass (imf16.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786040342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Od46/DzmUAyLPulZmr0Tuh5N+v6QlQ8E5evsDJ+JEQ=;
	b=d2I/PgM4ZPl/bKdx299DPaM8OC4mYK1YB1Ip2nXMTV5WJH+j/98Xisfg+xCN7fThS6nmKr
	NoGJzdBI+58l4uW9vIcroTSdedHffStfDgjhRkZQe+MSoROkIPxjWrBm04oYqLQIB8/FKp
	UIgKaNWkPa7q2ttvPwju36KePN/B1cs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786040342;
	b=KRZfGXSAYZghyUFg/91m4cY2STJARfsJELolDBsm+SvDMzzblPEnyqn1E/3lI1/RgBLwYy
	OkJhNH5dvWhwxVljpY0YtIu2DUDhxHjIJ2Bk5a0b/cW1FcLHnKJq3wvCsD8FUk4QW1Go8l
	FV1MDaxeJLoClq/gbEmFI827z68nm6U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gCiGC53v;
	spf=pass (imf16.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786040341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1Od46/DzmUAyLPulZmr0Tuh5N+v6QlQ8E5evsDJ+JEQ=;
	b=gCiGC53vUn3rCzFWerv9zO3aczR3OXy3QGr214ByNMS+FXp1TBIMs1EStgqI9qZJHbNMa7
	eiiG/Uh3ICOmjJ3tr/T7K66wfTppIj3oAdx2k/RXPnBP1EOu8PJetzpV2O9qvp5v3xT4L3
	NN43gHOI5t/WxTLrgr7pJKgFNGOZGm4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-njgfHLFnOPukWvRfLr7D5Q-1; Thu,
 06 Aug 2026 14:18:58 -0400
X-MC-Unique: njgfHLFnOPukWvRfLr7D5Q-1
X-Mimecast-MFC-AGG-ID: njgfHLFnOPukWvRfLr7D5Q_1786040336
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDFAD18002C8;
	Thu,  6 Aug 2026 18:18:55 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.255])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F249E180034C;
	Thu,  6 Aug 2026 18:18:52 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: david@kernel.org
Cc: jocolema@redhat.com,
	raquini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Andrei Vagin <avagin@google.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] selftests/mm: Fix soft-dirty kselftest supported check
Date: Thu,  6 Aug 2026 14:17:04 -0400
Message-ID: <20260806181843.1839943-3-audra@redhat.com>
In-Reply-To: <20260806181843.1839943-1-audra@redhat.com>
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
 <20260806181843.1839943-1-audra@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: EYsD6EkiAhjL6ltBSwTBAPa_LdhF5uVgSzcdp7mt5y4_1786040336
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7AC2318000C
X-Stat-Signature: smm7r77kyswzyt4g3crj68qfooxztoha
X-Rspam-User: 
X-HE-Tag: 1786040342-356873
X-HE-Meta: U2FsdGVkX1/eByt4sOD2A4Cv2AKi4914vFz5czI3tAfHb3EMPjdGcF2txidDAqdrlsyQOLUt5TmHI9Ou55GnfgzBMvNq/kQPq9Pn7OJ1seh8x4reAzLv1cNkk+7kP3ev64BAml8eb80Cuo8CpL183UmCjh+ZA8aBGAF88CpAC2MI5yk+t9z3SHXmMRYL8WN9MlJ3d6g4yh2qV3fHs/r+9Ivy1gukfdY67+MvPlYDz4v/8FsRkfTw7HfRa82wfSO/nFCaqTtQvTiMhXp8N26f2ZF8+v+yBFg1nm+uZl8G/pxXZhFsLITCAdQwzf1jUZ460bwnzj5zAVAroh4L4QnkYdTBgNhvWl9PgWk+r2oW2riXmQ8QCEOd1GwrYMwWUGfMpewDM5u5PlM5yRFsvrsB1zz8//Z6A/xWpAlCP8v3dcjW72wEF4aOXiXjQsCfdFl6Y2UvGMAYryJKfPCF9NfB+f7d6NIqwFy41vq7ALlI6GylUGJNv1m6QBe80flNA60m56Rgzh66P8YD1GSDuo8H7/lVRJFKsipgh+QTVxKkG/Na0LAlnB8vK3nyi0J8ZetLHYTWT36y8HigwhsKE+fhXcQvjzADyKSlAAZ+36fYrtRrXhrdtA1uptozH1KWGzM4wmR0OncnFErm1eqk5ryrBLDy1LcRkCWjb3dkTHqlx+NBCrCdilbo7Nv7tfhV83Y1CPfWHbLlg4URl24W6Qpi2UDzpn+YOD/nkci8r9Cox1NvDKxGVCzimFQocSWZCuX+6QLoLjDJ2LdRa7g0Scrfl13IqsIotikheGj+BMdS0497byiNA7N4nuN553PQMsvonJgufbrxWEQK/uvpzUq2MNt5LyvTMo4X8ahb5amXVg33Q5ukFqd5ZcTgEqebrJ+lIq+JWMAuXmgCl1JakxgcYjxR73Ie2TnCU5sdMGkVj8qQOgw35iBuxT8/Cb+Ic4b2oOyvXGnbeuaWUPIebAm
 p8RmSuzq
 Bh71YoZDBTpJ11DKNLdUAPwJrBczUu6kd3D6yO4FtjT/wiYMiDMYaetk+UqRnrDdCxQ4ywrNsno2Bj8PCKD2vojjE76gMj4n0ensvh9MjL8+ZHPPqbEPWcIlbicwDLrY3X/O0ureFhff2l+Dg6erCaG5hWSHBgVAAEt6cmOwU472yfh/rxGdDn7nRg8l23G3HncdKnFucuUJfQrOQ970yk933JjH2/jt78PLzK7yP5VOZOF22u54n3omS6RHOs4tBQzWJT+BSoQYuUPnRQWH0L7foUGxShEMCqpHv69uqM0umfH+tPZs5Xm4R+UUjcmQH2FmfWAJI7CTPueYSxSUmIiqthATfpdHX4XMDEuA9IaDNf+mNQN1QviZ3mofavKmw2YT5od9KbGvAsPipHJ9kaP9JCGLi7AfWRTzs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures with separate user address space, such as s390 or
those without an MMU, the soft-dirty kselftest may fail when checking
to see if the feature is supported.

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # Bail out! PAGEMAP_SCAN succeeded unexpectedly
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
an invalid address for the page_region. This is done intentionally to
have the ioctl return with an expected EFAULT and with the correct
categories returned.

However, on architectures with separate user address space, such as s390 or
those without an MMU, the call to __access_ok (used to validate the
variables provided with the ioctl) will always return true and we will not
fail as expected.

        if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
            !IS_ENABLED(CONFIG_MMU))
                return true;

Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
address so that we get a non-errno return if it is supported.

Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 tools/testing/selftests/mm/vm_util.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 6b65bd0a1e0b..4a8e339a7403 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -66,20 +66,25 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
 }
 
 /* `start` is any valid address. */
-static bool pagemap_scan_supported(int fd, char *start)
+static bool pagemap_scan_supported(int fd)
 {
+	const size_t pagesize = getpagesize();
 	static int supported = -1;
-	int ret;
+	struct page_region r;
+	void *test_area;
 
 	if (supported != -1)
 		return supported;
 
-	/* Provide an invalid address in order to trigger EFAULT. */
-	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
-
-	supported = errno == EFAULT;
+	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (test_area == MAP_FAILED) {
+		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
+		supported = 0;
+	} else {
+		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
+		munmap(test_area, pagesize);
+	}
 
 	return supported;
 }
@@ -89,7 +94,7 @@ static bool page_entry_is(int fd, char *start, char *desc,
 {
 	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
 
-	if (pagemap_scan_supported(fd, start)) {
+	if (pagemap_scan_supported(fd)) {
 		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
 		if (m == s)
-- 
2.52.0


