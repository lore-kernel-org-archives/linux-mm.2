Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1F8C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB3F6B0088; Fri, 24 Jul 2026 09:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B8C6B008C; Fri, 24 Jul 2026 09:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BFB6B0092; Fri, 24 Jul 2026 09:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48DD26B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:39:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAC4514035C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:39:23 +0000 (UTC)
X-FDA: 85023777006.11.7CB2502
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id EC9F080004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:39:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDTwShkh;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784900362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtkHIMsEHxohdqGiQq6BVLpCvEimV8PjsiIPAtDV6MA=;
	b=6qumgcDL7Iy0NFDo7+3JlSu5mw6ehb0nbNnWFhpw3Bp6BdZOEU9bP/mqCSNv+oY0sbjY1Q
	MpXw0oAJ81XsioCzkGTqiwNwmj78aGrt5dnfDJ/SIdP37mWms+ZK4+M/3fd1YV8VTGta5W
	AclLF0FxKy5FBRyXYEq9bVsPLCm2jaU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784900362;
	b=rqoewWNDd3rX5Ael8EA/jfqQcWo7FCksSWFlV64lkgRMw5+cShxIxzsJg2De3kqOyqEGWi
	7+m2XouB0/pz5m28794DBfJNxNHuisof3QgGnXlFV2oHdjnA137F41OHpr7hXgcd8MNZ4i
	RX/4gu1RvSVn0Iis2ywk33+qnEv+wR8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDTwShkh;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d2e1d8ae-74d1-4f46-9871-5f7f3e69ccb2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784900360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dtkHIMsEHxohdqGiQq6BVLpCvEimV8PjsiIPAtDV6MA=;
	b=eDTwShkhPSDeT8mihmnbGk+NrbBCBLhM+nD1HZW+oBfEZrqFb6NjOtIaESZOxn77AzFWdg
	9LeWIw0KQXz1l4VXonWtM/pdvX0EyV+ApzI/ikSYzaE5jld3fucFcDwwx4pVOTJwrOXqOe
	MSEbodEKd6e5fXXMD4SFUOkiXzv7YrQ=
Date: Fri, 24 Jul 2026 14:39:08 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
Content-Language: en-US
In-Reply-To: <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: r3y744azjsgjga3xphbz36wnomg4msn5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC9F080004
X-HE-Tag: 1784900361-24510
X-HE-Meta: U2FsdGVkX1/EGBv1KmoF4t9n87q3rNcSMGAwL+ZV/JGIgnNWbP2YktwtKIKccXVHEFrU6t395LAOO1w0RSa+QHIcDHfTFecMK2r49R2gVv0Cw5OueBMg6l2Ozez5ov5aOvzvF71346CWM4isuGcUqgwX5PY9pZf3ZlrxDz86nIyguVRMeHrEV3ghRwYFn8mQRdYhCAkLNVMB1oETuvQ53FoyH3jPdptaYvug8aL6aqOM/v83Ngox1Nky10/NSWzEEOX/Aigw7jRjNVQginSbwAefZ7j4wdaINY3LKNeAQnPBUigExMbx1LNvt+2Rm8mnC2wnAq++G/7JbLzDt3bZTFkkPfthnRw2WUu8fn+3wzxin9R//gExWUxGbnh5+e6gQmWcJmbD/krRH84RhTUkTPp2bIem9jZeiBtqD51zBrO8ukeZijASN21DbGx0xfa6Y80/Pn5EtD5gjVGlkXUPuzj1glUtPAkWS3lcNg2MCP6jnPmxdgh9JN2d0gJ4eSdI6dahkObZsEN7ZThyvlHe166VoqKqR2ylTdDFb+F6b+2IdGYrg9J4iGV9N1SkVAMGQQ4AAGMY1CXFgIeec9frypq966H7x0h2K8asJqZMztlMXksJHWBs6bLTgSlpgUF9//gk/m1RJ2qRwlIwzwhfKT5FHYyb1ikdx1TsdYN98bYX5QJRap4cnyJdOYfj/M+C1eo8QTXxNRqtR4bfwyvK7/p8hxXcfxz0zvS3UfT9rJcl4QvM7dwHYErO8waKSriJ0ah1KcZ0YQ0Jl4Dq+d8hylpczHs0vREqkHC5Rf+vDYcaaD90LfHGlwQMSEebWjBcSDf3LJ7kO7ohsuGOMhQp3zy2jkdJNu6UAeXB7O8gDeOnlS7sSjf8YLbcZKIXPEBydhy+TNvC+7K40cZVVK/VUbrsAB1WRTkUryG42qi+PTupLeiYY+9zkDOuEmmKHmqdDnpGd4zlpST3TzhOY/r
 LwkOBUY7
 0gcdPm6gkGEEt71Ksr47ElLhlwgnx+zMSree6ZfaXWRhBlGm30eQpx2aRsLZKQMpovkEz6zeJ1MiYcv5eJt61VmG+s0KwWJedgGNHLrKQEsI4hK7oOMTEeGKloywIyeCmyFXGDIe6Br6Vsf4vXCen5Jf5i0EumixdsaQ32omuRXDTuEbF6wRSG58bhXyKXBKNP9QLgBABkuVn+x8rO2Rdx07qJlx/2XKGU7IwK7Vse3W2dxGj1kcnbmYAjWmSqup37wPlWsSgs4Eb9rS17yt2+FJX9lFCinnplZ7xRhW3RZ/ngCQ9WpndBXfbNLfEgjVl8el3EjumunxxCLhC7msoxO1WYXYkQRGUDhUwPWZwjSm32n0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 14:36, Usama Arif wrote:
> 
> 
> On 24/07/2026 11:20, Pedro Falcato wrote:
>> ptep_get() does not need write access to the PTE.
>>
>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>> ---
>>  arch/parisc/include/asm/pgtable.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> hmm I think you might break build bisectibility if
> you separate out the patches, you should squash patch 3 and 4,
> with patch 1.

* squash patch 2, 3 and 4 with patch 1.

