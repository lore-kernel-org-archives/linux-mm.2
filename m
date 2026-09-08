Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3F8C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340ED6B0092; Tue,  8 Sep 2026 08:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F17D6B00A7; Tue,  8 Sep 2026 08:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E12A6B00A9; Tue,  8 Sep 2026 08:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFF1B6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:38:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F280F40642
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:38:49 +0000 (UTC)
X-FDA: 85190549178.05.2926616
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2353440004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:38:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RujEipcD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fY14K9jk30Jrb6+u7e+f1I2SecfbVWLG2CSKPUhXInI=;
	b=oIAPhgJWpudk6OV3JK5YgJs9WpFohZi6CMK9rF9HrPzoomPT5Wgz499sNMf0Ou2lm7Eoce
	obWBEdFbNxFt5RBFz7y3v5Wm3YYORuH/ZQk5cXARCcgfL1n9Lgh7e/CtAOQNz4XnnQGsEp
	3KL/krHSZYqKCbRlDj4Dq9cdMSl+Ij4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871128;
	b=JqZS2eYnswPFY3ljlb+ZruENDML/OHoN/XVNMce3ixiQpcIKvrRuuUnenxccHi3QngJ/4H
	K1Q9qpZF7HacIQWOimT4BfE8nxhtnsZhJ9yDcuoswdY+889jJhXVuATsW/lp8sqAhgTqzO
	uJbNdoGmao4RwR4t/Ay/TJU1KA+xlS4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RujEipcD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48B7343A41;
	Tue,  8 Sep 2026 12:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7F31F00A3A;
	Tue,  8 Sep 2026 12:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788871127;
	bh=fY14K9jk30Jrb6+u7e+f1I2SecfbVWLG2CSKPUhXInI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RujEipcDEg/FCA174vxG8rgLdPncusl4HTzzr2yjAaMI1b+cxe4wRSI/Sp1HbPwoB
	 fY820jq4QhzoOte2FDnbWzxohbWTFoXYQuM/xd5YbqCBT0Swgxd2cNkbr/6ALrazCD
	 +4CrNOV9nJe7vuy+DrwI3hjFp0CAT+oZplErdjVuHRpYeytfE0km+YNxw3KAAd2ifg
	 0k9JSsX+4sPrnWu95zYTI2TPZsW1jNxz890N2LJibA/gQU8sP6ahGX5n1YMpIFiVnF
	 6tO+7hjF8bL7K4jaT6iSbGSwhcllCVDF0T/1NFKDT/t27cwfPI++oFc3P7Cr+lZS58
	 Kn4Z7QfE8d/Nw==
Message-ID: <0f15df3b-b4ac-41f5-9470-08bc69bbdebe@kernel.org>
Date: Tue, 8 Sep 2026 14:38:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix size truncation in pagemap_ioctl test
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20260907135613.68692-1-zenghui.yu@linux.dev>
 <9a21fc3c-1ca9-42a3-a044-6421f20341f6@kernel.org>
 <df053a08-6c9a-4e56-9ba5-bdfbf930331b@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <df053a08-6c9a-4e56-9ba5-bdfbf930331b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2353440004
X-Stat-Signature: owqz6e343k64jtxohpisxkgxbjyu854i
X-HE-Tag: 1788871128-395059
X-HE-Meta: U2FsdGVkX18B4VHu8CxtJaBbUd7DU/EC4imMrWkjFjT+JSx8Sl8s6Z/6UoiQPpTfRh1uz90pVnzTICCsA7JMO41V+kue0kfRIgQoJ+nYcbWDKfUNdTwR7RlvhXpjdHxub/10kzShmEtK+P35JRHhC5gle6pLCeQs4oSCl64QnGeFwYrxeaAtEz44ggN47r7C7gn18SdsRUKRcM8M9TK9NoqlHdbMGGdkemwZDkKzV/y/bOKrhpG11DkD0c28H/6bbUFf6Wm42GyGc0JmTNIZsz7L2lD0IL2MsXp2F2CL8z3ZM3KrUFkDohjKopEC/Edm89CSUbtW6AT7+3LuTMX3vQV5aphEoplha9k5Xv66SgpqEvfG3Opj1V6R89CByEJLXRTMe3w4ri9BsWExkpaj21rynGMxl8YhGsekgksaK+54Vo9nSjPPtMOI4g2hMsa5qn2Uy+XGy60+0UB91W4KTn5b3G0DjM61GlXOW7b7Q8bpZBerZHDuaA+9goZm3lK16PjeFlznqw7alsOpHkN7DWmPts9cao3mtPyZ2VzdiUT+btVpFJ9UDxSbVwRsKTq8XDk8ZCVGBqFAYlaQxPo9FXLI6P6xZle5OEpthYJ2ApCj/I3Ffe6GYFFfCsaGIwcYI9vDNyYmUb3M1RiqlJj0qwezCcgEZlmFKc+RH+hLjiWv2K1yKPm7ZhV3en6Ajz5JHIS/wBFCAJBGA36NyHOagd89fwUDu6Doo/5OE6Yb1DC6uz8oa2do2oh0BGC+VdfZwputU+3AmT58L1x/NAzNKrmOVGqa/mieHew9YQ422bjpGPYfIrHmNweQl2fNQlc2wiXVlQ3o/pXMgcFPy6gtCHGX4smJaFnHL9TSSFPgPM0jjRB1upOqT1lZxt7KAmNu+0+3jigLDF/acBxHniQR7WMcGPhvCLjvDwyn1l8dRAtTPxPTesWKQRaEJdsajnRC3Ija84rqjQ1LV6wMgS9
 8+LxCRmz
 0DfuqUspLHMU7k+u8HerfGEf12i8vYBlo6uGmk/7f1TSYZSyzn7P12z1MFk5zNdSoTbea3hBLjf2UKp00SX32sXlbZHN3lASe1SNpYIGnR0WCTSpgCTC+24GasEEuY1Yzc9z9oUYNWgSN4UpEZIAp9JDURKNqSlXuHX37eozr4uM5baBVC55pe6v7iYw9Lkb8HPnc8RNskSAa2E5ktuz++5xM6pLCUReao6vNnNpxXn+mI7+w/mqyRzcsuXGavZoztvL1N6ytrtETrUqs91d9/A1pPASwg+ZtcmJEWG0jguOp2RqOrsdVgrUa2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 13:22, Zenghui Yu wrote:
> On 9/7/26 11:22 PM, David Hildenbrand (Arm) wrote:
>> On 9/7/26 15:56, Zenghui Yu wrote:
>>> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
>>>
>>> On arm64 with 64K base pages, the huge page size is 512 MiB, and
>>> hpage_unit_tests() builds a 5 GiB range (10 * 512 MiB) for its tests.  This
>>> exceeds the range of the int size parameters of gethugepage(),
>>> wp_addr_range() and pagemap_ioctl().  The implicit truncation to 1 GiB
>>> makes gethugepage() allocate a too small buffer, while the callers keep
>>> operating on the original 5 GiB range, resulting in spurious failures or
>>> SIGSEGV.
>>>
>>> Change those size parameters to size_t.
>>>
>>> Fixes: 46fd75d4a3c9 ("selftests: mm: add pagemap ioctl tests")
>>> Assisted-by: GLM-5.3 OpenCode
>>> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
>>> ---
>>
>> Looking at pagemap_ioctl.c ... I think most functions should actually be "static".
> 
> Yup.
> 
>> Using size_t is ok. But then we should also change "unsigned long long mem_size"
>> to size_t, no?
>>
>> Also, in wp_free() we are suddenly using "long size". In pagemap_ioc() we're
>> also still using "int len".
>>
>> Can we consistently use one type please?
> 
> Yes we can.  This patch adopts a minimal fix for this specific issue.

Right, but for this selftest in particular we don't need a minimal fix. :)

-- 
Cheers,

David

