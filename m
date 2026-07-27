Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0BFC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627196B007B; Sun, 26 Jul 2026 23:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D81D6B0088; Sun, 26 Jul 2026 23:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2E86B008A; Sun, 26 Jul 2026 23:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 184276B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:13:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 908761A0618
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:13:18 +0000 (UTC)
X-FDA: 85033085676.17.CEBABC7
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf11.hostedemail.com (Postfix) with ESMTP id EFFC940009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:13:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=IZHEJfIL;
	spf=pass (imf11.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785121996;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJpzWOd2AQ0qcTlQZVOnkgLY7Mxhg/fTu1TETcsiZ1I=;
	b=x5vK5x/GX0hUcW+ddbcNkAZDuj17x2lnQ9kr2uy5PTxFRgmsxR/+sXoJQzjhHfZrE7UqKY
	sxGJvxRPdtBROcRFaoyU8i3ukfkkI3ldumn1HcHHsllyG8B160aK7AMX7qsv4+DLjWV4Go
	Mym2ucHLEeYYLpoEZERjtC4q60DBvD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785121996;
	b=3+qdMlZeuK+sNsb8RR/zSCdmkE0tIJPyafz6irMpTP0i0KGO+INe6ydh0utHUCrv7zcAwh
	F6aTv/bmMuwLduigpmnhJAbS6ZuBUjp4x8rRfHL/flYxUIuUvfOl/y4JUyQhLd2rAgG+nP
	q45CMgrAwnsvdUfD4PeKAFloA9DWm+A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=IZHEJfIL;
	spf=pass (imf11.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.128 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785121918;
	bh=jJpzWOd2AQ0qcTlQZVOnkgLY7Mxhg/fTu1TETcsiZ1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=IZHEJfILfjskUgMmZGNHrmCzLAlhFokY2rkrfaWvb21Z/H0n/c7pIqscwxCpzy3a6
	 JO8GcBhH6AfbOgpd31mvxFhbAnKi3hNNKdyLmd4yUk+BZj56/n0Gan7ycmYywBZwUp
	 dRH+d99+fNPs6vzealCHRWiLv02QWh7yKX3+tUeU=
X-QQ-mid: zesmtpip4t1785121908t349a5306
X-QQ-Originating-IP: eeOVjjpr6h1nN30mzWPlymvg2gXH398TA2mHByZ2jLo=
Received: from [IPV6:240e:659:1b0:640::113:101 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 11:11:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12037815108902466553
EX-QQ-RecipientCnt: 25
Message-ID: <AEAA5D0F00F603DD+457fbbba-bb97-42f8-afbd-3dd9c2dacd6e@uniontech.com>
Date: Mon, 27 Jul 2026 11:11:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] powerpc/xive: remove dead NULL check after
 GFP_NOFAIL allocation
To: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com, jgg@ziepe.ca,
 leon@kernel.org, akpm@linux-foundation.org, namcao@linutronix.de,
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-2-gouhao@uniontech.com>
 <3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org>
Reply-To: 3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org
From: Gou Hao <gouhao@uniontech.com>
In-Reply-To: <3fba3c54-ea4f-449c-8cd3-f24c516bb31d@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MB7yC1M/vX6oBXSm9Gau9AYZU/uaRGPodXeItLGmw4vnDDw6grDD3wcd
	Dic592yBssIChmRrhvhQoynbJ3YU9dClDTGhGp9HwJF19ANkUyjdXpQX/f9+eaNwqosgkZK
	BZNmv8fn6Rh9SC5l+Trpx3KhaLpBpT8k8lE7Jl22nyd2PPXK6j/RnVFjlONZhMFy5vBK6o3
	w9i9VFn8EYuWw/oQlpCamN7pvLXFFYzSzz6zAB22rjqUdl6R1zzMzRZ1NXAgAW53/GsUPuc
	q4KJ/4/GPYsXbRtaC+yiysk6yGXljT01oaYKlGVY1d9AHnZ0hYRnCHKtnHt2svis972YZP4
	ykrhD0aGr7XeatUI3Rvda2NdWglDraejqtykxQnNZjR7eAkZ4DiwF3efscdc6V7b0QRIIhT
	yNyY09RAxWuRtxeMb5Es1W9f51sEWZnSoel2zFYXN5XgnInKxpUeuvFQRAejOxq40nP3MAE
	tlBIdyPS7ZTf3A+gMNS0lBwiTQawNG/AIE38Fj7X9lmeGH1uR34Tg/1WK+vjpj18YrJ5HI7
	gMi16R/gjqFeRsYRlJXrggfxYA3P2oN+DREogyk5uRguY8a93fuSAZxQsqizqW6AIS8A3YX
	c0hMpHelJa2676kzC6kOlwtmg0fswI1S28gFFJ09J2jg4iOJ/QtfSWewuCFivl+CSXDaMZ8
	PX4b6uEO8DAeIbmDxnGBvRcYEmAMb7NQ88L/Z/RrAcEFt6b5p5u7rnhevFoAOC+Sf8GEJLr
	v12zPoUufaEjMM+kPa00YAqK7HDNc/fq+0Zz7lQ9YzTVqs9DKyZOZzYjbZPYV/8lPorLoL4
	OAAt2syPmvwl9HkdHdQKNwLBRSlhFP+/rYMopE1mITfHpLjWzvnSR1kcQIV4cRJNxBsQu8l
	RAKeJAJJLjDjYfS9+NgtR5ALIHzZW2/ckN36o2MMTCNoxtV7sPv3Y+oODItLL4zUEVaT/mb
	TPz9RZDZpVT6/GqqHcBL/fVTPjmnO/sqJbD7289Jh16SWFP3rLRzdx75ZE/YcE0h26HyLeT
	MQaBIKguirwsXiilu9cgx/XklKZkl6zzZ6tqLaag154FnQFxplKx37k251GRxvY/OHQY297
	DdmJ8/AUxza
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EFFC940009
X-Stat-Signature: jnnm8ksh7fytc7xy4uzdydqdo7gkggr8
X-Rspam-User: 
X-HE-Tag: 1785121994-478939
X-HE-Meta: U2FsdGVkX19B02KOuevF921aNgHYmH/QJpQOcKEGatTcABmYgl9jGlLwxnY49sPZApOoJdj19Aio4D28MX67WrD8d+fjCqRNIjHQOMxi6k2VGWHfX7lwfT7g/OChXjqci1LSrKgsEZw5uRudSKD38wdrNlE/Bu/ZNLwvehfQzm+pkfbU52UMtxkkrMsXSZaAEDVAgYgXSZiXUpP1cdvlEYpORTY62V2OhFyVPuWmGjE1yIBxMZn+K6CS7BM2tBJT46s0ZJKg/yGOgRKUgEIzSjc5zmqh70CRwnxLtl+wNl3UqDEAw3+BeokLLjLYWmdHYAVbuUKF21GPeWoBbsDB3h5GCzzJqattfrpwKjuRHrc9rmphksDtRsSoopcU/s1pk9QhVeCj3xVEN1rBdDx6DmhRXc8kcNca0zk7+8tmlBJ8HGm+9Lk0/Q5pB88z9588i83Xj/i+rujcO1LdZtBW7EeDABW4f/ok+kqkcI6V4v9mFivXvUxiXCKqW9dMqD7Toqguj30X/XoQhdDL0Kwqi3ECoXy9/YNVJBFQfkTua6WU9X+IFVuZzxQpxc/MWdgTBQXm4jJVlXObYQaOK1rPR5nyIuA99VlQw5YTnmG80poOj3Zz90WJzlt7MNfmOZ6pOVkMhfUxcYaXjTgXU2UCatDwQ/ZpMAJuOWqLb+UN/reqC2MhQM8PiBgnWexO85bJNB0palHvk1VXQAOdOfhj/HWLZ6L2W2hLsBs4bh7ba2bDvVvnWZnkJrikYUHtrMVllMNf5wrDXdFy7T7YacxZmhW+6YYGv9N20t4/0P5CK5bT9nLJ/pMnSeVMB4dAhQsu0JZVoqZlWRYA96JjHALLMpo1f5eKVMhfyEJK2GlYE0qu+UoAovyyoKqybVlufCS5J8u/IM0cLJu3ZJVSIvQIuQYk9fPIfzbbNSc1Z5Rf+HjH9X2MFIb/YFG2ca9X3AmxBEsPIcW6zNjqO/tOEKK
 RjGBee0J
 1bZYGpFps4TqgXVWiWs5EL4hQm6WW9CBva/IEK0B6butSKH3NoUCl7rDsWT2zcLumhfI27k17eMTsSsDBt2LkwcuEHAh2im12VjypY/e3ZEzI3PbFYZjf7+uYmX2QVYyJFOwbu7Iinwq5w//WKmEnVBNl/1N0ynTV0s5lT57raQncw1P2e12wBWiWCQotGnzgsCp7eTRhCgCOUYhI1i2XKnQ8QbQfh4yOg0uGlE+qL9iWXRpM/eaUd2olxeF6w2CdhQFEFqOVSaPF5HAOqzPdbJDHUjh9rO+0wtuXQDYzFs8bomx1S6Zfi/Rk04pYS2Gw3GdIbuIq9IfZSqSfBhGj9/O4QSVQIjnI4HSidtHHFX+YW8nYaTvwuzyZ65HRawUFbrJF+S1wtarRpyN53BQ3SIHNx801frS13/+gSJPcoddo60gG2ko6/3Z0T7SCcXMhPbcpYc1cTZ40ufNbvuQvsvlxETXNWOsAFG1eqT45RxbMPbqPznG0VREwJl4rEqIqozwjCZ15sU4R5AdHybytAJiYdBa/02Ni0dGIazMebn3ruF28VYfia50uvHZaP63Jo+Lf4UoOm0sSepCh57776HwtAwXZS1JjuN7HbemLbW6fGY01kk1lf8DCkpasKNBGWvnlg+VgkD0xcE3sJ5lUUM7m7i2u6sBhy7q4eQJZbDR/FpJC9CZAQHI80RPkVQ5XX6BiVVmcZ9uAMiWNgWb9Hg//Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 01:04, Cédric Le Goater wrote:
> As suggested by Andrew, let's change the approach and remove entirely
> __GFP_NOFAIL instead and make all xive_ipis access paths NULL-safe.

Yes, that's better.

> On 7/24/26 04:28, Gou Hao wrote:
>> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
>> subsequent NULL check is unreachable dead code. Remove it.
>>
>> Signed-off-by: Gou Hao <gouhao@uniontech.com>
>> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
>> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
>> ---
>>   arch/powerpc/sysdev/xive/common.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/ 
>> xive/common.c
>> index dadd1f46ec939..f2904a5c2b7bf 100644
>> --- a/arch/powerpc/sysdev/xive/common.c
>> +++ b/arch/powerpc/sysdev/xive/common.c
>> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>>       xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>>                    GFP_KERNEL | __GFP_NOFAIL);
> 
> So let's remove __GFP_NOFAIL here.
> 
>> -    if (!xive_ipis)
>> -        goto out_free_domain;
>> -
> 
> Let's keep it now that allocation can really fail.
> 
>>       for_each_node(node) {>           struct xive_ipi_desc *xid = 
>> &xive_ipis[node];
>>           struct xive_ipi_alloc_info info = { node };
>> @@ -1158,7 +1155,7 @@ static int __init xive_init_ipis(void)
>>   out_free_xive_ipis:
>>       kfree(xive_ipis);
>> -out_free_domain:
> 
> and keep the out_free_domain label
> 
>> +    xive_ipis = NULL;
> 
> and yes we should add 'xive_ipis = NULL;'
> 
>>       irq_domain_remove(ipi_domain);
>>   out_free_fwnode:
>>       irq_domain_free_fwnode(fwnode);
> 
> 
> The prepare_cpu() path is broken. To fix, we need to check xive_ipis
> is not NULL in xive_setup_cpu_ipi() and xive_cleanup_cpu_ipi(). It
> should be a straight forward local change. Nothing complex.
> 
> You can test with QEMU. The pSeries and the PowerNV machines are well
> supported under emulation. Ping me if you need help.
> 
Thank you for the review. I will fix these issues in the next version of 
the patch, and test locally.

-- 
Thanks,
Gou Hao


