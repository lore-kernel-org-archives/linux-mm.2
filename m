Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A105FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA086B0005; Tue, 28 Apr 2026 15:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAFF6B008A; Tue, 28 Apr 2026 15:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8998F6B008C; Tue, 28 Apr 2026 15:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 76F616B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:33:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D27814044B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:33:39 +0000 (UTC)
X-FDA: 84708964158.01.040E214
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1496516000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:33:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ8aABjZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777404818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdWcdkfbQtgOrK5kRPxuP1O1GqT9/q1+MX844+UNjXQ=;
	b=wwXacG2FvQ14mMVWMUq/6Ixl3rq9c0UUg2SnA6HDVmHR4IIty79+6yZ8XMuJcRMhhRH0yk
	7AvefJ7uv11OtudaXdCimSQzdI8tNzsUgc0uClbp6JQs+vEWpPoPapWQbc4cs+495kPpiS
	OloPf49xJUXBQNRLvsOh8ZtuLmHN6wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777404818; a=rsa-sha256;
	cv=none;
	b=M5I2SSlNdKKxwDv53iOLn17wehsT75JB+ne76ufPHpRm3h3SfuxI9bt1SOStdwAeE4/yy5
	wJL050rXACNfrsCXNPV4p4ys55xfHoyGadRhQUXzwYqD76w8LgWdAhhQ1tLDykl05YVbUp
	DJX7Ldw+Lze2w/d6BTIqrEhMXLtBN6o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ8aABjZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 669BA6111B;
	Tue, 28 Apr 2026 19:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94407C2BCAF;
	Tue, 28 Apr 2026 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777404817;
	bh=VLzZDlhUCjBp/Nb1caKL1anemS6oS0IdafC7tiw5lCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LZ8aABjZLZBoaIB3KNlFtnaAYmCmmIx6F9Ms4tI8qpSPUWLLveN5TmiQgm+48wZRW
	 J/BWRiGsWEeAOSgZ5JHuK+pffj68Ehj+5sqr8mfte2FL9CK47tt7A7sxB6u5au+b+f
	 EwsmzWuUg+o1u1Uq/O8YUysyqnSiSD5BsqaNzB5HANxwoIcTOmjHLyEy6zQBTSf04N
	 3zU/gZsZUZJc6KX5wSOn+4pcZnPAH5wtwIyxXombYbOY2VEyTEFfsoQYFVZw15Fum1
	 2PZFiVS9T8OPv7B9Imad5MJ6DdnCzt7ZpuzOwbpDwQEhPH73wT71V0Az1SPH7bKJjR
	 eJTN2+QmB5Mbg==
Message-ID: <da60cc10-53ae-4f09-948b-c8c9f42d822e@kernel.org>
Date: Tue, 28 Apr 2026 21:33:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org
Cc: kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
 rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
 rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
 peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
 stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
 aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
 djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <cca382ca-861e-4bfd-a628-45a5505b8b31@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cca382ca-861e-4bfd-a628-45a5505b8b31@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1496516000B
X-Stat-Signature: 3k67wikk9173munp1qd1scf1pw54skej
X-Rspam-User: 
X-HE-Tag: 1777404817-842252
X-HE-Meta: U2FsdGVkX1/PF43q440wSjs7ahs/9wForISjfUiyZKqCTvRA2HqyEp3D1WRtLE+eSbNaNcxIr3DYRHUfd0hiUw43Lx3z3LVb1O3j9AqDI4pJaEflexYAr55PSFsKHhBhiMMaNm20bXCBpr9AYcxiWbhW9X7OPbRh3zmaBF3T55Ckrgsq3ZVS2GD+cSvRnSOJR8QKX+4gvfCW8VplbpL6LFpqJcXppIr0MRvFqddb2uQOSEKkETEs1fjye8webXbGjdmnSxGdZ8FGOFUeG/b4VBeUOIH624xpLd9+wTgcrzIE1Yy1x1dpWDpSkFcnzc1s6rwII1U68lQx3LH9yeKR5b1H79H8KRU2yXmGcjIQtXjxhAwfA86ovfpI34tnSSrnJwkskCVfMdfAUuLA5Qq+9QXvwGI1mgSsqRXsu651X12kJkyU+OX3uJ4uirEJWBXmFEZEBG76VkV3x4r+AQESV1okSBFDiBYJXeMHFbEgAKczzX34Nk99Ebr1w/tUINBDHfl4tkLw042SfmTeOBHxNvWSQkM4VUA4wkbACUWV1bjRL/h9qDMkQdsyeqx2c3EoqdBr4qap4ocNjq7Aviz8d85sGRi4TIZO/1o3wR34joH4GLhWFjRCHMa+VljATQZfBD3tBxquuqpPvHWNA9I2Fjjn8xAfFwX+BMH3srZNVhcolxbQ0vclOdMM9uiIxqemM9ZYSj+zVsTepKFbwNeegvk9TP/3+fjb4Ta7JAkIKZtCwUGDVBRV/+8A+HcLMgsskvruhfm1tyvuhm1w5B86VDua7SR8vVxPIJYD+W9BKSy7Y6+L59Mo156fovBtokDR6LuKTW6dV3LRfdG0N/cuX7I1uCdUnodLUPHpPkX0C8KLWAcfDnvq7moGBP0DdJMxY+MF+uEEeHG+NFCJKBjqvFa2IwUkHwB0enRAwkVzqeyi6xMh1LFPcHLFRG/eYL2WhrH7hbi+Ad/UTBCdOzc
 W7P2uQje
 sbXXrqKZhN04/Vq6RTIY8TEs0UGuX3iz51PLHuJn/F6rMHE+eFyHwA19r2y9RXpRcS20v5sGZcz3a6VczXdIa2o5BVtvvy/ho5zpWJvgwiiwUkD+iRkXoR8Fjk63E9h3k9u+pRIgKIEO49vr6V147R3/yG9Y9fjTJq/UU4jig2esP5qQePbopwPZfvYSso6RxR+pUKwaLaPCIlRTnMftSyWtz/txIZlofpiuCoMLUjK4KFAhbMztJVVNJCGpSuJs8pDeYE5P95Q93fPecUb6OOoSB5o1AJ9eTEZH2QcspZjXd288Bp+dQmRUmFSojVgGJFSxvQxbClvfIkTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 19:11, Garg, Shivank wrote:
> Hi all,
> 
> Apologies. The subject prefix should have been [RFC PATCH v5 0/7].
> 
> This is the fifth RFC, as mentioned in the cover letter, but I
> missed the prefix while formatting the patches. Please treat this
> round as RFC v5.

Ever since I switched to b4 for patch management, the quality of my life improved :)

$ b4 prep -n SERIES -f mm/mm-unstable
$ b4 prep --set-prefixes RFC
... add patches
$ b4 prep --auto-to-cc
$ b4 prep --edit-cover
$ b4 send  --no-sign

-- 
Cheers,

David

