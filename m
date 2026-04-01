Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7E03D2ED08
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4A5E6B0005; Wed,  1 Apr 2026 09:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22EC6B0088; Wed,  1 Apr 2026 09:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37736B0092; Wed,  1 Apr 2026 09:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAD2A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:45:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B9FC1A088E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:45:07 +0000 (UTC)
X-FDA: 84610108254.23.FDADD78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71BE3C0015
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:45:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G6ncSX4O;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G6ncSX4O;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775051105; a=rsa-sha256;
	cv=none;
	b=slFRagRm06L5IBXlliRlryK/OUQ+OJJv9KDFc6SjriHHt0jg3rzKKiJYR414jl9N8T4SGE
	/wcR3NpAjLc6mToWb85ypdCKRhQctmEN70r+9kjRjM7RzLSawBSLZvl7hYsXwolNP7n0ol
	4+caajsWtN/9IWLioxblMOgCByZME+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775051105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpgjXYWg+Hjk60RwOpnZIWST7vnvIQmUK05pccp+8vs=;
	b=a350sH/dpiAKysQH6tOWdSGzWFmzZSPxILixDRbLQhGigTYnWR3EWvDO1TyuO7zQvi4nCY
	f4+kAmq5Rmpt43vpfK04dNzQl5jAx0bl4wgXRqb2TtyZ2nAiyVC/IvSbGBfTWUBvGaWxxU
	MW7ndAwAk4kdt015l/POHyBDhsrXs9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB5A5600C4;
	Wed,  1 Apr 2026 13:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A847BC4CEF7;
	Wed,  1 Apr 2026 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775051104;
	bh=sXEt19JQ1n98ew1H3czQ+UsUIfs9zXbmSY2HuWsxRWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G6ncSX4OMSyBURFLqejZtgReUgcbfcgjOZCtVdcZMsxumWwOSmIKB9NS34FIMdLSm
	 5P3hWtWv5j/KLzldnAz5pqIo1Lwts0OX3kYcwevnqX/Vdozw7T7QQ9irRFrrWrH4Bf
	 lkoR5cSLzhCQDSOZ2QoOonaqifc7OlIU5RlcYFgQCxpQvnyMhwikkt7G5ew+2+fBim
	 s/XFXi7ArXee77MJxoraMZAt+lVyZUp+nT9AIXmhL2qiXmcx9I7LMjtTAh20tj0+Mg
	 7vuMaUZwMWfHGQd2xbjYagACPy9TQLxYdmTfthbW+AjBEgH3ETbv7iEFhZInxGaHTv
	 MCxfG3hKcQKMQ==
Message-ID: <153b1a47-ed97-49ee-8977-e010ef5648f8@kernel.org>
Date: Wed, 1 Apr 2026 15:44:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] selftests/mm: fix cow/gup_longterm link failures when
 liburing flags are missing
To: Li Wang <liwang@redhat.com>, akpm@linux-foundation.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260331040156.119158-1-liwang@redhat.com>
 <20260331040156.119158-4-liwang@redhat.com> <act0F2KTpXFFxmdf@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <act0F2KTpXFFxmdf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71BE3C0015
X-Stat-Signature: xusunxh7occj75pmthgme4hmzrdskyp3
X-Rspam-User: 
X-HE-Tag: 1775051105-24011
X-HE-Meta: U2FsdGVkX1+QFVPiBwdZNfQmTkLD/18v6YlKtwxjVob6GU9opBncQ23fy68Zwld8IKPwGMiKyCu6jYdUDuCMym38aWYAsNpPSg9wxuwV7isZ6P/gjeDs5HcdzffojjU/BNS1nBe7zVmvB1O4RJLeTCnNBKrr4Do/U6uSq7vEH0aUEn57/M/RnSOjDfhPncOmnR0q3k23qq3Gz9wy5z2gabFhQLH6RJHICHtRBHjYGONzsYyVnDK+4iy76pbqGYhHoaSzE8BRSWOeSpKB+wlXiDnrG4ydWPdaPoEXwZAIh/TCyv6OXro47AEY5Z966PccW4YCgvYC2NGZ8cI6uUbl0taeB8R0HkP4AXF5ljrE8dgpU0XoSVXqqcKSdV4cIbkNUb1MOIK4mok3ELAzVE4kzja2ewRK6WbOF9J7Z8yKeQDwCQSrilY0rMbGibINf7kHKBZiUNRft+URBsXLAQXNPslhNduwPQbLv2tP5fh6CaiKpqFL9fWQL5MGJa8zzvFZXUlDDF72vdMtSeRKVgGf7jn2leVuwUCUfpXCm6jMiEAbeoOJU5XAH2Qm5uAysO0ROE/w+FrWg10bfJW05demB/W5LAEIqItUAbtKftCTno8YN3yudTRMXdm+0r0qfCoP3vimuOeSsFP+qvHUDpwC9doBv37fFRTxxtIKcflib3aN9J/cdVVJI4RmQUH8ycyziKJ4fhxD6CJCyC7rhFIIA1b19vHc6iz0G2jTKF5fukIILhVJB77fdQNuBplXaFbxlJ7nUcKi1Fj4vCFGhaYcLE/Jd5ABDYhDbTwEGrUe78HgHEKVl2F1FXYvMkRBntzoH2ARmxlorfST48XzNmgwRTaqV2Mj58MxClfXrX2y9Esq+XSIkByYoIhzo18JtNizkV4eOuMLVTISdy34t+ufkRA94FsyOs5OxI1QlMmdVpq635vgPAsBIJfyKhM9U3fPGnSB90/K5Blw+pd7DhE
 h7d0xS6L
 8rvWLfWMyagwhh17+GoTvncw5pUaCvBM14YuR9u4pevQF4pJCTBwyWC6/2Bq3lDhAyrzT/vrlkobJX1lq0Olj2isD7LBqz1skmC0FGazlZQwpMxNEmqB642tpYmbfCnBwwDLOMsPRjQ01gjO3II79Mc4u3Sj2Oa52rVyiT9j757zjTI/otq777BV1BDlu2xW1gWQB5jsBv4Kx/K4MNhf5xYPwIyt5YzeWf027ETinBybxahAI9sKlAID9ZOr/I+naX5shxyIdW0x0FgL/7+gQJ0PIcwwaH9pgSO0g6YFgbxAe3EEpIJMj/tXKTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 09:13, Li Wang wrote:
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -10,6 +10,11 @@ LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
>>  
>>  include local_config.mk
>>  
>> +PKG_CONFIG ?= pkg-config
>> +ifeq ($(IOURING_EXTRA_LIBS),)
>> +IOURING_EXTRA_LIBS := $(shell $(PKG_CONFIG) --libs liburing 2>/dev/null)
>> +endif
>> +
>>  ifeq ($(ARCH),)
>>  
>>  ifeq ($(CROSS_COMPILE),)
>> @@ -55,10 +60,12 @@ else
>>  PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
>>  endif
>>  
>> -TEST_GEN_FILES = cow
>> -TEST_GEN_FILES += compaction_test
>> -TEST_GEN_FILES += gup_longterm
>> +TEST_GEN_FILES = compaction_test
>>  TEST_GEN_FILES += gup_test
>> +ifneq ($(IOURING_EXTRA_LIBS),)
>> +TEST_GEN_FILES += cow
>> +TEST_GEN_FILES += gup_longterm
>> +endif
> 
> Please ignore this one, as Sashiko points:

Right, this should be dropped.

-- 
Cheers,

David

