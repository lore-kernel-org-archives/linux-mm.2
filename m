Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08DBEB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0906D6B0088; Tue, 10 Mar 2026 06:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0483E6B0089; Tue, 10 Mar 2026 06:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC1546B008A; Tue, 10 Mar 2026 06:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D74F36B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:42:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CB4313B2E7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:42:56 +0000 (UTC)
X-FDA: 84529815552.25.042D1D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC56E1A000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:42:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMYZgNyO;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773139374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FN+TSPz+ltUzp9VbceUI7lOzqSaL3v1qzAWOwuafhg=;
	b=ZKuP1Fwortkj2hUdRB20aLIA4iwChwqxxt6bzamnwPmaV8PfvscU3OJuA1exR7RWu9QZaT
	w/vnIjLwEthLuyeuRs2NP3vF3mGHpx7reGbLjVYNwDoTio7rHWf7ZJG3dwjg7hLiiR1+cW
	2VZ4QFcNbBZDUeSbYyI3CVHYpCfWOxw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773139374; a=rsa-sha256;
	cv=none;
	b=rMxFjsvIy6+KtnPRSs67tD14zcYYFwxOdU1w0j7SAsITWtEyxj0JtYSOl2rtuKCyJUznwd
	IntW4tHN5G9qrjn4OdGn6onSAwdjfiME6bFqv9lgsr50QIYvmI7ySLAH2NAZaykRB+omwk
	2uqHpMYqQ0356+bsSVhP5hyJ6mDLRug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMYZgNyO;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16CAF600AE;
	Tue, 10 Mar 2026 10:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAC8C19423;
	Tue, 10 Mar 2026 10:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773139373;
	bh=3m4rwlvUFZd/0jBCZKj1ip7fgfW/CYTB+r1GS0xW8Zg=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=oMYZgNyO6Nw0x10/mkbxLbNa3w2PDuEiOMmiGOmxmWdsAOPsFzktLpRkbixkawRet
	 tj5YdvGt4sREgy8o/poBYWzHo4fTpp++pr5X2UMGlzKyJcO8Kg96Ns1yjhKZcd7txE
	 5EvJ6fTGwznHjJt6UprwMhfYioMNPBGVGqIg552QXnbdj/17cl6RZWlu6qMSpQI5f3
	 fLdCzn89uMtWTne6Wzrz92K8HderdBAcLDYXaxhjU2rrPCC8xYXawirkfsEz2sAUxV
	 Bw96P6McCBiZSVtvb2iwX4n2pJqHd42GbNC+AhmVlZYV+E4WHOf2LHjNboUFKYdqJn
	 gzzi3dYFxAlaA==
Message-ID: <d987d8a2-07b5-477c-9ca1-23eb7947768d@kernel.org>
Date: Tue, 10 Mar 2026 11:42:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
 <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
 <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
 <9172a09f-f014-4a76-b813-8f0c79fbe2f4@lucifer.local>
 <19fdac31-0d2e-4662-b3a4-02555d8e4221@kernel.org>
In-Reply-To: <19fdac31-0d2e-4662-b3a4-02555d8e4221@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC56E1A000B
X-Stat-Signature: 31fixzmzfwamr6thkdjg4uy6oqa19t4f
X-HE-Tag: 1773139374-572300
X-HE-Meta: U2FsdGVkX1/kTqtGSRJ+HWdERhXdnplUvP9v4DyOuBN9EFMIbz4X5VWi0s8bOVWnvqrWA8RzaPoNeW8rr5suO/6gW23urZSb1xXQXgKXfR75qwbgb0BWtTzTG0ZinUPztC05nZ8LXXPSD8rNyvS7egQuSnFxHCbcfczFVEsh3OJRg27AW0ZsNv7qyOJUlPP9mWYfZR0Gfbr0Tu2eUvcl5J7S8246LxQNbD8vFvoNneZUQ5pxvkoTpuqnWDFH62HXyTyJg5ZXyuXiMyhy/8hymS5h2FzO8elqOT9n1yTaN2dy75bGQNoczm4LdL1EudOZp5RhUvB62UVh0HZLYFxTjZdZpxJ9J0ei+8MxXe4dJ/n3nm34J558eq//l5le3Gq5d7Tog19rEMyd+ciQmmYCnZN7U9d062YKnroAmImNIZ4UA8/a2n2gOYEPB1y5dmRa6Vt44RvZfnIxPtZqzvDvvSROxsRi2t+LG4j7Dx6AcsjLgmRBWpa53/FNF60F/TPYFgGN3T4PdaRANNFC3RJwLdilv/YMMKuwbFPzSV4VmUF9vgWsVjRF8NndV5G7ys9tiiwmt9z63kFEaW94rFrKWwKqjeQkeN7/WoqDQXtgKWwMYbTRqQstpy64fesn0wfDnCHfNDCfJSMqFYNgDZEwvcFSLJ2o8lVramwodZsXOgiab/D6uz4PMysd7UGfYQUSrMXGKU+DOH5wLq5DovpNWEO6NabBV88dnxu7nUf8WedfXt38OD77y/e7f+4BUJEucrg/wC9rCJW4vTwmuMrqGA9yLiVJhUtTIou6tGSTUDuMfYGLgbsvs+IU2avrTwrHGY7DB7iyP3VdiURXXWKbvIvIlVowIRFohXl0W93YXbjYUJvDeEpBocAqscP4tw6OO3P/WrEtpCT+n6EA2pRYoAaGWmVhf8wiprW9HrEViylVxEgdkua2hJg3YH1cIPpLFvnqZtIqC9hhtLH5RIT
 e7O2Sfif
 Xm2FMwrzgRR/GcWe90qNqAvZMmoqZTESm9mmmjHRdLdlGH5qdI1Z5WABkvokxPWK9bHw8Wa9Uz6bLGiYscoxEr3GqmLFOapJu508EU/LzhtijEgiiQe5gZpd7LgAUL17P3/s3RBKba2H9N5DY5f61O/1kjP4KOsx4+a3GR+P9VAp31of9gJxIc8cTXEI9Ry2Jvqp6MLQ6pt4y1qS/05CSsDIpmKGCIHF/8eJauwktNGzjDsEJyWxmKs9FK9fPmz206tksgji8DdWSVr6pPjafhN4GXBboSYycegVd/wCzPXP14KPqVkNV4dMj3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 16:07, David Hildenbrand (Arm) wrote:
> On 3/9/26 14:42, Lorenzo Stoakes (Oracle) wrote:
>> On Fri, Mar 06, 2026 at 02:12:50PM +0100, David Hildenbrand (Arm) wrote:
>>> On 3/6/26 12:19, Lorenzo Stoakes (Oracle) wrote:
>>>>
>>>> Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
>>>> :P
>>>
>>> "--cc-cover" is apparently not the git default on my new machine.
>>>
>>> "See, I CCed you, I totally did not try to sneak something in. Oh, I
>>> messed up my tooling, stupid me ...". :)
>> 
>> ;)
>> 
>> Wasn't aware of that option actually, handy!
> 
> On my old setup I had a script that would, in addition, also CC anybody
> CC'ed on individual patches on the cover letter. Was quite useful for
> larger series where you don't want to spam people with unrelated patches.

I had such a script too.

> Still have to set that back up.

But now "b4 send" does that for me automatically. And I don't need to do a
"git format-patch" beforehand. It also does the equivalent of "--cc-cover".

