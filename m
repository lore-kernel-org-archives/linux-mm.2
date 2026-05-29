Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA098CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2740C6B00A0; Fri, 29 May 2026 10:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224316B00A1; Fri, 29 May 2026 10:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162236B00A2; Fri, 29 May 2026 10:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05FF56B00A0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:56:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4B9AA01BB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:31 +0000 (UTC)
X-FDA: 84820758582.28.F24344B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB59414000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:56:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSe5S316;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47oTURSZU7T5BO6BvCy7kSy02vxjhudIc61iax61bYM=;
	b=LtZbfdJbOWnd+RpA06zBWLx4jVEaPCdNNN6n7QfYXvKuItXsCFmn8laNOxAh8zmbCA2+QG
	TGZTOS1xN2+FkSNICSGlfmBbgPzg02ZeXX1lVtpZ0FaAccT4t4jb8GMKApvF8zSWUXAMmX
	As219YN3uwDv/gXBYuhjgqfAoA9gifc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CSe5S316;
	spf=pass (imf26.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066589; a=rsa-sha256;
	cv=none;
	b=iC5xQNw6Qj3XzqxJMWPRo8jsJ4MC6N5i6RDfI8D1ID46iFVbEDSRJchLcb9w8y/qifyVwr
	oMs9gXXbo8nuVf25Xy5FAeGvOYfTUwIGZ71/M4fM/eDUvM+WxmHSyM+1Trrq9Vfjmu1xL0
	xB3R00zjiqbOJHSGWonSf9FFkDmR1YU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780066589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47oTURSZU7T5BO6BvCy7kSy02vxjhudIc61iax61bYM=;
	b=CSe5S316hDoKHzzZcTId0hKXymqvD4OQoIIeiSwA7n/i/DBHCB22T7z5WIfe3TBYr8cYTa
	zp9E+da/i1mNDTL12eKV8v4TrrJ595WA8YAwVKNNNUWbIHX8/2sza4M6UA+XEkBX6oDM1o
	eqhleckKJZzxSLtcWtfM8TF5fO50HjE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-304-dV2tNgWuOfiFikDw1_JmsQ-1; Fri,
 29 May 2026 10:56:24 -0400
X-MC-Unique: dV2tNgWuOfiFikDw1_JmsQ-1
X-Mimecast-MFC-AGG-ID: dV2tNgWuOfiFikDw1_JmsQ_1780066581
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E1A319560AF;
	Fri, 29 May 2026 14:56:20 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.64.88])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3EBB30001BB;
	Fri, 29 May 2026 14:56:16 +0000 (UTC)
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
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: [PATCH v5 04/14] drivers: dax: use pgtable_has_pmd_leaves()
Date: Fri, 29 May 2026 10:55:22 -0400
Message-ID: <21a206695b42c4ab13707ee1abbf501dccec9ea1.1780066530.git.luizcap@redhat.com>
In-Reply-To: <cover.1780066530.git.luizcap@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Grr5HnplDBD1DHunvFtfNhf0edg_eZK7ivuHn8pl3Bk_1780066581
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 3jmt91uyrwyaai6uhp4s39ejn1cg1bad
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB59414000A
X-HE-Tag: 1780066589-364430
X-HE-Meta: U2FsdGVkX18QQbgjwqk0INWWghtDl3iL0fgQZPbzx8sFaZPE3QXUS0URIJYSHEnFwQSiZNhBb4mNi6QtY+MN5dizp1QQWmB3gI5z1R0vQWdXA9NtuK7KYdLS6oYmsz/A3sXLD69e64yt9ewA48aeJY8bIEtEzasfvdOP32BLQJLtHGJA07s1G2axJOK53kXbYC6gMd6XZaAohqzIIl87vY2qUvnjT+ErSG33plaRdQNExYz1qGTdbyPdfjepIen5ro/8hvsXyAUiw1FldbCHN8ezzgt1cuDJjSp0V8I92EubvKbt3jtuE/mcJOzDnKbTYi0zE7tsiBoDlW0INGQsU0ih2SRwoKek/zTQ3EGzlnHq1GEGpikUwmXes1BimDw4wmFnjv1H8AEUaScCEV2jzvp6TEpHEwx/TAcBp3/gdADrQ+C9JIUgsrFX92XAtXHYbTOu6A/JGcquPGai5GZ4VyWFQ76rwrwP86k/6Is8yfGoSSP8bNyUEw/Kp5R3IeyLE3iXbNx/E2oyS4B4jyO8yCZFMwtACKJvW9ReDxvkXAuwD5M3POr2yj3X8ZJzIiHYo1OK/ZD9T2DIGIVL3ueQGJaPFTUb9scl5j0XVm3YZUfCvomZBUHawAb1Q3N9vDELPuPTv/fTPy7NhGqnpcLDx0LwuFWhOXEqpu/zhBVEpqjU2+cvCOK23aaW3c9Ia+cQqm7Zg2zobNjs545vqSRbW48+42D4wYhhBiyI2qJ2WAyMQgk1xqohftj8RXWgiGfUJcdBNrEh+3dkdFmSagsE+4ysp1mFMnaj9jJRu12JzEiEEcGwwpn+sLl07dT9qyOLIGbE43iomcRO5MOCLHWMsUJOyKs4U02e49y8hm1mTseIRUVmGhFwz4Pv7vIlwRWmR8j1PlFc0U3E/eUZ3Qip2+cAmcky1cyMs2dAKkDwK3OrKVZZv0+rN2LlOaVQjRUWNYKdqhP5qa23E41hqCm
 QqMsjpDy
 jfhI9mJk+412aNEvlkYNeYrpeEVZ36yEyLvUdypt59PjYNWWFl3IbZAn1JY4CD42rwcGZs7krkirBNjbSo3oPco2qqnG3sBTdO4+F1m5u+sth/FSfiicFxFTALJmmAL+lJQ2j2NrqOoHmgaO46LYWDE1hAWyv61LnxuGPE1GQAawaEfGy54o55mVIb7L4tjzf2TYups31npqnTqNdJLTAnb8kph8/rYMCE9QC4aQb1RgpQnTzkVkNJheD67N8G1ICNrqk4BvxMbTpv4XhJVXeTTpHErNq4XeGUjtjI0G1QboWkmr3bRMSAGyo0+llhBvnUsiybn9pje71O7/jw1KgfEHh8yjar8YL4/RKdBVBpQN9+EwIwKks6iCMQXhLVVhznRzM6hZ+ij5iJ06AR8C7A9KmfMvV3Xd5YyFW
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
index 81e4af49e39c..35744ff6592a 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -123,7 +123,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.54.0


