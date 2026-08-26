Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88D8C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 08:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29306B0098; Wed, 26 Aug 2026 04:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01196B0099; Wed, 26 Aug 2026 04:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0806B009B; Wed, 26 Aug 2026 04:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0DF6B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:25:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E987B802A0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:25:04 +0000 (UTC)
X-FDA: 85142735328.22.C48E8B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 418C61C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:25:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWneUtSV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787732703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jl5mumK/mhgSaQuzPn8mgFLFcMqkcd1G53mgMXCtTV8=;
	b=RyOKDuMbwCayAg4mpqGOZ0PLJy2JCM22EGcdXoZPM71j+HLTivrMzMUCdEbb3MdTknAXGd
	QAU6vJdHhEUsqbpxOcejvZVJz3/O57ROjq8KeB8QQo0HGGC8VIMVZCqWn1zwocWIAWDTpU
	uT9HcdEAFQoK9cECRtF3/D3qTfValmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787732703;
	b=rh8BtDPee8wdKGfCGvCd9TlXfcNqYqjiNCPQUjp/kZSBxeNB+YspV6/Mb8WAeGIosIP3SG
	PrgoeIqSLrV4fg0zBA6D17Io13n8cy/1i1oFmwsvfMhZahF9pEwE1FA1RK7oYhdhx9auBE
	cDuFGuJqeDf5Tp/fKLyFrlvxMQLObs0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hWneUtSV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB53D6020E;
	Wed, 26 Aug 2026 08:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FED1F000E9;
	Wed, 26 Aug 2026 08:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787732702;
	bh=jl5mumK/mhgSaQuzPn8mgFLFcMqkcd1G53mgMXCtTV8=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=hWneUtSVWVkUEEHh53FsJz0JIoa96WZRviPHJpBFxUuUVIeQV+THrNBCtHoPDjUk/
	 KpD53rn8a79eP5KK+awECTdluAIyy7djbrqzzHsHem6rJUELi93M+1VZzIYbAjtp/a
	 dra+o6JA+s9kHFFVwVAzc3n7uUOr+cj7lY5ySRvnlMVfYdVuxWw0VU9vP4SFds8pY5
	 rwi1On+f7owvg6sSiuVjeF0ld22VKDs0xY3cyHlkfUhxgkaGmsEF8+UVjXfuPHmWZO
	 J2RwXA1WMQx4n9Vac8nKONppQhz4VM6oM89KFSHmFFXTY+kJLLZ4e+ite/DH9AuTzM
	 WC5CjFxMt9Geg==
Message-ID: <49aa013f-f613-42be-bc58-35956ef189de@kernel.org>
Date: Wed, 26 Aug 2026 10:24:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 zokeefe@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-2-vernon2gm@gmail.com>
 <edd7ed8d-0f2c-4de3-89e5-f2b23c2dd1e5@kernel.org>
 <6a9c2369-5589-4f2a-bcfe-c6e3b46a1ccd@gmail.com>
 <c8e3bb54-e4f1-45d3-8059-3ee1910a920a@kernel.org> <ao6c6Oe_KV0O1LJn@gremlin>
 <b6fbf952-c619-4fc7-8a8e-62a0ae64ff0d@kernel.org> <ao6fSHW_nX8YC9QK@gremlin>
 <42695df0-3962-4126-9afb-9a1905d096a0@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <42695df0-3962-4126-9afb-9a1905d096a0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 418C61C0002
X-Stat-Signature: akhhbn7bn53i4gb4ge5o4knc11ciudqd
X-Rspam-User: 
X-HE-Tag: 1787732703-650219
X-HE-Meta: U2FsdGVkX18YTFN7blIwhi4HcOl9r2ZssAIR6mpOBj715lr5nM6hqOYFt9rjuohCNtvviRBK8uVSZRl1l4K8Kjd3FywHkLpUiw4iwtN8Do8r0MFzpZ42vorV28zsohvmWbjspRWNzrpOWPpsLr5mPtDDuix/uMGq84E/aqG++whMDvyal6c1635zzqDUHg3G+a48thiWNxUuiiHa4ChCABAUI2UO1Pf6C9dJXa/WsY2yD+Rzq91sw7KEwfDSYd45enSVbsJj3es6lNOLFrrEiIhmYL0yGt4DjLiwKNhGMHWr0446s0u5Pc9UJdH6jO/TphJXksSJ642CsHllNcVt59sz7zZSgZr0tgABYkTb3zJO+UTfFrkKk8qMwxK5GZIsoShzGjBpAa6EtvygdHtSrwPROSyH+alJ9Z5vlErklBEAz/0j8/K8XglTpVLKT0I1Ez/zBX2Qdl5/AeoDcnkipBT4vp/x643CkTk5bDioRGwcTVTcOHE/Cn/7Q8Avmae30e73O3SSyBUMFLQ3iVz+rD/S3iu0lYxRJlRG7zkrbd5kZkyo0GVFLl6bJIddQ6VE5qnznRa5hQOtAWJFDFjwDYp3mKVcPw8WIeTa9gkVOId2Sk6yucMtBedV8BPmvBrMBBSxLGLA5xhhO/ZYsNuKGMJeHtMUl5edmfUp4ZeLNsYolqtmZomd4EGmBZkbvlsyAXEfXROrdVi55EQXTW/3ScZBBVMPB4bcplQu7QUc8Kjt+KCvignlyjbWwIqRSlcVJlaRUdxDnIKqMrLXrOMEXty4OseUO33/LxR5szEtJMmVdyR7aVs/o4eKyFTwQ3D6+biGGvAO30HoKqIaq2lvBUuBxNKzGJlAb9wnBY500gk3N6rdx0BsODoIUUNmV4fzZv9j9Cf2Zo7nBnfXwUZ9WbUlAygMRDmYTo36hLmIrKecD6h07l5AJQ8DjVhtZwXUZCFUw8B/vOeRHUzWHqq
 vnD/eeHg
 6TOurc4qYBnUYAQ3kSO1lEehdRqjGor1sveFY5dC3qUVAorb9ZiBieATQWLnWTHT1sd+trEikPVTnCEiVyetn+/Eu+Q/Uqx42Ov2xbD1LTQPRSXPT1q4n/GVUBBeqF8aL0hLtCSyb7upPqrjAcShHzepHiaaXDKBHmzX3r1C1t+TFum5rG4pzYccoTbWY4f1ebLiQeMDvVLgo6kDUVJg0NY6Jhy7RPEWfl2i5mfIUTqzi05b7XdIb6FtWWltQ7cM930o51jjYVl3PAJunpdDUWskEYQzSXfxKk/fi0uncUNOb96S8nw1/Ct/0gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 10:16, David Hildenbrand (Arm) wrote:
> On 8/26/26 10:11, Lorenzo Stoakes (ARM) wrote:
>> On Wed, Aug 26, 2026 at 10:08:58AM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Elaborate.
>>
>> It's overly long, I read it and am confused as to what is 'problematic' or not,
>> it reads weirdly in English and pfn_xxx is the usual convention for naming of
>> pfn's anyway.
> 
> Excuse me, what? Are you now just making up arguments?
To clarify, we have various users of "xxx_pfn" in the tree and I fail to see how
"this is a problematic pfn" -> "problematic_pfn" is odd and why
"pfn_problematic" would be any clearer.

I do agree with the "problematic" aspect. "failed" might indeed be nicer.

-- 
Cheers,

David

