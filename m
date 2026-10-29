Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9576E606AAC6
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AcnqFvq6
Received: by kanga.kvack.org (Postfix)
	id A58CF6B05B4; Thu, 29 Oct 2026 09:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30EA6B05B5; Thu, 29 Oct 2026 09:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946FE6B05B6; Thu, 29 Oct 2026 09:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72D896B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:38:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC79F1C2A1E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:38:10 +0000 (UTC)
X-FDA: 85375767540.05.143D803
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	by imf13.hostedemail.com (Postfix) with ESMTP id D294D20003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:38:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AcnqFvq6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793281089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyqAO/uWU5yVFQr+UTpxevk8bBFR60Op4CruyZ1Yw1c=;
	b=axoi+S2hQcrzOfvPy3I0StwukRCzjVOAWkCkFJgslOib8ZmFeRzviiKKdZRz6ciJ8J21Dd
	E2OA6BWZhcudW2k5ZejHu/J13R4yay+Q8Hc8WxySILgia+opWcLC+e4qOp9sIa1hI+QYFk
	1SJCU1ZDmrhyiup4MJutx8ykwIKx2Nw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AcnqFvq6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793281089;
	b=N3WUf4ksrGlqqHn8vRuUt1zEvpz3qU75hr1L9RVRzftxIcn+7OFVbO6I4QPFRtCGxiY6BD
	W7xW/lEKD74v3/BV0WlTi9w3O4sHuMFhlw5oZxC6J2usqYcsqYau4l+VgHP1mOGIGTFfYs
	pRZhmsHhuf1BPpSdOMmCmUkzvqClCfQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UkLfq2AiCr37WjjegzJiymqxIyI9DVtkKBDdhIlx4rA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793281087; v=1; x=1793885887;
 b=AcnqFvq6grjWGiixwLNrFUbCAe3FMNFxYBXdET61Ks57+qWvMENKyvD9y6ste8M2nPu38g9g
 LBfbtJjVGg93vAO0no6Xy7d59rpMOLEH2vkNMt7tzB2L18IDKL6VkaoMc+O5/eYk62y5aijwxpv
 f7tBWziYdLKrJBirq30IQAeI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 909f986a67bd46f8;
	Thu, 29 Oct 2026 13:38:07 +0000
X-Mizu-Trace-ID: 909f986a67bd46f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <2162e5c9-58f4-427f-984d-0099d9b515fc@linux.dev>
Date: Thu, 29 Oct 2026 21:37:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix uffd move-pmd test crash on 64K base
 page systems
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20261011163527.95988-1-zenghui.yu@linux.dev>
 <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <67c30e4c-3576-4ded-a71f-b49075ed42e3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D294D20003
X-Stat-Signature: guoyt95wboe7zz141ibt847x1ujss5kp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793281088-20041
X-HE-Meta: U2FsdGVkX196DW+3Sfl5GW45iV1skRr2j8IfYHlWEMhBu+bdH5Wk+6rIpdlCcRSsZAl43m4Tva3DhUVTTaP3rui8RGt0j6jGzColffzjY84buT1VuaeuJU7eikly2TNpQQJRv9JXL1YZWwMkEHL1TeY5Cd+5I7Xpeykh+YPCwcBM/czx05urC1FH6DjygRPs1mbii8rzArv3vX5MJvwACUh+QfVEmF+qaZQZJiVy/6ilhNFYeVtEYBwzCQzAm9zUbsqX1Rf7wxvjWvSSlic9eiPe3luTSJez5lqPglzMGcTXGzPWkWEz20COkzeVNFMTPSBdVijWMReqahDy4gb3Q0dsR2dd4cfzwlkZGWkCfNHQAr+CMpUoH2se9TSYpmJJ1WPldSThfVVWZvJLJEhUEJ6YPBr/ItyTe10UhzRzs3/Q1vsfkhV6HssYGy4CALEsjA0rsd/gfPG9ml5Mpc6i97ujMOHnA8kmB/TsQGBg4z7J3z2v/AmXB9c8TfPVFbnO5o5FJVH14DM8lwjGwL9qF1B7aMMwvPZ4thDTSk8gxUxn/0tOkXGIbY3vvehqC/zLBcWKZz1zaTGWTc22g0I7+/fddH8qLtyRO+Gc5QblxDwuXW1KnP3DUy7iTWNMk7mtspH63U77EtAuZ8UH1MZmSuLKjzHOis8qqMcLD7dM5Xakq8eE2cxzvwAJmWrv4eU6ecSz5fVQe13ZZaChm4uEgaM6VuRoiPNr6X3lkjfW1zT7AmeHg7OJTmFKwi3rfz6upfN29Lx5BfQRMbyzYtWhLfpa/JEwFsRQOi46yU3a0EEfS6T4sitwGDkrwpavKcoV4fq1AvwqxdRVp2qcpBHS7oMRI0+jvyy/RjpGbT4h9w2s083c9aGfhl/0eP2CGp575cx1J5KShcNP/1QSEzaXLnvx1EymI65khL2OUKFyS8k+O8ujEoH+2i9o7A4GWcnYM56g4BaPDwvBKKR4RmZ
 SuU6TlU5
 LzqQlrNWPVLgBYL63gVbP8S7asPvJgs/N9FwT76ZDd8xVmbplmjdmp8ZkawWpgPZYJ3YTXLwFsLdblKTi8ZRkwLRlxMiZ07LxmwXbb4vPuGdWp8FJyoaH1xCv2QBjngrZMfnTAwkuTDqMDuuy8/O6y4103CQZGA9yXjYdTW8oeoqoreiYAMpzRYuDFACck9iH0GQ2lq/lhj587ubQDNRJ+DtUK77i3q5fF2mxgbR2Zahp/VZfCmj8ku7iAff0lR7zU1ezOvemXcAmSGc9AsIlk1Iv6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 10/13/26 3:39 PM, David Hildenbrand (Arm) wrote:
> On 10/11/26 18:35, Zenghui Yu wrote:
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
> 
> That leaves 64k untested, though? Why not adjust the chunk size accordingly?

Right. Apparently this has never been tested on 64k :)

I agree that scaling the chunk size is the better approach -- it gives us
actual test coverage on such configuration, instead of bailing out early.

If anyone is interested in it, please feel free to send a patch. Otherwise
I'll work on it when I get some spare time.

Thanks,
Zenghui

