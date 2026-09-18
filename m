Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8985BC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532C96B009E; Thu, 17 Sep 2026 21:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2C76B009F; Thu, 17 Sep 2026 21:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3383A6B00A0; Thu, 17 Sep 2026 21:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0496F6B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B37E814051B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:31 +0000 (UTC)
X-FDA: 85225193382.20.E479CDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2ACD160004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ9y2JC9;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5VGhony2GlXcldX4fKODtBEKHSnENc20be4cbUK9lc=;
	b=lbVM+xkLcp8Gx87P3FC/Wl9RWj/1ANsLkfexOCLCfyMfV7L5x8N43xReMmHrZA1Tyi6Hw5
	lpWNLJajHAnLuH8+GgDzTzJCjfoZCcH5BnwDy1BArEdxuz/g6gT8qieLZewjgzm1G15fVQ
	7yd9w4D9LGYP6LYpVEEmDamO2DN2qE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695989;
	b=qfbzLaLhzcw6r4EdbYgqgGSHzVtvd2Mqq4I5w42zh2OIO1G8+OtoA6el6ynIuxC2hAcaOE
	oH06D+ZU8VH8jYpBmA7tiXNhssf217f7u7k5wwDJmCNX6yN2NUY+YKNUhZQ9ypktViausV
	+AoP/AHUEKsr9foWXkxdb4NlKL7r0S0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dZ9y2JC9;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5VGhony2GlXcldX4fKODtBEKHSnENc20be4cbUK9lc=;
	b=dZ9y2JC9oB6lb4nWEio8EQhl5+qavF9h7IvxamEF6bHcev3dBnUZk4PgY8zKCcNPkR6+iR
	e09ObBl+oQ9cBgupYoJB83QGU4aIkckoh0pb+eE9R1olynqsHR4qgrDglY1gLooVX2hB+d
	qWRD+eGF5+w0i9MUM2OhgQ6Sb+bzu+o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-_lSHthIDPy2okUaTYnaKsg-1; Thu,
 17 Sep 2026 21:46:25 -0400
X-MC-Unique: _lSHthIDPy2okUaTYnaKsg-1
X-Mimecast-MFC-AGG-ID: _lSHthIDPy2okUaTYnaKsg_1789695981
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94E7A195F142;
	Fri, 18 Sep 2026 01:46:21 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DBC3018004D2;
	Fri, 18 Sep 2026 01:46:17 +0000 (UTC)
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
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 04/14] drivers: dax: use pgtable_has_pmd_leaves()
Date: Thu, 17 Sep 2026 21:45:25 -0400
Message-ID: <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: vg3SDH1C6hfZ-jsxoxy59TIqCXr_H5C7wi6PNC5d8sc_1789695981
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ojnfbce13tjbwxwwpjje643jjqnye46c
X-Rspam-User: 
X-Rspamd-Queue-Id: D2ACD160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789695989-359525
X-HE-Meta: U2FsdGVkX1/1Ed3biYeOq3MqFWfUoiBJ+GS/5ovY36sQRZDdiYoSt1Z6LR69TBizmv4pRuC4s5uZacPQMi+/uNa18UXJc9fDoUUzoSmP/hRFXKz6RkbOAyHb0wCmNHI42rPXynU6aE6QLBOykLa+Gj1++JuLay3roF17/7CXvaaTQnamv1vH3GaAEGocEuYe3KAWtBUoLYUT9FsmU2bWnCuw5cUJDwzzTmJHGOYeufZMX1YXLz/szfZNcu7Yk915hD3yhsZuMNKg6hlfAqNz/7nU9/hoIzmVSL4NYFHueDUUWn1iXSC12W7w6sBVqfCIaC8Ttq1PYsq7iDJlAYSJvs0z7r8FUUaamH5Aru/l3eKsNRBTfuIKmA9cTU0sVaY3hP8P7IPlPFdkBr9DKpSmF7Az2jNeK4ZXZ3gqSpmLxcxf1XUD09WwGU0IuU7QKSatFvQHwOEVJY7Xg0Gr7Pjeh4pylU4F5VuDtwPmmIRAC2e7PITQpNOUUFbnEpAT8ORES2WNm+0ETNIV9wCp9Wmkeu9FJcgAs0SzOCYHDrBP7f3zb8uVNQR8/nqDpEVIgRxliuZogOjfs2eLybSreKyuTSXgHDyB+EC0K/G64+hha4gPRH3yV8ZkpXLIUlxETfzHVba6e6bWGrGzEPo3U81JOpoeesBjSBMBpRgozm1FYOdpM6EptSaJ+sHl7d11FhxN2wXqmIuiI5EcKCSGe9ltZkuqwysPUMcDeeRfOPzppGo/ydorhMuLfsOwbQjsTPuTLklVgLIR95+gJrf2XjXbX5URuMwFtGsoP8L68loU3D+JBtdEtDA//UVaenydu6QYwIOLypECt9Mat1C8qLtKr9gw2jyEtJ3r9w645msnSWYnqbZNMGq+8peqgjz6JjcFx+JM2kKzGktSg9q+c5GoCQKEk+aDQXraADnKubNRjZVU8A4dOB2RbLcG0JeTOxOs93Rmsq7o6/vilEIzkI+
 5iOt+k9A
 3s0r6frC5QnIYR2770lkxtNadn1mXZWtbisK/VZ/bUSwnKpB6l4Wd3xzAP2YovTHJSDObKuwoIds9in+Z8EvL/3/VjHiMpdneELAPhIlKJZfA6XWlcYgUuBe86xPr3j4KjQ4FnZwi9lnZ+3pCtaEL0JkO8683Lo28oI64z+8yKXPXa6uRnPIjsUsFE/s7AMMkLjgKMOsZt7cT1IKPHBR26cmzyzZpdUo6Y+QjKay3qC+sxU5oWAd+ochDxLLAgE4W9fJq78h+rniE8xuJGRQ2qR1xFJ77JaOuShUfXMOTFvvln4z4xoXhJciKNbDw0yYofVSEqHKYiwWrg+QnU8Qp5uZ4iIcrRT5XA/5L4TuZVni6wHTC8FIlsY+iVNBVZ/i25s4IbnrjTQOHzPU59eAaN9Rta4kBC+F4eNJy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
pages are supported, use pgtable_has_pmd_leaves() instead.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/dax/dax-private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 607a53a91f58..18a6295aa766 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -121,7 +121,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.55.0


