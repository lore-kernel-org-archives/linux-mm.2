Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1818C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 15:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3649F6B00C2; Fri,  3 Jul 2026 11:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315506B00C5; Fri,  3 Jul 2026 11:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8836B00C7; Fri,  3 Jul 2026 11:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB99E6B00C2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52E271C6EE2
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:43:48 +0000 (UTC)
X-FDA: 84947885736.10.872395B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id A622D1C000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:43:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uX3WhUE3;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783093426;
	b=IdR7K1jtoZLya++frqq4dTeUBnPahyBYVXXncXExraQaK3c6QuY2MkoTfNkSozjIIGW77s
	ftiult0/KmeyxYFEtgZbwfBfg+Gb7h3eY/L0xm1vuA4HsSUrUaUR818bHGg3lHfDkV4+tI
	MIiUouqcOSRLxNVfSql8YE9ZmbcucgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783093426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFC1s3Y4qDS3AnYkAd3JDVm/WCjlowQM1/RdwiUDxyc=;
	b=fTiSG9QggllWgpArZSMo+ME3YKwNkMQppFUPUcSnocI0jZYIXC4GE7iYOyDRy89Z+KSwVA
	xlik5X8PS9bh7QM26DKDqAjsOfemrMFPt/hRn9iMcr3yg06U8zje1aDWrDPaqNtJ2ip/H2
	YgS3bmNnpq7D86KM/NElhCVrIsI0Dpo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uX3WhUE3;
	spf=pass (imf18.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HFC1s3Y4qDS3AnYkAd3JDVm/WCjlowQM1/RdwiUDxyc=; b=uX3WhUE3Ow3FP9kFIOR87QiQff
	NgSGTJGyKb6WcuGZdLvTztT1+H1PsH/lJPYlBJ5yslnw55mk7gxdszLOJzj/oSEUssjrDDnl0TMYF
	l0QQqLbH+dNq2ZDZ1UElkTx1NHEOwUY7uH8Olx5fi7li90Ai2dtJnHllS/Kq9G+rbyeblQMnYTygu
	hj9a2JzEGWRlbV5cqv5XrLTrmKaL1AzSxyA3n5lOO4Dw1LSGUaqzksXc+X15d8I5KofsYj9NBqpyC
	6I/X8yhw50sIyX+zshY5mtluaaEytht6GhdkueAJk6sqFRc7C16rpEaMZENnEJvd1ILMIfokt3v2d
	dsVNAv6w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wfg3A-009VB6-1X;
	Fri, 03 Jul 2026 15:43:32 +0000
Date: Fri, 3 Jul 2026 08:43:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] selftests/mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <akfYImSNDh3OjIfR@gmail.com>
References: <20260626-kmemleak_twice-v1-0-ab28f7cc0971@debian.org>
 <20260626-kmemleak_twice-v1-2-ab28f7cc0971@debian.org>
 <akYkKgWOsYnw6ETE@arm.com>
 <akZ4tzQw70x3RR2D@gmail.com>
 <akeX8mFiizd65pDw@gmail.com>
 <akfNeK7OOpvoZE9z@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akfNeK7OOpvoZE9z@arm.com>
X-Debian-User: leitao
X-Rspamd-Queue-Id: A622D1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qyntjshau9ykfm9ej8xpbxhnqcr1qrzk
X-HE-Tag: 1783093426-909135
X-HE-Meta: U2FsdGVkX18HcddhSNEQWyV6Voy/jkT7pYv/ZlOoiPk6f8PRfuzgbLURPgcJgtyiqQBP05ul/HyC2RYx0XJHTjQcIqEOYlay8RT4LEu1G5oa8x4YZaanC8qhMd+i+Fe9yEwh2TcaGhVpyfU9z1Ipc06+BiMzMUuRSwJHYnmMEbHticlkCHFi/m5Qwu4+znsKX5eUk4+h4Z5ezreg2UrEsy6i/ew933LpVw2ti40Kj6kzbNFBU2EHgjeitDHrgjzQD6zK9mkbeGWUptPS6VIvSsY6VRmOZ4ak44+iYA6zLvZq2S1OuXXIyRZ1gk0DpPNgghnmw0mdvGIcKv+cNMTdFcIWh3D+jg+9vg3DZ344c3rl2k/JwZcQXinWCS6/Xk2u4U+rGi6vy5Jel3dh/Tp4fuiOG/aORfAwqAAZCyFkMzq13ZX3tvSVe56/F7WB4aCS2OynJt9NEujcaNLNsJgzXpw0SAvZlAkXcakYyK+IUzOZi8RwjIot7H/ytpbhWweMbS9yPw6gidU8wW8LfMfw7IHt7sbj2aeDnEdthrx7EbfvqwwfQ243Iu20XYx3jGGPgpD2A3MS5ZGE/VvN3az7X2kBhdRl2bPq3ATmt38ga4BDulaIx7Gf9OWYFJwk3X0OS7MikVKujMlGbKenpEo1ICJbTdtvGfxxtpXO4JsPfdo90kt6AfZkNSJx109N5hxf1JTTj1DSpAc3Q/tx2cGwA/oJZqeTmSGxnfC6hd9hCZgu9NiAKgnd6b1hAc7EA5z9GdmNp4X+mDwevbd7vBUBay8ApUwC7eEmqyWSBEOeajJG34GS8iUJIeuVnJw1HPWITQmB52jiMeH4u4+f6HGNGIPMI9Mpqxxan5LLTIhUplzzT7FXxfTyCgl7Gcr+JJeKQxNM6/reOZKV2kv8i8ZZoOTqhUDwJSI51WrlIS9OZZZLLCJnaYi0yrC8E32yzk+79ldStWi7GgGRmVCTwwX
 CEZ1j65d
 2iuPSgJae5EuD6KNJP82WQnqEXbx9n2ivLdwXs+TF3py7PqLvuhFyrHsccBvlJt9yL7z8jC4WsXeaSm4b5MxAPkvyt8kiWxPc96SQPDuAICB/rpuZS3RndiET1vozwQ+Rcd5If+itftfkneYY1xXDdreRoh+vfCjpARzn+BjcfLpOQgTwbVfvZXeUYhQvmWlH1OGZQJSe0Unn1/vaBZzKE8/XVv4cUD3kpRbA/5v0fPlv+OvLZD86Bmd9zlQl7gsX0ZP6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 03:55:52PM +0100, Catalin Marinas wrote:
> > I understand we want to detect any change in any of these per cpu field and
> > catch it independent of the CPU. I am inclined toward that.
> > 
> > 	--- a/mm/kmemleak.c
> > 	+++ b/mm/kmemleak.c
> > 	@@ -1409,8 +1409,9 @@ static bool update_checksum(struct kmemleak_object *object)
> > 			object->checksum = 0;
> > 			for_each_possible_cpu(cpu) {
> > 				void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
> > 	+                       u32 seed = object->checksum + cpu;
> > 
> > 	-                       object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
> > 	+                       object->checksum ^= crc32(seed, kasan_reset_tag((void *)ptr), object->size);
> 
> Yeah, the xor wasn't a great idea. What about initialising the checksum
> value on object allocation to ~0 (for the two-scans idea) and for
> per-cpu, just build the crc on top of the previous crc, something like:
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 7c7ba17ce7af..e196f53f9b46 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -687,7 +687,7 @@ static struct kmemleak_object *__alloc_object(gfp_t gfp)
>  	atomic_set(&object->use_count, 1);
>  	object->excess_ref = 0;
>  	object->count = 0;			/* white color initially */
> -	object->checksum = 0;
> +	object->checksum = ~0;
>  	object->del_state = 0;
>  
>  	/* task information */
> @@ -981,7 +981,7 @@ static void reset_checksum(unsigned long ptr)
>  	}
>  
>  	raw_spin_lock_irqsave(&object->lock, flags);
> -	object->checksum = 0;
> +	object->checksum = ~0;
>  	raw_spin_unlock_irqrestore(&object->lock, flags);
>  	put_object(object);
>  }
> @@ -1410,7 +1410,8 @@ static bool update_checksum(struct kmemleak_object *object)
>  		for_each_possible_cpu(cpu) {
>  			void *ptr = per_cpu_ptr((void __percpu *)object->pointer, cpu);
>  
> -			object->checksum ^= crc32(0, kasan_reset_tag((void *)ptr), object->size);
> +			object->checksum = crc32(object->checksum,
> +						 kasan_reset_tag((void *)ptr), object->size);
>  		}
>  	} else {
>  		object->checksum = crc32(0, kasan_reset_tag((void *)object->pointer), object->size);

Ack, this seems more robust and easier to follow than my approach,
thanks for your insight here.

I will spin this "fix" separated (CCing stable), and send a v2 for this
selftest with priming enabled.

Thanks for your suggestion,
--breno

