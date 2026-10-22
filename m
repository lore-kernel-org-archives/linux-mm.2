Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33777606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581AF6B08B7; Thu, 22 Oct 2026 03:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5323C6B08B8; Thu, 22 Oct 2026 03:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4479F6B08B9; Thu, 22 Oct 2026 03:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0A16B08B7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:00:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4FCB4076C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:00:04 +0000 (UTC)
X-FDA: 85349362728.12.EF50407
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 742AE80002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:00:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792652402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BOLg1bCs1asBKE5aZ98+9ofFLvLtot0mhuaU4d+8L6s=;
	b=TpY8wf2ztT/l96g9JkVES8S6eTzJ9uJz8TXk5wnuR733nT0zZBGeE7dUnHJl54Vd/ctEAG
	6AzWx1s1BlTKy7Z4spPLhSl8obFfrNT6sV3wKijfhjkSm3/oEiOrMmpj/FWKcQGgx8GqOt
	WnQ7fgSM8mItU90PR7xxrumSNqVq9a4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792652402;
	b=hM50U7ZACPZsKtqMRP0l7FiPzpPO51DKlBPnRsjfNt2y0yNyfs591pNLJa0JzfS1tdzZJe
	K9Ev1OfjXGF3DOGWqV8/2fzaHG67ulVzMfMH2boegjs1iodTWkuzijnSgDU4grBQ6Ua2n7
	cTQNNRIjDuTxMFUDrXFomAD6VuwbqI4=
X-UUID: 2d4ae9f6cde611f19a56ed5b684f684d-20261022
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:cdde1391-a70e-4a75-98c7-827322d195e5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION
	:release,TS:18
X-CID-INFO: VERSION:1.3.19,REQID:cdde1391-a70e-4a75-98c7-827322d195e5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:8,RULE:Release_Ham,ACTION:r
	elease,TS:18
X-CID-META: VersionHash:7db8b62,CLOUDID:8320dbb3c3d1d88689539e9c062e238a,BulkI
	D:261021142134RET8CHV6,BulkQuantity:5,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40|20,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0
	,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2d4ae9f6cde611f19a56ed5b684f684d-20261022
X-User: lienze@kylinos.cn
Received: from [192.168.111.179] [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1123371837; Thu, 22 Oct 2026 14:59:51 +0800
Message-ID: <ca400732-79c7-48b3-85f6-a5374d80e58f@kylinos.cn>
Date: Thu, 22 Oct 2026 14:59:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH] mm/hugetlb: drop unused mm parameter from
 unmap_ref_private()
To: Gregory Price <gourry@gourry.net>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org
References: <20261021061901.376104-1-lienze@kylinos.cn>
 <atjO4rhSYGJjaWCC@gourry-fedora-PF4VCD3F>
Content-Language: en-US
In-Reply-To: <atjO4rhSYGJjaWCC@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 742AE80002
X-Rspam-User: 
X-Stat-Signature: 6fkbyzot1pdpw71p7mhtnfcadaz8o18b
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792652400-766304
X-HE-Meta: U2FsdGVkX18mm0g83t9SiZQP2BaXGQIV29jwytbKEVZO+2vYH8nGQLte2ysw4wzDxCxMhwkFO7t816K0lFH51+AJJNF71bVsMQ9QdlBko4HLgVtfZdyLtfxziaHv3HVR+wWVbSZ1bpqGwgwgQwkFQbU8+WHpEpcVgBYrUSML7Oy6CMl5pV/RqlFqf9Esir1g0N6vURQ5gGq4FGzhBPK7VSL6vUpwoUtv/AHzEK1ttsvXW7PHV2NOdDMMmlVfjmX6wgjak3QZk4kvlV1xtYsn32B5F8C46AdGbd01s+m70HB7Tp45Cvi7xBvFL9g/040w8PFYU9718hgfPbz5z2DB/EX7fSvl4+UukcGhzvyt4Rh2YwED52sFSsFf3L8Ev1fJvwqFTWlzi9kq+sA40zoRrVne5sD2g9KnvdfijasK19cwYLaTt1v5XUx2HmTTB4BX3t637ec1pdbcBMGQOWzXh9EbTZisV/GTFISix2i1i2sgD1HfMkVyYDUpnC3bdcmA/gZNYUPPGiw0JsTU6Nrj33Z0OMgOJ1+R3TBLL3XwAj1mJMSsSSVTAwjQnCUv2h22dRUdXlFRBYe5inM1E7b2yCig4sd2bN2hVH/XNWppyWhl5M6vs4ISZxAPpsv1C5dYKhLnV1hnm7kyQMGKECoSEvNYa4Kl0PFuj7sQU87m0d3N1Tw+Oy6oz/rLymJO3+JTqWodZ+7fJbe63Brp1JJTgICfy5hL0oYwqvqrDcwEdJedHD5upizZGadbJ3IXAvNgpu7tQdMDxKyLbdpt0TLSiAWxYaQRnaZ63I5hbxlXwr7IYpvnpHGpsQ1wCHDgQIFa3kpiDLZRBdEx7+7x5Ztxi9SusNNZNG1uurYSm9rJhWEzdTx6Q7wQ1EL0eSiUMuqhq8I6JBRrIvpFsC8Fwg+M3W7aVLOfqYdzGhT1kJMBscPq+E6cDI5J1not+H1iwqHuE/9qRuWBXro4iSaPuzB
 FLtaX+14
 iuMUJrXRbZoLqivGL8po1CrYor51Q7UITTqoI7RLbKANuRvMHYXWXQiBUnOxJLH6BSaNBi/NTW/PjXTVG7qJGFdt01zowM0PA4xRTeaUckLD9b9sOTeOaMLGqzPjS+3BJjCACk1bvc8WxsFSwKHWiO34/F4XeuoHSGHR/CNzzYvgi9pcE41apYTQLsQygG2ONbjvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thank you, Gregory!

I noticed this was sent off-list, so looping the list back in for
record.

Thanks,
Enze

On 10/21/26 10:41 PM, Gregory Price wrote:
> On Wed, Oct 21, 2026 at 02:19:01PM +0800, Enze Li wrote:
>> The mm parameter has never been used since the helper was introduced in
>> commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
>> called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and drop
>> it at the sole call site.
>>
>> Signed-off-by: Enze Li <lienze@kylinos.cn>
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


