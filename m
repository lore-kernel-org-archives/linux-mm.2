Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A09CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44B36B008C; Wed, 13 May 2026 05:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C966B0092; Wed, 13 May 2026 05:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BC16B0093; Wed, 13 May 2026 05:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99C2F6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:08:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4702C1C0693
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:46 +0000 (UTC)
X-FDA: 84761821452.03.4D19612
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 11FD04000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778663324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ta2AvyGIKHZArVni97Skdw0HDIv0oz2tpoUDNQUICoU=;
	b=5/Hy4ARmUOH8mvpeEVeV5YzuRrWSqoiWOalhLjtwPaCEJsRoaVtPH7eoo0dwBeQu9pbTlr
	LuSejEa292sQBrz7BevznBDYyyvA3KNNMXr6GFRWlWsJirxrERPKddJjduT8b4cuGtbrVF
	hzsvzKR/Kd2iWN3aGc9uw5Gci1Z8wiI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778663324; a=rsa-sha256;
	cv=none;
	b=DYGLYgSpQBU6cBV8vnb1sKQZIEUY9ANbEr0L5XSLiHvXGUGr86X+HHXr5Iv3zl3JzCpTFp
	dfMYoKGJY0VYZxft4MJaZtOgk+ro9x9fohikr0nGmyuQcXi6PNQ35XyvJllQaysT4iTc4D
	EAPP8U87GUIpH/uUnPGFdrbGv5SjuI4=
X-UUID: 51dcdc9e4eab11f1aa26b74ffac11d73-20260513
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:3bab31d9-4453-4624-9563-d9e1d3b96e80,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:3bab31d9-4453-4624-9563-d9e1d3b96e80,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8c15798bd28ee1b51f4109a5929bb994,BulkI
	D:260513122752V9YYB0QK,BulkQuantity:1,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|817|841|850|898,TC:nil,Content:-10|-8|-5|14|50,EDM:-3,IP:-2,UR
	L:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SP
	R:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 51dcdc9e4eab11f1aa26b74ffac11d73-20260513
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 466138212; Wed, 13 May 2026 17:08:34 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: dev.jain@arm.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
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
Subject: Re: [PATCH] selftests/mm: Fix incorrect mmap() error handling with NULL instead of MAP_FAILED
Date: Wed, 13 May 2026 17:09:05 +0800
Message-Id: <20260513090905.765774-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <04203abd-b729-40cf-87e4-186b12c17298@arm.com>
References: <04203abd-b729-40cf-87e4-186b12c17298@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gqgfz6yioa1rywshsm3drnm11ib6kqzj
X-Rspamd-Queue-Id: 11FD04000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778663322-476163
X-HE-Meta: U2FsdGVkX18kRuD4lNghq3oxTSLnbIAaWzr8L8WhSxI1cGKZcff6hZ9GSxyw+slgKEwHMRhJTudWCpd6WPgoPVOpnsTXAmfRJo6qbxC9vnRMjj4XrsN5m22k9fJYt21lg3I5Y6Z0bhvXMu0WYJGRKaYnkjhQRzLqd2IRJopl7Hu0QcbbZvJUhX7eqpWc2cPXr9rG/E6krOpKwbRas9lRhF92YaOnfJ301hj6/GFEjDqAUF23X3cjHmbM3Cg0GIytwAlQcYEmTOl+P103r2W9eNpcnG9M08gzbtPIL9ai9m1SOTqcb9A6U8N0O0gNKjS6Z0d0fG8ji2aIpwoxNBwWR5pn9tGQMBHs79QCnMqkKKOawwctYvcYQVJr3oYkOYczXX+qQtbiI9RLgjtmm2wUpsTcHzmIWaO1hOVbe4ZEcIW1lfptugKhTxVI1biOSEjVvMAvpJdyzLeZt3y2O1fonIwAViJFYoCXvmbqaCxYw0evcqDjLQ90uBXZqZg26j8d9SQIEB4rH6wwxshISTGSFNtfX4mng66GJWKrIH3qf/YAzCQBTZlBjAkiOQ214dGqv4LWUcUS9jBUZ8OEo/cORH6WXx3SjhbQZAyHsEbV9g+xc+EtxW5ce8Y/ytVBk58jmB+2ThuilrmQ7ZdLt73pIeSHYOdFRCZ0fpPpjsPt+6a7Hsbclph62tecTgXe1fcMnmSZLxvjo4QRX7RjZdvMR4iG5kNJxK9DsBDLHYTEa/P3Fh40GrIR9S80FlK8fnCMMw4S/1LtLvRG/KgRvywghH7adD82Phueonb/mwEpKalUkwMYuXMWtSbImMaSbX0skJYuZ0no4EHpZptFXxaioK1XmehAq4+X+VSmwRIHdD4K7CjzlBXVmd4bfZnskYpjDKst0wC7asgAU6mSZpTLl8J+RlJ8DtzTPgaXKY9kgiIjEpcQ+Pu8kHIgmOBvl7Rg2l0sqdWKkpS+nPY6JLj
 qz2Kcji2
 dMSlQk6JI0cWO/g9EJhnB7MxR7SEfx35yS1EOmjawff1l0AxoxQUNv9A2mY0RaalqckYcXExdFg8WQM3+tnYcfiv1OIYs4jd4h7IY+sBBHAG3FHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> > not NULL.  Several selftests incorrectly check the return value of
> > mmap() using !ptr or ptr == NULL, which would erroneously treat
> > MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> > non-NULL.  This can lead to segfaults when mmap() actually fails
> > under memory pressure.
> > 
> > Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> Hopefully you have fixed all instances in selftests/mm :)
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thanks a lot for the reminder.
I missed some cases in selftests/mm, will fix all of them and post
v2 shortly.

Thanks again for your review.

Best regards,
Hongfu

