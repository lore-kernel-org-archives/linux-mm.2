Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC3EC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D7A6B007B; Fri,  7 Aug 2026 07:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97546B008A; Fri,  7 Aug 2026 07:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C372E6B0092; Fri,  7 Aug 2026 07:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910176B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:29:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06BD3801C1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:29:54 +0000 (UTC)
X-FDA: 85074253908.09.0DFC21E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EB03A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:29:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6YnebtQ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBZmvRMqQHFLdTL3oxi1yCZMaVS+T4GmULQiB/TUHxk=;
	b=Mghu7QgXg6NTJR0zZyAF/XvTTQ2JgilthMJC3LynHuPTQqaAwzKA+wTyQXrJY/LzZTCjjs
	H3N/IsLByQdAQ96VkSJj1UMGkOFN3xA9kOeaOxeFW+MB0GK7dMv03UcWcf1/HBQ/1H/Pbf
	0IvjDiR6ckMU2KZ/0aU8sJzZ3k1ewf4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102192;
	b=eMDhzm5F1UZJp6e8y5RqoxqORx/CjY/4hc3jcvuIUVvHBcT6sTDwWqOAN3znVhX/SysrdL
	fIIiSmLjSZEY5UyWxaaUxXYddooNAldSEbsY+qogrs/HZuzIDtMksEL4KRwJBRcZrcWy9t
	ns6tGJxCLMngwywMrQjqPwQzz/nXRAk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b6YnebtQ;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4F4560A70;
	Fri,  7 Aug 2026 11:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B691F00A3A;
	Fri,  7 Aug 2026 11:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786102191;
	bh=XBZmvRMqQHFLdTL3oxi1yCZMaVS+T4GmULQiB/TUHxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b6YnebtQgQXjeauox18EDtK9KO+KIpY5eiEieWcczMSB3Mr++/J/NT8771qX2vpR3
	 rcDxljc8SL91HNA66n/mrMohOKUDbiIyokoyJjxpkZwPOIx/+oOF3+O7VZ5mA/hHtf
	 e7RtKoxpmnRpsYjblRar1wk3KiX9oKRYwewQc20361JVlK26sg3zPgNlcA5oAZOsdg
	 y+Y4hmgAWFhsES7XzG3IfpOvO6nFMkRzYDr/eDxFmlGcvp1e85auBOhuQNk1rCxxx2
	 BO9kFs5zaMIKyhjFpUXighrsVYMNWazfE3V0Cmlt+NlANqqnawRQJ5w83e4Sgda8sP
	 1alwcS4Y5IGog==
Message-ID: <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
Date: Fri, 7 Aug 2026 13:29:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EB03A000B
X-Stat-Signature: iickdn6e179gwocomkxzz73tr7maiyq3
X-HE-Tag: 1786102192-478938
X-HE-Meta: U2FsdGVkX19grp6/k9kGh8qV3l3ieo57HugWL7X18mpOyjIjsPzJEjcYvhmTi+CXi2RtDY1JcJzcQAnUcoT1n1WBrzMFFqi+KThXjbs5CUfuaCLNlDSaRQmbEzAUulE6X1mR/iqnX8ITmkA7dfXqy0uLk6+0oNNIVFe2C4CoDsGDMTg55osL8OTV1UbAvDjO+vkm+lul0+sT4aOGGJYuM+sCWstoePvw79DyhK48s8qqVbC0nWq5QvOwEmgRWF+dEUjR5QeGeKEtDntY0J7GRp28o2MqmX92GRtT7TkQjOoRixow4714L17DT6KuqHS32sqUwhR1Ki4kcMlXRAXRETpwGLEQ6bwBR9zyV2JCSVXo7397xWDqClsFNsu92zx9rSM+C3ob1cOukfNd9qLbT2g5FBYV7KMDeJoZZ0CrFDc0kRZBPaDRofWoHn/LRU7w7WMes88HbRi7CiMICnfLGDqrQnhLz96P4UH80RbcfbGBc+6qg3gj/nOcqYOFj92Knmi6LgWiVRh8VXA8s/e5npUjzt+1U5+j2a0u23kERDzF6cAgEe08vgjpYhNYPBTkAWirpiKyc6ZMq2VGYOrkkiCd++Q7UFVo9k22e4uz3AT21B+fAq6rbLgPRJEhb6CMDr3GNnbyBf7vgjIozRBtMX9kD6fRQ9swAYo9Inmh+XgELE66kVI0yqzY+txm8clV4IBzt+Z9M78jT9WRxTrPDRaZite2N8llzmcvKI584cjGFuxn2W3JEwfIcKtUOvcFkVVt49076X8BuFrSbYBTe8o9GC7Z86A9gy8cuXuXOw+1LJeE6XlnlxfK30rbPONRy+m1jDpZagnx3tdDm/cRZwSHcQn5sjhbfM997KsYMjcQsTYrruu2stzJ0RqfaACplBjOQnolqJI9yfRY3qe1nITG6gobeuV/+FZJlgYdBSWbRT0v29kdreWwqJ2bgkcmLGkRF0Tinr+BJ106hBW
 OSZOM1R5
 sPPVI0Ey057UU+EIcwpYeeL8orfXyzIFp54v4iXT+zZMWP7iF8nGU/tSjPcNT9aSxH7eYpDI5qVJZAzE0ivdbVqVllGgeMgzw41T+0cUBJNUodFnUXoz4rFz9jMNYc40ZQS2dXpgrEjpA4BBsohfUs8DdnV7wPBv7H4dpOZvy4lWtVu1T3GDJKALIes3bhWj4KhDxu/UKbYyseqiqdHdCXbG0v10F5qWZBINGvCsppf7m76Hm3WAbH67Y3v8rffJ9wxSyEv5IgCjc0v9hylzRig7SN7nQkWlNLXIEIEHKUQjkwfM83A0vVnxV+Oa3kTh9l730cvlY9kMXIo2hdLz/rWUB0clNJmAS4f5JXM8w1gTARn0F78WMWCDpvE54+TiATYY/dhxAnzhexs7uKl96UOrpGHssuESgc0Ydy6SPH0Tuuk79DF+8rV4JFsr4ucb+zSHEhfrGHLIUMkYfaKMau6/2PkCehJSL+s/t2WKVIcKqzv7tfBtSnfdipGQ1EadDYBJfN7LhZ1qMjFKnyRlASOCxpjfVHXWqhD36rqA1j3mtNJ5xsvZwV9f+Ytlv56JfHw4crz2cVM1FK5eRiKnIHZRxqQAe0uudmep/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 11:52, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Thursday, August 6, 2026 4:46 PM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Deng, Pan
>> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
>> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous
>> check when changing pfn range
>>
>>
>>>
>>> Will do.
>>>
>>>
>>> pages_with_online_memmap counts all PFNs where pfn_to_online_page() is
>>> valid. With CONFIG_SPARSEMEM_VMEMMAP, pfn_section_valid() operates at
>>> PAGES_PER_SUBSECTION granularity — when any page in a subsection has
>>> memory, the entire subsection is valid/online. So we align to subsection
>>> boundaries to include hole pages within partially-populated subsections.
>>
>> But we must never account exceeding the zone range. So I don't understand
>> why we
>> would have to care about PAGES_PER_SUBSECTION here at all?
> 
> We never account beyond the zone range, because `sub_start` and
> `sub_end` are still clamped to the zone boundaries after the
> alignment.
> 
> The subsection alignment is needed for hole PFNs between memblocks
> within the zone. These hole PFNs are valid for
> `pfn_to_online_page()`, because they sit in a subsection that has
> memory, so the whole subsection's memmap is online.
> 
> |----------- zone range -----------|
> 
> +-----------+---------+------------+
> + memblock 1|  hole   | memblock 2 |
> +-----------+---------+------------+
>                ^
>                |
>                |
>      subsection boundary

Right, but init_unavailable_range() can just return how many were actually
initalized? Why can't we piggy-back on that?

I think we had something similar previously, why can't we use that?

We know the zone span, so we can just account all the mmap in the zone span
that we initialize.

What is the problem with that?

-- 
Cheers,

David

