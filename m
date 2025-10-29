Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB199CCF9F7
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5C38E0075; Wed, 29 Oct 2025 10:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47DC48E0045; Wed, 29 Oct 2025 10:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398AC8E0075; Wed, 29 Oct 2025 10:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23CCE8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:37:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E272A12AB44
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:37:21 +0000 (UTC)
X-FDA: 84051404682.10.3BB115F
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf14.hostedemail.com (Postfix) with ESMTP id 795AA100014
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:37:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=JzV5Lfwn;
	spf=pass (imf14.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761748640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGcswXRVbhQ1LyEBlNcfoiqv+Nc2O8kRex4L8HOu5WM=;
	b=05hdFejM50ZwDlRpaTxBKWdehVf6eWjlzhsoGElM+Rrf3Yx4BULGSOmuuQjpuuQ5gKFoCV
	Qr7VvANBKR0qZKEI39JORE4IAHnVgw3dPggZf8Jnogyd0GI+a5Veptt0AkelbhTzol8s9P
	tCMdhC14et3TSq3GB/wQsL5Dzm7KPqo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=JzV5Lfwn;
	spf=pass (imf14.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761748640; a=rsa-sha256;
	cv=none;
	b=gkvADBJdTzDS9ODejQFPQggB6hFyprhhuoDTSsny/orjFPQiJvpeSvUPvk8LyqRQguk+N1
	UaZsJPdLzOF2sfygsygHxs3u160XnfiM+BeCOT3QEtZq0DNrs3MDdKc3WVE+kgKm1MajJ/
	Jym1eAXe08HBwI/mXXERnnMYT4RF+7U=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59TEaGje2114125
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 29 Oct 2025 07:36:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59TEaGje2114125
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761748578;
	bh=QGcswXRVbhQ1LyEBlNcfoiqv+Nc2O8kRex4L8HOu5WM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=JzV5LfwnaN3YZoFEcXJk0aEuwVs0R3X1Jp6aHvdg9ZA4jAWacYgpv5erHYC8fGgNz
	 qM8H9VJj1Eu/OZ1kncOGWS8TjnPZ/acfmL6StOoysolsmfax3vxC6ilFAfkGh42AoH
	 jKURrsIkh/da3GgaUpXxxNBWQnDJJlVEx5gb3GcDEl28Z9oM/7Sag9QUUixtWPhZAs
	 NEELTtRrsbxx1GdoudZogM4z2TBbUWVGsqwFz1kMB8I8SMjJPDdhU4NysyIPkjVlFa
	 Nc6LoiVA5GI2RnRf/WVHZ4t884R2kX6+PYN5cKbVg4Fr5OAoyHMxkVcDe3WIrhNb+U
	 3o/zm49rbPppA==
Date: Wed, 29 Oct 2025 07:36:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Brian Gerst <brgerst@gmail.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2g1G9Jc6eL4L+Rq3kGvKALt-tuaA3NKUuZ-jJXeaKuPRA@mail.gmail.com>
References: <20251026221208.1938173-1-hpa@zytor.com> <20251026221208.1938173-4-hpa@zytor.com> <CAMzpN2g1G9Jc6eL4L+Rq3kGvKALt-tuaA3NKUuZ-jJXeaKuPRA@mail.gmail.com>
Message-ID: <AC974749-2246-4F2C-96CC-B2CACE054C2E@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kj3imifqi8n9auokf3m6om9rdjp57aed
X-Rspamd-Queue-Id: 795AA100014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761748639-470774
X-HE-Meta: U2FsdGVkX1/OCug2z9Muq6oF9Py72756i+aNQZS6Q3nsxQbwB8LYPYyc6iDTpR3m3JfGE2Fd38ANXJMFqMrnkTAzNJpHL4VG9OkMwD/4oO/UrO+i0I5h3vQtmDq4qSpaQVbf5p11cL+fdLs8Oyv17qByNfvVSBDBt3sCb7sr3Pe1kulKJY0u1YbgOF8u98qrMbggjnu+6Zt10/PtCVLxhtCFdwmj8T9WBgyNmVhjGsD2Yi4Q93C6kTFdARmyN/XKUh3joDVE3UyNQhJoaIulXCH/FFmRBB8I8rvYiTtgisHhYU1e8hysxhGeSNUCvcX0uatJHrr5BOTaXSkl2RglRbsZ7lgAELarWvHDxydlKbFORGdzcmVD0mzkHJOX3XbPVff2t3+jx2XM1W1kC2AVvj/X5mVl7fnbIjDn7brWWrOG+atBvvyQEQHPPvGpI36b2fy4yAiGo15bj86xTXpME2FdMljh7zPGxYjtUb/9MfgoZBx0CUjaysrAYJSPVIautHdbNVF/WpQ6TEJfn8TsqIcwT6g5Lvady5KbQYCs8Fo/gd1Jb8gZ6s2cDo9I8wffZsEBpR5li5OqgROryckCK2NezU6u7ucFNQNmIn2v3SklUuvwCQxmLyWt8iup2AJYPVzp1TaNRUFgK5iQkkrOCxTy1dfAmuzb1dyUlyrH5T6OqNrhl69A7ZQoXOsu9cMTOfN/4BtgOz8dcsZ/CYLqfi3JBaKHrNFLAAWPzjasTlLGTyvCFphhJ5MIO2I8GUsKgrLTXzWT7WItXIn74U4+G7eSeUHsgh+IR+d9qctPLJIMQ7esqXok6i+P6x7s5t+q4MfWTQh3y9FgboUHqDOxcEgbBY1C2jFp8EZ0+bUHFOVQIU11lB6vl+yEIk1yoJI7vNQZxo0uJ0oI+F5Uwm2jUYQp/jhkqZ8BPoFMGwNKfs4/rXLzAAm0rc2O32935GnYHABGBzVckBGqjGDCgaS
 1eSUXBtm
 O2w0olSwT77Wn+rzDtS8pN+cn6AaqR8YR/rpnr7nTsqDyvm9rStIjS9HTUtsI/PvqgxDJ/Ke8pgzNSWvwBS/rmXUWAXA06yOk9p/vnxoNUFWIyGn8u5GcBxW2MO2DkMPldVjRVIyVCpZ9cmG1i71nA1LzmGvMeMhNbv87zN1h3ps6X7OtDBPNcM959aQJ+I/KXpr4sN8VJ+hx0FLuoNjPM7iZli1V8YLMoJb5NtDDM5qLucQGbhZJ2RkiKOOuwjFixlOU/yMfRvH0N8Zdcc4mmlMHioskAX/kIFY8CZ0uOfONHZX+0EQfHojLV1/Q6s+VgLV9KJpiGRy9J5vuy2MCyQj6BLURfYh3a2ioojyVaV/cbKzkTf8ItTk6/0ff65WmBDpD3xEYXY+h34plWMU0u/AsMPML5+ksHZxtxvqp1vqxx2j9D2YCTCGcsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On October 28, 2025 11:54:43 PM PDT, Brian Gerst <brgerst@gmail=2Ecom> wrot=
e:
>On Sun, Oct 26, 2025 at 6:12=E2=80=AFPM H=2E Peter Anvin <hpa@zytor=2Ecom=
> wrote:
>>
>> There is no fundamental reason for the int80_landing_pad symbol=2E If i=
p
>> falls within the vdso, and the vdso is moved, we should change the ip
>> accordingly, regardless of mode or location within the vdso=2E This
>> *currently* can only happen on 32 bits, but there isn't any reason not
>> to do so generically=2E
>>
>> Note that if this is ever possible from a vdso-internal call, then the
>> user space stack will also needed to be adjusted (as well as the
>> shadow stack, if enabled=2E) Fortunately this is not currently the case=
=2E
>>
>> At the moment, we don't even consider other threads when moving the
>> vdso=2E The assumption is that it is only used by process freeze/thaw
>> for migration, where this is not an issue=2E
>>
>> Signed-off-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> ---
>>  arch/x86/entry/vdso/vdso32/system_call=2ES |  1 -
>>  arch/x86/entry/vdso/vma=2Ec                | 16 ++++++----------
>>  arch/x86/tools/vdso2c=2Ec                  |  1 -
>>  3 files changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/entry/vdso/vdso32/system_call=2ES b/arch/x86/entr=
y/vdso/vdso32/system_call=2ES
>> index 2a15634bbe75=2E=2Ed14eca4403c5 100644
>> --- a/arch/x86/entry/vdso/vdso32/system_call=2ES
>> +++ b/arch/x86/entry/vdso/vdso32/system_call=2ES
>> @@ -62,7 +62,6 @@ __kernel_vsyscall:
>>
>>         /* Enter using int $0x80 */
>>         int     $0x80
>> -SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
>
>This is still needed by do_fast_syscall_32()=2E
>
>
>Brian Gerst
>

Yeah, that was a complete brainfart on my part=2E I'm already reworking th=
e patchset, fixing this and adding more improvements=2E=20

