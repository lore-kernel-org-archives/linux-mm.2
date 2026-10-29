Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38107606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qiiz6ATw
Received: by kanga.kvack.org (Postfix)
	id 608666B00EF; Thu, 29 Oct 2026 09:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8DD6B05B3; Thu, 29 Oct 2026 09:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2816B05B4; Thu, 29 Oct 2026 09:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A74B6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:10:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32300A03F3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:10:54 +0000 (UTC)
X-FDA: 85375698828.04.295C1FC
Received: from mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
	by imf15.hostedemail.com (Postfix) with ESMTP id E92D5A0007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:10:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qiiz6ATw;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793279452;
	b=fIx6/KSDNnqZPhL37ihcov0EjD6ZpAXGlFCk69voOAAh126RhM8Piw8COa/2XAxhNQCphF
	vhFBtT7AcOkeobpc+KKV+gnJGq1/ubvDr1YQ/kOs43XnS6zSoX4RqpkXdXYmN6VL5MaJd5
	QdZ4Uc/RVyr02ikbDC1GupKcVEkXI78=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qiiz6ATw;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793279452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQABe9fyxw+SMMiPxA4Zn4DFjwVkHWXWcEdmXA+dMis=;
	b=a5RFn5qdcEL5LcemAJVwfGwTfjAkvhP0EpICE3SdJpdpzbrlXCurBElfQRWKVoLcA+ggHl
	sC+oEm7yM9L+/2n/cdZI+JFKSLJdnvKMogUjMxBXP0mjeVPNZeusBbg5qm/0kcifrs5q3M
	mzhLXf8MkNP7A+nGj2VYRrpGpOPNKtg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V5f+oq/M9eVDqi0oCP3GLKbRuxjAC1+FXXgoVyH9cpY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793279450; v=1; x=1793884250;
 b=qiiz6ATwkImFuwdZbU42HEebsGQZwDmQAaNXY5giwPr/R9ehLlEM6xJi4Sf9fYQXb+Bi5NtO
 N7HAkTeabP8LBKbcxMzTcrLYrtW8oZVzc+yKmCHBVe334LbYcaVBO9v1MuHD4y1WKdgA45b6+2r
 1bMj21madWjIC6v6abQBhqr4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d29fc1ab4caede27;
	Thu, 29 Oct 2026 13:10:50 +0000
X-Mizu-Trace-ID: d29fc1ab4caede27
X-Migadu-Flow: FLOW_OUT
Message-ID: <d36cb3c9-a2dc-4826-920a-994c773dffd2@linux.dev>
Date: Thu, 29 Oct 2026 21:10:42 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <bbdf1f71-6b86-4951-b5b7-e1fcbe672476@arm.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <bbdf1f71-6b86-4951-b5b7-e1fcbe672476@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8j4q5uzog9x5icfkynyttaitjyc6uod7
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E92D5A0007
X-Rspam-User: 
X-HE-Tag: 1793279451-57052
X-HE-Meta: U2FsdGVkX1/Crml+W/txlzRwn4L0wfAz43ERF3Cb00lgFj02ByRUXmVN3vwaMpOuLu0qN69jmrrwKWa+JtczhE37j581SI3Nq1KllFMR92mcWpxDHe+6gKdqaXvS6K9MeYUJULwKmQDrjvT7ve165cfuQYvXsrQdZ98bTKaQcXDvGJ0yl0nB1qRHRxYoL9povZ6UEKpr3P4XYG2UsUUpoRXLVrpS8zp3W5nIWShISxUVI4lX0VKoq3vaeWylBhokS/wCktzPtdZKTETARFv+Lw9losc4IkHMgra44giAX6vCOIN2wMD14Fuf+IWQ0+92hp/oC+OtXl8hkD+koQH6SYj1jb6T8pFw1jSvCPhhSp3zBlhuZbI3+N04MJ6srEBwzdero4ayIyDPhTQAfXj+KUVFLa9wFBZY43clgTD7MJmKQzup03glSp8zF2omr5H2droGMQXEVky9+Teg+7s6olAidd+yZ4dKFLoWxPsGGsZZCJtuYAEqmDr6EezhSHltH4EcBT6SFsT9PDAfJDxyMXF4z+vQBl17HTCHEcyYXS8ah0ILWQGFWRQcv3nhch6qDnublFZ92rvm+4X4iDiPiQFGlMszBO/w9F0rf9zMDcshAWNXdEOhU4hU/m80LMuKpVjcWttDgcgYiYsEgh1xnJbRymK+aj2a2smV6uT2psYD7g3EDw4cbZRaNHLhTdV3QbJp1ltQKOwy5u17+1fqNzXlHGipPg9oBiKmzg6+0ZWsLP4tbPF8fNnrAyoOSmWS2GPxyRHWcAsjJh57p7kOQbjcmfVGFf278ov0zh2G4/v4uos5W6j40rm1SswPM0QD25hZmS3k+EIbeC9nBUEVzVf9drGjHr6HrncOVyW3OaD373wG3LhyhsUPlMK1TrJ08opHEwxzpqQ/qG0X6lpdDSfurs/ggpyBo9zVy3zbIuECL6edsh3qh/0Fp7cP1RIy1Xf8Cd6HhFXpZr+MRrK
 oofudEJE
 nShg2XvR1YSASIOvWhXHDaGxYmz21DnJG69G9EXmd76zN9+nR/FXgDxZj0h0BeoOK+cPduk4LN//0pamzDlyq+GvwUAzpuwk5nBUdI0G01+3+sOQh35eU/Hz08BhlMjscMu3D4zeiuuZOtGgLV0lKPPCGMgEibOzEKhkRClOvFnz6sCg6w0DTMHRpS6lLHqON3Ec4H8Yv4otbk0llXXSMPibK+7ItEm5WiderOR8K9Wi/+OiZrdWzMtdCrQn2k1XNPkzA7vmX2xTSwtuFFzCqLQhWxuEPvSlUoEZI4mJC7DSqWkElLUwYz3OCzYdJ4n+dxNptYqrMuRqcjnc3Hspse+UlsWYzN8OoFNrD9Y2D7Z9a9xJc3IVRJPrSfydP6yjwf9aWBHWoAHIFBHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sarthak,

On 10/12/26 2:13 PM, Sarthak Sharma wrote:
> Hi Zenghui!
> 
> On 10/11/26 10:05 PM, Zenghui Yu wrote:
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> >
> > uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
> > chunks of chunk_size and moves them one by one.  On arm64 with 64K base
> > pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
> > the whole 32MB (UFFD_TEST_MEM_SIZE) test area:
> >
> >   step_count = nr_pages / (chunk_size / page_size) == 0
> >
> > Because chunk_size > page_size, the test then aligns both areas up to
> > 512MB, which points far outside of the 32MB mappings, and decrements
> > step_count, which underflows to ULONG_MAX.  The verification loop then
> > runs away and the first dereference of area_src faults with a SIGSEGV.
> >
> > Skip the test when a single chunk cannot fit into the test area.
> >
> > Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
> > Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> > ---
> 
> I run the test on a 64k kernel. Before the patch, a segmentation fault
> occurred, which was fixed by the patch. So:
> 
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

Thanks a lot!

> Though Sashiko has a few nits [1] you might take a look at.
> 
> [1]
> https://sashiko.dev/#/patchset/20261011163527.95988-1-zenghui.yu%40linux.dev

I think both of these comments are valid and worth fixing, but I don't have
much bandwidth to work on them in the next few days. If you are interested,
please feel free to fix them up and post the follow-up. I'm happy to review
and test it.

Thanks again,
Zenghui

