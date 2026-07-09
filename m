Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC9CC44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7046B0088; Thu,  9 Jul 2026 05:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67B46B008A; Thu,  9 Jul 2026 05:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D577E6B008C; Thu,  9 Jul 2026 05:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD7D76B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:58:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 480BD1C3971
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:58:12 +0000 (UTC)
X-FDA: 84968787624.12.49E948A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 888D1C0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:58:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeNxs0kk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIZMYCGQGBeYBRz+whWaY4gLPy2ytIC+Ky+/PPP/NbE=;
	b=PY8btensAeK82Y9xNzgdf8DUCKhIL438CdaTYML1Vc9kVxdd/h66ykGa0lyC+0PqvoS0VR
	3wH2PwskRGXVe3EH3I3g/q2KNEb9AsqWUAoOocuVS76NXPgBWJ06ZaCcXcrm4MNceSJMjb
	eKYjOlJr2rnuovW8Y0HROd5x/Xmuy6s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WeNxs0kk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591090;
	b=7Mt/T21uxJDZSkj4VU1WNP1vcvuSZ9Ok1o1XPZLRxXH1bhW8h8VpsDqMgkOpOodoq7MOjf
	5SQRguQmSfu8y3YC3e27br1BqY2jvOmv5kpgch63sp5C8Sih253Be+jSPxE+sc+PsLsp6L
	eASMWunIiNpvXK3p/exQ6VWm1GcVXOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBABD4063C;
	Thu,  9 Jul 2026 09:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABA61F000E9;
	Thu,  9 Jul 2026 09:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591089;
	bh=pIZMYCGQGBeYBRz+whWaY4gLPy2ytIC+Ky+/PPP/NbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WeNxs0kkEZTOSayX6k8SqjOWRMZrokZFwAHLQyFciN4Akkj37P02YgRmGi/jEKLQj
	 OZ0JYqIWL3JODmbUhux7WPSTUPcgacvDpAhSrr8wVADnrRFQGOqTqg3nx7XKyPHB9Q
	 wu6rHrJ/QkV0/n2rY9vKmcSABJEnEtBQ8Hy4VFaiXW9676QLCF+cgANsS4/OsRJIoP
	 KHdjEctL7UQo2970NOWNI2mjch6/U0a5wic2XoLpqSWdJqDp2Lv71i3F+ceG5+kpJA
	 XgWKlt7GFvydVEizWjUz+9Dd6ED15kZ8IYhOu7xToyH2GIwIMt+mP2639Zpp6UHikV
	 3zYAFhvKwMxrw==
Message-ID: <42a5cd12-9569-4719-bd6e-95dc0100c065@kernel.org>
Date: Thu, 9 Jul 2026 11:58:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
References: <20260708031129.3503195-1-jthoughton@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 888D1C0002
X-Stat-Signature: 41hkn7c3hrfdq9gmbqzgf3uwh6nekcui
X-Rspam-User: 
X-HE-Tag: 1783591090-668894
X-HE-Meta: U2FsdGVkX1+FIX2MkW+6sdiQ4WW2aSGiJQcCYJGbBwzCO5P9+7xC4jqxiPhvMA9/kV6vErO7WQ2+BsqMdS+sOW4qFtR3BmFk8MYKxY4uG4fQz6f2+nXfWVX1oPOvFKmIxxbuHDNV5fjDXSeIGnimBznP9yWbscj+Y1pU1N2EslofBAJ5eE5xIi4EICXNce+c9ERuI+JvUtL7NDmWQq4i3dToDwLFImnoHecPiOMe1EzBiBEzGWL9EkpbPhexBB+hpcivdy5lmyROLQG4rp+gueUkYHSrD4Zv3PsIhAqjF/me5Gi82AUpMmcePSgKd4F5WJS4OKYJApgqfnyn1uqywvrRjgeyTAmZmWJpovKfk2SWO0mwXcSZpZtONcGsZxLw3vTP3C27v2wghD7PFB8sjz/aFL7yWv62lMmnjB2V0wRtAFJIudrty+gb+57hbYMN5I+b2z7cAU5ncsN02cIbV7aZX4Xh/0N2zOjWUVqPCaR4hq+2vOF05WlZa9oqqeiZJIUYz5ZduD0Tn2IK+WqQE9cNhUX9wYGES5P89vv4mBjikPT3PDSC1QSX8uu0mbtamZsfB5OjwVHOc4rVsOcsjhhhESsvb+uGoVrKa0QH3OgKlqEKWszaMzJWjI59ETBO/V4Q+2tz16rQbdiWsiMNoKeEluQHcMJSkBmTjRjj5Cvbqs2wMD7kMKx57BagRWS8HsprpDQiHktK7reAbpKH/OBN2pQIxlkV1R/9WBLldeWZgrmGKM0IgBr5LUbAp2K931aDCkmwJIzpODgBYTs7ga2zxLMJ13/HUSmFqlJrQFWvSleuhVspBhrrW3g1VxbxIGjc/s0MIkBivnJ51uU1WumkJEEMITS5v6M47VubFJG6rraW+S1yXCPJ0Pk54kk1yC5YvpY6zPKvND4TXTnA+QPD5p8CvQbQE3cH7OY/epg2oMqfTI5M7azi0TIAl9dH6Uq0mTNKcJ7TzRhC4wF
 /OvBlG3a
 t3GnH/1DsSq6t+yld6AvUqqlV27OO6MXiCfoshIgyKaX7Z4KNH7NvMf+VAHJBWWsQfABQIGIiBkPH8NGDQkK/eSFp5fT5WzwcLBNRn9wOS0gnC7sisX/4vxCKPIrny92BOroVwYiiCFQMsp6M3HVrN353hCbAGLMlPKTEqOA+Y+/7YKUgSNfyQ7ExVatM7vbMK2MMLGkkt9+NG1tKQE/rjNsSoecObc0GXSHCmc4zg8sB4mUUh5a5Do/hGCyxEXxkvHogOIj7VvcSt7kZsYm0k6N5gKlafVhHxS0t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -- The AF trick --
> 
> The trick is that translations with the AF unset cannot be cached in the
> TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically updated
> without needing a full break-before-make sequence.
> 
> So the PTE update sequence becomes:
>   1. Atomically clear the AF on the existing PTE.
>   2. Invalidate the TLB.
>   3. cmpxchg the AF=0 PTE with the new PTE. If this fails, goto 1.
> 
> If there is a CPU on the system that does not support hardware access
> flag updates, clearing the AF is problematic, as those CPUs might fault
> on the vmemmap usage. Therefore, HVO compatbility checks all CPUs for HW
> AF updates.

Pretty nice trick, I hope this will fly :)

-- 
Cheers,

David

