Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99822F43857
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F328B6B0005; Wed, 15 Apr 2026 12:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3B86B0088; Wed, 15 Apr 2026 12:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2926B0089; Wed, 15 Apr 2026 12:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC68F6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:06:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F1B81403E1
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:06:31 +0000 (UTC)
X-FDA: 84661267782.28.792977D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id CCC031C0007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:06:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LayR2o4i;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776269189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=volIntgCytMyyz9CGQVY0aKWzemt3fNYnxr7susioHg=;
	b=bBsyZ0SzEo/saptBL0TRzvZIiBKClSfz2ezd/ec4qkt7O5P1O0BGIl+wJYz/JpNBbGpX5L
	LrB9hiMM+Fxp3rBDPG91lrnQnSBVypVngXq1Z0mgRoFZx9oX9J+5M9YWWE12PiVssG0PzH
	gPEkWNMyFz/iQ+e/h50ykjihjl7sqvI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LayR2o4i;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776269189; a=rsa-sha256;
	cv=none;
	b=j9LJg5vNlH7IknuusXV9uPMFAUXI+5s83qPEqoX2rNPB6QrjDXQNc6Kl181Kv4zObSFlKz
	zsl2EZ14IQOYE5jKIx6e7wLEniVrUm3RXpQC5kzsFIkAmg9a3IdCktm/9K2cpNiYrYq5cL
	vrDgRb4v66TrLKQHOWXIckEQjPkGUlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2175560126;
	Wed, 15 Apr 2026 16:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68251C19424;
	Wed, 15 Apr 2026 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776269188;
	bh=pP5qF55v4T/UO8xfVPhdQ1Q8GyZ5nL/NH5kww4BEids=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LayR2o4ifNIJdDeSe2KzWJZrtOP1YP62HtJ+BrYGKck8hYnArzshH1pgYHK34Ds2D
	 1Is039hXefQaHBWah6+dNXT3fbxJ0yX8UusyU/VsacfhFxzllgDz8bPLHZNvwj/Rq5
	 QsWAl5I/ecqEMwIAzhsXNCZ7nDcMZyRBXg4X6Xf+KvT9/rcxvTQSqjb/qslXCMo+eN
	 LPegkRVn6tD8yhspc6hEwbXbLaIoEBZW/yNpWZAN5GjDLoOEEViEz+8GbfJizn+VbV
	 YqGPD+o5k/4FeQkfGWxbjtqwTixF/d8ZvC6kdvKidGwI9aZKWeMMo84UQDxsrxJJlU
	 w8JLvd1NhnUow==
Message-ID: <4993bd8e-427a-47b4-894b-d003d6717909@kernel.org>
Date: Wed, 15 Apr 2026 18:06:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
To: Yin Tirui <yintirui@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <41b1ff54-c120-42ae-8b74-54767abf3554@gmail.com>
 <fe357495-2e45-443a-93b4-52bf21d3bdff@lucifer.local>
 <c6748ac8-6dcf-41b5-a281-2f21069b1f2e@gmail.com> <adTb6_xqQoQqK74Q@lucifer>
 <2f29f66b-46db-4925-b922-4add61b633bf@gmail.com>
 <53d748d3-4150-4e7b-8c1f-4c58587e9183@kernel.org>
 <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
 <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
 <f7f26a91-5346-40d6-aee3-3b64c3249ac4@gmail.com>
 <6edde1e9-0f42-4dae-b0d1-3f2895f2111b@kernel.org>
 <2987ed25-bba1-4218-a776-0bb98aa87bbc@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2987ed25-bba1-4218-a776-0bb98aa87bbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w7doz9dsdda71dnsdu61gqh45pcyqj4s
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCC031C0007
X-HE-Tag: 1776269189-822670
X-HE-Meta: U2FsdGVkX18l62Ae+J43WhVa1JlWbpz0F1CvbsbGAvSO9WoERAcL+8fMQO4fKDB5C8Imxv0ic6RLG27Bwi14KfeRmIXEXhffu+8RstiDxtTIgblYAA/LRPGmAzQCKoHOybhi3sSbxk+olQKaFDukzrxp8s7DgPET1SBQzgh+t8JexSasDHAQbl1zSwO9a+7IjQZOIrsed7fegGZyvTrJUJ70LbofQvSoM4EghPyb/PN2orC0DppEz2VuZRo8FuuLUZvqFxwXq2h9Jmz1ZqXrkaa+fBXEfQcpbdCwShD4iqP4SKBncqdJdKtYqtxNdYII5m1j/Zv3LnJ+LWXcGwfSVN5s1/EjliAnu/6hsECmgDJSqsnT086FFY1pQ5XTyaBtUjTYzXbH0TqaUzDpOli+uLli2bD2M3GSRGu1/NflWzA8vQRPLL7ozzwfprzfzi9FhXWJPMOlFKoe31xDd7VIdw5y04TdhyDu3VfTRDQFgrC6IvSRn28+lAOd9Vdp0CFC7w46LM2OKCgtKlX1upj/KNSBZRfzE7Na7dC6CYWe2XX/BRU4l+Uc1HGQaoLEj2nzc9EA6wgXKvq0DkU0w0PuHn/2qh+QZzH/cJyXqM2yCrfGO/7sjiHZv6/5sIbEpcZJMyymilPY88vIohTrNqdKKpvk+Why+vc475lzDVVcpGZcZJSQQaPuPVv+2oqDLKJ1Df7JlkiNhFW1vgjg+mk3tiAeXdv+p2BSfkNIbjBFtJ493MU3o240h7vyNEVILWSFS0/RcyDkJx+0XBiLLxl0zL2yYjmshy2vHni1tXKP4mgnMnTBtfcMr3D3Y4DhrlHcW8d21jT4jAnfcUE/mQGQDjvd2rzQ8cYjPVIDmEw1yda8POJRlmnm8RmUth8iHbEfpcTmUgFKJKw97VzXolLiQCqrrduvQskA6vdKl8RWl0FqjGXvHHXnMAheRZpWpV+bAQGiH1NmUs5UJr6DU0j
 uFII9af4
 F7RWZZC7pQBUpHCGM9gggmQzFEoy8jXfGZVJopg6OIC8lQN2MGW0YWDYgsQWzHQQw0FDQY7GKJALD4/m1ZtscGMASo5aw868YFR8f+nvG7WAR4uR92O3rDMRx6eP3s/YerK5h4S0Q/F+KlQjrkRoXBHgm4P+6NbikzDJdw0Ljp0vjjboE9+UANv7TJpJt78amMCZziblP8LbvmZ812r3oPuD0PwdZhLhd+aOvpbByAvIFumuwfZhD/pYNykE439zQ8KRtr7HwaPRMwLv/NjvoM2Jmc0mFE+Vg/GifyDvH3e2nnr9YMA3xxT+ky6FnIvd/AWxTP0LKVnahHiWRzQQ87n1pjH81XJWkYsOkrKW2gyRUF3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> Then, when we encounter a huge PMD, we know for sure whether it was
>>> installed through remap_pfn_range() (needs a deposited pgtable) or
>>> ->huge_fault() (no deposit needed, can be refaulted).
>>>
>>> So for Lorenzo's `has_deposited_pgtable()` helper, we could simply use:
>>>
>>>     /* Huge PFN map without a huge_fault handler must deposit */
>>>     if (vma_test(vma, VMA_PFNMAP_BIT))
>>>         return !vma->vm_ops || !vma->vm_ops->huge_fault;
>> As mentioned above, also considering vma->vm_ops->fault;
> 
> 
> Will do.


Please make sure to wrap such a check in a well named and good
documented helper function :)


-- 
Cheers,

David

