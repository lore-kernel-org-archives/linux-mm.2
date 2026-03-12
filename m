Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4F6FED2EB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 900916B0088; Thu, 12 Mar 2026 04:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E27C6B0089; Thu, 12 Mar 2026 04:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA326B008A; Thu, 12 Mar 2026 04:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B99D6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:32:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFA91BB91F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:32:40 +0000 (UTC)
X-FDA: 84536744880.21.5D91F3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 201D014000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:32:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jIEyu1dv;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773304359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUVRqUomtYAYrfR+7zK6dTgM/+nFBWUC39AkJoWtLR8=;
	b=tfirwN8iQfCxIAiCIZwu9hRm46FCLK0qlisgWjatCRozrp8qeszUjjmFY8Z9d0giG8jdpL
	QLfmXlkoMi5LwzMAu/ZcpN/kbl+ib6s5Z/zSJzmDrVwoaDvcNxVh9LrMqe7VJcBor1/d9U
	nFy1QdEg8gjc+lQZf3xr8BbcJ48QAh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773304359; a=rsa-sha256;
	cv=none;
	b=f8xwOO83O51vz7Pt3cvKzN8BDjaYOpr6P9U2zAWZJOECGlC6aXc/J2KPsqQt8Zqav0pB6W
	lX6y9kOEHQKHmMxPnyOoTKSskwQnxL/Tlc//Lk04CI9S+Txtw1PUZvyehO9GW/Z5EGp6P+
	p4cAl++3ae1cOJKAEIWPM8ipQRowRuE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jIEyu1dv;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9053F60054;
	Thu, 12 Mar 2026 08:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E244DC4CEF7;
	Thu, 12 Mar 2026 08:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773304358;
	bh=5AYs6BroVkxtKJhCWyhPPa9+11YmMxWFhSfvifCztJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jIEyu1dv/G4tXeoiWpSNi4nEf3g58BTBHj2mu/oATMIOixTT41BqLjCQxdgDqOlMR
	 dWo1Irhc9Rda6uMgaylO7vhng4jYYp2ncOAl0bMG9Z9Wscn47ydAYWqszHgk8kkwvm
	 jIIeE2kA2LmeaerQl6GOhhAy00f+21223GH6HUC15vORxdsEiCRKFYCWW5i0G9bczv
	 E5aqD6XXBCTyhp4zy8LNf+7lQsDqsk4VhKoxq2mYxVoOAz5iP9ArCF0i3h0FnIQmAJ
	 QktSsW6qGCUJ7X7h8eklysemTHCLn9XpED5QjOdDJWp+TtyksQHMOgjl0o9Bi9QGYd
	 CTikNaGY7gqYA==
Message-ID: <2c069fb1-fd23-4e7b-92de-7f4a4eaa4f67@kernel.org>
Date: Thu, 12 Mar 2026 09:32:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
To: anthony.yznaga@oracle.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com, shuah@kernel.org
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
 <de35525c-4522-4117-b6cb-01d48325c4f1@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <de35525c-4522-4117-b6cb-01d48325c4f1@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ghsdbjjq5o8koo1zp3xbygmwxj5p5bpe
X-Rspam-User: 
X-Rspamd-Queue-Id: 201D014000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773304358-994510
X-HE-Meta: U2FsdGVkX199Xk2B2MWLo1AvqOvknmc3rXQA+AiqP2jzDSHNP9SZRMNs/14UbedPlZCbtizWkrz1dbmtoUoUtIJYXHDg/yVgAiGMm+BegCzzMRNoMMG8SyrpWcbeDJYEHGfHzyY++3EKpoCHcpl81o14n+omr1IkuZGj42Rrpb+OWiZvsF1qbiZ5QlXm4KQXIj5TaQFufdtFXET1ROrF3hIWMj7naqNrsz4YJIhlMKDye/hWDbCJrNkIqYSIc2pOWV1QK8ZMq630BCWGCldymolgyLvt0v5+HmFc7tDPF/HF8pa/sbrVQk5EC0kOQ0M+OauPTJ8YP+ESM6m1aPTbt5s5vV9pXc2W6bf6ecB6P9BY+lau7J+qrFtB4waj3442ue27ycc5APO6o5bjsTwod7ruEwTXqD7ToLdduXWL9eI96L3eIgtf1ZkHwEoUh3logukAscbUgJVNtd9shrgL/oAb8dIMEMd4a+l9rIhEFDcLoUFkldXuTK+V9eZEo2lvBsriDVwrKmA3D2YqH6rhG+t+WOMILmegBOckFuUmsB2jlqmiJSWceIBCwBPkAa+kEGHaRh/mpVXH01XMMX9RJwzKCbOpwh6+H/ujAHVx2Ffu54LbZGYNWINI1CIYhz7hRIvVxDQ4yQQs3Kn+brZRqEFXyW1Mgpot41YTTZydysBnLk2NT4fbAgEXDNUiQXitHZ8jkgwUs9T84eFGefJjtRjiFrJHJdCmRMaTiMWrq8doJ86egMTsM7kgzL9fF9Axs2L88p+nxshZ8ge5hCFoX81YofIrqGawshTZzKTlp1EWYaIaMM3gnD3rTrgKFVIEoFgQU/ODqb7XpKdcQwajN9k7OUkdNFJqKuFh277yeZBlwJP58Vhfu0681B2fUDGk/qFRvafwXOE43Cy/QVJzeobXkC0/Srkru7UhADK4OMRg1AYq/Q3ypebaZlein1L8gQ0LMSePb4znqrJJ896
 Q2T3mJpx
 /AttIpi0K4S8dIZ82YT+EyCdOtP/v9n17KtI7lon5e/r3WnfsZPRS2x8Hb7j3ODojRon4DM5xcirUw4ErKcwRx62EZf8qI/t2Sh2oOA0PcGnY2VFAFvjkzHeAyPU8JJU1BT3WKqxYvlGf2nApzV4f8CRYa67K/+I1dR3BBpDXM8KBcBLuEfXhrbfblglQ+dYKkG3ZG6s/r+AzQM4gJUmSZQ+zPeeR2Gg2fT1PdqSs/LbbXv6Bylv6ntuIPgn11HkXfye4CBJwqphbTV+ulsD0wSYbrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 03:16, anthony.yznaga@oracle.com wrote:
> 
> On 3/11/26 3:36 AM, Lorenzo Stoakes (Oracle) wrote:
>> On Tue, Mar 10, 2026 at 08:58:20AM -0700, Anthony Yznaga wrote:
>>> Droppable mappings must not be lockable. There is a check for VMAs with
>>> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
>>> unlockable VMAs which ensures this when calling mlock()/mlock2().
>>>
>>> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
>>> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set,
>>> the
>>> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
>>> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also
>>> set.
>>> When these flags are set as default in this manner they are cleared in
>>> __mmap_complete() for new mappings that do not support mlock. A check
>>> for
>>> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
>>> mappings created with VM_LOCKED set. To fix this and reduce that
>>> chance of
>>> similar bugs in the future, introduce and use vma_supports_mlock().
>>>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always
>>> lazily freeable mappings")
>> We should definitely cc: stable I think.
>>
>> It might result in some backport pain since it'll probably pre-date the
>> __mmap_region() stuff :)) sorry.
> 
> I could add a patch at the beginning that does the cheap fix followed by
> this patch.

Any backport conflicts should be easy and fast too resolve (if any). No
need to uglify our mainline patches :)

-- 
Cheers,

David

