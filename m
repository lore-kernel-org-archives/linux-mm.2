Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B56106F303
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC1C6B0005; Thu, 26 Mar 2026 04:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BE06B0088; Thu, 26 Mar 2026 04:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293176B008C; Thu, 26 Mar 2026 04:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA896B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:47:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B29E1108
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:47:54 +0000 (UTC)
X-FDA: 84587586468.22.60BFECF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEC59180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:47:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4wRCeZZJpPtQ28CZ0Jk06VMStKRJNTKIGhfXr1MgyDg=;
	b=m4cpyshs99E/1i71WYwr/YQxETK6EuRWSJ7yQcj0I7xIkK6YuIX44aU1KusfPNRUeqNEjg
	P9CNrz0dC8kfz9kl7q4BCe+STSQEqYWyO6eAY3rRaD9Pc9PGkgsAzmHiiTdQiEKasDFKcm
	M1T35h9qTXCuOugwQxCEEaJidF6oXWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514872; a=rsa-sha256;
	cv=none;
	b=gOk1+M3DrzCFSIIgmz+hVyI0g+FQuHTOa8zxfY+/aPTTlDkArJgF2RmlK1Y0e6TpIpiAZ8
	AYqRkUEoQblYWHRKXDMnroNV+upgNOzrhV6jRHG9g4kVZL7BF+bAil3ehjj5+PXGjRTPPA
	E8gNCz9PzjbI/UIdO1KZTv6iV/s2P9c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 73c55d0828f011f1a21c59e7364eecb8-20260326
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:5ca0d562-7c30-444b-ac19-fe5ec1e98ee5,IP:10,
	URL:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:5
X-CID-INFO: VERSION:1.3.11,REQID:5ca0d562-7c30-444b-ac19-fe5ec1e98ee5,IP:10,UR
	L:25,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-META: VersionHash:89c9d04,CLOUDID:7996783b31fdf81527dc884e1c2daa08,BulkI
	D:260326164743MELBTWO0,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:11|94|81|99|1,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 73c55d0828f011f1a21c59e7364eecb8-20260326
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.21)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2030651803; Thu, 26 Mar 2026 16:47:42 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH v3 0/7] Modify memfd_luo code
Date: Thu, 26 Mar 2026 16:47:20 +0800
Message-Id: <20260326084727.118437-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xejjr7euqncf1i4qn9g7hng3jt1pwp7m
X-Rspamd-Queue-Id: AEC59180005
X-Rspam-User: 
X-HE-Tag: 1774514870-756340
X-HE-Meta: U2FsdGVkX19NNmJYKPhO1tpjGXRrYiRb6PlNhiiZivzNMh882xi1j+e8LNSDII+Ns0AuCZHkQTmQabHqkXvnUxi6b4k5V99OFma2m6x27Gg+baZu2Ig2yZ+FwAhAek25OtJEeND9EsRt+UQOu6HrbCKLqcUjJpxxlyOOpFcGJnRcufAH2L6s12etIKMhgzyVk3PN84C0gIDj2zb+KEPdvsVPUeRJNOgCA/Cz6Ze3UEnPsp0z+9DHq0aoC0NJiuliBpyfc2089NnFOTYphvSC6HZcSwfYyfp5B6bz+NK19/6/QnarHccoFTD9MI6T4YLGPb5XYUng/hSG38fo8KfS65+EZckx+a41GiZWKNJFWUK8xkiIg5IWZ+36LFVhplgSnCJjg4SZsBYw07QpZrQwhDZSStr86DNndfZA10QDHZ+nFovAvMCiso//jq88hbeLvNAyf66WDNyePkQ3TyWvPdfLJT+mU80aQkpVF6tpdLozdjQBaJAf8mSwV9WejxL7F0q9PMvOUwblO1Md12PkP0chDQnsW+izO8G2m+McOsc091Yb/Mbyheh+5+7Nm/t7Ihniclim+C8l9AaqyWWi3NSn+HkUcfK9aggvcW4EQ7p+jes9XcRnx6NzuJA7jq1yIUaxZX/8IIV30eQgNapVp/IyQFudxX7/iRzQDZFvp18Irznymt6XxwQGRCCgpmyX6B6FjrDMF0GkqJ2ZgqbEsAdInAmHUzFfi+Y3MY0QzTtBCGE/ZzrdQmC1Jg5E4RFISRFnXd/1f7xCbMJF/QnZ46Amq3FIRalhzvT7P1kypm3IsTzcQZnokxQ9L0FbajDEEK5mrYJis7ctB13mizYXzAUSlM7D39rpIN68zNkuLZwBSTqjVnbOtO2crS2eFRB5ZpEJpkYvHy6EtRjZhxY0NPw9BC1dpVi6EkGGiev4k1JZ4hsa5OVczifyr4U5PBHImocZCk4njGDvcQ4uDIE
 atjfuesE
 CzPEaTjlE2Rtgq/+0A4t6giL9dvOmbjcSfHFC3RWC44O7vyjd+ahjdoNq35Rgm5+ix8c31iC+wYNxjx0GIhB+SlBAsiq1uK2ZQAPRYsS43GUr7PmzKqtT7YZihK8TmdJxG8eQVDnWWh+6CBeFY4yHZYPlrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I found several modifiable points while reading the code. Please review.

v3:
v2 patches remain unchanged, and v3 adds 3 additional patches.
<mm/memfd_luo: fix physical address conversion in put_folios cleanup>
<mm/memfd_luo: remove folio from page cache when accounting fails>
<mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios>

These three patches address issues identified by the AI review,
with the review link as follows:
https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

v2:
https://lore.kernel.org/all/20260323140938.ba8943a5247c14b17bc70142@linux-foundation.org/

As suggested by Pratyush Yadav, add patch
<mm/memfd: use folio_nr_pages() for shmem inode accounting>.
https://lore.kernel.org/all/2vxzqzpebzi2.fsf@kernel.org/

<mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path>
Same as V1, no logic changes; depends on patch #1 for modifications.

<mm/memfd_luo: remove unnecessary memset in zero-size memfd path>
No modifications have been made.

<mm/memfd_luo: use i_size_write() to set inode size during retrieve>
Add consistency-related descriptions to the commit log.

v1:
https://lore.kernel.org/all/20260319012845.29570-1-duanchenghao@kylinos.cn/

Chenghao Duan (7):
  mm/memfd: use folio_nr_pages() for shmem inode accounting
  mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
  mm/memfd_luo: remove unnecessary memset in zero-size memfd path
  mm/memfd_luo: use i_size_write() to set inode size during retrieve
  mm/memfd_luo: fix physical address conversion in put_folios cleanup
  mm/memfd_luo: remove folio from page cache when accounting fails
  mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios

 mm/memfd_luo.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

-- 
2.25.1


