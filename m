Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB87E94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B3C6B008C; Mon,  9 Feb 2026 17:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F886B0092; Mon,  9 Feb 2026 17:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548926B0099; Mon,  9 Feb 2026 17:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F18E6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 072091C00D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:55 +0000 (UTC)
X-FDA: 84426324150.12.BBD18CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 26E57100003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWLMW88K;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgcYXNV9AndVyM0eXgkCwf75FkwR80fy6ED6RTnrjIA=;
	b=llHA591VBtzifEp0vDV83Lp/NjDU9JBlQYJhGP3PC+BJflRIwXFAmoI7GaXoIV+G1CeEIr
	ip2TNH+jSHwK6hE0YNMWwimwdtqfnDdoBtGvCCiANs/C3j8tV2B2J53JPTyllziPYPPE6S
	Kroi713u4W+1pepLvahNHOJrS0dl3Ps=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWLMW88K;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675293; a=rsa-sha256;
	cv=none;
	b=YTt/AyCIQsRaCTRum8AqHWgk7EFgbEix/Le8vvommcItX1Unh+ICcZVicsoI0WJbQPgjN8
	R54Z9cb7mkG+R4pjcANMFlRSkGpaHfCpozROKvF5czSbeU83cxNqmUH3+sH/yxEVBlKJ/G
	cWU8sSeAOQYJfxqdA0X2XftHmpr5gko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jgcYXNV9AndVyM0eXgkCwf75FkwR80fy6ED6RTnrjIA=;
	b=BWLMW88KKS0DSI60txIf9cA7elqwqqfbWnFW6I38TH3h+uLIqnMbyTGefexpYFfLPqGzWn
	8VbxaD0ROp+XelHpXTXbtTvCw33zE7g0W+ES5Lws35NTQ45t32CZnWDujwYLNudbpDGDq3
	HGlJo+QScszyMtE5RhITDUHeP3wKS2A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-BcyOFAXXPr-Qtb6-F_-Nvg-1; Mon,
 09 Feb 2026 17:14:51 -0500
X-MC-Unique: BcyOFAXXPr-Qtb6-F_-Nvg-1
X-Mimecast-MFC-AGG-ID: BcyOFAXXPr-Qtb6-F_-Nvg_1770675289
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D03831956088;
	Mon,  9 Feb 2026 22:14:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8E52018004BB;
	Mon,  9 Feb 2026 22:14:48 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 03/11] drivers: dax: use pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:25 -0500
Message-ID: <cc34e4ceec2496ee192ca8e4803373255b0de137.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: vQmiTDKASUyxJ0D7wmCiSWPLqu_Eo0s_51cBOrYoiXI_1770675289
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 26E57100003
X-Stat-Signature: r7cubjq65xiqoeftj46j8fj3r4qrgatu
X-Rspam-User: 
X-HE-Tag: 1770675292-196801
X-HE-Meta: U2FsdGVkX1//s4H+SWmMr6WGpSWEwkhVAFXzoZUnaEUxhsKUcYnw9zxiNcE7ehwMRJv0yMAB7FSStF/smcBAHiCBpVsN0pa++IqbuTfrlvjPNlHJ3rIG8iixdz3rZ5DALVmWI8WSSHAsoVi3ps7kPcqVfrNIRa9Psu/e5XV9ql39hksTA10qtrDIV8KHSGV7/++Jw4MyXPJ2qOe8eYe6Pkx34Lt5bJLDKBYFOwtTXpbJCqxTV4i5WsieZxR0FPAScmEplhTyJwaNUHVRiHziTzbLafn7z7ktrf+gdSLNQJTt6jWeaKUbHmd4jC8FweicfP5gRT/GK7KcPFOlvx66Pq3VRrK3cpJN09Y93qAIQhrUpzgLWTaWA0eZVsPLYvQW34eP52tj/a47MuDARGypLiFYL2QSy3VQ8Vt59FCVKY/6N7wE8wK+mNP3imvWBITbnG+9cm8OZiCs9iKWXzfQfhEa0KRHBtcknBNKdipZjuHtqi5gl66Kbjx9W+m9n+6yEXNojWhC73VF8Pt3h8S4jaoQn05uTLWLgblofbD5eH5IxRjRGugANPkNuelHuq9T3pYBnShjW4+RfPDiSAT2djgHRS4somn3Yn835etmWV8v/SLp9bSJfyAd3w6x56pV9xeG/EmFoiJ9feaRtde7WqlKRgQAPVfRPW9j69ghHsRIkpvBim8ib3GEcP5wsRtUXiu80wLPrTsfzU2WoI4WrG5fVaV5SGAU73eXmzqVKX2g2De7tx79Vf3IO385AH8PPSUMIHmPvzgJut2BJ4B1plzcsj6AjkCoyWyartqsJ+88CAPwLCvinPR9CiDbWBUcSkXeRI9HJifYQN/vaexTIdRTt7MvdGW7nirUJL1ZjxxIfnf3H/ud/ZpYrTAc2vIMYoGpDtWwNfXwLNsrl5MYWj2FJ4ARJgRuE0JnyyeSupqewj9o6RxTkZqVmMiTMFgjC7s0datWEaIZ9QPfe4G
 u7VfhZP3
 fO4P+W23FIRUdCI2t2emurD6xj6QVpnBw7UA7jdfl6GK7dnrhYsUuEgWh6uSwJUV8CYz4E3zwEoS9/hfPtSvwDzYhklRbfL3jsM3TmJgxdTPWr6CaDhw6ZNaVjDwGsxQZyTKbFDLJXv/t8skzgl5t8c9za2k+6EsNSSKK9BpqcpWqk9UzaxnWqinJU4cj9ft9DBuMKzDuXfOGi4O6VJ/PHAaI3rSLH5Jy4U7DSapYgwzNNQZRmq42Od2MxZM73/wutsNv4hnG96+swaH8zyFJOLTvbEThDzGc3YWIyuefxxLPTNLz258nTNDoP1QKAW+H1gp9icWJV8uRtileAB3pdtIxMBF+Z3a4S/vH8Pr2ZrciakppnJsoeQYwIbQ/0RsQNpDAlYkBn80EHeA0/vqRkzAUgDbATY0lnO9Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index c6ae27c982f4..97b577f4107b 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -119,7 +119,7 @@ static inline bool dax_align_valid(unsigned long align)
 {
 	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
 		return true;
-	if (align == PMD_SIZE && has_transparent_hugepage())
+	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
 		return true;
 	if (align == PAGE_SIZE)
 		return true;
-- 
2.53.0


