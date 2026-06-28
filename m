Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04850C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 07:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6960E6B0005; Sun, 28 Jun 2026 03:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646A76B0088; Sun, 28 Jun 2026 03:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55C3C6B008A; Sun, 28 Jun 2026 03:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8336B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 03:47:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8ED3140325
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 07:47:52 +0000 (UTC)
X-FDA: 84928542384.25.77BCDDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E451F40003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 07:47:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1Cp5PT8;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782632870;
	b=79fSAzcyY2voXzKoejfsEYf6+JIGv5TYI1Oa4j5qISb2b9bKhTYgFhIwsp/8Ajju04Nd0A
	lXX/L6AojMfQXbCZ0xHtjNhiq3mHSOu4Sr2stULPA+gwSXKDR4rFHJ1yhKOAlCYIVVyWvC
	lTCizCjew8Siiaroi18PIGGHRHbUblY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782632870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOXsSp9elfJ7spiFgdSwpNJTwjePPuVq0k4sQC7N0jI=;
	b=3DbN5H6kH2MPvbAy1kOhb4eC+SP9luDWFk/4V9Vn+gy8HQHyhu6mdERrC29pP7VATmZLsW
	n40/IFuwoqkPd9CczcbXI0dlrccMhLm5F9Ee7eXa4+3qqSsohlZSUVhV0Iz2p/hq7CrpqK
	2YLrGtfDlEFS7qrKsy/PFCR2E8UHK7c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P1Cp5PT8;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D3D7600B0;
	Sun, 28 Jun 2026 07:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222FD1F000E9;
	Sun, 28 Jun 2026 07:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782632869;
	bh=WOXsSp9elfJ7spiFgdSwpNJTwjePPuVq0k4sQC7N0jI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P1Cp5PT8znUS78WKkff45gZAe5Y+yGxs0RhcpgBYQkrjmmY+DQ+eid31PV05A9NXC
	 R/dL/GK5gvATP7vSgLn/2QJVQVMZvi66gsB0IpUEZ6bwZ4b1jC/+Voi0tGRtaIREer
	 ZCkCKhg52+5LjTCsRkS4mMQvafseCD8XIuBWAaPHWWWssabY2Q/lJgBM1NNrfnmkxb
	 my6sWiwQXkj3EfhfT4Ad/R2oCm4yBw2UK7+sdm2sFQpHYElYZco56WZBXX4UXwDBRT
	 ohFD1NGFzCtYVGwB2bbMuNTj5/PkfswFKqg8d8wrl/0Cz3sbVSmo+5Xq07s6WMb0Pj
	 pu/17arSdaIIw==
Message-ID: <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
Date: Sun, 28 Jun 2026 09:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <akCSftF6mrsKsz1V@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mwz8o6d5anwrp345c6p8ms6mnr76384u
X-Rspamd-Queue-Id: E451F40003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782632870-728061
X-HE-Meta: U2FsdGVkX1/7+W4MI7cq/Wuj5/61+HVmW+l8sTJ+lfI0GTm5/8Dn8kqJNQ6mGPj4SwP/gRUyiRNgBrF1hCVXWUL5OAPhfSTE/1Rln9aBTnfoF1XpJuHh1TMx7Qy6NI2+ckp4MGRQ6Q2KZyYir+Bhst3UWPhuafl4EAdYOIJa2ugZvLBKvCLh0p6kckvZUMrxhBepPrJ9z+LaJOeSdxCyazzdX/if2+x+mRLuIXN0AV8ByW52FHuHVrrg89q741NsthloUJhCb2X044pgSP4a+J/oTeXp5xkurSxdIaFwOl8ccw3JDVZeJpPNXwUrFhD0P+JFU1cvNQCksAEcfyTBtMEF7U7muP6m4S7TmfMPKqTLRDUt4lcls4nS9dQYT/PduIhHwXAeNtSkt8zhbwALMVTFFl5rce64Txao0HLO8dpjCeNoVr5CWbrtADKYt9JXGlKoGbEkeqTAtBZUF9hq1Y+g+Kb2Fvxz93fr7Cuwxj/ALNzJhrpYNdeEeCV8w7mdr//YhfPpOug53jtpzGEn5ZAVEys/ORkOqFB4IuwUbwOG93T0sCVwGPiwR01FaMO19XutxOqUPzi79xaNVL1gRv02itPX3BnzWfwXGU7eH1n6V1/yPiIUuhZeO2A3gjdrlNtmK6fiUCr3Rnljoer0CkqS6nC1d2kyT4WcJ3Ba4iIKNHYfeqp3vHJ77aF5AQZeXsJ4sC9EWiL+dMbwiUNUYcjybYmGaFutra08sU2Bc3xcwnGpGJjLFaH8huO8eL0YL3GWWGTPmCGoU7tOo/Y1RcPHFcSJOO/yWRcEyWvJ+I+1g3p2BBzh5C9nk5FkSQbn8HGAXE3jRoNXRWCUKPM44TzDoIKPt5lxk8M/xEkc/Jqo3x/trP+TKx1s6ypq7dugqLYfmb/mGZo9pAzvQZJurvzQo7NKJot2V/k1H15ARfJ7S1etmbJZ3I27mYfjjXLh4BihlpN2GQsYwfeVAf3
 pzj8RkKA
 E4PVu92/JEU3n4+GVuWlJ5qNCWQFASpgm4O0eYHTbxSf552nKvQ3GmPx3w6l492QZPs+P1SauITs+Ius2Gn0x7sWhui0K0r7WBkHZICvRuoyaGdFRFel2FIB1qH5TsTqDzcI9VgZML7qrKpenUnVVe7EFV/B3xLeVO2V1F4495iLO8C+SSwbG2z/E/eyCvfWHbJpGuNp7fVdrjRnY38KfcwwIlS1DTTF7m5PgZP0MoKpPj5jYpQOOoQWebkvGLBfp9m2fJDXcCH8wCAioifM+uFl8ebyix2O0JrRBtw8Wc/KdEuKe906spG0OBklxF7LXKyP6+WWYWbdcn0wOzrL0+gvz5piMlbqotnKz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/28/26 5:23 AM, Shakeel Butt wrote:
> On Sat, Jun 27, 2026 at 07:58:12PM -0700, Shakeel Butt wrote:
>> On Fri, Jun 26, 2026 at 07:11:33PM +0200, Vlastimil Babka (SUSE) wrote:
>> [...]
>>>>>> Fix it structurally by removing cycles of every shape: serve the array
>>>>>> from a cache strictly larger than the one it describes whenever it would
>>>>>> otherwise come from the same or a smaller cache.  Every reference edge
>>>>>> then points from a smaller to a larger cache (here kmalloc-1k's array
>>>>>> moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
>>>>>
>>>>> This will fix the problem.
>>>>>
>>>>> But this will waste memory as we need smaller obj_exts array
>>>>> as the size gets larger.
>>>>>
>>>>> We should probably create a new kmalloc type to avoid cycles instead?
>>>>> (needed only when memory profiling is enabled, though)
>>>>>
>>>>> That would also prevent recursion even further.
>>>>
>>>> Yes but I assume that would add kmem caches even for users not using memory
>>>> profiling. Anyways, I think that is a separate discussion. Am I understanding
>>>> correctly that you don't have any concerns with this approach?
>>>
>>> Umm, the memory waste is a concern?
>>>
>>> Minimally I'd now want to only do that size bumping when allocation
>>> profiling is enabled. Ideally that means both configured in and not booted
>>> with "never".
>>>
>>> We probably should have done that already in 280ea9c3154b2. Because AFAIU
>>> memcg-only obj_exts array don't have this issue (or maybe they do have the
>>> [1] issue? Harry?). But if memcg-only should keep avoiding the same size
>>> bucket, it can keep what it was doing and only memalloc profiling would do
>>> the strictly larger thing.
>>
>> memcg should not have this issue as normal kmalloc caches do not serve memcg
>> charged objects. 
> 
> I am wrong here as I went back and see d8df600b67d7.

(8dafa9f5900c upstream)

>>
>> So here we can do dedicated caches as Harry suggested or make this size bumping
>> very specialized as Vlastimil suggested. What do we want long term? Orthogonally

Maybe long term we make kmem_buckets unconditional and use that.

>> we do want this fix to be backported easily to older stable kernels. I will see
>> how does this narrowed down size bumping looks like.
>>
> 
> BTW I think we need something like the following, right?
> 
> 	if (mem_alloc_profiling_enabled()) {
> 		if (obj_exts_cache->object_size <= s->object_size)
> 			return s->object_size + 1;
> 	} else {
> 		if (obj_exts_cache->object_size == s->object_size)
> 			return s->object_size + 1;
> 	}

Yeah.

>>>
>>> Suren's input would be also nice to have.
>>>
>>> Thanks!
>>>
>>> [1] https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com
>>>


