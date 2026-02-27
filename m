Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB66FD5310
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 08:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DDC6B0005; Fri, 27 Feb 2026 03:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B8E6B0088; Fri, 27 Feb 2026 03:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82476B0089; Fri, 27 Feb 2026 03:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42EB6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:53:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75E961605BA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:53:10 +0000 (UTC)
X-FDA: 84489622140.11.780558F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3736C0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:53:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pTd/82pF";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772182388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=giLVQo7ce9jkQleEDrKHUWPwm2hPX1oNiANDD4UqDQ8=;
	b=QH5Ucgv/Sk4TWr25hEL7YNZQWWX6rnE0GSMh2m85CtY+fHiOz9/YwT6Iqmcr+6hSMgWIH3
	aTyu39f9a8sdtZJvYtBAw4hB7GSwqY9UkTQDE0JPnyKon818enFlTCg8Tcd/gjYaYsTzjo
	bTSMDrA79jSBwNz30g/ljgaNvEWM6pM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772182388; a=rsa-sha256;
	cv=none;
	b=sJWhTZjmfvUcpuzhLzN3Qen6JUgvC3fyj0C2KTsBjJVAVbXmATkhwpwm1ODqBYIKK8JHuj
	QvexUvp9A9JeCApMtQY/UkQ9rQkKdtvXQNt94k863KOYBgjPr0/hJtFASPoW3tPn0ysjbr
	COmCuL5HE94N7e4Er6LoW9+uKHcWeug=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pTd/82pF";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E28643C63;
	Fri, 27 Feb 2026 08:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8735C116C6;
	Fri, 27 Feb 2026 08:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772182387;
	bh=tgLQxMu6JITyZWwdAuEZLvS6iu1D7yDVqCZzIsREeBM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pTd/82pF246Y0dN0z7yyzx6rvF8YgPCDiBlu2mYjwr8Vxmtw9MXBDk+GtcjLU6iI1
	 FXgMUcBSb062z97ntKmAuoPmJOuJkgNFb/X0S7Z9eQqw2xm807wVsVMKrnsrwW3JnV
	 3A6jJAod0wACY5Ss84WpbLX5T1DNXL6ldRfs5j+aw1KKYgih+0GqLgn8gYqGQBAcUv
	 EDGs0DmMKh/OnyDoT401kSjFuJ5DLvvbAQFs6XF4FwzXlj5gA23tcuWo6V3Y8/fxRF
	 FFb9SyivscCecVcpJhyvHejyke9895NWMLBcd/EtNEvsuPxa9LM2FAKOtm9OggJz27
	 bwoPPsIQ94Ayg==
Message-ID: <0421d482-a2b0-420c-b83f-1cc057d6662a@kernel.org>
Date: Fri, 27 Feb 2026 09:52:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-4-npache@redhat.com>
 <25723c0f-c702-44ad-93e9-1056313680cd@kernel.org>
 <CAA1CXcDYc0=_=BiFDJXQ6KwjZZB6TYwykW_c8ZhocfEZw=MXbA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcDYc0=_=BiFDJXQ6KwjZZB6TYwykW_c8ZhocfEZw=MXbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3736C0002
X-Stat-Signature: 6hwop4qg9rmmccb7g17381pa57ra3wmm
X-Rspam-User: 
X-HE-Tag: 1772182388-305160
X-HE-Meta: U2FsdGVkX180gYs+bGebcgU8E7i4k4B/hf8vgtX1HW9XRDhLFIYflwLOfiChmqmdClygDuUYRz8enaefQtKMezoI9Ov6j2JsFRtp+6a9AT7qizyJDnrPu8RBqrwYWV4rwKVlDuzVsoCGtYldN+d3RMURgg/o8SW4COw3UFin0tBoLNa+GzrkAo3yericDo/cr0s+21NlPCoNJ26KPpW+40D2t1lIU7yXnmDhLSmeNf+PvB764zmzxgmKL1w4otqQLNbKpGtZbPeyfNYy1O4J0YS6adhy23oqSfYFcpqZgD8Nu1xFkf3rwDOfP3Qd4PQue8CAxoIZjkoaYglTcH2idloV39dXwZNYjaus1c3emzOjk7YKkQnGocuD/dQ0HAD0zVRZpIAYJs/cc878eMsLB/H6b51HADjb1qQuEjmyOsWsyqwPcgXV1/lcf7zRknQvfuJ9fICBgspVHc5nerN5NvDKfYgeLV8JeftHaI/QGsD+UUeY7Nii8+u/8j89oaGLAc7CjP7BYXscXT9FMIfm1tlCUtsC7we73iIwRp24f5d8cMAGfT7FZHYJGem8fhbJ8RO/1ntP2RSZdmaQmrsrYqwpxmhqvNfokqjgUgAOOfrOiTgotWLMdiJ/CGe6fiDyRWSBd3sT/NMfuH+2A3flPKJxPujQ/W3FyeeH8SqfkEYPkq5cGiA1T6IJ7o7ct+4mbOzwrIj4ovZZG5se/MO9nmt/J3uiGI0x3m4I3fzJKSvttwREfNaREweUuKlOz+RlsIczb+UYorP58kiLwxhnszOSnDgM6xK5u/0bDq8skgZxBSHR4vOADtT8MZ0qh0uy3DWNwJZdhhhbMelFsKaYsvZU7g/V4RgzHXFyRrXsQpNDsplDzAptzAgK99VT+ob2qgqppf7mfaJz5u8QWdGDN6/iGSg8I0KZEmJ2087uh2IZ5B9aCKcqIl6Z3qjvPLwFHtQ21csArxpXYE/CY2Y
 NrDN2p+E
 6W7UdRWsfG471hsj0Ls/KV+JMWMaajKABl8LW4LfrUDQ+6lHOoPacqXyksao90pvOTgy9UIVJhOwz+Mti0M5MBMOlfKdIJK6aMKMq+Ol8oqX4fuSwrDCWTcDixO2pbe1OejLx1Kte61QSAsylqfaYOljNj+cSOicUmyXFvvdLbHwn1Sndmdub/d9QVCmCpegY4kuZyIKLCmLj/p2ul3W7WyMIrOYkW9oBWdjYvGlUqxUQFbYygMlmvFJ/q55TLYnh+QTzqVkrsHeiLhWOWwSkVaL071WPClWqjWtqGvcclAE3bZwhYbSEWFBmLL7Ofr4azSnuArci/LY/kZ/SwxYqahfuFBygwBFyDOBafNHcbuMIYlWyy86Y53Yz5XBxVmXvifRnpCwJQcio3M8Vaui+OPsvR4k8kvYa/ei0dusS/a/UXw72JpHQh5fbocg2pro20dHxpbnm34aml0me1hxwu35coQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 21:17, Nico Pache wrote:
> On Thu, Feb 26, 2026 at 2:28 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/26/26 02:29, Nico Pache wrote:
>>> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
>>> signify the limit of the max_ptes_* values. Add a define for this to
>>> increase code readability and reuse.
>>>
>>> Acked-by: Pedro Falcato <pfalcato@suse.de>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>  mm/khugepaged.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 2ef4b972470b..4615f34911d1 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>>>   *
>>>   * Note that these are only respected if collapse was initiated by khugepaged.
>>>   */
>>> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>>
>> I'd call it "KHUGEPAGED_MAX_PTES_LIMIT", because it's khugepaged
>> specific (no madvise) and matches the parameters.
> 
> Ok before changing that, note that this is also leveraged in the mTHP
> set. It's technically used for madvise collapse because when it's not
> khugepaged we set max_ptes_none= 511.

It's more about disabling that parameter, right?

-- 
Cheers,

David

