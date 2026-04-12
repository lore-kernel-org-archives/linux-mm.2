Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E905F3ED6F
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 03:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061BA6B0089; Sat, 11 Apr 2026 23:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012876B008A; Sat, 11 Apr 2026 23:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AA46B0092; Sat, 11 Apr 2026 23:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8C2A6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 23:25:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2896D1A0A5F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 03:25:06 +0000 (UTC)
X-FDA: 84648462612.03.6FECBD7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id 26CD240004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 03:25:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZgMuV62l;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775964304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7F6ExSq2zsiYKOQxY6wgG6WKAhk4DvCSTWfDleLB2Y=;
	b=Del/FzM36KcG4xaUeKIv+6UVI79ATwojEbv0OG5fgUn83q2vc/nc7pvl9W0iLSwx5OHKI/
	yJ1kmCDgs5Dka5emsQ8YDtcEUqgyLo4FHYBUh4PWutd5CjAjX4sFuL83Bp5n8NTHrM1qYy
	63Cq5Y//IAtyCCqe4/o2yYXwfkwpd1U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZgMuV62l;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775964304; a=rsa-sha256;
	cv=none;
	b=1vKn/VDFC8I5x1UCMjLjX7e0sSjhP+Tu/ppneWfLJUVY7VsOKlLYtafB7lE1mOf9JvENVU
	j5EEZGfoIsS+erbg8wZ0yeCbYt0p+e5CUt7147TVBPC+R/zdtFm5unDT7VVGWLiO2tK6vF
	V/HwoedvDxbGKViJz48EyM4HFu//GmM=
Message-ID: <3e688ea1-05ba-4e75-9d92-2751ff6f3b7b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775964301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P7F6ExSq2zsiYKOQxY6wgG6WKAhk4DvCSTWfDleLB2Y=;
	b=ZgMuV62lY8nfvrhh5RSEipLHno6dZ7PcK6Aduun7TThkr7wr8/4Wo+FK+uadqLJmEPPwDm
	/jk/E3QAMoEs6mZc7ViZUSXUVArA6w3AtTPhcp13XBglkOqPtHd7/4exmgI3DE70o7tSXt
	ed14obd+deDrohCEwy/u61pg3hAPDNQ=
Date: Sun, 12 Apr 2026 11:24:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: lgs201920130244@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
 <20260411142858.85496-1-lance.yang@linux.dev>
 <848180C7-F98C-44B2-AB1F-579BF9EEA28E@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <848180C7-F98C-44B2-AB1F-579BF9EEA28E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26CD240004
X-Stat-Signature: yjhnmdha1fkams1z5ywcrdsdtn94dt43
X-Rspam-User: 
X-HE-Tag: 1775964303-195914
X-HE-Meta: U2FsdGVkX18f+pmOY0Z+ICfHY4L3nvyymCPeeqCr5hfcGC89618BGYRv+naCKBCWnbaVqGDJhWY12Lb52u/CUUhvAKvVFq9Bamc4PApw/ToqXsaSG0lB8+EYF5/o+zn6c+oT5V/ZmD6FrHx7WXYcN3uxJEwIN9YsL6yl5NW7nK4bOtljlyOQlEg+fTRjzPwJbrEbGcmBdGIWZF8StwMFwJJHdJgR5yQ2uGHzThumjncsvEsZkjjnV0gNRpYYD1AAGPufgYcj91zbOf4BJFMrrDwyR+KARH6EKAO5h0g6XG+Kj/cHNHr6LlQX+xx7CMMd1CRBd8pqQ+I7tPabD90DcpZ0vNWKApdMLqoPL5T9W17kxejN+VNYLZexmsdKwUbT4s+M1+h5KdBXWz85a2te9xe6HfQpgHpaqfSC5+keNhtUOudsLHW+G/FdsRi0mg+MYTDDaO+3dUSyzXU9jkaUlnORVpnY+J2cDhRRA85R9QV/Vklp0QI7u3yrGGfDtQwdSJwX67vjEkwbkurc9SFEmuO6b5se5p/M13kgumHeBiBfXS4Vd3oTpl1T0iKaLZeoNCMkWykzxr7Toe52iOy/B7WbY02VnSLrEZALqnJ654ljRFKKL0MuMmGxvZvkTJWC124Xy/HuwRrnb6sdigAdiUDnShGPu37nMoe5z/QQA/+lJPJNxRV9rnNEmdyO9v0PXf+v+Oe5Ga/MPVJmni6WSCMvQEgYOFyNwAqNrKwCVM48B1r03/pTx1vrdCwby1DGLaijwFWKot7CbLynnqJAlSeDwwjIsZBlMJrf+OaBnuAWNDtEdItwCf/OMUsMIs/huWkTa7t2YA9d/Mpmcxs4i/3yM4OAHd7LU92HURZex2raYx19V23XawQWI7yO3yoWb7dMTFCCV8PC6sU8uepPWaef/zzDNwiPUhcNYYhj+6p0/vu6qZInVcYiZbJpgGT1l5uaAg1PVOUkshDJs5M
 zUkdXQYs
 OP6hciH8TPy35gEFlftx5/LvWYzv1uR+VGpZEXAG8vMxbBaqYPP2knNe4Xd7UwwWX4gqCAENbtBd5u9vlMEqtPzHkIAHBMrsw8JD7dUw/09841GUT7FUrMrZojWVlwa9g/sKj8vkp1PeTE+JZe8j0nLWttv9/ca3t32E6myAcxWnp6nVvW8EEzBXhTTK0jChIoupbcCPcq9Z2lxwHFFToMiGrCEFYeh2vxOruS12S7I9gfS2IT4tw5aMs5F2rG99WJvhb10BgdBXqLe5TjDZgo6Krjo/tf3FrSRv6b0O/pns2Fok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/12 09:49, Zi Yan wrote:
> On 11 Apr 2026, at 10:28, Lance Yang wrote:
> 
>> On Sat, Apr 11, 2026 at 02:21:52PM +0800, Guangshuo Li wrote:
>>> After kobject_init_and_add(), the lifetime of the embedded struct
>>> kobject is expected to be managed through the kobject core reference
>>> counting.
>>>
>>> In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
>>> directly with kfree() rather than releasing the kobject reference with
>>> kobject_put(). This may leave the reference count of the embedded struct
>>
>> Right. As documented for kobject_init_and_add(), once it has been
>> called, the error path should go through kobject_put():
>>
>> /**
>>   * kobject_init_and_add() - Initialize a kobject structure and add it to
>>   *                          the kobject hierarchy.
>> ...
>>   *
>>   * This function combines the call to kobject_init() and kobject_add().
>>   *
>>   * If this function returns an error, kobject_put() must be called to
>>   * properly clean up the memory associated with the object.  This is the
>> ...
>>   */
>> int kobject_init_and_add(struct kobject *kobj, const struct kobj_type *ktype,
>> 			 struct kobject *parent, const char *fmt, ...)
>>
>>> kobject unbalanced, resulting in a refcount leak and potentially leading
>>> to a use-after-free.
>>
>> IIUC, this looks more like wrong kobject lifetime handling and likely a
>> leak, not a clear UAF :)
> 
> kobject_put() ends up with calling kobj_type->release(), which is just
> kfree(to_thpsize(kobj)), equivalent to kfree(thpsize) in the old code.
> IIUC, there is no leak. Let me know if I miss anything.

Right, the fix is correct. I was only commenting on the changelog
wording, especially:

"resulting in a refcount leak and potentially leading to a use-after-free"

The old code does skip the required kobject cleanup path, but is
a UAF actually possible there?

Just a wording nit.

