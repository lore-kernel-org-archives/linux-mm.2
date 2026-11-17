Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43568606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NVBqlWC1
Received: by kanga.kvack.org (Postfix)
	id 5DC686B05B0; Tue, 17 Nov 2026 16:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4766B05B1; Tue, 17 Nov 2026 16:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBBC6B05B2; Tue, 17 Nov 2026 16:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7C46B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:49:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5C501A0577
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:49:58 +0000 (UTC)
X-FDA: 85445954076.03.346FFBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D138240004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:49:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVBqlWC1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXE0D+8kWfYIVXIXnCUrO9YjBexR7cGSOZwGsQoKqqo=;
	b=kzBuhnHp5/QflKoiBsKdMAbcL9U751qcnx+EDE36GIF9MLJHpsmoZ+/K+P9ZNI7A7SY7Fo
	jbMEpRHHtOrVb3dXPcQFtP4ShVjjLEhsO6+UjUH0u7LqiBVLjKXmbiB/XwFjgrdHW8OMHg
	8l1Lfd6WZs9ZyHQ0k5jfAwy/ygE4Zag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVBqlWC1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794952197;
	b=b/VqrpoLzktK1OmvPOkOpcX1lUc7+CTy5fRubJAp7tyWUKSh4CW/CNVbBpjgvOr1IO99/s
	//r77mlGSdSp6r5MP0MyCW9MPGA4POXFJpVfaiDSawOzPtophJZcpzQ9cUhchf2iD6fwXw
	kczfBHTr3jGUeokpskmfUZhn7/g+3IU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36BCD618DD;
	Tue, 17 Nov 2026 21:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B261C1F000C5;
	Tue, 17 Nov 2026 21:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794952195;
	bh=hXE0D+8kWfYIVXIXnCUrO9YjBexR7cGSOZwGsQoKqqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NVBqlWC1Ow1rAtVPhZ7hVTfDp9ZLQcfY8I9DQP4w0h3DospTnLHkxOWr7k2lWkZMP
	 twbkFgvkPK3qDjtjXYNcvL/Nlk6RnhXZHMjr/bDnpE/sFqlAYkXXDPnCl6SSa+FTm6
	 IV6m0si2RajVtN90JkyrGWy6L5Gm7krPBmjWlAwHhH3u5FxWqjXBd2JxHC+1JFID6m
	 rNQDWcx0bWzUPkbvXTqoM2X4DAIqODEep8nJ/RbmVa0fiKgeuhW7mcFHXcDRmELH0Z
	 6WvWzEh5K2KlVPreV+eiFXjTv4ZER7BEGEL2jVoFibuZ2unFTvM4HHnwUHXINjOmmc
	 eKv3aicus8DgQ==
Message-ID: <9514b491-ce2b-41e1-b1c7-066855ed6fd7@kernel.org>
Date: Tue, 17 Nov 2026 22:49:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] mm/huge_memory: copy PMDs at fork like the PTE
 path does
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D138240004
X-Rspam-User: 
X-Stat-Signature: 1h9bfijfjh48je6hr9ibjh7p7jni7ecb
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794952196-52377
X-HE-Meta: U2FsdGVkX1/QD16jD7hxkHzsL34Wrxm7h5jWFapiIXoF3k5tMK9W+EiJ18qqlaPKzPc5+q/zbvz/yLHooqwOO8+1E5RUFXZLWW6cavbOB5wVdX/+rEWSE9XdzXi1MIIkNjLo6D1baDlw0xKrxC1/8H5ge+tw0StxGo+ns5ZGJrAgovL1+5Jz0FnoAS2EOydtxuVgD+v85hGwoD9voEFo3oNWJwykYvEnCPRRrw7A2EXwWTjZtQ+x5zRp9Ida/w92KvvyTHVYVqu881xQosram2xFRX6mbAOaHMu3PWgiiT16PywgDXNezReBabgktrgY9O5/CAT+X6bNSPEE3IHq88/8EmadzgnfiV1Je+9gyb1XrH7R1w6NRXjHdwbBM41Fttj+PPKYYaxC4hskGp0XasyjpdyL1xxDWvPLmxqrXwF4evkmEWEGr7yIgkqdzX4IvaEPJ6KiaHKgZDCbQ+zETHij2f6V6zAO8K3bP1UdankkSU6LD2aXVHuqyAqPAWg3GYq0dshSnbJ3iHFfZGIyAUkEUoavTjVD0ZlCUtCHn6pIO4nNw+BmKOC+XGBjBwGZ40Ob+sQdrwXlE+TMhdXFwqMoQqFLyEiQrWj1C+BlzE9FFXOpONDxFaVyMQFD+WQ7VdhXaBdaWZ0lAUkMr8Kw/Wg5t1ogn3dP1IkzTd7PyTOuLb/1PpVKZ9cnorki4V310AX7hrnWlWoBaOB+T6gm20vQJ67XTfbWPnNFjjH98OZCgOnm6yFB3jfaJMuzyv+qpE8ovoiKO0eWVwNJz0gLM+8pC5IzRnjHz4Sguy9cH1KdrT26wnzzYpama4aTGd/nYdu/DOZcLI2B56fTSzRY2xxiy7MNRACJqVTMS2XyIHOGF50ESGvKSwwQUWnPgKt0+G90Ym7fZymYDKi618xhfs+ppxZvOs725XA/PHVDP6eB3SF8rrt/DFxIKNrJetgblhULRJiXz2k1wDElxI8
 QBJGcz2z
 pq+ycHA+KePzTe9eGb+kFczr4J0KWO50/DJytRdrPva88pEDPJ9jfUgqaIdo/t5/0QOnhOfgdOViS4F73QbdaeJOm/c8CjKbpb7OnSRLTIG4sszCbHe5a8OF/hP+NoyGvnsgP7q5VjZ3LjbhLO/s2RICx1unCaQdMIC8GzZ/fNYtnV2kMA81IODsr1lZL+rkSMYcjtrJEDfNbPjMsy0pF+lEC50FE3PzwHJSComLPMcX+rq3Wjm/AhE9xwErbmoBfJMMZvfE9765uCiTBYLw3cj8ZpAvHnO4Ff4pKeGqhdmDGicN5+9U6SpxmUziJIyj++l98ojJkQqCl0esGOGgZDkmjXsLDM3bpXiYin/blrIMnwbJnCdVTs9vA+dOJxSTkbP/5g+gFa+3483OqfzgFPrNfTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 21:40, Konstantin Khorenko wrote:
> copy_huge_pmd() decides what to copy at fork by its own rules, apart
> from copy_present_ptes(): a lockless check for special PMDs, and a skip
> of every file THP. Following David's review of v3, this series makes it
> decide the way the PTE path does, under the page table lock, with
> vm_normal_page_pmd(). That fixes the two bugs v1-v3 were about. The
> patches:
> 
> 1. folio_dup_file_rmap_pmd() duplicated a PMD mapping as HPAGE_PMD_NR
>    PTE mappings. It had no caller until patch 2.
> 2. File THPs are copied at fork instead of being refaulted by the
>    child, as their PTEs would be.
> 3. The special-PMD read moves under the lock. That closes the race with
>    a driver zap (vfio-pci, panthor) and the missing page table deposit
>    on ppc64 hash that Sashiko found in v1.
> 4. A selftest for 1 and 2.
> 

Okay, the refcount overflow patches are now upstream.

Can you rebase against

	git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next

and resend?

Thanks!

-- 
Cheers,

David

