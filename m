Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A581CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5298E006D; Fri, 24 Oct 2025 05:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CE68E0042; Fri, 24 Oct 2025 05:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2248E006D; Fri, 24 Oct 2025 05:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65E8E8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:39:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2201CC0E36
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:39:33 +0000 (UTC)
X-FDA: 84032510226.11.BB5CC75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 92A0F40007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:39:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XcyYBwp8;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761298771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bdvi/SeJxTebVgRLLQ9ek6lLIgBPtVAggZRu03yVUZU=;
	b=tCE+1nscufgs9XfY/R9kSlrkufuoV1evpJrDFRVb2LgUsoVnUqS3O2qURjNELP/fzO+dte
	OazjixziIZdeCmuN09niXEQ0KF0W6LTbC9lP6M/MkzLz1CdXnpe7GfS3Z+FG314YpV0Z02
	tbUNomSruSxnrMBFjbYpYsYSP9Ees6I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XcyYBwp8;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761298771; a=rsa-sha256;
	cv=none;
	b=rqO+i1il+6jcwFwS9kuyMRD+u0vfGgRAyBqoVsRBeUzpYtRJGdPC2uDu/V1OxyRpw9eLDo
	CJ6xEWTbbHFXbNPp3uO/SOb0T+96dg2BztC2xbUgU3+gINx4DeWQvmgvIJ2JY7ZiaSLUUm
	Vg6R446lo9V8fekL143hIDoHHpUSJc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB2DC61206;
	Fri, 24 Oct 2025 09:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5C4C4CEF1;
	Fri, 24 Oct 2025 09:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761298770;
	bh=fjCbW0elSEHQWPF0dVcB3J2ybhy2ZJN8ePhdt//vJOM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XcyYBwp8EdP2kgPUzAYLtk96bUgcbjjFzbgrm7EAOb2CjTE2KEg1B/IoZ6OGbWm/K
	 bTSrIwYU9xYxFUITdqJyahmV5b3ZbmEBr2/w8LAtLRLjuYn0DkdWiIdFI/SuMyFfO6
	 Pis2cs6EN1+Rw80L0AUJsZRp5L/2KdV1TX/2+8kWsMmn7gN4+pS+zfTQRv8qSeksNz
	 s54IqIs3lctyACsVOmfuSUCcYgtwfQPXjk9yRn4TqODj/nkJQ87+eX8qvluwnOg1Mg
	 XsamiEJS2eBhw7ZBwKq7a7ThAF61W4k5JDaRbik6zVfWzPRY4+2RLUCivmPFvni9ro
	 Zpqhsbuh0/Lfg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,
  brauner@kernel.org,  corbet@lwn.net,  graf@amazon.com,  jgg@ziepe.ca,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  masahiroy@kernel.org,  ojeda@kernel.org,
  rdunlap@infradead.org,  tj@kernel.org
Subject: Re: [PATCHv7 3/7] kho: drop notifiers
In-Reply-To: <aPsZzxmGjrJSzB4q@kernel.org> (Mike Rapoport's message of "Fri,
	24 Oct 2025 09:16:47 +0300")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-4-pasha.tatashin@soleen.com>
	<mafs0ikg7fbez.fsf@kernel.org> <aPsZzxmGjrJSzB4q@kernel.org>
Date: Fri, 24 Oct 2025 11:39:26 +0200
Message-ID: <mafs01pmsfxkh.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: c63fx48rt5ajfyi41zr4eia161s6xb1h
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92A0F40007
X-HE-Tag: 1761298771-442707
X-HE-Meta: U2FsdGVkX19pyWwLXSsEknsGXl8gouMdGu9rMRmJyGI00mgHL4Vxy9fDcPdaS93M1gIJ1h92S28e8pcPHDIST4bWRY4w4Ew6ffLy/ffekpZewRT5tQmTtOs4pNfTm3ztBvFLqgzQu+YcxGH/ZBAdW//bgxq3GMJOgnj2suNbNVU1R6bBIAetCkWQoiR4F96ZPh/2W4M/omVYLPAbCkqgUvdA13qE/GXTBxR8K4VdvHuvzmI83Mjvf02bCppx1K3KLd3ac4lttyH2YiApNLQqdd3oW5Z1X0lb7mUmZG4/qLveox8Ze9ChVbZbVMywHC2RI3IJAaIF7iJMuimcdQ7D8NTF2XQEf6WsqVhslAYauzoVqv0SRqAelOMknned1iYsCG5LYHcrWyzkt3LJQS5Jd7JtNXMrcQPogAFtgOAQpV/Kd+Si0ujgoWBVkYI28w+Oi/eoevnLoG24G2scJUU6Sv6AXAHfP0SiyWp9Gl2Oz7/65UTWpozaQsz0AJ3WBDhvAl/nv2VA1lurZcMWmIUurMiOmmPVJEQmiu0LhrVQiVhVc+2dusUjUTBVwpVOvrdtkoab1lccWf3MgF15MmE9MsBd6xV7D0AjDQWEgU0o4f2vtOHZp2I6z7zD1XqzElF5ge3XobLP6DgGL24iaHixiR2F+U+WkP9w/PfSP478kqDVFHOoudTtMLgh8BgBDrzsWtgjPtuiIhx5mP4HnDM5bsCoPGUbwnGLyRAKC5OyuVm0GMdTy7eIIbA3X3TUoCYXfDbbCe2cH8e6JzWNTWM0Qr5q/m4/IthtY6RNBkV9PecHlJqIjX6iP57fmVdIaQrDUi5Wf+okT+CmSl7E5+3BTV58Hzq9lpa4vNiE5F0io4CvbJbRAS69jaL/n6Oz1UZKnHN193CTKS7qcuX1s67GX4gB/eLpgfqgCvky08J76nLmbdWYbvmJ0V7qx5V6e4Jomt7VpsItE7jljfCFeBI
 ridZ7nva
 AmzVmI/IR6K4SQ4i2azAnLT1QvZL0z0UF34aMfOT83ZVWS6VHa4TqyGFCoDQoHqCF3zCLW9iERCCxSW4WK5Bzpk1lxTArNSURIxjdWPZWEF+fmcM8nwG4wDsoTdQoMHjA3pHRCm0cOXqxJ8Qh/5tAq4CXn2PvX0CpfuHYji38rYR4kAl7oSbKAEF8KdyNUIMVW/86wnnrf2Y63HtSxVmoZX3pEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Mike Rapoport wrote:

> On Wed, Oct 22, 2025 at 01:01:08PM +0200, Pratyush Yadav wrote:
>> Hi Pasha,
>> 
>> On Tue, Oct 21 2025, Pasha Tatashin wrote:
>> 
>> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>> >
>> > The KHO framework uses a notifier chain as the mechanism for clients to
>> > participate in the finalization process. While this works for a single,
>> > central state machine, it is too restrictive for kernel-internal
>> > components like pstore/reserve_mem or IMA. These components need a
>> > simpler, direct way to register their state for preservation (e.g.,
>> > during their initcall) without being part of a complex,
>> > shutdown-time notifier sequence. The notifier model forces all
>> > participants into a single finalization flow and makes direct
>> > preservation from an arbitrary context difficult.
>> > This patch refactors the client participation model by removing the
>> > notifier chain and introducing a direct API for managing FDT subtrees.
>> >
>> > The core kho_finalize() and kho_abort() state machine remains, but
>> > clients now register their data with KHO beforehand.
>> >
>
> ...
>
>> > @@ -1280,7 +1298,7 @@ static __init int kho_init(void)
>> >  	kho_enable = false;
>> >  	return err;
>> >  }
>> > -late_initcall(kho_init);
>> > +fs_initcall(kho_init);
>> 
>> Is this change related to this patch? Also, why fs_initcall?
>
> memblock registers sub-fdt in late_initcall(), so we should have the root
> fdt ready by then. 

I see. Should this be even earlier then? Other components might also
depend on KHO being initialized, and those might be at or before
fs_initcall.

For example, LUO does its init using early_initcall and uses KHO, even
before it is initialized [0]. This works because kho_retrieve_subtree()
only uses parts initialized very early in boot (the KHO FDT), but I
suppose we want to have a proper initialization order to not rely on
things that just happen to work until they don't.

Since kho_init() has a dependency on debugfs, which gets initialized in
core_initcall, I guess the earliest it can be is postcore_initcall. Or,
we split out the debugfs parts into a separate init function (they have
their own file anyway) and initialize "core KHO" in early_initcall? Then
LUO can be in core_initcall and all its users in later ones.

Thoughts?

[0] https://lore.kernel.org/lkml/20250929010321.3462457-9-pasha.tatashin@soleen.com/

-- 
Regards,
Pratyush Yadav

