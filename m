Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A97CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642026B00FC; Wed, 13 May 2026 09:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF226B0103; Wed, 13 May 2026 09:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA636B0104; Wed, 13 May 2026 09:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35FB46B00FC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:34:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB9ABA0129
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:34:20 +0000 (UTC)
X-FDA: 84762490680.17.BFDBC5A
Received: from mail.kxxt.dev (mail.kxxt.dev [74.48.220.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 183C140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:34:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kxxt.dev header.s=mail header.b=cnDIdqmA;
	dmarc=pass (policy=reject) header.from=kxxt.dev;
	spf=pass (imf04.hostedemail.com: domain of i@kxxt.dev designates 74.48.220.112 as permitted sender) smtp.mailfrom=i@kxxt.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778679259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psldIh7n5nVm+Rtaa/u/V2mN+7zDFvNrqqhD8DETpec=;
	b=j8swRJwM1UCWgyeEYNVrBZnOJMIV725+S3LXsKWIP5w06z8UtFTHO6kwomRnWDKWBPWwMH
	OJfM478jBDpwkSifU3kw2oX33Ep3+tC7xL7LyKI7523AA5GdHTEXbe9sFMNSaDkQ+KSUTw
	3+52gjr2E9bK96anIJDqMHMjgqclcMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778679259; a=rsa-sha256;
	cv=none;
	b=snUCah5ExzWtDahgHxKTcS9aKwI1Uu4XKWRBaj53lv+Aba5NPXI2zM7ryAef2i+YXZgHaQ
	XYkHeYeKmMxIb8wK1i3B5I1bopNLODgdQRhbXD1uxPfpvQbnbAWEU0j+GDOGa996jq77bO
	dQOAFsu28zjqu9x0SX+AHzhjPFCDFvg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kxxt.dev header.s=mail header.b=cnDIdqmA;
	dmarc=pass (policy=reject) header.from=kxxt.dev;
	spf=pass (imf04.hostedemail.com: domain of i@kxxt.dev designates 74.48.220.112 as permitted sender) smtp.mailfrom=i@kxxt.dev
Message-ID: <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kxxt.dev; s=mail;
	t=1778679251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=psldIh7n5nVm+Rtaa/u/V2mN+7zDFvNrqqhD8DETpec=;
	b=cnDIdqmAIHI6Z9i4z4Fzs2EgIEwvu2fhMHxSHYx+jsmh8WYew61/BNiSh0bx8nzbKaH+af
	zFhayDHFZ1xwBiOthGyJumxVqCqWydEyxYNF6q9l7ytT2Ox5SnHaiIhIQ89GBqO5zCbIbH
	tTYxOBSg9VU/hAcPpU3jnyl7QjNEVCE=
Date: Wed, 13 May 2026 21:34:01 +0800
MIME-Version: 1.0
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: linux-mm@kvack.org, rcu@vger.kernel.org, bpf@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Amery Hung <ameryhung@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
 <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
Content-Language: en-US
From: Levi Zim <i@kxxt.dev>
In-Reply-To: <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 183C140002
X-Stat-Signature: riuzk1tmm7pexskwhehrr4zrs1psapqy
X-Rspam-User: 
X-HE-Tag: 1778679258-988841
X-HE-Meta: U2FsdGVkX19fJgZNsYBCAfjQ9qvokz/aCZwvFA/WuNhJOV6B+vX/UY7E0n28eHJyKgBg5C5QsAPj4/FtOOBBqrlTE6f540d+fUP/FKxNRwIudVOHEE9PdjJWu8wqQRC2bPnDaowifGLh/1QWgXLcsMJ7DAauwJayY0sA4Hb3xvJldLaz/OWji/1luNaat3EVBXbvFBK3WLMCLIyg4q7Qo898LPDyDBGZAczEK7UpMRuoIqSVlC1oAukbL5ky7vVKXY+gIzzEhFoVmb8qSu7+hNdG19BjtYcxUvxurgiX1n0Frx7LoRsNB8x1cBK7XH+YDJ7FiiMsu8ax4iSaxw6gIHo9HpavZP6M08ZJmA5jQ4JScxaqUKiuQe1RpzHgNLnyRzZ/ZtULAD2uduWM+iCloGWhEsRWu9ptiRBIYcBtAbmXu+WmQgoCW/mOe2f5wGkcsCI5xhw7CwmDcVJ7thN/UUBGgnQhCWkGL6pS5L+LyemZvyFbqbwTPnsl3aERSNR/ABZ5cMVNI2ZedzH/96m/ZZ2jpUId0L9bLoNIsoPrLK3LhpLumA0r+CwqaDlUhJTsHuiIQiXwd/sApFGKOSDY0pBPmRmxJG8sSVdisUA4PKfJdY6C5/hL0S5nrDnnUeZtnYeM5qFZp4EI1pKCGWlDtUYGJqknUbyuqo6LeDPf4ao/oWTXJ7xfYugYcFg9ASkiPGTY1kh93IGtW5G7ENmGHcpya8k+Wi+BnnxKIJK56OrDU+4asIbbSOP03E5nfoLLF1B6M+7erODGy6Fwn6I5UqAqA6TONv2fdKLebgmAoXTlYmevYomQ3tuJqqnNmiUb/1VlxZXYcSNzBW649Ceadvdha1n++J1DtcWz7u7BKKWvH4x1hX3SafukRRR9cz+dhANiOehnSyQ5w+SnfQzgASfdgsbQoVt2cieI2v11wV/WZe8KrCnVj95Ed8bzXlOG7m/kVtABER91LRfHQzW
 e5dIYKXc
 N5WQmBr3dAfoOhFjh4gkJ3xRk3B8DNB0sVZ97pk5yQrh0+XdixHbKKgq/GUWGfkTpJT715AR1uoXMdUU53tW1lyrgO0V5s20qHjspaZltFk7FuTNcRuHdjkS8ToQFkbSGhjQLg9Dv3u7Il1JlkW+uCGh6mR+kQaQUR3zyfXl/aPuygGSzSDBhnK8syuAvhTsEKmFWAV+Q91rN9wEe9XyWfW8DeXpuPO1osXCPJAelrfL/BRneOFWK5iuX2q7LWby4V5tYoe0rgUyLC4yHPWwIQEH7Eu94zyFk2DALoifSIPwiDSw16BLDBbycqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/13/26 9:42 AM, Harry Yoo (Oracle) wrote:
> On Tue, May 12, 2026 at 09:46:33PM +0800, Levi Zim wrote:
>> On 5/12/26 8:25 PM, Harry Yoo (Oracle) wrote:
>>> Hello everybody. This is a follow-up discussion of
>>> "kmalloc_nolock() follow-ups, including kfree_rcu_nolock()" topic at
>>> LSFMMBPF 2026 last week. Unfortunately, many RCU folks were not there,
>>> but we can still discuss over email ;)
>>>
>>> The slides: https://docs.google.com/presentation/d/1kpaLd7D1dwRvIqRwQfSjJVVJL0CC2gwb-AV56yCMqXw/edit?usp=sharing
>>>
>>> I'm copying the slides here to make it easier to reply.
> 
> [...]
> 
>>> The end goal
>>> ============
>>>
>>> - Drop the BPF memory allocator
>>> - Avoid preallocation as much as possible in BPF
>>> - Use kmalloc_nolock() and kfree_{,rcu_}nolock() (and friends) instead
>>
>> By using kmalloc_nolock, a regression happens on architectures without HAVE_CMPXCHG_DOUBLE.
>> For reference, currently only x86, arm64, s390 and loongarch selects HAVE_CMPXCHG_DOUBLE
>>
>> For example, this has already caused bpf_task_storage_get with flag
>> BPF_LOCAL_STORAGE_GET_F_CREATE to always fail on riscv64 6.19 kernel.
> 
> Ouch.
> 
>> I attempted to fix it in https://lists.infradead.org/pipermail/linux-riscv/2026-March/087159.html,
>> but as pointed out in the threads, the approach is not sound.
>>
>> After that, I thought about using the BPF memory allocator instead of kmalloc_nolock on such
>> architectures to fix it. But I haven't got time to implement it.
> 
> Oh please, let's not go in that direction :)
> 
>> I don't know how could we fix it otherwise after removing BPF memory allocator completely.
>> Could we find a path to move forward without causing regressions on architectures without HAVE_CMPXCHG_DOUBLE?
> 
> Probably we can. Could you please see if this works for you?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=slab-kmalloc-nolock-without-cmpxchg-double-rfc-v1r1-wip

Thanks a lot! I tested it and could confirm that it could fix the failure of
bpf_task_storage_get(BPF_LOCAL_STORAGE_GET_F_CREATE) on riscv64.

The commit message says that the allocation may still fail if the slab lock
acquisition fails upon the first try. But this is still a great improvement
compared to the previous always failing code.

Thanks,
Levi


