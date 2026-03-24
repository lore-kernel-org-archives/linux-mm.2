Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E832DF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B9D6B0005; Mon, 23 Mar 2026 21:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CDC6B0089; Mon, 23 Mar 2026 21:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C006B008A; Mon, 23 Mar 2026 21:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E21306B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:54:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 625011E81F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:54:34 +0000 (UTC)
X-FDA: 84579287268.04.19A2E7B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf06.hostedemail.com (Postfix) with ESMTP id 537DD180009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:54:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774317272; a=rsa-sha256;
	cv=none;
	b=dABiP1DAucTgS999fzQ25eVGpVgOGIFuRX5CYHcczGNeLGWY+O/nIJ3YBS89Cu1ObLb7AD
	30O8s+6GjEtv4eV05ejLLYW7VchAqDm6X09wNHlSpGI2b9KuCYoNbqKzz0iuj3j6exYxLK
	+U7t/mgMFN2Sfx4Lx2r7yxGkJOZczpA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774317272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tNu6K8aHBwF+C7TpSdR7Ea/0u2GRIvAEuWs7k2LTsAQ=;
	b=vEJQV4h85YXLNZ744f79C2++z2W8seW1sYVh2MaqcAOHAfdw9Eqml0WcSWIvHTOUgxgmeB
	tddvA5Rwim2ZaW3hIWfO9yHf3IFWeG9Onqb9Oo4laFi7O4c+5EBMKFNjH6D3DAl0AQFZ59
	yN+l3c5dOCtWnnGbpu3Ui62B5badLFs=
X-UUID: 620aede4272411f1a21c59e7364eecb8-20260324
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_BLACK, ABX_EXPLOIT, ABX_HEURISTIC
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:07daa168-16f7-4664-bfd8-53b877147872,IP:10,
	URL:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.11,REQID:07daa168-16f7-4664-bfd8-53b877147872,IP:10,UR
	L:25,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:89c9d04,CLOUDID:db17d0b01737c71faf8dcb379c95e13c,BulkI
	D:2603240509477XD5REKM,BulkQuantity:2,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|1
	,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 620aede4272411f1a21c59e7364eecb8-20260324
X-User: duanchenghao@kylinos.cn
Received: from localhost [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 37089547; Tue, 24 Mar 2026 09:54:24 +0800
Date: Tue, 24 Mar 2026 09:54:20 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	jianghaoran@kylinos.cn
Subject: Re: [PATCH v2 0/4] Modify memfd_luo code
Message-ID: <20260324015420.GA33036@chenghao-pc>
References: <20260323110747.193569-1-duanchenghao@kylinos.cn>
 <20260323140938.ba8943a5247c14b17bc70142@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260323140938.ba8943a5247c14b17bc70142@linux-foundation.org>
X-Stat-Signature: 9yci1ohh3heqa41snnk49zz9yhohybxx
X-Rspamd-Queue-Id: 537DD180009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774317270-443065
X-HE-Meta: U2FsdGVkX1/Lp2T0IjQSXksLir2iiRJ2bpP3hQvaQxIS4bVA/LBVDcoiXxy0V+msvJogbInrv9zY0JOttZsi7VaLUWUM46IwtNKmFGUybyL6j9P+poytKkWJMIBKMP63epZiRCj0PPppCBQV8Hv12pBELlevD4YSClwdHtLyeCY66SOVcOBL7x9FmvRD9Mq63rllvb8GitqgaCz86M10QIY8JxEQTqFDtQeVhNHqxXRvFFWvyKfNI3e1x/Xx9o1qOzzpB89l19VxxVAWHswoB5gbtHHN9IXCQA0bmQXkWhj+ZG5hHKYdwcaor/4zveF+wcMQTIkz3EnbPrs9i5314IyEi/JOIsNqjWL1+eGjhm4Qm2DkKSFFq1st72RdcoleEmmX4LK3Y3jnqjACSX2Z+zZHng02GJv45od9f7HeQMyPtu4xPNb15uGGDgANDu3SMor4UH6f4OB5HUuJ2W+vi7J53quZHDcfcmej3R9aUDBoihPkOBl5003Dee5W1P+Kdln7ZdaTS0TnwVGStbtWTLxo0hnnJsBZ8lxo+cC4nWoZIaOjLECyhxXCgicGR4bdzc+azJtAO0LpdI0Mq3nnxwyq02SB6nxWjM/RftDQeNrXjvbtGEGkegU0j3URogsDlxEd9rANy5kh4wa1kY+sVUnz7lWsbewHbwavv78KQwc818WvIoaruouWuyfxiy64Hm9jMIIJgt1JfbgVdHGQpfL7u+1MPVzQOnPjp2YRcYCjQ2tQbx/RaFFcDhkwQleMU2/jV/Cwvl8bhhoWAeZE1+fkyHKHvkbfHg2UQC3QpPUrB5T3PAyDZhAsTRnFeL6XRnKojPMtYMo5yNh4vN7fiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:09:38PM -0700, Andrew Morton wrote:
> On Mon, 23 Mar 2026 19:07:43 +0800 Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> 
> > I found several modifiable points while reading the code. Please review.
> 
> Thanks, I've updated mm.git to this version,
> 
> AI review has raised a few potential issues.  Perhaps they were present
> in its review of the v1 patchset.
> 
> 	https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

Sure. My apologies for only addressing Pratyush Yadav's comments in my
reply to the v1 patchset, while overlooking the AI review link mentioned
in the email.

I have realized that the AI raised structural potential issues in the
overall code, not problems specific to the patch itself. I will analyze
the findings from the AI review and attempt to resolve these potential
issues.

If anyone has better solutions or code for the potential issues raised
in the AI review, please feel free to contribute.

BRs
Chenghao

