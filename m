Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1704AF9D0EE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 18:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710586B0088; Tue, 14 Apr 2026 14:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8556B0089; Tue, 14 Apr 2026 14:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FE9E6B0092; Tue, 14 Apr 2026 14:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 519FE6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:15:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EAE75B3BF3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:15:42 +0000 (UTC)
X-FDA: 84657964524.16.9F98CCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 390F040003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:15:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=En1bHn1r;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776190541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fuie6dC9E2SAs59g/2pXQ54q1er6WVjTf6xzpZujU60=;
	b=nuG8ToGw6eAfw9A6KOAtqUuPQH7ZPBvsubhMJHg08bzaBh59lbNI+K9aXalbXjgtjjYd0/
	aogln+E5xRVS9MW/9xvu+cW9TrSRBbIn+LZGOw2GzTdW7PjcSvTl+z/3me9cpQVll6Ptwx
	fSfQ+GCABfI1EVTrfiCdxw3KcqQWsiU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=En1bHn1r;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776190541; a=rsa-sha256;
	cv=none;
	b=IsdhYTWzF3k1vrcbRtUL1LSBRDk+8ht091m2CKSjBZ18OWOUxfO1kXp0e7lyJu1GHixt7S
	b8bm+SzDzLawb5W3Ss1Xtpsd+AeAGDggO6tIkhrRVgLZ38CSNkRrHIA6t2OyEeUytwcSE1
	o02jCA3BtRgVPuy0xBP8tBpkKq4/jWk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 85874600AE;
	Tue, 14 Apr 2026 18:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D010CC2BCB4;
	Tue, 14 Apr 2026 18:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190540;
	bh=q0rUomqXSUV8ZGyZgbkZbpYJ8u2tAB/veX/90Uauzv4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=En1bHn1ry5NBVqC358619JwGCQlH+ElgApcKZ08XaIllICM/Byuv6aF8RKyb4kBGM
	 B1osRyNHagiELNjD3Us7OZjscR/L7cbrV7dVFJOZfu3ZkROpt3JLPxIjoSZACH298L
	 9u3ZdkTG+FCLKQYji01Sulz+2WgAHZHHvtbRAk5HFfEaRvyRNkIvawoy5KFgsL8Dh+
	 pT7b46v4MS8KNyiNIkM6rr12UK5Kc95QI49HeaGYHtwY7rVs0mYaFjcHpIFE9XLpPF
	 AAKVSO+6GdItulWWlD+cbLnHJXRSZ40CBYnNIFYqPX5QzQOf5hqtbAMpm7K2AoTkiK
	 2g/5N+V8MGtFA==
Message-ID: <6417587a-7e43-4615-9e2c-50a245842f59@kernel.org>
Date: Tue, 14 Apr 2026 20:15:31 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6125defb-3aa4-494c-abed-982be684f839@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6rzbb9gbg6doi14i3aes64bymanwh8tg
X-Rspamd-Queue-Id: 390F040003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776190541-867232
X-HE-Meta: U2FsdGVkX18WrZyMeaDTZzGw4JkWQr8LyV0/RY6c0D3vi6tuE5lv2gWmQ7hROnOyp/PnEa+ILCddkzKZrmN3OmESxCE8XXSeaISORdDWz1Pe4GwYLoilvI1iFyCiZquHX36IZK7lBec58m822yPnLFrSvWz4gNtLmcuQh4BVcYBQV5jRo9CEYsSEPxlEterFvbzzCjnoP48lYz0aztLqxld7naTiwoXFjKAomnwl89bu9AdKCAM/EI34aDSbWtWpu/15g3rs5F4Q9AmLst6LsRWd9A/dZnzjWX+2SSnEp9LiMuc7qFp9Ou8T2/zQKKbK2tyZ6iOFZZDUscum0i5+wYyCwomtk4iFyG2k4xgAOfUZvuW5vbqFldk8Ci177y0jCoecJMRUDAIULxqzg1ItGNTqELCzieAq4lFDRoxO1/L5b0S38Q6mx+gZaYCeA9pKNMF+FbSKoj7BgpyG5yyCwNC0bQiZNY/cEV9f5MaZXPvs4tLgEqRjKy2+2l5MyEycPHxJb+RTGwl7mCD6eFpln/MZVovzr5j5ni8WeIGWKAEpyCQFzzpKi5leuBLDK+ggFkqrPlrAjysr+GEA4crjQrmni+yhiovGuA2CEatjX6pG2GKBzF9ZEH0hmcmRlk+cEqiXA834aJcD7+l2JC/55f45fSzQWRiTh6GYbwFSZI33+taVTYrYZY3dmI1DiZCF5azkWVtU57HVK493qVNObauTs5NOrfZ3Pv34qSNbLqqMtd7UsI/Ld5UxBLF9Zku5wVe6K1r2lwQVlAKIr7KPXTPDko+R9pv8FfUF6B4PWooMVOhX9zlctWhnML2NuccwvN0dSBQ9CqvDtyyK5x4D1WO37a+ZSaTUh49dy+Xuetxz5W1DUXUdfLzrDB23XfrkFYKt7Xcuu+n0bDjcIWQYX3YraTlsqL4TX9cG7E/ziYooU3aAhAG0elpWTxDEmt8A51mh6JiO8tHbom/poRQ
 WiDQJNHD
 uXJGBFyrJJtR6pNyUD2ZqaRbXKRgMCKkl+YKHbMiaobA8Rb0rl4oiQE3xGLsnqf3ZObB5JBuaPmL9HPSvFTWRrVj77iQ16b6eBxhKrx1in/FrS58pS73n0KHcevNvCF9exs/ZOmo1WirWMqfajzUP0QQq6mSsCupSNLp/HtH/kJORSd12lVRrHSqzKtcZ92vixBIAQebUgKPgSS8DZ4DIvSg/aZUZF+wftHtCRyfVXkMZRbIL93IruHemVYWBZb6JaHuSl/2bkPzUpQP968lcGWEaJiioucIyNEyfDgbeu7aHc9BYc/qDsh1DvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 17:14, Yin Tirui wrote:
> On 4/14/26 17:44, David Hildenbrand (Arm) wrote:
>>
>> I mean, we need some indication to know also during folio splitting
>> whether we can just discard the PMD, as we can refault it later, or
>> whether we really have to install a PTE table.
>>
>> What if someone used remap_pfn_range() on some part of the VMA, and
>> faults on another part?
>>
>> Doesn't really work.
>>
>> Do we have users of remap_pfn_range() that have ->fault set? If not, we
>> should probably just disallow this combination.
> 
> I did a quick tree-wide grep:
> $ git grep -l "remap_pfn_range" | xargs grep -l "\.fault\s*="
> arch/powerpc/platforms/book3s/vas-api.c
> drivers/infiniband/hw/hfi1/file_ops.c
> drivers/uio/uio.c
> drivers/vfio/pci/vfio_pci_core.c
> fs/proc/vmcore.c
> security/selinux/selinuxfs.c
> 
> It turns out there are two users of this "hybrid" approach in the kernel:
> 1. fs/proc/vmcore.c: It pre-maps via remap_pfn_range() but registers
> mmap_vmcore_fault().
> 2. arch/powerpc/platforms/book3s/vas-api.c: It pre-maps via
> remap_pfn_range(), but registers vas_mmap_fault().
> 
>>
>> Then we know for sure whether something was installed through
>> remap_pfn_range() or through a fault handler.
>>
> 
> How would you suggest we proceed here?

How about we populate PMDs in remap_pfn_range() only if !fault?

Then, if we have !fault, we know that the PMD is from remap_pfn_range()
and has a disposed page table.

Would that work?

-- 
Cheers,

David

