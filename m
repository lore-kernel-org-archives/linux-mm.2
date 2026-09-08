Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E940BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA7B6B0098; Tue,  8 Sep 2026 07:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABC86B009B; Tue,  8 Sep 2026 07:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05D26B009D; Tue,  8 Sep 2026 07:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C072B6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:55:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 707401A0550
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:55:57 +0000 (UTC)
X-FDA: 85190441154.17.80DB42F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B02AE40003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:55:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lpGDXF7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQfUobdb4z00WEwtnabznk2vNczJUBLHs2sPtjNr3cI=;
	b=RigEsmBGK9FcXgYAiZrtQQfrQvuYqXM6ux6N9/noIQR0RjGIDIcXmw20cWHdeqj0lWHANu
	i7qv3tarWawbJbUJaKWj72ZPPXJgitJtJXNi8XQm6nLtgcXyL5XOhcwO5Qhkjt8TPSr02P
	nILtdragrXkVP203nTQkRfezgsNNTiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868555;
	b=DH18trNJWUce6MVIGAYWUAzyg/pYFNMZasssUTCa6+/nrC2k7bILv9PREc4Plct+HCAai0
	5EHBrbBIH8AdygZd/KdssK4l4tJsaoWStL2CSOTUQ8JfxfrW0kP+o9qQ26NfIk5MxboNAj
	/mhixrcqiUugVaDmz+5rG21jVMwDf8M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lpGDXF7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF71E60A99;
	Tue,  8 Sep 2026 11:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96B01F00A3A;
	Tue,  8 Sep 2026 11:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868554;
	bh=YQfUobdb4z00WEwtnabznk2vNczJUBLHs2sPtjNr3cI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lpGDXF7ZqLHduzl8FnziPOy44BLBHhC2Fw4f0jqmHQkKoysL/bVzIHC+FAe7sHw7Q
	 jkocHRdaF0XzNj4f4PhKK93kmAF0iSVIiVQBbYfZPdmZHT4alxIAbfCODf6JWSb4LO
	 MwoTcpezTjSOf7GShhM+TnQcNElLIb67uyP0XYwKTUG+OCwygDjUkHFMZQEHcinVRQ
	 BQebwXbqAoK2cziX/sxNuAXk6q3CSoAjS+xNfEqMEoKs1lRGDE/xicTO/J4jx762XW
	 F9VTD3V3103VvgiKmAuvnoNaijapfyIllBeaojqtCUKnCJmwj+700uh0TqrbiauV9A
	 cMHAnXdOJcyYQ==
Message-ID: <29e6d0d2-cdd6-4d59-aa6f-0073ac63eace@kernel.org>
Date: Tue, 8 Sep 2026 13:55:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-1-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B02AE40003
X-Stat-Signature: t1msbuqsb89eqd5yc7689gwx6kj18pp6
X-HE-Tag: 1788868555-936552
X-HE-Meta: U2FsdGVkX18EdJMT0aCfbiMtCj3IRhDgBZA4ZpN7cJVqW4btgB1uDFXi9e6ZTrsnJQ5p/cJ7KLPLoNwFQFjfyfDmngWplEZIjJRk9kft/wxbGOHfuS3xUS19wDRZzOnNZEhOPyeg7ki10XgRMS7Qjrd7rInLmQxuOzOSUBR34uNCU6jrH8sRx5ouPkhyXRr6WKBd04WGmBsyJu3XhkCevggEpZGXUNDiSQOP1zBlk9hGgUDQYZpVGayk7RfT6DYHldG8u63rOXyGbUiXnrWaN7l+J/q2T3SU8ShK1/llSEboiNN/FAcs4smZRcmDag8M/b/Xca6knxeTPXDAbVazfcXMkah2uQ6Js8Fe0mBTa7p6gNAliw/yB6BztZSijxOC7NcInZNRCp06UivGnd66x+8JllkLsjBU42SFEKJEGDT4iqqb3OVcIOQnFkwBM9hH/MvmLt/TkspLodxMiwOv1or46DJOGZyHKpNAUB5+wm0JKpfVRLxXAgmcdN5BYY+VHAFFClQFCM3e7DaWG9fHZGD8656apiACmhMT0o3CSxSa5PcFpipf3F7qGbc1omzRfgoFEy/JhUGxpAIUa3GAi4wA9hGhH/tpex+yvOwjLwUnvi6uONv1uTE54qh1SteyyHtI6lYBkKVC9STUW/1yU1EmqnxZ72Q0sbS4wQJeGvXHgniu0z6teybcxFdqKmMPpB9ALRgUo146VUkqu6DrQF3bT0gh8pJ7FMfGTp+NxRCWKac3+TvUuL237otlFuFdZVXnrOq9kCeOFVEXZKWrJtxNg8314UzonsQoHl2VKxz44T5zesrb67N3XU2PGLcfOUxvKd7BzuGdjfkpFxQchtpgHr5t8zm3RBjgxW/WlSRLf0poaON2fhF4EKL+0KbKh5bL6F5H22muarG6F2+C0OlMA5NF8e1Vdoj7e2lqnkd7VrXitvICV3gCQhwU4/aandnECHzYrJ5qpG/PrOH
 YWaOMZ9z
 S0yBNU7UwLxdY4jQlZZ0xjUXm7z4+ZPnsw2f2dzi0YEPb7OzF9pdCpTKb0/A6HeJs81I2vBv07GMqff/0zVSsfCEElwC6xw9rspdznvrUWaCkOd7VRO52oNkn8P7HwZup9SzqtuHiKbvFDjmIocRIJ4pxxvcV/SYL9FX3qRps2Tz4lLdkMzFDXFBVDqTXMpmih8YGVQXii0sAKHOADOgadLKG6YnXc0ar5I6hgCnOmBwubg4oyx2WZG7De5moGfKAbYoIt5RsC0AimKf1mowi9bnFuroOZWOwaVMxHu91Hbzf2Lgm/Wes8Q3OqHMV5xiACWAsB+adTpGVUtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> When set_direct_map APIs were introduced by the commit d253ca0c3865
> ("x86/mm/cpa: Add set_direct_map_*() functions") the single page
> parameter made sense because the initial callers (vmalloc and
> hibernation) had sets of unsorted struct pages that required changes of
> their mappings in the direct map.
> 
> Since there is an increasing demand for direct map manipulation and it
> is also desirable to be able to update larger physically contiguous
> mappings, for example an entire large folio, extend set_direct_map APIs
> to receive number of pages parameter.
> 
> As there is still only a handful of callers, change the existing
> functions directly and update all the call sites rather than adding
> wrappers for single page case.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

