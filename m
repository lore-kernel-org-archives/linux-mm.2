Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A71D606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m5ujUUUX
Received: by kanga.kvack.org (Postfix)
	id 8769C6B0852; Tue, 27 Oct 2026 12:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E266B0853; Tue, 27 Oct 2026 12:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A466B0854; Tue, 27 Oct 2026 12:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 556896B0852
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:59:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E508940A8B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:59:20 +0000 (UTC)
X-FDA: 85369016880.01.934539A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4C7854000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:59:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5ujUUUX;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793120359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mRKG8JUg3W3apzQzP5V2MJURHdFBSMtjSahcXC2r10=;
	b=pydIYZBBi7N6fUfuq89SmpRxlCrPa8s4jWb3QW+Ko8jOJ8Fj79bQExsqFo4H0aWNCad7qp
	/vb/VxnkHzqSnTamgFYb0m5Iejl3bTp9ECNevaCJcBGngGzplAzmL7NqpW5ewyQH+zymlS
	WUok4wNd2GwcOHRzidZoX4m1oJFt2vY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m5ujUUUX;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793120359;
	b=iarBtXPvDhdaOTaWuo3sPf0EY3VDfw15WWrKm0AMmzbR3yjNtbHhZO0iHD4I4yOOU0y7u5
	PEWc4R8QN7+KJdJjR2KFbKzX+4AoqORWvjUuDCidW53OOayoXM5NUciUSTCpuMPaP0OpiH
	va3z4B2JUiXV66gLk0UIIBoHjofNAAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 732ED4045A;
	Tue, 27 Oct 2026 16:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43981F01825;
	Tue, 27 Oct 2026 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793120358;
	bh=3mRKG8JUg3W3apzQzP5V2MJURHdFBSMtjSahcXC2r10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m5ujUUUXAwTOongi7tFEnIIdgeIt9AuFKpymAcGPUMvr2q8LfPolwmbBptOAtCb/H
	 Z0p44KyhyTdVUmld6mDFP8w0vV8d91Kuix/C4wExtPryNc9XPcCzxK8ka5Q/ucT+dM
	 YM7z0rEdHtCI1aPqyPKALFsZ6QgFDMT2lkdQG2/E5E3t/g4jcd58KSJMN6c+sVei6k
	 IhP4lwLE/sfL/tl5frtbhmtVS9FOyg+4sooIl4hIWYejOEx22O/HcDQo3FPSdJ4VGm
	 mggZ6gWZPusZgh3pbLa7dKEPww2V++2MABWvlxDlFFRduBoQuuO7LU+PnPlz/zHP0K
	 o+lyO5Jwt+2mA==
Date: Tue, 27 Oct 2026 16:59:10 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mseal sysmap: Allow with CHECKPOINT_RESTORE, default
 off
Message-ID: <auDYWiSVzd681e4U@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <7ff59c2ab6c234ca4d799f862eb7c3f22d671f99.1793094611.git.chris@chrisdown.name>
 <auC7SFhV_qj-agQp@gremlin>
 <auDTVShTfZ2et9m4@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDTVShTfZ2et9m4@chrisdown.name>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C7854000A
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: bees6nbansjqy3anozx8g91std6p5qf1
X-HE-Tag: 1793120359-440903
X-HE-Meta: U2FsdGVkX18zuig08ER8eAPaLRLSu9BqANj6HEG92h1AhdFSzcqyv1PCPbKhGx/Cz+WyGXOA4YW7qjTZGx5wQRVivG23o1NeEwRcTFiY9tTG6CYGnPtdmgZjrC0Ldn8PUvLsf6QS8wuMe0bgTLUX66cc+QpFrVoDaCFwYv0w0HaUmKBBGbVdrfmBb0nRzI/BjeDZV11m25dogqSIgqqFm1xG7a+FEu+1HTfBu6ucUhWGFz/gHOQRaB0/uvBKvjNL8ziIz9qp/1s8WTl14Ral3A0oQzpziQo6wzTm1q9PQTfxRsxN70hR78n8AD0fc+ibCoszd3cQBlu/qci3X/0lcEcYqvv/TJ2GtHGnW3R8QYqfkrKhrUuJxdxmyHdedn9DHnGMMxIiOVAeL+lO8MjBXQeL9WetiBHoDujEPbQX2OHPxhoORqzJ/Nqs/8I5yJtQ4gVGnwcB8UeErjLeH5B90s51ZdtBmHC55P9A7K+qRq6D2ThFV5U/DK0UDTpw+tfGyK2/AkwrolmNeeXN22u/LpRSJnYkB8fw0ylxEqwPAJPBOGhSyt8CE2Rrbuz0aYbQyEgCCbUHPg/zd+s4yNfHBGxR3wkK9MwVlmRu0IXFlhTLHsrzFyRNPSsrKb1O+GljBK9ipuWrXawRgIZgw3+6nPySgZZfKccI+Brcf4ayG2klBTY+XfAvxq9qgLMhbmAiAE6UcvToR6gkp2dHFYxHqdsjmLILGXxUhTmklSXyup2gYvpiYzJHQAtutJfa+mh2jbcFzFcnmYknnbSuaLSWHU4ceVZovGNBFkRN5uiFEf+DauNuEwtBiJAo4EsjHnVgt5u6HZ8pqdSj0me38B199pPcehwI/iZFmYPPdd1gN0De3UvesQXoej06ekKUdYCTDjNRZo5aftiaQ2piy25KgVJ7rUBc2xfHDqWTe0abVVq9dyL6bCutxge6qrfdIgVFe4nttVbBMu07U/Uej16
 CDJGxmFw
 8B9JDo9y95gcA6iD28VJjiu6KepHvfeggbtwtF391I/l9so1MWvhFOQOymfmNsl2oDlv+E7EmSm05QE4jBrps5o6m5aSLGJF5zZMP+p+PdfqkWlGWKoCTziEdHXSbMWVYQcwCpaxPsvr1p9oNUn8zuOZR4JZRbzFUiVjG6GPTNbEQhE15F0NAk7mndk3q4nw5fQC8P+G9wA4nRG8ff2gv9sUK2jYWPDC+NZnFB0AmTgeR0zxISsiXcfR9hOKmboCicJh4kpDcjDbnQKmRfLLXThAULoB7LxjnvdaaenzcjvdUigM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:37:41AM +0800, Chris Down wrote:
> Ok, sounds good. I'll drop MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON, and fold
> dropping the !CHECKPOINT_RESTORE dependency into the boot parameter patch.
> Thanks!

Thanks!

--
Cheers, Lorenzo

