Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9278DCA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6454D6B0092; Wed, 30 Sep 2026 05:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6626B0093; Wed, 30 Sep 2026 05:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C576B0095; Wed, 30 Sep 2026 05:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD9F6B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:37:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A3E91C3770
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:37:38 +0000 (UTC)
X-FDA: 85269926196.18.2EFE98E
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CC13100007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:37:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDaXKaPx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790761056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccMGElv/uC2U7hFsaCAKdp5ZzLBHGsWkyEO+TwSXrDE=;
	b=KT5/+wxhasvKeVnRTPuLAvyHw0foHPgnV2z8E5mVf3zyRW7KFDbJsGlj6ZVVtZc4y6PM0w
	NYFfWb0WV8UBFZKzPB65QRtJlCyA1iuFhmAoIu202zAaS7Xix9V5EuCmjWGIyYHzNfVY/I
	c0Rq2CIbHLkDZ826p7Pwp1nlUwhi2oc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDaXKaPx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790761056;
	b=1IIsufL0aJr4VsKROaEcw6egpB1iMXipxn++kCs05GbSQdMes8z1FvkDuVr8k+/VkgyAJO
	/tRkuHlwEgAGz/PVrgt9k3e5slQ8H3EaauHWjnm8z8TN3olmQ56nIiHHmQEqezDJjQVZt6
	OXAOl517Q5f1FQBNUKrQWfQ6YYZuSI8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=X6NhOSSQEW58fF/T8iO6Cc8WhbapIj1EK2DhImjFRYI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790761052; v=1; x=1791365852;
 b=vDaXKaPxoHUDe6xJBYjz/b8ax5TbwYLTCOwoNEhfLYhiepxMG3G0feiagcL8gJplJONpzP6n
 7UaYmpuzQVxXSNzMEmWt/60cDauC6JZRdlFQXy0pWDNhIoITDUu/5K5kdiqlTLeiMPzzzGnfHmb
 KW0ixfR6RPFSBS78pfS7lAKw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2848c540328b850a;
	Wed, 30 Sep 2026 09:37:31 +0000
X-Mizu-Trace-ID: 2848c540328b850a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <ary5Nn9le4xG7_-N@MacBookPro>
Date: Wed, 30 Sep 2026 17:37:11 +0800
Cc: Jialiang Huang <huang-jl@deepseek.com>,
 lance.yang@linux.dev,
 baohua@kernel.org,
 damon@lists.linux.dev,
 david@kernel.org,
 kunwu.chan@gmail.com,
 lianux.mm@gmail.com,
 linux-mm@kvack.org,
 mst@redhat.com,
 ryncsn@gmail.com,
 sj@kernel.org,
 virtualization@lists.linux.dev,
 xueyuan.chen21@gmail.com
Content-Transfer-Encoding: 7bit
Message-Id: <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
 <ary5Nn9le4xG7_-N@MacBookPro>
To: Gao Xiang <xiang@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Stat-Signature: 6tzf31snmiictd7sdumfkhjjo4zrrurw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CC13100007
X-HE-Tag: 1790761054-317130
X-HE-Meta: U2FsdGVkX1+Lqc7FsWuPpv+tkZR2mWK+wRpH0RFl+8lC7LPhDKQaPysslHofZ93aJtIWWK2tpAbLkcQ2KfGZUmi7f2wGMVHvoW2uQVMwSLovfljPeiW3aYGIabm+4vZbF3gOrnM/KmOCmG/2XAKDtMraYRysVo53xx7qcvmSGftXz1KpmSMcY3vSBKYpD6NU4KXuMdMUQApdHz+j7GzSBs9tkcMR6P5cA32taKJlxsmlCyy0SHBu6vY27bJ3wbDA6eNXWDzQct+FcBC28uFURVD4RvgvRaJNaQNpXlqiiqOwERMd8o3oNmziBtYtcXMfS07pfzGGzV8NrdtjN2ZqnXA4AnoJxCrwyLBe7fM+LsVTjE/9ut31PN+LkN3S9GEL14VhQC6z+l/jsf5YAnnpAOajkpKNPvnVSgq+cUIMO8K972rYg5OTXDCWCPH21j0vAsupGeS8ggR+wh7c20CBi7RLeNQVZnao3Bwrmy5bt4mg4TdXBxukPgEPE/SmYWPFRBgDNHyollObh4oY4MFWshQVVC+thcIPq/CYtsq4uJWVZvP6cP6TkxOPqRASwKxZ9oY2P73hOfPFGiIXS1R6h+FIVn/7u2UVCG5Ig8Yff6fM57PIYvj+c/2+/GS6XVW8TedbfP+68kskPvmnqimkiThIsfsSpIoJ5/4A4itB62cmihKvuIFvkfbDcY9WdKsS8MG/wax2yK7bo9YfUtgWiBKues853YmIfbFXuW0XBAq+ljU4WfxRrfwrjJyVGisF6r5pYT/e6HBzOhLqSf4hFkKCuhpbVi3KsHgEvJjF+IWZMEUh5h3XjwTvfHuc4FPE4WEgE1i76R/JDz9ltQu0iZTnD4cHSbpiBSSspuRLk/byLwEoEpoekmJkZFqIMm/7M/AWSUHtLv032VB5a55nfLmaCpmpXrjsyg+FVt5gZYpCs49rmqx4G30gQdzDeXdtzQv3AzDVLLkhnZoHREU
 1yL+Z6li
 T2R3BCTev/8BE2ZXlhDBXsG0zK6lb0qE0otKDv4dR7CbUZ3GaXaKAxS3YK/aJ4Uiw1HHwvnalrVnxofMvj8oyYJkWw5dy4KWwXVdR/0YW3u8/idrGCGdqMU7uzotstjI1bGSj44s8MlQ3DQtILBmlShkWSUTByAl0DxeV6e70Xl6NVpQENyTE1HPrVsHUq6IgHUEI2BjCeuOeb4NA4n50eLVVYAkh1H1IhKXsX+I2IWK9q0kx0njJJl8UKqyWfaVUYyDZ29AvhbU39+gY1UjuZAWzr2xpoZAgXVQfiLsbEGk+wvhtOpHz4oN6sJCDbWdPH4/OGnuJhQlnYGme6ajJKw7AxDRH9JUyimdpootE3kV66qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 30, 2026, at 15:24, Gao Xiang <xiang@kernel.org> wrote:
> 
> On Wed, Sep 30, 2026 at 11:36:23AM +0800, Muchun Song wrote:
>> 
>> 
>>> On Sep 29, 2026, at 20:41, Gao Xiang <xiang@kernel.org> wrote:
>>> 
>>> On Tue, Sep 29, 2026 at 08:32:41PM +0800, Jialiang Huang wrote:
>>>> Hi all,
>>>> 
>>>> I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
>>>> to everyone working on DAMON and virtio-balloon free-page reporting.
>>>> They have been very useful for our workloads.
>>>> 
>>>> Gao Xiang wrote:
>>>>> It can cause sync 4K faults on the host in the worst case
>>>> 
>>>> This is one of our concerns with virtio-pmem as well: moving I/O onto
>>>> the page-fault path can introduce performance trade-offs. The other
>>>> concern is the substantial struct page overhead for large images.
>>>> 
>>>> For now, we enable virtio-pmem only for moderately sized, frequently
>>>> used read-only images, where there is more opportunity to share the
>>>> same host page cache across sandboxes, as Gao pointed out.
>>>> 
>>>> Muchun's vmemmap work is also interesting to us. My understanding is
>>>> that it allocates private backing for struct page metadata on demand,
>>>> which could help reduce the upfront memory overhead for large images.
>>> 
>>> Although I haven't had a chance and time to look into that, the main
>>> concern from me is that mmap() access will call
>>> "dax_fault_iter->vmemmap_materialize_page()", and malicious sandbox
>>> workloads (or not malicious, just valid mmap workloads) can cause guest
>>> memory OOMs due to "struct page balloon" for large rootfs in the worst
>>> cases and cause the follow-up mmap access failure, because the guest
>>> memory size may not even fulfill "struct page" for large rootfs.
>> 
>> I agree that this is a real issue with v1.
>> 
>> One detail is that merely establishing the mapping does not materialize
>> the metadata. Materialization happens when a fault resolves to an
>> allocated DAX extent, before its PFN is inserted into a userspace
>> mapping. However, that distinction does not remove the problem.
>> 
>> In the worst case, a workload can fault enough of the pmem range to
>> restore the full vmemmap cost, about 1.56% of the pmem size. Since v1
>> does not dematerialize private vmemmap pages, even a one-time scan can
>> retain that cost until the device is removed.
>> 
>> The follow-up mentioned in the cover letter is intended to make the
>> optimization reversible. One possible direction would be to invalidate
>> clean DAX entries under memory pressure and zap their userspace
>> mappings. Once a DAX entry has been removed and the corresponding PFNs
>> have no remaining mappings, references, or pins that require private
>> metadata, the associated vmemmap backing could be remapped to the
>> shared read-only page. A later access would fault and materialize it
>> again.
> 
> BTW, it's impossible for shared DAX entries (like the current XFS DAX
> with reflink and EROFS will support this feature later too for chunk
> memory sharing), since you cannot just use mapping and index to get
> the VMA like page cache does unless you invent another new mechanism
> for this.

You're right. For the reflink scenario, reclamation is currently
difficult. If we want to reclaim, it would also be in three stages:
1) reclaim the struct page corresponding to PFNs that no longer have
any mapping; 2) reclaim the cases where mappings exist but are not
reflink; 3) reclaim the reflink scenario.

These three stages go from simple to difficult. Of course, I hadn't
thought this far ahead before. So in the v1 version, not even the
first stage was implemented. At the very least, before I act, I need
enough planning and thought.

> 
> Reclaiming page entry mechanism seems it can be used for or overlapped
> to another types of memory (in order to save struct page memory in
> general): I'm not sure if it needs wider discussion on reclaiming
> "struct page" in general first.

Of course, I don't think struct page saving is the focus of the discussion
here, so we can stop discussing it.

> 
> Anyway, it'd be better to get some numbers with RL or agent workloads
> (especially the host memory is under reasonable pressure) before
> landing all these new infras upstream if proceeding in this way.

At least for now, as far as I'm concerned, I don't intend to land all the
features mentioned here. The first thing I want to address is on-demand
allocation of struct page.

Thanks,
Muchun

> 
> Thanks,
> Gao Xiang



