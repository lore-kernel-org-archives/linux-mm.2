Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53679C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E4A6B00A2; Wed, 29 Jul 2026 10:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFEF6B00A6; Wed, 29 Jul 2026 10:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8276B00B4; Wed, 29 Jul 2026 10:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1876B00A2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:14:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7BB28064D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:27:15 +0000 (UTC)
X-FDA: 85041285630.30.6A48906
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D48164000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:27:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRGtm4ZG;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785317234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEkM6tHdYvAmijWhRzhBNP+8NQIT97ZMVC9D6UXN+gI=;
	b=0jreNaQ/01ByskEtgE7QYhDj6uv8iFTv3Yy2Q248xrroz7c4eHW0FoiYyvUKy/naQY6Zs0
	eXbPs67uZa1Evkhcv0QM4OJTnU5+ZI+DHh6h+RqWXjNC4sZ3f/V1RxscwwzPZ0Xaar45WS
	nwgeHHL1kYKsIm5LG00yob7afHUbsGE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRGtm4ZG;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785317234;
	b=lkBEqPFdA+Xru3l9VEkOYEt4xbH9ubbAmuXbNum0KXsGLNlKmSUzwiBEXhUhBzPcEdiceC
	yaYl+2gbfMldFp7ASDJuoaJQdOyn/g1+wcqdv0dAQiTgVjFk7COQdF0XhZiY7o6rqvu2z3
	1Vi5rJ7vMjIQXBLKVLsX+J+tE8BrrH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F4AB435A8;
	Wed, 29 Jul 2026 09:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8843E1F00A3A;
	Wed, 29 Jul 2026 09:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785317233;
	bh=nEkM6tHdYvAmijWhRzhBNP+8NQIT97ZMVC9D6UXN+gI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lRGtm4ZGd7Di3ehxNoi+3eL7Fgoc1gHNi6kcJKeuVlAvImOajZ9Q6mr3gRJfZII3J
	 xPNBMqf4XMsMHo7FLiqQU+FcA2fBytFdQuJu5fcvqLbhTQNWlSVjhT/pbJemPH96Q+
	 iTuB1Zg8Y1HI7FuWjR96a68daX9m/tRpvOHefmP6G4ciZtkAE12nFtxthoYlxJmVBK
	 QSBXTu5wjwplFXHTUvLtgW75EmCgA6Sfp5xB4Drgl929hGe0/cdkVXV73WnF+jZTTS
	 wuX7oC+htDdcGVYGrs+lVfKN8y5+QGZbWgjyoDvPQ7etcQuHUpYrp0ZGZ75Nakjs0I
	 pgtPY/0vsDHKw==
Message-ID: <49d7454b-b76b-43e7-a359-b2182545dbcc@kernel.org>
Date: Wed, 29 Jul 2026 11:27:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm/slab: replace slab.stride with
 obj_exts_in_object
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>
 <ammbWxBtX7KxgJ5R@dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ammbWxBtX7KxgJ5R@dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D48164000A
X-Rspamd-Server: rspam01
X-Stat-Signature: mgkc5bgpy64y5doycpk9u4tqte6jhtni
X-HE-Tag: 1785317233-74719
X-HE-Meta: U2FsdGVkX18bJn4BtXKM5ORHyAJs3hlTE2//zqmBsU/QJXVz7Eijwt7EfoZ8ojK4801XyeZPP6jb+//ylAs8USbkvsP4Ymb7XvipNEAZAqM/13ETuJcsKo1mQYtRrlHJyKei4bKT4UB9x7PlizjI3bwJZecxPtXg8ZTlBUMar1YOapL/haUJTX/hF4P85QttyuQG1MchwAvhzyUfFLNiquTXvm3/0AuV15TGh5PN90ISLUrvV1BbPnUokUAQEYhkv9GCC7QR/0sZkH7AATkrGU/2akZq4kRk/G7sLrKH4ty/EGKNS2Lc7Y+Tv+g4wUf1z/TnxrTDYNIozeV/adD18q7XLvVcOfP2drSYGZs9j0xMb7+jMy/uv/tcPhVtoXtVtQWWcAhlmThRZ9P5F3GyWZFalCZxBF1anbeeI1sFeQ6SC8MdgOWIE3MJMl7azWuL4ND/avvMOJkNLaFDoSRd0e3e9Y/vAhJXCnioDadJH0fpoRBC9ZkTI8pvQg1/SQU65LKjaw8SQYjtClSSzOA+Sq7W1Uy17DXv89rLsJbbQ7D9Pfic5aHQ15AyZwQAOSEJYaGrt/HzO2JWFs2lGaQ8IG5l+BeAaaSik6jh5jH95J/NLqJ5q3eVfXFL9tlErfX8KlxQJRrXE8LVZphgBScwZjagsWoa8RCH6ksTVN4z5FDjfnOgrwLa5TZ0EcZmkxv/6fMipDfwlk65EagdB4TpVCcSedxzRSSAsr1+iLoQuZ4nBk2JH/lh2Ipuh3scwyswCPWs52FRruTECqu3HnQPyslY6eMwD7THvO+7oCMXE0n4KETEP6fWb48kr9rONBf9AQbPHTGsc4YmBA1zZ+cvJAGHNMyA6XmvguuXgXi6K1TMMuGwk3C0/iClJxzwGP0wXwYVNCyfBjYJi01WUADNSzWG4NM6kALcP/lVjagV+d19W29vfpjH5TRLF1sLDeveegOCHae9+G36QmqHNgM
 nthYPKce
 9mz8V775xisAT1Xjl2DQ83rabCEw3g4bQio1gOkKlrDV5HbZWCqw3fE0Yi17GbDA6PyRusLzm0GaRmIl3Xpw9hdd44gwSSfEaLgxfAPLBCMWRKziZxBBXV/v7CoRdqFtOZBXSSH9P20UGmffDc3cQRauoSDT5iCeJSPd5o7GxF0SD2Y+c1HCDS7u4O6Q60cgobaVqLAIk+I8GsqYtBJ+h6+uSgukHM9y7ZU5858B0izeKl8yQYEAdND19Q4iEQ1W4Pi1UPgl4tKVgA8nWhltO+rEsuKVQnsiMN9JTQ+nrD6xbyYXIEHNPCWIftJzan8a5VT6Ux8nC9aIjLeFDfPLjFx3h2TRUx9CHm5cb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 08:40, Harry Yoo wrote:
> On Mon, Jul 27, 2026 at 02:54:01PM +0200, Vlastimil Babka (SUSE) wrote:
>> The stride field is used to convert object index to an slabobj_ext so
>> both compact arrays (kmalloc() or in-slab-leftover) and spread
>> in-object-padding obj_ext layouts are supported.
>> 
>> In practice thus the stride is always sizeof(slabobj_ext) or s->size.
>> 
>> This simplifies the calculations, but with the upcoming slabobj_ext
>> handling changes, it will be easier to stop storing the stride and
>> instead just have a flag whether obj_ext is in the object padding.
>> obj_exts_in_object() can then rely on this flag and slab_obj_ext()
>> can use that to determine the stride.
>> 
>> No functional change intended. Performance impact TBD, hopefully
>> in the noise.
> 
> Performance impact is not TBD anymore?

Ah right, thanks. Since I didn't measure this commit separately, will remove
the note completely and leave it to cover letter -> merge commit only.

>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

