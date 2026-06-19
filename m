Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5350CDB46B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 15:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872CA6B0088; Fri, 19 Jun 2026 11:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD286B008A; Fri, 19 Jun 2026 11:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4E26B008C; Fri, 19 Jun 2026 11:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF6F6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:47:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE0BFA0501
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:47:14 +0000 (UTC)
X-FDA: 84897091188.26.B489E82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9EAF8140008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:47:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FEByl+I+;
	spf=pass (imf26.hostedemail.com: domain of thuth@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=thuth@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781884032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GAzDhoVdtpZYLl4TTqX1/urTejCGM2zR+/1agFVZ7Hc=;
	b=7crKg8O6tQq/tJxTL2UVpz9cu8Zj/qRmDqnfopW/hqkWAfTJrSOzDdjm40zskxnnwl7mFU
	cwR4LExfyzoGs2iB07CHH5e017iSGrDCq3Qg5O7d+hF02A7v18cQfkK5RE2INgW9Krs71B
	ytFRJwz32XH+sLt834gtsaJ5ntm7pkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781884032;
	b=DljbpZkYWBzdN4ry3ZBG7YmHuHMrSnPzsiN/GGp8KROxbTUzatj2Z6ixr3jlIxSi/6WQFw
	MKcUXjOgTge1AIZnlqpLtaIhnmR+PkylySDmfHWqUKW7hu3DLmt2Ii37eFMX7BRbnrxgBn
	tjrooiipC8KsGw2DpQyD6KfnnfCjx0c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FEByl+I+;
	spf=pass (imf26.hostedemail.com: domain of thuth@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=thuth@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781884032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GAzDhoVdtpZYLl4TTqX1/urTejCGM2zR+/1agFVZ7Hc=;
	b=FEByl+I+PGdpbTblYSHa8bFKW3ZuNmemnr8UUH5vNQiSVPJJFAq+lSbibOR/xqj4D+3DMB
	rj82FoEpmkxyYEzRAcVVI4+vGorGEtMXkTIPSvvkfPaY8M/2Ru8WylH2eWNfqw4J0Et9vy
	EYeU0snU8ijEJvbj3RviAZbmeNIrSVY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-yXaf8j-cNdG94rlTD8-fZw-1; Fri,
 19 Jun 2026 11:47:08 -0400
X-MC-Unique: yXaf8j-cNdG94rlTD8-fZw-1
X-Mimecast-MFC-AGG-ID: yXaf8j-cNdG94rlTD8-fZw_1781884027
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 639251956040;
	Fri, 19 Jun 2026 15:47:07 +0000 (UTC)
Received: from thuth-p1g4.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD3101956095;
	Fri, 19 Jun 2026 15:47:05 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: Replace __ASSEMBLY__ with __ASSEMBLER__ in percpu-defs.h header file
Date: Fri, 19 Jun 2026 17:47:04 +0200
Message-ID: <20260619154704.41293-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: cOYjttgxmKZK_xuytE_AgwP63fPjh4dOPtZpZeN1zZo_1781884027
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9EAF8140008
X-Stat-Signature: re7qpy5r1xrwyoyxpgaco3611rj7ssu3
X-HE-Tag: 1781884032-353366
X-HE-Meta: U2FsdGVkX1/WSEQwWkNZi9Tcbog2rAVvz9vWZbIbZb13NO03jBr9e6XCp+RqouAqCiRsKYhLUyIKnO93l5BX/Wwr2AGNoqrtuVh1kQ28wb8Ty/4GjqA8T86OxriqFasIweHfVngr9qGc0IH38mgLQajTcrjr8vnlBVPbGAGtDbN4ByqJLkwCE0ZK7pcW4LcpoXUDrHKyNL1JmFeRM1UkvQFoGHM5ewyVPkTiDI2RzVV8ABrDJgoLjpO+axAaWY7krh8oaS4Xe1ZcNssA62B0qe3nRjRW+dT7MYoikwiqktJ5eu6Ad89Dm3ZHLVhK3OKTwAY682nwHf49P7WbNk4uLoAkjPeT3WsAVlutJj3SBDKZUg8iO3UKxuEyti78dy0tjuvmHmn8qPLQR3WZycJhuo1XMxDJ+FXzHu7V1H22BRbynfM5lZvw0V4vqJqOvWXXwHifQ/wGbCv1qNnQ2DYghSlm5cfTm/HJ9PdP8VO/ot54hpYhBSfDhAbUaObxX+3xU72ZilWZPTRfAbFlIFNUlDlpPIz/d9YZ8bFh9CP4qN1PD4ymrk7k0Yj84Jud2DlywUC2NvjgZkR0CS92zidpV8nREozQgyVn0D5U7CTuHGZ7PiKhRdnPImOEEUvD9cqFInHBsMW/opE/TMSeceKG9GOAW4itjKXNQKxOJseTGnqUUux0AkP87Sy8rGl0qQnlA0r0mv0qdt8Bbcc2itrQ+MyvPInDUoywdic68IU4fo76aEBGBNIebAnOX8tyRcmw0QON4NXzNtzwyVZxc6GEqctXgVlychB25U3ikoBRERQMhPerQBNeQ5eRkubzXgoMjil8CcwHiLza/ZD1ZgqCsSAN8HKLCcGH9Lp1EwIuZXcwo7XK3STNh5Q+faI1fdaGj3yG2ZTay9+iZlej2ztp4DSQ+OWugQsancki6u1AmBsR9INriEj63NeaTDAgKbhOv6ZFjqwKCHeVDxu6+AT
 y9iAjRQu
 d29fFrcnWweVe7jgSXC4C0XSKBbRaiDNRY5k+fAMnzhZOCYK+FIcAvQRy+PGo/pohfWY6lKim27uXCH0p0XLzhpr4D92WcYTsLwH6UX7XwAGOSAQVTIlXhv0ldIKlKG1SqyJEmtQ0fuXPegMYqEH3LqBgKrXzt7XfvFwYx0Qwvo+PeRpgqX+aPmxD6t4mhSyEawQy9pDJNCDRkmqaMhSGLu1Kh5v/3gfWOwjh70yTZChRdi1ubTe9iuB4rBse2akPyXz1fxZNzlLSABIcY4AZt+DwVzslgvh7N98t1qkEFG4fepUo2e2IhjNu7nMjUW2EaIjn+EviGowK4HjUK7/4h/AjDgFtK5mVBHDBr5co5q2b1v+p/UJ2FNrLwtbISN6gV54f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thomas Huth <thuth@redhat.com>

While the GCC and Clang compilers already define __ASSEMBLER__
automatically when compiling assembly code, __ASSEMBLY__ is a
macro that only gets defined by the Makefiles in the kernel.
This can be very confusing when switching between userspace
and kernelspace coding, or when dealing with uapi headers that
rather should use __ASSEMBLER__ instead. So let's standardize now
on the __ASSEMBLER__ macro that is provided by the compilers.

This is a completely mechanical patch (done with a simple "sed -i"
statement.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: This patch has been split from an earlier bigger patch of
 mine to ease reviewing.

 include/linux/percpu-defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 43c854a273c3a..2cba7cc2b01f9 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -203,7 +203,7 @@
 /*
  * Accessors and operations.
  */
-#ifndef __ASSEMBLY__
+#ifndef __ASSEMBLER__
 
 /*
  * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
@@ -514,5 +514,5 @@ do {									\
 #define this_cpu_inc_return(pcp)	this_cpu_add_return(pcp, 1)
 #define this_cpu_dec_return(pcp)	this_cpu_add_return(pcp, -1)
 
-#endif /* __ASSEMBLY__ */
+#endif /* __ASSEMBLER__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
-- 
2.54.0


