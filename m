Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F02910F9976
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624D26B0005; Wed,  8 Apr 2026 16:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D56E6B0088; Wed,  8 Apr 2026 16:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBA56B0089; Wed,  8 Apr 2026 16:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEC76B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:23:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECAE357D1C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:32 +0000 (UTC)
X-FDA: 84636513864.13.A7B7C3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0377D140004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c6CM9nw1;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpd53IYBKPxfvsuuiOqR/eqPWf1cD9+LMYnfXG431mU=;
	b=0JiBnwqfdj0XTf6jiZNmvE9iMwhzYMdxL9T774hrNsgj7NnKPqrhaPrFy9Ma9eJuZqC5h/
	S7v2TjnR4JV9busZHUIUzzouq23PPKzIzww3/VBlHwPXuzZKQvRGkXrsFOodlcDRGDKJle
	7zSMCb/2eSbvILqX0l/N7Uz2nTSiWDM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c6CM9nw1;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679810; a=rsa-sha256;
	cv=none;
	b=ZKC/9aURtDp4eEvRs+ENm4LCaeKK0b/mUVnbsRIpvmDxk0jLUM5q8v1R68cdY7bOTTXuWi
	B/1boO4X/LOQ/5kwCZQlmS9BX/HFbAYvklZ9+/qtJcey++CCuZKXF3F8gfZmnepk/gC3yv
	S24R3vze4lmnZmYL2fycp9Vo15fphZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dpd53IYBKPxfvsuuiOqR/eqPWf1cD9+LMYnfXG431mU=;
	b=c6CM9nw1/A3RYkKHAQ6VAa/MvvgfoiSWtZUaiTcQQr7Zhn4vPKijSTkNP2K7Et1Ok8pOXL
	CFs1VlYEB+10Gl6nAFCZi44vitrCrLa99yv4lixS8DfklROSuG3vS3oeB27uvBtUOzrlvJ
	g0DQWK28x6WC8MVkUeN1GOCc34iVbtk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-CwFTT27VPcaMhy004THKQg-1; Wed,
 08 Apr 2026 16:23:25 -0400
X-MC-Unique: CwFTT27VPcaMhy004THKQg-1
X-Mimecast-MFC-AGG-ID: CwFTT27VPcaMhy004THKQg_1775679804
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65E6A18005BB;
	Wed,  8 Apr 2026 20:23:24 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0BF50180075C;
	Wed,  8 Apr 2026 20:23:22 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 06/10] mm: shmem: drop has_transparent_hugepage() usage
Date: Wed,  8 Apr 2026 16:23:01 -0400
Message-ID: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: gPXNVKezzQgPhxveTBAQR47NfBvM1LyNN1r3RH8MVys_1775679804
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: kf3oopjtznu35cqkgk8e3bfi3u93hpcn
X-Rspamd-Queue-Id: 0377D140004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775679809-804222
X-HE-Meta: U2FsdGVkX1/OrgIwxpAdVceG/9lSP0vJT5hT6q/aaM0zu/n0IfRos+JH0e8Qd4Y9qL0dO8X9uEyYz4nyUXyHOEoTecoolFQ6iujKsHXzSovtY4HcKBA46W5wuU9/D4gQng4v/X5UoYn9iUM4AY39f8k30Bc/GcXS2Tfa0L4Lj9DH/UMiOisxznFnD5SOo+IevEN1EjZCItyOgfMxyp2KzH6Hz5AV1RCekhQTNnOzp107IRsWu75Hk5VmIFN4rgCkYFGNwGMO4SDlyh0VUVtL40OEp2tN3kWdHd6PIpmr5SIA5PMt65Hzl61PmBYjZsf2SfumpSR0xbDQbnuEkO4mBPUDD4eCF9BdPtzPh6BfUqD7IQfVmSIgNPHfW0aiWIyFkSx2iBXe/gh8Sjog0xddIxKE7yO+sW3nQCUpf8vYKPf6W96B/n3fqwbig5Sa4VLBKftP5UassaPE6Emn5WK6eN9ITs6X3pVb9/94K40dtQbMPgHhM9mOCwntWsGD4r4E58vQKx0OZ3UOHbchTefv+WuiuMQ6zoDGta18VfoAGk+zRGEhmp9qDZObmSL9H8wFGbsHqjcpa75OrWwVjyd3UZnPUNChp1vb0RxAHdXOWrPatuagPXIiviOjTQpPWgCWtTmWrYMYvI+K/OQYvKTSlbdp9PQ4cQHo2NhcOSGbiGKnMYGgB+mVlaUot7clEQ2ONJrw5oSr3AgkRyr/TEtUXAXcJmb7450JZDpevSQD3LI/hV/jF8/fEXbRl+Stez6MbY6XZHrvZuOejCdEIi9P6DDdPAUsqPMZSF+aIIPBCxbOvuuyB8EUCtsIbZ9YWxvEN5RAD4Ah5WMweY+zMmrsuGlt/iy/RlGXS1cR/LMjEkqSSctOjjC/bavBwwlVF16QcoTRfdjg7Z4RXd3+vDSzRtSFgQSrND9FiDqePHQudl6yFWaAawQv0H0XkLJFA/Y/oX272rqWoWdou+XWNZ3
 OKW7t6AZ
 BAySgFUoBo3hNEdBl0QNePZOfFVEW6AOc17+YGRBwXPK1UvCaWyIzqzSCRx+0MX3EphG9woZUKpDks2TPxMSm4mYWxBJJRu7zD2OUtSkPDF9lzDrdphbNsck6ZawegmUISPghq4+94djhjJrr5VpHQoyHNPp1cjCuyLSCxKhJVixuUb02PzAPGMJ3ymgGw/cBnzhWh/oVf4Cl2QzOXVoLtcQ2uHtF60gke05H+KjcwO4o9AWB83I+1r9NDa26nNbxjIZUdSYi/36FWXyipxEL4bZ+yCjWFjwudScamEOK71CgKWTN6A+ApSr1a9pUSBjvJbqXjOO4TgmsMhLdQ6DvZI94c17OAT83oGZz2EWaSu5Dc5+3att/jgj/avjaCxvq2xTe
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

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b40f3cd48961..6f8b20d77e07 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -4664,8 +4664,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5451,7 +5450,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.53.0


