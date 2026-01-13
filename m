Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025F6D29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A5B6B0005; Tue, 13 Jan 2026 05:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C79D6B0089; Tue, 13 Jan 2026 05:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37ECE6B008A; Tue, 13 Jan 2026 05:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 254F46B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:15:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0C7513A088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:15:36 +0000 (UTC)
X-FDA: 84326533872.27.920CAA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1B5AD180010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:15:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKchUiTq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768299335; a=rsa-sha256;
	cv=none;
	b=R6Xzsv+IZ/vtPy+Zjyb0NLzLD+QvZak08pOX0wJtwfT+RL1BO92lSkVSq59fq5wq5ch1zT
	J86aH2ftM/gFfyD+A1pWLoaAYEM9XdYR4f59uAdSnaZb33EmWZ/E5yfnv3OUeCsYWTbR8L
	Zdb70wKknbPe346i5R7xElDAP//EUgw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKchUiTq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768299335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDuAlQCoPjdePQLrM++pUkJUtidNshf5Qum2+kg6rUw=;
	b=LhWIr7Clvw8anQs3O5oL+hEhkgZazaNEL8VJDObIH64gbMAMORcB6FvXt9oawyOFZ35bMW
	/orKRuFrhhx8QlxbKV6FuGqTOnEF781WqCDX+raR05qfvh0isJYAIxiqxe0fLK6ojqHOqo
	grQWC3wlVLcpshpkteEgAQJw3TW4i8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 420766000A;
	Tue, 13 Jan 2026 10:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5468AC116C6;
	Tue, 13 Jan 2026 10:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768299334;
	bh=deRUAWIkgjHzXVV3cTmMvD4gr7oy47IkI84pINNcAqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JKchUiTqrBXmedCjGI0bAxn9puHSObsRiojxEBeoJJxbhHibVzSCf/lyzADGXCpoy
	 n1RMGbqC6tGw97/p1n93+GR5kJpE3NTQL0qYksCYAT+ZIhKeCrm0zahbCGScUyxerz
	 MqwJSCf7hocs3WwkqnwrrmqMej+7D4Y39Xsr581gkUSdzH5svy4pIlXoctvzEudqD2
	 hTQ1WLTwFbQMVmxxAG56nxOBnUq5/jWTiKaE3tUwqqGmDGh4YTNyVYz0hL8oKt6vyE
	 6WmhxjeMQPdzfVEmwd0FE+Hc29ax7w7YJSuKRQa9Ga2+mdi8NjeeFA9xCt9/+axWWf
	 S2ssqlJLg1OXg==
Message-ID: <7963534f-cce8-4330-8a67-3f31bd6b2166@kernel.org>
Date: Tue, 13 Jan 2026 11:15:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, ankur.a.arora@oracle.com, fvdl@google.com,
 joao.m.martins@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@suse.com, mjguzik@gmail.com, muchun.song@linux.dev,
 osalvador@suse.de, raghavendra.kt@amd.com
References: <ee0bbcde-612b-4a53-aa2a-bc3f60302408@kernel.org>
 <20260113063736.29694-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260113063736.29694-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B5AD180010
X-Rspamd-Server: rspam06
X-Stat-Signature: aktx5dsqxi91yzms39tb36y8mmtzxzds
X-Rspam-User: 
X-HE-Tag: 1768299334-976832
X-HE-Meta: U2FsdGVkX1/9ffYE5oMKBoU3+Kt2B+F2hhvkvnOO68q6zEwXrDCXb5QsHo7UfQPc+mQTXI7qA9EfG7c7HXBR5cdBbmYbLaK2C4OU3mQT4sqYHBUqKMPBb0xRuvpbgDHuVYUTSNVUtTTTymWG/2kmhC0AcVDHQcOarTxEFzjvXcy+uSST5m6/iWQ1jQ1U83KK11wHEXnX6Izo6EQlZfI59g+YlrS2WUL4RH8ASU3SdeE9lKpGAgEciz8h5hSPogVFAKfK3qp0UEavNnmnYexxCO6UshRgUvsng9XH/QfwkO7BipxUt3p80sdi+vvTVoj9/21shJoGJJgnjEOZwVsQfEGjrQUfh4n8S+EKp/8aXevFpmKTGkJ33qsRLVRjymSC0PSttT2d6C0nC9Q6igUpc8l/16TvNTJk8NL0jGvV9zjXwFglB5A9pKVPz7Yf4pSB1V6w6dOPm3JgnWnrVYrih6F8uLZstIW8KtO55moug05C0gG7kim/QIs5LovtvNiFuhtlfUOPExwUn1aSrCDiDKSN0FQiJt1o5dX+nUeNElWjQefQhJ8e6X0vz3RD2sTII2gTGQk5j/+mfd7q2kWkt8o8Imjf8tTng0F6YDTy9rtinF2RhKCXj+dIm/X0b5OON9muYG3N7VqssLEFe98XZIGdNsFVoL4CZiQL/uaWHBuCGXlTFwcr2Kzf4Y0c8tdx6gPpqHrQyawR/GtXHkc20vNk2iw8+3xxmW8UU6cLMerG2AMfv3FcQQwsIwmJzhMPFKLTG6bla5aTpRvoC2iyaaDeXu4+TCtAIsuRsXgcnBMfpkcGxxUiGkmgMRMu71Bbbs1Hr07+P2BRiGAGL/XKHjTsrjmQFpqupTZalVlc/MTf+291T12mSF4OcMsFb5hVVAO4XDUxWTjR0Idy+24W3Sr7oA1biK0Pkualio0LTCAbHAnpfNniDpPmWce3rsmCNHnQaM+tXqLdneK0LMC
 3J/CTPWe
 PyyvMdEVtVpfKfkWKZjGXBYK5y+mlUbQ1RZuhS4PLMLZz4lQl3ZvZ4V9IvkwwDsGSu5DphlK0tz+s6AaGLNMEh5H1T3ImCUEdP3k0IWV7BT0W4NdJ4AyAPyMd1jqMXeMdCzSEjJB433jcNFjCYdgOMteq8yseSIxFFbK1RfB4F0yqhR5VKKzkra1BVKhgDFyv8wiOgJ24qvi0Vet6EGxixdqVEdkMC0HilwiYYfM8TM4uhX2KTiuvBhx1EXGExVYVEhpIxH4i5+oSMaPHq3bMz4hr5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 07:37, Li Zhe wrote:
> On Mon, 12 Jan 2026 20:52:12 +0100, david@kernel.org wrote:
> 
>>> As for concern (4), I believe it is orthogonal to this patchset, and
>>> the cover letter already contains a performance comparison that
>>> demonstrates the additional benefit.
>>>
>>>> I did see some comments in [1] about QEMU supporting user-mode
>>>> parallel zero-page operations; I'm just not sure what the current
>>>> state of that support looks like, or what the corresponding benchmark
>>>> numbers are.
>>>
>>> As noted above, QEMU already employs a parallel page-touch mechanism,
>>> yet the elapsed time remains noticeable. I am not deeply familiar with
>>> QEMU; please correct me if I am mistaken.
>>
>> I implemented some part of the parallel preallocation support in QEMU.
>>
>> With QEMU, you can specify the number of threads and even specify the
>> NUMA-placement of these threads. So you can pretty much fine-tune that
>> for an environment.
>>
>> You still pre-zero all hugetlb pages at VM startup time, just in
>> parallel though. So you pay some price at APP startup time.
> 
> Hi David,
> 
> Thank you for the comprehensive explanation.
> 
> You are absolutely correct: QEMU's parallel preallocation is performed
> only during VM start-up. We submitted this patch series mainly
> because we observed that, even with the existing parallel mechanism,
> launching large-size VMs still incurs prohibitive delays. (Bringing up
> a 2 TB VM still requires more than 40 seconds for zeroing)
> 
>> If you know that you will run such a VM (or something else) later, you
>> could pre-zero the memory from user space by using a hugetlb-backed file
>> and supplying that to QEMU as memory backend for the VM. Then, you can
>> start your VM without any pre-zeroing.
>>
>> I guess that approach should work universally. Of course, there are
>> limitations, as you would have to know how much memory an app needs, and
>> have a way to supply that memory in form of a file to that app.
> 
> Regarding user-space pre-zeroing, I agree that it is feasible once the
> VM's memory footprint is known. We evaluated this approach internally;
> however, in production environments, it is almost impossible to predict
> the exact amount of memory a VM will require.

Of course, you could preallocate to the expected maximum and then 
truncate the file to the size you need :)

-- 
Cheers

David

