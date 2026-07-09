Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DDC6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 01:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08406B008A; Wed,  8 Jul 2026 21:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFA26B008C; Wed,  8 Jul 2026 21:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8126B0092; Wed,  8 Jul 2026 21:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4F376B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:55:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23F434038F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:55:28 +0000 (UTC)
X-FDA: 84967571136.05.05D9E93
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE346140005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:55:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783562126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LloEwvMY9GGAsbiI4eeZBBYaWMHHbJEVNQiEJZqx0XI=;
	b=pvZzSET7Ensc73I1+pAhc+g7saHotzeEc8JAtJEFqFnQmFnGUfnbd4660J7wbGbkTwgr0s
	L+7BYcBXNv1GNYLSgAGr+bdn3MNvTcvb+FRDi/6mfVpCKKqk07LYE0AgHp41+13L/Oya3Z
	pBprsbOKQSf0bHAFmsdX6DcWzEBD/Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783562126;
	b=Ke+tiFxK1er2oQGW1HRXx6E7zdQSdaC2Y9MfrMKtfl/16C3MNX409OYcPBTNsBOI5rJQPm
	y9wK3+xCCglAnm44/WAAwR08yjsH6tsFaPhhHpzKAwnFtVhCI+COZ+Hf9Yk+nJofUNDHyq
	hW/V93fz/ZdXmqIzSmGeF8K67KTx/Cg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
X-UUID: 3c4dde187b3911f1aa26b74ffac11d73-20260709
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:abfe4ba2-cac0-4f47-b462-ecca843d3bb0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:fc6c9494758eabc419db5f7bb6b48182,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|850|865|898,TC:nil,Conte
	nt:-10|0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3c4dde187b3911f1aa26b74ffac11d73-20260709
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 309357710; Thu, 09 Jul 2026 09:55:18 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hongfu.li@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org,
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
Subject: Re: [PATCH] selftests/mm: Fix memleak in migration benchmark
Date: Thu,  9 Jul 2026 09:54:04 +0800
Message-Id: <20260709015404.1267976-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a9b3885b-b764-49ce-9335-6efce3e67b77@kernel.org>
References: <a9b3885b-b764-49ce-9335-6efce3e67b77@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE346140005
X-Stat-Signature: rt6h5zcb8prj81uqpghqdw17jxjx8f6e
X-HE-Tag: 1783562124-87334
X-HE-Meta: U2FsdGVkX1/qnHY0haL17HzFIcsFUIld8CdVHZBAdiQ4fnIFF2JVhIu3JkeTrsUzkIjDLfcbEeR8cRS6UpG+F8GXkcPaFjBUyOWuuRVKtXR+prQP6gT2I3q7sBu8Uk5v40JAMXTdKCfHZ2GcMUSW5/mhbyOPy55DbICBVRPcdn19h38SpfHtuIUhX+mqQs+8h94WiFoNaEnHdY+F3lRIJEQxJHP94ZSfutEfnlYoociQI4jE7TvUFElJFq5/1lOySxfipimN3oVk5MLaSWvbg940Nm6ap7EOGLAgGgtOIvKNt3is6c8cQPCHenR9u0IThOdA9EZJWTgMhGia7gFC+Iku86P7oXdtSfe0wysG8B/TIW/mydqxM/k87r7JNE4yjj6zRTztn/4mskBYo6vma0vR3oVMZemK0fqgO+Yk7BzuZsHlJdjYJcMWTwVcc0UIs2LyxOZUcrt+iDPbKMzyDOKd7AKfoTefXCcLuPdYLkH+Oo4Z9/7//hfRM+Qer22WUzdELUwnNoawZU6W6Ew0bF60MnFoUaFyIBUFI/aXlihXtXVv4Ykh89q+nGDcuTcJ2z0ZU4uxVfdjGOBYAc/I8tuFjprLb10JUn5KRT5UxGtBeS73m4n4rCnbog7fFApy9bPV4csg4mA2p/s4RJQbj2GQtEpCOaufuXEwyXqcHaNxVo3m8lrOL4OgmSG3n6wZmFOGiYjkc4Jn/3XtylD4T7jwJ9jFIQ8bPvsk+X1GtYQbGqhB3CiFf/iWE/eHYA6Sxv+qbngOVuAXMULE4fTWNHQeCgpfK6xBzeZGfOY5wpyc32xCmADe1HTh3TcEviiL2sWpJqIAKbWeaw2GxO6In64VIJWaNAARgEJZ9Z8Prz+6JcqHPvYrDd8z0w4UvZjONQfFEhXf2fF+MHdH5cNM5nsx3ubyycURGvCdiiniTQtDfYCW/fYvQUasLVyO4ZRsU+BIxi+cdJgsOScQX2t
 u3/M5iax
 F3vxF6hpgYrOCiBtEcJF0xDIv0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> > Several early return paths in run_migration_benchmark() skip
> > hmm_buffer_free(), leaking the buffer. Replace with a single cleanup
> > label.
> > 
> 
> Probably best to add a Fixes: even when not really critical.
> 
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> > ---
> 
> Nothing jumped at me
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for reviewing. Will add the Fixes tag and post an updated patch.

Best regards,
Hongfu

