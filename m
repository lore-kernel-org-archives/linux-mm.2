Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E101FB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C49A6B0088; Mon,  6 Apr 2026 23:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275A26B0089; Mon,  6 Apr 2026 23:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164DB6B008A; Mon,  6 Apr 2026 23:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 01E666B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:55:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3D95BA410
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:55:57 +0000 (UTC)
X-FDA: 84630396354.10.80B94B1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94794100009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:55:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uhKBDx9C;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775534155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/SN3cde34vYrXXv9Yap1E3YMIsPr4AanC6zRI3cK0k=;
	b=DwuGTyQw1OD/1Oo1TC3JUTPLHGoCojZPB33BrC6DAZFopAF3ExLXPPSGmssP05QoAg+yGX
	Je4d0x8zrdSM9DK6bfKMkRrzs3aXA00hZ8FKd96ssPi3kuGTZPLnN+dmBx4yN+tDHFsCSG
	atBuMJawTsA8b+hR/bgG+N+887JKI68=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uhKBDx9C;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775534155; a=rsa-sha256;
	cv=none;
	b=LmQKjAoL7dVsaYx5aPQZxdASSM9Ebk/qy3Sgon7+XIUPLkgFhZFtdqoDpWlC5odbqdwTeL
	mUQ3k0I3nznISsCKgFvzgSwhupTqLelMuvbZsEhQJVUtM/6gHzoDTj97hhpWLe2GI9W1aj
	BpAjtKDL1dzF8F5Itl1Jgnba46aAuLE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N/SN3cde34vYrXXv9Yap1E3YMIsPr4AanC6zRI3cK0k=;
	b=uhKBDx9CRiP9dznDHPcAkzvQcYzKf+KKMOiPGcXiexycWbsSTMd1KgFwfPAHLOxP3YyQrMynU
	pagQ1IEkx1g07P4uhWYC2vBErW7iTxaB4srAQ+vsATgYjVbNx3cleQrVnxqXszYZn/tMo2UX/Pn
	z6W9yX1IZSPrP9YF2Kkcwzo=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fqXJ74B00znTVg;
	Tue,  7 Apr 2026 11:49:27 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4B43140565;
	Tue,  7 Apr 2026 11:55:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 11:55:50 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Apr 2026 11:55:48 +0800
Subject: Re: [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio
 to return MF_DELAYED
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
 <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
 <adA_1zXLUBqmSHFl@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <5c5dfa85-baab-5c0f-6f6d-b71abbe10ed8@huawei.com>
Date: Tue, 7 Apr 2026 11:55:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <adA_1zXLUBqmSHFl@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 94794100009
X-Stat-Signature: u1etj73uwftw8zxe64yw9swrb3mdzdk6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775534154-457098
X-HE-Meta: U2FsdGVkX19WQYgA8ldb+1Yrd0/PDQ6wHp45ODVqA1wq9vw/KCL9Wbnlrq8NoFIJvcCmchwD185CDsSClhtKd9D9HLLKV3qERvaZb4iOOgWVaRJAL5AaJU3V1BIwIIsBvEx29QaSR7+0LdypQKTnDknLAykT9PKOeqEP52/33ufSiZZRMLEzKDgb1zyW8U4NRGN/nBT0ZR0EvBAzFipQpRcAyo3s0FFsO4SszaBlkSyXHF3Rsvn5A+dIlbwTr7pf6ibbAoe5tmvLr5zNV3Leh17f9au7aGB3Nj+1+0gAAJxl1fI0RKBpRc+ewHDJUBf++eSjPpRJwbwsrcJBnVW5ibuKGTnl0KlCi2RZZxA690YQjYe5giNsPxxvcuO3+MTd1ofKdWKCo8o9jbdLdBdX4X60QUVEeWxxyKpEFWeeTvZvRj0dG5LqniSRemTM2kp+mvirODGvaTZ2K38c5dIgCtt8OiBpZEg2/TuQXrQWmLMF7jtkHfQH0YWT8xPPmoQZKMvhv1hvyDaEc7Wvy2iRBuQjonyYYRMcYYj5KBlK3FnGkZe/Hy9Qs65qsCozpEpThwS2M6M/Z2tnX4SqoeemIpejVqX4j1nK7Bg/9ZbBAJLrud/gY/dO0eWxHKjppfazte0eKecgb2+YE7eQMiVSeYEcavdbYc4sI/r+F+LPyO8cZ/M4DJvlLCneYvXFH74awyyPiUvGzRnk8mixbmM6nk6mYgOvIuh+tR3Mf5zyAz2os5hjCt0UMWAHCZo5Nfu+OBAe1Wr/cfQPva6xqppR4MhRNan41pMF+Q+qlEjRVaJWnW4rN9x1VKS/b4QciHv12yW11qSovExGcAsdnWXT0Rsn9y0PbNoFwPGQUSTIx2/Jy4bHJ8ovWBTIsUp93ydsOkp2c6dBKK7yEnCvpy4fHjsQDoYhZ67qyK8DVJHRkKvOYIP6eYuCNk2IDmFTd2Bh/JZ96ktDMwC9g+mkVn4
 GQfUxPIY
 Ypyiw9kQQ/xUrxYFhrMPtm/Fg1eNXjgAzs9a94dS+vjPpuZ2PxSHPisGRB3RpO5DRU2vMV2i8YJrlIANuoekALAA3pFtQRhNDB3TVnPRwKyMmkiu7OnGNm3gbEDJwomJh4px9Ovs9sQi14HNZ9x1e8NGDpUka5eoYrnxsx0Sgj3aeJB416DPEdRdkvKSFvmmPqmRPKV/ULee5+zAOhBglU8sML11ESou6Xtk4+eWKDuDdoh1ZxowKTwdGlZAgmIV/7YS3ai1QKGl5yv7BDd31CKso9WraGG3lxEuFJF/rAoRHmenj/dz0zRU4nHIsITcuAI5HxbpKADv0y6tnCnqR1qQkA0Pe+KEbGK8U+u/hPQJjQfwnmIj2i6EVMSkjtIdUwGnFLFlg2d2zUIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/4 6:31, Lisa Wang wrote:
>> On Mon, Mar 30, 2026 at 03:02:01PM +0800, Miaohe Lin wrote:
> [...snip...]
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -941,6 +941,8 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
>>>  	if (mapping->a_ops->error_remove_folio) {
>>>  		int err = mapping->a_ops->error_remove_folio(mapping, folio);
>>>  
>>> +		if (err == MF_DELAYED)
>>> +			return err;
>>
>> Will it be better to add a pr_info here to provide some information for users?
>>
>> Thanks.
>> .
> I think we don't need to add pr_info here; truncate_error_folio() always
> leads to action_result, which already logs the recovery status.

No strong opinion but I want to make code style more consistent with sth. like below:

if (err == MF_DELAYED)
	pr_info xxx
else if (err != 0)
	pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
else if (!filemap_release_folio(folio, GFP_NOIO))
	pr_info("%#lx: failed to release buffers\n", pfn);
else
	ret = MF_RECOVERED;

Thanks.
.


