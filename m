Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6808AC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A056B00DF; Wed, 12 Aug 2026 07:00:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7018F6B00E1; Wed, 12 Aug 2026 07:00:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFF26B00E2; Wed, 12 Aug 2026 07:00:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB446B00DF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:00:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58463140270
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:00:22 +0000 (UTC)
X-FDA: 85092323484.22.ABF8EA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 922BB8000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:00:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jb9O0ZCO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QnBF5cx9VLaWvudPLevSkmZpIlMTP6N0U12ZPxdSiY=;
	b=4DVaFUiwRR0zHGX7Tbuw1xnq0Xtj8DYW1JKnBkjI5QxM2bawUKvX/snTMl+HQJL9xROAkJ
	+LfWDnWAk7epBrqI+u9Y/u1rwx5g4zpICp7EKX/fiCSYfv+E13bihxB3b1oDnhDyRPhEfT
	GXSy0hnBcsyJfhKuW1SAjipVkMeXkdY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jb9O0ZCO;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532420;
	b=VoBpUr9R1Y/9h3R90OW+erligloJ4n6rhWTBhKI/YxF2RRpn7iDLGEr+hHNDVgcrMUp0b5
	xjKfuXRp67oTRQA+/vBbsrS8DnEW4/0b0Kjrjm1nzb9HL0jsvP9NtRbMnPabcK1RVlaG8q
	ofajSU737Mj2Dp/eiKWC5sVbnRxi9Fk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B0E860A84;
	Wed, 12 Aug 2026 11:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9CE1F000E9;
	Wed, 12 Aug 2026 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532419;
	bh=8QnBF5cx9VLaWvudPLevSkmZpIlMTP6N0U12ZPxdSiY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jb9O0ZCOJvtddTj9kfvHp3dixVdT9HaxzC/dmoAb5LK/re0HHMIRYp1/qmMD2EY0Z
	 +zeqGzYrn2ZET0rvEZVmMBF9ilbtQlpr6pYfwFZcErhX7EiueptygVXuI3wT0W1NOm
	 /GV111+RFOpe0A1tuyuNamWHMcvqYbxy0v1KmCqvVip9z2rvTBakEXUw2RwfFX0Pf1
	 stpdbKDeeE2psgydDurRPsjVAY3DRVtIFJfEb9SCGK88CmniFX5a8MZEjaJH8EBr/z
	 S5XLKfkWSdgOnhIsPzH6P5sRD9TIXX9iSD5Z7avs8td7pirGPOHzcKA+Ijh7PVKRzZ
	 N4LWurlA8XCdA==
Message-ID: <48790bb1-fd21-449b-858f-c6584f0af96e@kernel.org>
Date: Wed, 12 Aug 2026 13:00:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-2-375ef0767206@debian.org>
 <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
 <anxOqNmL24Cj9A7K@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anxOqNmL24Cj9A7K@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 97mmuin8o5dz1bicdadsoocegtqwtdyy
X-Rspamd-Queue-Id: 922BB8000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786532420-587633
X-HE-Meta: U2FsdGVkX198OkN5ymumibzibm1AAFCoJHNcro1dR3mCD4mKLRcFRQfylH8LJZuv937zJvSbydhID7ToWXzilGiup3Op2sZS7iTCt9ioEotbnidUjAGHidBej0lCx7szcHpERyC3n5eAghlmfEMc7auLkfMLXG5k8mp+RL23IRvtaSM3kYG6on4ndyGEvVGxQKrNK9SkWb/QCWRLxsA0Q0XrWaDF24LZNA8BTCqW5FtE1PWWetbMGygV83rlDP0oJ69yMJU+D0Xx8a6i7edKCUDahviO5TBm0n0fUqGQcTPY++6esq2UYds6DXo8/Jws8tXjdWtKQc6p36Pr8JDZ4fKqNnu8FM183/vwSZDZjxOrPqzBLuqupBqfz2wQO9j7B2qjFoLNwcgXQdhbWD0uGqdCgUXRJHYWbBJFaUk9cXuLHeZ4Mx0swqmHVSQ8eV9qtbBrzNNTKmjHYI6dzldJXtPFiXKfUr7fkStRsU+JtHFTWzcnRrvSw9qxaRZI7insgJOguJcjv3mFW7H72DhRDp81lHpmPepwZQuxUzimPwQ3T987YZXLbYJt42vnTjQ+gKchdLJSxTgdumWWDkizplB9jp2tDfMkCfLNXywIMSCHCRdlTNE0M2WKfXMNfXJAaTRpeUuPSVWv7lqGkO+SsUOKAemtGiFNbF/jHprpkI7yJywtbUBlG8tSEPzFX7p4YUpuQwUHJlucQjcG3A+hSB9qLZ6asCcJRQBkAT83LkthPnr7isCFCU7e2DP5DM5qwE2SdutelY1V8CWy+W4Q7inCCSgVU2vHmQdSQFtsPrRGNgNkh0R8+8+AxSj0Z1rgnkDfSFHWndO3u6lfKq8P7acVGFZbbn4aUY76Z/BypAQvvUli9zFsiomZYLundqGqkkUh+PonqFq1djHyfuWhLPc6CqtOPoGui5EZHNwRB5bV2ZvLdzCNjwlWti5Aq+xOf5z21nrZeOOy7gYcoiT
 +AWIz08y
 5w9vayr0lO6hP9zAlJShN1epGzp1v6kFjyZ/F5HxegwYsc3QPcEt2DYZG5dSSjURl/31r+qFbFBOzXLSSLqKtjiP0si/JCG7JkO9mzR8wdThzBBz7VEEMY4HDOYLLrGutznk6brO+zlic6pT+kEApakSssR9xp0kAT6dtH0U+pyUhpLp3V+OQQm9I8vsGaAeWNlkDtnAHd5tq1EGhkdMXgrxq7UA9XNkD5+nfSRnJus1eLQXh4dD+ZSVofzrTFNwdosCi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 12:48, Breno Leitao wrote:
> Hello David,
> 
> On Tue, Aug 11, 2026 at 05:36:31PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/10/26 18:26, Breno Leitao wrote:
>>> +	return ERR_PTR(-EINVAL);
>>>  }
>>
>> Is -EINVAL really the logical right return value? Running into bad swap entries
>> sounds more serious to me than "-EINVAL" :)
> 
> Good point, maybe we need a strong drug here, what about -EIO?
> 
> I picked -EINVAL because it is what the swap code already returns for
> this exact condition. 
> 
> 
> 	* Returns -EINVAL if the swap entry is invalid, which might
> 	* occur if a page table entry has got corrupted.
> 	*/
> 	int swap_dup_entry_direct(swp_entry_t entry)
> 	{
> 		si = swap_entry_to_info(entry);
> 		if (WARN_ON_ONCE(!si)) {
> 			pr_err("%s%08lx\n", Bad_file, entry.val);
> 			return -EINVAL;
> 
> But, I do agree -EINVAL is too soft given the situation we are in.
> 
> I will return -EIO in the next version, if I don't hear any concern.

Sounds definitely better.

-- 
Cheers,

David

