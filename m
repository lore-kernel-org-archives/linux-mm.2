Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D91FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2156B009E; Tue, 31 Mar 2026 05:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A086B009F; Tue, 31 Mar 2026 05:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C6916B00A0; Tue, 31 Mar 2026 05:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3606B009E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:44:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD9281A0C0E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:36 +0000 (UTC)
X-FDA: 84605873352.18.85882BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id DEBF8C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:44:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXfbhCh6;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXfbhCh6;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950274; a=rsa-sha256;
	cv=none;
	b=fg4551XSYKx9iD1xdD7HDOXNPu95A516Rb3vvn3BaQPPwS+I1+HXZkmr2MQsReDxMQqOq+
	35EbevceYbE5jHvBc3TChfCRzBWrcoPRnEE4Mxwgkl2b8S9gt7QwdhaCnmcT8yPmLjTmzR
	N1cpO3g+AH7jII12JW7lSRWgPQlKi1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbIbNiX+eqkEdr0SMcNuiwraBoTf68pP2H/YvQLprqw=;
	b=ahQNasENk89BAC2QKOEx+iHf1pzc/ffiQ7i1v37YwnBpv0l+Tttusafnfv3TyBJcHqgM9+
	j33jCkXU4yJpPOtmyW/aGjulAz4QmnebBgCO9T7sVjT2J/4zBE10d+RPtnY0hHfYKIyP7K
	zVsItmIeEHM07s2rXXAeu0rvPf4afxs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774950274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NbIbNiX+eqkEdr0SMcNuiwraBoTf68pP2H/YvQLprqw=;
	b=PXfbhCh6gAiBz0xBG11LcWXT5IPwL3ksUnywf/VhCs8dptTXuMwnzoMctqWOKX9+aLp7gU
	IUaAvmCsggGFS9967eIDdUGhFVHCjiay/9uK20FW3z36TQWGOMaJEdfawWK2INgQO2Ad+A
	Rbiv7kFfiG0D0beQT3j84ZuAfWothyw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-K4IZLIOxNGq32mAcJSMVoA-1; Tue,
 31 Mar 2026 05:44:28 -0400
X-MC-Unique: K4IZLIOxNGq32mAcJSMVoA-1
X-Mimecast-MFC-AGG-ID: K4IZLIOxNGq32mAcJSMVoA_1774950266
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90E5F1955EA1;
	Tue, 31 Mar 2026 09:44:26 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9392030002C3;
	Tue, 31 Mar 2026 09:44:20 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: nathan@kernel.org,
	nsc@kernel.org,
	akpm@linux-foundation.org,
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
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: [PATCH v2 2/2] selftests/mm: suppress compiler error in liburing check
Date: Tue, 31 Mar 2026 17:44:02 +0800
Message-ID: <20260331094402.144131-3-liwang@redhat.com>
In-Reply-To: <20260331094402.144131-1-liwang@redhat.com>
References: <20260331094402.144131-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: hzz3YDqt1dBCUynv00DQxU633xfaRPXHHjPpLJ1TYcQ_1774950266
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEBF8C0002
X-Stat-Signature: u1a9e8ch8j584h9eaju5xn8ti5jctygz
X-Rspam-User: 
X-HE-Tag: 1774950274-329349
X-HE-Meta: U2FsdGVkX19yPLOMwMWlfgtfIGtDPPf9jizdH5NVdBkwle/WQ6OXHJc8lCoFyJMkdNDZzerP8oA7LW6gxDQikyLT/tv6l9gN5/0fn9MenzRfPsE9U9FpHaqHH0Ve3SQRBNWFalhAPZUI9p8rdQirLeiXdMfqQxcCjd6a18dxAUqhH8VlA2NVsGaAFvakEFWsZldstUa7bVX/FhLc5iXS2CrefrTtpRa0cSJwzgINMx83qs9q8q0poRk6ptACDfyksocnkx88E07btClT9LX2BUH4OFiJnAuWTOV+LxbTKzvWa1yEn+h1sQ723JZcp6VBToZpKR+3Shs3xPK73Ss/7UzJyXa1Ye7OtMAGO0OgUOrtjb8fhoWzMs4gySdBmHcY0qFp8yFuJFJ/SNPrqaqqeVnsWGTUqcD7UThYj6zxTAEEredyoqVzZVsaVIzWQosiCONHOKyN5NubNdi4StrBzj/3Tg8XOwiQERkpevIRa4kJK4jITLOTRIPKT4KLyT9zYAVa95DH4nRiivqTX8G8MLMPKwE3oT2r7fHaN8NrxfQ45lT7VvY2fcb/PnCzp7W7E7IAoUuyFOTmDZ1Jj8o6aJgd/Qh0zOH5c2w5UA3hmu5lV3iI2zZbzTXUkT54EHYnuMkcX+k48m1nfpKDjo5BaRza2LDaA20LIcjhY9w0NI+9sZHZhwExUiZmSMC1yyJiLcd7vu2X3iM3eGNFzG+Fl8eUekQfIqR2nrR/G2axJCouVkAQz4Yn/zS6pu/69HzrvHkDPG00xKmAfja1rHODuFtAqdtD+C0nYIlO/C0lEQ+mzvuUIa5AuaLOIZ/qIQi3yRKlcyt6DD7DOLL+hpTcCSjGq+SFkIw1lDp4HpioykiA8bKUW7oeNZUdKGKxaT/J0wyVoTZJSVKOHU9s1+vcoP7YoL0z3cD0+NDN2tYpn8tKlDWI/yvUKPqIvDjuBs/uM/k3lMGepc49kfrdBo2
 fwWe0p7W
 HoOD5WBhOGskv56ibOdnfuh8Z7PIlzGI968+KzuNTLYfsRgj297GCTZ134YTb/evbS+mggCJh/9KQfdmubSbiosq3HyJn+wBOhbT9BV3cIH2PiHFeWxWo0JzMW6mycTrj4TRHtNnEUUaEWQTl5hFlMHYWGJIEbpVetS8rQ368zaM35meyVaqKkZjSPr34u2qtzksMwVJYvIIM3TFFk/uKB1q1whvFUPK5htl9oRiS/f03FmCEh0gwuBeWSFNPcQ58qmORXdyVDBCtJvjXaPGegKGIk5cqravChRgUDCHALrkDt5iS7BHf1tVWJz5p8Wtxt5EGZxMp/1GlVhXOs0DSEzJx8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When building the mm selftests on a system without liburing development
headers, check_config.sh leaks a raw compiler error:

  /tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
      2 | #include <liburing.h>
        |          ^~~~~~~~~~~~

Since this is an expected failure during the configuration probe,
redirect the compiler output to /dev/null to hide it.

And the build system prints a clear warning when this occurs:

  Warning: missing liburing support. Some tests will be skipped.

Because the user is properly notified about the missing dependency, the
raw compiler error is redundant and only confuse users.

Additionally, update the Makefile to use $(Q) and $(call msg,...) for
the check_config.sh execution. This aligns the probe with standard
kbuild output formatting, providing a clean "CHK" message instead of
printing the raw command during the build.

Signed-off-by: Li Wang <liwang@redhat.com>
---
 tools/testing/selftests/mm/Makefile        | 3 ++-
 tools/testing/selftests/mm/check_config.sh | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 3b222cd6a048..2f6d2a207a0c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -262,7 +262,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
 local_config.mk local_config.h: check_config.sh
-	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+	$(call msg,CHK,config,$@)
+	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
 EXTRA_CLEAN += local_config.mk local_config.h
 
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index b84c82bbf875..32beaefe279e 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -16,7 +16,7 @@ echo "#include <sys/types.h>"        > $tmpfile_c
 echo "#include <liburing.h>"        >> $tmpfile_c
 echo "int func(void) { return 0; }" >> $tmpfile_c
 
-$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o
+$CC $CFLAGS -c $tmpfile_c -o $tmpfile_o >/dev/null 2>&1
 
 if [ -f $tmpfile_o ]; then
     echo "#define LOCAL_CONFIG_HAVE_LIBURING 1"  > $OUTPUT_H_FILE
-- 
2.53.0


