Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB27BEC01CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081956B0089; Mon, 23 Mar 2026 07:07:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031F36B008A; Mon, 23 Mar 2026 07:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A5E6B008C; Mon, 23 Mar 2026 07:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D83596B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:07:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9680413BF84
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:07:30 +0000 (UTC)
X-FDA: 84577051860.15.89FF377
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id B7D9AA0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:07:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=0aNdsj8PaSEniXngWJbx8+5KoHYrzdhnzPiiCGQs3rU=;
	b=lb2HBTT2so2L0ZNoPZbCCTwmCOE5IljPdHZcz/sx3xAtZCxXBkxeNDdeX9zwJNRG5+DzkS
	BeDVBoiRf3Y3FKw1fVCeziNTivkb8warx9bQaxvyP0j/64pb8XYvfKHdtzPjE+tLlm/WmI
	ooxrejjmLB2WnouL6FvSnYj6NkvazRY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264048; a=rsa-sha256;
	cv=none;
	b=uPQuCHVFQ6Rc4SzAOPyWxoYrg0I6Lj73Jf6/U+l31XfILhvyyWFyUnrBjx8GOCP4EBLgga
	3K24qwNHajwzJWADgXLtmIR2YL2djjVeNIYP2/dT21cgW9McVLh/9SCLV1PdRV3vDmFNYK
	djDZnGWOT/FxvO4uyUDggHcLrY5vaOk=
X-UUID: 6f32154626a811f1a21c59e7364eecb8-20260323
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_BLACK, ABX_EXPLOIT
	ABX_HEURISTIC, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:685c1e49-7ba7-419c-a199-5ef5d043eb7d,IP:20,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:10
X-CID-INFO: VERSION:1.3.11,REQID:685c1e49-7ba7-419c-a199-5ef5d043eb7d,IP:20,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-META: VersionHash:89c9d04,CLOUDID:20736f0d8911a9e95f0121d8c7442fa1,BulkI
	D:260323190711XSJ8CHOQ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6f32154626a811f1a21c59e7364eecb8-20260323
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(183.242.174.22)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1117164201; Mon, 23 Mar 2026 19:07:08 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: [PATCH v2 0/4] Modify memfd_luo code
Date: Mon, 23 Mar 2026 19:07:00 +0800
Message-Id: <20260323110704.193413-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7D9AA0005
X-Stat-Signature: o7kzwcqxswwq6ppt6ncbezn6t8r9bmo1
X-Rspam-User: 
X-HE-Tag: 1774264045-681241
X-HE-Meta: U2FsdGVkX18RyC9D6szIokoA48Q4lRxl+3jVmYpF5m5DUvC6DseTrVroAeT88ZfuiHdfuc8rjZvoytzAzhfgWSNpQrrxqEEwEuoiNZHFnUTcjEiqsymY9qMs+7gchyT6mwrAIifhXpt1cpoKzHeQzD82T3o3fuEiTNb4imoBoGPHMTzk4HPbxpahIqpcERb1QoZLTadjEgKdq4UmiZF7WbYyL2nLKfCjLQ+G2JqJOpNVUE94x13GO+h3QOz9er2WRS/zFIz83AbIypZsfZdJUkGVeESe3MzG/v42yL3ND9yrQe2sB/hGibdVrYuuAfOWGOSqi//17s20fIB7ifid8WJXCGCW/HJI7SozPtK8Xdzv5Mf50Soa2zVfYtjggZQkL58btklUHNag/ACqOgX2ILYqoEitQCvLTshCFyp4zEqk5MZ/y1y78RLNdJ13CitTYgLQk5/eFyuX/zCWmu75TLG9M8CcSWrJBuEz0WlHJPADdK293Ft8UHaxRi0u5NXNsC023YLT+IkjIh5Mjz0YRsGnt8Qi4vfH6mdjix+mXtqPPVzarSxwXSqtMz1ToPV1+P7NBgLuE7GNfl46+mZRof9ieMoZeANj9VAzcQIf2dcmd5izR1nCj4L+ZIr1Rlc/8KE8BpF1npgUzrLh+7U6cOrPBDVf0EyXVLCHwvMOvvXavB8ZEo1YeVKSdkHhZY2z919NO1pnL45GX3bf6u8J2THsC8+555DKTAPjHsAmEh11uqXnQ9jjB0LA4J1mOqmJuhMREx2BgOfBgM9ELF+1XsrwU9Eo4QgLqf8DgcOJPXABezO67+CJuLnISoh8+clBVXq7HIMqzuAVME7eknwZYGIsGOHlFMtDk35yslTV4aSjNwJr3bbunAnxLv9ufSF2VtMnN3wB9yM5x04l3VT0l/fIHskSAzaBoVdwR55reFECSI6ddAD1D/KFABR3FTQfmXphEgWbH5HV9MQhKtM
 gWaG2vZU
 FHh2bvyTyXPeNgxcO1TlxGYe9Q0mxJ3Oo+OTIIlaXG9TuXaqshgrBNKGaq+OJ7b1DAsWb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I found several modifiable points while reading the code. Please review.

v2:
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

Chenghao Duan (4):
  mm/memfd: use folio_nr_pages() for shmem inode accounting
  mm/memfd_luo: optimize shmem_recalc_inode calls in retrieve path
  mm/memfd_luo: remove unnecessary memset in zero-size memfd path
  mm/memfd_luo: use i_size_write() to set inode size during retrieve

 mm/memfd_luo.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

-- 
2.25.1


