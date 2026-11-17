Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FA9606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jH9Lu/TL
Received: by kanga.kvack.org (Postfix)
	id BDFA86B05B8; Tue, 17 Nov 2026 16:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B699D6B05B9; Tue, 17 Nov 2026 16:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B746B05BA; Tue, 17 Nov 2026 16:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677C56B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:37:25 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E12CF140571
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:37:24 +0000 (UTC)
X-FDA: 85445922408.16.3A61515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 257F720007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:37:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jH9Lu/TL";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u97xZXfl9UmG2YPsneqUJYX7Gb/4wM5PkwFNw/mpsHw=;
	b=RRBrjVXQtxNcbWE6+JbKWCwFGJS2nL9jJKovFnXRHL0CvvV5Vv7G0xPpcppqFwnWsrelFE
	3zK8eVppZ6B7xBvewnawiHwx9QGgQTR4Nedn418l4flLn1U8cYI/kInBMURwa8dmle7QsY
	nUocU1Je9IumZ9mNJZmX1L/ACwh5aU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951443;
	b=JBUPTkYo/3Eo1sROsdN35dBkH/gJlMdWeOttjMQW+WSl0VJozMI1n/3RsA2eZMbqoqhQLy
	9onUs47qDZ4IomcS5Pne07bAxAJyO8iqe6mtb6ERnCSgPMZ+BVr+vZpt+wlEqWL3C6yHwK
	34+Wy5dXiUuYSyCodK/txU3cAMu1ac4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jH9Lu/TL";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8436E60622;
	Tue, 17 Nov 2026 21:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4172A1F000C4;
	Tue, 17 Nov 2026 21:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951442;
	bh=u97xZXfl9UmG2YPsneqUJYX7Gb/4wM5PkwFNw/mpsHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jH9Lu/TLPfmDezgyPU8ezC3zehjSfy5TNxfaFlj1tRg9bo40bQJHLjV3yRnmCZMJK
	 yEm3fMXSf9VCFpD0wJ+1dAdIYGWT+OqSF1PNphrAqGxSnokeC78RVeHT0ZbAgBHhsc
	 vhvQGgVaDqoxZc3dlzXUBtmpeZzgsdLVbBzdGw19xI1ZCsYMOJSnUOa9OhEFqxncNn
	 777FU9hupsscXuD6Gn7cw//A/nMiS+PN1pDViqfLpNnrHvJJfdsRNPe1r2+bwgKKcG
	 hriJAHVzFNaez2P1yYomDBm3O08goFxcYcCaYRm88uXpT1iIx5gV7fpzRUK9CcQHHq
	 6CbLqAIoF7UAQ==
Message-ID: <817f3ce2-8b49-4cee-810c-9cebe742ccf2@kernel.org>
Date: Tue, 17 Nov 2026 22:37:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/userfaultfd: prevent poison marker loss
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Peter Xu <peterx@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-b4-uffd_marker_loss-v2-1-0fe9c5d1b43a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3aha6nqodyjzm89tgttfty1o1wxxzhkq
X-Rspam-User: 
X-Rspamd-Queue-Id: 257F720007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794951442-663485
X-HE-Meta: U2FsdGVkX19CT7tIY9/OAEfQexAl3kP6fj/vtQVTv8stv30OSMKmg4701RjT8LOtPYr4g7GIAI6rffCodAZvWy6Oi2YTiHBOGTZosMs2q0VxkqSBRt8JBOfizHH73+KsiAOQWmZE9tpxv+GSfkgK1wN1yu1NfY9l2eChE2kyJKxpWSZIsDbenvdKwnc8ASTlr+Eu802KIcTdg5pJ0oWdGvNAApoN+Udh5k/lSmG5m4XIw7f3b/F65PDEB92EQFMVVRJ2hQd/SyZNz7BXYH1vJO3y1ElFNsAWXMBocRDovJ8PqAT/Y1O0qjSGitSNwVYwaenGQQjSmbV065QJfKgs0O1fx2Kpew7/tLOJG1k74NxP6E+3tMw1ak7LzG5XyAQ8gW/lGYbAI3FisIs4HlclK2dY0em2V8lelvYBMRSKzROaGZtGKZVaE0yw0NfyFhOUnx2VnkCuM/y4B2mjKu3kwUkKefP92LWlfmGkHDCJQtj7BMubG3w7arElzLnb97LMKamza45nW0zq4thD2RpN2Yec04sjhC23Hd1SU/Smt3l6Ciyv/xlWEg7jsrhON8Tt0aRkj/RNca81K0KmgxsF/IdLQcDfl5087GkaL26IFf9LMjtxr2Mfn/3kg13f9zOeFVnw3XBxGZO6A06tcxEQKNCfCQCdjt6pJjruTS6UqkmUKlxsfO0OwtZcbf2cLv2TPwBIfA+zbjznm6Nj0gU1zvQtisrcKKtZpRc2UqRlQh6jDJ3Id4jZpDLHgSdHaW24sK7EOpsRjjMusFeM0kf/KMoYNX9kAw7hm97gx90TCgoRJq28FhyQk/Ezw3X9myF9YkLd5mZLDR99qYQpWEJ3H9eYdORLPRvIWafBnFWq8qAh2rEB/XV5bIvBZk0phMSwyBx5t96/skuXdfPwaPxp6QSDJaNC+U12p+qtAvHTfK8xO8TecLUC8enWzMksh/nywj40wjWpSRujelWDs1u
 AQA0sOX7
 XXZDl3AmIqPjTCsOAc1WvKJMvdL3mmYZi+6dS6EGAKQKeZImYtLYXmmpCK4jWa0o5WQwo93ioSVDaFWlG4Vb6IfSSLkciJ7MCjQ7D+V84BApL3PI8DFmXzHYJw31m568ZG68Q12fZ+Ps0QetMkTPylGR69VD2xwNXZk1dYe1DveHc51oJjleRG8niJpupkw6dnaw7nBY6YI2W2EierPThFbvw52tELuMJ/RYLIp2AsgfA6BJe8XatpIiYM5CI3VlI/XFrjrrd7zjfaWA6KFuGd4OOHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 16:17, David Hildenbrand (Arm) wrote:
> Unregistering userfaultfd leaves poison markers in the page tables.
> However, once unregistered, hugetlb PMD tables can be shared again.
> 
> Further, shmem page-table retraction can discard poison markers even
> while registered in missing mode, and fork() can skip copying page
> tables containing poison markers.
> 
> To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> markers. Preserve it across unregistration, splits, merges and fork(),
> just like we do with guard markers.
> 
> Use the new atomic VMA flag to disable PMD sharing and page-table
> retraction, and to force page-table copying during fork().
> 
> Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> Expose the flag as "up" in smaps.
> 
> Losing poison markers, while unpleasant, is not really fatal, and the
> use case is rather a niche thing. In addition, we rely on the atomic
> VMA flags infrastructure ... so let's not CC stable.
> 
> Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Andrew, I think this is ready to be picked up.

(unless you did that already ;) )

-- 
Cheers,

David

