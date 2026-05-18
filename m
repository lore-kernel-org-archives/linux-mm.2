Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF2DCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831EE6B0005; Mon, 18 May 2026 15:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2E26B0088; Mon, 18 May 2026 15:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8F46B008C; Mon, 18 May 2026 15:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F75C6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:53:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CE6A93750
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:53:38 +0000 (UTC)
X-FDA: 84781590516.05.E8DBD60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 65EAA4000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:53:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O7U/5SfC";
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779134016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=947SOLNtyKjftx3F/FZ7uNcrN3ZeuC/GABDa4a4xvv4=;
	b=DnIHkaMGz6R3gMMDc0xca0Ax4XIAHRvbtZ/8EqGuqFgdrIXki2alrr60H9wmvRITvy+I++
	A1mjVOU/w8AukksfI7KVN6sFnbwsQVZKSTXQYelLIrfEldXZ3U/kqhiRkv+8fvkmUsowJb
	9zNb9eeOL12GMQMdcFQ9/74EDRmjFyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779134016; a=rsa-sha256;
	cv=none;
	b=VkeNSUXswBj3wBSel2inj3xiZNhxha/tE3hgWuF4iByRAT1QvKUdlSNJWfAiaih/qQ3SzC
	ldw1pcZP6NwW8YHowOGKnpxN65PWGyHJ4ObC4IZ5CaG+SXH5a+CxDU15BKTrsNlNIZIcpG
	Rm8uLHymsePqjPfwroFrOxJHUSzAmVU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O7U/5SfC";
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A661419B5;
	Mon, 18 May 2026 19:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245BFC2BCC6;
	Mon, 18 May 2026 19:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779134015;
	bh=nZ0D31rkJ58LmFaS2W1jBidt3T9eg8DSZrXA9r0f9Ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O7U/5SfC8PP4wcXOspJBnyLZb8fjuk1HP3PEPyF0HIn2Ol0sAqvYeirvFb76FXTEV
	 7bP5b9jtSmSp0lbLozkGPZzV2ePN+x3oKsnbmcjC3dGCgssQwrpbZEcc4f+Yrh9Zua
	 DriwYDD0PKgwef2oYAWjf8kFFx4pIo645Am5zxDzXKIwL0mUfQWQn+WqmrU6EUuGMC
	 4oHyw0BCaJQeh3JHzSX28eKEPukAnj95j2ZxM40kb+iIrvhAqcNHOH2uXrsebtcEn+
	 cLD/nrjnJYs4zdQz08NAjMpyWK/YGQqSjN2NP8c+cBNlGfIOS3hLZ4dA+dGnlzn/sI
	 j6XR/xgodjqmA==
Date: Mon, 18 May 2026 09:53:34 -1000
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot
 installs
Message-ID: <agtuPrgIDNKSu2Oo@slm.duckdns.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65EAA4000A
X-Rspam-User: 
X-Stat-Signature: 9cb575c579fk81hcaod3zgtm56h6idge
X-HE-Tag: 1779134016-168327
X-HE-Meta: U2FsdGVkX18cANEy49O75Ax/jnrz7fjMOxU1sWmPJqO5i5oi2wamw/3ToWZ9GkfEbdVoq98EFthwNuhEy9DRt9MzhefQCHfwwRzKBC2MoiDaVBqyyjffSUAzjilp0ogQUyg8MoeJHdizd1jm/77SYC42cDMHUABlJipRA+iqbOlnPH1MZMKMYbOwGBpMkOdbAC7xl3PGOkN5nZe1xLE+V8WcGr3X7ZkcQ2XnzIdjJ2DGk8Cz9KHevDd16IKf2ZsJ3n/p5OlUM1YEeczIVQe53LIC1X6Z56/XtXZnhZ3VH1YSgtstzRRhDmSVtFgQVPJ5nsaWNzQaqqwUh947gb62+bl7JnfBdm3K5zUDmDGn0fVs0RYi+qNpOIkqmlicZ7b0Em8IxaAGzK4VPz68zlaock2JvMJqCpsVSBMDNAYUadpxMVQmUf8gbgA1rD8AhmJy5t4OOl/VtFLOu5FpM5SstoBEyU+6spiG6CpjV11Jkmx1RprOzBr7I1vZ+q3bSsM+FRf9ngIWAgsJkCirycacdcR4Dv8DMyNHPujInopuOEOpT8EFqbHlRdVc1lcCZJTI7c4z5r3DlCtOYIjrm8rFX5EV/29irgDNal2rTBi5+UBnNWSbZUIDQBossWC8ggv9Lbrl5vuV1fOG1n4GqDL/XWoGNTQ/J3CuwDnctMkbjq81XWxkbjqSka9YYWOVOQJe2A9MnmM6w4NLbp6Dj7/Aw4Ra+dqAzlE6G/W8lM7Wzkvz3qYnFd6KmrlNuLN6l2drkctnoK1PQ+YDLuXHJHFFUos6sEljmp/lHnCkoBqMdUAZgrbojN4e+jZuod4Tcu0mun6gOYn7cSSb9zc2qPAzOxTcuoLCVTzMijQmsDesDfhHeBxuAd5+JuCEeKlU9K/63r9mTeUhiiI0eLSRHmeLqI6Y3L1zgbOgKZ14Abe2sWaYpdDah8cUvcXwF6zNWxscWHaNNthjiwZFG3ep8yS
 W62Y36HJ
 uV5sR3sU8Uav2jjuHzhQkKj8ZgiZCrt2+/ilRSp2iInxoLPOPLL8T3t3nW/eHPsLEFxlrOMyIa+wLLTanY8tM6Ox15i9U20FcxFfWyZGIB0ul8rQ+l8Jsib9kO7hwjiFBdnJdNRN+td0IKk/4LzsIFr/XXa7w4aKTO7Jfq9T5bGpKkzZY1FCb/8nJDSsvJFVisURLOwFDR1JBwAbpiRUuZq5t5L2SD6Y392q+38cU3JIZdbpjsPM/1dUaXzvzLbmfNLsnRrxKI2ggk0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, May 18, 2026 at 10:06:29AM +0200, David Hildenbrand (Arm) wrote:
> On 5/17/26 23:12, Tejun Heo wrote:
> > +static inline bool ptep_try_install(pte_t *ptep, pte_t new_pte)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> Ehm, what?
> 
> This is a very, very, very bad generic idea/interface.
> 
> On which ptes is this supposed to be used? User ptes or kernel ptes?
> 
> Surely we don't want this on user ptes.

Yeah, this is only for the BPF arena PTEs which are already managed in their
own way. I'd be happy to place / gate it however appropriate.

Thanks.

-- 
tejun

