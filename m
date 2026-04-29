Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D116FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 07:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860836B0088; Wed, 29 Apr 2026 03:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8115C6B008A; Wed, 29 Apr 2026 03:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E2E6B008C; Wed, 29 Apr 2026 03:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63D746B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:57:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 416DD160734
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:57:19 +0000 (UTC)
X-FDA: 84710838198.20.DF6CEB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F80714000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:57:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tu884VDN;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777449437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPTQwN6FHCEM1yLuNFwiLgAzpEKdINGGfUZaIfMV9DE=;
	b=7YJaYN0N5scuAWnnAqAGomscqggnOyDijuEMY5gVtvVSAH9O2V6jw5upFMdwJFtfHiXS2M
	Uk69QWhVtrM70yy1N2wfOU0HrJRmKwraMDFwPnr2sPyb3UR3JtzDkPK/5Sl48KcdAPB54C
	xGy1wgzaj1iryf4iUdIvbS6ZJg2BpPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777449437; a=rsa-sha256;
	cv=none;
	b=WpBnLIscFvfJL3H+cpNXBlLveLHuiKooplyIvhpHUR/CvfgbivpSB57RF9ehQ2rXGnUfg+
	fr7si7+GePDvUGI7Dj6xOcHqEdHX67D/7bzPJVFqBtCwWtI1HZJdlUJ7GwgbMASVgJarU/
	Ed3iDS1IVseIYOn4YTMDd0EjIJhnq9k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tu884VDN;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D5982574;
	Wed, 29 Apr 2026 00:57:10 -0700 (PDT)
Received: from [10.57.62.76] (unknown [10.57.62.76])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC0283F62B;
	Wed, 29 Apr 2026 00:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777449436; bh=PPTQwN6FHCEM1yLuNFwiLgAzpEKdINGGfUZaIfMV9DE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tu884VDNcnff9i319agoWfbHCU09dt7nv52tTghEcTpUmoE/TLPT0pXCWMeWZK+hR
	 5tZo5fr795P2mHfGf0u5pH2d+gOGMhuK62mkoBPTbQE/fpcwqBc2rXrefL8saY2apM
	 vGNABGXJYLp2iVd9jeWXE4aOkG4vyKK3pzyrtv+I=
Message-ID: <1ba0b6ce-3e71-45f7-a3c8-cdc5aadcaf27@arm.com>
Date: Wed, 29 Apr 2026 09:57:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/15] arm64: mm: Map the linear alias of text/rodata
 as tagged
To: Ard Biesheuvel <ardb@kernel.org>, Ard Biesheuvel <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-18-ardb+git@google.com>
 <82091dd4-9d11-4054-89ec-99aadaeec7b2@arm.com>
 <6f514d91-c8ce-473f-8383-f3b9a4cc2f7a@app.fastmail.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <6f514d91-c8ce-473f-8383-f3b9a4cc2f7a@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F80714000D
X-Rspam-User: 
X-Stat-Signature: owrbm48yf35wq99apywhz79x5m9dntdb
X-HE-Tag: 1777449436-153707
X-HE-Meta: U2FsdGVkX18QKXhD/O8ER7fASwCL5jfcPbA74QvPvqsIISJoauMlm7IQv9s53kzrmRSLy8IujVFo4NKD8qwDVR0k2V8TTLime0l4MGt6Dpsg8VCECYTip4UrYgzl2iZT+S2ouiP4dP3SefnHzGc+EXVGTyFfcVmgb4YLOJmp/ruwDJYOAFrHCCfo5lD0vbH4TNxcHZDwWDDMVA56bGZX6zL2So7FMpmpR2/3oXN9aroTZATVJGA0xcDh1g8dj25Kh+rG24YrP4hXQWzAhV9O4nUDQEDK8V5FFbHB8exa620VzEHMJ5p12Zarwy+/Wt7LlSEBRlGRHT+YOb6tPvpnV6NLFrCoaweP5EvpexdXuz8Dn3fdUIMX631oayotW+g31QM0/B+nN/C+3bTjVxhJ2zbEPoGwXRpbSBRe0arHLrs6+mKIJRFglf/TQ0L/XfQ7QoHKPpk4Xaghc416Pwukt95y7DTWbILYDplZuUyHPzb6DQHlph+9YZ/F7D+kBWy6YVbhL9ShtTtZehVJmlm2GJac3gfDV4a4Uti+ZNu78+mimC9haJXZS8f5S+tJozPgHzZ+MxtQedoifPBFmAPCDPyUHpeJSrdWxPIHupRmUkamz1mIz0LDYff5k+NGPpM/YjbquMJWu9nwEkySCarwHg9xK4+2HlN3CLzGbyq+Ki4NryDkzTBD1pAGj7osPd5C05Jxut6tzKS3kWG92w1D4+0HGDvP6sBIrrSfZgvdPLYpsMY6W2z/4YfWGrpah8C6gt4R2Dth72TRL58dUHNlS4iig1dX/n5gnPIJmTUhLufjNle8jkaE/G46e7wkWBUyhzVkzwp2IcRDGX1i0TpMCMBrh0OwI5NhtehYqWUXNs/7fUoB4YcqHXtMn9kWqtj58rhhvQyUOm0FFIfTeWq/SABCu/FqoRvtIxx8W/qBJ/hrHA6m1AdoOofNl/Q3NPUbncAR/hT4fk60khO49sP
 twPTdeJF
 6x3JFsdC8SPQz+XxH3RusK3+C4UZeOWHwwiyAAWKVoboRFQItm9Nn12PuGp9tSTyZ1Fcz3qMq5D5Fqx8DvERjjJsoekMvPHGpHLErx8OGHZLjCG0e3mh9M6gISKk3gBQ6AeW05m9jQyLlbYog/OvWLrp68yqS0aZvO4GQVa6apZrsRXcp6e/z0THX+Uy/9kStdqrMtPsMUsXBL2PY5O4AoFM0K87aO01psghVWNI06oZOXycaiTpstZpgYvpy6nZHdqtd2+asGCr21nKke0SKdcSOBoDEwYouxQ8tQ2rtAhj478wKYMDQJwfefmsrCH2y533inif4De9X1uzH0pIOuoJqIN8MMgLIWAO7CovrfyLyGno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28/04/2026 18:23, Ard Biesheuvel wrote:
> Hi Kevin,
>
> On Tue, 28 Apr 2026, at 16:16, Kevin Brodsky wrote:
>> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>>> From: Ard Biesheuvel <ardb@kernel.org>
>>>
>>> Before moving the empty_zero_page into the __ro_after_init section, make
>>> sure it has the memory-tagged type. This is needed to ensure that
>>> cpu_enable_mte() will be able to initialize the tags correctly.
>> mark_linear_text_alias_ro() is called after all features have been
>> detected and enabled, so do we actually need this?
>>
>> AFAICT the lines that matter for cpu_enable_mte() are those, in map_mem():
>>
>>     __map_memblock(pgdp, kernel_start, kernel_end,
>>                PAGE_KERNEL, NO_CONT_MAPPINGS);
>>
>> It is probably this call that needs to be changed to use
>> pgprot_tagged(PAGE_KERNEL).
>>
> I see. I guess we should probably update both, no?

We could, but would we ever access the tags in data mapped read-only?
cpu_enable_mte() needs tag access to zero them, but AFAIU it's really a
special case that is only relevant to the situation where the data is RW.

- Kevin

