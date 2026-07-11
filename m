Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5EDC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 05:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879316B0005; Sat, 11 Jul 2026 01:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A8A6B0088; Sat, 11 Jul 2026 01:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718D56B008A; Sat, 11 Jul 2026 01:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 492486B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:04:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C26F6A041F
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:04:33 +0000 (UTC)
X-FDA: 84975305226.15.C994EE1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4BD3F1A0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:04:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783746271;
	b=t8VCavNFTsFwJXmhbMEWCtRg+C3NA4aIT3mO6doGDln2gFd2MeA3LOYI5yd//MX1EVtbbM
	zqOy+on7FV26Yrau6HeLzmAYh3Y9CrS6+D+22f8GwVjICu41GfruJX1dgQh2M5CFzkPJMY
	FpKyRN9+zEaBx1eHUgOP01AgG9wSUTE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783746271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+NoeYCbVI4uJdknr2B+CNTPsSQqgMmP/ZHNQGvmfjNc=;
	b=49g4JMkZORN8qLiJu9KCgg4j/FecUTKJbQhTfhM0OacPQsqUTBCfX27Ik7v4puOdnDXlYX
	IIhCw0xG0Or69wEP8BPJejR6RnEpILFn0d6Fo/pCpwzh7prj8mEqkvnusm1P/WibYZ/nKW
	gMBazBk3LtZqYeT1QI3opw50OOifVfI=
X-UUID: f88789647ce511f1aa26b74ffac11d73-20260711
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_QP, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_MAILER_MTBG
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR
	SRC_UNFAMILIAR, DN_TRUSTED, SRC_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1281cd33-2b67-4854-bbd9-17ee00ce8ccf,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:1281cd33-2b67-4854-bbd9-17ee00ce8ccf,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:2c71dac5849ae06242c1f1c11ef34077,BulkI
	D:260710221752NO56G64A,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|865|898,TC:nil,Content:0|15|52,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f88789647ce511f1aa26b74ffac11d73-20260711
X-User: husong@kylinos.cn
Received: from ehlo.thunderbird.net [(223.160.130.75)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1252713203; Sat, 11 Jul 2026 13:04:18 +0800
Date: Sat, 11 Jul 2026 13:04:12 +0800
From: Song Hu <husong@kylinos.cn>
To: SJ Park <sj@kernel.org>
CC: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] Docs/ABI/damon: fix typo in intervals_goal sysfs path
User-Agent: Thunderbird for Android
In-Reply-To: <20260711002127.32005-1-sj@kernel.org>
References:  <20260711002127.32005-1-sj@kernel.org>
Message-ID: <C8C472D0-9818-4569-87EC-1B95BE9667F2@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4BD3F1A0003
X-Rspam-User: 
X-Stat-Signature: bgnnebct69nrje347yxsn9pfmzp7ff8k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783746269-228955
X-HE-Meta: U2FsdGVkX1/A6bFtcen5NGMj8NZ7cLV5HsDgGLw75yfpjgzJxmFuFIJjnmgEHUBrXAsCNjbMYOPG+skrPV64nN1V04ygEQxU/nlWxmiPeItkGTuPzzovJaHgVaaOtGv9YgX3k8jaGbKrXjZofY584Xoy7NLDfZbFJxbEF+P5SebSpNPuvWiRclwEBRE2YleDR2ZUrB0YAuua1r5aphAqP95qmrhxFydwSARjO8/g7SYOAjMc/P8BF2fKOVOxaMChx9mfavhJLqZ5U8W0f40zQ6UiMZE3lxsu490ase28nEWeGykrI7LvCaFT4QmLRToLmJ8kjFTwKzoGycAvUlg4aecyA7F27IZG5hf3HPaW2FpWwnO3UuRObNRu7RQe599AEovlSi5WySBsq8KL9JCdG6sYA838jxshW+RkbJtWNYClD/GPzeG9gSqSwTO8thL4TOrCkX1iEyBYkdP6aYdSq2OYoSlAATdsxNMnCcWmz0KsEhzupwBD+qx1qqgmQeX5NGUdxPwHvXBtiaD4w22ckoZm239M3CYwfcshTWn+kkiOdEjTMpo501qA4Vaos63GDw3jRm77eTNg4a5koI/2YbNmKPqyo854kgfDbuQ/WHaW8ZEHZsg6711buxL6kVfVmKnzjzeKS0WW/GRBFX0LoGyRUVLIAthzBbglTLvLNTNg7IbuJf0hi2FjKihCNcBhDAZzFaZbFSJutsnuT4YKjQqeisAZBv17tNlLpc1+kNkdE2h6WW4VeiBshHMymHw2qE9A7kr3JexXsv2tDsekadgub1YQNNmbspaSIgEuJJiJWai/oi1fjIqJh0txHkp5hsEBOUhklunq8B0F0m4G+RCtfGVnnqsjS92xYS+G0SA+Yi6rsTHoFE9RdrChV1mKGa6Cz1xH0nXn5o8N3Uvddj5TqP3oEeYWIBdIlEE+qgjt30Z+lMfksuYk0B0LT+AANp6Mi95Q57U+ryvL2ox
 cd40M2FM
 dAHPke/u2AuJHxmMulolRFnKy6Lxlwgwdtaqps/2pWX4ouKKMw5WN2jrEr2ICAA7p3k7swh63uuFGlxayiNqe/YteSI4f0MpPrg6POvTQ2VhdATF3a1Dr78JOsatXbx0lrMsx/cnvZAPfDOgkvccH4mG/vrtKPJj5RBPlwqhcCFzbb1Us0LgmGVt8aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



=E4=BA=8E 2026=E5=B9=B47=E6=9C=8811=E6=97=A5 GMT+08:00 08:21:25=EF=BC=8CSJ=
 Park <sj@kernel=2Eorg> =E5=86=99=E9=81=93=EF=BC=9A
>On Fri, 10 Jul 2026 07:17:37 -0700 SJ Park <sj@kernel=2Eorg> wrote:
>
>> On Fri, 10 Jul 2026 12:47:34 +0800 Song Hu <husong@kylinos=2Ecn> wrote:
>>=20
>> > The ABI document spells the DAMON sysfs directory as "intrvals_goal"
>> > (missing 'e') in four What: entries, but the kernel creates it as
>> > "intervals_goal" (mm/damon/sysfs=2Ec)=2E  Following the documented pa=
th
>> > therefore yields a non-existent directory=2E
>>=20
>> Nice catch!
>>=20
>> >=20
>> > Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning =
ABI")
>> > Cc: stable@vger=2Ekernel=2Eorg
>
Hi SJ,

Thanks a lot for your thorough reviews and ongoing support=2E

I will strictly check the complete recipient list generated by =C2=A0get_m=
aintainer=2Epl=C2=A0 for all future patch submissions=2E

>By the way, hotfixes and non-hotfixes usually take different trains to th=
e
>mainline=2E  Having those in single series therefore makes maintainer wor=
ks
>difficult=2E  I understand this is not a hotfix but just somewhat worthy =
to
>eventually be backported to stable kernels=2E  So no problem for this=2E
>
>But, from the next time, please clarify or use different series for Cc: s=
table@
>patches=2E
>
As I=E2=80=99m still figuring out the correct timing for =C2=A0Cc: stable@=
=C2=A0, I will consult with you prior to adding this tag next time and sepa=
rate stable-bound patches into an independent series=2E

Thanks,
Song
>
>Thanks,
>SJ
>
>[=2E=2E=2E]

