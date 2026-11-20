Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD7E606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mosgJSs3
Received: by kanga.kvack.org (Postfix)
	id BF9466B05CF; Fri, 20 Nov 2026 05:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0EA6B05D2; Fri, 20 Nov 2026 05:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC67B6B05CF; Fri, 20 Nov 2026 05:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768886B05CF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:36:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F5BEA8C23
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:36:36 +0000 (UTC)
X-FDA: 85455143592.11.26E61A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3956CC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:36:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mosgJSs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170994;
	b=roXJA/+ltpUKL4q+n6rSrbU9EklLADZZwL6KifunG0U9iUd06ymI5VFKLqo62nzjNScZ2Y
	8vB4SjaxJXEFYuOpmyxp+MJ3N82fD4ZKfpwI7AupWLHOwJuE9QU/46Zf2YeM7z4tuIWPJt
	wpFAPPzujc9WCwpynuZITxIW2EJT8A0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oF6M31GYIt+6QAQt/ArsJswJVvBXznFA4rKyyqSwiE=;
	b=lUi5dbqfna6z4OK04X01EEgXyGHYZxuS5No/VVKr1cyogXcJdO81phf/fEtQINj3xzaZSP
	xGDQYfh39iBwwfdb3JWeaASHPHodKzJ0n8juCoLXl+f6j+dzUUAMTXVWKrfWeatKHX6K1X
	uzROnfvh34eIdHxi9/c1S2D3XavyzzA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mosgJSs3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7915640D82;
	Fri, 20 Nov 2026 10:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C581F000C6;
	Fri, 20 Nov 2026 10:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170992;
	bh=2oF6M31GYIt+6QAQt/ArsJswJVvBXznFA4rKyyqSwiE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mosgJSs3KKKEEMmxUq59CjxU708/Tsqtcc0zy/zDxzutZQQX9kNy10cUptJNIbytq
	 d+5g/AYO/BvfbAkfLU1g6JsHLmRxeOeiwF4mxd3EVJn1XPdymv89apUxtQm5r7hBw/
	 bQvii/t7LokAaopj3x1jLsu1uCgqRQXJEXTKeWPQCnYOIBUOmsjirZzcb/bIcnpT37
	 HzR4zMlpzKNa01U25swiS5OHY455j4Iv0xTOHTFAcwfceH+ziP23lgsVJ5cpcngplC
	 nrwE1R8iwJvqeAUKvDrDWm0ncgqDS8X5E8NejdLf616fO9d297/V0r+2iyydhDEgeb
	 TQPPp+NLx7eYw==
Message-ID: <6b646955-4ab9-418d-b3ca-deda9506fedf@kernel.org>
Date: Fri, 20 Nov 2026 11:36:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mempool: account the element array to the caller
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org
References: <20261119-alloc_tag-v1-0-efcccfd3a9c9@kernel.org>
 <20261119-alloc_tag-v1-3-efcccfd3a9c9@kernel.org>
 <0d55ddb1-0cc7-4d87-9d29-9165d35102a7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0d55ddb1-0cc7-4d87-9d29-9165d35102a7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3956CC000A
X-Stat-Signature: ebo4r8zpfjbfgumh3f8bo477o9ouaekc
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795170994-90754
X-HE-Meta: U2FsdGVkX18ZtDwHG5WNJDD/CAn5ylaQjyI6t8U0rtkm/bR+hCyCN6xHhrpKwrCNab66N4NNxqEv61vOg1AHHytqVZxIKaoU0PLoeD7azcu1WRGx0T5XGSoUble6FCPqLAZKFKhiFrtZL47yZllfHGBno0HfV2NhFdRXKNEdp/ictgIY1UnbZjAVDd2TmvRH9BQUW9komMH5QwoT0QP5DgAf1CtZRI2Cs+Bdndg4vPg9l+wnWmzLEgSWY64em/Cp05Ao/EF/cfQyxhS+Z+j0cOk8WFy2cQcdyhG5uD4vhOaiSUVUKSUip9EuGSRBwtbHgnYy17Hfdr5P47tCophKAY0CUgmnbqFmEkNUnnIoIvvx1hFjlJhTwsAOBJJwrKbOivyYEFVxF6iq9nP7yePVJFb2A2vd3Ig0YZ/5vjE2BKLkV6fr54cJY00/Zux2d4reIPPESbIxQ3CR2a8JmJ4RnQWU7Efl30chGZadv3rrqZqgkiiTty6LcDjv5LjlPxnzyoDidq2sy2hw8rMzVS59hFgaR/EGq4PKE8e5BSA/vvNHq3IiG4kyBN6DvbjUmp2ryW4boWelNS2ydoDLR8gVnfu0mNwztg+0Jixl0nsZXuRpB7GE3IfaA2LAtvPlVbf+JNDhx3HDTB2oClIkZatkrH+Yc4S1UCSel5FWfogSidDdRXWs2uoy9F0y3FM6sGzKdyJmoS/jSSIXiQtida74jGqj/pHYHBSqfS8UrdxYSVWMQ+Bb/KuCWNSs+cUIHtMZRkVkYXmPe5Yvx1/ln/SNYDI7zciduOyou9efrs8b8l2YUh47FMcc5Bujtl3QOFdqDWVR2jUvOWcQ+Kb0NCx4PWAR8VbOnDEAVEgQX29bNuO5Kc2zjifZ1+eB6Cr+PJ7xE4RiOyFPUxbW0IsXzFplUnC+EpDW4bKz9Q7oIEu+RpeOFG51SOmfwzwV/zdbix4I67b0fFaNLqG1K7kHGJf
 zd8Dykv5
 f17ZG+6++AC6GMWEo0KkzFwO6rSodFr/sNybSkp/cciSAWz9D+JPKgvNPtioQN3LNEMfi+yW7KY9hcUDOkrir9iMCYu+LIsSMbw67zFU17XGlihGpd8r6sASWmUPw5gH3CgBbUyFu5ZoXxPMTDVOyIvtgn7uhyQMUYxKSnZNbOFPKb+9JgQtqWrSZLVIlkse8+e/MKUhcos7mfXQogT7QC4iQ/GYfnh3qRG+GdDctZhd1LknLmVLoqbcZZgjvPGpXM7AcrpjlPfxpEGxE4HLMnbj+jdPh/IP5e1r0OJH5iVJ/wbekQQ4Q+QXoaabwu0Bwlki9XSJCtQvQ8J0U6xyi/NWIR7gOoL2cskGONAiKMeprWq2NkTZ3GlJV/H9kp1aJ5vNCLp2Fih9IFaRpz0zz62x2lQTUqxSVG4Dqz65cUzl5Ql2+/YcgfImS9BxRtva69HTJ3E+qKz3rSjJZ9bYZBDmaarRUjbAisBYwRld4AQbR9+S0apdbiab7+mAWNLChEUNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 11:33, Vlastimil Babka (SUSE) wrote:
> On 11/19/26 09:52, David Hildenbrand (Arm) wrote:
>> mempool_create_node() accounts the struct mempool and all elements to
>> the caller, but the array of element pointers allocated by
>> mempool_init_node() and mempool_resize() ends up being accounted to
>> mm/mempool.c in /proc/allocinfo.
>>
>> Let's consistently account all mempool allocations to the caller, like
>> ptr_ring_init() and ptr_ring_resize() do, by using the _noprof variants.
>>
>> mempool_init_node() is only called from mempool_init_noprof() and
>> mempool_create_node_noprof(), which already set the allocation tag.
>>
>> While at it, make mempool_init_node() static and rename it to
>> mempool_init_node_noprof(): it is not used outside of mm/mempool.c, and
>> calling it without an allocation tag would be wrong.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> LGTM, but if this is due to an AI report, they should teach it better about
> what's urgent, to the point of not reporting such things at all :)

That's just a cleanup from me while reworking #2, where AI tried to do some of
this here inconsistently in patch #2.

Feel free to drop this one here.

-- 
Cheers,

David

