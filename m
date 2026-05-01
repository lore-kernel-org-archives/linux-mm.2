Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22952CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5EC6B0099; Fri,  1 May 2026 15:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DBD6B009B; Fri,  1 May 2026 15:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792FF6B009D; Fri,  1 May 2026 15:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6609B6B0099
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:20:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30C8E1C00F8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:29 +0000 (UTC)
X-FDA: 84719817378.10.AA10B4A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F2ED1C0003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:20:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BZUk/7IK";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vI1pVR9OhMfQO7McpLsXLDDOj63yJGYULZKGOcQ3TPw=;
	b=lDc7Rm0zxHy5+/My47bucG4s27ssAHZzeMt1fXAiwtT0oH2RDTwH/p8Cp/zrj8lX6VEhjn
	lMlKIIIdkFxwum5n8tKTwJcjXh+arlJkinb1KzDFXhe2wsqf1OjqtLO3fSzXkZlPrjr32f
	Mw99s62ZS9MbEyWKc7HCxV559dVglz4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BZUk/7IK";
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663227; a=rsa-sha256;
	cv=none;
	b=GxMOdYIjwA/r/ZO06xUg3xZkU3J+TCigH4wanv0VwVXhz8XmVUyuWuS9WeB67MKikLRYBP
	RMxt+KCjzNvsvJWCUqo6+r524BSEAu2cFVIN2YwQlGkUBUf+y6Fi/zFdgrRM/rblyuvvpY
	VjB0haIFFfAENYfi4sKOTK+ggr5Y8+8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777663226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vI1pVR9OhMfQO7McpLsXLDDOj63yJGYULZKGOcQ3TPw=;
	b=BZUk/7IKGv/gL1ujE+E2GXSji2yg9tKPBhZGW78SAKAnVgU0KyeBmsz+75xCCYF5Az2pYo
	zoCeiwy7jhE/c53W2mQHFWr2OG3lLwBAbLRb3V+8NnfbI5nDaEs/I8cLDJG4UizWseomao
	nY/+Rh2N28a2/3GCX/jfA5RaffmOlbc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-DcaIPPpjM6eZpCNc6flWOw-1; Fri,
 01 May 2026 15:20:20 -0400
X-MC-Unique: DcaIPPpjM6eZpCNc6flWOw-1
X-Mimecast-MFC-AGG-ID: DcaIPPpjM6eZpCNc6flWOw_1777663217
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B33C195608E;
	Fri,  1 May 2026 19:20:17 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5096F1800345;
	Fri,  1 May 2026 19:20:14 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v4 6/9] mm: shmem: drop has_transparent_hugepage() usage
Date: Fri,  1 May 2026 15:18:48 -0400
Message-ID: <d2d1d0deaa5732d82bc2daea5033a1578781d641.1777663129.git.luizcap@redhat.com>
In-Reply-To: <cover.1777663129.git.luizcap@redhat.com>
References: <cover.1777663129.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: WBaXtBpMonC8CVxnMbLO3P7W0GZU9U38nttJXC9dD5k_1777663217
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 1ijzkytgyonau5pm8ry6qwsrqtmucm1f
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F2ED1C0003
X-Rspam-User: 
X-HE-Tag: 1777663227-926348
X-HE-Meta: U2FsdGVkX1+WxLWXConQbNm8enUtwgzIyVVnYRjD/yKMWm6zsvzbBORkVwwKsQ7nGDrt2IoWB/PwGY3Tn2FLxLW+WIvjkLytJPygcLAIM0KXAdB485N2yA11nSGIrZvofsyGRrZTrz0JgdaFAfVsUD23msgNcFxZttdgZonX9dvJyW7XtJsZOQfuFa+CxINdVQa4LVecWXn8DuEMlgCLF5pGmS+fW01+pL66fAY3HSFr0FSlmYtrVboDQ0P2WWFA1BwU0xITqr5BeBA9+AXVMiMiIJiAdk4OKzdC/HZ6sCUEqM+4y1SmaOVro3VslpOA3UpVEVD1zVzrXl44LOvRa/GO3yzun0iplDW4FddYlye4RMOfHjkYyCg4VFj0sGVedlt+pidkdMbGp8TiM+t0nG+Qa8qZZrf/5e0xnjrPQ70R0Q8ZzBBC/Rw5Nba0tYMsk9sYv2HrM44+SEsi2XAEOCBJIY+TZmIvDYs9eFLZDS6rxs6SYauzO6SH+eCqx10mvkSdTPUiJnB9hACfETIg0FndIQrmRMo/XhKSjcA/30MKHxGJhFeOGN3wIglTzOwii9BFYDMe9VkExMAIsYPW/nIRoxB7Eyxueoe4Gt2GGN1BI6RYdOLTp7DBKhFQpPlFQUm3rW85B0tozPR1lAsTbXDcygLT6KXlwPQbnINnucHzp1X9cGb4Y2Wj64t9FMwxYZPB4P0Ul3fo1N0pugyCKQjGPillQqApp+jjkfRLVbjbTZXabkadzl7505Zhn87Yq1ochvmLb2cIAFKlejsj7KpeDiBEQ72SSHiILZOdEJDMd+IbDXZpmMBn2LQxbDLbgGAA0d/mXqWg2ZOkMFYP5aFY+J51N9at5fqBOz/fPfbbSHx44j9XkFWAjQHgdZWw+6Q7GwD9TPWsBr+69m/2jnQ6bSpqgUIIMwV2ke/nB6A+zczAa85ywd9Yq1mRjWxoDzuzq3N3I11MUFJPx0F
 ljDT/8zE
 LT/+bqQRznPs0wj79Uc7JSo1fdxMn3Sy8F5vOgFBd51yDSQxyW+9Ye78odIcA0KZa9Z8cvfwJt7tJxgo5iynQztgvc3bFoXEygDgFzTLoAiwoBIJj40C+hzTkKUdHbDjxFVkbHkIgy4Rdxd5BqrdUc9LsKNAaGddUxHZM3nphpYMsoDl0eK1xgnxRf6h4T5ejRb3fvOjsQJZmlK1YPewPc0hEwmuEWmfcbKstzwynKoKMW5Z8XkzpzxSdcnGHzKpXjZg5c7im8SAeYhb1ZeuKX5Ep9n9zAJ3D3BNXJMVHgHk8WVSSSNFdA1zYM4vJSKeS5xhduw2nARxBD5/cYLg1ai8B0ADAA+MCEc20GPWsF3b6Y6BnKYWEPs9tDYZDNtOTTaUtb77tp4rh+ZTWIC6JXPWHVA82eWsr4lcKFfM+pGjBEXn2YEnja6KtQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shmem uses has_transparent_hugepage() in the following ways:

- shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
  if the CPU supports PMD-sized pages

- shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
  the code block calling has_transparent_hugepage(), the
  has_transparent_hugepage() call is exclusively checking if the CPU
  supports PMD-sized pages

While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
in all cases, shmem can determine mTHP size support at folio allocation
time. Therefore, drop has_transparent_hugepage() usage while keeping the
CONFIG_TRANSPARENT_HUGEPAGE checks.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..1948d73fb1e3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -4656,8 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5449,7 +5448,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.53.0


