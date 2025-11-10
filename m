Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9689CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1339E8E001C; Mon, 10 Nov 2025 09:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BC788E000D; Mon, 10 Nov 2025 09:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E508E001C; Mon, 10 Nov 2025 09:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1C798E000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:39:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 561FC12AE63
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:39:43 +0000 (UTC)
X-FDA: 84094956246.08.9F9496C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3C96FC0012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:39:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="fq/6bZr3";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762785581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52h3btDgfApCo4cTARjbeD/+n7ncTe762Z+6oMGl+44=;
	b=IHJgpa76CUOuGYPoLsFQkdyS7EfODWPGs1vsTyPJoFuNJY54Z4m6ODE/gqjMvGHU+nAw8U
	BJpBwS6rbX3g4LRueDGCYZRW408oPtXPbXmid3JtUHxiRYny3CysRPPO4hL7GPx3IcYgk0
	3TtBJQDRF1dqkbXzNRbIVv6+S3EDTNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762785581; a=rsa-sha256;
	cv=none;
	b=FjFVXbZOaUFXPzF+Fj5Kyd/ms0Xf8Wq5/Balz9zPSrgMQm1CwxjlfjoQrbnMY4722wVQy6
	w6fcxGBykjd2Yv2d/DJuebehTpykTJjIBq5r09qWrV4CgaWMLUWDkX3OL/452/Ajt0Jqzx
	NZTKD5tQGHVSW+z129lWNCAjxd00MpI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="fq/6bZr3";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762785579;
	bh=PmfHj5puT5EuJo5jMH3r8sbaCa9NbA7iIIBw3q5tS7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fq/6bZr3AF2h2wkMNGSn1bXsocPuQEeBd+ezF2avzPXvHo/lvHsrcNC+tZbS8E5Iq
	 xkJB4+am2a5IfxqIp+ehb9NPVKFSgvleVHdn4CivlgZRwnuPF9SnL8ajyR0NknfvP2
	 s7xp9Kqk+2jipyZbRtQfHx9eyAwAhm/ABmTkeAkIjdOiTtc2+8qqtYFcn7QauIky0J
	 qi2AkZfthvSdYWmtrRTHuQs5oTa836l4Rwoz4pKgCE7iGHMIdDFb3F2YXgGACOPt1d
	 jxQdyUfGkeW7/htZh8Ig5e8reM+6vEQVZbJRkW4WM4vf5Ct5o9PibWgvFUQrFyq3hO
	 0R67ZlTin9JNA==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 17CAE17E0610;
	Mon, 10 Nov 2025 15:39:38 +0100 (CET)
Message-ID: <e19cdd3a-0d33-4c06-9c9a-7e9e2df51c4b@collabora.com>
Date: Mon, 10 Nov 2025 15:39:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] drm/shmem-helper: Map huge pages in fault
 handlers
To: Matthew Wilcox <willy@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Bagas Sanjaya
 <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-4-loic.molinari@collabora.com>
 <aO_ZmA6yoqbzTKt9@casper.infradead.org>
 <f564735b-7cbd-486c-9dd4-a4555e73edde@collabora.com>
 <aPK4YwMmYTDsKHcL@casper.infradead.org>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <aPK4YwMmYTDsKHcL@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yssnqmo8sh6ximdhh65bey5rxa3sogk7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C96FC0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1762785580-146729
X-HE-Meta: U2FsdGVkX1+eBBm/nQt00F0voxRmo1HidYe19g0OiIh40XFxjIdAWCJG4qFqHfUT7diQCexNCKHvR9hPjUHgQocnPMLasRCpUSpTe7wDWfSE1zemX55qyf8lSORHtJSpbr2KeU9odjBCMTY6m1OONSeYW/WONSOAkBzq9Xcmp5MhhUFp0WeRXKMuXF6HFxqLP1Epr+SLwQ7v8FjKs4Wc8AuoqsJkUz6JAt70P0VtBUc8wCzPww61nBLmHXbDHxZNObvAAtYzBfd570Wm0qnY6i83SKHrl0xDh0zNq5OSgtHFU6VkpKyCu9z5Ca7eQATBP4KPjeoNm4NVQPZA18u4QYNHuVMat6ATvhVQbApkO/9WHrWyTCJ3j/MEZYiXxTP4ib831wB9RD0RYzh5qAKgmApkCHqhCjLReqx2WgHjL6XZ8GY88Sb/S5nD+HfmIa5C7zw/zSYQiVg9qty4V381V1gdVdXyzbsnaMVeg2b9bckn3O8meK+VkFQCdNoxi9szsjMtanJBGPHRSi0/AdNXGXsM57McAvKaC4gKnWEeL7V3QOfNAG0waC3bOir8MP5+ua9OLb3MLZFX3xg9cw28io1UOv+n8gNmlVQRkPzaOq4Kt2OhJGcM4URDwLksrA+Y30E8jn/IO+CwH3iMw40EPguKfO/zS3pYRfaVT68E7pTyeg9+p9Bnv18rl86tfdLa5sqpR6JiNcu5QgrGHCHOaWG2/kTxMvlOUniD9+ccEidwDWJ5EFQUK/6FfeyEJjzLEX+SJgq8+NCnq9TQhoLFb1lThooyblHPKRV7YwOecUhlZMUy2/NTnUdaaz7WAxO20kvmH6hTokKb2Xy7Ek6yOe+OYKxYay3BRMFQ1ol7VM5CwEGuP5WlY+kenNiqd+CCCExNodwh2TXxn0MLJ9sYhxTwCArX1raJH/ip2xdWXNR9HGedq7waXAVyToruSUaNfOboyrxB/+eBfPRED06
 oocxB5PD
 7BY+1nubgICzyGFZo7WqDdlvt0ESkmO/6lcmPRBgh71kBRy0U0As+8OElRnjhws0eWfWGBALOB79qxb/IjoRRfgF75s80TirqNTif+FOX2BX4GELYeCKfyYGp17daXucIsYrFLHo6IhDOJS8V6hKAKbzEod7hkhHYv3wS8/usbF0NBf0tSuAI1i+nMx0+tOYWzInRS5U+FanVRneAuBoxgeHOESoi5hzGFMiKFPd37875Ekbm0bzNMOmNZ33v+3QQB0U2MJa2+nOfl8jFRXQuajzPU0cY6axCjl9FvxuOw9AGPvA+yvjlLgzDmEU1mK8EBOkNwI6lyQXFmwW8yF02Y5O4lS9zzjqsvJVuSKHKQV+pW3k8uF91JlBIqhMKQK86WzUJrFQySuHUVayfzGYx4gFn7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

On 17/10/2025 23:42, Matthew Wilcox wrote:
> On Thu, Oct 16, 2025 at 01:17:07PM +0200, Loïc Molinari wrote:
>>> It looks to me like we have an opportunity to do better here by
>>> adding a vmf_insert_pfns() interface.  I don't think we should delay
>>> your patch series to add it, but let's not forget to do that; it can
>>> have very good performnce effects on ARM to use contptes.
>>
>> Agreed. I initially wanted to provide such an interface based on set_ptes()
>> to benefit from arm64 contptes but thought it'd better be a distinct patch
>> series.
> 
> Agreed.
> 
>>>
>>>> @@ -617,8 +645,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>>> [...]
>>>> -		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
>>>> +	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
>>>> +		ret = VM_FAULT_NOPAGE;
>>>> +		goto out;
>>>>    	}
>>>
>>> Does this actually work?
>>
>> Yes, it does. Huge pages are successfully mapped from both map_pages and
>> fault handlers. Anything wrong with it?
> 
> No, I just wasn't sure that this would work correctly.
> 
>> There seems to be an another issue thought. There are failures [1], all
>> looking like that one [2]. I think it's because map_pages is called with the
>> RCU read lock taken and the DRM GEM map_pages handler must lock the GEM
>> object before accessing pages with dma_resv_lock(). The locking doc says:
>> "If it's not possible to reach a page without blocking, filesystem should
>> skip it.". Unlocking the RCU read lock in the handler seems wrong and doing
>> without a map_pages implementation would be unfortunate. What would you
>> recommend here?
> 
> I'm not familiar with GEM locking, so let me describe briefly how
> pagecache locking works.
> 
> Calling mmap bumps the refcount on the inode.  That keeps the inode
> around while the page fault handler runs.  For each folio, we
> get a refcount on it, then we trylock it.  Then we map each page in the
> folio.
> 
> So maybe you can trylock the GEM object?  It isn't clear to me whether
> you want finer grained locking than that.  If the trylock fails, no big
> deal, you just fall through to the fault path (with the slightly more
> heavy-weight locking that allows you to sleep).

I proposed a series v5 using dma_resv_trylock(). This actually fails 
later because the vmf_insert_pfn*() functions end up locking too. Not 
sure how to fix that yet so I proposed a v6 with no fault-around path 
and will get back to it (along with contptes) later.

Loïc


