Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA212CDE00E
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 21:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C366B00C1; Thu, 25 Jun 2026 17:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED4A6B00C2; Thu, 25 Jun 2026 17:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703B86B00C3; Thu, 25 Jun 2026 17:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 429AD6B00C1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 17:39:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76DF0C1851
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:39:09 +0000 (UTC)
X-FDA: 84919750818.23.B63B87F
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id 022BB120002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 21:39:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=GrHOF4C4;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782423547;
	b=tqF8Ijjf/FdZxtB2MuEp8u9k+qjpH/SBHaSIbA7yTwhZqqjihbJIt0usfnIQ1o+HD+b7Eh
	Rl0fge2THsyCqQX5ptmvBvmLFX7Uns/ZfT3QqNcA30m4rKRmLKmTM+AHo84tgcPVv0PFsN
	9mQv+iDGmCYnGliCPFnrhO5Ogiih2EQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782423547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YygjFt0bxen+mlG3NS0z4kC+05lgrMBGaJ+EXmSWwpg=;
	b=YYj+Z6o9Op2hHcnmOwaQEIACbQCl+OWTF5RcVJfLiUPeAktn2+8bBq1E3Axr6FbwmnQCWB
	RhJ+mOCG8YhvhGEdW7PWv21PAEQBt0jaLlRAXPJuR5nk9QO2e+sORLaK+L7PY5ElAPviWx
	DXhLJmELMywk06/uFjAy8uZOkH4AiD0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=GrHOF4C4;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65PLcOJl3246491
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 25 Jun 2026 14:38:25 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65PLcOJl3246491
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1782423507;
	bh=YygjFt0bxen+mlG3NS0z4kC+05lgrMBGaJ+EXmSWwpg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=GrHOF4C43sQ7cXiCnjdSyQxb51Pxmj3dWNyz8fwztXYM7yu/qgGRH5vNkmW1mr/Wk
	 bCB+aLcoVzp2ZmJ5TkenheA3pbIKU68OKD/K5nEJdu9YZA5O2xvy6g9KuAqcCLoGk9
	 qq9BZuhKIItAcCG4ZwZnZcooz0Bn/FU/SZHHwRw940ggSpYTYSmck68kvveDDH9un0
	 USajn4Z0YOWrb3oI1eGfEQrQnnwFI4rFyJreYzvOAsjcWPCbI3hmRYi0PV/PEO5Vpr
	 1klyfnXvEt0sGYAbjgYlq/mfggYCg6s57Se8m6IkcPr64CwRFbi9zpfcDizahcwj3Q
	 4cUq9kbQf8LRA==
Date: Thu, 25 Jun 2026 14:38:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Andrew Cooper <andrew.cooper3@citrix.com>, zokeefe@google.com
CC: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
        dave.hansen@intel.com, dave.hansen@linux.intel.com, david@kernel.org,
        kees@kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
        luto@kernel.org, mhocko@suse.com, mingo@redhat.com,
        pasha.tatashin@soleen.com, peterz@infradead.org, qperret@google.com,
        rppt@kernel.org, stevensd@google.com, surenb@google.com,
        tglx@kernel.org, urezki@gmail.com, vbabka@kernel.org,
        willdeacon@google.com, x86@kernel.org, xin@zytor.com
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
User-Agent: K-9 Mail for Android
In-Reply-To: <bfb0fea2-ce59-4c10-8597-58e495ad6d81@citrix.com>
References: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com> <bfb0fea2-ce59-4c10-8597-58e495ad6d81@citrix.com>
Message-ID: <59914109-7214-483A-8B56-BF5C5EBF777C@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 022BB120002
X-Stat-Signature: 1e6z91sdrhwcd4hw66dhpw1ki74kh7m5
X-HE-Tag: 1782423546-702403
X-HE-Meta: U2FsdGVkX18q7t5YS/nC3wgJw7SmwuIpPIdkVeBIteDmBuXFGUKYL3fY9P+204jU+PGzDwOrj0F3XCfQ/TykeVZ0uo3oLShhLhm58oeoPOdwwA9rgIwnVoN4BwpKb/7xKPpP1vSQ/5J3EnqESMc3QqXrE6HtZqx2752G2Lgby7coEYv3WAk2TkOKeU9XMrfmp7N9XqmsrdUfOXnz6wyI3AACu/VFT6fl8BR/lXdq/l+7wLYMFd9Q1I6Zesz2lctuIleJ3ApsOUpQKDZN05Uz4EzaxcLuolgFeDqweVbdILuulJNQtDq5OKsv0o97k1MpN+rC8BPDQ0q9M5g1dJ9jojdPixFf7tj2r6pIaIzM0aZYeSkNY/lbZ+a6bfCMUnNyXbBPwtKIOwU6fyFNv6o0cKDzXZeCwiJ6xKl7SKh/DbZBgGdVr/YCE/GWDhAC1EQa4mROyrP7ryXy047NGItmIXigqCgYnjh+kBxjv63WqPUKmLPerqnmZG0XyPXZd4Ir538RVFPe0puTIjkraJaPt1wo52dxkzmPkHWlPTIzwbSJRBSXg0zO3ZhMxHTPhbcxMjzvd0yPpVXVXxIMGftQyfFNouypscklGaDE6VdVarmtRCdDcswfOb+XCyuQTmdGN1uajqsa3dCYF95pyoDVuM8CnPWbJ+o4jHhFqhl/PEl0S9zrXgOfzc1p6GZBE7vS+LYtyMVg/hTKSIIp7uY8kUbJfFPv2dORNWNkyGkFqLazp6KwjnmyV2ruxGyi50i7vIhLsEHIQNTbYAaODvdo8Toyx7xH24vfYVMmP8DZI6TRgM5rTFvLDkZJZWTdFUzq+s7ID7i2iH3a/oCXBUs888iAfN29Y6BkrpiCUW2z+RBWlxXakvZjzXk6a6rQIz/2dJRvyaeQ13Emkg9tLU/k2amqC934b7T1A+zIeO55B4JFmV4kU3Ttysa8j13yCvy3W0sN/qiB1vtDv8OuMDt
 xhhItlFK
 pwVogOsim6KjLlGinY0QqEilAAOS8nqRLEw7/mXO2EXB9qT+B9Do8vR40EbHXOInNn4VeOXlUbveDPw/M9+OvuFGyu/a1oYoRdFiqm1NPoZi7DAfc3m53jO0A+K48ecAwGDZNpBVJZiISKw+HtEuZl34wKg3IqRhjP3pfgHuptVPCDBNboGal1t3+3ynB0HQkdyGtvQ9K9VaQprx+v/IDQ6UBQIz6SRZYvttTGjBLVwynrWgfz1gTIOJZKbR0LeA+HxkDL+PAErCeYYu9uYRHnOVLqmtayFO9qDkl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On June 25, 2026 4:56:00 AM PDT, Andrew Cooper <andrew=2Ecooper3@citrix=2Ec=
om> wrote:
>> However, I'd still like to work with you to understand what feasible
>> path forward you see, hoping you can proactively steer us away from
>> some of the bigger headaches=2E
>>
>> I think we are fine being forward-looking, and only supporting this
>> for FRED (which is on our doorstep)=2E That said, understanding the
>> issues you foresee with the IST approach
>
>For IST, read
>https://docs=2Egoogle=2Ecom/document/d/1hWejnyDkjRRAW-JEsRjA5c9CKLOPc6VKJ=
QsuvODlQEI/edit?usp=3Dsharing
>
>This was written prior to the first public drafts of FRED and SEE specs,
>and FRED evolved quite a lot from the first draft to where we are today=
=2E
>
>>  would still be valuable, as
>> it might save us internal trouble should we choose to carry it
>> temporarily to bridge the gap with FRED=2E
>
>A lot has been said about the invasiveness and tradeoffs=2E=C2=A0 I don't=
 wish
>to dwell on or rehash that=2E
>
>There is one critical point which has not been made as far as I can tell:
>
>In x86, if delivering an interrupt (NMI or INTR) causes an exception
>(any exception, not just pagefault), the original interrupt is lost=2E
>
>If you are aware of this, then in principle you can look at the LAPIC
>state to figure out when an INTR was missed=2E=C2=A0 However there is no
>ability at all to figure out when an NMI was missed=2E=C2=A0 Worse, it is=
 both
>vendor and IDT-vs-FRED specific as to whether NMIs are blocked following
>a missed NMI, and that too is state you cannot recover=2E
>
>If you wish to make dynamic stacks works, then you *must* find a
>non-fault based approach on x86=2E
>
>~Andrew

Yes, this is why I said interrupts would absolutely need to be on a separa=
te stack=2E=20

As one of the FRED architects: there was a lot of desire to fix every sing=
le little bit of the systems architecture with the first release of FRED, b=
ut in that case it would simply never have gotten released, so a key criter=
ion became if some specific improvement would tie fundamentally to FRED or =
if it can be done separately (possibly specifically in FRED mode=2E)

At the time, there was absolutely no interest in paging kernel stacks from=
 any OS, and I think you will find when you dig into it that it might very =
well mean having to promote most, if not all, exceptions onto an SL1 stack =
in the end=2E




