Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C01DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339E46B008C; Thu, 10 Sep 2026 08:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAA16B0092; Thu, 10 Sep 2026 08:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8BA6B0093; Thu, 10 Sep 2026 08:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E91696B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:34:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B4EAC04AD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:34:55 +0000 (UTC)
X-FDA: 85197796950.17.D593734
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8F05E80007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:34:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EyCim8z1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EyCim8z1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043693;
	b=neLuOvBUiM3z9NZhcsMtM1oh9cBLWUUOmSR8jsY44mlVoe9R1Hmqhkg+iF/KRxI7XGyKBu
	WBH8MPHR0/CcULA5M7Ri+WuB+FAbRUZvMLPmuLkCC/eaw+dnbZTf5dmfH0m3YSDqPtRN/G
	0C3g2CRKXnllIVju2zOvPG1Yu/RYJcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyFV7zmyLxpEZvligdnuDoR5IOSsacIpTEqjLZPY4Hg=;
	b=rytEgz4vq5RN/AIMm0xhAPfemjexVZu5M07TcvOriFj23yFEGIv20J10k5wixxzG2epOUM
	m8mCb6No1LKJ7ZnVj8BdYlAQMjZyM2xIU6LEXVq+oHVF8wm/N6LebxduH/ZJqLgsreq/l7
	gEtjy2paOasaO8lC/d0iWlQmXvQx/oc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB9A2153B;
	Thu, 10 Sep 2026 05:34:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0467F3F7B4;
	Thu, 10 Sep 2026 05:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789043692; bh=3VduiEwRT1CiMZeMrb/9DRZj/SpWNd3+qDuMjc6JUx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EyCim8z1BXVvNkA1xBGQ4fcu6OUw6Mp7njnhN0VWg8gTaxRcZLvkZsfUFmfHBVbAj
	 +sCuf7gjxCheN+REc0W+MySoxgx0IjTxXWJAkxDBCr9e/j+MmYZNrZ3bGLk9drGcnp
	 0F83MHlbKNzouc73XXXeCAze3/qegFM0w0dpZ1vQ=
Date: Thu, 10 Sep 2026 13:34:46 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
Message-ID: <aqKj5ojQ3dabOV5g@e129823.arm.com>
References: <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
 <aqKfjqa6ye2AOU5k@e129823.arm.com>
 <11a36d52-89a0-4f43-8a51-a4930e171ba0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11a36d52-89a0-4f43-8a51-a4930e171ba0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F05E80007
X-Stat-Signature: 6okyxwgayngsm44zfphfykai1iags3pr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789043693-645281
X-HE-Meta: U2FsdGVkX18BPNpxWUcHM6K/o6vv2xWSJGsV1lemJfxE5O0zQ/IfirU1usLrQxDokOYPZ46z2sOavRkK5tp1ga2n77Z99azqO0lJWgiDuXur6ZoZXqKIYncIF9xqpIGOR+TE/CrShlpjRA1nNwfbJ6yS3qfT1W8AqbpRzEpXOE+vQuktlkjLV5vtgRi6g52l87q2EMm1w6IsgPmvLD4DmJ+aOcjjopSzYQpYBtbyJUcjQ9WtxgexZ/mcc+g7qfpJjJRjjKvNvPsJZ75YMkGh64kIPXBj/NY88Ql84vQMRY7daF82RX0laXjHZ7GMkXBDHoWA8bHTBYoBViFfASJPLza/4WqmztiBaEyp18jh8fQDgCDVWEXFtLXsTaJ3sOYnN9wXFOhyRs4WK8ueqHYv4z/2XQM3aTNvG4jukDZXFSAMySSlCZFBt07EeeAvv5tzz3oQbbNrBYj9ze+K/VUnX7ukd3PJBkU/84fkM7am7viFbqPBGt5knkcS/yTldxR23TJiDp+fjB0BDFs0j4c9pNXtFqSLoiQxX7p7qAQqiqfbnBZmRa5BDOtVe1NZdRVGSqiZarnktxfqQzOsRUwfB3P4cqI0TVq9r3GYW+ldr5DMMP9kg4gx8MNXjX0glztidVJrUceg7PEC7pE5KH/8bvGSWAy7FkGHiarN0/T45Dbss4irWXtkNa4iWUuI8hU1NqShXLxp79/Owb2yxcXUOiM8t1U2l0WXQV2FYkZoMWhIlLA7NERWoIChCtXyFrsYgAfnagdoB09A4LXHZ0h5mPzR1Y2TFhmTTJ4yJcUeHGMOke+9a1lTiVpGEalwXUYw78yqqaligrVHqRuVQcLMVCmwLgfrIBWhUD+Qi07DIjlnXhHUbOn6QHCGIFf3xC3H8lKP2dU5IPJzNw1tS5SVsxqRMMcWti/Srm2M7HCJWoGNtTe/kfyYkar9m1FPFCnkA/6Ap/W5zrJRLPIu/D0
 n7+qZJyf
 EQVYS1+ex0Tql9or+AdKSZsApS5iV5HI2z91lKav4NrSYkMTF8X7aTWSPCYu/1RsRQZLEdFeHNYxK8HmfiZr/hDZYlj/osUL1yOe/Ym4hzx+sHxAmnnftLEQrTDZNXd/c8jlKQLOoTK7MQUPXKTNxJKNWRfyvTVyQisp/+iYNFtY7erzMRDrouBtBZpRDZrKrxymjzOLbvxIYTQDthKb/Z0lSoxXhBbG7vz7PWGU5fXHREgXwDr5yvgASHch9Tz4VfjL5xXjrLlrjol0YBv2Rn2tsC/yonzNXqmWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:25:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 14:16, Yeoreum Yun wrote:
> >> On 9/10/26 13:30, Yeoreum Yun wrote:
> >>>
> >>> Yes. so if we remove ASSERT_FALSE(check_vmflag_guard(ptr)), TBH
> >>> we don't need this patch unless other usage comes up to prevent unwanted
> >>> VMA merge.
> >>>
> >>> Would it be better to drop ASSERT_FALSE(check_vmflag_guard(ptr)) in
> >>> guard test?
> >>
> >> I guess there is value in asserting that not all VMAs by accident start
> >> with an over-indication of maybe having guard pages, which is why Lorenzo
> >> added that check :)
> >>
> >> But I think even alloc_isolated_mem() is wrong in that regard: if the
> >> original VMA gets merged, we could inherit the guard-marker, no?
> > 
> > True. I overlooked guard bit is sticky.
> > 
> >>
> >> Maybe the following would be good enough?
> >>
> >> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> >> index 5c8ec3ca75d7d..791bf6a68b9e6 100644
> >> --- a/tools/testing/selftests/mm/guard-regions.c
> >> +++ b/tools/testing/selftests/mm/guard-regions.c
> >> @@ -2257,10 +2257,20 @@ TEST_F(guard_regions, smaps)
> >>         char *ptr, *ptr2;
> >>         int i;
> >>
> >> -       /* Map a region. */
> >> -       ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> >> +       /* Reserve a 10 page region with 1 page space to both sides. */
> >> +       ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
> >>         ASSERT_NE(ptr, MAP_FAILED);
> >>
> >> +       /* Map a new region that is guaranteed to not get merged in any way. */
> >> +       ptr = mmap_(self, variant | MAP_FIXED, ptr + pagesize, 10 * page_size,
> >> +                   PROT_READ | PROT_WRITE, 0, 0);
> >> +       ASSERT_EQ(ptr, ptr + pagesize);
> >> +
> >> +       /* Clean up the excess pages left and right. */
> >> +       munmap(ptr, pagesize);
> >> +       munmap(ptr + 11, pagesize);
> >> +       ptr + = pagesize;
> >> +
> >>         /* We shouldn't yet see a guard flag. */
> >>         ASSERT_FALSE(check_vmflag_guard(ptr));
> >>
> >> -- 
> >> Cheers,
> > 
> > It's enough but alloc_isolated_mem() could be modified to allocate with
> > PROT_NONE first and then change the prot.
> > 
> > It seems whether make a helper or testcase should write the code
> > properly in case of unwanted VMA merge.
> > 
> > IMHO, instead of testcase write them all
> 
> So far I am aware of exactly one test case, which others do absolutely need this?

True. I'll respin with your suggestion.

Thanks!

-- 
Sincerely,
Yeoreum Yun

