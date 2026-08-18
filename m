Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28EA2C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254D06B0886; Mon, 17 Aug 2026 21:05:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C2F6B088C; Mon, 17 Aug 2026 21:05:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BE86B0892; Mon, 17 Aug 2026 21:05:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF37B6B0886
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:05:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65CEAA362C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:05:29 +0000 (UTC)
X-FDA: 85112597178.08.26755BC
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2642D100007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:05:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787015127;
	b=S3zrRqdFyv7B+AvkeZ1grjgBI2Pd7dNFy8ucEV/FC0VpOi0fWKPdZBsieObkP0rDX5NlTi
	z/zyQky1G9jIj5rzQyEOspG+BEpKNC2ZMoUW3T81uRqfMh1ocdqbBrZaL4xfWYDer6xq70
	nebABHf8BAza/3IRQhud+cPojzQjdmY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787015127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ldI2PA8PHpJFTuUK5RjS+4cmA6h1TKoHDrn5lMVtpIY=;
	b=OEwgQkg0GHsCzqEYyeEeIo61KTKDH+Kp7/a9CGzwYdyP1B9jGUppNOUXT+gnQSCEp31CYB
	kCwJtQXY+8Bp1zs0ZlIGxjMrHzHmIDBtFvH4ztFkJRZyf7LyljE33JZn92J7XhgGVYmjkh
	OO13PVKMN30MdRPpnH4fBlaxAx/LxDQ=
X-UUID: de1bf62c9aa011f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:67336774-f8da-4d01-b25d-312dbc6da10a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:67336774-f8da-4d01-b25d-312dbc6da10a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:2426a112fd7eed1304d354514c774d3a,BulkI
	D:260811205833BZBX3QXG,BulkQuantity:1,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bu
	lk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: de1bf62c9aa011f19a56ed5b684f684d-20260818
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1340971763; Tue, 18 Aug 2026 09:05:13 +0800
From: Song Hu <husong@kylinos.cn>
To: ye.liu@linux.dev
Cc: akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuye@kylinos.cn,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	husong@kylinos.cn
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with OOM_SCORE_ADJ_MAX
Date: Tue, 18 Aug 2026 09:04:33 +0800
Message-ID: <20260818010433.65169-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811033609.3992348-1-ye.liu@linux.dev>
References: <20260811033609.3992348-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2642D100007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8ocoznjw1f1zojtzuxu93ktz4dp9priw
X-HE-Tag: 1787015125-823307
X-HE-Meta: U2FsdGVkX18LfT3wZGDOY4MNeIg3rnLP+aYn5Ml/6+5kBgnPKg0ipSYS7SaekX3xTj5zwRuvQW00/UoSaDENZfiGMRELwneoVx9YzTXqmZwR8lhO+hkA7MWI7gfRy4Nvi+/PofmjyArxtnVpswI5NmulY5UTw9AdXlIe+/9YBusTGzVasNgAC4zH5sd/X0KlIPExHSB4oW+rJRa2a/MWGNTNX9E7aiym81njyjFoZThKpGkF5pLFOx73yyw6ue7PC2DQP9szd0uOlyAn++D3/FMdSwPiPzp6ur9NPFr7K+ts564J+oCcE3nEucdtttPdZUVAcY5HlzivDPwFvJrXBFfYpxTUv6eHVtRlC2Em/Abadi5grj97sOYXFGmvZlV0Y+9qxJHai5luVk5fLlmJerJ+hiwxWZQdrajJEBVOvA6AS+8mTdVNOJ/QTPP6obLPBvHnk+hkvmWoKByays03rRqKXynWbr9172NpxpUgCUQzqIbjAubOdxRI7o10D1yiou+iWiXJMzSKzyM+76/CdhEeViNUeQyx/OYmamiaDMWpv9IJAkNVJwLK53mH/38K9QNMd+H3podZ/7cEKIuS3tZqlh2b0JxUNYlLvz4ANQomm4o+c8axu9NcurBFIg1grswBeGshBfPZgL/BfOOBfjKn6lJr1wOg+KSpXTi9G2NyzpeL59xwEYFcQhFtqugNgejiSUynvepJQ4PkUDfGg1Ijn+RH5qdaz8lDR0Nl2MhkLMJk6gGlCt5AfRjWFFM/MPY+pBf93TwVJ2kqihkBsXYY6mFnIHIy5GCm2MiPGoPqxaC4IXXiGuXKrrGqZrEwJ6GT3pcrmFp5Wy9SbG4uTAug2PMU2w+opXuvi2uOFwx0WGuZImcZUipROklCq7e52dFvKkwLicignhRdTeJSN5lJujRmN84fUVQRv/+506IGQEIDFMzQjaSdxQzmReQ+3N6f1OCEzaV8t4ONO4h
 QK8GC1JO
 TQkzdIYdvBcRMa1n67sCqZu9pdTOXiXJ/jvGVIvE+/vDX6S8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/11 11:36, Ye Liu wrote:
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
>  	task_unlock(p);
>
>  	/* Normalize to oom_score_adj units */
> -	adj *= totalpages / 1000;
> +	adj *= totalpages / OOM_SCORE_ADJ_MAX;

One thing this line hides: for a memcg OOM, totalpages is
mem_cgroup_get_max(), which can be below 1000 pages when the
container limit is under 4M.  The division then yields 0, the whole
oom_score_adj contribution goes away, and a task protected with
-997 scores the same as a best-effort task with 1000.  The -1000
exemption is checked separately above and still works.

DIV_ROUND_UP(totalpages, OOM_SCORE_ADJ_MAX) would preserve the adj
weighting for small limits and change nothing meaningful for large
ones.  This is an edge case, so probably fine to leave as is -
noting it here since the line is being touched anyway.

