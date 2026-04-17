Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DE6F43693
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 11:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9636B00E3; Fri, 17 Apr 2026 07:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A266B00E5; Fri, 17 Apr 2026 07:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232296B00E6; Fri, 17 Apr 2026 07:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D70D6B00E3
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:51:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4C9C140136
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:51:01 +0000 (UTC)
X-FDA: 84667881522.19.14DD8C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D974440009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:50:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlAhKPap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776426660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4l2c19gVfa4+m/q0X3jHxVArR0avNpCxQB7TlMcoOrg=;
	b=PHsIoRxr/oM/YVmLnEMh2dCPbq2yxKSiUh4H0iwDF33A4N7BozPZ027hiBXhFYN3cv1SkD
	8j+Sg59Nt26L7GNfVv4WnpVCoFaKIZK2oBpGnWe4elbEWtKInq3hfUyQCbKkbwt+YqjnmO
	XPqAqoIyE3SbbxkVnpNZltoj/RH7sCw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlAhKPap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776426660; a=rsa-sha256;
	cv=none;
	b=KwDem7+/Jjbk3w8J6dK9w6Cih081f0hMIRUrFQo0xiBHPJ1kwkc6CH2QJxEEQh10QP0VuL
	4ImIj3QfJvmaFhx3Wj+LZRUOkc1zCi/DLrZQRWhObexgedYdBieIu6sbxgTmBS34Jgokrz
	YFk365PQDjIwW9E/kTeck7JfakLjmbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC875441CE;
	Fri, 17 Apr 2026 11:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F00C19425;
	Fri, 17 Apr 2026 11:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776426658;
	bh=eChbAgykxjX0W5rYjX38q+EpgtcI2CThnTHQSgO+2C8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SlAhKPapXV3MGVCHn44BXiJ4tHz78BdMc1lyfrOGcjqzwRPmD1Hc3rHm7p1TxaBRk
	 PQ++dEY3fDb7DCQ4mUa5IvWEqtKLP31N60Ysd2Tt2gAY2LsLyw9MpSp02SY3733zLd
	 MZko1FyQgkrc2bADXrdz8I92E3NKO02cC+yBAXrQVng6/zVdCc4yX4CpJYZsxv1J5Q
	 WRFHqWyBUZvKeZA5Ipu35Yc3XiFyjNj1QLXDIya+la75QzfBjJosdmznj0Z0pTgt5y
	 Wgd8VPKql4RexoTD3gyzmSul528C3LMQKtqg2Vc+Ns0eke9xlBVII8I1VgjrehhiQM
	 g9agWd2ZFrkkA==
Message-ID: <2c0f57b1-7a4f-4e50-9d7f-6b96c0f73796@kernel.org>
Date: Fri, 17 Apr 2026 13:50:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap_flush()
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-3-ziy@nvidia.com>
 <10aadfeb-86c6-47b2-b6ab-b86657aafb88@kernel.org>
 <842D3AD2-32A0-41E1-AC09-08EC793EAF7F@nvidia.com>
 <C83282EC-F3C3-44FB-A8A4-615F67F9CEEC@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <C83282EC-F3C3-44FB-A8A4-615F67F9CEEC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D974440009
X-Stat-Signature: mjwisj7ucdhi4u7c3e8ygdxu496qksu3
X-Rspam-User: 
X-HE-Tag: 1776426659-321850
X-HE-Meta: U2FsdGVkX1/8EnbO9LvUEXA91DomoHcXITqfXmWP0J+SBdsE/44binQCrfN9ofExJAmVMqbl1XAa3Ljw629iQE9w1n0CqOXN7fKcOaPCzbm/Toebj1cpLcreb9Q2ZMGYJzEvPlncJ8N9M8VaTl9qJwWLkZ9kK4Dk50CPw6hAhhRaBm0BPiMGtUQWL6hNFoRX+TF0iKBbKe5xwzrYgKYIwr5TgTc5wTIDFcq8VYPqIVzwBGsRbkyuGy1AJ4oeb5NDZ9PV71PAT2S+Qn1uR68iaWW8VPBngKdkkK5jDkjUybUuLROCQuWRxrRciLj6cM2yph4W2GldFUFK8zfyYD3Dsgv7imCZllqse3IiCb5LNnxNNBT/Ibjxj1nbTTnzC3o9VGhOawsEdO7FS3f5zq2cbKFvFnGRHF+ZZ5RUbYXx1OjxrTaAsI7wbT585MLTrCIKK6bkz25mozZxIGXJHnZzXMD+/jAQCEWG216rQAtLy84pRowMNhEzaKxfsRPHHazCDfqO7T4DAh9BikLv5gmaZqHi/Pb9h5WXNgfX7bajevY+61BxBSzI6yWi3xRqfLnbrcGZSXDDPXMdMSKQpjgm4UGGyl28Leu9DMu7GX/A5itzud/vaXqELyZH0HrfI7UG7bDMVommO78F+1frn36pyKSCsIT0CURvTfo4CY/3GEAfenrbfzcjE8QFxzCOk8oOLmUqKwMDjD4uX4PzaDMV1bM0LMRzTYG7MYqFRkcNChutG6Qmb2TlmbLqnwp/AMQhmZGPVlMaMcVXrIOXr6/Ca2uKLP2pvVyyRBV3ZXHdQB91iZIhRK3toHYlw9Sky9JC5CwITiQlH6JspwIeLndTxRDlXAXqigFCwRIO5VDVIzlRrh/ciRBvIbWw4sdHrfzPMYIHNwoR9cNKFQ6yURDlNtI/fRMka9kt2CHHUVwM8pFTlTsiNhCUTqe5sbXNUDP2TLoMzKKFIIYd+maG8Qx
 2/EdZRkj
 xsk56Ct6j08p5bUXGKoDBpBzCOn4ZHdx3ajWXU7fcjmIEhjAvbq+j5X6GxTICawiLvt7yhTIQ5V7vFFA7EhP1GUPBtFkcf4/daJ+kXZwHtlW4sWSaXmowNUGcf2yC62PN93wkHQJ52I4Lx8+NfqkIjK5dopDh0NlnqOzDqrBPEmnB0GW/nhoD/vqiDoLv2ZtyDZAnYrMR6Z+7KHUw4rLLa+E8db7zYUqPpII2kJ6pSozsjUo+rqlWYVjMoW8C0zxaOWCuVAzAdo381KmolL5aMyVa/5T3nGQnexB/PxPByy3A1962XXD2Immpsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 04:09, Zi Yan wrote:
> On 14 Apr 2026, at 11:55, Zi Yan wrote:
> 
>> On 14 Apr 2026, at 6:38, David Hildenbrand (Arm) wrote:
>>
>>>
>>> maybe simplify to "folios, since that would require taking the folio lock first."
>>
>> Sure.
>>
>>>
>>>
>>>
>>> IIRC, after successful try_to_unmap() the PTE dirty bit would be synced to the
>>> folio. That's what you care about, not about any stale TLB entries.
>>
>> Right. I missed the PTE dirty bit to folio dirtiness part.
>>
>>>
>>> The important part is that the
>>>
>>> So can't we simply test for dirty folios after the refcount check (where
>>> we made sure the folio is no longer mapped)?
>>>
>>
>> I think so.
> 
> After more thoughts, this still works but the reasoning is more complicated.
> 
> After try_to_unmap(), PTE dirty bit is transferred to folio dirty flag if exists.
> The code bails out if the folio is dirty. A clean folio means the removed
> PTEs were clean, thus TLB entries caching these PTEs have dirty bit not set.

Right.

> Any write to the folio after try_to_unmap() causes a page table walk and
> a page fault due to invalid PTEs, and they cannot proceed since collapse_file()
> is holding the folio lock. 

Right.

> As a result, we can skip marking folio dirty
> after the collapse.

Exactly.

> 
> If we allow a dirty folio after try_to_unmap(), we need to mark the folio dirty
> after the collapse like shmem. And a potential optimization is that we only
> mark the after-collapse folio dirty if any old folio is dirty after try_to_unmap().

That was my thinking as well, but it would be something we'd try to
handle separately.

Folios that are under writeback cannot be collapsed IIUC.

-- 
Cheers,

David

