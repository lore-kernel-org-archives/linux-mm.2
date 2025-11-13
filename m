Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66053CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F468E0010; Thu, 13 Nov 2025 14:17:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0EFC8E0007; Thu, 13 Nov 2025 14:17:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFDF58E0010; Thu, 13 Nov 2025 14:17:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C39C8E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:17:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65682160B35
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:17:32 +0000 (UTC)
X-FDA: 84106542744.12.279D3BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8103180019
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:17:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvIhnU76;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzsflB0sNLQVC2NratA1sltzAGQt6i0/CD9ALRM46uw=;
	b=Sqp98ZbxcfZKB6w5XVQLK2R92eWIHJ/0j5GASpNUkP9TlY5I3bPqRma/xhzjgpRS1CYXtE
	EYx8BNLFkYNpZsG4zQ2M6SK6FhUWPVKpDNY1YFgIk1X9FKUeUT2fIMUbzdDit6oaOhYUmD
	SFVrPlRUsJVGDxMZBiEFTuSgXUcE8Ac=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dvIhnU76;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061450; a=rsa-sha256;
	cv=none;
	b=P8uWQsmumBvG1TcrpdR1gKnifY75C3u2GCB9m52EI8MmWEyRjCu0/H0IZ1CQHte2j1kKf3
	OnkIGcc1R5F2BT1WVGNBdssdfnbWSb2d+8/+E5nOqgqUevQnZbtxeKNqWK3o2UBkEmkCHE
	pEfOCDrFarhjnpxRmrVbz8Q0INs7lsg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23C31600C4;
	Thu, 13 Nov 2025 19:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDD1C4CEF5;
	Thu, 13 Nov 2025 19:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763061449;
	bh=kt1jO8UvsULEtaDs/E7EX9tnRAFarugVzSN9GuwH6ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dvIhnU76/pW+vCvvgnPNOO2XoQTRK5+zJKW4w6KCqjeswisCxWkZpIiklY0SGPySS
	 dc4BL0IQw9fjzF4yEHDnzZhbHolCVFhMkJCDkfroC1oOYtZ1AEzdpJNIltye3ymCvr
	 EoRUENxrYwJSfHaAGwqCFp4xZkLO5vyi37LLaJudOdlSK/ZjLC+8F3TSas9cOVBxw/
	 b33BvjEkKZPiNKw/m8PlodjOhuvFQf0UXpUiKy2dufHvnPJCEUu7MAIUM+q8ZL3qRP
	 ySj9jf4v/bQJ/v3kabWXXf5WDP40v48ydCR215Lvnu4LAirAtUi8mxv+N29aZK0vi3
	 AC64p6ZBMkUBw==
Message-ID: <273b638e-8251-4faf-929a-87432a48abdc@kernel.org>
Date: Thu, 13 Nov 2025 20:17:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/22] checkpatch: Warn on page table access without
 accessors
To: Samuel Holland <samuel.holland@sifive.com>, Joe Perches
 <joe@perches.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Andy Whitcroft <apw@canonical.com>,
 Dwaipayan Ray <dwaipayanray1@gmail.com>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-8-samuel.holland@sifive.com>
 <1dfa1e3566cafbe43a1d4753defef9c82ddb3b64.camel@perches.com>
 <a6e7a571-91d2-4e66-bc86-ba30f624294b@sifive.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a6e7a571-91d2-4e66-bc86-ba30f624294b@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8103180019
X-Stat-Signature: bueg3mzp3he65brnh4sk7999jw7nki6m
X-Rspam-User: 
X-HE-Tag: 1763061450-514994
X-HE-Meta: U2FsdGVkX19ImzF7zhkPyPOn1IDslLtCFb6aVJ3wRu0KFI2+AkqwrQcBG82F/0N8QczwPlESFWv09GfMvAYKaA/VCd4x7I9jEeLGxxMT72L10ocVfuJthe0KmspiRhpPxOUc/2GiCGGM5HoT85L9GfO8C+ug7bKnPCkLSpgYg04PBXysttj+B+t7VHr+hiHvEwhjSqHjZlUaogN4c+DxGpmQyMSQQ3T2UsM0f70JYki7nNNyTIqWw0WaK3nuEiV3HhrPeRObuZmME7VT0thPt2htcl24p+kHYZE3Lmt6+r8tHMv5Upq/mVN0L3cjRJn4I4O34ScmhhkSwYb0t3M9FhFXbRl6c4Fh57DQESHDiaX+bwWvMfEtMpGEAMuF+0rmDNc3saa3TSF004/3K1WcDrPC6Ro8RRwo6nE3dTJqnIOzVkpmwswW0bMMwsKsrBwK75S8sHZlJVc7VKp83koER9GnrnD4s+7lNZjAlQtW1gZ0QNgeZOpS3h+J0f7Ofdlomm1u7l901eqPMUiWhZZxDyWdH+OroytW1xOWze3Mo/Tf4EXe1TjwzqN9qd197zwoeCWe5afs2L2DBwO3NjKl+Qb1keoJEhgBf2A6tmLZP/r7FY0y3YTuy3Gvx6KxJ5HPjd1ibxXiLv4OOOjGBuOiA6CN+9PaFZypj4DGTz45pqG9wq5tNpuEu5Njs41ZMY3/9dAugu4e5VHPHLSa2dvniuhRPN4qO4m5L3yXjdIhNoS0cylMn/W9krSC3hyDGuKYGZL5w5x1d3vRkq4rpNTnGg4oGkQ/smL5zloMg70PzNscfbRjeAgh23BNLEkRYTIYEKAG3MMHoiAefH7HtM4cXcqU1Kh0Nkvya8JX4yECY7vD1WHk2uITC8A/Pghbajdd4Ish5oZZWraDoDX0cvm19V7psSCNogTDl/1qM2MDrdlySqPdQJBrto2KqEjdz02NQNbkLL5riXUNSWNjqnE
 ljbCNUmO
 PjEsS3Wjye5R1+trp3LzbeMSmUcQT239grnKuTHwsEEvI5Oi3jSOwt187EdqAyqOuMRqfltdtHlPLvuy2zRl9FaeMP1YZk3XwzadvmyLhmSFfwEuKLAst9ob1+v46yrJJfuaD8M/RU+y/x6zbZleQ0QvQwO9FZfjZs5CCvrGA95EwQ61zAQHOTY/Q97hIJMceHYTTsCalLG2CvKc+O+qmYmpX5I4mBzW3PwtEMLvlCr55CDMBQddItfCDT7z3Vt9B0WFpstGVasxvM65Jo7s2fE0YwNaXsPAxv7sgWn5NI1v+6aE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 03:36, Samuel Holland wrote:
> On 2025-11-12 8:21 PM, Joe Perches wrote:
>> On Wed, 2025-11-12 at 17:45 -0800, Samuel Holland wrote:
>>> Architectures may have special rules for accessing the hardware page
>>> tables (for example, atomicity/ordering requirements), so the generic MM
>>> code provides the pXXp_get() and set_pXX() hooks for architectures to
>>> implement. These accessor functions are often omitted where a raw
>>> pointer dereference is believed to be safe (i.e. race-free). However,
>>> RISC-V needs to use these hooks to rewrite the page table values at
>>> read/write time on some platforms. A raw pointer dereference will no
>>> longer produce the correct value on those platforms, so the generic code
>>> must always use the accessor functions.
>> []
>>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> []
>>> @@ -7721,6 +7721,13 @@ sub process {
>>>   				ERROR("MISSING_SENTINEL", "missing sentinel in ID array\n" . "$here\n$stat\n");
>>>   			}
>>>   		}
>>> +
>>> +# check for raw dereferences of hardware page table pointers
>>> +		if ($realfile !~ m@^arch/@ &&
>>> +		    $line =~ /(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b/) {
>>> +			WARN("PAGE_TABLE_ACCESSORS",
>>> +			     "Use $3p_get()/set_$3() instead of dereferencing page table pointers\n" . $herecurr);
>>> +		}
>>>   	}
>>
>> Seems like a lot of matches
>>
>> $ git grep -P '(?<!pte_t |p[mu4g]d_t |izeof\()\*\(?(vmf(\.|->))?(pte|p[mu4g]d)p?\b' | \
>>    grep -v '^arch/' | wc -l
>> 766

That is indeed concerning.

I recall that we discussed an alternative approach with Ryan in the 
past: I don't remember all the details, but essentially it was about 
using separate types, such that dereferencing would not get you the type 
the other functions would be expecting. Such that the compiler will bark 
when you try to dereference.


-- 
Cheers

David

