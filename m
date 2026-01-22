Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7F4DC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D226B00AC; Wed, 21 Jan 2026 21:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9C16B00AD; Wed, 21 Jan 2026 21:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC0D6B00AE; Wed, 21 Jan 2026 21:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A11B86B00AC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:17:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42ED2D4F90
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:17:13 +0000 (UTC)
X-FDA: 84357987546.09.26DE0E0
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id D405540007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:17:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vxVaWm4o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769048231; a=rsa-sha256;
	cv=none;
	b=xIovoNgb479+/Yh6NBHSMi080sZDotLmuo0aYTtvn3BtDmpFDu18DBM8OabEsJTTYex/n/
	JUD4MVCkzH16AkgzFxkwel9ZZecKOkVR1cJDXMSZLCMKnxVnwdJg4LoP6rRyAwWtlnDXpf
	hIiBcRQ0zbygx2pxPRtcIMyBgKoRFaQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vxVaWm4o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769048231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+C6AtOWHzYIGqfm/rwPb/eSNwaxZ0ijqjDnRreQERY=;
	b=4fhWriWhQ0wVE4t9IjzJ+VXrFNIGCAwgVN4ZZb56tRkYOLndBd52m5XLxmPd2r4mjVfPWq
	reQ8K4mY+CRic9dnPafAmozefOP2OnEFiNRkpOR0HnTKVlLEKaDjY1bW9PiR39v6aeDORm
	D5nfnOILLmoev0x4AOEPGGmBNhqDVI8=
Message-ID: <e47fc0e7-b941-4504-8d69-a937d4d18be5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769048224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f+C6AtOWHzYIGqfm/rwPb/eSNwaxZ0ijqjDnRreQERY=;
	b=vxVaWm4oPNUgRXy4kjIxipzVZgD6lz2Zb7uQ7ZKeIROuiWh9Vu1mqypGiE2r/sJnSwmpak
	T/4pNtt2hjKXREXc37HmPzmnd4B++kFCf/zyct0CHyOVMlgk4sdB/q3BsgTf4E1pcIGgGg
	4vZCql5IkHvgdufTZmrQGhCF/hxpUs0=
Date: Thu, 22 Jan 2026 10:16:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: Fix iterator variable usage after swap()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 zenghongling <zenghongling@kylinos.cn>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, dev.jain@arm.com, akpm@linux-foundation.org,
 ryan.roberts@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 linux-kernel@vger.kernel.org, baohua@kernel.org, Liam.Howlett@oracle.com,
 zhongling0719@126.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com
References: <20260121081343.713715-1-zenghongling@kylinos.cn>
 <ada6d430-fe18-4db7-aa1b-96a03f7af37b@linux.dev>
 <f9bfaa03-bc02-4379-b542-457015053e5e@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f9bfaa03-bc02-4379-b542-457015053e5e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D405540007
X-Stat-Signature: 3pioeexrapmrodh43dqmrtq5ujp6a7p4
X-HE-Tag: 1769048229-81049
X-HE-Meta: U2FsdGVkX18a9aG+VUKeu/SOoDmG5dv2xcHctzGXQC4+++mIb9Tx7qhcK+dUz8cTxidmx81loFI7JgfMnfSgmF5gc2Xu9SLuq9XGeY9lS/Q8rcPfEb+pMuWki0GPmPCEJse8inUxAUCcVTrhxzRQCWSlbm4g5tgGPKskbqLitI5XUHDnIuZWMJFY6eGvU4IVo+fvvarjpLiXQt6JqcX5SxjVEriTW47/IcTN3BvZBAcZ3v650dxEPHmDvWpYgJK09Pf/WProg3nWMShGcQexW5ffIt0KIeuAkQ6YrTnGHElVGeR3Q6B/I8v992slcPRc21n4HFLAnH1PrPLfJMKDHIeIgD4BX7J/CfO4yW1GvsxTi/xJQ7g+Wv4FZqeicQqj3XDpTKz2FpKJ/rlSlzmXY1UIYe4MKo5CJmMm3SBRW90KN+tlIZ72rLHajzz0/6TqDQpyM5+0aqlfrYlpsMFrk6avjRNQtIguHWbRsRH11QBdiR8iFOhYDMbVL++hhzd3ovcfCe+IuzP7VnA1oUYe2EH9WBMZg8PTdIY0ius9aXmZrhsBbRGl7LJMDXGjpCzC4VkvMaWhSdDXlitm6aMztcoj5tlat9f8rQZOq4MZrua7CiI0a6/rc8GI+ekdqGAzFoYr2y1IEnusBjYokTxA/59gG1WCbXHbCgve46sqwN9SdY5HvECWTUsgnOfWOciLDVtId09ll5KN4pT/l1yZqVzCo6oRyVJVzRFyyecf8zaPf10yVDuEWrFEn11r9N5SSxg/tdzKT2I7c+SpA26cS8YuSY6Nm6T2GTbBTw57kBNURH4AHX+qtDaR++nqiCMlBFpVGya7Fr5jz95z4kJSAqyZeQNjyTpmjxwVJWMWXM7EDcbJ8vWpRECdJuugIWvdR9nFkZKCXeek/N1Mlg4JqGE9aGjXhyK4Psd1YlymhjefND1QAgzd8HgCZTyEB2tJl8Jt2RtDMjKZKdAtzZ5
 Quq3xJPa
 KCQl4Qp0d+Hwo8Th+kz2a9lplZW80kMS1aBf14jyymvf0IZtEXmOYrA8Civb9iYB8hlLmwMZ+dblQa2YGD3YC7ICvD14E1EcO0pbII2FQ5t3dHTu/GIMwIOj2Oaxy/Vh39WB2Avkg8QPUjGRn8cSWMS2Jkl9XQRMygNYowjSGMASrd1TfFJCbV+bilqX4ZE5HdDM0CcGBA0gYTFOM4ekMOvTykHl+Y9yEcUfAjcUi767IFZOyYE1bEaVsn4aIBZOtQqBs7t7F0E+qIwqem8LCRJFOEoMCT1S3bIT5CAkmfI3xPsyG1XbzD2p9+JNuKUmhBXGZacdu6m31IK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/21 20:28, David Hildenbrand (Red Hat) wrote:
> On 1/21/26 10:25, Lance Yang wrote:
>>
>>
>> On 2026/1/21 16:13, zenghongling wrote:
>>> The iterator variable 'folio' is swapped with 'prev' in the else
>>> branch. Using 'folio' after swap() checks the potentially NULL
>>> 'prev' value, not the original iterator value.
>>>
>>> Fix by moving folio_put() call before the swap operation in the
>>> path where swap() occurs.
>>>
>>> Found by:
>>> ./huge_memory.c:4225:6-11: ERROR: iterator variable bound on line 
>>> 4178 cannot be NULL
>>
> 
> Which tool did find that? A compiler?

Looks like a false positive from coccinelle? The pattern is tricky to
follow statically :)

> 
>> Good catch!
>>
>> But which tree is your patch based on?
>>
>> Seems like that was already fixed in commit 776bde7caf80[1]. The
>> whole thing deferred_split_scan() was refactored using folio_batch,
>> so the buggy code with swap(folio, prev) is gone ...
>>
>> Ccing Muchun and Qi who fixed that.
>>
>> [1]
>> https://lore.kernel.org/ 
>> all/59cb6b6fb5ffcff9d23b81890b252960139ad8e7.1762762324.git.zhengqi.arch@bytedance.com/
> 
> Right, in
> 
> commit 776bde7caf80f6af72b087cafe7d9f607b14716d
> Author: Muchun Song <muchun.song@linux.dev>
> Date:   Mon Nov 10 16:17:57 2025 +0800
> 
>      mm: thp: use folio_batch to handle THP splitting in 
> deferred_split_scan()
> 
> 
> Which raises the question whether we would want to backport that patch 
> to stable kernels
> if there was indeed a problem?
> 
> 
> But: I don't immediately see the problem.
> 
> If pref is NULL (and folio obviously !+NULL), we'll end up with
>      * pref != NULL
>      * folio == NULL
> 
>      The "if (folio)" check will do nothing, because we defer the 
> freeing to the
> 
>          if (prev)
>              folio_put(prev);
> 
>      later
> 
> If pref is != NULL (and folio obviously !+NULL), we'll end up with
>      * pref = NULL
>      * folio = NULL
> 
>      The if (folio) and if (prev) handling will care of it all.
> 
> 
> So ... this pretty much looks like working as expected?

Right! After reading through the old code, the swap() design is
correct and working as intended, IIUC.


