Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47281606FEB0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=g-ucla-edu.20260707.gappssmtp.com header.i=@g-ucla-edu.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fq2MzP83
Received: by kanga.kvack.org (Postfix)
	id 5BF3D6B05DA; Mon, 16 Nov 2026 06:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570646B05DB; Mon, 16 Nov 2026 06:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADD06B05DC; Mon, 16 Nov 2026 06:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28A156B05DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5867A7432
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:54 +0000 (UTC)
X-FDA: 85440704748.01.50914E1
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A0E6C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=fq2MzP83;
	dmarc=pass (policy=none) header.from=ucla.edu;
	spf=pass (imf10.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.42 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6Er2nPrtscnG/s8rWHw2Y9sWYYlyx2QveGZLr9tu7k=;
	b=DQV8lhJ/b9OySTcQDHD9W4+W8UsPvTHwN36eMgZaqt6IYDClX+SQ75dTvIfK45+ZyWVONv
	pu23Jmp+ipiIZUwgEVqoAmDI79q/QYSACIU5XJtPuj7pF/6cfVJZaUvDQs+gtDwvBN8/W1
	7Lq54UuYnVHs2E4S2VaIXzCkB8nUWvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827212;
	b=kyIgccjNvp61Rmd4jhiJ+agierHbhLcbNBzzcHMIaA/vU5+tzQwFshuSXtftJvmOtl4PH9
	ZrdVcTAvYr+UCs+TMV1Z0XlmOJFBy1NAFWT6dnQ5uykenSpqaOQUbBJhi/OiSveg4sDJ55
	6nJG1uvDrkqt49sCIvREymDpSQWuz4M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20260707.gappssmtp.com header.s=20260707 header.b=fq2MzP83;
	dmarc=pass (policy=none) header.from=ucla.edu;
	spf=pass (imf10.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 74.125.82.42 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b3b4bcbfc9so3662407c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20260707.gappssmtp.com; s=20260707; t=1794827211; x=1795432011; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G6Er2nPrtscnG/s8rWHw2Y9sWYYlyx2QveGZLr9tu7k=;
        b=fq2MzP83HqBb/7JtQqfkEb5p9D/ahOyS4hUwZ4QG209reTeMRg6wig+q0Q19ntFYYU
         GtFcFPAq04rTic7QYo3EeiwU9MC+CTfc8MHbzvg2uPzet8DLr/ovxzv3xHYZCWQQeC0w
         0u+HpOpjL1yVeeBoXfGMXQa6HpyIW6nnGjEoXWW0rhqkZrrteLq1A2dP1iuT0PiXUJdh
         nMFJfC1FE4PRFevHW9XxxG7G7Eqd3REgOBS8PAitmoZxUatNo2MJ+Jas0VJbp0Us4gPe
         RL2xVFZK46mflKOJlBWvwyAGj4SXyM3Bs+/4OUIkD2reMvXU57iBsUsq/3KCoOedcB5t
         rwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827211; x=1795432011;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G6Er2nPrtscnG/s8rWHw2Y9sWYYlyx2QveGZLr9tu7k=;
        b=zGzuOsOcxag4kH2Ol80GSAjVT2m2lISFupvJEfXP5EeBtV4t/QoSxgshKBzTWedsu7
         HEYeSKiEzVkPr9ZNTtg6Uc2N3v8tmNT4bMJkRwveeWZXqwEPCCsXyp4UrqkXUM+SkkSb
         SCbBzcJ0l9HF9ORJroO7m7GGy0iE+JiTbFNCZyO1lwASh/v54ViHskGSC3QTU2dT5ImR
         lurZCN8TtL0xDCGC8+IHHFD7Xxakq5ldXyzZUVE2tlOjWAgCbpcf1P//Qw3pWCco3reN
         0lxUVAiqDAgQfsFo651WePYg3LKktu1ytBT+4ixmFhb4p3igTyOGxLFPUEAN/I+aWDqd
         wCPg==
X-Forwarded-Encrypted: i=1; AL+hErGLeyz3r8JkLthdbbelE/C6fBfY1dR2ErDaI8vgGzXpvhwgqVzjE0Orm2R885z0GXApSmSZj2yTsQ==@kvack.org
X-Gm-Message-State: APuU4Z+DV9JcGN1NcanfphQGpPIMFsBkyjpC2VGl4bE5CnaULM+QDrXL
	hqQGjPgqryyO44EusUtPQEmkzlsGLanBIo+Lhtj92LqIfYsSPIi4E1pE73+ICQjBlko=
X-Gm-Gg: AYBFou0YZOM2odwEpySk4YgOjMxXKmqGlygUakgGd9TxDuzZCTckfMw3aSaUxlBG/rl
	xbkXcx03xHc4+Ax6B2CUfW/a/15IDUQlGznSm9e30klTR0NC2NgFvd91q+9eoI1oOD1ZpWXLHXb
	RHk2pyC0NlbL9QFh9SJwysSeFHphIg0pV5L2oka70iyqC2+kiaafYbgSuVkAFgd99v/RRR6fDYW
	Uieu6Iwhwb25QM9/XjAhPjNVUJnrZq1lOQ53P8+Drb8eetQPnmYAPcz4VRSUgAp3GCM3y9oBvkp
	U/9MOBbMMn//okZ2/4OnZ1DAV00WXBxdaWXa9jjqU8FPd5tXOtf77sqsSUFX9YDgM8Mi3gZUApk
	c4BtL12mXzyOrw3PcS/e77d0iGliIoIbPVcjemxecznPaLSHLYvFzYMBXZlyx/Si1tFcuM+9Eq+
	FYTOXGIcGiHuwKME5F0F5FAyU2c09c0FIJJ/NqRVdC1PCPncM6gj4Fzrp/Yw8CmZAlSkUHA8NRj
	WGx+5eDjou+FLGXlq86otCkFSxSt/RjHTj9Elg4MBi3Q3ySvrHKdD8NmNvfBqxXUfUa71ArueIh
	T85ypYI5wO9zd/XwcoyHLWSSL0J/Lw==
X-Received: by 2002:a05:7022:38b:b0:1ac:9da7:e881 with SMTP id a92af1059eb24-1b503175cf7mr11947613c88.36.1794827211184;
        Mon, 16 Nov 2026 03:06:51 -0800 (PST)
Received: from [127.0.1.1] ([131.179.95.34])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b524049e0asm12522103c88.4.2026.11.16.03.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:06:48 -0800 (PST)
From: Jason Angelov <jasonangelov@ucla.edu>
Date: Mon, 16 Nov 2026 03:06:22 -0800
Subject: [PATCH v2 2/3] mm/damon/tests/core-kunit: test
 DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-test-age-ms-filter-v2-2-3b265d59ec98@ucla.edu>
References: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
In-Reply-To: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jason Angelov <jasonangelov@ucla.edu>
X-Mailer: b4 0.14.3
X-Stat-Signature: 89u5miuooio54zd7bsoc6gpmrm639wp4
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A0E6C0004
X-HE-Tag: 1794827212-942693
X-HE-Meta: U2FsdGVkX18pL2tJakY2gz49+vxO6w2pQuULt/Gh2fE1WaMq2dfi8jJG+/S3nSKtFVW3HAG8067zupkDY6VHpqyVcBohGTtjd59beJ12QHO1AXW66W3f33vTlpLkZkEwYcgeTLvwU4nTw2c2kp6dg798TfiGd8Ag8+gaqKNOYeyiwerAjBLJS7LuLDKlgkajtAOJ0geWUXlS9H5zDp0hYDCNA58NxMYHCycsJiDwwYmu+IeYoMWIOC8j0lgOjMaviymknumFPCKpW/CaxSE/A9TTDjgrTUafcvJ2QOrahpCg8ufqbvdJMXglOXnf4HQl8A0JcVJMzAdJH47P6LlUVGk31OpVz5ZEohQuufmlxGnIpyRGWIMSU6QlQSc6ZpuuFmWD808zr9uaJMC7MQ65b19i+ptQP/6ORhy+1TF261lo9vOO6gSvIerbxMcMR4xANVh1+fcgtGw/CH7BdhAvmYAp9LYXlgd6Zh4Ynb0i2dY/P3PllySb0DzAKoCNU4CYBXjgdyHagrHTg9oGZcayj+aEAlMDxWeqwnPoFHSOJm97/5sEJ8Tl9j2KsKzBPDVSxR3FYwSVyX6RTCKh3Blqft5+ugKpDQuc+/iYPucrfdr5+ktYeXjuqrENoiR66VuMxvdC6d75J3OQI43yalzaxwoUWP5LC+U/hj/UIrNF8hKoyxKd0wBaFjBggUHHjf/5DL7nfEkrwK1oA452+54Gbny8ZzFDTbcyWjjVhxWDPE7LBBu1aONaKe8aNtMs4gnOY+jm5BcTgHa0mFeLa57sj8rE+w0SXGvhufREQMrAuD7whHYuAA6oDygbAf6d5OmVQIXDUJC1Ls0SbrytdlyLBPlePAX+rxPLAjpivTzzCXH0ZzULKUCkE0LlhY8rAldXKthed0gLWLaW6xLWKwHhUF4Wh9WV2ne5XVOLHbavu+OcBSLlwl+qN/bO1zNHFwVWdfPkOTwcOf65yqg4awT
 1qrm3EFh
 J234vzupffcVDDAGRuuGTHw0jqsrbTaDeOKKN2+3Q+fLLP75iTmZXqqopUQEOH5gpdYcJK+wTn0YlkISFMyJTLqYXcOuUPUQUxUR3lrVJkdI/uOxaSIFdA14SxHyWTSML/ZKxa0UKpiZ0PAmFXKHw3up8dKVrUdRH2SymS1ATXBmUGqEA6k6QFhgvU/s7UTGv97p2dH6vKrupyZ7ZTGa/8vm92VDgW+M+mklq7wV0vEWiRW4Gr9MFO27INcfpTawHL/CgfiDMb72bYEXBEMiZ273yxANJ1YxKzWJ+lVLPwqo8SRn4JUKt7VOyWr6iaW6MCDKyI4XFGypIdACkAOMlcz8iSCd1xSQrmDHsfCl0UKujDsanTaqX5fBjZqFAeGLJOQIALyJew+43bIVu4GjTHyUFlEFat6ZQ5XDqv9p4zfDHgKE0xvyH7Vs2ayiFJkvT7leEienxgfPy5ISZ0JXlc4EfRnUwZU8D8xFMdu46AwkHqJ82x7BjOLYOxTsU3TTXMyexA8N8r/W9CKTHgqNAcck/5xyUlXV4fkqKWKi6ri6i/EVB6AcXCMCm8v1qpOL446ixLnzJ8/a7DxwaajKhfjBUNyLCHky6KUwBbkHGZu6kP1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS_FILTER_TYPE_AGE_MS is core filter, not ops filter.
Add kunit test covering this rejection.

Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
---
 mm/damon/tests/core-kunit.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0eb5dcdba0ae..156f74832c40 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1832,6 +1832,12 @@ static void damon_test_valid_probe_params(struct kunit *test)
 	damon_destroy_ctx(ctx);
 }
 
+static void damos_test_age_ms_filter_is_core(struct kunit *test)
+{
+	KUNIT_EXPECT_FALSE(test,
+			damos_filter_for_ops(DAMOS_FILTER_TYPE_AGE_MS));
+}
+
 static void damos_test_filter_out(struct kunit *test)
 {
 	struct damon_target *t;
@@ -2593,6 +2599,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damon_test_commit_ctx_keeps_quota),
 	KUNIT_CASE(damon_test_valid_probe_params),
+	KUNIT_CASE(damos_test_age_ms_filter_is_core),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damos_test_apply_scheme_filtered_sz),
 	KUNIT_CASE(damos_test_apply_scheme_filter_sz_unchanged),

-- 
2.53.0


