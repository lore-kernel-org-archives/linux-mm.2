Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD81CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E649F6B0098; Fri, 22 May 2026 10:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17B66B009B; Fri, 22 May 2026 10:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D524F6B009E; Fri, 22 May 2026 10:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3B756B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:44:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FCB71C060A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:44:30 +0000 (UTC)
X-FDA: 84795326700.19.AE80A2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7365120006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:44:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0xk8tYT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779461068; a=rsa-sha256;
	cv=none;
	b=5qfFPoD2+NuqRdIr94VDmzAug8v/1lTKSMEn9P5dsMxG3L9orfz+wwUkpljzTIHxSwr/8J
	5mPDapTQ2rKXYysYSf0LR7AVJV6IzObQ4RltZoBD4f2Xr2PN1NHRbGU9CG/4D45eH8nTGB
	dfjAHM23u5zhkLLSC3F/kh7beGEXmdY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0xk8tYT;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779461068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DF/A+szhwbuz+2nSWgzzrz066HQqGdxgJmdWKxjCuo=;
	b=JMAUZfA0Jiya9GjGH0BU5tltYw0hwpeurYLeiVvROer0PVn+1H5UHijuFQ7cL8iOaNGQLe
	UA9Ea5jX96tyzUYGsKKkGxTIJ20Ka4JWX+srPS9vnvh0LgL9pGgIU0gnf9Qwg7AImTA50O
	qDLQTWsCZfmrDuabRyT+9TG3FzOycmg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44A8F60138;
	Fri, 22 May 2026 14:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B6B1F000E9;
	Fri, 22 May 2026 14:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779461068;
	bh=8DF/A+szhwbuz+2nSWgzzrz066HQqGdxgJmdWKxjCuo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i0xk8tYTlnWycUambv6K+eaDirNs91oo/9bqoHEVJrWXsZF6necPPcXFDXqYoUQKV
	 Vbf7u8j/Xq7olgoib1EOlWPXuCPt7t+ftRFi7r/iYy5f7dnSlmtuFjZ+nlI71CTG0d
	 pE13nZMlZDWLc/+h+4j8vZlJ/i65Fj0IfUMdJj8IR5FUVbGqUoAMYT5lQLjA0aMe9/
	 +Melr4BVyao+Xe1uXmUk867+EeEjIDeVebjX+KFUIssNwftgjnti6z8fp0byFQ/3gg
	 K3UmjyDiIazNeZy2lM3FhWe+rCSGRXLBbqRvyqECIrOaH/GmDqjBWNTbqtpqzXQsyK
	 5a04dTMHSDrfQ==
Message-ID: <e14c0efe-1b4b-4331-934d-162449fb7291@kernel.org>
Date: Fri, 22 May 2026 16:44:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm, slab] 298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Content-Language: en-US
To: Oliver Sang <oliver.sang@intel.com>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, Hao Li <hao.li@linux.dev>, linux-mm@kvack.org
References: <202605112204.9382cecf-lkp@intel.com>
 <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
 <eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org>
 <d28b4a2f-501a-45dc-8589-acc41633e2e3@kernel.org>
 <agp1kUJSzZqyJO81@xsang-OptiPlex-9020>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <agp1kUJSzZqyJO81@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C7365120006
X-Rspamd-Server: rspam03
X-Stat-Signature: p7tmi8jqwnuia7jsphocpod5m8sinim8
X-HE-Tag: 1779461068-489035
X-HE-Meta: U2FsdGVkX181gnxki4lLtV8Ek0/AmAnTomjLUZmBfCnh+GFYLLoVNhSTyd+GrzGKoJpBzeiVltf/COBhivIU5mVkcOWJ65ey7W/cDv+1pOj/P+Nh5QmIWJwXkeSkedPgQ1xIStnIMxJ+tDNFnbQ9DjJJPAUh+bl3R5jlojMigWKD9USMnw9BPkIUZPmBqz+WX8um9V7cODwWg1/VqVYACFpsmi40Cuf7JyrWvRvr+8CjTqnFOgZKobviOS+oDg/h2Nx4B31/AUy6BVBOQ1RteqAGDd0K3xL7jGBVcULVX4Z2cuCUrFARBhljxLF8AG/BNKUdsIm084Imby9miy4i+0XDnQtUtJQYhF6LbJw9LYindQjirxv8rk4MlzOXQ+qm+UHjI04YoE1lPA9L0KPREVeDrruHcJ9OlRYTyw4oGXD6xaLPtDkLTIb0p8mNU+G1pVgLJake5k2x0V1IPzO2NfbDChYdoycMkZIaQ21gBnbS0JswO/XN2UQgGgIdBuH2wHU2sm1D0IyXwaNVdNw4TSZvSg+YMITG0fYVYFJrSvIBjolc/fpNU4m7DucIQdwNxgUlyksh6ucW4ogIf1+o7hKANqpl7AJ13LC0Agc4Et2KbDmu1IOTPqIu5NZAjXtchBrXjl+idXqZ3sVUedUE6Ru5v2QMUo2VSQUadq2gFP5adsKWxt9IKD1L5I2WdICLOPhiXyKPrUdLLm1FDTWgB5QJycE041rcWljtocvhr8670BuPweuF9e3yHBujUA+GC/gzrdqQu5VjNY3h4lpzqaKQNgVANIvHRKJaTrRaxsSwnzUGWH44QamfFnHvpCsTCfFkdl0G8/QjTvAeBvn3Lg5iecVfQ/61ReW97vzf11ClhLFdorrVsPoREaOMowXLz2YZnFm1K36OIiSMcaftuwgUUxRxh7akwz/XGraUYrDTPLCXU6UAY8Aa7+PA8BOyFDrGQwzbFttAVr2GZs5
 2KR6pzp7
 fDwMV9oP3Ch78oV1fiR+Qo5LOTXudN5W39Gph1XJws9xv9azC7GmB/Os8T+qYHmuo6YhA+a7vGcvyxPfCsxVDbStKulYz0SPjbIEbz9KNyaY+0nvCE6t3EkGbSEeNiBMDMXn9JBwTsGD6RguZaakotG9NLSwxV9ZLrVi0Iejqnw84RvAZAYSzUTcnjKlmSBwJnU9nodDa7H6dvDu7uOODOw75lpMpCH+dP4NcHhO7oLBjIoUu1BBs0LkHfSohpBsicUi7DmbLVv5a1j7ZGNDkxHuw6BHX8vnjbH+e9cG72dptTIBc2IRWNimXQOmvn6XUP5Oh0b5BIGYndWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 04:12, Oliver Sang wrote:
> hi, Vlastimil Babka,
> 
> On Thu, May 14, 2026 at 06:02:59PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 5/14/26 18:00, Vlastimil Babka (SUSE) wrote:
>> > On 5/14/26 16:45, Vlastimil Babka (SUSE) wrote:
>> >> On 5/11/26 16:45, kernel test robot wrote:
>> >>> 
>> >>> 
>> >>> Hello,
>> >>> 
>> >>> kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:
>> >> 
>> >> Yay for an optimization that was supposed to have no tradeoffs :)
>> > 
>> > Does this help? I don't expect much, but perhaps...
>> 
>> And a separate measurement with this on top of the previous one, plase?
> 
> we applied previous one in [1] on top of 298cdbf5f7, then applied this one on
> top of [1], the git tree is as below:
> 
> * 487ba8f16af85 mm, slab: ADD_TO_TAIL in __refill_objects_node
> * 200ca7702bc5a mm, slab: simplify __refill_objects_node
> * 298cdbf5f7c9e mm, slab: add an optimistic __slab_try_return_freelist()
> * 1f7c8e1d52428 mm/slub: defer freelist construction until after bulk allocation from a new slab
> 
> in our tests, it seems 200ca7702bc5a have little impact as you expected.
> but 487ba8f16af85 not only recovered the performance regression, it now makes
> the results a little better than 1f7c8e1d52428.

Thanks a lot! I've reshuffled things a bit here, to put the changes that
were not impactful as a cleanup after fixed up version of the original patch.

https://lore.kernel.org/all/20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org/



