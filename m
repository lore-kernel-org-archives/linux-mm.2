Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5689BD116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15536B0089; Mon,  1 Dec 2025 13:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC4C6B008A; Mon,  1 Dec 2025 13:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28B36B0096; Mon,  1 Dec 2025 13:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9390F6B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:06:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 309C7B87F4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:06:18 +0000 (UTC)
X-FDA: 84171681636.26.7C46D66
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 053C4120012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:06:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f4PUV0hS;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764612376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZkWTp/EDJ/VeIcerw9yapHoMI8jZHDWqXRh7vFqMLc=;
	b=RRQUGtugbhfcNgDvKvjJ47DMeFSQsgUe4vlIOATeE4uX0XOvtawo/q7pNX2VxiZYlWnGe6
	jbfYllgarzHOgFx1PuOjaC5+zK5SGP0rufS+MMBfoWAe9YF7jcm8Nhz2rjxywkkauNcgxx
	e5YUA/wonmbIjQom30q2/0tmjEMzmsI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f4PUV0hS;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764612376; a=rsa-sha256;
	cv=none;
	b=7uqTRAfEmxsc429DhgqrgNIsGcEZUqlSBlMN6hjQu4DeEspuKzuEU9cLzYExbVD4h020PC
	INACrQgLQ6TLJEQkMZDBu6nGY+EXKmr70TP7qyoOL2vlHuDyj+GuyM+4Efg93Xj6VhZW+R
	ntxbb8Fq9idVUnIFtu//pD7KYGYz5wY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764612372;
	bh=orbc3nuJhRBtP9HgFH/P7FPSU37dWjp236YX9cJ7qE8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f4PUV0hSvnZmXOb2ZWccPOP5NEDYIGqGFgBkNrbZyFaHM7AR8XkGmUCu6OnkAodFA
	 lj5NCIdmHu1VugxhaE8lMbzPaT6HbXdt5WZnd5bt3N42gHcTYxhDWAzN9HVwBIwjOs
	 wdh52nnjvww3IORZATNTc/QuBF4ZPRL+RPQm7US6QnUUen3lLtN6Dv1IYOTdi4dcWS
	 AiGsuJvFHisXkpA/o+9Kz0ReKG5F2tmIUDUJW25d4tnP+kt56w/AIqTphtfRva/KiA
	 u6FWll/izQjWEpNlUNWFGTrJo9QZHfBgL6O4c1OlNQ0vK4YGvQYfqiR60p6q1ijFoC
	 QluNngkMsJeTA==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DD47317E1157;
	Mon,  1 Dec 2025 19:06:11 +0100 (CET)
Message-ID: <e2102c82-6b8f-4f6e-80ea-ee185bb1e52e@collabora.com>
Date: Mon, 1 Dec 2025 19:06:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 01/10] drm/shmem-helper: Simplify page offset
 calculation in fault handler
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251128185252.3092-1-loic.molinari@collabora.com>
 <20251128185252.3092-2-loic.molinari@collabora.com>
 <20251201090507.1ee10c65@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251201090507.1ee10c65@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 053C4120012
X-Stat-Signature: a3ktmykqruk6fm5zaoz7ic5dj18ajbpn
X-Rspam-User: 
X-HE-Tag: 1764612375-63375
X-HE-Meta: U2FsdGVkX1/8mexKiz6nSodeX4d1aSlY/M/r4YK5m8/2IpUcOi4WljPXz+FhUpimHPiU7c9pSTysiiLkzlPob047CvdJ0fZ07MNOF8VsuDDYnat+DkT3FV7+MbhbRZW4EntxttPKrJBmnxhkp59zWEUYfCKbKUGiDMWKpBQbuFmFe3946+voKkglVavKGPJJCskC+/6MERZTWUV8KHNHPJtphlTb0ZgzFo8mYR0BpBvONJc+A1pJLJqLylcghQl7AvTcNkURoId36kBw/ViSTWN7mCDTq2jC7CxKxoHVsxyPnUl7CutPeiQXuYxPRPAxZzcEq1/mujqokyqV/Fu9hrEbK2YgHAkKMLPFIa8Z8jYdarQ9mapqOfQ/oykCWGvcTIgoFtcjyOV+jRk+TRgz22G5WE9K+GRkkY8WtC4vYL+oKpixMh6PPGL/fToQtLejIFO+SloA6dPJy6vINrMP+fOIIxxxSaVhyNNd+ORhKkmbHlNpmnOSFM4VJWL5OXTjNgI1TbMnZ7Qbxbc0KDDZzQTu7zyX0wPFiOf8a1yQUU9jK2etpjGf/F3kAZAW5AMepkW3SakEcX2N2NLGtSnPEKppe2c+9mj0JToTN0rc67bUySvsfRyuym8maDDP7fQRQDa1LZytTwLVTom0ByN568QmwUzsOKb/7xZ6u7lgzxnwzeetsLUxy7w5RC0SyVu5obNVXZCtI/1BMhdGuDWzMfVaH8R3IM1yjVKXKfNivZrnNa9mryWGAwgY3QcXH+ODxwj/v7BSadEbnwj++Kcj8QiDZ0YSBtneWU1pp/SlOIYyIZrsj+bu7vOcRgxamkWOC1J5HPkOMuKK1X+ZRJq3hwZUNQgk/PpiWnGAjTWc6nI6vaw2nIyUoXRYptOgn+TnUb5dQ9uqgJgZtvoAkS4wM3vJ/cQX61ijsNWfHbE3+VewdA63gCIILGxobp5F2TaMep9PirmHvOGjZV9mHmv
 rEyA++9J
 1wN8Ygfm2p7fLSJ9pS/2p06aL4w3oURbF/jrFUQu92oUnxNRm2yFdgjRR470a+cmKxfP0HkDPGTLWrInPnodefxNyKcJruIAkMaEzghMX9zFd9jPasVnhgPPzOvn4pXl7rBG5QGqtE9zq4EFX8I74dDaJTwvXR+pCFpkLWGvtQ7lcQgrlYDhLB7vFPT6pgjbwjiFgnr+K2kh0lem1pr9Ao3n8L76VF0eD+aZowO3qX/saBr8D/9ID6KIcfLQ9UvdjpW+c5n+dOweuJPt6mHUrqlTFW3XyqRb5ueRZf/Iktig9InZUxJzjcAC9Q2L1BNs7qwPMUOyh7LPf/T0kXVjZmiT29hFqSAArZMtAmb+6XZ6W5ZP3wyEqD+wP6m5QiRgMtTJWfgcT6lCEhwZgJg8+vCrfYRYmuTUoT+x6Cj/rudVNXDYzphW1FCOEbYPjaydth5/rGwO/hVXintyoSV68YgudBaBWET1CDZSH/Lx7Urp4BRlEZlX/dAFYJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

On 01/12/2025 09:05, Boris Brezillon wrote:
> On Fri, 28 Nov 2025 19:52:43 +0100
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> For a fault at address addr, the page offset is
>>    page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT
>>                = ((addr & PAGE_MASK) - vma->vm_start) >> PAGE_SHIFT
>> 	      = (addr - vma->vm_start) >> PAGE_SHIFT
>>
>> Since the faulty logical page offset based on VMA is
>>    vmf->pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)
>>
>> We can slightly simplify the calculation using
>>    page_offset = vmf->pgoff - vma->vm_pgoff
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> 
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> 
> One nit below
> 
>> ---
>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> index dc94a27710e5..be89be1c804c 100644
>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>> @@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>   	struct page *page;
>>   	pgoff_t page_offset;
>>   
>> -	/* We don't use vmf->pgoff since that has the fake offset */
>> -	page_offset = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
>> +	/* Offset to faulty address in the VMA (without the fake offset). */
> 
> It's weird to say "without the fake offset" here, because IIUC, both
> vmf->pgoff and vma->vm_pgoff contain the fake offset. And that's fine,
> the problem really is when one of the subtraction operand is not
> relative to the fake offset.

Yes, both values contain the fake offset. vma->vm_pgoff is the actual 
fake offset (mmap offset in the GEM context). vmf->pgoff is the fake 
offset added to the offset we're looking for (offset from start of VMA 
to faulty address). So the difference just gets rid of it, hence the 
precision, but now that I read it again after a few weeks, it's a bit 
misleading so I'll just remove it.

Regards,
Loïc

>> +	page_offset = vmf->pgoff - vma->vm_pgoff;
>>   
>>   	dma_resv_lock(shmem->base.resv, NULL);
>>   
> 


