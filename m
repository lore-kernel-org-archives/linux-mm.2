Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12B2CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A1C6B0096; Thu, 11 Jun 2026 07:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0AE76B0098; Thu, 11 Jun 2026 07:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20F66B0099; Thu, 11 Jun 2026 07:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACDDF6B0096
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:47:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B7EC16546D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:47:05 +0000 (UTC)
X-FDA: 84867455610.18.308A3DB
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3677E40017
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:47:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x5DTgfgw;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkCGrWKzCfTn3xVMps93ytdggiT1d+I4EJDhk4sAvA4=;
	b=mWQnkFNxTuG/455KKmzBHoRzhhk+KPUTKLstzCpQctvLR4chmRWibKvDVt75eD6gg+TEY8
	DeWF6hZec/uNuylo1J3/95ld71TGePg3z4ntlVHs9zrJ33preHketZwtNGhxu3b6irLR9o
	tMTlSRMQg1M91XmLt9htAAw6GDTQsto=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x5DTgfgw;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178423;
	b=Ccx196AGI25eDKpwpfPBTzkIv8xu06LNb38EnoFc9lL/uXq0A65c0VFnVvd4avKdUmWmFd
	VZYqi4tYXCzK3BJAf4/N8CQ1eEvyC5uBaOiQbxz1pDl7EoTwUoGya0bmlTTgDnoAVa5qcs
	xQ0sX27FgXNr7s6PkqL3IM6PQy9pj6Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781178418; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SkCGrWKzCfTn3xVMps93ytdggiT1d+I4EJDhk4sAvA4=;
	b=x5DTgfgwOVeAIdghOG/38uy2UNGYsogTVhz0s+zkWp4nQHEj45zNprchhbXrTACHZ54+i/0jqWKB2TYPLsJiPyapo3BUqGVp+N4MovinhwJ3RUE/SgkSGODZqewlYK5zdvaA2xr6W/8GHAqRz9L0WFg/2ioRjUxCrtug0aI7eb0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4dY2QC_1781178416;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4dY2QC_1781178416 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 19:46:57 +0800
Message-ID: <47f472ac-0b07-4ffa-a3d4-04fba621252f@linux.alibaba.com>
Date: Thu, 11 Jun 2026 19:46:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/11] add shmem mTHP collapse support
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com,
 willy@infradead.org, ziy@nvidia.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <aipSe9Snx5x0esQx@lucifer>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aipSe9Snx5x0esQx@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3677E40017
X-Stat-Signature: zb9rwpe5rip9pgym5o1pd5ha9ox3ggpa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781178421-198722
X-HE-Meta: U2FsdGVkX1918KH5gQuHE1ThMdNZmOntuA415iwzOc7QkU/HWwn45hkgIMqzrgHs7huQqX+PUBS1vkiJ/nd3K6Q6yMBpX13aTJHkGJjwdFI1KgqdTyVC0jUJsx0LoMCWtrgZh5CKTkJAssCmpnMm53cOvLQzEWkNS6S3CjQ0Grcy4J708/I5Dmueb6Atq7j/cVYiJxxouiuvDN0f5HSQ8l3ksTfJERPlLtl8aBOLLeB/ijTkarxMakKfpFwfoj/9jtTcfTb/rm6ak1cmRXsu4OyDi9g+VUUqIC+fpq2LFCiZQJmAxPieMpcDFfJ68gFww5u7xzaMsR40rrovl78fslCY9AHJQawux3eXdk7Z79aNLdcq7MojL4/RbEcHbRIZrISY21Z+NaiTDzfZ2fCsgKullIYCeZQYOj+Js+Im0i/SW6p7DfdxPOGJTUWXo1Ci7TbLvNLdqYJcexEf+GZj/7rvS1xMtvm0alIbqyFu4e6dcUlVHmvqU7QNhB8eJfEi2/nrDXwVthLC1C092cZY+De5Ps/bvsoGEgnEyWjIxAnJ/FVMwL4eheQT/Sfx4XgmFbDotazepKoK92QPWLenTIdXrcDLNCpYB4E47r8bhrWQf5WmshVXyxGVm9HCdKFm6BRp0PKocC47piG9OPZIpmGfihoq4pN0wsgD8jdBBMfI7lvTx9M5O1HVgXXuuOG1do1iHMUixeWMcacTADyApRL2dIaMRPvwdPJ2lH499u9xCB6H3ciqxfe8SuFsddOETnxUl+56vqIRVw+fCh0A5J+esU3oz+3nNGiHJa4fUrgLXrlxqxaXD9fPUzz76rH1p6Uymh349KFYlrKCBN/S9QMAcsr1FNGjGCvy6aL7zKlui0a11ZE69s1NxLP4xccwqWNZ18t4lY/F1kGzln8Q90DWu1jgaq3fdnyOstU5RpPD0sfol4dxkE1uGrGCALy9DHhLz8Sh7voAbT65KDB
 XLlC71hH
 pNoMOTM8y5jmwnhX6NYwv1/AsBE1NjE0m5atAsQEjIQl1s42eWLsMdV9s1JHtoKU81QbDy6735UAEpOJfMqDpAUPQAklYAWR0ClSI82lUgPxL2SPC0391+mdgy3n6arGMYjuQcPrKPlMsxXQIg7vhFcyNP+pP9khEKfWKO8jZayYiuPwZ9bQInRL6n4Gk09ZBtd4dcC4E66BjqQ9bb1rKmVhCUljESPKuzdORkqRXcVUIyYrmnLerOglJKQ1p/p9B+0lR6hEFwE5wojvfR1iFsrGh1zC0YqFOKDr0vVXEt8wYPE+kwkuhDBn/bK55VPjzYlySZgbNMmmXy1Kd1X0heAP8jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On 6/11/26 2:18 PM, Lorenzo Stoakes wrote:
> On Wed, Jun 10, 2026 at 06:29:08PM +0800, Baolin Wang wrote:
>> (Note: this patchset is not targeting v7.2, but posted for early feedback.)
> 
> Hi Baolin,
> 
> Speaking broadly, and to repeat what I said to Nico - I'd like to
> re-emphasise my _strong_ desire for us to pay down technical debt in THP
> code before adding any further major features.
> 
> Really I'd have liked to see us do this _before_ khugepaged mTHP, but I
> didn't want to put Nico through more than he already endured with that
> series :)
> 
> So I'd really like to see some action on that before we embark on any
> further significant changes.
> 
> This is no comment on your changes, just something that we really need to
> address in THP generally.
> 
> Will try to give some detailed commentary on the actual changes when I have
> time also :)

I fully understand the current state of THP maintenance, which is why 
this is an RFC. I’m not expecting it to be merged into mainline quickly 
(but thanks to Lance for the comments).

Also, as Nico noted, it might be worth reviewing the mTHP collapse 
selftests in this series firstly? as they can help validate the 
anonymous mTHP collapse path for future changes.

