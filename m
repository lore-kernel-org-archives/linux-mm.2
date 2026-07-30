Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1F4C53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64BE6B0088; Wed, 29 Jul 2026 21:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14956B008A; Wed, 29 Jul 2026 21:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DE16B008C; Wed, 29 Jul 2026 21:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE2456B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:02:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32FB0C0818
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:02:45 +0000 (UTC)
X-FDA: 85043643090.15.4EF5ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7C53C14000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:02:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RkaxOLGY;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785373363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKS0B12CjE/o8N1gbs5VdqTnXRPU5U8YKsog3scuw+A=;
	b=ehRwJbIaaZKIR6wU4EOgrxgWo00BFV5olCUGVDEotkkn7am0P92wVSajqMDueyF/Ir8E/X
	l60Sr0jDdW1xd+OvO2q6zilU7X2+vqDD09DYjpn8dEdAm8Y889102XhuLNIINghT7DZ5m7
	qLjiF6tA/eY+ECqk3dozFaFtbqfH4mc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785373363;
	b=T9n1pvMjJyyax+ogJJIuJPjBkjlOHVQGXtX2dvOp4zaI7fa1tnseXyhRAcZU/5NI40kwoQ
	EUBV0gs0FnCO+f+oAeqiCbrMywcVLgkBac65tu9EdkdzQM1AiH/PMiIswG0bEwfp7zh/r3
	lXpMBi3D9n1QksnfqlLmVm3FSZMXnpY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RkaxOLGY;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7A6740884;
	Thu, 30 Jul 2026 01:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137161F000E9;
	Thu, 30 Jul 2026 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785373362;
	bh=JKS0B12CjE/o8N1gbs5VdqTnXRPU5U8YKsog3scuw+A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RkaxOLGYcTsZH3TOBiDLha67pIQvWbABhJls6CJaK6Daw3XnIdsNi9ANVccmPbBDF
	 eYo7eDv6udeYGWQhqWZZ7ddjuO4FWEKgkiB6cQ++2OjQigbGpa+asLinhcd6prvRsl
	 Wwo/wQisCmBtHtMR3Em5O+0Fghm7lp/C9D903fm4=
Date: Wed, 29 Jul 2026 18:02:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: xueyuan.chen@vivo.com, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau
 <kas@kernel.org>, Bob Liu <lliubbo@gmail.com>,
 linux-kernel@vger.kernel.org, Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH] mm/huge_memory: fix huge zero folio publication race
Message-Id: <20260729180241.2b8bcb2379b975b22c48d251@linux-foundation.org>
In-Reply-To: <37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
References: <4ee89c27873fb4d9e598f8a5cfe71d700ecf894e.1785300563.git.xueyuan.chen@vivo.com>
	<37c40d62-51e2-45b4-9837-a4b96d1640b3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7C53C14000C
X-Stat-Signature: ajn4ceqjcrdi35ru63z4woymzhtd1wrs
X-HE-Tag: 1785373363-279365
X-HE-Meta: U2FsdGVkX19JBRMSjtz+f7jLP7a8xIAOee5wxa/c+l/NAHE4QggB25J4VoRQslLhZNIFypOlBOfKbLs7fXUfLj6HKN7slL8+Lwyx2u3E3cmjGdG5RXUYZTg4k0EOQdgXJdZtTp8jxF1N1MgMsu7uB0ECcsZe+xDX7PYutPOnb6hMO1KxsYR2fZJTJ9qLKWLz/jWsFoClnOYWD6i8z+01QoF4aOzbSVoK7w33STglFQgpuj8Z61NYAY8FNAOPEWqlAmetJnfrXY+HRm8oA4pmdJc6CuvM4HOirdZrXGv2ZAlxmcCaKIvvmGGmsghV9kGmkql9jOG7TZ1Ju5hlH/78lrAO5a9hDPbZ5SAlZBAeTmwXKy6tX8AsvBWVNgsprHmgA2Y/p8WQxXHUPMS6XFzgJah5wmMpbpsqMuF0FJfZSfgJgqhLz108zUtE3nZ5Ey6vPK+rMQcTZKgTFivzlBAqkRiQijBGv+hfMEWLwF+2+sLYnsEzmib2h0+duGFTl1cIUCpCmoud3/F76hzGXr6WjJXwFafVWQXvdyQMbYTKiaW0t20oNJilQlAuG0vER7a0DNyxbATp4ztqPNySAdnboDNI/d2nCqVS4A16lrANkMJhKag9N0zFPVvxYxmAYG0uRRjzBcMFmn9M8lUtA1TlxQaxjbKXosvhay0nMNCGd+C/1W/wsTev6KFIxHAXM0hBKVYZWXlN0KuBXis5bqvYHFq//ql44sD+2UUuucy5KWEDDZO20VIaqW1em5EUa4ejIubC4qEkFrMTOzkRPpXt38eGER8h6w1zcWRdjHDjLiRNP+N0XT4x0AiIRnvlyMTQwuc6ByxLdh3VyNXrRKjfDmSGRKYngoRCbCR3twK/P7yDcB7n8pq4xO7Xz1vpaqOTmY9JsO7Ge4jUdMagmzP4wrJfAoaUrI9kRfKTMgQ8mBcVmbdW2gUJK2H8KkSwr5QifKMtdeqNIrMBO8tKPiP
 S8AcEYkO
 ousTzvoKXSROZIqVJooPgtqGy2yx00fczf86j/n/+MLEAA6ISvipAIQSvlCCw6fV9EFO2hmGmR4G6NXAqEno1DLkXbGYZi8BZUGzy158CUR500RJvAZS9TIvDF9hIQMVhFSPen/eyhOSG8+N3Fo0LdBtJumEKPcHKGXyMtCC/2gOVehx7qOEHAVg1EvvjFuU6XRU6McBCA9SiNi72CdC5NNT6d0Nwm1OxrERXZ2bcuXHhNix7wU0P+PKD/BLpfkM94rFilWbbXCbM4KJ/mGNMxs79hvQN3w657rmMAFF6vFBSr2wdlFHxkRwVJ+yCdPT44NgZckWMVasfnNzEaw2GdStXyu/vmx61kaiRgJPP3+gtG7VcrJ+ukEbLrTS2Z9naZq9Jfe2amdJLZf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 08:44:12 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -245,8 +245,11 @@ static bool get_huge_zero_folio(void)
> >  	}
> >  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
> >  
> > -	/* We take additional reference here. It will be put back by shrinker */
> > -	atomic_set(&huge_zero_refcount, 2);
> > +	/*
> > +	 * Publish the folio and PFN before making them available to lockless
> > +	 * users. Pairs with a successful atomic_inc_not_zero() above.
> > +	 */
> > +	atomic_set_release(&huge_zero_refcount, 2);
> >  	preempt_enable();
> >  	count_vm_event(THP_ZERO_PAGE_ALLOC);
> >  	return true;
> 
> https://lore.kernel.org/r/20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org

Does that actually fix the same thing?

Is so, Xueyuan's Fixes: is 97ae17497e99 ("thp: implement refcounting
for huge zero page").  Which to believe?


