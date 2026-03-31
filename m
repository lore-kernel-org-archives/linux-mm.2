Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A6CFF60C1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9802E6B0098; Tue, 31 Mar 2026 00:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A056B0099; Tue, 31 Mar 2026 00:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1756B009B; Tue, 31 Mar 2026 00:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64D126B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 232AEC3223
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:30 +0000 (UTC)
X-FDA: 84605011260.17.1C77D39
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49094180012
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aR3nwPCp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DLWLzQsoTlruy6dZYJmzr//ur1QVX1gW6lYgZn98iI=;
	b=0nYqGR/4OdNCHQy7lk0rd76bZscFSVxYlxjrjqTyslJp6FpZcY00lYO0aWlYulNd0mO7t7
	yFaQc8XYNVusho0brCtUmcoF79er3SXoqfpyaSxNmOu91W/2KqQGObgrbTLgO+UoWmVO9B
	kTYYt+xppra/0kOOIl7ImpAotJDX8zA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929748; a=rsa-sha256;
	cv=none;
	b=L5tQkrpDWC3ha9KkEhbhZo2e0AflrOTiEg/Kn1tRUoj7s38Qg6jwQofKGmD0Sejmd5CDVF
	X/22t32AxeXYgPq9pax3t8grnhAoao9GxTbIh5BaJpYr38FKdaeLAxhhU3zVP5Bexcb0Ue
	U6EjchUbLR1zVrtdK7WkO7MQPBmr2PU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aR3nwPCp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774929747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6DLWLzQsoTlruy6dZYJmzr//ur1QVX1gW6lYgZn98iI=;
	b=aR3nwPCp2ZWg94QxRzqQQEhe1OrjREiBQ3ujPHWXGwEAtdhnD9444SINWMTVBONI75sybj
	ZOw1dbk6JMqmVUNSY9S+cMXCgjkWob46xJO0wKFjHoflCKLoUzBLjhkDpt8IT9SwvjBCok
	N8GFRL+lXinWC6VqD0Wha7l1lN6E818=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-kZ2gZjV7OFK3kiiuA2eVcw-1; Tue,
 31 Mar 2026 00:02:20 -0400
X-MC-Unique: kZ2gZjV7OFK3kiiuA2eVcw-1
X-Mimecast-MFC-AGG-ID: kZ2gZjV7OFK3kiiuA2eVcw_1774929738
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63E2118002E8;
	Tue, 31 Mar 2026 04:02:18 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56EEC30001A1;
	Tue, 31 Mar 2026 04:02:13 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] selftests/lib.mk: set PWD from CURDIR to avoid wrong extmod path
Date: Tue, 31 Mar 2026 12:01:55 +0800
Message-ID: <20260331040156.119158-3-liwang@redhat.com>
In-Reply-To: <20260331040156.119158-1-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ji5aUdrxfN4L8Awi5rdwpigiSYxf3gDd3jssCGZzKmQ_1774929738
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 49094180012
X-Stat-Signature: rmow44umsf9nt8o54mdaydhimifj7te6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774929748-887046
X-HE-Meta: U2FsdGVkX18lbUsoH/k1dH7geh9ncp6rz8LTFt8uroRqB0p30io0yZmE1pcgn28e+W2T4uz6x26R2AyrpFZ40PM3RIjdhRtgIGxZ92DbdTB1sjjxC6CZ+89W6ndHhpUesbuorUHPNVbzCNF13nINLRd1QtpJofRJpUHKlNgw7KKGV/7Z62odp7Xh2NlXsjhNs+XxaqiS0arWYuKAAkR7XaEiG7NIqi84v5piHgsQ8wJCsY/Vlw1ccbHz+iLLDu5/4ot06BAzVH2/sOtvjIvjMluW6l76029d0GTC+W6FB2Ydl0177YYdMsYXWgkieEuLBiwWTeyggdlzA4zwY6h4SoZ53C6YHkpjsXaXw5DJQHIB+6fBVvKjzvgj0xvZ+8t/xnKFNKZHO50ZLowVSeHBgsJplD2nl/YTFU9U5nYfiM8WEykajijs+SPuUiw8zjEgmTgDb3RTv0UKHXSdTxr37FdUXE5sSUy2fGDmC5KQZx0LjyVV8huRNA6MEjUgTfPUqTwY+spfoF5JDnOmLQihVVnr/hYq+FqUaNJkkBxrd7m+QzmWU+rfZKqLlVi5bIB3rtT9iLhy2umoATDSAgFcdlnltHjmBwNWTAAMSdpoPUkI56S+4lKntKKZQ+o5L+0fCBRYq0e4LQGe0wLZVIEn4xwJa8TugjfGSsA5oLIxKAGQML0YXlH/B6VAYiJOXYJtiaWRZIIOMRiAyx9+mCsDf9VQE8gFkKdk01d5NaSiJqJa7tM+iEE5VIU9A2kHJWjSEA+hNtXOCGPSN6w3pN1zWRXqJZGxivnqSpGm8ydJMN9REuz8UhvbKIrgBXCyIZd+xWZNpJzTItf+yYH8bskqhGAZlhNEWO1Sqe8jSreOouitxfp48oQ1oXVZFayxThzvuS/hZZCx2o8jOYO8HXZvSOo7sQ/FbUX2qlJiUxzOmfWe5GJGIgT0ifGpZj3A7w5q5FuXOlzE34Q+Cq4PaqR
 E81qLR7+
 2189QqxkUAoIw0oXtEEUS5cqHH1Y90LZuK6yLKI0sRdIroH1tnxf7Xhew2moxsTbRCTsx/c0kjNwpPW5OO4eslJaEDf0SG4zydJRguxgISqke7gKkOQYLWwdNMEmXuL8fmTeSYhwVDn40iVS+euJ5CEWt9j6NW2UgxMnrGZN7z8hbl/oVl/77Vg7LqoigGqVZcn6wDzOWfLk4Kab5jCGX5R4RqdkxSBUytkeKPgS2g0/V9+DY30ptl4lnkti13pqRme0w+kWOLrAayF2/rXH4z5106mjOeffq7+YWMYjbGnDadrPEuaQns8VaZprAyX84Z08+4GcYg69e6pkDXjGWgzfF+lrEB2idnwrqmnGhNY4q2HAaPgZwZOaATV7nwmka9BfVT/lXAU2Md9B2rEUmLeQZaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running selftests from the kernel top-level (e.g. make kselftest-all),
sub-makes might still inherit the caller's PWD from the environment.

Some selftests use $(PWD) in recursive kbuild invocations, which can
then incorrectly resolve to the kernel top directory instead of the
current test directory.

In that case, kbuild may generate an external-module wrapper Makefile in
the wrong location, potentially clobbering the top-level Makefile and
causing recursive include failures ("Too many open files").

Export PWD := $(CURDIR) in selftests/lib.mk so $(PWD) always matches the
actual current selftest directory.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Li Wang <liwang@redhat.com>
---
 tools/testing/selftests/lib.mk                | 2 ++
 tools/testing/selftests/mm/local_config.stamp | 0
 2 files changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/mm/local_config.stamp

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index f02cc8a2e4ae..2840e98c225c 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -60,6 +60,8 @@ endif
 selfdir = $(realpath $(dir $(filter %/lib.mk,$(MAKEFILE_LIST))))
 top_srcdir = $(selfdir)/../../..
 
+export PWD := $(CURDIR)
+
 # msg: emit succinct information message describing current building step
 # $1 - generic step name (e.g., CC, LINK, etc);
 # $2 - optional "flavor" specifier; if provided, will be emitted as [flavor];
diff --git a/tools/testing/selftests/mm/local_config.stamp b/tools/testing/selftests/mm/local_config.stamp
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.53.0


