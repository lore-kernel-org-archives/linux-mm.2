Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457CB1073CAE
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A1A6B0089; Wed,  8 Apr 2026 08:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DAC56B008A; Wed,  8 Apr 2026 08:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C96E6B008C; Wed,  8 Apr 2026 08:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17E796B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:57:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4932C1A0B1C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:57:16 +0000 (UTC)
X-FDA: 84635389272.16.14ACF43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81354C0014
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:57:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AtIJfCqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775653034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zf2PIKrgXahUuF/JQlP2F8qFC9YCtti67OLMQoAICsU=;
	b=YEYGw/515u8GTEarLxzow6aByw7wXk8ib3dlAhuRIdVdgoCiKUn+ojrFgmQVmpFY4iFuNp
	c5cq3CZiZb753dCi1s9Bk0qkNgU0FRt5TvZmySosGogSquO/HrRKy1Dl2q77J4nHVQbdjB
	FB2sDcOGTmvr85hjksrVVzMHlW9rm18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775653034; a=rsa-sha256;
	cv=none;
	b=tbBWA5rGLj8DESj5qjMYijwkROJhI8cvsbzPBzS5cR2A5FJsCEUGHOmyuO0kkld0CfLzsy
	iGkyOemCa65geznod3xDDyySVHVOXNWwg3jLMuIiAvMBTdRtjTrYjUl/KUsUBol9kLorsM
	ALd5tKUnndOG0worDojfUWbmhF9ckl8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AtIJfCqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D55B600AD;
	Wed,  8 Apr 2026 12:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70E0C19421;
	Wed,  8 Apr 2026 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775653033;
	bh=rr1xzx2Eh6OHGsQ46VBfmOaRm2wD/OwQmkGUmzL5x/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AtIJfCqK2EPsOxsIOKQyQgg52/CWyUR1WE+DjPwboxmxtAJ3nSQXYnT8srGlgrkCg
	 e1OafIHm9kaK65lHNPIAVCX0ylYVJIwKKlvx0Lp2XD+/zkMiGFVnvC26a9OxDdgXTB
	 r+I2V4DhiFd6GGSGlkWUxXMiuQnhnXvf24KLBo7s6GvJ55SLXQH+b79p4FNHrVzv7a
	 uuUB+U74YN5ey9aRgMO/GyBrOi2y3Mq+Cb+WoHntP1NvBFSzTmDsRZ3uy/axh185dk
	 Nuv5tQkfYl6NSKR7jKhKSgoDDZP5dAfY3cZ5oTfZLffNVWruiR02l3q3BAjj9LGVJ2
	 JUjSo4IyajBKg==
Message-ID: <8332aedb-e499-4789-8f46-832df8d60224@kernel.org>
Date: Wed, 8 Apr 2026 14:57:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, xu.xin16@zte.com.cn
Cc: hughd@google.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, michel@lespinasse.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
 <adTPQSb-qSSHviJN@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adTPQSb-qSSHviJN@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81354C0014
X-Stat-Signature: u4md5a9n5oiqogqpyezx4sucfuieob4u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775653034-215385
X-HE-Meta: U2FsdGVkX18p9riibXuqAy2rj2TAhP4bnGAZ5KFDSdHuHnxBPn01QsT1Kw0MfNJf5E5/3DK0kONQI3oNe9dXeOlCK0Ur1RvmzHwcH0Le5lxC6r294Vol68GTwVpb6A/53S2qEgcfg214v2ta6lGXhs+ENAfQk/742HsvQgTo6HAjJ3qCWkil3V3WEwnTG0K0LQkc+pRpu/V5fM4UjnW/UXbSCmdF4d/XkhpJKTwgrNltdv0KdPMEoT+6hm/gpVEGSJqOlmiEv4NB5dQc5Ici4LMPOKX4WTftQOYezJxL6ovW5qfbI+VtSnVs2NkLYFbleQY5RRY5OoZtiMBQbz4eN88zhwq+jD7lHw8tfUYOFNDqShJBh+lxJq4QWirLPscfyiwO6c8l+SploIgreuraiOzDDdMcJSd3VF2Kaax4vt2iuOmchfapV6KAyKQhuYRECJOBE5JjtLr/mMH8y8kXKRjWMlHS74DAV9AJMaJRgcULiLGodGU+aRPbAZ01QBn3ryb5iT1EjrV/WludPWJNF1mTjugw06Kc+2NS3VTjtI1zPDt6z3gp/XESUYRQc1bntrbhf82bkPIuk5Z2t26sWKmxIuXadUVETu8sdsllV5c7qztJIn10ymle0bXBg4UNkcD0bGLT3FLuDpB4UWi08ki9EsBHfltzXApbLjwoKquiCQ2Cwi9U3XuzbF1Yxw5F/8W9x4nnKWs0Sm44/PURBSi0AsspxxNNXDHSpbBeUC1I1r6lom5a4veDWYOk15uGsubym0w7NTKTgKsZHC2G6kv14rjggXs1+b6UAubGn0fdPu2lrX9M03PuZBpoVsVwVUuhcUaOnt59aCN8/Ae0Hqd8N4c3stQSDpPr1/PBiWueVMP34eGFVM5gx+0C+LrVBFWuDXcU4qIf79I5vvwfLRWwOxxxl0i1u3Rn8e0Q4uTrkDKzcxYqUaHacbZhR4WOSCv4CCynJSSCuHOO0U5
 GG2SXPvC
 ojP0f4EUz+J7kyLoXpZNL/GH3HUVu5tWgLZqDxKHLMSKXVJAQxPwFVF5r0k9mGFlSUqKP4PrY7jGi+zxfaXbnhGNNXe3AFf96fdRTmHZaVmz6M5xpTaPfoBv8UWRg8glfIHV8YBE31aJNG7XqV4r0aPDY2HgIkI4RSgGfpa5DrHK0C2uGgYY0PTs6r74ghfx0Fjccbb8UjX8xDN81F1f7iINq4dWhwrlEgwKgz0RmaGLPZTXLn2iNIDpbUKJ7Wbrau+EGGH7IArnURBYcswsTPaLEb+dHQtjvehBo86CzXgj4wRjH2sNV4o95cYQLGWkl63myiq9BgJvL5l30uHXnPX03bNVAT4jJvbMCS4olCr224cE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 11:36, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Apr 07, 2026 at 02:21:41PM +0800, xu.xin16@zte.com.cn wrote:
>>>
>>> I'd completely forgotten that patch by now!  But it's dealing with a
>>> different issue; and note how it's intentionally leaving MADV_MERGEABLE
>>> on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
>>> interface to CoW the KSM pages at that time, letting them be remerged after.
> 
> Hmm yeah, we mark them unmergeable but don't update the VMA flags (since using
> &dummy), so they can just be merged later right?
> 
> And then the:
> 
> void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> {
> 	...
> 		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> 		...
> 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> 					       pgoff, pgoff) {
> 			...
> 		}
> 	...
> }
> 
> Would _assume_ that folio->pgoff == addr >> PAGE_SHIFT, which will no longer be
> the case here?

I'm wondering whether we could figure the pgoff out, somehow, so we
wouldn't have to store it elsewhere.

What we need is essentially what __folio_set_anon() would have done for
the original folio we replaced.

	folio->index = linear_page_index(vma, address);

Could we obtain that from the anon_vma assigned to our rmap_item?

pgoff_t pgoff;

pgoff = (rmap_item->address - anon_vma->vma->vm_start) >> PAGE_SHIFT;
pgoff += anon_vma->vma->vm_pgoff;

It would be the same adjustment everywhere we look in child processes,
because the moment they would mremap() would be where we would have
unshared.

Just a thought after reading avc_start_pgoff ...

-- 
Cheers,

David

