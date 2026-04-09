Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114CDEA3C59
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 11:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486866B0005; Thu,  9 Apr 2026 07:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437666B0088; Thu,  9 Apr 2026 07:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34DC46B008A; Thu,  9 Apr 2026 07:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22CF86B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:41:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C34B59EE7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:41:15 +0000 (UTC)
X-FDA: 84638826510.10.E956665
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC022A000B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:41:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EElsSNSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775734873; a=rsa-sha256;
	cv=none;
	b=jMsrinDW3Th0XuDLB36wy0jLBTzvmuvBTUJYZcD7gs2z3FI9hv+7F+9s0ulmVTf3Yt0vRK
	srmR4P53tEebutAsMWmBCiOgUAsWLgoHV9bygvEj9z949Db+ga++fwjsu+5gt+vPCXJ1ok
	OKFOwmFYw+Q+d1wpZKKpVULcyaTzKJY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EElsSNSC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775734873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs/VI904FekyOG73HJ6C/dK9dumEXcCfq78JAVX1ARU=;
	b=cMdxr9FdwRsQLGLDOqm/M2ZYcNQ514hEkFJ19KgXycH4/j4Y+W60No8I3wfBaTtZJzRRS6
	YXipxLFj1lz/e4Wfkdddolp7+MQ++u7pah2uJGhnDZg0X4HP1VsmeAvT7oDbv8MAlrUYw0
	aDeMzhuIXyiJXEcQNU7yJbzRVBgdHiA=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775734869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xs/VI904FekyOG73HJ6C/dK9dumEXcCfq78JAVX1ARU=;
	b=EElsSNSCD/qGE9ZUq4C0pa44QnDRJOd7EQ1FiCnBc/i8kuOXk04lkoRAqHzCVTKUPERQTC
	KwLD8fcsQ00CvPRYKL5TCZutqwEr+2hnA9wDKYahzWBz9EJvUME3+ypVQCq91uFQSdr8eL
	FibPEWCw133nsYQW6i66yeI4xOZs2Wo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/sparse: remove sparse_buffer
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
Date: Thu, 9 Apr 2026 19:40:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 yinghai@kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <70EF8E41-31A2-4B43-BABE-7218FD5F7271@linux.dev>
References: <20260407083951.2823915-1-songmuchun@bytedance.com>
 <b22f0af1-848d-45da-99b2-0c28b740e979@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wr9asxqizeqs4i5udqqc9qrgjn5n4gu7
X-Rspamd-Queue-Id: CC022A000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775734871-607347
X-HE-Meta: U2FsdGVkX1/++gECOYGImYnpo6zfUxNgXIvFVmvrvQgp7h+6jcmWwdjwvKYNDHRoG+PFYsFOAr1zhdJL5j0++w8RmG6TS3ZrvMZthn/Do5yvNWzLVLPtAhMrp2KL7+fn7UstKAlQSWLJ7z/7eamHOXYiaf1i9FVM+yp1rSIVK4XgAxsmZE8O6G7+4n6Q8qCCL0t3TZkFo4Xi3oTkq87YEbjRPPpPOkTFe+D/QfBMnjJe28deiWBNUaCgUO7RuqQaGBqYBnLyjLNTcNY4Dse9L4hzjmiRj9/EH1JVtrEVqslyJx2tUm5zzZLxtqGqPIP5xmndkSe+r5klsrL/tEGexLTaoALHP8/jFfgB2dnMxUR0qAxd+n4u/jEvmx7BpVDivd2345JDY5OTgl0Rui5+4kWe1Bknt/z7BUiRx2NpBB9adgDWZ6zyVYEKhA8jcL/DqI9TYgmKTl//bS/Mqj8f/1feC24lpHvXRL/TvJ104VmTFc/ft89rV/a2ZoAwaBGqvNj9f/UkidJaFUjTwF6b2LHv3hbsoJey0vC+rI79HqGWzfQBeSTaTQ6vdLkPuIXLuRDbZMFQusts9Q4SARYiElHLNVGW1zFct7zue2SpKETYmqc2nF8m199hEoEwgy1JDj4+7nGkUwUmYqysjCZPG8soIHnGoGujP6ZblPnKH6EKE+l0Yl/uspMy2JV/ye0wBoZIUak4mVfxAu1NJpjfI2eGbGBXJ92KKDAvnoFClDbMxKouknTUJPzt0PC8WC17qVCF4OZL6QfRTDPLZ6gbFgfFl400z1rEXkgXUW76D7bC2GNTk+QrGwNNcBN/hui6zG9GJ73zMwh22Va/E4j6224eAAgAtqp2BIuCd8F8UntuRq6vU9WeH1lWogcGRDmbRMvbF5Uuq27I38J5bXiuDCX7ghvnBqMIkVfdcpwKd2SE1LnpaORJQnwW76hkEV3Hdr4TJmymDZ8TM97PB3d
 RRPtveUY
 7d1TZKfoP7X2poZly3pMsAFCpVBgsWhGipLZIhsYI73EAQfXGwd1t0uqBESZ57LU3vrv8bauHlFOPSFebdH3YiCpOC35XYbzLj2mPQeEPOUSFt0zefCEhvmWsKMEJwu8O5/kK2vfhxQtnnrqQDc2x4cjTo+Lb+oNSntPa5kONOCgVLfQUWiptlfqWyPpU16cBLD+FnCYMpZFhVaEf7B67oFwuCPP+HoWUrnS4s5HodXqpP5LUgiYVdd2hK5i5fO9JBZTCxKF2r2sbHxyigIh7eoL3xBGA3qOQ72U50CHGneRCDQnwwhBr2ah9IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 8, 2026, at 21:40, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/7/26 10:39, Muchun Song wrote:
>> The sparse_buffer was originally introduced in commit 9bdac9142407
>> ("sparsemem: Put mem map for one node together.") to allocate a
>> contiguous block of memory for all memmaps of a NUMA node.
>>=20
>> However, the original commit message did not clearly state the actual
>> benefits or the necessity of keeping all memmap areas strictly
>> contiguous for a given node.
>=20
> We don't want the memmap to be scattered around, given that it is one =
of
> the biggest allocations during boot.
>=20
> It's related to not turning too many memory blocks/sections
> un-offlinable I think.

Hi David,

Got it.

>=20
> I always imagined that memblock would still keep these allocations =
close
> to each other. Can you verify if that is indeed true?

You raised a very interesting point about whether memblock keeps
these allocations close to each other. I've done a thorough test
on a 16GB VM by printing the actual physical allocations.

I enabled the existing debug logs in arch/x86/mm/init_64.c to
trace the vmemmap_set_pmd allocations. Here is what really happens:

When using vmemmap_alloc_block without sparse_buffer, the
memblock allocator allocates 2MB chunks. Because memblock
allocates top-down by default, the physical allocations look
like this:

[ffe6475cc0000000-ffe6475cc01fffff] PMD -> =
[ff3cb082bfc00000-ff3cb082bfdfffff] on node 0
[ffe6475cc0200000-ffe6475cc03fffff] PMD -> =
[ff3cb082bfa00000-ff3cb082bfbfffff] on node 0
[ffe6475cc0400000-ffe6475cc05fffff] PMD -> =
[ff3cb082bf800000-ff3cb082bf9fffff] on node 0
[ffe6475cc0600000-ffe6475cc07fffff] PMD -> =
[ff3cb082bf600000-ff3cb082bf7fffff] on node 0
[ffe6475cc0800000-ffe6475cc09fffff] PMD -> =
[ff3cb082bf400000-ff3cb082bf5fffff] on node 0
[ffe6475cc0a00000-ffe6475cc0bfffff] PMD -> =
[ff3cb082bf200000-ff3cb082bf3fffff] on node 0
[ffe6475cc0c00000-ffe6475cc0dfffff] PMD -> =
[ff3cb082bf000000-ff3cb082bf1fffff] on node 0
[ffe6475cc0e00000-ffe6475cc0ffffff] PMD -> =
[ff3cb082bee00000-ff3cb082beffffff] on node 0
[ffe6475cc1000000-ffe6475cc11fffff] PMD -> =
[ff3cb082bec00000-ff3cb082bedfffff] on node 0
[ffe6475cc1200000-ffe6475cc13fffff] PMD -> =
[ff3cb082bea00000-ff3cb082bebfffff] on node 0
[ffe6475cc1400000-ffe6475cc15fffff] PMD -> =
[ff3cb082be800000-ff3cb082be9fffff] on node 0
[ffe6475cc1600000-ffe6475cc17fffff] PMD -> =
[ff3cb082be600000-ff3cb082be7fffff] on node 0
[ffe6475cc1800000-ffe6475cc19fffff] PMD -> =
[ff3cb082be400000-ff3cb082be5fffff] on node 0
[ffe6475cc1a00000-ffe6475cc1bfffff] PMD -> =
[ff3cb082be200000-ff3cb082be3fffff] on node 0
[ffe6475cc1c00000-ffe6475cc1dfffff] PMD -> =
[ff3cb082be000000-ff3cb082be1fffff] on node 0
[ffe6475cc1e00000-ffe6475cc1ffffff] PMD -> =
[ff3cb082bde00000-ff3cb082bdffffff] on node 0
[ffe6475cc2000000-ffe6475cc21fffff] PMD -> =
[ff3cb082bdc00000-ff3cb082bddfffff] on node 0
[ffe6475cc2200000-ffe6475cc23fffff] PMD -> =
[ff3cb082bda00000-ff3cb082bdbfffff] on node 0
[ffe6475cc2400000-ffe6475cc25fffff] PMD -> =
[ff3cb082bd800000-ff3cb082bd9fffff] on node 0
[ffe6475cc2600000-ffe6475cc27fffff] PMD -> =
[ff3cb082bd600000-ff3cb082bd7fffff] on node 0
[ffe6475cc2800000-ffe6475cc29fffff] PMD -> =
[ff3cb082bd400000-ff3cb082bd5fffff] on node 0
[ffe6475cc2a00000-ffe6475cc2bfffff] PMD -> =
[ff3cb082bd200000-ff3cb082bd3fffff] on node 0
[ffe6475cc2c00000-ffe6475cc2dfffff] PMD -> =
[ff3cb082bd000000-ff3cb082bd1fffff] on node 0
[ffe6475cc2e00000-ffe6475cc2ffffff] PMD -> =
[ff3cb082bce00000-ff3cb082bcffffff] on node 0
[ffe6475cc4000000-ffe6475cc41fffff] PMD -> =
[ff3cb082bcc00000-ff3cb082bcdfffff] on node 0
[ffe6475cc4200000-ffe6475cc43fffff] PMD -> =
[ff3cb082bca00000-ff3cb082bcbfffff] on node 0
[ffe6475cc4400000-ffe6475cc45fffff] PMD -> =
[ff3cb082bc800000-ff3cb082bc9fffff] on node 0
[ffe6475cc4600000-ffe6475cc47fffff] PMD -> =
[ff3cb082bc600000-ff3cb082bc7fffff] on node 0
[ffe6475cc4800000-ffe6475cc49fffff] PMD -> =
[ff3cb082bc400000-ff3cb082bc5fffff] on node 0
[ffe6475cc4a00000-ffe6475cc4bfffff] PMD -> =
[ff3cb082bc200000-ff3cb082bc3fffff] on node 0
[ffe6475cc4c00000-ffe6475cc4dfffff] PMD -> =
[ff3cb082bc000000-ff3cb082bc1fffff] on node 0
[ffe6475cc4e00000-ffe6475cc4ffffff] PMD -> =
[ff3cb082bbe00000-ff3cb082bbffffff] on node 0
[ffe6475cc5000000-ffe6475cc51fffff] PMD -> =
[ff3cb083bfa00000-ff3cb083bfbfffff] on node 1
[ffe6475cc5200000-ffe6475cc53fffff] PMD -> =
[ff3cb083bf800000-ff3cb083bf9fffff] on node 1
[ffe6475cc5400000-ffe6475cc55fffff] PMD -> =
[ff3cb083bf600000-ff3cb083bf7fffff] on node 1
[ffe6475cc5600000-ffe6475cc57fffff] PMD -> =
[ff3cb083bf400000-ff3cb083bf5fffff] on node 1
[ffe6475cc5800000-ffe6475cc59fffff] PMD -> =
[ff3cb083bf200000-ff3cb083bf3fffff] on node 1
[ffe6475cc5a00000-ffe6475cc5bfffff] PMD -> =
[ff3cb083bf000000-ff3cb083bf1fffff] on node 1
[ffe6475cc5c00000-ffe6475cc5dfffff] PMD -> =
[ff3cb083b6e00000-ff3cb083b6ffffff] on node 1
[ffe6475cc5e00000-ffe6475cc5ffffff] PMD -> =
[ff3cb083b6c00000-ff3cb083b6dfffff] on node 1
[ffe6475cc6000000-ffe6475cc61fffff] PMD -> =
[ff3cb083b6a00000-ff3cb083b6bfffff] on node 1
[ffe6475cc6200000-ffe6475cc63fffff] PMD -> =
[ff3cb083b6800000-ff3cb083b69fffff] on node 1
[ffe6475cc6400000-ffe6475cc65fffff] PMD -> =
[ff3cb083b6600000-ff3cb083b67fffff] on node 1
[ffe6475cc6600000-ffe6475cc67fffff] PMD -> =
[ff3cb083b6400000-ff3cb083b65fffff] on node 1
[ffe6475cc6800000-ffe6475cc69fffff] PMD -> =
[ff3cb083b6200000-ff3cb083b63fffff] on node 1
[ffe6475cc6a00000-ffe6475cc6bfffff] PMD -> =
[ff3cb083b6000000-ff3cb083b61fffff] on node 1
[ffe6475cc6c00000-ffe6475cc6dfffff] PMD -> =
[ff3cb083b5e00000-ff3cb083b5ffffff] on node 1
[ffe6475cc6e00000-ffe6475cc6ffffff] PMD -> =
[ff3cb083b5c00000-ff3cb083b5dfffff] on node 1
[ffe6475cc7000000-ffe6475cc71fffff] PMD -> =
[ff3cb083b5a00000-ff3cb083b5bfffff] on node 1
[ffe6475cc7200000-ffe6475cc73fffff] PMD -> =
[ff3cb083b5800000-ff3cb083b59fffff] on node 1
[ffe6475cc7400000-ffe6475cc75fffff] PMD -> =
[ff3cb083b5600000-ff3cb083b57fffff] on node 1
[ffe6475cc7600000-ffe6475cc77fffff] PMD -> =
[ff3cb083b5400000-ff3cb083b55fffff] on node 1
[ffe6475cc7800000-ffe6475cc79fffff] PMD -> =
[ff3cb083b5200000-ff3cb083b53fffff] on node 1
[ffe6475cc7a00000-ffe6475cc7bfffff] PMD -> =
[ff3cb083b5000000-ff3cb083b51fffff] on node 1
[ffe6475cc7c00000-ffe6475cc7dfffff] PMD -> =
[ff3cb083b4e00000-ff3cb083b4ffffff] on node 1
[ffe6475cc7e00000-ffe6475cc7ffffff] PMD -> =
[ff3cb083b4c00000-ff3cb083b4dfffff] on node 1
[ffe6475cc8000000-ffe6475cc81fffff] PMD -> =
[ff3cb083b4a00000-ff3cb083b4bfffff] on node 1
[ffe6475cc8200000-ffe6475cc83fffff] PMD -> =
[ff3cb083b4800000-ff3cb083b49fffff] on node 1
[ffe6475cc8400000-ffe6475cc85fffff] PMD -> =
[ff3cb083b4600000-ff3cb083b47fffff] on node 1
[ffe6475cc8600000-ffe6475cc87fffff] PMD -> =
[ff3cb083b4400000-ff3cb083b45fffff] on node 1
[ffe6475cc8800000-ffe6475cc89fffff] PMD -> =
[ff3cb083b4200000-ff3cb083b43fffff] on node 1
[ffe6475cc8a00000-ffe6475cc8bfffff] PMD -> =
[ff3cb083b4000000-ff3cb083b41fffff] on node 1
[ffe6475cc8c00000-ffe6475cc8dfffff] PMD -> =
[ff3cb083b3e00000-ff3cb083b3ffffff] on node 1
[ffe6475cc8e00000-ffe6475cc8ffffff] PMD -> =
[ff3cb083b3c00000-ff3cb083b3dfffff] on node 1

Notice that the physical chunks are strictly adjacent to each
other, but in descending order!

So, they are NOT "scattered around" the whole node randomly.
Instead, they are packed densely back-to-back in a single
contiguous physical range (just mapped top-down in 2MB pieces).

Because they are packed tightly together within the same
contiguous physical memory range, they will at most consume or
pollute the exact same number of memory blocks as a single
contiguous allocation (like sparse_buffer did). Therefore, this
will NOT turn additional memory blocks/sections into an
"un-offlinable" state.

It seems we can safely remove the sparse buffer preallocation
mechanism, don't you think?

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David


