Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D48EC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905AA6B009B; Tue,  2 Jun 2026 00:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B68F6B009E; Tue,  2 Jun 2026 00:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5056B00A0; Tue,  2 Jun 2026 00:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65F356B009B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:58:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EEB0E16292B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:58:51 +0000 (UTC)
X-FDA: 84833767662.30.033A58A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id A348DC0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:58:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780376330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2Nlh4k0zv0/JD8JtLvOoaFoynesvsoq0ZCrM4p5cz5U=;
	b=3y/gJU6dDINv3W80AUM8YhLXCYkWtsCWy4A4Qhdz8ihrpgFbOlYNUsrV+pSZTe4xc3nmw1
	dxL+bx/Y6u8SP5hcAY6NO2nteYmnXxD2vD6E2qLa4WYNhICCCSsY2Yjz0aeOkDmzwnznxw
	XsXmA1pbq2zVxju36zakx+KaD5uIeyk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780376330;
	b=TxpnvwPJ5yQ7lsbMdWwh/tlUSGQ3T31uOgeHDoHC/p4uCAr70WHYEDTEyqO7d4IDQrEt1p
	h6RiiPXJ5StXEpSKoqLxZsLH6elWAALCHJxVFujsED3ey6pt2YtTaclvZyX0RO8g907rxW
	3Jvo52T2VUu9sJInHBV98LFODVww9fY=
X-UUID: b5d3bd5a5e3f11f1aa26b74ffac11d73-20260602
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, UD_TRUSTED, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5042bfde-d3af-422d-b906-80343846f216,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.12,REQID:5042bfde-d3af-422d-b906-80343846f216,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:468d7e58709b32c741750523244e7009,BulkI
	D:260602071707M3QLEKGM,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|136|817|841|850|865|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,
	IP:-2,URL:11|94|82|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b5d3bd5a5e3f11f1aa26b74ffac11d73-20260602
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 420245183; Tue, 02 Jun 2026 12:58:35 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v5 0/4] selftests/mm: refactor pkey helpers and fix mmap error handling
Date: Tue,  2 Jun 2026 12:58:31 +0800
Message-Id: <20260602045831.1385324-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260601161656.203154d9f53c2861f1bb2623@linux-foundation.org>
References: <20260601161656.203154d9f53c2861f1bb2623@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A348DC0003
X-Rspam-User: 
X-Stat-Signature: b4iwnd7bdfn75jtgqz1c6dhof4xf3p8a
X-Rspamd-Server: rspam09
X-HE-Tag: 1780376328-805205
X-HE-Meta: U2FsdGVkX18BWr6pfPd2edhZ6kvSKE0erKXhEhVknKx3FaHEA9ykDFM2qLCPZJK6hMbnCSpE/TASN1YzVDuLt8RQyNpHIhQux5hzDHV6xmAqrYP/qG04t1eWGThCC9zNp/XbrkDw8iCnKhjCiQDvd5N0rhTwsx0IImP4mKwLyX8WDcFrA9dar8ZXpRJIf1YGUOhW7sZVTSgMoK3KnfVddE0UOia7FgnwWSgTQif5bGVmpwX5TZMy0QM1gsCbfr8+FOTCkPelFsVV4G6CdmkW9Ew0dTAtGmCTHDyuVxoOHAaKTyMt7F1VB+p6Qfy0E3tYvVIXsccRZ+GzJ1qy9PTbyM8m4WLtQlVXlXGrwGpViyioTJLyqc7+xEML+ROFONQqoDTRKoIgiYCp7KQZLLB0VrkvyM3gDmT1cfOxsGYKJdhJdr93JiyItDy67Ph8NcLiXfa2tG1tSFPgnENw24r2fPLd7FHfP1ZEu42ou9sCEaxcFgapMijMLJP/Mss4zXMHnndasQlGZ3z1yR7jDm4vviLmSacmNLReOxaG2jcOzQqW+Qmgn+OBNQVGt/4IfabxjwrEcdiOKorsgeAFYS+PdKIRov2yG5IYivjgZ/sd6T8hQ2+5o83Vdx5EHPiE/DebMN0i0tYx00T4+Gq3Eu68Id9AHrhJO/3OtN7549jLR9Bl4QCo2J7BUlX/XdB6V08TzGEqFd7nc+IMYSh2t5eiRtXTGSHe78wjQMffRBsSDtv3yJqHzLAaVuCJucLXcaAzkU8ghy1gZ6vfx1NhTXoX3oeS/JY3IPoSrYRe9dIcI9VZtoe94uAv8hqWz+tQyR76Jke/GwfjOURj+UH305u2YlicXSKjADSL4hcmU31+tNj89titzTSPc9LC7i4QXOy17pOZFkJk5nGYhJQjaHzGH1DU+ouhe1mqHnduro1JAoL8nWHQc63F4lEET2GrkkXBtUuG2CFSJDwtwgNAd2Q
 S4WeHZ6k
 A1QZzw994+D5Gwa5oajPSIPKxgumOiS3LJVE26ZXgAAAOWH0/s1hbU4JStyEOsN1K2CWW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > The main changes in this series are to refactor shared tracing and assertion
> > helpers into a common file, unify both pkey selftests on pkey_assert() and 
> > per-test tracing for consistent diagnostics, and add missing mmap() return 
> > checks with MAP_FAILED used throughout for readability and consistency.
> 
> Thanks.  AI review found a couple of legitimate-looking issues.  At
> least one of these was also reported against the v2(?) series and you
> said you'd take a look.  Were these things false positives?
> 
> 	https://sashiko.dev/#/patchset/20260601061953.696844-1-lihongfu@kylinos.cn

Thanks for pointing these out.
I initially suspected this one was a false positive, but upon recheck, 
it also needs a fix. I will address both issues in the next revision.

Best regards,
Hongfu

