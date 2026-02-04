Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3676EA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56D96B0098; Wed,  4 Feb 2026 15:00:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34566B0099; Wed,  4 Feb 2026 15:00:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57576B009B; Wed,  4 Feb 2026 15:00:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C33B36B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:00:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87F2516025C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:00:45 +0000 (UTC)
X-FDA: 84407842050.03.FB3275F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BA04180005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:00:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V77fOIPp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770235243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rx6NnBLa/5uRY3jYHFXV11DdFd23EdNAxbFo+sSPJp8=;
	b=7Y5shjc9NFV2IVHnKVPNmhaa4vI8ehWIAZ8ak4FHbr+znLiRAwdbHljBYY6dKDufClIExg
	7tZR9YAEZfFz93D5QNnohYqtgYr98ytA+Y8KQeXzpOq+l9qypW+hBAgqOEWEE83kR+vBEl
	75u5d71WbyzzwaiNF3VfP0HGykAVlb0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V77fOIPp;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770235243; a=rsa-sha256;
	cv=none;
	b=ys6OlO5wzTxsDyOm5WH66iUwA7ErZ5TaP6A8yW2GEbCTRH0pYim4DUQAUT/eTjytISKa9J
	XkNDBqrt2YOTCrk3l9mECYXtkektJg3x2uPcceU4T1xf/CE9K4am9zuE1DWSG1Ry/WW+UA
	3pEzyva5wheXVHroCYlYDY6/2zfnres=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1011C600AA;
	Wed,  4 Feb 2026 20:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F50C19425;
	Wed,  4 Feb 2026 20:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770235242;
	bh=tHNm7+iDyHbPJd/eg2zZb8QElfqohJCKbz7sI/dd45I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V77fOIPptAyQ15AIB6hddQUX35UU6lB+X9NmVYhTfGqbST5e98ns0VfCWf3teSk2s
	 sCPl+WWN7yZM2PNVFqrKoLKEX7gKsJayNqxVfTL9PG6pQDbMrqXTj03zwaNKVxrw/I
	 LA/CyDJX37UEq28N0fgczFbxyBYJuAuEQPEQ8loyDALzU/ee6xKdqFtSx4O1k8mUoS
	 9CHGXDF/eSYEAx6C3sjPLncGTKA+wdGAcOLDVZ20aqHV8VUkU+6S8jSMD6SAMYLiWt
	 KxXMge7ysaT5dPMaTMlGGCt4NbL4wUgq8bp/76g0pTyfvKCvLhaMk5QlKn0U6GJ81w
	 fRVYH4psjhuhQ==
Message-ID: <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
Date: Wed, 4 Feb 2026 21:00:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260203174946.1198053-2-prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wwz5wfxd1mzmdai49frazrdscooqp1bd
X-Rspamd-Queue-Id: BA04180005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770235243-571320
X-HE-Meta: U2FsdGVkX1//+Te0nv2ui+ZW5O8g5TuBwn8hlN1G7X+bIdq05y4ptIhbq3u3fZEf+mI8Vf+zDgT8grAjZUALlGXlO6vEVWfTtVFh3O68x3fvuAJaO8R7SzPjiE/x00TiPP29c/uLquHtrwbyRLPisfMZwxd9R3avvWsJoM3u6n7RkV97nnaXx0GCrpefWua2UPx6ko8mX7ZSW2vOGDiNqGWoSGjnMCVMNKBYjUPIPQm19vVd4lu4QnaHl3SDP3rw1xcxVrPqJUXhcZbWeBhZsyXqT7AAfouTtrK37FmKz9ELMpbdRpQmXYdJ/mD3dvp9U0xLbnA7jJ3ApJKEhCNXfuqGSOExtTWvxADxWkat7/dlfzdmhJwcDKDd5jiTcGfl62Yu6CNZQhj/f8qgfI64m1XVt9FGnSHD63BWnjIKGFsShyp2eOmjm32pBbKWSU3xJb6rhOD90YlCKACUbWXBPWulDYVy4qw7kPKNfZeehEUQJymQxkM7NipYzc01RMo7hxJ6DGLvuCzPKmrGcK29i4GUERUL9rzAJlAjoXPH2ARKyYOVqRqjVN0GaVjsQozkNpHQG/H9hBLfMhIAMNfxC8MByTqANum/j/4dVk6p5vmJJvdfXF3vdNHaC07/h85oYWWjeuLzWW9PTo4VImwyL82oYNYMPbgIfbg5W+BwOKhQld7pDxywairQrmJU5zqYXYKHbt8lKeNEYy2vKk6kYeWON1uzs7H+2elSHn69pjlsXztJcLr4cBuxM2uKAosZQ6m/M1q5x6P3kG7BL1h2SKOtSjxXRRvw8iDf+ytgvtW8WMEkR4ncRzTA57gkGoLUEbkAq8SP4MtQkhkFLQ41CbHLtJBonW/zcFxprh8zNI6VS1hHeVsxQvzyXDWslc9Na2QSxrbgwAn7ukRu9l9ute+dHI5S5NficyKyKD7r2KlxJgtpHzUg+2ihf4Aty7QynwRzecWELEMzcTmHh2y
 VCvbVRAv
 7vYbA+2IFFhntB1mCKSFveX6FfSkUG9Fe0vajfYdeUjWJlKkhTBVmek3ptj33CGSaOTnxTKvcYg9vE9L6FGhSYnde9HDqkeTbJpL4Ce0jA0WVegd4SYVUb5La/WRSr/b5p39JHlWd86XGxgh0Biwv3D/jOcmCdTIyPZnJgKRZgT+OhYmijSOydCxyTGygYReuuU8oT/GTiRwIKtIJt3C8QrsH1apv2mJxse2uEP1O3YNS5knu17IR9K5k2tgzWEDQAjYxjVNBOyYBUGB4gHzPYTJ1YL2tWrmJCdUKmsotGqXU9s9EjibhP9Omjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   #endif
>   
>   static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..549ccfd190ee 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   	if (!strcmp(res->name, "System RAM"))
>   		firmware_map_add_hotplug(start, start + size, "System RAM");
>   
> +	accept_hotplug_memory(start, size);
> +
>   	/* device_online() will take the lock when calling online_pages() */
>   	mem_hotplug_done();
>   

I really hate that accepting (and un-accepting) hotplugged memory is 
different to accepting ordinary boot memory.

Is there really no way we can get a reasonable implementation where we 
just call a generic accept_memory() and it will know what to do?

-- 
Cheers,

David

