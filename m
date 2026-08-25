Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C76AC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881FF6B00D0; Tue, 25 Aug 2026 09:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A2D6B00D2; Tue, 25 Aug 2026 09:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797306B00D3; Tue, 25 Aug 2026 09:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 598916B00D0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:49:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA409120447
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:49:41 +0000 (UTC)
X-FDA: 85139924562.29.050166F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 91DA7140009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:49:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OryRtCXC;
	spf=pass (imf23.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787665779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hm2gUvfhpHXEbN+h51BDtN0eertigwioMYzJBWquQm0=;
	b=AYzWkjJf+hndW+ngg0YAT9mOcHkkEbDEj0H09By22khOawVpXtBWUZLy1anDuaKMqXunKN
	Mlm82wMgeQGiJP8+AJjB37mvagUDJzOKJObQzHtB4zqZbQssBOvrOCK1tUVVg0CtptzBw0
	EIhRHA2U/vU2/YjGEeioijevinDL2Dk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787665779;
	b=x+5BNz1g8WfTe4NSu67wl/NKflwhmxTsxDZIFqJQrUcbSZKxUFZGZXuJAvBIZkpei11gRH
	DgT3Y8ZQZEUOQ8fW0QOHa8eFWE5bSz2PEiaZbvTNfKCNuRRJI6YXk/tQU6PkA0H2GBtvys
	8FcgkkqJHYeo5B0La+MSO3mvirziQrw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OryRtCXC;
	spf=pass (imf23.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=hm2gUvfhpHXEbN+h51BDtN0eertigwioMYzJBWquQm0=;
	b=OryRtCXCW1dae7H9xpiFcrdPq5Ra6XujoD8TNELVCXKmF9MN3gc5NhwnyqfGd+
	za5PXSNO9zYsR8DD3p7HdK3IpojkXYnqDFZgXyiSXCJZVsxofFwOWHTcjvPw4w+N
	47XdRmgmUc7NwwTrlethsMUP7qqJ8XzZ/IqY0RIA9TEkk=
Received: from [IPV6:2409:8d1e:e12:7fe:b7cb:e263:e9d9:f20f] (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3v4i0nI1qDr1BRA--.57630S2;
	Tue, 25 Aug 2026 21:46:30 +0800 (CST)
Message-ID: <93d6e366-e7f2-4cd6-b8e7-96a9f79813d3@163.com>
Date: Tue, 25 Aug 2026 21:46:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/slab_common: reject zero object_size before
 calculate_alignment
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
References: <20260824092454.1693745-1-xialonglong2025@163.com>
 <ao2RAVvU5g9Am7_J@fedora>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <ao2RAVvU5g9Am7_J@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v4i0nI1qDr1BRA--.57630S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFy5uFWkZryxCFW7JF1kXwb_yoW8uw1Upr
	W8Ka4DXFW0qr13WrZ2ya4DGFZ5t395tFy7CFWaya18Xr98uw1kJ398KryUWry3Gry5GayI
	vFZYg3Wv934UGaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zReuWXUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:b7cb:e263:e9d9:f20f]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xZSS2qNnLbdBQAA3B
X-Rspam-User: 
X-Stat-Signature: 7xhi5maehtocxksozxfcpwesoaakbkex
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91DA7140009
X-HE-Tag: 1787665776-908901
X-HE-Meta: U2FsdGVkX18HJJYNxtvorWx6J8zmeHyZubgtiwTx0UXybayeVx4XVtTiYMaqAmFEubBNXVhvYCKGAaxSRm56dCyNblx4Bej+A1WT2VVOY+FBMfRrfhGPQtg4egqvGTsyb5QiMdHluSjArxAC1wC2dnTaCqTmUaDy+iFv48u3LMHcO0YwJP7Hk0aKx29K4Pbb/rhL9nqxX7u50BZoIYEGnP8Ixi5u96fkrGh7W/jXHJpbVADmLQKR87dBmxtb1twqRefpccBHYgn2H4hoWXFj3wXCfayuzvEnwit+soJwrQF8w3JqX0cmIkad5dPoh5FjWXZsAJqXCbbulR1fWHO6ojqvtJMh13P10exlJVQRfCBe+QMTnmFNy547hD9QJegGTVvjFHK8oPwWtB3/NB2P3V8DDWGHlCO44ZQcLKFwBWT/JvllYbYEA0M2Wn1cP0qse3SEQkxl+seeQsdo88oaGrBnvfMEQDVM3SpbkHtbyJtwH1jb3Irs4UGfkJmiySomom1UTvx/ZainLuHOwiR9i1yeDPcj/O2Oj0NvDObXE72/SgN47BJVbV6F1VD75CyByVS+AOMkN5rFrFBnSxpxZf8+xHoRpOf4mHeXYasrNYGrOhgo7AbRwHLTIPD4gYQ8inEoO5nouJrzwy8zVChsgxwYWqcNH3K83ZkSYiUmVYtFfwxGzxyWEzoyS33My/pwZGGSC4ZDQOAzqhDAWcBblO1fuB3x2fFXagLi90xHw7FNCfB+RYoxXQe6ctn4y1aM3IWvtx0z42XL8niYBIaglFPVd4OzAm14xjMXluGhM8ySIRWhTK6ZhXhy6TzWKoDHFbnT7QMo6U2XiaNRDJDKVeJUMmqIJSPPYI1OAamjBtDx38Ajcfz3ykJSx5Lu6RAWxYS3lk2I/DOhZwY9t+dHgDAJusQAF8fUcO5au/sZNZAN61P2aAWghPiSXSIJ82VSpZ+gusUdiT1wkYXX8Y6
 kKvH8SMq
 QochIFR0enSNs471Pi78uCicX+s1WgNVDNycBpKxgHh+4k3BiDzPx94O+dsAldERprg9ZQJWgyeWNGehrwVg+WsqLPag4h0YUv3dDnG7LXdAJkYFJbTR/pz2zWCdXICoMz7M6X0SEUPHURbXBnOdpidS4WPU0siHoi04UCqS0mCGh4r4C2/daL6mfD+JTvxmN+0BayQ9d0IUZNJDIoq7Z7Sjpbiwa259RxlWpUKBSgk+d5Oc2tYGIvxYkcBtI4DRT6UJMBaqTAGOlBYDZMU09kVIrY/z84XcUCsbRe/0L8iKm7i9wem0/U+408kHq01JQHWHUWq3kkMRaq4+3BUbD0ScOYkd8cSODwmh3T4dAjTUP67JJ03Jg07QXXwO9O+z22ZxZP3IXF/7jSm/yhcbTpIsGrIPH79Jjg4uvGCWefx0nag69301qtHoIuh+Hcer9idv0J4rFqnlMVHwBfWJNFK5Glb4f02Oo3iImLFHDCylZS5Jbz0WndoXvN1h7BeArDM3ZRygSHMte/guOmpLKI/l1B9UKqBc7N2pj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/25 20:59, Hao Li 写道:
> On Mon, Aug 24, 2026 at 05:24:54PM +0800, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
>> while (size <= ralign / 2) loop. When size is 0, ralign eventually
>> reaches 0 and the condition stays true indefinitely, hanging the
>> kernel.
>>
>> kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
>> size == 0, and the sanity check is compiled out without
>> CONFIG_DEBUG_VM. Add a !object_size check in
>> __kmem_cache_create_args(), which is always compiled, and add !size
>> to the DEBUG_VM sanity check for diagnostics.
>>
>> Assisted-by: Codex:gpt-5.6-sol
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/slab_common.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 657fd75776ea..209fe838fe71 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
>>   
>>   static int kmem_cache_sanity_check(const char *name, unsigned int size)
>>   {
>> -	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
>> +	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {
>>   		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>>   		return -EINVAL;
>>   	}
>> @@ -354,7 +354,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>>   		goto out_unlock;
>>   	}
>>   
>> -	if (flags & ~SLAB_FLAGS_PERMITTED) {
>> +	if (!object_size || flags & ~SLAB_FLAGS_PERMITTED) {
> under !CONFIG_DEBUG_VM, I think we ignore the sanity_check deliberately, so it
> seems we don't need to add !object_size check here. right?

Thanks for the review.

Right, agreed. The !object_size check duplicates what 
kmem_cache_sanity_check()
is for, and that one is intentionally debug-only. I'll drop the
__kmem_cache_create_args() hunk in v2 and keep only the !size addition in
kmem_cache_sanity_check().


Thanks,

Longlong

>>   		err = -EINVAL;
>>   		goto out_unlock;
>>   	}
>> -- 
>> 2.43.0
>>


