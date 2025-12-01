Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E28A0D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E006B0029; Mon,  1 Dec 2025 03:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5426B0062; Mon,  1 Dec 2025 03:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232446B007B; Mon,  1 Dec 2025 03:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9746B0029
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:59:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE9AA16018B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:59:57 +0000 (UTC)
X-FDA: 84170304834.22.7AA9116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id EAB4840008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:59:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUQnqU3I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764579596; a=rsa-sha256;
	cv=none;
	b=ii/Y7VTcoSGBUpOeUDNPasWJrps0lowuisZFM1XxqOe08TWRLUo3LXQZ2dUIMMpJUWWGvE
	QmWKN+bzuWztFSCFYdrLzKm26dfJ1U1Dup1qvf3Au40+cJQtdc5AwevLkl4Bu/lAa8UAFB
	Og8d8ZqcR1Q3+EXl9XI/QxdZ8TCzxbw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dUQnqU3I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764579596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xRHVsGXsAklwvyjQQK8Fd2Hk6gtYMtRi82oz16QcCI=;
	b=xss0FybcBwt62S2O+qzRr3ATMwMcranzjHBhwyHExydICEhMjENsZrm1H00LPcOwk8YjgV
	JM9YescFp2ZuZDdbacyXaATkz6GWjb0uW/C0xmHkXgSkDAZMn9vWFB56TTVgY2ZQzsSGl8
	VhAMzupb8YN0vsb/Tc2fHUUQLGDrOOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B00D444398;
	Mon,  1 Dec 2025 08:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190FFC4CEF1;
	Mon,  1 Dec 2025 08:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764579594;
	bh=XFnJpvWNqT0Iil1YFGSDXH4hktrbxLGtcmxxzhqoVxQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dUQnqU3IKLkudOiVLuuIXEmlc+kZnsIYDwkJW75j8OQM+SDFYy3x3JAijGlZ9NmO1
	 76Baw2b68fUlUApo91neXXzMCDpf8SmPOceJp0/whw9qYqhQlIjoCNOP+h6GQ2Eyn3
	 gM1FXpcgAUd6+Ge6UTQuLbuZEEv64px3Y9oEkQ2Pl6S3Lmm8kx6+v4617oh88WbiY8
	 NIUVCvEO+SnH6RefcuOpEeWbP1dL/44xfVtywyoAV+hEFu8OAWH+WSxXvjF6Fe3UFw
	 VtgGNpqb7MzdOSJ2XBwlvF1LWQtVzimiAEZSOcbQSV240B31+CipR8x8JMGtxLI3bp
	 Zi88BYx5W9X4w==
Message-ID: <3b1916a6-0883-4713-8334-17d3932fe3b9@kernel.org>
Date: Mon, 1 Dec 2025 09:59:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] mm: introduce VM_FAULT_UFFD_MINOR fault reason
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-4-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251130111812.699259-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EAB4840008
X-Stat-Signature: 6d5izk858f1krzaf1dehqk144zkisi5b
X-Rspam-User: 
X-HE-Tag: 1764579595-966539
X-HE-Meta: U2FsdGVkX1//aJLPe636Rs9ExCpKD34sMjZl2siVigVnq3L6mxszuhyOltju7JM7ORkF7lCrYef+vAXz0+FTICs0fCi1f1VQVSiUnq9qqz9Hk0K6JS3tzK8cteJcfwpzo0XVxGvmQS82ZARgGVhOgUlXszYN9ZJM5vd6Bv5cIPBJWG0d+95tVknxVExDdiyL5sObPw6Du+53l4KOhYCAh1IxjcZcQOnP3sM0ov79y7g4bcsz+1jDzkfWwhjds5YFcKhT5TgHUwXUujS/4ylOwHeeiQxLCi+IGrNmfh+ZbnDhMNB9YehGpyHiYI8mm5v+HEwTwf+Vs/Jf34eiBPj6g3IlbdWqgeBtQ/vDslOBqXa7wtfQfB8RTtw9DU9uQy0OsBwTLjXjqB1P8k0pw9NFPCO7E8YUshZlYEIKFRLi9ZScktN3qiC2Phyg406622w9/brhleViUa5Ql4QBl+OfB2YxrYgnuRdXo3TP1ziX2BMI8Si4J4NRT88zR1imCzbmQHbQH90G48PQU5+neNkhsRXcaphplwlHqEsZVY+ck5DWhnrkicflPUT8mQHkqvZyKfbtt75eGDiu5Q4pBd5OZyYQ+Au94f9RZxmjljnosDe2Yokv48biyzqQXSJfpmqhfNUULkmQVAeE5Is8Q43nqj1v4CT5W+SRPyOcX38JJGQyYBRyqRdEb7tPFrCICOrs9a0Rxok8hYz63zNdUG2/EVciSU5r5YiVbMOd6Sg2lETw96PK/koiXm8LhnEYx6qRjNKG+DIzZHjjoqswXDtmFd4mWeE8M1lv8Rp46FV/A9nlkuenL691hxHkJVn4Qy9zxYLWgFrDYtSvSXiOVf1L/P+qLNetRZWjKr0CwHKpeJZK1Wy1gykhVbqEP18LnLO/8EknND77KMJ306xOmxOfvOprsaKTCgLzFvlIREbKUdZTn2S72LNWLc4jOC288aBxkAFsZeCFTNav+s36yQV
 X7f2gCi3
 Inpr6eFZt1nmbD7sZ2XSnLdlvSmY/yzyzyWh48uIkEQ6isGuyaVf6oG2ZDYei4JjGoF8t9bQSFuFVcHUan+nJAstxPe5hy7lgW7RKgu7r4Vdz9njIENGPB23iMEt3uvKW2XrjNEAQYaWaos6wjYCyVgVd5K2Xli14i4CH9pTV5jGk56jctVAGX109TR38nXmyPy8lHVFToqRajgQlx0YIWQ07rAowPqw5mFpBWmB+VL6xWq9kQ2Eixq+fPYLB+hBXE7rzFSgqFUy0NBeig0qJlqpxAcBWZam1zCu3SvXZpTfzZD/0hOc+wQqRb3MCOCL8psm/xRDhZPpZmcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/30/25 12:18, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When a VMA is registered with userfaulfd in minor mode, its ->fault()
> method should check if a folio exists in the page cache and if yes
> ->fault() should call handle_userfault(VM_UFFD_MINOR).
> 
> Instead of calling handle_userfault() directly from a specific ->fault()
> implementation introduce new fault reason VM_FAULT_UFFD_MINOR that will
> notify the core page fault handler that it should call
> handle_userfaultfd(VM_UFFD_MINOR) to complete a page fault.
> 
> Replace a call to handle_userfault(VM_UFFD_MINOR) in shmem and use the
> new VM_FAULT_UFFD_MINOR there instead.
> 
> For configurations that don't enable CONFIG_USERFAULTFD,
> VM_FAULT_UFFD_MINOR is set to 0.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

LGTM and does not look too invasive for me.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

