Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0308C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859FA6B00A3; Mon, 31 Aug 2026 23:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830D86B00AA; Mon, 31 Aug 2026 23:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F0D6B00AB; Mon, 31 Aug 2026 23:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9036B00A3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:05:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B26661A01F4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:05:38 +0000 (UTC)
X-FDA: 85163703156.30.A81D108
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf31.hostedemail.com (Postfix) with ESMTP id B20A520003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:05:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RzCg2EyL;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788231937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5BxyLRLxa8TYSgP2v0wqtE7VNxwkDSM7heKgfXMMiA=;
	b=jLAesX2NRdlQ0bl9XOhodhXmrbSTdn5T2HooT9vgl8olYF7A2nhEbOJ9ymIvEIn69oC2oW
	cCFO9yVgby1H2xJzE8yHOXRlJf5UU/y7fwqENcpPmxZhajzIL6X17u9NpgAtp0oBe2YUbS
	caIlagGk9cdTnqStk/J8ZmVpOcpcPHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788231937;
	b=8WlkN+D/RbiWjxOJhoJIYg8gUjBC/sQ89g51jxPTQ4xFKlh8L3MgFvhfCP5/RG4YlLRMwA
	a1+1IRSR4aISE+U38K5MdF6BzkJZ2S0AFOCHEljxAK6gidl2mV4Cx4L2dAHfx3QNESHccT
	v7TEl/82kK00DzoxRThwyZVEZ9aU0hI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RzCg2EyL;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=om/9bGBfkYvM+IJmkkqUPDFd/PD2WvlDipw0cZRTGNE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788231935; v=1; x=1788836735;
 b=RzCg2EyLX+DLkWdT5WwAUtyG2TSekpBJmYi40rJg2sjLfJcqww9e3QBg8c5Cw8UhjU6CLPgO
 lwUTqHb3tHJPHRAzJKi7/uMXWZvcESuAZ0Fj2Mzkzgvg7xOHH3kOgikMZ6PfyRMGj8hB+4dSqhH
 Y3yyds94CFHfvZGaiiPNDRsU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 83324dd7b0a9859a;
	Tue, 01 Sep 2026 03:05:35 +0000
X-Mizu-Trace-ID: 83324dd7b0a9859a
X-Migadu-Flow: FLOW_OUT
Message-ID: <b59449c6-d2b5-4b0b-ada4-7630e060ee7a@linux.dev>
Date: Tue, 1 Sep 2026 11:05:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] mm/sparse-vmemmap: factor out shared vmemmap tail
 page allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-3-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260831075342.57563-3-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qwkanyxxbpbs9843h6ooz66g8die9onp
X-Rspamd-Queue-Id: B20A520003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788231936-52972
X-HE-Meta: U2FsdGVkX19wAAv4NA0DH9azg/WpgeOqgRDoT428Ylb+N5a1u0kraAZa5W6J/OT7AmdxG9OiYzr1kiww+mpFxCkFAYaN08xHWIAp2wSIEobcSBsy99VQRhMArYW8xnOxZR22PifTWjOP8xGBpKbm3O3+aqu2FVFmgh3hamlWT8tjDsgonrgO84JA4ZquSU7cJgj9fLpXMcSVB+9g3w2oUUBPmlbxjdhyCr3J311bBn61SLBwlND5VqIrUc4sUeEKQvLEIkfIHLjHc7XerORxj2IK0G3uV5ClGEd0JP2pulW9g6V01tlI+wi6F+Xy99mu5xYma2BBbA6LjqosPNMSXqAC6YczdI/0I/fb7E+ydsMTkt5WCWtd9U5WZXRyGzwEPMx7SuXJhZcymbUXTJxjUxPpli1TLCM3bDIopVmqLcK/3Dlz5Wd7BSaiR/4Dh7HrFsSy6BWjH1PgWqp+pAtwEZraoTmm2xEr7bxNj4oENCDcOaR7E0qf1bCDC5sD5m5wutBTiZn1fSwLLrc3UMsJSF1fDoriOV4SyUrlUR60OpOX0iw+vMHCZYoVdwBtQY31krEpmL7lUSn/Q7xTwCWRBk3Zk4nq1AKZa2b7FaJBiTWVILFDY4FSgKpWPoPIwVEvsNPJMz9GPZDOTKTgn/ZwtR1d7KVEX74BpMDxurjMznrw+5IuH4gpuuu0h6eAQi+Q1Is9BhNmX4QQ2eAckDDymRM2pvNgT++41lsDXvHklfYqUgsla1YFadXwFAiDumPzCYF2S2vKFSwvL0gJUko6iTFFDGL4JrMMx1z8ndeCidp3hvYh4Tf0mlt+8CfQy+l3n3NmYcY4bGiOHYd0clrHKWkyZ5kT+Uwy2rTecAD/GsEM8vWlfDbDubmoHo8a0henF8YHmvMozm5hmwjhDzqh+KOXpHUeAGOPV1f2Wdub0eelsCDWggUEbJB75xxswriYn7DJr1INmZ1A4RADVcQ
 tMF83U3P
 +c7MZyOoSTJeoPvdQdc+S8QOjvfgIBNThtRTCG6C3eKOhyRZ5Y9afYRwa1xHeYU2PBmw625oPJik8c6cpXvfDvmX7FMCD3l3kDXvqNphR9De0Qiu7t6+LLWavcSAE2Of+bkGZrVh1oHKDJi1ehFncgRyopEHDMswU/n81ThARIwZXt9T/M4zEr6kkEqVX509TyYcGeMItJZAcUA5sBYabhE1zvRVSnEE+CgEal+V7w7Tp5Um9s7oFiNvaDM7H5fdry9c15wX9Dk/yokbLzu3KKgM8PMMtsEN2FPW4mtSIVc/hCTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 3:53 PM, Muchun Song wrote:
> HugeTLB and sparse-vmemmap each have their own helper to allocate the
> shared vmemmap tail page used by vmemmap optimization.
> 
> Factor that logic into a common vmemmap_shared_tail_page() helper. It
> allocates the page through vmemmap_alloc_block(), and uses cmpxchg()
> to install the per-zone shared page.
> 
> Expose zone->vmemmap_tails under CONFIG_SPARSEMEM_VMEMMAP to match the
> shared helper's build condition. This avoids a
> !CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION stub; when optimization is
> disabled, the array has no entries and the compiler folds away the unused
> paths, so no storage or runtime overhead is added.
> 
> This removes duplicate allocation logic while still handling both the
> early boot and runtime paths through the same helper.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   include/linux/mmzone.h |  2 +-
>   mm/hugetlb_vmemmap.c   | 28 +---------------
>   mm/sparse-vmemmap.c    | 74 +++++++++++++++++-------------------------
>   mm/sparse.h            |  1 +
>   4 files changed, 33 insertions(+), 72 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



