Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE204C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D981A6B00C4; Mon, 31 Aug 2026 23:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22176B00C6; Mon, 31 Aug 2026 23:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B7F6B00C7; Mon, 31 Aug 2026 23:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5326B00C4
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B5CDA0352
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:09 +0000 (UTC)
X-FDA: 85163722098.27.737736E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E6061C0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hncj7p0A;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5VGhony2GlXcldX4fKODtBEKHSnENc20be4cbUK9lc=;
	b=0hERPVB5EiuUFFjMKuurG+WFlFUSkg1y3f7CoudyR1D78wONJmkp0odo1gwu5iRa9evHTH
	Xc6faBj/F24B8krG1ZOQn6d20xomyrMSbttWgd5AK/G9gfUKWWaPPlhEazwOVDOkrsAsmL
	fQIvqXrPHYHiZEROfADIkbC39ByT/LI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hncj7p0A;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232387;
	b=f/HwMTqmlk3F+NqQ6h47y40ITgeEchuU6NrmlAHLvvTAlSE1JqdMbZqAxkM8p1C1lE0JNP
	x0hlg8QHsgSzuyI5sDzDcYyHtpvcliE7gyoYuN2zV6rDPXF6IUrQ2PTPej3HmDUiJQ76ZB
	BAADBh24QsHt9/dVfONoi4raEOdVZxw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5VGhony2GlXcldX4fKODtBEKHSnENc20be4cbUK9lc=;
	b=hncj7p0AolMSEfT7BEbN9/gThHSXHOaq8lIcmne64aNuvwccdSxztdlYKOU6NfHZs2jhv7
	9mZxFpt5F75VWFWZp+bvdSZgUv80wOX6F+gtesy4BVZ1w/Kke8LtVmi2eAh/5MTN0/+Kmv
	KYDWeKx26oErKWYTqV+TH7ffYu3aG4A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-152-mDrP8zVkNGum5w-rbgaU_g-1; Mon,
 31 Aug 2026 23:13:02 -0400
X-MC-Unique: mDrP8zVkNGum5w-rbgaU_g-1
X-Mimecast-MFC-AGG-ID: mDrP8zVkNGum5w-rbgaU_g_1788232378
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CC8919792E3;
	Tue,  1 Sep 2026 03:12:57 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C14CE18005B8;
	Tue,  1 Sep 2026 03:12:53 +0000 (UTC)
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
Subject: [PATCH v7 04/14] drivers: dax: use pgtable_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:08 -0400
Message-ID: <bfa653ca6aae4765a026437c5bb231ff839c0586.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: TG31M-iVZKi7ALr9M4ir9YJ8lNtpZUeyCAXpuiFh1M4_1788232378
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E6061C0003
X-Stat-Signature: ywf8dzodj4s4nsxknuq4rx1x11dn795w
X-Rspam-User: 
X-HE-Tag: 1788232386-432076
X-HE-Meta: U2FsdGVkX18IW1hB1Xubef7SMNwEoSNYnav+PDNctKjnxeGWts/xdu6x7L+BFLF0qwgb8lfGskskhZAqffotAoR1BggdfP3CFC49dMHiqFJAP/UUhUlDX3NF2zoAOyAxO0NUMG95bLw1ojB57w+gSN8VnoRu/gU71OR+cX+4nsp9q34A91SIL4xYRlMHLTeXJcIM83KEsi6YTZSdbh9H6RZeCD5TjZK9LuUhy4rhkG/qFeIIA2cEsOyPD6aqlzB31xIVkRvbgR72n0im32L1zinf22PsBtHrzo+sBuDNJJzosNMO/5tYto01bxpgFiugqyHH4E6hH1bTnTB0ZM1hYaaXa2KA1rBx3RvluFwTMo2kf2+b3VGScUXEifKWBcbllXoWan0dCyirYfrUELZSVW7IQlJsfyG0r2jqw84Ew+DwvxrTRGZC1e7QI2732oWbKy6gnfOrRieTPpP/WJ1zm5NsLSj58WyHww4EFzzmTDoTGowbDMEOdNQJA1wRyQpJas5k/gzEiSId+bNPWN7ZAS/21eUNv2ujVhs7ckAS7C0BeSroHkmRDSyK4YAMimOW0ydWCn9SDJSBVl9E3oawjgYDqQNAeLCkkCwwq7ij0jLShYzA880AxGeEUPboTNxqM6MhykBS17iO3BqVHhFLOTknBQoo8l3xndlBgfFaeHeDMN5jrUv0eqcfWpu1xscDv1SgIVb5DD3neX3eHyZukuF7eZA/WXDGBpz7FkyO1bUhCVNQ16ZHuAzgx/99vCozILXFSM8uVFKx8a3hZxskhBDx5uYjYoIcRXyA51AySmbak2n/PslO41PtdbE9FpZrFAX2ekcLhkmZN01xsEiWUJAKlskJde3hTvXgqaZRutywwHbM/vsDQHsu5hmsA8tDaWYPWwHLh7KDfn41t4Q2Tl8pd5RlkFhekEZstS+0Wf4L9AmI5AXAn3Ns6nTx1siaSiTkg2iAcIJMc8TYUVt
 r3mKLPwj
 tdXOzFInhe+xgpxMo7EZbYUjuM70lWdMocXNBHm5XWFebJEzu3LrsPDsom8WgKMixjW+0BRra56ivoy0yEjBNCxxUSgntvQVTyn3WgLdfXKcK/xv44uangBtVADfg2jbLALZzY7DyjuKKIAof6ahcTxcWviwtjfopnsNkiJVmcm+VASg3DgCdSye7v9c+aWEgST9sitaZYZISqw0ItG+qKHZATTVFgn43caFseX7/RbpRxOX44Xq9870iY5RtOOp8eYYcX68AwvbwXsaOhSZC8Oc0QtKy846WxHlplQycrR1k5R79rgkx2qpqxZDzTcjJM90CjSB24kDms4J/q74aAyXEdcJUttmBoaI3LBnqBH8SpJI0mbdZbx94qhh1hFrILRdYAqxsZH/u2ELOSgYSfix2cJT7MTeV6NOX
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


