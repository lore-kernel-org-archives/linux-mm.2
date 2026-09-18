Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5AF1C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3476B00A2; Thu, 17 Sep 2026 21:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9826B00A3; Thu, 17 Sep 2026 21:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691FA6B00A4; Thu, 17 Sep 2026 21:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 333846B00A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB29D1C2124
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:43 +0000 (UTC)
X-FDA: 85225193886.20.8386046
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B9023C0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NE216Ui9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789696001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sn1phcmIUsqYDE7FBADv0MCd5ZBigkQob+Tfo5WLJXU=;
	b=nsRFUYcEfipSIPJH5NBGnUfaz7n6UwneV4+uEuNmotOIHhc+w97HudDXJ7KYW80iIuXCBX
	RaHD0O85e+/NazVUHACTV6acc02KNkw5LdY5EmUJCLwHNntKO+mOEaqBUziNW4AVdcQ8if
	iCuyBnYBZgQsky5jNxNfWxda0V6D+/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789696001;
	b=DYqynxwSuewBvsMlZnZ2/6BZZPsSm8WNSH3ficrljeqsVc1M8/0LpUfprQuEwLyLN2DuuI
	el6sKxi+Gimp7oEJevtXJTh77k6SXS+iMl0RSNfAfai6t0EV4GaO4ejwStDHXgvziJmRv4
	QiEhqyjSKb2eSq8we9gq/5llCJXfgBg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NE216Ui9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789696001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sn1phcmIUsqYDE7FBADv0MCd5ZBigkQob+Tfo5WLJXU=;
	b=NE216Ui9+aZkz29E1g1o6nkFKCzYbkMLU/laAyQDGUD0d1sjLjl4bpcby9PAIWXLXAcxwm
	pucIHxfmKgKSgDEtQkpYbJ2OFmdha8Njgr124yxDFWAJXXXiP66wfH0479Jh2X5OyD0Kew
	/fHHBw7g2TXe5YYsiLFGcGkSCp/9IWQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-pdNvms8EOEm0xi0nlB4bTw-1; Thu,
 17 Sep 2026 21:46:37 -0400
X-MC-Unique: pdNvms8EOEm0xi0nlB4bTw-1
X-Mimecast-MFC-AGG-ID: pdNvms8EOEm0xi0nlB4bTw_1789695994
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B0501800148;
	Fri, 18 Sep 2026 01:46:34 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A633B18002B1;
	Fri, 18 Sep 2026 01:46:30 +0000 (UTC)
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
Subject: [PATCH v8 07/14] mm: shmem: allow THP support determination at folio allocation time
Date: Thu, 17 Sep 2026 21:45:28 -0400
Message-ID: <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 4FWXA2hOeLeRbGWeXuqKgUPoBkRcYzf8GshOgPG3tN0_1789695994
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9023C0005
X-Stat-Signature: 495p73f1k9iq7gmiibftm3xaduqz9kie
X-HE-Tag: 1789696001-345474
X-HE-Meta: U2FsdGVkX182nShLXQRWVuJKpv1VZPbNT+ezUfs11dhYbXghsz/MZKWgXjDqiI0ggOnkz0kGUmpI1G9iFVZ1hP+MLrl6vZ0GP8mrYiPVz/vAK9VNIrgMpm4LVHzMYttsCy1l0UMtQuf0nzpcZwdjPr7vQ7lI0mfjfeq5srXmCWZgC+dweii0Tq8m2SysyXUxTJ3i0mJrFdFiQZkvb3Vp9KLn23wPE9d3nlYDM1Tio6TNYQCIyh9EjrQ18l23jIhxhi99HpUP6rv+JYwwTnV1/sRdAAD0mQwAofPTMSnTcibb852Bey3A+n7OUERnzQziA8ObuMajNZqGd744ndf446ZoWH4HAFws4KITUglPHeI2YL2VjAkRIlaWqgiHR7JICi6LQHC2y8hZDpVxmGGzj5E3hpMb8xkQSh7O6uSih+XFwT1bVkKQrcr28qhfUTLhFHHiXcRr/nOBJOd2LhSkl48XCUqCMparUGUS0G5aza/4VkmdBhJX/qQ0pHQpj/nPnWiX8ZOllDXK+fqbqJ+3Ayvtjg3LeqG92SoeVdpcmN9cxJ/SNMW4oWDGZG827wxVyOBeFC4UqKmUsSjGePYcxmSScm1iXZ43M2fdtSmmAzr3UouAz8YAu4eflbcYBFFYgaeqlty4SpOXPORFttPl+TFNRWioSlrlQQzYW6+nHsQcppweDOYDj7t9NKACB5vZkUZDIr5E+S2hob8DLBwZCt52acxTvmMpL4RbyW4QeKyd6/r/NW7SDmFwhwmSHVbZAQP06iPfmrX++kEmUWHqJWuXSQMQg77WqPYrxG3ukN/978HC5fOouBhMmWU62OGIHxw3EvJy6cy3iai1mBlmESsCju0E4uj+ARdx2seNvcJ1tr3ViUnicQ1brT9ek6n2+c5Na+CmTIoHWnuHfsgneZoFbtKBOwUvHxOiQvh2aKkSxCgAEutZ7K+455hWrT7SKMDCSsr6FkpgMAAieYR
 Ry144zrO
 nfcHYMFkw3quAGajIV3Slf8YGjlFL0yT7Vf9I5BbnGlQ5N0LgtzeDq2pG2hmd3L8q7fQvbOReRDp1vGigYyDHaz1bjquJzmx5TsIrRwnE+uFfjZPV4Kqj0fYei4XI2tQ94VqoCcCYOLNw87bI1bWyYqyMiEG7ezFEXRZ3wmhMc3qjok7tjG1o+fAQik6upyOgNhUyjoudFo9ZeV4483z7x3Dat6O2PmFwavObP6lVkdbTFUIl2huCJnB+0LvzqKflJy7XJQSXeWpNj3qmK580a42ZJp0FYOsBK24SY9tMuLlbmP2zwz+kuXrkOCA3zVFZruiGJMxm5N3xH7TUP9FdN3D3EHxuuy/Nwk2Cm18wW96Be7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to enable THP support in shmem today, besides the user
configuration required, the CPU must support PMD-sized pages. This
is the case because of the following has_transparent_hugepage()
usage:

- shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
  if the CPU supports PMD-sized pages

- shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
  the code block calling has_transparent_hugepage(), the
  has_transparent_hugepage() call is exclusively checking if the CPU
  supports PMD-sized pages

While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
in all cases, shmem can determine THP size support at folio allocation
time. Therefore, drop the has_transparent_hugepage() usage listed above
while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.

Additionally, we need to check if PMD size order is supported in
shmem_getattr(). Use pgtable_has_pmd_leaves() for that.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/shmem.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 776dff8a848e..930657d05375 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
 	else
 		return -EINVAL;
 
-	if (!has_transparent_hugepage() &&
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
 		return -EINVAL;
 
@@ -1524,6 +1524,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
 	generic_fillattr(idmap, request_mask, inode, stat);
 
 	orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~BIT(PMD_ORDER);
 	if (orders)
 		stat->blksize = PAGE_SIZE << highest_order(orders);
 
@@ -4814,8 +4816,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_huge:
 		ctx->huge = result.uint_32;
 		if (ctx->huge != SHMEM_HUGE_NEVER &&
-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-		      has_transparent_hugepage()))
+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 			goto unsupported_parameter;
 		ctx->seen |= SHMEM_SEEN_HUGE;
 		break;
@@ -5620,7 +5621,7 @@ void __init shmem_init(void)
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
+	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
 	else
 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
-- 
2.55.0


