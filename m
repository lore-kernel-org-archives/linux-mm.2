Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A622F103E2E4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35CD6B0005; Wed, 11 Mar 2026 17:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3A96B0089; Wed, 11 Mar 2026 17:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB5B6B008A; Wed, 11 Mar 2026 17:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9C226B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C3BC14044D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:34:26 +0000 (UTC)
X-FDA: 84535086132.07.DFD7CB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C705B180006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:34:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7wdytT+;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773264864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVgwRLu5iXuLc54q//zu8ktDqdMc0lUI71g9flpG7k8=;
	b=GT9/HXvxrqyDUHuhqKlzKEb4L1aNSbviiZnjq7GGDVGV1nZjtb/p4rWrk4hFTn2N0ociKP
	SyoQPqCusmuU/BrcgxlXYJJe0n+CdmSQJnfDhkkRv9cPKamnxXywogt5gkc5/kIWGZe7OM
	bEz1AOJlw1DTn6VjVNqqRVXYYglJGx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773264864; a=rsa-sha256;
	cv=none;
	b=CDTQqwD9YUNWMmv7OeGNa5slU+7CXa1BhxKH3VR66EszwXHNzOrS8frVfhfd47N1POwPGx
	0CKFCPxf2zdkSqVl5wuwRB5LFS69IssstBTly5XNZBimGRVOK1/tVltAaewAvGc8ruzxlX
	wWdsDsQOSveRau6b9mq4FkqMn6z6+NY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7wdytT+;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B1C4560142;
	Wed, 11 Mar 2026 21:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE42C4CEF7;
	Wed, 11 Mar 2026 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773264863;
	bh=CctnsvPHlBhyigdAST5vd/olihCES868mxNRQkvgQEM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h7wdytT+0G04oWXIn4P8iMAVXw/0nNjJWboWgVafbBUSnfeOGQ9xC6ncpr4ylbuwC
	 m2rm7wNoJOMEEjRNsfTs8w+9bx5OJtNtzr8YzDs8nggI7WPnidn3lgjZp87kGQ4ouw
	 e74fF0QSsCjVOEPx/1DrG3KZfu/ujr6Nf3LZb88E=
Date: Wed, 11 Mar 2026 14:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
 hughd@google.com, jackmanb@google.com, jack@suse.cz, jannh@google.com,
 jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
 lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 0/5] mm: khugepaged cleanups and mTHP
 prerequisites
Message-Id: <20260311143420.54537eb3962c16228862fdc0@linux-foundation.org>
In-Reply-To: <20260311211315.450947-1-npache@redhat.com>
References: <20260311211315.450947-1-npache@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C705B180006
X-Stat-Signature: tqgtz9daadd1c3xmb9yk85egmqooxq76
X-Rspam-User: 
X-HE-Tag: 1773264864-984942
X-HE-Meta: U2FsdGVkX18AOrMi/zPcDg6kjPpqnDoKoYHj0niM/DvlW0lRAfX1FkXCluBM1WwlsNAQJAn0GzN6GsXVlMsEVzdAPqhBkkzEADe8CLU8ab/cpCncuYoaHJ6OVrsYA8i+1jbzejKzmwlYBDfMFIUgYUczwXk0SXPwVLk9a2ErIzc7dF5bkQ1Y7IEaihsF6VLB8EiaPHKFMnl1k0ieGusJ2xlGDSEtHOyt7ZG8D5Ix/jyEdk41Omjr3eNIA/wuijoIPPA5HheMXPuhKel+jYzyVFbknAF8neRlsiT3Qe00x6i52mg1QGE62xy3/46k69w9GuzPbwMDhDaResMnw6Apl1hbhJYXRdjGRiB+1nvB2Hk79JTVHc4PZfVSOd8Rv5OIlXz9Y8egjqA5vmggsecOVXdxzJgaTl+DC/R3HcDWiHjwcH89eki0n/Hvma/aHMIcSvgX3Lfbq42AKwWh2wgUKnRjn3wNtIHndjYipeaNliGLq1w/oMIGnvPtOc6C4AmUL9uy1NfYcexIwVHM2f9Frc9L7ztoQExYxe9SFYMVolsGwdF3qp9h8Hj6Ko6NExvkve8SFuF8e+aMVoAFYvjDrWG3lB+Oh6cDNYKBjq7xMdX1+7O5Ji+vFqL6jsOe9SKhdyih5eJrxh8l3obFBPR/193PcAouaJswI3CQQekOArKgUI3Z4BtAu763nyBbYqfQisFYsLbtFsrZCAIhlLWMhGGAthkJcs+l/RiSnu9ONcTFc4uWqFZMRRFTo2nu7hofueZFx92cbLeFjmsDj4vQB7QFF+WALVjZZ5SouMVgkeQLEc/Xg06NGppCsdWs1fSb8qoN9eUJPYtXjwZ7m7BtH6/cbIfq3fHsDmPKMyRkmTmb4Oa8zeZHlt4Kmi56dwsrgNTnfTvx0Oo511nuzqab/4bg5Kp1eU1IvBzVYg9KUmOg4gAwGR8W/wiRt24KS7edhosPJAw7OyWl/3MBadr
 ycoLdUI+
 LFC2NTF6MemRQfWdy59vkmv967S9VV3Mp0POTw0rvvjqGoSg0eUxMhfbyxKcrMma5mjQT/MRxV6bFY9OIfHcAqSTsjSdYDCUWQyQsSo+GWY+EC+pBRITSz4u+NxhDbVbjL8zvbNtYfzM1fHd8jvlOYirEgnPQah1XTuv0Fo9iGDr0eHDDduYtXJm/FZXw+BF8DRNN6lhqYWRZlmCvaW0RVRDWsDcb2u7m6h3C4k3QZPcGecn/m9SFU3RAIwy2lvrsghCKbmtada8BMr1sxmKwKIYAUwMzJkoyEpE+hvJyb/BlTJAOQ3mGsWMdsVTWGwQhCILf9JU8SuQKoxcEMJp+hx29QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 15:13:10 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series contains cleanups and prerequisites for my work on
> khugepaged mTHP support [1]. These have been separated out to ease review.

Thanks, I'll add[1] these to mm.git's mm-new branch for testing.  Later (a
few days) I'll hopefully move them into the mm-unstable branch, where
they will get linux-next exposure.

[1]: I'll suppress the usual added-to-mm emails.  What a lot of cc's.

