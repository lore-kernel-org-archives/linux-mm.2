Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853FBC5CFEB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 08:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5596B00A1; Wed, 12 Aug 2026 04:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420E66B00A7; Wed, 12 Aug 2026 04:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9B86B00AA; Wed, 12 Aug 2026 04:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10DE26B00A1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:04:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 86CDB1C0F71
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:39 +0000 (UTC)
X-FDA: 85091880678.06.FD7FB99
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D9BB1C0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:04:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786521877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yAfXlDqwrV66jV+U51l1PjPH2xY6W4uIUHrBgRiG3go=;
	b=e0dYFFEoga8st1xyEn89PEZ2Zxg/JkhO2iHBQNkCUNUmFn6OEYwvhdBMP5/yWSxbG4Hu03
	0kFVAN3LUwZj/2bwPRjKzdn9QM76G8IabN7QzQEah+0xnxIg1uuICsbwHY8Mm0YU+KXKgT
	B1AKZLJDBdhBXFNNltbChrdMo5TvOZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786521877;
	b=SZkZIlVl4TCsGAX+zDy/Tt4cXYqj41PgXLF7TDg2KiGi7lhcZf0xccoaMqike967G2rfy8
	LYXhbr/mptxOHaw+KpOXomv8UuDi/5YytPjinxSV202WdBxfli5RnsAx6BVH096Wp7xXC9
	1Pb0OBDDtgwNVElGIrMT1TviwxxovKY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
X-UUID: 6f30d654962411f1aa26b74ffac11d73-20260812
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:805cb2e1-2a05-4900-82e9-39d0179a355c,IP:10,
	URL:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-10
X-CID-INFO: VERSION:1.3.12,REQID:805cb2e1-2a05-4900-82e9-39d0179a355c,IP:10,UR
	L:0,TC:0,Content:0,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:e7bac3a,CLOUDID:8a5fe3aa4b666b997e91bda91c6aa5d7,BulkI
	D:260812160428G7BWOWO4,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|865|898,TC:nil,Content:0|15|50,EDM:1|-100,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_AEC,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6f30d654962411f1aa26b74ffac11d73-20260812
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1613457883; Wed, 12 Aug 2026 16:04:25 +0800
From: Song Hu <husong@kylinos.cn>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
Date: Wed, 12 Aug 2026 16:03:13 +0800
Message-ID: <20260812080313.330413-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812080313.330413-1-husong@kylinos.cn>
References: <20260812080313.330413-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n8uc4ik3rcyttqbz5ccbe3dwxxzkdci6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D9BB1C0002
X-HE-Tag: 1786521875-158742
X-HE-Meta: U2FsdGVkX19eH/ZXN9IhPKUPqdvtAv9PZ5qmV4FlVPgEE3EIITUthZgKkzOTxlcKezqJfuuXp1P18gwsVGlLPHAFriAbMB0Rw+4j8TZAEWuyKjEpBt1QhWLQNt4NtGlelgMbcXiO/AVLY825MY77+ggFsBzmmx/Vrc8pyLqiyAKZNCZfk+s8w3BsMckhB+T+TkQcB0FeVX4ChMiQ0BHrt7i32EEda4lTNYiKWjMs2zg8XK5Fa5zcuIZAp2epJB7SXP6R4h+eBLON88RCN6XTAmW144x9kosS1UKIXp0hGExXla5tgtjOWpgRtcPLxXDRW+UhEcT+FVu056KYHNH40JVG+Ijq7EKe3IoXCPizJH834Dsp0ofS0/h0s+Du1L48GYZDn52hbOPHG9wWUaoM0FVFvb5LCDyCqafajvXNL4tMwoPB/OcXr3YIFOhpsWcxiMSzKW9F1X99JVD3pH81RwQ6DnyMXFXIMso9477RYBYLXUWEhmsZu/MNzjFQh5BFfVnICZQNOk4qMDW7UmEUB9rYr69hKjvq/zoR5YC9yjx0s1HQBg5oZ/wwGa1U+yBje4EcZiSMeZmYr5oV5DX9668mTE4i2vCbgR6nZJTLnyAZ/axgHlTytL7mFuPhPg2pT9I0yhZy3WcWXCGZBzEPoidTEzlkEEtgJsBahYLu46qJi1SINnal5EnKYLfX68vb+Vx283cGw2CUAV6toe/3UoZZZtoMd2IaPYP3EoXcW5jDTfxkA3VXfVxnKbsiIbcTvalwJjKh+nNM+P/ZzYTEakker1TZkNYx2ZE6EG3pQmGeopJue7BK3iO6IvFU+sqbI9eLDNAVl2jSGZyCMYtpCMPOHtq5deebh/eTQgEEX7dkNCElHusU7qYbsAg/PdOiEq/xheFE8/favN4xoGvdC/dq740ZxRb8uVYp13TtSiqJ43G4Tq1MWYrQH4fvItDXrmRvqVaBo469rhEDIT1
 QbsO+GbL
 R5pvx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

transhuge.rst claims seven policies for transparent_hugepage_shmem= and
four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
shmem_parse_huge(), which accepts six: always, within_size, advise, never,
deny and force.  The "four" applies only to the per-mount huge= option
(shmem_param_enums_huge).  Fix both counts to six.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 Documentation/admin-guide/mm/transhuge.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b187d618452f..72e944f49da5 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
 Similarly to ``transparent_hugepage``, you can control the hugepage
 allocation policy for the internal shmem mount by using the kernel parameter
 ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
-seven valid policies for shmem (``always``, ``within_size``, ``advise``,
+six valid policies for shmem (``always``, ``within_size``, ``advise``,
 ``never``, ``deny``, and ``force``).
 
 Similarly to ``transparent_hugepage_shmem``, you can control the default
 hugepage allocation policy for the tmpfs mount by using the kernel parameter
 ``transparent_hugepage_tmpfs=<policy>``, where ``<policy>`` is one of the
-four valid policies for tmpfs (``always``, ``within_size``, ``advise``,
-``never``). The tmpfs mount default policy is ``never``.
+six valid policies for tmpfs (``always``, ``within_size``, ``advise``,
+``never``, ``deny``, and ``force``). The tmpfs mount default policy is ``never``.
 
 Additionally, Kconfig options are available to set the default hugepage
 policies for shmem (``CONFIG_TRANSPARENT_HUGEPAGE_SHMEM_HUGE_*``) and tmpfs
-- 
2.43.0


