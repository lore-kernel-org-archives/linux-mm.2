Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF15DF55439
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224326B0088; Tue, 24 Feb 2026 21:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1A96B0089; Tue, 24 Feb 2026 21:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4506B008A; Tue, 24 Feb 2026 21:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC3B46B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:05:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91ADD1B6D1B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:05:11 +0000 (UTC)
X-FDA: 84481336422.16.B204DCA
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72EAC40003
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:05:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sqa0UltQ;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771985109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8GFd9DZ5Mzak01ikJ0Ii/rzl08O/AE6cxsXIoEpx8g=;
	b=KGV9MkyRt7cS5qn5DbwzEchXtBxfV12iMX0z4PC+XaO2HjfalKz5wMtQ/ft6SQdqN+HIE2
	rQaH4aX+4aHH6FKPutaLB4ZFxyjzsreNMAklTJBOv2cNUOSy1aaWmLvBh41n1lGrVjfF+T
	OJujG+eBbLEnxnSr4l1Wz0KPpOtQN/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771985109; a=rsa-sha256;
	cv=none;
	b=ShMXZZl00JlR1n8ILN6PyDZwUQ2Z85PXSzklsfn/N2id5ofmR4aJ9JaCLCQeu0eVp10Nza
	Fa/06Fqs4kAsB/NLQsjVDW0y/8LFD8cwr5oC5Bh/oSPxBURmbC4lZlrWGB7WmfYOjGI1se
	fr5EZaGoYGshVECrXZ/1VNJATE/tfjA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Sqa0UltQ;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771985103; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=i8GFd9DZ5Mzak01ikJ0Ii/rzl08O/AE6cxsXIoEpx8g=;
	b=Sqa0UltQT0jBVbkf1aQCqCI4DIIVMCIhi7zGLS17Pv3hLuhC2vLqXqG0Soydsg33W0ZIWUrZObSAI0XFykNdEoTrzAdGRNTFKdPMQzhnso05J6ddT5pLF4OWfCM3VdNz6klfdjGvgdUn6OjGOavsFrDEOIhihu1KulxYharj3Ww=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzkm-vc_1771985101 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Feb 2026 10:05:02 +0800
Message-ID: <04c429fe-303f-45b9-807f-7f2b745c273a@linux.alibaba.com>
Date: Wed, 25 Feb 2026 10:05:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add a batched helper to clear the young flag for
 large folios
To: Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
 <58e1883fe084d8284dac68dcd570f5a6c56c0abc.camel@surriel.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <58e1883fe084d8284dac68dcd570f5a6c56c0abc.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kf1wcwefuz3wa36czbjgbgia9oajnj56
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 72EAC40003
X-HE-Tag: 1771985108-217938
X-HE-Meta: U2FsdGVkX180wX3gMpGQ2MupxlwT5vcS1GaZPOv4UpCYFxUZ/YE2i4sk0ULZRrkIdh29TsYtnR9rKpctWpwf9THiXIolBVZ0bVa8IyYINHwI/GRRH+DhIFpKigpZ+z8FM1KzKsdKMvzyMK3evcCDbV1JV/ubFsGbQEYC/PrDxCky2h0iRQuFvVaup6cwI1Zqt2ioq6mIudD8aGxZwq6mwaWM+jztK3icJC6Ij6nqZZDtr6YCT4jX8A9Oay3xJujpPg7pLC/Fhy7UWiN+d4NO5RLlz8CCbmFAuHIL/CIbypA2Xzwwke2TPeqJ5GjqmNX9WJv4xP1snmXTD1BTyBoPTutJ5fE+E5bXH5olaElSNnfIRY7xQAQbdgKDdm4HmvpRLIT7BeJOzZgRPsEaKSCGoOZFOCbCht3l0/qDlV7QMawan1aKT01jLpvIPN25CEG3VgsPdCAUBKFlZiX/zWKzn6DGTfdn+iaIriv27wGuwYTkJWNGm9nbPBYiyIm4Mqbet3nZJvnyN7NlHEzfA36g46vaosnthC8zuROsF/5fYEoPl5tIz5+l2It5zidjzOA5dgTFDtqmcu3VFDFbd+/NWPGJhd8Vm+YR8v9TVuTyXY12yccyQ4U4HvF3Glm9rUQHO+yUnJ/ua29Nl6zmEwRcl3snUpm9mDTv6710rsUhcBd+NsQwLfcbEQN6BKbn0ia4/HGrXGFAgpBLG16qHEgjB/Zc9/SX89neP0gsGZRXbU4alU3iKwz/2yQs1xn8sFu7bxjLZ6VGnSgGfAItW7DrTJw3xicbzNpbJGQ4KmabtMD3UQi+1fx+YuctzkDBU0ZEVoFlvbeiuD/eqF31LGno00SK+WHzgIQf9qbvIu6QDSG8H0fCvpx4e2TlO9XAYEJrjL3dUYPF88rYK/3fSRwzuMtHek90tGcjGzAUFIIUlzwrUeqS7qDkxc4IsnCaMiBtGM1gwhFbBkdAuZ+T9vZ
 jl0IO+03
 X1rPN2e6DFOTk4syS4OPj2JonrNjW2fX4uaMKFS0ZssrMOtH43i5da2F5Vs1p/3TumJRZkpN07WbBsc3X0PsyUoaX253M14DFrSa7Pg4cqXV1uhqpJC0B5sKDDN+grobzw6RiFBMeSJEnyX9jM4M6sxgPUWpYrH1oTtMgnrL3vxRZT+4hVKpmBUXYoH/kLX/bU1Zin0/80kXYa5+xqkGjIWIcC6sy+vT584bBBmHXMBxVbGAGDTQ4CGC6n2lu+LAYRRrVtl5OOxBMC661pTOZQhY5mKRWHD6VN4Td1wS5/4hL3TRFRioZkvaZG/ffSjR4seNKR6avegXAjRqk9cY0njhLum+R+XrPooRnF+FILQqcEZn47ColBhDmLx/KJ+8Ny0d473Lq1FRKMyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/25/26 6:03 AM, Rik van Riel wrote:
> On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
>>
>> +static inline int test_and_clear_young_ptes(struct vm_area_struct
>> *vma,
>> +					    unsigned long addr,
>> pte_t *ptep,
>> +					    unsigned int nr)
>> +{
>> +	int young = 0;
>> +
>> +	for (;;) {
>> +		young |= ptep_test_and_clear_young(vma, addr, ptep);
>> +		if (--nr == 0)
>> +			break;
>> +		ptep++;
>> +		addr += PAGE_SIZE;
>> +	}
> 
> This may be a nitpick, but could the --nr thing be
> stuck into the loop conditional?
> 
> Something that looks like an infinite loop just
> seems wrong for something so bounded.

It seems that people have different preferences regarding loop patterns.

The current code keeps this loop pattern consistent with other similar 
functions in the same file, as previously suggested by David [1].

[1] 
https://lore.kernel.org/all/3d5cb9a4-6604-4302-a110-3d8ff91baa56@kernel.org/

