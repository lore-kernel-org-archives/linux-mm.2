Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF21FCD98F3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE926B0099; Thu, 18 Jun 2026 07:58:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4863A6B0098; Thu, 18 Jun 2026 07:58:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BD46B0099; Thu, 18 Jun 2026 07:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 00B516B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:58:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4D1A120679
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:48:34 +0000 (UTC)
X-FDA: 84892860948.24.B481FBA
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05829100012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:48:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWXdEekc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cv879vejZmMUoFEF8EqJXVB2DS4FZf0fq3v1r5btMdY=;
	b=sWD1jBIrFYP2SchbbzF0GOe75YNjIftt74HVdeiv/wCkew6+l4GT0631yOqufTCtB+Oqee
	cwZfD64BBx+JrDLIySa4IN6SSu8OuN2AOLLA7xt1C5SQ0TeybxncIRT1l5FU/8f3bOuLI2
	T0F0siXeg+qQKOlZuIzbhi5VcFeb2d0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NWXdEekc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783313;
	b=aTUOHq4uKpnvKzH4vhGcWk8xtFd+VEuQEHC0uExBv/6VgQi0QFp/RKsVVYsemMVVCDaCxz
	HJYeKXpiWEZHtFb+7buXCvflupPTef6kpzFXwmYTOCf9xniF3wgdzGbJtBZeZniFMYBU5Z
	thTGMnNey2GW9kb/8dI5/Ifmnq3qKpM=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-37c60edbd69so61883a91.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781783312; x=1782388112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cv879vejZmMUoFEF8EqJXVB2DS4FZf0fq3v1r5btMdY=;
        b=NWXdEekccSmUk0l4Aw5xCYx7BO6oLQ5muNJbAGRCSeGZymnoEbnC/YmhtHcdz3jCCp
         IJTE6p3b4fBHIEUAEq3OvBI28xz99opbOa4Q/OJdZbw6WhNzia5won110n92oEjpnm3l
         2lzAZrTKOUOlcjP7XiJgtRYe5yAcPTM5Bv8qqC3tiFS5+ZUzBElNcMa7chlJYG0Wjy0E
         fVi7uk+DRCLSbo3bu32zYu/TlJxMU/dPFlY78HCm0Dw3PgMRIRonByd5zX+GaiJaXfcU
         AkKndiGpcgkblK716r7tF2HCCkwaLUu1pw8lyWacZbmirdUXF5Pzx1VoKWhavwQ9uB6G
         Vd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781783312; x=1782388112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cv879vejZmMUoFEF8EqJXVB2DS4FZf0fq3v1r5btMdY=;
        b=nQOCnKkCVDuuLTeJ0Ss8cMCoOb/EptYue5/DlXSR8YMPCRuHZw4lT0xHjMzmgsqzQz
         iw1ydnwHtGaTrvFlG9hk7lpPdLBWvUHYvaiZrIVCNKOjZyEWKiLQuLcXgm+WWjmxoXPq
         YzgBabaexqfaTJrOz+o8bw39VVVZM5x5X/VRUI1V5//DcLF1jgh8bEkV/1fM4jffQ0uB
         OyCM0xkKond8YHY72sxB4x3kHBBfu99hI3viGRFnpX+lEUDSCeSZiJRC1qX5TabK0hZ2
         5aYp3LaGAoXA9XhsYLiYSoS5h8oq9/Acr2JfrSO26HFAe4cm8LfKfl/2kSssphHid4B0
         rnnQ==
X-Forwarded-Encrypted: i=1; AFNElJ9MP2v3qgHaff7J+vHNfiXyx6Kj/ovodPPXS1an43J3r27CTuBPX23JpynjmAeqFjHsoFqLf5cvQQ==@kvack.org
X-Gm-Message-State: AOJu0Yxdy8KihryWvacvuO+YPGlSrQne4+zAqhdlgl7e0PPLJSP3Lim1
	77ZnWqx7CoPNKEscH8Ct4W0e2zjqkrLFNs7Kx9bMffUPpHP8dmxZHjyD
X-Gm-Gg: AfdE7cmaACXg7fsvjD8VSOFHNOhlCTEicKe9/OxZchQlUTdgWZ43FTgD+7gRJvxYUS9
	pJNRIOgqAsnHHbswPE6O3c/RwRrG2PeS0Hul92o32/gjHy8Jz8/M0dRZHZ5+KkW89QusIgvdn7b
	4HMC+iwMQNFPmJr3Sovr9fCTsdaeYyi6L5wZmxA/1QGsXHf/LNjL8L0VbAHAy6uA5PfMtu5zB5T
	KQIMwRObzPUF04tG1XH8Emdvol4jrO+CeXzZjOJ8y4fxtsjRg87IjgkHFv9dkkOk31anGkz1GXR
	Clfu+npqYrVMJNTmFrrpL7x5XWtjs1dnTu5irwS3Qd8DKAT5GIIGd79iFf+3AS9aL8XzfI2WBM7
	n8UdqInkqH39W11GWlEjKFHw+7qJXrg0OSGMSTrrNx3poNi5dfXitiersVFwWbqV2yvswiACFuv
	O4WsRmSVFBq4ahItFG19ososp1ohxSRBUX+A5wg15KOLGU9EH9nXAIkOV4JBFqvUJxYO8VyK51Y
	t5WnW7WA0qETQ==
X-Received: by 2002:a17:90b:3850:b0:35f:bf50:b4b6 with SMTP id 98e67ed59e1d1-37c9daa1e81mr4257520a91.1.1781783311747;
        Thu, 18 Jun 2026 04:48:31 -0700 (PDT)
Received: from fedora ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8661b5ccafsm17408329a12.2.2026.06.18.04.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 04:48:31 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: david@kernel.org
Cc: xueyuan.chen21@gmail.com,
	dave.hansen@intel.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Thu, 18 Jun 2026 19:48:22 +0800
Message-ID: <20260618114822.165413-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <acca377c-a308-480c-9840-4edf1a94a3a0@kernel.org>
References: <acca377c-a308-480c-9840-4edf1a94a3a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05829100012
X-Rspam-User: 
X-Stat-Signature: 76ywhw4uqk1fg3peif3q9ybqw5zyc5pq
X-Rspamd-Server: rspam09
X-HE-Tag: 1781783312-763153
X-HE-Meta: U2FsdGVkX1/9DrrWGdrqNsplNllpKEn+jIYf4Mf6+HQqp4HWfL0ZREQ723O9cO9EK1Ndkc1S0KRpgEI+OQnNzJ3JVf6OZC7SIMBslQxNoIgKPiivtgeHzuTwm7QW5s8Tka5OQB3OXw9M4IT/mazd3DR7lp75gitK9igrwyLqm5SGFbkQlrMr4IEr8ika1wlMqmzCCyDSwhufKLHvBJEcl8O9g/RP05ZCjRGFYOtJxFjSkV0kGmbzfN7dlAUawwYhBSgsPGjhCfunKQgOCoKZroZ7LooORWu2K5CmcJ+NwRTEJc9Xf76AIgh8+UNL8o7YmhJOIrKKW753lUPf9oQQaHJuR+mqCpgc/2Xr1ucFuH/Is1IaurIYHUoIrKbLw2fJRfEW5Rwgd63IiIQDDQer/JfQF/0gUWL1PAfWwQkcqB0s2vc3Rt6GGtfpmk1C5VSr5uVcqhk5Xg/LxaKbtXGf+XOmfPeOnMMSaDamgLq+ja6E0jUUgB4vid5NR8YvLoPspNj9HCq2vGaF1PMEaN8ZbXE5HSNnpbnCtIIDVG8BEN9CRIirurznQXuDDILZlLMl3r9mKML8PmfHenEsDGMMk9LvOvRp366ueChdX4sVyF3gJJY/AvT6r8uwut0wKomSf+NYD7A9qdxH7Ms4QvOX7x87RfzvZuA1Gsv/QX59Ed0gLzGF3oBpIfdAzf4QLEl+lk2BdcnGyrFKMFYXFTthup/ETKIGOl8cV3tgDTCBmvqWcOpZUrGQBBkct3yesEXaORdOvWbP3xkdne6SWM6wWXtA/3eXEQcq4XhFs5V2t52Iv7HyQlMcmeG1e94GiMQpXLMa5D+wPRIImogkokspwiw3Sz/zTFL6aG8Tkn2QlRDFsZ7d75o61n1EnM4Bq6fO5OqhOI+XYs30Omdz9DpSXL21DeMfYfRW0JnxQlkW05WjLUzZNirgWx8/UEwzrb5Lu0+KjDn6XaU55YqPoo5
 74CVBUJk
 fooesJKFQ6LWIDvMQhIb5BUoSFv7MHUQqVkcu/7QHerUpn88PgG01eaHogrSvWd/rGUxUJ9xmPIRfi/dXSbJZ6RMCKJu35EXbwtJ9ntFNbU0hiRIGKBDHPNHGPEkq6co26lkO+eeqY9ZjoSTY3ACbFL6fhNYshFiTppy5McWy4DPdAkJumhpxkEHz4RVVO+buyPc11owb6FEtSrKjwZxPr1B58LW6Cs59FAp5ZUBc2rA8NPTCPiTDobZDMRSq2QgH7qH+tNWdQFheNZ4t0Hfvx8R3dAgZSMjMnf8XEo72/sD9qJ1RF0K0ZGE9zGCDZuEJPFgw48WEbxGP9AmJC/BXOuyBz3pDat5WsJnT8PpA0VLowt2LFv7jn5omocd2KNxPGSYqDjO1TglLVvdicBvDc4NPNMkBaHXRuOK2k3odj1zQPO2VwohxCnwKURdoGN4BgmlQtU40fgKK0nRF7nbCKbrfhxRgFMs/UhzpNpok+r+Kbpzq2+SNR2B6D2PgxwftFqzCAYlEZwEGnD0QNnWGd9CMcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 18, 2026 at 11:06:41AM +0200, David Hildenbrand (Arm) wrote:

Hi, David

[...]

>>> We're adjusting the directmap, remapping a r/w page to be r/o. I think we should
>>> be very clear about which transition we expect+support.
>>>
>>> Also, I rather hate the "set_memory" naming scheme ... "set_direct_map" is
>>> clearer. Anyhow ...
>>>
>>> Now we are throwing a "arch_make_pages_*" into the mix.
>>>
>>> Should it really contain the "arch"?
>>> Should it really contain the "make" ?
>>>
>>> Why can't we just reuse set_memory_ro and pass address+nr_pages? (highmem check?
>>> Could that be moved in there?)
>>>
>>> Or do we want a "change_direct_map_ro()" / "remap_direct_map_ro" interface?
>>>
>>>
>> 
>> How about naming it int set_direct_map_ro(struct page *page, unsigned nr)?
>
>To distinguish it from "set_memory*" cruft, maybe best to use "remap" or
>"adjust" instead.
>

OK, how about `remap_direct_map_ro`? If no objections, I will add this 
API to `set_memory.h` in the next version.

Thanks, Xueyuan

