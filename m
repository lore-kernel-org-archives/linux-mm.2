Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8900CFD8763
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD7A6B0088; Tue, 17 Mar 2026 09:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADA36B008A; Tue, 17 Mar 2026 09:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CFE6B008C; Tue, 17 Mar 2026 09:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A92736B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:06:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77C1F1A017A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:06:15 +0000 (UTC)
X-FDA: 84555578310.10.569C613
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 43E55100005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:06:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKIPqh0w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773752773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHIcPjPEsSqBx5jkdfPqAnrveeBzUGXrfa2FRQKI/30=;
	b=3nunb6VmHfEWzAELlJ5+lOmNbMjXcV2+Dxc9O0oIsn8OpHvq0ZhMOzCHzYhoSP/unDmaOO
	DwMxDt/JBo/V0MWwL9orgRG/p6qovN2bYEV3nnrnrHzmRQMFXrXt/ZxRC+QSx4COfXcpJ0
	i6dsftEyppWGd8jmbeuJtWujnZ2yD94=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773752773; a=rsa-sha256;
	cv=none;
	b=4g9TNTtke9mSxxmDw5rTnJpKoe5JENqCkx0odZlulgrFZkocJudLyWOBcdH9UWHFYJ+3gY
	6ruBpSA1rFWw13Sd2vhsw5AI0SnzG/yIKzYy2bicYeKIISDnuNh89JVkv5Fiv/0rBd8QqA
	QUU5QM7JsDWG+fKNYof3pLgfnNk1GxQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gKIPqh0w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BFA640986;
	Tue, 17 Mar 2026 13:06:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB425C19425;
	Tue, 17 Mar 2026 13:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773752772;
	bh=Psbirt/YP7hNGPqGR4mZdh4NA6DQF0ohxeq1831l9KE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gKIPqh0wjUeANGMDdq7LVx5gZCDNbXAI3zeBGD+RFqIx1XJ6omk9ZYbGXbcPWi3No
	 ionisDQH5w4gli0Yi0kg8zTkv1UWw+2fdHqZfC3jOylVwAPd9jz1zdJOs0sh84Bbh6
	 IynphC85kTHWzw33qqswiVuCuxXiDIUas+pYdgG3uLOAFrmG2IqadkNToYIzm6KmU7
	 A0ohkV7z3dmqJBPiGVDi+NdVWQr/mnCzvEQTyy40eANihkKBiWr3avR2L4ligsr5vG
	 eOXx/kO5s9EFSzLM3C0H9YOWa2BqRac1wxr2HiR/AnMA0g24pwGm12G3i1xVv8/i95
	 PC0YTXsmgngyw==
Message-ID: <049d056b-844b-4480-b90e-bf4c850fc70e@kernel.org>
Date: Tue, 17 Mar 2026 14:05:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
 kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
 dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
 linux@rasmusvillemoes.dk, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 muchun.song@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 jannh@google.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 pfalcato@suse.de, rientjes@google.com, shakeel.butt@linux.dev,
 riel@surriel.com, harry.yoo@oracle.com, cl@gentwo.org,
 roman.gushchin@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 zhengqi.arch@bytedance.com, terry.bowman@amd.com
References: <20260222084842.1824063-1-gourry@gourry.net>
 <c10400db-2259-4465-a07e-19d0691101a4@kernel.org>
 <aZxqP7J1kOClQUPQ@gourry-fedora-PF4VCD3F>
 <aZx7hsVNU0XOCCiG@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZx7hsVNU0XOCCiG@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43E55100005
X-Stat-Signature: uc15acr4wfwxwai4djm45mazmd4npwdj
X-Rspam-User: 
X-HE-Tag: 1773752773-163693
X-HE-Meta: U2FsdGVkX1+JSGu94i5PK64OgeTzD6Ov2iS/gTDTWmNzG+g1KSK5W0mkvX9VMe1TfCqRq0dX0lpujIjD0F5fdHDXptm4ROlJPWiH2CR5uIXryFhsARA5QujQfgjQKmZ9SVGiRYMJ7y9FlKqlyYi0hwIi57/+jFYj/OJYRsFB6/yPIbQEIfvYkoUDfDfNfMlAe6Z/P3Hd0oi68NwaO+3lXn0qBWYzA+sOL/AIKqSZJfMOdn3FA4eyQYJ+BN71iAbRN2VWq8esJgIEK5mUKzS0Eip/6iZoyZqp4/qcox7DRS+wDe894zCqpZ6PccZD1zlUZgvWD3Q4j88nnWnzUGj8AfNoLWVXxn14Bg6jKZzBbwg+6XtdcHxyWq/W8gWD+IkimPYJsx1DzxJoDN/ebVkayNO8Qj4tiFz/sA/+dFNR23CwTHwaz4a45AmVu3Onx8rRfaM6o2HHeN77ad6LVTWMsK2qOj3UrqXV3llvnkSb+OGoJEQjiswx2RoCIgU9bLG8ZXoOGVj5NKf9yjYbxDVQSfOO9TMqiGOZS4Add7+0dlZBgukh6swlM4TS/EKM/Cm5AyoiLi3gux6nSVOhfnZB7lg3l33em8dZy8AfNRrFMsJLVg901dlRmoX0YklbQH9KQV7xz1Dxg6yOivbstNypGgi6ISc/NFzpd2XKbGtaS+7fTDANVI3VhHx6f8zwDlh22aTr29XCwqGleP1x4Xo4HQI7IKHwt1OnThFFb5iLkLqSYpxkaTxdHgfRYd+vcndD0FNSAzXBM7c/LBKjiqllmUu4LAUqecPyPk5xPUxYDpAtgo59ldnHi+ys0+AxuJdXMTsnTmXh23RZ4grB9/flx46hpcePEDcsenFkc4ryjbqafh5gGuhONEfbSU98NxWqgTUWVYW3LIYtGDLZL35C9qeJfcPRecQPl+GhM1DGnN1fEou8Tbzf+/bxNHABjqGFJ/lCoDd5bRjXwq+33Ch
 U8zw233F
 T4wSMX1QnV1PpziyplJc+DKjn9b8gQdAC430NDbqxcx6MGBI8CzsZclaw07IK4mEeqztyBGqwyFmHlhf+QzUv+jfDXaM/EQKS+2iqDSX+Wgdq5jmEE1eAdMRe+FYAgrj94vTWApi9Hp+WGzrLeSR+ZxzdpLfD28yxAEym0ZvrhC3ON/+oOxn15zA8BB0CicJVPUPrcR0nG1YlkSr4Ek4Ugf3jfVDg2FHjhBPVaq3KSTB/WZ4sprO7RBrMzs+U9CrlU2D3KUiF0wbxywWR+HYhD0i/cnK3uPxPOhFAyoBgrZe2Lui7E5DkHRZ0Xp7muY7ro0qcwYJCJMXrEvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 17:08, Gregory Price wrote:
> On Mon, Feb 23, 2026 at 09:54:55AM -0500, Gregory Price wrote:
>> On Mon, Feb 23, 2026 at 02:07:15PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> I'm concerned about adding more special-casing (similar to what we already
>>> added for ZONE_DEVICE) all over the place.
>>>
>>> Like the whole folio_managed_() stuff in mprotect.c
>>>
>>> Having that said, sounds like a reasonable topic to discuss.
>>>
>>
>> Another option would be to add the hook to vma_wants_writenotify()
>> instead of the page table code - and mask MM_CP_TRY_CHANGE_WRITABLE.
>>
> 
> scratch all this - existing hooks exist for exactly this purpose:
> 
> 	can_change_[pte|pmd]_writable()
> 
> Surprised I missed this.
> 
> I can clean this up to remove it from the page table walks.

Sorry for the late reply -- sounds like we can handle this cleaner.

But I am wondering: why is this even required?

Is it just for "Services that intercept write faults (e.g., for
promotion tracking) need PTEs to stay read-only"

But that promotion tracking sounds like some orthogonal work to me. What
am I missing that this is required in this patch set? (is it just for
the special compressed RAM bits?)

-- 
Cheers,

David

