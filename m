Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B0ACD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583B66B00A8; Fri, 22 May 2026 13:40:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533D06B00AD; Fri, 22 May 2026 13:40:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449936B00B0; Fri, 22 May 2026 13:40:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 369F86B00A8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:40:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7B291C01ED
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:40:14 +0000 (UTC)
X-FDA: 84795769548.27.21A8EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21E8F40018
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:40:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMooIo4g;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471613; a=rsa-sha256;
	cv=none;
	b=5jLoG/wboOxop9qy56inOmp51fWxjQ96M/cU2w/i0C/8ckZqXptD2Zl+69+Wygl4Hs7di5
	4mPdzzdT7zNdtIbRV7ujyOVNxIwjgiGm54vdc9h1hvlg+hLu9plfNFzBIou/rzScNPz8X+
	A14DEaMGbOs2eY5F6xFp/gK8Lle0Ipg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMooIo4g;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WwkBV81wOHvttIz/rOckI+E/ryTlTGksdzGygNXqCHU=;
	b=FbUWz6vPV0Ekm7QthpAHJBy0U2gJr7Syu6z7ANUv0Y4BnmJhTUhi8y3V9klYoQgMBrDL0/
	aiRGluCZLBRjt+gndEJL4ep1eSBESIPuHCBb94vQEFaS0azofWVKdHfdjYt+r2FqzVwioP
	bhohAiUD6AfapaCnhvZ1S9ZGHthcjH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8212760138;
	Fri, 22 May 2026 17:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557241F000E9;
	Fri, 22 May 2026 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779471612;
	bh=WwkBV81wOHvttIz/rOckI+E/ryTlTGksdzGygNXqCHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NMooIo4gZbSZ2eRwNwO+JhDw+hOkxzstzZQf+sfRssOBp4Vsum9nQob+Z/xY4tndM
	 3z+HWVe+0tl0S8RICpKYTxHdomyTDcYJwUSUBveqXhDKcaCtAyA3LGOc1Reg50os2/
	 HdpHTVgONOo0l7HH7j3Jazhy9CtIygFHv2nGelZ2zmJA77cP3PwW+ldRdULS6xSvtD
	 D6Ll7AuMO0tMiMbtLHB5Xtg3utLTIzm9G0tH36opU8xfzJEdwXLgjNQI0rW/g+LA1P
	 rXXjZujZftpmMz25k1ffeen/BweZEceHm2IC1Dtq/6wZUhTUFe+2ajrLj94LmuFjZR
	 FUI/2sn3YPkUA==
Message-ID: <856eef1c-df34-4f2d-89b2-94b2453f395b@kernel.org>
Date: Fri, 22 May 2026 19:40:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm, slab: add an optimistic
 __slab_try_return_freelist()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-1-2ba78ec1c6ed@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-1-2ba78ec1c6ed@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E8F40018
X-Rspamd-Server: rspam03
X-Stat-Signature: pggsrxcf3f1c1ntpwu8b46x53q7zcron
X-HE-Tag: 1779471612-446320
X-HE-Meta: U2FsdGVkX1/VbyzerXtE1/Epri4a50/lBsqB4vqFv2M1ZzlW1LSIiNTZ0zBi25bF50JzAFqy9TtbDMW3Mbkgjv/OM8JbY/z7Eg7WXnRYzO1Re6B9fD55hkx5g8S2LpRgUJQ6rYWkq5ERIUUyqM0FeaEo9yoDQ3ISLu8DmFeyZjn7+/cQiCTLscmRpvinj9EeSxOBaSkKZwnCx+GuFNZbJm1BWunNQk9D+QkCCefm8kMPR/rnDryB8PfufNXTUb0ka0lzKWYRLdrarBeta0NsIIdMuLfBthNuYqgi3kcRrFrxMTymaAm6FN2BtOOI7REzkNb0Ilme3ovstcZUUMvhL5tpjsscYYpN2Y+/4YaK4PGHi5IZxUz09JuDekooGnN8KMVBMQW2WLhwumPRhKToZxDQWIeiuHglGWCkJ0HKNk1NIQbrAz2fO52OQXYR+oTUvs8WFG1o09DoVnz6SPeAgaA3/+Hi8TRWpaA8QR0cVu4tBboar2+P7FOOvNQJGn7R5gFSjyBVTZ/O4XcpwgZHOLE3ltcJOGWoH4ngEFe6Uk7XEBYHkIIf0d1Gu4rojWQcQSsY02h6Hn92azaX1tIvS5nh2dysxbYbXoOkwStEMPYw734myhlXVlDKWrzDGnfLL479gzrk1HIyAy1O+STnva+jXdH2REKHkPxs6tyXgryolXiUoHgUDP4Ii7CK+tBQ54MwbWMhgUzDL9RrIybQGQbCCpbPjHdZ37NzoYtI+KIoirVdMjIXCheuPGdVwTlBI7jD2xj8Skb0cdZo6DtBM1Dzr8pSjgzTcu9TefATdevqZPh/4G9V6KA6i7HsiCa0m18wXCuj8FDtoqTuGXgk05FdJ3EJrpDXKDXQyz8Ho8P+ay8ZiMHMQxUfDXDLJMctc7BjJA5a2GtyMXFmInMjrwB8NwT4fENiP+zctbBt+CabHbxavpH8x/UIbfL5T39W2oOqQ3GTlY+vnFOgnm3
 K1vhQ9k9
 ANmaYLWioi3Zd4hDZrxquLUH6nZalm4W24iVmguud5fXx6CxTBbzIjQboaO1recX7WVdd70ddYHl9P1JbDuXmUFZtdAAR/FSaiqzGNAIPBC8w0wlALD5nT/sTrLnHjqiwCipeOMogOldtlMz7z0kOp5LxiGQ0nO4UhIjyl0Aqsi2sd6+J5+XzNRiewxPxu7wWK3dD0atwne2MljquQfXDbksz3uzqfRIpT/5O74Dc3uEH3mBxhJ402dqQoy7pHw6kvi+kqJHNtBoOuBJRoYKdYkkS6wKrUy/x1AOsRZJqwPXvHHj44Cx9Ewe8bA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 16:23, Vlastimil Babka (SUSE) wrote:
> +/*
> + * Try returning (remainder of) the freelist that we just detached from the
> + * slab.  Optimistically assume the slab is still full, so we don't need to find
> + * the tail of the detached freelist.
> + *
> + * Fail if the slab isn't full anymore due to a cocurrent free.

Just found out I reintroduced here some comment typos that were already
corrected in slab/for-next and fixed them up again locally.

