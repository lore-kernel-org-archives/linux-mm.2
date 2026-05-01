Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9B4CD13DA
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 02:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36716B0088; Thu, 30 Apr 2026 22:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7CA6B008A; Thu, 30 Apr 2026 22:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD976B008C; Thu, 30 Apr 2026 22:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAAE6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 22:56:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 165DE120598
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:56:08 +0000 (UTC)
X-FDA: 84717336816.06.14B82D4
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 36EA31C0003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 02:56:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pR1/V6/q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777604166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzFf8IXRVbYQTRERWmhi4Gau4qI+ard8q8aBvde/xAg=;
	b=p5EEvAJR+OVST8NbfCZKCUdrJyHdxlK4eT+mlIqB0MBKJ2TRVmyFIF8AgQmPVoRXUNukqZ
	Ive7VDLDIHL6D1GgLz7HOEvKGrqgHI1D7QALT37UayjPR5/1FhdGcooWcq7jEIirnR7gW2
	P0XZSVAY1H9dxyRQSc2eqoLYgXXiXsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777604166; a=rsa-sha256;
	cv=none;
	b=2qWuKuMxaY46rm1OqnDFy0He6mWCh32Qy7siEfURIKapq3S7F+t7mpKR1D5bQt/brF/C8F
	W3ES8sQZTdQL/zb/LvLskGrEXOO9+K0v/BdBbGoXAKfmt66V5Img7ai0XpXQh7bUlp8u11
	IMzTZhxX8BTUz9Us9tTJUZJNQwUAvjo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pR1/V6/q";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777604163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OzFf8IXRVbYQTRERWmhi4Gau4qI+ard8q8aBvde/xAg=;
	b=pR1/V6/qpV+GN44kVDka7D4dqFdY2WTJYK/vqPYvWOHqMaJHINcU1ag8cD+x4K6EX5Q+K9
	8vOYFOCmwwZYjnajkk3cPsRC+X7Sh/xq1gbXeL7lEy2lDw7Pkqt1xi09L1D/wafbwNt+d9
	BZtjVjMHrD7JWlEe3MId1ZvkKP0r8lY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260430085058.f566bdc2aa5c19a54936da30@linux-foundation.org>
Date: Fri, 1 May 2026 10:55:06 +0800
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Usama Arif <usama.arif@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Rafael J Wysocki <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <89000C13-1AAD-489A-B70F-73ED909EF4DD@linux.dev>
References: <20260429101134.1358607-1-usama.arif@linux.dev>
 <b67ff3f9-8661-45cc-b408-6a7b611d31c1@kernel.org>
 <C2C5188E-76BF-444C-BF2D-8BDC1410BC61@linux.dev>
 <20260430085058.f566bdc2aa5c19a54936da30@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36EA31C0003
X-Stat-Signature: 9oyxididiydtgk8tedy5hfrnajkd5jry
X-Rspam-User: 
X-HE-Tag: 1777604165-859398
X-HE-Meta: U2FsdGVkX18DTY3VUIzurhuJ/WR+iPO7VmVblq8TDqYtJ2eCQ3NAcDwLLP51lMfijIwL+mwj3zFZmkOaKsdEAgDmS/ckF8oe1hzwCBpFT9tEfYbdqFW06E5jvNBL4LhDtsH2KpMSe3+c95JJ4o3xo5fz/PZH+UmZaXe3QX68rRnvoLODxkIJGQ8nbUHIwvDfNCU6QxytIRRmpdPoMdpb7rKrZ9FlZ/KP/sAEacGftWwP3czmXqjfWXVfQ3J9hRuRVheqHcpK9Bei8IdS+dLjrMHUIbMF41JX2RGP9dVCji0mkQFk32p3gJ8jZdRw7D87RA3OJGLnE97S7LgmIzzMKr+FE/q+roi9UwKqJYN04pzqGRtYyynv9qED8G8APsuRDh2N4k99uflVevC0Ba6P3ol1aO3BRw/nd6KWopmchFOKiRFhG4ZBcsQSdugUbXQChCLWz3u253sWfjHjSzLesNN2XJHAu+s0DGY917X9FEye2ThbFEU84aUQ/7hOseupWxR0Xxd1lxxn0snWy6r03SsI37KezxTZs8vp1L9fr3MXH9WMNZmmult6m75zuyMIPV+zeXzWHn/3Wgz9DzUT5XjB+yVBHe0VhoPZhOM6isWpv8SOgcbRpOF3H63M100ca/BIUnWJZa0JS4bMZiSoSunRrAYoKJIKPZ24OvyUdT9eIZpfKzTsU8OyJx6vh/ku1JTt2PFx3zZeLgvmL3HsZfo8jHifYTXqYr+yxGpDrZy1X4eq0GsnIjJuWJudr6Nfh3fz5UzNcdHxy73P0YQyGt4HKZhGmRK7xkRErbWsjgMm71am7XiiFa2aq22u3X0aTAUKBH04TCSStiQ8pCY17FZU6EAkktV77P3mELCBqs2TKdS1ggzx+ymzI2NfdNwRkLLrOLAmSP/oJKSUF9ID3MoapewE7/9LjNVOyWbfOldiI3qigUJ6o5tKOLxAAlVLn5T1wsxvvkCs9gS0i/v
 7nbCSWlG
 9nphhIO9wEZ7JKxGve3XmmFodD3/XxV/RJXD8s30fAzM35rabExD/BP3j/UYum5mkxUeMOvdGM7VBWZV/w7b8VQ3KCot+eb5QHWFUwyHp+5QbNq7WmQ36sF3u49yroFuCL0ZvYqli7SgwXDiDsvUa00PTH/D/PmfCsaRAuWpyNtlc+EXPCiSHrWyNYVxZBfMH/2fWkXjZeJnT0Bf5XMFDpVEVoTDnyWnw4vgGKd1iko3Plzoi1/jgdqKeD21VKXHBi5Q8+0Or3ckUFpVGHSRxHEfltmMB1hqt/jlstVUJSFK2uv7yFUlwcWxAlskqwCe5E4Shb1dN90nOycyal30bOfo85whe/7UdT5tIkKr4k2xwPKWcdqKTDiM3Hm93NNhUTz5YzSH/HZRHhw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 30, 2026, at 23:50, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Thu, 30 Apr 2026 15:59:33 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>>> Lockdep would flag this as sleeping while atomic when acquiring =
mutex I think.
>>>=20
>>> Another thought would be, that we always call the inc/sub from =
memory failure
>>> code while we hold a folio reference and the page is not poisoned =
yet.
>>>=20
>>> That way, memory offlining cannot continue and the memory block =
cannot go away.
>>>=20
>>> So we'd let out page reference keep the memory block alive.
>>=20
>> It seems unnecessary to hold lock_device_hotplug if the user already =
holds a
>> refcount on the page. I'd like to drop this patch.
>=20
> Dropped, thanks.

Thank you so much for helping me with this.

Thanks,
Muchun.

>=20
> mm-hotfixes-unstable still has
>=20
> "mm/memory_hotplug: fix memory block reference leak on remove"
> and
> "drivers/base/memory: fix memory block reference leak in poison =
accounting"


