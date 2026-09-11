Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D09C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 10:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40AB16B008A; Fri, 11 Sep 2026 06:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD116B008C; Fri, 11 Sep 2026 06:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1DA6B0092; Fri, 11 Sep 2026 06:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22436B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:51:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45C3D1A01BF
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:51:13 +0000 (UTC)
X-FDA: 85201164426.24.2085F19
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFA1640006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:51:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AIz7jU+N;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789123871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNIARwvAoaD587kn8kLvRjpjKEQ+aDSYPufdVCROqUQ=;
	b=Q8WdBKoo8LZVm6Xsn7KHSHxWaDzp5Is3ltjAVMgRU3L0oG10c/KrmacwwcC/HcHbcdWU/T
	tUj/Vrwta8KuCYmwQucn8Ux5RiMP60a6AJe28czSpePKQcOsArg+4//U/rTYHZ3BhnbpFO
	Z0yvgclSo1xZExANz5exez6OzTq22Xk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AIz7jU+N;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789123871;
	b=naohJspE5WHvSxbQ+NmGwykrvf81ZXtbctY1DIFvVG9Iu2i4m5vvqgvmHECFl+LXLbq1Ds
	EcPtbPSHQjvhYgxrTIGdOrIOiE3LPyODAKmJ/6RP4v3VlfLgyckahWaWcf14Umm/mbcbJm
	qUbINbhPIF7Dt0RFVf61QQd1DgWCIiA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YNIARwvAoaD587kn8kLvRjpjKEQ+aDSYPufdVCROqUQ=;
	b=AIz7jU+N0TKZGvyxZmpvRaHfK9ACzUFrPcPQzf4wOuWlMI2yC9QrgixQZJVyBB4sqnpDo4EFo
	AWZFQYN54yHyznl9+IQKrUxEBy4eo1u8JpDd9DY+Gucla3YzXvz5c1gaj6geiJT6MABM5Myn27x
	OaFLo60/KYV1AvK2D9DAzLs=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hh9zX1WG2z1K9B2;
	Fri, 11 Sep 2026 18:40:08 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id F083640578;
	Fri, 11 Sep 2026 18:51:03 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 kwepemk300003.china.huawei.com (7.202.195.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:51:02 +0800
Message-ID: <b430989d-a146-4db7-ba82-21c5b5e04f11@huawei.com>
Date: Fri, 11 Sep 2026 18:51:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: kill xfs_trans_set/clear_context() helpers
To: Christoph Hellwig <hch@infradead.org>
CC: Brian Foster <bfoster@redhat.com>, <brauner@kernel.org>,
	<djwong@kernel.org>, <cem@kernel.org>, <akpm@linux-foundation.org>,
	<vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<brendan.jackman@linux.dev>, <hannes@cmpxchg.org>, <ziy@nvidia.com>,
	<david@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<ljs@kernel.org>, <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Linux MM
	<linux-mm@kvack.org>
References: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <20260910140742.833170-1-wangkefeng.wang@huawei.com>
 <aqLqeTsbKBMEsl-G@bfoster> <93256043-c590-4001-bd7f-41ba36055b94@huawei.com>
 <aqOp035i41XIrDXg@infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aqOp035i41XIrDXg@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFA1640006
X-Stat-Signature: iszdcmom4kk83wrdomzum5z76qsx3jjm
X-Rspam-User: 
X-HE-Tag: 1789123869-206659
X-HE-Meta: U2FsdGVkX19altn99pC9nuOFOLbz+3H6F7O9BCcnOx2xP+YjwOCncZYrfVnpjibJ03m5pO3L9p/N8810Jw64kgmU4QGSldSFBaaFkqNt10b5Drib8V0s52P/WFerOfTIVA5r3G93H8QFwh3S+WpgBg50mNLKcL+b+eYdAvXkP14PXINS9pB1TpNI+q0VCys5I9D8KQHaL1IjLrlDo5B+YbXXhub908+z6ryueqTQGdMyCr9UV/O/J+ERHAc0N/V6BnDtE36mOLRFAfuNaRGxHiKgYNiPogrqOeOXADLd5Ydk81DajzylsC4EjduOK3b4V5fKB4AxmoCBSGvGUjQLTraVokDauw35d5nk+xz6Hf1wKSBWVHc7NDxL4YhIRvUU90RHP+IEO0Cfe9CHYYG7NuIynGCmuQaYcow8jplbt0gXLVwtTa6zx3YrhVCpTRZ+8o+we3FUMssmDekq4eGapU+gBq2pyCLbvchCvHe09FgcUO10AADYIb18GMweEyHQFJAb8a8y72dhwo2hg9KFrfQKede/V7n6KnseteSgOaggx5Xxr09HbSimqIJTvA9RHN+du0K8YFlZgzZU3sq0wm4imEOMnuuQyYmirIrpnkTtF/I4gAmRWJFjLskCLVQqPEqaBTHahjATcfXzKQeKkN51Ff2F7LDNrye1TU26e1O+PVH+BDr8ob3a1nu5Rygv0j8qZp7ct4AUst/hhbaET+IGfP7jO4wHPiEdw99G0Oq8VnkpUPQ8F0h+w4TRPCYXDN9fgUF7CnDIWlxhCexh3N5gaKZX76ePRWt+3qtFmEyOSSj10PYqVG+kQw2rRc6+WnkSPRW4dFtKnJC2dbCPc2zRlLRvZH19MkenwPs6orFL/GEzlWqC8peJ5UQSba5k9xbpRoI9Si69wM2OeiSvgc83yR0xarA1hig1/4hRvHTnJ7hHBqqDJTO7hYGuc9aaAN9Y1+a1mfSMdjq21x8
 ZJnVMdUw
 cttTN2C+jdNfQOTHsz8MC2xy5Qjbr9Pxw5mq6bpRaZW0Jq8nRXr2PUskde3mrNuN7S1AczR5vDiI3iVih1PQ2jpFKOhjwUqwmC90SWV/4R/2UgbL33fEiJVA36PwzOBjKRoNFsJxow/vU8lUjGAkgHnpxpgRy+BcWqn5TMTplLKR4g6qbq0g91NWQzPFvqiDxvsHeHGstd3+rDtsxrFelDWWIamOfznXX/Pncxx/O+oYyyGMlAidTwA1CJCSwM+iNG+QQJzv8my/W2l5FloqIuwmlzUXI7GJ3SFxX/ZORmhDba9ZVAtuoc4vv83BxuJ0sYL0dl1Vq0XZp/ruVoVQNXF9F+3+L+0hmS8uxo51vsT9SvD0YfW+4F4tzPlEGGPdpi0h7w8FiqLRxznCMtSYFJrodYEZpJvU2GVDbkMC962u4DLDqOVHbWWlkZCUDLEEC7ZFT3uUqQaZZ1Xs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/2026 3:12 PM, Christoph Hellwig wrote:
> On Fri, Sep 11, 2026 at 08:57:53AM +0800, Kefeng Wang wrote:
>> Another question is the target repository for merging this patch.
>> Both this patch and the previous bug fix are based on the mm-new
>> branch. Merging into xfs separately (if an independent branch exists) might
>> cause conflicts.
> 
> Your first follow up fixes a xfs bug that can have somewhat nasty
> consequences.  So I'd suggest you send us a standalone series that
> we can get into 7.3 and -stable with as few dependencies as possible.
> mm-new can get rebased on top of that, and then we can delay the pure
> cleanups for xfs until after that is merged


Thank you for your suggestion. I rebase on v7.3-rc2 and resend them.
https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/T/#t


