Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1253BC83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 05:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECDB8E0003; Wed, 23 Jul 2025 01:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD4F8E0001; Wed, 23 Jul 2025 01:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9D08E0003; Wed, 23 Jul 2025 01:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33D318E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:18:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81E26C053D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:18:44 +0000 (UTC)
X-FDA: 83694374568.25.F73B65F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D107CA0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:18:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aHux7sbx;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753247923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIwAGu7AmRiBwQj9SrVS95IAdlTnB4xCHhcoek4q+Dw=;
	b=lvyuRs4qAb4sYAP06i/GE3/40cv6hawIf8f3Oz6gsii2K1GPDEKvKuktmYlQQv4fLYbAYv
	286Q7XTVmMWJRNa+Wv1P7tdDtEIHMMMDxzzGfpgZcPPp5E6uMRjjVqUmVig2xbNCmiHvRv
	BImK2HuvW9FwyyYv/F6dcXYvwCSqg4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753247923; a=rsa-sha256;
	cv=none;
	b=ffsEdP78pDgOEBXcWt7E4GWeQsskt/I7MRDSUzJMSBcAaP0Grwi5at711mqTpzTuUP/+Ph
	i3k1viAr3D2NFuzAD1jt7LOZz9Ax3gODZyluOBPnCiu6bowL+eKKLmysdFfSO5YvaQI4Zb
	kpa37qcl1vGDJf5wQomM+F/FFwjGppc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aHux7sbx;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6409F44DDB;
	Wed, 23 Jul 2025 05:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236D7C4CEE7;
	Wed, 23 Jul 2025 05:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753247921;
	bh=kF4IPwhM4HYaC5OYAGkDsFkIDR4awcOTgIWQid4x2yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aHux7sbx11I7KG2xIMA7yFSf3JCpZ2HV6BNUYZXPxObtWAS2elBxr8Bg5BICdgMSr
	 ILbzPBLstH4OI/luBuwso9nu26oL8SmVUKOG7trO+/MhrP6TaEnl4MOa5X4RGpIP0t
	 zM82H15ER3b/5eNiWPfxN46UGqLV7RVXfKjgaExQ1vXTvyn7TY2cIRSfZjOE3r45wF
	 w3FuXqVMuDxHc4Ph/Phvpo4XgROKtRwbGTgjh9N3iBI837GC1EfpUHxNv7ZxbDo2bp
	 n7vMMJHon9yrSvCbrmjIlJSpofKaOw0w6ZXO+1aXAIWqd3QlYkCaU8xlHLMuPsWuf/
	 jgP4uQ8H/kfkg==
Date: Wed, 23 Jul 2025 08:18:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] MAINTAINERS: rename MM to MM MISC, add missing files
Message-ID: <aIBwqmITl1VyZp7S@kernel.org>
References: <20250722192704.164758-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722192704.164758-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: D107CA0002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 3ac8wba7qtjiisgmprktqszkeaqffnut
X-HE-Tag: 1753247922-782625
X-HE-Meta: U2FsdGVkX1+F8GToxo3QRwfpeWSKkcZEwJGhGE/AjjMA2olcBywAvscNJ20i+GOjt7QB/q62hqTdZYuanXkFOxVDpqxob1wMHwp/3YwlzqDngxRIgVJVzPuwaNiKx5Kn1kwIoyfLTLLgh3CFgifJN0vkwbixw9jt+4cnFfWeD4nGrUsWcXmYrArsZ1EFXPanMgsELON/MPHWIqaj/Lfulj+S6ZfhbIvQHXqGC2YlokU7+gZL9mpgM21oomHX0JyULwa1fb9L2lCvd8z4j87P7pSv8lpC0o8oZT3HNK1nyFyT3lLG5YBZj9KdKoeF51oKtDZYH1kKIZ3u2dwZDJtnVK1Rc5w3Hz4meZ7eGaC0j91YyRz5qCSuHQ4t83jtVK/W728LrL85hXX7D7Y3yQJc9HaO303bTPBRnjVVpXCih1qYLWqg8lKFfrleCerp4aexxr68SohR0PTysC564HdmHRIODo9zAgAWP6iz1n2ApQ61rfBeBRcR947IqbZhoJ/E94nQg8DUzXKUocI1HkWdeAUgY7Euez/DnxOwm9zsC/njH/hcOV0CjBthIE+FUrFp57fRmrZVB6sOp83qzWg9KztvgwaRLiLflmV6Dna86Hm8/uH8YO6pnvj1Qbxd7FLU82AjCRCr3x73aO+KiBn05aC24gFv+HH0j933gZAHfftwsv9Nq1OaaoNTK61SfQo7n+w3ccSQKr2TmvpxoPyT87GAFTJJl8XyHbh9HAE60PokdDtl6dSDK27qdkM9lXCqCU1PyYx1OzgDkK6evxpBybEg7/lteS6dmtAvC497rZ4brR7/Kql0GBKEgssvSa0yNMBqEtDL51uwDmlDQe28y3IbECqU2zL+THKBHjZaTv548qsp8CVPXJdRBStw8EJvo7u0zMSDvCu3u68dNzVKNlIgjtmuFAaF9LWOSgqqp4AuQjwKUi/wpvWPnZIZXNDPlPy1cQlBKWEVcEuu85n
 pqpJKawz
 jVbbyqvdFLTVXw+qZiZtdXanKUVBL4PytMFRNHLr6+rQJcU5FbHeFg/pVPLW/BaNW6bwC+V2eCCb+ImHZzM6P3yZzle830mbEKCE5YJqciYMsP4xyRxVJwIMcuzziCbbsLyFD8irdjRZG+gU1oUCB4zQFhnkowzx4UHE3dZvcI9bwr543ZMZof+fKmUgD+KEuCZXuIh5rXIzsi0cbKFrP7J5QMkowlmCVUlPI9W1oEfOiLOzjjG1AZSSRV/9wNDb2p9cKS10hjRewBu7iCw0CxgowDsRn0Uup/UGk76+uV3aMNwA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 08:27:04PM +0100, Lorenzo Stoakes wrote:
> To fit in with other sections within MAINTAINERS for memory management
> files, rename the MEMORY MANAGEMENT section to MEMORY MANAGEMENT - MISC to
> contain files that are not described by other sections.
> 
> We also add missing files to MEMORY MANAGEMENT - MISC and MEMORY MANAGEMENT
> - CORE sections.
> 
> Move over appropriate files to the core section, and in both sections add
> remaining missing files. At this point, with the other recent MAINTAINERS
> changes, this should now mean that every memory management-related file has
> a section and assigned maintainers/reviewers.
> 
> For the time being, we maintain catch-all mm/ and tools/mm/ entries for MM
> - MISC, though in future we may wish to remove these to make it obvious
> when files don't have assigned entries.
> 
> Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
> CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
> related for this to be sensible.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

