Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9378AF36B97
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 01:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF566B0005; Thu,  9 Apr 2026 21:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68F86B0089; Thu,  9 Apr 2026 21:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31436B008A; Thu,  9 Apr 2026 21:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8316B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 21:45:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16D18C188D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:45:50 +0000 (UTC)
X-FDA: 84640954860.13.CD52869
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1D36180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 01:45:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775785548; a=rsa-sha256;
	cv=none;
	b=A6UnMsS/bhDukakttVBM+WNOlJtk2XMZqoZB3rGQO2hq5aVjolwVPzKcpOq6ZVVWpi5AA8
	jiZbF3IILZeU5S56VQlLlRubmrhjFS23VhlaCvB/BBdL955JDejylcwilp5hO+usSZdL0b
	NPBlmaLV/pl1ZkvCZDpP4Yc743KZ8J8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775785548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoXEF3swranLJssVc+xoP6WYfizu9i2w+fTdPZ4DMNo=;
	b=lpLcNimq9TFA3Idm6uHrQ4D8eGpmlXuhk1fGoPWMDT6FpIeE4Gx7VNIpEhTju2y+9BEKaI
	CIrPiqikVoimE7jYrT+hFEPCAKYeMy0eltVKOAgO+Pect7sD2KtXNRfUG34k3hFbqwmiC0
	53gTRkViKdy81AkHwqk9flDmP5AGilE=
X-UUID: fae9241a347e11f1aa26b74ffac11d73-20260410
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_MISS, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c0a3695b-2827-4ab0-be2c-583600168ecd,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:c0a3695b-2827-4ab0-be2c-583600168ecd,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:2de7d952e5399516536cf2261e99e66d,BulkI
	D:260402190217GRSRXCIQ,BulkQuantity:7,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil
	,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,D
	KP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fae9241a347e11f1aa26b74ffac11d73-20260410
X-User: duanchenghao@kylinos.cn
Received: from localhost [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1494716942; Fri, 10 Apr 2026 09:45:40 +0800
Date: Fri, 10 Apr 2026 09:45:37 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 2/7] mm/memfd_luo: optimize shmem_recalc_inode calls
 in retrieve path
Message-ID: <20260410014537.GA28528@chenghao-pc>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
 <20260326084727.118437-3-duanchenghao@kylinos.cn>
 <2vxz8qb5hbgz.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2vxz8qb5hbgz.fsf@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1D36180003
X-Stat-Signature: uo8xdki7rdrzobuiijitj8tcgzm55axu
X-Rspam-User: 
X-HE-Tag: 1775785546-272388
X-HE-Meta: U2FsdGVkX19E0R5wrYDCx+HPGTUfjJcbWWQnG+jt5IvIHxzjxkaLo9ofqIOrIf1qPBaHd6948HPQLY+luRp26Kh0kIVIcvXJEkJQFkXZi18tdbivFEzgIG+Vq87PS969koLZSFO0tN6MNlp8zaf5Sz5XMVMoLsY2X8RokNzi774hkTKqlTFRjclDG0jTnVAEivVoMRDSXx+Vpp38V5hCRp75W7RNfh5S2wtdXAwnVOt2XC6gjV/88yeWtGXJ2mQSPbPVGl8lZQZVqTEb45OXqS1vzgXPM7nRXTrK+qM5tMgxB+GgYIFH/RNaD2u2iclR43K9UsjU1JuloTVJkNMmddbl1BBmBAD1EDOyhenz68N2atOnJaC2FxW8hECFZZqRCdOJUJtWtYWl+EZMErMw/uFN3JR6veCdj1LFZK3XV9yjaxE5JIwYi4Vx2/3Kr06TVk+rcILqeWE93TGtcZEFWQJA8NEsiMM1w0jylPS07P0U2I3NMgFw5zMbTIpi4EVKpJGhiik7JIzPgz2YbGfggJBSJxBBqAAj+hdea48u3a4HUP0GwJyhCVhpTtI6hegOe4u2hmYE3F3X/5zOpp5k1Lm5sK+usoKUwXHnZ2yQyNndsISsS7M0vpzw9Au3ipRY+bnihbiAu/cAmK8ZpgZicuI5VlYCij4XGI2LBQzLH1HfZwa2J+ucUgVt/TLsvgxAQLm69E7FZXtxVVqS+YHsUK8sH5+KDWLyRpvWaULh9slWhUzarY8uU/J001QvrRzcUWYIh/WCLTQDhm/Di2lm1tGQenKv9253nmiwATZ8RJ82FyAAIaN/C/e6pEDhMjND5Fmo1b+W1IFDQ3DjnvicHDtBzI9QynQuSbAxtkVfNV3XdCn+ACyuhnKS0CHmjvS3nv925cibVR771DksGYasknU3ApfCRefLqlvYAVLApayhaRr+5uB29KNOQ3eioKRoClTsznDWMa7k56PkITS
 EnaEjQwl
 lA2+B96KsQmDFdMOkv9PyKPkY/ET06r4BTjrYxSIWr1bEhSjetDCCPTYgZzFm0Nx409TxaiqdSlaUsPOY82fGm5cqDXqXXSb3zleO5LQvKaXs0L9Cf26X2trCL62f31KLSmx1hFLK4T5gCRfdnBpbundHXuUh9rYDqGrT1je8eivV242U2MEceSFc2iY5T36DeQRYoq2tq5N/Ucf4xQwDTYfsvaIcPWg3ioc0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 11:02:04AM +0000, Pratyush Yadav wrote:
> On Thu, Mar 26 2026, Chenghao Duan wrote:
> 
> > Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
> > to improve performance when restoring large memfds.
> >
> > Currently, shmem_recalc_inode() is called for each folio during restore,
> > which is O(n) expensive operations. This patch collects the number of
> > successfully added folios and calls shmem_recalc_inode() once after the
> > loop completes, reducing complexity to O(1).
> >
> > Additionally, fix the error path to also call shmem_recalc_inode() for
> > the folios that were successfully added before the error occurred.
> >
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> 
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> 
> BTW, can we also do the same for shmem_inode_acct_blocks() it the call
> to it can also be aggregated in the same way? You don't have to do it in
> this series, but possibly as a follow up.
> 
Thanks for pointing that out.

We can move shmem_recalc_inode() outside the loop for aggregation, as it
performs a single inode state update for the folios.

In contrast, shmem_inode_acct_blocks() is a validation step for resource
reservation, quota, and block accounting. Since it can fail on its own,
aggregating it outside the loop would complicate the error handling and
rollback paths, especially when only a subset of folios have been restored.

BRs
Chenghao
> [...]
> 
> -- 
> Regards,
> Pratyush Yadav

