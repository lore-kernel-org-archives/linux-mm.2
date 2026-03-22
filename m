Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21969FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CAB96B00A1; Sun, 22 Mar 2026 12:17:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AFC6B00A9; Sun, 22 Mar 2026 12:17:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490E16B00AA; Sun, 22 Mar 2026 12:17:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 353606B00A1
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:17:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA889BB50F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:17:28 +0000 (UTC)
X-FDA: 84574204176.15.099873A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0DD68100004
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:17:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rqMEGL82;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774196247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNRDwT63C9SqT75nbbTtKGBy0nj1zHy752JbqHnkVB4=;
	b=CZQgB+gmqW4MQlHbzp57l31uv/XFLsVXCusN8iiCY5ha/cCY3Lj8c3HaKkjfyPh0HdQS0I
	DTRdfOWs9xzGlDwdzkp/qahxNrIv6+4inIOs5XQb/Hvur11BP/DG/5V5ZyHcvMPU6iM6cW
	T2AkH72HMlz4JVDpT0nTi0bVH9WlOos=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rqMEGL82;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774196247; a=rsa-sha256;
	cv=none;
	b=mZRBcLaXXgOvnAOr9t2xMNE7MYuvD2TXfYMSRmCkHbQgWfYrzxkfRajKFCw/SqWm3EaT5X
	c+EyyzDvFfsu0yQ2PfoN/S4z6kqX5mPUAmfPBFfKcTmpzofODSODF7vLCuOnn6IquONWKN
	Z0vjruWMfoRpqXVFtKTt4BYi3+sdJ90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2BB343D53;
	Sun, 22 Mar 2026 16:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC38C19424;
	Sun, 22 Mar 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774196245;
	bh=xn7acWrcNfOM9ZzwScwVBSuLjXy+6p1AilKCtVPfDiw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rqMEGL82CatXzSZUGssMlnUBlu7gibQcWJDmvlWNKM8wR3LI3RfabxRShgetGdnKM
	 qLVqViq53DE0oJ/EZ62HKok/IvlxVVVO2j8c2jdxjK1jRsQYexN6L6lz/p6Ea6GpOg
	 Z40l5OIIF154Wpf+2VLWVtL80h1i7JP6sGNOXwGg=
Date: Sun, 22 Mar 2026 09:17:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org,
 mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
 npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Use killable vma write locking in most places
Message-Id: <20260322091723.dbc1a8e45f4412fca43ba510@linux-foundation.org>
In-Reply-To: <20260322054309.898214-1-surenb@google.com>
References: <20260322054309.898214-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DD68100004
X-Rspamd-Server: rspam07
X-Stat-Signature: f6z5rynh497wjrsiqmyno88tdueefgne
X-Rspam-User: 
X-HE-Tag: 1774196246-123658
X-HE-Meta: U2FsdGVkX19ArH02nDwAZs8JRnvJRId9q+4dCY6ajm4DRsPlGiq+DybXx5Gc/kr/dBJZ6GMk0qx06NDtcWnKjDPhlSj51ST6bTY9IQNXpW3gxS3uW+Qs+t8DRJDViul4GlCVMiYa5tYC/Jy+MAMs6JxQhg7+hmhYo7PNtj7SIxa30HEdxxIv5O1N55fPSXt+T9bZkP/fqZG/rxdr4MuuFVRVgdzB4L5d3GLO63VPHZcDL93Ly55LewNjGSHcYKbH8kvz3eFP/V1NR7tTxZdxbDvFN6ovR2LRZh7NKWRuVGoRRnzNloZMJQE4zDHjlF2Xn2j6s7dq+hPs6PWDONr79eZLnR2lVRYcqZUvR0dCbnWOWVdrKeCn+mEfzn7ZUmD74bxwz77JF0BF8C7HkoSM9rjCk3+vcliYSWg+ZA1NMgwmBJ5evEoSjco9KmUK4eXjrH4GuE137yQWE9K+Vlb0aphchYYyW44jVZzZUoanTaHJv5h38ZGyYgC0f5Gqxxf5uQx3v79i8h2+VcFHhT3m6ad53t8LoTcepFnXODzo6J90y5gdilOidfBioEptClQo+5V3FbibKq3W6Jv/WtGtsb7rCzXIbbvFriBltvz8dq5rlsHecIExCoRn9UbvND12/7CGfpuuMIG6Gb8xDWMQwJUvBQIbrlt3YD7n1ZDqZEmVFQVUo0+RLh+5U1fATOwcpxQHImjiAP2aLPsxstiH4vBxC6tyzTsLNTIvN3+21BmErp4EcgzSMFRfIrHElR4KybLf4BkiK/Kzpm0FX9vwlCAATGTIKd2g+C59pVzWDEAWYzRvgU6HaTuHKS+QP23QtMH335VGoqh0PqmCncaTHzwAJf+iWh/EE+KgaLfYZtvUJ1IvDs8Ngfy2XrwkOKm3POMWbH07o4e2Du/to3z6TWq0uoE1qANwZVvC5NWAD9cP+nLQdKLj31/+6nWt0Sa11jWflFeaGLK2iitSMTD
 2SXNRImP
 e69qOH2bCbuF/6nmIUWLbZucqsEvEcjWV/XgzOWZ8s4aONKpDQrBvStZlTWt48qU5eBQBfJPZNuqhdF7Slzvv/0Sse3rWVTl4qCIcgtXuFYS1CTqqchxDn7bi19ZbLJWAedJNNvT4uY2LWf0uJ7xK5ZhvFEzESB+oP6CSSI1Vqg+bgmfoNMAEVD5QQCXpIE+qwQdMc4DXI/WgzMcyuTKGuvd96bvHZ4XzgQ+EtZoipHk5B3DkAfGCAeCjLSN1E/4iNxlOBWCWQ80POLfjsSEB3Fw6uo37NpVMbOVG+gjMTpQ95Xhl6JEKG8VD4x33AZAINyrwrXSy9LmzbkU6pZlTPXyIGiAk86tBOFQ/1q3E//CN6IBqmnZGEXLqKjPQZqIrctVFPk6VFKwomRamHYndWzjjfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 22:43:04 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.

Thanks.  Sashiko review raised a few possible issues:
	https://sashiko.dev/#/patchset/20260322054309.898214-1-surenb@google.com

