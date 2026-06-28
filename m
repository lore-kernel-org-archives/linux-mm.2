Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4CDC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 20:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04F96B0005; Sun, 28 Jun 2026 16:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5786B0088; Sun, 28 Jun 2026 16:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD466B008A; Sun, 28 Jun 2026 16:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7611F6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:33:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E43974049B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:33:50 +0000 (UTC)
X-FDA: 84930472620.27.D0F01EE
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 926A8180003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:33:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=NszmPxQ1;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782678829;
	b=AoYqHP2mlDdJNYmXPScVGlpYUlkMSoT8oOhzfVIndaOo47P1WgS5Te8RJ5SztIhP6rVA/x
	x0IgM0o1lW+MD8xRoO7Qok+C13C5J0DEKi+xgsUY03EA+9ylxFHDos3oaaSQpCbwr5E7T9
	SeyfEX+tsrHnXVQ0JALluUn0QNw/xsg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782678829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hHkkrsNMZT0O9wtqbdmauroM8dLeoBeYas3cz5fvoE=;
	b=4eCskzkL+5Hu25tKfMphUUmZilZt6HXfndC2pe1APUJ6ANKhUMxm5biqfKOqMMCc6e5D3s
	tPgpugjcGGVMIxVugkiCfgHKQCgLylOfjhoB6srFAM/enGtWpucCHBbF5nRaRCqaDPrrAN
	7b68/duWD6KYyx5Ky0nAVyhCpOHD4eM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026052701 header.b=NszmPxQ1;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf16.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65SKX9Fc2699327
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 28 Jun 2026 13:33:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65SKX9Fc2699327
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026052701; t=1782678791;
	bh=5hHkkrsNMZT0O9wtqbdmauroM8dLeoBeYas3cz5fvoE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=NszmPxQ1WPMOaCrJDuL3o5bdzt4WDtZQqs7n+t1PPrTGFuuyBtBSSLx570gYRCxmC
	 VlVcm7JjJ9awHV9T2+rRe4Gky7FaNiSyyyPy18rcPflSt7KwqU2JJF/vatpOwBo846
	 0Ium/vS+0rYYS5GkfJlHvb/uxJ/llNtEZQroav+qvgjDP5C2IaR4nhJFKoZl/2sraH
	 PBLWr1lHQV3eSWso18CbHuznN+Ed3uJlFru5e89ICel6qwMfFWd3YMPAWujGjzzpa8
	 eIW76RtLn7y/UTgfyCUC++MrmBm5EhiHFn3SVMgIAstrH0OnkNVBU4fAWT0JZYx4/W
	 nghpja145d9uA==
Date: Sun, 28 Jun 2026 13:33:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Thomas Gleixner <tglx@kernel.org>, David Stevens <stevensd@google.com>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <willdeacon@google.com>,
        Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_12/13=5D_x86=3A_Add_suppor?=
 =?US-ASCII?Q?t_for_dynamic_kernel_stacks_via_FRED?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87ldbyhatz.ffs@fw13>
References: <20260424191456.2679717-1-stevensd@google.com> <20260424191456.2679717-13-stevensd@google.com> <87zf0hgc3r.ffs@fw13> <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com> <87ldbyhatz.ffs@fw13>
Message-ID: <888C322E-BF59-4C72-BFD2-2E71FD8605C0@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 926A8180003
X-Rspam-User: 
X-Stat-Signature: o8dkqep17sf3u5bbydyhqz4w5t6wwk1p
X-HE-Tag: 1782678828-635064
X-HE-Meta: U2FsdGVkX1/MP2DTHwAGA367BtUQQvw/6PS4WLEac2sysBQb7Fh2SAmPjOUzUw/imh2z8VeCJauAAdu3hYwXgwUsEgnd+YBFlvnrM/eeQkhmQgdfFCNEPD3i5dxlRtZKpet/cTNjAxH2q+KY4YAQY+CAYBAhYmSW0j+q4NajOVJ+mkXFd7MrLGWH43azesnHao51S7+fOnUuEbN1TZCz3O84xUcXDDN9q4fzLvq5LGF4ZPk4KEq2oexVSUlXhjQ7roUhiqnUifoDcd7IVtEAFJ+lcfK2aD/xXOW1PoV/MGlnFNgy7UMqoCbbqTMNnojTm077QXxU6dTdzD3O5yIoNn+qsAjwP0/BMi4xJKFGogNQBJPNAZLQbFzUVaXL5HZrbdpgxiAuGdWyNFoeESWuHjA/Rgg547HuoHTJ5jaOFLbe8mAznSjeAHD3VBMz2OwtJSsK79sBMtMZA1MkD3BfQpt4Sw6Reh37pAa+h/WtBomZYcXTx8abtoIocMQzfP/cNvUJqI14yu9lstNJjJobemfjA3OjYz4/mdXnvVoVnCXweJE7loVuvvQdsojHjtibLB5atuhazyUf0Fe9yZaDAepmV4LLKe27Dw+qUwRNooUGS4h/FxEIgnJ9piNvq2YxSdPN0PExgHuzqxhZbEGHEUnrYjdmBuFzxXwOLhAffvYS7FJno4sMeyKCOIhkNiCS+dr8jwNj0vaap+fvYr4X4htPFNemUX9a6QOXwo5GslONbwwrIaFb6f+6Biu1kf8nYn9BVdW+p7kedmblJlXXRbXhdgdScuQyQSDIEnaxjjeX2rLAzon4S2j12UssVUlxkfW8VJnXERwGMl3dh4vQUP0J206iqf/eJL/xtUNYvSY50F7fZIaiRwelfzBP+0SGklC84U5FCduFTGZlMKZ0MS/kjTqyPquFu5WoXtffe3+46ZV6cJ2gAzGo93/PcTkOSkQZxcYB9/BJbb6qm7K
 Oc7xbuxo
 aBrjJ7QeCb6zdBXmyri5DfHJG2fmgnj5kp58sHh6vqE+Ed5yvQOfftSEo4IKYF0o0e5ZAtEGq60h+shIxH/iXDZHq/6jCUluTQGIE9TsxCkFZW/qVigbuFGoPLpY0+tcVCCpR7cMTn8mGRn3yDYEGUKC20oYLOF6fmpxI2IPPMLVgKs7nZyvp8a1kYEkuFpp2MkeYozZsKF8LjAknA5yyftsrIITTVgR6I31KojLCGFcZGHhXT2oL6yPTwVReP/DLfWbHwZ+1YPdQp6S3vSZ9gm9cnfOdMEqcNmSLiZspuVQpxBmGnI5s9Ea18ClztfcUcqHDtIwgMNrw64g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On June 28, 2026 9:46:32 AM PDT, Thomas Gleixner <tglx@kernel=2Eorg> wrote:
>On Fri, Jun 26 2026 at 21:05, David Stevens wrote:
>> On Fri, Jun 26, 2026 at 3:39=E2=80=AFPM Thomas Gleixner <tglx@kernel=2E=
org> wrote:
>> That is definitely a situation that could happen, I hadn't thought of
>> it=2E Luckily, I don't think we need NMI-safe re-entrancy to handle
>> this, since an NMI on SL0 couldn't have interrupted a dynamic stack
>> fault=2E
>
>Correct=2E
>
>>> As a consequence you copy stack data around to the same place, which
>>> should be benign, but it is well understood that memcpy() source and
>>> destination areas _must_ not overlap=2E That's UB, no?
>>>
>>> I know that should not happen, but that doesn't make it less UB :)
>>
>> That sort of fault would probably end up either with a
>> page_fault_oops() or risk a context switch with SL>0, but we shouldn't
>> make debugging harder with UB=2E
>
>Definitely not :)
>
>You can avoid quite some of the problems right in the ASM entry code=2E
>Instead of checking event type/vector and then going to the stack switch
>logic, you can check the stack level on which the event happened
>first=2E If it's not 0, then there is nothing to do=2E
>
>

To be fair, for this *specific* case, memmove() does exist for a reason :)

