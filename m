Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAF1CCD183
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 11:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962F28E0003; Sun, 19 Oct 2025 07:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914558E0002; Sun, 19 Oct 2025 07:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802318E0003; Sun, 19 Oct 2025 07:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4D58E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:49:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 062C01605C8
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 11:49:36 +0000 (UTC)
X-FDA: 84014693952.09.65CF2F8
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id C596020008
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 11:49:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of hehuiwen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=hehuiwen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760874572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kqR+Ijifgnm6Y6XUjNSzQ3T72IVAhN5V+YJaO9iVFvU=;
	b=D3O6TasIhZ0Almn4eIvB6fPx6n+DXmsmILvMixwhXOfk5tTEu/8j0bS/C7BseqlXuUin/W
	4jw/N0BCROwIbBOQb4wtR/B6T5uTCMq+r/VMgYzBCpZwsFv161G7HDWkJ0me5J0AzsiAWK
	wxbHmAgd8fgG9JcN8rDdL5DOLPEA+Do=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hehuiwen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=hehuiwen@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760874572; a=rsa-sha256;
	cv=none;
	b=bEFb58mDTMns2tBKlWEP7a6Ep3RRoeJcxW4zxAr6kS/VwlhU3Scf5bDCKiAM+zkuQCwzds
	0HG9h37NYWf5mW1VvsOP4ZUEH+nkVUN0tSLaj9CmYgr0V+X0JnXwdwfSAOh916Qw0HEZ87
	VuXSo/ul5AJAYOY0hMeQ53F8z4fq+xM=
X-UUID: a6110220ace111f0a38c85956e01ac42-20251019
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP, DN_TRUSTED
	SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:dc6f269d-d8e6-48e9-a2d4-9493ac5d2d19,IP:10,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:25
X-CID-INFO: VERSION:1.3.6,REQID:dc6f269d-d8e6-48e9-a2d4-9493ac5d2d19,IP:10,URL
	:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:d3632cf283a6e97c63ebf86d83d88eba,BulkI
	D:2510190038440NM0JYT2,BulkQuantity:3,Recheck:0,SF:17|19|25|43|66|74|78|81
	|82|83|102|841|850,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a6110220ace111f0a38c85956e01ac42-20251019
X-User: hehuiwen@kylinos.cn
Received: from localhost.localdomain [(220.202.195.150)] by mailgw.kylinos.cn
	(envelope-from <hehuiwen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1897312501; Sun, 19 Oct 2025 19:49:20 +0800
From: Huiwen He <hehuiwen@kylinos.cn>
To: markus.elfring@web.de
Cc: Liam.Howlett@oracle.com,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	hehuiwen@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Fix potential NULL pointer dereference if mas_pop_node() fails
Date: Sun, 19 Oct 2025 19:49:16 +0800
Message-ID: <20251019114916.1618642-1-hehuiwen@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
References: <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ohy4yjszysofz4wk3mqjcnsjfwkf16z6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C596020008
X-HE-Tag: 1760874570-31700
X-HE-Meta: U2FsdGVkX1/SgBUP6FWOI4fl8RHKKcc2tpq0VALJlG/BQbB3tJC5VMhRwPHd80/iwK1V/8jhhFHwpzK/qc8WOTPwtuUuRnshdyuGq8Hyindz9xRrilFv9z6hRzkMbjGWtBIRYvRCD4Nt2ZlZ8/GuRLRTtNePGAogxZRa02CPaZ1SjzhKRWCgKcaOJOHsC5b/gAqVO8BGIk4b5ROsZqngAatQ3peqjTq4alFmdI7BReewBSM/ktxO/fVURaO1kE/KfhE4cP0Pl4TaRygpi/GF7m3MP+IasEOSqOj5MW/DmihRvv/l+Ewk0ylbfubquLZGEYCq9+5B4/4b9gZDFIvtaJwupa0htPNjNKNZ7GYUpPY0H6cf2mVLafSrFcrwAS6MMOjoy8zQlpCWHVxozOWVhDSTH8lOmkzufdYNYJfOAbr5t0qhH2hDeD4ZgJ4PXQ8rJlJSl6JtoJhHx5b6t2YETOlIsHWxV4AmHt9X+AfsTzhZU1xs0HcCDxdAPpOokWYy7UDblcaxXfUDwM10zFtn2M0AjWOJ+WZJhn81O/7oHnPF8EkV+k+Ftl6AJw3YCjEc8ofjDUNfSQv6e/SOWf3O6kWnmvLsQ9obAyrGO+A7QUCnc/5odt7VERU68BJLquM32StCH2ZkI3Vn2pGXQ7TGPvilAC2n16FWsjvz/WGjPEEh4r3pin7MuP3Mof/Tcwyr2MQ9ibykzsBx6nst7Am+I9+wJAT4OI91XwNacFzW7UWZk+Sea6K4weDPRZuv5zwfAA/362is4GXPCNBheY1chGAgtbk3nyEE32MK16GHAB3k1WDX47VPZWsKaTO7voLVMi5HId0ebdhgrJdLljKJc5qyShIPSukaNlMTodHw22Ecf33ZnGTtbigLaCyPdxjtqiuooIoiTDzMwYYt02LG5RGObifijDoRPYC+IpwFyNoWAlPCnoYubKSLrErT+WoTa3fcW0DdnloZ9sFMSJD
 m1sU5/4u
 /2Av/Thq8jlWwckRiIsQofyImo0Rp3W8vyeYXskuSM1DBQf8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Markus,

Thanks for your suggestion.
The commit description could be improved to better follow the imperative style.
I'll update it in the later version (maybe v2). 

Best regards,
Huiwen He

