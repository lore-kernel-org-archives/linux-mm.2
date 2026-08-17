Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF798C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E401D6B00CC; Mon, 17 Aug 2026 09:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0466B00D0; Mon, 17 Aug 2026 09:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE796B00D1; Mon, 17 Aug 2026 09:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B44316B00CC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:13:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4215814078C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:13:08 +0000 (UTC)
X-FDA: 85110802056.15.45EC46B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5633618000A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:13:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786972386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DLGH8nrt+wyvlXE20YBZAmpRnLNCwAuZcV6OpqIalug=;
	b=zPXxK2nm1HF6v7gVS5Jb+u3jQ4VLcGmMit2CEcD75XpljiXf9uAo2o5Kthe8W9mpG77qxH
	OfnpGbXxTSKIIQl8jbkGkmPqSvvoWRJdl2K8UlcGad61GaRkcA2uEnu8HZmTjQHJVqAVuf
	EQ7CZo2/NcTRxLPc57civ69Wz/qnBHc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786972386;
	b=M6nBZvu45T3R3n3AeDIS18zFXxSRDGYsRFJIUUUC0M5PiQnnSjgW+XfzrmYG1Yzg31/pQb
	dgRFcOFVrRbUcZylbMleQBCPKJWXaJ2wl331TwWzMatfwlURz3kxtyqltkIuxY/EEAtGcR
	z3KpIcr11ajOmggR48Q5HdZ+seb7tZg=
X-UUID: 5a3936f29a3d11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2059e333-ecd3-415f-8235-31db290688d2,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:21,RULE:Release_Ham,ACTI
	ON:release,TS:56
X-CID-INFO: VERSION:1.3.19,REQID:2059e333-ecd3-415f-8235-31db290688d2,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:21,RULE:Release_Ham,ACTION
	:release,TS:56
X-CID-META: VersionHash:7db8b62,CLOUDID:d0f739e605b8aecbb2a0add61b02c04b,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:8,SF:17|19|66|78|81|82|83|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40|20,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a3936f29a3d11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1245843252; Mon, 17 Aug 2026 21:12:52 +0800
From: Song Hu <husong@kylinos.cn>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	audra@redhat.com,
	bingfangguo@tencent.com,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	zhuhui@kylinos.cn,
	Song Hu <husong@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Mon, 17 Aug 2026 21:12:21 +0800
Message-ID: <20260817131221.44761-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aoLGzZHS8kj53-ey@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5633618000A
X-Stat-Signature: bcdyysbfsac9s5rcqukdk5h4gp4ngi4d
X-Rspam-User: 
X-HE-Tag: 1786972384-589311
X-HE-Meta: U2FsdGVkX19dPRzz0Qeyzaayegf33P86ggmMEHKBJVluCMrDh3WWDjIuEaNBlHCWLQiXuRtQ1Z8Rb69a9ma1mHqLu1R2Hh+z6Ol/gLXDIpPzCKa+sQhyn+X69zicb6hU+UdbcQct0UcqqJ+sPdLvaE+13wjVLP6L92nQpj/JWucSsq/iwABoDg62f1x9prRg30QSFkDqojMv9gJYnee67xs5Strxbycpxmnr6CpWBaxm1SiCpXQK4ysYQ1rva9cQov5PpbkfGfPoAMSOjJp0Xn52Kdvp4R8V1C3takgeA7SJeSEH4FjoigILtDu/4rofukBx3qOCPETPMPAd30GOxhaeVi+I4jm2dSI2W8lJYeFXJAKVcnFFaBz78xslMOMl7tChv8UJyi/koQ4e2YiJRzvy8Glq2D1oF+po/wkMo9C5VKNc/GtGJnNwt7JkOpnFErxOuaVTO2Cgm9UKs8b/QRfp+9yj928dQKHg8q9itOshagIi8Z+aLQjbTjD+C+veU+NJLUswmWbrcSoNbRzWvUunmpd3Dcu2/K4dFpqUoITdWt7qX1S9ANjYlGEGA7x3K0t/HTDsqfDiJCO2jY8sw9n59icMVTcn4MptbNrXN2EQEiF3wxntZ8HomYApWEpxw9h+kT0JoCHar6y/iYq+e1H9XPkXqoT1jpoXU40t8tFJSbPK5YuH966y2illmSNiL/LjRy/XZtSJQqZi5IWTyz7eZwL+JJ5jpkDPNPvtcnh284XZuFav9yBWmDnBsXOLNMqGCja7KlQZShNzy4cdhdNt0dKlW/aDFRtmngYmgEQCmsGqbRCrDR5VaTFpm7/CceYLzqqKlsmv2i6yq/DxBgNIAvEDRcs0DwNzzUz2mwCqikafME1XkNtyKfQEA//iIjbGt03IS+4ZzoCP5GDmU59noQog5TX0kWmjFySz7dAL2K8CxyizJSNnokbUmU4PD9eDXUd4//o8HI7LbeP
 3YGG1/X/
 qzek9r3H5JN6YXYNcBq88Z8D+mg7EXuo836czYz/KtZ1uo7CtYETrJXGHKLYSIpsLBPQBFQnAsbCgTirlYgpwYWQCJITGoKzVsZXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26, Michal Hocko wrote:
> Is there any specific reason why the memcg stays in the cache slot
> without any pages?

consume_stock() doesn't release the slot when nr_pages hits zero.  It
is kept for the next charge of the same task and only gets displaced
by a charge under a different memcg or by CPU hotplug.  The problem is
that the offlining drain skips empty slots, so the css reference they
hold is never dropped unless something unrelated displaces them.

