Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 916F9C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 11:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B8B6B0088; Sat, 29 Aug 2026 07:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D949C6B008A; Sat, 29 Aug 2026 07:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E316B008C; Sat, 29 Aug 2026 07:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A35C6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:32:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82BB61C1528
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:32:51 +0000 (UTC)
X-FDA: 85154094942.21.470DC6D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 58A4640006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:32:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aXgWjF3R;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788003169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwk+BI46++mQRfC3AlfNr23A+9jAy9KyTdI8CCPcTAI=;
	b=Pv15DjCdMPEnhSz2cgowkpiBfJqG4XC5EaKZPkt/MeMWTtaEfhw4AqcQCM6UTWkfcUPhIH
	D7EXXE1FWqgg3/aPy6/BBOWrWFdUA2tN2VoH2/+h8MG/JWW1nK3yX/9uExE0ROHpHBC44m
	t6OGJFkT5U5F7XT8XnkjQgsddcrbFBc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788003169;
	b=niQk97s2KFjYu5oWwltOVW1SvK6eb1tTAyixieNXuxq8RaEZd9VDghc5P7DJANeNYuJx3u
	/Ni7CTTGLsamrJt5PXk+mO8j24P4TUQtxKbv1W4PUkDCVC3w1jUN31VRNfroz6eqVfGtel
	TbrVPLxdJOQ5f1ARPXcE6iDaO4+oXso=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=aXgWjF3R;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gwk+BI46++mQRfC3AlfNr23A+9jAy9KyTdI8CCPcTAI=;
	b=aXgWjF3RCIrF73N2rxm23D543lwf65bN7UvH+g2NVAUDpVegRpfeATmI1PN02/WVWdpSFpa8M
	HWWnQOsJJpTvtR/aOTzTUPlt0KBHGvJmorYqKsCmKC7Tj1nlMNL+LZRwlN2uVVEpzZ6CT8gBQBD
	84eIU0ZhClM0bygV8z+7uEY=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hXClX0C7TzJ4686;
	Sat, 29 Aug 2026 19:32:08 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A8794058B;
	Sat, 29 Aug 2026 19:32:32 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 14:32:31 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <david@kernel.org>, <liam@infradead.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux@armlinux.org.uk>, <ljs@kernel.org>,
	<mark.rutland@arm.com>, <mhocko@suse.com>, <panov.nikita@huawei.com>,
	<rppt@kernel.org>, <surenb@google.com>, <vbabka@kernel.org>,
	<wangkefeng.wang@huawei.com>, <will@kernel.org>,
	<yang.shi@os.amperecomputing.com>
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Sat, 29 Aug 2026 19:19:53 +0800
Message-ID: <20260829111953.893466-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f47c0ab3-6d78-fcdc-b7c0-cd3a7b5c8276@gentwo.org>
References: <f47c0ab3-6d78-fcdc-b7c0-cd3a7b5c8276@gentwo.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Stat-Signature: kmif74y365o54zgpsbrekoxer5jekejr
X-Rspamd-Queue-Id: 58A4640006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788003168-1403
X-HE-Meta: U2FsdGVkX19VTlaWcrPFuPeK19jiFxdFaV0Wfdujnw3LN28h99jLayTV7Bqkbe5rn9KQflwn8Lwz1+IrAbsMzLTO6quqxVAj6xns9IeBYgeE5ZwQNzgTc01D6/AA6LL0KQBsJEkwiYkU6zDwPXOeV9jcyTMPAxCGqKp2RDKmjhHmpon9GMos0W9brvaOm9/8YsnB9Zile9AHzO/E70/nlL0Nx2HO095GCwy5DNPnqwjKykgWwYiO0Ue2lnw+7fHvyge7H+ZELctFbuG8a2Ib6BTwN6r8a07JuvLgVi+oguivsg6Bg7qUiFM6r8xVnLtI0c0ZGe7+9GeFQqJfNwnOrnwxGuf0XneRi07fQVA5jHXXx2huVwn9OCb/jJii76wgovXGczOwwX+eExsW6ajZ1alQW3Qn+Q3OPWg+nWO9O2PGmDE7nq4iivJCehIV7F84a2lIeiQa9WSxsbOcjLoyLjy9UTB4gyHnax1wKLDEe8mcNGX6kfC7iv8tdQm5bXo8RY7KQawP9seR643BGGqpCIEGh6tToqotQ+PwPJnYeCamJjS6C4/H8zZbEkluwky3eQV2rAywnrCA+8Fd7O0x3Q+ORI3BE1ufjOwL6IVBavoNnsz3OPrpSKSIrnxvRwdHnc13+Vu1T9GGspKe9Wmq3a63qJYbUF/CwpPOvxjWIA3WdrqEvWlt1pqnAKYvyxN7qn6rD3QO06U+fAWzxh9IgiLD4GpoU8J7f39MaJisq7kYZG9QLD7qdQAsFgtS9WeNfPWLOi2RdZlNNMVTDK2RkYgf4FQRFdE6cf4jbEbLAR4Ok5jR4tsrnZHUn1Lm6muIurMASmiTTEiGZ+ZJhPLbyd1GRoQi1oSx4nVC6fceUaVadnRUyGkJvqHpMfJE5D0zthTLSumlnfUdAiPRlN0VHZVq2qIpOwJfcVSjmC5rQ+LWnvv34atNO/fg1JzYma3sv0Xe1NjBs0P3/ev4FPp
 SggTi8kJ
 SXzueogFT+KzjCJCe9srXsGAAr0kM9Nt24uyouRXo8wdDPgsSporu+ipC7AhK+B5ZbtaiMZXw92C/cJXlyI28e7OcrdH41uFgkeZADMxapWULaPTL39QdWOqqtsUJR8rhPqtM5bNDRIopnkMGgPxlf21lNHH4piqT+Xxpi9WG/yjDJjhglz8mH454RFiO4ZKosmzCIDWS5jGJTlWcygxKG/XoNjTLa/B/u455Stf3P8S+wrKfOMMD9dRx9Y1eMjnK5uagkwMAB9yTRU12ypoLBaprNJswVk1cC2VyV5h3M6Fu+NIOTlHyVnAOhYPaZoOhNVMBkmAc/ZTSP9bg87K4JEfwcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, thanks a lot for your reply.

On 8/28/2026 8:58 PM, Christoph Lameter (Ampere) wrote:
> On Fri, 28 Aug 2026, Nikita Panov wrote:
>
>> There were several prior submissions with some sort of replication
>> for NUMA systems, including one from our side for the x86_64 platform.
>> In the last couple years, several research articles related to solving
>> locality issues on NUMA machines through replication emerged as well.
>
> Thank you for this work. This aligns with our efforts to increase data
> locality and the performance of local data access. Yang Shi has a patchset
> that introduces similar code to be able to map partial virtual ranges
> differently. His code may be more mature and I think these mechanisms can
> be used in a straightforward way in future iterations of your patchset.
>
> If we combine our efforts then I think we could be rapidly come to a clean
> implementation that can be merged.
>

I will check these patches in detail and leave some comments during the
following week (or to the v3, if it will be published).
At a first glance, code is definitely more mature and can be reused
for the text replication patches.
It would be great if we merged our efforts to produce something clean
and viable.

>
> Please see Yang Shi's patches. We can provide resources to push this
> functionality forward and have seen significant performance improvements
> with earlier approaches like this. There is significant customer demand as
> well.
>
> https://lore.kernel.org/all/0344c559-1959-4531-9265-d5a5180eb7cd@arm.com/
>

For me, it looks like the kernel text and rodata replication could be
adapted on top of the "Optimize this_cpu_*" patch set.
Problems with pgd synchronizations are the same and should be fixed as well.
Since vmalloc code is used for percpu memory allocations, module replication
might be supported, the only thing that should be taken into account -
data locality.
Consider all of this, we can focus on preparing the new patch series, on top of
the Yang Shi's patches and share it. If that path is ok, we will start.

Thanks again for your input.

BR
Nikita Panov

