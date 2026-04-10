Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A844F36BA9
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7156B008A; Fri, 10 Apr 2026 00:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E896B008C; Fri, 10 Apr 2026 00:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB1E6B0092; Fri, 10 Apr 2026 00:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2656B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:50:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F39FC1B7B6D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:50:50 +0000 (UTC)
X-FDA: 84641421060.25.96A105C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3BEE220005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:50:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GZovmfCj;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pvQL6DBxdgPUZVp7bF95+XhXSCx213mQ8nPOmWc+k4=;
	b=Aq5dsDVqfEAZseUSvOlCfBqBMniRFQHAcdYGOTf4DHg+Qb2B7pOhYEAxn6Df60T2lf7xny
	732cn9ypuEF5qDTE47p33WoensYDSDaKeLQmwAs+nhGb0WHEySNrHSR/QoTQXyZH0fqUTF
	kok4cc5I7SwapQXgfpKHtHYlwGRWiW0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GZovmfCj;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796649; a=rsa-sha256;
	cv=none;
	b=iWuHAwbCAN+tbnQHCzHymbAtFRbWx3I9XKTaTcCtjCbGWvgb8mHbOG0dxuQ2sogpmMTNnb
	ekFx/r7woM3sAdZpPxnoJMeus2LD257pJup1DQV1d57ZdTyesJc4jVGU2szbTJLCyss9Xw
	l8u+yBim6wgdGs/lIKbsSP91JJHU/+U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69FD72008;
	Thu,  9 Apr 2026 21:50:42 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 088823FAF5;
	Thu,  9 Apr 2026 21:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775796648; bh=vXofvo1m8OBdJOMnjG/myR5+E0MqcahYsCCk38Vlw9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GZovmfCj6dNyFwOVOI79CkD3FW9Uw+uSnlvictrhFQKqouJTQQ0FHHOD8AstrTPIu
	 rvLZ1fl5GnWdFoPMKMst59k1jcr5ZZlsMyG2I7CkGovwCmZaqx/DpKIKuBgK4yTb6l
	 fZkGjrOSgc9V3KEUiFXZi9FgJnTBf3kxNwuk7Ywc=
Message-ID: <6d91c17f-2027-482a-b0b2-98ad258f1687@arm.com>
Date: Fri, 10 Apr 2026 10:20:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 06/16] arm64/mm: Convert READ_ONCE() as pudp_get() while
 accessing PUD
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-7-anshuman.khandual@arm.com>
 <b1e1783c-3621-41e4-b65d-38cf66a1124c@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <b1e1783c-3621-41e4-b65d-38cf66a1124c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: aw17kh4qa5r17zoy6ggpeh31f5mxwwxx
X-Rspamd-Queue-Id: 3BEE220005
X-Rspamd-Server: rspam09
X-HE-Tag: 1775796649-752821
X-HE-Meta: U2FsdGVkX1801voCIkP8dWqElnfq0CpMTNHXEu+dfLlafnV34GRhQcY5i5ALJU1tgio/h7qPllgbNbH2HLFOiDeytxhegbq7Oi7JvLDTZjmyYzX2DBrIRSFR1FXC5SuYsCDubVNEGXYvBEki1+v5jNHkIIi2mHHJuJUJUQJeu1X5j7oOfq/17SExNSyWijM83rl028bOBJvKu6jZ0zdAYrgQhQff/QxIfadLsuKh9cQWsJFRXFZf6OJw97I3lZcKJ6AU1WPYUB9EfRwjqTa6Zf4oD0ero5m9hvsEBj5IbTAQyStbNrghXSrCwDqYbTCzYdSs3uIfU9cqa7Y9iEOUVCAo9Uj5UG4CDethka3E2FNAMxmwJXTZ7H/AVvVYbOIut6hHhNeIuutYZlYVFPJXq0vHfacWu8h5u4muL03/0baQyAOkDDuH8nrHKvSMUuzbr2GLSuhrvNYclJNSU+i5Gc1g9barHkJ+J6AiUo4r+EPdV9pazFuz4h2nNzL37l8pHq0A8SiriwcqLLpGwoWBBegWMmOzq83/OKFQrQlfbCeSpjzg6XZPD5IJtKkTzp892A6MuOu2W1UIDbGQcNghbHvXfX071fReMA5IR7lbu04Q0/kwgEJzTAcTsOt1wmeUgIEXy/wvt8tq86M+M+4Sx/qgJOCI6QAWph6Oj26F7PXbejCM5YuiPFMRxuNqeMRdA53FI/eEUGdTkYipW9J9V/6dqM42PfP9pz1B3RSr5pfa4DsQeuFQIJ8XeCCCZi0DLT3ngd+I64RCALGva3TEGX/1O6maeV/NjIDGakTuwJ2QMHgrWmTz2wnKNRrVwEQb1GpkN0hdJGUWBlmTV4uFlrvgELy5CEnnpjO5DaEhv6Lz6cjT5r9awrWUh5ChBhMJ/XOH44LSSqu5SPMRI1HLUf6yOUlJulhcsXL10A3vzXuBnWZ32wk6CMuxWK1g+psiVRD7AgFAly58PZaRpEE
 I+13wPN4
 oFeHVZ5CcS9x2Iq4MyXb5WQQbOGOqcj9u+Sa2aWsWx5iMvkwWpi42q221zYlxD0kZKcXtC67T4VQw55dI3rslyhROXLibGSSWCTqw6PcyBfE3yML7Fr6OipDRKytFM5oArSkqkb8/OGvhYjKvIqyg+mv0oy6BsQXq3nCagZ7qKFokvwceDm8tOH+jVigXXVGFYF3PERS5Zgso7aH8LaF+EAx9ZFKC5yprTuI6T2qLac7jjr19HydHF7riEURUckVdw8Hhg5uOUZRtYaxMaNFcA8X8ZVvc/zfXhuXrrfuJf4E300pYVxojEzl/CKhB+yky5eWT77C+Abo82KzzoXXc9dFLj4EwrkaOZGsZ2DQH8aeQ4tQvL6wtPkDGzqwCsYOafydd6Lh4wnzl/b+V2DeY8mYopfosXRWfxRRL6v0SafGDAs6X05Wb+Ue3bKy+SxoWq2MoozAAk6QLzpMDBmm9/xtfUiPFGWqo4eSVrnxulIU+3B8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 5:45 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Convert all READ_ONCE() based PUD accesses as pudp_get() instead which will
>> support both D64 and D128 translation regime going forward.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kasan-dev@googlegroups.com
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
> 
> I was wondering for a second whether it would be better to structure
> this as "convert READ_ONCE to use pxxxp_get() in fault.c" instead,
> essentially, to touch each file only once.

But will not that create too many patches ?

> 
> Anyhow
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks !


