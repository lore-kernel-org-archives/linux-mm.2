Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1112FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6C96B008C; Wed, 29 Apr 2026 03:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240C86B0092; Wed, 29 Apr 2026 03:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109246B0093; Wed, 29 Apr 2026 03:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEA026B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:27:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 921A9C1E43
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:27:42 +0000 (UTC)
X-FDA: 84710763564.25.C264B9D
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf12.hostedemail.com (Postfix) with ESMTP id C6BFC40007
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:27:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=KZJmf8mi;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="Ph/AGL2V";
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf12.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777447661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyvqRSJSM73q2bj8SRnjn1jgWkm+YanSrvLR5MkSDLk=;
	b=BRZoKjpZ4jkEKU4PDUdNETkbV8EOjeVPjDtafGgk/SyoyuCN6CjoPI57joUScq7SVYAD4W
	TnJmhQB/B6fO6qYGV/wwJ2LzmAtwEnhxxCnmGijAJJEjF0ghj8wp7jFo6r+KbpIxh/dlzn
	+sZqfURkXW/Y7w7wiemXgZYMdAzd1YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777447661; a=rsa-sha256;
	cv=none;
	b=dWSS0daO450CZHlFkk2ZfUk1EH0EADVVcGjeavZ39hq0QPwFtOmylymQfyc6m3lzedgPQk
	oWo62hh2VixbrWauZcft9OIDx23h/bCe0rXslXOGYn0F+aMJkIy+qkw5qzliF+NriryaxZ
	/KtsSTceF1EwM5enTlZISqFhjFQeedc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=KZJmf8mi;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b="Ph/AGL2V";
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf12.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4g585l2TXQz9t4r;
	Wed, 29 Apr 2026 09:27:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777447659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qyvqRSJSM73q2bj8SRnjn1jgWkm+YanSrvLR5MkSDLk=;
	b=KZJmf8millWJRx0w9oer0vD9Ui6ca81VwWTXAA30WK1rGq/2dNY7LxlVrS05PJu4FXtTBM
	aofBbgOsQ16jDPbmdsh5tQ3JO/2IgVdwO5ogNmf57b42XwcnU/7StnvM9wMQIHrPXZnDPm
	dDfEToYsFIBnuAio0Cl8nFj3k4pHO5BJRJZGIcZJB1hfNQm6HhxXSFsgnu/2JevHys8Tsl
	l7PS4k6l3ZvR2j7h26/TScHhfaLHu/B/q9gM3y6f2k8/4f+j8+VBenazkInH0mYGISyV1M
	a89Gs0eEK//0l7YJE86TdiC8BlbagOkVXBT1FlQr++vIATtWP9G4J0hBf92TaQ==
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777447657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qyvqRSJSM73q2bj8SRnjn1jgWkm+YanSrvLR5MkSDLk=;
	b=Ph/AGL2VBQ9Sqg8b37oLd04HHK3L0jfLdUIXiq76BjAN7Qiv7SeVYzxwWmW1XTk9uFGKEG
	2j4N2RZB3LVajAxzxXL8GeWrpgxZI4Z/odt639rN8mtsN0M2NppScWeZ+tJ6I6rXNxnYV9
	GozinWKyDqR5SSCU0EZ/L+Uvg/Am+ChGgNhCVfs0L6Vwfy1wODi+8FDUvmgTc9cV1pdJe/
	n5NOAXTEoSZ2DJ/WImLAKl2iOu32MkcgVs8xbhG57v7OHiOu8ysnZnHR/bJu8AExnqoCNn
	KoaSDSAzZuo6K+cWJQ+LrgJcEfKFfUtWDfteSnuCsqNIfR3dsedfI9c3Hcd+7w==
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org
Cc: workflows@vger.kernel.org,
	linux-mm@kvack.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH v4 3/3] Documentation: deprecated.rst: kmalloc-family: mark argument as optional
Date: Wed, 29 Apr 2026 09:27:04 +0200
Message-ID: <20260429072704.311603-2-manuelebner@mailbox.org>
In-Reply-To: <20260429070759.309110-3-manuelebner@mailbox.org>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: b04ec1542f739eb7150
X-MBO-RS-META: 89orio9eoe4yn574r1rzwrwkhunkhbee
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6BFC40007
X-Stat-Signature: ru4wus5hdxbehc1kj16mioix3tkfptsf
X-Rspam-User: 
X-HE-Tag: 1777447660-181150
X-HE-Meta: U2FsdGVkX1/K3NM6/ET63Zg8U44FgZXkQtfi8VTavLBrkKTaxmLNuPWVlOwU0i/wk6O6T88G0EVOa53OUWOw+yTcYw+gtm+wgVFDgov8V5qV9t/G6i1yW1pjlRRbcmnS763y7c2vMtyuDd9pU0Nm8Om6KIzoXsyPwn6Tskys77OnDQOm7gN7agkQqAWCU9DnkJKxxPI8J0NF/YDAQ+5CL7/87DqO92rsH711cpjzdYDarrWyy+KbSvLb0df77p1f+I8X3XAorSxXd2KRMEoLoDx7HfsdDDSEuewcVOmnBqGfwABIB++StqQLMODh1Us4GSJC5/qe0WycfhghBGb/RMeBa5s3TRjop5zDLK6X1fDSU8kt1qNtnlB47houy8bjni+Q8+ZabfNhtiRVGfdS7otasofKIIbP9SzSyFIPekkNxZdhrGlZjpF6yqvSAtkQnnQxcAwFtsS296x8WMNe3v0J8o3gPLtt+Yii9Md+7GWxqZeGvul+GkLI8OiHFB0LDDsM4XjkljgANJYZulCmoVJBA4NuBMe4o3s4HkD1UIkxRePwcIT2GVUITY1mXXCjOQs5aZktmEmrfYQ72Kb1Fn+oP9388DOs+x9id96251c9UDeZIujI0iQB63uVGcV4scv9XibUwFtlyXYmYojaieXxbfnYN0sJgy7H+Ld6hFOtqQmamierz0ibX8gispFPnr2RvVVXE+eObdarRSJiRvzJ6qMBsrPHiSbKz1kAEWjAKD3vU18bVy/LZ72yMGwoSczF4dENR6WdUJBJflW3jM12hH7LexM361d/tCCHq0fkRA39371GaVSHH2Lf6zGn5wy90B5pxJ4ZFa6DKjTqw8O7YoA06RV40SjSNDFyRs3qH1ty9PVmWpeFH8o5pfPEm/Oa/AUIBoqYNI3IkPhcCwWgXtNOFdDmTJetxUYVHK4nwDplQyHWSkeTEoWPs9MaQZRdDL8d68zrfslKhGB
 6HHf+HFA
 MoPL8z/LbgwRqF8e7YQgHuwwBNS6WjrS34ly7Xzlarov5WtjA7TMOeVIBvvjm3fzbiplmWq9yIhIKLOhTW2gT1Wyn1kCGZF3uazpJqOozJ5gbiHygdHxMGGwDYuwGdKlPuEJVguhTYqwYjxjU7WTXpC/2oGhREjzSvzS84Hx2/bSMqtk0/N06DTS6aVis74mOBXtxJ0G5n0qdD8MrDVOoO61gAra4FalzEexLFFIDE2xGiP6Iv2y8b+HEER6aViHP/BiWTtT8IJ9DIr9+GJMFv0kkse18NZpK7j/DINXtAr0zjT4mq5c/3IsPCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

put the optional argument (gfp) in square brackets
add default value = GFP_KERNEL

eg. ptr = kmalloc_obj(*ptr, gfp);
 -> ptr = kmalloc_obj(*ptr [, gfp] );

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/process/deprecated.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index fed56864d036..ac75b7ecac47 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -392,13 +392,14 @@ allocations. For example, these open coded assignments::
 
 become, respectively::
 
-	ptr = kmalloc_obj(*ptr, gfp);
-	ptr = kzalloc_obj(*ptr, gfp);
-	ptr = kmalloc_objs(*ptr, count, gfp);
-	ptr = kzalloc_objs(*ptr, count, gfp);
-	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
-	__auto_type ptr = kmalloc_obj(struct foo, gfp);
-
+	ptr = kmalloc_obj(*ptr [, gfp] );
+	ptr = kzalloc_obj(*ptr [, gfp] );
+	ptr = kmalloc_objs(*ptr, count [, gfp] );
+	ptr = kzalloc_objs(*ptr, count [, gfp] );
+	ptr = kmalloc_flex(*ptr, flex_member, count [, gfp] );
+	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
+
+The argument gfp is optional, the default value is GFP_KERNEL.
 If `ptr->flex_member` is annotated with __counted_by(), the allocation
 will automatically fail if `count` is larger than the maximum
 representable value that can be stored in the counter member associated
-- 
2.53.0


